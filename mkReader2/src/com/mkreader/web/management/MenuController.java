package com.mkreader.web.management;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.util.Param;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ISiteConstant;

public class MenuController extends MultiActionController implements
ISiteConstant {
	
	public static Logger logger = Logger.getRootLogger();
	
	private GeneralDAO generalDAO;
	
	public void setGeneralDAO(GeneralDAO generalDAO) {
		this.generalDAO = generalDAO;
	}
	
	
	/**
	 * 메뉴관리리스트
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView menuList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		// mav
		ModelAndView mav = new ModelAndView();
		// db query parameter
		HashMap dbparam = new HashMap();
		
		String compCd = param.getString("compCd", "82101");
		
		dbparam.put("compCd", compCd);
		List<Object> menuList = generalDAO.queryForList("management.menu.selectMenuList", dbparam);
		List<Object> partList = generalDAO.queryForList("management.menu.selectPartList", dbparam);
		
		mav.addObject("partList", partList);
		mav.addObject("menuList", menuList);
		mav.setViewName("management/menu/menuList");
		return mav;
	}

}
