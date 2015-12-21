package com.mkreader.web.billing.branch;

import java.util.ArrayList;
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
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.CommonUtil;
import com.mkreader.util.Paging;



public class CmsrequestController extends MultiActionController implements
		ISiteConstant {
	
	public static Logger logger = Logger.getRootLogger();

	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {

		this.generalDAO = generalDAO;
	}
	
	/**
	 * 계좌확인내역 목록
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
		mav.setViewName("billing/branch/cmsrequest/index");
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
	 * 계좌확인내역 상세
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
		String view = param.getString("view");
		
		HttpSession session = request.getSession();
		String agencyId = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		String EACH_filename = "EB13" + filename.substring(filename.length()-4);
		
		
		// db query parameter		
		HashMap dbparam = new HashMap();
		dbparam.put("filename", EACH_filename);
		dbparam.put("cmsdate", cmsdate);
		dbparam.put("agencyId", agencyId);
		int totals = (Integer) generalDAO.queryForObject("billing.branch.cmsrequest.getEALogCount", dbparam);
		logger.debug("===== billing.branch.cmsrequest.getEALogCount");
		
		dbparam = new HashMap();
		dbparam.put("filename", EACH_filename);
		dbparam.put("cmsresult", "00000");
		dbparam.put("cmstype", "EA13+");
		dbparam.put("cmsdate", cmsdate);
		dbparam.put("agencyId", agencyId);
		int noErrnum1 = (Integer) generalDAO.queryForObject("billing.branch.cmsrequest.getEALogCount", dbparam);
		logger.debug("===== billing.branch.cmsrequest.getEALogCount");
		
		dbparam = new HashMap();
		dbparam.put("filename", EACH_filename);
		dbparam.put("cmsresult_not", "00000");
		dbparam.put("cmstype", "EA13+");
		dbparam.put("cmsdate", cmsdate);
		dbparam.put("agencyId", agencyId);
		int Errnum1 = (Integer) generalDAO.queryForObject("billing.branch.cmsrequest.getEALogCount", dbparam);
		logger.debug("===== billing.branch.cmsrequest.getEALogCount");
		
		dbparam = new HashMap();
		dbparam.put("filename", EACH_filename);
		dbparam.put("cmsresult", "00000");
		dbparam.put("cmstype", "EA13-");
		dbparam.put("cmsdate", cmsdate);
		dbparam.put("agencyId", agencyId);
		
		int noErrnum2 = (Integer) generalDAO.queryForObject("billing.branch.cmsrequest.getEALogCount", dbparam);
		logger.debug("===== billing.branch.cmsrequest.getEALogCount");
		
		dbparam = new HashMap();
		dbparam.put("filename", EACH_filename);
		dbparam.put("cmsresult_not", "00000");
		dbparam.put("cmstype", "EA13-");
		dbparam.put("cmsdate", cmsdate);
		dbparam.put("agencyId", agencyId);
		int Errnum2 = (Integer) generalDAO.queryForObject("billing.branch.cmsrequest.getEALogCount", dbparam);
		logger.debug("===== billing.branch.cmsrequest.getEALogCount");
		
		dbparam.put("view", view);
		
		dbparam = new HashMap();
		dbparam.put("filename", EACH_filename);
		dbparam.put("cmsdate", cmsdate);
		dbparam.put("agencyId", agencyId);
		List resultList = generalDAO.queryForList("billing.branch.cmsrequest.getEALogList", dbparam);
		logger.debug("===== billing.branch.cmsrequest.getEALogList");
		
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
		mav.setViewName("billing/branch/cmsrequest/view");
		mav.addObject("now_menu", MENU_CODE_BILLING);
		mav.addObject("show_hidden3", "display");
		
		mav.addObject("numid", numid);
		mav.addObject("filename", filename);
		mav.addObject("cmsdate", cmsdate);
		
		mav.addObject("totals", totals);
		mav.addObject("noErrnum1", noErrnum1);
		mav.addObject("Errnum1", Errnum1);
		mav.addObject("noErrnum2", noErrnum2);
		mav.addObject("Errnum2", Errnum2);
		
		mav.addObject("resultList", resultList);
		mav.addObject("pageNo", pageNo);
		
		mav.addObject("view", view);
		
		return mav;
	}
	
	
}
