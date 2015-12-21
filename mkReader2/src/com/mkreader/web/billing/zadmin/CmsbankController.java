/*------------------------------------------------------------------------------
 * NAME : CmsbankController 
 * DESC : 자동이체(일반) - 은행신청/은행신청결과
 * Author : shlee
 *----------------------------------------------------------------------------*/
package com.mkreader.web.billing.zadmin;

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
import javax.servlet.http.HttpSession;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.servlet.util.MultipartHttpServletParam;
import kr.reflexion.espresso.util.Param;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.CommonUtil;
import com.mkreader.util.FileUtil;
import com.mkreader.util.Paging;



public class CmsbankController extends MultiActionController implements
		ISiteConstant {
	
	public static Logger logger = Logger.getRootLogger();

	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {

		this.generalDAO = generalDAO;
	}
	
	/**
	 * 은행신청(EB11)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		int pagesize = 40;
		int conternp = 10;
		//String idid = "tbl_cmsdata";
		String thisorder = "";
		String orderby = "";
		
		// param
		Param param = new HttpServletParam(request);
		int pageNo = param.getInt("pageNo", 1);			// 리스트의 몇번째 페이지인지 읽음
		String view = param.getString("view", "0");
		String view2 = param.getString("view2", "0");
		
		String search_key = param.getString("search_key");
		String search_type = param.getString("search_type");
		search_type = "txt";
	
		String strget1 = "view="+view+"&search_key="+search_key+"&search_type="+search_type+"&pageNo="+pageNo;
		String strget2 = "orders="+thisorder+"&orderby="+orderby;
		
		
		// db query parameter		
		HashMap dbparam = new HashMap();
		dbparam.put("PAGE_NO", pageNo);
		dbparam.put("PAGE_SIZE", pagesize);

		// excute query
		List resultList = generalDAO.queryForList("billing.zadmin.cmsbank.getEB11LogList", dbparam);
		
		int t_count = (Integer) generalDAO.queryForObject("billing.zadmin.cmsbank.getEB11LogCount");
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("billing/zadmin/cmsbank/index");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_BILLING);
		mav.addObject("show_hidden3", "display");
		
		mav.addObject("pageNo", pageNo);
		mav.addObject("view", view);
		mav.addObject("view2", view2);
		mav.addObject("search_key", search_key);
		mav.addObject("search_type", search_type);
		mav.addObject("strget1", strget1);
		mav.addObject("strget2", strget2);
		
		mav.addObject("resultList", resultList);
		mav.addObject("t_count", t_count);
		mav.addObject("pageInfo", Paging.getPageMap(pageNo, t_count, pagesize, 10));
		
		return mav;
	}
	
	
	/**
	 * 은행신청(EB11) 상세
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView view(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		int pagesize = 40;
		int conternp = 10;
		//String idid = "tbl_cmsEA11data_log";
		String thisorder = "";
		String orderby = "";
		
		// param
		Param param = new HttpServletParam(request);
		int numid = param.getInt("numid");
		String filename = param.getString("filename");
		String cmsdate = param.getString("cmsdate");
		int pageNo = param.getInt("pageNo", 1);			// 리스트의 몇번째 페이지인지 읽음
		
		// db query parameter		
		Map dbparam = new HashMap();
		dbparam.put("numid", numid);
		Map resultMap = (Map) generalDAO.queryForObject("billing.zadmin.cmsbank.getEA11LogInfo", dbparam);
		logger.debug("===== billing.zadmin.cmsbank.getEA11LogInfo");
		
		dbparam = new HashMap();
		dbparam.put("FILENAME", filename);
		dbparam.put("SGTYPE", CODE_SUGM_TYPE_DIRECT_DEBIT);
		dbparam.put("NEWSCD", MK_NEWSPAPER_CODE);
		List resultList = generalDAO.queryForList("billing.zadmin.cmsbank.getEA11List", dbparam);
		logger.debug("===== billing.zadmin.cmsbank.getEA11List");
		
		List tmpList = new ArrayList();
		if ( resultList != null ) {
			for ( int i = 0; i < resultList.size(); i++ ) {
				Map tmpMap = (Map) resultList.get(i);
				String cmsresult = (String)tmpMap.get("RESULT");
				if ( StringUtils.isNotEmpty(cmsresult) && cmsresult.length() >= 5) {
					tmpMap.put("CMSRESULTMSG", CommonUtil.err_code(cmsresult.substring(1, 5)));
				}
				tmpList.add(tmpMap);
			}
			resultList = tmpList;
		}
		
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("billing/zadmin/cmsbank/view");
		mav.addObject("now_menu", MENU_CODE_BILLING);
		mav.addObject("show_hidden3", "display");
		
		mav.addObject("numid", numid);
		mav.addObject("filename", filename);
		mav.addObject("cmsdate", cmsdate);
		mav.addObject("pageNo", pageNo);
		
		mav.addObject("resultMap", resultMap);		
		mav.addObject("resultList", resultList);
		
		return mav;
	}
	
	
	/**
	 * 은행신청(EB11) db 저장
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView input_db(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		MultipartHttpServletParam param = new MultipartHttpServletParam(request);
		MultipartFile cmsfile = param.getMultipartFile("cmsfile");
		
		HashMap dbparam = new HashMap();
		
		// mav
		ModelAndView mav = new ModelAndView();
		
		if ( cmsfile.isEmpty()) {	// 파일 첨부가 안되었으면 
			mav.setViewName("common/message");
			mav.addObject("message", "파일첨부가 되지 않았습니다.");
			mav.addObject("returnURL", "/billing/zadmin/cmsbank/index.do");
			return mav;
		}
		else {	// 파일 첨부가 되었으면
			
			Calendar now = Calendar.getInstance();
			int year = now.get(Calendar.YEAR);
			
			
			FileUtil fileUtil = new FileUtil( getServletContext() );
			String strFile = fileUtil.saveUploadFile(
											cmsfile, 
											PATH_PHYSICAL_HOME,
											PATH_UPLOAD_ABSOLUTE_CMS_EB11 + "/" + year
										);
			
			
			if ( StringUtils.isEmpty(strFile) ) {
				mav.setViewName("common/message");
				mav.addObject("message", "파일 저장이 실패하였습니다. ");
				mav.addObject("returnURL", "/billing/zadmin/cmsbank/index.do");
				return mav;
			}
			else if ( strFile.length() != 8 ) { 
				mav.setViewName("common/message");
				mav.addObject("message", "파일명이 잘못되었습니다.");
				mav.addObject("returnURL", "/billing/zadmin/cmsbank/index.do");
				return mav;
			}
			else {
				
				String msg = "출금이체 내역이 아닙니다.";
				String dataproc = "";
				
				// 기존에 같은 데이터가 있는지 체크
				Calendar cal = Calendar.getInstance();
				int nowYear =  cal.get(Calendar.YEAR);
				String nowYearStr = Integer.toString(nowYear);
				
				dbparam = new HashMap();
				dbparam.put("cmsdate", nowYearStr.substring(2, 4) + strFile.substring(4, 8));

				// excute query
				String filename = (String) generalDAO.queryForObject("billing.zadmin.cmsbank.getEB11FileName", dbparam);
				logger.debug("===== billing.zadmin.cmsbank.getEB11FileName");
				
				if ( StringUtils.isEmpty(filename)) {
					// 파일 분석
					String fmt1 = strFile.substring(0, 4);
					String fmt2 = strFile.substring(4, 8);				
					
					if ( "EB11".equals(fmt1)) {			dataproc = "신청내역";
					} else if ( "EB12".equals(fmt1)) {	dataproc = "신청결과내역불능";
					} else if ( "EB13".equals(fmt1)) {	dataproc = "신청내역";
					} else if ( "EB14".equals(fmt1)) {	dataproc = "신청결과내역";
					} else if ( "EB21".equals(fmt1)) {	dataproc = "출금이체의뢰내역";		msg = "잘못된 파일";
					} else if ( "EB22".equals(fmt1)) {	dataproc = "출금이체결과내역";		msg = "정상처리 완료";
					}
					
					if ( "EB11".equals(fmt1) ) {
	
						int LINE_NUM = 120;
						
						String fileName = PATH_UPLOAD_RELATIVE_CMS_EB11 + "/" + year + "/" + strFile;
						
						File f = new File(fileName);
						FileInputStream fis = new FileInputStream(f);
						
						int count;
						byte[] b = new byte[LINE_NUM];
						
						int i = 0;
						
						String txt_file = "";
						String txt_date = "";
						
						try {
							// transaction start
							generalDAO.getSqlMapClient().startTransaction();
							generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
						
							while ((count = fis.read(b)) != -1) {
								
								String txtline = new String(b);
								
								if ( txtline.length() != 0 ) {
									
									String txt_code = txtline.substring(0, 1);		// (1) Record 구분코드
									String txt_count = txtline.substring(1, 9);		// (8) 일련번호
									String txt_code2 = txtline.substring(9, 19);	// (10)기관코드
									
									if ( txt_code.equals(CODE_CMS_LAYOUT_HEADER)) {	// 헤더면
										txt_file = txtline.substring(19, 27);		// (8) File 이름
										txt_date = txtline.substring(27, 33);		// (6) 신청접수날짜
										//String txt_hfiller = txtline.substring(27, 33);		// (6) FILLER
									}
									else if ( txt_code.equals(CODE_CMS_LAYOUT_DATA)) {	// 데이터면
										
										i++;
										
										String txt_rdate = txtline.substring(19, 25);			// (6) 신청일자
										String txt_type = txtline.substring(25, 26);			// (1) 신청구분
										String txt_number = txtline.substring(26, 46);			// (20) 납부자번호
										String txt_bank_code = txtline.substring(46, 53);		// (7) 은행점코드
										String txt_bank_numb = txtline.substring(53, 69);		// (16) 지점출금계좌번호
										String txt_bank_jumin = txtline.substring(69, 85);		// (16) 주민등록번호 또는 사업자번호
										String txt_ccode = txtline.substring(85, 89);			// (4) 취급점코드
										String txt_mtype = txtline.substring(89, 91);			// (2) 자금종류
										String txt_result = txtline.substring(91, 96);			// (5) 처리결과
										String txt_tmp = txtline.substring(96, 101);			// (5) FILLER
										
										
										// 로그인 아이디
										HttpSession session = request.getSession();
										String adminId = (String) session.getAttribute(SESSION_NAME_ADMIN_USERID);
										
										// EB11 data 등록
										dbparam = new HashMap();
										dbparam.put("rtype", fmt1);
										dbparam.put("serial", txt_count);
										dbparam.put("filename", txt_file);
										dbparam.put("rdate", txt_rdate);
										dbparam.put("type", txt_type);
										dbparam.put("number", txt_number);
										dbparam.put("bank_code", txt_bank_code);
										dbparam.put("bank_numb", txt_bank_numb);
										dbparam.put("bank_jumin", txt_bank_jumin);
										dbparam.put("ccode", txt_ccode);
										dbparam.put("mtype", txt_mtype);
//										dbparam.put("result", txt_result);
										dbparam.put("tmp", txt_tmp);
										dbparam.put("chk_id", adminId);
										
										
										dbparam.put("rOutDate","20" + txt_rdate);
										// excute query

										
										boolean isStu = false;
										String jikuk = txt_number.substring(0,6);
										String serial = txt_number.substring(6,11);
										if(jikuk.equals("999999"))isStu = true;
										
										dbparam.put("jikuk", jikuk);
										dbparam.put("serial", serial);
										
										HashMap tblUsers = null;
										if(isStu)tblUsers = (HashMap)generalDAO.getSqlMapClient().queryForObject("billing.zadmin.cmsbank.getTblUsersStu",dbparam);
										else tblUsers = (HashMap)generalDAO.getSqlMapClient().queryForObject("billing.zadmin.cmsbank.getTblUsers",dbparam);
										
										String result = " 0000";
										// 결과코드가 성공(0000) 이면
//										if ( StringUtils.isNotEmpty(txt_result) && "0000".equals(txt_result.trim())) {
											if ( StringUtils.isNotEmpty(txt_number) && txt_number.length() >= 13 ) {
												if ( StringUtils.isNotEmpty(txt_type) ) {

													if ("1".equals(txt_type)) {//신청
														if(txt_ccode.equals("CHNG")){
															if(tblUsers != null){
																dbparam.put("status", "EA21");			// 신청처리
																dbparam.put("levels", "3");				// 상태 정상
																dbparam.put("saup", txt_bank_jumin.trim());	// 주민번호
																dbparam.put("bank", txt_bank_code);		// 은행코드
																dbparam.put("bank_num", txt_bank_numb);	// 계좌번호
																if(isStu){
																	generalDAO.getSqlMapClient().update("billing.zadmin.cmsbank.updateTblStuUsers", dbparam);
																}else{
																	generalDAO.getSqlMapClient().update("billing.zadmin.cmsbank.updateTblUsers", dbparam);
																}
															}else{
																result = " A017";
															}
														}else{
															result = " A013";
														}
													}else if ("3".equals(txt_type)) {//해지
														// 1. tbl_users 테이블에 중지 정상처리 update
														if(txt_ccode.equals("CHNG")){//고객이 ‘자동이체 통합관리서비스’ 등을 통해 변경을 요청
															if(tblUsers != null){
																dbparam.put("status", "EB13-");
																if(isStu){//학생
																	// 해지(계좌변경)으로 클론 등록
																	generalDAO.getSqlMapClient().insert("billing.zadmin.cmsbank.stuCloneBankInfo", dbparam);
																}else{//일반
																	generalDAO.getSqlMapClient().insert("billing.zadmin.cmsbank.cloneBankInfo", dbparam);
																}
															}else{
																result = " A017";
															}
															
														}else{
															if(tblUsers != null){
																String readno = null;
																if(isStu){
																	readno = (String)generalDAO.getSqlMapClient().queryForObject("billing.zadmin.cmsbank.getReaderNoStu", dbparam);
																}else{
																	readno = (String)generalDAO.getSqlMapClient().queryForObject("billing.zadmin.cmsbank.getReaderNo", dbparam);
																}
																dbparam.put("status", "EA99");		// 중지처리
																if(isStu){//학생
																	// 해지(계좌변경)으로 클론 등록
																	generalDAO.getSqlMapClient().update("billing.zadmin.cmsbank.updateTblStuUsers", dbparam);
																}else{//일반
																	generalDAO.getSqlMapClient().update("billing.zadmin.cmsbank.updateTblUsers", dbparam);
																}
																dbparam.put("NEWSCD", MK_NEWSPAPER_CODE);
																dbparam.put("SGTYPE", CODE_SUGM_TYPE_DIRECT_DEBIT);
																dbparam.put("READNO", readno);
																dbparam.put("SGTYPE_NEW", CODE_SUGM_TYPE_GIRO);
																generalDAO.getSqlMapClient().update("billing.zadmin.cmsbank.updateReaderNewsSgtype", dbparam);
																logger.debug("===== billing.zadmin.cmsbank.updateReaderNewsSgtype");
															}
														}
													}else if ("7".equals(txt_type)) {//임의해지
														if(tblUsers != null){
															dbparam.put("status", "EA99");		// 중지처리
															if(isStu){//학생
																// 해지(계좌변경)으로 클론 등록
																generalDAO.getSqlMapClient().update("billing.zadmin.cmsbank.updateTblStuUsers", dbparam);
															}else{//일반
																generalDAO.getSqlMapClient().update("billing.zadmin.cmsbank.updateTblUsers", dbparam);
															}
														}
													}
												}
											}
											dbparam.put("serial", txt_count);
											dbparam.put("result",result);
											generalDAO.getSqlMapClient().insert("billing.zadmin.cmsbank.insertCmsEA11Data", dbparam);
											logger.debug("===== billing.zadmin.cmsbank.insertCmsEA11Data");
//										}
									}
									else if ( txt_code.equals(CODE_CMS_LAYOUT_TRAILER)) {	// 트레일러면
										
										txt_file = txtline.substring(19, 27);				// (8) File 이름
										String txt_totals = txtline.substring(27, 35);		// (8) 총 Data Record 수
										String txt_type1 = txtline.substring(35, 43);		// (8) 등록의뢰건수 - 신규등록
										String txt_type2 = txtline.substring(43, 51);		// (8) 등록의뢰건수 - 변경등록 (00000000)
										String txt_type3 = txtline.substring(51, 59);		// (8) 등록의뢰건수 - 해지등록
										String txt_type4 = txtline.substring(59, 67);		// (8) 등록의뢰건수 - 임의해지
										String txt_filler = txtline.substring(67, 110);		// (43) SPACE
										
										// 로그인 아이디
										HttpSession session = request.getSession();
										String adminId = (String) session.getAttribute(SESSION_NAME_ADMIN_USERID);
										
										// EB11 data 결과 등록
										dbparam = new HashMap();
										dbparam.put("rtype", fmt1);
										dbparam.put("code", txt_code2);
										dbparam.put("filename", txt_file);
										dbparam.put("cmsdate", txt_date);
										dbparam.put("totals", txt_totals);
										dbparam.put("type1", txt_type1);
										dbparam.put("type2", txt_type2);
										dbparam.put("type3", txt_type3);
										dbparam.put("type4", txt_type4);
										dbparam.put("chk_id", adminId);
		
										// excute query
										generalDAO.getSqlMapClient().insert("billing.zadmin.cmsbank.insertCmsEA11DataResult", dbparam);
										logger.debug("===== billing.zadmin.cmsbank.insertCmsEA11DataResult");
										
										msg = "정상적으로 처리되었습니다.";
										
										// transaction commit
										generalDAO.getSqlMapClient().getCurrentConnection().commit();
									}
								}
								else {
									msg = "정상적으로 처리되지 않았습니다.1";
									// transaction rollback
									generalDAO.getSqlMapClient().getCurrentConnection().rollback();
								}
							}
						}
						catch(Exception e) {
							e.printStackTrace();
							msg = "정상적으로 처리되지 않았습니다." + e.getMessage();
							// transaction rollback
							generalDAO.getSqlMapClient().getCurrentConnection().rollback();
						}
						finally {
							fis.close();
							
							// transaction end
							generalDAO.getSqlMapClient().endTransaction();
						}
					}
				}
				else {
					msg = "이미 데이터가 있습니다.";
				}
			
				mav.setViewName("billing/zadmin/cmsbank/input_db");
				mav.addObject("now_menu", MENU_CODE_BILLING);
				
				mav.addObject("dataproc", dataproc);
				mav.addObject("msg", msg);
				return mav;
			}
		}
	}
	
	
	/**
	 * 상태변경 (자동이체로)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView changeStatus(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		// param
		Param param = new HttpServletParam(request);
		int numid = param.getInt("numid", 0);
		String filename = param.getString("filename");
		String cmsdate = param.getString("cmsdate");
		int pageNo = param.getInt("pageNo", 1);			// 리스트의 몇번째 페이지인지 읽음
		String flag = param.getString("flag");			// 1: 자동이체 신청, 3: 자동이체 해지
		String jikuk = param.getString("jikuk");		// 지국번호
		String readno = param.getString("readno");		// 독자번호
		String serial = param.getString("serial");					// 파일데이터 일련번호
		String users_serial = param.getString("users_serial");		// 납부자번호
		
		// mav
		ModelAndView mav = new ModelAndView();
		
		// db query parameter		
		Map dbparam = new HashMap();
		
		String strz = "";
		
		if ( StringUtils.isEmpty(filename) || StringUtils.isEmpty(jikuk) || StringUtils.isEmpty(readno) || StringUtils.isEmpty(serial)) {
			strz = "잘못된 파라미터입니다.";
		}
		else {
			dbparam = new HashMap();
			dbparam.put("filename", filename);
			dbparam.put("cmsdate", cmsdate);
			dbparam.put("serial", serial);
			Map cms11Map = (Map) generalDAO.queryForObject("billing.zadmin.cmsbank.getCmsEA11DataInfo", dbparam);
			logger.debug("===== billing.zadmin.cmsbank.getCmsEA11DataInfo");
			
			if ( cms11Map == null ) {		// 해당 데이터가 없으면 에러
				strz = "유효하지 않은 데이터입니다.";
			}
			else {
				try {
					// transaction start
					generalDAO.getSqlMapClient().startTransaction();
					generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
				
					if ( "1".equals(flag)) {			// 자동이체 신청
						dbparam = new HashMap();
						dbparam.put("jikuk", jikuk);
						dbparam.put("readno", readno);
						int count = (Integer) generalDAO.getSqlMapClient().queryForObject("billing.zadmin.cmsbank.existTblUsers", dbparam);
						logger.debug("===== billing.zadmin.cmsbank.existTblUsers");
						
						if ( count > 0 ) {		// tbl_users 테이블에 지국+일련번호 조합을 가진 독자가 이미 있다면 에러
							
							// 1. 납부자 번호 중복처리
							//strz = "납부자 번호 중복"
							dbparam = new HashMap();
							dbparam.put("filename", filename);
							dbparam.put("cmsdate", cmsdate);
							dbparam.put("serial", serial);
							dbparam.put("result", "NA013");
							generalDAO.getSqlMapClient().update("billing.zadmin.cmsbank.updateCmsEA11data", dbparam);
							logger.debug("===== billing.zadmin.cmsbank.updateCmsEA11data");
							
							strz = "납부자 번호 중복입니다.";
						}
						else {
							
							dbparam = new HashMap();
							dbparam.put("NEWSCD", MK_NEWSPAPER_CODE);
							dbparam.put("SGTYPE", CODE_SUGM_TYPE_DIRECT_DEBIT);
							dbparam.put("filename", filename);
							dbparam.put("cmsdate", cmsdate);
							dbparam.put("serial", serial);
							Map resultMap = (Map) generalDAO.getSqlMapClient().queryForObject("billing.zadmin.cmsbank.getReaderInfoForNew", dbparam);
							logger.debug("===== billing.zadmin.cmsbank.getReaderInfoForNew");
							
							// 1. tbl_users 에 insert
							String username = "";
							String dlvzip = "";					
							String dlvadrs1 = "";
							String dlvadrs2 = "";
							String hometel1 = "";
							String hometel2 = "";
							String hometel3 = "";
							String mobile1 = "";
							String mobile2 = "";
							String mobile3 = "";
							
							String bank = "";
							String bank_num = "";
							BigDecimal bank_money = null;
							String saup = "";
							
							if (resultMap != null ) {
								username = (String) resultMap.get("READNM");
								dlvzip = (String) resultMap.get("DLVZIP");					
								dlvadrs1 = (String) resultMap.get("DLVADRS1");
								dlvadrs2 = (String) resultMap.get("DLVADRS2");
								hometel1 = (String) resultMap.get("HOMETEL1");
								hometel2 = (String) resultMap.get("HOMETEL2");
								hometel3 = (String) resultMap.get("HOMETEL3");
								mobile1 = (String) resultMap.get("MOBILE1");
								mobile2 = (String) resultMap.get("MOBILE2");
								mobile3 = (String) resultMap.get("MOBILE3");
								
								bank = (String) resultMap.get("BANK_CODE");
								bank_num = (String) resultMap.get("BANK_NUMB");
								bank_money = (BigDecimal) resultMap.get("UPRICE");
								saup = (String) resultMap.get("BANK_JUMIN");
							}
							
							// 현재날짜 (yyyymmdd)
							Calendar cal = Calendar.getInstance();
							SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
							String nowDate = df.format(cal.getTime());
							
							
							dbparam = new HashMap();
							dbparam.put("jikuk", jikuk);
							dbparam.put("intype", "기존");
							dbparam.put("username", username);
							dbparam.put("saup", saup.trim());
							if ( StringUtils.isNotEmpty(dlvzip) && dlvzip.length() == 6) {
								dbparam.put("zip1", dlvzip.substring(0, 3));
								dbparam.put("zip2", dlvzip.substring(3, 6));
							}
							dbparam.put("addr1", dlvadrs1);
							dbparam.put("addr2", dlvadrs2);
							dbparam.put("phone", hometel1 + "-" + hometel2 + "-" + hometel3);
							dbparam.put("handy", mobile1 + "-" + mobile2 + "-" + mobile3);
							dbparam.put("levels", "3");
							dbparam.put("memo", "은행신청분 접수 등록");			
							dbparam.put("sdate", nowDate.substring(0, 2) + cmsdate);
							dbparam.put("bank", bank);
							dbparam.put("bank_num", bank_num);
							dbparam.put("bank_name", username);
							dbparam.put("bank_money", bank_money);					
							dbparam.put("status", "EA21");
							dbparam.put("readno", readno);
							dbparam.put("realjikuk", jikuk);
							dbparam.put("serial", users_serial);
							generalDAO.getSqlMapClient().insert("billing.zadmin.cmsbank.insertTblUsers", dbparam);
							logger.debug("===== billing.zadmin.cmsbank.existTblUsers");
							
							// 2. tm_reader_news 에 021 로 update
							dbparam = new HashMap();
							dbparam.put("NEWSCD", MK_NEWSPAPER_CODE);
							dbparam.put("SGTYPE_NOT", CODE_SUGM_TYPE_DIRECT_DEBIT);
							dbparam.put("READNO", readno);
							dbparam.put("SGTYPE_NEW", CODE_SUGM_TYPE_DIRECT_DEBIT);					
							generalDAO.getSqlMapClient().update("billing.zadmin.cmsbank.updateReaderNewsSgtype", dbparam);
							logger.debug("===== billing.zadmin.cmsbank.updateReaderNewsSgtype");
							
							// 3. tbl_cmsEA11data 에 결과 저장
							dbparam = new HashMap();
							dbparam.put("filename", filename);
							dbparam.put("cmsdate", cmsdate);
							dbparam.put("serial", serial);
							dbparam.put("result", " 0000");
							generalDAO.getSqlMapClient().update("billing.zadmin.cmsbank.updateCmsEA11data", dbparam);
							logger.debug("===== billing.zadmin.cmsbank.updateCmsEA11data");
							
							strz = "정상적으로 처리되었습니다.";
						}

						// transaction commit
						generalDAO.getSqlMapClient().getCurrentConnection().commit();
					}
					else if ( "3".equals(flag)) {		// 자동이체 해지
						// 1. tm_reader_news 테이블에 수금방법을 021 에서 방문으로 변경..
						dbparam = new HashMap();
						dbparam.put("NEWSCD", MK_NEWSPAPER_CODE);
						dbparam.put("SGTYPE", CODE_SUGM_TYPE_DIRECT_DEBIT);
						dbparam.put("READNO", readno);
						dbparam.put("SGTYPE_NEW", CODE_SUGM_TYPE_VISIT);
						generalDAO.getSqlMapClient().update("billing.zadmin.cmsbank.updateReaderNewsSgtype", dbparam);
						logger.debug("===== billing.zadmin.cmsbank.updateReaderNewsSgtype");
						
						// 2. tbl_users 테이블에 정보 update
						dbparam = new HashMap();
						dbparam.put("jikuk", jikuk);
						dbparam.put("serial", users_serial);
						dbparam.put("status", "EA99");		// 중지처리
						generalDAO.getSqlMapClient().update("billing.zadmin.cmsbank.updateTblUsers", dbparam);
						logger.debug("===== billing.zadmin.cmsbank.updateTblUsers");
						
						// 2-2. 수금테이블에 상태가 미수인 건 수금방법 수정 (박윤철)
						dbparam.put("readNo", param.getString("readno"));		    // 독자번호
						dbparam.put("agency_serial", param.getString("jikuk"));		// 지국번호
						List sugmList = generalDAO.getSqlMapClient().queryForList("reader.billingAdmin.getChgSugmTargetList", dbparam);

						for(int i=0; i<sugmList.size(); i++){
							Map cList = (Map)sugmList.get(i);
							dbparam.put("newsCd", cList.get("NEWSCD"));
							dbparam.put("yymm", cList.get("YYMM"));
							dbparam.put("seq", cList.get("SEQ"));
							
							// 02.수금 이력 생성
							generalDAO.getSqlMapClient().insert("collection.collection.insertReaderSugmHist", dbparam); //수금정보히스토리업데이트
							
							// 03.수금 방법 수정
							generalDAO.getSqlMapClient().update("reader.billingAdmin.updateReaderSugm", dbparam); //수금정보 업데이트
			
						}
						
						// 3. tbl_cmsEA11data 에 결과 저장
						dbparam = new HashMap();
						dbparam.put("filename", filename);
						dbparam.put("cmsdate", cmsdate);
						dbparam.put("serial", serial);
						dbparam.put("result", " 0000");
						generalDAO.getSqlMapClient().update("billing.zadmin.cmsbank.updateCmsEA11data", dbparam);
						logger.debug("===== billing.zadmin.cmsbank.updateCmsEA11data");
						
						strz = "정상적으로 처리되었습니다.";
						// transaction commit
						generalDAO.getSqlMapClient().getCurrentConnection().commit();
					}
				}
				catch (Exception e) {
					// transaction rollback
					generalDAO.getSqlMapClient().getCurrentConnection().rollback();
					
					strz = "정상적으로 처리되지 않았습니다.";
				}
				finally {
					// transaction end
					generalDAO.getSqlMapClient().endTransaction();
				}
			}
		}
		
		//mav.setView(new RedirectView("/billing/zadmin/cmsbank/view.do"));
		mav.setViewName("billing/zadmin/cmsbank/changeStatus");
		mav.addObject("now_menu", MENU_CODE_BILLING);
		
		mav.addObject("numid", numid);
		mav.addObject("filename", filename);
		mav.addObject("cmsdate", cmsdate);
		mav.addObject("pageNo", pageNo);
		
		mav.addObject("strz", strz);
		
		return mav;
	}
	
	
	/**
	 * EB11 로그 상태변경 (불능처리)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView changeResult(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		// param
		Param param = new HttpServletParam(request);
		int numid = param.getInt("numid", 0);
		String filename = param.getString("filename");
		String cmsdate = param.getString("cmsdate");
		int pageNo = param.getInt("pageNo", 1);			// 리스트의 몇번째 페이지인지 읽음
		String flag = param.getString("flag");			// 1: 자동이체 신청, 3: 자동이체 해지
		String jikuk = param.getString("jikuk");		// 지국번호
		String readno = param.getString("readno");		// 독자번호
		String serial = param.getString("serial");					// 파일데이터 일련번호
		String users_serial = param.getString("users_serial");		// 납부자번호
		String result = param.getString("result");		// 불능코드
		
		// mav
		ModelAndView mav = new ModelAndView();
		
		String strz = "";
		
		if ( StringUtils.isEmpty(filename) || StringUtils.isEmpty(jikuk) || StringUtils.isEmpty(serial)) {
			strz = "잘못된 파라미터입니다.";
		}
		else {
			
			if ( "1".equals(flag) || "3".equals(flag)) {
				
				try {
					// transaction start
					generalDAO.getSqlMapClient().startTransaction();					
					generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
					
					// 1. tbl_cmsEA11data 에 불능코드 저장
					Map dbparam = new HashMap();
					dbparam = new HashMap();
					dbparam.put("filename", filename);
					dbparam.put("cmsdate", cmsdate);
					dbparam.put("serial", serial);
					dbparam.put("result", "N" + result);
					generalDAO.getSqlMapClient().update("billing.zadmin.cmsbank.updateCmsEA11data", dbparam);
					logger.debug("===== billing.zadmin.cmsbank.updateCmsEA11data");
					
					// 2. tbl_users 테이블에 정보 update
					dbparam = new HashMap();
					dbparam.put("jikuk", jikuk);
					dbparam.put("serial", users_serial);
					dbparam.put("status", "EA99");		// 중지처리
					dbparam.put("levels", "9");				
					generalDAO.getSqlMapClient().update("billing.zadmin.cmsbank.updateTblUsers", dbparam);
					logger.debug("===== billing.zadmin.cmsbank.updateTblUsers");
					
					strz = "정상적으로 처리되었습니다.";
					// transaction commit
					generalDAO.getSqlMapClient().getCurrentConnection().commit();
				}
				catch (Exception e) {
					// transaction rollback
					generalDAO.getSqlMapClient().getCurrentConnection().rollback();
					
					strz = "정상적으로 처리되지 않았습니다.";
				}
				finally {
					// transaction end
					generalDAO.getSqlMapClient().endTransaction();
				}
			}
			else {
				strz = "잘못된 정보입니다.";
			}
		}
		
		//mav.setView(new RedirectView("/billing/zadmin/cmsbank/view.do"));
		mav.setViewName("billing/zadmin/cmsbank/changeResult");
		mav.addObject("now_menu", MENU_CODE_BILLING);
		
		mav.addObject("numid", numid);
		mav.addObject("filename", filename);
		mav.addObject("cmsdate", cmsdate);
		mav.addObject("pageNo", pageNo);
		
		mav.addObject("strz", strz);
		
		return mav;
	}
	
	
	/**
	 * 이체신청결과 (EB12) 파일생성
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView process12b(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		int pagesize = 40;
		int conternp = 10;
		//String idid = "tbl_cmsEA14data_log";
		String thisorder = "";
		String orderby = "";
		
		// param
		Param param = new HttpServletParam(request);
		String ccode = MK_COMPANY_CODE;
		String eanum = "EB12";
		int numid = param.getInt("numid", 0);
		String filename = param.getString("filename");
		String cmsdate = param.getString("cmsdate");
		int pageNo = param.getInt("pageNo", 1);			// 리스트의 몇번째 페이지인지 읽음
		
		
		// 현재날짜 (yyyymmdd)
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		String nowDate = df.format(cal.getTime());
		
		String rdate = nowDate.substring(2, 4) + filename.substring(4);
		String fdate = rdate;
		
		int errorch = 0;
		String error_str = "";
		String err_total_str = "";

		int good_c = 0;
		int erro_c = 0;
		int count = 0;

		String header_str = "";
		String data_str = "";
		String trailer_str = "";
		
		// mav
		ModelAndView mav = new ModelAndView();
		
		
		// db query parameter		
		HashMap dbparam = new HashMap();
		dbparam.put("filename", filename);
		dbparam.put("cmsdate", cmsdate);
		
		int ea11cnt = (Integer) generalDAO.queryForObject("billing.zadmin.cmsbank.getCmsEA11DataCount", dbparam);
		logger.debug("===== billing.zadmin.cmsbank.getCmsEA11DataCount");
		
		try {
			// transaction start
			generalDAO.getSqlMapClient().startTransaction();					
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
		
			if ( ea11cnt != 0 ) {	// 체크되지 않은 값이 존재할 때
				error_str = "체크되지 않은 값이 존재합니다.";
			}
			else {
				
				// Header Record 생성
				String fileDate = "";
				if ( rdate.length() > 4 ) {
					fileDate = rdate.substring(rdate.length()-4);
				}
				
				header_str = 	CODE_CMS_LAYOUT_HEADER					// (1) Record 구분(Header Record 식별부호 "H")
									+ "00000000"						// (8) 일련번호 ("00000000" 고정값)
									+ ccode								// (10) 기관번호 (이용기관식별번호)
									+ eanum + filename.substring(4,8)	// (8) File 이름 (EB11,EB12,EB13,EB14MMDD)
									+ nowDate.substring(2, 4) + filename.substring(4,8)			// (6) 신청접수일자 ("YYMMDD", File 이름과 동일한 날짜)
									;
				
				for ( int i = 0; i < 87; i++ ) {
					header_str += " ";
				}
				
				if ( StringUtils.isEmpty(header_str) || header_str.length() != 120 ) {
					errorch = 1;
					error_str = " 헤더값 길이 오류";
				}
				
				// Tailer data를 위한 Data Record 사용 변수 정의
				int serialno =0;
				int total_rec = 0;
				int type1 = 0;
				int type2 = 0;
				int type3 = 0;
				int type7 = 0;
				
				String tmp = "";
				
				
				// Data Record 생성
				dbparam = new HashMap();
				dbparam.put("filename", filename);
				dbparam.put("cmsdate", cmsdate);
				
				List resultList = generalDAO.getSqlMapClient().queryForList("billing.zadmin.cmsbank.getCmsEA11DataList", dbparam);
				
				if ( resultList != null && resultList.size() > 0 ) {
					
					BigDecimal serial = null;
					String result = "";
					String r_date = "";
					String whostep = "";
					String number = "";
					String bank_code = "";
					String bank_numb = "";
					String bank_jumin = "";
					String c_code = "";
					
					Iterator iter = resultList.iterator();
					int index = 1;
					while ( iter.hasNext() ) {
						Map resultMap = (Map) iter.next();
						
						serial = (BigDecimal)resultMap.get("SERIAL");
						result = (String)resultMap.get("RESULT");
						r_date = (String)resultMap.get("RDATE");
						whostep = (String)resultMap.get("TYPE");
						number = (String)resultMap.get("NUMBER_");
						bank_code = (String)resultMap.get("BANK_CODE");
						bank_numb = (String)resultMap.get("BANK_NUMB");
						bank_jumin = (String)resultMap.get("BANK_JUMIN");
						c_code = (String)resultMap.get("CCODE");
						
						String temp_str = "";
						if ( !"N0000".equals(result.trim()) && !"0000".equals(result.trim()) ) {
							
							temp_str = "R";								// (1) Record 구분
							tmp = "00000000" + index;
							temp_str += tmp.substring(tmp.length()-8);	// (8) 일련번호
							temp_str += ccode;							// (10)기관코드
							
							if ( "1".equals(whostep) ) {
								type1++;
								whostep = "1";
							}
							else if ( "2".equals(whostep) ) {
								type2++;
								whostep = "1";
							}
							else if ( "3".equals(whostep) ) {
								type3++;
								whostep = "3";
							}
							else if ( "7".equals(whostep) ) {
								type7++;
								whostep = "7";
							}
							
							temp_str += r_date;				// (6) 신청일자
							temp_str += whostep;			// (1) 신청구분(여기서는 일단 신청만 다룸, 1로 세팅)
							temp_str += number;				// (20)납부자번호
							temp_str += bank_code;			// (7) 은행점코드
							temp_str += bank_numb;			// (16)지정출금계좌번호
							temp_str += bank_jumin;			// (16)주민등록번호 또는 사업자등록번호
							temp_str += c_code;				// (4) 취급점코드
							temp_str += "  ";				// (2) 자금종류
							temp_str += result;				// (5) 처리결과
							
							for ( int i = temp_str.length(); i < 120; i++ ) {	// (24)FILLER
								temp_str += " ";
							}
							
							count++;
							data_str = data_str + temp_str;
							index++;
						}
						else {
							temp_str = "";
							for ( int i = 0; i < 120; i++ ) {
								temp_str += " ";
							}
						}
						
						if ( temp_str.length() != 120 ) {
							errorch = 1;
							error_str = error_str + " 데이터 레코드 " + serial + " 길이 오류";
						}
						else {
	
							// tbl_ea_log 테이블에 저장
							dbparam = new HashMap();						
							tmp = "00000000" + serialno;
							dbparam.put("serialno", tmp.substring(tmp.length()-8));
							dbparam.put("filename", eanum + rdate.substring(2, 6));
							dbparam.put("cmstype", "EA13");
							dbparam.put("cmsdate", fdate);
							dbparam.put("cmsresult", "EEEEE");
							dbparam.put("userid", "");
							dbparam.put("usernumid", "");
							generalDAO.getSqlMapClient().insert("billing.zadmin.cmsrequest.insertEALog", dbparam);
							logger.debug("===== billing.zadmin.cmsrequest.insertEALog");
						}
						
					}
				}
				// Data Record 생성 끝
	
	
				// Trailer Record 생성 
				trailer_str = "";
				trailer_str += CODE_CMS_LAYOUT_TRAILER;	// Record 구분(1)
				trailer_str += "99999999";								// 일련번호(8) - 고정값, "99999999"
				trailer_str += ccode;									// 기관코드(10)
				trailer_str += eanum + rdate.substring(2, 6);			// File 이름(8)
				int totalCount = type1+type3+type7;
				tmp = "00000000" + totalCount;
				trailer_str += tmp.substring(tmp.length()-8);			// 총 Data Record 수(8)
				tmp = "00000000" + type1;
				trailer_str += tmp.substring(tmp.length()-8);			// 신규등록(8)
				trailer_str += "00000000";  							// 변경등록(8) (변경은 "00000000")
				tmp = "00000000" + type3;
				trailer_str += tmp.substring(tmp.length()-8);			// 해지등록(8)
				tmp = "00000000" + type7;
				trailer_str += tmp.substring(tmp.length()-8);			// 임의해지(8)
				
				for ( int i = 0; i < 43; i++ ) {
					trailer_str += " ";
				}
				
				for ( int i = 0; i < 10; i++ ) {
					trailer_str += " ";
				}
				
				if ( trailer_str.length() != 120 ) {
					errorch = 1;
					error_str = error_str + " Tailer 레코드 길이 오류";
				}
			
				// Tailer Record 생성 끝
	
				// 전체 Record 연결
				String text = header_str + data_str + trailer_str;
				
				// 파일생성
				if ( count != 0 && StringUtils.isNotEmpty(text) ) {
					
					Calendar now = Calendar.getInstance();
					String year = Integer.toString(now.get(Calendar.YEAR));
					
					FileUtil.saveTxtFile(
							PATH_UPLOAD_RELATIVE_CMS_EB12 + "/" + year.substring(0, 2) + rdate.substring(0, 2), 
							"EB12" + rdate.substring(2, 6), 
							text,
							ENCODING_TYPE_CMS
						);
					
					// DB에 기록				
					HttpSession session = request.getSession();
					
					dbparam = new HashMap();
					dbparam.put("memo", text);
					dbparam.put("err_str", err_total_str);					
					dbparam.put("adminid", session.getAttribute(SESSION_NAME_ADMIN_USERID));
					generalDAO.getSqlMapClient().insert("billing.zadmin.cmsbank.insertEB12Log", dbparam);
					logger.debug("===== billing.zadmin.cmsbank.insertEB12Log");

					// 파일생성으로 연것에 파일로 씀
					if ( errorch == 0 ) {
						error_str = "정상출력";
						
						// transaction commit
						generalDAO.getSqlMapClient().getCurrentConnection().commit();
					}
					
					mav.addObject("header_str", header_str);
					mav.addObject("header_str_len", header_str.length());
					mav.addObject("fname", eanum + rdate.substring(2, 6));
				}
				else {
					// transaction rollback
					generalDAO.getSqlMapClient().getCurrentConnection().rollback();
					
					error_str = "파일생성할 데이터가 없습니다.";
				}
			}
		}
		catch (Exception e) {
			// transaction rollback
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			
			error_str = "정상적으로 처리되지 않았습니다.";
		}
		finally {
			
			// transaction end
			generalDAO.getSqlMapClient().endTransaction();
		}
		
		mav.setViewName("billing/zadmin/cmsbank/process12b");
		mav.addObject("now_menu", MENU_CODE_BILLING);
		mav.addObject("show_hidden3", "display");
		
		mav.addObject("numid", numid);
		mav.addObject("filename", filename);
		mav.addObject("cmsdate", cmsdate);
		mav.addObject("pageNo", pageNo);
		
		mav.addObject("error_str", error_str);
		
		return mav;
	}
	
	
	/**
	 * 이체신청결과 (EB12) 목록
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index12(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		int pagesize = 40;
		
		// param
		Param param = new HttpServletParam(request);
		int pageNo = param.getInt("pageNo", 1);			// 리스트의 몇번째 페이지인지 읽음
		
		// db query parameter		
		HashMap dbparam = new HashMap();
		dbparam.put("PAGE_NO", pageNo);
		dbparam.put("PAGE_SIZE", pagesize);
		
		// excute query
		List resultList = generalDAO.queryForList("billing.zadmin.cmsbank.getEB12LogList", dbparam);
		logger.debug("===== billing.zadmin.cmsbank.getEB12LogList");
		
		int t_count = (Integer) generalDAO.queryForObject("billing.zadmin.cmsbank.getEB12LogCount");
		logger.debug("===== billing.zadmin.cmsbank.getEB12LogCount");
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("billing/zadmin/cmsbank/index12");
		mav.addObject("now_menu", MENU_CODE_BILLING);
		mav.addObject("show_hidden3", "display");
		
		mav.addObject("pageNo", pageNo);
		
		mav.addObject("resultList", resultList);
		mav.addObject("t_count", t_count);
		mav.addObject("pageInfo", Paging.getPageMap(pageNo, t_count, pagesize, 10));
		
		return mav;
	}
	
	
	/**
	 * 이체신청 (EB13) 상세
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView view12(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
				
		// param
		Param param = new HttpServletParam(request);
		String numid = param.getString("numid");
		String fname = param.getString("fname");
		
		// db query parameter		
		HashMap dbparam = new HashMap();
		dbparam.put("numid", numid);
		
		Map resultMap = (Map) generalDAO.queryForObject("billing.zadmin.cmsbank.getEB12LogInfo", dbparam);
		logger.debug("===== billing.zadmin.cmsbank.getEB12LogInfo");

		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("billing/zadmin/cmsbank/view12");
		mav.addObject("now_menu", MENU_CODE_BILLING);

		mav.addObject("resultMap", resultMap);
		mav.addObject("fname", fname);
		
		return mav;
	}
	
	
	/**
	 * 이체신청(EB13) 에러목록
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView err12(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		// param
		Param param = new HttpServletParam(request);
		int numid = param.getInt("numid");
		String filename = param.getString("filename");
		
		
		// db query parameter		
		HashMap dbparam = new HashMap();
		dbparam.put("numid", numid);
		
		Map resultMap = (Map) generalDAO.queryForObject("billing.zadmin.cmsbank.getEB12LogInfo", dbparam);
		logger.debug("===== billing.zadmin.cmsbank.getEB12LogInfo");
		
		List resultList = new ArrayList();
		if ( resultMap != null ) {
			String err_str = (String) resultMap.get("ERR_STR");
			
			if ( StringUtils.isNotEmpty(err_str)) {
				String[] errArr = err_str.split("\n");
				
				for ( int i = 0; i < errArr.length; i++ ) {
					String tmpStr = errArr[i];
					
					String num = tmpStr.substring(0, tmpStr.indexOf(":")-1);
					String errmsg = tmpStr.substring(tmpStr.indexOf(":")+1);
					
					dbparam = new HashMap();
					dbparam.put("numid", numid);
					Map userMap = (Map) generalDAO.queryForObject("billing.zadmin.cmsrequest.getUserInfo", dbparam);
					
					String jikuk = "";
					String serial = "";
					String username = "정보없음";
					String readno = "";
					
					if ( userMap != null ) { 
						jikuk = (String) userMap.get("JIKUK");
						serial = (String) userMap.get("SERIAL");
						username = (String) userMap.get("USERNAME");
					}
					
					Map tmpMap = new HashMap();
					tmpMap.put("NUM", num);
					tmpMap.put("SERIAL", jikuk + serial);
					tmpMap.put("USERNAME", username);
					tmpMap.put("READNO", readno);
					tmpMap.put("ERRMSG", errmsg);
					
					resultList.add(tmpMap);
				}
			}
		}
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("billing/zadmin/cmsbank/err12");
		mav.addObject("now_menu", MENU_CODE_BILLING);
		mav.addObject("show_hidden3", "display");
		
		mav.addObject("resultList", resultList);
		mav.addObject("filename", filename);
		
		return mav;
	}
	
}
