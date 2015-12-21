/*------------------------------------------------------------------------------
 * NAME : DeliveryNumSortController 
 * DESC : 배달 번호 정렬
 * Author : pspkj
 *----------------------------------------------------------------------------*/
package com.mkreader.web.etc;

import java.util.HashMap;
import java.util.List;

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

public class DeliveryNumSortController extends MultiActionController implements
ISiteConstant, ICodeConstant {

	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}
	
	/**
	 * 배달 번호 정렬 페이지 오픈
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView reteriveDeliveryNum(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		

		try{
			HashMap dbparam = new HashMap();
			dbparam.put("boSeq", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			List gnoList = generalDAO.queryForList("etc.deadLine.reterieveGnoList", dbparam);
			
			mav.addObject("gnoList" , gnoList);
			mav.addObject("now_menu", MENU_CODE_MANAGEMENT_J_DELIVERY_CODE);
			mav.setViewName("etc/deliveryNum");
			
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
	 * 배달 번호 정렬 
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView deliveryNumSort(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		

		try{
			HashMap dbparam = new HashMap();
			
			dbparam.put("boSeq", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			
			String gno[][] = new String[param.getInt("gnoSize",0)][2];
			
			for(int i=0; i<gno.length ; i++){
				gno[i][0] = param.getString("gno"+i);
				dbparam.put("gno", gno[i][0]);
				
				if(dbparam.get("gno") != null && !"".equals(dbparam.get("gno")) ){
					gno[i][1] = (String)generalDAO.queryForObject("etc.deadLine.deliverNumSort", dbparam);
					if(gno[i][1].indexOf("FAIL" ) > -1 ){
						throw new Exception(gno[i][1]);
					}else{
						String tmp[] = gno[i][1].split("COUNT=");
						gno[i][1] = tmp[1];
						
					}
				}
			}

			List gnoList = generalDAO.queryForList("etc.deadLine.reterieveGnoList", dbparam);
			
			mav.addObject("gno" , gno);
			mav.addObject("gnoList" , gnoList);
			mav.addObject("now_menu", MENU_CODE_MANAGEMENT_J_DELIVERY_CODE);
			mav.setViewName("etc/deliveryNum");
			
			return mav;
		}catch(Exception e){
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	
	
}
