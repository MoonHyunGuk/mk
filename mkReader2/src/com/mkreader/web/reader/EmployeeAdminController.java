/*------------------------------------------------------------------------------
 * NAME : EmployeeAdminController 
 * DESC : 본사직원 구독 관리
 * Author : pspkj
 *----------------------------------------------------------------------------*/
package com.mkreader.web.reader;

import java.util.Calendar;
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
import org.springframework.web.servlet.view.RedirectView;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.DateUtil;
import com.mkreader.util.Paging;
import com.mkreader.util.StringUtil;

public class EmployeeAdminController extends MultiActionController implements
ISiteConstant, ICodeConstant {

	private GeneralDAO generalDAO;
	
	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}

	/**
	 * 본사 직원 리스트 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView retrieveEmployeeList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		
		try{
			HashMap dbparam = new HashMap();
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 20;
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			int totalCount = 0;

			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" , dbparam); //지국 리스트
			List employeeList = generalDAO.queryForList("reader.employeeAdmin.employeeList", dbparam);
			totalCount = generalDAO.count("reader.employeeAdmin.employeeListCount" , dbparam);
			
			mav.addObject("now_menu", MENU_CODE_READER_EMPLOYEE);
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 10));
			mav.addObject("employeeList" , employeeList);
			mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("count" , generalDAO.count("reader.employeeAdmin.employeeCount" , dbparam)) ;
			mav.setViewName("reader/employee/employeeList");
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
	 * 본사 직원 리스트 검색
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView searchEmployeeList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		
		try{
			HashMap dbparam = new HashMap();
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 20;
			int totalCount = 0;
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));

			dbparam.put("boSeq", param.getString("boSeq"));
			dbparam.put("searchKey", param.getString("searchKey"));
			dbparam.put("searchText", param.getString("searchText"));
			dbparam.put("status", param.getString("status"));
			
			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" , dbparam); //지국 리스트
			List searchEmployeeList = generalDAO.queryForList("reader.employeeAdmin.searchEmployeeList", dbparam);
			totalCount = generalDAO.count("reader.employeeAdmin.searchEmployeeListCount" , dbparam);

			mav.addObject("now_menu", MENU_CODE_READER_EMPLOYEE);
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 10));
			mav.addObject("param" , param);
			mav.addObject("employeeList" , searchEmployeeList);
			mav.addObject("agencyAllList" , agencyAllList);
			//mav.addObject("count" , generalDAO.count("reader.employeeAdmin.searchEmployeeCount" , dbparam));
			mav.setViewName("reader/employee/employeeList");
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
	 * 본사 직원 리스트 엑셀
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView employeeExcel(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		
		try{
			HashMap dbparam = new HashMap();
			dbparam.put("boSeq", param.getString("boSeq"));
			dbparam.put("searchKey", param.getString("searchKey"));
			dbparam.put("searchText", param.getString("searchText"));
			dbparam.put("status", param.getString("status"));
			System.out.println("asdfawerasdf");
			
			List employeeList = generalDAO.queryForList("reader.employeeAdmin.employeeExcel", dbparam);

			String fileName = "employeeList_(" + DateUtil.getCurrentDate("yyyyMMdd") + ").xls";
			//Excel response
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName); 
			response.setHeader("Content-Description", "JSP Generated Data");
			mav.addObject("employeeList" , employeeList);
			mav.setViewName("reader/employee/employeeExcel");
			
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
	 * 본사 직원 상세 정보
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView employeeInfo(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		
		try{
			HashMap dbparam = new HashMap();
			
			String flag = param.getString("flag");
			dbparam.put("boSeq", param.getString("boSeq"));
			dbparam.put("readNo", param.getString("readNo"));
			dbparam.put("newsCd", param.getString("newsCd"));
			dbparam.put("seq", param.getString("seq"));

			List areaCode = generalDAO.queryForList("reader.common.retrieveAreaCode" );// 전화번호 지역번호 조회
			List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" );// 핸도폰 앞자리 번호 조회
			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" , dbparam); //지국 리스트
			List employeeInfo = generalDAO.queryForList("reader.employeeAdmin.employeeInfo", dbparam);
			List company = generalDAO.queryForList("reader.common.retrieveCompany" , dbparam); //회사명조회
			List office = generalDAO.queryForList("reader.common.retrieveOffice" , dbparam); //부서명조회
			
			//메모리스트 조회
			dbparam.put("READNO", param.getString("readNo"));
			List memoList  = generalDAO.queryForList("util.memo.getMemoListByReadno" , dbparam);
			
			mav.addObject("param" , param);
			mav.addObject("office" , office);
			mav.addObject("company" , company);
			mav.addObject("employeeInfo" , employeeInfo);
			mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("mobileCode" , mobileCode);
			mav.addObject("areaCode" , areaCode);
			mav.addObject("memoList" , memoList);
			mav.addObject("flag" , flag);
			
			mav.setViewName("reader/employee/employeeInfo");
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
	 * 본사 직원 등록 폼
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView employeeEdit(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		
		try{
			HashMap dbparam = new HashMap();
			
			List areaCode = generalDAO.queryForList("reader.common.retrieveAreaCode" );// 전화번호 지역번호 조회
			List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" );// 핸도폰 앞자리 번호 조회
			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" , dbparam); //지국 리스트
			List company = generalDAO.queryForList("reader.common.retrieveCompany" , dbparam); //회사명조회
						
			mav.addObject("now_menu", MENU_CODE_READER_EMPLOYEE);
			mav.addObject("param" , param);
			mav.addObject("company" , company);
			mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("mobileCode" , mobileCode);
			mav.addObject("areaCode" , areaCode);
			mav.setViewName("reader/employee/employeeEdit");
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
	 * 회사명에 따른 부서명 셋팅 ajax
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView ajaxOfficeNm(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		try{
			HashMap dbparam = new HashMap();
			dbparam.put("resv1", param.getString("resv1"));
		
			List office = generalDAO.queryForList("reader.common.retrieveOffice" , dbparam); //부서명 리스트

			mav.addObject("office" , office);
			mav.setViewName("reader/employee/ajaxOfficeNm");
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
	 * 본사 직원 구독 정보 생성
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView SaveEmployee(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			HashMap dbparam = new HashMap();
			
			dbparam.put("newsCd" , MK_NEWSPAPER_CODE);
			dbparam.put("boSeq" , param.getString("boSeq"));
			dbparam.put("gno" , "300");
			dbparam.put("bno" , "000");
			dbparam.put("readTypeCd" , "016");
			dbparam.put("readNm" , param.getString("readNm"));
			dbparam.put("offiNm" , param.getString("offiNm"));
			dbparam.put("company" , param.getString("company"));
			dbparam.put("sabun" , param.getString("sabun"));
			dbparam.put("homeTel1" , param.getString("homeTel1"));
			dbparam.put("homeTel2" , param.getString("homeTel2"));
			dbparam.put("homeTel3" , param.getString("homeTel3"));
			dbparam.put("mobile1" , param.getString("mobile1"));
			dbparam.put("mobile2" , param.getString("mobile2"));
			dbparam.put("mobile3" , param.getString("mobile3"));
			dbparam.put("dlvZip" , param.getString("dlvZip1")+"-"+param.getString("dlvZip2"));
			dbparam.put("dlvAdrs1" , param.getString("dlvAdrs1"));
			dbparam.put("dlvAdrs2" , param.getString("dlvAdrs2"));
			dbparam.put("newaddr" , param.getString("newaddr"));
			dbparam.put("dlvStrNm" , param.getString("dlvStrNm"));
			dbparam.put("dlvStrNo" , param.getString("dlvStrNo"));
			dbparam.put("aptCd" , param.getString("aptCd"));
			dbparam.put("aptDong" , param.getString("aptDong"));
			dbparam.put("aptHo" , param.getString("aptHo"));
			dbparam.put("sgType" , "023");
			dbparam.put("sgInfo" , param.getString("sgInfo"));
			dbparam.put("sgTel1" , param.getString("sgTel1"));
			dbparam.put("sgTel2" , param.getString("sgTel2"));
			dbparam.put("sgTel3" , param.getString("sgTel3"));
			dbparam.put("uPrice" , Integer.parseInt(param.getString("qty"))*4500);
			dbparam.put("qty" , param.getString("qty"));
			dbparam.put("stQty" , param.getString("stQty"));
			dbparam.put("rsdTypeCd" , param.getString("rsdTypeCd"));
			dbparam.put("dlvTypeCd" , param.getString("dlvTypeCd"));
			dbparam.put("dlvPosiCd" , param.getString("dlvPosiCd"));
			dbparam.put("hjPathCd" , "004");
			dbparam.put("hjTypeCd" , param.getString("hjTypeCd"));
			dbparam.put("hjPsregCd" , param.getString("hjPsregCd"));
			dbparam.put("hjPsnm" , param.getString("hjPsnm"));
			dbparam.put("hjDt" , StringUtil.replace(param.getString("indt"), "-", ""));
			dbparam.put("indt" , StringUtil.replace(param.getString("indt"), "-", ""));
			dbparam.put("aplcDt" , StringUtil.replace(param.getString("indt"), "-", ""));
//			dbparam.put("sgBgmm" , this.getSgBgmm(DateUtil.getCurrentDate("yyyyMMdd")));
//			dbparam.put("sgBgmm" , DateUtil.getWantDay(DateUtil.getCurrentDate("yyyyMMdd"), 2, 1).substring(0,6));
			dbparam.put("sgEdmm" , param.getString("sgEdmm"));
			dbparam.put("sgCycle" , param.getString("sgCycle"));
			dbparam.put("stSayou" , param.getString("stSayou"));
			dbparam.put("aplcNo" , param.getString("aplcNo"));
			//dbparam.put("remk" , param.getString("remk"));
			dbparam.put("inps" , session.getAttribute(SESSION_NAME_ADMIN_USERID));
			dbparam.put("spgCd" , param.getString("spgCd"));
			dbparam.put("bnsBookCd" , param.getString("bnsBookCd"));
			dbparam.put("taskCd" , param.getString("taskCd"));
			dbparam.put("intFldCd" , param.getString("intFldCd"));
			dbparam.put("bidt" , param.getString("bidt"));
			dbparam.put("eMail" , param.getString("email"));
			dbparam.put("agency_serial", param.getString("boSeq"));
			
			String readNo = Integer.toString( generalDAO.count("reader.employeeAdmin.getReadNo" , dbparam));
			dbparam.put("readNo" ,  readNo);
			
			//통합독자생성
			generalDAO.getSqlMapClient().insert("reader.employeeAdmin.insertTmreader", dbparam); 
			//구독정보 생성
			generalDAO.getSqlMapClient().insert("reader.employeeAdmin.inserTmreaderNews", dbparam); 
					
			if(!("").equals(param.getString("remk"))) {	//null이 아닐때만 메모생성
				dbparam.put("READNO", readNo);
				dbparam.put("MEMO", param.getString("remk"));
				dbparam.put("CREATEID",  (String)session.getAttribute(SESSION_NAME_ADMIN_USERID));
				
				generalDAO.getSqlMapClient().insert("util.memo.insertMemo", dbparam); //메모생성
			}
			
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			
			/*
			mav.addObject("boSeqSerial", param.getString("boSeq"));
			mav.addObject("readNo", readNo);
			mav.addObject("newsCd", MK_NEWSPAPER_CODE);
			mav.addObject("seq", "0001");
			
			mav.setView(new RedirectView("/reader/employeeAdmin/employeeInfo.do"));
			*/
			return mav;
			
		}catch(Exception e){
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}finally{
			generalDAO.getSqlMapClient().endTransaction();
		}
	}
	
	/**
	 * 유가년월 조회
	 * @category 유가년월 조회
	 * @param String
	 * @return String
	 * @throws Exception
	 */
	
	public String getSgBgmm(String toDay){

		// 날짜 길이가 8 자리 인경우
		if (toDay.length() == 8){
			int year = Integer.parseInt(toDay.substring(0,4));
			int month = Integer.parseInt(toDay.substring(4,6));
			int day = Integer.parseInt(toDay.substring(6));

			// 현재 일이 15일 이후인 경우 당월+1
			if(day > 15){
				// 12월인 경우 당해+1, 유가월= 1월
				if(month == 12) {
					year = year + 1;
					month = 1;
				}else{
					month = month+1;
				}
			}
			
			// 해당 월 두자릿수로 변경
			String tmp_month = Integer.toString(month);
			if(tmp_month.length() < 2){
				tmp_month = "0"+ tmp_month;
			}
			
			// 유가년월 생성
			String result = Integer.toString(year) + tmp_month;
			
			System.out.println(result);
			
			return result;

		}else{
			throw new NumberFormatException("날짜 스트링의 길이가 8이 아닙니다.");
		}

	}
	
	/**
	 * 구독 중지
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView closeNews(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		try{
			HashMap dbparam = new HashMap();
			dbparam.put("readNo", param.getString("readNo"));
			generalDAO.update("reader.readerManage.closeNews", dbparam);//구독 해지
			
			mav.setView(new RedirectView("/reader/employeeAdmin/retrieveEmployeeList.do"));
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
	 * 본사 직원 구독 정보 수정
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView update(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			HashMap dbparam = new HashMap();
			
			dbparam.put("newsCd" , MK_NEWSPAPER_CODE);
			dbparam.put("seq" , param.getString("seq"));
			dbparam.put("readNo" , param.getString("readNo"));
			dbparam.put("boSeq" , param.getString("boSeq"));
			dbparam.put("gno" , "300");
			dbparam.put("bno" , "000");
			dbparam.put("readTypeCd" , "016");
			dbparam.put("readNm" , param.getString("readNm"));
			dbparam.put("offiNm" , param.getString("offiNm"));
			dbparam.put("company" , param.getString("company"));
			dbparam.put("sabun" , param.getString("sabun"));
			dbparam.put("homeTel1" , param.getString("homeTel1"));
			dbparam.put("homeTel2" , param.getString("homeTel2"));
			dbparam.put("homeTel3" , param.getString("homeTel3"));
			dbparam.put("mobile1" , param.getString("mobile1"));
			dbparam.put("mobile2" , param.getString("mobile2"));
			dbparam.put("mobile3" , param.getString("mobile3"));
			dbparam.put("dlvZip" , param.getString("dlvZip1")+param.getString("dlvZip2"));
			dbparam.put("dlvAdrs1" , param.getString("dlvAdrs1"));
			dbparam.put("dlvAdrs2" , param.getString("dlvAdrs2"));
			dbparam.put("newaddr" , param.getString("newaddr"));
			dbparam.put("bdMngNo" , param.getString("bdMngNo"));
			dbparam.put("dlvStrNm" , param.getString("dlvStrNm"));
			dbparam.put("dlvStrNo" , param.getString("dlvStrNo"));
			dbparam.put("aptCd" , param.getString("aptCd"));
			dbparam.put("aptDong" , param.getString("aptDong"));
			dbparam.put("aptHo" , param.getString("aptHo"));
			dbparam.put("sgType" , "023");
			dbparam.put("sgInfo" , param.getString("sgInfo"));
			dbparam.put("sgTel1" , param.getString("sgTel1"));
			dbparam.put("sgTel2" , param.getString("sgTel2"));
			dbparam.put("sgTel3" , param.getString("sgTel3"));
			dbparam.put("uPrice" , Integer.parseInt(param.getString("qty"))*4500);
			dbparam.put("qty" , param.getString("qty"));
			dbparam.put("stQty" , param.getString("stQty"));
			dbparam.put("rsdTypeCd" , param.getString("rsdTypeCd"));
			dbparam.put("dlvTypeCd" , param.getString("dlvTypeCd"));
			dbparam.put("dlvPosiCd" , param.getString("dlvPosiCd"));
			dbparam.put("hjPathCd" , "004");
			dbparam.put("hjTypeCd" , param.getString("hjTypeCd"));
			dbparam.put("hjPsregCd" , param.getString("hjPsregCd"));
			dbparam.put("hjPsnm" , param.getString("hjPsnm"));
			dbparam.put("hjDt" , StringUtil.replace(param.getString("indt"), "-", ""));
			dbparam.put("indt" , StringUtil.replace(param.getString("indt"), "-", ""));
			dbparam.put("aplcDt" , StringUtil.replace(param.getString("indt"), "-", ""));
//			if(Integer.parseInt(DateUtil.getCurrentDate("yyyyMMdd").substring(6,8)) <= 15){
//				dbparam.put("sgBgmm" , DateUtil.getCurrentDate("yyyyMMdd").substring(0,6));
//			}else{
//				dbparam.put("sgBgmm" , DateUtil.getWantDay(DateUtil.getCurrentDate("yyyyMMdd"), 2, 1).substring(0,6));	
//			}
			dbparam.put("sgEdmm" , param.getString("sgEdmm"));
			dbparam.put("sgCycle" , param.getString("sgCycle"));
			dbparam.put("stSayou" , param.getString("stSayou"));
			dbparam.put("aplcNo" , param.getString("aplcNo"));
			dbparam.put("remk" , param.getString("remk"));
			dbparam.put("inps" , session.getAttribute(SESSION_NAME_ADMIN_USERID));
			dbparam.put("chgps" , session.getAttribute(SESSION_NAME_ADMIN_USERID));
			dbparam.put("spgCd" , param.getString("spgCd"));
			dbparam.put("bnsBookCd" , param.getString("bnsBookCd"));
			dbparam.put("taskCd" , param.getString("taskCd"));
			dbparam.put("intFldCd" , param.getString("intFldCd"));
			dbparam.put("bidt" , param.getString("bidt"));
			dbparam.put("eMail" , param.getString("email"));
			dbparam.put("agency_serial", param.getString("boSeq"));
			
			if(param.getString("boSeq").equals(param.getString("oldBoseq"))) { //단순 수정
				generalDAO.getSqlMapClient().update("reader.employeeAdmin.updateTmreader", dbparam);//tm_reader 수정
				generalDAO.getSqlMapClient().update("reader.employeeAdmin.updateNews", dbparam);//tm_reader_news 수정
				mav.addObject("boSeqSerial", param.getString("boSeq"));
				mav.addObject("readNo", param.getString("readNo"));
				mav.addObject("newsCd", param.getString("newsCd"));
				mav.addObject("seq", param.getString("seq"));
				mav.setView(new RedirectView("/reader/employeeAdmin/employeeInfo.do"));
			} else { //지국 변경
				generalDAO.getSqlMapClient().update("reader.readerManage.closeNews", dbparam);//기존 데이터 구독 해지
				
				dbparam.put("readNo", generalDAO.count("reader.employeeAdmin.getReadNo" , dbparam));//독자번호 새로 생성
//				dbparam.put("sgBgmm", param.getString("sgBgmm"));//수금시작월 새로 셋팅
				dbparam.put("hjDt" , DateUtil.getCurrentDate("yyyyMMdd"));
				dbparam.put("indt" , DateUtil.getCurrentDate("yyyyMMdd"));
				dbparam.put("aplcDt" , DateUtil.getCurrentDate("yyyyMMdd"));
				
				generalDAO.getSqlMapClient().insert("reader.employeeAdmin.insertTmreader", dbparam); //통합독자생성
				generalDAO.getSqlMapClient().insert("reader.employeeAdmin.inserTmreaderNews", dbparam); //구독정보 생성
				
				mav.addObject("searchKey", "readnm");
				mav.addObject("searchText", param.getString("readNm"));
				mav.setView(new RedirectView("/reader/employeeAdmin/searchEmployeeList.do"));
			}
			
			//value param
			if(!("").equals(param.getString("remk"))) {	//null이 아닐때만 메모생성
				dbparam.put("READNO", param.getString("readNo"));
				dbparam.put("MEMO", param.getString("remk"));
				dbparam.put("CREATEID",  (String)session.getAttribute(SESSION_NAME_ADMIN_USERID));
				
				generalDAO.getSqlMapClient().insert("util.memo.insertMemo", dbparam); //메모생성
			}
			
			String addrChgYn = param.getString("addrChgYn");
					
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			return mav;
			
		} catch(Exception e) {
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		} finally {
			generalDAO.getSqlMapClient().endTransaction();
		}
	}
}