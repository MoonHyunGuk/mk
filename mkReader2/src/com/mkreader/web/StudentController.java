package com.mkreader.web;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Iterator;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.servlet.util.MultipartHttpServletParam;
import kr.reflexion.espresso.util.Param;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.support.DefaultMultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.Paging;
import com.mkreader.util.FileUtil;



public class StudentController extends MultiActionController implements
		ISiteConstant {

	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {

		this.generalDAO = generalDAO;
	}
	
	
	/**
	 * 관리자 메인
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		// admin login id
		HttpSession session = request.getSession();
		String adminId = (String) session.getAttribute(SESSION_NAME_ADMIN_USERID);
		String agencyId = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		if ( adminId != null || agencyId != null ) {
			response.sendRedirect("/admin/index.do");
			return null;
		}		
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("student/index");
		return mav;
	}
	
	
	// logout
	public ModelAndView logout(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		HttpSession session = request.getSession();
		session.removeAttribute(SESSION_NAME_ADMIN_USERID);
		session.removeAttribute(SESSION_NAME_ADMIN_LEVELS);
		
		session.removeAttribute(SESSION_NAME_AGENCY_USERID);
		session.removeAttribute(SESSION_NAME_AGENCY_NUMID);
		session.removeAttribute(SESSION_NAME_AGENCY_SERIAL);
		session.removeAttribute(SESSION_NAME_AGENCY_NAME);
		session.removeAttribute(SESSION_NAME_AGENCY_LEVELS);
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setView(new RedirectView("/admin/index.do"));
		
		return mav;
	}
	
	public ModelAndView main(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("student/main");
		return mav;
	}
}
