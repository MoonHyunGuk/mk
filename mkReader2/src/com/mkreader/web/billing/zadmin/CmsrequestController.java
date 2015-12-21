/*------------------------------------------------------------------------------
 * NAME : CmsrequestController 
 * DESC : 자동이체(일반) - 이체신청/신청결과
 * Author : shlee
 *----------------------------------------------------------------------------*/
package com.mkreader.web.billing.zadmin;

import java.io.File;
import java.io.FileInputStream;
import java.math.BigDecimal;
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
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.CommonUtil;
import com.mkreader.util.DateUtil;
import com.mkreader.util.FileUtil;
import com.mkreader.util.Paging;



public class CmsrequestController extends MultiActionController implements
		ISiteConstant {
	
	public static Logger logger = Logger.getRootLogger();

	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {

		this.generalDAO = generalDAO;
	}
	
	
	/**
	 * 자동이체 메뉴 메인
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView main(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("billing/zadmin/cmsrequest/main");
		mav.addObject("now_menu", MENU_CODE_BILLING);
		return mav;
	}
	
	/**
	 * 이체신청(EB13) 목록
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index13(HttpServletRequest request,
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
		List resultList = generalDAO.queryForList("billing.zadmin.cmsrequest.getEB13LogList", dbparam);
		logger.debug("===== billing.zadmin.cmsrequest.getEB13LogList");
		
		int t_count = (Integer) generalDAO.queryForObject("billing.zadmin.cmsrequest.getEB13LogCount");
		logger.debug("===== billing.zadmin.cmsrequest.getEB13LogCount");
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("billing/zadmin/cmsrequest/index13");
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
	public ModelAndView view13(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
				
		// param
		Param param = new HttpServletParam(request);
		String numid = param.getString("numid");
		String fname = param.getString("fname");
		
		// db query parameter		
		HashMap dbparam = new HashMap();
		dbparam.put("numid", numid);
		
		Map resultMap = (Map) generalDAO.queryForObject("billing.zadmin.cmsrequest.getEB13LogInfo", dbparam);
		logger.debug("===== billing.zadmin.cmsrequest.getEB13LogInfo");

		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("billing/zadmin/cmsrequest/view13");
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
	public ModelAndView err13(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		// param
		Param param = new HttpServletParam(request);
		int numid = param.getInt("numid");
		String filename = param.getString("filename");
		
		
		// db query parameter		
		HashMap dbparam = new HashMap();
		dbparam.put("numid", numid);
		
		Map resultMap = (Map) generalDAO.queryForObject("billing.zadmin.cmsrequest.getEB13LogInfo", dbparam);
		logger.debug("===== billing.zadmin.cmsrequest.getEB13LogInfo");
		
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
					dbparam.put("numid", Integer.parseInt(num.trim()));
					Map userMap = (Map) generalDAO.queryForObject("billing.zadmin.cmsrequest.getUserInfo", dbparam);
					
					String jikuk = "";
					String serial = "";
					String username = "정보없음";
					String readno = "";
					
					if ( userMap != null ) {
						jikuk = (String) userMap.get("JIKUK");
						serial = (String) userMap.get("SERIAL");
						username = (String) userMap.get("USERNAME");
						readno = (String) userMap.get("READNO");
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
		mav.setViewName("billing/zadmin/cmsrequest/err13");
		mav.addObject("now_menu", MENU_CODE_BILLING);
		mav.addObject("show_hidden3", "display");
		
		mav.addObject("resultList", resultList);
		mav.addObject("filename", filename);
		
		return mav;
	}
	
	
	/**
	 * 이체신청 (EB13) 파일생성
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView process13b(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		int pagesize = 40;
		int conternp = 10;
		//String idid = "tbl_cmsEA14data_log";
		String thisorder = "";
		String orderby = "";
		
		// param
		Param param = new HttpServletParam(request);
		String ccode = param.getString("ccode");
		String eanum = param.getString("eanum");
		String rdate = param.getString("rdate");
		
		//ccode="9922113081";
		//eanum="EA13";
		//rdate="070507";
		
		String fdate = rdate;
		
		int errorch = 0;
		String error_str = "";
		String err_total_str = "";

		int good_c = 0;		// 정상출력건(신청)
		int good_h = 0;		// 정상출력건(해지) 
		int erro_c = 0;		// 출력에러건(신청)
		int erro_h = 0;		// 출력에러건(해지)

		String header_str = "";
		String data_str = "";
		String trailer_str = "";
		
		// mav
		ModelAndView mav = new ModelAndView();
		
		
		// db query parameter		
		HashMap dbparam = new HashMap();
		dbparam.put("fdate", fdate);
		
		Map existMap = (Map) generalDAO.queryForObject("billing.zadmin.cmsrequest.getExistEB13Log", dbparam);
		logger.debug("===== billing.zadmin.cmsrequest.getExistEB13Log");
		
		if ( existMap != null ) {	// 오늘 생성된 파일이 없을 때 생성가능.
			mav.setViewName("common/message");
			mav.addObject("message", "오늘 날짜의 데이타가 존재합니다 하루에 한건만 입력이 가능합니다.");
			mav.addObject("returnURL", "/billing/zadmin/cmsrequest/index13.do");
			return mav;
		}
		else {

			// Header Record 생성
			String fileDate = "";
			if ( rdate.length() > 4 ) {
				fileDate = rdate.substring(rdate.length()-4);
			}
			
			header_str = 	CODE_CMS_LAYOUT_HEADER	// (1) Record 구분(Header Record 식별부호 "H")
								+ "00000000"						// (8) 일련번호 ("00000000" 고정값)
								+ ccode								// (10) 기관번호 (이용기관식별번호)
								+ eanum + fileDate					// (8) File 이름 (EB11,EB12,EB13,EB14MMDD)
								+ rdate								// (6) 신청접수일자 ("YYMMDD", File 이름과 동일한 날짜)
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
			
			// type1
			// Data Record 생성 - DB로 부터 추출
			// 신청 부분에 대해서만... 해지신청 따로 처리
			
			try {
				// transaction start
				generalDAO.getSqlMapClient().startTransaction();					
				generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
				// 신청오류를 신청으로 전환
				dbparam = new HashMap();
				dbparam.put("STATUS_NEW", "EA00");
				dbparam.put("STATUS_OLD", "EA14");		// 중지요청하지 않은 오류
				generalDAO.getSqlMapClient().update("billing.zadmin.cmsrequest.updateUsersStatus", dbparam);
				logger.debug("===== billing.zadmin.cmsrequest.updateUsersStatus");
				
				// 해지오류를 해지신청으로 전환 (주석처리 해제 2012.06.21 박윤철)
				
				dbparam = new HashMap();
				dbparam.put("STATUS_NEW", "EA13-");
				dbparam.put("STATUS_OLD", "EA14-");		// 중지요청한 자료
				generalDAO.getSqlMapClient().update("billing.zadmin.cmsrequest.updateUsersStatus", dbparam);
				logger.debug("===== billing.zadmin.cmsrequest.updateUsersStatus");
	
			
				dbparam = new HashMap();
				dbparam.put("STATUS", "EA00");		// 추출조건 ( 이전에 정상신청되었으면 pass )
				dbparam.put("LEVELS", "3");			// 1:오류, 2:일시중지, 3:정상
				List resultList = generalDAO.getSqlMapClient().queryForList("billing.zadmin.cmsrequest.getUserList", dbparam);
				logger.debug("===== billing.zadmin.cmsrequest.getUserList");
				
				if ( resultList != null && resultList.size() > 0 ) {
					Iterator iter = resultList.iterator();
					
					while ( iter.hasNext() ) {
						Map resultMap = (Map) iter.next();
						
						BigDecimal numid = (BigDecimal) resultMap.get("NUMID");
						String jikuk = (String) resultMap.get("JIKUK");
						String serial = (String) resultMap.get("SERIAL");
						String saup = (String) resultMap.get("SAUP");
						String bank = (String) resultMap.get("BANK");
						String bank_num = (String) resultMap.get("BANK_NUM");
						//String whostep = (String) resultMap.get("WHOSTEP");
						//String r_date = (String) resultMap.get("RDATE");
						//String r_out_date = (String) resultMap.get("R_OUT_DATE");
						String userid = (String) resultMap.get("USERID");
						
						
						String naknum = jikuk + serial;
						String err_13_str = "";
						
						if ( StringUtils.isEmpty(naknum) || StringUtils.isEmpty(serial)) {
							err_13_str = "사용자 번호와 지국이 잘못되었습니다.";
						} else if (naknum.length() != 11) { 
							err_13_str = "사용자 번호와 지국이 잘못되었습니다.";
						}
						
						if (StringUtils.isEmpty(saup) || saup.length() < 6) {
							err_13_str = "구독자 통장 가입자 식별번호가 올바르지 않습니다.";
						}
						
						if ( StringUtils.isEmpty(err_13_str)) {
							good_c++;
							
							int naknumlen = 0;
							if ( StringUtils.isNotEmpty(naknum) ) {
								naknumlen = naknum.length();
							}
							for ( int i = naknumlen; i < 20; i++ ) {
								naknum += " ";
							}
		
							String gubun = saup;
							int gubunlen = 0;
							if ( StringUtils.isNotEmpty(gubun) && !"null".equals(gubun) ) {
								gubunlen = gubun.length();
							}
							for ( int i = gubunlen; i < 16; i++ ) {
								gubun += " ";
							}
		
							
							// Data Record 생성
							String temp_str = "";
							String tmp = "";
							
							// 1. Record 구분(1)
							temp_str += CODE_CMS_LAYOUT_DATA;
							
							// 2. Data 일련번호(8)
							serialno++;
							tmp = "0000000" + serialno;
							temp_str += tmp.substring(tmp.length()-8);
							
							// 3. 기관코드(10)
							temp_str += ccode;
		
							// 4. 신청일자(6) - YYMMDD
							temp_str += rdate;
							
							// 5. 신청구분(1) (여기서는 일단 신청만 다룸)
							temp_str += CODE_CMS_REQ_TYPE_NEW;
							
							// 6. 납부자번호(20) (위에서 20yte로 맞췄음)
							temp_str += naknum;
								
							// 7. 은행점코드(7) (회원관리시 은행지정하면 자동으로 세팅)
							if ( StringUtils.isNotEmpty(bank) ) {
								if ( bank.trim().length() == 6 ) {
									bank = bank.trim() + "0";
								}
								tmp = "0000000" + bank.trim();
							}
							else {
								tmp = "0000000";
							}
							
							tmp = tmp.substring(tmp.length()-7);
							temp_str += tmp;
							
							// 8. 지정출금계좌번호(16) (회원 직접 입력 - 빼고)
							if ( StringUtils.isNotEmpty(bank_num) ) {
								temp_str += bank_num;
								for ( int i = bank_num.length(); i < 16; i++ ) {
									temp_str += " ";
								}
							}
							else {
								for ( int i = 0; i < 16; i++ ) {
									temp_str += " ";
								}
							}
							
							// 9. 주민등록번호나 사업자등록번호(16)
							temp_str += gubun;
							
							// 10. 취급점 코드(4) (EB11 - 신청서접수점코드, EB13 - SPACE)
							for ( int i = 0; i < 4; i++ ) {
								temp_str += " ";
							}
							
							// 11. 자금종류(2) (사용하지 않으면 공백)
							for ( int i = 0; i < 2; i++ ) {
								temp_str += " ";
							}
							
							// 12. 처리결과(5)
							for ( int i = 0; i < 5; i++ ) {
								temp_str += " ";
							}
							
							// 13. filler(1)
							for ( int i = 0; i < 1; i++ ) {
								temp_str += " ";
							}
							
							// 14. 전화번호(12)
							for ( int i = 0; i < 12; i++ ) {
								temp_str += " ";
							}
							
							// 15. filler(11)
							for ( int i = 0; i < 11; i++ ) {
								temp_str += " ";
							}
							
							type1++;
							
							data_str += temp_str;
		
							if ( temp_str.length() != 120 ) {
								errorch = 1;
								error_str += "데이터 레코드 " + serialno + " 길이 오류";
							} else {
								
								dbparam = new HashMap();
								
								tmp = "0000000" + serialno;
								dbparam.put("serialno", tmp.substring(tmp.length()-8));
								dbparam.put("filename", eanum + rdate.substring(2, 6));
								dbparam.put("cmstype", "EA13+");
								dbparam.put("cmsdate", fdate);
								dbparam.put("cmsresult", "EEEEE");
								dbparam.put("userid", userid);
								dbparam.put("usernumid", numid);
								dbparam.put("codenum", naknum);
								generalDAO.getSqlMapClient().insert("billing.zadmin.cmsrequest.insertEALog", dbparam);
								logger.debug("===== billing.zadmin.cmsrequest.insertEALog");
								
								dbparam = new HashMap();
								dbparam.put("STATUS", "EA13");
								dbparam.put("numid", numid);
								generalDAO.getSqlMapClient().update("billing.zadmin.cmsrequest.updateUsersStatus2", dbparam);
								logger.debug("===== billing.zadmin.cmsrequest.updateUsersStatus2");
							}
						} else {
							erro_c++;
							err_total_str = err_total_str + numid + " : " + err_13_str + "\n";
						}
					}
				}
				
				// type1
				// Data Record 생성 - DB로 부터 추출
				// 해지신청 부분에 처리 (주석처리 해제 2012.06.21 박윤철)
				dbparam = new HashMap();
				dbparam.put("STATUS", "EA13-");		// 추출조건 ( 이전에 정상신청되었으면 pass )
				dbparam.put("LEVELS", "3");			// 1:오류, 2:일시중지, 3:정상
				resultList = generalDAO.getSqlMapClient().queryForList("billing.zadmin.cmsrequest.getUserList2", dbparam);
				logger.debug("===== billing.zadmin.cmsrequest.getUserList2");
				
				if ( resultList != null && resultList.size() > 0 ) {
					Iterator iter = resultList.iterator();
					
					while ( iter.hasNext() ) {
						Map resultMap = (Map) iter.next();
						
						BigDecimal numid = (BigDecimal) resultMap.get("NUMID");
						String jikuk = (String) resultMap.get("JIKUK");
						String serial = (String) resultMap.get("SERIAL");
						String saup = (String) resultMap.get("SAUP");
						String bank = (String) resultMap.get("BANK");
						String bank_num = (String) resultMap.get("BANK_NUM");
						//String whostep = (String) resultMap.get("WHOSTEP");
						//String r_date = (String) resultMap.get("RDATE");
						//String r_out_date = (String) resultMap.get("R_OUT_DATE");
						String userid = (String) resultMap.get("USERID");
						
						String naknum = jikuk + serial;
						int naknumlen = 0;
						if ( StringUtils.isNotEmpty(naknum) ) {
							naknumlen = naknum.length();
						}
						for ( int i = naknumlen; i < 20; i++ ) {
							naknum += " ";
						}
	
						String gubun = saup;
						int gubunlen = 0;
						if ( StringUtils.isNotEmpty(gubun) && !"null".equals(gubun) ) {
							gubunlen = gubun.length();
						}
						for ( int i = gubunlen; i < 16; i++ ) {
							gubun += " ";
						}
						
						// Data Record 생성
						String temp_str = "";
						String tmp = "";
	
						// 1. Record 구분(1)
						temp_str = CODE_CMS_LAYOUT_DATA;
							
						// 2. Data 일련번호(8)
						serialno++;
						tmp = "0000000" + serialno;
						temp_str += tmp.substring(tmp.length()-8);
							
						// 3. 기관코드(10)
						temp_str += ccode;
						
						// 4. 신청일자(6) - YYMMDD
						temp_str += rdate;
						
						// 5. 신청구분(1) (여기서는 해지만 다룸)
						temp_str += CODE_CMS_REQ_TYPE_CANCEL;
						
						// 6.  납부자번호(20) (위에서 20yte로 맞췄음)
						temp_str += naknum;
						
						// 7. 은행점코드(7) (회원관리시 은행지정하면 자동으로 세팅)
						if ( StringUtils.isNotEmpty(bank) ) {
							if ( bank.trim().length() == 6 ) {
								bank = bank.trim() + "0";
							}
							tmp = "0000000" + bank.trim();
						}
						else {
							tmp = "0000000";
						}
						tmp = tmp.substring(tmp.length()-7);
						temp_str += tmp;
						
						// 8. 지정출금계좌번호(16) (회원 직접 입력 - 빼고)
						if ( StringUtils.isNotEmpty(bank_num) ) {
							temp_str += bank_num;
							for ( int i = bank_num.length(); i < 16; i++ ) {
								temp_str += " ";
							}
						}
						else {
							for ( int i = 0; i < 16; i++ ) {
								temp_str += " ";
							}
						}
						
						// 9. 주민등록번호나 사업자등록번호(16)
						temp_str += gubun;
						
						// 10. 취급점 코드(4) (EB11 - 신청서접수점코드, EB13 - SPACE)
						for ( int i = 0; i < 4; i++ ) {
							temp_str += " ";
						}
						
						// 11. 자금종류(2) (사용하지 않으면 공백)
						for ( int i = 0; i < 2; i++ ) {
							temp_str += " ";
						}
						
						// 12. 처리결과(5)
						for ( int i = 0; i < 5; i++ ) {
							temp_str += " ";
						}
						
						// 13. filler(1)
						for ( int i = 0; i < 1; i++ ) {
							temp_str += " ";
						}
						
						// 14. 전화번호(12)
						for ( int i = 0; i < 12; i++ ) {
							temp_str += " ";
						}
						
						// 15. filler(11)
						for ( int i = 0; i < 11; i++ ) {
							temp_str += " ";
						}
						
						type3++;
						
						data_str += temp_str;
						
						if ( temp_str.length() != 120 ) {
							erro_h++;
							errorch = 1;
							error_str += "데이터 레코드 " + serialno + " 길이 오류";
						} else {
							good_h++;
							dbparam = new HashMap();
							
							tmp = "0000000" + serialno;
							dbparam.put("serialno", tmp.substring(tmp.length()-8));
							dbparam.put("filename", eanum + rdate.substring(2, 6));
							dbparam.put("cmstype", "EA13-");
							dbparam.put("cmsdate", fdate);
							dbparam.put("cmsresult", "EEEEE");
							dbparam.put("userid", userid);
							dbparam.put("usernumid", numid);
							dbparam.put("codenum", naknum);
							dbparam.put("rdate", rdate);
							generalDAO.getSqlMapClient().insert("billing.zadmin.cmsrequest.insertEALog", dbparam);
							logger.debug("===== billing.zadmin.cmsrequest.insertEALog");
						}
					}
				}
				
				// Data Record 생성 끝 - DB로 부터 추출
				String tmp = "";
	
				// Trailer Record 생성 
				trailer_str = "";
				trailer_str += CODE_CMS_LAYOUT_TRAILER;	// Record 구분(1)
				trailer_str += "99999999";								// 일련번호(8) - 고정값, "99999999"
				trailer_str += ccode;									// 기관코드(10)
				trailer_str += eanum + rdate.substring(2, 6);			// File 이름(8)
				tmp = "00000000" + serialno;
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
				if ( StringUtils.isNotEmpty(text) ) {
					
					Calendar now = Calendar.getInstance();
					String year = Integer.toString(now.get(Calendar.YEAR));
					
					
					try {
						System.out.println(PATH_UPLOAD_RELATIVE_CMS_EB13);
						FileUtil.saveTxtFile(
								PATH_UPLOAD_RELATIVE_CMS_EB13 + "/" + year.substring(0, 2) + rdate.substring(0, 2), 
								"EB13" + rdate.substring(2, 6), 
								text,
								"MS949"
							);
					} catch(Exception e) {
						mav.setViewName("common/message");
						mav.addObject("message", "파일생성 실패");
						mav.addObject("returnURL", "/billing/zadmin/cmsrequest/index13.do");
						return mav;
					}
				}
				else {
					mav.setViewName("common/message");
					mav.addObject("message", "파일생성할 데이터가 없습니다.");
					mav.addObject("returnURL", "/billing/zadmin/cmsrequest/index13.do");
					return mav;
				}
				
				if ( serialno == 0 ) {
					mav.setViewName("common/message");
					mav.addObject("message", "생성될 데이터가 없습니다.");
					mav.addObject("returnURL", "/billing/zadmin/cmsrequest/index13.do");
					return mav;
				}
				else {
					
					HttpSession session = request.getSession();
					
					dbparam = new HashMap();
					dbparam.put("memo", text);
					dbparam.put("err_str", err_total_str);
					dbparam.put("adminid", session.getAttribute(SESSION_NAME_ADMIN_USERID));
					generalDAO.getSqlMapClient().insert("billing.zadmin.cmsrequest.insertEB13Log", dbparam);
					logger.debug("===== billing.zadmin.cmsrequest.insertEB13Log");
	
					// 파일생성으로 연것에 파일로 씀
					if ( errorch == 0 ) {
						error_str = "정상출력";
						
						// transaction commit
						generalDAO.getSqlMapClient().getCurrentConnection().commit();
					}
					else {
						// transaction rollback
						generalDAO.getSqlMapClient().getCurrentConnection().rollback();
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
			
			mav.setViewName("billing/zadmin/cmsrequest/process13b");
			mav.addObject("now_menu", MENU_CODE_BILLING);
			mav.addObject("show_hidden3", "display");
			
			mav.addObject("error_str", error_str);
			mav.addObject("good_c", good_c);
			mav.addObject("good_h", good_h);
			mav.addObject("erro_c", erro_c);
			mav.addObject("erro_h", erro_h);
			mav.addObject("fname", eanum + rdate.substring(2, 6));

			return mav;
		}
	}
	
	
	/**
	 * 이체신청 (EB13) 파일생성 결과
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView process13c(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		// param
		Param param = new HttpServletParam(request);
		String fname = param.getString("fname");
		
		// db query parameter		
		HashMap dbparam = new HashMap();
		
		Map resultMap = (Map) generalDAO.queryForObject("billing.zadmin.cmsrequest.getEB13LogFirstRow", dbparam);
		logger.debug("===== billing.zadmin.cmsrequest.getEB13LogFirstRow");

		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("billing/zadmin/cmsrequest/process13c");
		mav.addObject("now_menu", MENU_CODE_BILLING);
		
		mav.addObject("resultMap", resultMap);
		mav.addObject("fname", fname);
		
		return mav;
	}
	
	
	/**
	 * 이체결과(EB14) 목록
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
		//String idid = "tbl_cmsEA14data_log";
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
		dbparam.put("view", view);
		dbparam.put("view2", view2);
		dbparam.put("search_key", search_key);

		// excute query
		List resultList = generalDAO.queryForList("billing.zadmin.cmsrequest.getEB14LogList", dbparam);
		logger.debug("===== billing.zadmin.cmsrequest.getEB14LogList");
		
		int t_count = (Integer) generalDAO.queryForObject("billing.zadmin.cmsrequest.getEB14LogCount", dbparam);
		logger.debug("===== billing.zadmin.cmsrequest.getEB14LogCount");
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("billing/zadmin/cmsrequest/index");
		mav.addObject("now_menu", MENU_CODE_BILLING);
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
	 * 이체결과(EB14) 상세
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
		//String idid = "tbl_cmsEA14data_log";
		String thisorder = "";
		String orderby = "";
		
		// param
		Param param = new HttpServletParam(request);
		int pageNo = param.getInt("pageNo", 1);			// 리스트의 몇번째 페이지인지 읽음
		int numid = param.getInt("numid");
		String filename = param.getString("filename");
		String cmsdate = param.getString("cmsdate");
		String jikuk = param.getString("jikuk");
		String chbx = param.getString("chbx", "all");
		
		String EACH_filename = "EB13" + filename.substring(filename.length()-4);
		
		// db query parameter
		HashMap dbparam = new HashMap();
		dbparam.put("filename", EACH_filename);
		dbparam.put("cmsdate", cmsdate);
		int totals = (Integer) generalDAO.queryForObject("billing.zadmin.cmsrequest.getEALogCount", dbparam);
		logger.debug("===== billing.zadmin.cmsrequest.getEALogCount");
		
		dbparam = new HashMap();
		dbparam.put("filename", EACH_filename);
		dbparam.put("cmsresult", "00000");
		dbparam.put("cmstype", "EA13+");
		dbparam.put("cmsdate", cmsdate);
		int noErrnum1 = (Integer) generalDAO.queryForObject("billing.zadmin.cmsrequest.getEALogCount", dbparam);
		logger.debug("===== billing.zadmin.cmsrequest.getEALogCount");
		
		dbparam = new HashMap();
		dbparam.put("filename", EACH_filename);
		dbparam.put("cmsresult_not", "00000");
		dbparam.put("cmstype", "EA13+");
		dbparam.put("cmsdate", cmsdate);
		int Errnum1 = (Integer) generalDAO.queryForObject("billing.zadmin.cmsrequest.getEALogCount", dbparam);
		logger.debug("===== billing.zadmin.cmsrequest.getEALogCount");
		
		dbparam = new HashMap();
		dbparam.put("filename", EACH_filename);
		dbparam.put("cmsresult", "00000");
		dbparam.put("cmstype", "EA13-");
		dbparam.put("cmsdate", cmsdate);
		int noErrnum2 = (Integer) generalDAO.queryForObject("billing.zadmin.cmsrequest.getEALogCount", dbparam);
		logger.debug("===== billing.zadmin.cmsrequest.getEALogCount");
		
		dbparam = new HashMap();
		dbparam.put("filename", EACH_filename);
		dbparam.put("cmsresult_not", "00000");
		dbparam.put("cmstype", "EA13-");
		dbparam.put("cmsdate", cmsdate);
		int Errnum2 = (Integer) generalDAO.queryForObject("billing.zadmin.cmsrequest.getEALogCount", dbparam);
		logger.debug("===== billing.zadmin.cmsrequest.getEALogCount");
		
		dbparam = new HashMap();
		dbparam.put("filename", EACH_filename);
		dbparam.put("cmsdate", cmsdate);
		dbparam.put("jikuk", jikuk);
		dbparam.put("chbx", chbx);
		List resultList = generalDAO.queryForList("billing.zadmin.cmsrequest.getEALogList", dbparam);
		logger.debug("===== billing.zadmin.cmsrequest.getEALogList");
		
		List jikukList = generalDAO.queryForList("billing.zadmin.cmsrequest.getAgencyList", dbparam);

		List tmpList = new ArrayList();
		if ( resultList != null ) {
			for ( int i = 0; i < resultList.size(); i++ ) {
				Map tmpMap = (Map) resultList.get(i);
				String cmsresult = (String)tmpMap.get("CMSRESULT");
				if ( StringUtils.isNotEmpty(cmsresult) && cmsresult.length() >= 5) {
					tmpMap.put("CMSRESULTMSG", CommonUtil.err_code(cmsresult.substring(1, 5)));
				}
				tmpList.add(tmpMap);
			}
			resultList = tmpList;
		}
		
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("billing/zadmin/cmsrequest/view");
		mav.addObject("now_menu", MENU_CODE_BILLING);
		mav.addObject("show_hidden3", "display");
		
		mav.addObject("numid", numid);
		mav.addObject("filename", filename);
		mav.addObject("cmsdate", cmsdate);
		
		mav.addObject("jikuk", jikuk);
		mav.addObject("totals", totals);
		mav.addObject("noErrnum1", noErrnum1);
		mav.addObject("Errnum1", Errnum1);
		mav.addObject("noErrnum2", noErrnum2);
		mav.addObject("Errnum2", Errnum2);
		
		mav.addObject("chbx",chbx);		
		mav.addObject("jikukList", jikukList);
		mav.addObject("resultList", resultList);
		mav.addObject("pageNo", pageNo);
		
		return mav;
	}
	
	/**
	 * 이체신청결과(EB14) 엑셀출력
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 * @category 이체신청결과엑셀출력
	 */
	public ModelAndView viewExcel(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// param
		ModelAndView mav = new ModelAndView();

		HashMap dbparam = new HashMap();
		Param param = new HttpServletParam(request);
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			int pageNo = param.getInt("pageNo", 1);			// 리스트의 몇번째 페이지인지 읽음
			int numid = param.getInt("numid");
			String filename = param.getString("filename");
			String cmsdate = param.getString("cmsdate");
			String jikuk = param.getString("jikuk");
			String chbx = param.getString("chbx", "all");
			String EACH_filename = "EB13" + filename.substring(filename.length()-4);	
			
			dbparam.put("filename", EACH_filename);
			dbparam.put("cmsdate", cmsdate);
			dbparam.put("jikuk", jikuk);
			dbparam.put("chbx", chbx);
			
			List resultList = generalDAO.queryForList("billing.zadmin.cmsrequest.getEALogList", dbparam);			
	
			List tmpList = new ArrayList();
			if ( resultList != null ) {
				for ( int i = 0; i < resultList.size(); i++ ) {
					Map tmpMap = (Map) resultList.get(i);
					String cmsresult = (String)tmpMap.get("CMSRESULT");
					if ( StringUtils.isNotEmpty(cmsresult) && cmsresult.length() >= 5) {
						tmpMap.put("CMSRESULTMSG", CommonUtil.err_code(cmsresult.substring(1, 5)));
					}
					tmpList.add(tmpMap);
				}
				resultList = tmpList;
			}
			
			// mav
			mav.addObject("filename", filename);
			mav.addObject("cmsdate", cmsdate);
			mav.addObject("resultList", resultList);
			
			String fileName = "resultAplcCMS_(" + DateUtil.getCurrentDate("yyyyMMdd") + ").xls";
			//Excel response
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName); 
			response.setHeader("Content-Description", "JSP Generated Data");
			mav.setViewName("billing/zadmin/cmsrequest/viewExcel");
			
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
	 * 이체결과(EB14) db 저장
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
			mav.addObject("returnURL", "/billing/zadmin/cmsrequest/index.do");
			return mav;
		}
		else {	// 파일 첨부가 되었으면
			
			Calendar now = Calendar.getInstance();
			int year = now.get(Calendar.YEAR);
			
			
			FileUtil fileUtil = new FileUtil( getServletContext() );
			String strFile = fileUtil.saveUploadFile(
											cmsfile, 
											PATH_PHYSICAL_HOME,
											PATH_UPLOAD_ABSOLUTE_CMS_EB14 + "/" + year
										);
			
			
			if ( StringUtils.isEmpty(strFile) ) {
				mav.setViewName("common/message");
				mav.addObject("message", "파일 저장이 실패하였습니다. ");
				mav.addObject("returnURL", "/billing/zadmin/cmsrequest/index.do");
				return mav;
			}
			else if ( strFile.length() != 8 ) { 
				mav.setViewName("common/message");
				mav.addObject("message", "파일명이 잘못되었습니다.");
				mav.addObject("returnURL", "/billing/zadmin/cmsrequest/index.do");
				return mav;
			}
			else {
				// 파일 분석
				String fmt1 = strFile.substring(0, 4);
				String fmt2 = strFile.substring(4, 8);				
				
				String msg = "출금이체 내역이 아닙니다.";
				String dataproc = "";
				if ( "EB11".equals(fmt1)) {			dataproc = "신청내역";
				} else if ( "EB12".equals(fmt1)) {	dataproc = "신청결과내역불능";
				} else if ( "EB13".equals(fmt1)) {	dataproc = "신청내역";
				} else if ( "EB14".equals(fmt1)) {	dataproc = "신청결과내역";
				} else if ( "EB21".equals(fmt1)) {	dataproc = "출금이체의뢰내역";		msg = "잘못된 파일";
				} else if ( "EB22".equals(fmt1)) {	dataproc = "출금이체결과내역";		msg = "정상처리 완료";
				}
				
				if ( "EB14".equals(fmt1) ) {

					int LINE_NUM = 120;
					
					String fileName = PATH_UPLOAD_RELATIVE_CMS_EB14 + "/" + year + "/" + strFile;
					
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
									
									// 신청데이터를 일단 다 성공으로 만듦.
									dbparam = new HashMap();
									dbparam.put("cmsresult", "00000");
									dbparam.put("cmsdate", txt_date);
									dbparam.put("cmstype", "EA13");
	
									// excute query
									generalDAO.getSqlMapClient().update("billing.zadmin.cmsrequest.updateEALog", dbparam);
									logger.debug("===== billing.zadmin.cmsrequest.updateEALog");
									
									// 신청처리
									dbparam = new HashMap();
									dbparam.put("users_status", "EA21");
									dbparam.put("levels", "3");
									dbparam.put("cmsdate", txt_date);
									dbparam.put("log_status", "EA13");
	
									// excute query
									generalDAO.getSqlMapClient().update("billing.zadmin.cmsrequest.updateTblUsers", dbparam);
									logger.debug("===== billing.zadmin.cmsrequest.updateTblUsers");
	
									// 해지처리
									dbparam = new HashMap();
									dbparam.put("users_status", "EA99");
									dbparam.put("levels", "3");
									dbparam.put("cmstype", "EA13-");
									dbparam.put("cmsdate", txt_date);
									dbparam.put("log_status", "EA13-");
	
									// excute query
									generalDAO.getSqlMapClient().update("billing.zadmin.cmsrequest.updateTblUsers", dbparam);
									logger.debug("===== billing.zadmin.cmsrequest.updateTblUsers");
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
									
									// 신청데이터에서 에러 난것만 에러값을 세팅
									dbparam = new HashMap();
									dbparam.put("cmsresult", txt_result);
									dbparam.put("cmsdate", txt_date);
									dbparam.put("cmstype", "EA13");
									dbparam.put("serialno", txt_count);
	
									// excute query
									generalDAO.getSqlMapClient().update("billing.zadmin.cmsrequest.updateEALog", dbparam);
									logger.debug("===== billing.zadmin.cmsrequest.updateEALog");
	
									// 결과처리
									/*
									dbparam = new HashMap();
									dbparam.put("users_status", "EA14");
									dbparam.put("levels", "1");
									dbparam.put("rdate_result", txt_result);
									dbparam.put("cmsdate", txt_date);
									dbparam.put("log_status", "EA13");
	
									// excute query
									generalDAO.getSqlMapClient().update("billing.zadmin.cmsrequest.updateTblUsers", dbparam);
									logger.debug("===== billing.zadmin.cmsrequest.updateTblUsers");
									*/
									
									// 로그인 아이디
									HttpSession session = request.getSession();
									String adminId = (String) session.getAttribute(SESSION_NAME_ADMIN_USERID);
									
									// EB14 data 등록
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
									dbparam.put("result", txt_result);
									dbparam.put("tmp", txt_tmp);
									dbparam.put("chk_id", adminId);
	
									// excute query
									generalDAO.getSqlMapClient().insert("billing.zadmin.cmsrequest.insertCmsEA14Data", dbparam);
									logger.debug("===== billing.zadmin.cmsrequest.insertCmsEA14Data");
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
									
									// EB14 data 등록
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
									generalDAO.getSqlMapClient().insert("billing.zadmin.cmsrequest.insertCmsEA14DataResult", dbparam);
									logger.debug("===== billing.zadmin.cmsrequest.insertCmsEA14DataResult");
								}
							}
						}

						// 해지처리
						dbparam = new HashMap();
						dbparam.put("users_status", "EA99");
						dbparam.put("levels", "3");
						dbparam.put("cmsdate", txt_date);
						dbparam.put("cmstype", "EA13-");
						dbparam.put("cmsresult", "00000");
						dbparam.put("log_status", "EA13-");
	
						// excute query
						generalDAO.getSqlMapClient().update("billing.zadmin.cmsrequest.updateTblUsers", dbparam);
						logger.debug("해지처리 ===== billing.zadmin.cmsrequest.updateTblUsers");
						
						// 에러처리(신청시에만)
						dbparam = new HashMap();
						dbparam.put("users_status", "EA14");
						dbparam.put("levels", "3");
						dbparam.put("cmsdate", txt_date);
						dbparam.put("cmstype", "EA13+");
						dbparam.put("cmsresult_not", "00000");
	
						// excute query
						generalDAO.getSqlMapClient().update("billing.zadmin.cmsrequest.updateTblUsersError", dbparam);
						logger.debug("에러처리(신청시)===== billing.zadmin.cmsrequest.updateTblUsersError");
	
						// 에러처리(해지시에만)
						dbparam = new HashMap();
						dbparam.put("users_status", "EA14-");
						dbparam.put("levels", "3");
						dbparam.put("cmsdate", txt_date);
						dbparam.put("cmstype", "EA13-");
						dbparam.put("cmsresult_not", "00000");
	
						// excute query
						generalDAO.getSqlMapClient().update("billing.zadmin.cmsrequest.updateTblUsersError", dbparam);
						logger.debug("에러처리(해지시)===== billing.zadmin.cmsrequest.updateTblUsersError");
	
						// 신청처리
						dbparam = new HashMap();
						dbparam.put("users_status", "EA21");
						dbparam.put("levels", "3");
						dbparam.put("cmsdate", txt_date);
						dbparam.put("cmstype", "EA13+");
						dbparam.put("cmsresult", "00000");
						dbparam.put("log_status", "EA13");
	
						// excute query
						generalDAO.getSqlMapClient().update("billing.zadmin.cmsrequest.updateTblUsers", dbparam);
						logger.debug("신청시 ===== billing.zadmin.cmsrequest.updateTblUsers");
						
						// transaction commit
						generalDAO.getSqlMapClient().getCurrentConnection().commit();
						
						msg = "정상적으로 처리되었습니다.";
					}
					catch (Exception e) {
						// transaction rollback
						generalDAO.getSqlMapClient().getCurrentConnection().rollback();
						
						msg = "정상적으로 처리되지 않았습니다.";
					}
					finally {
						fis.close();
						
						// transaction end
						generalDAO.getSqlMapClient().endTransaction();
					}
				}
			
				mav.setViewName("billing/zadmin/cmsrequest/input_db");
				mav.addObject("now_menu", MENU_CODE_BILLING);
				
				mav.addObject("dataproc", dataproc);
				mav.addObject("msg", msg);
				//mav.addObject("area1", area1);
				//mav.addObject("idid", idid);
				return mav;
			}
		}
	}
}
