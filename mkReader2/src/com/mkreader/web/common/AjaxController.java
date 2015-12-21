package com.mkreader.web.common;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.util.Param;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;

public class AjaxController extends MultiActionController implements
ISiteConstant, ICodeConstant {
	
	private GeneralDAO generalDAO;
	
	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}

	
	/**
	 * 지국명 자동완성 기능 (AJAX)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @category 지국명 자동완성 기능 (AJAX)
	 * @throws Exception
	 */
	public ModelAndView selectAjaxJikukList(HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		System.out.println("select Ajax list start");
		request.setCharacterEncoding("utf-8");

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();

		try{
			
			HashMap dbparam = new HashMap();
			dbparam.put("SEARCH_KEY", param.getString("SEARCH_KEY"));		
			
			System.out.println("SEARCH_KEY = "+param.getString("SEARCH_KEY"));
			
			// 지국목록 조회
			List jikukList = generalDAO.queryForList("common.ajax.jikuk.getList" , dbparam);  // 지국조회
			
			System.out.println("jikukList,size = "+jikukList.size());
			
			/*

			//쿼리 결과를 jsonArray로 만들어 준다
			JSONArray jsonArray = JSONArray.fromObject(jikukList);
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("jikukNamelist", jsonArray);
			
			//jsonArray를 jsonObject로 만들어 준다
			JSONObject jsonObject = JSONObject.fromObject(map);
			
			response.setContentType( "text/xml; charset=UTF-8" );
		
			
			//jsp로 값을 보낸다.
			response.getWriter().print(jsonObject);
				*/
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}

}
