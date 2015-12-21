package com.mkreader.web.billing.branch;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.util.Param;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.CommonUtil;
import com.mkreader.util.Paging;



public class CmsgetController extends MultiActionController implements
		ISiteConstant {
	
	public static Logger logger = Logger.getRootLogger();

	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {

		this.generalDAO = generalDAO;
	}
	
	
	
	/**
	 * 청구결과(EB22) 일반
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
		mav.setViewName("billing/branch/cmsget/index");
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
	 * 청구결과(EB22) 상세 일반
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
		String cmstype = "EA21";
		
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
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
		mav.setViewName("billing/branch/cmsget/view");
		mav.addObject("now_menu", MENU_CODE_BILLING);
		mav.addObject("show_hidden3", "display");
		
		mav.addObject("numid", numid);
		mav.addObject("cmsdate", cmsdate);
		mav.addObject("filename", filename);
		mav.addObject("jikuk", jikuk);
		
		mav.addObject("resultMap", resultMap);
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
	 * 이체내역조회(일반) 일반
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
		String chbx = param.getString("chbx", "all");
		String filename = param.getString("filename");
		String sdate = param.getString("sdate");
		String edate = param.getString("edate");
		int startpage = param.getInt("startpage", 1);
		
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		
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
			//String sdate_tmp = sdate.replace("-", ""); 
			//String edate_tmp = edate.replace("-", "");
			s_cmsdate = sdate.substring(sdate.length() - 10);
			e_cmsdate = edate.substring(edate.length() - 10);
		}
		
		//dbparam
		HashMap dbparam = new HashMap();
		dbparam.put("CMSTYPE", "EA21");
		dbparam.put("CHBX", chbx);
		dbparam.put("JIKUK", jikuk);
		dbparam.put("S_CMSDATE", s_cmsdate);
		dbparam.put("E_CMSDATE", e_cmsdate);
		
		//paging
		Map result = (Map)generalDAO.queryForObject("billing.branch.cmsget.getStatResult", dbparam);
		
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
		List resultList = generalDAO.queryForList("billing.branch.cmsget.getStatResultList", dbparam);
		
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
		mav.setViewName("billing/branch/cmsget/stat");
		return mav;
	}
	

	/**
	 * 이체내역 조회 엑셀리스트 일반
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
		String chbx = param.getString("chbx", "all");
		String filename = param.getString("filename");
		String sdate = param.getString("sdate");
		String edate = param.getString("edate");
		
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
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
			//String sdate_tmp = sdate.replace("-", ""); 
			//String edate_tmp = edate.replace("-", "");
			s_cmsdate = sdate.substring(sdate.length() - 10);
			e_cmsdate = edate.substring(edate.length() - 10);
		}
		
		//dbparam
		HashMap dbparam = new HashMap();
		dbparam.put("CMSTYPE", "EA21");
		dbparam.put("CHBX", chbx);
		dbparam.put("JIKUK", jikuk);
		dbparam.put("S_CMSDATE", s_cmsdate);
		dbparam.put("E_CMSDATE", e_cmsdate);
		
		//리스트
		List resultList = generalDAO.queryForList("billing.branch.cmsget.getStatResultList", dbparam);
		
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
		mav.setViewName("billing/branch/cmsget/stat_excel");
		return mav;

	}
	
	
	/**
	 * 이체내역조회 학생
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView stat_stu(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		//메뉴펼치기
		String show_hidden5 = "display";
		
		int pagesize = 40;
		int conternp = 10;
		
		//parameter
		Param param = new HttpServletParam(request);
		int pageNo = param.getInt("pageNo", 1);
		String idid = param.getString("idid");
		String numid = param.getString("numid");
		int page = param.getInt("page");
		String chbx = param.getString("chbx", "all");
		String filename = param.getString("filename");
		String sdate = param.getString("sdate");
		String edate = param.getString("edate");
		int startpage = param.getInt("startpage", 1);
		
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		
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
		dbparam.put("CHBX", chbx);
		dbparam.put("JIKUK", jikuk);
		dbparam.put("S_CMSDATE", s_cmsdate);
		dbparam.put("E_CMSDATE", e_cmsdate);
		
		//지국정보
		List jikukList = generalDAO.queryForList("billing.student.cmsget.getStatStuJikukList", dbparam);
		if( jikuk.length() > 4 ){
			dbparam.put("JIKUK_CHECK", "Y");
		}
		
		//paging
		Map result = (Map)generalDAO.queryForObject("billing.student.cmsget.getStatStuResult", dbparam);
		
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
		
		//String link = "<a href='stat_stu.do?chbx=" + chbx + "&sdate=" + sdate + "&edate=" + edate + "&jikuk=" + jikuk;
		//String paging = PagingUtil.CreatePaging(startpage, totpage, conternp, gotopage, link);
		
		dbparam.put("PAGE_NO",pageNo);
		dbparam.put("PAGE_SIZE",pagesize);
		
		//리스트
		List resultList = generalDAO.queryForList("billing.student.cmsget.getStatStuResultList", dbparam);
		
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
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_BILLING_STU);
		mav.addObject("show_hidden5",show_hidden5);
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
		mav.setViewName("billing/branch/cmsget/stat_stu");
		return mav;
	}
	

	/**
	 * 이체내역 조회 엑셀리스트 학생
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView stat_stu_excel(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		
		//parameter
		Param param = new HttpServletParam(request);
		String idid = param.getString("idid");
		String numid = param.getString("numid");
		int page = param.getInt("page");
		String chbx = param.getString("chbx", "all");
		String filename = param.getString("filename");
		String sdate = param.getString("sdate");
		String edate = param.getString("edate");
		
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
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
		dbparam.put("CHBX", chbx);
		dbparam.put("JIKUK", jikuk);
		dbparam.put("S_CMSDATE", s_cmsdate);
		dbparam.put("E_CMSDATE", e_cmsdate);
		
		//지국정보
		List jikukList = generalDAO.queryForList("billing.student.cmsget.getStatStuJikukList", dbparam);
		if( jikuk.length() > 4 ){
			dbparam.put("JIKUK_CHECK", "Y");
		}
		

		//리스트
		List resultList = generalDAO.queryForList("billing.student.cmsget.getStatStuResultList", dbparam);
		
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
		mav.setViewName("billing/branch/cmsget/stat_stu_excel");
		return mav;

	}
	
	
}
