package com.mkreader.web.community;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.servlet.util.MultipartHttpServletParam;
import kr.reflexion.espresso.util.Param;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;
import org.springframework.web.servlet.view.RedirectView;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.DateUtil;
import com.mkreader.util.FileUtil;
import com.mkreader.util.Paging;
import com.mkreader.util.StringUtil;

public class BbsController extends MultiActionController implements
		ISiteConstant {

	private GeneralDAO generalDAO;
	
	public void setGeneralDAO(GeneralDAO generalDAO) {

		this.generalDAO = generalDAO;
	}
	
	/**
	 * 공지사항 리스트
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView noticeList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		int pagesize = 10;

		// param
		Param param = new HttpServletParam(request);
		int pageNo = param.getInt("pageNo", 1);
		String search_key = param.getString("search_key");
		String search_type = param.getString("search_type");
		
		//지국 번호
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		// db query parameter
		HashMap dbparam = new HashMap();
		String jikukType = "";
		String userGb = "";
		String typeCd[] = null;
		
		//지국으로 로그인 했을 경우 직영 지국인지 체크
		if( StringUtils.isNotEmpty(jikuk) ){
			dbparam.put("JIKUK",jikuk);
			jikukType = (String)generalDAO.queryForObject("community.bbs.getJikukType", dbparam);
		}
		//지국이 아닌 경우 usergb(권한레벨) 확인
		else if ( null != session.getAttribute(SESSION_NAME_ADMIN_LEVELS) ){
			userGb = (String)session.getAttribute(SESSION_NAME_ADMIN_LEVELS).toString();
		}
		//지국이 구분별 권한레벨이 관리자일 경우 직영 공지사항도 노출 대상 정의
		if( "9".equals(userGb) ){
			//1전체	2직영  5청약  6지방
			typeCd = new String[]{"1","2","5","6"};
		}else if( "101".equals(jikukType) || "102".equals(jikukType) ){
			typeCd = new String[]{"1","2"};
		}else if( "201".equals(jikukType) || "202".equals(jikukType) || "203".equals(jikukType) ){
			typeCd = new String[]{"1","5"};
		}else if( "301".equals(jikukType) ){
			typeCd = new String[]{"1","6"};
		}else{
			typeCd = new String[]{"1"};
		}
		
		dbparam.put("PAGE_NO",pageNo);
		dbparam.put("PAGE_SIZE", pagesize);
		dbparam.put("SEARCH_KEY",search_key);
		dbparam.put("SEARCH_TYPE",search_type);
		dbparam.put("TYPECD",typeCd);
		
		//결과리스트
		List resultList = generalDAO.queryForList("community.bbs.getList", dbparam);
		
		int t_count = generalDAO.count("community.bbs.getCount", dbparam);
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("community/bbs/noticeList");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COMMUNITY);
		
		mav.addObject("pageNo", pageNo);
		mav.addObject("search_key", search_key);
		mav.addObject("search_type", search_type);
	
		mav.addObject("resultList", resultList);
		mav.addObject("t_count", t_count);
		mav.addObject("pageInfo", Paging.getPageMap(pageNo, t_count, pagesize, 10));
		
		return mav;
	}
	
	/**
	 * 공지사항 상세
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView noticeView(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		int pagesize = 10;

		// param
		Param param = new HttpServletParam(request);
		int pageNo = param.getInt("pageNo", 1);
		String search_key = param.getString("search_key");
		String search_type = param.getString("search_type");
		String seq = param.getString("seq");
		
		// db query parameter
		HashMap dbparam = new HashMap();
		dbparam.put("SEQ",seq);
		
		
		//직영공지 임의경로로 접속할 경우 차단
		//지국 번호
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		String adminId = (String) session.getAttribute(SESSION_NAME_ADMIN_USERID);
		
		// db query parameter
		String jikukType = "";
		String userGb = "";

		
		//지국으로 로그인 했을 경우 직영 지국인지 체크
		if( StringUtils.isNotEmpty(jikuk) ){
			dbparam.put("JIKUK",jikuk);
			jikukType = (String)generalDAO.queryForObject("community.bbs.getJikukType", dbparam);
		}
		//지국이 아닌 경우 usergb(권한레벨) 확인
		else if ( null != session.getAttribute(SESSION_NAME_ADMIN_LEVELS) ){
			userGb = (String)session.getAttribute(SESSION_NAME_ADMIN_LEVELS).toString();
		}
		
		//cnt update(조회수 증가)
		generalDAO.update("community.bbs.updateCnt", dbparam);
		
		String tempId = (StringUtils.isNotEmpty(jikuk))?jikuk:adminId;
		dbparam.put("JIKUK",tempId);
		
		Map result = (Map)generalDAO.queryForObject("community.bbs.getView", dbparam);
		
		
		if(!StringUtil.notNull(result.get("IS_READ")).equals("Y")){
			generalDAO.insert("community.bbs.insertNoticeViewHistory",dbparam);
		}
		
			
		//개행처리
		if( result != null ){
			if( result.get("CONT") != null ){
				String cont = (String)result.get("CONT");
				cont = cont.replaceAll("\r\n", "<br>");
				result.put("CONT", cont);
			}
		}
		

		//지국이 직영지국 이거나 권한레벨이 관리자일 경우 직영 공지사항도 노출
		if( !"101".equals(jikukType) && !"102".equals(jikukType) && !"9".equals(userGb) ){
			if( result != null && "2".equals(result.get("TYPECD")) ){
				ModelAndView mav = new ModelAndView();
				mav.setViewName("common/message");
				mav.addObject("message", "직영공지는 직영지국,관리자만 확인 가능합니다.");
				mav.addObject("returnURL", "/community/bbs/noticeList.do");
				return mav;
			}
			
		}
		
		List notReadNoticeJikukList = null;
		if(userGb.equals("9")){
			notReadNoticeJikukList = generalDAO.queryForList("community.bbs.getNotReadNoticeJikukList",dbparam);
		}
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("community/bbs/noticeView");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COMMUNITY);
		
		mav.addObject("pageNo", pageNo);
		mav.addObject("search_key", search_key);
		mav.addObject("search_type", search_type);
		mav.addObject("seq", seq);
	
		mav.addObject("result", result);
		mav.addObject("notReadNoticeJikukList",notReadNoticeJikukList);
		
		return mav;
	}
	
	/**
	 * 공지사항 폼(TYPE에 따라 쓰기,수정)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView noticeForm(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		// param
		Param param = new HttpServletParam(request);
		int pageNo = param.getInt("pageNo", 1);
		String search_key = param.getString("search_key");
		String search_type = param.getString("search_type");
		String type = param.getString("type");
		String seq = param.getString("seq");
		
		//지국 번호
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		String userGb = "";
		
		if ( null != session.getAttribute(SESSION_NAME_ADMIN_LEVELS) ){
			userGb = (String)session.getAttribute(SESSION_NAME_ADMIN_LEVELS).toString();
		}
		
		ModelAndView mav = new ModelAndView();
		//type이 파라미터로 없는 경우, 관리자 권한이 9가 아닌경우 
		if( StringUtils.isEmpty(type) || !"9".equals(userGb)){
			mav.setViewName("common/message");
			mav.addObject("message", "경로를 확인해주세요.");
			mav.addObject("returnURL", "/community/bbs/noticeList.do");
			return mav;
		}
		
		//::todo
		if( "write".equals(type) ){
			mav.setViewName("community/bbs/noticeForm");
			mav.addObject("type", type);
			
		}else if( "modify".equals(type) ){
			
			// db query parameter
			HashMap dbparam = new HashMap();
			dbparam.put("SEQ",seq);
			
			Map result = (Map)generalDAO.queryForObject("community.bbs.getView", dbparam);
			
			mav.setViewName("community/bbs/noticeForm");
			mav.addObject("seq", seq);
			mav.addObject("type", type);
			mav.addObject("result", result);
			
		}else if( "delete".equals(type) ){
			// db query parameter
			HashMap dbparam = new HashMap();
			
			dbparam.put("SEQ", seq);
			//delete
			generalDAO.delete("community.bbs.delete", dbparam);
			
			mav.setView(new RedirectView("/community/bbs/noticeList.do"));
			
		}
		mav.addObject("pageNo", pageNo);
		mav.addObject("search_key", search_key);
		mav.addObject("search_type", search_type);
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COMMUNITY);
		return mav;
		
	}
	
	
	/**
	 * 공지사항 폼 프로세스(TYPE에 따라 쓰기,수정)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView formProcess(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		// param
		MultipartHttpServletParam param = new MultipartHttpServletParam(request);
		String type = param.getString("type");
		String titl = param.getString("titl");			//제목
		String typecd = param.getString("typecd");		//게시판 형태 전체공지,직영공지
		String inps = param.getString("inps");			//쓰기일 경우 작성자
		String chgps = param.getString("chgps");		//수정일 경우 수정자
		String cont = param.getString("cont");			//내용
		MultipartFile save_fnm = param.getMultipartFile("save_fnm");	//첨부파일
		
		//지국 번호
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		String userGb = "";
		
		if ( null != session.getAttribute(SESSION_NAME_ADMIN_LEVELS) ){
			userGb = (String)session.getAttribute(SESSION_NAME_ADMIN_LEVELS).toString();
		}
		
		ModelAndView mav = new ModelAndView();
		//type이 파라미터로 없는 경우, 관리자 권한이 9가 아닌경우 
		if( StringUtils.isEmpty(type) || !"9".equals(userGb)){
			mav.setViewName("common/message");
			mav.addObject("message", "경로를 확인해주세요.");
			mav.addObject("returnURL", "/community/bbs/noticeList.do");
			return mav;
		}
		
		String real_fnm = "";
		if( !save_fnm.isEmpty() ){
			FileUtil fileUtil = new FileUtil( getServletContext() );
			real_fnm = fileUtil.saveOriginalFile(
											save_fnm, 
											//PATH_PHYSICAL_HOME,
											PATH_UPLOAD_ABSOLUTE_BBS_NOTICE
										);
		}
		
		HashMap dbparam = new HashMap();
		if( "write".equals(type) ){
			dbparam.put("TITL", titl);
			dbparam.put("TYPECD", typecd);
			dbparam.put("INPS", inps);
			dbparam.put("CONT", cont);
			if( !save_fnm.isEmpty() && StringUtils.isNotEmpty(real_fnm)){
				dbparam.put("SAVE_FNM", real_fnm);
				dbparam.put("REAL_FNM", real_fnm);
				dbparam.put("FILE_PATH", PATH_UPLOAD_ABSOLUTE_BBS_NOTICE);
			}
			//insert
			int seq = (Integer)generalDAO.insert("community.bbs.insert", dbparam);
			
			mav.setViewName("common/message");
			mav.addObject("message", "등록되었습니다.");
			mav.addObject("returnURL", "/community/bbs/noticeView.do?seq=" + seq);
			
		}else if( "modify".equals(type) ){
			String seq = param.getString("seq");			//게시글 번호
			
			dbparam.put("SEQ", seq);
			dbparam.put("TITL", titl);
			dbparam.put("TYPECD", typecd);
			dbparam.put("CHGPS", chgps);
			dbparam.put("CONT", cont);
			if( !save_fnm.isEmpty() && StringUtils.isNotEmpty(real_fnm)){
				dbparam.put("SAVE_FNM", real_fnm);
				dbparam.put("REAL_FNM", real_fnm);
				dbparam.put("FILE_PATH", PATH_UPLOAD_ABSOLUTE_BBS_NOTICE);
			}
			//update
			generalDAO.update("community.bbs.update", dbparam);
			
			mav.setViewName("common/message");
			mav.addObject("message", "수정되었습니다.");
			mav.addObject("returnURL", "/community/bbs/noticeView.do?seq=" + seq);
			
		}
		
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COMMUNITY);
		return mav;
		
	}
	
	/**
	 * 공지사항 폼 프로세스(TYPE에 따라 쓰기,수정)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView fileDelete(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		// param
		MultipartHttpServletParam param = new MultipartHttpServletParam(request);
		String type = param.getString("type");
		String seq = param.getString("seq");			//게시글 번호
		
		//지국 번호
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		String userGb = "";
		
		if ( null != session.getAttribute(SESSION_NAME_ADMIN_LEVELS) ){
			userGb = (String)session.getAttribute(SESSION_NAME_ADMIN_LEVELS).toString();
		}
		
		ModelAndView mav = new ModelAndView();
		//type이 파라미터로 없는 경우, 관리자 권한이 9가 아닌경우 
		if( StringUtils.isEmpty(type) || !"9".equals(userGb)){
			mav.setViewName("common/message");
			mav.addObject("message", "경로를 확인해주세요.");
			mav.addObject("returnURL", "/community/bbs/noticeList.do");
			return mav;
		}
		
		
		HashMap dbparam = new HashMap();
		dbparam.put("SEQ", seq);
			
		//update
		generalDAO.update("community.bbs.updateFileName", dbparam);
		
		mav.setViewName("common/message");
		mav.addObject("message", "파일이 삭제되었습니다.");
		mav.addObject("returnURL", "/community/bbs/noticeForm.do?type=modify&seq=" + seq);
		
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COMMUNITY);
		return mav;
		
	}
	
	
	/**
	 * 메인알림 리스트
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView mainList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		int pagesize = 10;

		// param
		Param param = new HttpServletParam(request);
		int pageNo = param.getInt("pageNo", 1);
		String search_key = param.getString("search_key");
		String search_type = param.getString("search_type");
		
		//지국 번호
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		// db query parameter
		HashMap dbparam = new HashMap();
		String jikukType = "";
		String userGb = "";
		String typeCd[] = null;
		
		//지국으로 로그인 했을 경우 직영 지국인지 체크
		if( StringUtils.isNotEmpty(jikuk) ){
			dbparam.put("JIKUK",jikuk);
			jikukType = (String)generalDAO.queryForObject("community.bbs.getJikukType", dbparam);
		}
		//지국이 아닌 경우 usergb(권한레벨) 확인
		else if ( null != session.getAttribute(SESSION_NAME_ADMIN_LEVELS) ){
			userGb = (String)session.getAttribute(SESSION_NAME_ADMIN_LEVELS).toString();
		}
		//지국이 직영지국 이거나 권한레벨이 관리자일 경우 직영 메인알림노출
		/*
		if( "101".equals(jikukType) || "102".equals(jikukType) || "9".equals(userGb) ){
			//3직영 4청약
			typeCd = new String[]{"3","4"};
		}else{
			typeCd = new String[]{"3"};
		}
		*/
		//현재는 직영지국 메인알림기능만 있음
		typeCd = new String[]{"3"};
		
		dbparam.put("PAGE_NO",pageNo);
		dbparam.put("PAGE_SIZE", pagesize);
		dbparam.put("SEARCH_KEY",search_key);
		dbparam.put("SEARCH_TYPE",search_type);
		dbparam.put("TYPECD",typeCd);
		
		//결과리스트
		List resultList = generalDAO.queryForList("community.bbs.getList", dbparam);
		
		int t_count = generalDAO.count("community.bbs.getCount", dbparam);
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("community/bbs/mainList");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COMMUNITY_MAIN);
		
		mav.addObject("pageNo", pageNo);
		mav.addObject("search_key", search_key);
		mav.addObject("search_type", search_type);
	
		mav.addObject("resultList", resultList);
		mav.addObject("t_count", t_count);
		mav.addObject("pageInfo", Paging.getPageMap(pageNo, t_count, pagesize, 10));
		
		return mav;
	}
	
	/**
	 * 메인알림 폼(TYPE에 따라 쓰기,수정)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView mainForm(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		// param
		Param param = new HttpServletParam(request);
		int pageNo = param.getInt("pageNo", 1);
		String search_key = param.getString("search_key");
		String search_type = param.getString("search_type");
		String type = param.getString("type");
		String seq = param.getString("seq");
		
		//지국 번호
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		String userGb = "";
		
		if ( null != session.getAttribute(SESSION_NAME_ADMIN_LEVELS) ){
			userGb = (String)session.getAttribute(SESSION_NAME_ADMIN_LEVELS).toString();
		}
		
		ModelAndView mav = new ModelAndView();
		//type이 파라미터로 없는 경우, 관리자 권한이 9가 아닌경우 
		if( StringUtils.isEmpty(type) || !"9".equals(userGb)){
			mav.setViewName("common/message");
			mav.addObject("message", "경로를 확인해주세요.");
			mav.addObject("returnURL", "/community/bbs/mainList.do");
			return mav;
		}
		
		//::todo
		if( "write".equals(type) ){
			mav.setViewName("community/bbs/mainForm");
			mav.addObject("type", type);
			
		}else if( "modify".equals(type) ){
			
			// db query parameter
			HashMap dbparam = new HashMap();
			dbparam.put("SEQ",seq);
			
			Map result = (Map)generalDAO.queryForObject("community.bbs.getView", dbparam);
			
			mav.setViewName("community/bbs/mainForm");
			mav.addObject("seq", seq);
			mav.addObject("type", type);
			mav.addObject("result", result);
			
		}else if( "delete".equals(type) ){
			// db query parameter
			HashMap dbparam = new HashMap();
			
			dbparam.put("SEQ", seq);
			//delete
			generalDAO.delete("community.bbs.delete", dbparam);
			
			mav.setView(new RedirectView("/community/bbs/mainList.do"));
			
		}
		mav.addObject("pageNo", pageNo);
		mav.addObject("search_key", search_key);
		mav.addObject("search_type", search_type);
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COMMUNITY_MAIN);
		return mav;
		
	}
	
	/**
	 * 메인알림 폼 프로세스(TYPE에 따라 쓰기,수정)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView formMainProcess(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		// param
		Param param = new HttpServletParam(request);
		String type = param.getString("type");
		String titl = param.getString("titl");			//제목
		String typecd = param.getString("typecd");		//게시판 형태 직영알림
		String inps = param.getString("inps");			//쓰기일 경우 작성자
		String chgps = param.getString("chgps");		//수정일 경우 수정자
		String cont = param.getString("cont");			//내용
		
		//지국 번호
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		String userGb = "";
		
		if ( null != session.getAttribute(SESSION_NAME_ADMIN_LEVELS) ){
			userGb = (String)session.getAttribute(SESSION_NAME_ADMIN_LEVELS).toString();
		}
		
		ModelAndView mav = new ModelAndView();
		//type이 파라미터로 없는 경우, 관리자 권한이 9가 아닌경우 
		if( StringUtils.isEmpty(type) || !"9".equals(userGb)){
			mav.setViewName("common/message");
			mav.addObject("message", "경로를 확인해주세요.");
			mav.addObject("returnURL", "/community/bbs/mainList.do");
			return mav;
		}
		
		
		HashMap dbparam = new HashMap();
		if( "write".equals(type) ){
			dbparam.put("TITL", titl);
			dbparam.put("TYPECD", typecd);
			dbparam.put("INPS", inps);
			dbparam.put("CONT", cont);
			
			//insert
			int seq = (Integer)generalDAO.insert("community.bbs.insert", dbparam);
			
			mav.setViewName("common/message");
			mav.addObject("message", "등록되었습니다.");
			mav.addObject("returnURL", "/community/bbs/mainView.do?seq=" + seq);
			
		}else if( "modify".equals(type) ){
			String seq = param.getString("seq");			//게시글 번호
			
			dbparam.put("SEQ", seq);
			dbparam.put("TITL", titl);
			dbparam.put("TYPECD", typecd);
			dbparam.put("CHGPS", chgps);
			dbparam.put("CONT", cont);
			
			//update
			generalDAO.update("community.bbs.update", dbparam);
			
			mav.setViewName("common/message");
			mav.addObject("message", "수정되었습니다.");
			mav.addObject("returnURL", "/community/bbs/mainView.do?seq=" + seq);
			
		}
		
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COMMUNITY_MAIN);
		return mav;
		
	}
	/**
	 * 메인알림 상세
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView mainView(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		int pagesize = 10;

		// param
		Param param = new HttpServletParam(request);
		int pageNo = param.getInt("pageNo", 1);
		String search_key = param.getString("search_key");
		String search_type = param.getString("search_type");
		String seq = param.getString("seq");
		
		// db query parameter
		HashMap dbparam = new HashMap();
		dbparam.put("SEQ",seq);
		
		//cnt update(조회수 증가)
		generalDAO.update("community.bbs.updateCnt", dbparam);
		
		Map result = (Map)generalDAO.queryForObject("community.bbs.getView", dbparam);
		
		//개행처리
		if( result != null ){
			if( result.get("CONT") != null ){
				String cont = (String)result.get("CONT");
				cont = cont.replaceAll("\r\n", "<br>");
				result.put("CONT", cont);
			}
		}
		
		//직영공지 임의경로로 접속할 경우 차단
		//지국 번호
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		// db query parameter
		String jikukType = "";
		String userGb = "";

		
		//지국으로 로그인 했을 경우 직영 지국인지 체크
		if( StringUtils.isNotEmpty(jikuk) ){
			dbparam.put("JIKUK",jikuk);
			jikukType = (String)generalDAO.queryForObject("community.bbs.getJikukType", dbparam);
		}
		//지국이 아닌 경우 usergb(권한레벨) 확인
		else if ( null != session.getAttribute(SESSION_NAME_ADMIN_LEVELS) ){
			userGb = (String)session.getAttribute(SESSION_NAME_ADMIN_LEVELS).toString();
		}
		//지국이 직영지국 이거나 권한레벨이 관리자일 경우 직영 공지사항도 노출
		if( !"101".equals(jikukType) && !"102".equals(jikukType) && !"9".equals(userGb) ){
			if( result != null && "3".equals(result.get("TYPECD")) ){
				ModelAndView mav = new ModelAndView();
				mav.setViewName("common/message");
				mav.addObject("message", "직영알림는 관리자만 확인 가능합니다.");
				mav.addObject("returnURL", "/community/bbs/mainList.do");
				return mav;
			}
			
		}
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("community/bbs/mainView");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COMMUNITY_MAIN);
		
		mav.addObject("pageNo", pageNo);
		mav.addObject("search_key", search_key);
		mav.addObject("search_type", search_type);
		mav.addObject("seq", seq);
	
		mav.addObject("result", result);
		
		return mav;
	}
	
	/**
	 * 자료실 리스트
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView dataList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		int pagesize = 10;

		// param
		Param param = new HttpServletParam(request);
		int pageNo = param.getInt("pageNo", 1);
		String search_key = param.getString("search_key");
		String search_type = param.getString("search_type");
		
		//지국 번호
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		// db query parameter
		HashMap dbparam = new HashMap();
		String jikukType = "";
		String userGb = "";
		String typeCd[] = null;
		
		//지국으로 로그인 했을 경우 직영 지국인지 체크
		if( StringUtils.isNotEmpty(jikuk) ){
			dbparam.put("JIKUK",jikuk);
			jikukType = (String)generalDAO.queryForObject("community.bbs.getJikukType", dbparam);
		}
		//지국이 아닌 경우 usergb(권한레벨) 확인
		else if ( null != session.getAttribute(SESSION_NAME_ADMIN_LEVELS) ){
			userGb = (String)session.getAttribute(SESSION_NAME_ADMIN_LEVELS).toString();
		}
		//지국이 직영지국 이거나 권한레벨이 관리자일 경우 직영 공지사항도 노출
		if( "101".equals(jikukType) || "102".equals(jikukType) || "9".equals(userGb) ){
			//1전체	2직영
			typeCd = new String[]{"1","2"};
		}else{
			typeCd = new String[]{"1"};
		}
		
		dbparam.put("PAGE_NO",pageNo);
		dbparam.put("PAGE_SIZE", pagesize);
		dbparam.put("SEARCH_KEY",search_key);
		dbparam.put("SEARCH_TYPE",search_type);
		dbparam.put("TYPECD",typeCd);
		
		//결과리스트
		List resultList = generalDAO.queryForList("community.bbs.getDataList", dbparam);
		
		int t_count = generalDAO.count("community.bbs.getDataCount", dbparam);
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("community/bbs/dataList");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COMMUNITY_DATALIST);
		
		mav.addObject("pageNo", pageNo);
		mav.addObject("search_key", search_key);
		mav.addObject("search_type", search_type);
	
		mav.addObject("resultList", resultList);
		mav.addObject("t_count", t_count);
		mav.addObject("pageInfo", Paging.getPageMap(pageNo, t_count, pagesize, 10));
		
		return mav;
	}
	/**
	 * 자료실 상세
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView dataView(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		int pagesize = 10;

		// param
		Param param = new HttpServletParam(request);
		int pageNo = param.getInt("pageNo", 1);
		String search_key = param.getString("search_key");
		String search_type = param.getString("search_type");
		String seq = param.getString("seq");
		
		// db query parameter
		HashMap dbparam = new HashMap();
		dbparam.put("SEQ",seq);
		
		//cnt update(조회수 증가)
		generalDAO.update("community.bbs.updateDataListCnt", dbparam);
		
		Map result = (Map)generalDAO.queryForObject("community.bbs.getDataView", dbparam);
		
		//개행처리
		if( result != null ){
			if( result.get("CONT") != null ){
				String cont = (String)result.get("CONT");
				cont = cont.replaceAll("\r\n", "<br>");
				result.put("CONT", cont);
			}
		}
		
		//직영공지 임의경로로 접속할 경우 차단
		//지국 번호
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		// db query parameter
		String jikukType = "";
		String userGb = "";

		
		//지국으로 로그인 했을 경우 직영 지국인지 체크
		if( StringUtils.isNotEmpty(jikuk) ){
			dbparam.put("JIKUK",jikuk);
			jikukType = (String)generalDAO.queryForObject("community.bbs.getJikukType", dbparam);
		}
		//지국이 아닌 경우 usergb(권한레벨) 확인
		else if ( null != session.getAttribute(SESSION_NAME_ADMIN_LEVELS) ){
			userGb = (String)session.getAttribute(SESSION_NAME_ADMIN_LEVELS).toString();
		}
		//지국이 직영지국 이거나 권한레벨이 관리자일 경우 직영 공지사항도 노출
		if( !"101".equals(jikukType) && !"102".equals(jikukType) && !"9".equals(userGb) ){
			if( result != null && "2".equals(result.get("TYPECD")) ){
				ModelAndView mav = new ModelAndView();
				mav.setViewName("common/message");
				mav.addObject("message", "직영공지는 직영지국,관리자만 확인 가능합니다.");
				mav.addObject("returnURL", "/community/bbs/dataList.do");
				return mav;
			}
			
		}
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("community/bbs/dataView");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COMMUNITY_DATALIST);
		
		mav.addObject("pageNo", pageNo);
		mav.addObject("search_key", search_key);
		mav.addObject("search_type", search_type);
		mav.addObject("seq", seq);
	
		mav.addObject("result", result);
		
		return mav;
	}
	/**
	 * 자료실 폼(TYPE에 따라 쓰기,수정)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView dataForm(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		// param
		Param param = new HttpServletParam(request);
		int pageNo = param.getInt("pageNo", 1);
		String search_key = param.getString("search_key");
		String search_type = param.getString("search_type");
		String type = param.getString("type");
		String seq = param.getString("seq");
		
		//지국 번호
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		String userGb = "";
		
		if ( null != session.getAttribute(SESSION_NAME_ADMIN_LEVELS) ){
			userGb = (String)session.getAttribute(SESSION_NAME_ADMIN_LEVELS).toString();
		}
		
		ModelAndView mav = new ModelAndView();
		//type이 파라미터로 없는 경우, 관리자 권한이 9가 아닌경우 
		if( StringUtils.isEmpty(type) || !"9".equals(userGb)){
			mav.setViewName("common/message");
			mav.addObject("message", "경로를 확인해주세요.");
			mav.addObject("returnURL", "/community/bbs/dataList.do");
			return mav;
		}
		
		//::todo
		if( "write".equals(type) ){
			mav.setViewName("community/bbs/dataForm");
			mav.addObject("type", type);
			
		}else if( "modify".equals(type) ){
			
			// db query parameter
			HashMap dbparam = new HashMap();
			dbparam.put("SEQ",seq);
			
			Map result = (Map)generalDAO.queryForObject("community.bbs.getDataView", dbparam);
			
			mav.setViewName("community/bbs/dataForm");
			mav.addObject("seq", seq);
			mav.addObject("type", type);
			mav.addObject("result", result);
			
		}else if( "delete".equals(type) ){
			// db query parameter
			HashMap dbparam = new HashMap();
			
			dbparam.put("SEQ", seq);
			//delete
			generalDAO.delete("community.bbs.deleteData", dbparam);
			
			mav.setView(new RedirectView("/community/bbs/dataList.do"));
			
		}
		mav.addObject("pageNo", pageNo);
		mav.addObject("search_key", search_key);
		mav.addObject("search_type", search_type);
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COMMUNITY_DATALIST);
		return mav;
		
	}
	
	/**
	 * 자료실 폼 프로세스(TYPE에 따라 쓰기,수정)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView dataProcess(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		// param
		MultipartHttpServletParam param = new MultipartHttpServletParam(request);
		String type = param.getString("type");
		String titl = param.getString("titl");			//제목
		String typecd = param.getString("typecd");		//게시판 형태 전체공지,직영공지
		String inps = param.getString("inps");			//쓰기일 경우 작성자
		String chgps = param.getString("chgps");		//수정일 경우 수정자
		String cont = param.getString("cont");			//내용
		MultipartFile save_fnm = param.getMultipartFile("save_fnm");	//첨부파일

		//지국 번호
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		String userGb = "";
		
		if ( null != session.getAttribute(SESSION_NAME_ADMIN_LEVELS) ){
			userGb = (String)session.getAttribute(SESSION_NAME_ADMIN_LEVELS).toString();
		}
		
		ModelAndView mav = new ModelAndView();
		//type이 파라미터로 없는 경우, 관리자 권한이 9가 아닌경우 
		if( StringUtils.isEmpty(type) || !"9".equals(userGb)){
			mav.setViewName("common/message");
			mav.addObject("message", "경로를 확인해주세요.");
			mav.addObject("returnURL", "/community/bbs/dataList.do");
			return mav;
		}
		
		String real_fnm = "";
		if( !save_fnm.isEmpty() ){
			FileUtil fileUtil = new FileUtil( getServletContext() );
			real_fnm = fileUtil.saveOriginalFile(
											save_fnm, 
											//PATH_PHYSICAL_HOME,
											PATH_UPLOAD_ABSOLUTE_BBS_DATA
										);
		}
		
		HashMap dbparam = new HashMap();
		if( "write".equals(type) ){
			dbparam.put("TITL", titl);
			dbparam.put("TYPECD", typecd);
			dbparam.put("INPS", inps);
			dbparam.put("CONT", cont);
			if( !save_fnm.isEmpty() && StringUtils.isNotEmpty(real_fnm)){
				dbparam.put("SAVE_FNM", real_fnm);
				dbparam.put("REAL_FNM", real_fnm);
				dbparam.put("FILE_PATH", PATH_UPLOAD_ABSOLUTE_BBS_DATA);
			}
			//insert
			int seq = (Integer)generalDAO.insert("community.bbs.insertData", dbparam);
			
			mav.setViewName("common/message");
			mav.addObject("message", "등록되었습니다.");
			mav.addObject("returnURL", "/community/bbs/dataView.do?seq=" + seq);
			
		}else if( "modify".equals(type) ){
			String seq = param.getString("seq");			//게시글 번호
			
			dbparam.put("SEQ", seq);
			dbparam.put("TITL", titl);
			dbparam.put("TYPECD", typecd);
			dbparam.put("CHGPS", chgps);
			dbparam.put("CONT", cont);
			if( !save_fnm.isEmpty() && StringUtils.isNotEmpty(real_fnm)){
				dbparam.put("SAVE_FNM", real_fnm);
				dbparam.put("REAL_FNM", real_fnm);
				dbparam.put("FILE_PATH", PATH_UPLOAD_ABSOLUTE_BBS_DATA);
			}
			//update
			generalDAO.update("community.bbs.updateData", dbparam);
			
			mav.setViewName("common/message");
			mav.addObject("message", "수정되었습니다.");
			mav.addObject("returnURL", "/community/bbs/dataView.do?seq=" + seq);
			
		}
		
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COMMUNITY_DATALIST);
		return mav;
		
	}
	
	/**
	 * 게시판
	 * 
	 * @param request
	 * @param response
	 * @category 게시판
	 * @author ycpark
	 * @return
	 * @throws Exception
	 */
	public ModelAndView retrieveBoard(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			HashMap dbparam = new HashMap();
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 20;
			int totalCount = 0;
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));

			// 게시판 목록 조회
			List resultList = generalDAO.queryForList("community.bbs.retrieveBoard", dbparam);   
			// 게시판 목록 카운트
			totalCount = generalDAO.count("community.bbs.retrieveBoardCount", dbparam);
			
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 20));
			mav.addObject("resultList", resultList);
			mav.addObject("totalCount", totalCount);

			mav.addObject("now_menu", MENU_CODE_COMMUNITY_MEMBER);
			mav.setViewName("/community/bbs/board");
			return mav;
		}catch(Exception e){
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	
	/**
	 * 게시판 에디터 호출
	 * 
	 * @param request
	 * @param response
	 * @category 게시판 에디터 호출
	 * @author ycpark
	 * @return
	 * @throws Exception
	 */
	public ModelAndView popEditor(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		HashMap dbparam = new HashMap();

		String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
		String loginId = (String)session.getAttribute(SESSION_NAME_ADMIN_USERID);

		mav.addObject("loginId", loginId);
		mav.addObject("now_menu", MENU_CODE_COMMUNITY);
		mav.setViewName("/community/bbs/editor");
		return mav;
		
	}

	/**
	 * 게시판 에디터 호출
	 * 
	 * @param request
	 * @param response
	 * @category 게시판 에디터 호출
	 * @author ycpark
	 * @return
	 * @throws Exception
	 */
	public ModelAndView retrieveEditor(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		HashMap dbparam = new HashMap();
		Param param = new HttpServletParam(request);

		String loginId = (String)session.getAttribute(SESSION_NAME_ADMIN_USERID);
		String type = param.getString("type");
		String seq = param.getString("seq");

		dbparam.put("seq", seq);

		if("write".equals(type)){
			
		}else if("modify".equals(type)){
			//결과리스트
			Map result = (Map)generalDAO.queryForObject("community.bbs.getContents", dbparam);
			mav.addObject("result", result);
		}

		dbparam.put("loginId", loginId);
		String userNm = (String)generalDAO.queryForObject("community.bbs.getUserNm", dbparam);
		
		mav.addObject("userNm", userNm);
		mav.addObject("type", type);
		mav.addObject("loginId", loginId);
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COMMUNITY_MEMBER);
		mav.setViewName("community/bbs/editor");

		return mav;
	}
	
	/**
	 * 게시글 보기
	 * 
	 * @param request
	 * @param response
	 * @category 게시글 보기
	 * @author ycpark
	 * @return
	 * @throws Exception
	 */
	public ModelAndView viewBoard(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
	
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);

			Param param = new HttpServletParam(request);
			HashMap dbparam = new HashMap();
		
			String loginId = (String)session.getAttribute(SESSION_NAME_ADMIN_USERID);
			String seq = param.getString("seq");
	
			dbparam.put("seq", seq);
	
			// 조회수 증가
			generalDAO.getSqlMapClient().update("community.bbs.updateBoardCnt", dbparam);
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			
			Map result = (Map)generalDAO.queryForObject("community.bbs.getContents", dbparam);
			
			mav.addObject("filePath", PATH_UPLOAD_ABSOLUTE_BBS_DATA+"/");
			mav.addObject("result", result);
			mav.addObject("loginId", loginId);
			mav.addObject("now_menu", ICodeConstant.MENU_CODE_COMMUNITY_MEMBER);
			mav.setViewName("community/bbs/viewer");
	
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
	 * 게시글 작성, 수정
	 * 
	 * @param request
	 * @param response
	 * @category 게시글작성, 수정
	 * @author ycpark
	 * @return
	 * @throws Exception
	 */
	public ModelAndView saveCont(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			HashMap dbparam = new HashMap();
			MultipartHttpServletParam param = new MultipartHttpServletParam(request);
	
			String loginId = (String)session.getAttribute(SESSION_NAME_ADMIN_USERID);
			String type = param.getString("type");
			String seq = param.getString("seq");
			String title = param.getString("title");
			String content = param.getString("content");
			
			// 첨부 파일 처리
			if(param.getMultipartFile("fileNm") != null){
				MultipartFile multipartFile = param.getMultipartFile("fileNm");
				String realName = "";
				String newFileName = "";
				if(!multipartFile.isEmpty() ){
					realName = multipartFile.getOriginalFilename();
					int pos = realName.lastIndexOf(".");
					String etc = realName.substring(pos+1);
					
					newFileName = DateUtil.getCurrentDate("yyyyMMddHHmmssSSSS")+"."+etc;
					String fullFilePath = PATH_UPLOAD_RELATIVE_BOARD_DATA+"/data/"+newFileName;

					multipartFile.transferTo(new File(fullFilePath));
					dbparam.put("fileNm" , newFileName);
					dbparam.put("realNm" , realName);
				}
			}else{
			}
			
			dbparam.put("seq", seq);
			dbparam.put("title", title);
			dbparam.put("content", content);
			dbparam.put("loginId", loginId);

			if("write".equals(type)){
				generalDAO.getSqlMapClient().insert("community.bbs.saveBoard", dbparam);
				mav.addObject("message", "게시물 작성이 완료 되었습니다.");
			}else if("modify".equals(type)){
				generalDAO.getSqlMapClient().update("community.bbs.updateBoard", dbparam);
				mav.addObject("message", "게시물 수정이 완료 되었습니다.");
			}else if("delete".equals(type)){
				generalDAO.getSqlMapClient().delete("community.bbs.deleteBoard", dbparam);
				mav.addObject("message", "게시물 삭제가 완료 되었습니다.");
			}
			
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			mav.addObject("type", type);
			mav.addObject("loginId", loginId);
			mav.addObject("now_menu", ICodeConstant.MENU_CODE_COMMUNITY);
		    mav.setViewName("common/message");
			mav.addObject("returnURL", "/community/bbs/retrieveBoard.do");
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
	 * 직원게시판 파일 삭제
	 * 
	 * @param request
	 * @param response
	 * @category  직원게시판 파일 삭제
	 * @author ycpark
	 * @return
	 * @throws Exception
	 */
	public ModelAndView deleteFileBoard(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		// param
		MultipartHttpServletParam param = new MultipartHttpServletParam(request);
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			String type = param.getString("type");
			String seq = param.getString("seq");			//게시글 번호
		
			HashMap dbparam = new HashMap();
			dbparam.put("seq", seq);
			
			//update
			generalDAO.update("community.bbs.deleteFile", dbparam);

			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			mav.setViewName("common/message");
			mav.addObject("message", "파일이 삭제되었습니다.");
			mav.addObject("returnURL", "/community/bbs/retrieveEditor.do?type=modify&seq=" + seq);
			mav.addObject("now_menu", ICodeConstant.MENU_CODE_COMMUNITY);
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
	 * 직원게시판 이미지 첨부
	 * 
	 * @param request
	 * @param response
	 * @category  직원게시판 이미지 첨부
	 * @author ycpark
	 * @return
	 * @throws Exception
	 */
	public ModelAndView insertImage(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		FileInputStream in = null;
		// param
		MultipartHttpServletParam param = new MultipartHttpServletParam(request);
		
		try{
			MultipartFile multipartFile = param.getMultipartFile("uploadInputBox");
			// 첨부 파일 처리
			String realName = "";
			String newFileName = "";
			if(!multipartFile.isEmpty() ){
				realName = multipartFile.getOriginalFilename();
				int pos = realName.lastIndexOf(".");
				String etc = realName.substring(pos+1);

				// 1. was 서버로 파일 전송
				newFileName = DateUtil.getCurrentDate("yyyyMMddHHmmssSSSS")+"."+etc;
				String fullFilePath = PATH_UPLOAD_RELATIVE_BOARD_DATA+"/data/"+newFileName;
				multipartFile.transferTo(new File(fullFilePath));
				
				// 2. web 서버로 sftp를 이용하여 파일 전송
				ChannelSftp channelSftp = connect();
				in = new FileInputStream(fullFilePath);
				// 업로드하려는 위치르 디렉토리를 변경한다.
				channelSftp.cd("/home/tmax/mkreader/uploadedfile/board/img");
	            channelSftp.put(in, newFileName);

	            // 업로드 후 was서버 파일 삭제
	            File f = new File(fullFilePath);
	            f.delete();
	            System.out.println("==> Deleted: at wasServer");

	            // 3. 에디터에 첨부하기 위하여 경로 전달
	            String editorFilePath = "/uploadedfile/board/img/"+newFileName;
				mav.addObject("newFileName", newFileName);
				mav.addObject("FilePath", editorFilePath);
			}
			
			System.out.println("==> Uploaded: at webServer");
			mav.setViewName("community/bbs/callback");
			return mav;
		}catch(Exception e){
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}finally {
            try {
            	// 업로드된 파일을 닫는다.
                in.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
	}

	
	private ChannelSftp connect() {
		System.out.println("==> Connecting to webserver");
		Session session = null;
		Channel channel = null;
		ChannelSftp channelSftp = new ChannelSftp();
		// 1. JSch 객체를 생성한다.
		JSch jsch = new JSch();
		
		try{
			// 2. 세션 객체를 생성한다 (사용자 이름, 접속할 호스트, 포트를 인자로 준다.)
			session = jsch.getSession("tmax", "218.144.58.1", 22);
			// 3. 패스워드를 설정한다.
			session.setPassword("tm1324");
			// 4. 세션과 관련된 정보를 설정한다.
			java.util.Properties config = new java.util.Properties();
			// 4-1. 호스트 정보를 검사하지 않는다.
			config.put("StrictHostKeyChecking", "no");
			session.setConfig(config);
			// 5. 접속한다.
			session.connect();
			// 6. sftp 채널을 연다.
			channel = session.openChannel("sftp");
			// 7. 채널에 연결한다.
			channel.connect();
        }catch(JSchException e){
            e.printStackTrace();
        }
		// 8. 채널을 FTP용 채널 객체로 캐스팅한다.
		channelSftp = (ChannelSftp)channel;
        System.out.println("==> Connected to webserver");
        return channelSftp;
    }
	
	/**
	 * 메인 알림 리스트
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView mainNoticeList(HttpServletRequest request,HttpServletResponse response) throws Exception {
		int pagesize = 2;

		// param
		Param param = new HttpServletParam(request);
		int pageNo = param.getInt("pageNo", 1);
		
		//지국 번호
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		String adminId = (String) session.getAttribute(SESSION_NAME_ADMIN_USERID);
		
		// db query parameter
		HashMap dbparam = new HashMap();
		String jikukType = "";
		String userGb = "";
		String typeCd[] = null;
		
		//지국으로 로그인 했을 경우 직영 지국인지 체크
		if( StringUtils.isNotEmpty(jikuk) ){
			dbparam.put("JIKUK",jikuk);
			jikukType = (String)generalDAO.queryForObject("community.bbs.getJikukType", dbparam);
		}
		//지국이 아닌 경우 usergb(권한레벨) 확인
		else if ( null != session.getAttribute(SESSION_NAME_ADMIN_LEVELS) ){
			userGb = (String)session.getAttribute(SESSION_NAME_ADMIN_LEVELS).toString();
		}
		
		//지국이 구분별 권한레벨이 관리자일 경우 직영 공지사항도 노출 대상 정의
		if( "9".equals(userGb) ){
			//1전체	2직영  5청약  6지방
			typeCd = new String[]{"1","2","5","6"};
		}else if( "101".equals(jikukType) || "102".equals(jikukType) ){
			typeCd = new String[]{"1","2"};
		}else if( "201".equals(jikukType) || "202".equals(jikukType) || "203".equals(jikukType) ){
			typeCd = new String[]{"1","5"};
		}else if( "301".equals(jikukType) ){
			typeCd = new String[]{"1","6"};
		}else{
			typeCd = new String[]{"1"};
		}
		
		dbparam.put("PAGE_NO",pageNo);
		dbparam.put("PAGE_SIZE", pagesize);
		dbparam.put("TYPECD",typeCd);
		
		//공지사항 결과리스트
		String tempId = StringUtils.isNotEmpty(jikuk)?jikuk:adminId;
		dbparam.put("JIKUK",tempId);
		
		List<HashMap<String,Object>> noticeList = generalDAO.queryForList("community.bbs.getMainNoticeList", dbparam);
		String noticeDate = null;
		// mav
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("noticeList", noticeList);
		mav.addObject("jikukType",jikukType);
		mav.setViewName("community/bbs/mainNoticeList");
		return mav;
	}
	
}
