package com.mkreader.web.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.util.Param;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;
import org.springframework.web.servlet.view.RedirectView;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.Paging;

public class MemoController extends MultiActionController implements
ISiteConstant, ICodeConstant {
	
	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {
			this.generalDAO = generalDAO;
	}
	
	/**
	 * 독자별 메모 리스트
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView popMemoList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		List memoList = new ArrayList();
		
		try{
			HashMap dbparam = new HashMap();
			dbparam.put("READNO" , param.getString("readno"));
			System.out.println("READNO = "+param.getString("readno"));			
			memoList = generalDAO.queryForList("util.memo.getMemoListByReadno" , dbparam);
			
			mav.addObject("memoList" , memoList);
			mav.setViewName("common/memoPopup");
			
			return mav;
		} catch(Exception e) {
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	
	
	/**
	 * 독자별 메모 리스트(ajax)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getAjaxMemoList(HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		List memoList = new ArrayList();
		
		try{
			HashMap dbparam = new HashMap();

			//메모조회
			dbparam.put("READNO" , param.getString("readNo"));
			memoList = generalDAO.queryForList("util.memo.getMemoListByReadno", dbparam);

			JSONObject jsonObject = new JSONObject();
			jsonObject.put("memoList", JSONArray.fromObject(memoList));
			
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return null;
	}
	
	/**
	 * 독자별 메모 리스트(ajax) - 최근4건
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getAjaxMemoOfRecently(HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		List memoList = new ArrayList();
		
		try{
			HashMap dbparam = new HashMap();

			//메모조회
			dbparam.put("READNO" , param.getString("readNo"));
			memoList = generalDAO.queryForList("util.memo.getMemoRecently", dbparam);

			JSONObject jsonObject = new JSONObject();
			jsonObject.put("memoList", JSONArray.fromObject(memoList));
			
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return null;
	}
	
	
	/**
	 * 독자별 메모 리스트(ajax)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getAjaxAllMemoList(HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		List memoList = new ArrayList();
		
		try{
			HashMap dbparam = new HashMap();

			//메모조회
			dbparam.put("READNO" , param.getString("readNo"));
			memoList = generalDAO.queryForList("util.memo.getMemoRecently", dbparam);

			JSONObject jsonObject = new JSONObject();
			jsonObject.put("memoList", JSONArray.fromObject(memoList));
			
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return null;
	}
	/**
	 * 메모저장
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView saveMemoContents(HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		HashMap dbparam = new HashMap();
		
		try {
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);

			//value param
			String rtnUrl 		= param.getString("rtnUrl");
			String readNo 		= param.getString("readNo");
			String remk 		= param.getString("remk");
			String createId 	= (String)session.getAttribute(SESSION_NAME_AGENCY_SERIAL);
			
			dbparam.put("READNO", readNo);
			dbparam.put("MEMO", remk);
			dbparam.put("CREATEID", createId);
			
			generalDAO.getSqlMapClient().insert("util.memo.insertMemo", dbparam); //메모생성
			
			//search param
			mav.addObject("searchText" ,param.getString("searchText") );
			mav.addObject("searchType" ,param.getString("searchType") );	
			mav.setView(new RedirectView(rtnUrl));
			
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
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
	
}
