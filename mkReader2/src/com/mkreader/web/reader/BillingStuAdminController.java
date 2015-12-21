/*------------------------------------------------------------------------------
 * NAME : BillingStuAdminController 
 * DESC : 자동이체 학생독자(관리자)
 * Author : pspkj
 *----------------------------------------------------------------------------*/
package com.mkreader.web.reader;

import java.util.ArrayList;
import java.util.Calendar;
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
import com.mkreader.util.DateUtil;
import com.mkreader.util.Paging;
import com.mkreader.util.StringUtil;

public class BillingStuAdminController extends MultiActionController implements
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
		
		
		try{
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 20;
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			int totalCount = 0;
			
			List billingList = generalDAO.queryForList("reader.billingStuAdmin.getBillingList" , dbparam);// 자동이체 일반독자 리스트
			totalCount = generalDAO.count("reader.billingStuAdmin.getBillingCount" , dbparam);// 자동이체 일반독자 카운트
			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" , dbparam);// 지국 목록
			
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 20));
			mav.addObject("billingList", billingList);
			mav.addObject("agencyAllList", agencyAllList);
			mav.addObject("status", "EA00");
			mav.addObject("now_menu", MENU_CODE_READER_BILLING);
			mav.setViewName("reader/billingAdmin/billingStuList");
			
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
		
		
		
		try{
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 20;
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			int totalCount = 0;
			
			dbparam.put("realJikuk" , param.getString("realJikuk"));
			dbparam.put("search_type" , param.getString("search_type"));
			dbparam.put("search_key" , param.getString("search_key"));
			dbparam.put("status" , param.getString("status"));
			
			totalCount = generalDAO.count("reader.billingStuAdmin.searchBillingCount" , dbparam);// 자동이체 학생독자 검색 카운트
			List billingList = generalDAO.queryForList("reader.billingStuAdmin.searchBilling" , dbparam);// 자동이체 학생독자 검색 리스트
			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" , dbparam);// 지국 목록
			
			mav.addObject("inType", param.getString("inType"));
			mav.addObject("realJikuk", param.getString("realJikuk"));
			mav.addObject("search_type", param.getString("search_type"));
			mav.addObject("search_key", param.getString("search_key"));
			mav.addObject("status", param.getString("status"));
			
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 10));
			mav.addObject("billingList", billingList);
			mav.addObject("agencyAllList", agencyAllList);
			
			mav.addObject("now_menu", MENU_CODE_READER_BILLING);
			mav.setViewName("reader/billingAdmin/billingStuList");
			
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
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			
			String flag = param.getString("flag");
			dbparam.put("numId", param.getString("numId"));

			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" );// 지국 목록
			List areaCode = generalDAO.queryForList("reader.common.retrieveAreaCode" );// 전화번호 지역번호 조회
			List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" );// 핸도폰 앞자리 번호 조회
			List bankInfo = generalDAO.queryForList("reader.common.bankInfo" );// 은행 정보 조회
			int countCalllog = generalDAO.count("reader.billingStuAdmin.countCalllog" , dbparam); // 통화로그 카운트
			Map billingInfo = (Map)generalDAO.queryForObject("reader.billingStuAdmin.billingInfo" , dbparam);// 자동이체 정보
			Map<String, Object> stopReserveData = null; 			//예약중지정보 조회
			
			
			String zipcode  = null;
			String addr1  = null;
			String addr2  = null;
			String newaddr  = null;
			String bdMngNo = null;
			List memoList = null;
			
			if("UPT".equals(flag) || "SAVEOK".equals(flag)) {
				//select memo list 
				memoList  = generalDAO.queryForList("util.memo.getMemoListForStu" , dbparam);
				
				dbparam.put("readNo", (String)billingInfo.get("READNO"));
				
				//예약중지정보 조회
				 stopReserveData = (Map)generalDAO.queryForObject("reader.billingAdmin.selectStopReserveData", dbparam);
				
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
			}
			
			mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("areaCode" , areaCode);
			mav.addObject("mobileCode" , mobileCode);
			mav.addObject("bankInfo" , bankInfo);
			mav.addObject("billingInfo" , billingInfo);
			mav.addObject("countCalllog" , countCalllog);
			mav.addObject("memoList" , memoList);
			mav.addObject("stopReserveData", stopReserveData);
			mav.addObject("flag", flag);
			
			//mav.addObject("now_menu", MENU_CODE_READER_BILLING);
			mav.setViewName("reader/billingAdmin/billingStuInfo");
			
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
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			dbparam.put("numId",  param.getString("numId"));
			
			dbparam.put("cmsType", String.valueOf("EA13+"));//자동이체 신청 이력 조건 값
			List aplcPayment = generalDAO.queryForList("reader.billingStuAdmin.paymentHist" , dbparam);// 자동이체 신청 이력

			dbparam.put("cmsType", String.valueOf("EA21"));//자동이체 청구이력 조건값
			List paymentHist = generalDAO.queryForList("reader.billingStuAdmin.paymentHist" , dbparam);// 자동이체납부이력

			dbparam.put("cmsType", String.valueOf("EA13-"));//자동이체 해지이력 조건값
			List canclePayment = generalDAO.queryForList("reader.billingStuAdmin.paymentHist" , dbparam);// 자동이체납부이력

			List refundHist = generalDAO.queryForList("reader.billingStuAdmin.refundHist" , dbparam);// 자동이체 환불 내역

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
			
			mav.setViewName("reader/billingAdmin/pop_paymentStuHist");
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
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			//levels 2 ==> 일시정지
			//levels 3==> 일시정지해제
			dbparam.put("numId", param.getString("numId"));
			dbparam.put("levels", param.getString("levels"));
			dbparam.put("condition", param.getString("condition"));
			
			List billingInfo = generalDAO.getSqlMapClient().queryForList("reader.billingStuAdmin.billingInfo" , dbparam);// 자동이체 정보
			Map temp = (Map) billingInfo.get(0);
			dbparam.put("readNo", (String)temp.get("READNO"));
			dbparam.put("agency_serial", (String)temp.get("REALJIKUK"));
			
			if("2".equals(param.getString("levels"))){
				dbparam.put("sgType", "033");
				generalDAO.getSqlMapClient().update("reader.readerManage.updateReaderSgType", dbparam);	//수금방법 수정	
			}else if("3".equals(param.getString("levels"))){
				dbparam.put("sgType", "021");
				generalDAO.getSqlMapClient().update("reader.readerManage.updateReaderSgType", dbparam);	//수금방법 수정
			}
			generalDAO.getSqlMapClient().update("reader.billingStuAdmin.updateTblUserState", dbparam);
			
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			mav.setViewName("common/message");
			mav.addObject("message", "처리 되었습니다.");
			mav.addObject("returnURL", "/reader/billingStuAdmin/billingList.do");
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
			
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			if(session.getAttribute(SESSION_NAME_ADMIN_USERID) != null ){
				dbparam.put("chgps", session.getAttribute(SESSION_NAME_ADMIN_USERID));	
			}else if(session.getAttribute(SESSION_NAME_AGENCY_USERID) != null){
				dbparam.put("chgps", session.getAttribute(SESSION_NAME_AGENCY_USERID));
			}
			
			dbparam.put("agency_serial", dbparam.get("chgps"));
			dbparam.put("numId", param.getString("numId"));
			dbparam.put("readNo", param.getString("readNo"));
			dbparam.put("sgType", "012");
			
			/*
			 * 자동이체 해지를 하면
			 * 구독정보 히스토리 업데이트 후  구독정보 해지
			 * */
			List reader = generalDAO.queryForList("reader.readerManage.getReader",dbparam);
			for(int i=0 ; i < reader.size() ; i++){
				Map list = (Map)reader.get(i);
				dbparam.put("newsCd", list.get("NEWSCD"));
				dbparam.put("seq", list.get("SEQ"));
				generalDAO.insert("reader.readerManage.insertreaderHist", dbparam);
			}

			generalDAO.update("reader.readerManage.closeNews", dbparam);//구독 해지
			generalDAO.update("reader.billingStuAdmin.removePayment", dbparam);
			
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			mav.setViewName("common/message");
			mav.addObject("message", "처리 되었습니다.");
			mav.addObject("returnURL", "/reader/billingStuAdmin/billingList.do");
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
	 * 자동이체 정보 등록 
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView savePayment(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
				
			dbparam.put("bankInfo", param.getString("bankInfo")+"0000");
			
			if(Integer.parseInt(DateUtil.getCurrentDate("yyyyMMdd").substring(6,8)) < 11 ){
				dbparam.put("sdate", DateUtil.getCurrentDate("yyyyMMdd").substring(0,6)+"17");
			}else{
				dbparam.put("sdate", DateUtil.getWantDay(DateUtil.getCurrentDate("yyyyMMdd"), 2, 1).substring(0, 6)+"05");
			}
			
			dbparam.put("inType" , param.getString("inType"));
			dbparam.put("stuSch" , param.getString("stuSch"));
			dbparam.put("stuPart" , param.getString("stuPart"));
			dbparam.put("stuClass" , param.getString("stuClass"));
			dbparam.put("stuProf" , param.getString("stuProf"));
			dbparam.put("stuAdm" , param.getString("stuAdm"));
			dbparam.put("stuCaller" , param.getString("stuCaller"));
			dbparam.put("userName" , param.getString("userName"));
			dbparam.put("phone" , param.getString("phone1")+"-"+param.getString("phone2")+"-"+param.getString("phone3"));
			//dbparam.put("zip1" , param.getString("zip1"));
			//dbparam.put("zip2" , param.getString("zip2"));
			dbparam.put("dlvZip" , param.getString("dlvZip"));
			dbparam.put("addr1" , param.getString("addr1"));
			dbparam.put("addr2" , param.getString("addr2"));
			dbparam.put("newaddr" , param.getString("newaddr"));
			dbparam.put("realJikuk" , param.getString("realJikuk"));
			dbparam.put("busu" , param.getString("busu"));
			dbparam.put("bankMoney" , param.getString("bankMoney"));
			dbparam.put("bankName" , param.getString("bankName"));
			dbparam.put("bankNum" , param.getString("bankNum"));
			dbparam.put("saup" , param.getString("saup"));
			dbparam.put("handy" , param.getString("handy1")+"-"+param.getString("handy2")+"-"+param.getString("handy3") );
			dbparam.put("email" , param.getString("email"));
			dbparam.put("memo" , param.getString("memo"));
			dbparam.put("whoStep" , "1");
			dbparam.put("bdMngNo" , param.getString("bdMngNo"));
			
			//numId 가져오기
			String numId = (String)generalDAO.queryForObject("reader.billingStuAdmin.getStuUsersNumId");
			dbparam.put("numId" , numId);
				
			// 자동이체 정보 등록
			generalDAO.insert("reader.billingStuAdmin.savePayment" , dbparam);
			
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			generalDAO.getSqlMapClient().endTransaction();
			
			mav.setViewName("common/message");
			mav.addObject("message", "처리 되었습니다.");
			mav.addObject("returnURL", "/reader/billingStuAdmin/billingList.do");
			return mav;
		}catch(Exception e){
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			generalDAO.getSqlMapClient().endTransaction();
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
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
				
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
			//dbparam.put("zip1" , param.getString("zip1"));
			//dbparam.put("zip2" , param.getString("zip2"));
			dbparam.put("dlvZip" , param.getString("dlvZip"));
			dbparam.put("addr1" , param.getString("addr1"));
			dbparam.put("addr2" , param.getString("addr2"));
			dbparam.put("newaddr" , param.getString("newaddr"));
			dbparam.put("bdMngNo" , param.getString("bdMngNo"));
			dbparam.put("jiSerial" , param.getString("jiSerial"));
			dbparam.put("realJikuk" , param.getString("realJikuk"));
			dbparam.put("busu" , param.getString("busu"));
			dbparam.put("bankMoney" , param.getString("bankMoney"));
			dbparam.put("bankName" , param.getString("bankName"));
			dbparam.put("bankNum" , param.getString("bankNum"));
			dbparam.put("saup" , param.getString("saup"));
			dbparam.put("handy" , param.getString("handy1")+"-"+param.getString("handy2")+"-"+param.getString("handy3") );
			dbparam.put("email" , param.getString("email"));
			dbparam.put("memo" , param.getString("memo"));
			dbparam.put("numId" , param.getString("numId"));
			dbparam.put("oldNumId" , param.getString("numId"));
			dbparam.put("dbMngNum" , param.getString("dbMngNum"));
			if("on".equals(param.getString("newYn"))){
				dbparam.put("newYn" , "Y");	
			}else{
				dbparam.put("newYn" , "N");
			}
			
			// 예약해지관련
			String cancelDt = param.getString("cancelDt");
			dbparam.put("cancelMemo", param.getString("cancelMemo"));
			dbparam.put("cancelDt", param.getString("cancelDt"));
			dbparam.put("loginId",	session.getAttribute(SESSION_NAME_ADMIN_USERID));
			dbparam.put("readerType", "학생");
			
			if("기존".equals(param.getString("inType"))){
				if("".equals(param.getString("serial"))){  //납부자번호가 없을떄
					
					dbparam.put("readNo", param.getString("readNo"));
					List rederInfo = generalDAO.getSqlMapClient().queryForList("reader.billingStuAdmin.getReaderInfo" , dbparam);// 고객 정보 조회(독자 번호)
					
					if(rederInfo.size() == 0) { //독자번호가 없을때
						mav.setViewName("common/message");
						mav.addObject("message", "해당 지국에 독자 정보가 존재하지 않습니다.\\n지국에 다시 확인해 주시기 바랍니다.");
						mav.addObject("returnURL", "/reader/billingStuAdmin/billingInfo.do?numId="+param.getString("numId")+"&flag=UPT");
						return mav;
					} else if(rederInfo.size() == 1) { //독자번호가 있을때
						Map temp = (Map)rederInfo.get(0);
						String readNo = (String)temp.get("READNO");
						dbparam.put("readNo", readNo);
						dbparam.put("chgps", session.getAttribute(SESSION_NAME_ADMIN_USERID));	
						dbparam.put("agency_serial", dbparam.get("chgps"));
						dbparam.put("sgType", "021"); // 수금방법 자동이체
						dbparam.put("readTypeCd", "013"); //독자유형 학생(본사)
						
						//메모등록
						if(!("").equals(param.getString("memo"))) {	//null이 아닐때만 메모생성
							dbparam.put("READNO", param.getString("readNo"));
							dbparam.put("MEMO", param.getString("memo"));
							dbparam.put("CREATEID",  (String)session.getAttribute(SESSION_NAME_ADMIN_USERID));
							
							generalDAO.getSqlMapClient().insert("util.memo.insertMemo", dbparam); //메모생성
						}
						
						// 예약해지등록
						if (!"".equals(cancelDt)) {
							int chkCnt = generalDAO.count("reader.billingAdmin.chkStopReserveReader", dbparam); // 해지예약여부 조회
							if (chkCnt < 1) {
								generalDAO.insert("reader.billingAdmin.insertStopReserveData", dbparam);
							}
						}

						List reader = generalDAO.getSqlMapClient().queryForList("reader.readerManage.getReader",dbparam);
						for(int i=0 ; i < reader.size() ; i++){
							Map list = (Map)reader.get(i);
							dbparam.put("newsCd", list.get("NEWSCD"));
							dbparam.put("seq", list.get("SEQ"));
							generalDAO.getSqlMapClient().insert("reader.readerManage.insertreaderHist", dbparam);
						}
						
						//수금타입변경
						generalDAO.getSqlMapClient().update("reader.readerManage.updateSgType", dbparam);
						// 자동이체 정보 최종 등록
						generalDAO.getSqlMapClient().update("reader.billingStuAdmin.updatePaymentFinal" , dbparam);
						// 독자번호 수정
						generalDAO.getSqlMapClient().update("util.address.updateReadnoByNumId" , dbparam);
						
						mav.setViewName("common/message");
						mav.addObject("message", "처리 되었습니다.");
						mav.addObject("returnURL", "/reader/billingStuAdmin/billingInfo.do?numId="+param.getString("numId")+"&flag=SAVEOK");
						generalDAO.getSqlMapClient().getCurrentConnection().commit();
						return mav;
					}else if(rederInfo.size() > 1){
						mav.setViewName("common/message");
						mav.addObject("message", "해당 지국에 동일 독자 정보가 " +rederInfo.size()+ "개 존재합니다.\\n고객명 , 주소등 구독정보와 동일하게 자동이체 등록 정보를 \\n다시 한번 확인해주시기 바랍니다.");
						mav.addObject("returnURL", "/reader/billingStuAdmin/billingInfo.do?numId="+param.getString("numId")+"&flag=UPT");
						return mav;
					}
					
				} else {
					/*
					 * 지국변경 
					 * 자동이체 a->b
					 * 1. a 지국 독자 해지
					 * 2. b 지국에 신규 독자 생성  
					 * 3. a 자동이체 정보 카피 EA99 numid 증가 
					 * 4. a번 로그 usernumid 변경
					 * 5. b a자동이체 정보 지국,readno변경
					 * 지국변경 아니면 단순 수정...
					 */
					if(!param.getString("realJikuk").equals(param.getString("old_realJikuk"))){
						dbparam.put("readNo", param.getString("readNo"));
						dbparam.put("old_realJikuk", param.getString("old_realJikuk"));
						
						//신규데이터
						// 1. a 지국 독자 해지
						dbparam.put("chgps", session.getAttribute(SESSION_NAME_ADMIN_USERID));	
						dbparam.put("agency_serial", dbparam.get("chgps"));
						
						/*
						 * 자동이체 해지를 하면
						 * 구독정보 히스토리 업데이트 후  구독정보 해지
						 * */

						List reader = generalDAO.getSqlMapClient().queryForList("reader.readerManage.getReader",dbparam);
						for(int i=0 ; i < reader.size() ; i++){
							Map list = (Map)reader.get(i);
							dbparam.put("newsCd", list.get("NEWSCD"));
							dbparam.put("seq", list.get("SEQ"));
							generalDAO.getSqlMapClient().insert("reader.readerManage.insertreaderHist", dbparam);
						}
						generalDAO.getSqlMapClient().update("reader.readerManage.closeNews", dbparam);//구독 해지
						//2. b 지국에 신규 독자 생성
						dbparam.put("newsCd" , MK_NEWSPAPER_CODE);
						dbparam.put("agency_serial" , param.getString("realJikuk"));
						dbparam.put("gno", "200");
						dbparam.put("bno", "000");
						dbparam.put("readNm" , param.getString("userName"));
						dbparam.put("homeTel1" , param.getString("phone1"));
						dbparam.put("homeTel2" , param.getString("phone2"));
						dbparam.put("homeTel3" , param.getString("phone3"));
						dbparam.put("mobile1" , param.getString("handy1"));
						dbparam.put("mobile2" , param.getString("handy2"));
						dbparam.put("mobile3" , param.getString("handy3"));
						dbparam.put("dlvZip" , param.getString("dlvZip"));
						dbparam.put("dlvAdrs1" , param.getString("addr1"));
						dbparam.put("dlvAdrs2" , param.getString("addr2"));
						dbparam.put("newaddr" , param.getString("newaddr"));
						dbparam.put("bdMngNo" , param.getString("bdMngNo"));
						dbparam.put("sgType" , "021");//수금방법 자동이체
						dbparam.put("readTypeCd", "013"); //독자유형 학생(본사)
						dbparam.put("uPrice" , param.getString("bankMoney"));
						dbparam.put("qty" , param.getString("busu"));
						dbparam.put("hjDt" , DateUtil.getCurrentDate("yyyyMMdd"));
						dbparam.put("sgBgmm" , param.getString("sgBgmm") );
						dbparam.put("aplcDt" , DateUtil.getCurrentDate("yyyyMMdd"));
						dbparam.put("inps" , session.getAttribute(SESSION_NAME_ADMIN_USERID));
						dbparam.put("chgPs" , session.getAttribute(SESSION_NAME_ADMIN_USERID));
						dbparam.put("eMail" , param.getString("email"));
						String readNo = (String)generalDAO.getSqlMapClient().queryForObject("reader.readerManage.getReadNo" , dbparam);
						dbparam.put("readNo" , readNo );						
						//통합독자생성
						generalDAO.getSqlMapClient().insert("reader.readerManage.insertTmreader", dbparam); 
						//구독정보 생성
						generalDAO.getSqlMapClient().insert("reader.readerManage.inserTmreaderNews", dbparam); 
						
						dbparam.put("newNumId", generalDAO.count("reader.billingStuAdmin.newNumId", dbparam));//새로운 numid
			
						//3. a 자동이체 정보 카피 EA99 numid 증가
						generalDAO.getSqlMapClient().insert("reader.billingStuAdmin.cloneBankInfo2", dbparam);//기존데이터를 신규로 복사하면서 관리지국 변경
						
						//4. a번 로그 usernumid 변경
						generalDAO.getSqlMapClient().update("reader.billingStuAdmin.updateLog" , dbparam);
						//5. a자동이체 정보 새로운 지국정보 ,readno로 변경
						generalDAO.getSqlMapClient().update("reader.billingStuAdmin.updateChangeJikuk" , dbparam);//기존데이터 ea99 , SERIAL증가
						
						//메모등록
						if(!("").equals(param.getString("memo"))) {	//null이 아닐때만 메모생성
							dbparam.put("READNO", readNo);
							dbparam.put("MEMO", param.getString("memo"));
							dbparam.put("CREATEID",  (String)session.getAttribute(SESSION_NAME_ADMIN_USERID));
							
							generalDAO.getSqlMapClient().insert("util.memo.insertMemo", dbparam); //메모생성
						}
						
						// 예약해지등록
						if (!"".equals(cancelDt)) {
							int chkCnt = generalDAO.count("reader.billingAdmin.chkStopReserveReader", dbparam); // 해지예약여부 조회
							if (chkCnt < 1) {
								generalDAO.insert("reader.billingAdmin.insertStopReserveData", dbparam);
							}
						}
						
						mav.setViewName("common/message");
						mav.addObject("message", "처리 되었습니다.");
						mav.addObject("returnURL", "/reader/billingStuAdmin/searchBilling.do?search_type=userName&status=ALL&search_key="+param.getString("userName"));
						generalDAO.getSqlMapClient().getCurrentConnection().commit();
						return mav;
						
					} else { //단순정보수정
						//parameters
						dbparam.put("readNm" , param.getString("userName"));
						dbparam.put("homeTel1" , param.getString("phone1"));
						dbparam.put("homeTel2" , param.getString("phone2"));
						dbparam.put("homeTel3" , param.getString("phone3"));
						dbparam.put("mobile1" , param.getString("handy1"));
						dbparam.put("mobile2" , param.getString("handy2"));
						dbparam.put("mobile3" , param.getString("handy3"));
						dbparam.put("dlvZip" , param.getString("dlvZip"));
						dbparam.put("dlvAdrs1" , param.getString("addr1"));
						dbparam.put("dlvAdrs2" , param.getString("addr2"));
						dbparam.put("newaddr" , param.getString("newaddr"));
						dbparam.put("bdMngNo" , param.getString("bdMngNo"));
						dbparam.put("uPrice" , param.getString("bankMoney"));
						dbparam.put("qty" , param.getString("busu"));
						dbparam.put("readNo", param.getString("readNo"));
						dbparam.put("old_realJikuk", param.getString("old_realJikuk"));
						dbparam.put("chgps", session.getAttribute(SESSION_NAME_ADMIN_USERID));	
						dbparam.put("agency_serial", dbparam.get("chgps"));
						dbparam.put("readNo", param.getString("readNo"));
						
						//정보수정을 위해서 시퀀스조회
						List reader = generalDAO.getSqlMapClient().queryForList("reader.readerManage.getReaderForOnlyDataUpdate",dbparam);
						for(int i=0 ; i < reader.size() ; i++){
							Map list = (Map)reader.get(i);
							dbparam.put("newsCd", list.get("NEWSCD"));
							dbparam.put("seq", list.get("SEQ"));
							//히스토리 입력
							generalDAO.getSqlMapClient().insert("reader.readerManage.insertreaderHistWithoutNewaddr", dbparam);
							//정보수정_news테이블
							generalDAO.getSqlMapClient().update("reader.readerManage.updateReaderDataFor021", dbparam);
						}
						
						//메모등록
						if(!("").equals(param.getString("memo"))) {	//null이 아닐때만 메모생성
							dbparam.put("READNO", param.getString("readNo"));
							dbparam.put("MEMO", param.getString("memo"));
							dbparam.put("CREATEID",  (String)session.getAttribute(SESSION_NAME_ADMIN_USERID));
							
							generalDAO.getSqlMapClient().insert("util.memo.insertMemo", dbparam); //메모생성
						}
						
						// 예약해지등록
						if (!"".equals(cancelDt)) {
							int chkCnt = generalDAO.count("reader.billingAdmin.chkStopReserveReader", dbparam); // 해지예약여부 조회
							if (chkCnt < 1) {
								generalDAO.insert("reader.billingAdmin.insertStopReserveData", dbparam);
							}
						}
						
						generalDAO.getSqlMapClient().update("reader.billingStuAdmin.updatePayment" , dbparam);// 자동이체 정보 수정
						
						
						// 정보수정을 위해서 시퀀스조회
						System.out.println("boseq = "+param.getString("old_realJikuk"));
						System.out.println("opSeq = "+dbparam.get("seq"));
						
						dbparam.put("boseq", param.getString("old_realJikuk"));
						dbparam.put("readTypeCd", "013");
						dbparam.put("sgType", "021");
						generalDAO.getSqlMapClient().update("reader.readerManage.updateReaderJusoTelData", dbparam);
					}
				}
				generalDAO.getSqlMapClient().getCurrentConnection().commit();
				mav.setViewName("common/message");
				mav.addObject("message", "처리 되었습니다."); 
				mav.addObject("returnURL", "/reader/billingStuAdmin/billingInfo.do?numId="+param.getString("numId")+"&flag=SAVEOK");
				return mav;
			}else{
				//구독정보 생성
				dbparam.put("inType" , "기존");
				dbparam.put("userName" , param.getString("userName"));
				dbparam.put("phone" , param.getString("phone1")+"-"+param.getString("phone2")+"-"+param.getString("phone3"));
				//dbparam.put("zip1" , param.getString("zip1"));
				//dbparam.put("zip2" , param.getString("zip2"));
				dbparam.put("addr1" , param.getString("addr1"));
				dbparam.put("addr2" , param.getString("addr2"));
				dbparam.put("newaddr" , param.getString("newaddr"));
				dbparam.put("bdMngNo" , param.getString("bdMngNo"));
				dbparam.put("jikuk" , param.getString("jikuk"));
				dbparam.put("busu" , param.getString("busu"));
				dbparam.put("bankMoney" , param.getString("bankMoney"));
				dbparam.put("bankName" , param.getString("bankName"));
				dbparam.put("bankNum" , param.getString("bankNum"));
				dbparam.put("saup" , param.getString("saup"));
				dbparam.put("handy" , param.getString("handy1")+"-"+param.getString("handy2")+"-"+param.getString("handy3") );
				dbparam.put("email" , param.getString("email"));
				dbparam.put("memo" , param.getString("memo"));
				dbparam.put("numId" , param.getString("numId"));
				
				dbparam.put("newsCd" , MK_NEWSPAPER_CODE);
				dbparam.put("agency_serial" , param.getString("realJikuk"));
				dbparam.put("gno", "200");
				dbparam.put("bno", "000");
				dbparam.put("readNm" , param.getString("userName"));
				dbparam.put("homeTel1" , param.getString("phone1"));
				dbparam.put("homeTel2" , param.getString("phone2"));
				dbparam.put("homeTel3" , param.getString("phone3"));
				dbparam.put("mobile1" , param.getString("handy1"));
				dbparam.put("mobile2" , param.getString("handy2"));
				dbparam.put("mobile3" , param.getString("handy3"));
				dbparam.put("dlvZip" , param.getString("dlvZip"));
				dbparam.put("dlvAdrs1" , param.getString("addr1"));
				dbparam.put("dlvAdrs2" , param.getString("addr2"));
				dbparam.put("sgType" , "021");//수금방법 자동이체
				dbparam.put("readTypeCd", "013"); //독자유형 학생(본사)
				dbparam.put("uPrice" , param.getString("bankMoney"));
				dbparam.put("qty" , param.getString("busu"));
				dbparam.put("hjDt" , DateUtil.getCurrentDate("yyyyMMdd"));
				dbparam.put("sgBgmm" , DateUtil.getWantDay(DateUtil.getCurrentDate("yyyyMMdd"), 2, 1).substring(0,6) );
				dbparam.put("aplcDt" , DateUtil.getCurrentDate("yyyyMMdd"));
				dbparam.put("inps" , session.getAttribute(SESSION_NAME_ADMIN_USERID));
				dbparam.put("chgPs" , session.getAttribute(SESSION_NAME_ADMIN_USERID));
				dbparam.put("eMail" , param.getString("email"));
				String readNo = (String)generalDAO.getSqlMapClient().queryForObject("reader.readerManage.getReadNo" , dbparam);
				dbparam.put("readNo" , readNo);
				
				//통합독자생성
				generalDAO.getSqlMapClient().insert("reader.readerManage.insertTmreader", dbparam); 
				//구독정보 생성
				generalDAO.getSqlMapClient().insert("reader.readerManage.inserTmreaderNews", dbparam); 
				//자동이체정보 수정
				generalDAO.getSqlMapClient().update("reader.billingStuAdmin.updatePaymentFinal" , dbparam);
				
				//메모등록
				if(!("").equals(param.getString("memo"))) {	//null이 아닐때만 메모생성
					dbparam.put("READNO", readNo);
					dbparam.put("MEMO", param.getString("memo"));
					dbparam.put("CREATEID",  (String)session.getAttribute(SESSION_NAME_ADMIN_USERID));
					
					generalDAO.getSqlMapClient().insert("util.memo.insertMemo", dbparam); //메모생성
				}
				
				// 예약해지등록
				if (!"".equals(cancelDt)) {
					int chkCnt = generalDAO.count("reader.billingAdmin.chkStopReserveReader", dbparam); // 해지예약여부 조회
					if (chkCnt < 1) {
						generalDAO.insert("reader.billingAdmin.insertStopReserveData", dbparam);
					}
				}
			}
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			
			mav.setViewName("common/message");
			mav.addObject("message", "처리 되었습니다.");
			mav.addObject("returnURL", "/reader/billingStuAdmin/billingInfo.do?numId="+param.getString("numId")+"&flag=SAVEOK");
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
		
		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		Param param = new HttpServletParam(request);
		try{
			dbparam.put("numId", param.getString("numId"));
			dbparam.put("typeCd", param.getString("typeCd"));
			List callLog = generalDAO.queryForList("reader.billingAdmin.callLog", dbparam);

			// mav 
			mav.addObject("param" , param);
			mav.addObject("callLog" , callLog);
			mav.setViewName("reader/billingAdmin/pop_callLog");	
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
		
		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		Param param = new HttpServletParam(request);
		try{
			dbparam.put("numId", param.getString("numId"));
			dbparam.put("typeCd", param.getString("typeCd"));
			dbparam.put("remk" , param.getString("remk"));
			
			generalDAO.insert("reader.billingAdmin.insertCallLog", dbparam);

			// mav 
			request.setAttribute("param", param);
			mav.setView(new RedirectView("/reader/billingAdmin/popRetrieveCallLog.do?numId="+param.getString("numId")+"&typeCd="+param.getString("typeCd")));	
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
		
		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		Param param = new HttpServletParam(request);
		try{
			dbparam.put("numId", param.getString("numId"));
			List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" );// 핸도폰 앞자리 번호 조회
			List bankInfo = generalDAO.queryForList("reader.common.bankInfo" );// 은행 정보 조회
			List billingInfo = generalDAO.queryForList("reader.billingStuAdmin.billingInfo" , dbparam);// 자동이체 정보
			// mav 
			mav.addObject("param" , param);
			mav.addObject("mobileCode" , mobileCode);
			mav.addObject("bankInfo" , bankInfo);
			mav.addObject("billingInfo" , billingInfo);
			mav.setViewName("reader/billingAdmin/pop_bankEdit");	
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
		
		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		Param param = new HttpServletParam(request);
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
			dbparam.put("realJikuk" , param.getString("realJikuk"));
			
			
			//1. 기존데이터 복사 하면서 상태만 ea13-로 변경
			//2. 기존로그 데이터 복사
			//3. numid 증가하면서 기존데이터 복사
			if("EA21".equals(param.getString("tmp_status"))){//정상 사용중인 독자 계좌번호 변경로직
				dbparam.put("status", "EA00");
				//기존데이터를 신규로 복사하면서 EA13- 로 변경
				generalDAO.getSqlMapClient().insert("reader.billingStuAdmin.cloneBankInfo", dbparam);
				//신규 numid 조회
				dbparam.put("newNumId", generalDAO.count("reader.billingStuAdmin.newNumId", dbparam));
				//기존데이터 numid 증가 EA00으로 변경
				generalDAO.getSqlMapClient().update("reader.billingStuAdmin.updateBankInfo", dbparam);
				//기존 로그데이터 신규numid로 수정
				generalDAO.getSqlMapClient().update("reader.billingStuAdmin.updateLog", dbparam);
				mav.setViewName("common/message");
				mav.addObject("message", "처리 되었습니다.");
				mav.addObject("returnURL", "/reader/billingStuAdmin/searchBilling.do?search_type=userName&status=ALL&search_key="+param.getString("userName"));
				generalDAO.getSqlMapClient().getCurrentConnection().commit();
				return mav;
			}else{//단순 정보 수정
				generalDAO.getSqlMapClient().update("reader.billingStuAdmin.updateBankInfo", dbparam);
				mav.setViewName("common/message");
				mav.addObject("message", "처리 되었습니다.");
				mav.addObject("returnURL", "/reader/billingStuAdmin/billingInfo.do?numId="+param.getString("numId"));
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
	/**
	 * 자동이체 상태별 엑셀 저장
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView saveExcel(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		ModelAndView mav = new ModelAndView();
		
		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		Param param = new HttpServletParam(request);
		try{
			
			dbparam.put("fromDate", StringUtil.replace(param.getString("fromDate"), "-", ""));
			dbparam.put("toDate", StringUtil.replace(param.getString("toDate"), "-", ""));
			dbparam.put("status", param.getString("status"));
			
			List excel = generalDAO.queryForList("reader.billingStuAdmin.saveExcel" , dbparam);
			
			//String fileName = "billingStuList_(" + DateUtil.getCurrentDate("yyyyMMdd") + ").xls";
			String fileName = "학생자동이체독자리스트(" + StringUtil.replace(param.getString("fromDate"), "-", "") + "~" +  StringUtil.replace(param.getString("toDate"), "-", "") +").xls";
			
			//Excel response
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName); 
			response.setHeader("Content-Description", "JSP Generated Data");
			
			mav.addObject("excel" , excel);
			mav.addObject("fromDate",param.getString("fromDate"));
			mav.addObject("toDate",param.getString("toDate"));
			mav.setViewName("reader/billingAdmin/billingStuListExcel");
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
	 * 학생 자동이체 신청 리스트 조회
	 * 
	 * @param request
	 * @param response
	 * @category 자동이체 신청 리스트 조회
	 * @return
	 * @throws Exception
	 */
	public ModelAndView billingStuAplcList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		String status = param.getString("status", "0");

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
		
		// 7일전 날짜
		Calendar beforeWeek = Calendar.getInstance();
		beforeWeek.add(Calendar.DATE,-7);

		String bYear   = String.valueOf(beforeWeek.get(Calendar.YEAR));
		String bMonth  = String.valueOf(beforeWeek.get(Calendar.MONTH) + 1);
		String bDay = String.valueOf(beforeWeek.get(Calendar.DATE));
		
		if (bMonth.length() < 2){
			bMonth = "0" + bMonth;
		}
		if (bDay.length() < 2){
			bDay = "0" + bDay;
		}

		String fromDate= param.getString("fromDate", bYear + "-" + bMonth + "-" + bDay);		//기간 from
		String toDate= param.getString("toDate", year + "-" + month + "-" + day);				//기간 to

		try{
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 20;
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			dbparam.put("fromDate", StringUtil.replace(fromDate, "-", ""));
			dbparam.put("toDate", StringUtil.replace(toDate, "-", ""));
			dbparam.put("status", status);
			dbparam.put("search_value", param.getString("search_value"));
			dbparam.put("search_type", param.getString("search_type"));
			
			int totalCount = 0;
			
			List billingStuAplcList = generalDAO.queryForList("reader.billingStuAdmin.getStuAplcList" , dbparam);// 자동이체 신청 리스트
			totalCount = generalDAO.count("reader.billingStuAdmin.getStuAplcCount" , dbparam);// 자동이체 신청 카운트
			
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 20));
			mav.addObject("billingStuAplcList", billingStuAplcList);
			mav.addObject("fromDate", fromDate);
			mav.addObject("toDate", toDate);
			mav.addObject("status", status);
			mav.addObject("now_menu", MENU_CODE_READER_BILLING);
			mav.setViewName("reader/billingAdmin/billingStuAplcList");
			
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
	 * 학생 자동이체 신청 취소
	 * 
	 * @param request
	 * @param response
	 * @category 자동이체 신청 취소
	 * @return
	 * @throws Exception
	 */
	public ModelAndView refuseStuAplcList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);

			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			
			dbparam.put("aplcdt", param.getString("aplcdt"));
			dbparam.put("aplcno", param.getString("aplcno"));
			dbparam.put("status", "2");  // 1:승인 , 2:취소
			dbparam.put("chgps", session.getAttribute(SESSION_NAME_ADMIN_USERID));
			dbparam.put("PAGE_NO", "1");
			dbparam.put("PAGE_SIZE", "20");
			
			System.out.println("billingStuAplcList"+dbparam);
			generalDAO.getSqlMapClient().update("reader.billingStuAdmin.updateStuAplcList" , dbparam); // 자동이체 신청 업데이트
			
			System.out.println("getStuAplcList"+dbparam);
			List billingStuAplcList = generalDAO.getSqlMapClient().queryForList("reader.billingStuAdmin.getStuAplcList" , dbparam);// 자동이체 일반독자 리스트

			mav.addObject("billingStuAplcList", billingStuAplcList);
			mav.addObject("fromDate", param.getString("fromDate"));
			mav.addObject("toDate", param.getString("toDate"));
			mav.addObject("status", "2");
			mav.addObject("param", param);
			mav.addObject("now_menu", MENU_CODE_READER_BILLING);
			mav.setViewName("reader/billingAdmin/billingStuAplcList");

			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			
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
	 * 학생 자동이체 신청 접수
	 * 
	 * @param request
	 * @param response
	 * @category 자동이체 신청 접수
	 * @return
	 * @throws Exception
	 */
	public ModelAndView acceptStuAplcList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);

			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			
			// 파라미터 세팅
			dbparam.put("aplcdt", param.getString("aplcdt"));
			dbparam.put("aplcno", param.getString("aplcno"));
			dbparam.put("status", "1");  // 1:승인 , 2:취소
			dbparam.put("intype", "신규");  // 1:승인 , 2:취소
			dbparam.put("gubun", "학생");
			
			dbparam.put("chgps", session.getAttribute(SESSION_NAME_ADMIN_USERID));

			// 1. 자동이체 NUMID 조회 및 세팅
			dbparam.put("newNumId", generalDAO.count("reader.billingStuAdmin.newNumId", dbparam));//새로운 numid

			System.out.println("acceptStuAplcList"+dbparam);
			// 2. 자동이체 테이블에 INSERT
			generalDAO.getSqlMapClient().insert("reader.billingStuAdmin.insertUserStu" , dbparam); // 학생 자동이체 테이블 저장
			
			// 3. 자동이체 신청 테이블 UPDATE
			generalDAO.getSqlMapClient().update("reader.billingStuAdmin.updateStuAplcList" , dbparam); // 자동이체 신청 업데이트
			
			dbparam.put("PAGE_NO", "1");
			dbparam.put("PAGE_SIZE", "20");			
			System.out.println("getStuAplcList"+dbparam);
			List billingStuAplcList = generalDAO.getSqlMapClient().queryForList("reader.billingStuAdmin.getStuAplcList" , dbparam);// 자동이체 일반독자 리스트

			mav.addObject("billingStuAplcList", billingStuAplcList);
			mav.addObject("fromDate", param.getString("fromDate"));
			mav.addObject("toDate", param.getString("toDate"));
			mav.addObject("status",  "1");
			mav.addObject("param", param);
			mav.addObject("now_menu", MENU_CODE_READER_BILLING);
			mav.setViewName("reader/billingAdmin/billingStuAplcList");

			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			
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
}
