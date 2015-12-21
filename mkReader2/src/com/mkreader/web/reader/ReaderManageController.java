/*------------------------------------------------------------------------------
 * NAME : ReaderManageController 
 * DESC : 독자 관리
 * Author : pspkj
 *----------------------------------------------------------------------------*/
package com.mkreader.web.reader;

import java.net.URLDecoder;
import java.net.URLEncoder;
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

public class ReaderManageController extends MultiActionController implements
	ISiteConstant, ICodeConstant {

	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {

			this.generalDAO = generalDAO;
	}
	
	/**
	 * 독자 리스트
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView readerList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		try{
			HashMap dbparam = new HashMap();
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 200;
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			int totalCount = 0;
			
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
							dbparam.put("BOSEQ", list.get("SERIAL"));
						}
					}else{
						dbparam.put("agency_serial", param.getString("agency"));
						dbparam.put("BOSEQ", param.getString("agency"));
					}
				}else{
					List agencyList = generalDAO.queryForList("reader.common.agencyList" , dbparam); //지국 리스트
					mav.addObject("agency_serial", param.getString("agency"));
					mav.addObject("agencyList", agencyList);
					if("".equals(param.getString("agency")) ){
						if(agencyList.size() > 0){
							Map list = (Map)agencyList.get(0);
							dbparam.put("agency_serial", list.get("SERIAL"));
							dbparam.put("BOSEQ", list.get("SERIAL"));
						}
					}else{
						dbparam.put("agency_serial", param.getString("agency"));
						dbparam.put("BOSEQ", param.getString("agency"));
					}
				}
			}else{
				dbparam.put("agency_serial", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
				dbparam.put("BOSEQ", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			}
			
			List readerList = generalDAO.queryForList("reader.readerManage.getReaderList" , dbparam);// 독자리스트
			//List readerList = null;// 독자리스트
			totalCount = generalDAO.count("reader.readerManage.getReaderListCount" , dbparam);
			List newSList = generalDAO.queryForList("reader.common.retrieveNewsList", dbparam);//신문코드 조회
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
			List bnsBookList = generalDAO.queryForList("reader.common.retrieveBnsBookCd", dbparam);//자매지 조회
			List SpgCdList = generalDAO.queryForList("reader.common.retrieveSpgCd", dbparam);//판촉물 조회
			List stSayouList = generalDAO.queryForList("reader.common.retrieveStSayou", dbparam);//해지사유 조회
			List guYukList = generalDAO.queryForList("common.getAgencyAreaList", dbparam);//구역코드 조회
			String nowYYMM = (String)generalDAO.queryForObject("common.getLastSGYYMM", dbparam);//사용년월

			// mav 
			mav.addObject("now_menu", MENU_CODE_J_READER);
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 10));
			mav.addObject("readerList", readerList);
			mav.addObject("newSList", newSList);
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
			mav.addObject("bnsBookList", bnsBookList);
			mav.addObject("SpgCdList", SpgCdList);
			mav.addObject("stSayouList", stSayouList);
			mav.addObject("guYukList" , guYukList);
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
			mav.setViewName("reader/readerList");
			//mav.setViewName("reader/readerList_3"); //ABC용
			
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
	 * 독자 검색
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView searchReader(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			HashMap dbparam = new HashMap();
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 200;
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			int totalCount = 0;
			
			String flag = param.getString("flag");
			
			String searchText = param.getString("searchText");
			if(flag.equals("chgUrl")){
				searchText = URLDecoder.decode(searchText,"UTF-8");
			}
			
			//비고저장버튼 클릭시
			if("INS_MEMO".equals(flag)) {
				
			}
					
			if( session.getAttribute(SESSION_NAME_AGENCY_SERIAL) != null ){ //지국
				dbparam.put("searchText", searchText); 
				dbparam.put("searchType", param.getString("searchType"));
				dbparam.put("agency_serial", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
				dbparam.put("BOSEQ", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
				dbparam.put("searchSgType", param.getString("searchSgType"));
				dbparam.put("searchNewsCdType", param.getString("searchNewsCdType"));
				
				List readerList = generalDAO.queryForList("reader.readerManage.searchReader", dbparam);
				totalCount = generalDAO.count("reader.readerManage.searchReaderCount", dbparam);
				List newSList = generalDAO.queryForList("reader.common.retrieveNewsList", dbparam);//신문코드 조회
				mav.addObject("readerList", readerList);
				mav.addObject("newSList", newSList);
			}else{ //관리자
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
							dbparam.put("BOSEQ", list.get("SERIAL"));
						}
					}else{
						dbparam.put("agency_serial", param.getString("agency"));
						dbparam.put("BOSEQ", param.getString("agency"));
					}
				}else{
					List agencyList = generalDAO.queryForList("reader.common.agencyList" , dbparam); //지국 리스트
					mav.addObject("agency_serial", param.getString("agency"));
					mav.addObject("agencyList", agencyList);
					if("".equals(param.getString("agency")) ){
						if(agencyList.size() > 0){
							Map list = (Map)agencyList.get(0);
							dbparam.put("agency_serial", list.get("SERIAL"));
							dbparam.put("BOSEQ", list.get("SERIAL"));
						}
					}else{
						dbparam.put("agency_serial", param.getString("agency"));
						dbparam.put("BOSEQ", param.getString("agency"));
					}
				}
				dbparam.put("searchText", searchText); 
				dbparam.put("searchType", param.getString("searchType"));
				dbparam.put("searchSgType", param.getString("searchSgType"));
				dbparam.put("searchNewsCdType", param.getString("searchNewsCdType"));
				
				List readerList = generalDAO.queryForList("reader.readerManage.searchReader", dbparam);
				totalCount = generalDAO.count("reader.readerManage.searchReaderCount", dbparam);
				List newSList = generalDAO.queryForList("reader.common.retrieveNewsList", dbparam);//신문코드 조회
				mav.addObject("readerList", readerList);
				mav.addObject("newSList", newSList);
			}

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
			List bnsBookList = generalDAO.queryForList("reader.common.retrieveBnsBookCd", dbparam);//자매지 조회
			List SpgCdList = generalDAO.queryForList("reader.common.retrieveSpgCd", dbparam);//판촉물 조회
			List stSayouList = generalDAO.queryForList("reader.common.retrieveStSayou", dbparam);//해지사유 조회
			List guYukList = generalDAO.queryForList("common.getAgencyAreaList", dbparam);//구역코드 조회
			String nowYYMM = (String)generalDAO.queryForObject("common.getLastSGYYMM", dbparam);//사용년월
			// mav 
			mav.addObject("searchSgType", param.getString("searchSgType"));
			mav.addObject("searchNewsCdType", param.getString("searchNewsCdType"));
			mav.addObject("areaCode", areaCode);
			mav.addObject("mobileCode", mobileCode);
			mav.addObject("searchText", searchText);
			mav.addObject("searchType", param.getString("searchType"));
			mav.addObject("readTypeList", readTypeList);
			mav.addObject("rsdTypeList", rsdTypeList);
			mav.addObject("taskList", taskList);
			mav.addObject("intFldList", intFldList);
			mav.addObject("dlvTypeList", dlvTypeList);
			mav.addObject("hjPathList", hjPathList);
			mav.addObject("dlvPosiCdList", dlvPosiCdList);
			mav.addObject("sgTypeList", sgTypeList);
			mav.addObject("bnsBookList", bnsBookList);
			mav.addObject("SpgCdList", SpgCdList);
			mav.addObject("stSayouList", stSayouList);
			mav.addObject("guYukList" , guYukList);
			mav.addObject("nowYYMM" , nowYYMM);
			mav.addObject("now_menu", MENU_CODE_READER);
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 10));
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

			mav.setViewName("reader/readerList");
			
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
	 * 독자 상세보기(AJAX)
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView selectReaderView(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			HashMap dbparam = new HashMap();
			
			dbparam.put("boseq", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			dbparam.put("seq", param.getString("seq"));
			dbparam.put("readno", param.getString("readno"));
			dbparam.put("newscd", param.getString("newscd"));
			
			//독자 상세보기
			Map readerView = (Map)generalDAO.queryForObject("reader.readerManage.getReaderView" , dbparam);
			
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("readerView", JSONArray.fromObject(readerView));
			
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
	
	
	/**
	 * 신규독자팝업
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView popRetrieveApplyReader(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		ModelAndView mav = new ModelAndView();
		HashMap dbparam = new HashMap();
		HttpSession session = request.getSession();
		
		dbparam.put("agency_serial", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
		dbparam.put("BOSEQ", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
		List newSList = generalDAO.queryForList("reader.common.retrieveNewsList", dbparam);//신문코드 조회
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
		List bnsBookList = generalDAO.queryForList("reader.common.retrieveBnsBookCd", dbparam);//자매지 조회
		List SpgCdList = generalDAO.queryForList("reader.common.retrieveSpgCd", dbparam);//판촉물 조회
		List guYukList = generalDAO.queryForList("common.getAgencyAreaList", dbparam);//구역코드 조회
		// mav 
		mav.addObject("newSList", newSList);
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
		mav.addObject("bnsBookList", bnsBookList);
		mav.addObject("SpgCdList", SpgCdList);
		mav.addObject("guYukList", guYukList);
		mav.setViewName("reader/pop_applyReader");	
		return mav;
	}
	
	/**
	 * 독자 통화내역 팝업
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView popRetrieveCallLog(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		ModelAndView mav = new ModelAndView();
		
		HashMap dbparam = new HashMap();
		Param param = new HttpServletParam(request);
		try{
			dbparam.put("readNo" , param.getString("readNo"));
			dbparam.put("newsCd" , param.getString("newsCd"));
			dbparam.put("seq" , param.getString("seq"));
			List callLog = generalDAO.queryForList("reader.readerManage.callLog", dbparam);
			int totalCount = generalDAO.count("reader.readerManage.countCalllog" , dbparam);
			// mav 
			mav.addObject("param" , param);
			mav.addObject("count" , totalCount);
			mav.addObject("callLog" , callLog);
			mav.setViewName("reader/pop_callLog");	
			return mav;

		}catch(Exception e){
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
		
	/**
	 * 독자 통화내역 생성
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView saveCallLog(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		ModelAndView mav = new ModelAndView();
		
		HashMap dbparam = new HashMap();
		Param param = new HttpServletParam(request);
		try{
			   
			dbparam.put("readNo" , param.getString("readNo"));
			dbparam.put("newsCd" , param.getString("newsCd"));
			dbparam.put("seq" , param.getString("seq"));
			dbparam.put("remk" , param.getString("remk"));
			generalDAO.insert("reader.readerManage.insertCallLog", dbparam);

			// mav 
			request.setAttribute("param", param);
			mav.setView(new RedirectView("/reader/readerManage/popRetrieveCallLog.do?readNo="+param.getString("readNo")+"&newsCd="+param.getString("newsCd")+"&seq="+param.getString("seq")+"&gbn="+param.getString("gbn") ));	
			return mav;

		}catch(Exception e){
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	
	
	/**
	 * 신규신청독자조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView retrieveApplyReader(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		try{
			HashMap dbparam = new HashMap();
			dbparam.put("isCheck", param.getString("isCheck"));
			dbparam.put("sdate", param.getString("sdate"));
			dbparam.put("edate", param.getString("edate"));
			
			List ApplyReaderList = null; 
			
			if( !"1000".equals(session.getAttribute(SESSION_NAME_MENU_AUTH)  )){
				dbparam.put("agency_serial", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
				dbparam.put("BOSEQ", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			}
			
			ApplyReaderList = generalDAO.queryForList("reader.readerManage.applyReaderList", dbparam);
			List newSList = generalDAO.queryForList("reader.common.retrieveNewsList", dbparam);//신문코드 조회
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
			List bnsBookList = generalDAO.queryForList("reader.common.retrieveBnsBookCd", dbparam);//자매지 조회
			List SpgCdList = generalDAO.queryForList("reader.common.retrieveSpgCd", dbparam);//판촉물 조회
			List guYukList = generalDAO.queryForList("common.getAgencyAreaList", dbparam);//구역코드 조회
			// mav 
			mav.addObject("newSList", newSList);
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
			mav.addObject("bnsBookList", bnsBookList);
			mav.addObject("SpgCdList", SpgCdList);
			mav.addObject("guYukList", guYukList);
			mav.addObject("ApplyReaderList", ApplyReaderList);
			mav.addObject("param", param);
			mav.addObject("now_menu", MENU_CODE_READER);
			mav.setViewName("reader/readerAplc/pop_applyReader");	
			return mav;

		}catch(Exception e){
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	
	/**
	 * 확장자명 검색
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
			dbparam.put("hjPathCd", param.getString("hjPathCd") );
			dbparam.put("boSeq", param.getString("boSeq") );
			List hjPsNmList = generalDAO.queryForList("reader.readerManage.hjPsNmList", dbparam);
			// mav 
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
	 * 확장자명 검색
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
			
			List hjPsNmList = null;
			String hjPathCd = param.getString("hjPathCd");
			
			dbparam.put("hjPathCd", param.getString("hjPathCd") );
			dbparam.put("boSeq", param.getString("boSeq") );
			
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
	 * 확장자명 검색(JSON)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ajaxHjPsNmListForJson(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		
		try{
			HashMap dbparam = new HashMap();
			Map<String, Object> hjPsNmMap = new HashMap<String, Object>();
			
			dbparam.put("hjPathCd", param.getString("hjPathCd") );
			dbparam.put("boSeq", param.getString("boSeq") );
			
			int index = 0;
			
			List<Map<String, Object>> hjPsNmList = generalDAO.queryForList("reader.readerManage.hjPsNmListForJson", dbparam);
			System.out.println("hjPsNmList = "+hjPsNmList);
			
			for(Map<String, Object> map : hjPsNmList) {
				for (Map.Entry<String, Object> entry : map.entrySet()) {
					String key = entry.getKey();
					Object value = entry.getValue();
					hjPsNmMap.put(key, value);
				}
				index++;
			}

			JSONObject jsonObject = new JSONObject();
			jsonObject.put("hjPsNmList", JSONArray.fromObject(hjPsNmList));
			
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 확장자명 검색
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView getHjPsNmListForAjax(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		

		try{
			HashMap dbparam = new HashMap();
			Map<String, Object> hjPsNmMap = new HashMap<String, Object>();;
			int index = 0;
			
			dbparam.put("hjPathCd", param.getString("hjPathCd") );
			dbparam.put("boSeq", param.getString("boSeq") );
			List<Map<String, Object>> hjPsNmList = generalDAO.queryForList("reader.readerManage.hjPsNmList", dbparam);
			
			for(Map<String, Object> map : hjPsNmList) {
				for (Map.Entry<String, Object> entry : map.entrySet()) {
					String key = entry.getKey();
					Object value = entry.getValue();
					hjPsNmMap.put(key, value);
				}
				index++;
			}
			
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("hjPsNmList", JSONArray.fromObject(hjPsNmList));
			
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 신규 독자 생성
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView saveReader(HttpServletRequest request,
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
		dbparam.put("boReadNo" , param.getString("boReadNo"));
		dbparam.put("gno" , param.getString("gno"));
		dbparam.put("bno" , param.getString("bno"));
		dbparam.put("sno" , param.getString("sno"));
		dbparam.put("readTypeCd" , param.getString("readTypeCd"));
		dbparam.put("readNm" , param.getString("readNm"));
		dbparam.put("offiNm" , param.getString("offiNm"));
		dbparam.put("homeTel1" , param.getString("homeTel1"));
		dbparam.put("homeTel2" , param.getString("homeTel2"));
		dbparam.put("homeTel3" , param.getString("homeTel3"));
		dbparam.put("mobile1" , param.getString("mobile1"));
		dbparam.put("mobile2" , param.getString("mobile2"));
		dbparam.put("mobile3" , param.getString("mobile3"));
		dbparam.put("dlvZip" , param.getString("dlvZip"));
		dbparam.put("dlvAdrs1" , param.getString("dlvAdrs1"));
		dbparam.put("dlvAdrs2" , param.getString("dlvAdrs2"));
		dbparam.put("newaddr" , param.getString("newaddr"));
		dbparam.put("bdMngNo" , param.getString("bdMngNo"));
		dbparam.put("dlvStrNm" , param.getString("dlvStrNm"));
		dbparam.put("dlvStrNo" , param.getString("dlvStrNo"));
		dbparam.put("aptCd" , param.getString("aptCd"));
		dbparam.put("aptDong" , param.getString("aptDong"));
		dbparam.put("aptHo" , param.getString("aptHo"));
		dbparam.put("sgType" , param.getString("sgType"));
		dbparam.put("sgInfo" , param.getString("sgInfo"));
		dbparam.put("sgTel1" , param.getString("sgTel1"));
		dbparam.put("sgTel2" , param.getString("sgTel2"));
		dbparam.put("sgTel3" , param.getString("sgTel3"));
		dbparam.put("uPrice" , param.getString("uPrice"));
		dbparam.put("qty" , param.getString("qty"));
		dbparam.put("stQty" , param.getString("stQty"));
		dbparam.put("rsdTypeCd" , param.getString("rsdTypeCd"));
		dbparam.put("dlvTypeCd" , param.getString("dlvTypeCd"));
		dbparam.put("dlvPosiCd" , param.getString("dlvPosiCd"));
		dbparam.put("hjPathCd" , param.getString("hjPathCd"));
		dbparam.put("hjTypeCd" , param.getString("hjTypeCd"));
		dbparam.put("hjPsregCd" , param.getString("hjPsregCd"));
		dbparam.put("hjPsnm" , param.getString("hjPsnm"));
		dbparam.put("hjDt" , StringUtil.replace(param.getString("hjDt"), "-", ""));
		dbparam.put("sgBgmm" , StringUtil.replace(param.getString("sgBgmm"), "-", ""));
		dbparam.put("sgEdmm" , param.getString("sgEdmm"));
		dbparam.put("sgCycle" , param.getString("sgCycle"));
		dbparam.put("stdt" , StringUtil.replace(param.getString("stdt"), "-", ""));
		dbparam.put("stSayou" , param.getString("stSayou"));
		dbparam.put("aplcDt" , StringUtil.replace(param.getString("hjDt2"), "-", ""));
		dbparam.put("aplcNo" , param.getString("aplcNo"));
		dbparam.put("remk" , param.getString("remk"));
		dbparam.put("spRemk" , param.getString("spRemk"));
		dbparam.put("inps" , param.getString("inps"));
		dbparam.put("spgCd" , param.getString("spgCd"));
		dbparam.put("bnsBookCd" , param.getString("bnsBookCd"));
		dbparam.put("taskCd" , param.getString("taskCd"));
		dbparam.put("intFldCd" , param.getString("intFldCd"));
		dbparam.put("bidt" , param.getString("bidt"));
		dbparam.put("eMail" , param.getString("eMail"));
		if("on".equals(param.getString("receipt"))){
			dbparam.put("receipt" , "N");	
		}else{
			dbparam.put("receipt" , "Y");
		}
		
		dbparam.put("agency_serial", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
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
		dbparam.put("realJikuk" , dbparam.get("agency_serial"));
		dbparam.put("busu" , param.getString("qty"));
		dbparam.put("handy" , param.getString("mobile1")+"-"+param.getString("mobile2")+"-"+param.getString("mobile3") );
		dbparam.put("email" , param.getString("eMail"));
		dbparam.put("whoStep" , "2");
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			String readNo = (String)generalDAO.getSqlMapClient().queryForObject("reader.readerManage.getReadNo");
				
			dbparam.put("readNo" , readNo);
			
			if( !"".equals(param.getString("aplcNo")) && "applyReader".equals(param.getString("gbn")) ) { //구독 신청 테이블에서 신규 독자 생성
				dbparam.put("boAcptStat", param.getString("boAcptStat"));
				if("01".equals(param.getString("boAcptStat"))){//민원만 업데이트
					generalDAO.getSqlMapClient().insert("reader.readerManage.insertTmreader", dbparam); //통합독자생성
					generalDAO.getSqlMapClient().insert("reader.readerManage.inserTmreaderNews", dbparam); //구독정보 생성 (ABC : inserTmreaderNews2)
				}	
				dbparam.put("aplcDt2" , param.getString("aplcDt"));
				generalDAO.getSqlMapClient().update("reader.readerManage.updateApplyReader", dbparam); //독자신청 테이블 수정	
				
			} else { //신규 독자 생성
				generalDAO.getSqlMapClient().insert("reader.readerManage.insertTmreader", dbparam); //통합독자생성
				generalDAO.getSqlMapClient().insert("reader.readerManage.inserTmreaderNews", dbparam); //구독정보 생성 (ABC : inserTmreaderNews2)
			}
			
			String numId = (String)generalDAO.getSqlMapClient().queryForObject("reader.billing.getNumId" , dbparam);// 자동이체 등록 번호 조회
			if("".equals(numId) || numId == null)  {numId = "00"+param.getString("sgType");}
			
			//신규 신청시 자동이체 정보 등록
			if( "".equals(param.getString("oldReadTypeCd")) && "".equals(param.getString("oldSgType"))) {
				//자동이체이면서 일반,학생(지국) 이면 자동이체 테이블 정보 등록
				if( ("011".equals(param.getString("readTypeCd")) || "012".equals(param.getString("readTypeCd"))) && "021".equals(param.getString("sgType"))) {
					dbparam.put("inType", "기존");
					generalDAO.getSqlMapClient().insert("reader.billing.savePayment", dbparam);// 자동이체 정보 등록
					mav.setView(new RedirectView("/reader/billing/billingInfo.do?numId="+numId));
					generalDAO.getSqlMapClient().getCurrentConnection().commit();
					return mav;
				}
			}
			
			String searchText = URLEncoder.encode(param.getString("searchText"), "UTF-8");
			String readNm = URLEncoder.encode(param.getString("readNm"), "UTF-8");
			
			if(!"".equals(searchText)){
				mav.addObject("searchText" ,searchText );
				mav.addObject("searchType" ,param.getString("searchType") );
				mav.addObject("flag","chgUrl");
			}else{
				mav.addObject("searchText" ,readNm );
				mav.addObject("searchType" ,"4" );
				mav.addObject("flag","chgUrl");
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
		
		String searchText = URLEncoder.encode(param.getString("searchText"), "UTF-8");
		String readNm = URLEncoder.encode(param.getString("readNm"), "UTF-8");
		
		//구독정보 생성을 위한 정보
		dbparam.put("readNo" , param.getString("readNo"));
		dbparam.put("newsCd" , param.getString("newsCd"));
		dbparam.put("seq" , param.getString("seq"));
		dbparam.put("boSeq" , param.getString("boSeq"));
		dbparam.put("boReadNo" , param.getString("boReadNo"));
		dbparam.put("gno" , param.getString("gno"));
		dbparam.put("bno" , param.getString("bno"));
		dbparam.put("sno" , param.getString("sno"));
		dbparam.put("readTypeCd" , param.getString("readTypeCd"));
		dbparam.put("readNm" , param.getString("readNm"));
		dbparam.put("offiNm" , param.getString("offiNm"));
		dbparam.put("homeTel1" , param.getString("homeTel1"));
		dbparam.put("homeTel2" , param.getString("homeTel2"));
		dbparam.put("homeTel3" , param.getString("homeTel3"));
		dbparam.put("mobile1" , param.getString("mobile1"));
		dbparam.put("mobile2" , param.getString("mobile2"));
		dbparam.put("mobile3" , param.getString("mobile3"));
		dbparam.put("dlvZip" , param.getString("dlvZip"));
		dbparam.put("dlvAdrs1" , param.getString("dlvAdrs1"));
		dbparam.put("dlvAdrs2" , param.getString("dlvAdrs2"));
		dbparam.put("dlvStrNm" , param.getString("dlvStrNm"));
		dbparam.put("dlvStrNo" , param.getString("dlvStrNo"));
		dbparam.put("aptCd" , param.getString("aptCd"));
		dbparam.put("aptDong" , param.getString("aptDong"));
		dbparam.put("aptHo" , param.getString("aptHo"));
		dbparam.put("sgType" , param.getString("sgType"));
		dbparam.put("sgInfo" , param.getString("sgInfo"));
		dbparam.put("sgTel1" , param.getString("sgTel1"));
		dbparam.put("sgTel2" , param.getString("sgTel2"));
		dbparam.put("sgTel3" , param.getString("sgTel3"));
		dbparam.put("uPrice" , param.getString("uPrice"));
		dbparam.put("qty" , param.getString("qty"));
		dbparam.put("stQty" , param.getString("stQty"));
		dbparam.put("rsdTypeCd" , param.getString("rsdTypeCd"));
		dbparam.put("dlvTypeCd" , param.getString("dlvTypeCd"));
		dbparam.put("dlvPosiCd" , param.getString("dlvPosiCd"));
		dbparam.put("hjPathCd" , param.getString("hjPathCd"));
		dbparam.put("hjTypeCd" , param.getString("hjTypeCd"));
		dbparam.put("hjPsregCd" , param.getString("hjPsregCd"));
		dbparam.put("hjPsnm" , param.getString("hjPsnm"));
		dbparam.put("hjDt" , StringUtil.replace(param.getString("hjDt"), "-", ""));
		dbparam.put("sgBgmm" , StringUtil.replace(param.getString("sgBgmm"), "-", ""));
		dbparam.put("sgEdmm" , param.getString("sgEdmm"));
		dbparam.put("sgCycle" , param.getString("sgCycle"));
		dbparam.put("stdt" , StringUtil.replace(param.getString("stdt"), "-", ""));
		dbparam.put("stSayou" , param.getString("stSayou"));
		dbparam.put("aplcDt" , StringUtil.replace(param.getString("hjDt2"), "-", ""));
		dbparam.put("aplcNo" , param.getString("aplcNo"));
		dbparam.put("remk" , param.getString("remk"));
		dbparam.put("spRemk" , param.getString("spRemk"));
		dbparam.put("inps" , param.getString("inps"));
		dbparam.put("spgCd" , param.getString("spgCd"));
		dbparam.put("bnsBookCd" , param.getString("bnsBookCd"));
		dbparam.put("taskCd" , param.getString("taskCd"));
		dbparam.put("intFldCd" , param.getString("intFldCd"));
		dbparam.put("bidt" , param.getString("bidt"));
		dbparam.put("eMail" , param.getString("eMail"));
		if("on".equals(param.getString("receipt"))){
			dbparam.put("receipt" , "N");	
		}else{
			dbparam.put("receipt" , "Y");
		}
		
		System.out.println("oldsgtype" + param.getString("oldSgType"));
		System.out.println("sgtype" + param.getString("sgType"));
		
		dbparam.put("agency_serial", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
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
		dbparam.put("realJikuk" , dbparam.get("agency_serial"));
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
				generalDAO.getSqlMapClient().update("reader.readerManage.updateTmreader", dbparam); //통합독자 수정
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
			dbparam.put("startYYMM", param.getString("preYear01"));
			dbparam.put("endYYMM", param.getString("nextYear12"));
			List collectionList = generalDAO.queryForList("collection.collection.collectionList", dbparam);//수금정보 조회

			for(int i=1 ; i <13 ; i++ ){
				dbparam.put("lossAmt", "");//초기화
				String index="";
				if(i<10){
					index = '0'+Integer.toString(i);
				}else{
					index = Integer.toString(i);
				}

				dbparam.put("preYear"+index , param.getString("preYear"+index));
				dbparam.put("preSnDt"+index , StringUtil.replace(param.getString("preSnDt"+index), "-", ""));
				dbparam.put("preBillAmt"+index , param.getString("preBillAmt"+index));
				dbparam.put("preAmt"+index , param.getString("preAmt"+index));
				dbparam.put("preSgbbCd"+index , param.getString("preSgbbCd"+index));
				dbparam.put("nowYear"+index , param.getString("nowYear"+index));
				dbparam.put("nowSnDt"+index , StringUtil.replace(param.getString("nowSnDt"+index), "-", ""));
				dbparam.put("nowBillAmt"+index , param.getString("nowBillAmt"+index));
				dbparam.put("nowAmt"+index , param.getString("nowAmt"+index));
				dbparam.put("nowSgbbCd"+index , param.getString("nowSgbbCd"+index));
				dbparam.put("nextYear"+index , param.getString("nextYear"+index));
				dbparam.put("nextSnDt"+index , StringUtil.replace(param.getString("nextSnDt"+index), "-", ""));
				dbparam.put("nextBillAmt"+index , param.getString("nextBillAmt"+index));
				dbparam.put("nextAmt"+index , param.getString("nextAmt"+index));
				dbparam.put("nextSgbbCd"+index , param.getString("nextSgbbCd"+index));
				
				/** 이전수금처리 */
				if(!"".equals(dbparam.get("preSnDt"+index)) || !"".equals(dbparam.get("preBillAmt"+index)) || !"".equals(dbparam.get("preAmt"+index)) || !"".equals(dbparam.get("preSgbbCd"+index))){
					boolean ckeck = true;
					dbparam.put("yymm", dbparam.get("preYear"+index));
					dbparam.put("sgbbCd", dbparam.get("preSgbbCd"+index));
					dbparam.put("amt", dbparam.get("preAmt"+index));
					dbparam.put("billAmt", dbparam.get("preBillAmt"+index));
					dbparam.put("snDt", dbparam.get("preSnDt"+index));
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
						if(  dbparam.get("preYear"+index).equals(cList.get("YYMM"))  ){
							if( dbparam.get("preSnDt"+index).equals(cList.get("ICDT")) && dbparam.get("preBillAmt"+index).equals(String.valueOf(cList.get("BILLAMT"))) &&	
								dbparam.get("preAmt"+index).equals(String.valueOf(cList.get("AMT"))) && dbparam.get("preSgbbCd"+index).equals(cList.get("SGBBCD"))){
								ckeck = false;
							}else {
								generalDAO.getSqlMapClient().insert("collection.collection.insertReaderSugmHist", dbparam); //수금정보히스토리업데이트
								generalDAO.getSqlMapClient().update("collection.collection.updateReaderSugm", dbparam); //수금정보 업데이트 (ABC : updateReaderSugm2)
								ckeck = false;
							}
						}
					}
					if(ckeck){
						generalDAO.insert("collection.collection.insertReaderSugm", dbparam); //수금정보 생성  (ABC : insertReaderSugm2)
					}
				}
				/** 이전수금처리 END */
				
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
				
				/** 다음수금처리 */
				if(!"".equals(dbparam.get("nextSnDt"+index)) || !"".equals(dbparam.get("nextBillAmt"+index)) || !"".equals(dbparam.get("nextAmt"+index)) || !"".equals(dbparam.get("nextSgbbCd"+index))){
					boolean ckeck = true;
					dbparam.put("yymm", dbparam.get("nextYear"+index));
					dbparam.put("sgbbCd", dbparam.get("nextSgbbCd"+index));
					dbparam.put("amt", dbparam.get("nextAmt"+index));
					dbparam.put("billAmt", dbparam.get("nextBillAmt"+index));
					dbparam.put("snDt", dbparam.get("nextSnDt"+index));
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
						if(  dbparam.get("nextYear"+index).equals(cList.get("YYMM"))  ){
							if( dbparam.get("nextSnDt"+index).equals(cList.get("ICDT")) && dbparam.get("nextBillAmt"+index).equals(String.valueOf(cList.get("BILLAMT"))) &&	
								dbparam.get("nextAmt"+index).equals(String.valueOf(cList.get("AMT"))) && dbparam.get("nextSgbbCd"+index).equals(cList.get("SGBBCD"))){
								ckeck = false;
							}else {
								generalDAO.getSqlMapClient().insert("collection.collection.insertReaderSugmHist", dbparam); //수금정보히스토리업데이트
								generalDAO.getSqlMapClient().update("collection.collection.updateReaderSugm", dbparam); //수금정보 업데이트  (ABC : updateReaderSugm2)
								ckeck = false;
							}
						}
					}
					if(ckeck){
						generalDAO.insert("collection.collection.insertReaderSugm", dbparam); //수금정보 생성 (ABC : insertReaderSugm2)
					}
				}
			}
			/** 다음수금처리 END */
			
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
				
				// 수금주기 변경시 같은 독자의 정보를 함께 변경한다 ( 2012.08.17 박윤철 )
				if(!param.getString("sgCycle").equals(param.getString("oldSgCycle"))){
						//같은 독자번호를 가진 고객의 경우 수금주기정보도 같이 변경된다.
						generalDAO.getSqlMapClient().update("reader.readerManage.updateReaderSgCycle", dbparam);	//수금방법 수정
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
						numId = (String)generalDAO.getSqlMapClient().queryForObject("reader.billing.getNumIdForNew" , dbparam);// 자동이체 등록 번호 조회	
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
					//mav.setView(new RedirectView("/reader/billing/billingInfo.do?numId="+numId));
					//한글깨짐처리
					String strPparam1 = URLEncoder.encode(param.getString("readNm"), "UTF-8");
					strPparam1=new String(strPparam1.getBytes("8859_1"),"UTF-8"); 
					mav.setView(new RedirectView("/reader/billing/searchBilling.do?flag=chgUrl&search_type=search_type&status=EA00&search_key="+strPparam1)); 
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

				if(!"".equals(searchText)){
					mav.addObject("searchText" ,searchText);
					mav.addObject("searchType" ,param.getString("searchType") );
					mav.addObject("flag","chgUrl");
				}else{
					mav.addObject("searchText" ,readNm);
					mav.addObject("searchType" ,"4" );
					mav.addObject("flag","chgUrl");
				}
				mav.setView(new RedirectView("/reader/readerManage/searchReader.do"));
				generalDAO.getSqlMapClient().getCurrentConnection().commit();
				return mav;
			} else if("021".equals(param.getString("sgType")) && !"".equals(param.getString("stdt"))  && (param.getString("qty").equals(param.getString("stQty")))) { 			//자동이체 ----> 구독중지 이고 전체 해지 EA13-로 변경 (단 seq==1 일때만)
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
					if(!"".equals(searchText)){
						mav.addObject("searchText" ,searchText);
						mav.addObject("searchType" ,param.getString("searchType") );
						mav.addObject("flag","chgUrl");
					}else{
						mav.addObject("searchText" ,readNm );
						mav.addObject("searchType" ,"4" );
						mav.addObject("flag","chgUrl");
					}
					mav.setView(new RedirectView("/reader/readerManage/searchReader.do"));
					generalDAO.getSqlMapClient().getCurrentConnection().commit();
					return mav;
				}
			} else if( "022".equals(param.getString("oldSgType")) && !"022".equals(param.getString("sgType"))) { 			//카드 ----> 카드X 카드해지처리
				System.out.println("카드만 해지처리========================================>");
				dbparam.put("readNo", param.getString("readNo"));
				//카드정보 조회
				Map cardDatas = (Map)generalDAO.getSqlMapClient().queryForObject("reader.card.selectCardSeqForReaderNews" , dbparam);
				
				if(cardDatas != null) { //카드정보가 살아 있을때만
					String cardSeq = (String)cardDatas.get("CARD_SEQ");
					String readerId = (String)cardDatas.get("ID");
							
					dbparam.put("cardSeq", cardSeq);
					dbparam.put("id", readerId);
					
					generalDAO.getSqlMapClient().update("reader.card.cancelCardReaderForReaderNews", dbparam); //카드정보해지
					generalDAO.getSqlMapClient().update("reader.card.cancelCardPaymentForReaderNews", dbparam); //카드신청정보해지
				} else {
					mav.setViewName("common/message");
					mav.addObject("message", "카드독자정보가 없습니다. 확인해주세요.");
					mav.addObject("returnURL", "/index.jsp");
					return mav;
				}
			} else if( "022".equals(param.getString("oldSgType")) && "022".equals(param.getString("sgType")) && !"".equals(param.getString("stdt"))  && (param.getString("qty").equals(param.getString("stQty")))) { 			//카드 ----> 카드X 카드해지처리
				System.out.println("카드독자 해지처리========================================>");
				
				dbparam.put("readNo", param.getString("readNo"));
				//카드정보 조회
				Map cardDatas = (Map)generalDAO.getSqlMapClient().queryForObject("reader.card.selectCardSeqForReaderNews" , dbparam);
				
				String cardSeq = (String)cardDatas.get("CARD_SEQ");
				String readerId = (String)cardDatas.get("ID");
						
				dbparam.put("cardSeq", cardSeq);
				dbparam.put("id", readerId);
				
				generalDAO.getSqlMapClient().update("reader.card.cancelCardReaderForReaderNews", dbparam); //카드정보해지
				generalDAO.getSqlMapClient().update("reader.card.cancelCardPaymentForReaderNews", dbparam); //카드신청정보해지
			}
			
			if(!"".equals(searchText)){
				mav.addObject("searchText" ,searchText );
				mav.addObject("searchType" ,param.getString("searchType") );
				mav.addObject("flag","chgUrl");
			}else{
				mav.addObject("searchText" ,readNm );
				mav.addObject("searchType" ,"4" );
				mav.addObject("flag","chgUrl");
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
	
	
	
	/**
	 * 추가 구독 || 매체 추가 팝업
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView popExtendReader(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		try{
			
			HashMap dbparam = new HashMap();
			dbparam.put("agency_serial", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			List newSList = generalDAO.queryForList("reader.common.retrieveNewsList", dbparam);//신문코드 조회
			
			mav.addObject("newsCd" , param.getString("newsCd"));
			mav.addObject("newSList" , newSList);	
			mav.addObject("gbn" , param.getString("gbn"));
			mav.addObject("sgBgmm" , param.getString("sgBgmm"));
			mav.setViewName("/reader/pop_extendReader");	
			return mav;

		}catch(Exception e){
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	
	/**
	 * 추가 구독 || 매체 추가
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView extendReader(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		try{
			HashMap dbparam = new HashMap();

			dbparam.put("readNo" , param.getString("readNo"));
			dbparam.put("newsCd" , param.getString("newsCd"));
			dbparam.put("seq" , param.getString("seq"));
			dbparam.put("boSeq" , param.getString("boSeq"));
			dbparam.put("boReadNo" , param.getString("boReadNo"));
			dbparam.put("gno" , param.getString("gno"));
			dbparam.put("bno" , param.getString("bno"));
			dbparam.put("sno" , param.getString("sno"));
			dbparam.put("readTypeCd" , param.getString("readTypeCd"));
			dbparam.put("readNm" , param.getString("readNm"));
			dbparam.put("offiNm" , param.getString("offiNm"));
			dbparam.put("homeTel1" , param.getString("homeTel1"));
			dbparam.put("homeTel2" , param.getString("homeTel2"));
			dbparam.put("homeTel3" , param.getString("homeTel3"));
			dbparam.put("mobile1" , param.getString("mobile1"));
			dbparam.put("mobile2" , param.getString("mobile2"));
			dbparam.put("mobile3" , param.getString("mobile3"));
			dbparam.put("dlvZip" , param.getString("dlvZip"));
			dbparam.put("dlvAdrs1" , param.getString("dlvAdrs1"));
			dbparam.put("dlvAdrs2" , param.getString("dlvAdrs2"));
			dbparam.put("dlvStrNm" , param.getString("dlvStrNm"));
			dbparam.put("dlvStrNo" , param.getString("dlvStrNo"));
			dbparam.put("aptCd" , param.getString("aptCd"));
			dbparam.put("aptDong" , param.getString("aptDong"));
			dbparam.put("aptHo" , param.getString("aptHo"));
			dbparam.put("sgType" , param.getString("sgType"));
			dbparam.put("sgInfo" , param.getString("sgInfo"));
			dbparam.put("sgTel1" , param.getString("sgTel1"));
			dbparam.put("sgTel2" , param.getString("sgTel2"));
			dbparam.put("sgTel3" , param.getString("sgTel3"));
			dbparam.put("uPrice" , param.getString("uPrice"));
			dbparam.put("qty" , param.getString("qty"));
			dbparam.put("stQty" , param.getString("stQty"));
			dbparam.put("rsdTypeCd" , param.getString("rsdTypeCd"));
			dbparam.put("dlvTypeCd" , param.getString("dlvTypeCd"));
			dbparam.put("dlvPosiCd" , param.getString("dlvPosiCd"));
			dbparam.put("hjPathCd" , param.getString("hjPathCd"));
			dbparam.put("hjTypeCd" , param.getString("hjTypeCd"));
			dbparam.put("hjPsregCd" , param.getString("hjPsregCd"));
			dbparam.put("hjPsnm" , param.getString("hjPsnm"));
			dbparam.put("hjDt" , StringUtil.replace(param.getString("hjDt"), "-", ""));
			dbparam.put("sgBgmm" , StringUtil.replace(param.getString("sgBgmm"), "-", ""));
			dbparam.put("sgEdmm" , param.getString("sgEdmm"));
			dbparam.put("sgCycle" , param.getString("sgCycle"));
			dbparam.put("stdt" , StringUtil.replace(param.getString("stdt"), "-", ""));
			dbparam.put("stSayou" , param.getString("stSayou"));
			dbparam.put("aplcDt" , param.getString("aplcDt"));
			dbparam.put("aplcNo" , param.getString("aplcNo"));
			dbparam.put("remk" , param.getString("remk"));
			dbparam.put("inps" , param.getString("inps"));
			dbparam.put("chgPs" , param.getString("chgPs"));
			dbparam.put("spgCd" , param.getString("spgCd"));
			dbparam.put("bnsBookCd" , param.getString("bnsBookCd"));
			dbparam.put("taskCd" , param.getString("taskCd"));
			dbparam.put("intFldCd" , param.getString("intFldCd"));
			dbparam.put("bidt" , param.getString("bidt"));
			dbparam.put("eMail" , param.getString("eMail"));
			if("on".equals(param.getString("receipt"))){
				dbparam.put("receipt" , "N");	
			}else{
				dbparam.put("receipt" , "Y");
			}
			dbparam.put("agency_serial", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			
			//확장 구독
			dbparam.put("extendQty", param.getInt("qty"));
			generalDAO.insert("reader.readerManage.inserExtendTmreaderNews", dbparam); //확장 구독정보 생성

			String searchText = URLEncoder.encode(param.getString("searchText"), "UTF-8");
			String readNm = URLEncoder.encode(param.getString("readNm"), "UTF-8");
			if(!"".equals(searchText)){
				mav.addObject("searchText" ,searchText );
				mav.addObject("searchType" ,param.getString("searchType") );
				mav.addObject("flag","chgUrl");
			}else{
				mav.addObject("searchText" ,readNm);
				mav.addObject("searchType" ,"4" );
				mav.addObject("flag","chgUrl");
			}
			mav.setView(new RedirectView("/reader/readerManage/searchReader.do"));	
				
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
	 * 추가 구독 || 매체 추가(ABC용)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView extendReaderForABC(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		try{
			HashMap dbparam = new HashMap();

			dbparam.put("readNo" , param.getString("readNo"));
			dbparam.put("newsCd" , param.getString("newsCd"));
			dbparam.put("seq" , param.getString("seq"));
			dbparam.put("boSeq" , param.getString("boSeq"));
			dbparam.put("boReadNo" , param.getString("boReadNo"));
			dbparam.put("gno" , param.getString("gno"));
			dbparam.put("bno" , param.getString("bno"));
			dbparam.put("sno" , param.getString("sno"));
			dbparam.put("readTypeCd" , param.getString("readTypeCd"));
			dbparam.put("readNm" , param.getString("readNm"));
			dbparam.put("offiNm" , param.getString("offiNm"));
			dbparam.put("homeTel1" , param.getString("homeTel1"));
			dbparam.put("homeTel2" , param.getString("homeTel2"));
			dbparam.put("homeTel3" , param.getString("homeTel3"));
			dbparam.put("mobile1" , param.getString("mobile1"));
			dbparam.put("mobile2" , param.getString("mobile2"));
			dbparam.put("mobile3" , param.getString("mobile3"));
			dbparam.put("dlvZip" , param.getString("dlvZip"));
			dbparam.put("dlvAdrs1" , param.getString("dlvAdrs1"));
			dbparam.put("dlvAdrs2" , param.getString("dlvAdrs2"));
			dbparam.put("newaddr" , param.getString("newaddr"));
			dbparam.put("bdMngNo" , param.getString("bdMngNo"));
			dbparam.put("dlvStrNm" , param.getString("dlvStrNm"));
			dbparam.put("dlvStrNo" , param.getString("dlvStrNo"));
			dbparam.put("aptCd" , param.getString("aptCd"));
			dbparam.put("aptDong" , param.getString("aptDong"));
			dbparam.put("aptHo" , param.getString("aptHo"));
			dbparam.put("sgType" , param.getString("sgType"));
			dbparam.put("sgInfo" , param.getString("sgInfo"));
			dbparam.put("sgTel1" , param.getString("sgTel1"));
			dbparam.put("sgTel2" , param.getString("sgTel2"));
			dbparam.put("sgTel3" , param.getString("sgTel3"));
			dbparam.put("uPrice" , param.getString("uPrice"));
			dbparam.put("qty" , param.getString("qty"));
			dbparam.put("stQty" , param.getString("stQty"));
			dbparam.put("rsdTypeCd" , param.getString("rsdTypeCd"));
			dbparam.put("dlvTypeCd" , param.getString("dlvTypeCd"));
			dbparam.put("dlvPosiCd" , param.getString("dlvPosiCd"));
			dbparam.put("hjPathCd" , param.getString("hjPathCd"));
			dbparam.put("hjTypeCd" , param.getString("hjTypeCd"));
			dbparam.put("hjPsregCd" , param.getString("hjPsregCd"));
			dbparam.put("hjPsnm" , param.getString("hjPsnm"));
			dbparam.put("hjDt" , StringUtil.replace(param.getString("hjDt"), "-", ""));
			dbparam.put("sgBgmm" , StringUtil.replace(param.getString("sgBgmm"), "-", ""));
			dbparam.put("sgEdmm" , param.getString("sgEdmm"));
			dbparam.put("sgCycle" , param.getString("sgCycle"));
			dbparam.put("stdt" , StringUtil.replace(param.getString("stdt"), "-", ""));
			dbparam.put("stSayou" , param.getString("stSayou"));
			dbparam.put("aplcDt" , StringUtil.replace(param.getString("hjDt2"), "-", ""));
			dbparam.put("aplcNo" , param.getString("aplcNo"));
			dbparam.put("remk" , param.getString("remk"));
			dbparam.put("inps" , param.getString("inps"));
			dbparam.put("chgPs" , param.getString("chgPs"));
			dbparam.put("spgCd" , param.getString("spgCd"));
			dbparam.put("bnsBookCd" , param.getString("bnsBookCd")); 
			dbparam.put("taskCd" , param.getString("taskCd"));
			dbparam.put("intFldCd" , param.getString("intFldCd"));
			dbparam.put("bidt" , param.getString("bidt"));
			dbparam.put("eMail" , param.getString("eMail"));
			if("on".equals(param.getString("receipt"))){
				dbparam.put("receipt" , "N");	
			}else{
				dbparam.put("receipt" , "Y");
			}
			dbparam.put("agency_serial", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			
			//확장 구독
			dbparam.put("extendQty", param.getInt("qty"));
			generalDAO.insert("reader.readerManage.inserExtendTmreaderNewsForABC", dbparam); //확장 구독정보 생성

			String searchText = URLEncoder.encode(param.getString("searchText"), "UTF-8");
			String readNm = URLEncoder.encode(param.getString("readNm"), "UTF-8");
			if(!"".equals(searchText)){
				mav.addObject("searchText" ,searchText );
				mav.addObject("searchType" ,param.getString("searchType") );
				mav.addObject("flag","chgUrl");
			}else{
				mav.addObject("searchText" ,readNm);
				mav.addObject("searchType" ,"4" );	
				mav.addObject("flag","chgUrl");
			}
			
			mav.setView(new RedirectView("/reader/readerManage/searchReader.do"));
				
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
	 * 주소 코드 팝업
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView popAddrCode(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		HashMap dbparam = new HashMap();
		Param param = new HttpServletParam(request);
		try{
			dbparam.put("agency_serial", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			dbparam.put("cmd", param.getString("cmd"));
			List addrList = generalDAO.queryForList("reader.readerManage.retrieveAddrCode", dbparam);
			
			// mav 
			mav.addObject("param" , param);
			mav.addObject("addrList" , addrList);
			mav.setViewName("reader/pop_addrCode");	
			return mav;

		}catch(Exception e){
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	
	/**
	 * 우편 주소 팝업
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView popAddr(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		// mav 
		mav.addObject("cmd" , param.getString("cmd"));
		mav.setViewName("reader/pop_addr");	
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
	public ModelAndView searchAddr(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		ModelAndView mav = new ModelAndView();
		
		HashMap dbparam = new HashMap();
		Param param = new HttpServletParam(request);
		try{
			dbparam.put("search", param.getString("search"));
			List addrList = generalDAO.queryForList("reader.readerManage.retrieveAddr", dbparam);
			// mav 
			mav.addObject("cmd" , param.getString("cmd"));
			mav.addObject("search" , param.getString("search"));
			mav.addObject("addrList" , addrList);
			mav.setViewName("reader/pop_addr");	
			return mav;

		}catch(Exception e){
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	
	/**
	 * 다부수 해지 팝업
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView popCloseReader(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		// mav 
		mav.setViewName("reader/pop_close");	
		return mav;
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
			
			List gnoList = generalDAO.queryForList("etc.deadLine.reterieveGnoList", dbparam);
			
			for(int i=0; i < gnoList.size() ; i++){
				Map tem = (Map) gnoList.get(i);

				dbparam.put("gno", tem.get("GNO"));
				System.out.print(dbparam.get("gno"));
				generalDAO.queryForObject("etc.deadLine.deliverNumSort", dbparam);
			}
			mav.setViewName("common/message");
			mav.addObject("message", "배달번호 정렬 작업이 완료 되었습니다.");
			mav.addObject("returnURL", "/reader/readerManage/readerList.do");
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
	 * 중지여부 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ajaxCheckStopReaderYN(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		
		try{
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			Map<String, Object> collectionMap = new HashMap<String, Object>();;
			Map<String, Object> sugmTypeMap = new HashMap<String, Object>();;
			int index = 0;
			
			dbparam.put("readNo", param.getString("readNo")); // 고객번호
			dbparam.put("newsCd", param.getString("newsCd")); // 뉴스코드
			dbparam.put("seq", param.getString("seq")); // 일련번호
			dbparam.put("boSeq", param.getString("boSeq"));	
			
			String chgDt = (String)generalDAO.queryForObject("reader.readerManage.selectCheckchangeDate", dbparam);
			
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("chgDt", chgDt);
			
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	
	/**
	 * 독자정보 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ajaxSelectReaderData(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		
		try{
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			Map<String, Object> collectionMap = new HashMap<String, Object>();;
			Map<String, Object> sugmTypeMap = new HashMap<String, Object>();;
			int index = 0;

			dbparam.put("readno", param.getString("readNo")); // 고객번호
			dbparam.put("newscd", param.getString("newsCd")); // 뉴스코드
			dbparam.put("seq", param.getString("seq")); // 일련번호
			dbparam.put("boseq", param.getString("boSeq"));
			dbparam.put("BOSEQ", param.getString("boSeq"));	
			
			Map<String, Object> readerData= (Map)generalDAO.queryForObject("reader.readerManage.getReaderView", dbparam);
			List guYukList = generalDAO.queryForList("common.getAgencyAreaList", dbparam);					//구역코드 조회
			List areaCode = generalDAO.queryForList("reader.common.retrieveAreaCode" , dbparam);			// 전화번호 지역번호 조회
			List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" , dbparam);		// 핸도폰 앞자리 번호 조회
			
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("readerData", readerData);
			jsonObject.put("guYukList", JSONArray.fromObject(guYukList));
			jsonObject.put("areaCodeList", JSONArray.fromObject(areaCode));
			jsonObject.put("mobileCodeList", JSONArray.fromObject(mobileCode));
			
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	
	/**
	 * 독자수금 조회(올해)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ajaxSelectReaderSumgData(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		
		// 현재날짜
		Calendar rightNow = Calendar.getInstance();
		String thisYear = String.valueOf(rightNow.get(Calendar.YEAR));
		String thisMonth = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));
		
		try{
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			Map<String, Object> sugmMap = new HashMap<String, Object>();;
			int index = 0;

			dbparam.put("readNo", param.getString("readNo")); // 고객번호
			dbparam.put("newsCd", param.getString("newsCd")); // 뉴스코드
			dbparam.put("seq", param.getString("seq")); // 일련번호
			dbparam.put("boSeq", param.getString("boSeq"));	
			dbparam.put("startYYMM", thisYear+"01");
			dbparam.put("endYYMM", thisYear+"12");
			
			List<Map<String, Object>> readerSugmData= generalDAO.queryForList("collection.collection.collectionList", dbparam);
			
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("readerSugmData", JSONArray.fromObject(readerSugmData));
			
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
		
}
