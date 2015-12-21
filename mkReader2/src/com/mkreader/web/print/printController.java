/*------------------------------------------------------------------------------
 * NAME : printController 
 * DESC : 인쇄
 * Author : 
 *----------------------------------------------------------------------------*/
package com.mkreader.web.print;

import java.io.File;
import java.net.InetAddress;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;
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
import com.mkreader.util.StringUtil;

public class printController extends MultiActionController implements
ISiteConstant, ICodeConstant {

	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}
	
	
	/**
	 * 조건별명단
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView conditionList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		//현재날짜
		Calendar rightNow = Calendar.getInstance();
		String year = String.valueOf(rightNow.get(Calendar.YEAR));
		String year2 = String.valueOf(rightNow.get(Calendar.YEAR));
		String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		String month2 = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH) + 1);
		
		if(Integer.parseInt(day) < 21){
			month2 = String.valueOf(rightNow.get(Calendar.MONTH) );
		}
		if(month2.equals("0")){
			month2 = "12";
			 year2 = String.valueOf(rightNow.get(Calendar.YEAR)-1);
		}
		if (month2.length() < 2) {
			month2 = "0" + month2;
		}
		
		if (month.length() < 2) {
			month = "0" + month;
		}
		
		if (day.length() < 2) {
			day = "0" + day;
		}
		
		// param
		Param param = new HttpServletParam(request);
		
		String listType = param.getString("listType", "1");										// 조건별명단 타입(default:확장일자)
		String fromYyyymmdd = param.getString("fromYyyymmdd", year2 + "-" + month2 + "-21");	// 기간 from
		String toYyyymmdd = param.getString("toYyyymmdd", year + "-" + month + "-" + day);		// 기간 to
		String fromGno = param.getString("fromGno");											// 구역 from
		String toGno = param.getString("toGno");												// 구역 to
		String newsCd[] = param.getStringValues("newsCd", MK_NEWSPAPER_CODE);					// 뉴스코드(최초에 매일경제값셋팅)
		if(newsCd.length == 0) newsCd = new String[] {MK_NEWSPAPER_CODE};  // 최초 매일경제값 세팅(param.getStringValues 가 제대로 안되서 추가)
		
		String order = param.getString("order", "gno");											// 정렬방식(gno:구역별, hjdt:확장일자별, readno:독자번호별)
		String hiddenOpt2Sel1 = param.getString("hiddenOpt2Sel1");								// 동적 selectbox1
		String hiddenOpt2Sel2 = param.getString("hiddenOpt2Sel2");								// 동적 selectbox2
		String hiddenOpt2Sel3 = param.getString("hiddenOpt2Sel3");								// 동적 selectbox3
		String hiddenOpt2Sel4 = param.getString("hiddenOpt2Sel4");								// 동적 selectbox4
		String hiddenOpt1Text1 = param.getString("hiddenOpt1Text1");							// 동적 input=text1
		String hiddenOpt1Text2 = param.getString("hiddenOpt1Text2");							// 동적 input=text2
		String hiddenOpt2Text3 = param.getString("hiddenOpt2Text3");							// 동적 input=text3
		
		
		//지국 일 경우 지국에 대한 정보만 보여준다.
		HttpSession session = request.getSession();
		String boseq = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		// 구역리스트
		HashMap dbparam = new HashMap();
		dbparam.put("BOSEQ", boseq);
		dbparam.put("BNO_NOT", "999");	// 해지독자 제외
		
		List gnoList = generalDAO.queryForList("print.print.getGnoList", dbparam);
		
		// 신문명리스트
		List newsCodeList = null;
		
		dbparam = new HashMap();
		dbparam.put("BOSEQ",boseq);
		dbparam.put("USEYN","Y");
		dbparam.put("CDCLSF",MK_NEWSPAPER_CODE);
		
		if( StringUtils.isEmpty(boseq) ){
			newsCodeList = generalDAO.queryForList("statistics.stats.getNewsCodeList", dbparam);
		}else{
			newsCodeList = generalDAO.queryForList("statistics.stats.getNewsJikukCodeList", dbparam);
		}
		
		// 확장유형 조회
		List hjTypeList = generalDAO.queryForList("common.getHjTypeList");
		
		List hjPsNmList = null;
		if ( "006".equals(hiddenOpt2Sel3) || "007".equals(hiddenOpt2Sel3) || "011".equals(hiddenOpt2Sel3)) {
			dbparam = new HashMap();
			dbparam.put("RESV1",hiddenOpt2Sel3);
			dbparam.put("BOSEQ",boseq);
			hjPsNmList = generalDAO.queryForList("print.print.getHjPsNmList", dbparam);
		}
		
		// 독자유형 조회
		List readerTypeList = generalDAO.queryForList("common.getReaderTypeList");
		
		// 수금방법 조회
		List sgTypeList = generalDAO.queryForList("common.getSugmTypeList");
		
		// 조회결과 리스트
		List resultList = null;
		
		// db query parameter
		dbparam = new HashMap();
		dbparam.put("LISTTYPE", listType);
		dbparam.put("GU", "구 ");
		dbparam.put("APT", "아파트");
		dbparam.put("BOSEQ", boseq);
		
		dbparam.put("FROMYYYYMMDD", fromYyyymmdd.replace("-", ""));
		dbparam.put("TOYYYYMMDD", toYyyymmdd.replace("-", ""));
		dbparam.put("FROMGNO", fromGno);
		dbparam.put("TOGNO", toGno);
		dbparam.put("NEWSCD", newsCd);
		
		dbparam.put("HIDDEN_SEL1", hiddenOpt2Sel1);
		dbparam.put("HIDDEN_SEL2", hiddenOpt2Sel2);
		dbparam.put("HIDDEN_SEL3", hiddenOpt2Sel3);
		dbparam.put("HIDDEN_SEL4", hiddenOpt2Sel4);
		dbparam.put("HIDDEN_TEXT1", hiddenOpt1Text1);
		dbparam.put("HIDDEN_TEXT2", hiddenOpt1Text2);
		dbparam.put("HIDDEN_TEXT3", hiddenOpt2Text3);
		
		dbparam.put("ORDER", order);
		
		// 수금정보 테이블에서 조회(수금개월)
		if ( "14".equals(listType) ) {
			resultList = generalDAO.queryForList("print.print.getConditionList5", dbparam);
		}
		else if ( "16".equals(listType) ) {		// 다부수
			resultList = generalDAO.queryForList("print.print.getConditionList2", dbparam);
		}
		else if ( "17".equals(listType) || "18".equals(listType) || "19".equals(listType) || "21".equals(listType)) {
			if ("17".equals(listType)) {		// 재무독자
				dbparam.put("SGBBCD", "032");
			} else if ("18".equals(listType)) {	// 결손독자
				dbparam.put("SGBBCD", "031");
			} else if ("19".equals(listType)) {	// 휴독독자
				dbparam.put("SGBBCD", "033");
			} else {							// 미수독자
				dbparam.put("SGBBCD", "044");
			}
			resultList = generalDAO.queryForList("print.print.getConditionList3", dbparam);
		}
		else if ( "20".equals(listType) ) {		// 선불독자
			resultList = generalDAO.queryForList("print.print.getConditionList4", dbparam);
		}
		else {	// 구독정보 테이블에서 조회
			resultList = generalDAO.queryForList("print.print.getConditionList", dbparam);
		}
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("print/conditionList");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_PRINT_J_CONDITION);

		mav.addObject("boseq", boseq);
		mav.addObject("listType", listType);
		mav.addObject("fromYyyymmdd", fromYyyymmdd);
		mav.addObject("toYyyymmdd", toYyyymmdd);
		mav.addObject("fromGno", fromGno);
		mav.addObject("toGno", toGno);
		mav.addObject("newsCd", newsCd);
		mav.addObject("order", order);
		mav.addObject("hiddenOpt2Sel1", hiddenOpt2Sel1);
		mav.addObject("hiddenOpt2Sel2", hiddenOpt2Sel2);
		mav.addObject("hiddenOpt2Sel3", hiddenOpt2Sel3);
		mav.addObject("hiddenOpt2Sel4", hiddenOpt2Sel4);
		mav.addObject("hiddenOpt1Text1", hiddenOpt1Text1);
		mav.addObject("hiddenOpt1Text2", hiddenOpt1Text2);
		mav.addObject("hiddenOpt2Text3", hiddenOpt2Text3);
	
		mav.addObject("gnoList", gnoList);
		mav.addObject("newsCodeList", newsCodeList);
		mav.addObject("hjTypeList", hjTypeList);
		mav.addObject("hjPsNmList", hjPsNmList);
		mav.addObject("readerTypeList", readerTypeList);
		mav.addObject("sgTypeList", sgTypeList);
		mav.addObject("resultList", resultList);
		
		return mav;
	}
	
	
	
	
	/**
	 * 조건별명단 OZ인쇄
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ozConditionList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		//현재날짜
		Calendar rightNow = Calendar.getInstance();
		String year = String.valueOf(rightNow.get(Calendar.YEAR));
		String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH) + 1);
		if (month.length() < 2) {
			month = "0" + month;
		}
		if (day.length() < 2) {
			day = "0" + day;
		}
		
		// param
		Param param = new HttpServletParam(request);
		
		String listType = param.getString("listType", "1");										// 조건별명단 타입(default:확장일자)
		String fromYyyymmdd = param.getString("fromYyyymmdd", year + "-" + month + "-" + day);	// 기간 from
		String toYyyymmdd = param.getString("toYyyymmdd", year + "-" + month + "-" + day);		// 기간 to
		String fromGno = param.getString("fromGno");											// 구역 from
		String toGno = param.getString("toGno");												// 구역 to
		String newsCdParam[] = param.getStringValues("newsCd", MK_NEWSPAPER_CODE);					// 뉴스코드(최초에 매일경제값셋팅)
		if(newsCdParam.length == 0) newsCdParam = new String[] {MK_NEWSPAPER_CODE};  // 최초 매일경제값 세팅(param.getStringValues 가 제대로 안되서 추가)
		
		String order = param.getString("order", "gno");											// 정렬방식(gno:구역별, hjdt:확장일자별, readno:독자번호별)
		String hiddenOpt2Sel1 = param.getString("hiddenOpt2Sel1");								// 동적 selectbox1
		String hiddenOpt2Sel2 = param.getString("hiddenOpt2Sel2");								// 동적 selectbox2
		String hiddenOpt2Sel3 = param.getString("hiddenOpt2Sel3");								// 동적 selectbox3
		String hiddenOpt2Sel4 = param.getString("hiddenOpt2Sel4");								// 동적 selectbox4
		String hiddenOpt1Text1 = param.getString("hiddenOpt1Text1");							// 동적 input=text1
		String hiddenOpt1Text2 = param.getString("hiddenOpt1Text2");							// 동적 input=text2
		String hiddenOpt2Text3 = param.getString("hiddenOpt2Text3");							// 동적 input=text3
		
		// 매체구분
		String newsCd = "";

		for(int i=0 ; i < newsCdParam.length ; i++ ){
			if(!"".equals(newsCdParam[i]) &&newsCdParam[i] != null){
				newsCd = newsCd + "'" + newsCdParam[i] + "',";
				logger.debug("로그 확인 newsCd["+i+"] : " + newsCdParam[i]);		
			}
		}
		newsCd = newsCd + "''" ;

		
		//지국 일 경우 지국에 대한 정보만 보여준다.
		HttpSession session = request.getSession();
		String boseq = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("print/ozConditionList");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_PRINT_J_CONDITION);

		// parameter
		mav.addObject("boseq", boseq);
		mav.addObject("listType", listType);
		mav.addObject("fromYyyymmdd", fromYyyymmdd.replace("-", ""));
		mav.addObject("toYyyymmdd", toYyyymmdd.replace("-", ""));
		mav.addObject("fromGno", fromGno);
		mav.addObject("toGno", toGno);
		mav.addObject("newsCd", newsCd);
		mav.addObject("order", order);
		mav.addObject("hiddenOpt2Sel1", hiddenOpt2Sel1);
		mav.addObject("hiddenOpt2Sel2", hiddenOpt2Sel2);
		mav.addObject("hiddenOpt2Sel3", hiddenOpt2Sel3);
		mav.addObject("hiddenOpt2Sel4", hiddenOpt2Sel4);
		mav.addObject("hiddenOpt1Text1", hiddenOpt1Text1);
		mav.addObject("hiddenOpt1Text2", hiddenOpt1Text2);
		mav.addObject("hiddenOpt2Text3", hiddenOpt2Text3);
		
		return mav;
	}
	
	

	
	/**
	 * 일일수금현황
	 * @category 일일수금현황
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView sugmState(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		//현재날짜
		Calendar rightNow = Calendar.getInstance();
		String year = String.valueOf(rightNow.get(Calendar.YEAR));
		String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));
		if (month.length() < 2)
			month = "0" + month;
		if (day.length() < 2)
			day = "0" + day;
		
		// param
		Param param = new HttpServletParam(request);
		String fromYymmdd = param.getString("fromYymmdd", year + "-" + month + "-" + day);				//기간 from
		String toYymmdd = param.getString("toYymmdd", year + "-" + month + "-" + day);					//기간 to
		String fromGno = param.getString("fromGno");													//구역from
		String toGno = param.getString("toGno");														//구역to
		String newsCd[] = param.getStringValues("newsCd",MK_NEWSPAPER_CODE);							//뉴스코드(최초에 매일경제값셋팅)
		if(newsCd.length == 0) newsCd = new String[] {MK_NEWSPAPER_CODE};  // 최초 매일경제값 세팅(param.getStringValues 가 제대로 안되서 추가)
		String gubun = param.getString("gubun","day");													//구분
		String dateGubun = param.getString("dateGubun","cldt");											//조회 기준일
			
		//지국 일 경우 지국에 대한 정보만 보여준다.
		HttpSession session = request.getSession();
		String boseq = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		if( StringUtils.isEmpty(boseq) ){
			ModelAndView mav = new ModelAndView();
			
			mav.setViewName("common/message");
			mav.addObject("message", "지국으로 접속해 주세요.");
			mav.addObject("returnURL", "/");
			return mav;
		}
		
		// db query parameter
		HashMap dbparam = new HashMap();
		dbparam.put("BOSEQ",boseq);
		dbparam.put("USEYN","Y");
		dbparam.put("CDCLSF",MK_NEWSPAPER_CODE);
		
		List gnoList = generalDAO.queryForList("print.print.getGnoList", dbparam);
		
		//신문명리스트
		List newsCodeList = null;
		
		if( StringUtils.isEmpty(boseq) ){
			newsCodeList = generalDAO.queryForList("statistics.stats.getNewsCodeList", dbparam);
		}else{
			newsCodeList = generalDAO.queryForList("statistics.stats.getNewsJikukCodeList", dbparam);
		}
		
		// db query parameter
		dbparam = new HashMap();
		dbparam.put("FROMYYMMDD",fromYymmdd.replace("-", ""));
		dbparam.put("TOYYMMDD",toYymmdd.replace("-", ""));
		dbparam.put("FROMGNO",fromGno);
		dbparam.put("TOGNO",toGno);
		dbparam.put("GUBUN",gubun);
		dbparam.put("DATEGUBUN",dateGubun);
		dbparam.put("NEWSCD",newsCd);
		dbparam.put("BOSEQ",boseq);
		
		// excute query
		List resultList = generalDAO.queryForList("print.print.getSugmList", dbparam);
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("print/sugmState");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_PRINT_J_DAILY);
		
		mav.addObject("fromYymmdd", fromYymmdd);
		mav.addObject("toYymmdd", toYymmdd);
		mav.addObject("newsCd", newsCd);
		mav.addObject("fromGno", fromGno);
		mav.addObject("toGno", toGno);
		
		mav.addObject("dateGubun", dateGubun);

		mav.addObject("gubun", gubun);
		mav.addObject("boseq", boseq);
	
		mav.addObject("gnoList", gnoList);
		mav.addObject("newsCodeList", newsCodeList);
		mav.addObject("resultList", resultList);
		
		return mav;
	}
	
	/**
	 * 일일수금현황 OZ 인쇄
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ozSugmState(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		//현재날짜
		Calendar rightNow = Calendar.getInstance();
		String year = String.valueOf(rightNow.get(Calendar.YEAR));
		String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));
		if (month.length() < 2)
			month = "0" + month;
		if (day.length() < 2)
			day = "0" + day;
		
		// param
		Param param = new HttpServletParam(request);
		String fromYymmdd = param.getString("fromYymmdd", year + "-" + month + "-" + day);				//기간 from
		String toYymmdd = param.getString("toYymmdd", year + "-" + month + "-" + day);					//기간 to
		String fromGno = param.getString("fromGno");													//구역from
		String toGno = param.getString("toGno");														//구역to
		String newsCdParam[] = param.getStringValues("newsCd",MK_NEWSPAPER_CODE);							//뉴스코드(최초에 매일경제값셋팅)
		if(newsCdParam.length == 0) newsCdParam = new String[] {MK_NEWSPAPER_CODE};  // 최초 매일경제값 세팅(param.getStringValues 가 제대로 안되서 추가)
		String gubun = param.getString("gubun","day");													//구분
		String dateGubun = param.getString("dateGubun","cldt");											//조회 기준일
		
		// 매체구분
				String newsCd = "";

				for(int i=0 ; i < newsCdParam.length ; i++ ){
					if(!"".equals(newsCdParam[i]) &&newsCdParam[i] != null){
						newsCd = newsCd + "'" + newsCdParam[i] + "',";
						logger.debug("로그 확인 newsCd["+i+"] : " + newsCdParam[i]);		
					}
				}
				newsCd = newsCd + "''" ;
		
		
		//지국 일 경우 지국에 대한 정보만 보여준다.
		HttpSession session = request.getSession();
		String boseq = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);

		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("print/ozSugmState");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_PRINT_J_DAILY);
		
		//parameter
		mav.addObject("fromYymmdd",fromYymmdd.replace("-", ""));
		mav.addObject("toYymmdd",toYymmdd.replace("-", ""));
		mav.addObject("fromGno",fromGno);
		mav.addObject("toGno",toGno);
		mav.addObject("gubun",gubun);
		mav.addObject("newsCd",newsCd);
		mav.addObject("boseq",boseq);
		mav.addObject("dateGubun",  dateGubun);		  									//조회 기준일
		
		return mav;
	}
	
	
	
	/**
	 * 입금내역현황
	 * @category 입금내역현황
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView detailState(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		//현재날짜
		Calendar rightNow = Calendar.getInstance();
		String year = String.valueOf(rightNow.get(Calendar.YEAR));
		String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));
		if (month.length() < 2)
			month = "0" + month;
		if (day.length() < 2)
			day = "0" + day;
		
		// param
		Param param = new HttpServletParam(request);
		String fromYymmdd = param.getString("fromYymmdd", year + "-" + month + "-" + day);				//기간 from
		String toYymmdd = param.getString("toYymmdd", year + "-" + month + "-" + day);					//기간 to
		String fromGno = param.getString("fromGno");													//구역from
		String toGno = param.getString("toGno");														//구역to
		String newsCd[] = param.getStringValues("newsCd",MK_NEWSPAPER_CODE);							//뉴스코드(최초에 매일경제값셋팅)
		if(newsCd.length == 0) newsCd = new String[] {MK_NEWSPAPER_CODE};  // 최초 매일경제값 세팅(param.getStringValues 가 제대로 안되서 추가)
		String gubun[] = param.getStringValues("gubun","011,012,013,021,022,023,024,031,032,033,044,088,099");												//구분
		String dateGubun = param.getString("dateGubun","icdt");											//조회 기준일
		
		//지국 일 경우 지국에 대한 정보만 보여준다.
		HttpSession session = request.getSession();
		String boseq = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		if( StringUtils.isEmpty(boseq) ){
			ModelAndView mav = new ModelAndView();
			
			mav.setViewName("common/message");
			mav.addObject("message", "지국으로 접속해 주세요.");
			mav.addObject("returnURL", "/");
			return mav;
		}
		
		// db query parameter
		HashMap dbparam = new HashMap();
		dbparam.put("BOSEQ",boseq);
		dbparam.put("USEYN","Y");
		dbparam.put("CDCLSF",MK_NEWSPAPER_CODE);
		
		List gnoList = generalDAO.queryForList("print.print.getGnoList", dbparam);
		
		//신문명리스트
		List newsCodeList = null;
		
		if( StringUtils.isEmpty(boseq) ){
			newsCodeList = generalDAO.queryForList("statistics.stats.getNewsCodeList", dbparam);
		}else{
			newsCodeList = generalDAO.queryForList("statistics.stats.getNewsJikukCodeList", dbparam);
		}
		
		// db query parameter
		dbparam = new HashMap();
		dbparam.put("FROMYYMMDD",fromYymmdd.replace("-", ""));
		dbparam.put("TOYYMMDD",toYymmdd.replace("-", ""));
		dbparam.put("FROMGNO",fromGno);
		dbparam.put("TOGNO",toGno);
		dbparam.put("GUBUN",gubun);
		dbparam.put("DATEGUBUN",dateGubun);
		dbparam.put("NEWSCD",newsCd);
		dbparam.put("BOSEQ",boseq);
		
		dbparam.put("GU", "구 ");  // 구
		dbparam.put("APT", "아파트");  // 아파트
		
		// excute query
		List resultList = null;
		// ip_check
		InetAddress AllIpData = InetAddress.getLocalHost();
		String ipConfirm = AllIpData.getHostAddress();
		/*
		if (!"218.144.58.97".equals(ipConfirm)) {
			resultList = generalDAO.queryForList("print.print.getDetailList", dbparam);	
		} else {
			resultList = generalDAO.queryForList("print.print.getDetailListForABC", dbparam); //abc용
		}
		
		*/
		System.out.println("=====================");
		resultList = generalDAO.queryForList("print.print.getDetailListForABC", dbparam); //abc용
		System.out.println("=====================adasdsads");
		Map result = null;
		String thisYearHistory = "";
		for(int i=0;i<resultList.size();i++){
			result  = (Map)resultList.get(i);
			if( result != null ){
				thisYearHistory = "";
				
				dbparam.put("readNo", result.get("READNO")); // 고객번호
				dbparam.put("newsCd", result.get("NEWSCD")); // 뉴스코드
				dbparam.put("seq", result.get("SEQ")); // 일련번호
				
				thisYearHistory = (String)generalDAO.queryForObject("collection.collection.sumgClamList", dbparam);//금년 독자 수금 이력 약어
				
				result.put("THISYEARHISTORY", thisYearHistory);
				
				resultList.set(i, result);
			}
		}
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("print/detailState");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_PRINT_J_INCOME);
		
		mav.addObject("fromYymmdd", fromYymmdd);
		mav.addObject("toYymmdd", toYymmdd);
		mav.addObject("newsCd", newsCd);
		mav.addObject("fromGno", fromGno);
		mav.addObject("toGno", toGno);
		
		mav.addObject("gubun", gubun);
		mav.addObject("dateGubun", dateGubun);
		mav.addObject("boseq", boseq);
	
		mav.addObject("gnoList", gnoList);
		mav.addObject("newsCodeList", newsCodeList);
		mav.addObject("resultList", resultList);
		
		return mav;
	}
	
	/**
	 * 입금내역현황 엑셀
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView detailState_excel(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		//현재날짜
		Calendar rightNow = Calendar.getInstance();
		String year = String.valueOf(rightNow.get(Calendar.YEAR));
		String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));
		if (month.length() < 2)
			month = "0" + month;
		if (day.length() < 2)
			day = "0" + day;
		
		// param
		Param param = new HttpServletParam(request);
		String fromYymmdd = param.getString("fromYymmdd", year + "-" + month + "-" + day);				//기간 from
		String toYymmdd = param.getString("toYymmdd", year + "-" + month + "-" + day);					//기간 to
		String fromGno = param.getString("fromGno");													//구역from
		String toGno = param.getString("toGno");														//구역to
		String newsCd[] = param.getStringValues("newsCd",MK_NEWSPAPER_CODE);							//뉴스코드(최초에 매일경제값셋팅)
		if(newsCd.length == 0) newsCd = new String[] {MK_NEWSPAPER_CODE};  // 최초 매일경제값 세팅(param.getStringValues 가 제대로 안되서 추가)
		String gubun[] = param.getStringValues("gubun","011,012,013,021,022,023,024,031,032,033,044,088,099");												//구분
		
		
		//지국 일 경우 지국에 대한 정보만 보여준다.
		HttpSession session = request.getSession();
		String boseq = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		// db query parameter
		HashMap dbparam = new HashMap();
		dbparam.put("BOSEQ",boseq);
		dbparam.put("USEYN","Y");
		dbparam.put("CDCLSF",MK_NEWSPAPER_CODE);
		
		List gnoList = generalDAO.queryForList("print.print.getGnoList", dbparam);
		
		//신문명리스트
		List newsCodeList = null;
		
		if( StringUtils.isEmpty(boseq) ){
			newsCodeList = generalDAO.queryForList("statistics.stats.getNewsCodeList", dbparam);
		}else{
			newsCodeList = generalDAO.queryForList("statistics.stats.getNewsJikukCodeList", dbparam);
		}
		
		// db query parameter
		dbparam = new HashMap();
		dbparam.put("FROMYYMMDD",fromYymmdd.replace("-", ""));
		dbparam.put("TOYYMMDD",toYymmdd.replace("-", ""));
		dbparam.put("FROMGNO",fromGno);
		dbparam.put("TOGNO",toGno);
		dbparam.put("GUBUN",gubun);
		dbparam.put("NEWSCD",newsCd);
		dbparam.put("BOSEQ",boseq);
		
		dbparam.put("GU", "구 ");  // 구
		dbparam.put("APT", "아파트");  // 아파트
		
		// excute query
		List resultList = generalDAO.queryForList("print.print.getDetailList", dbparam);
		
		Map result = null;
		String thisYearHistory = "";
		for(int i=0;i<resultList.size();i++){
			result  = (Map)resultList.get(i);
			if( result != null ){
				thisYearHistory = "";
				
				dbparam.put("readNo", result.get("READNO")); // 고객번호
				dbparam.put("newsCd", result.get("NEWSCD")); // 뉴스코드
				dbparam.put("seq", result.get("SEQ")); // 일련번호
				
				thisYearHistory = (String)generalDAO.queryForObject("collection.collection.sumgClamList", dbparam);//금년 독자 수금 이력 약어
				
				result.put("THISYEARHISTORY", thisYearHistory);
				
				resultList.set(i, result);
			}
		}
		
		String fileName = "입금내역현황.xls";
		
		//Excel response
		response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
		response.setHeader("Content-Description", "JSP Generated Data");
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("print/detailState_excel");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_PRINT_J_INCOME);
		
		mav.addObject("fromYymmdd", fromYymmdd);
		mav.addObject("toYymmdd", toYymmdd);
		mav.addObject("newsCd", newsCd);
		mav.addObject("fromGno", fromGno);
		mav.addObject("toGno", toGno);
		
		mav.addObject("gubun", gubun);
		mav.addObject("boseq", boseq);
	
		mav.addObject("gnoList", gnoList);
		mav.addObject("newsCodeList", newsCodeList);
		mav.addObject("resultList", resultList);
		
		return mav;
		
	}
	


	/**
	 * 입금내역현황 OZ인쇄
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ozDetailState(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		//현재날짜
		Calendar rightNow = Calendar.getInstance();
		String year = String.valueOf(rightNow.get(Calendar.YEAR));
		String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));
		if (month.length() < 2)
			month = "0" + month;
		if (day.length() < 2)
			day = "0" + day;
		
		// param
		Param param = new HttpServletParam(request);
		String fromYymmdd = param.getString("fromYymmdd", year + "-" + month + "-" + day);				//기간 from
		String toYymmdd = param.getString("toYymmdd", year + "-" + month + "-" + day);					//기간 to
		String fromGno = param.getString("fromGno");													//구역from
		String toGno = param.getString("toGno");														//구역to
		String newsCdParam[] = param.getStringValues("newsCd",MK_NEWSPAPER_CODE);							//뉴스코드(최초에 매일경제값셋팅)
		if(newsCdParam.length == 0) newsCdParam = new String[] {MK_NEWSPAPER_CODE};  // 최초 매일경제값 세팅(param.getStringValues 가 제대로 안되서 추가)
		String gubunCdParam[] = param.getStringValues("gubun","011,012,013,021,022,023,024,031,032,033,044,088,099");												//구분
		String dateGubun = param.getString("dateGubun","icdt");											//조회 기준일
		
		// 매체구분
		String newsCd = "";

		for(int i=0 ; i < newsCdParam.length ; i++ ){
			if(!"".equals(newsCdParam[i]) &&newsCdParam[i] != null){
				newsCd = newsCd + "'" + newsCdParam[i] + "',";
				logger.debug("로그 확인 newsCd["+i+"] : " + newsCdParam[i]);		
			}
		}
		newsCd = newsCd + "''" ;
		
		//수금구분
		String gubun = "";

		for(int i=0 ; i < gubunCdParam.length ; i++ ){
			if(!"".equals(gubunCdParam[i]) &&gubunCdParam[i] != null){
				gubun = gubun + "'" + gubunCdParam[i] + "',";
				logger.debug("로그 확인 gubun["+i+"] : " + gubunCdParam[i]);		
			}
		}
		gubun = gubun + "''" ;
		
		//지국 일 경우 지국에 대한 정보만 보여준다.
		HttpSession session = request.getSession();
		String boseq = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("print/ozDetailState");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_PRINT_J_INCOME);
		
		//  parameter
		mav.addObject("fromYymmdd",fromYymmdd.replace("-", ""));
		mav.addObject("toYymmdd",toYymmdd.replace("-", ""));
		mav.addObject("fromGno",fromGno);
		mav.addObject("toGno",toGno);
		mav.addObject("gubun",gubun);
		mav.addObject("newsCd",newsCd);
		mav.addObject("boseq",boseq);
		mav.addObject("dateGubun",  dateGubun);		  									//조회 기준일
		
		return mav;
	}
	/**
	 * 해지독자 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView stReaderList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		
		Param param = new HttpServletParam(request);
		HashMap dbparam = new HashMap();
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		try{
			String boseq = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
			
			// db query parameter
			dbparam.put("BOSEQ",boseq);
			dbparam.put("agency_serial", boseq);
			
			//화면에 표시할 기본 조회
			List newSList = generalDAO.queryForList("reader.common.retrieveNewsList", dbparam);//신문명
			List gnoList = generalDAO.queryForList("print.print.getGnoList", dbparam);//구역 리스트
			List stSayouList = generalDAO.queryForList("reader.common.retrieveStSayou", dbparam);//해지 사유 리스트
			List nowYYMM = generalDAO.queryForList("common.getLastSGYYMM2", dbparam);//사용년월
			
			String newsCd[] =  param.getStringValues("newsCd",MK_NEWSPAPER_CODE);
			if(newsCd.length == 0) newsCd = new String[] {MK_NEWSPAPER_CODE};  // 최초 매일경제값 세팅(param.getStringValues 가 제대로 안되서 추가)
			if(newsCd != null ){
				dbparam.put("check", param.getString("check"));
				dbparam.put("fromGno", param.getString("fromGno"));		
				dbparam.put("toGno", param.getString("toGno"));	
				dbparam.put("fromDate", StringUtil.replace(param.getString("fromDate"), "-", ""));
				dbparam.put("toDate", StringUtil.replace(param.getString("toDate"), "-", ""));
				dbparam.put("searchText", param.getString("searchText"));
				dbparam.put("stSayou", param.getString("stSayou"));
				dbparam.put("newsCd", newsCd);
				dbparam.put("remk", param.getString("remk"));
				dbparam.put("sort", param.getString("sort"));

				if("5".equals(param.getString("check"))){//해지사유별 통계
					List sayouStatic	= generalDAO.queryForList("print.print.sayouStatic", dbparam);//구독년월별 통계
					mav.addObject("sayouStatic" , sayouStatic	);
				}else if("6".equals(param.getString("check"))){//구독년월별 통계
					List yearStatic	= generalDAO.queryForList("print.print.yearStatic", dbparam);//구독년월별 통계
					mav.addObject("yearStatic" , yearStatic	);
				}else{
					List stReaderList = generalDAO.queryForList("print.print.stReaderList", dbparam);//해지독자 조회
					mav.addObject("stReaderList" , stReaderList);
				}
				mav.addObject("newsCd" , newsCd);
				mav.addObject("param" , param);
				mav.addObject("nowYYMM" , nowYYMM);
			}
		
			
			mav.addObject("newSList" , newSList);
			mav.addObject("gnoList", gnoList);
			mav.addObject("stSayouList", stSayouList);
			mav.addObject("now_menu", ICodeConstant.MENU_CODE_PRINT_J_STOP);
			mav.setViewName("print/stReaderList");
			return mav;
		}catch(Exception e){
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
		
	}
	

	
	/**
	 * 해지독자 조회 - OZ인쇄
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ozStReaderList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		
		Param param = new HttpServletParam(request);
		HashMap dbparam = new HashMap();
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		try{
			String boseq = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
			
			String newsCdParam[] =  param.getStringValues("newsCd","MK_NEWSPAPER_CODE");
			if(newsCdParam.length == 0) newsCdParam = new String[] {MK_NEWSPAPER_CODE};  // 최초 매일경제값 세팅(param.getStringValues 가 제대로 안되서 추가)
			
			// 매체구분
			String newsCd = "";

			for(int i=0 ; i < newsCdParam.length ; i++ ){
				if(!"".equals(newsCdParam[i]) &&newsCdParam[i] != null){
					newsCd = newsCd + "'" + newsCdParam[i] + "',";
					logger.debug("로그 확인 newsCd["+i+"] : " + newsCdParam[i]);		
				}
			}
			newsCd = newsCd + "''" ;
			
			mav.addObject("boseq", boseq);
			mav.addObject("check", param.getString("check"));
			mav.addObject("fromGno", param.getString("fromGno"));		
			mav.addObject("toGno", param.getString("toGno"));	
			mav.addObject("fromDate", StringUtil.replace(param.getString("fromDate"), "-", ""));
			mav.addObject("toDate", StringUtil.replace(param.getString("toDate"), "-", ""));
			mav.addObject("searchText", param.getString("searchText"));
			mav.addObject("stSayou", param.getString("stSayou"));
			mav.addObject("newsCd", newsCd);
			mav.addObject("sort", param.getString("sort"));
			
			if("5".equals(param.getString("check"))){   //해지사유별 통계
				mav.addObject("type" , "stReaderList2");
			}else if("6".equals(param.getString("check"))){   //구독년월별 통계
				mav.addObject("type" , "stReaderList3");
			}else{  // 명단
				mav.addObject("type" , "stReaderList");
			}

			mav.addObject("now_menu", ICodeConstant.MENU_CODE_PRINT_J_STOP);
			mav.setViewName("print/ozStReaderList");
			return mav;
		}catch(Exception e){
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
		
	}
	
	
	/**
	 * 미수독자현황
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView misuState(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		//현재날짜
		Calendar rightNow = Calendar.getInstance();
		String year = String.valueOf(rightNow.get(Calendar.YEAR));
		String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));
		if (month.length() < 2)
			month = "0" + month;
		if (day.length() < 2)
			day = "0" + day;
		
		// param
		Param param = new HttpServletParam(request);
		String fromYymm = param.getString("fromYymm", year + "-" + month);				//기간 from
		String toYymm = param.getString("toYymm", year + "-" + month);					    //기간 to
		String fromGno = param.getString("fromGno");													//구역from
		String toGno = param.getString("toGno");														//구역to
		String newsCd[] = param.getStringValues("newsCd",MK_NEWSPAPER_CODE);		//뉴스코드(최초에 매일경제값셋팅)
		if(newsCd.length == 0) newsCd = new String[] {MK_NEWSPAPER_CODE};  // 최초 매일경제값 세팅(param.getStringValues 가 제대로 안되서 추가)
		String gubun = param.getString("gubun","1");													//구분
		String streader = param.getString("streader","");												//중지포함여부
		
		//지국 일 경우 지국에 대한 정보만 보여준다.
		HttpSession session = request.getSession();
		String boseq = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		if( StringUtils.isEmpty(boseq) ){
			ModelAndView mav = new ModelAndView();
			
			mav.setViewName("common/message");
			mav.addObject("message", "지국으로 접속해 주세요.");
			mav.addObject("returnURL", "/");
			return mav;
		}
		
		// db query parameter
		HashMap dbparam = new HashMap();
		dbparam.put("BOSEQ",boseq);
		dbparam.put("USEYN","Y");
		dbparam.put("CDCLSF",MK_NEWSPAPER_CODE);
		
		List yymm = generalDAO.queryForList("print.print.misuYYMM", dbparam);
		List gnoList = generalDAO.queryForList("print.print.getGnoList", dbparam);
		
		//신문명리스트
		List newsCodeList = null;
		
		if( StringUtils.isEmpty(boseq) ){
			newsCodeList = generalDAO.queryForList("statistics.stats.getNewsCodeList", dbparam);
		}else{
			newsCodeList = generalDAO.queryForList("statistics.stats.getNewsJikukCodeList", dbparam);
		}
		
		// db query parameter
		dbparam = new HashMap();
		dbparam.put("GU", "구 ");  // 구
		dbparam.put("APT", "아파트");  // 아파트
		dbparam.put("FROMYYMM",fromYymm);
		dbparam.put("TOYYMM",toYymm);
		dbparam.put("FROMGNO",fromGno);
		dbparam.put("TOGNO",toGno);
		dbparam.put("GUBUN",gubun);
		dbparam.put("NEWSCD",newsCd);
		dbparam.put("BOSEQ",boseq);
		dbparam.put("STREADER",streader);
		
		// excute query
		List resultList = generalDAO.queryForList("print.print.getMisuList", dbparam);
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("print/misuState");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_PRINT_J_NOPAIED);
		
		mav.addObject("fromYymm", fromYymm);
		mav.addObject("toYymm", toYymm);
		mav.addObject("newsCd", newsCd);
		mav.addObject("fromGno", fromGno);
		mav.addObject("toGno", toGno);
		
		mav.addObject("gubun", gubun);
		mav.addObject("boseq", boseq);
		mav.addObject("streader",streader);
		
		mav.addObject("yymm", yymm);
		mav.addObject("gnoList", gnoList);
		mav.addObject("newsCodeList", newsCodeList);
		mav.addObject("resultList", resultList);

		return mav;
	}


	/**
	 * 미수독자현황 - OZ인쇄
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ozMisuState(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		//현재날짜
		Calendar rightNow = Calendar.getInstance();
		String year = String.valueOf(rightNow.get(Calendar.YEAR));
		String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));
		if (month.length() < 2)
			month = "0" + month;
		if (day.length() < 2)
			day = "0" + day;
		
		// param
		Param param = new HttpServletParam(request);
		String fromYymm = param.getString("fromYymm", year + "-" + month);				//기간 from
		String toYymm = param.getString("toYymm", year + "-" + month);					    //기간 to
		String fromGno = param.getString("fromGno");													//구역from
		String toGno = param.getString("toGno");														//구역to
		String newsCdParam[] = param.getStringValues("newsCd",MK_NEWSPAPER_CODE);		//뉴스코드(최초에 매일경제값셋팅)
		if(newsCdParam.length == 0) newsCdParam = new String[] {MK_NEWSPAPER_CODE};  // 최초 매일경제값 세팅(param.getStringValues 가 제대로 안되서 추가)
		String gubun = param.getString("gubun","1");													//구분
		String streader = param.getString("streader","");												//중지포함여부
		
		//지국 일 경우 지국에 대한 정보만 보여준다.
		HttpSession session = request.getSession();
		String boseq = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		if( StringUtils.isEmpty(boseq) ){
			ModelAndView mav = new ModelAndView();
			
			mav.setViewName("common/message");
			mav.addObject("message", "지국으로 접속해 주세요.");
			mav.addObject("returnURL", "/");
			return mav;
		}
		
		// 매체구분
				String newsCd = "";

				for(int i=0 ; i < newsCdParam.length ; i++ ){
					if(!"".equals(newsCdParam[i]) &&newsCdParam[i] != null){
						newsCd = newsCd + "'" + newsCdParam[i] + "',";
						logger.debug("로그 확인 newsCd["+i+"] : " + newsCdParam[i]);		
					}
				}
				newsCd = newsCd + "''" ;
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("print/ozMisuState");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_PRINT_J_NOPAIED);
		
		mav.addObject("fromYymm", fromYymm);
		mav.addObject("toYymm", toYymm);
		mav.addObject("newsCd", newsCd);
		mav.addObject("fromGno", fromGno);
		mav.addObject("toGno", toGno);
		mav.addObject("gubun", gubun);
		mav.addObject("boseq", boseq);
		mav.addObject("streader",streader);

		return mav;
	}
	
	

	/**
	 * 독자통계현황
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView readerState(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		// param
		Param param = new HttpServletParam(request);
		String newsCd[] = param.getStringValues("newsCd",MK_NEWSPAPER_CODE);		//뉴스코드(최초에 매일경제값셋팅)
		if(newsCd.length == 0) newsCd = new String[] {MK_NEWSPAPER_CODE};  // 최초 매일경제값 세팅(param.getStringValues 가 제대로 안되서 추가)
		
		String gubun = param.getString("gubun","6");													//구분
		
		System.out.println("gubun = "+gubun);
		
		//지국 일 경우 지국에 대한 정보만 보여준다.
		HttpSession session = request.getSession();
		String boseq = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		System.out.println(" boseq = "+ boseq);
		
		if( StringUtils.isEmpty(boseq) ){
			ModelAndView mav = new ModelAndView();
			
			mav.setViewName("common/message");
			mav.addObject("message", "지국으로 접속해 주세요.");
			mav.addObject("returnURL", "/");
			return mav;
		}
		
		// db query parameter
		HashMap dbparam = new HashMap();
		dbparam.put("BOSEQ",boseq);
		dbparam.put("USEYN","Y");
		dbparam.put("CDCLSF",MK_NEWSPAPER_CODE);

		//신문명리스트
		List newsCodeList = null;
		
		if( StringUtils.isEmpty(boseq) ){
			newsCodeList = generalDAO.queryForList("statistics.stats.getNewsCodeList", dbparam);
		}else{
			newsCodeList = generalDAO.queryForList("statistics.stats.getNewsJikukCodeList", dbparam);
		}
		
		// db query parameter
		dbparam = new HashMap();
		dbparam.put("GUBUN",gubun);
		dbparam.put("NEWSCD",newsCd);
		dbparam.put("BOSEQ",boseq);
		
		List resultList;
		// mav
		ModelAndView mav = new ModelAndView();
		
		// excute query
		if(gubun.equals("1")){
			resultList = generalDAO.queryForList("print.print.getReaderList1", dbparam);
		}else if(gubun.equals("2")){
			resultList = generalDAO.queryForList("print.print.getReaderList2", dbparam);
		}else if(gubun.equals("3")){
			resultList = generalDAO.queryForList("print.print.getReaderList3", dbparam);
		}else if(gubun.equals("4")){
			resultList = generalDAO.queryForList("print.print.getReaderList4", dbparam);
		}else if(gubun.equals("5")){
			resultList = generalDAO.queryForList("print.print.getReaderList5", dbparam);
		}else{
			resultList = generalDAO.queryForList("print.print.getReaderList1", dbparam);
			List resultList2 = generalDAO.queryForList("print.print.getReaderList2", dbparam);
			List resultList3 = generalDAO.queryForList("print.print.getReaderList3", dbparam);
			List resultList4 = generalDAO.queryForList("print.print.getReaderList4", dbparam);
			List resultList5 = generalDAO.queryForList("print.print.getReaderList5", dbparam);
			mav.addObject("resultList2", resultList2);
			mav.addObject("resultList3", resultList3);
			mav.addObject("resultList4", resultList4);
			mav.addObject("resultList5", resultList5);
		}
		
		

		mav.setViewName("print/readerState");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_PRINT_J_READER);
		mav.addObject("newsCd", newsCd);
		
		mav.addObject("gubun", gubun);
		mav.addObject("boseq", boseq);
		
		mav.addObject("newsCodeList", newsCodeList);
		mav.addObject("resultList", resultList);

		return mav;
	}


	/**
	 * 독자통계현황 - OZ인쇄
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ozReaderState(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		// param
		Param param = new HttpServletParam(request);
		String newsCdParam[] = param.getStringValues("newsCd",MK_NEWSPAPER_CODE);		//뉴스코드(최초에 매일경제값셋팅)
		if(newsCdParam.length == 0) newsCdParam = new String[] {MK_NEWSPAPER_CODE};  // 최초 매일경제값 세팅(param.getStringValues 가 제대로 안되서 추가)
		String gubun = param.getString("gubun","1");													//구분
		
		//지국 일 경우 지국에 대한 정보만 보여준다.
		HttpSession session = request.getSession();
		String boseq = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		

		// 매체구분
	    String newsCd ="";
		for(int i=0 ; i < newsCdParam.length ; i++ ){
			if(!"".equals(newsCdParam[i]) &&newsCdParam[i] != null){
				newsCd = newsCd + "'" + newsCdParam[i] + "',";
				logger.debug("로그 확인 newsCd["+i+"] : " + newsCdParam[i]);		
			}
		}
		newsCd = newsCd + "''" ;

		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("print/ozReaderState");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_PRINT_J_READER);
		mav.addObject("newsCd", newsCd);
		mav.addObject("gubun", gubun);
		mav.addObject("boseq", boseq);
		
		return mav;
	}
	

	/**
	 * 지대 입금현황(본사)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView jidaeList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		HttpSession session = request.getSession(true);
		HashMap dbparam = new HashMap();
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		
		//현재날짜
		Calendar rightNow = Calendar.getInstance();
		String year = String.valueOf(rightNow.get(Calendar.YEAR));
		String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		if (month.length() < 2)			month = "0" + month;
		
		// param
		String fromYymm = param.getString("fromYymm", year + month);				//기간 from
		String type = param.getString("type","");													//구분
		String manager = param.getString("manager");
		String txt = param.getString("txt");
		
		String printBoseq = "";
		List<Object> agencyAllList = null;
		Map agencyListMap = null;
		
		System.out.println("type = "+type);
		
		
		//로그인 아이디
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_ADMIN_USERID));
		dbparam.put("userId", userId);
		
		//영업담당여부체크
		String chkSellerYn = (String) generalDAO.queryForObject("management.jidae.chkSellerYn", dbparam);
		
		//관리자, 관리팀여부체크
		String chkAdminMngYn = (String) generalDAO.queryForObject("management.jidae.chkAdminMngYn", dbparam);
		
		//영업담당일때만 지국조회
		if("Y".equals(chkSellerYn)) { 
			//담당코드 가져오기
			String localCode = (String) generalDAO.queryForObject("management.jidae.selectLocalCodeBySeller", dbparam);
			
			//담당부서코드 가져오기
			String compCd = (String) generalDAO.queryForObject("management.jidae.selectCompcdBySeller", dbparam);
			
			if("82105".equals(compCd)) {
				type= "수도권1";
			} else if("82106".equals(compCd)) {
				type= "수도권2";
			} else if("82104".equals(compCd)) {
				type= "지방판매";
			}
			
			dbparam.put("localCode", localCode);
			//지국목록
			agencyAllList = generalDAO.queryForList("reader.common.agencyListByLocalCode", dbparam);// 지국 목록 
			
			//전체지국 출력용
			for(int i=0;i<agencyAllList.size();i++) {
				agencyListMap = (Map)agencyAllList.get(i);
				//printBoseq += "'"+agencyListMap.get("USERID")+"',";
				printBoseq += agencyListMap.get("USERID")+",";
				agencyListMap = null;
			}
			
			if(printBoseq.length() > 1) {
				printBoseq = printBoseq.substring(0, printBoseq.length()-1);
			}
		} else if("Y".equals(chkAdminMngYn)){
			//지국목록
			agencyAllList = generalDAO.queryForList("reader.common.agencyListByAlive" );
			
			//전체지국 출력용
			for(int i=0;i<agencyAllList.size();i++) {
				agencyListMap = (Map)agencyAllList.get(i);
				//printBoseq += "'"+agencyListMap.get("USERID")+"',";
				printBoseq += agencyListMap.get("USERID")+",";
				agencyListMap = null;
			}
			
			if(printBoseq.length() > 1) {
				printBoseq = printBoseq.substring(0, printBoseq.length()-1);
			}
		}

		List yymm = generalDAO.queryForList("print.print.getJidaeYYMM", dbparam);
				
		// db query parameter
		dbparam = new HashMap();
		dbparam.put("FROMYYMM",fromYymm);
		dbparam.put("TOYYMM",fromYymm);
		dbparam.put("TYPE",type);
		dbparam.put("txt",txt);
		
		//System.out.println("dbparam = "+dbparam);
		String userName = (String)generalDAO.queryForObject("admin.getUserName", dbparam);
		dbparam.put("manager", userName); 
		
		System.out.println("userId = "+userId);
		System.out.println("dbparam = "+dbparam);
		System.out.println("type = "+type);
		
		// excute query
		List resultList = generalDAO.queryForList("print.print.getJidaeList", dbparam);
		List mngCb = generalDAO.queryForList("management.adminManage.getManager");  // 지국 담당자 조회
		
		System.out.println("resultList = "+resultList);
		
		// mav
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_MANAGEMENT_JIDAELIST);
		mav.addObject("fromYymm", fromYymm);
		mav.addObject("txt", txt);
		mav.addObject("type", type);
		mav.addObject("manager", manager);
		mav.addObject("yymm", yymm);
		mav.addObject("mngCb", mngCb);
		mav.addObject("resultList", resultList);
		mav.addObject("chkSellerYn",chkSellerYn); 					//영업담당여부
		mav.addObject("chkAdminMngYn",chkAdminMngYn);	//관리자, 관리팀여부
		mav.addObject("printBoseq", printBoseq); 
		mav.addObject("agencyAllList",agencyAllList);
		mav.setViewName("print/jidaeList");

		return mav;
	}


	/**
	 * 지대 입금현황(지국)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView jidaeListAgency(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		HashMap dbparam = new HashMap();
		List<Object> agencyAllList = null;
		Map agencyListMap = null;
		String printBoseq = "";
		List<Object> yymmList = new ArrayList();
		
		//현재날짜
		Calendar cal = Calendar.getInstance();
		
		//현재달부터 일년날짜 계산
		String tmpYear = "";
		int intMonth =0;
		String tmpMonth = "";
		String tmpYYMM = "";
		for(int i=0;i<12;i++) {
			cal.add(cal.MONTH, -1);
			tmpYear = Integer.toString(cal.get(cal.YEAR));
			intMonth =cal.get(cal.MONTH)+1;
			if(intMonth<10) {
				tmpMonth = "0"+Integer.toString(intMonth);
			} else {
				tmpMonth = Integer.toString(intMonth);
			}
			tmpYYMM =  tmpYear+tmpMonth;
			//yymmParam.put("yymm"+i, tmpYYMM);
			yymmList.add(tmpYYMM);
		}
		
		//마지막 지대년월가져오기
		String lastYYMM = (String)generalDAO.queryForObject("management.jidae.getJidaeLastYymm");
		String lastYear = "";
		String lastMonth = "";
		
		if(lastYYMM != null) {
			lastYear = lastYYMM.substring(0, 4);
			lastMonth = lastYYMM.substring(4, 6);
		}
		
		// param
		Param param = new HttpServletParam(request);
		String fromYymm = param.getString("fromYymm", lastYear+lastMonth);				//기간 from
		String toYymm = param.getString("toYymm", lastYear+lastMonth);					    //기간 to
		String type = "";
		
		//지국 일 경우 지국에 대한 정보만 보여준다.
		HttpSession session = request.getSession();
		String boseq = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		String opBoseq = param.getString("opBoseq", boseq);
		dbparam.put("boseq", boseq);
		
		//지사여부체크
		String chkSellerYn = (String) generalDAO.queryForObject("management.jidae.chkJisaYn", dbparam);
		
		//영업담당일때만 지국조회
		if("Y".equals(chkSellerYn)) { 
			//담당코드 가져오기
			String localCode = (String) generalDAO.queryForObject("management.jidae.selectLocalCode", dbparam);
			
			dbparam.put("localCode", localCode);
			//지국목록
			agencyAllList = generalDAO.queryForList("reader.common.agencyListByLocalCode", dbparam);// 지국 목록
			
			//전체지국 출력용
			for(int i=0;i<agencyAllList.size();i++) {
				agencyListMap = (Map)agencyAllList.get(i);
				//printBoseq += "'"+agencyListMap.get("USERID")+"',";
				printBoseq += agencyListMap.get("USERID")+",";
				agencyListMap = null;
			}
			
			if(printBoseq.length() > 1) {
				printBoseq = printBoseq.substring(0, printBoseq.length()-1);
			}
		}
		
		if( StringUtils.isEmpty(boseq) ){
			ModelAndView mav = new ModelAndView();
			
			mav.setViewName("common/message");
			mav.addObject("message", "지국으로 접속해 주세요.");
			mav.addObject("returnURL", "/");
			return mav;
		}
		
		dbparam.put("BOSEQ",boseq);
		int agencyCnt = (Integer) generalDAO.queryForObject("print.print.getJidaeArea", dbparam);
		
		if ( agencyCnt > 0 ) {
			type = "수도권1부";
		} else {
			type = "수도권2부";
		}

		String area1 = (String) generalDAO.queryForObject("print.print.getArea1Cd", dbparam);		
		
		// db query parameter
		dbparam = new HashMap();
		dbparam.put("FROMYYMM",fromYymm);
		dbparam.put("TOYYMM",toYymm);
	
		dbparam.put("BOSEQ",opBoseq);
		
		// excute query
		List resultList = generalDAO.queryForList("print.print.getJidaeList", dbparam);
		
		// mav
		ModelAndView mav = new ModelAndView();
		
		dbparam.put("userId",boseq);
		List jikyungYn = generalDAO.queryForList("output.billOutput.getJikyung" , dbparam);  // 직영여부 조회
		if(jikyungYn.size()!=0){
			mav.addObject("jikyungYn", "1");
		}
		
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_MANAGEMENT_JIDAELIST);
		
		mav.addObject("fromYymm", fromYymm);
		mav.addObject("toYymm", toYymm);
		
		mav.addObject("type", type);
		mav.addObject("opBoseq", opBoseq);
		mav.addObject("area1", area1);
		
		mav.addObject("yymmList",  yymmList);
		mav.addObject("resultList", resultList);
		mav.addObject("agencyAllList" , agencyAllList);
		mav.addObject("chkSellerYn", chkSellerYn);
		mav.addObject("printBoseq", printBoseq);
		
		mav.setViewName("print/jidaeListAgency");
		return mav;
	}
	
	
	/**
	 * 지대 입금현황(본사)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView excelJidaeList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		HttpSession session = request.getSession(true);
		HashMap dbparam = new HashMap();
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		
		try{
		
			// param
			String fromYymm = param.getString("fromYymm");				//기간 from
			String type = param.getString("type");													//구분
			String manager = param.getString("manager");
			String txt = param.getString("txt");
			String printBoseq = param.getString("printBoseq");
			
			List<Object> agencyAllList = null;
			Map agencyListMap = null;
			
			
			//로그인 아이디
			String userId = String.valueOf(session.getAttribute( SESSION_NAME_ADMIN_USERID));
			dbparam.put("userId", userId);
			
			//영업담당여부체크
			String chkSellerYn = (String) generalDAO.queryForObject("management.jidae.chkSellerYn", dbparam);
			
			//관리자, 관리팀여부체크
			String chkAdminMngYn = (String) generalDAO.queryForObject("management.jidae.chkAdminMngYn", dbparam);
			
			//영업담당일때만 지국조회
			if("Y".equals(chkSellerYn)) { 
				//담당코드 가져오기
				String localCode = (String) generalDAO.queryForObject("management.jidae.selectLocalCodeBySeller", dbparam);
				
				//담당부서코드 가져오기
				String compCd = (String) generalDAO.queryForObject("management.jidae.selectCompcdBySeller", dbparam);
				
				if("82105".equals(compCd)) {
					type= "수도권1";
				} else if("82106".equals(compCd)) {
					type= "수도권2";
				} else if("82104".equals(compCd)) {
					type= "지방판매";
				}
			} 
	
					
			// db query parameter
			dbparam = new HashMap();
			dbparam.put("FROMYYMM",fromYymm);
			dbparam.put("TOYYMM",fromYymm);
			dbparam.put("TYPE",type);
			dbparam.put("manager", manager); 
			dbparam.put("txt",txt);
			
			// excute query
			List resultList = generalDAO.queryForList("print.print.getJidaeList", dbparam);
			
			String fileName = "지대리스트_(" +fromYymm+ ").xls";
			//Excel response
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName); 
			response.setHeader("Content-Description", "JSP Generated Data");
			
			// mav
			mav.addObject("fromYymm", fromYymm);
			mav.addObject("txt", txt);
			mav.addObject("type", type);
			mav.addObject("manager", manager);
			mav.addObject("resultList", resultList);
			mav.addObject("printBoseq", printBoseq); 
			mav.setViewName("print/excelJidaeList");
	
		} catch(Exception e) {
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
		}
		return mav;
	}
	
	
	/**
	 * 본사신청구독통계 조회
	 * @category 본사신청구독통계 조회
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView officeReaderState(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		ModelAndView mav = new ModelAndView();
		
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
			
			dbparam.put("fromDate", StringUtil.replace(fromDate, "-", ""));
			dbparam.put("toDate", StringUtil.replace(toDate, "-", ""));

			List officelist = generalDAO.queryForList("print.print.getOfficeReaderState" , dbparam); // 본사구독현황 조회
			
			mav.addObject("officelist", officelist);

			mav.addObject("fromDate",fromDate);
			mav.addObject("toDate",toDate);
			
			mav.addObject("now_menu", MENU_CODE_PRINT_REDEAR_STATS);
			mav.setViewName("print/officeReaderState");	
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
	 * 본사신청구독통계 엑셀저장
	 * @category 본사신청구독통계 엑셀저장
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView officeReaderStateExcel(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		ModelAndView mav = new ModelAndView();
		
		HashMap dbparam = new HashMap();
		Param param = new HttpServletParam(request);
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			dbparam.put("fromDate", StringUtil.replace(param.getString("fromDate"), "-", ""));
			dbparam.put("toDate", StringUtil.replace(param.getString("toDate"), "-", ""));
			
			if(!"".equals(param.getString("fromDate")) && !"".equals(param.getString("toDate"))){
				dbparam.put("month", StringUtil.replace(param.getString("fromDate"), "-", "").substring(4,6));
				dbparam.put("year", StringUtil.replace(param.getString("fromDate"), "-", "").subSequence(0, 4));
				
				List officelist = generalDAO.queryForList("print.print.getOfficeReaderState" , dbparam); // 본사구독현황 조회
				
				mav.addObject("officelist", officelist);
				mav.addObject("fromDate",param.getString("fromDate"));
				mav.addObject("toDate",param.getString("toDate"));
			}
			
			String fileName = "officelist_(" + DateUtil.getCurrentDate("yyyyMMdd") + ").xls";
			//Excel response
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName); 
			response.setHeader("Content-Description", "JSP Generated Data");
			mav.setViewName("print/officeReaderStateExcel");	
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
	 * 본사신청중지현황 조회
	 * @category 본사신청중지현황 조회
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView stopOfficeReaderList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		ModelAndView mav = new ModelAndView();
		
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
			
			dbparam.put("fromDate", StringUtil.replace(fromDate, "-", ""));
			dbparam.put("toDate", StringUtil.replace(toDate, "-", ""));
			dbparam.put("searchTyp", param.getString("searchTyp"));
			dbparam.put("searchVal", param.getString("searchVal"));

			List stopOfficeReaderList = generalDAO.queryForList("print.print.getStopOfficeReaderList" , dbparam); // 본사신청중지현황 조회
			
			mav.addObject("stopOfficeReaderList", stopOfficeReaderList);

			mav.addObject("fromDate",fromDate);
			mav.addObject("toDate",toDate);
			mav.addObject("searchTyp",param.getString("searchTyp"));
			mav.addObject("searchTyp",param.getString("searchVal"));
			
			mav.addObject("now_menu", MENU_CODE_PRINT_REDEAR_STOP);
			mav.setViewName("print/stopOfficeReaderState");
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
	 * 본사신청구독통계 엑셀저장
	 * @category 본사신청구독통계 엑셀저장
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView stopOfficeReaderListExcel(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		ModelAndView mav = new ModelAndView();
		
		HashMap dbparam = new HashMap();
		Param param = new HttpServletParam(request);
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			dbparam.put("fromDate", StringUtil.replace(param.getString("fromDate"), "-", ""));
			dbparam.put("toDate", StringUtil.replace(param.getString("toDate"), "-", ""));
			
			if(!"".equals(param.getString("fromDate")) && !"".equals(param.getString("toDate"))){
				dbparam.put("month", StringUtil.replace(param.getString("fromDate"), "-", "").substring(4,6));
				dbparam.put("year", StringUtil.replace(param.getString("fromDate"), "-", "").subSequence(0, 4));
				
				List stopOfficeReaderList = generalDAO.queryForList("print.print.getStopOfficeReaderList" , dbparam); // 본사구독현황 조회
				
				mav.addObject("stopOfficeReaderList", stopOfficeReaderList);
				mav.addObject("fromDate",param.getString("fromDate"));
				mav.addObject("toDate",param.getString("toDate"));
			}
			
			String fileName = "stopOfficelist_(" + DateUtil.getCurrentDate("yyyyMMdd") + ").xls";
			//Excel response
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName); 
			response.setHeader("Content-Description", "JSP Generated Data");
			mav.setViewName("print/stopOfficeReaderStateExcel");	
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
	 * 월별 수금현황
	 * @category 월별 수금현황
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView moveYearsSugmStat(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		HashMap dbparam = new HashMap();
		
		//현재날짜
		Calendar rightNow = Calendar.getInstance();
		String years = String.valueOf(rightNow.get(Calendar.YEAR));
		
		try{
			
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			String loginId = (String)session.getAttribute(SESSION_NAME_AGENCY_SERIAL);
			// 본사 권한 확인
			// 지국인 경우 당해 월별 수금 현황 조회
			if(!"A".equals(loginType)){
				dbparam.put("boseq", loginId);
				dbparam.put("years",  years);
				List yearsSugmList = generalDAO.queryForList("print.print.yearSugmStats" , dbparam); // 월별 수금 현황				
				mav.addObject("boseq", loginId);
				mav.addObject("years", years);
				mav.addObject("yearsSugmList", yearsSugmList);
			// 본사인 경우 지국목록 조회, 수금 현황은 조회 하지 않음
			}else{
				List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" , dbparam);// 지국 목록
				mav.addObject("agencyAllList" , agencyAllList);				
			}
			
			List yearsList = generalDAO.queryForList("print.print.yearsList" , dbparam);// 조회가능년도 목록 -2년

			mav.addObject("yearsList" , yearsList);
			mav.addObject("loginType" , loginType);
			mav.addObject("now_menu", MENU_CODE_PRINT);
			mav.setViewName("print/yearsSugmStat");
			return mav;

		}catch(Exception e){
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	
	/**
	 * 월별 수금현황 조회
	 * @category 월별 수금현황 조회
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */	
	public ModelAndView searchSugmStats(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			HashMap dbparam = new HashMap();

			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" , dbparam);// 지국 목록
			dbparam.put("boseq",  param.getString("boseq"));
			dbparam.put("years",  param.getString("years"));
			List yearsSugmList = generalDAO.queryForList("print.print.yearSugmStats" , dbparam); // 월별 수금 현황
			List yearsList = generalDAO.queryForList("print.print.yearsList" , dbparam);// 조회가능년도 목록 -2년

			mav.addObject("yearsList" , yearsList);		
			mav.addObject("loginType", loginType);
			mav.addObject("param", param);
			mav.addObject("boseq", param.getString("boseq"));
			mav.addObject("years", param.getString("years"));
			mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("yearsSugmList", yearsSugmList);
			mav.addObject("now_menu", MENU_CODE_PRINT);
			mav.setViewName("print/yearsSugmStat");
			return mav;
		}catch(Exception e){
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	
	
	/**
	 * 지국별 본사독자 실사현황
	 * @category 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView viewJikukSilsaStats(HttpServletRequest request,HttpServletResponse response) {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		try {
			HashMap dbparam = new HashMap();
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			String boseq = param.getString("boseq");
			String yyyy = param.getString("yyyy");
			
			dbparam.put("boseq",boseq);
			dbparam.put("yyyy",yyyy);
			
			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" , dbparam);// 지국 목록
			
			List silsaList = null;
			if(!boseq.isEmpty() && !yyyy.isEmpty()){
				if(!boseq.equals(""))
					silsaList = (List)generalDAO.queryForList("print.print.getJikukSilsaStats",dbparam);
			}
			if(silsaList != null)
				System.out.println(silsaList.toString());
			mav.addObject("loginType", loginType);
			mav.addObject("param", param);
			mav.addObject("boseq", boseq);
			mav.addObject("yyyy", yyyy);
			mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("silsaList", silsaList);
			mav.setViewName("print/viewJikukSilsaStats");
			mav.addObject("now_menu",MENU_CODE_PRINT_SILSA);
			return mav;
		} catch (Exception e) {
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	
	/** 
	 * 지대/본사입금현황 오즈출력
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ozJidaeListPrint(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		
		HashMap dbparam = new HashMap();
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession(true);
		
		try {
			String type = param.getString("type");
			String manager = param.getString("manager");
			String fromYymm = param.getString("fromYymm");
			String txt = param.getString("txt");
			
			mav.addObject("now_menu", ICodeConstant.MENU_CODE_PRINT_JIDAE);
			mav.addObject("type" , type);
			mav.addObject("manager" , manager);
			mav.addObject("fromYymm" , fromYymm);
			mav.addObject("txt" , txt);
			mav.setViewName("print/ozJidaeList");
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return mav;
	}
	
	public ModelAndView uploadJikukSilsa(HttpServletRequest request,HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		try {
			MultipartHttpServletParam param = new MultipartHttpServletParam(request);
			MultipartFile silsaFile = param.getMultipartFile("silsaFile");
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			HashMap dbparam = new HashMap();
			
			// 카드독자신청 파일 첨부 여부 확인
			if(silsaFile.isEmpty()){
				mav.setViewName("common/message");
				mav.addObject("message", "파일첨부가 되지 않았습니다.");
				mav.addObject("returnURL", "/print/print/viewJikukSilsaStats.do");
				return mav;
			}
			FileUtil fileUtil = new FileUtil( getServletContext() );
			String fileUploadPath = fileUtil.saveUploadFile(
									silsaFile, 
									PATH_PHYSICAL_HOME,
									PATH_UPLOAD_ABSOLUTE_ROOT+PATH_DIR_TEMP
								);
			
			if ( StringUtils.isEmpty(fileUploadPath) ) {
				mav.setViewName("common/message");
				mav.addObject("message", "파일 저장이 실패하였습니다. "); 
				mav.addObject("returnURL", "/print/print/viewJikukSilsaStats.do");
				return mav;
			}
			String fileName = PATH_PHYSICAL_HOME+PATH_UPLOAD_ABSOLUTE_ROOT+PATH_DIR_TEMP+"/"+fileUploadPath;
			
			Workbook myWorkbook = Workbook.getWorkbook(new File(fileName)); // 파일을 읽어 와서...
			Sheet mySheets[] = myWorkbook.getSheets();
			int index=0;
			String boseq = null;
			String readtypecd = param.getString("readtypecd");
			String yyyy = param.getString("yyyy");
			String yyyymm = null;
			String qty = null;
			String mm = null;
			int rowCount = 0;
			int colCount = 0;
			
			for(Sheet sheet:mySheets) {
				if(index > 11)break;
				rowCount = sheet.getRows();                            //총 로우수를 가져옵니다.
				colCount = sheet.getColumns();                       //총 열의 수를 가져옵니다.
				mm = String.valueOf(index +1);
				if(mm.length() == 1) mm = "0" + mm;
				for(int no=1 ; no < rowCount ; no++){
					for(int i=0 ; i < colCount ; i++){
			    		Cell myCell = sheet.getCell(i,no);
			    		if(i == 0) boseq = myCell.getContents();
			    		if(i == 2) qty = myCell.getContents();
			    		
			    	}
					if(isNumber(boseq) && isNumber(qty)) {
						dbparam = new HashMap();
						dbparam.put("boseq",boseq);
						dbparam.put("readtypecd",readtypecd);
						dbparam.put("qty",qty);
						dbparam.put("yyyymm",yyyy + mm);
						generalDAO.insert("print.print.insertJikukSilsaStats" , dbparam); // 월별 수금 현황
					}
				}
				index++;
			}
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			mav.setViewName("common/message");
			mav.addObject("message", "파일 저장이 완료되었습니다. ");
			mav.addObject("returnURL", "/print/print/viewJikukSilsaStats.do");
			return mav;
		} catch (Exception e) {
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/print/print/viewJikukSilsaStats.do");
			return mav;
		}finally{
			generalDAO.getSqlMapClient().endTransaction();
		}
	}
	
	
	private boolean isNumber(String str) {
		if(str.indexOf(".") > -1){
			str = str.substring(0,str.indexOf("."));
		}
		str = StringUtils.trim(str);
        boolean result = true;
        if (str.equals("")) {
            result = false;
        }
        for (int i = 0; i < str.length(); i++) {
            char c = str.charAt(i);
            if (c < 48 || c > 59) {
                result = false;
                break;
            }
        }
        return result;
    }

}
