package com.mkreader.web.management;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.util.Param;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;

public class ReaderRestoreController extends MultiActionController implements
ISiteConstant, ICodeConstant {

	public static Logger logger = Logger.getRootLogger();
	
	private GeneralDAO generalDAO;
	
	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}

	/** 
	 * 독자복구화면
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView readerRestore(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		try{
			HashMap dbparam = new HashMap();
			
			String opReaderNo = param.getString("opReaderNo");
			
			dbparam.put("opReaderNo", opReaderNo);
			
			//독자정보조회
			List readerDataList = generalDAO.queryForList("management.readerRestore.getReaderDataList",  dbparam);// 지국 목록
			
			mav.addObject("now_menu", MENU_CODE_MANAGEMENT_RESTORE);
			mav.addObject("opReaderNo", opReaderNo);
			mav.addObject("readerDataList", readerDataList);
			mav.setViewName("management/reader/readerRestore");
		} catch(Exception e){
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
		}	
		return mav;
	}
	
	/** 
	 * 독자정보조회
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectReaderData(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		
		try{
			HashMap dbparam = new HashMap();
			
			String readNo = param.getString("readNo");
			String seq = param.getString("seq");
			
			dbparam.put("readNo", readNo);
			dbparam.put("seq", seq);
			
			//독자정보조회
			Map readerData = (Map)generalDAO.queryForObject("management.readerRestore.getReaderData", dbparam);
			
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("readerData", JSONArray.fromObject(readerData));
			
			//독자타입명
			String readTypeCd = (String)readerData.get("READTYPECD");
			String readTypeNm = "";
			if("011".equals(readTypeCd)) {
				readTypeNm = "일반";
			} else if("012".equals(readTypeCd)) {
				readTypeNm = "학생(지국)";
			} else if("013".equals(readTypeCd)) {
				readTypeNm = "학생(본사)";
			} else if("014".equals(readTypeCd)) {
				readTypeNm = "병독";
			} else if("015".equals(readTypeCd)) {
				readTypeNm = "교육";
			} else if("016".equals(readTypeCd)) {
				readTypeNm = "본사사원";
			} else if("017".equals(readTypeCd)) {
				readTypeNm = "소외계층";
			} else if("021".equals(readTypeCd)) {
				readTypeNm = "기증";
			} else if("022".equals(readTypeCd)) {
				readTypeNm = "홍보";
			}
			
			//수금방법명
			String sgType = (String)readerData.get("SGTYPE");
			String sgTypeNm = "";
			if("011".equals(sgType)) {
				sgTypeNm = "지로 ";
			} else if("012".equals(sgType)) {
				sgTypeNm = "방문";
			} else if("013".equals(sgType)) {
				sgTypeNm = "통장입금";
			} else if("021".equals(sgType)) {
				sgTypeNm = "자동이체";
			} else if("022".equals(sgType)) {
				sgTypeNm = "카드";
			} else if("023".equals(sgType)) {
				sgTypeNm = "본사입금";
			} else if("024".equals(sgType)) {
				sgTypeNm = "쿠폰";
			} 
			
			jsonObject.put("readTypeNm", readTypeNm);
			jsonObject.put("sgTypeNm", sgTypeNm);
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
		} catch(Exception e){
			e.printStackTrace();
		}	
		return null;
	}
	
	
	/** 
	 * 독자정보조회
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectReaderHistoryData(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		
		try{
			HashMap dbparam = new HashMap();
			
			String readNo = param.getString("readNo");
			String seq = param.getString("seq");
			
			dbparam.put("readNo", readNo);
			dbparam.put("seq", seq);
			
			//독자히스토리조회 
			List readerHistoryList = generalDAO.queryForList("management.readerRestore.getReaderHistoryList", dbparam);

			JSONObject jsonObject = new JSONObject();
			jsonObject.put("readerHistoryList", JSONArray.fromObject(readerHistoryList));
			
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
		} catch(Exception e){
			e.printStackTrace();
		}	
		return null;
	}
	
	/** 
	 * 독자수금,히스토리정보조회
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectReaderSugmNHistoryData(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		List readerSugmList =  new ArrayList();
		List readerHistoryList = new ArrayList();
		
		try{
			HashMap dbparam = new HashMap();
			
			String readNo = param.getString("readNo");
			String seq = param.getString("seq");
			
			dbparam.put("readNo", readNo);
			dbparam.put("seq", seq);
			
			//독자수금조회 
			readerSugmList = generalDAO.queryForList("management.readerRestore.getReaderSugmList", dbparam);
			
			//독자히스토리조회 
			readerHistoryList = generalDAO.queryForList("management.readerRestore.getReaderHistoryList", dbparam);
			
			mav.addObject("readerSugmList", readerSugmList);
			mav.addObject("readerHistoryList", readerHistoryList);
			mav.setViewName("management/reader/pop_sugmdata");
			return mav;
		} catch(Exception e){
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}	
	}
	
	/**
	 * 지로, 방문, 통장입금독자 복구
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView restoreOnlyReaderNewsTable(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HashMap dbparam = new HashMap();
		List readerDataList =  new ArrayList();
		
		//String opSgtype = param.getString("opSgtype");
		//String opReadTypeCd = param.getString("opReadTypeCd");
		String readNo = param.getString("hdnReadno");
		String seq = param.getString("hdnSeq");
		String opReaderNo = param.getString("opReaderNo");
		String newsCd = param.getString("hdnNewsCd");
		String bno = param.getString("bno");
		
		dbparam.put("readNo", readNo);
		dbparam.put("seq", seq);
		dbparam.put("opReaderNo", opReaderNo);
		dbparam.put("newsCd", newsCd);
		dbparam.put("bno", bno);
		
		try {
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			//독자 HISTORY 생성
			generalDAO.getSqlMapClient().insert("management.readerRestore.insertreaderHist", dbparam); //구독정보히스토리 업데이트
			
			//독자수금조회 
			generalDAO.getSqlMapClient().update("management.readerRestore.updateReaderNewsTable", dbparam);
			
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			generalDAO.getSqlMapClient().endTransaction();
			
			//독자정보조회
			readerDataList = generalDAO.queryForList("management.readerRestore.getReaderDataList",  dbparam);// 지국 목록
			/*
			mav.addObject("now_menu", MENU_CODE_MANAGEMENT_RESTORE);
			mav.addObject("opReaderNo", opReaderNo);
			mav.addObject("readerDataList", readerDataList);
			mav.setViewName("management/reader/readerRestore");
			*/
			mav.setViewName("common/message");
			mav.addObject("now_menu", MENU_CODE_MANAGEMENT_RESTORE);
			mav.addObject("opReaderNo", opReaderNo);
			mav.addObject("readerDataList", readerDataList);
			mav.addObject("message", "독자복구를 완료되었습니다.");
			mav.addObject("returnURL", "/management/readerRestore/readerRestore.do");
		} catch(Exception e) {
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			generalDAO.getSqlMapClient().endTransaction();
			mav.setViewName("common/message");
			mav.addObject("message", "독자복구를 실패하였습니다.");
			mav.addObject("returnURL", "/management/readerRestore/readerRestore.do");
		}
		return mav;
	}
	
	 
	/**
	 * 카드독자 복구
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView restoreCardReaderNewsNTable(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HashMap dbparam = new HashMap();
		
		//String opSgtype = param.getString("opSgtype");
		//String opReadTypeCd = param.getString("opReadTypeCd");
		String readNo = param.getString("hdnReadno");
		String seq = param.getString("hdnSeq");
		String opReaderNo = param.getString("opReaderNo");
		String newsCd = param.getString("hdnNewsCd");
		String bno = param.getString("bno");
		
		dbparam.put("readNo", readNo);
		dbparam.put("seq", seq);
		dbparam.put("opReaderNo", opReaderNo);
		dbparam.put("newsCd", newsCd);
		dbparam.put("bno", bno);
		
		try {
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			//독자 HISTORY 생성
			generalDAO.getSqlMapClient().insert("management.readerRestore.insertreaderHist", dbparam); //구독정보히스토리 업데이트
			
			//독자수금조회 
			generalDAO.getSqlMapClient().update("management.readerRestore.updateReaderNewsTable", dbparam);
			
			//카드테이블 상태변경
			generalDAO.getSqlMapClient().update("management.readerRestore.updateCardReaderTable", dbparam);
			
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			generalDAO.getSqlMapClient().endTransaction();
			
			//독자정보조회
			List readerDataList = generalDAO.queryForList("management.readerRestore.getReaderDataList",  dbparam);// 지국 목록
			
			/*
			mav.addObject("now_menu", MENU_CODE_MANAGEMENT_RESTORE);
			mav.addObject("opReaderNo", opReaderNo);
			mav.addObject("readerDataList", readerDataList);
			mav.setViewName("management/reader/readerRestore");
			*/
			mav.setViewName("common/message");
			mav.addObject("now_menu", MENU_CODE_MANAGEMENT_RESTORE);
			mav.addObject("opReaderNo", opReaderNo);
			mav.addObject("readerDataList", readerDataList);
			mav.addObject("message", "독자복구를 완료되었습니다.");
			mav.addObject("returnURL", "/management/readerRestore/readerRestore.do");
		} catch(Exception e) {
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			generalDAO.getSqlMapClient().endTransaction();
			mav.setViewName("common/message");
			mav.addObject("message", "독자복구를 실패하였습니다.");
			mav.addObject("returnURL", "/index.jsp");
		}
		return mav;
	}
	
	
	/**
	 * 자동이체독자 복구
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView restoreReaderUserTable(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HashMap dbparam = new HashMap();
		
		//String opSgtype = param.getString("opSgtype");
		String readTypeCd = param.getString("opReadTypeCd");
		String readNo = param.getString("hdnReadno");
		String seq = param.getString("hdnSeq");
		String opReaderNo = param.getString("opReaderNo");
		String newsCd = param.getString("hdnNewsCd");
		String bno = param.getString("bno");
		
		dbparam.put("readNo", readNo);
		dbparam.put("seq", seq);
		dbparam.put("opReaderNo", opReaderNo);
		dbparam.put("newsCd", newsCd);
		dbparam.put("bno", bno);
		
		try {
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			//독자 HISTORY 생성
			generalDAO.getSqlMapClient().insert("management.readerRestore.insertreaderHist", dbparam); //구독정보히스토리 업데이트
			
			//독자수금조회 
			generalDAO.getSqlMapClient().update("management.readerRestore.updateReaderNewsTable", dbparam);
			
			//자동이체테이블 상태변경
			if("011".equals(readTypeCd)) {	//일반
				generalDAO.getSqlMapClient().update("management.readerRestore.updateTblUsersTable", dbparam);
			} else {	//학생
				generalDAO.getSqlMapClient().update("management.readerRestore.updateTblUsersStuTable", dbparam);
			}
			
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			generalDAO.getSqlMapClient().endTransaction();
			
			//독자정보조회
			List readerDataList = generalDAO.queryForList("management.readerRestore.getReaderDataList",  dbparam);// 지국 목록
			
			/*
			mav.addObject("now_menu", MENU_CODE_MANAGEMENT_RESTORE);
			mav.addObject("opReaderNo", opReaderNo);
			mav.addObject("readerDataList", readerDataList);
			mav.setViewName("management/reader/readerRestore");
			*/
			mav.setViewName("common/message");
			mav.addObject("now_menu", MENU_CODE_MANAGEMENT_RESTORE);
			mav.addObject("opReaderNo", opReaderNo);
			mav.addObject("readerDataList", readerDataList);
			mav.addObject("message", "독자복구를 완료되었습니다.");
			mav.addObject("returnURL", "/management/readerRestore/readerRestore.do");
		} catch(Exception e) {
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			generalDAO.getSqlMapClient().endTransaction();
			mav.setViewName("common/message");
			mav.addObject("message", "독자복구를 실패하였습니다.");
			mav.addObject("returnURL", "/index.jsp");
		}
		return mav;
	}
			

}
