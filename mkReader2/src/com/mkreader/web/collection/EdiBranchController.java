/*------------------------------------------------------------------------------
 * NAME : EdiController 
 * DESC : 수금입력 - EDI관리
 * Author : shlee
 *----------------------------------------------------------------------------*/
package com.mkreader.web.collection;

import java.text.SimpleDateFormat;
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

import org.apache.commons.lang.StringUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;

public class EdiBranchController extends MultiActionController implements
ISiteConstant, ICodeConstant {

	private GeneralDAO generalDAO;
	
	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}
	
	/**
	 * EDI입금 - 자료조회
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
		String jiroNum = param.getString("jiroNum", "");
		String snType = param.getString("snType", "");	
		
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
						
		// 이체일자별 EDI 입금 정상 처리 목록
		Map dbparam = new HashMap();
		dbparam.put("JIKUK_CODE", jikuk);					// 지국코드
		dbparam.put("EDATE", edate_tmp);					// 이체일자(YYYYMMDD)
		dbparam.put("NEWSCD", MK_NEWSPAPER_CODE);			// 뉴스코드		
		dbparam.put("SGBBCD", CODE_SUGM_TYPE_GIRO);			// 수금방법
		dbparam.put("GU", "구 ");							// 구
		dbparam.put("APT", "아파트");							// 아파트
		dbparam.put("snType", snType);		// 지로형태 콤보박스 (1:금융결재원 지로수납 , 2:더존 바코드 수납, 0:전체)
		dbparam.put("jiroNum", jiroNum);				
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
					if ( txt_type.equals(CODE_EDI_NEW_READER_GUBUN) || txt_type.equals(CODE_EDI_NEW_READER_GUBUN_OTHERS)) {
						
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
		dbparam.put("snType", snType);		// 지로형태 콤보박스 (1:금융결재원 지로수납 , 2:더존 바코드 수납, 0:전체)
		dbparam.put("jiroNum", jiroNum);				
		Map normalMap = (Map) generalDAO.queryForObject("collection.edibranch.getEdiSumInfo", dbparam);
		logger.debug("===== collection.edibranch.getEdiSumInfo");
		
		// 에러 자료 총합
		dbparam = new HashMap();
		dbparam.put("JIKUK_CODE", jikuk);					// 지국코드
		dbparam.put("EDATE", edate_tmp);					// 이체일자(YYYYMMDD)
		dbparam.put("E_ERROR", "ERROR");					// 상태정보
		dbparam.put("snType", snType);		// 지로형태 콤보박스 (1:금융결재원 지로수납 , 2:더존 바코드 수납, 0:전체)
		dbparam.put("jiroNum", jiroNum);				
		Map errorMap = (Map) generalDAO.queryForObject("collection.edibranch.getEdiSumInfo", dbparam);
		logger.debug("===== collection.edibranch.getEdiSumInfo");
		
		// 금융결재원 등록 지국 지로번호 
		List jiroList = generalDAO.queryForList("collection.edibranch.getAgencyJiro", dbparam);
		logger.debug("===== collection.edibranch.getAgencyJiro");
				
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("collection/edibranch/ediList");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COLLECTION_EDI);

		mav.addObject("resultList", resultList);
		mav.addObject("normalMap", normalMap);
		mav.addObject("errorMap", errorMap);
		mav.addObject("jiroList", jiroList);
		
		mav.addObject("edate", edate);
		mav.addObject("snType", snType);
		mav.addObject("jiroNum", jiroNum);
		
		return mav;
	}
	
	
	/**
	 * EDI입금 - 내역서인쇄
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ozEdiList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		String edate = param.getString("edate");
		String jiroNum = param.getString("jiroNum", "");
		String snType = param.getString("snType", "");	
		
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

		// mav
		ModelAndView mav = new ModelAndView();
		
		// 이체일자별 EDI 입금 정상 처리 목록
		mav.addObject("JIKUK_CODE", jikuk);					// 지국코드
		mav.addObject("EDATE", edate_tmp);					// 이체일자(YYYYMMDD)
		if ( "20120106".compareTo(edate_tmp) <= 0 ) {
			mav.addObject("CHANGE", "TRUE");				  	    // 2012년 1월 6일 전후(TRUE : 후, FALSE ; 전) SUGM테이블 EDIPROCNO 입력관련
		}
		mav.addObject("NEWSCD", MK_NEWSPAPER_CODE);			// 뉴스코드		
		mav.addObject("SGBBCD", CODE_SUGM_TYPE_GIRO);			// 수금방법
		mav.addObject("JIRONUM", jiroNum);			// 지국종류
		mav.addObject("snType", snType);
		
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COLLECTION_EDI);
		mav.setViewName("collection/edibranch/ozEdiList");
		
		return mav;
	}
	
	
	/**
	 * EDI입금 - 과입금조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ediOverList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		String sdate = param.getString("sdate");
		String edate = param.getString("edate");
		String jiroNum = param.getString("jiroNum", "");
		String snType = param.getString("snType", "");	
		
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
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
		dbparam.put("JIKUK_CODE", jikuk);			// 지국코드
		dbparam.put("sdate", sdate_tmp);			// 시작일(YYYYMMDD)
		dbparam.put("edate", edate_tmp);			// 종료일(YYYYMMDD)
		dbparam.put("jiroNum", jiroNum);		
		dbparam.put("snType", snType);		// 지로형태 콤보박스 (1:금융결재원 지로수납 , 2:더존 바코드 수납, 0:전체)
		List resultList = generalDAO.queryForList("collection.edi.getGR15OverList", dbparam);
		logger.debug("===== collection.edi.getGR15OverList");
		

		// 금융결재원 등록 지국 지로번호 
		List jiroList = generalDAO.queryForList("collection.edibranch.getAgencyJiro", dbparam);
		logger.debug("===== collection.edibranch.getAgencyJiro");
				
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("collection/edibranch/ediOverList");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COLLECTION_EDI);
		
		mav.addObject("sdate", sdate);
		mav.addObject("edate", edate);
		mav.addObject("snType", snType);
		mav.addObject("jiroNum", jiroNum);
		mav.addObject("jiroList", jiroList);
		
		mav.addObject("resultList", resultList);
		
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
	public ModelAndView ediErrList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		String sdate = param.getString("sdate");
		String edate = param.getString("edate");
		String jiroNum = param.getString("jiroNum", "");	
		
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
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
		dbparam.put("JIKUK_CODE", jikuk);			// 지국코드
		dbparam.put("sdate", sdate_tmp);			// 시작일(YYYYMMDD)
		dbparam.put("edate", edate_tmp);			// 종료일(YYYYMMDD)
		dbparam.put("MK_JIRO_NUMBER", MK_JIRO_NUMBER);	// 직영지로번호
		dbparam.put("jiroNum", jiroNum);	
		List errList = generalDAO.queryForList("collection.edibranch.getGR15ErrList", dbparam);
		logger.debug("===== collection.edi.getGR15ErrList");
		
		// 금융결재원 등록 지국 지로번호 
		List jiroList = generalDAO.queryForList("collection.edibranch.getAgencyJiro", dbparam);
		logger.debug("===== collection.edibranch.getAgencyJiro");
		
		// 에러 자료 총합
		dbparam = new HashMap();
		dbparam.put("JIKUK_CODE", jikuk);					// 지국코드
		dbparam.put("sdate", sdate_tmp);			// 시작일(YYYYMMDD)
		dbparam.put("edate", edate_tmp);			// 종료일(YYYYMMDD)
		dbparam.put("jiroNum", jiroNum);				
		Map errorMap = (Map) generalDAO.queryForObject("collection.edibranch.getEdiErrSum", dbparam);
		logger.debug("===== collection.edibranch.getEdiSumInfo");
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("collection/edibranch/ediErrList");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COLLECTION_EDI);
		
		mav.addObject("sdate", sdate);
		mav.addObject("edate", edate);
		mav.addObject("jiroNum", jiroNum);
		mav.addObject("jiroList", jiroList);
		mav.addObject("errorMap", errorMap);
		mav.addObject("errList", errList);
		
		return mav;
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
	
}
