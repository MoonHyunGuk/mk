package com.mkreader.web.mobile;

import java.util.Calendar;
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

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.SecurityUtil;
import com.mkreader.util.StringUtil;

public class JidaeController extends MultiActionController implements
ISiteConstant, ICodeConstant {
	
private GeneralDAO generalDAO;
	
	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}
	
	/**
	 * 지대납부금통지서 
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView jidaeViewForPersonal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();  
		Param param = new HttpServletParam(request);
		HashMap<String, String> dbparam = new HashMap<String, String>();
		
		String boseq = param.getString("boseq");
		String yymm = param.getString("yymm");
		String url = "";
		
		dbparam.put("boseq", boseq);
		dbparam.put("yymm", yymm);
		
		//지대정보조회
		Map jidaeData  = (Map)generalDAO.queryForObject("management.jidae.selectJidaeNoticeForSms", dbparam);
		
		//직영지국인지 확인
		if(("5").equals(boseq.substring(0, 1))) {
			url = "mobile/jidae/jidaeViewForPersonalByDirect";
		} else {
			url = "mobile/jidae/jidaeViewForPersonal";
		}
		
		mav.addObject("boseq", boseq);
		mav.addObject("yymm", yymm);
		mav.addObject("jidaeData", jidaeData);
		mav.setViewName(url);
		return mav; 
	}
	
	/**
	 * 지대납부금통지서 로그인화면(지국)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView jidaeLogin(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();  
		Param param = new HttpServletParam(request);
		
		String key = param.getString("key");
		System.out.println("key = "+key);
		if(StringUtil.isNull(key)){
			return null;
		}
		String str = SecurityUtil.decode(key);
		JsonParser jsonParser = new JsonParser();
		JsonObject json = (JsonObject)jsonParser.parse(str);
		
		String boseq = json.get("boseq").getAsString();
		String yymm = json.get("yymm").getAsString();
		//String boseq = param.getString("boseq");
		//String yymm = param.getString("yymm");
		
		mav.addObject("boseq", boseq);
		mav.addObject("yymm", yymm);
		mav.setViewName("mobile/jidae/jikukLogin");
		return mav;
	}
	
	/**
	 * 지대납부금통지서 로그인
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView chkJidaeLogin (HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();  
		Param param = new HttpServletParam(request);
		JSONObject jsonObject = new JSONObject();
		HashMap<String, String> dbparam = new HashMap<String, String>();
		
		String boseq = param.getString("boseq");
		String logPw = param.getString("logPw");
		
		try {
			dbparam.put("BOSEQ", boseq);
			dbparam.put("PASSWD", logPw);
			String chkYn = (String)generalDAO.queryForObject("admin.chkJiaeLogin", dbparam);
			System.out.println("chkYn = "+chkYn);
			
			jsonObject.put("chkYn", chkYn);
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace(); 
		}	
		return null;
	}
	
	
	/**
	 * 지대납부금통지서 로그인화면(관리자)
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView master(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		mav.addObject("logId" , "");
		mav.addObject("logPw" , "");
		mav.setViewName("mobile/jidae/masterLogin");
		return mav;
	}
	
	/**
	 * 관리자 아이디/패스워드 체크
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView masterLoginChk (HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		JSONObject jsonObject = new JSONObject();
		HashMap<String, String> dbparam = new HashMap<String, String>();
		Map userMap = null;
				
		String logId = param.getString("logId");
		String logPw = param.getString("logPw");
		
		String useYn = "N";
		
		try {
			dbparam.put("USERID", logId);
			dbparam.put("PASSWD", logPw);
			userMap = (Map)generalDAO.queryForObject("admin.getAdminLogin", dbparam);
			
			if(userMap != null) {
				useYn = "Y";
			}
			
			jsonObject.put("useYn", useYn);
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace(); 
		}	
		return null;
	}
	
	
	/**
	 * 관리자 로그인
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView masterLogin (HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		HashMap<String, String> dbparam = new HashMap<String, String>();
		HttpSession session = request.getSession();
		
		List<Object> agencyAllList = null;
		
		//마지막 지대년월가져오기
		String lastYYMM = (String)generalDAO.queryForObject("management.jidae.getJidaeLastYymm");
		String lastYear = "";
		String lastMonth = "";
		
		if(lastYYMM != null) {
			lastYear = lastYYMM.substring(0, 4);
			lastMonth = lastYYMM.substring(4, 6);
		}
				
		String logId = param.getString("logId");
		String logPw = param.getString("logPw");
		String localCode = "";
		
		try {
			dbparam.put("userId", logId);
			dbparam.put("PASSWD", logPw);
			
			//영업담당여부체크
			String chkSellerYn = (String) generalDAO.queryForObject("management.jidae.chkSellerYn", dbparam);
			
			//관리자, 관리팀여부체크
			String chkAdminMngYn = (String) generalDAO.queryForObject("management.jidae.chkAdminMngYn", dbparam);
			
			//영업담당일때만 지국조회
			if("Y".equals(chkSellerYn)) { 
				//담당코드 가져오기
				localCode = (String) generalDAO.queryForObject("management.jidae.selectLocalCodeBySeller", dbparam);
				
				//dbparam.put("localCode", localCode);
				//지국목록
				//agencyAllList = generalDAO.queryForList("reader.common.agencyListByLocalCode", dbparam);// 지국 목록 
			} else if("Y".equals(chkAdminMngYn)){
				//지국목록
				//agencyAllList = generalDAO.queryForList("reader.common.agencyListByAlive" );
			}
			
			session.setAttribute("userPw", logPw);
			//mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("intYear" , lastYear);
			mav.addObject("opYear" , lastYear);
			mav.addObject("opMonth" , lastMonth);
			mav.addObject("userId" , logId);
			mav.addObject("logPw" , logPw);
			mav.addObject("chkAdminMngYn" , chkAdminMngYn);
			mav.addObject("chkSellerYn" , chkSellerYn);
			mav.addObject("localCode" , localCode);
			mav.setViewName("mobile/jidae/masterView");
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace(); 
		}	
		return mav;
	}
	
	
	/**
	 * 관리자 로그인
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView masterJidaeView (HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		HashMap<String, String> dbparam = new HashMap<String, String>();
		HttpSession session = request.getSession();
		
		List<Object> agencyAllList = null;
		
		//마지막 지대년월가져오기
		String lastYYMM = (String)generalDAO.queryForObject("management.jidae.getJidaeLastYymm");
		String lastYear = "";
		String lastMonth = "";
		
		if(lastYYMM != null) {
			lastYear = lastYYMM.substring(0, 4);
			lastMonth = lastYYMM.substring(4, 6);
		}
			
		String userId = param.getString("userId");
		String boseq = param.getString("boseq");				//지국아이디
		String boSeqNm = param.getString("boSeqNm");				//지국명
		boSeqNm = new String(boSeqNm.getBytes("8859_1"), "utf-8");
		String opYear = param.getString("opYear", lastYear);			//년도
		String opMonth = param.getString("opMonth", lastMonth);	//해당월
		String url = "";
		String userPw = (String)session.getAttribute("userPw");
		String localCode = "";
		
		
			if(boseq.substring(0, 1).equals("5") && !boseq.substring(0, 2).equals("52")) {
				url = "mobile/jidae/masterViewForDirect";
			} else if (boseq.substring(0, 1).equals("5") && boseq.substring(0, 2).equals("52")){
				url ="mobile/jidae/masterView";
			} else {
				url ="mobile/jidae/masterView";
			}
			
			try {
				dbparam.put("userId", userId);
				
				//영업담당여부체크
				String chkSellerYn = (String) generalDAO.queryForObject("management.jidae.chkSellerYn", dbparam);
				
				//관리자, 관리팀여부체크
				String chkAdminMngYn = (String) generalDAO.queryForObject("management.jidae.chkAdminMngYn", dbparam);
				
				//영업담당일때만 지국조회
				if("Y".equals(chkSellerYn)) { 
					//담당코드 가져오기
					localCode = (String) generalDAO.queryForObject("management.jidae.selectLocalCodeBySeller", dbparam);
					
					dbparam.put("localCode", localCode);
					//지국목록
					agencyAllList = generalDAO.queryForList("reader.common.agencyListByLocalCode", dbparam);// 지국 목록 
				} else if("Y".equals(chkAdminMngYn)){
					//지국목록
					agencyAllList = generalDAO.queryForList("reader.common.agencyListByAlive" );
				}
				
				dbparam.put("boseq", boseq);
				dbparam.put("yymm", opYear+opMonth);
				
				//지대정보조회
				Map jidaeData  = (Map)generalDAO.queryForObject("management.jidae.selectJidaeNoticeForSms", dbparam);
				
				mav.addObject("agencyAllList" , agencyAllList);
				mav.addObject("userId" , userId);
				mav.addObject("boseq" , boseq);
				mav.addObject("boSeqNm" , boSeqNm);
				mav.addObject("intYear" , lastYear);
				mav.addObject("opYear" , opYear);
				mav.addObject("opMonth" , opMonth);
				mav.addObject("jidaeData" , jidaeData);
				mav.addObject("chkAdminMngYn" , chkAdminMngYn);
				mav.addObject("chkSellerYn" , chkSellerYn);
				mav.addObject("localCode" , localCode);
				
				if(!"".equals(userPw) && userPw != null) {
					mav.setViewName(url);
				} else {
					session.invalidate();
					mav.setViewName("mobile/jidae/masterLogin");
				}
			} catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace(); 
			}	
		return mav;
	}
	
	
	/** 
	 * 지국정보조회
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ajaxSelectJikukList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		
		try{
			HashMap dbparam = new HashMap();
			
			String localCode = param.getString("localCode");
			String chkAdminMngYn = param.getString("chkAdminMngYn");
			String chkSellerYn = param.getString("chkSellerYn");
			String boSeqNm = param.getString("boSeqNm");
			
			String boSeq = null;
			
			System.out.println("localCode ====================>"+localCode);
			System.out.println("chkSellerYn ====================>"+chkSellerYn);
			System.out.println("chkAdminMngYn ====================>"+chkAdminMngYn);
			System.out.println("boSeqNm ====================>"+boSeqNm.trim());
			
			//영업담당일때만 지국조회
			if("Y".equals(chkSellerYn)) { 
				//담당코드 가져오기
				dbparam.put("localCode", localCode);
				dbparam.put("boSeqNm", boSeqNm.trim());
				//지국목록
				boSeq = (String)generalDAO.queryForObject("reader.common.getAgencyCodeByLocalCode", dbparam);// 지국 목록 
			} else if("Y".equals(chkAdminMngYn)){
				//지국목록
				dbparam.put("boSeqNm", boSeqNm.trim());
				boSeq = (String)generalDAO.queryForObject("reader.common.getAgencyCodeByAlive", dbparam);
			}
			
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("boSeq", boSeq);
		
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
		} catch(Exception e){
			e.printStackTrace();
		}	
		return null;
	}
	

}
