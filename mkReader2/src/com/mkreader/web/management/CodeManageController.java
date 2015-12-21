/*------------------------------------------------------------------------------
 * NAME : CodeManageController 
 * DESC : 관리 -> 코드관리 
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
import com.mkreader.util.StringUtil;

public class CodeManageController extends MultiActionController implements
	ISiteConstant, ICodeConstant {

	public static Logger logger = Logger.getRootLogger();
	
	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {

			this.generalDAO = generalDAO;
	}
	
	/**
	 * 구역정보 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView guyukList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();

		HttpSession session = request.getSession(true);
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		
		HashMap dbparam = new HashMap();
		dbparam.put("userId", userId);
		
		logger.debug("세션정보_UserID : "+ userId);		
		logger.debug("===== management.codeManage.getGuyukInfo");
		
		List guyukInfo = generalDAO.queryForList("management.codeManage.getGuyukInfo" , dbparam);
		mav.addObject("guyukInfo", guyukInfo);
		mav.addObject("userId", userId);
		
		mav.addObject("now_menu", MENU_CODE_MANAGEMENT_J_AREA);
		mav.setViewName("management/guyukCode");
		return mav;

	}
	


	/**
	 * 구역정보 수정
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView guyukModify(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);		
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession(true);
		
		StringUtil utl = new StringUtil();
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		
		HashMap dbparam = new HashMap();
		dbparam.put("userId", userId); 
		dbparam.put("guNo", param.getString("guNo")); 
		dbparam.put("guNm", param.getString("guNm")); 
		dbparam.put("guApt", utl.nullToZero(param.getString("guApt"))); 
		dbparam.put("guBilla", utl.nullToZero(param.getString("guBilla"))); 
		dbparam.put("guOffice", utl.nullToZero(param.getString("guOffice"))); 
		dbparam.put("guSanga", utl.nullToZero(param.getString("guSanga"))); 
		dbparam.put("guJuteak", utl.nullToZero(param.getString("guJuteak"))); 
		dbparam.put("guGita", utl.nullToZero(param.getString("guGita"))); 
		
		logger.debug("세션정보_UserID : "+ userId);
		logger.debug("파람정보 확인 GuNo / GuNm : "+param.getString("guNo")+" / "+param.getString("guNm"));		
		logger.debug("===== management.codeManage.getDupGuyuk");
		
		// 구역번호 존재여부 확인
		List guyukInfo = generalDAO.queryForList("management.codeManage.getDupGuyuk" , dbparam);
		if(guyukInfo.size()==0){
			mav.addObject("message", "존재하지 않는 구역번호 입니다.");
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/management/codeManage/guyukList.do");
		}else{
			
			try{
				logger.debug("===== management.codeManage.updateGuyukInfo");
				if(generalDAO.update("management.codeManage.updateGuyukInfo", dbparam) > 0){
					mav.addObject("message", "정상적으로 수정 되었습니다.");
				}
			}catch (Exception e){
				    mav.addObject("message", "수정이 실패했습니다.");
				    e.printStackTrace();
			}
	
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/management/codeManage/guyukList.do");
		
		}
		return mav;
						

	}



	/**
	 * 구역정보 삭제
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView guyukDelete(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);		
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession(true);
		
		StringUtil utl = new StringUtil();
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		String guNo = param.getString("guNo");
		
		HashMap dbparam = new HashMap();
		dbparam.put("userId", userId); 
		dbparam.put("guNo", guNo); 
		
		logger.debug("세션정보_UserID : "+ userId);
		logger.debug("파람정보 확인 GuNo : "+param.getString("guNo"));		
		
		// 구역번호 존재여부 확인
		logger.debug("===== management.codeManage.getDupGuyuk");
		List guyukInfo = generalDAO.queryForList("management.codeManage.getDupGuyuk" , dbparam);
		
		//구역정보 삭제전 해당구역 사용여부 조회
		logger.debug("===== management.codeManage.getDupGuyukUse");
		List guyukUseYn = generalDAO.queryForList("management.codeManage.getDupGuyukUse" , dbparam);
		
		if(guyukInfo.size()==0){
			mav.addObject("message", "존재하지 않는 구역번호 입니다.");
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/management/codeManage/guyukList.do");
		}else if(guyukUseYn.size()!=0){
			mav.addObject("message", "해당구역에 등록된 구독정보가있어 삭제할수 없습니다.");
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/management/codeManage/guyukList.do");	
		}else{							
					
			try{
				logger.debug("===== management.codeManage.deleteGuyukInfo");
				if(generalDAO.delete("management.codeManage.deleteGuyukInfo", dbparam) > 0){
					mav.addObject("message", guNo+"구역이 정상적으로 삭제 되었습니다.");
				}
			}catch (Exception e){
				    mav.addObject("message", "삭제를 실패했습니다.");
				    e.printStackTrace();
			}
	
		mav.setViewName("common/message");
		mav.addObject("returnURL", "/management/codeManage/guyukList.do");
		}
		
		return mav;
			

	}
	
	/**
	 * 구역정보 등록
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView guyukInsert(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);		
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession(true);
		
		StringUtil utl = new StringUtil();
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		
		HashMap dbparam = new HashMap();
		dbparam.put("userId", userId); 
		dbparam.put("guNo", param.getString("guNo")); 
		dbparam.put("guNm", param.getString("guNm")); 
		dbparam.put("guApt", utl.nullToZero(param.getString("guApt"))); 
		dbparam.put("guBilla", utl.nullToZero(param.getString("guBilla"))); 
		dbparam.put("guOffice", utl.nullToZero(param.getString("guOffice"))); 
		dbparam.put("guSanga", utl.nullToZero(param.getString("guSanga"))); 
		dbparam.put("guJuteak", utl.nullToZero(param.getString("guJuteak"))); 
		dbparam.put("guGita", utl.nullToZero(param.getString("guGita"))); 
		
		logger.debug("세션정보_UserID : "+ userId);
		logger.debug("파람정보 확인 GuNo / GuNm : "+param.getString("guNo")+" / "+param.getString("guNm"));		
		
		// 구역번호 중복여부 확인
		logger.debug("===== management.codeManage.getDupGuyuk");
		List guyukInfo = generalDAO.queryForList("management.codeManage.getDupGuyuk" , dbparam);
		if(guyukInfo.size()>0){
			mav.addObject("message", "이미 등록된 구역번호 입니다.");
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/management/codeManage/guyukList.do");
		}else{	
		
			try{
				logger.debug("===== management.codeManage.insertGuyukInfo");
				generalDAO.insert("management.codeManage.insertGuyukInfo", dbparam);
				mav.addObject("message", "정상적으로 등록 되었습니다.");
				
			}catch (Exception e){
				mav.addObject("message", "등록을 실패했습니다.");
				e.printStackTrace();
			}
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/management/codeManage/guyukList.do");
		}
		return mav;
			
	}

	/**
	 * 확장자정보 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView extdList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();

		HttpSession session = request.getSession(true);
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		
		HashMap dbparam = new HashMap();
		dbparam.put("userId", userId);
		
		logger.debug("세션정보_UserID : "+ userId);
		logger.debug("===== management.codeManage.getExtdInfo");
		
		List extdInfo = generalDAO.queryForList("management.codeManage.getExtdInfo" , dbparam);
		
		logger.debug("===== management.codeManage.getAgency");
		Object agencyInfo = generalDAO.queryForObject("management.codeManage.getAgency" , dbparam);
		
		mav.addObject("extdInfo", extdInfo);
		mav.addObject("agencyInfo", agencyInfo);
		
		mav.addObject("now_menu", MENU_CODE_MANAGEMENT_J_EXET);
		mav.setViewName("management/extdCode");
		return mav;

	}
	


	/**
	 * 확장자정보 수정
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView extdModify(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);		
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession(true);
		
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		String code = param.getString("code");
				
		HashMap dbparam = new HashMap();
		dbparam.put("userId", userId); 
		dbparam.put("cName", param.getString("cName")); 
		dbparam.put("resv3", param.getString("resv3")); 
		dbparam.put("sortFd", param.getString("sortFd")); 
		dbparam.put("code", code); 
	  
		logger.debug("세션정보_UserID : "+ userId);
		logger.debug("파람정보_Code : "+ code);
		
		// 확장자번호 존재여부 확인
		logger.debug("===== management.codeManage.getExtdCdChk");
		List extdInfo = generalDAO.queryForList("management.codeManage.getExtdCdChk" , dbparam);
		
		// 확장자명 중복여부 조회
		logger.debug("===== management.codeManage.getExtdDup");
		List extdNm = generalDAO.queryForList("management.codeManage.getExtdDup" , dbparam);
		if(extdInfo.size()==0){
			mav.addObject("message", "존재하지 않는 확장자 입니다.");
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/management/codeManage/extdList.do");
			
		}else	if(extdNm.size()!=0){
			mav.addObject("message", "이미 등록된 확장자 입니다.");
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/management/codeManage/extdList.do");
			
		}else{
		
			try{
				logger.debug("===== management.codeManage.updateExtdInfo");
				if(generalDAO.update("management.codeManage.updateExtdInfo", dbparam) > 0){
					mav.addObject("message", "정상적으로 수정 되었습니다.");
				}
			}catch (Exception e){
				    mav.addObject("message", "수정이 실패했습니다.");
				    e.printStackTrace();
			}

		mav.setViewName("common/message");
		mav.addObject("returnURL", "/management/codeManage/extdList.do");
		}
		return mav;
						

	}



	/**
	 * 확장자정보 삭제(미사용처리)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView extdUseN(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);		
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession(true);
		
		StringUtil utl = new StringUtil();
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		String code = param.getString("code");
		String cName = param.getString("cName");
		
		HashMap dbparam = new HashMap();
		dbparam.put("userId", userId); 
		dbparam.put("code", code); 
		dbparam.put("cName", cName); 

		logger.debug("세션정보_UserID : "+ userId);
		logger.debug("파람정보 확인 Code / CName : "+code+" / "+cName);		

		// 확장자번호 존재여부 확인
		logger.debug("===== management.codeManage.getExtdCdChk");
		List extdInfo = generalDAO.queryForList("management.codeManage.getExtdCdChk" , dbparam);
		if(extdInfo.size()==0){
			mav.addObject("message", "존재하지 않는 확장자입니다.");
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/management/codeManage/extdList.do");
		}else{							
					
			try{
				logger.debug("===== management.codeManage.updateExtdUseN");
				if(generalDAO.update("management.codeManage.updateExtdUseN", dbparam) > 0){
					mav.addObject("message", "확장자 "+cName+"("+code+")"+"가 정상적으로 삭제 되었습니다.");
				}
			}catch (Exception e){
				    mav.addObject("message", "삭제를 실패했습니다.");
				    e.printStackTrace();
			}

		mav.setViewName("common/message");
		mav.addObject("returnURL", "/management/codeManage/extdList.do");
		}
		return mav;
			
	}
	
	/**
	 * 확장자정보 등록
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView extdInsert(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);		
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession(true);
		
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		String cName =  param.getString("cName");
		
		HashMap dbparam = new HashMap();
		dbparam.put("userId", userId); 
		dbparam.put("cName", cName); 
		dbparam.put("resv3", param.getString("resv3")); 
		dbparam.put("sortFd", param.getString("sortFd")); 
		
		logger.debug("세션정보_UserID : "+ userId);
		logger.debug("파람정보 확인 CName : "+cName);		
		
		// 확장자명 중복여부 확인
		logger.debug("===== management.codeManage.getExtdDup");
		List extdInfo = generalDAO.queryForList("management.codeManage.getExtdDup" , dbparam);
		if(extdInfo.size()>0){
			mav.addObject("message", "이미 등록된 확장자 입니다.");
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/management/codeManage/extdList.do");
		}else{	
		
			try{
				logger.debug("===== management.codeManage.insertExtdInfo");
				generalDAO.insert("management.codeManage.insertExtdInfo", dbparam);
				mav.addObject("message", "정상적으로 등록 되었습니다.");
				
			}catch (Exception e){
				mav.addObject("message", "등록을 실패했습니다.");
				e.printStackTrace();
			}
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/management/codeManage/extdList.do");
		}
		return mav;
			

	}
	

	/**
	 * 관할지역(지국) 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView jikukZipList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		
		ModelAndView mav = new ModelAndView();

		HttpSession session = request.getSession(true);
		
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		String txt = param.getString("txt");
		HashMap dbparam = new HashMap();
		dbparam.put("userId", userId); 
		dbparam.put("txt", txt); 
		
		logger.debug("세션정보_UserID : "+ userId);
		logger.debug("파람정보 확인 Txt : "+txt);		
		
		logger.debug("===== management.codeManage.getJikukZipList");
		List jikukZipList = generalDAO.queryForList("management.codeManage.getJikukZipList" , dbparam);
		mav.addObject("jikukZipList", jikukZipList);
		mav.addObject("txt", txt);
		
		mav.addObject("now_menu", MENU_CODE_MANAGEMENT_J_LOCATION);
		mav.setViewName("management/jikukZipCode");
		return mav;
		}

	/**
	 * 신문관리화면 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView newsList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();

		HttpSession session = request.getSession(true);
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		
		HashMap dbparam = new HashMap();
		dbparam.put("userId", userId);
		
		logger.debug("세션정보_UserID : "+ userId);		
		logger.debug("===== management.codeManage.getNewsCode");
		
		List newsAllList = generalDAO.queryForList("management.codeManage.getNewsCode" , dbparam);
		
		logger.debug("===== management.codeManage.getNews");
		List newsList = generalDAO.queryForList("management.codeManage.getNews" , dbparam);
		
		mav.addObject("newsAllList", newsAllList);
		mav.addObject("newsList", newsList);
		mav.addObject("userId", userId);
		
		mav.addObject("now_menu", MENU_CODE_MANAGEMENT_MEDIA);
		mav.setViewName("management/newsCode");
		return mav;

	}



	/**
	 * 매체정보 삭제
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView newsDelete(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);		
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession(true);
		
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		String code = param.getString("code");
		String news = param.getString("news");
		
		HashMap dbparam = new HashMap();
		dbparam.put("userId", userId); 
		dbparam.put("code", code); 
		dbparam.put("news", news); 
		
		logger.debug("세션정보_UserID : "+ userId);
		logger.debug("파람정보 확인 Code : "+ code);		
		logger.debug("파람정보 확인 News : "+ news);		
		
		// 관리중 신문코드 존재여부 확인
		logger.debug("===== management.codeManage.getDupNews");
		List newsInfo = generalDAO.queryForList("management.codeManage.getDupNews" , dbparam);
		
		//신문코드 삭제전 해당신문 구독독자 존재여부 조회
		logger.debug("===== management.codeManage.getNewsUsed");
		List newsUseYn = generalDAO.queryForList("management.codeManage.getNewsUsed" , dbparam);
		
		if(newsInfo.size()==0){
			mav.addObject("message", news + " 는 관리중인 매체가 아닙니다.");
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/management/codeManage/newsList.do");
		}else if(newsUseYn.size()!=0){
			mav.addObject("message", news + " 매체를 구독중인 독자가있어 삭제할수 없습니다.");
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/management/codeManage/newsList.do");	
		}else{							
					
			try{
				logger.debug("===== management.codeManage.deleteNews");
				if(generalDAO.delete("management.codeManage.deleteNews", dbparam) > 0){
					mav.addObject("message", news + " 매체가 정상적으로 삭제 되었습니다.");
				}
			}catch (Exception e){
				    mav.addObject("message", "삭제를 실패했습니다.");
				    e.printStackTrace();
			}
	
		mav.setViewName("common/message");
		mav.addObject("returnURL", "/management/codeManage/newsList.do");
		}
		
		return mav;
			

	}
	
	/**
	 * 매체정보 등록
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView newsInsert(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);		
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession(true);

		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		String code = param.getString("code");
		String news = param.getString("news");
		
		HashMap dbparam = new HashMap();
		dbparam.put("userId", userId); 
		dbparam.put("code", code); 
		dbparam.put("news", news); 
		
		logger.debug("세션정보_UserID : "+ userId);
		logger.debug("파람정보 확인 Code : "+ code);		
		logger.debug("파람정보 확인 News : "+ news);		
		
		// 매체코드 중복(등록)여부 확인
		logger.debug("===== management.codeManage.getDupNews");
		List guyukInfo = generalDAO.queryForList("management.codeManage.getDupNews" , dbparam);
		if(guyukInfo.size()>0){
			mav.addObject("message", news + " 는 이미 등록된 매체입니다.");
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/management/codeManage/newsList.do");
		}else{	
		
			try{
				logger.debug("===== management.codeManage.insertNews");
				generalDAO.insert("management.codeManage.insertNews", dbparam);
				mav.addObject("message", "정상적으로 등록 되었습니다.");
				
			}catch (Exception e){
				mav.addObject("message", "등록을 실패했습니다.");
				e.printStackTrace();
			}
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/management/codeManage/newsList.do");
		}
		return mav;
			
	}
	
}
