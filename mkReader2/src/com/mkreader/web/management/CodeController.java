package com.mkreader.web.management;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.servlet.util.MultipartHttpServletParam;
import kr.reflexion.espresso.util.Param;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;
import org.springframework.web.servlet.view.RedirectView;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.DateUtil;
import com.mkreader.util.FileUtil;

public class CodeController extends MultiActionController implements
ISiteConstant, ICodeConstant {
	
public static Logger logger = Logger.getRootLogger();
	
	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {

			this.generalDAO = generalDAO;
	}
	
	
	/**
	 * 코드 1레벨 리스트 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView codeList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		
		HttpSession session = request.getSession();
		List<Object> codeStep1List = new ArrayList<Object>();
		
		String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
	
		//코드 1레벨 리스트 조회
		codeStep1List = generalDAO.queryForList("management.code.selectCodeStep1List");
		
		mav.addObject("loginType", loginType);
		mav.addObject("now_menu", MENU_CODE_MANAGEMENT_CODE);
		mav.addObject("codeStep1List", codeStep1List);
		mav.setViewName("management/code/codeList");
		return mav;

	}
	
	
	/**
	 * 코드 1레벨 선택후 리스트조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView codeSubList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		Param param = new HttpServletParam(request);
		
		List<Object> codeStep1List = new ArrayList<Object>();
		List<Object> codeStep2List = new ArrayList<Object>();
		
		//parameter values
		String selCdclsf = param.getString("selCdclsf");
		
		//코드 1레벨 리스트 조회
		codeStep1List = generalDAO.queryForList("management.code.selectCodeStep1List");
		
		//코드 2레벨 리스트 조회
		dbparam.put("CODE", selCdclsf);
		codeStep2List = generalDAO.queryForList("management.code.selectCodeStep2List", dbparam);
		
		mav.addObject("now_menu", MENU_CODE_MANAGEMENT_CODE);
		mav.addObject("selCdclsf", selCdclsf);
		mav.addObject("codeStep1List", codeStep1List);
		mav.addObject("codeStep2List", codeStep2List);
		mav.setViewName("management/code/codeList");
		return mav;

	}
	
	
	/**
	 * 코드관리 상세보기
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView codeDetailView(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		Param param = new HttpServletParam(request);
		
		List<Object> codeStep1List = new ArrayList<Object>();
		List<Object> codeStep2List = new ArrayList<Object>();
		
		//parameter values
		String flag = param.getString("flag");
		String selCdclsf = param.getString("selCdclsf");
		String subCode = param.getString("subCode");
		
		//코드 1레벨 리스트 조회
		codeStep1List = generalDAO.queryForList("management.code.selectCodeStep1List");
		
		//코드 2레벨 리스트 조회
		dbparam.put("CODE", selCdclsf);
		codeStep2List = generalDAO.queryForList("management.code.selectCodeStep2List", dbparam);
		
		//코드 상세내용 조회
		dbparam.put("SUBCODE", subCode);
		Map codeView =  (Map)generalDAO.queryForObject("management.code.getCodeView", dbparam);
		
		mav.addObject("now_menu", MENU_CODE_MANAGEMENT_CODE);
		mav.addObject("subCode", subCode);
		mav.addObject("selCdclsf", selCdclsf);
		mav.addObject("codeStep1List", codeStep1List);
		mav.addObject("codeStep2List", codeStep2List);
		mav.addObject("codeView", codeView);
		mav.setViewName("management/code/codeList");
		return mav;

	}
	
	
	/**
	 * 코드 수정 페이지보기
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView codeEdit(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		Param param = new HttpServletParam(request);
		
		List<Object> codeStep1List = new ArrayList<Object>();
		List<Object> codeStep2List = new ArrayList<Object>();
		
		//parameter values
		String flag = param.getString("flag");
		String selCdclsf = param.getString("selCdclsf");
		String subCode = param.getString("subCode");
		
		//코드 1레벨 리스트 조회
		codeStep1List = generalDAO.queryForList("management.code.selectCodeStep1List");
		
		//코드 2레벨 리스트 조회
		dbparam.put("CODE", selCdclsf);
		codeStep2List = generalDAO.queryForList("management.code.selectCodeStep2List", dbparam);
		
		//코드 상세내용 조회
		dbparam.put("SUBCODE", subCode);
		Map codeView =  (Map)generalDAO.queryForObject("management.code.getCodeView", dbparam);
		
		mav.addObject("now_menu", MENU_CODE_MANAGEMENT_CODE);
		mav.addObject("flag", flag);
		mav.addObject("subCode", subCode);
		mav.addObject("selCdclsf", selCdclsf);
		mav.addObject("codeStep1List", codeStep1List);
		mav.addObject("codeStep2List", codeStep2List);
		mav.addObject("codeView", codeView);
		mav.setViewName("management/code/codeEdit");
		return mav;

	}
	
	/**
	 * 코드정보 등록 이벤트
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView insertCodeData(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		// mav
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		HttpSession session = request.getSession();
		
		List<Object> codeStep1List = new ArrayList<Object>();
		List<Object> codeStep2List = new ArrayList<Object>();
		
		String cdclsf 	= param.getString("cdclsf");					//코드구분		
		String code 	= param.getString("code");					//코드
		String cname 	= param.getString("cname");				//코드명
		String yname 	= param.getString("yname");				//코드약어	
		String remk 	= param.getString("remk");					//비고
		String resv1 	= param.getString("resv1");					//예약1
		String resv2 	= param.getString("resv2");					//예약2
		String resv3 	= param.getString("resv3");					//예약3
		String useyn 	= param.getString("useyn");					//사용여부
		
		String selCdclsf = param.getString("selCdclsf");			//코드구분
		String subCode = param.getString("subCode");			//코드(명)
		
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		
		dbparam = new HashMap<Object, Object>();
		try {
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
		
			//변수 값 설정
			dbparam.put("CDCLSF", cdclsf);
			dbparam.put("CODE", code);
			dbparam.put("CNAME", cname);
			dbparam.put("YNAME", yname);
			dbparam.put("REMK", remk);
			dbparam.put("RESV1", resv1);
			dbparam.put("RESV2", resv2);
			dbparam.put("RESV3", resv3);
			dbparam.put("USEYN", useyn); //130006358
			dbparam.put("userId", userId);
		
			//등록
			generalDAO.getSqlMapClient().update("management.code.insertCodeData", dbparam);
		
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			
			//코드 1레벨 리스트 조회
			codeStep1List = generalDAO.queryForList("management.code.selectCodeStep1List");
			
			//코드 2레벨 리스트 조회
			dbparam.put("CODE", cdclsf);
			codeStep2List = generalDAO.queryForList("management.code.selectCodeStep2List", dbparam);
			
			//코드 상세내용 조회
			dbparam.put("SUBCODE", code);
			Map codeView =  (Map)generalDAO.queryForObject("management.code.getCodeView", dbparam);
			
			mav.addObject("now_menu", ICodeConstant.MENU_CODE_MANAGEMENT_CODE);
			mav.addObject("selCdclsf", cdclsf);
			mav.addObject("subCode", code);
			mav.addObject("codeStep1List", codeStep1List);
			mav.addObject("codeStep2List", codeStep2List);
			mav.addObject("codeView", codeView);
			mav.setViewName("management/code/codeList");
		} catch(Exception e) {
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}finally{
			generalDAO.getSqlMapClient().endTransaction();
		}
		return mav;
	}
	
	
	/**
	 * 코드정보 수정 이벤트
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView updateCodeData(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		// mav
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		HttpSession session = request.getSession();
		
		List<Object> codeStep1List = new ArrayList<Object>();
		List<Object> codeStep2List = new ArrayList<Object>();
		
		String cdclsf 	= param.getString("cdclsf");					//코드구분		
		String code 	= param.getString("code");					//코드
		String cname 	= param.getString("cname");				//코드명
		String yname 	= param.getString("yname");				//코드약어	
		String remk 	= param.getString("remk");					//비고
		String resv1 	= param.getString("resv1");					//예약1
		String resv2 	= param.getString("resv2");					//예약2
		String resv3 	= param.getString("resv3");					//예약3
		String useyn 	= param.getString("useyn");					//사용여부
		
		String selCdclsf = param.getString("selCdclsf");			//코드구분
		String subCode = param.getString("subCode");			//코드(명)
		
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		
		dbparam = new HashMap<Object, Object>();
		try {
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
		
			//변수 값 설정
			dbparam.put("CDCLSF", selCdclsf);
			dbparam.put("CODE", subCode);
			dbparam.put("CNAME", cname);
			dbparam.put("YNAME", yname);
			dbparam.put("REMK", remk);
			dbparam.put("RESV1", resv1);
			dbparam.put("RESV2", resv2);
			dbparam.put("RESV3", resv3);
			dbparam.put("USEYN", useyn); //130006358
			dbparam.put("userId", userId);
		
			//수정
			generalDAO.getSqlMapClient().update("management.code.updateCodeData", dbparam);
		
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			
			//코드 1레벨 리스트 조회
			codeStep1List = generalDAO.queryForList("management.code.selectCodeStep1List");
			
			//코드 2레벨 리스트 조회
			dbparam.put("CODE", selCdclsf);
			codeStep2List = generalDAO.queryForList("management.code.selectCodeStep2List", dbparam);
			
			//코드 상세내용 조회
			dbparam.put("SUBCODE", subCode);
			Map codeView =  (Map)generalDAO.queryForObject("management.code.getCodeView", dbparam);
			
			mav.addObject("now_menu", ICodeConstant.MENU_CODE_MANAGEMENT_CODE);
			mav.addObject("selCdclsf", selCdclsf);
			mav.addObject("subCode", subCode);
			mav.addObject("codeStep1List", codeStep1List);
			mav.addObject("codeStep2List", codeStep2List);
			mav.addObject("codeView", codeView);
			mav.setViewName("management/code/codeList");
		} catch(Exception e) {
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}finally{
			generalDAO.getSqlMapClient().endTransaction();
		}
		return mav;
	}
	
	
	/**
	 * 코드정보 삭제 이벤트
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView deleteCodeData(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		// mav
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		HttpSession session = request.getSession();
		
		List<Object> codeStep1List = new ArrayList<Object>();
		List<Object> codeStep2List = new ArrayList<Object>();
		
		String cdclsf 	= param.getString("cdclsf");					//코드구분		
		String code 	= param.getString("code");					//코드
		
		String selCdclsf = param.getString("selCdclsf");			//코드구분
		String subCode = param.getString("subCode");			//코드(명)
		
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		
		dbparam = new HashMap<Object, Object>();
		try {
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
		
			//변수 값 설정
			dbparam.put("CDCLSF", cdclsf);
			dbparam.put("CODE", code);
			dbparam.put("userId", userId);
		
			//삭제
			generalDAO.getSqlMapClient().update("management.code.deleteTopCodeData", dbparam);
		
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			
			//코드 1레벨 리스트 조회
			codeStep1List = generalDAO.queryForList("management.code.selectCodeStep1List");
			
			//코드 2레벨 리스트 조회
			dbparam.put("CODE", selCdclsf);
			codeStep2List = generalDAO.queryForList("management.code.selectCodeStep2List", dbparam);
			
			mav.addObject("now_menu", ICodeConstant.MENU_CODE_MANAGEMENT_CODE);
			mav.addObject("selCdclsf", selCdclsf);
			mav.addObject("subCode", "");
			mav.addObject("codeStep1List", codeStep1List);
			mav.addObject("codeStep2List", codeStep2List);
			mav.setViewName("management/code/codeList");
		} catch(Exception e) {
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}finally{
			generalDAO.getSqlMapClient().endTransaction();
		}
		return mav;
	}
	
	/**
	 * 코드구분(상위코드) 등록
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView insertTopCode(HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		HttpSession session = request.getSession();
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			String insCname 	= param.getString("insCname");					//코드명		
			String insCode 	= param.getString("insCode");					//코드
			String cdclsf 		= "001";													//코드구분(상위코드)
			String userId 		= String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
			
	    	dbparam.put("CNAME", insCname);
    		dbparam.put("CODE", insCode);	
    		dbparam.put("CDCLSF", cdclsf);
    		dbparam.put("userId", userId);

    		//상위코드 등록
    		generalDAO.getSqlMapClient().insert("management.code.insertTopCodeData", dbparam);

		    generalDAO.getSqlMapClient().getCurrentConnection().commit();
		    mav.setViewName("common/message");
			mav.addObject("message", "코드등록이 되었습니다.");
			mav.addObject("returnURL", "codeSubList.do");
		} catch(Exception e) {
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
		} finally {
			generalDAO.getSqlMapClient().endTransaction();
		}
		
		return mav;
	}
	
	
	/**
	 * 코드구분(상위코드) 삭제
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView deleteTopCode(HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		HttpSession session = request.getSession();
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			String code 	= param.getString("cdclsf");					//코드		
			String cdclsf 		= "001";													//코드구분(상위코드)
			String userId 		= String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
			
    		dbparam.put("CODE", code);	
    		dbparam.put("CDCLSF", cdclsf);
    		dbparam.put("userId", userId);

    		//상위코드 등록
    		generalDAO.getSqlMapClient().insert("management.code.deleteTopCodeData", dbparam);

		    generalDAO.getSqlMapClient().getCurrentConnection().commit();
		    mav.setViewName("common/message");
			mav.addObject("message", "코드가 삭제 되었습니다.");
			mav.addObject("returnURL", "codeSubList.do");
		} catch(Exception e) {
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
		} finally {
			generalDAO.getSqlMapClient().endTransaction();
		}
		
		return mav;
	}
	
	/**
	 * 코드 중복 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView chkCodeValidation(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		String result = "";
		String opCode 	= param.getString("opCode");		
    	dbparam.put("CODE", opCode);

    	//코드 중복 조회
    	Map chkCode =  (Map)generalDAO.queryForObject("management.code.chkCodeValidate", dbparam);
		
		result = chkCode.get("CHKYN").toString();
	
		response.getWriter().print(result);
		
		return null;
	}
	
	
	/**
	 * 코드명 중복 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView chkCodeNameValidation(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		String result = "";
		String opCodeName 	= param.getString("opCodeName");		
    	dbparam.put("CNAME", opCodeName);

    	//코드 중복 조회
    	Map chkCode =  (Map)generalDAO.queryForObject("management.code.chkCodeNameValidate", dbparam);
		
		result = chkCode.get("CHKYN").toString();
	
		response.getWriter().print(result);
		
		return null;
	}
	

}
