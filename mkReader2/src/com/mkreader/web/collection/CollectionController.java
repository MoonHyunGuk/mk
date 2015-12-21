/*------------------------------------------------------------------------------
 * NAME : CollectionController 
 * DESC : 수금 관리
 * Author : pspkj
 *----------------------------------------------------------------------------*/
package com.mkreader.web.collection;

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

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.DateUtil;

public class CollectionController extends MultiActionController implements
ISiteConstant, ICodeConstant {

	private GeneralDAO generalDAO;
	
	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}

	
	/**
	 * 수금 정보 조회(AJAX)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ajaxCollectionList_org(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			HashMap dbparam = new HashMap();
			
			dbparam.put("readNo", param.getString("readNo")); // 고객번호
			dbparam.put("newsCd", param.getString("newsCd")); // 뉴스코드
			dbparam.put("seq", param.getString("seq")); // 일련번호
			dbparam.put("boSeq", param.getString("boSeq"));	

			String nowYYMM = (String)generalDAO.queryForObject("common.getLastSGYYMM", dbparam);//사용년월
			List collectionList = generalDAO.queryForList("collection.collection.collectionList", dbparam);//독자 수금 이력
			dbparam.put("year", DateUtil.getWantDay(nowYYMM+"01",1,-1).substring(0,4)); 
			String lastYearList = (String)generalDAO.queryForObject("collection.collection.sumgClam", dbparam);//작년 독자 수금 이력 약어
			dbparam.put("year", nowYYMM.substring(0,4)); 
			String thisYearList = (String)generalDAO.queryForObject("collection.collection.sumgClam", dbparam);//금년 독자 수금 이력 약어
			
			mav.addObject("collectionList", collectionList);
			mav.addObject("thisYear", thisYearList);
			mav.addObject("lastYear", lastYearList);

			// mav
			mav.setViewName("collection/ajaxCollectionList");
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
	 * 수금 정보 조회(AJAX)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ajaxCollectionList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		
		try{
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			Map<String, Object> collectionMap = new HashMap<String, Object>();;
			Map<String, Object> sugmTypeMap = new HashMap<String, Object>();;
			int index = 0;
			
			dbparam.put("readNo", param.getString("readNo")); // 고객번호
			dbparam.put("newsCd", param.getString("newsCd")); // 뉴스코드
			dbparam.put("seq", param.getString("seq")); // 일련번호
			dbparam.put("boSeq", param.getString("boSeq"));	
			
			String nowYYMM = (String)generalDAO.queryForObject("common.getLastSGYYMM", dbparam);//사용년월
			//독자 수금 이력
			List<Map<String, Object>> collectionList = generalDAO.queryForList("collection.collection.collectionList", dbparam);
			
			for(Map<String, Object> map : collectionList) {
				for (Map.Entry<String, Object> entry : map.entrySet()) {
					String key = entry.getKey();
					Object value = entry.getValue();
					collectionMap.put(key, value);
				}
				index++;
			}
			
			//수금방법 조회
			List<Map<String, Object>> sgTypeList = generalDAO.queryForList("reader.common.retrieveSgType", dbparam);
			
			index = 0;
			for(Map<String, Object> map : sgTypeList) {
				for (Map.Entry<String, Object> entry : map.entrySet()) {
					String key = entry.getKey();
					Object value = entry.getValue();
					sugmTypeMap.put(key, value);
				}
				index++;
			}
			
			//작년 독자 수금 이력 약어
			dbparam.put("year", DateUtil.getWantDay(nowYYMM+"01",1,-1).substring(0,4)); 
			String lastYearList = (String)generalDAO.queryForObject("collection.collection.sumgClam", dbparam);
			
			//금년 독자 수금 이력 약어
			dbparam.put("year", nowYYMM.substring(0,4)); 
			String thisYearList = (String)generalDAO.queryForObject("collection.collection.sumgClam", dbparam);
			
			HashMap<String, String> yearList = new HashMap<String, String>();
			yearList.put("LASTYEAR", lastYearList);
			yearList.put("THISYEAR", thisYearList);
			
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("collectionList", JSONArray.fromObject(collectionList));
			jsonObject.put("sgTypeList", JSONArray.fromObject(sgTypeList));
			jsonObject.put("yearList", JSONArray.fromObject(yearList));
			
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
		
		
	/**
	 * 지국 아이디 중복 체크
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView agencyDupChk(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);		
		ModelAndView mav = new ModelAndView();
		
		String userId = param.getString("userId");
		String useYn = "N";
		
		HashMap dbparam = new HashMap();
		dbparam.put("userId", userId); 

		logger.debug("파람정보_UserID : "+ userId);
		
		// 지국번호 중복여부 확인
		List agencyInfo = generalDAO.queryForList("collection.collection.getDupAgency" , dbparam);
		
		if(agencyInfo.size()>0){
			mav.addObject("alert", "이미 등록된 지국번호 입니다.");
		}else{	
			mav.addObject("alert", "사용 가능한 지국번호입니다.");
			useYn = "Y";
		}
		
		mav.addObject("userId", userId);
		mav.addObject("useYn", useYn);
		
		// mav
		mav.setViewName("collection/ajaxAgencyDupChk");
		
		return mav;
			
	}
	
	
	/** 
	 * 지국아이디 중복체크
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView agencyOverlapChk(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		
		try{
			HashMap dbparam = new HashMap();
			
			String userId = param.getString("userId");
			
			dbparam.put("userId", userId);
			
			// 지국번호 중복여부 확인
			String overlapYn = (String)generalDAO.queryForObject("collection.collection.selectAgencyOverlap" , dbparam);
			
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("overlapYn", overlapYn);
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
		} catch(Exception e){
			e.printStackTrace();
		}	
		return null;
	}
	
	
}
