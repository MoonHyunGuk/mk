package com.mkreader.web;

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

import org.apache.commons.lang.StringUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;

public class AdminController extends MultiActionController implements
		ISiteConstant, ICodeConstant {

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
	public ModelAndView main(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		int pagesize = 5;

		// param
		Param param = new HttpServletParam(request);
		int pageNo = param.getInt("pageNo", 1);
		
		//지국 번호
		HttpSession session = request.getSession();
		String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		// db query parameter
		HashMap<String,Object> dbparam = new HashMap<String,Object>();
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
		List noticeList = generalDAO.queryForList("community.bbs.getList", dbparam);
		logger.debug("===== community.bbs.getList");

		//신규독자 결과리스트
		dbparam.put("BOSEQ", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
		List applyReaderList = generalDAO.queryForList("admin.applyReaderList", dbparam);

		//자동이체 결과리스트
		dbparam.put("STATUS", "EA00");
		List resultBillList = generalDAO.queryForList("admin.resultBillList", dbparam);
		
		List stopReserveList = generalDAO.queryForList("reader.billingAdmin.selectStopReserveListForMain", dbparam);

		//자동이체정보(left menu)
		dbparam = new HashMap();
		dbparam.put("JIKUK",jikuk);

		//Map resultBill = (Map)generalDAO.queryForObject("admin.getResultBill", dbparam);
		//Map resultBillStu = (Map)generalDAO.queryForObject("admin.getResultBillStu", dbparam);

		//지로입금정보
		//Map giroEdiInfo = (Map)generalDAO.queryForObject("admin.getGiroEdi", dbparam);

		//메인알림
		//지국이 직영지국 이거나 권한레벨이 관리자일 경우 직영 메인알림 노출
/*		Map mainInfo = null;
		if( "101".equals(jikukType) || "102".equals(jikukType) || "9".equals(userGb) ){
			//1전체	2직영
			typeCd = new String[]{"3"};
			dbparam.put("TYPECD",typeCd);
			mainInfo = (Map)generalDAO.queryForObject("admin.getMainInfo", dbparam);
			if( mainInfo != null ){
				if( mainInfo.get("CONT") != null ){
					String cont = (String)mainInfo.get("CONT");
					cont = cont.replaceAll("\r\n", "<br>");
					mainInfo.put("CONT", cont);
				}
			}
		}
*/
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("admin/main");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_MAIN);
		
		mav.addObject("noticeList", noticeList);
		mav.addObject("applyReaderList", applyReaderList);
		mav.addObject("resultBillList", resultBillList);
		mav.addObject("stopReserveList",stopReserveList);
		//mav.addObject("resultBill", resultBill);
		//mav.addObject("resultBillStu", resultBillStu);
		//mav.addObject("giroEdiInfo", giroEdiInfo);
		//mav.addObject("mainInfo", mainInfo);
		mav.addObject("JIKUK",jikuk);
		mav.addObject("jikukType",jikukType);
		
		return mav;
	}
	
	/**
	 * 지로입금건수, 금액 조회(AJAX)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ajaxGiroEdiInfo(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		
		try{
			HashMap<String,Object> dbparam = new HashMap<String,Object>();
			dbparam.put("JIKUK", param.getString("JIKUK"));
	
			Map giroEdiInfo = (Map)generalDAO.queryForObject("admin.getGiroEdi", dbparam);
			
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("giroEdiInfo", JSONArray.fromObject(giroEdiInfo));
			
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 자동이체 일반건수, 금액 조회(AJAX)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ajaxResultBill(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		
		try{
			HashMap<String,Object> dbparam = new HashMap<String,Object>();
			dbparam.put("JIKUK", param.getString("JIKUK"));
	
			Map resultBill = (Map)generalDAO.queryForObject("admin.getResultBill", dbparam);
			
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("resultBill", JSONArray.fromObject(resultBill));
			
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 자동이체 학생건수, 금액 조회(AJAX)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ajaxResultBillStu(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		
		try{
			HashMap<String,Object> dbparam = new HashMap<String,Object>();
	
			dbparam.put("JIKUK", param.getString("JIKUK")); 
	
			Map resultBillStu = (Map)generalDAO.queryForObject("admin.getResultBillStu", dbparam);
			
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("resultBillStu", JSONArray.fromObject(resultBillStu));
			
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return null;
	}
}
