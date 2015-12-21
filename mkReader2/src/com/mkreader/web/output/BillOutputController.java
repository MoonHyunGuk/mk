/*------------------------------------------------------------------------------
 * NAME : BillOutputController 
 * DESC : 고지서  
 * Author : 유진영
 *----------------------------------------------------------------------------*/
package com.mkreader.web.output;

import java.awt.Rectangle;
import java.awt.Robot;
import java.awt.Toolkit;
import java.awt.image.BufferedImage;
import java.io.File;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
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

public class BillOutputController extends MultiActionController implements
	ISiteConstant, ICodeConstant {

	public static Logger logger = Logger.getRootLogger();
	
	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {

			this.generalDAO = generalDAO;
	}
	
	/**
	 * 지로영수증 화면호출
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView giroView(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();

		HttpSession session = request.getSession(true);
			
		HashMap dbparam = new HashMap();
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		
		logger.debug("세션정보_UserID : "+ userId);		
		dbparam.put("userId", userId); 
		
		logger.debug("===== output.billOutput.getGuyukList");		
		List guyukList = generalDAO.queryForList("output.billOutput.getGuyukList" , dbparam);
		
		logger.debug("===== output.billOutput.getNews");
		List newsCode = generalDAO.queryForList("output.billOutput.getNews" , dbparam);  // 지국별 매체코드 조회

		logger.debug("===== output.billOutput.getPrtCb");
		Object prtCb = generalDAO.queryForObject("output.billOutput.getPrtCb" , dbparam);  // 인쇄조건 조회
		
		logger.debug("===== output.billOutput.getCustNotice");
		List noti = generalDAO.queryForList("output.billOutput.getCustNotice" , dbparam);  // 고객안내문 코드 조회
		
		logger.debug("===== output.billOutput.getCustNotice");
		List jikyungYn = generalDAO.queryForList("output.billOutput.getJikyung" , dbparam);  // 직영여부 조회
		
		if(jikyungYn.size()!=0){
			mav.addObject("jikyungYn", "1");
		}
		mav.addObject("notiNo", "01");
		mav.addObject("newsCode", newsCode);
		mav.addObject("prtCb", prtCb);
		mav.addObject("guyukList", guyukList);
		mav.addObject("noti", noti);
		mav.addObject("userId", userId);
		
		mav.addObject("now_menu", MENU_CODE_OUTPUT_JIRO);
		mav.setViewName("output/giroBill");
		return mav;

	}
	
	/**
	 * 방문영수증 화면호출
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView visitView(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();

		HttpSession session = request.getSession(true);
			
		HashMap dbparam = new HashMap();
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		
		logger.debug("세션정보_UserID : "+ userId);		
		dbparam.put("userId", userId); 
		
		logger.debug("===== output.billOutput.getGuyukList");		
		List guyukList = generalDAO.queryForList("output.billOutput.getGuyukList" , dbparam);
		
		logger.debug("===== output.billOutput.getNews");
		List newsCode = generalDAO.queryForList("output.billOutput.getNews" , dbparam);  // 지국별 매체코드 조회

		logger.debug("===== output.billOutput.getPrtCb");
		Object prtCb = generalDAO.queryForObject("output.billOutput.getPrtCb" , dbparam);  // 인쇄조건 조회
		
		logger.debug("===== output.billOutput.getCustNotice");
		List noti = generalDAO.queryForList("output.billOutput.getCustNotice" , dbparam);  // 고객안내문 코드 조회
		
		mav.addObject("notiNo", "01");
		mav.addObject("newsCode", newsCode);
		mav.addObject("prtCb", prtCb);
		mav.addObject("guyukList", guyukList);
		mav.addObject("noti", noti);
		
		mav.addObject("now_menu", MENU_CODE_OUTPUT_VISIT);
		mav.setViewName("output/visitBill");
		return mav;

	}
	

	/**
	 * 방문영수증 화면호출(ABC용)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView visitView2(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();

		HttpSession session = request.getSession(true);
			
		HashMap dbparam = new HashMap();
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		
		logger.debug("세션정보_UserID : "+ userId);		
		dbparam.put("userId", userId); 
		
		logger.debug("===== output.billOutput.getGuyukList");		
		List guyukList = generalDAO.queryForList("output.billOutput.getGuyukList" , dbparam);
		
		logger.debug("===== output.billOutput.getNews");
		List newsCode = generalDAO.queryForList("output.billOutput.getNews" , dbparam);  // 지국별 매체코드 조회

		logger.debug("===== output.billOutput.getPrtCb");
		Object prtCb = generalDAO.queryForObject("output.billOutput.getPrtCb" , dbparam);  // 인쇄조건 조회
		
		logger.debug("===== output.billOutput.getCustNotice");
		List noti = generalDAO.queryForList("output.billOutput.getCustNotice" , dbparam);  // 고객안내문 코드 조회
		
		mav.addObject("notiNo", "01");
		mav.addObject("newsCode", newsCode);
		mav.addObject("prtCb", prtCb);
		mav.addObject("guyukList", guyukList);
		mav.addObject("noti", noti);
		
		mav.addObject("now_menu", MENU_CODE_OUTPUT_VISIT);
		mav.setViewName("output/visitBill2");
		return mav;

	}
	
	
	/**
	 * 개별영수증 화면호출
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView eachView(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);		
		HttpSession session = request.getSession(true);
			
		HashMap dbparam = new HashMap();
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		logger.debug("세션정보_UserID : "+ userId);		
		dbparam.put("userId", userId); 
		
		if(!"".equals(param.getString("serial")) && null != param.getString("serial")){
			dbparam.put("serial", param.getString("serial")); 
		}else{
			dbparam.put("serial", userId); 
		}
		
		dbparam.put("newsCd", param.getString("newsCd")); 
		dbparam.put("readNo", param.getString("readNo")); 
		
		logger.debug("===== output.billOutput.getAgencyList");		
		List agencyList = generalDAO.queryForList("output.billOutput.getAgencyList" , dbparam);
		
		logger.debug("===== output.billOutput.getNews");
		List newsCode = generalDAO.queryForList("output.billOutput.getNews" , dbparam);  // 지국별 매체코드 조회
		
		logger.debug("===== output.billOutput.getBillList");		
		List billList = generalDAO.queryForList("output.billOutput.getBillList" , dbparam);  // 개별영수증 발행 리스트
		
		logger.debug("===== output.billOutput.getCustNotice");
		List jikyungYn = generalDAO.queryForList("output.billOutput.getJikyung" , dbparam);  // 직영여부 조회
		
		if(jikyungYn.size()!=0){
			mav.addObject("jikyungYn", "1");
		}
		
		List noti = generalDAO.queryForList("output.billOutput.getCustNotice" , dbparam);  // 고객안내문 코드 조회
		
		mav.addObject("agencyList", agencyList);
		mav.addObject("newsCode", newsCode);
		mav.addObject("billList", billList);
		mav.addObject("noti", noti);
		
		mav.addObject("notiNo",  param.getString("noti"));
		mav.addObject("newsCd",  param.getString("newsCd"));
		mav.addObject("serial",  param.getString("serial"));
		mav.addObject("readNo",  param.getString("readNo"));
		
		mav.addObject("now_menu", MENU_CODE_OUTPUT_EACH);
		mav.setViewName("output/eachBill");
		return mav;

	}
	

	/**
	 * 개별영수증 독자조회결과
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView eachReaderView(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);		
		HttpSession session = request.getSession(true);
			
		HashMap dbparam = new HashMap();
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		logger.debug("세션정보_UserID : "+ userId);		
		dbparam.put("userId", userId); // 상단 조회조건의 지국콤보 조회조건
		
		dbparam.put("gu", "구 ");  // 구
		dbparam.put("apt", "아파트");  // 아파트
		dbparam.put("serial", param.getString("serial"));  // 상단 조회조건의 지국
		dbparam.put("newsCd", param.getString("newsCd"));  // 상단 조회조건의 매체
		dbparam.put("readNo", param.getString("readNo"));  // 상단 조회조건의 독자번호
		
		dbparam.put("reader", param.getString("readNo")); 
		dbparam.put("news", param.getString("newsCd")); 
		
		if(!"".equals(param.getString("reader")) && null != param.getString("reader")){
			dbparam.put("reader", param.getString("reader")); // 독자조회 및 발행시 독자번호
			dbparam.put("news", param.getString("news"));    // 독자조회 및 발행시 매체코드
			dbparam.put("seq", param.getString("seq"));         // 독자조회 및 발행시 시퀀스
		}
		
		logger.debug("===== output.billOutput.getAgencyList");		
		List agencyList = generalDAO.queryForList("output.billOutput.getAgencyList" , dbparam);  // 지국리스트
		
		logger.debug("===== output.billOutput.getNews");
		List newsCode = generalDAO.queryForList("output.billOutput.getNews" , dbparam);  // 지국별 매체코드 조회
		
		logger.debug("===== output.billOutput.getReaderList");		
		List readerList = generalDAO.queryForList("output.billOutput.getReaderList" , dbparam);  // 독자리스트
		
		logger.debug("===== output.billOutput.getSugmList1");		
		List sugmList1 = generalDAO.queryForList("output.billOutput.getSugmList1" , dbparam);  // 이전 수금 리스트

		logger.debug("===== output.billOutput.getSugmList2");		
		List sugmList2 = generalDAO.queryForList("output.billOutput.getSugmList2" , dbparam);  // 이후 수금 리스트
		
		logger.debug("===== output.billOutput.getBillList");		
		List billList = generalDAO.queryForList("output.billOutput.getBillList" , dbparam);  // 개별영수증 발행 리스트
		
		logger.debug("===== output.billOutput.getReader");	
		Object reader = generalDAO.queryForObject("output.billOutput.getReader" , dbparam);  // 독자조회

		logger.debug("===== output.billOutput.getCustNotice");
		List jikyungYn = generalDAO.queryForList("output.billOutput.getJikyung" , dbparam);  // 직영여부 조회
		
		if(jikyungYn.size()!=0){
			mav.addObject("jikyungYn", "1");
		}
		
		List noti = generalDAO.queryForList("output.billOutput.getCustNotice" , dbparam);  // 고객안내문 코드 조회

		mav.addObject("newsCd",  param.getString("newsCd"));
		mav.addObject("serial",  param.getString("serial"));
		mav.addObject("readNo",  param.getString("readNo"));
		mav.addObject("notiNo",  param.getString("noti"));
		
		mav.addObject("reader", reader);
		mav.addObject("noti", noti);
		mav.addObject("agencyList", agencyList);
		mav.addObject("newsCode", newsCode);
		mav.addObject("readerList", readerList);
		mav.addObject("sugmList1", sugmList1);
		mav.addObject("sugmList2", sugmList2);
		mav.addObject("billList", billList);
		
		if(readerList.size()==0){
			mav.addObject("message", "존재하지 않는 독자입니다.");
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/output/billOutput/eachView.do");
		}else{
		
			mav.addObject("now_menu", MENU_CODE_OUTPUT_EACH);
			mav.setViewName("output/eachBill");
		}
		return mav;

	}
	
	

	/**
	 * 개별영수증 발행내역 선택건 삭제
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView deleteBill(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);		
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession(true);

		String id = param.getString("id");
		String boseq = param.getString("boseq");
		
		HashMap dbparam = new HashMap();
		dbparam.put("id", id); 
		dbparam.put("boseq", boseq); 
		
		logger.debug("파람정보_ID : "+ id);
		logger.debug("파람정보 확인 BOSEQ : "+boseq);							
					
		try{
			logger.debug("===== output.billOutput.deleteBill");
			if(generalDAO.delete("output.billOutput.deleteBill", dbparam) > 0){
				mav.addObject("message", " 정상적으로 삭제 되었습니다.");
			}
		}catch (Exception e){
			    mav.addObject("message", "삭제를 실패했습니다.");
			    e.printStackTrace();
		}
	
		mav.setViewName("common/message");
		mav.addObject("returnURL", "/output/billOutput/eachView.do");
		
		return mav;
			
	}
	

	/**
	 * 개별영수증 발행
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView insertBill(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);		
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession(true);

		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		
		HashMap dbparam = new HashMap();
		String misuSum = param.getString("misuSum");
		
		dbparam.put("userId", userId); 
		dbparam.put("gu", "구 ");  // 구
		dbparam.put("apt", "아파트");  // 아파트
		dbparam.put("reader", param.getString("reader")); // 독자조회 및 발행시 독자번호
		dbparam.put("news", param.getString("news"));    // 독자조회 및 발행시 매체코드
		dbparam.put("seq", param.getString("seq"));         // 독자조회 및 발행시 시퀀스
		dbparam.put("sYear", param.getString("sYear"));   
		dbparam.put("sMonth", param.getString("sMonth"));   
		dbparam.put("eYear", param.getString("eYear"));   
		dbparam.put("eMonth", param.getString("eMonth"));   
		dbparam.put("amount", param.getString("amount"));   
		dbparam.put("qty", param.getString("qty"));   
		dbparam.put("misuSum", misuSum);   // 통합 (통합:0, 월별 :1)
		dbparam.put("jikyung", param.getString("jikyung"));  // 직영지로번호사용(사용:1)
		dbparam.put("noti", param.getString("noti"));  // 고객안내문
		dbparam.put("MK_JIRO_NUMBER",MK_JIRO_NUMBER); // 지로번호 상수
		dbparam.put("MK_APPROVAL_NUMBER",MK_APPROVAL_NUMBER); // 지로승인번호 상수

		dbparam.put("addrType",param.getString("addrType")); // 발행주소 구분 ( roadNm: 도로명주소, lotNo: 지번주소 - 박윤철 2014.2.3)
		
		List jikyungYn = generalDAO.queryForList("output.billOutput.getJikyung" , dbparam);  // 직영여부 조회
		List jikyungJiroYn = generalDAO.queryForList("output.billOutput.getJikyungJiro" , dbparam);  // 직영지로번호 사용여부 조회

		if(jikyungYn.size()!=0){
			if("1".equals(param.getString("jikyung")) || jikyungJiroYn.size()!=0){
				dbparam.put("jiroDv", "99");  // 직영지국이면서 직영지로번호인 '3146440' 사용시 고객조회번호 앞 2자리 99

			}else{
				dbparam.put("jiroDv", "98");  // 직영지국이면서 직영지로번호인 '3146440' 미사용시 고객조회번호 앞 2자리 98

			}
		}else{
			dbparam.put("jiroDv", "99");  // 직영이 아닐경우 고객조회번호 앞 2자리 99 

		}
		
		logger.debug("파람정보_READER / NEWS / SEQ : "+ param.getString("reader") + "/" + param.getString("news") + "/" + param.getString("seq") );		

		String[] yymm = getYYMM( param.getString("sYear"), param.getString("sMonth"),  param.getString("eYear"), param.getString("eMonth")  );
		
		try{
			if("0".equals(misuSum)){
				dbparam.put("yymm", yymm); 
				logger.debug("===== output.billOutput.insertBill");
				generalDAO.insert("output.billOutput.insertBill", dbparam);
				
			}else{
				for(int i=0 ; i<yymm.length ; i++){
					dbparam.put("yymm", yymm[i]); 
					logger.debug("배열값"+i+":" +yymm[i]);
						logger.debug("===== output.billOutput.insertBillMonth");
						generalDAO.insert("output.billOutput.insertBillMonth", dbparam);
				}
			}
			mav.addObject("message", "정상적으로 발행되었습니다.");
			
		}catch (Exception e){
			mav.addObject("message", "발행을 실패했습니다.");
			e.printStackTrace();
		}
		mav.setViewName("common/message");
		mav.addObject("returnURL", "/output/billOutput/eachView.do");

		return mav;
			
	}
	
	/**
	 * 시작년월과 종료년월 사이의 모든 월을 배열로 반환한다.
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String[] getYYMM(String startYYYY, String strtMM, String endYYYY,  String endMM) {
		
		int count = 1;
		int years = Integer.parseInt(endYYYY) - Integer.parseInt(startYYYY);
		int months = Integer.parseInt(endMM) - Integer.parseInt(strtMM);
		count = count + (years * 12) + months;

		String yymm[] = new String[count];
		int yearTmp = 1;
			for(int i=0 ; i < yymm.length ; i++ ){
				if(Integer.parseInt(strtMM)+i < 13){  // 시작년도의 월 추출
					if(Integer.parseInt(strtMM)+i<10){
						yymm[i] = startYYYY + "-0" + Integer.toString(Integer.parseInt(strtMM)+i);
					}else{
						yymm[i] = startYYYY + "-" + Integer.toString(Integer.parseInt(strtMM)+i);
					}
				}else{
					if(years >= yearTmp){  // 시작년도 이후의 년도별 월 추출
						if((Integer.parseInt(strtMM)+i)%12<10 && (Integer.parseInt(strtMM)+i)%12 != 0){
							yymm[i] =  Integer.toString(Integer.parseInt(startYYYY)+yearTmp) + "-0" + Integer.toString((Integer.parseInt(strtMM)+i)%12);
						}else{
							if((Integer.parseInt(strtMM)+i)%12==0){
								yymm[i] =  Integer.toString(Integer.parseInt(startYYYY)+yearTmp) +"-12";
								yearTmp++;
							}else{
								yymm[i] =  Integer.toString(Integer.parseInt(startYYYY)+yearTmp) + "-" + Integer.toString((Integer.parseInt(strtMM)+i)%12);
							}
						}
					}
				}
			}

		return yymm;
	}

	
	
	/**
	 * 개별영수증 발행내역 전체 삭제
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView deleteAllBill(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);		
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession(true);

		String serial = param.getString("serial");

		HashMap dbparam = new HashMap();
		dbparam.put("serial", serial); 
		
		logger.debug("파람정보 확인 SERIAL : "+serial);							
					
		try{
			logger.debug("===== output.billOutput.deleteAllBill");
			if(generalDAO.delete("output.billOutput.deleteAllBill", dbparam) > 0){
				mav.addObject("message", " 정상적으로 삭제 되었습니다.");
			}
		}catch (Exception e){
			    mav.addObject("message", "삭제를 실패했습니다.");
			    e.printStackTrace();
		}
	
		mav.setViewName("common/message");
		mav.addObject("returnURL", "/output/billOutput/eachView.do");
		
		return mav;
			
	}
	
	/**
	 * 고객안내문 팝업 호출
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView popCustNotiView(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);		
		HttpSession session = request.getSession(true);
			
		HashMap dbparam = new HashMap();
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		
		dbparam.put("userId", userId); 
		String code = param.getString("code");

		dbparam.put("userId", userId); 
		dbparam.put("code", code); 
		
		logger.debug("세션정보_UserID : "+ userId);		
		logger.debug("파람정보_Code : "+ code);		
		
		logger.debug("===== output.billOutput.getCustNotice");
		List noti = generalDAO.queryForList("output.billOutput.getCustNotice" , dbparam);  // 고객안내문  조회
		
		if(!"".equals(code) && code != null){
			logger.debug("===== output.billOutput.getCustNoticeDtl");
			Object notiDtl = generalDAO.queryForObject("output.billOutput.getCustNoticeDtl" , dbparam);  // 고객안내문  상세조회
			mav.addObject("notiDtl", notiDtl);
		}
		
		mav.addObject("noti", noti);
		
		mav.addObject("now_menu", MENU_CODE_OUTPUT);
		mav.setViewName("output/popCustNotice");
		return mav;

	}


	/**
	 * 고객안내문 수정
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView custNotiModify(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);		
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession(true);
		
		StringUtil utl = new StringUtil();
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		
		HashMap dbparam = new HashMap();
		dbparam.put("userId", userId); 
		dbparam.put("code", param.getString("code")); 
		dbparam.put("giro", param.getString("giro")); 
		dbparam.put("visit", param.getString("visit")); 
		
		logger.debug("세션정보_UserID : "+ userId);
		logger.debug("파람정보 확인 code / giro / visit : "+param.getString("code")+" / "+param.getString("giro") +" / "+param.getString("visit"));		
		logger.debug("===== output.billOutput.getCustNotice");
		
		// 구역번호 존재여부 확인
		List custCd = generalDAO.queryForList("output.billOutput.getCustNoticeCd" , dbparam);
		if(custCd.size()==0){
			mav.addObject("message", "존재하지 않는 고객안내문 코드 입니다.");
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/output/billOutput/popCustNotiView.do");
		}else{
			
			try{
				logger.debug("===== output.billOutput.updateCustNotice");
				if(generalDAO.update("output.billOutput.updateCustNotice", dbparam) > 0){
					mav.addObject("message", "정상적으로 수정 되었습니다.");
				}
			}catch (Exception e){
				    mav.addObject("message", "수정이 실패했습니다.");
				    e.printStackTrace();
			}
	
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/output/billOutput/popCustNotiView.do");
		
		}
		return mav;
						

	}



	/**
	 * 고객안내문 삭제
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView custNotiDelete(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);		
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession(true);
		
		StringUtil utl = new StringUtil();
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		String code = param.getString("code");
		
		HashMap dbparam = new HashMap();
		dbparam.put("userId", userId); 
		dbparam.put("code", code); 
		
		logger.debug("세션정보_UserID : "+ userId);
		logger.debug("파람정보 확인 Code : "+ code);		
		
		// 코드 존재여부 확인
		logger.debug("===== output.billOutput.getCustNoticeCd");
		List custCd = generalDAO.queryForList("output.billOutput.getCustNoticeCd" , dbparam);
		
		
		if(custCd.size()==0){
			mav.addObject("message", "존재하지 않는 고객안내문 코드입니다.");
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/output/billOutput/popCustNotiView.do");
		}else{							
					
			try{
				logger.debug("===== output.billOutput.deleteCustNotice");
				if(generalDAO.delete("output.billOutput.deleteCustNotice", dbparam) > 0){
					mav.addObject("message", code+"코드의 내용이 정상적으로 삭제 되었습니다.");
				}
			}catch (Exception e){
				    mav.addObject("message", "삭제를 실패했습니다.");
				    e.printStackTrace();
			}
	
		mav.setViewName("common/message");
		mav.addObject("returnURL", "/output/billOutput/popCustNotiView.do");
		}
		
		return mav;
			

	}
	
	/**
	 * 고객안내문 등록
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView custNotiInsert(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);		
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession(true);
		
		StringUtil utl = new StringUtil();
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		
		HashMap dbparam = new HashMap();
		dbparam.put("userId", userId); 
		dbparam.put("code", param.getString("code")); 
		dbparam.put("giro", param.getString("giro")); 
		dbparam.put("visit", param.getString("visit")); 
		
		logger.debug("세션정보_UserID : "+ userId);
		logger.debug("파람정보 확인 code / giro / visit : "+param.getString("code")+" / "+param.getString("giro") +" / "+param.getString("visit"));			
		
		// 코드 존재여부 확인
		logger.debug("===== output.billOutput.getCustNoticeCd");
		List custCd = generalDAO.queryForList("output.billOutput.getCustNoticeCd" , dbparam);
		if(custCd.size()>0){
			mav.addObject("message", "이미 등록된 코드번호 입니다.");
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/output/billOutput/popCustNotiView.do");
		}else{	
		
			try{
				logger.debug("===== output.billOutput.insertCustNotice");
				generalDAO.insert("output.billOutput.insertCustNotice", dbparam);
				mav.addObject("message", "정상적으로 등록 되었습니다.");
				
			}catch (Exception e){
				mav.addObject("message", "등록을 실패했습니다.");
				e.printStackTrace();
			}
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/output/billOutput/popCustNotiView.do");
		}
		return mav;
			
	}
	
	/**
	 * 지로영수증 인쇄
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ozGiroViewer(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();

		Param param = new HttpServletParam(request);		
		
		HttpSession session = request.getSession(true);
			
		HashMap dbparam = new HashMap();
		
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		logger.debug("세션정보_UserID : "+ userId);		

		// 매체구분
		String newsCdParam[] = new String[param.getInt("newsSize",0)];
		String newsCd = "";

		for(int i=0 ; i < newsCdParam.length ; i++ ){
			if(!"".equals(param.getString("news"+i)) && param.getString("news"+i) != null){
				newsCdParam[i] = param.getString("news"+i);
				newsCd = newsCd + "'" + param.getString("news"+i) + "',";
				logger.debug("로그 확인 newsCd["+i+"] : " + newsCdParam[i]);		
			}
		}
		newsCd = newsCd + "''" ;

		// 구독구분
		String readerParam[] = new String[param.getInt("readerSize",0)];
		String reader = "";
		
		for(int i=0 ; i < readerParam.length ; i++ ){
			if(!"".equals(param.getString("reader"+i)) && param.getString("reader"+i) != null){
				readerParam[i] = param.getString("reader"+i);
				reader = reader + "'" + param.getString("reader"+i) + "',";
				logger.debug("로그 확인 reader["+i+"] : " + readerParam[i]);		
			}
		}
		reader = reader + "''" ;

		// 수금방법
		String sugmParam[] = new String[param.getInt("sugmSize",0)];
		String sugm = "";
		
		for(int i=0 ; i < sugmParam.length ; i++ ){
			if(!"".equals(param.getString("sugm"+i)) && param.getString("sugm"+i) != null){
				sugmParam[i] = param.getString("sugm"+i);
				sugm = sugm + "'" + param.getString("sugm"+i) + "',";
				logger.debug("로그 확인 sugm["+i+"] : " + sugmParam[i]);		
			}
		}
		sugm = sugm + "''" ;
		
		// 구역
		String guyuk[] = new String[param.getInt("guyukSize",0)];
		String strt[] = new String[param.getInt("guyukSize",0)];
		String end[] = new String[param.getInt("guyukSize",0)];
		String guyukSql=" AND (";
		int j = param.getInt("guyukSize",0) -1 ;

		for(int i=0 ; i < guyuk.length ; i++ ){

			if(!"".equals(param.getString("guyuk"+i)) && param.getString("guyuk"+i) != null){
				guyuk[i] = param.getString("guyuk"+i);
				strt[i] = param.getString("strt"+guyuk[i]);
				end[i] = param.getString("end"+guyuk[i]);
				logger.debug("로그 확인 guyuk["+i+"] : " + guyuk[i]);		
				logger.debug("로그 확인 strt["+i+"] : " + strt[i]);		
				logger.debug("로그 확인 end["+i+"] : " + end[i]);		
				guyukSql = guyukSql + "(B.GNO = '"+ guyuk[i] +"' AND B.BNO BETWEEN LPAD('"+ strt[i] +"', 3, '0')  AND LPAD('"+ end[i] +"', 3, '0') ) OR";
			}
			
		}
		guyukSql = guyukSql + " (B.GNO = '')) ";
		logger.debug("로그 확인sql : " + guyukSql);	

		String prtCb = param.getString("prtCb");		
		String mm = prtCb.substring(4);
		String quarter = "N";
		
		if(mm.equals("03") || mm.equals("06") || mm.equals("09") || mm.equals("12") ){
			quarter = "Y";
		}
		
		mav.addObject("guyukSql", guyukSql); 
		
		mav.addObject("userId", userId); 
		mav.addObject("newsCd",newsCd);
		mav.addObject("reader",reader);
		mav.addObject("sugm",sugm);
		mav.addObject("prtCb", prtCb);      // 인쇄조건 날짜 YYYYMM
		mav.addObject("quarter", quarter);  // 분기수금대상 인쇄여부 (Y:포함, N:미포함)
		mav.addObject("prtCbAA", param.getString("prtCbAA"));  // 당월분 날짜 YYYYMM
		mav.addObject("prtCbAB", param.getString("prtCbAB"));  // 마감전출력여부 판단조건 YYYYMM (prtCb와 같으면 마감전출력)
		mav.addObject("misuPrt", param.getString("misuPrt")); // 미수인쇄여부 (포함:0, 제외 :1)
		mav.addObject("month", param.getString("month"));   // 미수개월수(1~12)
		mav.addObject("noti", param.getString("noti"));   // 고객안내문 
		mav.addObject("misuSum", param.getString("misuSum"));  // 미수통합 (통합:0, 월별 :1)
		mav.addObject("misuOnly", param.getString("misuOnly"));  // 미수만인쇄(미수만:1)
		mav.addObject("subs", param.getString("subs"));  // 신문명인쇄(인쇄:1)
		mav.addObject("jikyung", param.getString("jikyung"));  // 직영지로번호사용(사용:1)
		mav.addObject("MK_JIRO_NUMBER",MK_JIRO_NUMBER); // 지로번호 상수
		mav.addObject("MK_APPROVAL_NUMBER",MK_APPROVAL_NUMBER); // 지로승인번호 상수
		mav.addObject("addrType", param.getString("addrType"));  // 주소구분(도로명주소:roadNm, 지번주소:lotNo)
		
		System.out.println("addrType"+param.getString("addrType"));
		
		dbparam.put("userId", userId); 
		dbparam.put("MK_JIRO_NUMBER",MK_JIRO_NUMBER); // 지로번호 상수
		List jikyungYn = generalDAO.queryForList("output.billOutput.getJikyung" , dbparam);  // 직영여부 조회
		List jikyungJiroYn = generalDAO.queryForList("output.billOutput.getJikyungJiro" , dbparam);  // 직영지로번호 사용여부 조회

		if(jikyungYn.size()!=0){
			if("1".equals(param.getString("jikyung")) || jikyungJiroYn.size()!=0){
				mav.addObject("jiroDv", "99");  // 직영지국이면서 직영지로번호인 '3146440' 사용시 고객조회번호 앞 2자리 99

			}else{
				mav.addObject("jiroDv", "98");  // 직영지국이면서 직영지로번호인 '3146440' 미사용시 고객조회번호 앞 2자리 98

			}
		}else{
			mav.addObject("jiroDv", "99");  // 직영이 아닐경우 고객조회번호 앞 2자리 99 

		}
		
		mav.addObject("now_menu", MENU_CODE_OUTPUT_JIRO);

		// A3 사이즈		
		if("A3".equals(param.getString("pageSize"))){
			if("1".equals(param.getString("model"))){			
				mav.addObject("type","giroBill");  			// 한섬 XL-6100
			}else if("4".equals(param.getString("model"))){
				mav.addObject("type","giroBill3");			//교세라FS-6970
			}else{
				mav.addObject("type","giroBill2");  	    // 양재 글초롱 526CS
			}
		// A4 사이즈
		}else{
			if("1".equals(param.getString("model"))){			
				mav.addObject("type","giroBillA4");  		// 한섬 XL-6100
			}else if("4".equals(param.getString("model"))){
				mav.addObject("type","giroBillA4_3");		 //교세라FS-6970
			}else{
				mav.addObject("type","giroBillA4_2");  	    // 양재 글초롱 526CS
			}
		}
		
		mav.setViewName("output/ozGiroBill");
		
		return mav;

	}
	
	
	/**
	 * 방문영수증 인쇄
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ozVisitViewer(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();

		Param param = new HttpServletParam(request);		
		HttpSession session = request.getSession(true);
			
		HashMap dbparam = new HashMap();
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		logger.debug("세션정보_UserID : "+ userId);		

		// 매체구분
		String newsCdParam[] = new String[param.getInt("newsSize",0)];
		String newsCd = "";

		for(int i=0 ; i < newsCdParam.length ; i++ ){
			if(!"".equals(param.getString("news"+i)) && param.getString("news"+i) != null){
				newsCdParam[i] = param.getString("news"+i);
				newsCd = newsCd + "'" + param.getString("news"+i) + "',";
				logger.debug("로그 확인 newsCd["+i+"] : " + newsCdParam[i]);		
			}
		}
		newsCd = newsCd + "''" ;

		// 구독구분
		String readerParam[] = new String[param.getInt("readerSize",0)];
		String reader = "";
		
		for(int i=0 ; i < readerParam.length ; i++ ){
			if(!"".equals(param.getString("reader"+i)) && param.getString("reader"+i) != null){
				readerParam[i] = param.getString("reader"+i);
				reader = reader + "'" + param.getString("reader"+i) + "',";
				logger.debug("로그 확인 reader["+i+"] : " + readerParam[i]);		
			}
		}
		reader = reader + "''" ;

		// 수금방법
		String sugmParam[] = new String[param.getInt("sugmSize",0)];
		String sugm = "";
		
		for(int i=0 ; i < sugmParam.length ; i++ ){
			if(!"".equals(param.getString("sugm"+i)) && param.getString("sugm"+i) != null){
				sugmParam[i] = param.getString("sugm"+i);
				sugm = sugm + "'" + param.getString("sugm"+i) + "',";
				logger.debug("로그 확인 sugm["+i+"] : " + sugmParam[i]);		
			}
		}
		sugm = sugm + "''" ;
		
		// 구역
		String guyuk[] = new String[param.getInt("guyukSize",0)];
		String strt[] = new String[param.getInt("guyukSize",0)];
		String end[] = new String[param.getInt("guyukSize",0)];
		String guyukSql=" AND (";
		int j = param.getInt("guyukSize",0) -1 ;

		for(int i=0 ; i < guyuk.length ; i++ ){

			if(!"".equals(param.getString("guyuk"+i)) && param.getString("guyuk"+i) != null){
				guyuk[i] = param.getString("guyuk"+i);
				strt[i] = param.getString("strt"+guyuk[i]);
				end[i] = param.getString("end"+guyuk[i]);
				logger.debug("로그 확인 guyuk["+i+"] : " + guyuk[i]);		
				logger.debug("로그 확인 strt["+i+"] : " + strt[i]);		
				logger.debug("로그 확인 end["+i+"] : " + end[i]);		
				guyukSql = guyukSql + "(B.GNO = '"+ guyuk[i] +"' AND B.BNO BETWEEN LPAD('"+ strt[i] +"', 3, '0')  AND LPAD('"+ end[i] +"', 3, '0') ) OR ";
			}
			
		}
		guyukSql = guyukSql + " (B.GNO = '')) ";
		logger.debug("로그 확인sql : " + guyukSql);
		
		String prtCb = param.getString("prtCb");		
		String mm = prtCb.substring(4);
		String quarter = "N";
		
		if(mm.equals("03") || mm.equals("06") || mm.equals("09") || mm.equals("12") ){
			quarter = "Y";
		}
						
		mav.addObject("guyukSql", guyukSql); 
		
		mav.addObject("userId", userId); 
		mav.addObject("newsCd",newsCd);
		mav.addObject("reader",reader);
		mav.addObject("sugm",sugm);
		mav.addObject("prtCb", prtCb);      // 인쇄조건 날짜 YYYYMM
		mav.addObject("quarter", quarter);  // 분기수금대상 인쇄여부 (Y:포함, N:미포함)
		mav.addObject("misuPrt", param.getString("misuPrt")); // 미수인쇄여부 (포함:0, 제외 :1)
		mav.addObject("month", param.getString("month"));   // 미수개월수(1~12)
		mav.addObject("noti", param.getString("noti"));   // 고객안내문 
		mav.addObject("subs", param.getString("subs"));  // 신문명인쇄(인쇄:1)
		mav.addObject("misuSum", param.getString("misuSum"));  // 미수통합 (통합:0, 월별 :1)
		mav.addObject("misuOnly", param.getString("misuOnly"));  // 미수만인쇄(미수만:1)
		mav.addObject("remkPrt", param.getString("remkPrt"));  // 비고인쇄(인쇄포함:1)
		mav.addObject("all", param.getString("all"));  // 당월전체인쇄(인쇄:1)  -- 당월에한해 sugm ='044'가 아닌내역도 모두인쇄
		
		mav.addObject("addrType", param.getString("addrType"));  // 주소구분(도로명주소:roadNm, 지번주소:lotNo)

		logger.debug("userId"+userId);
		logger.debug("param.getString(prtCb)"+param.getString("prtCb"));
		logger.debug("param.getString(misuPrt)"+param.getString("misuPrt"));
		logger.debug("param.getString(month)"+param.getString("month"));
		logger.debug("param.getString(noti)"+param.getString("noti"));
		logger.debug("param.getString(misuSum)"+param.getString("misuSum"));
		logger.debug("param.getString(misuOnly)"+param.getString("misuOnly"));
		logger.debug("param.getString(remkPrt)"+param.getString("remkPrt"));
		logger.debug("param.getString(all)"+param.getString("all"));
		
		
		mav.addObject("now_menu", MENU_CODE_OUTPUT_VISIT);
		
		if("1".equals(param.getString("model"))){			
			mav.addObject("type","visitBill");  		// 한섬 XL-6100
		}else if("4".equals(param.getString("model"))){
			mav.addObject("type","visitBill3");  		// 교세라FS-6970
		}else{				
			mav.addObject("type","visitBill2");  	    // 양재 글초롱 526CS
		}
		
		mav.setViewName("output/ozVisitBill");
		
		return mav;

	}


	
	/**
	 * 방문영수증 인쇄(ABC용)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ozVisitViewer2(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();

		Param param = new HttpServletParam(request);		
		HttpSession session = request.getSession(true);
			
		HashMap dbparam = new HashMap();
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		logger.debug("세션정보_UserID : "+ userId);		

		// 매체구분
		String newsCdParam[] = new String[param.getInt("newsSize",0)];
		String newsCd = "";

		for(int i=0 ; i < newsCdParam.length ; i++ ){
			if(!"".equals(param.getString("news"+i)) && param.getString("news"+i) != null){
				newsCdParam[i] = param.getString("news"+i);
				newsCd = newsCd + "'" + param.getString("news"+i) + "',";
				logger.debug("로그 확인 newsCd["+i+"] : " + newsCdParam[i]);		
			}
		}
		newsCd = newsCd + "''" ;

		// 구독구분
		String readerParam[] = new String[param.getInt("readerSize",0)];
		String reader = "";
		
		for(int i=0 ; i < readerParam.length ; i++ ){
			if(!"".equals(param.getString("reader"+i)) && param.getString("reader"+i) != null){
				readerParam[i] = param.getString("reader"+i);
				reader = reader + "'" + param.getString("reader"+i) + "',";
				logger.debug("로그 확인 reader["+i+"] : " + readerParam[i]);		
			}
		}
		reader = reader + "''" ;

		// 수금방법
		String sugmParam[] = new String[param.getInt("sugmSize",0)];
		String sugm = "";
		
		for(int i=0 ; i < sugmParam.length ; i++ ){
			if(!"".equals(param.getString("sugm"+i)) && param.getString("sugm"+i) != null){
				sugmParam[i] = param.getString("sugm"+i);
				sugm = sugm + "'" + param.getString("sugm"+i) + "',";
				logger.debug("로그 확인 sugm["+i+"] : " + sugmParam[i]);		
			}
		}
		sugm = sugm + "''" ;
		
		// 구역
		String guyuk[] = new String[param.getInt("guyukSize",0)];
		String strt[] = new String[param.getInt("guyukSize",0)];
		String end[] = new String[param.getInt("guyukSize",0)];
		String guyukSql=" AND (";
		int j = param.getInt("guyukSize",0) -1 ;

		for(int i=0 ; i < guyuk.length ; i++ ){

			if(!"".equals(param.getString("guyuk"+i)) && param.getString("guyuk"+i) != null){
				guyuk[i] = param.getString("guyuk"+i);
				strt[i] = param.getString("strt"+guyuk[i]);
				end[i] = param.getString("end"+guyuk[i]);
				logger.debug("로그 확인 guyuk["+i+"] : " + guyuk[i]);		
				logger.debug("로그 확인 strt["+i+"] : " + strt[i]);		
				logger.debug("로그 확인 end["+i+"] : " + end[i]);		
				guyukSql = guyukSql + "(B.GNO = '"+ guyuk[i] +"' AND B.BNO BETWEEN LPAD('"+ strt[i] +"', 3, '0')  AND LPAD('"+ end[i] +"', 3, '0') ) OR ";
			}
			
		}
		guyukSql = guyukSql + " (B.GNO = '')) ";
		logger.debug("로그 확인sql : " + guyukSql);	
						
		String visitSndt = "";
		try{
			
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			dbparam.put("userId", userId); 
			dbparam.put("prtCb", param.getString("prtCb"));  // 인쇄조건 날짜 YYYYMM
			
			// 지국별 방문 출력일자 조회
			visitSndt = (String)generalDAO.getSqlMapClient().queryForObject("output.billOutput.getVisitSndt" , dbparam); 
			
			// 구독정보 임시테이블 해당지국 데이타 삭제
			generalDAO.getSqlMapClient().delete("output.billOutput.deleteTmpReader", dbparam);

			// 구독정보 해당월분독자 임시테이블에 데이타 등록
			dbparam.put("visitSndt", visitSndt); 
			generalDAO.getSqlMapClient().insert("output.billOutput.insertTmpReader", dbparam);
			
			// 구독정보 임시테이블중 중지독자 조회
			List stReader = generalDAO.getSqlMapClient().queryForList("output.billOutput.getStReader" , dbparam);  
						
			if ( stReader != null ) {
				for ( int i = 0; i < stReader.size(); i++ ) {
					Map readerMap = (Map) stReader.get(i);
					String readno = (String)readerMap.get("READNO");				// 독자번호
					String seq = (String)readerMap.get("SEQ");					// 시퀀스	
					dbparam.put("readno", readno);
					dbparam.put("seq", seq); 	
			
					// 구독정보 임시테이블중 중지독자 배달번호 수정 및 독자 부활
					generalDAO.getSqlMapClient().update("output.billOutput.updateStReader", dbparam);
				}
			}
			
			
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			
			// 배달번호 정렬			
				List gnoList = generalDAO.getSqlMapClient().queryForList("output.billOutput.reterieveGnoList", dbparam);
				
				for(int i=0; i < gnoList.size() ; i++){
					Map tem = (Map) gnoList.get(i);

					dbparam.put("gno", tem.get("GNO"));
					System.out.println("배달번호 정렬 :"+ userId + "지국 - " + tem.get("GNO"));
					generalDAO.getSqlMapClient().queryForObject("output.billOutput.deliverNumSort", dbparam);
				}
						
		}catch (Exception e){
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
		}finally{
			generalDAO.getSqlMapClient().endTransaction();
		}
		
		
		mav.addObject("guyukSql", guyukSql); 
		
		mav.addObject("userId", userId); 
		mav.addObject("newsCd",newsCd);
		mav.addObject("reader",reader);
		mav.addObject("sugm",sugm);
		mav.addObject("prtCb", param.getString("prtCb"));  // 인쇄조건 날짜 YYYYMM
		mav.addObject("misuPrt", param.getString("misuPrt")); // 미수인쇄여부 (포함:0, 제외 :1)
		mav.addObject("month", param.getString("month"));   // 미수개월수(1~12)
		mav.addObject("noti", param.getString("noti"));   // 고객안내문 
		mav.addObject("subs", param.getString("subs"));  // 신문명인쇄(인쇄:1)
		mav.addObject("misuSum", param.getString("misuSum"));  // 미수통합 (통합:0, 월별 :1)
		mav.addObject("misuOnly", param.getString("misuOnly"));  // 미수만인쇄(미수만:1)
		mav.addObject("remkPrt", param.getString("remkPrt"));  // 비고인쇄(인쇄포함:1)
		mav.addObject("all", param.getString("all"));  // 당월전체인쇄(인쇄:1)  -- 당월에한해 sugm ='044'가 아닌내역도 모두인쇄
		mav.addObject("visitSndt", visitSndt); // 출력일자
		
		mav.addObject("now_menu", MENU_CODE_OUTPUT_VISIT);
		
		// 월분별 구분자 (2011년 11월분까지 : 이전시스템, 2011년 12월분이후 => 신규시스템)
		
		int yearDv = Integer.parseInt(param.getString("prtCb"));
		
		if(yearDv>=201112){

			if("1".equals(param.getString("model"))){			
				mav.addObject("type","visitBill");  		// 한섬 XL-6100
			}else{				
				mav.addObject("type","visitBill2");  	    // 양재 글초롱 526CS
			}

		}else{
			if("1".equals(param.getString("model"))){			
				mav.addObject("type","visitBill_old");  		// 한섬 XL-6100
			}else{				
				mav.addObject("type","visitBill2_old");  	    // 양재 글초롱 526CS
			}
			
		}
		
		mav.setViewName("output/ozVisitBill2");
		
		return mav;

	}

	
	/**
	 * 개별영수증 - 지로 인쇄
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ozEachGiroViewer(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();

		Param param = new HttpServletParam(request);		
		HttpSession session = request.getSession(true);
			
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		logger.debug("세션정보_UserID : "+ userId);		
		
		if(!"".equals(param.getString("serial")) && null != param.getString("serial")){
			mav.addObject("serial", param.getString("serial"));  
		}else{
			mav.addObject("serial", userId);  
		}
		mav.addObject("subs", param.getString("subs"));  // 신문명인쇄(인쇄:1)
		logger.debug("param.getString(serial)"+param.getString("serial"));
		logger.debug("param.getString(subs)"+param.getString("subs"));
		
		mav.addObject("now_menu", MENU_CODE_OUTPUT_EACH);
		
		// A3 사이즈		
		if("A3".equals(param.getString("pageSize"))){
			if("1".equals(param.getString("model"))){			
				mav.addObject("type","eachGiroBill");  			// 한섬 XL-6100
			}else if("4".equals(param.getString("model"))){
				mav.addObject("type","eachGiroBill3");			//교세라 FS-6970
			}else{
				mav.addObject("type","eachGiroBill2");  	    // 양재 글초롱 526CS
			}
		// A4
		}else{
			if("1".equals(param.getString("model"))){			
				mav.addObject("type","eachGiroBillA4");  		// 한섬 XL-6100
			}else if("4".equals(param.getString("model"))){
				mav.addObject("type","eachGiroBillA4_3");		//교세라 FS-6970
			}else{				
				mav.addObject("type","eachGiroBillA4_2");  	    // 양재 글초롱 526CS
			}
		}
				
		mav.setViewName("output/ozEachGiroBill");
		
		return mav;

	}


	/**
	 * 개별영수증 - 방문 인쇄
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ozEachVisitViewer(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();

		Param param = new HttpServletParam(request);		
		HttpSession session = request.getSession(true);
			
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		logger.debug("세션정보_UserID : "+ userId);		
		
		if(!"".equals(param.getString("serial")) && null != param.getString("serial")){
			mav.addObject("serial", param.getString("serial"));  
		}else{
			mav.addObject("serial", userId);  
		}
		mav.addObject("subs", param.getString("subs"));  // 신문명인쇄(인쇄:1)
		logger.debug("param.getString(serial)"+param.getString("serial"));
		
		mav.addObject("now_menu", MENU_CODE_OUTPUT_EACH);
		
		if("1".equals(param.getString("model"))){			
			mav.addObject("type","eachVisitBill");  		// 한섬 XL-6100
		}else if("4".equals(param.getString("model"))){
			mav.addObject("type","eachVisitBill3");		 //교세라FS-6970
		}else{				
			mav.addObject("type","eachVisitBill2");  	    // 양재 글초롱 526CS
		}
		
		mav.setViewName("output/ozEachVisitBill");
		
		return mav;

	}
	
	
	/**
	 * 지대통지서 화면호출
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView jidaeView(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);		
		HttpSession session = request.getSession(true);
		
		request.setCharacterEncoding("utf-8");
			
		HashMap dbparam = new HashMap();
		List<Object> agencyAllList = new ArrayList();
		List<Object> yymmList = new ArrayList();
		HashMap yymmParam = new HashMap();
		
		String url = "";
		//지국코드 가져오기
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		
		//마지막 지대년월가져오기
		String lastYYMM = (String)generalDAO.queryForObject("management.jidae.getJidaeLastYymm");
				
		String opYYMM = param.getString("opYYMM", lastYYMM);
		
		//직영인지 청약인지 확인
		boolean directJikuk = false;
		if(userId.substring(0, 1).equals("5")) {
			directJikuk = true;
			url ="output/jidaeBillForDirect";
		} else {
			directJikuk = false;
			url = "output/jidaeBill";
		}
		
		//날짜가져오기**************************************
		Calendar cal = Calendar.getInstance();
		
		//현재달부터 일년날짜 계산
		String tmpYear = "";
		int intMonth2 =0;
		String tmpMonth = "";
		String tmpYYMM = "";
		for(int i=0;i<12;i++) {
			cal.add(cal.MONTH, -1);
			tmpYear = Integer.toString(cal.get(cal.YEAR));
			intMonth2 =cal.get(cal.MONTH)+1;
			if(intMonth2<10) {
				tmpMonth = "0"+Integer.toString(intMonth2);
			} else {
				tmpMonth = Integer.toString(intMonth2);
			}
			tmpYYMM =  tmpYear+tmpMonth;
			//yymmParam.put("yymm"+i, tmpYYMM);
			yymmList.add(tmpYYMM);
		}
		
		String printBoseq="";
		
		dbparam.put("boseq", userId);
		dbparam.put("yymm", opYYMM);
		
		//지대정보조회
		Map jidaerData = (Map)generalDAO.queryForObject("management.jidae.selectJidaeNoticeByJikuk", dbparam); 
		
		//지사여부체크
		String chkJisaYn = (String) generalDAO.queryForObject("management.jidae.chkJisaYn", dbparam);
		
		//지사일때만 지국조회
		if("Y".equals(chkJisaYn) && !directJikuk) { 
			//담당코드 가져오기
			String localCode = (String) generalDAO.queryForObject("management.jidae.selectLocalCode", dbparam);
			
			dbparam.put("localCode", localCode);
			//지국목록
			agencyAllList = generalDAO.queryForList("reader.common.agencyListByLocalCode", dbparam);// 지국 목록
			
			Map agencyListMap = null;
			
			//전체지국 출력용
			for(int i=0;i<agencyAllList.size();i++) {
				agencyListMap = (Map)agencyAllList.get(i);
				//printBoseq += "'"+agencyListMap.get("USERID")+"',";
				printBoseq += agencyListMap.get("USERID")+",";
				agencyListMap = null;
			}
			
			if(printBoseq.length() > 0) {
				printBoseq = printBoseq.substring(0, printBoseq.length()-1);
			}
		}
		
		mav.addObject("boseq", userId);
		mav.addObject("opYYMM", opYYMM);
		mav.addObject("jidaerData", jidaerData);
		mav.addObject("chkJisaYn", chkJisaYn);
		mav.addObject("agencyAllList" , agencyAllList);
		mav.addObject("printAllBoseq" , printBoseq);
		mav.addObject("yymmList" , yymmList);
		mav.addObject("now_menu", MENU_CODE_MANAGEMENT_JIDAE);
		mav.setViewName(url);
		return mav;

	}
	
	/**
	 * 지대통지서 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectJidaeView(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();

		HttpSession session = request.getSession(true);
		Param param = new HttpServletParam(request);
		HashMap dbparam = new HashMap();
		List<Object> agencyAllList = new ArrayList();
		List<Object> yymmList = new ArrayList();
		
		//지국코드 가져오기
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		
		//날짜가져오기**************************************
		Calendar cal = Calendar.getInstance();
			
		//현재달부터 일년날짜 계산
		String tmpYear = "";
		int intMonth2 =0;
		String tmpMonth = "";
		String tmpYYMM = "";
		for(int i=0;i<12;i++) {
			cal.add(cal.MONTH, -1);
			tmpYear = Integer.toString(cal.get(cal.YEAR));
			intMonth2 =cal.get(cal.MONTH)+1;
			if(intMonth2<10) {
				tmpMonth = "0"+Integer.toString(intMonth2);
			} else {
				tmpMonth = Integer.toString(intMonth2);
			}
			tmpYYMM =  tmpYear+tmpMonth;
			yymmList.add(tmpYYMM);
		}
		
		//parameters
		String boseq = param.getString("boseq");
		String chkJisaYn = param.getString("chkJisaYn");
		String opYYMM = param.getString("opYYMM");
		String printBoseq = "";
		
		dbparam.put("boseq", boseq);
		dbparam.put("yymm", opYYMM);
		
		//지대정보조회
		Map jidaerData = (Map)generalDAO.queryForObject("management.jidae.selectJidaeNoticeByJikuk", dbparam);
		
		if("Y".equals(chkJisaYn)) { //지사일때만 지국조회
			//담당코드 가져오기
			dbparam.put("boseq", userId);
			String localCode = (String) generalDAO.queryForObject("management.jidae.selectLocalCode", dbparam);
			
			dbparam.put("localCode", localCode);
			//지국목록
			agencyAllList = generalDAO.queryForList("reader.common.agencyListByLocalCode", dbparam);// 지국 목록
			
			Map agencyListMap = null;
			
			//전체지국 출력용
			for(int i=0;i<agencyAllList.size();i++) {
				agencyListMap = (Map)agencyAllList.get(i);
				//printBoseq += "'"+agencyListMap.get("USERID")+"',";
				printBoseq += agencyListMap.get("USERID")+",";
				agencyListMap = null;
			}
			
			printBoseq = printBoseq.substring(0, printBoseq.length()-1);
		}
		
		mav.addObject("boseq", boseq);
		mav.addObject("opYYMM" , opYYMM);
		mav.addObject("jidaerData", jidaerData);
		mav.addObject("chkJisaYn", chkJisaYn);
		mav.addObject("agencyAllList" , agencyAllList);
		mav.addObject("printAllBoseq" , printBoseq);
		mav.addObject("yymmList", yymmList);
		mav.addObject("now_menu", MENU_CODE_MANAGEMENT_JIDAE);
		mav.setViewName("output/jidaeBill");
		return mav;

	}
	
	/**
	 * 직영지국 지대통지서 조회
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectJidaeViewForDirect(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();

		HttpSession session = request.getSession(true);
		Param param = new HttpServletParam(request);
		HashMap dbparam = new HashMap();
		List<Object> agencyAllList = new ArrayList();
		List<Object> yymmList  = new ArrayList();
		
		//지국코드 가져오기
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		
		//날짜가져오기**************************************
		Calendar cal = Calendar.getInstance();

		//현재달부터 일년날짜 계산
		String tmpYear = "";
		int intMonth2 =0;
		String tmpMonth = "";
		String tmpYYMM = "";
		for(int i=0;i<12;i++) {
			cal.add(cal.MONTH, -1);
			tmpYear = Integer.toString(cal.get(cal.YEAR));
			intMonth2 =cal.get(cal.MONTH)+1;
			if(intMonth2<10) {
				tmpMonth = "0"+Integer.toString(intMonth2);
			} else {
				tmpMonth = Integer.toString(intMonth2);
			}
			tmpYYMM =  tmpYear+tmpMonth;
			yymmList.add(tmpYYMM);
		}
		
		//parameters
		String opYYMM = param.getString("opYYMM");
		String boseq = param.getString("boseq");
		
		dbparam.put("boseq", boseq);
		dbparam.put("yymm", opYYMM);
		
		//지대정보조회
		Map jidaerData = (Map)generalDAO.queryForObject("management.jidae.selectJidaeNoticeByJikuk", dbparam);
		
		mav.addObject("boseq", boseq);
		mav.addObject("opYYMM" , opYYMM);
		mav.addObject("jidaerData", jidaerData);
		mav.addObject("agencyAllList" , agencyAllList);
		mav.addObject("yymmList", yymmList);
		mav.addObject("now_menu", MENU_CODE_MANAGEMENT_JIDAE);
		mav.setViewName("output/jidaeBillForDirect");
		return mav;

	}
	
	
	
	/**
	 * 지대통지서 화면캡쳐
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView jidaeCapture(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();

		try {
			/*
			// 전체 화면 Capture
			BufferedImage screencapture = new Robot()
					.createScreenCapture(new Rectangle(Toolkit
							.getDefaultToolkit().getScreenSize()));

			//이미지 사이즈 지정
			screencapture = screencapture.getSubimage(100,100,850,750);
			*/
			
			BufferedImage screencapture = new Robot()
			.createScreenCapture(new Rectangle(Toolkit
					.getDefaultToolkit().getScreenSize()));

			//이미지 사이즈 지정
			screencapture = screencapture.getSubimage(100,100,850,750);
			
			// JPEG 저장.
			File file = new File(
					"C:/screencapture.jpg");
			ImageIO.write(screencapture, "jpg", file);
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		HttpSession session = request.getSession(true);
			
		HashMap dbparam = new HashMap();
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_AGENCY_USERID) );
		
		logger.debug("세션정보_UserID : "+ userId);		
		dbparam.put("userId", userId); 
		
		mav.addObject("userId", userId);
		
		mav.addObject("now_menu", MENU_CODE_OUTPUT_JIDAE);
		mav.setViewName("output/jidaeBill");
		return mav;
	}
	
	/** 
	 * 지국통지서 오즈출력
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ozJidaePrint(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		
		HashMap dbparam = new HashMap();
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession(true);
		
		try {
			String yymm = param.getString("opYYMM");
			String printBoseq = param.getString("printBoseq");
			
			dbparam.put("boseq", printBoseq); 
			dbparam.put("yymm", yymm);
			
			mav.addObject("now_menu", MENU_CODE_MANAGEMENT_JIDAE);
			mav.addObject("boseq" , printBoseq);
			mav.addObject("yymm" , yymm);
			mav.setViewName("output/ozJidae");
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return mav;
	}
	
}
