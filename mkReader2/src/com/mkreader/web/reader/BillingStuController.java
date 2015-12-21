/*------------------------------------------------------------------------------
 * NAME : BillingStuController 
 * DESC : 자동이체 학생독자(지국)
 * Author : pspkj
 *----------------------------------------------------------------------------*/
package com.mkreader.web.reader;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.util.Param;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;
import org.springframework.web.servlet.view.RedirectView;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.CommonUtil;
import com.mkreader.util.Paging;

public class BillingStuController extends MultiActionController implements
ISiteConstant, ICodeConstant {

	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}
	
	/**
	 * 자동이체 학생 독자 리스트
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView billingList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			HashMap dbparam = new HashMap();
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 20;
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			int totalCount = 0;
			dbparam.put("realJikuk", session.getAttribute(SESSION_NAME_AGENCY_USERID));
			
			List billingList = generalDAO.queryForList("reader.billingStu.getBillingList" , dbparam);// 자동이체 일반독자 리스트
			totalCount = generalDAO.count("reader.billingStu.getBillingCount" , dbparam);// 자동이체 일반독자 카운트
			
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 20));
			mav.addObject("billingList", billingList);
			mav.addObject("status", "EA00");
			mav.addObject("now_menu", MENU_CODE_READER_BILLING);
			mav.setViewName("reader/billing/billingStuList");
			
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
	 * 자동이체 독자 검색
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView searchBilling(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			HashMap dbparam = new HashMap();
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 20;
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			int totalCount = 0;
			
			dbparam.put("realJikuk", session.getAttribute(SESSION_NAME_AGENCY_USERID));
			dbparam.put("search_type" , param.getString("search_type"));
			dbparam.put("search_key" , param.getString("search_key"));
			dbparam.put("status" , param.getString("status"));
			
			totalCount = generalDAO.count("reader.billingStu.searchBillingCount" , dbparam);// 자동이체 일반독자 검색 카운트
			List billingList = generalDAO.queryForList("reader.billingStu.searchBilling" , dbparam);// 자동이체 일반독자 검색 리스트
			
			mav.addObject("search_type", param.getString("search_type"));
			mav.addObject("search_key", param.getString("search_key"));
			mav.addObject("status", param.getString("status"));
			
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 10));
			mav.addObject("billingList", billingList);
			
			mav.addObject("now_menu", MENU_CODE_READER_BILLING);
			mav.setViewName("reader/billing/billingStuList");
			
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
	 * 자동이체 독자 상세보기 페이지
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView billingInfo(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		
		try{
			HashMap dbparam = new HashMap();
			
			dbparam.put("numId", param.getString("numId"));

			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" );// 지국 목록
			List areaCode = generalDAO.queryForList("reader.common.retrieveAreaCode" );// 전화번호 지역번호 조회
			List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" );// 핸도폰 앞자리 번호 조회
			List bankInfo = generalDAO.queryForList("reader.common.bankInfo" );// 은행 정보 조회
			List billingInfo = generalDAO.queryForList("reader.billingStu.billingInfo" , dbparam);// 자동이체 정보
			int countCalllog = generalDAO.count("reader.billingStu.countCalllog" , dbparam); // 통화로그 카운트
			
			//select memo list 
			List memoList  = generalDAO.queryForList("util.memo.getMemoListForStu" , dbparam);
			
			mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("areaCode" , areaCode);
			mav.addObject("mobileCode" , mobileCode);
			mav.addObject("bankInfo" , bankInfo);
			mav.addObject("billingInfo" , billingInfo);
			mav.addObject("countCalllog" , countCalllog);
			mav.addObject("memoList" , memoList);
			//mav.addObject("now_menu", MENU_CODE_READER_BILLING);
			mav.setViewName("reader/billing/billingStuInfo");
			
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
	 * 자동이체 독자 납부이력 보기 페이지
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView popPaymentHist(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		
		try{
			HashMap dbparam = new HashMap();
			dbparam.put("numId",  param.getString("numId"));
			
			dbparam.put("cmsType", String.valueOf("EA13+"));//자동이체 신청 이력 조건 값
			List aplcPayment = generalDAO.queryForList("reader.billingStu.paymentHist" , dbparam);// 자동이체 신청 이력

			dbparam.put("cmsType", String.valueOf("EA21"));//자동이체 청구이력 조건값
			List paymentHist = generalDAO.queryForList("reader.billingStu.paymentHist" , dbparam);// 자동이체납부이력

			dbparam.put("cmsType", String.valueOf("EA13-"));//자동이체 해지이력 조건값
			List canclePayment = generalDAO.queryForList("reader.billingStu.paymentHist" , dbparam);// 자동이체납부이력

			List refundHist = generalDAO.queryForList("reader.billingStu.refundHist" , dbparam);// 자동이체 환불 내역

			if ( aplcPayment != null ) {
				List tmpList = new ArrayList();
				for ( int i = 0; i < aplcPayment.size(); i++ ) {
					Map tmpMap = (Map) aplcPayment.get(i);
					String cmsresult = (String)tmpMap.get("CMSRESULT");
					if ( StringUtils.isNotEmpty(cmsresult) && cmsresult.length() >= 5) {
						if("EEEEE".equals(cmsresult)){
							tmpMap.put("CMSRESULTMSG", "신청확인중");	
						}else{
							tmpMap.put("CMSRESULTMSG", CommonUtil.err_code(cmsresult.substring(1, 5)));	
						}
					}
					tmpList.add(tmpMap);
				}
				aplcPayment = tmpList;
			}
			if ( paymentHist != null ) {
				List tmpList = new ArrayList();
				for ( int i = 0; i < paymentHist.size(); i++ ) {
					Map tmpMap = (Map) paymentHist.get(i);
					String cmsresult = (String)tmpMap.get("CMSRESULT");
					if ( StringUtils.isNotEmpty(cmsresult) && cmsresult.length() >= 5) {
						if("EEEEE".equals(cmsresult)){
							tmpMap.put("CMSRESULTMSG", "신청확인중");	
						}else{
							tmpMap.put("CMSRESULTMSG", CommonUtil.err_code(cmsresult.substring(1, 5)));	
						}
					}
					tmpList.add(tmpMap);
				}
				paymentHist = tmpList;
			}
			if ( canclePayment != null ) {
				List tmpList = new ArrayList();
				for ( int i = 0; i < canclePayment.size(); i++ ) {
					Map tmpMap = (Map) canclePayment.get(i);
					String cmsresult = (String)tmpMap.get("CMSRESULT");
					if ( StringUtils.isNotEmpty(cmsresult) && cmsresult.length() >= 5) {
						if("EEEEE".equals(cmsresult)){
							tmpMap.put("CMSRESULTMSG", "신청확인중");	
						}else{
							tmpMap.put("CMSRESULTMSG", CommonUtil.err_code(cmsresult.substring(1, 5)));	
						}
					}
					tmpList.add(tmpMap);
				}
				canclePayment = tmpList;
			}
			mav.addObject("userName" , param.getString("userName"));
			mav.addObject("aplcPayment" , aplcPayment);
			mav.addObject("paymentHist" , paymentHist);
			mav.addObject("canclePayment" , canclePayment);
			mav.addObject("refundHist" , refundHist);
			
			mav.setViewName("reader/billing/pop_paymentStuHist");
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
	 * 자동이체 일시정지 ,일시정지 해제, 임의 해지
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView pauseControll(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		

		try{
			HashMap dbparam = new HashMap();
			
			dbparam.put("numId", param.getString("numId"));
			dbparam.put("levels", param.getString("levels"));
			dbparam.put("condition", param.getString("condition"));
			
			generalDAO.update("reader.billingStu.updateTblUserStuState", dbparam);

			mav.setViewName("common/message");
			mav.addObject("message", "처리 되었습니다.");
			mav.addObject("returnURL", "/reader/billingStu/billingList.do");
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
	 * 자동이체 해지
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView removePayment(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			HashMap dbparam = new HashMap();
			dbparam.put("chgps", session.getAttribute(SESSION_NAME_AGENCY_USERID));
			
			dbparam.put("agency_serial", dbparam.get("chgps"));
			dbparam.put("numId", param.getString("numId"));
			dbparam.put("readNo", param.getString("readNo"));
			dbparam.put("sgType", "012");
			/*
			 * 자동이체 해지를 하면 구독정보 수금방법을 방문으로 수정
			 * 구독정보 히스토리 업데이트 후 구독정보의 수금방법 수정
			 * 자동이체 해지
			 * */
			List reader = generalDAO.getSqlMapClient().queryForList("reader.readerManage.getReader",dbparam);
			for(int i=0 ; i < reader.size() ; i++){
				Map list = (Map)reader.get(i);
				dbparam.put("newsCd", list.get("NEWSCD"));
				dbparam.put("seq", list.get("SEQ"));
				generalDAO.getSqlMapClient().insert("reader.readerManage.insertreaderHist", dbparam);
			}
			generalDAO.getSqlMapClient().update("reader.readerManage.updateSgType", dbparam);
			generalDAO.getSqlMapClient().update("reader.billingStu.removePayment", dbparam);
			
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			
			mav.setViewName("common/message");
			mav.addObject("message", "처리 되었습니다.");
			mav.addObject("returnURL", "/reader/billingStu/billingList.do");
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
	 * 자동이체 등록 페이지 오픈
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView billingEdit(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		ModelAndView mav = new ModelAndView();
		
	
		List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" );// 지국 목록
		List areaCode = generalDAO.queryForList("reader.common.retrieveAreaCode" );// 전화번호 지역번호 조회
		List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" );// 핸도폰 앞자리 번호 조회
		List bankInfo = generalDAO.queryForList("reader.common.bankInfo" );// 은행 정보 조회
		
		mav.addObject("agencyAllList" , agencyAllList);
		mav.addObject("areaCode" , areaCode);
		mav.addObject("mobileCode" , mobileCode);
		mav.addObject("bankInfo" , bankInfo);
		mav.addObject("now_menu", MENU_CODE_READER_BILLING);
		mav.setViewName("reader/billingAdmin/billingStuEdit");
		return mav;
	}
	
	
	/**
	 * 자동이체 정보 수정
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView updatePaymentFinal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			HashMap dbparam = new HashMap();
				
			dbparam.put("bankInfo", param.getString("bankInfo")+"0000");
			dbparam.put("inType" , param.getString("inType"));
			dbparam.put("stuSch" , param.getString("stuSch"));
			dbparam.put("stuPart" , param.getString("stuPart"));
			dbparam.put("stuClass" , param.getString("stuClass"));
			dbparam.put("stuProf" , param.getString("stuProf"));
			dbparam.put("stuAdm" , param.getString("stuAdm"));
			dbparam.put("stuCaller" , param.getString("stuCaller"));
			dbparam.put("userName" , param.getString("userName"));
			dbparam.put("phone" , param.getString("phone1")+"-"+param.getString("phone2")+"-"+param.getString("phone3"));
			dbparam.put("zip1" , param.getString("zip1"));
			dbparam.put("zip2" , param.getString("zip2"));
			dbparam.put("addr1" , param.getString("addr1"));
			dbparam.put("addr2" , param.getString("addr2"));
			dbparam.put("newaddr" , param.getString("newaddr"));
			dbparam.put("bdMngNo" , param.getString("bdMngNo"));
			dbparam.put("busu" , param.getString("busu"));
			dbparam.put("bankMoney" , param.getString("bankMoney"));
			dbparam.put("bankName" , param.getString("bankName"));
			dbparam.put("bankNum" , param.getString("bankNum"));
			dbparam.put("saup" , param.getString("saup"));
			dbparam.put("handy" , param.getString("handy1")+"-"+param.getString("handy2")+"-"+param.getString("handy3") );
			dbparam.put("email" , param.getString("email"));
			dbparam.put("memo" , param.getString("memo"));
			dbparam.put("numId" , param.getString("numId"));
			dbparam.put("realJikuk", session.getAttribute(SESSION_NAME_AGENCY_USERID));
	
			dbparam.put("readNo" , param.getString("readNo"));
			generalDAO.update("reader.billingStu.updatePaymentFinal" , dbparam);// 자동이체 정보 수정
			
			//value param
			if(!("").equals(param.getString("memo"))) {	//null이 아닐때만 메모생성
				dbparam.put("READNO", param.getString("readNo"));
				dbparam.put("MEMO", param.getString("memo"));
				dbparam.put("CREATEID",  (String)session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
				
				generalDAO.getSqlMapClient().insert("util.memo.insertMemo", dbparam); //메모생성
			}
			
			mav.setViewName("common/message");
			mav.addObject("message", "처리 되었습니다.");
			mav.addObject("returnURL", "/reader/billingStu/billingList.do");
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
	 * 자동이체 통화 메모 팝업
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
			dbparam.put("numId", param.getString("numId"));
			dbparam.put("typeCd", param.getString("typeCd"));
			List callLog = generalDAO.queryForList("reader.billing.callLog", dbparam);

			// mav 
			mav.addObject("param" , param);
			mav.addObject("callLog" , callLog);
			mav.setViewName("reader/billing/pop_callLog");	
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
	 * 독자 통화메모 생성
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
			dbparam.put("numId", param.getString("numId"));
			dbparam.put("typeCd", param.getString("typeCd"));
			dbparam.put("remk" , param.getString("remk"));
			
			generalDAO.insert("reader.billing.insertCallLog", dbparam);

			// mav 
			request.setAttribute("param", param);
			mav.setView(new RedirectView("/reader/billing/popRetrieveCallLog.do?numId="+param.getString("numId")+"&typeCd="+param.getString("typeCd")));	
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
	 * 자동이체 납부자 정보 변경 팝업
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView popChangeBank(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		ModelAndView mav = new ModelAndView();
		
		HashMap dbparam = new HashMap();
		Param param = new HttpServletParam(request);
		try{
			dbparam.put("numId", param.getString("numId"));
			List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" );// 핸도폰 앞자리 번호 조회
			List bankInfo = generalDAO.queryForList("reader.common.bankInfo" );// 은행 정보 조회
			List billingInfo = generalDAO.queryForList("reader.billingStu.billingInfo" , dbparam);// 자동이체 정보
			// mav 
			mav.addObject("param" , param);
			mav.addObject("mobileCode" , mobileCode);
			mav.addObject("bankInfo" , bankInfo);
			mav.addObject("billingInfo" , billingInfo);
			mav.setViewName("reader/billing/pop_bankEdit");	
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
	 * 자동이체 납부자 정보 변경
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView changeBank(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		ModelAndView mav = new ModelAndView();
		
		HashMap dbparam = new HashMap();
		Param param = new HttpServletParam(request);
		HttpSession session = request.getSession();
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			dbparam.put("numId" ,  param.getString("numId"));
			dbparam.put("bankName" , param.getString("bankName"));
			dbparam.put("bankInfo" , param.getString("bankInfo")+"0000");
			dbparam.put("bankNum" , param.getString("bankNum"));
			dbparam.put("bankMoney" , param.getString("bankMoney"));
			dbparam.put("saup" , param.getString("saup"));
			dbparam.put("handy" , param.getString("handy1")+"-"+param.getString("handy2")+"-"+param.getString("handy3") );
			dbparam.put("realJikuk", session.getAttribute(SESSION_NAME_AGENCY_USERID));
			
			//1. 기존데이터 복사 하면서 상태만 ea13-로 변경
			//2. 기존로그 데이터 복사
			//3. numid 증가하면서 기존데이터 복사
			if("EA21".equals(param.getString("tmp_status"))){//정상 사용중인 독자 계좌번호 변경로직
				dbparam.put("status", "EA00");
				//기존데이터를 신규로 복사하면서 EA13- 로 변경
				generalDAO.getSqlMapClient().insert("reader.billingStu.cloneBankInfo", dbparam);
				//신규 numid 조회
				dbparam.put("newNumId", generalDAO.count("reader.billingStu.newNumId", dbparam));
				//기존데이터 numid 증가 EA00으로 변경
				generalDAO.getSqlMapClient().update("reader.billingStu.updateBankInfo", dbparam);
				//기존 로그데이터 복사
				generalDAO.getSqlMapClient().update("reader.billingStu.updateLog", dbparam);
				mav.setViewName("common/message");
				mav.addObject("message", "처리 되었습니다.");
				mav.addObject("returnURL", "/reader/billingStu/searchBilling.do?search_type=userName&status=ALL&search_key="+param.getString("userName"));
				generalDAO.getSqlMapClient().getCurrentConnection().commit();
				return mav;
			}else{//단순 정보 수정
				generalDAO.getSqlMapClient().update("reader.billingStu.updateBankInfo", dbparam);
				mav.setViewName("common/message");
				mav.addObject("message", "처리 되었습니다.");
				mav.addObject("returnURL", "/reader/billingStu/billingInfo.do?numId="+param.getString("numId"));
				generalDAO.getSqlMapClient().getCurrentConnection().commit();
				return mav;
			}
			
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
