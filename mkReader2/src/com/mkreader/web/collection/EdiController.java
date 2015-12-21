/*------------------------------------------------------------------------------
 * NAME : EdiController 
 * DESC : 수금입력 - EDI관리
 * Author : shlee
 *----------------------------------------------------------------------------*/
package com.mkreader.web.collection;

import java.io.File;
import java.io.FileInputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.servlet.util.MultipartHttpServletParam;
import kr.reflexion.espresso.util.Param;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.DateUtil;
import com.mkreader.util.FileUtil;

public class EdiController extends MultiActionController implements
ISiteConstant, ICodeConstant {

	private GeneralDAO generalDAO;
	
	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}
	
	
	/**
	 * 지로 수납명세서(GR15) 등록화면
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView gr15attach(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("collection/edi/gr15attach");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COLLECTION_EDI);
		
		return mav;
	}
	
	
	/**
	 * 지로 수납명세서(GR15) 처리
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView gr15process(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		MultipartHttpServletParam param = new MultipartHttpServletParam(request);
		MultipartFile edifile = param.getMultipartFile("edifile");
		
		HashMap dbparam = new HashMap();
		
		// mav
		ModelAndView mav = new ModelAndView();
		
		
		if ( edifile.isEmpty()) {	// 파일 첨부가 안되었으면 
			mav.setViewName("common/message");
			mav.addObject("message", "파일첨부가 되지 않았습니다.");
			mav.addObject("returnURL", "/collection/edi/gr15attach.do");
			return mav;
		}
		else {	// 파일 첨부가 되었으면
			
			int sngError = 0;
			int rec_count = 0;
			
			dbparam = new HashMap();
			dbparam.put("FILENAME", edifile.getOriginalFilename());
			dbparam.put("TYPE", "JIKYUNG");

			// excute query
			Map fileMap = (Map) generalDAO.queryForObject("collection.edi.getUploadFileInfo", dbparam);
			logger.debug("===== collection.edi.getUploadFileInfo");
			
			// 이미 같은 이름으로된 파일이 업로드 되었다면 실패
			if ( fileMap != null ) {
				mav.setViewName("common/message");
				mav.addObject("message", "이미 파일이 있습니다.");
				mav.addObject("returnURL", "/collection/edi/gr15attach.do");
				return mav;
				
			}else {
				
				FileUtil fileUtil = new FileUtil( getServletContext() );
				String strFile = fileUtil.saveUploadFile(
												edifile, 
												PATH_PHYSICAL_HOME,
												PATH_UPLOAD_ABSOLUTE_EDI_GR15
											);
				
				if ( StringUtils.isEmpty(strFile) ) {
					mav.setViewName("common/message");
					mav.addObject("message", "파일 저장이 실패하였습니다. ");
					mav.addObject("returnURL", "/collection/edi/gr15attach.do");
					return mav;
				}
				else if ( strFile.length() != 10 ) {	// GR15YYMMDD 
					mav.setViewName("common/message");
					mav.addObject("message", "파일명이 잘못되었습니다.");
					mav.addObject("returnURL", "/collection/edi/gr15attach.do");
					return mav;
				}
				else {
					
					String msg = "";
					
					int LINE_NUM = 120;
					
					String fileName = PATH_UPLOAD_RELATIVE_EDI_GR15 + "/" + strFile;
					
					File f = new File(fileName);
					FileInputStream fis = new FileInputStream(f);
					String txtline = "";
					
					try {
						
						// transaction start
						generalDAO.getSqlMapClient().startTransaction();					
						generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
						
						int count;
						byte[] b = new byte[LINE_NUM];
						
						String txt_jiro = "";
						String txt_hdate = "";
						String txt_gunsoo = "";
						
						// 마지막 수금년월을 가져옴. 
						String last_yymm = (String) generalDAO.getSqlMapClient().queryForObject("common.getLastSGYYMM");
						String lastYYMM = last_yymm.substring(2,6);
						
						String txt_code = "";
						txtline = "";
						String errstr = "";		// 0 : 정상, others : 에러
						
						String txt_num = "";
						String txt_sdate = "";
						String txt_edate = "";
						String txt_scode = "";
						String txt_empty1 = "";
						String txt_empty2 = "";
						String txt_gnum = "";
						String txt_money = "";
						String txt_sgubun = "";
						String txt_gmoney = "";
						String txt_jgubun = "";

						String txt_jcode = "";
						String newscd = "";
						String readno = "";
						String gno = "";
						String boreadno = "";
						
						String startYYMM = "";
						String endYYMM = "";
															
						String txt_type = "";
						
						Calendar cal = Calendar.getInstance();
						int nowYear =  cal.get(Calendar.YEAR);
						String nowYearStr = Integer.toString(nowYear);
						
						while ((count = fis.read(b)) != -1) {
							
							txtline = new String(b);
							
							if ( txtline.length() != 0 ) {
								
								txt_code = txtline.substring(0, 2);			// (2) Data 구분코드
								
								if ( txt_code.equals(CODE_EDI_LAYOUT_HEADER) ) {			// 헤더면
									txt_jiro = txtline.substring(4, 11);			// (7) 지로번호
									txt_hdate = txtline.substring(17, 25);			// (8) 이체일자 (YYYYMMDD)
									
									if ( !txt_jiro.equals(MK_JIRO_NUMBER)) {		// 직영지로번호의 파일인지 체크
										mav.setViewName("common/message");
										mav.addObject("message", "직영 지로번호가 일치하지 않습니다.");
										mav.addObject("returnURL", "/collection/edi/gr15attach.do");
										return mav;
									}
								}
								else if ( txt_code.equals(CODE_EDI_LAYOUT_TRAILER) ) {
									txt_gunsoo = txtline.substring(2, 9);			// (7) Data Record의 총 Record 건수
								}
								else if ( txt_code.equals(CODE_EDI_LAYOUT_DATA) ) {		// 데이터면
									
									rec_count++;
										
									errstr = "0";		// 0 : 정상, others : 에러
									
									txt_num = txtline.substring(2, 9);			// (7) 일련번호
									txt_sdate = txtline.substring(9, 17);		// (8) 수납일자(YYYYMMDD)
									txt_edate = txtline.substring(17, 25);		// (8) 이체일자(YYYYMMDD)
									txt_scode = txtline.substring(25, 32);		// (7) 수납점 코드(은행코드(3) + 점포코드(4))
									txt_empty1 = txtline.substring(32, 39);		// (7) 정보 작성점(은행코드(3) + 점포코드(4))
									txt_empty2 = txtline.substring(39, 51);		// (12)색인번호(IRN)
									txt_gnum = txtline.substring(51, 71);		// (20)고객조회번호(Check Digit 1자리 포함)
									txt_money = txtline.substring(71, 84);		// (13)금액(Check Digit 1자리 생략)
									txt_sgubun = txtline.substring(84, 85);		// (1) 수납구분(정상분(공란),...)
									txt_gmoney = txtline.substring(85, 89);		// (4) 지로수수료
									txt_jgubun = txtline.substring(89, 90);		// (1) 장표처리구분(정상분(공란), Reject분(R), A장표(A))

									txt_jcode = "";
									newscd = "";
									readno = "";
									gno = "";
									boreadno = "";
									
									startYYMM = "";
									endYYMM = "";
									
									txt_type = txtline.substring(51, 53);		// (2) 고객조회번호에 들어있는 신구 구분코드
									if ( txt_type.equals(CODE_EDI_NEW_READER_GUBUN) || txt_type.equals(CODE_EDI_NEW_READER_GUBUN_OTHERS) ) {
										
										// 신 고객조회번호 (구분(2) + 매체번호(2) + 독자번호(9) + 시작년월(4) + 개월분(2) + check(1))											
										newscd = "1" + txtline.substring(53, 55);		// (2) 매체번호 (원래 매체번호는 3자리이나 여기선 첫번째 1이 빠진 나머지 2자리만 넘어옴)
										readno = txtline.substring(55, 64);				// (9) 독자번호
										startYYMM = txtline.substring(64, 68);			// (4) 시작년월
										String plusMonths = txtline.substring(68, 70);	// (2) 개월분
										
										endYYMM = getEndYYMM(startYYMM, plusMonths);	// 종료년월을 구한다.
										
										// (6) 지국코드. 독자번호로 news 테이블에서 가져와야함.
										dbparam = new HashMap();
										dbparam.put("NEWSCD", newscd);
										dbparam.put("READNO", readno);
										
										txt_jcode = (String ) generalDAO.getSqlMapClient().queryForObject("collection.edi.getAgencyCodeFromReadno", dbparam);
										logger.debug("===== collection.edi.getAgencyCodeFromReadno");
										
										// 입금처리하기 위한 데이터가 없다면 에러처리
										if ( StringUtils.isEmpty(newscd) || StringUtils.isEmpty(readno)) {
											errstr = "1";
										}
										// 입금처리하기 위한 지국코드 데이터가 없다면 에러처리, 해당칼럼 not null이므로 임시값 세팅
										if ( StringUtils.isEmpty(txt_jcode)) {
											errstr = "1";
											txt_jcode = "000000";
										}
									}
									else {	
										
										// 구 고객조회번호 (지국번호(6) + 구역(2) + 독자번호(5) + 시작월(2) + 종료년월(4) + check(1))
										newscd = MK_NEWSPAPER_CODE;
										txt_jcode = txtline.substring(51, 57);			// (6) 지국코드
										gno = "1" + txtline.substring(57, 59);			// (2) 구역코드(1을 뺀 2자리)
										boreadno = txtline.substring(59, 64);			// (5) 지국독자번호
										String startMM = txtline.substring(64, 66);		// (2) 시작월
										endYYMM = txtline.substring(66, 70);			// (4) 종료년월
										
										if ( "00".equals(startMM) ) {	// 시작월이 00이면 종료년월 필드에 있는 yymm 한달을 의미
											startYYMM = endYYMM;
										}
										else {		// 시작월이 00이 아니라면 종료년월의 년도만 가져와서 조합.
											if ( startMM.compareTo(endYYMM.substring(2,4)) > 0 ) {
												int tmpYY = Integer.parseInt(endYYMM.substring(0, 2));
												tmpYY = (tmpYY - 1) % 100;
												String tmpYYStr = (tmpYY < 10) ? "0"+Integer.toString(tmpYY) : Integer.toString(tmpYY);
												startYYMM = tmpYYStr.substring(0, 2) + startMM;
											}
											else {
												startYYMM = endYYMM.substring(0, 2) + startMM;
											}
										}
										
										// 입금처리하기 위한 데이터가 없다면 에러처리
										if ( StringUtils.isEmpty(newscd) || StringUtils.isEmpty(txt_jcode) || StringUtils.isEmpty(gno) || StringUtils.isEmpty(boreadno) ) {
											errstr = "1";
										}
										
										// 지국 코드를 가져온다.
										dbparam = new HashMap();
										dbparam.put("SERIAL", txt_jcode);

										// excute query
										int agencyCnt = (Integer) generalDAO.getSqlMapClient().queryForObject("collection.edi.getAgencyInfo", dbparam);
										logger.debug("===== collection.edi.getAgencyInfo");
										
										if ( agencyCnt > 0 ) {
											errstr = "0";
										} else {
											errstr = "1";
										}
									}
									
									if ( StringUtils.isEmpty(startYYMM) || StringUtils.isEmpty(endYYMM) 
											|| startYYMM.length() != 4 || endYYMM.length() != 4 ) {
										errstr = "1";
									}
									
									String txt_rcode = txtline.substring(51, 65);
									String txt_all = txtline;

									
									// 수납구분이 Reject 이거나 장표처리구분이 Reject 이면 오류
									if ( "R".equals(txt_sgubun) || "R".equals(txt_jgubun)) {
										errstr = "1";
									}
									
									
									// GR15 data 등록
									dbparam = new HashMap();
									dbparam.put("E_NUMBER", txt_num);
									dbparam.put("E_SDATE", txt_sdate);
									dbparam.put("E_EDATE", txt_edate);
									dbparam.put("E_SCODE", txt_scode);
									dbparam.put("E_INFO", txt_empty1);
									dbparam.put("E_INDEXINFO", txt_empty2);
									dbparam.put("E_CHECK", txt_gnum);
									dbparam.put("E_SGUBUN", txt_sgubun);
									dbparam.put("E_MONEY", txt_money);
									dbparam.put("E_CHARGE", txt_gmoney);
									dbparam.put("E_JCODE", txt_jcode);
									// txt_wdate
									dbparam.put("E_RCODE", txt_rcode);
									dbparam.put("E_ERROR", errstr);
									dbparam.put("E_JGUBUN", txt_jgubun);
									dbparam.put("E_ALL", txt_all);
									dbparam.put("E_JIRO", txt_jiro);
	
									// excute query
									int e_numid = (Integer) generalDAO.getSqlMapClient().insert("collection.edi.insertEdiGR15", dbparam);
									logger.debug("===== collection.edi.insertEdiGR15");
									
									int nTxtMoney = Integer.parseInt(txt_money);			// 지로로 받은 금액
									
									// 에러가 아니면 입금처리
									if ( errstr == "0") {
										
										List newsList = null;
										List sugmList = null;
										
										String nextYYYYMMDD = "";
										String nextYYMM = startYYMM;
										
										int remainMoney = nTxtMoney;			// 수금처리 후 남은 금액
										
										while ( nextYYMM.compareTo(endYYMM) <= 0 ) {
											
											// 마지막 월마감 수금년월이 구독년월보다 크거나 같다면 미수입금처리
											if ( lastYYMM.compareTo(nextYYMM) >= 0 ) {
												
												dbparam = new HashMap();
												dbparam.put("NEWSCD", newscd);									// 신문코드
												dbparam.put("SGBBCD", CODE_SUGM_GUBUN_NOT_COMPLETE);			// 수금방법 - 미수
												//dbparam.put("SGGBCD_NOT", "'021','023','024','033','099'");			// 수금구분 - 자동이체 제외(본사입금,쿠폰,휴독,월삭제 제외 추가)
												dbparam.put("BOSEQ", txt_jcode);								// 지국코드
												dbparam.put("SDATE", nowYearStr.substring(0, 2) + nextYYMM);	// 구독년월, 시작년월
												dbparam.put("EDATE", nowYearStr.substring(0, 2) + nextYYMM);	// 구독년월, 종료년월
												
												if ( txt_type.equals(CODE_EDI_NEW_READER_GUBUN) || txt_type.equals(CODE_EDI_NEW_READER_GUBUN_OTHERS) ) {	// 신 고객조회번호: newscd, txt_jcode, readno 로 처리
													dbparam.put("READNO", readno);								// 독자번호(9자리)
												}
												else {												// 구 고객조회번호: newscd, txt_jcode, gno, boreadno 로 처리
													dbparam.put("GNO", gno);									// 구역번호
													dbparam.put("BOREADNO", boreadno);							// 지국독자번호
												}
												
												// 미수 목록 조회
												sugmList = generalDAO.getSqlMapClient().queryForList("collection.edi.getSugmList", dbparam);
												logger.debug("===== collection.edi.getSugmList");
												
												if ( sugmList != null ) {
													for ( int i = 0; i < sugmList.size(); i++ ) {
														Map sugmMap = (Map) sugmList.get(i);
														String read_no = (String)sugmMap.get("READNO");				// 독자번호
														BigDecimal billAmt = (BigDecimal)sugmMap.get("BILLAMT");	// 청구금액
														String seq = (String)sugmMap.get("SEQ");					// 시퀀스	
														
														int nBillAmt = Integer.parseInt(billAmt.toString());		// 청구금액 int형으로 변환
														if ( remainMoney > 0 ) {	// 입금 처리 
															
															// 수금테이블 update
															dbparam = new HashMap();
															dbparam.put("READNO", read_no);									// 독자번호
															dbparam.put("NEWSCD", newscd);									// 신문코드
															dbparam.put("YYMM", nowYearStr.substring(0, 2) + nextYYMM);		// 구독년월
															dbparam.put("SEQ", seq);										// 시퀀스
															dbparam.put("SGBBCD", CODE_SUGM_GUBUN_NOT_COMPLETE);			// 수금방법 - 미수
															//dbparam.put("SGGBCD_NOT", "'021','023','024','033','099'");			// 수금구분 - 자동이체 제외(본사입금,쿠폰,휴독,월삭제 제외 추가)
															dbparam.put("BOSEQ", txt_jcode);								// 지국코드
															if ( remainMoney < nBillAmt ) {
																dbparam.put("AMT", remainMoney);							// 수금금액
																dbparam.put("LOSSAMT", nBillAmt - remainMoney);				// 결손금액
															}
															else {
																dbparam.put("AMT", nBillAmt);								// 수금금액
															}
															dbparam.put("SGBBCD_NEW", CODE_SUGM_TYPE_GIRO);					// 수금방법 - 지로
															dbparam.put("SGYYMM", last_yymm);								// 수금년월
															dbparam.put("EDIPROCNO", e_numid);								// EDI처리번호
															dbparam.put("SNDT", txt_sdate);									// 수납일자
															dbparam.put("ICDT", txt_edate);									// 이체일자
															dbparam.put("CLDT", txt_edate);									// 처리일자
															dbparam.put("CHGPS", txt_jcode);								// 수정자 ID
															
															generalDAO.getSqlMapClient().update("collection.edi.updateSugm", dbparam);
															logger.debug("===== collection.edi.updateSugm 1 : " + read_no + ", " + seq + ", " + nextYYMM);
															
															if ( remainMoney > nBillAmt ) {
																remainMoney -= nBillAmt;
															}
															else {
																remainMoney = 0;
															}
														}
														else {	// 결손처리
															// 수금테이블 update
															dbparam = new HashMap();
															dbparam.put("READNO", read_no);									// 독자번호
															dbparam.put("NEWSCD", newscd);									// 신문코드
															dbparam.put("YYMM", nowYearStr.substring(0, 2) + nextYYMM);		// 구독년월
															dbparam.put("SEQ", seq);										// 시퀀스
															dbparam.put("SGBBCD", CODE_SUGM_GUBUN_NOT_COMPLETE);			// 수금방법 - 미수
															//dbparam.put("SGGBCD_NOT", "'021','023','024','033','099'");			// 수금구분 - 자동이체 제외(본사입금,쿠폰,휴독,월삭제 제외 추가)
															dbparam.put("BOSEQ", txt_jcode);								// 지국코드
															dbparam.put("AMT", 0);											// 수금금액
															dbparam.put("LOSSAMT", nBillAmt);								// 결손금액
															dbparam.put("SGBBCD_NEW", CODE_SUGM_TYPE_GIRO);					// 수금방법 - 지로
															dbparam.put("SGYYMM", last_yymm);								// 수금년월
															dbparam.put("EDIPROCNO", e_numid);								// EDI처리번호
															dbparam.put("SNDT", txt_sdate);									// 수납일자
															dbparam.put("ICDT", txt_edate);									// 이체일자
															dbparam.put("CLDT", txt_edate);									// 처리일자
															dbparam.put("CHGPS", txt_jcode);								// 수정자 ID
															
															generalDAO.getSqlMapClient().update("collection.edi.updateSugm", dbparam);
															logger.debug("===== collection.edi.updateSugm 2 : " + read_no + ", " + seq + ", " + nextYYMM);
														}
													}
												}
											}
											else {	// 마지막 월마감 수금년월이 구독년월보다 작다면 선입금처리
												
												dbparam = new HashMap();
												dbparam.put("NEWSCD", newscd);									// 신문코드
												dbparam.put("BOSEQ", txt_jcode);								// 지국코드
												dbparam.put("YYMM", nowYearStr.substring(0, 2) + nextYYMM);		// 수금시작월 비교
												
												if ( txt_type.equals(CODE_EDI_NEW_READER_GUBUN)|| txt_type.equals(CODE_EDI_NEW_READER_GUBUN_OTHERS) ) {	// 신 고객조회번호: newscd, txt_jcode, readno 로 처리
													dbparam.put("READNO", readno);								// 독자번호(9자리)
												}
												else {												// 구 고객조회번호: newscd, txt_jcode, gno, boreadno 로 처리
													dbparam.put("GNO", gno);									// 구역번호
													dbparam.put("BOREADNO", boreadno);							// 지국독자번호
												}
												
												newsList = generalDAO.getSqlMapClient().queryForList("collection.edi.getNewsList", dbparam);
												logger.debug("===== collection.edi.getNewsList");
												
												if ( newsList != null ) {
													for ( int i = 0; i < newsList.size(); i++ ) {
														Map newsMap = (Map) newsList.get(i);
														String read_no = (String)newsMap.get("READNO");				// 독자번호
														String seq = (String)newsMap.get("SEQ");					// 시퀀스
														BigDecimal qty = (BigDecimal)newsMap.get("QTY");			// 구독부수
														BigDecimal uprice = (BigDecimal)newsMap.get("UPRICE");		// 구독금액
														
														int nUprice = Integer.parseInt(uprice.toString());		// 구독금액 int형으로 변환
														
														dbparam = new HashMap();
														dbparam.put("READNO", read_no);					// 독자번호
														dbparam.put("NEWSCD", newscd);					// 신문코드
														dbparam.put("YYMM", nowYearStr.substring(0, 2)+nextYYMM);// 구독년월(월분)
														dbparam.put("SEQ", seq);						// 일련번호
														
														Map sugmMap = (Map) generalDAO.getSqlMapClient().queryForObject("collection.edi.getSugmMap", dbparam);
														logger.debug("===== collection.edi.getSugmMap");
														
														if ( sugmMap == null ) { 	// 있는지 검사후 없으면
															if ( remainMoney > 0 ) {	// 입금 처리 
																dbparam = new HashMap();
																dbparam.put("READNO", read_no);					// 독자번호
																dbparam.put("NEWSCD", newscd);					// 신문코드
																dbparam.put("YYMM", nowYearStr.substring(0, 2)+nextYYMM);// 구독년월(월분)
																dbparam.put("SEQ", seq);						// 일련번호
																dbparam.put("BOSEQ", txt_jcode);				// 지국코드
																dbparam.put("SGBBCD", CODE_SUGM_TYPE_GIRO);		// 수금방법 - 지로
																dbparam.put("SGGBCD", CODE_SUGM_TYPE_GIRO);		// 수금구분 - 지로
																dbparam.put("BILLAMT", nUprice);				// 청구금액
																dbparam.put("BILLQTY", qty);					// 청구부수
																dbparam.put("SGYYMM", last_yymm);				// 수금년월(월분)
																if ( remainMoney < nUprice ) {
																	dbparam.put("AMT", remainMoney);				// 수금금액
																	dbparam.put("LOSSAMT", nUprice - remainMoney);	// 결손금액
																}
																else {
																	dbparam.put("AMT", nUprice);					// 수금금액
																}
																dbparam.put("EDIPROCNO", e_numid);				// EDI처리번호
																dbparam.put("SNDT", txt_sdate);					// 수납일자
																dbparam.put("ICDT", txt_edate);					// 이체일자
																dbparam.put("CLDT", txt_edate);					// 처리일자
																dbparam.put("INPS", txt_jcode);					// 등록자 ID
																dbparam.put("CHGPS", txt_jcode);				// 수정자 ID
																
																generalDAO.getSqlMapClient().insert("collection.edi.insertPreSugm", dbparam);
																logger.debug("===== collection.edi.insertPreSugm 1 : " + read_no + ", " + seq + ", " + nextYYMM);
																
																if ( remainMoney > nUprice ) {
																	remainMoney -= nUprice;
																}
																else {
																	remainMoney = 0;
																}
															}
															else {	// 결손처리
																dbparam = new HashMap();
																dbparam.put("READNO", read_no);					// 독자번호
																dbparam.put("NEWSCD", newscd);					// 신문코드
																dbparam.put("YYMM", nowYearStr.substring(0, 2)+nextYYMM);// 구독년월(월분)
																dbparam.put("SEQ", seq);						// 일련번호
																dbparam.put("BOSEQ", txt_jcode);				// 지국코드
																dbparam.put("SGBBCD", CODE_SUGM_TYPE_GIRO);		// 수금방법 - 지로
																dbparam.put("SGGBCD", CODE_SUGM_TYPE_GIRO);		// 수금구분 - 지로
																dbparam.put("BILLAMT", nUprice);				// 청구금액
																dbparam.put("BILLQTY", qty);					// 청구부수
																dbparam.put("SGYYMM", last_yymm);				// 수금년월(월분)
																dbparam.put("AMT", 0);							// 수금금액
																dbparam.put("LOSSAMT", nUprice);				// 결손금액
																dbparam.put("EDIPROCNO", e_numid);				// EDI처리번호
																dbparam.put("SNDT", txt_sdate);					// 수납일자
																dbparam.put("ICDT", txt_edate);					// 이체일자
																dbparam.put("CLDT", txt_edate);					// 처리일자
																dbparam.put("INPS", txt_jcode);					// 등록자 ID
																dbparam.put("CHGPS", txt_jcode);				// 수정자 ID
																
																generalDAO.getSqlMapClient().insert("collection.edi.insertPreSugm", dbparam);
																logger.debug("===== collection.edi.insertPreSugm 2 : " + read_no + ", " + seq + ", " + nextYYMM);
															}
														}
														else {
															String sgbbcd = (String) sugmMap.get("SGBBCD");
															
															// 미수로 수금에 들어있다면 입금처리
															if ( sgbbcd.equals(CODE_SUGM_GUBUN_NOT_COMPLETE) ) {
																
																BigDecimal billAmt = (BigDecimal)sugmMap.get("BILLAMT");	// 청구금액
																
																int nBillAmt = Integer.parseInt(billAmt.toString());		// 청구금액 int형으로 변환
																if ( remainMoney > 0 ) {	// 입금 처리 
																	
																	// 수금테이블 update
																	dbparam = new HashMap();
																	dbparam.put("READNO", read_no);									// 독자번호
																	dbparam.put("NEWSCD", newscd);									// 신문코드
																	dbparam.put("YYMM", nowYearStr.substring(0, 2) + nextYYMM);		// 구독년월
																	dbparam.put("SEQ", seq);										// 시퀀스
																	dbparam.put("SGBBCD", CODE_SUGM_GUBUN_NOT_COMPLETE);			// 수금방법 - 미수
																	//dbparam.put("SGGBCD_NOT", "'021','023','024','033','099'");			// 수금구분 - 자동이체 제외(본사입금,쿠폰,휴독,월삭제 제외 추가)
																	dbparam.put("BOSEQ", txt_jcode);								// 지국코드
																	if ( remainMoney < nBillAmt ) {
																		dbparam.put("AMT", remainMoney);							// 수금금액
																		dbparam.put("LOSSAMT", nBillAmt - remainMoney);				// 결손금액
																	}
																	else {
																		dbparam.put("AMT", nBillAmt);								// 수금금액
																	}
																	dbparam.put("SGBBCD_NEW", CODE_SUGM_TYPE_GIRO);					// 수금방법 - 지로
																	dbparam.put("SGYYMM", last_yymm);								// 수금년월
																	dbparam.put("EDIPROCNO", e_numid);								// EDI처리번호
																	dbparam.put("SNDT", txt_sdate);									// 수납일자
																	dbparam.put("ICDT", txt_edate);									// 이체일자
																	dbparam.put("CLDT", txt_edate);									// 처리일자
																	dbparam.put("CHGPS", txt_jcode);								// 수정자 ID
																	
																	generalDAO.getSqlMapClient().update("collection.edi.updateSugm", dbparam);
																	logger.debug("===== collection.edi.updateSugm 3 : " + read_no + ", " + seq + ", " + nextYYMM);
																	
																	if ( remainMoney > nBillAmt ) {
																		remainMoney -= nBillAmt;
																	}
																	else {
																		remainMoney = 0;
																	}
																}
																else {	// 결손처리
																	// 수금테이블 update
																	dbparam = new HashMap();
																	dbparam.put("READNO", read_no);									// 독자번호
																	dbparam.put("NEWSCD", newscd);									// 신문코드
																	dbparam.put("YYMM", nowYearStr.substring(0, 2) + nextYYMM);		// 구독년월
																	dbparam.put("SEQ", seq);										// 시퀀스
																	dbparam.put("SGBBCD", CODE_SUGM_GUBUN_NOT_COMPLETE);			// 수금방법 - 미수
																	//dbparam.put("SGGBCD_NOT", "'021','023','024','033','099'");			// 수금구분 - 자동이체 제외(본사입금,쿠폰,휴독,월삭제 제외 추가)
																	dbparam.put("BOSEQ", txt_jcode);								// 지국코드
																	dbparam.put("AMT", 0);											// 수금금액
																	dbparam.put("LOSSAMT", nBillAmt);								// 결손금액
																	dbparam.put("SGBBCD_NEW", CODE_SUGM_TYPE_GIRO);					// 수금방법 - 지로
																	dbparam.put("SGYYMM", last_yymm);								// 수금년월
																	dbparam.put("EDIPROCNO", e_numid);								// EDI처리번호
																	dbparam.put("SNDT", txt_sdate);									// 수납일자
																	dbparam.put("ICDT", txt_edate);									// 이체일자
																	dbparam.put("CLDT", txt_edate);									// 처리일자
																	dbparam.put("CHGPS", txt_jcode);								// 수정자 ID
																	
																	generalDAO.getSqlMapClient().update("collection.edi.updateSugm", dbparam);
																	logger.debug("===== collection.edi.updateSugm 4 : " + read_no + ", " + seq + ", " + nextYYMM);
																}
															}
														}
													}
												}
											}
											
											// 한달씩 넘기면서 구독년월을 구한다.
											nextYYYYMMDD = DateUtil.getWantDay(nowYearStr.substring(0, 2)+ nextYYMM + "01", 2, 1);
											nextYYMM = nextYYYYMMDD.substring(2, 6);
										}
										
										// 과입금 처리
										if ( remainMoney > 0 ) {
											dbparam = new HashMap();
											dbparam.put("EDINUMID", e_numid);						// edi 테이블에 저장된 pk
											dbparam.put("OVERMONEY", remainMoney);					// 과입금액
											generalDAO.getSqlMapClient().insert("collection.edi.insertEdiOver", dbparam);
											logger.debug("===== collection.edi.insertEdiOver");
										}
									}
									else {
										sngError++;
									}
								}
							}
						}
						
						// file_t 테이블에 insert
						dbparam = new HashMap();
						dbparam.put("FILENAME", edifile.getOriginalFilename());
						dbparam.put("TYPE", "JIKYUNG");
						
						generalDAO.getSqlMapClient().insert("collection.edi.insertFile_t", dbparam);
						logger.debug("===== collection.edi.insertFile_t");
						
						msg = "정상적으로 처리되었습니다.";
						// transaction commit
						generalDAO.getSqlMapClient().getCurrentConnection().commit();
					}
					catch (Exception e) {
						// transaction rollback
						generalDAO.getSqlMapClient().getCurrentConnection().rollback();
						
						System.out.println("txtline:"+txtline ) ;
						e.printStackTrace();
						msg = "정상적으로 처리되지 않았습니다.";
					}
					finally {
						fis.close();
						
						// transaction end
						generalDAO.getSqlMapClient().endTransaction();
					}
					
					mav.setViewName("collection/edi/gr15process");
					mav.addObject("now_menu", ICodeConstant.MENU_CODE_COLLECTION_EDI);
					
					mav.addObject("msg", msg);
					mav.addObject("sngError", sngError);
					mav.addObject("rec_count", rec_count);
					
					return mav;
				}				
			}
		}
	}
	
	
	/**
	 * 지로 수납명세서(GR15) 처리 목록
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView gr15list(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		String sdate = param.getString("sdate");
		String edate = param.getString("edate");
		String type = param.getString("type", "1");	
		String jiroNum = param.getString("jiroNum", "");	
		
		// 현재날짜 (yyyymmdd)
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		String nowDate = df.format(cal.getTime());
		
		if ( StringUtils.isEmpty(sdate) ) {
			sdate = nowDate.substring(0, 4) + "-" + nowDate.substring(4, 6) + "-" + nowDate.substring(6, 8);
		}
		if ( StringUtils.isEmpty(edate) ) {
			edate = nowDate.substring(0, 4) + "-" + nowDate.substring(4, 6) + "-" + nowDate.substring(6, 8);
		}
		
		String sdate_tmp = sdate.replaceAll("-", "");
		String edate_tmp = edate.replaceAll("-", "");
		
		// 기간별 gr15 처리 목록
		Map dbparam = new HashMap();
		dbparam.put("sdate", sdate_tmp);			// 시작일(YYYYMMDD)
		dbparam.put("edate", edate_tmp);			// 종료일(YYYYMMDD)
		dbparam.put("type", type);		// 지로형태 콤보박스 (1:직영지로 , 2:타 지로, 0:전체)
		dbparam.put("MK_JIRO_NUMBER", MK_JIRO_NUMBER);	// 직영지로번호
		dbparam.put("jiroNum", jiroNum);	

		List resultList = generalDAO.queryForList("collection.edi.getGR15List", dbparam);
		logger.debug("===== collection.edi.getGR15List");
		
		// 기간별 gr15 처리 에러 금액
		dbparam = new HashMap();
		dbparam.put("sdate", sdate_tmp);			// 시작일(YYYYMMDD)
		dbparam.put("edate", edate_tmp);			// 종료일(YYYYMMDD)
		dbparam.put("type", type);		// 지로형태 콤보박스 (1:직영지로 , 2:타 지로, 0:전체)
		dbparam.put("MK_JIRO_NUMBER", MK_JIRO_NUMBER);	// 직영지로번호
		dbparam.put("jiroNum", jiroNum);	
		
		Map errMap = (Map) generalDAO.queryForObject("collection.edi.getGR15ErrTotalMoney", dbparam);
		logger.debug("===== collection.edi.getGR15ErrTotalMoney");
		
		// 금융결재원 등록 지로번호 목록
		List jiroList = generalDAO.queryForList("collection.edi.getJiroList", dbparam);
		logger.debug("===== collection.edi.getJiroList");

		BigDecimal errcount = null;
		BigDecimal summoney = null;
		BigDecimal sumcharge = null;
		BigDecimal summ = null;
		
		if ( errMap != null ) {
			errcount = (BigDecimal) errMap.get("ERRCOUNT");
			summoney = (BigDecimal) errMap.get("SUMMONEY");
			sumcharge = (BigDecimal) errMap.get("SUMCHARGE");
			summ = (BigDecimal) errMap.get("SUMM");
		}
		else {
			errcount = new BigDecimal(0);
			summoney = new BigDecimal(0);
			sumcharge = new BigDecimal(0);
			summ = new BigDecimal(0);
		}
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("collection/edi/gr15list");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COLLECTION_EDI);
		
		mav.addObject("sdate", sdate);
		mav.addObject("edate", edate);
		mav.addObject("type", type);
		mav.addObject("jiroNum", jiroNum);
		mav.addObject("jiroList", jiroList);
		mav.addObject("resultList", resultList);

		mav.addObject("errcount", errcount);
		mav.addObject("summoney", summoney);
		mav.addObject("sumcharge", sumcharge);
		mav.addObject("summ", summ);
		
		return mav;
	}
	
	
	/**
	 * 지로 수납명세서(GR15) 처리 목록(엑셀)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView gr15list_excel(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		String sdate = param.getString("sdate");
		String edate = param.getString("edate");
		String type = param.getString("type", "1");	
		String jiroNum = param.getString("jiroNum", "");	
		
		// 현재날짜 (yyyymmdd)
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		String nowDate = df.format(cal.getTime());
		
		if ( StringUtils.isEmpty(sdate) ) {
			sdate = nowDate.substring(0, 4) + "-" + nowDate.substring(4, 6) + "-" + nowDate.substring(6, 8);
		}
		if ( StringUtils.isEmpty(edate) ) {
			edate = nowDate.substring(0, 4) + "-" + nowDate.substring(4, 6) + "-" + nowDate.substring(6, 8);
		}
		
		String sdate_tmp = sdate.replaceAll("-", "");
		String edate_tmp = edate.replaceAll("-", "");
						
		// 기간별 gr15 처리 목록
		Map dbparam = new HashMap();
		dbparam.put("sdate", sdate_tmp);			// 시작일(YYYYMMDD)
		dbparam.put("edate", edate_tmp);			// 종료일(YYYYMMDD)
		dbparam.put("type", type);		// 지로형태 콤보박스 (1:직영지로 , 2:타 지로, 0:전체)
		dbparam.put("MK_JIRO_NUMBER", MK_JIRO_NUMBER);	// 직영지로번호
		dbparam.put("jiroNum", jiroNum);	
		List resultList = generalDAO.queryForList("collection.edi.getGR15ExcelList", dbparam);
		logger.debug("===== collection.edi.getGR15ExcelList");
		
		// 기간별 gr15 처리 에러 금액
		dbparam = new HashMap();
		dbparam.put("sdate", sdate_tmp);			// 시작일(YYYYMMDD)
		dbparam.put("edate", edate_tmp);			// 종료일(YYYYMMDD)
		dbparam.put("type", type);		// 지로형태 콤보박스 (1:직영지로 , 2:타 지로, 0:전체)
		dbparam.put("MK_JIRO_NUMBER", MK_JIRO_NUMBER);	// 직영지로번호
		dbparam.put("jiroNum", jiroNum);	
		Map errMap = (Map) generalDAO.queryForObject("collection.edi.getGR15ErrTotalMoney", dbparam);
		logger.debug("===== collection.edi.getGR15ErrTotalMoney");
		
		BigDecimal errcount = null;
		BigDecimal summoney = null;
		BigDecimal sumcharge = null;
		BigDecimal summ = null;
		
		if ( errMap != null ) {
			errcount = (BigDecimal) errMap.get("ERRCOUNT");
			summoney = (BigDecimal) errMap.get("SUMMONEY");
			sumcharge = (BigDecimal) errMap.get("SUMCHARGE");
			summ = (BigDecimal) errMap.get("SUMM");
		}
		else {
			errcount = new BigDecimal(0);
			summoney = new BigDecimal(0);
			sumcharge = new BigDecimal(0);
			summ = new BigDecimal(0);
		}
		
		String fileName = "GR15_(" + sdate + "_" + edate + ").xls";
		
		//Excel response
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName); 
		response.setHeader("Content-Description", "JSP Generated Data");
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("collection/edi/gr15list_excel");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COLLECTION_EDI);
		
		mav.addObject("sdate", sdate);
		mav.addObject("edate", edate);
		mav.addObject("type", type);
		mav.addObject("jiroNum", jiroNum);
		
		mav.addObject("resultList", resultList);

		mav.addObject("errcount", errcount);
		mav.addObject("summoney", summoney);
		mav.addObject("sumcharge", sumcharge);
		mav.addObject("summ", summ);
		
		return mav;
	}
	
	/**
	 * 지로 수납명세서(GR15) 처리 에러목록
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView gr15errList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		String sdate = param.getString("sdate");
		String edate = param.getString("edate");
		String type = param.getString("type", "1");	
		String jiroNum = param.getString("jiroNum", "");	
		
		// 현재날짜 (yyyymmdd)
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		String nowDate = df.format(cal.getTime());
		
		if ( StringUtils.isEmpty(sdate) ) {
			sdate = nowDate.substring(0, 4) + "-" + nowDate.substring(4, 6) + "-" + nowDate.substring(6, 8);
		}
		if ( StringUtils.isEmpty(edate) ) {
			edate = nowDate.substring(0, 4) + "-" + nowDate.substring(4, 6) + "-" + nowDate.substring(6, 8);
		}
		
		String sdate_tmp = sdate.replaceAll("-", ""); //yyyymmdd
		String edate_tmp = edate.replaceAll("-", ""); //yyyymmdd
		
		
		// 기간별 gr15 처리 에러 목록
		Map dbparam = new HashMap();
		dbparam.put("sdate", sdate_tmp);			// 시작일(YYYYMMDD)
		dbparam.put("edate", edate_tmp);			// 종료일(YYYYMMDD)
		dbparam.put("type", type);		// 지로형태 콤보박스 (1:직영지로 , 2:타 지로, 0:전체)
		dbparam.put("MK_JIRO_NUMBER", MK_JIRO_NUMBER);	// 직영지로번호
		dbparam.put("jiroNum", jiroNum);	
		List errList = generalDAO.queryForList("collection.edi.getGR15ErrList", dbparam);
		logger.debug("===== collection.edi.getGR15ErrList");
		
		// 지국 목록
		List agencyList = generalDAO.queryForList("common.getAgencyList");
		logger.debug("===== common.getAgencyList");
		
		// 금융결재원 등록 지로번호 목록
		List jiroList = generalDAO.queryForList("collection.edi.getJiroList", dbparam);
		logger.debug("===== collection.edi.getJiroList");
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("collection/edi/gr15errList");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COLLECTION_EDI);
		
		mav.addObject("sdate", sdate);
		mav.addObject("edate", edate);
		mav.addObject("type", type);
		mav.addObject("jiroNum", jiroNum);
		mav.addObject("jiroList", jiroList);
		
		mav.addObject("errList", errList);
		mav.addObject("agencyList", agencyList);
		
		return mav;
	}
	
	
	/**
	 * 에러목록 수정
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView modifyError(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		String sdate = param.getString("sdate");
		String edate = param.getString("edate");
		String type = param.getString("type", "1");	
		String jiroNum = param.getString("jiroNum", "");	
		
		String[] e_sdate = param.getStringValues("e_sdate");
		String[] e_edate = param.getStringValues("e_edate");
		String[] e_number = param.getStringValues("e_number");
		String[] ErrCK = param.getStringValues("ErrCK");
		String[] e_jcode = param.getStringValues("e_jcode");
		String[] NCustNo = param.getStringValues("NCustNo");
		String[] e_rcode = param.getStringValues("e_rcode");
		String[] e_wdate = param.getStringValues("e_wdate");
		String[] e_numid = param.getStringValues("e_numid");
		String[] e_money = param.getStringValues("e_money");		
		String[] e_check = param.getStringValues("e_check");
		
		String msg = "";
		int successCnt = 0;

		try {
			// transaction start
			generalDAO.getSqlMapClient().startTransaction();					
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			String last_yymm = (String) generalDAO.getSqlMapClient().queryForObject("common.getLastSGYYMM");
			String lastYYMM = last_yymm.substring(2,6);
			
			for ( int i = 0; i < ErrCK.length; i++ ) {
				
				for ( int j = 0; j < e_numid.length; j++) {
					
					if ( ErrCK[i].equals(e_numid[j]) ) {
						
						Boolean sugmFlag = true;	// 수금이 정상적으로 되었는지 체크하는 변수
						
						Map dbparam = new HashMap();
						
						String txt_jcode = "";
						String newscd = "";
						String readno = "";
						String gno = "";
						String boreadno = "";
						
						String startYYMM = "";
						String endYYMM = "";
															
						String txt_type = NCustNo[j].substring(0, 2);		// (2) 고객조회번호에 들어있는 신구 구분코드
						if ( txt_type.equals(CODE_EDI_NEW_READER_GUBUN) || txt_type.equals(CODE_EDI_NEW_READER_GUBUN_OTHERS) ) {
							// 신 고객조회번호 (구분(2) + 매체번호(2) + 독자번호(9) + 시작년월(4) + 개월분(2) + check(1))											
							newscd = "1" + NCustNo[j].substring(2, 4);				// (2) 매체번호 (원래 매체번호는 3자리이나 여기선 첫번째 1이 빠진 나머지 2자리만 넘어옴)
							readno = NCustNo[j].substring(4, 13);				// (9) 독자번호
							startYYMM = NCustNo[j].substring(13, 17);			// (4) 시작년월
							String plusMonths = NCustNo[j].substring(17, 19);	// (2) 개월분
							
							endYYMM = getEndYYMM(startYYMM, plusMonths);		// 종료년월을 구한다.
							
							// (6) 지국코드. 독자번호로 news 테이블에서 가져와야함.
							dbparam = new HashMap();
							dbparam.put("NEWSCD", newscd);
							dbparam.put("READNO", readno);
							
							txt_jcode = (String ) generalDAO.getSqlMapClient().queryForObject("collection.edi.getAgencyCodeFromReadno", dbparam);
							logger.debug("===== collection.edi.getAgencyCodeFromReadno");
							
							// 입금처리하기 위한 데이터가 없다면 에러처리
							if ( StringUtils.isEmpty(newscd) || StringUtils.isEmpty(txt_jcode) || StringUtils.isEmpty(readno)) {
								sugmFlag = false;
							}
						}
						else {
							
							// 구 고객조회번호 (지국번호(6) + 구역(2) + 독자번호(5) + 시작월(2) + 종료년월(4) + check(1))
							newscd = MK_NEWSPAPER_CODE;
							txt_jcode = NCustNo[j].substring(0, 6);				// (6) 지국코드
							gno = "1" + NCustNo[j].substring(6, 8);				// (2) 구역코드(1을 뺀 2자리)
							boreadno = NCustNo[j].substring(8, 13);				// (5) 지국독자번호
							String startMM = NCustNo[j].substring(13, 15);		// (2) 시작월
							endYYMM = NCustNo[j].substring(15, 19);				// (4) 종료년월
							
							if ( "00".equals(startMM) ) {	// 시작월이 00이면 종료년월 필드에 있는 yymm 한달을 의미
								startYYMM = endYYMM;
							}
							else {		// 시작월이 00이 아니라면 종료년월의 년도만 가져와서 조합.
								if ( startMM.compareTo(endYYMM.substring(2,4)) > 0 ) {
									int tmpYY = Integer.parseInt(endYYMM.substring(0, 2));
									tmpYY = (tmpYY - 1) % 100;
									String tmpYYStr = (tmpYY < 10) ? "0"+Integer.toString(tmpYY) : Integer.toString(tmpYY);
									startYYMM = tmpYYStr.substring(0, 2) + startMM;
								}
								else {
									startYYMM = endYYMM.substring(0, 2) + startMM;
								}
							}
							
							// 입금처리하기 위한 데이터가 없다면 에러처리
							if ( StringUtils.isEmpty(newscd) || StringUtils.isEmpty(txt_jcode) || StringUtils.isEmpty(gno) || StringUtils.isEmpty(boreadno) ) {
								sugmFlag = false;
							}
						}
						
						if ( StringUtils.isEmpty(startYYMM) || StringUtils.isEmpty(endYYMM) 
								|| startYYMM.length() != 4 || endYYMM.length() != 4 ) {
							sugmFlag = false;
						}
						
						// 지국 코드를 가져온다.
						dbparam = new HashMap();
						dbparam.put("SERIAL", txt_jcode);
			
						// excute query
						int agencyCnt = (Integer) generalDAO.getSqlMapClient().queryForObject("collection.edi.getAgencyInfo", dbparam);
						logger.debug("===== collection.edi.getAgencyInfo");
						
						if ( agencyCnt <= 0 ) {
							sugmFlag = false;
						}
						
						Calendar cal = Calendar.getInstance();
						int nowYear =  cal.get(Calendar.YEAR);
						String nowYearStr = Integer.toString(nowYear);
						
						// 에러가 아니면 입금처리
						if ( sugmFlag ) {
							
							List newsList = null;
							List sugmList = null;
							
							String nextYYYYMMDD = "";
							String nextYYMM = startYYMM;
							
							int nTxtMoney = Integer.parseInt(e_money[j]);			// 지로로 받은 금액
							
							int remainMoney = nTxtMoney;			// 수금처리 후 남은 금액
							
							while ( nextYYMM.compareTo(endYYMM) <= 0 ) {
								
								// 마지막 월마감 수금년월이 구독년월보다 크거나 작다면 미수입금처리
								if ( lastYYMM.compareTo(nextYYMM) >= 0 ) {
									
									dbparam = new HashMap();
									dbparam.put("NEWSCD", newscd);									// 신문코드
									dbparam.put("SGBBCD", CODE_SUGM_GUBUN_NOT_COMPLETE);			// 수금방법 - 미수
									//dbparam.put("SGGBCD_NOT", "'021','023','024','033','099'");			// 수금구분 - 자동이체 제외(본사입금,쿠폰,휴독,월삭제 제외 추가)
									dbparam.put("BOSEQ", txt_jcode);								// 지국코드
									dbparam.put("SDATE", nowYearStr.substring(0, 2) + nextYYMM);	// 구독년월, 시작년월
									dbparam.put("EDATE", nowYearStr.substring(0, 2) + nextYYMM);	// 구독년월, 종료년월
									
									if ( txt_type.equals(CODE_EDI_NEW_READER_GUBUN)|| txt_type.equals(CODE_EDI_NEW_READER_GUBUN_OTHERS) ) {	// 신 고객조회번호: newscd, txt_jcode, readno 로 처리
										dbparam.put("READNO", readno);								// 독자번호(9자리)
									}
									else {												// 구 고객조회번호: newscd, txt_jcode, gno, boreadno 로 처리
										dbparam.put("GNO", gno);									// 구역번호
										dbparam.put("BOREADNO", boreadno);							// 지국독자번호
									}
									
									// 미수 목록 조회
									sugmList = generalDAO.getSqlMapClient().queryForList("collection.edi.getSugmList", dbparam);
									logger.debug("===== collection.edi.getSugmList");
									
									if ( sugmList != null ) {
										for ( int k = 0; k < sugmList.size(); k++ ) {
											Map sugmMap = (Map) sugmList.get(k);
											String read_no = (String)sugmMap.get("READNO");				// 독자번호
											BigDecimal billAmt = (BigDecimal)sugmMap.get("BILLAMT");	// 청구금액
											String seq = (String)sugmMap.get("SEQ");					// 시퀀스	
											
											int nBillAmt = Integer.parseInt(billAmt.toString());		// 청구금액 int형으로 변환
											if ( remainMoney > 0 ) {	// 입금 처리 
												
												// 수금테이블 update
												dbparam = new HashMap();
												dbparam.put("READNO", read_no);									// 독자번호
												dbparam.put("NEWSCD", newscd);									// 신문코드
												dbparam.put("YYMM", nowYearStr.substring(0, 2) + nextYYMM);		// 구독년월
												dbparam.put("SEQ", seq);										// 시퀀스
												dbparam.put("SGBBCD", CODE_SUGM_GUBUN_NOT_COMPLETE);			// 수금방법 - 미수
												//dbparam.put("SGGBCD_NOT", "'021','023','024','033','099'");			// 수금구분 - 자동이체 제외(본사입금,쿠폰,휴독,월삭제 제외 추가)
												dbparam.put("BOSEQ", txt_jcode);								// 지국코드
												if ( remainMoney < nBillAmt ) {
													dbparam.put("AMT", remainMoney);							// 수금금액
													dbparam.put("LOSSAMT", nBillAmt - remainMoney);				// 결손금액
												}
												else {
													dbparam.put("AMT", nBillAmt);								// 수금금액
												}
												dbparam.put("SGBBCD_NEW", CODE_SUGM_TYPE_GIRO);					// 수금방법 - 지로
												dbparam.put("SGYYMM", last_yymm);								// 수금년월
												dbparam.put("EDIPROCNO", e_numid[j]);							// EDI처리번호
												dbparam.put("SNDT", e_sdate[j]);								// 수납일자
												dbparam.put("ICDT", e_edate[j]);								// 이체일자
												dbparam.put("CLDT", e_edate[j]);								// 처리일자
												dbparam.put("CHGPS", txt_jcode);								// 수정자 ID
												
												generalDAO.getSqlMapClient().update("collection.edi.updateSugm", dbparam);
												logger.debug("===== collection.edi.updateSugm 1 : " + read_no + ", " + seq + ", " + nextYYMM);
												
												if ( remainMoney > nBillAmt ) {
													remainMoney -= nBillAmt;
												}
												else {
													remainMoney = 0;
												}
											}
											else {	// 결손처리
												// 수금테이블 update
												dbparam = new HashMap();
												dbparam.put("READNO", read_no);									// 독자번호
												dbparam.put("NEWSCD", newscd);									// 신문코드
												dbparam.put("YYMM", nowYearStr.substring(0, 2) + nextYYMM);		// 구독년월
												dbparam.put("SEQ", seq);										// 시퀀스
												dbparam.put("SGBBCD", CODE_SUGM_GUBUN_NOT_COMPLETE);			// 수금방법 - 미수
												//dbparam.put("SGGBCD_NOT", "'021','023','024','033','099'");			// 수금구분 - 자동이체 제외(본사입금,쿠폰,휴독,월삭제 제외 추가)
												dbparam.put("BOSEQ", txt_jcode);								// 지국코드
												dbparam.put("AMT", 0);											// 수금금액
												dbparam.put("LOSSAMT", nBillAmt);								// 결손금액
												dbparam.put("SGBBCD_NEW", CODE_SUGM_TYPE_GIRO);					// 수금방법 - 지로
												dbparam.put("SGYYMM", last_yymm);								// 수금년월
												dbparam.put("EDIPROCNO", e_numid[j]);							// EDI처리번호
												dbparam.put("SNDT", e_sdate[j]);								// 수납일자
												dbparam.put("ICDT", e_edate[j]);								// 이체일자
												dbparam.put("CLDT", e_edate[j]);								// 처리일자
												dbparam.put("CHGPS", txt_jcode);								// 수정자 ID
												
												generalDAO.getSqlMapClient().update("collection.edi.updateSugm", dbparam);
												logger.debug("===== collection.edi.updateSugm 2 : " + read_no + ", " + seq + ", " + nextYYMM);
											}
										}
									}
								}
								else {	// 마지막 월마감 수금년월이 구독년월보다 작다면 선입금처리
									
									dbparam = new HashMap();
									dbparam.put("NEWSCD", newscd);									// 신문코드
									dbparam.put("BOSEQ", txt_jcode);								// 지국코드
									dbparam.put("YYMM", nowYearStr.substring(0, 2) + nextYYMM);		// 수금시작월 비교
									
									if ( txt_type.equals(CODE_EDI_NEW_READER_GUBUN) || txt_type.equals(CODE_EDI_NEW_READER_GUBUN_OTHERS) ) {	// 신 고객조회번호: newscd, txt_jcode, readno 로 처리
										dbparam.put("READNO", readno);								// 독자번호(9자리)
									}
									else {												// 구 고객조회번호: newscd, txt_jcode, gno, boreadno 로 처리
										dbparam.put("GNO", gno);									// 구역번호
										dbparam.put("BOREADNO", boreadno);							// 지국독자번호
									}
									
									newsList = generalDAO.getSqlMapClient().queryForList("collection.edi.getNewsList", dbparam);
									logger.debug("===== collection.edi.getNewsList");
									
									if ( newsList != null ) {
										for ( int k = 0; k < newsList.size(); k++ ) {
											Map newsMap = (Map) newsList.get(k);
											String read_no = (String)newsMap.get("READNO");				// 독자번호
											String seq = (String)newsMap.get("SEQ");					// 시퀀스
											BigDecimal qty = (BigDecimal)newsMap.get("QTY");			// 구독부수
											BigDecimal uprice = (BigDecimal)newsMap.get("UPRICE");		// 구독금액
											
											int nUprice = Integer.parseInt(uprice.toString());		// 구독금액 int형으로 변환
											
											dbparam = new HashMap();
											dbparam.put("READNO", read_no);					// 독자번호
											dbparam.put("NEWSCD", newscd);					// 신문코드
											dbparam.put("YYMM", nowYearStr.substring(0, 2)+nextYYMM);// 구독년월(월분)
											dbparam.put("SEQ", seq);						// 일련번호
											
											Map sugmMap = (Map) generalDAO.getSqlMapClient().queryForObject("collection.edi.getSugmMap", dbparam);
											logger.debug("===== collection.edi.getSugmMap");
											
											if ( sugmMap == null ) { 	// 있는지 검사후 없으면
												if ( remainMoney > 0 ) {	// 입금 처리 
													dbparam = new HashMap();
													dbparam.put("READNO", read_no);					// 독자번호
													dbparam.put("NEWSCD", newscd);					// 신문코드
													dbparam.put("YYMM", nowYearStr.substring(0, 2)+nextYYMM);// 구독년월(월분)
													dbparam.put("SEQ", seq);						// 일련번호
													dbparam.put("BOSEQ", txt_jcode);				// 지국코드
													dbparam.put("SGBBCD", CODE_SUGM_TYPE_GIRO);		// 수금방법 - 지로
													dbparam.put("SGGBCD", CODE_SUGM_TYPE_GIRO);		// 수금구분 - 지로
													dbparam.put("BILLAMT", nUprice);				// 청구금액
													dbparam.put("BILLQTY", qty);					// 청구부수
													dbparam.put("SGYYMM", last_yymm);				// 수금년월(월분)
													if ( remainMoney < nUprice ) {
														dbparam.put("AMT", remainMoney);				// 수금금액
														dbparam.put("LOSSAMT", nUprice - remainMoney);	// 결손금액
													}
													else {
														dbparam.put("AMT", nUprice);				// 수금금액
													}
													dbparam.put("EDIPROCNO", e_numid[j]);			// EDI처리번호
													dbparam.put("SNDT", e_sdate[j]);				// 수납일자
													dbparam.put("ICDT", e_edate[j]);				// 이체일자
													dbparam.put("CLDT", e_edate[j]);				// 처리일자
													dbparam.put("INPS", txt_jcode);					// 등록자 ID
													dbparam.put("CHGPS", txt_jcode);				// 수정자 ID
													
													generalDAO.getSqlMapClient().insert("collection.edi.insertPreSugm", dbparam);
													logger.debug("===== collection.edi.insertPreSugm 1 : " + read_no + ", " + seq + ", " + nextYYMM);
													
													if ( remainMoney > nUprice ) {
														remainMoney -= nUprice;
													}
													else {
														remainMoney = 0;
													}
												}
												else {	// 결손처리
													dbparam = new HashMap();
													dbparam.put("READNO", read_no);					// 독자번호
													dbparam.put("NEWSCD", newscd);					// 신문코드
													dbparam.put("YYMM", nowYearStr.substring(0, 2)+nextYYMM);// 구독년월(월분)
													dbparam.put("SEQ", seq);						// 일련번호
													dbparam.put("BOSEQ", txt_jcode);				// 지국코드
													dbparam.put("SGBBCD", CODE_SUGM_TYPE_GIRO);		// 수금방법 - 지로
													dbparam.put("SGGBCD", CODE_SUGM_TYPE_GIRO);		// 수금구분 - 지로
													dbparam.put("BILLAMT", nUprice);				// 청구금액
													dbparam.put("BILLQTY", qty);					// 청구부수
													dbparam.put("SGYYMM", last_yymm);				// 수금년월(월분)
													dbparam.put("AMT", 0);							// 수금금액
													dbparam.put("LOSSAMT", nUprice);				// 결손금액
													dbparam.put("EDIPROCNO", e_numid[j]);			// EDI처리번호
													dbparam.put("SNDT", e_sdate[j]);				// 수납일자
													dbparam.put("ICDT", e_edate[j]);				// 이체일자
													dbparam.put("CLDT", e_edate[j]);				// 처리일자
													dbparam.put("INPS", txt_jcode);					// 등록자 ID
													dbparam.put("CHGPS", txt_jcode);				// 수정자 ID
													
													generalDAO.getSqlMapClient().insert("collection.edi.insertPreSugm", dbparam);
													logger.debug("===== collection.edi.insertPreSugm 2 : " + read_no + ", " + seq + ", " + nextYYMM);
												}
											}
											else {
												String sgbbcd = (String) sugmMap.get("SGBBCD");
												
												// 미수로 수금에 들어있다면 입금처리
												if ( sgbbcd.equals(CODE_SUGM_GUBUN_NOT_COMPLETE) ) {
													
													BigDecimal billAmt = (BigDecimal)sugmMap.get("BILLAMT");	// 청구금액
													
													int nBillAmt = Integer.parseInt(billAmt.toString());		// 청구금액 int형으로 변환
													if ( remainMoney > 0 ) {	// 입금 처리 
														
														// 수금테이블 update
														dbparam = new HashMap();
														dbparam.put("READNO", read_no);									// 독자번호
														dbparam.put("NEWSCD", newscd);									// 신문코드
														dbparam.put("YYMM", nowYearStr.substring(0, 2) + nextYYMM);		// 구독년월
														dbparam.put("SEQ", seq);										// 시퀀스
														dbparam.put("SGBBCD", CODE_SUGM_GUBUN_NOT_COMPLETE);			// 수금방법 - 미수
														//dbparam.put("SGGBCD_NOT", "'021','023','024','033','099'");			// 수금구분 - 자동이체 제외(본사입금,쿠폰,휴독,월삭제 제외 추가)
														dbparam.put("BOSEQ", txt_jcode);								// 지국코드
														if ( remainMoney < nBillAmt ) {
															dbparam.put("AMT", remainMoney);							// 수금금액
															dbparam.put("LOSSAMT", nBillAmt - remainMoney);				// 결손금액
														}
														else {
															dbparam.put("AMT", nBillAmt);								// 수금금액
														}
														dbparam.put("SGBBCD_NEW", CODE_SUGM_TYPE_GIRO);					// 수금방법 - 지로
														dbparam.put("SGYYMM", last_yymm);								// 수금년월
														dbparam.put("EDIPROCNO", e_numid[j]);							// EDI처리번호
														dbparam.put("SNDT", e_sdate[j]);								// 수납일자
														dbparam.put("ICDT", e_edate[j]);								// 이체일자
														dbparam.put("CLDT", e_edate[j]);								// 처리일자
														dbparam.put("CHGPS", txt_jcode);								// 수정자 ID
														
														generalDAO.getSqlMapClient().update("collection.edi.updateSugm", dbparam);
														logger.debug("===== collection.edi.updateSugm 3 : " + read_no + ", " + seq + ", " + nextYYMM);
														
														if ( remainMoney > nBillAmt ) {
															remainMoney -= nBillAmt;
														}
														else {
															remainMoney = 0;
														}
													}
													else {	// 결손처리
														// 수금테이블 update
														dbparam = new HashMap();
														dbparam.put("READNO", read_no);									// 독자번호
														dbparam.put("NEWSCD", newscd);									// 신문코드
														dbparam.put("YYMM", nowYearStr.substring(0, 2) + nextYYMM);		// 구독년월
														dbparam.put("SEQ", seq);										// 시퀀스
														dbparam.put("SGBBCD", CODE_SUGM_GUBUN_NOT_COMPLETE);			// 수금방법 - 미수
														//dbparam.put("SGGBCD_NOT", "'021','023','024','033','099'");			// 수금구분 - 자동이체 제외(본사입금,쿠폰,휴독,월삭제 제외 추가)
														dbparam.put("BOSEQ", txt_jcode);								// 지국코드
														dbparam.put("AMT", 0);											// 수금금액
														dbparam.put("LOSSAMT", nBillAmt);								// 결손금액
														dbparam.put("SGBBCD_NEW", CODE_SUGM_TYPE_GIRO);					// 수금방법 - 지로
														dbparam.put("SGYYMM", last_yymm);								// 수금년월
														dbparam.put("EDIPROCNO", e_numid[j]);							// EDI처리번호
														dbparam.put("SNDT", e_sdate[j]);								// 수납일자
														dbparam.put("ICDT", e_edate[j]);								// 이체일자
														dbparam.put("CLDT", e_edate[j]);								// 처리일자
														dbparam.put("CHGPS", txt_jcode);								// 수정자 ID
														
														generalDAO.getSqlMapClient().update("collection.edi.updateSugm", dbparam);
														logger.debug("===== collection.edi.updateSugm 4 : " + read_no + ", " + seq + ", " + nextYYMM);
													}
												}
											}
										}
									}
								}
								
								// 한달씩 넘기면서 구독년월을 구한다.
								nextYYYYMMDD = DateUtil.getWantDay(nowYearStr.substring(0, 2)+ nextYYMM + "01", 2, 1);
								nextYYMM = nextYYYYMMDD.substring(2, 6);
							}
							
							// 과입금 처리
							if ( remainMoney > 0 ) {
								dbparam = new HashMap();
								dbparam.put("EDINUMID", e_numid[j]);					// edi 테이블에 저장된 pk
								dbparam.put("OVERMONEY", remainMoney);					// 과입금액
								generalDAO.getSqlMapClient().insert("collection.edi.insertEdiOver", dbparam);
								logger.debug("===== collection.edi.insertEdiOver");
							}
						}
						
						// 입금처리 
						if ( sugmFlag ) { 		// 입금처리 성공시 정상처리
							// 수금테이블에 정보가 없으면 에러 처리
							dbparam = new HashMap();
							dbparam.put("E_ERROR", "0");		// 정상처리
							successCnt++;
						}
						else {
							dbparam = new HashMap();
							dbparam.put("E_ERROR", "2");		// 에러처리
						}
						
						// 수금테이블에 정보가 없으면 에러 처리
						dbparam.put("E_RCODE", NCustNo[j]);
						dbparam.put("E_JCODE", e_jcode[j]);
						dbparam.put("E_WDATE", e_wdate[j]);
						dbparam.put("E_NUMBER", e_number[j]);
						dbparam.put("E_NUMID", e_numid[j]);
						generalDAO.getSqlMapClient().update("collection.edi.updateEdi", dbparam);
						logger.debug("===== collection.edi.updateEdi");
					}
				}
			}
			
			msg = "총 " + ErrCK.length + "건 중에 " + successCnt + "건이 정상적으로 입금 처리되었습니다.";
			
			// transaction commit
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
		}
		catch (Exception e) {
			// transaction rollback
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			
			msg = "정상적으로 처리되지 않았습니다.";
		}
		finally {
			// transaction end
			generalDAO.getSqlMapClient().endTransaction();
		}
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("common/message");
		mav.addObject("message", msg);
		mav.addObject("returnURL", "/collection/edi/gr15errList.do?sdate=" + sdate + "&edate=" + edate + "&type=" + type + "&jiroNum=" + jiroNum);
		return mav;
	}
	
	
	/**
	 * 지로 수납명세서(GR15) 처리 과입금 목록
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView gr15overList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		String sdate = param.getString("sdate");
		String edate = param.getString("edate");
		String type = param.getString("type", "1");	
		String jiroNum = param.getString("jiroNum", "");
		
		// 현재날짜 (yyyymmdd)
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		String nowDate = df.format(cal.getTime());
		
		if ( StringUtils.isEmpty(sdate) ) {
			sdate = nowDate.substring(0, 4) + "-" + nowDate.substring(4, 6) + "-" + nowDate.substring(6, 8);
		}
		if ( StringUtils.isEmpty(edate) ) {
			edate = nowDate.substring(0, 4) + "-" + nowDate.substring(4, 6) + "-" + nowDate.substring(6, 8);
		}
		
		String sdate_tmp = sdate.replaceAll("-", ""); //yyyymmdd
		String edate_tmp = edate.replaceAll("-", ""); //yyyymmdd
		
		// 기간별 gr15 처리 과입금 목록
		Map dbparam = new HashMap();
		dbparam.put("sdate", sdate_tmp);			// 시작일(YYYYMMDD)
		dbparam.put("edate", edate_tmp);			// 종료일(YYYYMMDD)
		dbparam.put("type", type);		// 지로형태 콤보박스 (1:직영지로 , 2:타 지로, 0:전체)
		dbparam.put("MK_JIRO_NUMBER", MK_JIRO_NUMBER);	// 직영지로번호
		dbparam.put("jiroNum", jiroNum);
		List resultList = generalDAO.queryForList("collection.edi.getGR15OverList", dbparam);
		logger.debug("===== collection.edi.getGR15OverList");
		
		// 금융결재원 등록 지로번호 목록
		List jiroList = generalDAO.queryForList("collection.edi.getJiroList", dbparam);
		logger.debug("===== collection.edi.getJiroList");
				
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("collection/edi/gr15overList");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COLLECTION_EDI);
		
		mav.addObject("sdate", sdate);
		mav.addObject("edate", edate);
		mav.addObject("type", type);
		mav.addObject("jiroNum", jiroNum);
		mav.addObject("jiroList", jiroList);
		
		mav.addObject("resultList", resultList);
		
		return mav;
	}
	
	
	/**
	 * 지로 수납명세서(GR15) 등록화면 - 청약지국 임시처리용
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView gr15attach2(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("collection/edi/gr15attach2");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COLLECTION_EDI);
		
		return mav;
	}
	
	
	/**
	 * 지로 수납명세서(GR15) 처리 - 청약지국 임시처리용
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView gr15process2_excel(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		MultipartHttpServletParam param = new MultipartHttpServletParam(request);
		MultipartFile edifile = param.getMultipartFile("edifile");
		
		HashMap dbparam = new HashMap();
		
		// mav
		ModelAndView mav = new ModelAndView();
		
		List resultList = new ArrayList();
		
		if ( edifile.isEmpty()) {	// 파일 첨부가 안되었으면 
			mav.setViewName("common/message");
			mav.addObject("message", "파일첨부가 되지 않았습니다.");
			mav.addObject("returnURL", "/collection/edi/gr15attach2.do");
			return mav;
		}
		else {	// 파일 첨부가 되었으면
			
			int sngError = 0;
			int rec_count = 0;
				
			FileUtil fileUtil = new FileUtil( getServletContext() );
			String strFile = fileUtil.saveUploadFile(
											edifile, 
											PATH_PHYSICAL_HOME,
											PATH_UPLOAD_ABSOLUTE_EDI_GR15 + "/view"
										);
			
			if ( StringUtils.isEmpty(strFile) ) {
				mav.setViewName("common/message");
				mav.addObject("message", "파일 저장이 실패하였습니다. ");
				mav.addObject("returnURL", "/collection/edi/gr15attach2.do");
				return mav;
			}
			else if ( strFile.length() != 10 ) {	// GR15YYMMDD 
				mav.setViewName("common/message");
				mav.addObject("message", "파일명이 잘못되었습니다.");
				mav.addObject("returnURL", "/collection/edi/gr15attach2.do");
				return mav;
			}
			else {
				
				String msg = "";
				
				int LINE_NUM = 120;
				
				String fileName = PATH_UPLOAD_RELATIVE_EDI_GR15 + "/view/" + strFile;
				
				File f = new File(fileName);
				FileInputStream fis = new FileInputStream(f);
					
					
				int count;
				byte[] b = new byte[LINE_NUM];
				
				String txt_jiro = "";
				String txt_hdate = "";
				String txt_gunsoo = "";
				
				String txt_code = "";
				String txtline = "";
				
				String errstr = "";		// 0 : 정상, others : 에러
				
				String txt_num = "";
				String txt_sdate = "";
				String txt_edate = "";
				String txt_scode = "";
				String txt_empty1 = "";
				String txt_empty2 = "";
				String txt_gnum = "";
				String txt_money = "";
				String txt_sgubun = "";
				String txt_gmoney = "";
				String txt_jgubun = "";

				String txt_jcode = "";
				String newscd = "";
				String readno = "";
				String gno = "";
				String boreadno = "";
				
				String startYYMM = "";
				String endYYMM = "";
													
				String txt_type = "";
				
				Calendar cal = Calendar.getInstance();
				int nowYear =  cal.get(Calendar.YEAR);
				String nowYearStr = Integer.toString(nowYear);
				
				while ((count = fis.read(b)) != -1) {
					
					txtline = new String(b);
					
					if ( txtline.length() != 0 ) {
						
						txt_code = txtline.substring(0, 2);			// (2) Data 구분코드
						
						if ( txt_code.equals(CODE_EDI_LAYOUT_HEADER) ) {			// 헤더면
							txt_jiro = txtline.substring(4, 11);			// (7) 지로번호
							txt_hdate = txtline.substring(17, 25);			// (8) 이체일자 (YYYYMMDD)
						}
						else if ( txt_code.equals(CODE_EDI_LAYOUT_TRAILER) ) {
							txt_gunsoo = txtline.substring(2, 9);			// (7) Data Record의 총 Record 건수
						}
						else if ( txt_code.equals(CODE_EDI_LAYOUT_DATA) ) {		// 데이터면
							
							rec_count++;
								
							errstr = "";		// 0 : 정상, others : 에러
							
							txt_num = txtline.substring(2, 9);			// (7) 일련번호
							txt_sdate = txtline.substring(9, 17);		// (8) 수납일자(YYYYMMDD)
							txt_edate = txtline.substring(17, 25);		// (8) 이체일자(YYYYMMDD)
							txt_scode = txtline.substring(25, 32);		// (7) 수납점 코드(은행코드(3) + 점포코드(4))
							txt_empty1 = txtline.substring(32, 39);		// (7) 정보 작성점(은행코드(3) + 점포코드(4))
							txt_empty2 = txtline.substring(39, 51);		// (12)색인번호(IRN)
							txt_gnum = txtline.substring(51, 71);		// (20)고객조회번호(Check Digit 1자리 포함)
							txt_money = txtline.substring(71, 84);		// (13)금액(Check Digit 1자리 생략)
							txt_sgubun = txtline.substring(84, 85);		// (1) 수납구분(정상분(공란),...)
							txt_gmoney = txtline.substring(85, 89);		// (4) 지로수수료
							txt_jgubun = txtline.substring(89, 90);		// (1) 장표처리구분(정상분(공란), Reject분(R), A장표(A))

							txt_jcode = "";
							newscd = "";
							readno = "";
							gno = "";
							boreadno = "";
							
							startYYMM = "";
							endYYMM = "";
																
							txt_type = txtline.substring(51, 53);		// (2) 고객조회번호에 들어있는 신구 구분코드
							if ( txt_type.equals(CODE_EDI_NEW_READER_GUBUN)|| txt_type.equals(CODE_EDI_NEW_READER_GUBUN_OTHERS)  ) {
								
								// 신 고객조회번호 (구분(2) + 매체번호(2) + 독자번호(9) + 시작년월(4) + 개월분(2) + check(1))											
								newscd = "1" + txtline.substring(53, 55);		// (2) 매체번호 (원래 매체번호는 3자리이나 여기선 첫번째 1이 빠진 나머지 2자리만 넘어옴)
								readno = txtline.substring(55, 64);				// (9) 독자번호
								startYYMM = txtline.substring(64, 68);			// (4) 시작년월
								String plusMonths = txtline.substring(68, 70);	// (2) 개월분
								
								endYYMM = getEndYYMM(startYYMM, plusMonths);	// 종료년월을 구한다.
								
								// (6) 지국코드. 독자번호로 news 테이블에서 가져와야함.
								dbparam = new HashMap();
								dbparam.put("NEWSCD", newscd);
								dbparam.put("READNO", readno);
								
								txt_jcode = (String ) generalDAO.queryForObject("collection.edi.getAgencyCodeFromReadno", dbparam);
								logger.debug("===== collection.edi.getAgencyCodeFromReadno");
							}
							else {	
								
								// 구 고객조회번호 (지국번호(6) + 구역(2) + 독자번호(5) + 시작월(2) + 종료년월(4) + check(1))
								newscd = MK_NEWSPAPER_CODE;
								txt_jcode = txtline.substring(51, 57);			// (6) 지국코드
								gno = "1" + txtline.substring(57, 59);			// (2) 구역코드(1을 뺀 2자리)
								boreadno = txtline.substring(59, 64);			// (5) 지국독자번호
								String startMM = txtline.substring(64, 66);		// (2) 시작월
								endYYMM = txtline.substring(66, 70);			// (4) 종료년월
								
								if ( "00".equals(startMM) ) {	// 시작월이 00이면 종료년월 필드에 있는 yymm 한달을 의미
									startYYMM = endYYMM;
								}
								else {		// 시작월이 00이 아니라면 종료년월의 년도만 가져와서 조합.
									if ( startMM.compareTo(endYYMM.substring(2,4)) > 0 ) {
										int tmpYY = Integer.parseInt(endYYMM.substring(0, 2));
										tmpYY = (tmpYY - 1) % 100;
										String tmpYYStr = (tmpYY < 10) ? "0"+Integer.toString(tmpYY) : Integer.toString(tmpYY);
										startYYMM = tmpYYStr.substring(0, 2) + startMM;
									}
									else {
										startYYMM = endYYMM.substring(0, 2) + startMM;
									}
								}
							}
							


							if ( "3172508".equals(txt_jiro) ) {  //전자신문(000000) 공덕지국 => 마포지국(511009)
								txt_jcode = "511009";
								if(!boreadno.trim().equals("")){
									boreadno = Integer.toString(Integer.parseInt(boreadno) + 50000);
								}
								dbparam = new HashMap();
								dbparam.put("BOSEQ", txt_jcode);
								dbparam.put("BOREADNO", boreadno);
								dbparam.put("GNO", gno);
								newscd = (String) generalDAO.getSqlMapClient().queryForObject("collection.edi.getNewsCode", dbparam);
							}else if ( "3162851".equals(txt_jiro) ) {  // 국민일보 가락석촌지국 => 신송파(511017)
								txt_jcode = "511017";
								if(!boreadno.trim().equals("")){
									boreadno = Integer.toString(Integer.parseInt(boreadno) + 50000);
								}
								dbparam = new HashMap();
								dbparam.put("BOSEQ", txt_jcode);
								dbparam.put("BOREADNO", boreadno);
								dbparam.put("GNO", gno);
								newscd = (String) generalDAO.getSqlMapClient().queryForObject("collection.edi.getNewsCode", dbparam);
							}else if ( "3020634".equals(txt_jiro) ) {  // 세계일보(010010) 영등포지국 => 영등포지국(511019)
								txt_jcode = "511019";
								if(!boreadno.trim().equals("")){
									boreadno = Integer.toString(Integer.parseInt(boreadno) + 50000);
								}
								dbparam = new HashMap();
								dbparam.put("BOSEQ", txt_jcode);
								dbparam.put("BOREADNO", boreadno);
								dbparam.put("GNO", gno);
								newscd = (String) generalDAO.getSqlMapClient().queryForObject("collection.edi.getNewsCode", dbparam);
							}else if ( "3033647".equals(txt_jiro) ) {  // 세계일보 왕십리지국
								txt_jcode = "511020";
								if(!boreadno.trim().equals("")){
									boreadno = Integer.toString(Integer.parseInt(boreadno) + 50000);
								}
								dbparam = new HashMap();
								dbparam.put("BOSEQ", txt_jcode);
								dbparam.put("BOREADNO", boreadno);
								dbparam.put("GNO", gno);
								newscd = (String) generalDAO.getSqlMapClient().queryForObject("collection.edi.getNewsCode", dbparam);
							}else if ( "3163643".equals(txt_jiro) ) {  // 서울신문(511002), 스포츠서울(511002), 전자신문(511005) 세종 => 서소문지국(511002)
								if("511002".equals(txt_jcode)){
									if(!boreadno.trim().equals("")){
										boreadno = Integer.toString(Integer.parseInt(boreadno) + 60000);
									}
								}else{
									txt_jcode = "511002";
								}
								
								dbparam = new HashMap();
								dbparam.put("BOSEQ", txt_jcode);
								dbparam.put("BOREADNO", boreadno);
								dbparam.put("GNO", gno);
								newscd = (String) generalDAO.getSqlMapClient().queryForObject("collection.edi.getNewsCode", dbparam);
							}else if ( "3168279".equals(txt_jiro) ) {  // 국민일보 왕십리지국
								txt_jcode = "511020";
								if(!boreadno.trim().equals("")){
									boreadno = Integer.toString(Integer.parseInt(boreadno) + 50000);
								}
								dbparam = new HashMap();
								dbparam.put("BOSEQ", txt_jcode);
								dbparam.put("BOREADNO", boreadno);
								dbparam.put("GNO", gno);
								newscd = (String) generalDAO.getSqlMapClient().queryForObject("collection.edi.getNewsCode", dbparam);
							}else if ( "3162327".equals(txt_jiro) ) {  // 매일경제 청담지국
								txt_jcode = "512015";
								if(!boreadno.trim().equals("")){
									boreadno = Integer.toString(Integer.parseInt(boreadno) + 50000);
								}
								dbparam = new HashMap();
								dbparam.put("BOSEQ", txt_jcode);
								dbparam.put("BOREADNO", boreadno);
								dbparam.put("GNO", gno);
								newscd = (String) generalDAO.getSqlMapClient().queryForObject("collection.edi.getNewsCode", dbparam);
								
							}else if ( "3173099".equals(txt_jiro) ) {  //  가락지국
								txt_jcode = "512039";
								if(!boreadno.trim().equals("")){
									boreadno = Integer.toString(Integer.parseInt(boreadno) + 50000);
								}
								dbparam = new HashMap();
								dbparam.put("BOSEQ", txt_jcode);
								dbparam.put("BOREADNO", boreadno);
								dbparam.put("GNO", gno);
								newscd = (String) generalDAO.getSqlMapClient().queryForObject("collection.edi.getNewsCode", dbparam);
								
							}else if ( "3172249".equals(txt_jiro) ) {  //  서여의지국(511011) 경향신문 등
								txt_jcode = "511011";
								if(!boreadno.trim().equals("")){
									boreadno = Integer.toString(Integer.parseInt(boreadno) + 50000);
								}
								dbparam = new HashMap();
								dbparam.put("BOSEQ", txt_jcode);
								dbparam.put("BOREADNO", boreadno);
								dbparam.put("GNO", gno);
								newscd = (String) generalDAO.getSqlMapClient().queryForObject("collection.edi.getNewsCode", dbparam);
								
							}else if ( "3158742".equals(txt_jiro) ) {  //  서여의지국(311011) 문화일보
								txt_jcode = "311011";
								
								dbparam = new HashMap();
								dbparam.put("BOSEQ", txt_jcode);
								dbparam.put("BOREADNO", boreadno);
								dbparam.put("GNO", gno);
								newscd = (String) generalDAO.getSqlMapClient().queryForObject("collection.edi.getNewsCode", dbparam);
								
							}											
							
							
							String txt_rcode = txtline.substring(51, 65);
							String txt_all = txtline;
							
							// 지국 코드를 가져온다.
							dbparam = new HashMap();
							dbparam.put("SERIAL", txt_jcode);

							// excute query
							int agencyCnt = (Integer) generalDAO.queryForObject("collection.edi.getAgencyInfo", dbparam);
							logger.debug("===== collection.edi.getAgencyInfo");
							
							int nTxtMoney = Integer.parseInt(txt_money);			// 지로로 받은 금액
							int nTxtGmoney = Integer.parseInt(txt_gmoney);			// 지로수수료
							
							dbparam = new HashMap();
							dbparam.put("NEWSCD", newscd);									// 신문코드
							dbparam.put("BOSEQ", txt_jcode);								// 지국코드
							dbparam.put("YYMM", nowYearStr.substring(0, 2) + startYYMM);	// 구독시작월분
							
							if ( txt_type.equals(CODE_EDI_NEW_READER_GUBUN)|| txt_type.equals(CODE_EDI_NEW_READER_GUBUN_OTHERS) ) {	// 신 고객조회번호: newscd, txt_jcode, readno 로 처리
								dbparam.put("READNO", readno);								// 독자번호(9자리)
							}
							else {												// 구 고객조회번호: newscd, txt_jcode, gno, boreadno 로 처리
								dbparam.put("GNO", gno);									// 구역번호
								dbparam.put("BOREADNO", boreadno);							// 지국독자번호
							}
							
							Map newsMap = (Map) generalDAO.queryForObject("collection.edi.getNewsMap", dbparam);
							
							if ( newsMap == null ) {
								newsMap = new HashMap();
							}
							
							newsMap.put("txt_gnum", txt_gnum);		// 고객조회번호
							newsMap.put("startYYMM", startYYMM);	// 시작월분
							newsMap.put("endYYMM", endYYMM);		// 종료월분
							newsMap.put("nTxtMoney", nTxtMoney);	// 입금액
							newsMap.put("nTxtGmoney", nTxtGmoney);	// 수수료
							newsMap.put("txt_sdate", txt_sdate);	// 수납일자(YYYYMMDD)
							newsMap.put("txt_edate", txt_edate);	// 이체일자(YYYYMMDD)
							
							resultList.add(newsMap);
						}
					}
				}
				
				fis.close();
				
				String file_name = edifile.getOriginalFilename() + "_fileview.xls";
				
				//Excel response
				response.setHeader("Content-Disposition", "attachment; filename=" + file_name);
				response.setHeader("Content-Description", "JSP Generated Data");
				
				mav.setViewName("collection/edi/gr15process2_excel");
				mav.addObject("now_menu", ICodeConstant.MENU_CODE_COLLECTION_EDI);
				
				mav.addObject("msg", msg);
				mav.addObject("sngError", sngError);
				mav.addObject("rec_count", rec_count);
				
				mav.addObject("resultList", resultList);
				mav.addObject("txt_jiro", txt_jiro);
				
				return mav;
			}
		}
	}
	
	
	private String getEndYYMM(String startYYMM, String plusMonths) {
		
		String endYYMM = null;
		
		if ( StringUtils.isNotEmpty(startYYMM) && StringUtils.isNotEmpty(plusMonths)) {
		
			int months = Integer.parseInt(plusMonths);
			
			if ( months > 0 ) {
				
				months -= 1;		// 현재월만 처리할 때 01이 넘어오니까 연산시에는 1을 빼줘야함.
		
				int year_plus = months / 12;
				int month_plus = months % 12;
				
				int tmpYY = Integer.parseInt(startYYMM.substring(0, 2));	
				int tmpMM = Integer.parseInt(startYYMM.substring(2, 4));

				tmpYY += year_plus;
				tmpMM += month_plus;
				
				tmpYY += (tmpMM/13);				
				
				tmpMM += ( tmpMM >= 13 ) ? 1 : 0;
				tmpMM = tmpMM % 13;
				
				// 종료 년도
				String endYY = Integer.toString(tmpYY);
				if ( endYY.length() == 1 ) {
					endYY = "0" + endYY; 
				} else if ( endYY.length() >= 3 ) {
					endYY = endYY.substring(1, 3); 
				}
				
				// 종료 월
				String endMM = (tmpMM < 10) ? ("0" + Integer.toString(tmpMM)) : Integer.toString(tmpMM);
				
				// 종료 년월
				endYYMM = endYY + endMM;
			}
		}
		
		return endYYMM;
	}
	
	/**
	 * EDI관리 - 지국별자료조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ediList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		String edate = param.getString("edate");
		String jikuk = param.getString("jikuk");
		String type = param.getString("type", "1");	
		
		// 현재날짜 (yyyymmdd)
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		String nowDate = df.format(cal.getTime());
		
		if ( StringUtils.isEmpty(edate) ) {
			edate = nowDate.substring(0, 4) + "-" + nowDate.substring(4, 6) + "-" + nowDate.substring(6, 8);
		}
		
		String edate_tmp = edate.replaceAll("-", "");
		
		//지국목록
		List jikukList = generalDAO.queryForList("reader.common.agencyAllList");
		logger.debug("===== reader.common.agencyAllList");
						
		// 이체일자별 EDI 입금 정상 처리 목록
		Map dbparam = new HashMap();
		dbparam.put("JIKUK_CODE", jikuk);					// 지국코드
		dbparam.put("EDATE", edate_tmp);					// 이체일자(YYYYMMDD)
		dbparam.put("NEWSCD", MK_NEWSPAPER_CODE);			// 뉴스코드		
		dbparam.put("SGBBCD", CODE_SUGM_TYPE_GIRO);			// 수금방법
		dbparam.put("GU", "구 ");							// 구
		dbparam.put("APT", "아파트");							// 아파트
		dbparam.put("type", type);		// 지로형태 콤보박스 (1:직영지로 , 2:타 지로, 3, 바코드 수납, 0:전체)	
		dbparam.put("MK_JIRO_NUMBER", MK_JIRO_NUMBER);	// 직영지로번호
		List resultList = generalDAO.queryForList("collection.edibranch.getEdiList", dbparam);
		logger.debug("===== collection.edibranch.getEdiList");
		
		String startYYMM = "";
		String endYYMM = "";
		
		int nowYear =  cal.get(Calendar.YEAR);
		String nowYearStr = Integer.toString(nowYear);
		
		String nowYY = nowYearStr.substring(0, 2);
		
		if ( resultList != null ) {
			Iterator iter = resultList.iterator();
			while ( iter.hasNext()) {
				Map tmpMap = (Map) iter.next(); 
				
				String e_check = (String) tmpMap.get("E_CHECK");
				
				if ( StringUtils.isNotEmpty(e_check) && e_check.length() >= 20 ) {
				
					String txt_type = e_check.substring(0, 2);		// (2) 고객조회번호에 들어있는 신구 구분코드
					if ( txt_type.equals(CODE_EDI_NEW_READER_GUBUN) || txt_type.equals(CODE_EDI_NEW_READER_GUBUN_OTHERS) ) {
						
						// 신 고객조회번호
						startYYMM = e_check.substring(13, 17);			// (4) 시작년월
						String plusMonths = e_check.substring(17, 19);	// (2) 개월분
						
						endYYMM = getEndYYMM(startYYMM, plusMonths);	// 종료년월을 구한다.
					}
					else {	
						
						// 구 고객조회번호
						String startMM = e_check.substring(13, 15);		// (2) 시작월
						endYYMM = e_check.substring(15, 19);			// (4) 종료년월
						
						if ( "00".equals(startMM) ) {	// 시작월이 00이면 종료년월 필드에 있는 yymm 한달을 의미
							startYYMM = endYYMM;
						}
						else {		// 시작월이 00이 아니라면 종료년월의 년도만 가져와서 조합.
							if ( startMM.compareTo(endYYMM.substring(2,4)) > 0 ) {
								int tmpYY = Integer.parseInt(endYYMM.substring(0, 2));
								tmpYY = (tmpYY - 1) % 100;
								String tmpYYStr = (tmpYY < 10) ? "0"+Integer.toString(tmpYY) : Integer.toString(tmpYY);
								startYYMM = tmpYYStr.substring(0, 2) + startMM;
							}
							else {
								startYYMM = endYYMM.substring(0, 2) + startMM;
							}
						}
					}
					
					tmpMap.put("STARTYYMM", startYYMM);
					tmpMap.put("ENDYYMM", endYYMM);
				}
			}
		}
		
		// 정상 자료 총합
		dbparam = new HashMap();
		dbparam.put("JIKUK_CODE", jikuk);					// 지국코드
		dbparam.put("EDATE", edate_tmp);					// 이체일자(YYYYMMDD)
		dbparam.put("E_ERROR", "NORMAL");					// 상태정보
		dbparam.put("type", type);		// 지로형태 콤보박스 (1:직영지로 , 2:타 지로, 0:전체)
		dbparam.put("MK_JIRO_NUMBER", MK_JIRO_NUMBER);	// 직영지로번호
		Map normalMap = (Map) generalDAO.queryForObject("collection.edibranch.getEdiSumInfo", dbparam);
		logger.debug("===== collection.edibranch.getEdiSumInfo");
		
		// 에러 자료 총합
		dbparam = new HashMap();
		dbparam.put("JIKUK_CODE", jikuk);					// 지국코드
		dbparam.put("EDATE", edate_tmp);					// 이체일자(YYYYMMDD)
		dbparam.put("E_ERROR", "ERROR");					// 상태정보
		dbparam.put("type", type);		// 지로형태 콤보박스 (1:직영지로 , 2:타 지로, 0:전체)
		dbparam.put("MK_JIRO_NUMBER", MK_JIRO_NUMBER);	// 직영지로번호
		Map errorMap = (Map) generalDAO.queryForObject("collection.edibranch.getEdiSumInfo", dbparam);
		logger.debug("===== collection.edibranch.getEdiSumInfo");
		
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("collection/edi/ediList");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COLLECTION_EDI);

		mav.addObject("jikuk", jikuk);
		mav.addObject("jikukList", jikukList);
		mav.addObject("resultList", resultList);
		mav.addObject("normalMap", normalMap);
		mav.addObject("errorMap", errorMap);
		mav.addObject("type", type);
		mav.addObject("edate", edate);
		
		return mav;
	}
	
	

	/**
	 * 지로 수납명세서(GR15)_수납대행용 파일 처리
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView gr15AgencyProcess(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		MultipartHttpServletParam param = new MultipartHttpServletParam(request);
		MultipartFile edifile = param.getMultipartFile("edifile");
		
		HashMap dbparam = new HashMap();
		
		// mav
		ModelAndView mav = new ModelAndView();
		
		
		if ( edifile.isEmpty()) {	// 파일 첨부가 안되었으면 
			mav.setViewName("common/message");
			mav.addObject("message", "파일첨부가 되지 않았습니다.");
			mav.addObject("returnURL", "/collection/edi/gr15attach.do");
			return mav;
		}
		else {	// 파일 첨부가 되었으면
			
			int sngError = 0;
			int rec_count = 0;
			
			dbparam = new HashMap();
			dbparam.put("FILENAME", edifile.getOriginalFilename());
			dbparam.put("TYPE", "AGENCY");

			// excute query
			Map fileMap = (Map) generalDAO.queryForObject("collection.edi.getUploadFileInfo", dbparam);
			logger.debug("===== collection.edi.getUploadFileInfo");
			
			// 이미 같은 이름으로된 파일이 업로드 되었다면 실패
			if ( fileMap != null ) {
				mav.setViewName("common/message");
				mav.addObject("message", "이미 파일이 있습니다.");
				mav.addObject("returnURL", "/collection/edi/gr15attach.do");
				return mav;
				
			}else {
				
				FileUtil fileUtil = new FileUtil( getServletContext() );
				String strFile = fileUtil.saveUploadFile(
												edifile, 
												PATH_PHYSICAL_HOME,
												PATH_UPLOAD_ABSOLUTE_EDI_GR15_AGENCY
											);
				
				if ( StringUtils.isEmpty(strFile) ) {
					mav.setViewName("common/message");
					mav.addObject("message", "파일 저장이 실패하였습니다. ");
					mav.addObject("returnURL", "/collection/edi/gr15attach.do");
					return mav;
				}
				else if ( strFile.length() != 10 ) {	// GR15YYMMDD 
					mav.setViewName("common/message");
					mav.addObject("message", "파일명이 잘못되었습니다.");
					mav.addObject("returnURL", "/collection/edi/gr15attach.do");
					return mav;
				}
				else {
					
					String msg = "";
					
					int LINE_NUM = 120;
					
					String fileName = PATH_UPLOAD_RELATIVE_EDI_GR15_AGENCY + "/" + strFile;
					
					File f = new File(fileName);
					FileInputStream fis = new FileInputStream(f);
					String txtline = "";
					
					try {
						
						// transaction start
						generalDAO.getSqlMapClient().startTransaction();					
						generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
						
						int count;
						byte[] b = new byte[LINE_NUM];
						
						String txt_jiro = "";
						String txt_hdate = "";
						String txt_gunsoo = "";
						
						// 마지막 수금년월을 가져옴. 
						String last_yymm = (String) generalDAO.getSqlMapClient().queryForObject("common.getLastSGYYMM");
						String lastYYMM = last_yymm.substring(2,6);
						
						String txt_code = "";
						txtline = "";
						String errstr = "";		// 0 : 정상, others : 에러
						
						String txt_num = "";
						String txt_sdate = "";
						String txt_edate = "";
						String txt_scode = "";
						String txt_empty1 = "";
						String txt_empty2 = "";
						String txt_gnum = "";
						String txt_money = "";
						String txt_sgubun = "";
						String txt_gmoney = "";
						String txt_jgubun = "";

						String txt_jcode = "";
						String newscd = "";
						String readno = "";
						String gno = "";
						String boreadno = "";
						
						String startYYMM = "";
						String endYYMM = "";
															
						String txt_type = "";
						String txt_rcode = "";
						
						Calendar cal = Calendar.getInstance();
						int nowYear =  cal.get(Calendar.YEAR);
						String nowYearStr = Integer.toString(nowYear);
						
						while ((count = fis.read(b)) != -1) {
							
							txtline = new String(b);
							
							if ( txtline.length() != 0 ) {
								
								txt_code = txtline.substring(0, 2);			// (2) Data 구분코드
								
								if ( txt_code.equals(CODE_EDI_LAYOUT_HEADER) ) {			// 헤더면
									txt_jiro = txtline.substring(4, 11);			// (7) 지로번호
									txt_hdate = txtline.substring(17, 25);			// (8) 이체일자 (YYYYMMDD)
									
									if ( txt_jiro.equals(MK_JIRO_NUMBER)) {		// 수납대행용 지로 파일인지 체크
										mav.setViewName("common/message");
										mav.addObject("message", "수납대행용 지로번호와 일치하지 않습니다.");
										mav.addObject("returnURL", "/collection/edi/gr15attach.do");
										return mav;
									}
								}
								else if ( txt_code.equals(CODE_EDI_LAYOUT_TRAILER) ) {
									txt_gunsoo = txtline.substring(2, 9);			// (7) Data Record의 총 Record 건수
								}
								else if ( txt_code.equals(CODE_EDI_LAYOUT_DATA) ) {		// 데이터면
									
									rec_count++;

									errstr = "0";		// 0 : 정상, others : 에러
									
									txt_num = txtline.substring(2, 9);			// (7) 일련번호
									txt_sdate = txtline.substring(9, 17);		// (8) 수납일자(YYYYMMDD)
									txt_edate = txtline.substring(17, 25);		// (8) 이체일자(YYYYMMDD)
									txt_scode = txtline.substring(25, 32);		// (7) 수납점 코드(은행코드(3) + 점포코드(4))
									txt_empty1 = txtline.substring(32, 39);		// (7) 정보 작성점(은행코드(3) + 점포코드(4))
									txt_empty2 = txtline.substring(39, 51);		// (12)색인번호(IRN)
									txt_gnum = txtline.substring(51, 71);		// (20)고객조회번호(Check Digit 1자리 포함)
									txt_money = txtline.substring(71, 84);		// (13)금액(Check Digit 1자리 생략)
									txt_sgubun = txtline.substring(84, 85);		// (1) 수납구분(정상분(공란),...)
									txt_gmoney = txtline.substring(85, 89);		// (4) 지로수수료
									txt_jgubun = txtline.substring(89, 90);		// (1) 장표처리구분(정상분(공란), Reject분(R), A장표(A))
									txt_rcode = txtline.substring(51, 65);

									txt_jcode = "";
									newscd = "";
									readno = "";
									gno = "";
									boreadno = "";
									
									startYYMM = "";
									endYYMM = "";
									
									txt_type = txtline.substring(51, 53);		// (2) 고객조회번호에 들어있는 신구 구분코드
									if ( txt_type.equals(CODE_EDI_NEW_READER_GUBUN) || txt_type.equals(CODE_EDI_NEW_READER_GUBUN_OTHERS) ) {
										
										// 신 고객조회번호 (구분(2) + 매체번호(2) + 독자번호(9) + 시작년월(4) + 개월분(2) + check(1))											
										newscd = "1" + txtline.substring(53, 55);		// (2) 매체번호 (원래 매체번호는 3자리이나 여기선 첫번째 1이 빠진 나머지 2자리만 넘어옴)
										readno = txtline.substring(55, 64);				// (9) 독자번호
										startYYMM = txtline.substring(64, 68);			// (4) 시작년월
										String plusMonths = txtline.substring(68, 70);	// (2) 개월분
										
										endYYMM = getEndYYMM(startYYMM, plusMonths);	// 종료년월을 구한다.
										
										// (6) 지국코드. 독자번호로 news 테이블에서 가져와야함.
										dbparam = new HashMap();
										dbparam.put("NEWSCD", newscd);
										dbparam.put("READNO", readno);
										
										txt_jcode = (String ) generalDAO.getSqlMapClient().queryForObject("collection.edi.getAgencyCodeFromReadno", dbparam);
										logger.debug("===== collection.edi.getAgencyCodeFromReadno");
										
										// 입금처리하기 위한 데이터가 없다면 에러처리
										if ( StringUtils.isEmpty(newscd) || StringUtils.isEmpty(readno)) {
											errstr = "1";
										}
										// 입금처리하기 위한 지국코드 데이터가 없다면 에러처리, 해당칼럼 not null이므로 임시값 세팅
										if ( StringUtils.isEmpty(txt_jcode)) {
											errstr = "1";
											txt_jcode = "000000";
										}
									}
									else {	
										
										// 구 고객조회번호 (지국번호(6) + 구역(2) + 독자번호(5) + 시작월(2) + 종료년월(4) + check(1))
										newscd = MK_NEWSPAPER_CODE;
										txt_jcode = txtline.substring(51, 57);			// (6) 지국코드
										gno = "1" + txtline.substring(57, 59);			// (2) 구역코드(1을 뺀 2자리)
										boreadno = txtline.substring(59, 64);			// (5) 지국독자번호
										String startMM = txtline.substring(64, 66);		// (2) 시작월
										endYYMM = txtline.substring(66, 70);			// (4) 종료년월
										
										if ( "00".equals(startMM) ) {	// 시작월이 00이면 종료년월 필드에 있는 yymm 한달을 의미
											startYYMM = endYYMM;
										}
										else {		// 시작월이 00이 아니라면 종료년월의 년도만 가져와서 조합.
											if ( startMM.compareTo(endYYMM.substring(2,4)) > 0 ) {
												int tmpYY = Integer.parseInt(endYYMM.substring(0, 2));
												tmpYY = (tmpYY - 1) % 100;
												String tmpYYStr = (tmpYY < 10) ? "0"+Integer.toString(tmpYY) : Integer.toString(tmpYY);
												startYYMM = tmpYYStr.substring(0, 2) + startMM;
											}
											else {
												startYYMM = endYYMM.substring(0, 2) + startMM;
											}
										}
										


										if ( "3172508".equals(txt_jiro) ) {  //전자신문(000000) 공덕지국 => 마포지국(511009)
											txt_jcode = "511009";
											if(!boreadno.trim().equals("")){
												boreadno = Integer.toString(Integer.parseInt(boreadno) + 50000);
											}
											dbparam = new HashMap();
											dbparam.put("BOSEQ", txt_jcode);
											dbparam.put("BOREADNO", boreadno);
											dbparam.put("GNO", gno);
											newscd = (String) generalDAO.getSqlMapClient().queryForObject("collection.edi.getNewsCode", dbparam);
											txt_rcode = txt_jcode + gno.substring(1) + boreadno + txtline.substring(64, 65);
											
										}else if ( "3162851".equals(txt_jiro) ) {  // 국민일보 가락석촌지국 => 신송파(511017)
											txt_jcode = "511017";
											if(!boreadno.trim().equals("")){
												boreadno = Integer.toString(Integer.parseInt(boreadno) + 50000);
											}
											dbparam = new HashMap();
											dbparam.put("BOSEQ", txt_jcode);
											dbparam.put("BOREADNO", boreadno);
											dbparam.put("GNO", gno);
											newscd = (String) generalDAO.getSqlMapClient().queryForObject("collection.edi.getNewsCode", dbparam);
											txt_rcode = txt_jcode + gno.substring(1) + boreadno + txtline.substring(64, 65);
											
										}else if ( "3020634".equals(txt_jiro) ) {  // 세계일보(010010) 영등포지국 => 영등포지국(511019)
											txt_jcode = "511019";
											if(!boreadno.trim().equals("")){
												boreadno = Integer.toString(Integer.parseInt(boreadno) + 50000);
											}
											dbparam = new HashMap();
											dbparam.put("BOSEQ", txt_jcode);
											dbparam.put("BOREADNO", boreadno);
											dbparam.put("GNO", gno);
											newscd = (String) generalDAO.getSqlMapClient().queryForObject("collection.edi.getNewsCode", dbparam);
											txt_rcode = txt_jcode + gno.substring(1) + boreadno + txtline.substring(64, 65);
											
										}else if ( "3033647".equals(txt_jiro) ) {  // 세계일보 왕십리지국
											txt_jcode = "511020";
											
											if(!boreadno.trim().equals("")){											
												boreadno = Integer.toString(Integer.parseInt(boreadno) + 50000);
											}
											dbparam = new HashMap();
											dbparam.put("BOSEQ", txt_jcode);
											dbparam.put("BOREADNO", boreadno);
											dbparam.put("GNO", gno);
											newscd = (String) generalDAO.getSqlMapClient().queryForObject("collection.edi.getNewsCode", dbparam);
											txt_rcode = txt_jcode + gno.substring(1) + boreadno + txtline.substring(64, 65);
											
										}else if ( "3163643".equals(txt_jiro) ) {  // 서울신문(511002), 스포츠서울(511002), 전자신문(511005) 세종 => 서소문지국(511002)
											if("511002".equals(txt_jcode)){
												if(!boreadno.trim().equals("")){
													boreadno = Integer.toString(Integer.parseInt(boreadno) + 60000);
												}
											}else{
												txt_jcode = "511002";
											}
											
											dbparam = new HashMap();
											dbparam.put("BOSEQ", txt_jcode);
											dbparam.put("BOREADNO", boreadno);
											dbparam.put("GNO", gno);
											newscd = (String) generalDAO.getSqlMapClient().queryForObject("collection.edi.getNewsCode", dbparam);
											txt_rcode = txt_jcode + gno.substring(1) + boreadno + txtline.substring(64, 65);
											
										}else if ( "3168279".equals(txt_jiro) ) {  // 국민일보 왕십리지국
											txt_jcode = "511020";
											if(!boreadno.trim().equals("")){
												boreadno = Integer.toString(Integer.parseInt(boreadno) + 50000);
											}
											dbparam = new HashMap();
											dbparam.put("BOSEQ", txt_jcode);
											dbparam.put("BOREADNO", boreadno);
											dbparam.put("GNO", gno);
											newscd = (String) generalDAO.getSqlMapClient().queryForObject("collection.edi.getNewsCode", dbparam);
											txt_rcode = txt_jcode + gno.substring(1) + boreadno + txtline.substring(64, 65);
											
										}else if ( "3162327".equals(txt_jiro) ) {  // 매일경제 청담지국
											txt_jcode = "512015";
											if(!boreadno.trim().equals("")){
												boreadno = Integer.toString(Integer.parseInt(boreadno) + 50000);
											}
											dbparam = new HashMap();
											dbparam.put("BOSEQ", txt_jcode);
											dbparam.put("BOREADNO", boreadno);
											dbparam.put("GNO", gno);
											newscd = (String) generalDAO.getSqlMapClient().queryForObject("collection.edi.getNewsCode", dbparam);
											txt_rcode = txt_jcode + gno.substring(1) + boreadno + txtline.substring(64, 65);
											
										}else if ( "3173099".equals(txt_jiro) ) {  //  가락지국
											txt_jcode = "512039";
											if(!boreadno.trim().equals("")){
												boreadno = Integer.toString(Integer.parseInt(boreadno) + 50000);
											}
											dbparam = new HashMap();
											dbparam.put("BOSEQ", txt_jcode);
											dbparam.put("BOREADNO", boreadno);
											dbparam.put("GNO", gno);
											newscd = (String) generalDAO.getSqlMapClient().queryForObject("collection.edi.getNewsCode", dbparam);
											txt_rcode = txt_jcode + gno.substring(1) + boreadno + txtline.substring(64, 65);
											
										}else if ( "3172249".equals(txt_jiro) ) {  //  서여의지국(511011) 경향신문 등
											txt_jcode = "511011";
											if(!boreadno.trim().equals("")){
												boreadno = Integer.toString(Integer.parseInt(boreadno) + 50000);
											}
											dbparam = new HashMap();
											dbparam.put("BOSEQ", txt_jcode);
											dbparam.put("BOREADNO", boreadno);
											dbparam.put("GNO", gno);
											newscd = (String) generalDAO.getSqlMapClient().queryForObject("collection.edi.getNewsCode", dbparam);
											txt_rcode = txt_jcode + gno.substring(1) + boreadno + txtline.substring(64, 65);
											
										}else if ( "3158742".equals(txt_jiro) ) {  //  서여의지국(311011) 문화일보
											txt_jcode = "311011";
											
											dbparam = new HashMap();
											dbparam.put("BOSEQ", txt_jcode);
											dbparam.put("BOREADNO", boreadno);
											dbparam.put("GNO", gno);
											newscd = (String) generalDAO.getSqlMapClient().queryForObject("collection.edi.getNewsCode", dbparam);
											txt_rcode = txt_jcode + gno.substring(1) + boreadno + txtline.substring(64, 65);
											
										}		
										
										
										// 지국 코드를 가져온다.
										dbparam = new HashMap();
										dbparam.put("SERIAL", txt_jcode);
										dbparam.put("E_JIRO", txt_jiro);

										// excute query
										int agencyCnt = (Integer) generalDAO.getSqlMapClient().queryForObject("collection.edi.getAgencyJiro", dbparam);
										logger.debug("===== collection.edi.getAgencyJiro");
										
										if ( agencyCnt > 0 ) {
											errstr = "0";
										} else {
											errstr = "1";
										}
										
										// 입금처리하기 위한 데이터가 없다면 에러처리
										if ( StringUtils.isEmpty(newscd) || StringUtils.isEmpty(txt_jcode) || StringUtils.isEmpty(gno) || StringUtils.isEmpty(boreadno) ) {
											errstr = "1";
										}
										
										
									}
									

									if ( StringUtils.isEmpty(startYYMM) || StringUtils.isEmpty(endYYMM) 
											|| startYYMM.length() != 4 || endYYMM.length() != 4 ) {
										errstr = "1";
									}
									
									
									String txt_all = txtline;

									
									// 수납구분이 Reject 이거나 장표처리구분이 Reject 이면 오류
									if ( "R".equals(txt_sgubun) || "R".equals(txt_jgubun)) {
										errstr = "1";
									}
									
									
									// GR15 data 등록
									dbparam = new HashMap();
									dbparam.put("E_NUMBER", txt_num);
									dbparam.put("E_SDATE", txt_sdate);
									dbparam.put("E_EDATE", txt_edate);
									dbparam.put("E_SCODE", txt_scode);
									dbparam.put("E_INFO", txt_empty1);
									dbparam.put("E_INDEXINFO", txt_empty2);
									dbparam.put("E_CHECK", txt_gnum);
									dbparam.put("E_SGUBUN", txt_sgubun);
									dbparam.put("E_MONEY", txt_money);
									dbparam.put("E_CHARGE", txt_gmoney);
									dbparam.put("E_JCODE", txt_jcode);
									// txt_wdate
									dbparam.put("E_RCODE", txt_rcode);
									dbparam.put("E_ERROR", errstr);
									dbparam.put("E_JGUBUN", txt_jgubun);
									dbparam.put("E_ALL", txt_all);
									dbparam.put("E_JIRO", txt_jiro);
	
									// excute query
									int e_numid = (Integer) generalDAO.getSqlMapClient().insert("collection.edi.insertEdiGR15", dbparam);
									logger.debug("===== collection.edi.insertEdiGR15");
									
									int nTxtMoney = Integer.parseInt(txt_money);			// 지로로 받은 금액
									
									// 에러가 아니면 입금처리
									if ( errstr == "0") {
										
										List newsList = null;
										List sugmList = null;
										
										String nextYYYYMMDD = "";
										String nextYYMM = startYYMM;
										
										int remainMoney = nTxtMoney;			// 수금처리 후 남은 금액
										
										while ( nextYYMM.compareTo(endYYMM) <= 0 ) {
											
											// 마지막 월마감 수금년월이 구독년월보다 크거나 같다면 미수입금처리
											if ( lastYYMM.compareTo(nextYYMM) >= 0 ) {
												
												dbparam = new HashMap();
												dbparam.put("NEWSCD", newscd);									// 신문코드
												dbparam.put("SGBBCD", CODE_SUGM_GUBUN_NOT_COMPLETE);			// 수금방법 - 미수
												//dbparam.put("SGGBCD_NOT", "'021','023','024','033','099'");			// 수금구분 - 자동이체 제외(본사입금,쿠폰,휴독,월삭제 제외 추가)
												dbparam.put("BOSEQ", txt_jcode);								// 지국코드
												dbparam.put("SDATE", nowYearStr.substring(0, 2) + nextYYMM);	// 구독년월, 시작년월
												dbparam.put("EDATE", nowYearStr.substring(0, 2) + nextYYMM);	// 구독년월, 종료년월
												
												if ( txt_type.equals(CODE_EDI_NEW_READER_GUBUN)|| txt_type.equals(CODE_EDI_NEW_READER_GUBUN_OTHERS) ) {	// 신 고객조회번호: newscd, txt_jcode, readno 로 처리
													dbparam.put("READNO", readno);								// 독자번호(9자리)
												}
												else {												// 구 고객조회번호: newscd, txt_jcode, gno, boreadno 로 처리
													dbparam.put("GNO", gno);									// 구역번호
													dbparam.put("BOREADNO", boreadno);							// 지국독자번호
												}
												
												// 미수 목록 조회
												sugmList = generalDAO.getSqlMapClient().queryForList("collection.edi.getSugmList", dbparam);
												logger.debug("===== collection.edi.getSugmList");
												
												if ( sugmList != null ) {
													
													for ( int i = 0; i < sugmList.size(); i++ ) {
														Map sugmMap = (Map) sugmList.get(i);
														String read_no = (String)sugmMap.get("READNO");				// 독자번호
														BigDecimal billAmt = (BigDecimal)sugmMap.get("BILLAMT");	// 청구금액
														String seq = (String)sugmMap.get("SEQ");					// 시퀀스	
														
														int nBillAmt = Integer.parseInt(billAmt.toString());		// 청구금액 int형으로 변환
														if ( remainMoney > 0 ) {	// 입금 처리 
															
															// 수금테이블 update
															dbparam = new HashMap();
															dbparam.put("READNO", read_no);									// 독자번호
															dbparam.put("NEWSCD", newscd);									// 신문코드
															dbparam.put("YYMM", nowYearStr.substring(0, 2) + nextYYMM);		// 구독년월
															dbparam.put("SEQ", seq);										// 시퀀스
															dbparam.put("SGBBCD", CODE_SUGM_GUBUN_NOT_COMPLETE);			// 수금방법 - 미수
															//dbparam.put("SGGBCD_NOT", "'021','023','024','033','099'");			// 수금구분 - 자동이체 제외(본사입금,쿠폰,휴독,월삭제 제외 추가)
															dbparam.put("BOSEQ", txt_jcode);								// 지국코드
															if ( remainMoney < nBillAmt ) {
																dbparam.put("AMT", remainMoney);							// 수금금액
																dbparam.put("LOSSAMT", nBillAmt - remainMoney);				// 결손금액
															}
															else {
																dbparam.put("AMT", nBillAmt);								// 수금금액
															}
															dbparam.put("SGBBCD_NEW", CODE_SUGM_TYPE_GIRO);					// 수금방법 - 지로
															dbparam.put("SGYYMM", last_yymm);								// 수금년월
															dbparam.put("EDIPROCNO", e_numid);								// EDI처리번호
															dbparam.put("SNDT", txt_sdate);									// 수납일자
															dbparam.put("ICDT", txt_edate);									// 이체일자
															dbparam.put("CLDT", txt_edate);									// 처리일자
															dbparam.put("CHGPS", txt_jcode);								// 수정자 ID
															
															generalDAO.getSqlMapClient().update("collection.edi.updateSugm", dbparam);
															logger.debug("===== collection.edi.updateSugm 1 : " + read_no + ", " + seq + ", " + nextYYMM);
															
															if ( remainMoney > nBillAmt ) {
																remainMoney -= nBillAmt;
															}
															else {
																remainMoney = 0;
															}
														}
														else {	// 결손처리
															// 수금테이블 update
															dbparam = new HashMap();
															dbparam.put("READNO", read_no);									// 독자번호
															dbparam.put("NEWSCD", newscd);									// 신문코드
															dbparam.put("YYMM", nowYearStr.substring(0, 2) + nextYYMM);		// 구독년월
															dbparam.put("SEQ", seq);										// 시퀀스
															dbparam.put("SGBBCD", CODE_SUGM_GUBUN_NOT_COMPLETE);			// 수금방법 - 미수
															//dbparam.put("SGGBCD_NOT", "'021','023','024','033','099'");			// 수금구분 - 자동이체 제외(본사입금,쿠폰,휴독,월삭제 제외 추가)
															dbparam.put("BOSEQ", txt_jcode);								// 지국코드
															dbparam.put("AMT", 0);											// 수금금액
															dbparam.put("LOSSAMT", nBillAmt);								// 결손금액
															dbparam.put("SGBBCD_NEW", CODE_SUGM_TYPE_GIRO);					// 수금방법 - 지로
															dbparam.put("SGYYMM", last_yymm);								// 수금년월
															dbparam.put("EDIPROCNO", e_numid);								// EDI처리번호
															dbparam.put("SNDT", txt_sdate);									// 수납일자
															dbparam.put("ICDT", txt_edate);									// 이체일자
															dbparam.put("CLDT", txt_edate);									// 처리일자
															dbparam.put("CHGPS", txt_jcode);								// 수정자 ID
															
															generalDAO.getSqlMapClient().update("collection.edi.updateSugm", dbparam);
															logger.debug("===== collection.edi.updateSugm 2 : " + read_no + ", " + seq + ", " + nextYYMM);
														}
													}
												}
											}
											else {	// 마지막 월마감 수금년월이 구독년월보다 작다면 선입금처리

												dbparam = new HashMap();
												dbparam.put("NEWSCD", newscd);									// 신문코드
												dbparam.put("BOSEQ", txt_jcode);								// 지국코드
												dbparam.put("YYMM", nowYearStr.substring(0, 2) + nextYYMM);		// 수금시작월 비교
												
												if ( txt_type.equals(CODE_EDI_NEW_READER_GUBUN) || txt_type.equals(CODE_EDI_NEW_READER_GUBUN_OTHERS) ) {	// 신 고객조회번호: newscd, txt_jcode, readno 로 처리
													dbparam.put("READNO", readno);								// 독자번호(9자리)
												}
												else {												// 구 고객조회번호: newscd, txt_jcode, gno, boreadno 로 처리
													dbparam.put("GNO", gno);									// 구역번호
													dbparam.put("BOREADNO", boreadno);							// 지국독자번호
												}
												
												newsList = generalDAO.getSqlMapClient().queryForList("collection.edi.getNewsList", dbparam);
												logger.debug("===== collection.edi.getNewsList");
												
												if ( newsList != null ) {

													for ( int i = 0; i < newsList.size(); i++ ) {
														Map newsMap = (Map) newsList.get(i);
														String read_no = (String)newsMap.get("READNO");				// 독자번호
														String seq = (String)newsMap.get("SEQ");					// 시퀀스
														BigDecimal qty = (BigDecimal)newsMap.get("QTY");			// 구독부수
														BigDecimal uprice = (BigDecimal)newsMap.get("UPRICE");		// 구독금액
														
														int nUprice = Integer.parseInt(uprice.toString());		// 구독금액 int형으로 변환
														
														dbparam = new HashMap();
														dbparam.put("READNO", read_no);					// 독자번호
														dbparam.put("NEWSCD", newscd);					// 신문코드
														dbparam.put("YYMM", nowYearStr.substring(0, 2)+nextYYMM);// 구독년월(월분)
														dbparam.put("SEQ", seq);						// 일련번호
														
														Map sugmMap = (Map) generalDAO.getSqlMapClient().queryForObject("collection.edi.getSugmMap", dbparam);
														logger.debug("===== collection.edi.getSugmMap");
														
														if ( sugmMap == null ) { 	// 있는지 검사후 없으면
															if ( remainMoney > 0 ) {	// 입금 처리 
																dbparam = new HashMap();
																dbparam.put("READNO", read_no);					// 독자번호
																dbparam.put("NEWSCD", newscd);					// 신문코드
																dbparam.put("YYMM", nowYearStr.substring(0, 2)+nextYYMM);// 구독년월(월분)
																dbparam.put("SEQ", seq);						// 일련번호
																dbparam.put("BOSEQ", txt_jcode);				// 지국코드
																dbparam.put("SGBBCD", CODE_SUGM_TYPE_GIRO);		// 수금방법 - 지로
																dbparam.put("SGGBCD", CODE_SUGM_TYPE_GIRO);		// 수금구분 - 지로
																dbparam.put("BILLAMT", nUprice);				// 청구금액
																dbparam.put("BILLQTY", qty);					// 청구부수
																dbparam.put("SGYYMM", last_yymm);				// 수금년월(월분)
																if ( remainMoney < nUprice ) {
																	dbparam.put("AMT", remainMoney);				// 수금금액
																	dbparam.put("LOSSAMT", nUprice - remainMoney);	// 결손금액
																}
																else {
																	dbparam.put("AMT", nUprice);					// 수금금액
																}
																dbparam.put("EDIPROCNO", e_numid);				// EDI처리번호
																dbparam.put("SNDT", txt_sdate);					// 수납일자
																dbparam.put("ICDT", txt_edate);					// 이체일자
																dbparam.put("CLDT", txt_edate);					// 처리일자
																dbparam.put("INPS", txt_jcode);					// 등록자 ID
																dbparam.put("CHGPS", txt_jcode);				// 수정자 ID
																
																generalDAO.getSqlMapClient().insert("collection.edi.insertPreSugm", dbparam);
																logger.debug("===== collection.edi.insertPreSugm 1 : " + read_no + ", " + seq + ", " + nextYYMM);
																
																if ( remainMoney > nUprice ) {
																	remainMoney -= nUprice;
																}
																else {
																	remainMoney = 0;
																}
															}
															else {	// 결손처리
																dbparam = new HashMap();
																dbparam.put("READNO", read_no);					// 독자번호
																dbparam.put("NEWSCD", newscd);					// 신문코드
																dbparam.put("YYMM", nowYearStr.substring(0, 2)+nextYYMM);// 구독년월(월분)
																dbparam.put("SEQ", seq);						// 일련번호
																dbparam.put("BOSEQ", txt_jcode);				// 지국코드
																dbparam.put("SGBBCD", CODE_SUGM_TYPE_GIRO);		// 수금방법 - 지로
																dbparam.put("SGGBCD", CODE_SUGM_TYPE_GIRO);		// 수금구분 - 지로
																dbparam.put("BILLAMT", nUprice);				// 청구금액
																dbparam.put("BILLQTY", qty);					// 청구부수
																dbparam.put("SGYYMM", last_yymm);				// 수금년월(월분)
																dbparam.put("AMT", 0);							// 수금금액
																dbparam.put("LOSSAMT", nUprice);				// 결손금액
																dbparam.put("EDIPROCNO", e_numid);				// EDI처리번호
																dbparam.put("SNDT", txt_sdate);					// 수납일자
																dbparam.put("ICDT", txt_edate);					// 이체일자
																dbparam.put("CLDT", txt_edate);					// 처리일자
																dbparam.put("INPS", txt_jcode);					// 등록자 ID
																dbparam.put("CHGPS", txt_jcode);				// 수정자 ID
																
																generalDAO.getSqlMapClient().insert("collection.edi.insertPreSugm", dbparam);
																logger.debug("===== collection.edi.insertPreSugm 2 : " + read_no + ", " + seq + ", " + nextYYMM);
															}
														}
														else {
															String sgbbcd = (String) sugmMap.get("SGBBCD");
															
															// 미수로 수금에 들어있다면 입금처리
															if ( sgbbcd.equals(CODE_SUGM_GUBUN_NOT_COMPLETE) ) {
																
																BigDecimal billAmt = (BigDecimal)sugmMap.get("BILLAMT");	// 청구금액
																
																int nBillAmt = Integer.parseInt(billAmt.toString());		// 청구금액 int형으로 변환
																if ( remainMoney > 0 ) {	// 입금 처리 
																	
																	// 수금테이블 update
																	dbparam = new HashMap();
																	dbparam.put("READNO", read_no);									// 독자번호
																	dbparam.put("NEWSCD", newscd);									// 신문코드
																	dbparam.put("YYMM", nowYearStr.substring(0, 2) + nextYYMM);		// 구독년월
																	dbparam.put("SEQ", seq);										// 시퀀스
																	dbparam.put("SGBBCD", CODE_SUGM_GUBUN_NOT_COMPLETE);			// 수금방법 - 미수
																	//dbparam.put("SGGBCD_NOT", "'021','023','024','033','099'");			// 수금구분 - 자동이체 제외(본사입금,쿠폰,휴독,월삭제 제외 추가)
																	dbparam.put("BOSEQ", txt_jcode);								// 지국코드
																	if ( remainMoney < nBillAmt ) {
																		dbparam.put("AMT", remainMoney);							// 수금금액
																		dbparam.put("LOSSAMT", nBillAmt - remainMoney);				// 결손금액
																	}
																	else {
																		dbparam.put("AMT", nBillAmt);								// 수금금액
																	}
																	dbparam.put("SGBBCD_NEW", CODE_SUGM_TYPE_GIRO);					// 수금방법 - 지로
																	dbparam.put("SGYYMM", last_yymm);								// 수금년월
																	dbparam.put("EDIPROCNO", e_numid);								// EDI처리번호
																	dbparam.put("SNDT", txt_sdate);									// 수납일자
																	dbparam.put("ICDT", txt_edate);									// 이체일자
																	dbparam.put("CLDT", txt_edate);									// 처리일자
																	dbparam.put("CHGPS", txt_jcode);								// 수정자 ID
																	
																	generalDAO.getSqlMapClient().update("collection.edi.updateSugm", dbparam);
																	logger.debug("===== collection.edi.updateSugm 3 : " + read_no + ", " + seq + ", " + nextYYMM);
																	
																	if ( remainMoney > nBillAmt ) {
																		remainMoney -= nBillAmt;
																	}
																	else {
																		remainMoney = 0;
																	}
																}
																else {	// 결손처리
																	// 수금테이블 update
																	dbparam = new HashMap();
																	dbparam.put("READNO", read_no);									// 독자번호
																	dbparam.put("NEWSCD", newscd);									// 신문코드
																	dbparam.put("YYMM", nowYearStr.substring(0, 2) + nextYYMM);		// 구독년월
																	dbparam.put("SEQ", seq);										// 시퀀스
																	dbparam.put("SGBBCD", CODE_SUGM_GUBUN_NOT_COMPLETE);			// 수금방법 - 미수
																	//dbparam.put("SGGBCD_NOT", "'021','023','024','033','099'");			// 수금구분 - 자동이체 제외(본사입금,쿠폰,휴독,월삭제 제외 추가)
																	dbparam.put("BOSEQ", txt_jcode);								// 지국코드
																	dbparam.put("AMT", 0);											// 수금금액
																	dbparam.put("LOSSAMT", nBillAmt);								// 결손금액
																	dbparam.put("SGBBCD_NEW", CODE_SUGM_TYPE_GIRO);					// 수금방법 - 지로
																	dbparam.put("SGYYMM", last_yymm);								// 수금년월
																	dbparam.put("EDIPROCNO", e_numid);								// EDI처리번호
																	dbparam.put("SNDT", txt_sdate);									// 수납일자
																	dbparam.put("ICDT", txt_edate);									// 이체일자
																	dbparam.put("CLDT", txt_edate);									// 처리일자
																	dbparam.put("CHGPS", txt_jcode);								// 수정자 ID
																	
																	generalDAO.getSqlMapClient().update("collection.edi.updateSugm", dbparam);
																	logger.debug("===== collection.edi.updateSugm 4 : " + read_no + ", " + seq + ", " + nextYYMM);
																}
															}
														}
													}
												}
											}
											
											// 한달씩 넘기면서 구독년월을 구한다.
											nextYYYYMMDD = DateUtil.getWantDay(nowYearStr.substring(0, 2)+ nextYYMM + "01", 2, 1);
											nextYYMM = nextYYYYMMDD.substring(2, 6);
										}
										
										// 과입금 처리
										if ( remainMoney > 0 ) {
											dbparam = new HashMap();
											dbparam.put("EDINUMID", e_numid);						// edi 테이블에 저장된 pk
											dbparam.put("OVERMONEY", remainMoney);					// 과입금액
											generalDAO.getSqlMapClient().insert("collection.edi.insertEdiOver", dbparam);
											logger.debug("===== collection.edi.insertEdiOver");
										}
									}
									else {
										sngError++;
									}
								}
							}
						}
						
						// file_t 테이블에 insert
						dbparam = new HashMap();
						dbparam.put("FILENAME", edifile.getOriginalFilename());
						dbparam.put("TYPE", "AGENCY");
						
						generalDAO.getSqlMapClient().insert("collection.edi.insertFile_t", dbparam);
						logger.debug("===== collection.edi.insertFile_t");
						
						msg = "정상적으로 처리되었습니다.";
						// transaction commit
						generalDAO.getSqlMapClient().getCurrentConnection().commit();
					}
					catch (Exception e) {
						// transaction rollback
						generalDAO.getSqlMapClient().getCurrentConnection().rollback();
						
						System.out.println("txtline:"+txtline ) ;
						e.printStackTrace();
						msg = "정상적으로 처리되지 않았습니다.";
					}
					finally {
						fis.close();
						
						// transaction end
						generalDAO.getSqlMapClient().endTransaction();
					}
					
					mav.setViewName("collection/edi/gr15process");
					mav.addObject("now_menu", ICodeConstant.MENU_CODE_COLLECTION_EDI);
					
					mav.addObject("msg", msg);
					mav.addObject("sngError", sngError);
					mav.addObject("rec_count", rec_count);
					
					return mav;
				}				
			}
		}
	}
	

	/**
	 * 더존 바코드 수납명세서(MR15) 파일 처리
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView mr15Process(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		MultipartHttpServletParam param = new MultipartHttpServletParam(request);
		MultipartFile edifile = param.getMultipartFile("edifile");
		
		HashMap dbparam = new HashMap();
		
		// mav
		ModelAndView mav = new ModelAndView();
		
		
		if ( edifile.isEmpty()) {	// 파일 첨부가 안되었으면 
			mav.setViewName("common/message");
			mav.addObject("message", "파일첨부가 되지 않았습니다.");
			mav.addObject("returnURL", "/collection/edi/gr15attach.do");
			return mav;
		}
		else {	// 파일 첨부가 되었으면
			
			int sngError = 0;
			int rec_count = 0;
			
			dbparam = new HashMap();
			dbparam.put("FILENAME", edifile.getOriginalFilename());
			dbparam.put("TYPE", "DUZON");

			// excute query
			Map fileMap = (Map) generalDAO.queryForObject("collection.edi.getUploadFileInfo", dbparam);
			logger.debug("===== collection.edi.getUploadFileInfo");
			
			// 이미 같은 이름으로된 파일이 업로드 되었다면 실패
			if ( fileMap != null ) {
				mav.setViewName("common/message");
				mav.addObject("message", "이미 파일이 있습니다.");
				mav.addObject("returnURL", "/collection/edi/gr15attach.do");
				return mav;
				
			}else {
				
				FileUtil fileUtil = new FileUtil( getServletContext() );
				String strFile = fileUtil.saveUploadFile(
												edifile, 
												PATH_PHYSICAL_HOME,
												PATH_UPLOAD_ABSOLUTE_EDI_MR15
											);
				
				if ( StringUtils.isEmpty(strFile) ) {
					mav.setViewName("common/message");
					mav.addObject("message", "파일 저장이 실패하였습니다. ");
					mav.addObject("returnURL", "/collection/edi/gr15attach.do");
					return mav;
				}
				else if ( strFile.length() != 10 ) {	// MR15YYMMDD 
					mav.setViewName("common/message");
					mav.addObject("message", "파일명이 잘못되었습니다.");
					mav.addObject("returnURL", "/collection/edi/gr15attach.do");
					return mav;
				}
				else {
					
					String msg = "";
					
					int LINE_NUM = 190;
					
					String fileName = PATH_UPLOAD_RELATIVE_EDI_MR15 + "/" + strFile;
					
					File f = new File(fileName);
					FileInputStream fis = new FileInputStream(f);
					String txtline = "";
					
					try {
						
						// transaction start
						generalDAO.getSqlMapClient().startTransaction();					
						generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
						
						int count;
						byte[] b = new byte[LINE_NUM];
						
						String txt_jiro = "";
						String txt_gunsoo = "";
						
						// 마지막 수금년월을 가져옴. 
						String last_yymm = (String) generalDAO.getSqlMapClient().queryForObject("common.getLastSGYYMM");
						String lastYYMM = last_yymm.substring(2,6);
						
						String txt_code = "";
						txtline = "";
						String errstr = "";		// 0 : 정상, others : 에러
						
						String txt_num = "";
						String txt_sdate = "";
						String txt_edate = "";
						String txt_scode = "";
						String txt_empty1 = "";
						String txt_empty2 = "";
						String txt_gnum = "";
						String txt_money = "";
						String txt_sgubun = "";
						String txt_gmoney = "";
						String txt_jgubun = "";

						String txt_jcode = "";
						String newscd = "";
						String readno = "";
						String gno = "";
						String boreadno = "";
						
						String startYYMM = "";
						String endYYMM = "";
															
						String txt_type = "";
						
						Calendar cal = Calendar.getInstance();
						int nowYear =  cal.get(Calendar.YEAR);
						String nowYearStr = Integer.toString(nowYear);
						
						while ((count = fis.read(b)) != -1) {
							
							txtline = new String(b);
							
							if ( txtline.length() != 0 ) {
								
								txt_code = txtline.substring(0, 2);			    // (2) Data 구분코드
								
								if ( txt_code.equals(CODE_EDI_LAYOUT_HEADER) ) {			// 헤더면
									txt_jiro = txtline.substring(9, 16);			// (7) 빌러(지로)번호
									txt_sdate = txtline.substring(16, 24);		// (8) 수납일자 (YYYYMMDD)
									txt_edate = txtline.substring(24, 32);		// (8) 이체일자 (YYYYMMDD)
									
									if ( !txt_jiro.equals(MK_JIRO_NUMBER)) {		// 매일경제 빌러번호(3146440)에 해당되는 파일인지 체크
										mav.setViewName("common/message");
										mav.addObject("message", "매일경제 빌러번호(3146440)와 일치하지 않습니다.");
										mav.addObject("returnURL", "/collection/edi/gr15attach.do");
										return mav;
									}
								}
								else if ( txt_code.equals(CODE_EDI_LAYOUT_TRAILER) ) {
									txt_gunsoo = txtline.substring(9, 16);			// (7) Record의 총 건수
								}
								else if ( txt_code.equals(CODE_EDI_LAYOUT_DATA) ) {		// 데이터면
									
									rec_count++;

									errstr = "0";		// 0 : 정상, others : 에러

									txt_num = txtline.substring(2, 9);			// (7) 일련번호
									txt_gnum = txtline.substring(9, 29);		    // (20)고객조회번호(Check Digit 1자리 포함)
																	
									txt_money = cropByteChar(txtline,96,109);  	// (13)금액(고객납부금액)
																		
									txt_empty1 = cropByteChar(txtline,112, 114)+ cropByteChar(txtline,110, 112);		// (5) 정보 작성점 => 수납처코드(보광훼미리마트 98/ 지에스리테일 91 / 바이더웨이: 92 / 세븐일레븐: 94 / 미니스톱: 93/ 청호컴넷 : 51 / 우리은행: 20 /신한은행 :88/ 삼성카드: 04 / 롯데카드 : 31 / 현대카드: 32 / 외환카드 /03) + 결재기관(계좌이체, 카드, 은행사코드, 현금일경우 공란) 
									txt_scode = cropByteChar(txtline,114, 120).trim();	// (6) 수납점 코드(은행코드(2) + 점포코드(4))
									txt_gmoney =  cropByteChar(txtline,120, 127);	// (7) 수수료
																
									txt_empty2 = "DUZON";							// 색인구분(DUZON)
									
									txt_sgubun = cropByteChar(txtline,109, 110);	    // (1)수납방법(1: 현금, 2: 계좌이체, 3: 카드 ETC)
									txt_jgubun =  cropByteChar(txtline,95, 96).replace("1","");	    // (1)거래구분(1: 정상, 0: 환불)
									txt_jiro =  cropByteChar(txtline,173, 180);	        // (7) 지로번호

									txt_jcode = "";
									newscd = "";
									readno = "";
									
									startYYMM = "";
									endYYMM = "";
									
									txt_type = txtline.substring(9, 11);		// (2) 고객조회번호에 들어있는 신구 구분코드
									if ( txt_type.equals(CODE_EDI_NEW_READER_GUBUN) || txt_type.equals(CODE_EDI_NEW_READER_GUBUN_OTHERS) ) {
										
										// 신 고객조회번호 (구분(2) + 매체번호(2) + 독자번호(9) + 시작년월(4) + 개월분(2) + check(1))											
										newscd = "1" + txtline.substring(11, 13);		// (2) 매체번호 (원래 매체번호는 3자리이나 여기선 첫번째 1이 빠진 나머지 2자리만 넘어옴)
										readno = txtline.substring(13, 22);				// (9) 독자번호
										startYYMM = txtline.substring(22, 26);			// (4) 시작년월
										String plusMonths = txtline.substring(26, 28);	// (2) 개월분
										
										endYYMM = getEndYYMM(startYYMM, plusMonths);	// 종료년월을 구한다.
										
										// (6) 지국코드. 독자번호로 news 테이블에서 가져와야함.
										dbparam = new HashMap();
										dbparam.put("NEWSCD", newscd);
										dbparam.put("READNO", readno);
										
										txt_jcode = (String ) generalDAO.getSqlMapClient().queryForObject("collection.edi.getAgencyCodeFromReadno", dbparam);
										logger.debug("===== collection.edi.getAgencyCodeFromReadno");
										
										// 입금처리하기 위한 데이터가 없다면 에러처리
										if ( StringUtils.isEmpty(newscd) || StringUtils.isEmpty(readno)) {
											errstr = "1";
										}
										// 입금처리하기 위한 지국코드 데이터가 없다면 에러처리, 해당칼럼 not null이므로 임시값 세팅
										if ( StringUtils.isEmpty(txt_jcode)) {
											errstr = "1";
											txt_jcode = "000000";
										}
									}else{
										errstr = "1";
									}
									
									if ( StringUtils.isEmpty(startYYMM) || StringUtils.isEmpty(endYYMM) 
											|| startYYMM.length() != 4 || endYYMM.length() != 4 ) {
										errstr = "1";
									}
									
									String txt_rcode =txtline.substring(9, 23);	
									String txt_all = txtline;

									
									// 수납구분이 Reject 이거나 장표처리구분이 Reject 이면 오류
									if ( "R".equals(txt_sgubun) || "R".equals(txt_jgubun) || "0".equals(txt_jgubun)) {
										errstr = "1";
									}				
									
									// GR15 data 등록
									dbparam = new HashMap();
									dbparam.put("E_NUMBER", txt_num);
									dbparam.put("E_SDATE", txt_sdate);
									dbparam.put("E_EDATE", txt_edate);
									dbparam.put("E_SCODE", txt_scode);
									dbparam.put("E_INFO", txt_empty1);
									dbparam.put("E_INDEXINFO", txt_empty2);
									dbparam.put("E_CHECK", txt_gnum);
									dbparam.put("E_SGUBUN", txt_sgubun);
									dbparam.put("E_MONEY", txt_money);
									dbparam.put("E_CHARGE", txt_gmoney);
									dbparam.put("E_JCODE", txt_jcode);
									// txt_wdate
									dbparam.put("E_RCODE", txt_rcode);
									dbparam.put("E_ERROR", errstr);
									dbparam.put("E_JGUBUN", txt_jgubun);
									dbparam.put("E_ALL", txt_all);
									dbparam.put("E_JIRO", txt_jiro);
	
									// excute query
									int e_numid = (Integer) generalDAO.getSqlMapClient().insert("collection.edi.insertEdiGR15", dbparam);
									logger.debug("===== collection.edi.insertEdiGR15");
									
									int nTxtMoney = Integer.parseInt(txt_money);			// 지로로 받은 금액
									
									// 에러가 아니면 입금처리
									if ( errstr == "0") {
										
										List newsList = null;
										List sugmList = null;
										
										String nextYYYYMMDD = "";
										String nextYYMM = startYYMM;
										
										int remainMoney = nTxtMoney;			// 수금처리 후 남은 금액
										
										while ( nextYYMM.compareTo(endYYMM) <= 0 ) {
											
											// 마지막 월마감 수금년월이 구독년월보다 크거나 같다면 미수입금처리
											if ( lastYYMM.compareTo(nextYYMM) >= 0 ) {
												
												dbparam = new HashMap();
												dbparam.put("NEWSCD", newscd);									// 신문코드
												dbparam.put("SGBBCD", CODE_SUGM_GUBUN_NOT_COMPLETE);			// 수금방법 - 미수
												//dbparam.put("SGGBCD_NOT", "'021','023','024','033','099'");			// 수금구분 - 자동이체 제외(본사입금,쿠폰,휴독,월삭제 제외 추가)
												dbparam.put("BOSEQ", txt_jcode);								// 지국코드
												dbparam.put("SDATE", nowYearStr.substring(0, 2) + nextYYMM);	// 구독년월, 시작년월
												dbparam.put("EDATE", nowYearStr.substring(0, 2) + nextYYMM);	// 구독년월, 종료년월
												
												dbparam.put("READNO", readno);								// 독자번호(9자리)
												
												// 미수 목록 조회
												sugmList = generalDAO.getSqlMapClient().queryForList("collection.edi.getSugmList", dbparam);
												logger.debug("===== collection.edi.getSugmList");
												
												if ( sugmList != null ) {
													for ( int i = 0; i < sugmList.size(); i++ ) {
														Map sugmMap = (Map) sugmList.get(i);
														String read_no = (String)sugmMap.get("READNO");				// 독자번호
														BigDecimal billAmt = (BigDecimal)sugmMap.get("BILLAMT");	// 청구금액
														String seq = (String)sugmMap.get("SEQ");					// 시퀀스	
														
														int nBillAmt = Integer.parseInt(billAmt.toString());		// 청구금액 int형으로 변환
														if ( remainMoney > 0 ) {	// 입금 처리 
															
															// 수금테이블 update
															dbparam = new HashMap();
															dbparam.put("READNO", read_no);									// 독자번호
															dbparam.put("NEWSCD", newscd);									// 신문코드
															dbparam.put("YYMM", nowYearStr.substring(0, 2) + nextYYMM);		// 구독년월
															dbparam.put("SEQ", seq);										// 시퀀스
															dbparam.put("SGBBCD", CODE_SUGM_GUBUN_NOT_COMPLETE);			// 수금방법 - 미수
															//dbparam.put("SGGBCD_NOT", "'021','023','024','033','099'");			// 수금구분 - 자동이체 제외(본사입금,쿠폰,휴독,월삭제 제외 추가)
															dbparam.put("BOSEQ", txt_jcode);								// 지국코드
															if ( remainMoney < nBillAmt ) {
																dbparam.put("AMT", remainMoney);							// 수금금액
																dbparam.put("LOSSAMT", nBillAmt - remainMoney);				// 결손금액
															}
															else {
																dbparam.put("AMT", nBillAmt);								// 수금금액
															}
															dbparam.put("SGBBCD_NEW", CODE_SUGM_TYPE_GIRO);					// 수금방법 - 지로
															dbparam.put("SGYYMM", last_yymm);								// 수금년월
															dbparam.put("EDIPROCNO", e_numid);								// EDI처리번호
															dbparam.put("SNDT", txt_sdate);									// 수납일자
															dbparam.put("ICDT", txt_edate);									// 이체일자
															dbparam.put("CLDT", txt_edate);									// 처리일자
															dbparam.put("CHGPS", txt_jcode);								// 수정자 ID
															
															generalDAO.getSqlMapClient().update("collection.edi.updateSugm", dbparam);
															logger.debug("===== collection.edi.updateSugm 1 : " + read_no + ", " + seq + ", " + nextYYMM);
															
															if ( remainMoney > nBillAmt ) {
																remainMoney -= nBillAmt;
															}
															else {
																remainMoney = 0;
															}
														}
														else {	// 결손처리
															// 수금테이블 update
															dbparam = new HashMap();
															dbparam.put("READNO", read_no);									// 독자번호
															dbparam.put("NEWSCD", newscd);									// 신문코드
															dbparam.put("YYMM", nowYearStr.substring(0, 2) + nextYYMM);		// 구독년월
															dbparam.put("SEQ", seq);										// 시퀀스
															dbparam.put("SGBBCD", CODE_SUGM_GUBUN_NOT_COMPLETE);			// 수금방법 - 미수
															//dbparam.put("SGGBCD_NOT", "'021','023','024','033','099'");			// 수금구분 - 자동이체 제외(본사입금,쿠폰,휴독,월삭제 제외 추가)
															dbparam.put("BOSEQ", txt_jcode);								// 지국코드
															dbparam.put("AMT", 0);											// 수금금액
															dbparam.put("LOSSAMT", nBillAmt);								// 결손금액
															dbparam.put("SGBBCD_NEW", CODE_SUGM_TYPE_GIRO);					// 수금방법 - 지로
															dbparam.put("SGYYMM", last_yymm);								// 수금년월
															dbparam.put("EDIPROCNO", e_numid);								// EDI처리번호
															dbparam.put("SNDT", txt_sdate);									// 수납일자
															dbparam.put("ICDT", txt_edate);									// 이체일자
															dbparam.put("CLDT", txt_edate);									// 처리일자
															dbparam.put("CHGPS", txt_jcode);								// 수정자 ID
															
															generalDAO.getSqlMapClient().update("collection.edi.updateSugm", dbparam);
															logger.debug("===== collection.edi.updateSugm 2 : " + read_no + ", " + seq + ", " + nextYYMM);
														}
													}
												}
											}
											else {	// 마지막 월마감 수금년월이 구독년월보다 작다면 선입금처리
												
												dbparam = new HashMap();
												dbparam.put("NEWSCD", newscd);									// 신문코드
												dbparam.put("BOSEQ", txt_jcode);								// 지국코드
												dbparam.put("YYMM", nowYearStr.substring(0, 2) + nextYYMM);		// 수금시작월 비교
												
												dbparam.put("READNO", readno);								// 독자번호(9자리)
												
												newsList = generalDAO.getSqlMapClient().queryForList("collection.edi.getNewsList", dbparam);
												logger.debug("===== collection.edi.getNewsList");
												
												if ( newsList != null ) {
													for ( int i = 0; i < newsList.size(); i++ ) {
														Map newsMap = (Map) newsList.get(i);
														String read_no = (String)newsMap.get("READNO");				// 독자번호
														String seq = (String)newsMap.get("SEQ");					// 시퀀스
														BigDecimal qty = (BigDecimal)newsMap.get("QTY");			// 구독부수
														BigDecimal uprice = (BigDecimal)newsMap.get("UPRICE");		// 구독금액
														
														int nUprice = Integer.parseInt(uprice.toString());		// 구독금액 int형으로 변환
														
														dbparam = new HashMap();
														dbparam.put("READNO", read_no);					// 독자번호
														dbparam.put("NEWSCD", newscd);					// 신문코드
														dbparam.put("YYMM", nowYearStr.substring(0, 2)+nextYYMM);// 구독년월(월분)
														dbparam.put("SEQ", seq);						// 일련번호
														
														Map sugmMap = (Map) generalDAO.getSqlMapClient().queryForObject("collection.edi.getSugmMap", dbparam);
														logger.debug("===== collection.edi.getSugmMap");
														
														if ( sugmMap == null ) { 	// 있는지 검사후 없으면
															if ( remainMoney > 0 ) {	// 입금 처리 
																dbparam = new HashMap();
																dbparam.put("READNO", read_no);					// 독자번호
																dbparam.put("NEWSCD", newscd);					// 신문코드
																dbparam.put("YYMM", nowYearStr.substring(0, 2)+nextYYMM);// 구독년월(월분)
																dbparam.put("SEQ", seq);						// 일련번호
																dbparam.put("BOSEQ", txt_jcode);				// 지국코드
																dbparam.put("SGBBCD", CODE_SUGM_TYPE_GIRO);		// 수금방법 - 지로
																dbparam.put("SGGBCD", CODE_SUGM_TYPE_GIRO);		// 수금구분 - 지로
																dbparam.put("BILLAMT", nUprice);				// 청구금액
																dbparam.put("BILLQTY", qty);					// 청구부수
																dbparam.put("SGYYMM", last_yymm);				// 수금년월(월분)
																if ( remainMoney < nUprice ) {
																	dbparam.put("AMT", remainMoney);				// 수금금액
																	dbparam.put("LOSSAMT", nUprice - remainMoney);	// 결손금액
																}
																else {
																	dbparam.put("AMT", nUprice);					// 수금금액
																}
																dbparam.put("EDIPROCNO", e_numid);				// EDI처리번호
																dbparam.put("SNDT", txt_sdate);					// 수납일자
																dbparam.put("ICDT", txt_edate);					// 이체일자
																dbparam.put("CLDT", txt_edate);					// 처리일자
																dbparam.put("INPS", txt_jcode);					// 등록자 ID
																dbparam.put("CHGPS", txt_jcode);				// 수정자 ID
																
																generalDAO.getSqlMapClient().insert("collection.edi.insertPreSugm", dbparam);
																logger.debug("===== collection.edi.insertPreSugm 1 : " + read_no + ", " + seq + ", " + nextYYMM);
																
																if ( remainMoney > nUprice ) {
																	remainMoney -= nUprice;
																}
																else {
																	remainMoney = 0;
																}
															}
															else {	// 결손처리
																dbparam = new HashMap();
																dbparam.put("READNO", read_no);					// 독자번호
																dbparam.put("NEWSCD", newscd);					// 신문코드
																dbparam.put("YYMM", nowYearStr.substring(0, 2)+nextYYMM);// 구독년월(월분)
																dbparam.put("SEQ", seq);						// 일련번호
																dbparam.put("BOSEQ", txt_jcode);				// 지국코드
																dbparam.put("SGBBCD", CODE_SUGM_TYPE_GIRO);		// 수금방법 - 지로
																dbparam.put("SGGBCD", CODE_SUGM_TYPE_GIRO);		// 수금구분 - 지로
																dbparam.put("BILLAMT", nUprice);				// 청구금액
																dbparam.put("BILLQTY", qty);					// 청구부수
																dbparam.put("SGYYMM", last_yymm);				// 수금년월(월분)
																dbparam.put("AMT", 0);							// 수금금액
																dbparam.put("LOSSAMT", nUprice);				// 결손금액
																dbparam.put("EDIPROCNO", e_numid);				// EDI처리번호
																dbparam.put("SNDT", txt_sdate);					// 수납일자
																dbparam.put("ICDT", txt_edate);					// 이체일자
																dbparam.put("CLDT", txt_edate);					// 처리일자
																dbparam.put("INPS", txt_jcode);					// 등록자 ID
																dbparam.put("CHGPS", txt_jcode);				// 수정자 ID
																
																generalDAO.getSqlMapClient().insert("collection.edi.insertPreSugm", dbparam);
																logger.debug("===== collection.edi.insertPreSugm 2 : " + read_no + ", " + seq + ", " + nextYYMM);
															}
														}
														else {
															String sgbbcd = (String) sugmMap.get("SGBBCD");
															
															// 미수로 수금에 들어있다면 입금처리
															if ( sgbbcd.equals(CODE_SUGM_GUBUN_NOT_COMPLETE) ) {
																
																BigDecimal billAmt = (BigDecimal)sugmMap.get("BILLAMT");	// 청구금액
																
																int nBillAmt = Integer.parseInt(billAmt.toString());		// 청구금액 int형으로 변환
																if ( remainMoney > 0 ) {	// 입금 처리 
																	
																	// 수금테이블 update
																	dbparam = new HashMap();
																	dbparam.put("READNO", read_no);									// 독자번호
																	dbparam.put("NEWSCD", newscd);									// 신문코드
																	dbparam.put("YYMM", nowYearStr.substring(0, 2) + nextYYMM);		// 구독년월
																	dbparam.put("SEQ", seq);										// 시퀀스
																	dbparam.put("SGBBCD", CODE_SUGM_GUBUN_NOT_COMPLETE);			// 수금방법 - 미수
																	//dbparam.put("SGGBCD_NOT", "'021','023','024','033','099'");			// 수금구분 - 자동이체 제외(본사입금,쿠폰,휴독,월삭제 제외 추가)
																	dbparam.put("BOSEQ", txt_jcode);								// 지국코드
																	if ( remainMoney < nBillAmt ) {
																		dbparam.put("AMT", remainMoney);							// 수금금액
																		dbparam.put("LOSSAMT", nBillAmt - remainMoney);				// 결손금액
																	}
																	else {
																		dbparam.put("AMT", nBillAmt);								// 수금금액
																	}
																	dbparam.put("SGBBCD_NEW", CODE_SUGM_TYPE_GIRO);					// 수금방법 - 지로
																	dbparam.put("SGYYMM", last_yymm);								// 수금년월
																	dbparam.put("EDIPROCNO", e_numid);								// EDI처리번호
																	dbparam.put("SNDT", txt_sdate);									// 수납일자
																	dbparam.put("ICDT", txt_edate);									// 이체일자
																	dbparam.put("CLDT", txt_edate);									// 처리일자
																	dbparam.put("CHGPS", txt_jcode);								// 수정자 ID
																	
																	generalDAO.getSqlMapClient().update("collection.edi.updateSugm", dbparam);
																	logger.debug("===== collection.edi.updateSugm 3 : " + read_no + ", " + seq + ", " + nextYYMM);
																	
																	if ( remainMoney > nBillAmt ) {
																		remainMoney -= nBillAmt;
																	}
																	else {
																		remainMoney = 0;
																	}
																}
																else {	// 결손처리
																	// 수금테이블 update
																	dbparam = new HashMap();
																	dbparam.put("READNO", read_no);									// 독자번호
																	dbparam.put("NEWSCD", newscd);									// 신문코드
																	dbparam.put("YYMM", nowYearStr.substring(0, 2) + nextYYMM);		// 구독년월
																	dbparam.put("SEQ", seq);										// 시퀀스
																	dbparam.put("SGBBCD", CODE_SUGM_GUBUN_NOT_COMPLETE);			// 수금방법 - 미수
																	//dbparam.put("SGGBCD_NOT", "'021','023','024','033','099'");			// 수금구분 - 자동이체 제외(본사입금,쿠폰,휴독,월삭제 제외 추가)
																	dbparam.put("BOSEQ", txt_jcode);								// 지국코드
																	dbparam.put("AMT", 0);											// 수금금액
																	dbparam.put("LOSSAMT", nBillAmt);								// 결손금액
																	dbparam.put("SGBBCD_NEW", CODE_SUGM_TYPE_GIRO);					// 수금방법 - 지로
																	dbparam.put("SGYYMM", last_yymm);								// 수금년월
																	dbparam.put("EDIPROCNO", e_numid);								// EDI처리번호
																	dbparam.put("SNDT", txt_sdate);									// 수납일자
																	dbparam.put("ICDT", txt_edate);									// 이체일자
																	dbparam.put("CLDT", txt_edate);									// 처리일자
																	dbparam.put("CHGPS", txt_jcode);								// 수정자 ID
																	
																	generalDAO.getSqlMapClient().update("collection.edi.updateSugm", dbparam);
																	logger.debug("===== collection.edi.updateSugm 4 : " + read_no + ", " + seq + ", " + nextYYMM);
																}
															}
														}
													}
												}
											}
											
											// 한달씩 넘기면서 구독년월을 구한다.
											nextYYYYMMDD = DateUtil.getWantDay(nowYearStr.substring(0, 2)+ nextYYMM + "01", 2, 1);
											nextYYMM = nextYYYYMMDD.substring(2, 6);
										}
										
										// 과입금 처리
										if ( remainMoney > 0 ) {
											dbparam = new HashMap();
											dbparam.put("EDINUMID", e_numid);						// edi 테이블에 저장된 pk
											dbparam.put("OVERMONEY", remainMoney);					// 과입금액
											generalDAO.getSqlMapClient().insert("collection.edi.insertEdiOver", dbparam);
											logger.debug("===== collection.edi.insertEdiOver");
										}
									}
									else {
										sngError++;
									}
								}
							}
						}
						
						// file_t 테이블에 insert
						dbparam = new HashMap();
						dbparam.put("FILENAME", edifile.getOriginalFilename());
						dbparam.put("TYPE", "DUZON");
						
						generalDAO.getSqlMapClient().insert("collection.edi.insertFile_t", dbparam);
						logger.debug("===== collection.edi.insertFile_t");
						
						msg = "정상적으로 처리되었습니다.";
						// transaction commit
						generalDAO.getSqlMapClient().getCurrentConnection().commit();
					}
					catch (Exception e) {
						// transaction rollback
						generalDAO.getSqlMapClient().getCurrentConnection().rollback();
						
						System.out.println("txtline:"+txtline ) ;
						e.printStackTrace();
						msg = "정상적으로 처리되지 않았습니다.";
					}
					finally {
						fis.close();
						
						// transaction end
						generalDAO.getSqlMapClient().endTransaction();
					}
					
					mav.setViewName("collection/edi/gr15process");
					mav.addObject("now_menu", ICodeConstant.MENU_CODE_COLLECTION_EDI);
					
					mav.addObject("msg", msg);
					mav.addObject("sngError", sngError);
					mav.addObject("rec_count", rec_count);
					
					return mav;
				}				
			}
		}
	}


	/**
	 * 바코드 수납 현황 통계(MR15)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView mr15List(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		String sdate = param.getString("sdate");
		String edate = param.getString("edate");
		String jiroNum = param.getString("jiroNum", "");
		
		// 현재날짜 (yyyymmdd)
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		String nowDate = df.format(cal.getTime());
		
		if ( StringUtils.isEmpty(sdate) ) {
			sdate = nowDate.substring(0, 4) + "-" + nowDate.substring(4, 6) + "-" + nowDate.substring(6, 8);
		}
		if ( StringUtils.isEmpty(edate) ) {
			edate = nowDate.substring(0, 4) + "-" + nowDate.substring(4, 6) + "-" + nowDate.substring(6, 8);
		}
		
		String sdate_tmp = sdate.replaceAll("-", ""); //yyyymmdd
		String edate_tmp = edate.replaceAll("-", ""); //yyyymmdd
		
		// 기간별 gr15 처리 과입금 목록
		Map dbparam = new HashMap();
		dbparam.put("sdate", sdate_tmp);			// 시작일(YYYYMMDD)
		dbparam.put("edate", edate_tmp);			// 종료일(YYYYMMDD)
		dbparam.put("jiroNum", jiroNum);
		List resultList = generalDAO.queryForList("collection.edi.getMR15List", dbparam);
		logger.debug("===== collection.edi.getMR15List");
		
		// 금융결재원 등록 지로번호 목록
		List jiroList = generalDAO.queryForList("collection.edi.getJiroList", dbparam);
		logger.debug("===== collection.edi.getJiroList");
				
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("collection/edi/mr15List");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COLLECTION_EDI);
		
		mav.addObject("sdate", sdate);
		mav.addObject("edate", edate);
		mav.addObject("jiroNum", jiroNum);
		mav.addObject("jiroList", jiroList);
		
		mav.addObject("resultList", resultList);
		
		return mav;
	}
	
	
	// txt를 byte단위로 자를수 있는 메소드
	public static String cropByteChar(String str, int i, int j) {
		if (str==null) return "";
		String tmp = str;
		int slen = 0, blen = 0;
		int slen2 = 0, blen2 = 0;
		char c ;
		if(tmp.getBytes().length>j) {
			while (blen+1 <= j) {
			c = tmp.charAt(slen);
			blen++;
			slen++;
			if ( c > 127 ) blen++; //2-byte character..
			}
		}
		tmp=tmp.substring(0,slen);
		
		if(tmp.getBytes().length>i) {
			while (blen2+1 <= i) {
			c = tmp.charAt(slen2);
			blen2++;
			slen2++;
			if ( c > 127 ) blen2++; //2-byte character..
			}
		}
		tmp=tmp.substring(slen2,tmp.length());
		return tmp;
	}
}
