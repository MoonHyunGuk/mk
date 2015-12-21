/*------------------------------------------------------------------------------
 * NAME : AgencyManageController 
 * DESC : 관리 -> 지국관리 
 * Author : 유진영
 *----------------------------------------------------------------------------*/
package com.mkreader.web.management;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.util.Param;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;

public class AgencyManageController extends MultiActionController implements
	ISiteConstant, ICodeConstant {

	public static Logger logger = Logger.getRootLogger();
	
	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {

			this.generalDAO = generalDAO;
	}
	
	/**
	 * 지국정보 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView agencyInfo(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();

		HttpSession session = request.getSession(true);
			
		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		String numId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_NUMID));
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		
		dbparam.put("userId", userId); 
		
		logger.debug("===== management.agencyManage.getAgencyInfo");
		Object agencyInfo = generalDAO.queryForObject("management.agencyManage.getAgencyInfo" , numId);
		
		logger.debug("===== management.agencyManage.getCode");
		List telExcNo = generalDAO.queryForList("management.agencyManage.getCode" , "015");
		
		logger.debug("===== management.agencyManage.getCode");
		List mblExcNo = generalDAO.queryForList("management.agencyManage.getCode" , "016");
		
		logger.debug("===== management.adminManage.getBankCode");
		List bankCb = generalDAO.queryForList("management.adminManage.getBankCode" , numId );  // 지역 조회
		
		logger.debug("===== output.billOutput.getCustNotice");
		List jikyungYn = generalDAO.queryForList("output.billOutput.getJikyung" , dbparam);  // 직영여부 조회
		
		if(jikyungYn.size()!=0){
			mav.addObject("jikyungYn", "1");
		}
		
		mav.addObject("telExcNo", telExcNo);
		mav.addObject("mblExcNo", mblExcNo);
		mav.addObject("agencyInfo", agencyInfo);
		mav.addObject("bankCb", bankCb);
		
		mav.addObject("now_menu", MENU_CODE_MANAGEMENT_JIKUK_INFO);
		mav.setViewName("management/agency/agencyInfo");
		return mav;

	}
	


	/**
	 * 지국정보 수정
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView agencyModify(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);		
		ModelAndView mav = new ModelAndView();
		
		String numId = param.getString("numId");
		String serial = param.getString("serial");
		
		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		dbparam.put("numId", numId); 
		dbparam.put("serial", serial); 
		dbparam.put("passwd", param.getString("passwd")); 
		dbparam.put("name2", param.getString("name2"));
		dbparam.put("nameSub", param.getString("nameSub")); 
		dbparam.put("jikuk_Email", param.getString("jikuk_Email")); 
		dbparam.put("zip", param.getString("zip")); 
		dbparam.put("addr1", param.getString("addr1")); 
		dbparam.put("iden_No", param.getString("iden_No")); 
		dbparam.put("giro_No", param.getString("giro_No")); 
		dbparam.put("approval_No", param.getString("approval_No")); 
		dbparam.put("bank", param.getString("bank"));
		dbparam.put("bankNum", param.getString("bankNum"));
		
		HashMap<String, Object> telNo = setTelNo(param);
		dbparam.put("jikuk_Tel", telNo.get("jikuk_Tel")); 
		dbparam.put("jikuk_Handy", telNo.get("jikuk_Handy")); 
		dbparam.put("jikuk_Fax", telNo.get("jikuk_Fax")); 
	
		logger.debug("파람정보_NumID : "+ numId);
		logger.debug("파람정보_Serial : "+ serial);
		
		try{
			logger.debug("===== management.agencyManage.updateAgencyInfo");
			if(generalDAO.update("management.agencyManage.updateAgencyInfo", dbparam) > 0){
				mav.addObject("message", "정상적으로 수정 되었습니다.");
			}
		}catch (Exception e){
			    mav.addObject("message", "수정이 실패했습니다.");
			    e.printStackTrace();
		}

		mav.setViewName("common/message");
		mav.addObject("returnURL", "/management/agencyManage/agencyInfo.do");

		return mav;
			

	}
	
	
	/**
	 * 전화번호 병합
	 */
	public HashMap setTelNo(Param param){
		String jikuk_Tel = "";
		String jikuk_Tel1 = (String) param.getString("jikuk_Tel1");
		String jikuk_Tel2 = (String) param.getString("jikuk_Tel2");
		String jikuk_Tel3 = (String) param.getString("jikuk_Tel3");
		if((!jikuk_Tel1.equals("") || jikuk_Tel1 != null)){

			jikuk_Tel = jikuk_Tel + jikuk_Tel1;
			if((!jikuk_Tel2.equals("") || jikuk_Tel2 != null)){
				jikuk_Tel = jikuk_Tel + "-" + jikuk_Tel2;
			}
			if((!jikuk_Tel3.equals("") || jikuk_Tel3 != null)){
				jikuk_Tel = jikuk_Tel + "-" + jikuk_Tel3;
			}
		}
		
		String jikuk_Handy = "";
		String jikuk_Handy1 = (String) param.getString("jikuk_Handy1");
		String jikuk_Handy2 = (String) param.getString("jikuk_Handy2");
		String jikuk_Handy3 = (String) param.getString("jikuk_Handy3");
		if((!jikuk_Handy1.equals("") || jikuk_Handy1 != null)){

			jikuk_Handy = jikuk_Handy + jikuk_Handy1;
			if((!jikuk_Handy2.equals("") || jikuk_Handy2 != null)){
				jikuk_Handy = jikuk_Handy + "-" + jikuk_Handy2;
			}
			if((!jikuk_Handy3.equals("") || jikuk_Handy3 != null)){
				jikuk_Handy = jikuk_Handy + "-" + jikuk_Handy3;
			}
		}
		
		String jikuk_Fax = "";
		String jikuk_Fax1 = (String) param.getString("jikuk_Fax1");
		String jikuk_Fax2 = (String) param.getString("jikuk_Fax2");
		String jikuk_Fax3 = (String) param.getString("jikuk_Fax3");
		if((!jikuk_Fax1.equals("") || jikuk_Fax1 != null)){

			jikuk_Fax = jikuk_Fax + jikuk_Fax1;
			if((!jikuk_Fax2.equals("") || jikuk_Fax2 != null)){
				jikuk_Fax = jikuk_Fax + "-" + jikuk_Fax2;
			}
			if((!jikuk_Fax3.equals("") || jikuk_Fax3 != null)){
				jikuk_Fax = jikuk_Fax + "-" + jikuk_Fax3;
			}
		}
		
		logger.debug("전화번호 병합 Tel : " + jikuk_Tel);
		logger.debug("전화번호 병합 Handy : " + jikuk_Handy);
		logger.debug("전화번호 병합 Fax : " + jikuk_Fax);

		HashMap<String, Object> telNo = new HashMap<String, Object>();

		telNo.put("jikuk_Tel", jikuk_Tel);
		telNo.put("jikuk_Handy", jikuk_Handy);
		telNo.put("jikuk_Fax", jikuk_Fax);
		
		return telNo;
	}
	
	/**
	 * 발송연락처 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView agencyDelivery(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();

		HttpSession session = request.getSession(true);
			
		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		String numId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_NUMID ));
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		String deliveryNm1 = "";
		String deliveryNum1 = "";
		String deliveryNm2 = "";
		String deliveryNum2 = "";
		String deliveryNm3 = "";
		String deliveryNum3 = "";
		
		dbparam.put("boseq", userId); 
		
		List deliveryNumList = generalDAO.queryForList("management.adminManage.selectDeliveryNumbers",dbparam);
		for(int i=0 ; i < deliveryNumList.size() ; i++){
			Map list = (Map)deliveryNumList.get(i);
			deliveryNum1 = (String)list.get("DELIVERY_NUM1");
			deliveryNm1 = (String)list.get("DELIVERY_NM1");
			deliveryNum2 = (String)list.get("DELIVERY_NUM2");
			deliveryNm2 = (String)list.get("DELIVERY_NM2");
			deliveryNum3 = (String)list.get("DELIVERY_NUM3");
			deliveryNm3 = (String)list.get("DELIVERY_NM3");
		}
		
		mav.addObject("deliveryNm1", deliveryNm1);
		mav.addObject("deliveryNum1", deliveryNum1);
		mav.addObject("deliveryNm2", deliveryNm2);
		mav.addObject("deliveryNum2", deliveryNum2);
		mav.addObject("deliveryNm3", deliveryNm3);
		mav.addObject("deliveryNum3", deliveryNum3);
		mav.addObject("now_menu", MENU_CODE_MANAGEMENT_JIKUK_INFO);
		mav.setViewName("management/agency/agencyDelivery");
		return mav;
	}
	
	/**
	 * 발송연락처 저장
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView agencyDeliverySave(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession(true);
		Param param = new HttpServletParam(request);		
		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID));
		String deliveryNm1 = (String) param.getString("deliveryNm1");
		String deliveryNum1 = (String)param.getString("deliveryNum1");
		String deliveryNm2 = (String)param.getString("deliveryNm2");
		String deliveryNum2 = (String)param.getString("deliveryNum2");
		String deliveryNm3 = (String)param.getString("deliveryNm3");
		String deliveryNum3 = (String)param.getString("deliveryNum3");
		
//		System.out.println("userId = "+userId);
//		System.out.println("deliveryNm1 = "+deliveryNm1);
//		System.out.println("deliveryNum1 = "+deliveryNum1);
//		System.out.println("deliveryNm2 = "+deliveryNm2);
//		System.out.println("deliveryNum2 = "+deliveryNum2);
//		System.out.println("deliveryNm3 = "+deliveryNm3);
//		System.out.println("deliveryNum3 = "+deliveryNum3);
		
		dbparam.put("boseq", userId); 
		dbparam.put("deliveryNm1", deliveryNm1);
		dbparam.put("deliveryNum1", deliveryNum1);
		dbparam.put("deliveryNm2", deliveryNm2);
		dbparam.put("deliveryNum2", deliveryNum2);
		dbparam.put("deliveryNm3", deliveryNm3);
		dbparam.put("deliveryNum3", deliveryNum3);
		
		//전화번호 업데이트
		generalDAO.update("management.adminManage.updateDeliveryNumbers", dbparam);
		
		mav.addObject("bankCb", "");
		
		mav.setViewName("common/message");
		mav.addObject("message", "저장되었습니다.");
		mav.addObject("returnURL", "/management/agencyManage/agencyDelivery.do");
		return mav;
	}
	
}
