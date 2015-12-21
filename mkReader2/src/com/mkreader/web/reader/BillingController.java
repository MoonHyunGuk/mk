/*------------------------------------------------------------------------------
 * NAME : BillingController 
 * DESC : 자동이체독자(지국)
 * Author : pspkj
 *----------------------------------------------------------------------------*/
package com.mkreader.web.reader;

import java.net.URLDecoder;
import java.net.URLEncoder;
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

public class BillingController extends MultiActionController implements
ISiteConstant, ICodeConstant {

	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}
	
	/**
	 * 자동이체 독자 리스트
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
			HashMap<String,Object> dbparam = new HashMap<String,Object>();
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 20;
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			int totalCount = 0;
			dbparam.put("realJikuk", session.getAttribute(SESSION_NAME_AGENCY_USERID));
			
			List billingList = generalDAO.queryForList("reader.billing.getBillingList" , dbparam);// 자동이체 일반독자 리스트
			totalCount = generalDAO.count("reader.billing.getBillingCount" , dbparam);// 자동이체 일반독자 카운트
			
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 20));
			mav.addObject("billingList", billingList);
			mav.addObject("now_menu", MENU_CODE_READER_BILLING);
			mav.setViewName("reader/billing/billingList");
			
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
			HashMap<String,Object> dbparam = new HashMap<String,Object>();
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 20;
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			int totalCount = 0;
			String flag = param.getString("flag");
			String search_key = param.getString("search_key");
			
			//독자관리에서 자동이체독자 화면으로 넘어올때
			if("chgUrl".equals(flag)) {
				search_key = new String(search_key.getBytes("8859_1"),"UTF-8"); 
			}
			
			dbparam.put("realJikuk", session.getAttribute(SESSION_NAME_AGENCY_USERID));
			dbparam.put("search_type" , param.getString("search_type"));
			dbparam.put("search_key" , search_key);
			dbparam.put("status" , param.getString("status"));

			List billingList = generalDAO.queryForList("reader.billing.searchBilling" , dbparam);// 자동이체 일반독자 검색 리스트
			totalCount = generalDAO.count("reader.billing.searchBillingCount" , dbparam);// 자동이체 일반독자 검색 카운트

			
			mav.addObject("search_type", param.getString("search_type"));
			mav.addObject("search_key", search_key);
			mav.addObject("status", param.getString("status"));
			
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 10));
			mav.addObject("billingList", billingList);

			
			mav.addObject("now_menu", MENU_CODE_READER_BILLING);
			mav.setViewName("reader/billing/billingList");
			
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
			HashMap<String,Object> dbparam = new HashMap<String,Object>();
			
			String flag = param.getString("flag");
			
			dbparam.put("numId", param.getString("numId"));

			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" );// 지국 목록
			List areaCode = generalDAO.queryForList("reader.common.retrieveAreaCode" );// 전화번호 지역번호 조회
			List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" );// 핸도폰 앞자리 번호 조회
			List bankInfo = generalDAO.queryForList("reader.common.bankInfo" );// 은행 정보 조회
			int countCalllog = generalDAO.count("reader.billing.countCalllog" , dbparam); // 통화로그 카운트
			Map<String, Object> billingInfo = (Map)generalDAO.queryForObject("reader.billing.billingInfo" , dbparam);// 자동이체 정보
			List memoList = null;
			String zipcode  = null;
			String addr1  = null;
			String addr2  = null;
			String newaddr  = null;
			String bdMngNo = null;
			
			String fullAddr = billingInfo.get("FULLADDR").toString();
			String[] cutAddr = new String[4];
			if(cutAddr != null) {
				cutAddr =	fullAddr.split("[|]"); //우편번호 | addr1 | addr2 | newaddr | bdmngno  ex)613809|광안동 569-13|1층|부산광역시 수영구 장대골로19번가길 46-3|2650010400105690013005758
			}
			
			for(int i=0;i<cutAddr.length;i++) {
				if(i==0) {
					zipcode  = cutAddr[0];
				} else if(i==1) {
					addr1  = cutAddr[1];
				} else if(i==2) {
					addr2  = cutAddr[2];
				} else if(i==3) {
					newaddr  = cutAddr[3];
				}else if(i==4) {
					bdMngNo  = cutAddr[4];
				}
			}
			
			billingInfo.put("DLVZIP", zipcode);
			billingInfo.put("ADDR1", addr1);
			billingInfo.put("ADDR2", addr2);
			billingInfo.put("NEWADDR", newaddr);
			billingInfo.put("BDMNGNO", bdMngNo);
			
			//memoList
			memoList  = generalDAO.queryForList("util.memo.getMemoList" , dbparam);
			
			mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("areaCode" , areaCode);
			mav.addObject("mobileCode" , mobileCode);
			mav.addObject("bankInfo" , bankInfo);
			mav.addObject("billingInfo" , billingInfo);
			mav.addObject("countCalllog" , countCalllog );
			mav.addObject("memoList" , memoList);
			//mav.addObject("now_menu", MENU_CODE_READER_BILLING);
			mav.setViewName("reader/billing/billingInfo");
			
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
			HashMap<String,Object> dbparam = new HashMap<String,Object>();
			dbparam.put("numId",  param.getString("numId"));
			
			dbparam.put("cmsType", String.valueOf("EA13+"));//자동이체 신청 이력 조건 값
			List aplcPayment = generalDAO.queryForList("reader.billingAdmin.paymentHist" , dbparam);// 자동이체 신청 이력

			dbparam.put("cmsType", String.valueOf("EA21"));//자동이체 청구이력 조건값
			List paymentHist = generalDAO.queryForList("reader.billingAdmin.paymentHist" , dbparam);// 자동이체납부이력

			dbparam.put("cmsType", String.valueOf("EA13-"));//자동이체 해지이력 조건값
			List canclePayment = generalDAO.queryForList("reader.billingAdmin.paymentHist" , dbparam);// 자동이체납부이력

			List refundHist = generalDAO.queryForList("reader.billingAdmin.refundHist" , dbparam);// 자동이체 환불 내역

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
			mav.setViewName("reader/billing/pop_paymentHist");
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
	 * 자동이체 정보 최종 등록
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
			HashMap<String,Object> dbparam = new HashMap<String,Object>();
				
			dbparam.put("bankInfo", param.getString("bankInfo")+"0000");
			dbparam.put("userName" , param.getString("userName"));
			dbparam.put("phone" , param.getString("phone1")+"-"+param.getString("phone2")+"-"+param.getString("phone3"));
			//dbparam.put("zip1" , param.getString("zip1"));
			//dbparam.put("zip2" , param.getString("zip2"));
			dbparam.put("dlvZip" , param.getString("dlvZip"));
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
			dbparam.put("memo" , "");
			dbparam.put("numId" , param.getString("numId"));

			// 자동이체 정보 수정
			generalDAO.update("reader.billing.updatePaymentFinal" , dbparam);
			
			//value param
			if(!("").equals(param.getString("memo"))) {	//null이 아닐때만 메모생성
				dbparam.put("READNO", param.getString("readNo"));
				dbparam.put("MEMO", param.getString("memo"));
				dbparam.put("CREATEID",  (String)session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
				
				generalDAO.getSqlMapClient().insert("util.memo.insertMemo", dbparam); //메모생성
			}

			mav.setViewName("common/message");
			mav.addObject("message", "처리 되었습니다.");
			mav.addObject("returnURL", "/reader/billing/billingList.do");
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
		
		HashMap<String,Object> dbparam = new HashMap<String,Object>();
		Param param = new HttpServletParam(request);
		try{
			dbparam.put("numId", param.getString("numId"));
			List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" );// 핸도폰 앞자리 번호 조회
			List bankInfo = generalDAO.queryForList("reader.common.bankInfo" );// 은행 정보 조회
			List billingInfo = generalDAO.queryForList("reader.billing.billingInfo" , dbparam);// 자동이체 정보
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
		
		HashMap<String,Object> dbparam = new HashMap<String,Object>();
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
			if("EA21".equals(param.getString("tmp_status"))){//정상 사용중인 독자 계좌번호 변경로직
				dbparam.put("status", "EA00");
				//기존데이터를 신규로 복사하면서 EA13- 로 등록
				generalDAO.getSqlMapClient().insert("reader.billing.cloneBankInfo", dbparam);
				//기존데이터 시리얼 증가 EA00으로 변경
				generalDAO.getSqlMapClient().update("reader.billing.updateBankInfo", dbparam);
				mav.setViewName("common/message");
				mav.addObject("message", "처리 되었습니다.");
				mav.addObject("returnURL", "/reader/billing/searchBilling.do?search_type=userName&status=ALL&search_key="+param.getString("userName"));
			}else{//단순 정보 수정
				generalDAO.getSqlMapClient().update("reader.billing.updateBankInfo", dbparam);
				mav.setViewName("common/message");
				mav.addObject("message", "처리 되었습니다.");
				mav.addObject("returnURL", "/reader/billing/billingInfo.do?numId="+param.getString("numId"));
			}
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
		
		HashMap<String,Object> dbparam = new HashMap<String,Object>();
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
		
		HashMap<String,Object> dbparam = new HashMap<String,Object>();
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
	

}
