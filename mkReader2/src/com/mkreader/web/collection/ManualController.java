/*------------------------------------------------------------------------------
 * NAME : ManualController 
 * DESC : 수금입력 - 수동입금
 * Author : shlee
 *----------------------------------------------------------------------------*/
package com.mkreader.web.collection;

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
import javax.servlet.http.HttpSession;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.util.Param;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.DateUtil;
import com.mkreader.util.StringUtil;

public class ManualController extends MultiActionController implements
ISiteConstant, ICodeConstant {

	private GeneralDAO generalDAO;
	
	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}

	/**
	 * 수동입금 - 개별/다부수입금
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView eachDeposit(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		String edate = param.getString("edate");
		
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		// 현재날짜 (yyyymmdd)
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		String nowDate = df.format(cal.getTime());
		
		if ( StringUtils.isEmpty(edate) ) {
			edate = nowDate.substring(0, 4) + "-" + nowDate.substring(4, 6) + "-" + nowDate.substring(6, 8);
		}
		
		String edate_tmp = edate.replaceAll("-", "");
		
		String last_yymm = (String) generalDAO.queryForObject("common.getLastSGYYMM");	// 가장 마지막 월마감의 수금년월분
		
		
		HashMap dbparam = new HashMap();
		dbparam.put("SERIAL", jikuk);
		List agencyNewsList = generalDAO.queryForList("common.getAgencyNewsList" , dbparam);  // 지국별 매체코드 목록
		
		List sgTypeList = generalDAO.queryForList("common.getSugmTypeList");	//수금방법 조회
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("collection/manual/eachDeposit");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COLLECTION);
		
		mav.addObject("agencyNewsList", agencyNewsList);
		mav.addObject("sgTypeList", sgTypeList);
		
		mav.addObject("edate", edate);
		mav.addObject("last_yymm", last_yymm);
		
		return mav;
	}
	
	
	/**
	 * 수동입금 - 개별/다부수입금 구독정보 목록 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ajaxGetNewsList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		String gubun = param.getString("gubun");						// 1:고유번호, 2:구역/배달번호 조회
		String newscd = param.getString("newscd", MK_NEWSPAPER_CODE);	// 매체코드 (default : 매일경제)
		String readno = param.getString("readno");						// 고유번호(독자번호)
		String gno = param.getString("gno");							// 구역번호
		String bno = param.getString("bno");							// 배달번호
		
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		HashMap dbparam = new HashMap();
		dbparam.put("NEWSCD", newscd);
		dbparam.put("BOSEQ", jikuk);
		
		if ( "1".equals(gubun) ) {
			dbparam.put("READNO", readno);
		} else {
			dbparam.put("GNO", gno);
			dbparam.put("BNO", bno);
		}

		List newsList = generalDAO.queryForList("collection.manual.getNewsList", dbparam);
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("collection/manual/ajaxGetNewsList");
		
		mav.addObject("newsList", newsList);
		
		return mav;
	}
	
	
	/**
	 * 수동입금 - 개별/다부수입금 수금목록 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ajaxGetSugmList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		String gubun = param.getString("gubun");						// 1:고유번호, 2:구역/배달번호 조회
		String newscd = param.getString("newscd", MK_NEWSPAPER_CODE);	// 매체코드 (default : 매일경제)
		String readno = param.getString("readno");						// 고유번호(독자번호)
		String seq = param.getString("seq");							// 시퀀스
		
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		
		String last_yymm = (String) generalDAO.queryForObject("common.getLastSGYYMM");	// 가장 마지막 월마감의 수금년월분
		
		int tmp = Integer.parseInt(last_yymm.substring(0, 4));
		tmp = tmp - 2;
		
		String yyyymmdd = Integer.toString(tmp) + "0101";
		
		HashMap dbparam = new HashMap();
		dbparam.put("READNO", readno);
		dbparam.put("NEWSCD", newscd);
		dbparam.put("SEQ", seq);
		dbparam.put("BOSEQ", jikuk);
		
		Map newsMap = (Map) generalDAO.queryForObject("collection.manual.getNewsInfo", dbparam);
		logger.debug("===== collection.manual.getNewsInfo");
		
		dbparam.put("SDATE", yyyymmdd.substring(0, 6));

		List sugmList = generalDAO.queryForList("collection.manual.getSugmListByEach", dbparam);
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("collection/manual/ajaxGetSugmList");
		
		mav.addObject("newsMap", newsMap);
		mav.addObject("sugmList", sugmList);
		
		return mav;
	}
	
	
	
	/**
	 * 수동입금 - 개별/다부수입금 입금처리
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ajaxEachDepositProcess(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		 
		Param param = new HttpServletParam(request);
		String edate = param.getString("edate");						// 입금일자
		String newscd = param.getString("newscd", MK_NEWSPAPER_CODE);	// 매체코드 (default : 매일경제)
		String depYYYY = param.getString("depYYYY");					// 입금년도
		String depMM = param.getString("depMM");						// 입금월
		String depMoney = param.getString("depMoney");					// 입금액
		String depType = param.getString("depType");					// 입금방법코드
		
		String depositArr = param.getString("depositArr");
		String depositType = param.getString("depositType");			// 개별다부수 구분 ( 1:개별, 2:다부수 )
		
		HttpSession session = request.getSession(); 
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("collection/manual/ajaxEachDepositProcess");
		
		List successList = new ArrayList();
		String sucSeq = "";
		String failSeq = "";
		
		
		if ( StringUtils.isNotEmpty(newscd) 
				&& StringUtils.isNotEmpty(depYYYY)
				&& StringUtils.isNotEmpty(depMM)
				&& StringUtils.isNotEmpty(depType)
		) {
			int i = 0;
			
			if ( StringUtils.isNotEmpty(depositArr) ) {
	
				JSONObject jsonObj = (JSONObject) JSONSerializer.toJSON( depositArr );	// depositArr 은 이중맵구조로 되어있음
				
				if ( jsonObj != null ) {
					
					String tmpKey = "";
					JSONObject tmpValue = null;
					JSONObject jsonMap = null;
					
					String eachReadno = "";			// 독자번호
					String eachNewscd = "";			// 매체코드
					String eachSeq = "";			// 시퀀스
					
					String last_yymm = (String) generalDAO.queryForObject("common.getLastSGYYMM");	// 가장 마지막 월마감의 수금년월분
					
					Map dbparam = new HashMap();
					dbparam.put("CODE", depType);				// 입금방법 코드
					String sgbbnm = (String) generalDAO.queryForObject("common.getSugmTypeName", dbparam);	// 수금타입 코드에 대한 한글명칭
					
					int nTxtMoney = Integer.parseInt(depMoney);			// 입금액
					int remainMoney = nTxtMoney;						// 남은 금액
	
					Iterator iter = jsonObj.keys();
					while ( iter.hasNext() ) {
						
						tmpKey = (String) iter.next();					// 1차원 맵에 key
						tmpValue = (JSONObject) jsonObj.get(tmpKey);	// 1차원 맵에 value
						
						if ( StringUtils.isNotEmpty(tmpKey) && tmpValue != null ) {
							
							jsonMap = (JSONObject) JSONSerializer.toJSON(tmpValue);			// 2차원 맵
							if ( jsonMap != null ) {
								
								eachReadno = (String) jsonMap.get("readno");    // 독자번호(9)
								eachNewscd = (String) jsonMap.get("newscd");    // 매체코드(3)
								eachSeq = (String) jsonMap.get("seq");          // 시퀀스   (4)
								
								if ( StringUtils.isNotEmpty(eachReadno)
										&& StringUtils.isNotEmpty(eachNewscd)
										&& StringUtils.isNotEmpty(eachSeq)
								) {
									// 1. 수금 테이블에 있는지 없는지 체크
									dbparam = new HashMap();
									dbparam.put("READNO", eachReadno);								// 독자번호(9)
									dbparam.put("NEWSCD", eachNewscd);								// 신문코드(3)
									dbparam.put("SEQ", eachSeq);									// 시퀀스(4)
									dbparam.put("YYMM", depYYYY + depMM);							// 구독년월(6)(YYYYMM)
									dbparam.put("BOSEQ", jikuk);									// 지국코드(6)
									
									Map sugmMap = (Map) generalDAO.queryForObject("collection.manual.getSugmInfo", dbparam);
									logger.debug("===== collection.manual.getSugmInfo");
									
									if ( sugmMap != null ) {	// 있다면 미수일때만 처리
										
										String sgbbcd = (String) sugmMap.get("SGBBCD");
										BigDecimal billAmt = (BigDecimal)sugmMap.get("BILLAMT");
										String readnm = (String) sugmMap.get("READNM");
										String dlvadrs1 = (String) sugmMap.get("DLVADRS1");
										String dlvadrs2 = (String) sugmMap.get("DLVADRS2");
										String newsnm = (String) sugmMap.get("NEWSNM");										
										
										if ( sgbbcd.equals(CODE_SUGM_GUBUN_NOT_COMPLETE) ) {	// 미수일때 수금처리
											
											int nBillAmt = Integer.parseInt(billAmt.toString());	// 수금테이블에 미수 청구금액
											
											if ( "1".equals(depositType) ) {	// 개별 구독정보 입금처리
											
												// 개별 구독정보의 입금처리 경우에는 입금액이 수정 가능하므로 수금금액에 입금액을 넣고 결손금액에 청구금액-수금금액을 넣어준다.
												if ( remainMoney > 0 ) {		// 입금액이 0보다 크면
													
													// 수금처리
													dbparam = new HashMap();
													dbparam.put("READNO", eachReadno);								// 독자번호(9)
													dbparam.put("NEWSCD", eachNewscd);								// 신문코드(3)
													dbparam.put("SEQ", eachSeq);									// 시퀀스(4)
													dbparam.put("YYMM", depYYYY + depMM);							// 구독년월(6)(YYYYMM)
													dbparam.put("BOSEQ", jikuk);									// 지국코드(6)
													dbparam.put("SGBBCD", depType);									// 수금방법(3)
													dbparam.put("SGYYMM", last_yymm);								// 수금년월
													dbparam.put("AMT", remainMoney);								// 수금금액
													if ( nBillAmt > remainMoney ) {	// 미수 청구금액이 입금액보다 크다면 결손금액 입력
														dbparam.put("LOSSAMT", nBillAmt-remainMoney);				// 결손금액
													}
													dbparam.put("SNDT", edate.replaceAll("-", ""));					// 수납일자(8)(YYYYMMDD)
													dbparam.put("ICDT", edate.replaceAll("-", ""));					// 이체일자(8)(YYYYMMDD)
													dbparam.put("CLDT", edate.replaceAll("-", ""));					// 처리일자(8)(YYYYMMDD)
													dbparam.put("CHGPS", jikuk);									// 수정자 아이디													
					
													// excute query
													generalDAO.update("collection.manual.updateSugm", dbparam);
													logger.debug("===== collection.manual.updateSugm");
													
													// 성공 목록에 추가
													Map tmpMap = new HashMap();
													tmpMap.put("READNO", eachReadno);					// 독자번호
													tmpMap.put("READNM", readnm);						// 독자명
													tmpMap.put("DLVADRS1", dlvadrs1);					// 주소
													tmpMap.put("DLVADRS2", dlvadrs2);					// 상세주소
													tmpMap.put("NEWSNM", newsnm);						// 지명
													tmpMap.put("YYMM", depYYYY + depMM);				// 월분
													tmpMap.put("AMT", remainMoney);						// 금액
													tmpMap.put("SGBBNM", sgbbnm);						// 수금방법
													tmpMap.put("SEQ", eachSeq);							// 시퀀스
													
													successList.add(tmpMap);
													
													sucSeq += (StringUtils.isNotEmpty(sucSeq) ? ","+Integer.parseInt(eachSeq) : ""+Integer.parseInt(eachSeq));
													
													i++;
													remainMoney = 0;
												}
												else {
													// 수금방법이 결손, 재무, 휴독이면
													if ( "031".equals(depType) || "032".equals(depType) || "033".equals(depType) ) {
														// 수금처리
														dbparam = new HashMap();
														dbparam.put("READNO", eachReadno);								// 독자번호(9)
														dbparam.put("NEWSCD", eachNewscd);								// 신문코드(3)
														dbparam.put("SEQ", eachSeq);									// 시퀀스(4)
														dbparam.put("YYMM", depYYYY + depMM);							// 구독년월(6)(YYYYMM)
														dbparam.put("BOSEQ", jikuk);									// 지국코드(6)
														dbparam.put("SGBBCD", depType);									// 수금방법(3)
														dbparam.put("SGYYMM", last_yymm);								// 수금년월
														dbparam.put("AMT", 0);											// 수금금액
														dbparam.put("LOSSAMT", nBillAmt);								// 결손금액
														dbparam.put("SNDT", edate.replaceAll("-", ""));					// 수납일자(8)(YYYYMMDD)
														dbparam.put("ICDT", edate.replaceAll("-", ""));					// 이체일자(8)(YYYYMMDD)
														dbparam.put("CLDT", edate.replaceAll("-", ""));					// 처리일자(8)(YYYYMMDD)
														dbparam.put("CHGPS", jikuk);									// 수정자 아이디
														
														// excute query
														generalDAO.update("collection.manual.updateSugm", dbparam);
														logger.debug("===== collection.manual.updateSugm");
														
														// 성공 목록에 추가
														Map tmpMap = new HashMap();
														tmpMap.put("READNO", eachReadno);					// 독자번호
														tmpMap.put("READNM", readnm);						// 독자명
														tmpMap.put("DLVADRS1", dlvadrs1);					// 주소
														tmpMap.put("DLVADRS2", dlvadrs2);					// 상세주소
														tmpMap.put("NEWSNM", newsnm);						// 지명
														tmpMap.put("YYMM", depYYYY + depMM);				// 월분
														tmpMap.put("AMT", 0);								// 금액
														tmpMap.put("SGBBNM", sgbbnm);						// 수금방법
														tmpMap.put("SEQ", eachSeq);							// 시퀀스
														
														successList.add(tmpMap);
														
														sucSeq += (StringUtils.isNotEmpty(sucSeq) ? ","+Integer.parseInt(eachSeq) : ""+Integer.parseInt(eachSeq));
														
														i++;
														remainMoney = 0;
													}
													else {
														failSeq += (StringUtils.isNotEmpty(failSeq) ? ","+Integer.parseInt(eachSeq) : ""+Integer.parseInt(eachSeq));
													}
												}
											}
											else {	// 다부수 구독정보 입금처리
												
												// 다부수 구독정보의 입금처리 경우에는 입금액을 청구금액대로만 자동입력되고 수정이 불가능 하므로 수금금액에 청구금액을 넣어준다.
												
												// 수금처리
												dbparam = new HashMap();
												dbparam.put("READNO", eachReadno);								// 독자번호(9)
												dbparam.put("NEWSCD", eachNewscd);								// 신문코드(3)
												dbparam.put("SEQ", eachSeq);									// 시퀀스(4)
												dbparam.put("YYMM", depYYYY + depMM);							// 구독년월(6)(YYYYMM)
												dbparam.put("BOSEQ", jikuk);									// 지국코드(6)
												dbparam.put("SGBBCD", depType);									// 수금방법(3)
												dbparam.put("SGYYMM", last_yymm);								// 수금년월
												dbparam.put("SNDT", edate.replaceAll("-", ""));					// 수납일자(8)(YYYYMMDD)
												dbparam.put("ICDT", edate.replaceAll("-", ""));					// 이체일자(8)(YYYYMMDD)
												dbparam.put("CLDT", edate.replaceAll("-", ""));					// 처리일자(8)(YYYYMMDD)
												dbparam.put("CHGPS", jikuk);									// 수정자 아이디
											
												// 수금방법이 결손, 재무, 휴독이면
												if ( "031".equals(depType) || "032".equals(depType) || "033".equals(depType) ) {
													dbparam.put("AMT", 0);									// 수금금액
													dbparam.put("LOSSAMT", nBillAmt);						// 결손금액
												}
												else {
													dbparam.put("AMT", nBillAmt);							// 수금금액
												}
				
												// excute query
												generalDAO.update("collection.manual.updateSugm", dbparam);
												logger.debug("===== collection.manual.updateSugm");
												
												// 성공 목록에 추가
												Map tmpMap = new HashMap();
												tmpMap.put("READNO", eachReadno);					// 독자번호
												tmpMap.put("READNM", readnm);						// 독자명
												tmpMap.put("DLVADRS1", dlvadrs1);					// 주소
												tmpMap.put("DLVADRS2", dlvadrs2);					// 상세주소
												tmpMap.put("NEWSNM", newsnm);						// 지명
												tmpMap.put("YYMM", depYYYY + depMM);				// 월분
												tmpMap.put("AMT", dbparam.get("AMT"));				// 금액
												tmpMap.put("SGBBNM", sgbbnm);						// 수금방법
												tmpMap.put("SEQ", eachSeq);							// 시퀀스
												
												successList.add(tmpMap);
												
												sucSeq += (StringUtils.isNotEmpty(sucSeq) ? ","+Integer.parseInt(eachSeq) : ""+Integer.parseInt(eachSeq));
												
												i++;
												remainMoney -= (Integer)dbparam.get("AMT");
											}
										}
										else {
											failSeq += (StringUtils.isNotEmpty(failSeq) ? ","+Integer.parseInt(eachSeq) : ""+Integer.parseInt(eachSeq));
										}
									}
									else {
										failSeq += (StringUtils.isNotEmpty(failSeq) ? ","+Integer.parseInt(eachSeq) : ""+Integer.parseInt(eachSeq));
									}
								}
								else {
									failSeq += (StringUtils.isNotEmpty(failSeq) ? ","+Integer.parseInt(eachSeq) : ""+Integer.parseInt(eachSeq));
								}
							}
						}
					}
					
					// 알림처리
					if ( StringUtils.isNotEmpty(sucSeq) ) {
						if ( remainMoney > 0 ) {	// 입금액이 적거나 초과했다면
							String msg = "미수금정보가 없거나 입금액이 0원이어서 정상적으로 처리를 완료하지 못하였습니다.";
							msg += "\\n정상처리 구분번호 : " + (StringUtils.isNotEmpty(sucSeq) ? sucSeq : "없음");
							msg += "\\n정상처리 금액 : " + (nTxtMoney-remainMoney);
							msg += "\\n미처리 구분번호 : " + (StringUtils.isNotEmpty(failSeq) ? failSeq : "없음");
							msg += "\\n미처리 금액 : " + remainMoney;
							mav.addObject("MSG", msg);
						}
						else {		// 정상적으로 처리되었다면
							if ( StringUtils.isNotEmpty(failSeq) ) {
								String msg = "미수금정보가 없어서 정상적으로 처리를 완료하지 못하였습니다.";
								msg += "\\n정상처리 구분번호 : " + (StringUtils.isNotEmpty(sucSeq) ? sucSeq : "없음");
								msg += "\\n정상처리 금액 : " + (nTxtMoney-remainMoney);
								msg += "\\n미처리 구분번호 : " + (StringUtils.isNotEmpty(failSeq) ? failSeq : "없음");
								msg += "\\n미처리 금액 : " + remainMoney;
								mav.addObject("MSG", msg);
							}
							else {
								mav.addObject("MSG", "정상적으로 입금처리되었습니다.");
							}
						}
					}
					else {
						mav.addObject("MSG", "이미 수금되어 있거나 수금정보가 없어 처리하지 못하였습니다.");
					}
				}
			}
		}
		
		mav.addObject("successList", successList);
		
		return mav;
	}
	
	
	/**
	 * 수동입금 - 구역별입금
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView areaDeposit(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		String gno = param.getString("gno");							// 구역번호
		String edate = param.getString("edate");						// 입금일자
		String newscd = param.getString("newscd", MK_NEWSPAPER_CODE);	// 매체코드 (default : 매일경제)
		String depType = param.getString("depType");					// 수금방법코드	
		String inStopMember = param.getString("inStopMember", "1");		// 중지독자포함여부(1:포함, 2:미포함)
		String memberType = param.getString("memberType");				// 전체 or 미수독자 (all:전체, 044:미수독자만)
		
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		// 현재날짜 (yyyymmdd)
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		String nowDate = df.format(cal.getTime());
		
		if ( StringUtils.isEmpty(edate) ) {
			edate = nowDate.substring(0, 4) + "-" + nowDate.substring(4, 6) + "-" + nowDate.substring(6, 8);
		}
		
		String edate_tmp = edate.replaceAll("-", "");
		
		HashMap dbparam = new HashMap();
		dbparam.put("SERIAL", jikuk);
		List agencyNewsList = generalDAO.queryForList("common.getAgencyNewsList" , dbparam);  // 지국별 매체코드 목록

		List sgTypeList = generalDAO.queryForList("common.getSugmTypeList");	// 수금방법 목록
		
		String last_yymm = (String) generalDAO.queryForObject("common.getLastSGYYMM");	// 가장 마지막 월마감의 수금년월분
		
		dbparam = new HashMap();
		dbparam.put("BOSEQ", jikuk);		
		List areaList = generalDAO.queryForList("common.getAgencyAreaList", dbparam);	// 구역목록
		
		List sugmList = null;
		
		if ( StringUtils.isNotEmpty(gno) ) {
			
			int tmp = Integer.parseInt(last_yymm.substring(0, 4));
			tmp = tmp - 1;
			
			String yyyymmdd = Integer.toString(tmp) + "0101";
			
			dbparam = new HashMap();
			dbparam.put("NEWSCD", newscd);
			dbparam.put("BOSEQ", jikuk);
			dbparam.put("GNO", gno);
			dbparam.put("SDATE", yyyymmdd.substring(0, 6));
			dbparam.put("EDATE", last_yymm);
			if ( !"1".equals(inStopMember) ) {
				dbparam.put("BNO_NOT", "999");		// 중지독자 미포함
			}
			if ( memberType.equals(CODE_SUGM_GUBUN_NOT_COMPLETE) ) {
				dbparam.put("SGBBCD", CODE_SUGM_GUBUN_NOT_COMPLETE);		// 미수독자만
			}
			
			String num = "";
			String yyyymm = "";
			for ( int i = 1; i <= 24; i++ ) {
				num = Integer.toString(i);
				if ( num.length() == 1 ) {
					num = "0" + num;
				}
				yyyymm = DateUtil.getWantDay(yyyymmdd, 2, i-1);
				dbparam.put("YYYYMM_" + num, yyyymm.substring(0, 6));
			}
			
			sugmList = generalDAO.queryForList("collection.manual.getSugmListByArea", dbparam);	// 구독정보 목록
		}		
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("collection/manual/areaDeposit");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COLLECTION);
		
		mav.addObject("agencyNewsList", agencyNewsList);
		mav.addObject("sgTypeList", sgTypeList);
		mav.addObject("areaList", areaList);
		mav.addObject("sugmList", sugmList);
		
		mav.addObject("gno", gno);
		mav.addObject("edate", edate);
		mav.addObject("newscd", newscd);
		mav.addObject("depType", (StringUtils.isNotEmpty(depType)?depType.split("\\|")[0]:""));
		mav.addObject("inStopMember", inStopMember);
		mav.addObject("memberType", memberType);
		
		mav.addObject("last_yymm", last_yymm);
		
		return mav;
	}
	
	
	
	/**
	 * 수동입금 - 구역별입금 처리
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView areaDepositProcess(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		String gno = param.getString("gno");							// 구역번호
		String edate = param.getString("edate");						// 입금일자
		String newscd = param.getString("newscd", MK_NEWSPAPER_CODE);	// 매체코드 (default : 매일경제)
		String depType = param.getString("depType");					// 수금방법코드
		String inStopMember = param.getString("inStopMember");			// 중지독자포함여부(1:포함, others:미포함)
		String memberType = param.getString("memberType");				// 전체 or 미수독자 (all:전체, 044:미수독자)
		
		String depositArr = param.getString("depositArr");
		
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		
		int i = 0;
		
		if ( StringUtils.isNotEmpty(depositArr) ) {

			JSONObject jsonObj = (JSONObject) JSONSerializer.toJSON( depositArr );	// depositArr 은 이중맵구조로 되어있음
			
			if ( jsonObj != null ) {
				
				String tmpKey = "";
				JSONObject tmpValue = null;
				JSONObject jsonMap = null;
				
				String eachReadno = "";			// 독자번호
				String eachNewscd = "";			// 매체코드
				String eachSeq = "";			// 시퀀스
				String eachYymm = "";			// 구독년월
				String eachSgbbcd = "";			// 수금방법
				String eachSndt = "";			// 입금일자
				
				String last_yymm = (String) generalDAO.queryForObject("common.getLastSGYYMM");	// 가장 마지막 월마감의 수금년월분

				Iterator iter = jsonObj.keys();
				while ( iter.hasNext() ) {
					
					tmpKey = (String) iter.next();					// 1차원 맵에 key
					tmpValue = (JSONObject) jsonObj.get(tmpKey);	// 1차원 맵에 value
					
					if ( StringUtils.isNotEmpty(tmpKey) && tmpValue != null ) {
						
						jsonMap = (JSONObject) JSONSerializer.toJSON(tmpValue);			// 2차원 맵
						if ( jsonMap != null ) {
							
							eachReadno = (String) jsonMap.get("readno");    // 독자번호(9)
							eachNewscd = (String) jsonMap.get("newscd");    // 매체코드(3)
							eachSeq = (String) jsonMap.get("seq");          // 시퀀스   (4)
							eachYymm = (String) jsonMap.get("yymm");		// 구독년월(6)(YYYYMM)
							eachSgbbcd = (String) jsonMap.get("sgbbcd");    // 수금방법(3)
							eachSndt = (String) jsonMap.get("sndt");        // 입금일자(8)(YYYYMMDD)
							
							if ( StringUtils.isNotEmpty(eachReadno)
									&& StringUtils.isNotEmpty(eachNewscd)
									&& StringUtils.isNotEmpty(eachSeq)
									&& StringUtils.isNotEmpty(eachYymm)
									&& StringUtils.isNotEmpty(eachSgbbcd)
									&& StringUtils.isNotEmpty(eachSndt)
							) {
								
								// 수금처리
								Map dbparam = new HashMap();
								dbparam.put("READNO", eachReadno);								// 독자번호(9)
								dbparam.put("NEWSCD", eachNewscd);								// 신문코드(3)
								dbparam.put("SEQ", eachSeq);									// 시퀀스(4)
								dbparam.put("YYMM", eachYymm);									// 구독년월(6)(YYYYMM)
								dbparam.put("BOSEQ", jikuk);									// 지국코드(6)
								dbparam.put("SGBBCD", eachSgbbcd);								// 수금방법(3)
								dbparam.put("SGYYMM", last_yymm);								// 수금년월
								dbparam.put("SNDT", eachSndt.replaceAll("-", ""));				// 수납일자(8)(YYYYMMDD)
								dbparam.put("ICDT", eachSndt.replaceAll("-", ""));				// 이체일자(8)(YYYYMMDD)
								dbparam.put("CLDT", eachSndt.replaceAll("-", ""));				// 처리일자(8)(YYYYMMDD)
								dbparam.put("CHGPS", jikuk);									// 수정자 아이디
								
								if ( "031".equals(eachSgbbcd) || "032".equals(eachSgbbcd) || "033".equals(eachSgbbcd) ) {	// 결손, 재무, 휴독 인 경우
									dbparam.put("AMT", 0);										// 수금금액
									dbparam.put("BILLAMT_TO_LOSSAMT", "TRUE");					// 청구금액을 결손금액으로
								}
								
								// excute query
								generalDAO.update("collection.manual.updateSugm", dbparam);
								logger.debug("===== collection.manual.updateSugm");
								
								i++;
							}
						}
					}
				}
			}
		}
		
		String returlUrl = "/collection/manual/areaDeposit.do"
							+"?gno="+gno
							+"&edate="+edate
							+"&newscd="+newscd
							+"&depType="+depType
							+"&inStopMember="+inStopMember
							+"&memberType="+memberType;
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("common/message");
		mav.addObject("returnURL", returlUrl);
		
		if ( i > 0 ) {	// 수금처리된 건이 1건 이상 있으면
			mav.addObject("message", i + " 건이 정상적으로 입금처리 되었습니다.");
		}
		else {
			mav.addObject("message", "입금처리할 데이터가 없습니다.");
		}
		
		return mav;
	}
	
	/**
	 * 방문수금장표 조회
	 * @category 방문수금장표 조회
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView visitSugmFormList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		HashMap dbparam = new HashMap();
		Param param = new HttpServletParam(request);
		
		//현재날짜
		Calendar rightNow = Calendar.getInstance();
		String year = String.valueOf(rightNow.get(Calendar.YEAR));
		String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));
		if (month.length() < 2)
			month = "0" + month;
		if (day.length() < 2)
			day = "0" + day;

		String fromDate= param.getString("fromDate", year + "-" + month + "-" + day);			//기간 from
		String toDate= param.getString("toDate", year + "-" + month + "-" + day);				//기간 to
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			dbparam.put("boseq", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			dbparam.put("fromDate", StringUtil.replace(fromDate, "-", ""));
			dbparam.put("toDate", StringUtil.replace(toDate, "-", ""));

			List visitSugmList = generalDAO.queryForList("collection.manual.visitSugmForm" , dbparam); // 본사신청중지현황 조회
			
			mav.addObject("visitSugmList", visitSugmList);

			mav.addObject("fromDate",fromDate);
			mav.addObject("toDate",toDate);
			
			mav.addObject("now_menu", MENU_CODE_COLLECTION);
			mav.setViewName("collection/manual/visitSugmForm");
			return mav;

		}catch(Exception e){
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}finally{
			generalDAO.getSqlMapClient().endTransaction();
		}
	}


	
	/**
	 * 방문수금장표 조회(OZ)
	 * @category 방문수금장표 조회(OZ)
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ozVisitSugmList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		Param param = new HttpServletParam(request);
		
		//현재날짜
		Calendar rightNow = Calendar.getInstance();
		String year = String.valueOf(rightNow.get(Calendar.YEAR));
		String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));
		if (month.length() < 2)
			month = "0" + month;
		if (day.length() < 2)
			day = "0" + day;

		String fromDate= param.getString("fromDate", year + month + day);			//기간 from
		String toDate= param.getString("toDate", year + month + day);				//기간 to
		
		try{
			
			mav.addObject("fromDate",fromDate.substring(0,4)+fromDate.substring(5,7)+fromDate.substring(8,10));
			mav.addObject("toDate",toDate.substring(0,4)+toDate.substring(5,7)+toDate.substring(8,10));
			mav.addObject("boseq",session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			
			mav.addObject("now_menu", MENU_CODE_COLLECTION);
			mav.setViewName("collection/manual/ozVisitSugmList");
			return mav;

		}catch(Exception e){
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	
}
