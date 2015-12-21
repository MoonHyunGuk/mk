/*------------------------------------------------------------------------------
 * NAME : DeliveryController 
 * DESC : 배달명단 관리
 * Author : pspkj
 *----------------------------------------------------------------------------*/
package com.mkreader.web.reader;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.util.Param;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;

public class DeliveryController extends MultiActionController implements
ISiteConstant, ICodeConstant {

	private GeneralDAO generalDAO;
	
	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}

	/**
	 * 배달 명단 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView retrieveDeliveryList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		try{
			HashMap dbparam = new HashMap();
			
			if( session.getAttribute(SESSION_NAME_AGENCY_SERIAL) == null ){ //관리자
				String adminId = (String)session.getAttribute(SESSION_NAME_ADMIN_USERID);
				dbparam.put("adminId", adminId);
				if("kbk".equals(adminId) || "dwhan".equals(adminId) || "changwhui".equals(adminId) || "taejin".equals(adminId) || "hjin".equals(adminId)  
				|| "leesh2012".equals(adminId) || "dlehsduq".equals(adminId) || "asttaek".equals(adminId)  ){
					List agencyList = generalDAO.queryForList("reader.common.adminAgencyList" , dbparam); //지국 리스트
					mav.addObject("agency_serial", param.getString("agency"));
					mav.addObject("agencyList", agencyList);
					if("".equals(param.getString("agency")) ){
						if(agencyList.size() > 0){
							Map list = (Map)agencyList.get(0);
							dbparam.put("agency_serial", list.get("SERIAL"));	
						}
					}else{
						dbparam.put("agency_serial", param.getString("agency"));	
					}
				}else{
					List agencyList = generalDAO.queryForList("reader.common.agencyList" , dbparam); //지국 리스트
					mav.addObject("agency_serial", param.getString("agency"));
					mav.addObject("agencyList", agencyList);
					if("".equals(param.getString("agency")) ){
						if(agencyList.size() > 0){
							Map list = (Map)agencyList.get(0);
							dbparam.put("agency_serial", list.get("SERIAL"));	
						}
					}else{
						dbparam.put("agency_serial", param.getString("agency"));	
					}
				}
			}else{
				dbparam.put("agency_serial", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			}
			String newsCd[] = new String[param.getInt("neswCdSize",0)];
			for(int i=0 ; i < newsCd.length ; i++ ){
				if(!"".equals(param.getString("newsCd"+i)) && param.getString("newsCd"+i) != null){
					newsCd[i] = param.getString("newsCd"+i);
				}
			}

			dbparam.put("newsCd", newsCd);
			
			if(newsCd.length > 0){
				List deliveryList = generalDAO.queryForList("reader.delivery.retrieveDeliveryList", dbparam);
				mav.addObject("deliveryList" , deliveryList);
			}
			List newSList = generalDAO.queryForList("reader.common.retrieveNewsList", dbparam);
			
			mav.addObject("newSList" , newSList);
			mav.addObject("newsCd" , newsCd);
			mav.addObject("now_menu", MENU_CODE_J_DELIVERY);
			mav.addObject("param" , param);
			
			mav.setViewName("reader/deliveryList");	
			return mav;
			
		}catch(Exception e){
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	
	/**
	 * 배달 명단 프린트
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView ozDeliveryList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		try{
			String agency_serial = "";
			if( session.getAttribute(SESSION_NAME_AGENCY_SERIAL) == null ){ //관리자
				agency_serial = param.getString("agency");	

			}else{
				agency_serial = (String)session.getAttribute(SESSION_NAME_AGENCY_SERIAL);
			}
			
			logger.debug("====>>>>"+agency_serial);
			
			String print[] = new String[param.getInt("printSize",0)];
			
			// 신문종류
			String newsCdParam[] = new String[param.getInt("neswCdSize",0)];
			String newsCd = "";
			
			for(int i=0 ; i < newsCdParam.length ; i++ ){
				if(!"".equals(param.getString("newsCd"+i)) && param.getString("newsCd"+i) != null){
					newsCdParam[i] = param.getString("newsCd"+i);
					newsCd = newsCd + "'" + param.getString("newsCd"+i) + "',";	
					logger.debug("로그 확인 newsCd["+i+"] : " + newsCdParam[i]);		
				}
			}
			newsCd = newsCd + "''";
			logger.debug(newsCd);
			
			// 구역
			String start[] = new String[param.getInt("printSize",0)];
			String end[] = new String[param.getInt("printSize",0)];
			String guyukSql=" AND (";

			for(int i=0 ; i < print.length ; i++ ){

				if(!"".equals(param.getString("print"+i)) && param.getString("print"+i) != null){
					if(!"".equals(param.getString("print"+i)) && param.getString("print"+i) != null){
						print[i] = param.getString("print"+i);
						start[i] = param.getString("start"+i);
						end[i] = param.getString("end"+i);
						logger.debug("로그 확인 guyuk["+i+"] : " + print[i]);		
						logger.debug("로그 확인 start["+i+"] : " + start[i]);		
						logger.debug("로그 확인 end["+i+"] : " + end[i]);		
						guyukSql = guyukSql + "(GNO = '"+ print[i] +"' AND BNO BETWEEN LPAD('"+ start[i] +"', 3, '0')  AND LPAD('"+ end[i] +"', 3, '0') ) OR ";
					}
				}
				
			}
			guyukSql = guyukSql + " (GNO = '')) ";
			logger.debug("로그 확인sql : " + guyukSql);	
			
			mav.addObject("guyukSql", guyukSql); 
			mav.addObject("userId", agency_serial); 
			mav.addObject("newsCd",newsCd);
			
			if(!"".equals(param.getString("detailYn"))){			

				if(!"".equals(param.getString("remkYn"))){			
					mav.addObject("type","deliveryList3");  		//비고 출력
				}else{				
					mav.addObject("type","deliveryList4");  	//비고 출력 X
				}
				
			}else{
				if(!"".equals(param.getString("reaNmYn"))){			
					mav.addObject("type","deliveryList");  		//독자명 출력
				}else{				
					mav.addObject("type","deliveryList2");  	//독자명 출력 X
				}
				
			}
			
			mav.setViewName("reader/oz/ozDeliveryList");
			return mav;
			
		}catch(Exception e){
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	
	
}