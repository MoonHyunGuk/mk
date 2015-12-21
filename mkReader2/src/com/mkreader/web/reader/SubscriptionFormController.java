/*------------------------------------------------------------------------------
 * NAME : SubscriptionFormController 
 * DESC : mk.co.kr 구독신청 자동이체신청(일반,학생) 연동
 * Author : pspkj
 *----------------------------------------------------------------------------*/
package com.mkreader.web.reader;

import java.io.File;
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
import kr.reflexion.espresso.servlet.util.MultipartHttpServletParam;

import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;
import org.springframework.web.servlet.view.RedirectView;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.CommonUtil;
import com.mkreader.util.DateUtil;
import com.mkreader.util.Paging;
import com.mkreader.util.SecurityUtil;
import com.mkreader.util.StringUtil;

public class SubscriptionFormController extends MultiActionController implements
ISiteConstant, ICodeConstant {

	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
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
		mav.setViewName("reader/SubscriptionForm/pop_addr");	
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
		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		Param param = new HttpServletParam(request);
		try{

			dbparam.put("search", param.getString("search"));
			List addrList = generalDAO.queryForList("reader.readerManage.retrieveAddr", dbparam);
			// mav 
			mav.addObject("cmd" , param.getString("cmd"));
			mav.addObject("search" , param.getString("search"));
			mav.addObject("addrList" , addrList);
			mav.setViewName("reader/SubscriptionForm/pop_addr");	
			return mav;

		}catch(Exception e){
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	/**
	 * 자동이체 약관 페이지 (일반) 오픈
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView useClauses(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("reader/SubscriptionForm/useClauses");
		
		return mav;
	}
	
	/**
	 * 자동이체 약관 페이지 (학생) 오픈
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView stuUseClauses(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("reader/SubscriptionForm/stuUseClauses");
		
		return mav;
	}
	
	/**
	 * 자동이체 등록(일반) 페이지 오픈
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView billingEdit(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		
		List areaCode = generalDAO.queryForList("reader.common.retrieveAreaCode" );// 전화번호 지역번호 조회
		List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" );// 핸도폰 앞자리 번호 조회
		List bankInfo = generalDAO.queryForList("reader.common.bankInfoForCustomer" );// 은행 정보 조회
		
		mav.addObject("areaCode" , areaCode);
		mav.addObject("mobileCode" , mobileCode);
		mav.addObject("bankInfo" , bankInfo);
		mav.setViewName("reader/SubscriptionForm/billingEdit");
		return mav;
	}
	
	/**
	 * 자동이체 등록(학생) 페이지 오픈
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView stuBillingEdit(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		
		List areaCode = generalDAO.queryForList("reader.common.retrieveAreaCode" );// 전화번호 지역번호 조회
		List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" );// 핸도폰 앞자리 번호 조회
		List bankInfo = generalDAO.queryForList("reader.common.bankInfoForCustomer" );// 은행 정보 조회
		
		mav.addObject("areaCode" , areaCode);
		mav.addObject("mobileCode" , mobileCode);
		mav.addObject("bankInfo" , bankInfo);
		mav.setViewName("reader/SubscriptionForm/stuBillingEdit");
		return mav;
	}
	
	/**
	 * 자동이체 신청 조회 페이지 오픈(일반)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView retrieveBilling(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("reader/SubscriptionForm/retrieveBilling");
		return mav;
	}
	
	/**
	 * 자동이체 신청 조회 페이지 오픈(학생)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView retrieveBillingStu(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("reader/SubscriptionForm/retrieveBillingStu");
		return mav;
	}
	
	/**
	 * 자동이체 정보 조회 일반
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView searchBillInfo(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		

		try{
			
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			dbparam.put("bankNum", param.getString("bankNum"));
			dbparam.put("saup", param.getString("saup"));

			List billingInfo = generalDAO.queryForList("reader.subscriptionForm.searchBillInfo" , dbparam);
			// mav 
			if(billingInfo.size() > 0){
				Map list = (Map)billingInfo.get(0);
				dbparam.put("numId", list.get("NUMID"));
				dbparam.put("cmsType", String.valueOf("EA21"));//자동이체 청구이력 조건값
				List paymentHist = generalDAO.queryForList("reader.billingAdmin.paymentHist" , dbparam);// 자동이체납부이력
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
				mav.addObject("paymentHist" , paymentHist );
			}

			mav.addObject("billingInfo" , billingInfo );
			mav.setViewName("reader/SubscriptionForm/billingInfo");
			
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
	 * 자동이체 정보 조회 학생 
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView searchBillInfoStu(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		try{
			
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			dbparam.put("bankNum", param.getString("bankNum"));
			dbparam.put("saup", param.getString("saup"));

			List billingInfo = generalDAO.queryForList("reader.subscriptionForm.searchBillInfoStu" , dbparam);
			// mav 
			if(billingInfo.size() > 0){
				Map list = (Map)billingInfo.get(0);
				dbparam.put("numId", list.get("NUMID"));
				dbparam.put("cmsType", String.valueOf("EA21"));//자동이체 청구이력 조건값
				List paymentHist = generalDAO.queryForList("reader.billingStuAdmin.paymentHist" , dbparam);// 자동이체납부이력
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
				mav.addObject("paymentHist" , paymentHist );
			}

			mav.addObject("billingInfo" , billingInfo );
			mav.setViewName("reader/SubscriptionForm/billingInfoStu");
			
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
	 * 자동이체 정보 등록 일반
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

			HashMap<String, Object> dbparam = new HashMap<String, Object>();
				
			dbparam.put("bankInfo", param.getString("bankInfo")+"0000");
			dbparam.put("inType" , param.getString("inType"));
			dbparam.put("userName" , param.getString("userName"));
			dbparam.put("phone" , param.getString("phone1")+"-"+param.getString("phone2")+"-"+param.getString("phone3"));
			dbparam.put("zip1" , param.getString("zip1"));
			dbparam.put("zip2" , param.getString("zip2"));
			dbparam.put("addr1" , param.getString("addr1"));
			dbparam.put("addr2" , param.getString("addr2"));
			dbparam.put("birth" , param.getString("birth"));
			dbparam.put("busu" , param.getString("busu"));
			dbparam.put("bankMoney" , param.getString("bankMoney"));
			dbparam.put("bankName" , param.getString("bankName"));
			dbparam.put("bankNum" , param.getString("bankNum"));
			dbparam.put("saup" , param.getString("saup"));
			dbparam.put("handy" , param.getString("handy1")+"-"+param.getString("handy2")+"-"+param.getString("handy3") );
			dbparam.put("email" , param.getString("email"));
			dbparam.put("memo" , param.getString("memo"));
			dbparam.put("whoStep" , "3");
			dbparam.put("addr3" , param.getString("addr3"));
			dbparam.put("bdMngNo" , param.getString("bdMngNo"));
			
			if(param.getString("userName") != null && !"".equals(param.getString("userName"))){
				generalDAO.insert("reader.subscriptionForm.savePayment" , dbparam);// 자동이체 정보 등록
				mav.addObject("message", "처리 되었습니다.");
				mav.setViewName("reader/SubscriptionForm/ajaxMessage");
				return mav;
			}else{
				mav.addObject("message", "처리 되지 않았습니다. 입력값을 다시 확인해 주세요.");
				mav.setViewName("reader/SubscriptionForm/ajaxMessage");
				return mav;
			}
			
		}catch(Exception e){
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	
	/**
	 * 자동이체 정보 등록 학생
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView savePaymentStu(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();

		try{

			HashMap<String, Object> dbparam = new HashMap<String, Object>();
				
			dbparam.put("bankInfo", param.getString("bankInfo")+"0000");
			
			
			if(Integer.parseInt(DateUtil.getCurrentDate("yyyyMMdd").substring(6,8)) < 11 ){
				dbparam.put("sdate", DateUtil.getCurrentDate("yyyyMMdd").substring(0,6)+"17");
			}else{
				dbparam.put("sdate", DateUtil.getWantDay(DateUtil.getCurrentDate("yyyyMMdd"), 2, 1).substring(0, 6)+"05");
			}
			dbparam.put("inType" , "기존");
			dbparam.put("stuSch" , param.getString("stuSch"));
			dbparam.put("stuPart" , param.getString("stuPart"));
			dbparam.put("stuClass" , param.getString("stuClass"));
			dbparam.put("stuProf" , param.getString("stuProf"));
			dbparam.put("userName" , param.getString("userName"));
			dbparam.put("phone" , param.getString("phone1")+"-"+param.getString("phone2")+"-"+param.getString("phone3"));
			dbparam.put("zip1" , param.getString("zip1"));
			dbparam.put("zip2" , param.getString("zip2"));
			dbparam.put("addr1" , param.getString("addr1"));
			dbparam.put("addr2" , param.getString("addr2"));
			dbparam.put("busu" , param.getString("busu"));
			dbparam.put("bankMoney" , param.getString("bankMoney"));
			dbparam.put("bankName" , param.getString("bankName"));
			dbparam.put("bankNum" , param.getString("bankNum"));
			dbparam.put("saup" , param.getString("saup"));
			dbparam.put("handy" , param.getString("handy1")+"-"+param.getString("handy2")+"-"+param.getString("handy3") );
			dbparam.put("email" , param.getString("email"));
			dbparam.put("memo" , param.getString("memo"));
			dbparam.put("whoStep" , "3");
			dbparam.put("addr3" , param.getString("addr3"));
			dbparam.put("bdMngNo" , param.getString("bdMngNo"));
			if(param.getString("userName") != null && !"".equals(param.getString("userName"))){
				generalDAO.insert("reader.subscriptionForm.savePaymentStu" , dbparam);// 자동이체 정보 등록
				mav.addObject("message", "처리 되었습니다.");
				mav.setViewName("reader/SubscriptionForm/ajaxMessage");
				return mav;
			}else{
				mav.addObject("message", "처리 되지 않았습니다. 입력값을 다시 확인해 주세요.");
				mav.setViewName("reader/SubscriptionForm/ajaxMessage");
				return mav;
			}
		}catch(Exception e){
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	
	/**
	 * 구독 신청 페이지 오픈
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView aplcEdit(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		
		List areaCode = generalDAO.queryForList("reader.common.retrieveAreaCode" );// 전화번호 지역번호 조회
		List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" );// 핸도폰 앞자리 번호 조회
		List bankInfo = generalDAO.queryForList("reader.common.bankInfoForCustomer" );// 은행 정보 조회
		List intFldList = generalDAO.queryForList("reader.common.retrieveIntFldCd");//관심유형 조회
		mav.addObject("intFldList" , intFldList);
		mav.addObject("areaCode" , areaCode);
		mav.addObject("mobileCode" , mobileCode);
		mav.addObject("bankInfo" , bankInfo);
		mav.setViewName("reader/SubscriptionForm/aplcEdit");
		return mav;
	}

	/**
	 * 구독 신청 정보 등록 일반
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView saveAplc(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();

		try{

			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			dbparam.put("aplcDt" , DateUtil.getCurrentDate("yyyyMMdd"));
			dbparam.put("userName" , param.getString("userName"));
			dbparam.put("phone1" , param.getString("phone1"));
			dbparam.put("phone2" , param.getString("phone2"));
			dbparam.put("phone3" , param.getString("phone3"));
			dbparam.put("zip" , param.getString("zip1") + param.getString("zip2"));
			dbparam.put("addr1" , param.getString("addr1"));
			dbparam.put("addr2" , param.getString("addr2"));
			dbparam.put("birth" , param.getString("birth"));
			dbparam.put("busu" , param.getString("busu"));
			dbparam.put("handy1" , param.getString("handy1"));
			dbparam.put("handy2" , param.getString("handy2"));	
			dbparam.put("handy3" , param.getString("handy3"));
			dbparam.put("email" , param.getString("email"));
			dbparam.put("memo" , param.getString("memo"));
			dbparam.put("intFldCd" , param.getString("intFldCd"));
			dbparam.put("addr3" , param.getString("addr3"));
			dbparam.put("bdMngNo" , param.getString("bdMngNo"));
			if(param.getString("userName") != null && !"".equals(param.getString("userName"))){
				generalDAO.insert("reader.subscriptionForm.saveAplc" , dbparam);// 자동이체 정보 등록
				mav.addObject("message", "처리 되었습니다.");
				mav.setViewName("reader/SubscriptionForm/ajaxMessage");
				return mav;
			}else{
				mav.addObject("message", "처리 되지 않았습니다. 입력값을 다시 확인해 주세요.");
				mav.setViewName("reader/SubscriptionForm/ajaxMessage");
				return mav;
			}
		}catch(Exception e){
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}

	/** 
	 * 자동이체 약관 페이지 (학생) 오픈 2
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView stuUseClauses2(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("reader/SubscriptionForm/stuUseClauses2");
		
		return mav;
	}
	
	/**
	 * 자동이체 정보 조회 학생  2
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView searchBillInfoStu2(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		try{
			
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			dbparam.put("bankNum", param.getString("bankNum"));
			dbparam.put("saup", param.getString("saup"));

			List billingInfo = generalDAO.queryForList("reader.subscriptionForm.searchBillInfoStu" , dbparam);
			// mav 
			if(billingInfo.size() > 0){
				Map list = (Map)billingInfo.get(0);
				dbparam.put("numId", list.get("NUMID"));
				dbparam.put("cmsType", String.valueOf("EA21"));//자동이체 청구이력 조건값
				List paymentHist = generalDAO.queryForList("reader.billingStuAdmin.paymentHist" , dbparam);// 자동이체납부이력
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
				mav.addObject("paymentHist" , paymentHist );
			}

			mav.addObject("billingInfo" , billingInfo );
			mav.setViewName("reader/SubscriptionForm/billingInfoStu2");
			
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
	 * 자동이체 등록(학생) 페이지 오픈 2
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView stuBillingEdit2(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		
		List areaCode = generalDAO.queryForList("reader.common.retrieveAreaCode" );// 전화번호 지역번호 조회
		List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" );// 핸도폰 앞자리 번호 조회
		List bankInfo = generalDAO.queryForList("reader.common.bankInfoForCustomer" );// 은행 정보 조회

		List schoolInfo = generalDAO.queryForList("reader.subscriptionForm.retrieveSchNm" );// 대학교 정보 조회
		
		mav.addObject("areaCode" , areaCode);
		mav.addObject("mobileCode" , mobileCode);
		mav.addObject("bankInfo" , bankInfo);
		mav.addObject("schoolInfo" , schoolInfo);// 대학교 정보
		mav.setViewName("reader/SubscriptionForm/stuBillingEdit2");
		return mav;
	}

	/**
	 * 자동이체 신청 조회 페이지 오픈(학생) 2
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView retrieveBillingStu2(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("reader/SubscriptionForm/retrieveBillingStu2");
		return mav;
	}

	/**
	 * 자동이체 학생 신청 2
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView savePaymentStu2(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		MultipartHttpServletParam param = new MultipartHttpServletParam(request);
		ModelAndView mav = new ModelAndView();

		String newFileName = "";

		try{

			MultipartFile multipartFile = param.getMultipartFile("fileName");			

			if(!multipartFile.isEmpty() ){
				
				if( multipartFile.getSize() > 512000){
					mav.addObject("errCd", "-1");
					mav.addObject("message", "파일용량은 500Kb를 초과 할수 없습니다.");
					mav.setViewName("reader/SubscriptionForm/message");
					return mav;
				}else{
					newFileName = DateUtil.getCurrentDate("yyyyMMddHHmmssSSSS")+".jpg";
					String fullFilePath = PATH_PHYSICAL_HOME+PATH_DIR_STU_APLC+newFileName;

					multipartFile.transferTo(new File(fullFilePath));
				}
				
			}else{
				mav.addObject("errCd", "-1");
				mav.addObject("message", "파일이 첨부 되지 않았습니다.");
				mav.setViewName("reader/SubscriptionForm/message");
				return mav;
			}
			
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
				
			dbparam.put("userName" , param.getString("userName"));
			dbparam.put("saup" , param.getString("saup"));
			dbparam.put("email" , param.getString("email"));
			dbparam.put("zip1" , param.getString("zip1"));
			dbparam.put("zip2" , param.getString("zip2"));
			dbparam.put("addr1" , param.getString("addr1"));
			dbparam.put("addr2" , param.getString("addr2"));
			dbparam.put("phone" , param.getString("phone1")+"-"+param.getString("phone2")+"-"+param.getString("phone3"));
			dbparam.put("handy" , param.getString("handy1")+"-"+param.getString("handy2")+"-"+param.getString("handy3") );
			dbparam.put("memo" , param.getString("memo"));
			dbparam.put("bankInfo", param.getString("bankInfo")+"0000");
			dbparam.put("bankNum" , param.getString("bankNum"));
			dbparam.put("bankName" , param.getString("bankName"));
			dbparam.put("bankMoney" , param.getString("bankMoney"));
			dbparam.put("busu" , param.getString("busu"));
			dbparam.put("stuSch" , param.getString("stuSch"));
			dbparam.put("stuPart" , param.getString("stuPart"));
			dbparam.put("stuClass" , param.getString("stuClass"));
			dbparam.put("stuProf" , param.getString("stuProf"));
			dbparam.put("stuCaller" , param.getString("stuCaller"));
			dbparam.put("fileNm" , newFileName);
			dbparam.put("addr3" , param.getString("addr3"));
			dbparam.put("bdMngNo" , param.getString("bdMngNo"));
			dbparam.put("aplcDt" , DateUtil.getCurrentDate("yyyyMMdd"));

			if(param.getString("userName") != null && !"".equals(param.getString("userName"))){

				System.out.println("aplcPaymentStu"+dbparam);
				generalDAO.insert("reader.subscriptionForm.aplcPaymentStu" , dbparam);// 자동이체 정보 등록
				mav.addObject("errCd", "1"); 
				mav.addObject("message", "처리 되었습니다.");
				mav.setViewName("reader/SubscriptionForm/message");
				return mav;
			}else{
				mav.addObject("errCd", "-1");
				mav.addObject("message", "처리 되지 않았습니다. 입력값을 다시 확인해 주세요.");
				mav.setViewName("reader/SubscriptionForm/message");
				return mav;
			}
		}catch(Exception e){
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}

	/**
	 * 사원확장 조회 페이지 오픈
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView empExtd(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" ); // 핸드폰 앞자리 번호 조회

		mav.addObject("mobileCode" , mobileCode);
		mav.setViewName("reader/SubscriptionForm/empExtd");
		return mav;
	}
	
	/**
	 * 사원확장 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView searchEmpExtd(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		HttpServletParam param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();

		try{
			HashMap<String, Object> dbparam = new HashMap<String, Object>();

			dbparam.put("empNm" , param.getString("empNm"));
			String empTel = param.getString("empTel1")+param.getString("empTel2")+param.getString("empTel3");
			dbparam.put("empTel" , empTel);

			List empExtdList = generalDAO.queryForList("reader.subscriptionForm.empExtdList", dbparam ); // 사원확장 현황 조회
			List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" ); // 핸드폰 앞자리 번호 조회
			List totalEmpExtdCount = generalDAO.queryForList("reader.subscriptionForm.getTotalCount" , dbparam);	// 사원확장 통계

			mav.addObject("param" , param);
			mav.addObject("mobileCode" , mobileCode);
			mav.addObject("totalEmpExtdCount" , totalEmpExtdCount);
			mav.addObject("empExtdList" , empExtdList);
			mav.setViewName("reader/SubscriptionForm/empExtd");
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
	 * 도로명주소 적용 새주소찾기
	 * 
	 * @category 새주소 팝업 호출(도로명주소)
	 * @author ycpark
	 * @return
	 * @throws Exception
	 */

	public ModelAndView popNewAddr(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();

		mav.setViewName("reader/SubscriptionForm/pop_newAddr");
		return mav;
	}

	/**
	 * 새주소 검색
	 * 
	 * @param request
	 * @param response
	 * @category 새주소 검색
	 * @author ycpark
	 * @return
	 * @throws Exception
	 */	
	public ModelAndView searchNewAddr(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);

		try{
			HashMap<String, Object> dbparam = new HashMap<String, Object>();

			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 10;
			int totalCount = 0;
			
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));

			String searchType = param.getString("searchType", "1");
			String searchValue = param.getString("searchValue"+searchType);
			dbparam.put("searchType", searchType);
			dbparam.put("searchValue", searchValue);

			int tmp = searchValue.indexOf(" ");
			int tmpBar = searchValue.indexOf("-");

			// searchType{1:도로명주소, 2:건물명, 3:지번주소}
			if("1".equals(searchType)){
				if(searchValue.indexOf(" ") > -1){
					dbparam.put("searchValue", searchValue.substring(0,tmp+1).replace(" ", ""));
					if(searchValue.indexOf("-") > -1){
						if(checkNumeric(searchValue.substring(tmp+1,tmpBar))){
							dbparam.put("bdNo1", searchValue.substring(tmp+1,tmpBar));							
						}
						if(checkNumeric(searchValue.substring(tmpBar+1))){
							dbparam.put("bdNo2", searchValue.substring(tmpBar+1));
						}
					}else{
						if(checkNumeric(searchValue.substring(tmp+1))){
							dbparam.put("bdNo1", searchValue.substring(tmp+1));
						}
					}
					dbparam.put("searchValue", searchValue.substring(0,tmp+1).replace(" ", ""));
				}else{
					dbparam.put("searchValue", searchValue);
				}
			}else if("3".equals(searchType)){
				if(searchValue.indexOf(" ") > -1){
					if(searchValue.indexOf("-") > -1){
						if(checkNumeric(searchValue.substring(tmp+1,tmpBar))){
							dbparam.put("lotNo1", searchValue.substring(tmp+1,tmpBar));							
						}
						if(checkNumeric(searchValue.substring(tmpBar+1))){
							dbparam.put("lotNo2", searchValue.substring(tmpBar+1));							
						}
					}else{
						if(checkNumeric(searchValue.substring(tmp+1))){
							dbparam.put("lotNo1", searchValue.substring(tmp+1));
						}
					}
					dbparam.put("searchValue", searchValue.substring(0,tmp+1).replace(" ", ""));
				}else{
					dbparam.put("searchValue", searchValue);
				}
			}else{
				if(searchValue.indexOf(" ") > -1){
					dbparam.put("searchValue", searchValue.substring(tmp+1));
					dbparam.put("addInfo", searchValue.substring(0,tmp+1).replace(" ", ""));
				}else{
					dbparam.put("searchValue", searchValue);
				}							
			}

			System.out.println("dbparam<><><><><><><>>"+dbparam);

			totalCount = generalDAO.count("reader.subscriptionForm.searchNewAddrCount", dbparam);
			List newAddrList = generalDAO.queryForList("reader.subscriptionForm.searchNewAddr", dbparam);

			mav.addObject("totalCount", totalCount);
			mav.addObject("searchValue", searchValue);
			mav.addObject("searchType", searchType);
			mav.addObject("param", param);
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, pageSize));
			mav.addObject("newAddrList" , newAddrList);
			mav.setViewName("reader/SubscriptionForm/pop_newAddr");
		}catch (Exception e) {
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
		}
		return mav;
	}
	
	/**
	 * 자동이체 거래내역 로그인 페이지
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView autobillLogin(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		
		mav.addObject("titleTxt", "자동이체 거래내역 로그인");
		mav.addObject("flag", "sugm");
		mav.setViewName("reader/SubscriptionForm/autobill/autobillLogin");
		
		return mav;
	}
	
	/**
	 * 자동이체 계좌변경 로그인 페이지
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView bankNumChgLogin(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		
		mav.addObject("titleTxt", "자동이체 계좌변경 로그인");
		mav.addObject("flag", "bankNum");
		mav.setViewName("reader/SubscriptionForm/autobill/autobillLogin");
		
		return mav;
	}
	
	/**
	 * 자동이체 거래내역 로그인
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView autobillLoginProcess(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		HttpServletParam param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HashMap<String, Object> dbparam = new HashMap<String, Object>();

		try{
			String bankNm = param.getString("bankNm").trim();
			String bankNumCode = param.getString("bankNumCode").trim();
			String readerType = "";
			String readerBoseq = "";
			String readNo = "";
			
			List sugmList = null;
			
			dbparam.put("bankNm", bankNm);
			dbparam.put("bankNumCode", bankNumCode);
			
			//독자인지확인
			Map<String, String>chkAutoBillReaderYn =  (Map)generalDAO.getSqlMapClient().queryForObject("reader.subscriptionForm.chkAutoBillReaderYn", dbparam);
			
			if(chkAutoBillReaderYn != null) {
				readerType = chkAutoBillReaderYn.get("READERTYPE");
				readerBoseq = chkAutoBillReaderYn.get("REALJIKUK");
				readNo = chkAutoBillReaderYn.get("READNO");
				
				dbparam.put("boseq", readerBoseq);
				dbparam.put("readNo", readNo);
				
				//수금리스트 조회
				sugmList = generalDAO.getSqlMapClient().queryForList("reader.subscriptionForm.selectAutoBillReaderSugmList", dbparam);
				
				mav.addObject("readerType" , readerType);
				mav.addObject("sugmList" , sugmList);
				mav.addObject("bankNm", bankNm);
				mav.setViewName("reader/SubscriptionForm/autobill/autobillPaymentList");
				return mav;
			} else {
				mav.setViewName("common/message");
				mav.addObject("message", "등록된 독자가 아닙니다. 다시한번 확인해주세요.");
				mav.addObject("returnURL", "/reader/subscriptionForm/autobillLogin.do");
				return mav;
			}
		}catch(Exception e){
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", "자동이체 거래내역 로그인 오류");
			mav.addObject("returnURL", "/reader/subscriptionForm/autobillLogin.do");
			return mav;
		}
	}
	
	/**
	 * 자동이체 계좌변경 로그인
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView bankNumChgLoginProcess(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		HttpServletParam param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HashMap<String, Object> dbparam = new HashMap<String, Object>();

		try{
			String bankNm = param.getString("bankNm").trim();
			String urlType = param.getString("urlType");
			
			if("UPT".equals(urlType)) {
				bankNm = new String(bankNm.getBytes("8859_1"),"UTF-8");
			}
			
			String bankNumCode = param.getString("bankNumCode").trim();
			String readerType = "";
			String readerBoseq = "";
			String readNo = "";
			
			Map readerData = null;
			
			dbparam.put("bankNm", bankNm);
			dbparam.put("bankNumCode", bankNumCode);
			
			//독자인지확인
			Map<String, String>chkAutoBillReaderYn =  (Map)generalDAO.getSqlMapClient().queryForObject("reader.subscriptionForm.chkAutoBillReaderYn", dbparam);
			
			if(chkAutoBillReaderYn != null) {
				readerType = chkAutoBillReaderYn.get("READERTYPE");
				readerBoseq = chkAutoBillReaderYn.get("REALJIKUK");
				readNo = chkAutoBillReaderYn.get("READNO");
				
				dbparam.put("boseq", readerBoseq);
				dbparam.put("readNo", readNo);
				
				if("ADULT".equals(readerType)) {			//일반독자
					readerData = (Map)generalDAO.getSqlMapClient().queryForObject("reader.subscriptionForm.selectAutoBillReaderData", dbparam);
					
				} else if("STU".equals(readerType)) {	//학생독자
					readerData = (Map)generalDAO.getSqlMapClient().queryForObject("reader.subscriptionForm.selectAutoBillStuReaderData", dbparam);
				}
				
				List bankInfo = generalDAO.queryForList("reader.common.bankInfo"); // 은행리스트 조회
				
				mav.addObject("readerType" , readerType);
				mav.addObject("bankInfo" , bankInfo);
				mav.addObject("readerData" , readerData);
				mav.addObject("bankNm", bankNm);
				mav.addObject("boseq" , readerBoseq);
				mav.addObject("readNo", readNo);
				mav.setViewName("reader/SubscriptionForm/autobill/bankNumChg");
				return mav;
			} else {
				mav.setViewName("common/message");
				mav.addObject("message", "등록된 독자가 아닙니다. 다시한번 확인해주세요.");
				mav.addObject("returnURL", "/reader/subscriptionForm/bankNumChgLogin.do");
				return mav;
			}
		}catch(Exception e){
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", "자동이체 계좌변경 로그인 오류");
			mav.addObject("returnURL", "/reader/subscriptionForm/bankNumChgLogin.do");
			return mav;
		}
	}
	
	/**
	 * 계좌 정보 업데이트
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView updateBankNum(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		HttpServletParam param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HashMap<String, Object> dbparam = new HashMap<String, Object>();

		try{
			String boseq = param.getString("boseq");
			String readerType = param.getString("readerType");
			String readNo = param.getString("readNo");
			String numId = param.getString("numId");
			
			String newBankInfo = param.getString("newBankInfo") + "0000";	//은행코드
			String newBankName = param.getString("newBankName");			//예금주명
			String newBankNum = param.getString("newBankNum");				//계좌번호
			
			dbparam.put("boseq", boseq);
			dbparam.put("readNo", readNo);
			dbparam.put("numId", numId);
			dbparam.put("newBankInfo", newBankInfo);
			dbparam.put("bank", newBankInfo);
			dbparam.put("newBankName", newBankName);
			dbparam.put("newBankNum", newBankNum);
			
			System.out.println("boseq = "+boseq);
			System.out.println("readNo = "+boseq);
			System.out.println("numId = "+numId);
			System.out.println("newBankInfo = "+newBankInfo);
			System.out.println("newBankName = "+newBankName);
			System.out.println("newBankNum = "+newBankNum);
		
			if("ADULT".equals(readerType)) {			//일반독자
				dbparam.put("status", "EA00");
				// 기존데이터를 신규로 복사하면서 EA13-로 변경
				generalDAO.getSqlMapClient().insert("reader.billingAdmin.cloneBankInfo", dbparam);
				// 기존데이터 시리얼 증가 EA00으로 변경
				generalDAO.getSqlMapClient().update("reader.billingAdmin.updateBankInfoForReader", dbparam);
				
				generalDAO.getSqlMapClient().update("reader.subscriptionForm.updateBankInfoForAdult", dbparam);
			} else if("STU".equals(readerType)) {	//학생독자
				//기존데이터를 신규로 복사하면서 EA13- 로 변경
				generalDAO.getSqlMapClient().insert("reader.billingStuAdmin.cloneBankInfoForReader", dbparam);
				//기존데이터 numid 증가 EA00으로 변경
				generalDAO.getSqlMapClient().update("reader.billingStuAdmin.updateBankInfoForReader", dbparam);
				
				generalDAO.getSqlMapClient().update("reader.subscriptionForm.updateBankInfoForStu", dbparam);
			}
			
			String strPparam1 = URLEncoder.encode(newBankName, "UTF-8");
			strPparam1=new String(strPparam1.getBytes("8859_1"),"UTF-8"); 
			mav.setView(new RedirectView("/reader/subscriptionForm/bankNumChgLoginProcess.do?bankNm="+strPparam1+"&bankNumCode="+newBankNum+"&urlType=UPT"));
			return mav;
		}catch(Exception e){
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", "자동이체 계좌변경 로그인 오류");
			mav.addObject("returnURL", "/reader/subscriptionForm/bankNumChgLogin");
			return mav;
		}
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
	
}
