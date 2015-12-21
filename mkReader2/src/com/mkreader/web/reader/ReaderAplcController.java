/*------------------------------------------------------------------------------
 * NAME : ReaderAplcController 
 * DESC : 독자 신청
 * Author : jyyoo
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

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;
import org.springframework.web.servlet.view.RedirectView;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.DateUtil;
import com.mkreader.util.Paging;
import com.mkreader.util.StringUtil;

public class ReaderAplcController extends MultiActionController implements
	ISiteConstant, ICodeConstant {

	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {

			this.generalDAO = generalDAO;
	}
	
	/**
	 * 구독신청 리스트
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView aplcList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
Param param = new HttpServletParam(request);
		
		ModelAndView mav = new ModelAndView();

		//현재날짜
		Calendar rightNow = Calendar.getInstance();
		String year = String.valueOf(rightNow.get(Calendar.YEAR));
		String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));
		if (month.length() < 2)
			month = "0" + month;
		if (day.length() < 2)
			day = "0" + day;

		String READNM = param.getString("READNM");
		String HOMETEL1 = param.getString("HOMETEL1");
		String HOMETEL2 = param.getString("HOMETEL2");
		String HOMETEL3 = param.getString("HOMETEL3");
		String INCMGPERSNM = param.getString("INCMGPERSNM");
		String AGNM = param.getString("AGNM");
		String ISCK = param.getString("ISCK");
		String READTYPE = param.getString("READTYPE");
		String STDT= param.getString("STDT", year + "-" + month + "-" + day);			//기간 from
		String ETDT= param.getString("ETDT", year + "-" + month + "-" + day);				//기간 to

		int pageNo = param.getInt("pageNo", 1);
		int pageSize = 20;
		int totalCount = 0;
		int totalQty = 0;
		
		HashMap dbparam = new HashMap();
		
		dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
		dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
		
		dbparam.put("READNM", READNM); 
		dbparam.put("HOMETEL1", HOMETEL1);
		dbparam.put("HOMETEL2", HOMETEL2);
		dbparam.put("HOMETEL3", HOMETEL3);
		dbparam.put("INCMGPERSNM", INCMGPERSNM); 
		dbparam.put("AGNM", AGNM); 
		dbparam.put("ISCK", ISCK); 
		dbparam.put("READTYPE", READTYPE); 
		dbparam.put("STDT", StringUtil.replace(STDT, "-", ""));
		dbparam.put("ETDT", StringUtil.replace(ETDT, "-", ""));
		
		logger.debug("===== reader.readerAplc.getAplcList");
		List aplcList = generalDAO.queryForList("reader.readerAplc.getAplcList" , dbparam);  // 리스트 조회
		
		logger.debug("===== reader.readerAplc.getAplcListCnt");
		totalCount = generalDAO.count("reader.readerAplc.getAplcListCnt" , dbparam); // 조건별 전체 건수 조회	
		
		logger.debug("===== reader.readerAplc.getAplcListQty");
		totalQty = generalDAO.count("reader.readerAplc.getAplcListQty" , dbparam); // 조건별 전체 부수 조회

		mav.addObject("READNM", READNM);
		mav.addObject("HOMETEL1", HOMETEL1);
		mav.addObject("HOMETEL2", HOMETEL2);
		mav.addObject("HOMETEL3", HOMETEL3);
		mav.addObject("INCMGPERSNM", INCMGPERSNM);
		mav.addObject("AGNM", AGNM);
		mav.addObject("ISCK", ISCK);
		mav.addObject("READTYPE", READTYPE);
		mav.addObject("STDT", STDT);
		mav.addObject("ETDT", ETDT);
		
		mav.addObject("aplcList", aplcList);
		mav.addObject("totalCount", totalCount);
		mav.addObject("totalQty", totalQty);
		
		mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 10));
		mav.addObject("now_menu", MENU_CODE_READER);
		mav.setViewName("reader/readerAplc/readerAplcList");
		return mav;
		
	}
	
	
	
	

	/**
	 * 구독신청팝업(신규등록, 기등록 독자조회)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView popAplcReader(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();

		try{			
			//현재날짜
			Calendar rightNow = Calendar.getInstance();
			String year = String.valueOf(rightNow.get(Calendar.YEAR));
			String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
			String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));
			if (month.length() < 2)
				month = "0" + month;
			if (day.length() < 2)
				day = "0" + day;
			
			String TODAY= year + "-" + month + "-" + day;			//기간 from
			
			HashMap dbparam = new HashMap();
						
			String aplcDt = param.getString("aplcdt");
			String aplcNo = param.getString("aplcno");
			Object AplcReader = null; 
			
			if(aplcDt != null && aplcNo != null){
				dbparam.put("aplcDt", aplcDt);
				dbparam.put("aplcNo", aplcNo);
				
				AplcReader = generalDAO.queryForObject("reader.readerAplc.getAplcReader", dbparam);  // 기등록독자의경우 정보 조회
				
				mav.addObject("aplcDt", aplcDt);
				mav.addObject("aplcNo", aplcNo);
			}
				
			List newsList = generalDAO.queryForList("reader.readerAplc.getNewsCode", dbparam);//신문코드 조회
			List areaCode = generalDAO.queryForList("reader.common.retrieveAreaCode" , dbparam);// 전화번호 지역번호 조회
			List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" , dbparam);// 핸도폰 앞자리 번호 조회
			List readTypeList = generalDAO.queryForList("reader.common.retrieveReaderType", dbparam);//독자유형 조회
			List rsdTypeList = generalDAO.queryForList("reader.common.retrieveRsdTypeCd", dbparam);//주거유형 조회
			List taskList = generalDAO.queryForList("reader.common.retrieveTaskCd", dbparam);//직종유형 조회
			List intFldList = generalDAO.queryForList("reader.common.retrieveIntFldCd", dbparam);//관심유형 조회
			List dlvTypeList = generalDAO.queryForList("reader.common.retrieveDlvTypeCd", dbparam);//배달유형 조회
			List hjPathList = generalDAO.queryForList("reader.common.retrieveHjPathCd", dbparam);//신청경로 조회
			List dlvPosiCdList = generalDAO.queryForList("reader.common.retrieveDlvPosiCd", dbparam);//배달장소 조회
			List sgTypeList = generalDAO.queryForList("reader.common.retrieveSgType", dbparam);//수금방법 조회
			List agencyAllList = generalDAO.queryForList("reader.common.agencyListByAlive" );// 지국 목록

			// mav 
			mav.addObject("newsList", newsList);
			mav.addObject("areaCode", areaCode);
			mav.addObject("mobileCode", mobileCode);
			mav.addObject("readTypeList", readTypeList);
			mav.addObject("rsdTypeList", rsdTypeList);
			mav.addObject("taskList", taskList);
			mav.addObject("intFldList", intFldList);
			mav.addObject("dlvTypeList", dlvTypeList);
			mav.addObject("hjPathList", hjPathList);
			mav.addObject("dlvPosiCdList", dlvPosiCdList);
			mav.addObject("sgTypeList", sgTypeList);
			mav.addObject("TODAY", TODAY);  // 현재날짜
			mav.addObject("agencyAllList", agencyAllList);
			
			mav.addObject("AplcReader", AplcReader);
			mav.addObject("boacptdt", param.getString("boacptdt"));  // 지국에서 해당 신규 독자 등록(확인)여부 

			mav.addObject("param", param);
			mav.setViewName("reader/readerAplc/pop_AplcReader");	
			return mav;

		}catch(Exception e){
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	
	
	/**
	 * 확장자명 검색(사원확장)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ajaxHjPsNmList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();

		try{
			HashMap dbparam = new HashMap();
			String hjPathCd = param.getString("hjPathCd");
			dbparam.put("hjPathCd", hjPathCd );
			dbparam.put("boSeq", "00000" ); // gabage데이타 조회, 지국판촉의 경우 지국에서 등록하므로 조회 필요없음 
			
			List hjPsNmList = null;
			
			if(hjPathCd.equals("005") || hjPathCd == "005"){
				hjPsNmList = generalDAO.queryForList("reader.readerAplc.hjPsNmList", dbparam);
			}else{			
				hjPsNmList = generalDAO.queryForList("reader.readerManage.hjPsNmList", dbparam);
			}

			mav.addObject("hjPsNmList", hjPsNmList);
			mav.setViewName("reader/ajaxHjPsNmList");	
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
	 * 확장자명 검색(사원확장)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ajaxHjPsNmListForJquery(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();

		try{
			HashMap dbparam = new HashMap();
			JSONObject jsonObject = new JSONObject();
			
			String hjPathCd = param.getString("hjPathCd");
			dbparam.put("hjPathCd", hjPathCd );
			dbparam.put("boSeq", "00000" ); // gabage데이타 조회, 지국판촉의 경우 지국에서 등록하므로 조회 필요없음
			
			List hjPsNmList = null;
			
			if(hjPathCd.equals("005") || hjPathCd == "005"){
				hjPsNmList = generalDAO.queryForList("reader.readerAplc.hjPsNmList", dbparam);
			}else{			
				hjPsNmList = generalDAO.queryForList("reader.readerManage.hjPsNmList", dbparam);
			}

			jsonObject.put("hjPsNmList", hjPsNmList);
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
		}catch(Exception e){
			e.printStackTrace();
			
		}
		return null;
	}
	
	

	/**
	 * 우편 주소 팝업
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView popAgSearch(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		mav.setViewName("reader/pop_AgSearch");	
		return mav;
	}
	
	/**
	 * 우편 주소 검색
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView popSearchAgency(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		ModelAndView mav = new ModelAndView();
		
		HashMap dbparam = new HashMap();
		Param param = new HttpServletParam(request);
		try{
			dbparam.put("search", param.getString("search"));
			List addrList = generalDAO.queryForList("reader.readerAplc.retrieveAgency", dbparam);

			mav.addObject("search" , param.getString("search"));
			mav.addObject("addrList" , addrList);
			mav.setViewName("reader/pop_AgSearch");	
			return mav;

		}catch(Exception e){
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	

	
	/**
	 * 구독신청
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView regAplc(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HashMap dbparam = new HashMap();
		HttpSession session = request.getSession();
		
		//구독신청 정보 생성을 위한 param값
		
		dbparam.put("readNm" , param.getString("readNm"));     // 독자명
		dbparam.put("bidt" ,StringUtil.replace(param.getString("bidt"), "-", ""));     // 생년월일
		dbparam.put("homeTel1" , param.getString("homeTel1"));   // 집전화번호1
		dbparam.put("homeTel2" , param.getString("homeTel2"));   // 집전화번호2
		dbparam.put("homeTel3" , param.getString("homeTel3"));   // 집전화번호3
		dbparam.put("mobile1" , param.getString("mobile1"));   // 휴대폰전화번호1
		dbparam.put("mobile2" , param.getString("mobile2"));   // 휴대폰전화번호2
		dbparam.put("mobile3" , param.getString("mobile3"));   // 휴대폰전화번호3
		dbparam.put("eMail" , param.getString("eMail"));			// 이메일
		dbparam.put("dlvZip" , param.getString("dlvZip"));  		// 우편번호
		dbparam.put("dlvAdrs1" , param.getString("dlvAdrs1")); // 주소1
		dbparam.put("dlvAdrs2" , param.getString("dlvAdrs2")); // 주소2
		dbparam.put("newaddr" , param.getString("newaddr"));
		dbparam.put("bdMngNo" , param.getString("bdMngNo"));
		dbparam.put("boseq" , param.getString("boseq"));			// 담당지국
		dbparam.put("rsdTypeCd" , param.getString("rsdTypeCd"));  // 주거구분
		dbparam.put("taskCd" , param.getString("taskCd"));		// 직종
		dbparam.put("intFldCd" , param.getString("intFldCd"));  // 관심분야
		dbparam.put("newsCd" , param.getString("newsCd"));   // 신문코드
		dbparam.put("hjDt" , StringUtil.replace(param.getString("hjDt"), "-", ""));	// 확장일자
		dbparam.put("readTypeCd" , param.getString("readTypeCd"));		// 독자유형
		dbparam.put("qty" , param.getString("qty"));				   // 구독부수
		dbparam.put("sgBgmm" , StringUtil.replace(param.getString("sgBgmm"), "-", ""));	// 유가연월
		dbparam.put("dlvTypeCd" , param.getString("dlvTypeCd"));		// 배달유형
		dbparam.put("uPrice" , param.getString("uPrice"));			// 단가
		dbparam.put("hjPathCd" , param.getString("hjPathCd"));    // 신청경로
		dbparam.put("dlvPosiCd" , param.getString("dlvPosiCd"));  // 배달장소
		dbparam.put("sgType" , param.getString("sgType"));			// 수금방법
		dbparam.put("hjPsnm" , param.getString("hjPsnm"));			// 확장자
		dbparam.put("hjPsregCd" , param.getString("hjPsregCd"));  // 확장자코드
		dbparam.put("hjpsRemk" , param.getString("hjpsRemk"));   // 확장자비고

		dbparam.put("inps" , (String)session.getAttribute(SESSION_NAME_ADMIN_USERID));          // 등록자(시스템 접속자 아이디)
		dbparam.put("chgPs" , (String)session.getAttribute(SESSION_NAME_ADMIN_USERID));		   // 수정자(시스템 접속자 아이디)
		dbparam.put("today" ,StringUtil.replace(param.getString("today"), "-", ""));     // APLCDT값으로 사용
	
		
		try{
			generalDAO.insert("reader.readerAplc.insertAplcInfo", dbparam);
			mav.setViewName("reader/readerAplc/pop_AplcReader");	
		}catch (Exception e){
			mav.addObject("message", "등록을 실패했습니다.");
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
		}
	
		return mav;
	
	}
	


	/**
	 * 구독신청정보 수정
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView modifyAplc(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HashMap<String,String> dbparam = new HashMap<String,String>();
		HttpSession session = request.getSession();
		
		//구독신청 정보 수정을 위한 param값
		
		dbparam.put("aplcNo" , param.getString("aplcNo"));			// 신청순번
		dbparam.put("aplcDt" , param.getString("aplcDt"));			// 신청일자
		dbparam.put("delYn" , param.getString("delYn"));				// 취소여부(Y:취소, N: 정상)
				
		dbparam.put("readNm" , param.getString("readNm"));     // 독자명
		dbparam.put("bidt" ,StringUtil.replace(param.getString("bidt"), "-", ""));     // 생년월일
		dbparam.put("homeTel1" , param.getString("homeTel1"));   // 집전화번호1
		dbparam.put("homeTel2" , param.getString("homeTel2"));   // 집전화번호2
		dbparam.put("homeTel3" , param.getString("homeTel3"));   // 집전화번호3
		dbparam.put("mobile1" , param.getString("mobile1"));   // 휴대폰전화번호1
		dbparam.put("mobile2" , param.getString("mobile2"));   // 휴대폰전화번호2
		dbparam.put("mobile3" , param.getString("mobile3"));   // 휴대폰전화번호3
		dbparam.put("eMail" , param.getString("eMail"));			// 이메일
		dbparam.put("dlvZip" , param.getString("dlvZip"));  		// 우편번호
		dbparam.put("dlvAdrs1" , param.getString("dlvAdrs1")); // 주소1
		dbparam.put("dlvAdrs2" , param.getString("dlvAdrs2")); // 주소2
		dbparam.put("newaddr" , param.getString("newaddr"));
		dbparam.put("bdMngNo" , param.getString("bdMngNo"));
		dbparam.put("boseq" , param.getString("boseq"));			// 담당지국
		dbparam.put("rsdTypeCd" , param.getString("rsdTypeCd"));  // 주거구분
		dbparam.put("taskCd" , param.getString("taskCd"));		// 직종
		dbparam.put("intFldCd" , param.getString("intFldCd"));  // 관심분야
		dbparam.put("newsCd" , param.getString("newsCd"));   // 신문코드
		dbparam.put("hjDt" , StringUtil.replace(param.getString("hjDt"), "-", ""));	// 확장일자
		dbparam.put("readTypeCd" , param.getString("readTypeCd"));		// 독자유형
		dbparam.put("qty" , param.getString("qty"));				   // 구독부수
		dbparam.put("sgBgmm" , StringUtil.replace(param.getString("sgBgmm"), "-", ""));	// 유가연월
		dbparam.put("dlvTypeCd" , param.getString("dlvTypeCd"));		// 배달유형
		dbparam.put("uPrice" , param.getString("uPrice"));			// 단가
		dbparam.put("hjPathCd" , param.getString("hjPathCd"));    // 신청경로
		dbparam.put("dlvPosiCd" , param.getString("dlvPosiCd"));  // 배달장소
		dbparam.put("sgType" , param.getString("sgType"));			// 수금방법
		dbparam.put("hjPsnm" , param.getString("hjPsnm"));			// 확장자
		dbparam.put("hjPsregCd" , param.getString("hjPsregCd"));  // 확장자코드
		dbparam.put("hjpsRemk" , param.getString("hjpsRemk"));   // 확장자비고

		dbparam.put("chgPs" , (String)session.getAttribute(SESSION_NAME_ADMIN_USERID));		   // 수정자(시스템 접속자 아이디)
		
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			if("".equals(param.getString("delYn"))){
				generalDAO.getSqlMapClient().update("reader.readerAplc.updateAplcInfo", dbparam); 		// 구독신청정보 수정

			}else{
				generalDAO.getSqlMapClient().update("reader.readerAplc.delAplcInfo", dbparam); 			// 구독신청정보에 대한 취소 / 재등록기능
				generalDAO.getSqlMapClient().update("reader.readerAplc.updateAplcInfo", dbparam); 		// 구독신청정보 수정
			}

			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			
			mav.setViewName("reader/readerAplc/pop_AplcReader");	
		}catch(Exception e){
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			mav.addObject("message", "수정을 실패했습니다.");
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
	
		}finally{
			generalDAO.getSqlMapClient().endTransaction();
		}
		return mav;
	}
	


	/**
	 * 구독신청관련 확장자 비고 수정
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView modifyHjRemk(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HashMap dbparam = new HashMap();
		HttpSession session = request.getSession();
		
		dbparam.put("aplcNo" , param.getString("aplcNo"));			// 신청순번
		dbparam.put("aplcDt" , param.getString("aplcDt"));			// 신청일자
		dbparam.put("hjpsRemk" , param.getString("hjpsRemk"));   // 확장자비고

		dbparam.put("chgPs" , (String)session.getAttribute(SESSION_NAME_ADMIN_USERID));		   // 수정자(시스템 접속자 아이디)		
		
		try{

			generalDAO.update("reader.readerAplc.updateHjRemk", dbparam); 		// 구독신청정보 수정

			mav.setViewName("reader/readerAplc/pop_AplcReader");	
		}catch(Exception e){
			e.printStackTrace();
			mav.addObject("message", "수정을 실패했습니다.");
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
		}

		return mav;
	}
}