package com.mkreader.web;

import java.math.BigDecimal;
import java.net.InetAddress;
import java.util.HashMap;
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
import org.springframework.web.servlet.view.RedirectView;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.web.common.CommonController;

public class MainComtroller_make extends MultiActionController implements
ISiteConstant, ICodeConstant {

private GeneralDAO generalDAO;

public void setGeneralDAO(GeneralDAO generalDAO) {

this.generalDAO = generalDAO;
}

/**
* 공통 로그인
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
	
	// param
	Param param = new HttpServletParam(request);
	String message = param.getString("message");
	String logintype = param.getString("logintype");
	
	// mav
	ModelAndView mav = new ModelAndView();
	
	if ( StringUtils.isNotEmpty(adminId) ) {	// 관리자 세션이 없다면 
		if ( "autherror".equals(message)) {
			mav.setViewName("common/message");
			mav.addObject("message", MSG_LOGIN_NOT_AUTH);
			mav.addObject("returnURL", URI_MAIN_ADMIN);
		} 
		else {
			mav.setView(new RedirectView(URI_MAIN_ADMIN));
		}
	} 
	else if ( StringUtils.isNotEmpty(agencyId) ) {	// 지국 세션이 없다면
		if ( "autherror".equals(message)) {
			mav.setViewName("common/message");
			mav.addObject("message", MSG_LOGIN_NOT_AUTH);
			mav.addObject("returnURL", URI_MAIN_ADMIN);
		} 
		else {
			mav.setView(new RedirectView(URI_MAIN_ADMIN));
		}			
	}
	else {		// 세션이 없다면 로그인 페이지로
		mav.setViewName("main/index");
		mav.addObject("logintype", logintype);
	}
	
	return mav;
	}
	
	
	/**
	* 공통 로그인 처리 (세션에 로그인 정보를 담는다)
	* 
	* @param request
	* @param response
	* @return
	* @throws Exception
	*/
	public ModelAndView login(HttpServletRequest request,
		HttpServletResponse response) throws Exception {
	// mav
	ModelAndView mav = new ModelAndView();
	
	// session
	HttpSession session = request.getSession();
	
	//ip_check
	InetAddress  AllIpData = InetAddress.getLocalHost();
	String ipConfirm = AllIpData.getHostAddress();
			
	// param
	Param param = new HttpServletParam(request);
	String logintype 	= param.getString("logintype", LOGIN_TYPE_ADMIN);
	String userid 		= param.getString("userid");
	String passwd 		= param.getString("passwd");
	String rtn_url 		= param.getString("rtn_url");
	String NameYn 	= param.getString("NameYn");
	String abcYn 		= "N";
	String localCode 	="";
	String compCd 	= "";
	int agencyCnt 	= 0;
	
	HashMap<Object, Object> dbparam = new HashMap<Object, Object>();	// query param
	dbparam.put("USERID", userid);
	dbparam.put("PASSWD", passwd);
	
	CommonController cc = new CommonController();
	boolean chkHangul = cc.isHangul(userid);
	
	//System.out.println("chkHangul = "+chkHangul);
	//System.out.println("ipConfirm = "+ipConfirm);
	
	//본사사원체크
	int chkMemberYn = (Integer) generalDAO.getSqlMapClient().queryForObject("admin.chkMemberYn", dbparam);
	
	if(!"218.144.58.97".equals(ipConfirm) && chkMemberYn == 0) {	//ABC용 서버가 아닐일때
		if(chkHangul) { //ABC용으로 로그인했을때(아이디가 한글일때)
			logintype = LOGIN_TYPE_BRANCH;  // 아이디가 지국명일경우 logintype을 자동으로 지국으로 변경
			mav = new ModelAndView();
			mav.addObject("userid", userid);
			mav.addObject("passwd", passwd);
			mav.addObject("NameYn", "Y");
			mav.setView(new RedirectView("http://218.144.58.97/main/login.do"));
			return mav;
		}
	} 
	
	mav = new ModelAndView();
	
	//System.out.println("chkMemberYn = "+chkMemberYn);
	if(chkMemberYn > 0) { // 본사 로그인 
		Map adminInfo = (Map) generalDAO.queryForObject("admin.getAdminLogin", dbparam);
		logintype = LOGIN_TYPE_ADMIN; 
		
		if ( adminInfo == null ) {
			mav.setViewName("common/message");
			mav.addObject("message", "해당 아이디가 없거나 비밀번호가 틀렸습니다.");
			mav.addObject("returnURL", "/main/index.do?logintype=" + logintype);
			return mav;
		}else{
			dbparam.put("userId", userid);
			
			//영업담당여부체크
			String chkSellerYn = (String) generalDAO.queryForObject("management.jidae.chkSellerYn", dbparam);
			
			//관리자, 관리팀여부체크
			String chkAdminMngYn = (String) generalDAO.queryForObject("management.jidae.chkAdminMngYn", dbparam);
			
			//영업담당일때만 지국조회
			if("Y".equals(chkSellerYn)) { 
				//담당코드 가져오기
				localCode = (String) generalDAO.queryForObject("management.jidae.selectLocalCodeBySeller", dbparam);
			}
			
			//부서코드 가져오기
			compCd = (String)generalDAO.queryForObject("admin.getUserCompCd", dbparam);
			
			//System.out.println("userid = "+userid);
			//System.out.println("chkSellerYn = "+chkSellerYn);
			//System.out.println("chkAdminMngYn = "+chkAdminMngYn);
			//System.out.println("compCd = "+compCd);
			
			//탑메뉴 조회
			dbparam.put("compCd", compCd);
			List<String> menuList = generalDAO.getSqlMapClient().queryForList("common.selectMenuList", dbparam);
			
			session.setMaxInactiveInterval(60*60);		// 60분
			session.setAttribute(SESSION_NAME_ADMIN_USERID, adminInfo.get("ID"));
			session.setAttribute(SESSION_NAME_ADMIN_LEVELS, adminInfo.get("USERGB"));
			session.setAttribute(SESSION_NAME_MENU_AUTH, AUTH_CODE_ADMIN);			// 관리자 권한
			session.setAttribute(SESSION_NAME_CHKSELLERYN, chkSellerYn);					//영업담당여부체크
			session.setAttribute(SESSION_NAME_CHKADMINMNGYN, chkAdminMngYn);		//관리자, 관리팀여부체크
			session.setAttribute(SESSION_NAME_LOCALCODE, localCode);							//담당구역코드
			session.setAttribute(SESSION_NAME_COMPCD, compCd);								//부서코드
			session.setAttribute(SESSION_MENU_LIST, menuList);										//메뉴리스트
			
			if ( rtn_url == null || rtn_url.length() < 3 ) {
				rtn_url = URI_MAIN_ADMIN;
			}			
			mav.setView(new RedirectView(rtn_url));
		}//if end
	} else	{	// 지국 로그인 
		mav.addObject("NameYn",NameYn);
		Map adminInfo = (Map) generalDAO.queryForObject("admin.getAgencyLogin", dbparam);
		logintype = LOGIN_TYPE_BRANCH;  
		
		if ( adminInfo == null ) {
			mav.setViewName("common/message");
			mav.addObject("message", "해당 아이디가 없거나 비밀번호가 틀렸습니다.");
			mav.addObject("returnURL", "/main/index.do?logintype=" + logintype);
			return mav;
			
		} else {
			
			BigDecimal numid = (BigDecimal) adminInfo.get("NUMID");
			String serial = (String) adminInfo.get("SERIAL");
			String name = (String) adminInfo.get("NAME");
			
			if(!"218.144.58.97".equals(ipConfirm) ) {	// ABC관련 로직-개발서버는 userid대신 serial
				session.setAttribute(SESSION_NAME_AGENCY_USERID, userid);  
				session.setAttribute(SESSION_NAME_ABC_CHK, "N");
			} else {
				session.setAttribute(SESSION_NAME_AGENCY_USERID, serial);
				session.setAttribute(SESSION_NAME_ABC_CHK, "Y");
			}
			session.setAttribute(SESSION_NAME_AGENCY_NUMID, numid);
			session.setAttribute(SESSION_NAME_AGENCY_SERIAL, serial);
			session.setAttribute(SESSION_NAME_AGENCY_NAME, name);
			session.setAttribute(SESSION_NAME_AGENCY_LEVELS, 5);
			session.setAttribute(SESSION_NAME_MENU_AUTH, AUTH_CODE_AGENCY);	// 지국권한
	
			if ( rtn_url == null || rtn_url.length() < 3 ) {
				rtn_url = URI_MAIN_ADMIN;
			}
			mav.setView(new RedirectView(rtn_url));
		}//if end
	}
	
	
	session.setAttribute(SESSION_NAME_LOGIN_TYPE, logintype);		// 로그인 타입
	return mav;
	}
	
	
	/**
	* 공통 로그아웃
	* 
	* @param request
	* @param response
	* @return
	* @throws Exception
	*/
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
	
	session.removeAttribute(SESSION_NAME_LOGIN_TYPE);
	session.removeAttribute(SESSION_NAME_MENU_AUTH);		
	
	// mav
	ModelAndView mav = new ModelAndView();
	mav.setView(new RedirectView("/main/index.do"));
	
	return mav;
	}

}
