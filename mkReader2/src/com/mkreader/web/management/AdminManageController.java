/*------------------------------------------------------------------------------
 * NAME : AgencyManageController 
 * DESC : 관리 -> 지국관리 
 * Author : 유진영
 *----------------------------------------------------------------------------*/
package com.mkreader.web.management;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.servlet.util.MultipartHttpServletParam;
import kr.reflexion.espresso.util.Param;

import com.mkreader.util.DateUtil;
import com.mkreader.util.Paging;
import com.mkreader.util.StringUtil;

import net.sf.json.JSONArray;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;
import org.springframework.web.servlet.view.RedirectView;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;

public class AdminManageController extends MultiActionController implements
	ISiteConstant, ICodeConstant {

	public static Logger logger = Logger.getRootLogger();
	
	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {

			this.generalDAO = generalDAO;
	}
	
	/**
	 * 지국 리스트 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView agencyList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		
		ModelAndView mav = new ModelAndView();

		String area1 = param.getString("area1");
		//String manager = param.getString("manager");
		String manager = URLDecoder.decode( param.getString("manager"), "utf-8");
		String type = param.getString("type");
		String txt = param.getString("txt");
		String opName2 = param.getString("opName2");
		String agencyType = param.getString("agencyType");
		String agencyArea = param.getString("agencyArea");
		String part = param.getString("part");
		
		//System.out.println("manager(list) = "+manager);
		//System.out.println("opManager(list) = "+opManager);
		
		int pageNo = param.getInt("pageNo", 1);
		int pageSize = 20;
		int totalCount = 0;
		
		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		
		dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
		dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
		
		dbparam.put("area1", area1); 
		dbparam.put("manager", manager); 
		dbparam.put("type", type); 
		dbparam.put("txt", txt); 
		dbparam.put("opName2", opName2);
		dbparam.put("agencyType", agencyType); 
		dbparam.put("agencyArea", agencyArea); 
		dbparam.put("part", part); 
		
		logger.debug("파람정보_Area1 : "+ area1);
		logger.debug("파람정보_Manager : "+ manager);
		logger.debug("파람정보_Type : "+ type);
		logger.debug("파람정보 확인_Txt : "+txt);		
		
		logger.debug("===== management.adminManage.getAgencyList");
		List agencyList = generalDAO.queryForList("management.adminManage.getAgencyList" , dbparam);  // 리스트 조회
		
		logger.debug("===== management.adminManage.getAgencyListCnt");
		totalCount = generalDAO.count("management.adminManage.getAgencyListCnt" , dbparam); // 조건별 전체 카운트 조회	
		
		logger.debug("===== management.adminManage.getCode");
		List areaCb = generalDAO.queryForList("management.adminManage.getCode" , "002");  // 부서 조회
		
		logger.debug("===== management.adminManage.getCode");
		List agencyTypeCb = generalDAO.queryForList("management.adminManage.getCode" , "017");  // 지국구분 조회
		
		logger.debug("===== management.adminManage.getCode");
		List partCb = generalDAO.queryForList("management.adminManage.getCode" , "018");  // 파트 조회
		
		logger.debug("===== management.adminManage.getCode");
		List agencyAreaCb = generalDAO.queryForList("management.adminManage.getCode" , "019");  // 지역 조회

		
		logger.debug("===== management.adminManage.getManager");
		//List mngCb = generalDAO.queryForList("management.adminManage.getManager");  // 담당자 조회
		List mngCb = generalDAO.queryForList("reader.common.selectManagerList"); // 담당자 조회
		
		


		mav.addObject("areaCb", areaCb);
		mav.addObject("mngCb", mngCb);
		mav.addObject("agencyTypeCb", agencyTypeCb);
		mav.addObject("agencyAreaCb", agencyAreaCb);
		mav.addObject("partCb", partCb);
		
		mav.addObject("agencyList", agencyList);
		mav.addObject("area1", area1);
		mav.addObject("manager", manager);
		mav.addObject("type", type);
		mav.addObject("agencyType", agencyType);
		mav.addObject("part", part);
		mav.addObject("agencyArea", agencyArea);
		mav.addObject("txt", txt);
		mav.addObject("opName2", opName2);
		
		mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 10));
		mav.addObject("now_menu", MENU_CODE_MANAGEMENT_AGENCY);
		mav.setViewName("management/agency/agencyList");
		return mav;
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
		Param param = new HttpServletParam(request);		
		ModelAndView mav = new ModelAndView();
			
		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		
		String numId = param.getString("numId");		
		String flag = param.getString("flag");
		logger.debug("파람정보_NumID : "+ numId);		
		
		// 파라미터값이 없을경우 DB 미조회, 등록화면호출
		if(numId != null || !"".equals(numId)){						
		logger.debug("===== management.agencyManage.getAgencyInfo");		
		Object agencyInfo = generalDAO.queryForObject("management.adminManage.getAgencyInfo" , numId);
		mav.addObject("agencyInfo", agencyInfo);
		}
		
		logger.debug("===== management.agencyManage.getCode");
		List telExcNo = generalDAO.queryForList("management.adminManage.getCode" , "015"); // 지역번호 조회
		
		logger.debug("===== management.agencyManage.getCode");
		List mblExcNo = generalDAO.queryForList("management.adminManage.getCode" , "016"); // 휴대폰국번조회
		
		logger.debug("===== management.adminManage.getCode");
		List areaCb = generalDAO.queryForList("management.adminManage.getCode" , "002");  // 부서 조회
		
		logger.debug("===== management.adminManage.getCode");
		List areaCb2 = generalDAO.queryForList("management.adminManage.getCode" , "003");  // 지역 조회
		
		logger.debug("===== management.adminManage.getCode");
		List agencyTypeCb = generalDAO.queryForList("management.adminManage.getCode" , "017");  // 지국구분 조회
		
		logger.debug("===== management.adminManage.getCode");
		List partCb = generalDAO.queryForList("management.adminManage.getCode" , "018");  // 파트 조회
		
		logger.debug("===== management.adminManage.getCode");
		List agencyAreaCb = generalDAO.queryForList("management.adminManage.getCode" , "019");  // 지역 조회
		
		logger.debug("===== management.adminManage.getBankCode");
		List bankCb = generalDAO.queryForList("management.adminManage.getBankCode" , numId );  // 지역 조회
		
		List selectManagerList = generalDAO.queryForList("reader.common.selectManagerList"); //담당자조회
		
		mav.addObject("flag", flag);
		mav.addObject("telExcNo", telExcNo);
		mav.addObject("mblExcNo", mblExcNo);
		mav.addObject("areaCb", areaCb);
		mav.addObject("areaCb2", areaCb2);
		mav.addObject("agencyTypeCb", agencyTypeCb);
		mav.addObject("agencyAreaCb", agencyAreaCb);
		mav.addObject("partCb", partCb);
		mav.addObject("bankCb", bankCb);
		mav.addObject("selectManagerList", selectManagerList);
		
		mav.addObject("now_menu", MENU_CODE_MANAGEMENT_AGENCY);
		mav.setViewName("management/agency/agencyMng");
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
		
		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		dbparam.put("numId", numId); 
		dbparam.put("passwd", param.getString("passwd")); 
		dbparam.put("name", param.getString("name"));
		dbparam.put("nameSub", param.getString("nameSub"));
		dbparam.put("name2", param.getString("name2")); 
		dbparam.put("manager", param.getString("manager")); 
		dbparam.put("area1", param.getString("area1")); 
		dbparam.put("area", param.getString("area")); 
		dbparam.put("jikuk_Email", param.getString("jikuk_Email")); 
		dbparam.put("zip", param.getString("zip")); 
		dbparam.put("agencyType", param.getString("agencyType")); 
		dbparam.put("part", param.getString("part")); 
		dbparam.put("agencyArea", param.getString("agencyArea")); 
		dbparam.put("addr1", param.getString("addr1")); 
		dbparam.put("iden_No", param.getString("iden_No")); 
		dbparam.put("giro_No", param.getString("giro_No")); 
		dbparam.put("approval_No", param.getString("approval_No")); 
		dbparam.put("bank", param.getString("bank"));
		dbparam.put("bankNum", param.getString("bankNum"));
		dbparam.put("sdate", param.getString("sdate")); 
		dbparam.put("edate", param.getString("edate")); 
		dbparam.put("rdate", param.getString("rdate")); 
		dbparam.put("admin", param.getString("admin")); 
		dbparam.put("memo", param.getString("memo")); 
		
		HashMap<String, Object> telNo = setTelNo(param);
		dbparam.put("jikuk_Tel", telNo.get("jikuk_Tel")); 
		dbparam.put("jikuk_Handy", telNo.get("jikuk_Handy")); 
		dbparam.put("jikuk_Fax", telNo.get("jikuk_Fax")); 
	
		try{
			logger.debug("===== management.adminManage.updateAgencyInfo");
			if(generalDAO.update("management.adminManage.updateAgencyInfo", dbparam) > 0){
				mav.addObject("message", "정상적으로 수정 되었습니다.");
			}
		}catch (Exception e){
			    mav.addObject("message", "수정이 실패했습니다.");
			    e.printStackTrace();
		}
		
		//한글인코딩
		String redirecParam = URLEncoder.encode(param.getString("manager"), "UTF-8");
		
		mav.addObject("numId", numId);
		mav.addObject("manager",redirecParam);
		mav.addObject("pageNo", param.getString("pageNo"));
		mav.setViewName("common/message");
		mav.addObject("returnURL", "/management/adminManage/agencyInfo.do?numId="+numId);
		return mav;
	}
	
	

	/**
	 * 지국정보 삭제
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView agencyDelete(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);		
		ModelAndView mav = new ModelAndView();
		
		String numId = param.getString("numId");
		String userId = param.getString("userId");
		
		HashMap dbparam = new HashMap();
		dbparam.put("numId", numId); 
		dbparam.put("userId", userId); 
		
		logger.debug("파람정보_NumID : "+ numId);
		logger.debug("파람정보_UserID : "+ userId);
		
		// 지국번호 존재여부 확인
		logger.debug("===== management.adminManage.getDupGuyuk");
		List agencyInfo = generalDAO.queryForList("management.adminManage.getDupAgency" , dbparam);
		
		//지국정보 삭제전 해당지국 사용여부 조회
		logger.debug("===== management.adminManage.getDupGuyukUse");
		List agencyUseYn = generalDAO.queryForList("management.adminManage.getAgencyUse" , dbparam);
		
		if(agencyInfo.size()==0){
			mav.addObject("message", "존재하지 않는 지국입니다.");
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/management/adminManage/agencyList.do");
		}else if(agencyUseYn.size()!=0){
			mav.addObject("message", "해당지국에 등록된 독자정보가있어 삭제할수 없습니다.");
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/management/adminManage/agencyList.do");	
		}else{							
			
			try{
				
				generalDAO.getSqlMapClient().startTransaction();
				generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
				
				logger.debug("===== management.adminManage.deleteAgencyInfo");
				if(generalDAO.getSqlMapClient().delete("management.adminManage.deleteAgencyInfo", dbparam) > 0){
					logger.debug("===== output.billOutput.deleteCustNotice");
					generalDAO.getSqlMapClient().delete("output.billOutput.deleteCustNotice", dbparam);
				}
			
				generalDAO.getSqlMapClient().getCurrentConnection().commit();
				mav.addObject("message", userId+"지국이 정상적으로 삭제 되었습니다.");
				
				
			}catch (Exception e){
				generalDAO.getSqlMapClient().getCurrentConnection().rollback();
				mav.addObject("message", "삭제를 실패했습니다.");
				e.printStackTrace();
				
			}finally{
				generalDAO.getSqlMapClient().endTransaction();
			}
			
	
		mav.setViewName("common/message");
		mav.addObject("returnURL", "/management/adminManage/agencyList.do");
		}
		
		return mav;
			

	}

	/**
	 * 지국정보 등록
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView agencyInsert(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);		
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession(true);
		
		String admin = String.valueOf(session.getAttribute( SESSION_NAME_ADMIN_USERID ));
		if("".equals(admin) || admin == null){
			admin = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID ));			
		}

		String userId = param.getString("userId");
		
		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		dbparam.put("userId", userId); 
		dbparam.put("passwd", param.getString("passwd")); 
		dbparam.put("serial", param.getString("serial")); 
		dbparam.put("name", param.getString("name")); 
		dbparam.put("nameSub", param.getString("nameSub")); 
		dbparam.put("name2", param.getString("name2")); 
		dbparam.put("manager", param.getString("manager")); 
		dbparam.put("area1", param.getString("area1")); 
		dbparam.put("area", param.getString("area")); 
		dbparam.put("jikuk_Email", param.getString("jikuk_Email"));
		dbparam.put("jikuk_Email2", param.getString("jikuk_Email2")); 
		dbparam.put("zip", param.getString("zip")); 
		dbparam.put("agencyType", param.getString("agencyType")); 
		dbparam.put("part", param.getString("part")); 
		dbparam.put("agencyArea", param.getString("agencyArea")); 
		dbparam.put("addr1", param.getString("addr1")); 
		dbparam.put("iden_No", param.getString("iden_No")); 
		dbparam.put("giro_No", param.getString("giro_No")); 
		dbparam.put("approval_No", param.getString("approval_No")); 
		dbparam.put("bank", param.getString("bank")); 
		dbparam.put("bankNum", param.getString("bankNum")); 
		dbparam.put("sdate", param.getString("sdate")); 
		dbparam.put("edate", param.getString("edate")); 
		dbparam.put("admin", admin); 
		dbparam.put("memo", param.getString("memo")); 
		
		HashMap telNo = setTelNo(param);
		dbparam.put("jikuk_Tel", telNo.get("jikuk_Tel")); 
		dbparam.put("jikuk_Handy", telNo.get("jikuk_Handy")); 
		dbparam.put("jikuk_Fax", telNo.get("jikuk_Fax")); 

		logger.debug("파람정보_UserID : "+ userId);
		logger.debug("세션정보_Admin : "+ admin);
		logger.debug("파람정보_Name : "+  param.getString("name"));
		
		
		// 지국번호 중복여부 확인
		logger.debug("===== management.adminManage.getDupAgency");
		List agencyInfo = generalDAO.queryForList("management.adminManage.getDupAgency" , dbparam);
		if(agencyInfo.size()>0){
			mav.addObject("message", "이미 등록된 지국번호 입니다.");
		}else{	
		
			try{
				
				generalDAO.getSqlMapClient().startTransaction();
				generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
				
				logger.debug("===== management.adminManage.insertAgencyInfo");
				generalDAO.getSqlMapClient().insert("management.adminManage.insertAgencyInfo", dbparam);
				
				// 고객안내문 생성
				dbparam.put("giro", ""); 
				dbparam.put("visit", ""); 
				for(int i=1 ; i < 8 ; i++ ){
					dbparam.put("code", i); 
					logger.debug("===== output.billOutput.insertCustNotice"+ i);
					generalDAO.getSqlMapClient().insert("output.billOutput.insertCustNotice", dbparam);
				}

				generalDAO.getSqlMapClient().getCurrentConnection().commit();
				mav.addObject("message", userId+"지국이 정상적으로 등록 되었습니다.");
			}catch (Exception e){
				generalDAO.getSqlMapClient().getCurrentConnection().rollback();
				mav.addObject("message", "등록을 실패했습니다.");
				e.printStackTrace();
			}finally{
				generalDAO.getSqlMapClient().endTransaction();
			}
		}
		
		mav.setViewName("common/message");
		mav.addObject("returnURL", "/management/adminManage/agencyInfo.do");
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

		HashMap telNo = new HashMap();

		telNo.put("jikuk_Tel", jikuk_Tel);
		telNo.put("jikuk_Handy", jikuk_Handy);
		telNo.put("jikuk_Fax", jikuk_Fax);
		
		return telNo;
	}
	
	/**
	 * 관할지역관리
	 * 
	 * @category 관할지역관리창 호출
	 * @author ycpark
	 * @return mav
	 * @throws Exception
	 */
	public ModelAndView mngArea(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList");// 지국 목록
		
		mav.addObject("agencyAllList", agencyAllList);
		mav.addObject("now_menu", MENU_CODE_MANAGEMENT_AGENCY);
		mav.setViewName("management/manageArea");
		return mav;
	}
	
	/**
	 * 관리지역검색 - 관할지역관리
	 * 
	 * @param request
	 * @param response
	 * @category 관리지역검색 - 관할지역관리
	 * @author ycpark
	 * @return json
	 * @throws Exception
	 */	
	public ModelAndView searchMngArea(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		request.setCharacterEncoding("utf-8");
		Param param = new HttpServletParam(request);

		try{
			HashMap<Object, Object> dbparam = new HashMap<Object, Object>();

			String type = param.getString("type");
			if("tbl1".equals(type)){
				String searchValue = param.getString("searchValue");
				int tmp = searchValue.indexOf(" ");
				int tmpBar = searchValue.indexOf("-");

				// 공백이 있는 경우
				if(searchValue.indexOf(" ") > -1){
					
					// 지번1 지번2가 나누어 있는 경우
					if(searchValue.indexOf("-") > -1){
						// - 기준으로 지번1, 지번2
						String lot1 = searchValue.substring(tmp+1,tmpBar);
						String lot2 = searchValue.substring(tmpBar+1);
						
						// 지번1 세팅
						int tmpComma1 = lot1.indexOf(",");
						int tmpBetween1 = lot1.indexOf("~");
						if(lot1.indexOf(",") > -1){
							String [] arrLot1 = lot1.split(",");
							dbparam.put("lotNo1", arrLot1);
							dbparam.put("lotType1", "or");
						}else if(lot1.indexOf("~") > -1){
							if(checkNumeric(lot1.substring(0, tmpBetween1))){
								dbparam.put("lotNo1", lot1.substring(0, tmpBetween1));
								dbparam.put("lotNo1_1", lot1.substring(tmpBetween1+1));
								dbparam.put("lotType1", "between");
							}
						}else{
							dbparam.put("lotNo1", lot1.replace(" ", ""));
						}
						
						int tmpComma2 = lot2.indexOf(",");
						int tmpBetween2 = lot2.indexOf("~");
						// 지번2 세팅
						if(lot2.indexOf(",") > -1){
							String [] arrLot2 = lot2.split(",");
							dbparam.put("lotNo2", arrLot2);
							dbparam.put("lotType2", "or");
						}else if(lot2.indexOf("~") > -1){
							if(checkNumeric(lot2.substring(0, tmpBetween2))){
								dbparam.put("lotNo2", lot2.substring(0, tmpBetween2));
								dbparam.put("lotNo2_1", lot2.substring(tmpBetween2+1));
								dbparam.put("lotType2", "between");
							}
						}else{
							dbparam.put("lotNo2", lot2.replace(" ", ""));
						}
						
					}else{
						// - 기준으로 지번1, 지번2
						String lot1 = searchValue.substring(tmp+1);
						// - 없는 경우 지번1'
						// 지번1 세팅
						int tmpComma1 = lot1.indexOf(",");
						int tmpBetween1 = lot1.indexOf("~");
						if(lot1.indexOf(",") > -1){
							String [] arrLot1 = lot1.split(",");
							dbparam.put("lotNo1", arrLot1);
							dbparam.put("lotType1", "or");
						}else if(lot1.indexOf("~") > -1){
							if(checkNumeric(lot1.substring(0, tmpBetween1))){
								dbparam.put("lotNo1", lot1.substring(0, tmpBetween1));
								dbparam.put("lotNo1_1", lot1.substring(tmpBetween1+1));
								dbparam.put("lotType1", "between");
							}
						}else{
							dbparam.put("lotNo1", lot1.replace(" ", ""));
						}
					}
					
					// 공백까지는 읍면동
					dbparam.put("searchValue", searchValue.substring(0, tmp).replace(" ", ""));
				// 공백이 없으면 번지 없음
				}else{
					dbparam.put("searchValue", searchValue);
				}

			}else{
				dbparam.put("boseq", param.getString("boseq"));
			}
			
			System.out.println("jsonObject param>>>>"+dbparam);
			
			List addrList = generalDAO.queryForList("management.adminManage.searchNewAddr", dbparam);
			
			JSONArray jsonArray = JSONArray.fromObject(addrList);  
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonArray);
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 관할지국업데이트 - 관할지역관리
	 * 
	 * @param request
	 * @param response
	 * @category 관할지국업데이트 - 관할지역관리
	 * @author ycpark
	 * @return json
	 * @throws Exception
	 */	
	public ModelAndView updateMngJikuk(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		request.setCharacterEncoding("utf-8");
		Param param = new HttpServletParam(request);

		try{
			HashMap<Object, Object> dbparam = new HashMap<Object, Object>();

			dbparam.put("bdMngNo", param.getString("bdMngNo"));
			dbparam.put("boseq", param.getString("boseq"));
			
			System.out.println("jsonObject param>>>>"+dbparam);
			int row = generalDAO.update("management.adminManage.updateMngJikuk", dbparam);
			
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(row);
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 숫자체크
	 * 
	 * @category 숫자인지 여부 체크
	 * @return boolean
	 * @author ycpark
	 * @throws Exception
	 */
	public boolean checkNumeric(String value) throws Exception {
		if(StringUtils.isNumeric(value)){
			return true;
		}else{
			return false;
		}

	}
	
	/**
	 * 새주소 DB 입력창 호출
	 * 
	 * @param request 
	 * @param response
	 * @category 새주소 DB 입력창 호출
	 * @author ycpark
	 * @return
	 * @throws Exception
	 */
	public ModelAndView manageNewAddr(HttpServletRequest request,
			HttpServletResponse response) throws Exception {	
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("now_menu", MENU_CODE_MANAGEMENT_ROADADDR);
		mav.setViewName("etc/manageNewAddr");
		return mav;
	}
	
	/**
	 * 새주소 DB입력
	 * 
	 * @param request
	 * @param response
	 * @category 새주소 DB입력
	 * @author ycpark
	 * @return
	 * @throws Exception
	 */	
	public ModelAndView insertNewAddrDataFile(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			// transaction 설정
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);

			// session 세팅
			HashMap dbparam = new HashMap();
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			String loginId = (String)session.getAttribute(SESSION_NAME_ADMIN_USERID);
			
			// request 객체 생성
			MultipartHttpServletParam param = new MultipartHttpServletParam(request);
			// 파일 객체 생성
			MultipartFile newAddrDataFile = param.getMultipartFile("newAddrDataFile");
			InputStream inputStream = newAddrDataFile.getInputStream();				
			BufferedReader bufferReader = new BufferedReader(new InputStreamReader(inputStream, "EUC-KR"));

			String line;
			String map[];
			
			// 파일 추출
			while( (line = bufferReader.readLine()) != null ){
				dbparam = new HashMap();
				String dataType = "";
				
				// "|"으로 분리
				map = line.split("\\|");
				for( int i = 0; i < map.length; i++ ){
					// 입력구분 초기화
					if(i == 0){
						//System.out.println("법정동코드 >>>>"+map[i].toString());
						dbparam.put("LW_DNG_CD", map[i].toString());
					}else if(i == 1){
						//System.out.println("시도명 >>>>"+map[i].toString());
						dbparam.put("SD_NM", map[i].toString());
					}else if(i == 2){
						//System.out.println("시군구명 >>>>"+map[i].toString());
						dbparam.put("SGG_NM", map[i].toString());
					}else if(i == 3){
						//System.out.println("법정읍면동명 >>>>"+map[i].toString());
						dbparam.put("LW_EPMNDNG_NM", map[i].toString());
					}else if(i == 4){
						//System.out.println("법정리명 >>>>"+map[i].toString());
						dbparam.put("LW_RI_NM", map[i].toString());
					}else if(i == 5){
						//System.out.println("산여부 >>>>"+map[i].toString());
						dbparam.put("MT_YN", map[i].toString());
					}else if(i == 6){
						//System.out.println("지번본번 >>>>"+map[i].toString());
						dbparam.put("LOT_NO1", map[i].toString());
					}else if(i == 7){
						//System.out.println("지번부번 >>>>"+map[i].toString());
						dbparam.put("LOT_NO2", map[i].toString());
					}else if(i == 8){
						//System.out.println("도로명코드 >>>>"+map[i].toString());
						dbparam.put("ROAD_CD", map[i].toString());
					}else if(i == 9){
						//System.out.println("도로명 >>>>"+map[i].toString());
						dbparam.put("ROAD_NM", map[i].toString());
					}else if(i == 10){
						//System.out.println("지하여부 >>>>"+map[i].toString());
						dbparam.put("UND_YN", map[i].toString());
					}else if(i == 11){
						//System.out.println("건물번호본번 >>>>"+map[i].toString());
						dbparam.put("BD_NO1", map[i].toString());
					}else if(i == 12){
						//System.out.println("건물번호부번 >>>>"+map[i].toString());
						dbparam.put("BD_NO2", map[i].toString());
					}else if(i == 13){
						//System.out.println("건축물대장 건물명 >>>>"+map[i].toString());
						dbparam.put("BD_NM", map[i].toString());
					}else if(i == 14){
						//System.out.println("상세건물명 >>>>"+map[i].toString());
						dbparam.put("BD_NM_DESC", map[i].toString());
					}else if(i == 15){
						//System.out.println("건물관리번호 >>>>"+map[i].toString());
						dbparam.put("BD_MNG_NO", map[i].toString());
					}else if(i == 16){
						//System.out.println("읍면동일련번호 >>>>"+map[i].toString());
						dbparam.put("EPMNDNG_SEQ", map[i].toString());
					}else if(i == 17){
						//System.out.println("행정동코드 >>>>"+map[i].toString());
						dbparam.put("ADM_DNG_CD", map[i].toString());
					}else if(i == 18){
						//System.out.println("행정동명 >>>>"+map[i].toString());
						dbparam.put("ADM_DNG_NM", map[i].toString());
					}else if(i == 19){
						//System.out.println("우편번호>>>>"+map[i].toString());
						dbparam.put("ZIP_CD", map[i].toString());
					}else if(i == 20){
						//System.out.println("우편일련번호>>>>"+map[i].toString());
						dbparam.put("ZIP_SEQ", map[i].toString());
					}else if(i == 21){
						//System.out.println("다량배달처명 >>>>"+map[i].toString());
						dbparam.put("MN_DLV_NM", map[i].toString());
					}else if(i == 22){
						//System.out.println("이동사유코드 >>>>"+map[i].toString());
						//이동사유코드
						dbparam.put("MV_REASON_CD", map[i].toString());
						dataType = map[i].toString();
					}else if(i == 23){
						//System.out.println("변경일자 >>>>"+map[i].toString());
						//변경일자
						dbparam.put("CHGDT", map[i].toString());
					}else if(i == 24){
						//System.out.println("변경전도로명주소 >>>>"+map[i].toString());
						//변경전도로명주소
						dbparam.put("PRE_ROAD_CD", map[i].toString());
					}else if(i == 25){
						//System.out.println("시군구용건물명 >>>>"+map[i].toString());
						dbparam.put("SGG_BD_NM", map[i].toString());
					}else if(i == 26){
						//System.out.println("공동주택여부 >>>>"+map[i].toString());
						//공동주택여부
						dbparam.put("APT_YN", map[i].toString());
					}else if(i == 27){
						//System.out.println("새우편주소 >>>>"+map[i].toString());
						//새우편주소
						dbparam.put("ZIP_NO", map[i].toString());
					}
					System.out.println("dataType_"+i+" = "+dataType+"dbparam>>"+dbparam); 
				}

				// 이동사유코드가 NULL이거나 31이면 입력
				
				if("".equals(dataType)||"31".equals(dataType)){
					
					// 해당 건물번호로 등록된 데이터가 있는지 조회(현재 변동분 데이터에 신규추가임에도 기 등록된 데이터가 존재함)
					int count = generalDAO.count("common.countNewAddr",  dbparam);
					if(count > 0 ){
						generalDAO.getSqlMapClient().update("common.updateNewAddr",  dbparam);
					}else{
						generalDAO.getSqlMapClient().insert("common.insertNewAddr",  dbparam);						
					}
				// 도로폐지(삭제)
				//}else if("61".equals(dataType)||"62".equals(dataType)||"63".equals(dataType)){
				}else if("63".equals(dataType)){
					generalDAO.getSqlMapClient().update("common.deleteNewAddr",  dbparam);
				// 업데이트(수정)
				}else if("34".equals(dataType)){
					generalDAO.getSqlMapClient().update("common.updateNewAddr",  dbparam);
				}
				
			}
			
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			mav.setViewName("common/message");
			mav.addObject("message", "새주소 데이터 입력이 완료 되었습니다.");
			mav.addObject("returnURL", "/management/adminManage/manageNewAddr.do");
			mav.addObject("now_menu", MENU_CODE_MANAGEMENT_ROADADDR);
		}catch(Exception e){
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
		}finally{
			generalDAO.getSqlMapClient().endTransaction();
			return mav;
		}
	}
	
	/**
	 * 발송연락처 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView agencyDeliveryList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();

		HttpSession session = request.getSession(true);
			
		HashMap dbparam = new HashMap();
		
		List deliveryNumList = generalDAO.queryForList("management.adminManage.selectDeliveryNumbersForAdmin",dbparam);
		
		mav.addObject("deliveryNumList", deliveryNumList);
		mav.addObject("now_menu", MENU_CODE_MANAGEMENT_AGENCY);
		mav.setViewName("management/agencyDeliveryList");
		return mav;
	}
	
	/**
	 * 발송연락처엑셀다운
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView excelDeliveryList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			HashMap dbparam = new HashMap();
			
			String printType = param.getString("printType");
			String url="";
			
			List deliveryList = generalDAO.queryForList("management.adminManage.selectDeliveryNumbersForExcel", dbparam);
			
			String fileName = "발송연락처(" + DateUtil.getCurrentDate("yyyyMMdd") + ").xls";
			//Excel response
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName); 
			response.setHeader("Content-Description", "JSP Generated Data");
			
			if("A".equals(printType)) { //전체
				url = "management/excelAgentDeliveryList";
			} else if("O".equals(printType)) { //지국장만
				url = "management/excelAgentDeliveryListOnlyOwner";
			}
			
			mav.addObject("deliveryList" , deliveryList);
			System.out.println("deliveryList = "+deliveryList);
			mav.setViewName(url);
		}catch(Exception e){
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
		}
		return mav;
	}

}
