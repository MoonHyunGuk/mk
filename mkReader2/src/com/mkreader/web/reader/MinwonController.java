/*------------------------------------------------------------------------------
 * NAME : MinwonController 
 * DESC : 민원 관리
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

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class MinwonController extends MultiActionController implements
ISiteConstant, ICodeConstant {

	private GeneralDAO generalDAO;
	
	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}

	/**
	 * 민원(민원테이블) 팝업 오픈
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView popMinwon(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		ModelAndView mav = new ModelAndView();
		mav.setViewName("reader/minwon/pop_minwon");	
		return mav;
	}
	
	/**
	 * 민원(민원테이블)2 팝업 오픈(테스트중 박윤철 2012.09.05)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @category 민원등록창 호출
	 * @throws Exception
	 */
	public ModelAndView popMinwon2(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		HttpSession session = request.getSession();
		HashMap dbparam = new HashMap();
		
		dbparam.put("readno", param.getString("hiddenReadno"));
		dbparam.put("seq", param.getString("hiddenSeq"));
		dbparam.put("userid", session.getAttribute(SESSION_NAME_ADMIN_USERID));
		
		Map minwonBasicInfo = (Map) generalDAO.queryForObject("reader.minwon.getMinwonBasicInfo", dbparam);
		
		mav.addObject("minwonBasicInfo" , minwonBasicInfo);
		mav.setViewName("reader/pop_Minwon2");
		return mav;
	}
	
	/**
	 * 민원 등록(테스트중 박윤철 2012.09.10)
	 * 
	 * @param request
	 * @param response
	 * @return 민원등록
	 * @throws Exception
	 */
	public ModelAndView saveMinwon2(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		HttpSession session = request.getSession();
		HashMap dbparam = new HashMap();

		String[] array2 = (String[])param.getStringValues("minwoncd2");
		String minwonCd1 = "";
		String minwonCd2 = "";
		
		// 민원소분류
		for( int i = 0; i < array2.length ; i++ ){
			// 민원 대분류 추출
			if(minwonCd1.indexOf(array2[i].substring(0,1)) < 0 ){
				if("".equals(minwonCd1)){
					minwonCd1 += array2[i].substring(0,1);		
				}else{
					minwonCd1 += "^"+array2[i].substring(0,1);										
				}
			}
			// 민원 소분류 추출
			if(i > 0){
				minwonCd2 += "^"+array2[i];
			}else{
				minwonCd2 += array2[i];
			}
		}
		
		System.out.println("saveMinwon3>>"+minwonCd1+"/"+minwonCd2);
		mav.setViewName("reader/pop_minwon2");
		return mav;
	}

	/**
	 * 민원(민원테이블) 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView minwon(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		try{
			HashMap dbparam = new HashMap();
			dbparam.put("minGb", param.getString("minGb")); //민원 구분
			dbparam.put("isCheck", param.getString("isCheck")); // 지국 민원 처리 여부
			dbparam.put("sdate", param.getString("sdate")); // 조회 시작 년월
			dbparam.put("edate", param.getString("edate")); // 지회 끝 년월
			
			if( ! "1000".equals(session.getAttribute(SESSION_NAME_MENU_AUTH)  )){
				dbparam.put("agency_serial", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			}
			
			List minwonList = generalDAO.queryForList("reader.minwon.minwonList", dbparam);	
						
			mav.addObject("minwonList" , minwonList);
			mav.addObject("param" , param);
			
			mav.setViewName("reader/minwon/pop_minwon");	
			return mav;
			
		}catch(Exception e){
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	
	/**
	 * 민원(민원테이블) 처리
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView actionMinwon(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		HashMap dbparam = new HashMap();
		try{
			dbparam.put("boRemk", param.getString("boRemk"));
			dbparam.put("aplcDt", param.getString("aplcDt"));
			dbparam.put("aplcNo", param.getString("aplcNo"));
			dbparam.put("aplcTypeCd", param.getString("aplcTypeCd"));
			
			// 민원 처리
			int result = generalDAO.update("reader.minwon.actionMinwon", dbparam);	

			if(result != 0){
				mav.setViewName("common/message");
				mav.addObject("message", "정상 처리 되었습니다.");
				mav.addObject("returnURL","/reader/minwon/minwon.do");
				
			}
			
			return mav;
		}catch(Exception e){
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	
	/**
	 * 이전(이전테이블) 팝업 오픈
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView popRerocation(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		String agency_serial = "";
		if( ! "1000".equals(session.getAttribute(SESSION_NAME_MENU_AUTH)  )){
			agency_serial = (String) session.getAttribute(SESSION_NAME_AGENCY_SERIAL);
		}else{
			agency_serial = (String) session.getAttribute(SESSION_NAME_ADMIN_USERID);
		}
		HashMap dbparam = new HashMap();
		dbparam.put("agency_serial", agency_serial);
		List areaCode = generalDAO.queryForList("reader.common.retrieveAreaCode" , dbparam);// 전화번호 지역번호 조회
		List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" , dbparam);// 핸도폰 앞자리 번호 조회
		
		mav.addObject("areaCode" , areaCode);
		mav.addObject("mobileCode" , mobileCode);
		mav.addObject("today" , DateUtil.getCurrentDate("yyyyMMdd"));
		mav.addObject("agency_serial", agency_serial);
		mav.setViewName("reader/pop_rerocation");
		return mav;
	}
	
	/**
	 * 이전(이전테이블) 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView rerocation(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		try{
			HashMap dbparam = new HashMap();
			
			dbparam.put("boCnfmStat", param.getString("boCnfmStat")); // 이사전 지국 확인 상태
			dbparam.put("aoCnfmStat", param.getString("aoCnfmStat")); // 이사후 지국 확인 상태
			
			if( ! "1000".equals(session.getAttribute(SESSION_NAME_MENU_AUTH)  )){
				dbparam.put("agency_serial", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			}else{
				dbparam.put("agency_serial" ,session.getAttribute(SESSION_NAME_ADMIN_USERID));
			}
			
			List rerocationList = generalDAO.queryForList("reader.minwon.rerocationList", dbparam);	
			List areaCode = generalDAO.queryForList("reader.common.retrieveAreaCode" , dbparam);// 전화번호 지역번호 조회
			List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" , dbparam);// 핸도폰 앞자리 번호 조회
			
			mav.addObject("areaCode" , areaCode);
			mav.addObject("mobileCode" , mobileCode);
			mav.addObject("rerocationList" , rerocationList);
			mav.addObject("param" , param);
			mav.addObject("agency_serial", dbparam.get("agency_serial"));
			mav.setViewName("reader/pop_rerocation");
			return mav;
			
		}catch(Exception e){
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	/**
	 * 이전(이전테이블) 처리
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView saveRerocation(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		HashMap dbparam = new HashMap();
		try{
			if( ! "1000".equals(session.getAttribute(SESSION_NAME_MENU_AUTH)  )){
				dbparam.put("agency_serial", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			}else{
				dbparam.put("agency_serial" ,session.getAttribute(SESSION_NAME_ADMIN_USERID));
			}
			
			dbparam.put("regNo" , param.getString("regNo"));
			dbparam.put("readNo" , param.getString("readNo"));
			dbparam.put("newsCd" , param.getString("newsCd"));
			dbparam.put("aoName" , param.getString("aoName"));
			dbparam.put("boName" , param.getString("boName"));
			dbparam.put("boHomeTel1" , param.getString("boHomeTel1"));
			dbparam.put("boHomeTel2" , param.getString("boHomeTel2"));
			dbparam.put("boHomeTel3" , param.getString("boHomeTel3"));
			dbparam.put("boZip" , param.getString("boZip"));
			dbparam.put("regDt" , param.getString("regDt"));
			dbparam.put("boAdrs1" , param.getString("boAdrs1"));
			dbparam.put("boAdrs2" , param.getString("boAdrs2"));
			dbparam.put("boOffNm" , param.getString("boOffNm"));
			dbparam.put("readNm" , param.getString("readNm"));
			dbparam.put("boMobile1" , param.getString("boMobile1"));
			dbparam.put("boMobile2" , param.getString("boMobile2"));
			dbparam.put("boMobile3" , param.getString("boMobile3"));
			dbparam.put("moveDt" , param.getString("moveDt"));
			dbparam.put("boQty" , param.getString("boQty"));
			dbparam.put("boMsg" , param.getString("boMsg"));
			dbparam.put("aoHomeTel1" , param.getString("aoHomeTel1"));
			dbparam.put("aoHomeTel2" , param.getString("aoHomeTel2"));
			dbparam.put("aoHomeTel3" , param.getString("aoHomeTel3"));
			dbparam.put("dlvHpDt" , param.getString("dlvHpDt"));
			dbparam.put("stbgMm" , param.getString("stbgMm"));
			dbparam.put("aoZip" , param.getString("aoZip"));
			dbparam.put("aoMobile1" , param.getString("aoMobile1"));
			dbparam.put("aoMobile2" , param.getString("aoMobile2"));
			dbparam.put("aoMobile3" , param.getString("aoMobile3"));
			dbparam.put("aoAdrs1" , param.getString("aoAdrs1"));
			dbparam.put("aoAdrs2" , param.getString("aoAdrs2"));
			dbparam.put("aoOffNm" , param.getString("aoOffNm"));
			dbparam.put("aoQty" , param.getString("aoQty"));
			dbparam.put("aoMsg" , param.getString("aoMsg"));
			dbparam.put("aoCnfmStat" , param.getString("aoCnfmStat"));
			dbparam.put("aoCnfmDt" , param.getString("aoCnfmDt"));
			dbparam.put("boSeq" , param.getString("boSeq"));
			dbparam.put("aoSeq" , param.getString("aoSeq"));
			
			// 이전 신청 등록
			generalDAO.insert("reader.minwon.saveRerocation", dbparam);	
			
			mav.setView(new RedirectView("/reader/minwon/popRerocation.do"));
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
	 * 이전(이전테이블) 수정
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView updateRerocation(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		HashMap dbparam = new HashMap();
		try{
			if( ! "1000".equals(session.getAttribute(SESSION_NAME_MENU_AUTH)  )){
				dbparam.put("agency_serial", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			}else{
				dbparam.put("agency_serial" ,session.getAttribute(SESSION_NAME_ADMIN_USERID));
			}
			
			dbparam.put("regNo" , param.getString("regNo"));
			dbparam.put("readNo" , param.getString("readNo"));
			dbparam.put("newsCd" , param.getString("newsCd"));
			dbparam.put("aoName" , param.getString("aoName"));
			dbparam.put("boName" , param.getString("boName"));
			dbparam.put("boHomeTel1" , param.getString("boHomeTel1"));
			dbparam.put("boHomeTel2" , param.getString("boHomeTel2"));
			dbparam.put("boHomeTel3" , param.getString("boHomeTel3"));
			dbparam.put("boZip" , param.getString("boZip"));
			dbparam.put("regDt" , param.getString("regDt"));
			dbparam.put("boAdrs1" , param.getString("boAdrs1"));
			dbparam.put("boAdrs2" , param.getString("boAdrs2"));
			dbparam.put("boOffNm" , param.getString("boOffNm"));
			dbparam.put("readNm" , param.getString("readNm"));
			dbparam.put("boMobile1" , param.getString("boMobile1"));
			dbparam.put("boMobile2" , param.getString("boMobile2"));
			dbparam.put("boMobile3" , param.getString("boMobile3"));
			dbparam.put("moveDt" , param.getString("moveDt"));
			dbparam.put("boQty" , param.getString("boQty"));
			dbparam.put("boMsg" , param.getString("boMsg"));
			dbparam.put("aoHomeTel1" , param.getString("aoHomeTel1"));
			dbparam.put("aoHomeTel2" , param.getString("aoHomeTel2"));
			dbparam.put("aoHomeTel3" , param.getString("aoHomeTel3"));
			dbparam.put("dlvHpDt" , param.getString("dlvHpDt"));
			dbparam.put("stbgMm" , param.getString("stbgMm"));
			dbparam.put("aoZip" , param.getString("aoZip"));
			dbparam.put("aoMobile1" , param.getString("aoMobile1"));
			dbparam.put("aoMobile2" , param.getString("aoMobile2"));
			dbparam.put("aoMobile3" , param.getString("aoMobile3"));
			dbparam.put("aoAdrs1" , param.getString("aoAdrs1"));
			dbparam.put("aoAdrs2" , param.getString("aoAdrs2"));
			dbparam.put("aoOffNm" , param.getString("aoOffNm"));
			dbparam.put("aoQty" , param.getString("aoQty"));
			dbparam.put("aoMsg" , param.getString("aoMsg"));
			dbparam.put("aoCnfmStat" , param.getString("aoCnfmStat"));
			dbparam.put("aoCnfmDt" , param.getString("aoCnfmDt"));
			dbparam.put("boSeq" , param.getString("boSeq"));
			dbparam.put("aoSeq" , param.getString("aoSeq"));
			dbparam.put("gbn" , param.getString("gbn"));
			//gbn  1.인수거절 2.이전처리 3.인수거절 4.인수처리
			// 이전 신청 등록
			generalDAO.update("reader.minwon.updateRerocation", dbparam);	

			mav.setView(new RedirectView("/reader/minwon/popRerocation.do"));
			return mav;

		}catch(Exception e){
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	
	/**
	 * 통합독자검색
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @category 통합독자검색
	 * @throws Exception
	 */
	public ModelAndView integReaderSearch(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		try{
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 15;
			int totalCount = 0;

			HashMap dbparam = new HashMap();
			
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));

			// 조회조건세팅
			dbparam.put("AREA1", param.getString("area1"));					// 부서
			dbparam.put("AREA", param.getString("area"));					// 부서관할지역
			dbparam.put("AGENCYTYPE", param.getString("agencyType"));		// 지국구분
			dbparam.put("PART", param.getString("part"));					// 파트
			dbparam.put("AGENCYAREA", param.getString("agencyArea"));		// 지국지역
			dbparam.put("MANAGER", param.getString("manager"));				// 담당자
			dbparam.put("JIKUKNM", param.getString("jikukName"));			// 지국명

			dbparam.put("READTYPECD", param.getString("readTypCb"));		// 독자유형
			dbparam.put("SGTYPE", param.getString("sgTypeCb"));				// 수금방법
			dbparam.put("STATUS", param.getString("status"));				// 구독상태

			dbparam.put("DATETYPE", param.getString("dateType"));			// 조회기간유형
			dbparam.put("FROMDATE", StringUtil.replace(param.getString("fromDate"), "-", ""));			// 조회시작일
			dbparam.put("TODATE", StringUtil.replace(param.getString("toDate"), "-", ""));				// 조회종료일
			
			dbparam.put("NEWSCD", param.getString("newsCd"));					// 주소
			dbparam.put("ADDR", param.getString("addr"));					// 주소
			dbparam.put("SEARCHTYPE", param.getString("searchType"));		// 조회유형
			dbparam.put("SEARCHVALUE", param.getString("searchValue"));		// 조회값
			
			List readerList = generalDAO.queryForList("reader.minwon.getReaderList", dbparam);		// 독자조회			
			totalCount = generalDAO.count("reader.minwon.getReaderListCnt" , dbparam); 				// 조건별 전체 카운트 조회	
			
			List areaCb = generalDAO.queryForList("management.adminManage.getCode" , "002");  		// 부서 조회
			List areaCb2 = generalDAO.queryForList("management.adminManage.getCode" , "003");  		// 지역 조회
			List partCb = generalDAO.queryForList("management.adminManage.getCode" , "018");  		// 파트 조회
			List agencyTypeCb = generalDAO.queryForList("management.adminManage.getCode" , "017");  // 지국구분 조회
			List agencyAreaCb = generalDAO.queryForList("management.adminManage.getCode" , "019");  // 지역 조회
			List mngCb = generalDAO.queryForList("management.adminManage.getManager");  			// 담당자 조회
			List readTypCb = generalDAO.queryForList("management.adminManage.getCode", "115");		// 독자유형 조회
			List sgTypeCb = generalDAO.queryForList("management.adminManage.getCode", "119");		// 수금방법 조회
			List newsCb = generalDAO.queryForList("management.adminManage.getCode", "100");		    // 신문명 조회
			
			mav.addObject("param" , param);
			mav.addObject("readerList" , readerList);
			mav.addObject("totalCount" , totalCount);
			mav.addObject("areaCb", areaCb);
			mav.addObject("areaCb2", areaCb2);
			mav.addObject("partCb", partCb);
			mav.addObject("mngCb", mngCb);
			mav.addObject("agencyTypeCb", agencyTypeCb);
			mav.addObject("agencyAreaCb", agencyAreaCb);
			mav.addObject("readTypCb", readTypCb);
			mav.addObject("sgTypeCb", sgTypeCb);
			mav.addObject("newsCb", newsCb);
			
			mav.addObject("now_menu", MENU_CODE_READER);
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 10));
			mav.setViewName("reader/integrateReaderSearch");
			return mav;
		
		}catch(Exception e){
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	
	/**
	 * 통합독자검색
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @category 통합독자검색
	 * @throws Exception
	 */
	public ModelAndView selectTotalReaderSearch(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		// 현재날짜
		Calendar rightNow = Calendar.getInstance();
		String thisYear = String.valueOf(rightNow.get(Calendar.YEAR));
		String thisMonth = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));

		try{
			String searchValue = param.getString("searchValue");
			String searchType = param.getString("searchType");
			searchValue = searchValue.trim();
			searchType = searchType.trim();

			HashMap dbparam = new HashMap();
			
			dbparam.put("SEARCHVALUE", searchValue);		// 조회값
			dbparam.put("SEARCHTYPE", searchType);			// 조회값

			List newSList = generalDAO.queryForList("reader.common.retrieveNewsListForAdmin", dbparam);	//신문코드 조회
			List readTypeList = generalDAO.queryForList("reader.common.retrieveReaderType", dbparam);		//독자유형 조회
			List sgTypeList = generalDAO.queryForList("reader.common.retrieveSgType", dbparam);				//수금방법 조회
			List stSayouList = generalDAO.queryForList("reader.common.retrieveStSayou", dbparam);				//해지사유 조회
			
			List readerList = generalDAO.queryForList("reader.minwon.getTotalReaderSearch", dbparam);		// 독자조회			
			
			mav.addObject("readerList" , readerList);
			mav.addObject("readTypeList" , readTypeList);
			mav.addObject("sgTypeList" , sgTypeList);
			mav.addObject("newSList" , newSList);
			mav.addObject("stSayouList" , stSayouList);
			mav.addObject("searchType" , searchType);
			mav.addObject("searchValue" , searchValue);
			mav.addObject("thisYear" , thisYear);
			mav.addObject("thisMonth" , thisMonth);
			mav.setViewName("reader/minwon/integrateReaderSearch");
			return mav;
		
		}catch(Exception e){
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	
	/**
	 * 통합독자검색 화면 호출
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @category 통합독자검색 화면 호출
	 * @throws Exception
	 */
	public ModelAndView retrieveIntegReaderSearch(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		// 현재날짜
		Calendar rightNow = Calendar.getInstance();
		String thisYear = String.valueOf(rightNow.get(Calendar.YEAR));
		String thisMonth = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));

		try{
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 20;
			int totalCount = 0;
			
			HashMap dbparam = new HashMap();
			
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));

			List readTypCb = generalDAO.queryForList("management.adminManage.getCode", "115");//독자유형 조회
			List sgTypeCb = generalDAO.queryForList("management.adminManage.getCode", "119");//수금방법 조회
			List newsCb = generalDAO.queryForList("management.adminManage.getCode", "100");//신문코드 조회

			mav.addObject("param" , param);
			mav.addObject("readTypCb", readTypCb);
			mav.addObject("sgTypeCb", sgTypeCb);
			mav.addObject("newsCb", newsCb);
			
			mav.addObject("today" , DateUtil.getCurrentDate("yyyy-MM-dd"));
			
			mav.addObject("thisYear" , thisYear);
			mav.addObject("thisMonth" , thisMonth);
			mav.setViewName("reader/minwon/integrateReaderSearch");
			return mav;
		
		}catch(Exception e){
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	
	/**
	 * 지국명 자동완성 기능 (AJAX)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @category 지국명 자동완성 기능 (AJAX)
	 * @throws Exception
	 */
	public ModelAndView retrieveJikukAutocomplete(HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		request.setCharacterEncoding("utf-8");

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		try{
			
			HashMap dbparam = new HashMap();
			dbparam.put("JIKUKNAME", param.getString("jikukName"));					// 부서
			
			// 지국목록 조회
			List jikukList = generalDAO.queryForList("reader.minwon.getJikukList" , dbparam);  // 지국조회

			//쿼리 결과를 jsonArray로 만들어 준다
			JSONArray jsonArray = JSONArray.fromObject(jikukList);
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("jikukNamelist", jsonArray);
			
			//jsonArray를 jsonObject로 만들어 준다
			JSONObject jsonObject = JSONObject.fromObject(map);
			
			response.setContentType( "text/xml; charset=UTF-8" );
			
			//jsp로 값을 보낸다.
			response.getWriter().print(jsonObject);
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 통합독자검색 화면의 독자 상세정보 화면 호출
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @category 통합독자검색 화면의 독자 상세정보 화면 호출
	 * @throws Exception
	 */
	public ModelAndView popReaderDetailInfo(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		try{
			HashMap dbparam = new HashMap();
			
			int pageNo = param.getInt("detailPageNo", 1);
			int pageSize = 20;

			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));

			dbparam.put("SEARCHTYPE", "readno");		// 조회유형
			dbparam.put("SEARCHVALUE", param.getString("readno"));		// 조회값

			List readerList = generalDAO.queryForList("reader.minwon.getReaderList", dbparam);		// 독자조회
			
			String nowYYMM = (String)generalDAO.queryForObject("common.getLastSGYYMM", dbparam);//사용년월

			mav.addObject("nowYYMM" , nowYYMM);
			/*현재월 기준 수금 년월*/
			mav.addObject("lastyymm01" , DateUtil.getWantDay(nowYYMM+"01", 2, -23).substring(0, 6).substring(0, 6));
			mav.addObject("lastyymm02" , DateUtil.getWantDay(nowYYMM+"01", 2, -22).substring(0, 6).substring(0, 6));
			mav.addObject("lastyymm03" , DateUtil.getWantDay(nowYYMM+"01", 2, -21).substring(0, 6).substring(0, 6));
			mav.addObject("lastyymm04" , DateUtil.getWantDay(nowYYMM+"01", 2, -20).substring(0, 6).substring(0, 6));
			mav.addObject("lastyymm05" , DateUtil.getWantDay(nowYYMM+"01", 2, -19).substring(0, 6).substring(0, 6));
			mav.addObject("lastyymm06" , DateUtil.getWantDay(nowYYMM+"01", 2, -18).substring(0, 6).substring(0, 6));
			mav.addObject("lastyymm07" , DateUtil.getWantDay(nowYYMM+"01", 2, -17).substring(0, 6).substring(0, 6));
			mav.addObject("lastyymm08" , DateUtil.getWantDay(nowYYMM+"01", 2, -16).substring(0, 6).substring(0, 6));
			mav.addObject("lastyymm09" , DateUtil.getWantDay(nowYYMM+"01", 2, -15).substring(0, 6).substring(0, 6));
			mav.addObject("lastyymm10" , DateUtil.getWantDay(nowYYMM+"01", 2, -14).substring(0, 6).substring(0, 6));
			mav.addObject("lastyymm11" , DateUtil.getWantDay(nowYYMM+"01", 2, -13).substring(0, 6));
			mav.addObject("lastyymm12" , DateUtil.getWantDay(nowYYMM+"01", 2, -12).substring(0, 6));
			mav.addObject("nowyymm01" , DateUtil.getWantDay(nowYYMM+"01", 2, -11).substring(0, 6));
			mav.addObject("nowyymm02" , DateUtil.getWantDay(nowYYMM+"01", 2, -10).substring(0, 6));
			mav.addObject("nowyymm03" , DateUtil.getWantDay(nowYYMM+"01", 2, -9).substring(0, 6));
			mav.addObject("nowyymm04" , DateUtil.getWantDay(nowYYMM+"01", 2, -8).substring(0, 6));
			mav.addObject("nowyymm05" , DateUtil.getWantDay(nowYYMM+"01", 2, -7).substring(0, 6));
			mav.addObject("nowyymm06" , DateUtil.getWantDay(nowYYMM+"01", 2, -6).substring(0, 6));
			mav.addObject("nowyymm07" , DateUtil.getWantDay(nowYYMM+"01", 2, -5).substring(0, 6));
			mav.addObject("nowyymm08" , DateUtil.getWantDay(nowYYMM+"01", 2, -4).substring(0, 6));
			mav.addObject("nowyymm09" , DateUtil.getWantDay(nowYYMM+"01", 2, -3).substring(0, 6));
			mav.addObject("nowyymm10" , DateUtil.getWantDay(nowYYMM+"01", 2, -2).substring(0, 6));
			mav.addObject("nowyymm11" , DateUtil.getWantDay(nowYYMM+"01", 2, -1).substring(0, 6));
			mav.addObject("nowyymm12" , nowYYMM);
			mav.addObject("nextyymm01" , DateUtil.getWantDay(nowYYMM+"01", 2, 1).substring(0, 6));
			mav.addObject("nextyymm02" , DateUtil.getWantDay(nowYYMM+"01", 2, 2).substring(0, 6));
			mav.addObject("nextyymm03" , DateUtil.getWantDay(nowYYMM+"01", 2, 3).substring(0, 6));
			mav.addObject("nextyymm04" , DateUtil.getWantDay(nowYYMM+"01", 2, 4).substring(0, 6));
			mav.addObject("nextyymm05" , DateUtil.getWantDay(nowYYMM+"01", 2, 5).substring(0, 6));
			mav.addObject("nextyymm06" , DateUtil.getWantDay(nowYYMM+"01", 2, 6).substring(0, 6));
			mav.addObject("nextyymm07" , DateUtil.getWantDay(nowYYMM+"01", 2, 7).substring(0, 6));
			mav.addObject("nextyymm08" , DateUtil.getWantDay(nowYYMM+"01", 2, 8).substring(0, 6));
			mav.addObject("nextyymm09" , DateUtil.getWantDay(nowYYMM+"01", 2, 9).substring(0, 6));
			mav.addObject("nextyymm10" , DateUtil.getWantDay(nowYYMM+"01", 2, 10).substring(0, 6));
			mav.addObject("nextyymm11" , DateUtil.getWantDay(nowYYMM+"01", 2, 11).substring(0, 6));
			mav.addObject("nextyymm12" , DateUtil.getWantDay(nowYYMM+"01", 2, 12).substring(0, 6));

			mav.addObject("flag" , "1");
			mav.addObject("param" , param);
			mav.addObject("readerList" , readerList);
			mav.setViewName("reader/retrieveReaderDetilInfo");
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
	 * 민원리스트 화면 호출 및 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @category 민원리스트 화면 호출 및 조회
	 * @throws Exception
	 */
	public ModelAndView retrieveMinwonList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		//현재날짜
		Calendar rightNow = Calendar.getInstance();
		
		String year = String.valueOf(rightNow.get(Calendar.YEAR));
		String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));

		if (month.length() < 2){
			month = "0" + month;
		}
		if (day.length() < 2){
			day = "0" + day;
		}

		String fromDate= param.getString("fromDate", year + "-" + month + "-" + day);		//기간 from
		String toDate= param.getString("toDate", year + "-" + month + "-" + day);				//기간 to
		
		try{
			HashMap dbparam = new HashMap();
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 13;
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			dbparam.put("fromDate", StringUtil.replace(fromDate, "-", ""));
			dbparam.put("toDate", StringUtil.replace(toDate, "-", ""));
			dbparam.put("search_value", param.getString("search_value"));
			dbparam.put("search_type", param.getString("search_type"));
			
			int minwonCnt = 0;
			int totalCnt = 0;

			List minwonList = generalDAO.queryForList("reader.minwon.getMinwonList" , dbparam); // 민원 리스트
			minwonCnt = generalDAO.count("reader.minwon.getMinwonListCount" , dbparam);
			totalCnt = generalDAO.count("reader.minwon.getMinwonTotalCount" , dbparam);
			
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, minwonCnt, pageSize, 12));
			mav.addObject("minwonList", minwonList);
			mav.addObject("fromDate", fromDate);
			mav.addObject("toDate", toDate);
			mav.addObject("param", param);
			mav.addObject("totalCnt", totalCnt);
			mav.addObject("minwonCnt", minwonCnt);
			mav.addObject("now_menu", MENU_CODE_COMPLAIN);
			mav.setViewName("reader/minwon/minwonList");
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
	 * 민원 등록
	 * 
	 * @param request
	 * @param response
	 * @return 민원등록
	 * @throws Exception
	 */
	public ModelAndView saveMinwon(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		HttpSession session = request.getSession();
		
		//현재날짜
		Calendar rightNow = Calendar.getInstance();
		
		String year = String.valueOf(rightNow.get(Calendar.YEAR));
		String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));

		if (month.length() < 2){
			month = "0" + month;
		}
		if (day.length() < 2){
			day = "0" + day;
		}

		String fromDate= param.getString("fromDate", year + "-" + month + "-" + day);		//기간 from
		String toDate= param.getString("toDate", year + "-" + month + "-" + day);				//기간 to
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
		
			HashMap dbparam = new HashMap();
			
			// 파라미터 세팅
			dbparam.put("readNm", param.getString("readNm"));
			dbparam.put("addr", param.getString("addr"));
			dbparam.put("telNo", param.getString("telNo").replace("-", "") );
			dbparam.put("minwonCd1", param.getString("minwonCd1"));
			dbparam.put("minwonCd2", param.getString("minwonCd2"));
			dbparam.put("boseq", param.getString("boseq"));
			dbparam.put("callPs", param.getString("callPs"));
			
			dbparam.put("callTm", param.getString("callTm1")+param.getString("callTm2"));
			dbparam.put("minwonDesc", param.getString("minwonDesc"));
			
			// 민원번호가 없으면 신규(insert)
			if("".equals(param.getString("minwonNo"))){
				dbparam.put("inps", session.getAttribute(SESSION_NAME_ADMIN_USERID));
				generalDAO.getSqlMapClient().insert("reader.minwon.insertMinwon" , dbparam);
			// 민원번호가 있으면 수정(update)
			}else{
				dbparam.put("minwonNo", param.getString("minwonNo"));
				dbparam.put("minwonDt", param.getString("minwonDt"));
				dbparam.put("spcialYn", param.getString("spcialYn"));
				dbparam.put("chgPs", session.getAttribute(SESSION_NAME_ADMIN_USERID));
				generalDAO.getSqlMapClient().update("reader.minwon.updateMinwon" , dbparam);
			}
			generalDAO.getSqlMapClient().getCurrentConnection().commit();

			// 목록 조회
			dbparam.put("PAGE_NO", 1);
			dbparam.put("PAGE_SIZE", 13);
			dbparam.put("fromDate", StringUtil.replace(fromDate, "-", ""));
			dbparam.put("toDate", StringUtil.replace(toDate, "-", ""));
			dbparam.put("search_value", param.getString("search_value"));
			dbparam.put("search_type", param.getString("search_type"));
			
			int minwonCnt = 0;
			int totalCnt = 0;

			List minwonList = generalDAO.queryForList("reader.minwon.getMinwonList" , dbparam); // 민원 리스트
			minwonCnt = generalDAO.count("reader.minwon.getMinwonListCount" , dbparam);
			totalCnt = generalDAO.count("reader.minwon.getMinwonTotalCount" , dbparam);
			
			mav.addObject("pageInfo", Paging.getPageMap(1, minwonCnt, 13, 13));
			mav.addObject("minwonList", minwonList);
			mav.addObject("fromDate", fromDate);
			mav.addObject("toDate", toDate);
			mav.addObject("minwonCnt", minwonCnt);
			mav.addObject("totalCnt", totalCnt);
			mav.addObject("now_menu", MENU_CODE_READER);
			mav.setViewName("reader/minwon/minwonList");
			
			return mav;
		}catch(Exception e){
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}finally{
			generalDAO.getSqlMapClient().endTransaction();
		}
	}

	/**
	 * 민원 리스트 출력(Oz)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ozMinwonList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);		
		HttpSession session = request.getSession(true);
		HashMap dbparam = new HashMap();

		mav.addObject("userId", session.getAttribute(SESSION_NAME_ADMIN_USERID));
		mav.addObject("fromDate", StringUtil.replace(param.getString("fromDate"), "-", ""));
		mav.addObject("toDate", StringUtil.replace(param.getString("toDate"), "-", ""));
		mav.addObject("search_value", param.getString("search_value"));
		mav.addObject("search_type", param.getString("search_type"));
		
		mav.addObject("morningWorker", param.getString("morningWorker"));
		mav.addObject("lunchWorker", param.getString("lunchWorker"));
		mav.addObject("dinnerWorker", param.getString("dinnerWorker"));

		mav.setViewName("reader/oz/ozMinwonList");
		return mav;
	}
	
	/**
	 * 민원 보고서 출력(Oz)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ozMinwonDetail(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);		
		HttpSession session = request.getSession(true);
		HashMap dbparam = new HashMap();

		mav.addObject("minwonDt", param.getString("minwonDt"));
		mav.addObject("minwonNo", param.getString("minwonNo"));
		
		System.out.println("minwonDt"+param.getString("minwonDt")+"/"+param.getString("minwonNo"));
		mav.setViewName("reader/oz/ozMinwonDetail");
		return mav;
	}

	/**
	 * 민원 상세 구분 조회(ajax)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @category  민원 상세 구분 조회(ajax)
	 * @throws Exception
	 */
	public ModelAndView retrieveMinwonCd2List (HttpServletRequest request,
			HttpServletResponse response) throws Exception{

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		try{
			HashMap dbparam = new HashMap();

			dbparam.put("minwonCd1" , param.getString("minwonCd1"));
			List minwonCd2List = generalDAO.queryForList("reader.minwon.getMinwonCd2", dbparam);

			JSONArray jsonArray = JSONArray.fromObject(minwonCd2List);
			
			//쿼리 결과를 jsonArray로 만들어 준다
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("minwonCd2List", jsonArray);
			
			//jsonArray를 jsonObject로 만들어 준다
			JSONObject jsonObject = JSONObject.fromObject(map);

			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
		
	}

	/**
	 * 민원 삭제
	 * 
	 * @param request
	 * @param response
	 * @return 민원삭제
	 * @throws Exception
	 */
	public ModelAndView deleteMinwon(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		HttpSession session = request.getSession();
		
		String fromDate= param.getString("fromDate");		//기간 from
		String toDate= param.getString("toDate");			//기간 to
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
		
			HashMap dbparam = new HashMap();
			
			// 파라미터 세팅
			dbparam.put("minwonNo", param.getString("minwonNo"));
			dbparam.put("minwonDt", param.getString("minwonDt"));
			dbparam.put("chgPs", session.getAttribute(SESSION_NAME_ADMIN_USERID));
			
			generalDAO.getSqlMapClient().delete("reader.minwon.deleteMinwon" , dbparam);
			
			generalDAO.getSqlMapClient().getCurrentConnection().commit();

			// 목록 조회
			dbparam.put("PAGE_NO", 1);
			dbparam.put("PAGE_SIZE", 13);
			dbparam.put("fromDate", StringUtil.replace(fromDate, "-", ""));
			dbparam.put("toDate", StringUtil.replace(toDate, "-", ""));
			dbparam.put("search_value", param.getString("search_value"));
			dbparam.put("search_type", param.getString("search_type"));
			
			int totalCount = 0;

			List minwonList = generalDAO.queryForList("reader.minwon.getMinwonList" , dbparam); // 민원 리스트
			totalCount = generalDAO.count("reader.minwon.getMinwonListCount" , dbparam);
			
			mav.addObject("pageInfo", Paging.getPageMap(1, totalCount, 13, 13));
			mav.addObject("minwonList", minwonList);
			mav.addObject("fromDate", fromDate);
			mav.addObject("toDate", toDate);
			mav.addObject("now_menu", MENU_CODE_READER);
			mav.setViewName("reader/minwon/minwonList");
			
			return mav;
		}catch(Exception e){
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}finally{
			generalDAO.getSqlMapClient().endTransaction();
		}
	}
	

	/**
	 * 통합독자검색 화면의 독자 상세정보 조회(ajax)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @category 통합독자검색 화면의 독자 상세정보 조회(ajax)
	 * @throws Exception
	 */
	public ModelAndView ajaxDetailReaderInfo (HttpServletRequest request,
			HttpServletResponse response) throws Exception{
			
		request.setCharacterEncoding("utf-8");

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		try{
			HashMap dbparam = new HashMap();

			dbparam.put("readNo" , param.getString("readNo"));
			dbparam.put("newsCd" , param.getString("newsCd"));
			dbparam.put("seq" , param.getString("seq"));
			
			Map readerInfo = (Map)generalDAO.queryForObject("reader.minwon.getReaderInfo", dbparam);

			List callLog = generalDAO.queryForList("reader.minwon.getCallLog", dbparam);
			
			//메모조회
			dbparam.put("READNO" , param.getString("readNo"));
			List memoList = generalDAO.queryForList("util.memo.getMemoListByReadno", dbparam);
			System.out.println("memoList = "+memoList);
			
			JSONObject jsonObject = new JSONObject();
			
			jsonObject.put("readerInfo", JSONObject.fromObject(readerInfo));		
			jsonObject.put("callLog", JSONArray.fromObject(callLog));
			jsonObject.put("memoList", JSONArray.fromObject(memoList));
			
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 독자 생성(수정)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView updateReaderData(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HashMap dbparam = new HashMap();
		HttpSession session = request.getSession();
		
		//구독정보 생성을 위한 정보
		dbparam.put("readNo" , param.getString("readNo"));
		dbparam.put("newsCd" , param.getString("newsCd"));
		dbparam.put("seq" , param.getString("seq"));
		dbparam.put("boSeq" , param.getString("boSeq"));
		dbparam.put("gno" , param.getString("gno"));
		dbparam.put("readTypeCd" , param.getString("readTypeCd"));
		dbparam.put("readNm" , param.getString("readNm"));
		dbparam.put("homeTel1" , param.getString("homeTel1"));
		dbparam.put("homeTel2" , param.getString("homeTel2"));
		dbparam.put("homeTel3" , param.getString("homeTel3"));
		dbparam.put("mobile1" , param.getString("mobile1"));
		dbparam.put("mobile2" , param.getString("mobile2"));
		dbparam.put("mobile3" , param.getString("mobile3"));
		dbparam.put("dlvZip" , param.getString("dlvZip"));
		dbparam.put("dlvAdrs1" , param.getString("dlvAdrs1"));
		dbparam.put("dlvAdrs2" , param.getString("dlvAdrs2"));
		dbparam.put("sgType" , param.getString("sgType"));
		dbparam.put("uPrice" , param.getString("uPrice"));
		dbparam.put("qty" , param.getString("qty"));
		dbparam.put("sgBgmm" , StringUtil.replace(param.getString("sgBgmm"), "-", ""));
		dbparam.put("stdt" , StringUtil.replace(param.getString("stdt"), "-", ""));
		dbparam.put("stSayou" , param.getString("stSayou"));
		dbparam.put("agency_serial", param.getString("boSeq"));
		dbparam.put("chgPs" , session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
		
		//자동이체 등록을 위한 정보
		dbparam.put("userName" , param.getString("readNm"));
		dbparam.put("phone" , param.getString("homeTel1")+"-"+param.getString("homeTel2")+"-"+param.getString("homeTel3"));
		dbparam.put("zip1" , "");
		dbparam.put("zip2" , "");
		dbparam.put("addr1" , param.getString("dlvAdrs1"));
		dbparam.put("addr2" , param.getString("dlvAdrs2"));
		dbparam.put("newaddr" , param.getString("newaddr"));
		dbparam.put("bdMngNo" , param.getString("bdMngNo"));
		dbparam.put("realJikuk" , dbparam.get("boSeq"));
		dbparam.put("busu" , param.getString("qty"));
		dbparam.put("handy" , param.getString("mobile1")+"-"+param.getString("mobile2")+"-"+param.getString("mobile3") );
		dbparam.put("email" , param.getString("eMail"));
		dbparam.put("whoStep" , "2");
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			generalDAO.getSqlMapClient().insert("reader.readerManage.insertreaderHist", dbparam); //구독정보히스토리 업데이트
			
			if("".equals(param.getString("stdt"))) { //단순 구독정보 수정
				System.out.println("단순 구독정보 수정(독자번호="+param.getString("readNo")+")");
				generalDAO.getSqlMapClient().update("reader.readerManage.updateTmreaderNews", dbparam);	//구독정보 수정
			} else { //독자중지
				// 부수와 중지부수가 같으면 해지일자 해지사유 배달번호999로 수정
				if(param.getString("qty").equals(param.getString("stQty"))){
					System.out.println("독자중지 부수와 중지부수가 같으면(독자번호="+param.getString("readNo")+")");
					generalDAO.getSqlMapClient().update("reader.readerManage.updateTmreaderNews", dbparam);	//구독정보 수정
					generalDAO.getSqlMapClient().update("reader.readerManage.updateTmreaderEdu", dbparam);	//교육용 독자정보 수정
				}else{
					// 부수와 중지부수가 다르면 다부수 해지 처리.... 해지되는거 만큼 중지데이터 신규로 만들고 기존 부수를 수정
					System.out.println("독자중지 부수와 중지부수가 다르면(독자번호="+param.getString("readNo")+")");
					generalDAO.getSqlMapClient().insert("reader.readerManage.inserStTmreaderNews", dbparam); //다부수 중지 구독정보 생성
					generalDAO.getSqlMapClient().update("reader.readerManage.updateTmreaderNews", dbparam);	//구독정보 수정
				}
			}
			
			//수금정보 컨트롤
			List collectionList = generalDAO.queryForList("collection.collection.collectionList", dbparam);//수금정보 조회

			for(int i=1 ; i <13 ; i++ ){
				dbparam.put("lossAmt", "");//초기화
				String index="";
				if(i<10){
					index = '0'+Integer.toString(i);
				}else{
					index = Integer.toString(i);
				}

				/** 현재수금처리 */
				if(!"".equals(dbparam.get("nowSnDt"+index)) || !"".equals(dbparam.get("nowBillAmt"+index)) || !"".equals(dbparam.get("nowAmt"+index)) || !"".equals(dbparam.get("nowSgbbCd"+index))){
					boolean ckeck = true;
					dbparam.put("yymm", dbparam.get("nowYear"+index));
					dbparam.put("sgbbCd", dbparam.get("nowSgbbCd"+index));
					dbparam.put("amt", dbparam.get("nowAmt"+index));
					dbparam.put("billAmt", dbparam.get("nowBillAmt"+index));
					dbparam.put("snDt", dbparam.get("nowSnDt"+index));
					
//					System.out.println("yymm = "+dbparam.get("nowYear"+index));
//					System.out.println("nowSgbbCd = "+dbparam.get("nowSgbbCd"+index));
//					System.out.println("nowAmt = "+dbparam.get("nowAmt"+index));
//					System.out.println("nowBillAmt = "+dbparam.get("nowBillAmt"+index));
//					System.out.println("nowSnDt = "+dbparam.get("nowSnDt"+index));
					
					if(dbparam.get("sgbbCd") != null &&!"044".equals(dbparam.get("sgbbCd"))){
						if(dbparam.get("billAmt") == null || "".equals(dbparam.get("billAmt")) ){
							dbparam.put("billAmt","0");
						}
						if(dbparam.get("amt") == null || "".equals(dbparam.get("amt")) ){
							dbparam.put("amt","0");
						}
						dbparam.put("lossAmt", Integer.parseInt((String)dbparam.get("billAmt"))-Integer.parseInt((String)dbparam.get("amt")));
					}
					for(int j=0 ; j < collectionList.size() ; j++){
						Map cList = (Map)collectionList.get(j);
						if(  dbparam.get("nowYear"+index).equals(cList.get("YYMM"))  ){
							if( dbparam.get("nowSnDt"+index).equals(cList.get("ICDT")) && dbparam.get("nowBillAmt"+index).equals(String.valueOf(cList.get("BILLAMT"))) &&	
								dbparam.get("nowAmt"+index).equals(String.valueOf(cList.get("AMT"))) && dbparam.get("nowSgbbCd"+index).equals(cList.get("SGBBCD"))){
								ckeck = false;
							}else {
								generalDAO.getSqlMapClient().insert("collection.collection.insertReaderSugmHist", dbparam); //수금정보히스토리업데이트
								generalDAO.getSqlMapClient().update("collection.collection.updateReaderSugm", dbparam); //수금정보 업데이트 (ABC : updateReaderSugm2)
								ckeck = false;
							}
						}
					}
					if(ckeck){
						generalDAO.insert("collection.collection.insertReaderSugm", dbparam); //수금정보 생성 (ABC : insertReaderSugm2)
					}
				}
				/** 현재수금처리 END */
				
				
			
			if("".equals(param.getString("stdt"))) { //단순 구독정보 수정
				if(!param.getString("sgType").equals(param.getString("oldSgType"))) {
					//011지로,012방문,013통장입금,021자동이체,022카드,023교육용,024쿠폰
					if("011".equals(param.getString("sgType")) || "012".equals(param.getString("sgType")) ||"013".equals(param.getString("sgType")) ||
						"021".equals(param.getString("sgType")) ||"022".equals(param.getString("sgType")) ||"023".equals(param.getString("sgType")) ||"024".equals(param.getString("sgType")) ){
						//같은 독자번호를 가진 고객의 경우 수금정보는 같이 변경된다.
						generalDAO.getSqlMapClient().update("reader.readerManage.updateReaderSgType", dbparam);	//수금방법 수정
						//미수분존재시 자동이체로 수금구분 변경
						generalDAO.getSqlMapClient().update("reader.readerManage.updateSugm", dbparam);	//수금방법 수정	
					}
				}
			} 
//			System.out.println("수금처리 완료===========================>");
//			System.out.println("oldSgType = "+param.getString("oldSgType"));
//			System.out.println("sgType = "+param.getString("sgType"));
			//수금방법이 자동이체 관련 수정-------------------
			//자동이체x ---> 자동이체
			if( !"021".equals(param.getString("oldSgType")) && "021".equals(param.getString("sgType")) ) {
				System.out.println("자동이체x ---> 자동이체");
				//학생(본사)독자가 아니면서 자동이체로 수금방법 변경시
				if(!"013".equals(param.getString("readTypeCd")) && "021".equals(param.getString("sgType")) ){ 
					String numId = "";
					List checkBilling = generalDAO.getSqlMapClient().queryForList("reader.billing.checkBilling" , dbparam);//자동이체 정보 존재 유무 확인
					
					if(checkBilling.size() == 0){
						dbparam.put("inType", "기존");
						generalDAO.getSqlMapClient().insert("reader.billing.savePayment" , dbparam);// 자동이체 정보 등록
						numId = (String)generalDAO.getSqlMapClient().queryForObject("reader.billing.getNumId" , dbparam);// 자동이체 등록 번호 조회	
					}else{
						//NUMID,STATUS
						Map temp = (Map)checkBilling.get(0);
						String status = (String)temp.get("STATUS");
						numId = temp.get("NUMID").toString();
						//EA13- 이면 EA00으로 변경 시리얼 증가 , 그외의 경우엔 EA00 으로 변경
						dbparam.put("numId", numId);
						
						if("EA13-".equals(status)){
							dbparam.put("status", status);
							
							generalDAO.getSqlMapClient().update("reader.billing.updateStatus", dbparam);//자동이체 상태값 변경
						}else{
							generalDAO.getSqlMapClient().update("reader.billing.updateStatus", dbparam);//자동이체 상태값 변경
						}
					}
					
					mav.setView(new RedirectView("/reader/billing/billingInfo.do?numId="+numId));
					generalDAO.getSqlMapClient().getCurrentConnection().commit();
					return mav;
				}
			} else if( "021".equals(param.getString("oldSgType")) && !"021".equals(param.getString("sgType"))) { 			//자동이체 ----> 자동이체x 자동이체정보 EA13-로 변경
//				System.out.println("자동이체 ----> 자동이체x");
//				System.out.println("readTypeCd = "+param.getString("readTypeCd"));
				String numId = "";
				if("013".equals(param.getString("readTypeCd")) ){//학생(본사)
					System.out.println("학생(본사)");
					numId = (String)generalDAO.getSqlMapClient().queryForObject("reader.billingStu.getNumId" , dbparam);// 자동이체 등록 번호 조회
					System.out.println("numId = "+numId);
					if(numId != null || !"".equals(numId)){
						dbparam.put("numId", numId);
						generalDAO.getSqlMapClient().update("reader.billingStu.removePayment", dbparam);//자동이체 해지	
					} 
				} else if( "021".equals(param.getString("oldSgType")) &&  !"021".equals(param.getString("sgType")) && "012".equals(param.getString("readTypeCd")) ) { //자동이체에서 자동이체아닌것으로 변경하면서 학생(지국)독자
					System.out.println("자동이체에서 자동이체아닌것으로 변경하면서 학생(지국)독자");
					numId = (String)generalDAO.getSqlMapClient().queryForObject("reader.billingStu.getNumId" , dbparam);// 자동이체 등록 번호 조회
					System.out.println("numId = "+numId);
					if(numId != null || !"".equals(numId)){
						dbparam.put("numId", numId);
						generalDAO.getSqlMapClient().update("reader.billingStu.removePayment", dbparam);//자동이체 해지	
					}
				} else{//그외~~
					System.out.println("그외~~");
					numId = (String)generalDAO.getSqlMapClient().queryForObject("reader.billing.getNumId" , dbparam);// 자동이체 등록 번호 조회
					System.out.println("numId = "+numId);
					if(numId != null || !"".equals(numId)){
						dbparam.put("numId", numId);
						generalDAO.getSqlMapClient().update("reader.billing.removePayment", dbparam);//자동이체 해지	
					}
				}

				if(!"".equals(param.getString("searchText"))){
					mav.addObject("searchText" ,param.getString("searchText") );
					mav.addObject("searchType" ,param.getString("searchType") );	
				}else{
					mav.addObject("searchText" ,param.getString("readNm") );
					mav.addObject("searchType" ,"4" );	
				}
				mav.setView(new RedirectView("/reader/readerManage/searchReader.do"));
				generalDAO.getSqlMapClient().getCurrentConnection().commit();
				return mav;
			} else if(!"".equals(param.getString("stdt"))  && (param.getString("qty").equals(param.getString("stQty")))) { 			//자동이체 ----> 구독중지 이고 전체 해지 EA13-로 변경 (단 seq==1 일때만)
				int count = (Integer) generalDAO.getSqlMapClient().queryForObject("reader.readerManage.getSeqNum" , dbparam);
				if(count == 0){
					String numId = "";
					if("013".equals(param.getString("readTypeCd")) ){//학생(본사)
						numId = (String)generalDAO.getSqlMapClient().queryForObject("reader.billingStu.getNumId" , dbparam);// 자동이체 등록 번호 조회
						if(numId != null || !"".equals(numId)){
							dbparam.put("numId", numId);
							generalDAO.getSqlMapClient().update("reader.billingStu.removePayment", dbparam);//자동이체 해지	
						}
					}else{//그외~~
						numId = (String)generalDAO.getSqlMapClient().queryForObject("reader.billing.getNumId" , dbparam);// 자동이체 등록 번호 조회
						if(numId != null || !"".equals(numId)){
							dbparam.put("numId", numId);
							generalDAO.getSqlMapClient().update("reader.billing.removePayment", dbparam);//자동이체 해지	
						}
					}
					if(!"".equals(param.getString("searchText"))){
						mav.addObject("searchText" ,param.getString("searchText") );
						mav.addObject("searchType" ,param.getString("searchType") );	
					}else{
						mav.addObject("searchText" ,param.getString("readNm") );
						mav.addObject("searchType" ,"4" );	
					}
					mav.setView(new RedirectView("/reader/readerManage/searchReader.do"));
					generalDAO.getSqlMapClient().getCurrentConnection().commit();
					return mav;
				}

			}
			}
			
			mav.setView(new RedirectView("/reader/readerManage/searchReader.do"));
			
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
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
	
}
