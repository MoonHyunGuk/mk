/*------------------------------------------------------------------------------
 * NAME : EmployeeController 
 * DESC : 본사직원 구독 관리
 * Author : pspkj
 *----------------------------------------------------------------------------*/
package com.mkreader.web.reader;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.util.Param;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;
import org.springframework.web.servlet.view.RedirectView;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.DateUtil;
import com.mkreader.util.Paging;
import com.mkreader.util.StringUtil;

public class EmployeeController extends MultiActionController implements
ISiteConstant, ICodeConstant {

	private GeneralDAO generalDAO;
	
	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}

	/**
	 * 본사 직원 리스트 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView retrieveEmployeeList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			HashMap dbparam = new HashMap();
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 20;
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			int totalCount = 0;
			
			dbparam.put("boSeq", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			List employeeList = generalDAO.queryForList("reader.employee.employeeList", dbparam);
			totalCount = generalDAO.count("reader.employee.employeeListCount" , dbparam);
			
			mav.addObject("now_menu", MENU_CODE_READER_EMPLOYEE);
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 10));
			mav.addObject("employeeList" , employeeList);
			mav.addObject("count" , generalDAO.count("reader.employee.employeeCount" , dbparam));
			mav.setViewName("reader/agentEmployeeList");
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
	 * 본사 직원 리스트 검색
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView searchEmployeeList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			HashMap dbparam = new HashMap();
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 20;
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			int totalCount = 0;

			dbparam.put("boSeq",  session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			dbparam.put("searchKey", param.getString("searchKey"));
			dbparam.put("searchText", param.getString("searchText"));
			dbparam.put("status", param.getString("status"));
			
			List searchEmployeeList = generalDAO.queryForList("reader.employee.searchEmployeeList", dbparam);
			totalCount = generalDAO.count("reader.employee.searchEmployeeListCount" , dbparam);

			mav.addObject("now_menu", MENU_CODE_READER_EMPLOYEE);
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 10));
			mav.addObject("param" , param);
			mav.addObject("employeeList" , searchEmployeeList);
			mav.addObject("count" , generalDAO.count("reader.employee.searchEmployeeCount" , dbparam));
			mav.setViewName("reader/agentEmployeeList");
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