/*------------------------------------------------------------------------------
 * NAME : CmsgetController 
 * DESC : 자동이체(일반) - 이체청구/청구결과
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
import java.util.List;
import java.util.Map;
import java.util.Iterator;

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



public class CmsgetController extends MultiActionController implements
		ISiteConstant {
	
	public static Logger logger = Logger.getRootLogger();

	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {

		this.generalDAO = generalDAO;
	}
	
	
	
	/**
	 * 이체청구(EB21) 목록
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index21(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		int pagesize = 40;
		int conternp = 10;
		//String idid = "tbl_EA21_log";
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
		List resultList = generalDAO.queryForList("billing.zadmin.cmsget.getEB21LogList", dbparam);
		logger.debug("===== billing.zadmin.cmsget.getEB21LogList");
		
		int t_count = (Integer) generalDAO.queryForObject("billing.zadmin.cmsget.getEB21LogCount");
		logger.debug("===== billing.zadmin.cmsget.getEB21LogCount");
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("billing/zadmin/cmsget/index21");
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
	 * 이체청구(EB21) 상세
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView view21(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
				
		// param
		Param param = new HttpServletParam(request);
		String numid = param.getString("numid");
		String fname = param.getString("fname");
		
		// db query parameter		
		HashMap dbparam = new HashMap();
		dbparam.put("numid", numid);
		
		Map resultMap = (Map) generalDAO.queryForObject("billing.zadmin.cmsget.getEB21LogInfo", dbparam);
		logger.debug("===== billing.zadmin.cmsget.getEB21LogInfo");

		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("billing/zadmin/cmsget/view21");
		mav.addObject("now_menu", MENU_CODE_BILLING);

		mav.addObject("resultMap", resultMap);
		mav.addObject("fname", fname);
		
		return mav;
	}
	
	
	/**
	 * 이체청구(EB21) 에러목록
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView err21(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		// param
		Param param = new HttpServletParam(request);
		int numid = param.getInt("numid");
		String filename = param.getString("filename");
		
		
		// db query parameter		
		HashMap dbparam = new HashMap();
		dbparam.put("numid", numid);
		
		Map resultMap = (Map) generalDAO.queryForObject("billing.zadmin.cmsget.getEB21LogInfo", dbparam);
		logger.debug("===== billing.zadmin.cmsget.getEB21LogInfo");
		
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
					
					if ( userMap != null ) {
						jikuk = (String) userMap.get("JIKUK");
						serial = (String) userMap.get("SERIAL");
						username = (String) userMap.get("USERNAME");
					}
					
					Map tmpMap = new HashMap();
					tmpMap.put("NUM", num);
					tmpMap.put("SERIAL", jikuk + serial);
					tmpMap.put("USERNAME", username);
					tmpMap.put("ERRMSG", errmsg);
					
					resultList.add(tmpMap);
				}
			}
		}
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("billing/zadmin/cmsget/err21");
		mav.addObject("now_menu", MENU_CODE_BILLING);
		mav.addObject("show_hidden3", "display");
		
		mav.addObject("resultList", resultList);
		mav.addObject("filename", filename);
		
		return mav;
	}
	
	
	/**
	 * 이체청구 (EB21) 파일생성
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView process21b(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		// param
		Param param = new HttpServletParam(request);
		String ccode = param.getString("ccode");
		String eanum = param.getString("eanum");
		
		String cbank = param.getString("cbank");
		String cbank_num = param.getString("cbank_num");
		String rdate = param.getString("rdate");
		
		String oeanum = eanum;
		String fdate = rdate;
		
		int errorch = 0;
		String error_str = "";
		String err_total_str = "";

		int good_c = 0;
		int erro_c = 0;

		String header_str = "";
		String data_str = "";
		String trailer_str = "";
		
		
		HashMap dbparam = new HashMap();
		
		// mav
		ModelAndView mav = new ModelAndView();
		
		// 현재날짜 (yyyymmdd)
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		String nowDate = df.format(cal.getTime());
		
		// 입력된 날짜 (yyyymmdd)
		String chedckdate = nowDate.substring(0, 2) + rdate;
		
		if ( nowDate.compareTo(chedckdate) >= 0 ) {
			
			mav.setViewName("common/message");
			mav.addObject("message", "익일 이후의 날이어야 합니다.");
			mav.addObject("returnURL", "/billing/zadmin/cmsget/index21.do");
			return mav;
		}
		else {
			
			// Header Record 생성
			String fileDate = "";
			if ( rdate.length() > 4 ) {
				fileDate = rdate.substring(rdate.length()-4);
			}
			
			header_str = 	ICodeConstant.CODE_CMS_LAYOUT_HEADER	// (1) Record 구분(Header Record 식별부호 "H")
								+ "00000000"						// (8) 일련번호 ("00000000" 고정값)
								+ ccode								// (10) 기관번호 (이용기관식별번호)
								+ eanum + fileDate					// (8) File 이름 (EB11,EB12,EB13,EB14MMDD)
								+ rdate								// (6) 신청접수일자 ("YYMMDD", File 이름과 동일한 날짜)
								+ cbank								// (7) 주거래은행점코드
								+ cbank_num							// (16) 입금계좌번호 ("-"는 생략)
								;
			
			if ( cbank_num.length() < 16 ) {
				for ( int i = cbank_num.length(); i < 16; i++ ) {
					header_str += " ";
				}
			}
			for ( int i = 0; i < 94; i++ ) {
				header_str += " ";
			}
			
			if ( StringUtils.isEmpty(header_str) || header_str.length() != 150 ) {
				errorch = 1;
				error_str = " 헤더값 길이 오류";
			}
			
			// Tailer data를 위한 Data Record 사용 변수 정의
			int serialno =0;
			int total_rec = 0;
			int totalmoney = 0;
			int type1 = 0;
			int type2 = 0;
			int type3 = 0;
			int type7 = 0;
			
			List resultList = null;
			List errorList = null;
			Map resultMap = null;
			
			
			// 수금목록 추출(수금테이블 기준으로 결제방법이 자동이체이면서 미수인 건들)
			dbparam = new HashMap();
			dbparam.put("SGTYPE", CODE_SUGM_TYPE_DIRECT_DEBIT);			// 수금타입 - 자동이체
			dbparam.put("READTYPECD1", CODE_READER_TYPE_GENERAL);		// 독자타입 - 일반 
			dbparam.put("READTYPECD2", CODE_READER_TYPE_STU_BRANCH);	// 독자타입 - 학생지국
			dbparam.put("NEWSCD", MK_NEWSPAPER_CODE);					// 신문코드 - 매일경제 신문
			dbparam.put("SGBBCD", CODE_SUGM_GUBUN_NOT_COMPLETE);		// 수금방법 - 미수			
			dbparam.put("SGGBCD", CODE_SUGM_TYPE_DIRECT_DEBIT);			// 수금구분 - 자동이체

			dbparam.put("chedckdate", chedckdate.substring(0, chedckdate.length()-2));			// 수금월 (수정 박윤철 12.03.28)
			
			resultList = generalDAO.queryForList("billing.zadmin.cmsget.getSugmList", dbparam);
			logger.debug("===== billing.zadmin.cmsget.getSugmList");
			
			
			serialno = 0;
			totalmoney = 0;
			String tmp = "";
			
			try {
				// transaction start
				generalDAO.getSqlMapClient().startTransaction();					
				generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
				if ( resultList != null && resultList.size() > 0 ) {
					Iterator iter = resultList.iterator();
					
					while ( iter.hasNext() ) {
						resultMap = (Map) iter.next();
						
						BigDecimal numid = (BigDecimal) resultMap.get("NUMID");
						String jikuk = (String) resultMap.get("JIKUK");
						String serial = (String) resultMap.get("SERIAL");
						String saup = (String) resultMap.get("SAUP");
						String bank = (String) resultMap.get("BANK");
						String bank_num = (String) resultMap.get("BANK_NUM");
						//String bank_money = (String) resultMap.get("BANK_MONEY");
						BigDecimal bank_money = (BigDecimal) resultMap.get("TOTALAMT");
						//String whostep = (String) resultMap.get("WHOSTEP");
						//String r_date = (String) resultMap.get("RDATE");
						//String r_out_date = (String) resultMap.get("R_OUT_DATE");
						String logs = (String) resultMap.get("LOGS");
						String userid = (String) resultMap.get("USERID");
						String status = (String) resultMap.get("STATUS");
						String levels = (String) resultMap.get("LEVELS");
						String subsmonth = (String) resultMap.get("SUBSMONTH");		// 구독월
						String readno = (String) resultMap.get("READNO");		// 수금테이블의 독자번호
						String handy = (String) resultMap.get("HANDY");
						
						String naknum = jikuk + serial;
						String err_21_str = "";
						
						if ( StringUtils.isEmpty(bank)) {
							err_21_str = "은행코드가 없습니다.";
						} else if ( StringUtils.isEmpty(bank_num)) {
							err_21_str = "계좌번호가 없습니다.";
						} else if ( StringUtils.isEmpty(saup)) {
							err_21_str = "주민등록번호 또는 사업자등록번호가 없습니다.";
						} 
						/*
						else if ( ! "EA21".equals(status) ) {		// 자동이체를 할 수 있는 상태가 아니면 수금정보를 방문으로 변경.
							dbparam = new HashMap();
							dbparam.put("READNO", readno);
							dbparam.put("NEWSCD", MK_NEWSPAPER_CODE);
							dbparam.put("SGBBCD", CODE_SUGM_GUBUN_NOT_COMPLETE);
							dbparam.put("SGGBCD_NEW", CODE_SUGM_TYPE_VISIT);
							dbparam.put("SGGBCD_OLD", CODE_SUGM_TYPE_DIRECT_DEBIT);
							
							generalDAO.getSqlMapClient().update("billing.zadmin.cmsget.updateSugmToVisit", dbparam);
							logger.debug("===== billing.zadmin.cmsget.updateSugmToVisit");
							
							continue;	// 그냥 통과
						}else if ( ! "3".equals(levels) ) {		// 자동이체를 할 수 있는 상태가 아니면 수금정보를 방문으로 변경.
							dbparam = new HashMap();
							dbparam.put("READNO", readno);
							dbparam.put("NEWSCD", MK_NEWSPAPER_CODE);
							dbparam.put("SGBBCD", CODE_SUGM_GUBUN_NOT_COMPLETE);
							dbparam.put("SGGBCD_NEW", CODE_SUGM_TYPE_VISIT);
							dbparam.put("SGGBCD_OLD", CODE_SUGM_TYPE_DIRECT_DEBIT);
							
							generalDAO.getSqlMapClient().update("billing.zadmin.cmsget.updateSugmToVisit", dbparam);
							logger.debug("===== billing.zadmin.cmsget.updateSugmToVisit");
							
							continue;	// 그냥 통과
						}
						*/
						
						if ( StringUtils.isEmpty(err_21_str) ) {
							good_c++;
							
							for ( int i = naknum.length(); i < 20; i++ ) {
								naknum += " ";
							}
		
							tmp = "0000000000000" + bank_money;
							String bank_money_tmp = tmp.substring(tmp.length()-13);
		
							String gubun = saup;
							if ( gubun.length() < 13) {
								for ( int i = gubun.length(); i < 13; i++ ) {
									gubun += " ";
								}
							}
							
							if(handy.length() <12){
								for(int i= handy.length();i<12;i++){
									handy += " ";
								}
							}
							
							// Data Record 생성
							String temp_str = "";
		
							// 1. Record 구분(1)
							temp_str = ICodeConstant.CODE_CMS_LAYOUT_DATA;
						        	
							serialno++;
							
							// 2. Data 일련번호(8)
							tmp = "0000000" + serialno;
							temp_str += tmp.substring(tmp.length()-8);
							
							// 3. 기관코드(10)
							temp_str += ccode;
							
							// 4. 출금 은행점코드(7) - (회원관리시 은행지정하면 자동으로 세팅)
							tmp = bank.trim();
							if ( tmp.length() == 6 ) {
								tmp = tmp + "0";
							}
							tmp = "0000000" + tmp;
							temp_str += tmp.substring(tmp.length()-7);
							
							
							// 5. 출금계좌번호(16) - (회원 직접 입력 - 빼고)
							temp_str += bank_num;
							
							// 6. 출금의뢰금액(13) - (위에서 13바이트 맞춤)
							temp_str += bank_money_tmp;
							
							// 7. 주민등록번호 또는 사업자등록번호(13)
							temp_str += gubun;
							
							// 8. 출금결과 : 출금여부(1), 불능코드(4) - 빈값으로 채움
							for ( int i = 0; i < 5; i++ ) {
								temp_str += " ";
							}
							
							// 9. 통장기재내용(16) - (한글 8자. 한영혼영불가)
							temp_str += "매일경제　　　　";
							
							// 10. 자금종류(2)
							for ( int i = 0; i < 2; i++ ) {
								temp_str += " ";
							}
							
							// 11. 납부자번호(20) - (위에서 20yte로 맞췄음)
							temp_str += naknum;
							
							// 12. 이용기관 사용영역(5)
							for ( int i = 0; i < 5; i++ ) {
								temp_str += " ";
							}
							
							// 13. 출금형태(1) - ("0":부분출금가능, "1":Only 전액출금, "2"~"6":1000원~5000기준. [2.8 출금형태] 참조)
							temp_str += "1";
							
							// 14. 전화번호(12)
//							for ( int i = 0; i < 12; i++ ) {
//								temp_str += " ";
//							}
							
							temp_str += handy;
							
							// 15. FILLER(21)
							for ( int i = 0; i < 21; i++ ) {
								temp_str += " ";
							}
							
							data_str += temp_str;
		
							totalmoney += Integer.parseInt(bank_money.toString());
							
							//type1 = tyo;
		
							dbparam = new HashMap();
							tmp = "0000000" + serialno;
							dbparam.put("serialno", tmp.substring(tmp.length()-8));
							dbparam.put("filename", eanum + rdate.substring(2, 6));
							dbparam.put("cmstype", "EA21");
							dbparam.put("cmsdate", fdate);
							dbparam.put("cmsmoney", bank_money_tmp);
							dbparam.put("cmsresult", "EEEEE");
							dbparam.put("userid", userid);
							dbparam.put("usernumid", numid);
							dbparam.put("codenum", naknum);
							dbparam.put("subsmonth", subsmonth);
							dbparam.put("readno", readno);						
							generalDAO.getSqlMapClient().insert("billing.zadmin.cmsrequest.insertEALog", dbparam);
							logger.debug("===== billing.zadmin.cmsrequest.insertEALog");
						} else {
							erro_c++;
							err_total_str = err_total_str + numid + " : " + err_21_str + "\n";
						}
					}
				}
				// Data Record 생성 끝 - DB로 부터 추출
				
				// Trailer Record 생성 
				trailer_str = "";
				trailer_str += ICodeConstant.CODE_CMS_LAYOUT_TRAILER;	// Record 구분(1)
				trailer_str += "99999999";								// 일련번호(8) - 고정값, "99999999"
				trailer_str += ccode;									// 기관코드(10)
				trailer_str += eanum + rdate.substring(2, 6);			// File 이름(8)
				tmp = "00000000" + serialno;
				trailer_str += tmp.substring(tmp.length()-8);			// 총 Data Record 수(8)
				tmp = "00000000" + serialno;
				trailer_str += tmp.substring(tmp.length()-8);			// 전액출금 건수(8)
				tmp = "0000000000000" + totalmoney;
				trailer_str += tmp.substring(tmp.length()-13);			// 전액출금 금액(13)
				
				for ( int i = 0; i < 8; i++ ) {
					trailer_str += "0";									// 부분출금 건수(8) - 고정값
				}
				for ( int i = 0; i < 13; i++ ) {
					trailer_str += "0";									// 부분출금 금액(13) - 고정값
				}
				for ( int i = 0; i < 63; i++ ) {
					trailer_str += " ";									// FILLER(63)
				}
				for ( int i = 0; i < 10; i++ ) {
					trailer_str += " ";									// MAC 검증값 (10)
				}
				
				if ( trailer_str.length() != 150 ) {
					errorch = 1;
					error_str = error_str + " Tailer 레코드 길이 오류 : " + trailer_str.length() + " bytes";
				}
			
				// Tailer Record 생성 끝
	
				// 전체 Record 연결
				String text = header_str + data_str + trailer_str;
	
				// 파일생성
				if ( StringUtils.isNotEmpty(text) ) {
					
					Calendar now = Calendar.getInstance();
					String year = Integer.toString(now.get(Calendar.YEAR));
					
					
					try {
						FileUtil.saveTxtFile(
								PATH_UPLOAD_RELATIVE_CMS_EB21 + "/" + year.substring(0, 2) + rdate.substring(0, 2), 
								"EB21" + rdate.substring(2, 6), 
								text,
								ENCODING_TYPE_CMS
							);
					} catch(Exception e) {
						mav.setViewName("common/message");
						mav.addObject("message", "파일생성 실패");
						mav.addObject("returnURL", "/billing/zadmin/cmsget/index21.do");
						return mav;
					}
				}
				else {
					mav.setViewName("common/message");
					mav.addObject("message", "파일생성할 데이터가 없습니다.");
					mav.addObject("returnURL", "/billing/zadmin/cmsget/index21.do");
					return mav;
				}
				
				if ( serialno == 0 ) {
					mav.setViewName("common/message");
					mav.addObject("message", "생성될 데이터가 없습니다.");
					mav.addObject("returnURL", "/billing/zadmin/cmsget/index21.do");
					return mav;
				}
				else {
					
					HttpSession session = request.getSession();
					
					dbparam = new HashMap();
					dbparam.put("counts", Integer.toString(serialno));
					dbparam.put("money", Integer.toString(totalmoney));
					dbparam.put("memo", text);
					dbparam.put("err_str", err_total_str);
					dbparam.put("adminid", session.getAttribute(SESSION_NAME_ADMIN_USERID));
					generalDAO.getSqlMapClient().insert("billing.zadmin.cmsget.insertEB21Log", dbparam);
					logger.debug("===== billing.zadmin.cmsget.insertEB21Log");
	
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
				e.printStackTrace();
				generalDAO.getSqlMapClient().getCurrentConnection().rollback();
				
				error_str = "정상적으로 처리되지 않았습니다.";
			}
			finally {
				// transaction end
				generalDAO.getSqlMapClient().endTransaction();
			}
			
			mav.setViewName("billing/zadmin/cmsget/process21b");
			mav.addObject("now_menu", ICodeConstant.MENU_CODE_BILLING);
			
			mav.addObject("error_str", error_str);
			mav.addObject("good_c", good_c);
			mav.addObject("erro_c", erro_c);
			mav.addObject("fname", eanum + rdate.substring(2, 6));
			return mav;
		}
	}
	
	/**
	 * 이체청구(EB21) 엑셀파일
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView process21b_excel(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		int pagesize = 40;
		int conternp = 10;
		//String idid = "tbl_EA21_log";
		String thisorder = "";
		String orderby = "";
		
		// param
		Param param = new HttpServletParam(request);
		int numid = param.getInt("numid");
		String fname = param.getString("fname");
		
		// db query parameter		
		HashMap dbparam = new HashMap();
		dbparam.put("cmstype", "EA21");
		dbparam.put("cmsdate", fname.substring(4, 8));
			
		// excute query
		String cmsdate = (String)generalDAO.queryForObject("billing.zadmin.cmsget.getLastRequestDate", dbparam);
		logger.debug("===== billing.zadmin.cmsget.getLastRequestDate");
		
		dbparam = new HashMap();
		dbparam.put("cmstype", "EA21");
		dbparam.put("cmsdate", cmsdate);
		
		// excute query
		List resultList = generalDAO.queryForList("billing.zadmin.cmsget.getEALogList", dbparam);
		logger.debug("===== billing.zadmin.cmsget.getEALogList");

		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("billing/zadmin/cmsget/process21b_excel");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_BILLING);
		mav.addObject("show_hidden3", "display");
		
		mav.addObject("numid", numid);
		mav.addObject("fname", fname);
		
		mav.addObject("resultList", resultList);
		
		return mav;
	}
	
	/**
	 * 이체청구 (EB21) 파일생성 결과
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView process21c(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		
		// param
		Param param = new HttpServletParam(request);
		String fname = param.getString("fname");
		
		// db query parameter		
		HashMap dbparam = new HashMap();
		
		Map resultMap = (Map) generalDAO.queryForObject("billing.zadmin.cmsget.getEB21LogFirstRow", dbparam);
		logger.debug("===== billing.zadmin.cmsget.getEB21LogFirstRow");
		
		String memo = "";
		if ( resultMap != null ) { 
			memo = (String) resultMap.get("MEMO");
		}
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("billing/zadmin/cmsget/process21c");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_BILLING);
		
		mav.addObject("memo", memo);
		
		return mav;
	}
	
	/**
	 * 청구결과(EB22)
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
		List resultList = generalDAO.queryForList("billing.zadmin.cmsget.getEB22LogList", dbparam);
		
		int t_count = (Integer) generalDAO.queryForObject("billing.zadmin.cmsget.getEB22LogCount");
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("billing/zadmin/cmsget/index");
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
	 * 청구결과(EB22) 상세
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
		String cmsdate = param.getString("cmsdate");
		String filename = param.getString("filename");
		String jikuk = param.getString("jikuk");
		String cmstype = "EA21";
		
		// db query parameter		
		HashMap dbparam = new HashMap();
		dbparam.put("cmsdate", cmsdate);
		dbparam.put("cmstype", cmstype);
		dbparam.put("cmsresult", "00000");
		dbparam.put("jikuk", jikuk);
		int noErrnum1 = (Integer) generalDAO.queryForObject("billing.zadmin.cmsget.getEALogCount", dbparam);
		logger.debug("===== billing.zadmin.cmsget.getEALogCount");
		
		dbparam = new HashMap();
		dbparam.put("cmsdate", cmsdate);
		dbparam.put("cmsresult_not", "00000");
		dbparam.put("cmstype", cmstype);
		dbparam.put("jikuk", jikuk);
		int Errnum1 = (Integer) generalDAO.queryForObject("billing.zadmin.cmsget.getEALogCount", dbparam);
		logger.debug("===== billing.zadmin.cmsget.getEALogCount");
		
		// summary
		dbparam = new HashMap();
		dbparam.put("numid", numid);
		Map resultMap = (Map) generalDAO.queryForObject("billing.zadmin.cmsget.getCmsdataLog", dbparam);
		logger.debug("===== billing.zadmin.cmsget.getCmsdataLog");
		
		String out_date = "";
		String totals =	"";
		String requestt =	"";
		String request_money =	"";
		String part =	"";
		String part_money =	"";

		if ( resultMap != null ) {
			out_date = (String) resultMap.get("OUT_DATE");
			totals = (String) resultMap.get("TOTALS");
			requestt = (String) resultMap.get("REQUESTT");
			request_money = (String) resultMap.get("REQUEST_MONEY");
			part = (String) resultMap.get("PART");
			part_money = (String) resultMap.get("PART_MONEY");
		}
		
		//지국정보
		dbparam = new HashMap();
		dbparam.put("CMSDATE", cmsdate);		
		List jikukList = generalDAO.queryForList("billing.zadmin.cmsget.getAgencyList", dbparam);
		logger.debug("===== billing.zadmin.cmsget.getAgencyList");
		
		dbparam = new HashMap();
		dbparam.put("cmstype", cmstype);
		dbparam.put("cmsdate", cmsdate);
		dbparam.put("jikuk", jikuk);
		List resultList = generalDAO.queryForList("billing.zadmin.cmsget.getEALogList", dbparam);
		logger.debug("===== billing.zadmin.cmsget.getEALogList");
		
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
		mav.setViewName("billing/zadmin/cmsget/view");
		mav.addObject("now_menu", MENU_CODE_BILLING);
		mav.addObject("show_hidden3", "display");
		
		mav.addObject("numid", numid);
		mav.addObject("cmsdate", cmsdate);
		mav.addObject("filename", filename);
		mav.addObject("jikuk", jikuk);
		
		mav.addObject("resultMap", resultMap);
		mav.addObject("jikukList", jikukList);
		mav.addObject("resultList", resultList);
		mav.addObject("pageNo", pageNo);

		mav.addObject("noErrnum1", noErrnum1);
		mav.addObject("Errnum1", Errnum1);
		
		mav.addObject("out_date", out_date);
		mav.addObject("totals", totals);
		mav.addObject("requestt", requestt);
		mav.addObject("request_money", request_money);
		mav.addObject("part", part);
		mav.addObject("part_money", part_money);
		
		return mav;
	}
	
	
	/**
	 * 청구결과(EB22) 통계
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView view_excel_list(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		// param
		Param param = new HttpServletParam(request);
		int pageNo = param.getInt("pageNo", 1);			// 리스트의 몇번째 페이지인지 읽음
		int numid = param.getInt("numid");
		String cmsdate = param.getString("cmsdate");
		String filename = param.getString("filename");
		String jikuk = param.getString("jikuk");

		int pay1 = 140;		// 성공은행수수료
		int pay2 = 260; 	// 성공대행수수료
		int pay3 = 20;		// 실패은행수수료
		
		// mydate = right(Year(now),2) & right( filename,4 )
		String[] cmsresult = {"00000","99999"};
		
		// 정상 데이터 추출
		HashMap dbparam = new HashMap();
		dbparam.put("CMSTYPE", "EA21");
		dbparam.put("CMSRESULT", cmsresult);
		dbparam.put("CMSDATE", cmsdate);
		List resultList = generalDAO.queryForList("billing.zadmin.cmsget.getEB22StatisticsNormalList", dbparam);
		logger.debug("===== billing.zadmin.cmsget.getEB22StatisticsNormalList"); 
		
		// 에러 데이터 추출
		dbparam = new HashMap();
		dbparam.put("CMSTYPE", "EA21");
		dbparam.put("CMSRESULT_NOT", cmsresult);
		dbparam.put("CMSDATE", cmsdate);
		List errorList = generalDAO.queryForList("billing.zadmin.cmsget.getEB22StatisticsErrorList", dbparam);
		logger.debug("===== billing.zadmin.cmsget.getEB22StatisticsErrorList");

		
		String fileName = "CMS내역_("+filename+").xls";
		
		//Excel response
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
		response.setHeader("Content-Description", "JSP Generated Data");
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("billing/zadmin/cmsget/view_excel_list");
		mav.addObject("now_menu", MENU_CODE_BILLING);
		mav.addObject("show_hidden3", "display");
		
		mav.addObject("resultList", resultList);
		mav.addObject("errorList", errorList);
		mav.addObject("pay1", pay1);
		mav.addObject("pay2", pay2);
		mav.addObject("pay3", pay3);
		
		mav.addObject("numid", numid);
		mav.addObject("cmsdate", cmsdate);
		mav.addObject("filename", filename);
		mav.addObject("jikuk", jikuk);
		return mav;
	}
	
	
	
	/**
	 * 청구결과(EB22) db 저장
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
			mav.addObject("returnURL", "/billing/zadmin/cmsget/index.do");
			return mav;
		}
		else {	// 파일 첨부가 되었으면
			
			Calendar now = Calendar.getInstance();
			int year = now.get(Calendar.YEAR);
			
			
			FileUtil fileUtil = new FileUtil( getServletContext() );
			String strFile = fileUtil.saveUploadFile(
											cmsfile, 
											PATH_PHYSICAL_HOME,
											PATH_UPLOAD_ABSOLUTE_CMS_EB22 + "/" + year
										);
			
			
			if ( StringUtils.isEmpty(strFile) ) {
				mav.setViewName("common/message");
				mav.addObject("message", "파일 저장이 실패하였습니다. ");
				mav.addObject("returnURL", "/billing/zadmin/cmsget/index.do");
				return mav;
			}
			else if ( strFile.length() != 8 ) { 
				mav.setViewName("common/message");
				mav.addObject("message", "파일명이 잘못되었습니다.");
				mav.addObject("returnURL", "/billing/zadmin/cmsget/index.do");
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
				dbparam.put("out_date", nowYearStr.substring(2, 4) + strFile.substring(4, 8));

				// excute query
				String filename = (String) generalDAO.queryForObject("billing.zadmin.cmsget.getEB22FileName", dbparam);
				logger.debug("===== billing.zadmin.cmsget.getEB22FileName");
				
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
					
					if ( "EB22".equals(fmt1) ) {
	
						int LINE_NUM = 150;
						
						String fileName = PATH_UPLOAD_RELATIVE_CMS_EB22 + "/" + year + "/" + strFile;
						
						File f = new File(fileName);
						FileInputStream fis = new FileInputStream(f);
						
						int count;
						byte[] b = new byte[LINE_NUM];
						
						int i = 0;
						
						String txt_file = "";
						String txt_date = "";
						String txt_bankcode = "";
						String txt_banknum = "";

						/* 출금월 (YYYYMM) */
						String subsmonth = "";		// (수정 박윤철 12.03.28)
						
						try {
							// transaction start
							generalDAO.getSqlMapClient().startTransaction();					
							generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
						
							while ((count = fis.read(b)) != -1) {
								
								String txtline = new String(b);
								
								if ( txtline.length() != 0 ) {
									
									String txt_code = txtline.substring(0, 1);			// (1) Record 구분코드
									String txt_count = txtline.substring(1, 9);			// (8) 일련번호
									String txt_code2 = txtline.substring(9, 19);		// (10)기관코드
									
									if ( txt_code.equals(CODE_CMS_LAYOUT_HEADER)) {		// 헤더면
										txt_file = txtline.substring(19, 27);			// (8) File 이름 (EB22MMDD)
										txt_date = txtline.substring(27, 33);			// (6) 출금일자 (YYMMDD)
										txt_bankcode = txtline.substring(33, 40);		// (7) 주거래은행점코드
										txt_banknum = txtline.substring(40, 56);		// (16)입금계좌번호
										subsmonth = nowYearStr.substring(0, 2) + txt_date.substring(0, 4) ;		// 출금월 (수정 박윤철 12.03.28)
										//String txt_hfiller = txtline.substring(27, 33);	// (6) FILLER
										
										// 신청데이터를 일단 다 성공으로 만듦.
										// 로그테이블 성공처리
										dbparam = new HashMap();
										dbparam.put("cmsresult", "00000");
										dbparam.put("cmsdate", txt_date);
										dbparam.put("subsmonth", subsmonth);				// (수정 박윤철 12.03.28)
										dbparam.put("cmstype", "EA21");									
		
										// excute query
										generalDAO.getSqlMapClient().update("billing.zadmin.cmsget.updateEALog", dbparam);
										logger.debug("===== billing.zadmin.cmsget.updateEALog");
									}
									else if ( txt_code.equals(CODE_CMS_LAYOUT_DATA)) {	// 데이터면
										
										i++;
										
										String txt_bank = txtline.substring(19, 26);			// (7) 출금은행점코드
										String txt_bank_num = txtline.substring(26, 42);		// (16)출금계좌번호
										String txt_money = txtline.substring(42, 55);			// (13)출금불능금액
										String txt_jumin = txtline.substring(55, 68);			// (13)주민등록번호 또는 사업자등록번호
										String txt_result = txtline.substring(68, 73);			// (5) 출금결과
										String txt_tmp = txtline.substring(73, 75);
										String txt_txt = "";
										String txt_type = "";
										String txt_jironum = "";
										String txt_etc = "";
										String txt_out_type = "";
										
										byte[] tmpByte;
										tmpByte = new byte[16];							// (16)통장기재내용
										for ( int j = 73; j < 89; j++ ) {
											tmpByte[j-73] = b[j];
										}
										txt_txt = new String(tmpByte, ENCODING_TYPE_CMS);
										
										tmpByte = new byte[2];							// (2) 자금종류
										for ( int j = 89; j < 91; j++ ) {
											tmpByte[j-89] = b[j];
										}
										txt_type = new String(tmpByte);
										
										tmpByte = new byte[20];							// (20)납부자번호
										for ( int j = 91; j < 111; j++ ) {
											tmpByte[j-91] = b[j];
										}
										txt_jironum = new String(tmpByte);
										
										tmpByte = new byte[5];							// (5) 이용기관 사용영역
										for ( int j = 111; j < 116; j++ ) {
											tmpByte[j-111] = b[j];
										}
										txt_etc = new String(tmpByte);
										
										tmpByte = new byte[1];							// (1) 출금형태
										for ( int j = 116; j < 117; j++ ) {
											tmpByte[j-116] = b[j];
										}
										txt_out_type = new String(tmpByte);
										
										
										// 신청데이터에서 에러 난것만 에러값을 세팅
										dbparam = new HashMap();
										dbparam.put("cmsresult", txt_result);
										dbparam.put("cmsdate", txt_date);
										dbparam.put("cmstype1", "EA21");
										dbparam.put("cmstype2", "EB21");
										dbparam.put("serialno", txt_count);
		
										// excute query
										generalDAO.getSqlMapClient().update("billing.zadmin.cmsget.updateEALog", dbparam);
										logger.debug("===== billing.zadmin.cmsget.updateEALog");
										
										
										// 로그인 아이디
										HttpSession session = request.getSession();
										String adminId = (String) session.getAttribute(SESSION_NAME_ADMIN_USERID);
										
										// EB14 data 등록
										dbparam = new HashMap();
										dbparam.put("rtype", fmt1);
										dbparam.put("serialno", txt_count);
										dbparam.put("code", txt_code2);
										dbparam.put("bank", txt_bank);
										dbparam.put("bank_num", txt_bank_num);
										dbparam.put("money", txt_money);
										dbparam.put("jumin", txt_jumin);
										dbparam.put("result", txt_result);
										dbparam.put("txt", txt_txt);
										dbparam.put("type", txt_type);
										dbparam.put("jironum", txt_jironum);
										dbparam.put("blk", txt_etc);
										dbparam.put("out_type", txt_out_type);
										dbparam.put("filename", txt_file);
										dbparam.put("logdate", txt_date);
										dbparam.put("filename", txt_file);
										dbparam.put("chk_id", adminId);
		
										// excute query
										generalDAO.getSqlMapClient().insert("billing.zadmin.cmsget.insertCmsdata", dbparam);
										logger.debug("===== billing.zadmin.cmsget.insertCmsdata");
									}
									else if ( txt_code.equals(CODE_CMS_LAYOUT_TRAILER)) {	// 트레일러면
										
										txt_file = txtline.substring(19, 27);					// (8) File 이름
										String txt_totals = txtline.substring(27, 35);			// (8) 총 Data Record 수
										String txt_request = txtline.substring(35, 43);			// (8) 전액출금 - 불능건수
										String txt_request_money = txtline.substring(43, 56);	// (13)전액출금 - 불능금액 (합계)
										String txt_part = txtline.substring(56, 64);			// (8) 부분출금 - 불능건수
										String txt_part_money = txtline.substring(64, 77);		// (13)부분출금 - 불능금액 (합계)
										String err_num = txtline.substring(77, 85);				// (8) 센터검증오류건수
										String filler = txtline.substring(85, 89);				// (4) FILLER ("0000")
										String chul_cost = txtline.substring(89, 100);			// (11) 출금은행 수수류 (출금건수*120원을 기준으로 산정)
										String ip_cost = txtline.substring(100, 111);			// (11) 입금은행 수수료 ("00000000000")
										
										// 로그인 아이디
										HttpSession session = request.getSession();
										String adminId = (String) session.getAttribute(SESSION_NAME_ADMIN_USERID);
										
		
										// EB22 data 등록
										dbparam = new HashMap();
										dbparam.put("rtype", fmt1);
										dbparam.put("code", txt_code2);
										dbparam.put("filename", txt_file);
										dbparam.put("out_date", txt_date);
										dbparam.put("bank_code", txt_bankcode);
										dbparam.put("bank_num", txt_banknum);
										dbparam.put("totals", txt_totals);
										dbparam.put("requestt", txt_request);
										dbparam.put("request_money", txt_request_money);
										dbparam.put("part", txt_part);
										dbparam.put("part_money", txt_part_money);
										dbparam.put("err_num", err_num);
										dbparam.put("chul_cost", chul_cost);
										dbparam.put("ip_cost", ip_cost);
										dbparam.put("chk_id", adminId);
		
										// excute query
										generalDAO.getSqlMapClient().insert("billing.zadmin.cmsget.insertCmsdataLog", dbparam);
										logger.debug("===== billing.zadmin.cmsget.insertCmsdataLog");
										
										String last_yymm = (String) generalDAO.getSqlMapClient().queryForObject("common.getLastSGYYMM");
										
										// 수금테이블 성공처리
										dbparam = new HashMap();
										dbparam.put("NEWSCD", MK_NEWSPAPER_CODE);					// 신문코드 - 매일경제 신문
										dbparam.put("SGBBCD_OLD", CODE_SUGM_GUBUN_NOT_COMPLETE);		// 수금방법 - 미수
										dbparam.put("SGGBCD", CODE_SUGM_TYPE_DIRECT_DEBIT);			// 수금구분 - 자동이체
										dbparam.put("CMSTYPE", "EA21");
										dbparam.put("CMSDATE", txt_date);
										dbparam.put("SGBBCD_NEW", CODE_SUGM_TYPE_DIRECT_DEBIT);
										dbparam.put("SGYYMM", last_yymm);		// YYYYMM
										dbparam.put("SNDT", nowYearStr.substring(0, 2) + txt_date);
										dbparam.put("ICDT", nowYearStr.substring(0, 2) + txt_date); 
										dbparam.put("CLDT", nowYearStr.substring(0, 2) + txt_date);
										dbparam.put("subsmonth", subsmonth); 		// (수정 박윤철 12.03.28)
										
										// excute query
										generalDAO.getSqlMapClient().update("billing.zadmin.cmsget.updateSugm", dbparam);
										logger.debug("===== billing.zadmin.cmsget.updateSugm");
									}
								}
							}
							
							// transaction commit
							generalDAO.getSqlMapClient().getCurrentConnection().commit();
						}
						catch (Exception e) {
							// transaction rollback
							e.printStackTrace();
							generalDAO.getSqlMapClient().getCurrentConnection().rollback();
							
							msg = "정상적으로 처리되지 않았습니다.";
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
			
				mav.setViewName("billing/zadmin/cmsget/input_db");
				mav.addObject("now_menu", MENU_CODE_BILLING);
				
				mav.addObject("dataproc", dataproc);
				mav.addObject("msg", msg);
				return mav;
			}
		}
	}
	
	
	/**
	 * 이체내역조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView stat(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		//메뉴펼치기
		String show_hidden3 = "display";
		
		int pagesize = 40;
		int conternp = 10;
		
		//parameter
		Param param = new HttpServletParam(request);
		int pageNo = param.getInt("pageNo", 1);
		String idid = param.getString("idid");
		String numid = param.getString("numid");
		int page = param.getInt("page");
		String jikuk = param.getString("jikuk");
		String chbx = param.getString("chbx", "all");
		String filename = param.getString("filename");
		String sdate = param.getString("sdate");
		String edate = param.getString("edate");
		int startpage = param.getInt("startpage", 1);
		
		
		String EACH_filename = "";
		if( filename.length() > 4 ){
			EACH_filename = "EA21" + filename.substring(filename.length() - 4); 
		}
		
		//이번달의 월말값 계산
		if( StringUtils.isEmpty(sdate) ){
			Calendar cal = Calendar.getInstance();
			String year = cal.get(Calendar.YEAR) + "";
			String month = cal.get(Calendar.MONTH)+1 + "";
			if( month.length() == 1 ){
				month = "0" + month;
			}
			//마지막날짜구하기
			int intLastDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
			sdate = year + "-" + month + "-01";
			edate = year + "-" + month + "-" + intLastDay;
			
		}
		//cmsdate
		String s_cmsdate = "";
		String e_cmsdate = "";
		if ( StringUtils.isNotEmpty(sdate) && StringUtils.isNotEmpty(edate) ){
			String sdate_tmp = sdate.replace("-", ""); 
			String edate_tmp = edate.replace("-", "");
			s_cmsdate = sdate_tmp.substring(sdate_tmp.length() - 6);
			e_cmsdate = edate_tmp.substring(edate_tmp.length() - 6);
		}
		
		//dbparam
		HashMap dbparam = new HashMap();
		dbparam.put("CMSTYPE", "EA21");
		dbparam.put("CHBX", chbx);
		dbparam.put("JIKUK", jikuk);
		dbparam.put("S_CMSDATE", s_cmsdate);
		dbparam.put("E_CMSDATE", e_cmsdate);
		
		//지국정보
		List jikukList = generalDAO.queryForList("billing.zadmin.cmsget.getAgencyList", dbparam);
		if( jikuk.length() > 4 ){
			dbparam.put("JIKUK_CHECK", "Y");
		}
		
		//paging
		Map result = (Map)generalDAO.queryForObject("billing.zadmin.cmsget.getStatResult", dbparam);
		
		BigDecimal count = null;
		BigDecimal totals = null;
		int totpage = 0;
		int notinidx = 0;
		
		if( result != null ){
			count = (BigDecimal)result.get("R_COUNT");
		}
		if( count.intValue() > 0 ){
			totals = (BigDecimal)result.get("TOTALS");
		}
		
		totpage = (((count.intValue()) - 1) / pagesize) + 1;
		notinidx = (pageNo - 1) * pagesize;
		
		//String link = "<a href='stat.do?chbx=" + chbx + "&sdate=" + sdate + "&edate=" + edate + "&jikuk=" + jikuk;
		//String paging = PagingUtil.CreatePaging(startpage, totpage, conternp, gotopage, link);
		
		dbparam.put("PAGE_NO",pageNo);
		dbparam.put("PAGE_SIZE",pagesize);
		
		//리스트
		List resultList = generalDAO.queryForList("billing.zadmin.cmsget.getStatResultList", dbparam);
		
		//은행에러코드
		Map resultMap = null;
		String cmsResult = "";
		String err_code = "";
		for( int i=0; i<resultList.size() ; i++ ){
			resultMap = (Map)resultList.get(i);
			cmsResult = (String)resultMap.get("CMSRESULT");
			if( cmsResult.length() > 4 ){
				cmsResult = cmsResult.substring(cmsResult.length() - 4);
			}
			err_code = CommonUtil.err_code(cmsResult);
			resultMap.put("ERR_CODE", err_code);
			resultList.set(i, resultMap);
		}
		// mav
		ModelAndView mav = new ModelAndView();
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_BILLING);
		mav.addObject("show_hidden3",show_hidden3);
		mav.addObject("jikukList",jikukList);
		mav.addObject("resultList",resultList);
		mav.addObject("jikuk",jikuk);
		mav.addObject("chbx",chbx);
		mav.addObject("sdate",sdate);
		mav.addObject("edate",edate);
		//paging
		mav.addObject("count",count);
		mav.addObject("totals",totals);
		mav.addObject("conternp",conternp);
		mav.addObject("startpage",startpage);
		mav.addObject("conternp",conternp);
		mav.addObject("totpage",totpage);
		mav.addObject("pageNo",pageNo);
		//mav.addObject("paging",paging);
		mav.addObject("pageInfo", Paging.getPageMap(pageNo, count.intValue(), pagesize, 10));
		mav.setViewName("billing/zadmin/cmsget/stat");
		return mav;
	}
	
	/**
	 * 이체내역 조회 엑셀리스트
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView stat_excel(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		
		//parameter
		Param param = new HttpServletParam(request);
		String idid = param.getString("idid");
		String numid = param.getString("numid");
		int page = param.getInt("page");
		String jikuk = param.getString("jikuk");
		String chbx = param.getString("chbx", "all");
		String filename = param.getString("filename");
		String sdate = param.getString("sdate");
		String edate = param.getString("edate");
		
		String EACH_filename = "";
		if( filename.length() > 4 ){
			EACH_filename = "EA21" + filename.substring(filename.length() - 4); 
		}
		
		//이번달의 월말값 계산
		if( StringUtils.isEmpty(sdate) ){
			Calendar cal = Calendar.getInstance();
			String year = cal.get(Calendar.YEAR) + "";
			String month = cal.get(Calendar.MONTH)+1 + "";
			if( month.length() == 1 ){
				month = "0" + month;
			}
			//마지막날짜구하기
			int intLastDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
			sdate = year + "-" + month + "-01";
			edate = year + "-" + month + "-" + intLastDay;
			
		}
		//cmsdate
		String s_cmsdate = "";
		String e_cmsdate = "";
		if ( StringUtils.isNotEmpty(sdate) && StringUtils.isNotEmpty(edate) ){
			String sdate_tmp = sdate.replace("-", ""); 
			String edate_tmp = edate.replace("-", "");
			s_cmsdate = sdate_tmp.substring(sdate_tmp.length() - 6);
			e_cmsdate = edate_tmp.substring(edate_tmp.length() - 6);
		}
		
		//dbparam
		HashMap dbparam = new HashMap();
		dbparam.put("CMSTYPE", "EA21");
		dbparam.put("CHBX", chbx);
		dbparam.put("JIKUK", jikuk);
		dbparam.put("S_CMSDATE", s_cmsdate);
		dbparam.put("E_CMSDATE", e_cmsdate);
		
		//지국정보
		List jikukList = generalDAO.queryForList("billing.zadmin.cmsget.getAgencyList", dbparam);
		if( jikuk.length() > 4 ){
			dbparam.put("JIKUK_CHECK", "Y");
		}
		

		//리스트
		List resultList = generalDAO.queryForList("billing.zadmin.cmsget.getStatResultList", dbparam);
		
		//은행에러코드
		Map resultMap = null;
		String cmsResult = "";
		String err_code = "";
		for( int i=0; i<resultList.size() ; i++ ){
			resultMap = (Map)resultList.get(i);
			cmsResult = (String)resultMap.get("CMSRESULT");
			if( cmsResult.length() > 4 ){
				cmsResult = cmsResult.substring(cmsResult.length() - 4);
			}
			err_code = CommonUtil.err_code(cmsResult);
			resultMap.put("ERR_CODE", err_code);
			resultList.set(i, resultMap);
		}
		
		String fileName = "Transfer_History_(" + sdate + "_" + edate + ").xls";
		
		//Excel response
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName); 
		response.setHeader("Content-Description", "JSP Generated Data");
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.addObject("resultList",resultList);
		mav.setViewName("billing/zadmin/cmsget/stat_excel");
		return mav;

	}
	
	/**
	 * 미수독자재청구 리스트
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView err_list(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		//메뉴펼치기
		String show_hidden3 = "display";
		
		//dbparam
		HashMap dbparam = new HashMap();
		dbparam.put("cmstype", "EA21");
		
		String cmsdate = (String)generalDAO.queryForObject("billing.zadmin.cmsget.getCmsDate", dbparam);

		String s_msg = "";
		
		if( StringUtils.isNotEmpty(cmsdate) && cmsdate.length() >= 6 ){
			s_msg = cmsdate.substring(0, 2) + "년 " + cmsdate.substring(2, 4) + "월 " + cmsdate.substring(4, 6) + "일자 청구분에 대한 미수독자입니다."; 
		}

		List resultList = null;
		
		if( StringUtils.isNotEmpty(cmsdate) ){
			
			String[] cmsresult = {"00000","99999","XXXXX","EEEEE"};
			
			dbparam = new HashMap();
			dbparam.put("CMSTYPE", "EA21");
			dbparam.put("CMSRESULT",cmsresult);
			dbparam.put("CMSDATE", cmsdate);

			resultList = generalDAO.queryForList("billing.zadmin.cmsget.getErrList", dbparam);
		}
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_BILLING);
		mav.addObject("show_hidden3",show_hidden3);
		mav.addObject("cmsdate",cmsdate);
		mav.addObject("s_msg",s_msg);
		mav.addObject("resultList",resultList);
		mav.setViewName("billing/zadmin/cmsget/err_list");
		
		return mav;
	}
	
	/**
	 * 미수독자재 청구 엑셀
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView err_list_excel(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		//dbparam
		HashMap dbparam = new HashMap();
		dbparam.put("cmstype", "EA21");
		
		String cmsdate = (String)generalDAO.queryForObject("billing.zadmin.cmsget.getCmsDate", dbparam);

		String s_msg = "";
		
		if( StringUtils.isNotEmpty(cmsdate) && cmsdate.length() >= 6 ){
			s_msg = cmsdate.substring(0, 2) + "년 " + cmsdate.substring(2, 4) + "월 " + cmsdate.substring(4, 6) + "일자 청구분에 대한 미수독자입니다."; 
		}
		
		List resultList = null;
		
		if( StringUtils.isNotEmpty(cmsdate) ){
			
			String[] cmsresult = {"00000","99999","XXXXX","EEEEE"};
			
			dbparam = new HashMap();
			dbparam.put("CMSTYPE", "EA21");
			dbparam.put("CMSRESULT",cmsresult);
			dbparam.put("CMSDATE", cmsdate);

			resultList = generalDAO.queryForList("billing.zadmin.cmsget.getErrList", dbparam);
			List tmpList = new ArrayList();
			if ( resultList != null ) {
				for ( int i = 0; i < resultList.size(); i++ ) {
					Map tmpMap = (Map) resultList.get(i);
					String result = (String)tmpMap.get("CMSRESULT");
					if ( StringUtils.isNotEmpty(result) && result.length() >= 5) {
						tmpMap.put("CMSRESULTMSG", CommonUtil.err_code(result.substring(1, 5)));
					}
					tmpList.add(tmpMap);
				}
				resultList = tmpList;
			}
		}

		Calendar cal = Calendar.getInstance();
		String year = cal.get(Calendar.YEAR) + "";
		String month = cal.get(Calendar.MONTH)+1 + "";
		
		
		String fileName = "err_list(" + year + "-" + month +").xls";
		
		//Excel response
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName); 
		response.setHeader("Content-Description", "JSP Generated Data");
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.addObject("resultList",resultList);
		mav.setViewName("billing/zadmin/cmsget/err_list_excel");
		
		return mav;

	}
	
}
