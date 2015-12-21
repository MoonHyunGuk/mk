/*------------------------------------------------------------------------------
 * NAME : BillingAdminController 
 * DESC : 자동이체독자(관리자)
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

public class BillingAdminController extends MultiActionController implements
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

		try {
			HashMap<String, Object> dbparam = new HashMap<String, Object>();

			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 20;
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			int totalCount = 0;

			List billingList = generalDAO.queryForList("reader.billingAdmin.getBillingList", dbparam);// 자동이체 일반독자 리스트
			totalCount = generalDAO.count("reader.billingAdmin.getBillingCount", dbparam);// 자동이체 일반독자 카운트
			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList", dbparam);// 지국 목록

			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 20));
			mav.addObject("billingList", billingList);
			mav.addObject("agencyAllList", agencyAllList);
			mav.addObject("status", "EA00");
			mav.addObject("now_menu", MENU_CODE_READER_BILLING);
			mav.setViewName("reader/billingAdmin/billingList");

			return mav;
		} catch (Exception e) {
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

		try {
			HashMap<String, Object> dbparam = new HashMap<String, Object>();

			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 20;
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			int totalCount = 0;

			dbparam.put("inType", param.getString("inType"));
			dbparam.put("realJikuk", param.getString("realJikuk"));
			dbparam.put("search_type", param.getString("search_type"));
			dbparam.put("search_key", param.getString("search_key"));
			dbparam.put("status", param.getString("status"));

			List billingList = generalDAO.queryForList("reader.billingAdmin.searchBilling", dbparam);// 자동이체 일반독자 검색 리스트
			totalCount = generalDAO.count("reader.billingAdmin.searchBillingCount", dbparam);// 자동이체일반독자 검색 카운트
			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList", dbparam);// 지국 목록

			mav.addObject("inType", param.getString("inType"));
			mav.addObject("realJikuk", param.getString("realJikuk"));
			mav.addObject("search_type", param.getString("search_type"));
			mav.addObject("search_key", param.getString("search_key"));
			mav.addObject("status", param.getString("status"));
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 10));
			mav.addObject("billingList", billingList);
			mav.addObject("agencyAllList", agencyAllList);

			mav.addObject("now_menu", MENU_CODE_READER_BILLING);
			mav.setViewName("reader/billingAdmin/billingList");

			return mav;
		} catch (Exception e) {
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

		try {
			HashMap<String, Object> dbparam = new HashMap<String, Object>();

			dbparam.put("numId", param.getString("numId"));

			String flag = param.getString("flag");
			int countCalllog = generalDAO.count(	"reader.billingAdmin.countCalllog", dbparam); // 통화로그 카운트

			List agencyAllList = generalDAO	.queryForList("reader.common.agencyAllList");// 지국 목록
			List areaCode = generalDAO.queryForList("reader.common.retrieveAreaCode");// 전화번호 지역번호
			List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode");// 핸도폰 앞자리														
			List bankInfo = generalDAO.queryForList("reader.common.bankInfo");// 은행
			List memoList = null;
			Map<String, Object> billingInfo = (Map)generalDAO.queryForObject("reader.billingAdmin.billingInfo", dbparam);// 자동이체 정보
			Map<String, Object> stopReserveData = null;
			
			String zipcode  = null;
			String addr1  = null;
			String addr2  = null;
			String newaddr  = null;
			String bdMngNo = null;
			
			if("UPT".equals(flag) || "SAVEOK".equals(flag)) {
				// memoList
				memoList = generalDAO.queryForList("util.memo.getMemoList", dbparam);
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

			mav.addObject("agencyAllList", agencyAllList);
			mav.addObject("areaCode", areaCode);
			mav.addObject("mobileCode", mobileCode);
			mav.addObject("bankInfo", bankInfo);
			mav.addObject("billingInfo", billingInfo);
			mav.addObject("countCalllog", countCalllog);
			mav.addObject("memoList", memoList);
			mav.addObject("stopReserveData", stopReserveData);
			mav.addObject("flag", flag);

			// mav.addObject("now_menu", MENU_CODE_READER_BILLING);
			mav.setViewName("reader/billingAdmin/billingInfo");

			return mav;
		} catch (Exception e) {
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

		try {
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			dbparam.put("numId", param.getString("numId"));

			dbparam.put("cmsType", String.valueOf("EA13+"));// 자동이체 신청 이력 조건 값
			List aplcPayment = generalDAO.queryForList("reader.billingAdmin.paymentHist", dbparam);// 자동이체 신청 이력

			dbparam.put("cmsType", String.valueOf("EA21"));// 자동이체 청구이력 조건값
			List paymentHist = generalDAO.queryForList("reader.billingAdmin.paymentHist", dbparam);// 자동이체납부이력

			dbparam.put("cmsType", String.valueOf("EA13-"));// 자동이체 해지이력 조건값
			List canclePayment = generalDAO.queryForList("reader.billingAdmin.paymentHist", dbparam);// 자동이체납부이력

			List refundHist = generalDAO.queryForList("reader.billingAdmin.refundHist", dbparam);// 자동이체 환불 내역

			if (aplcPayment != null) {
				List tmpList = new ArrayList();
				for (int i = 0; i < aplcPayment.size(); i++) {
					Map<String, Object> tmpMap = (Map) aplcPayment.get(i);
					String cmsresult = (String) tmpMap.get("CMSRESULT");
					if (StringUtils.isNotEmpty(cmsresult)
							&& cmsresult.length() >= 5) {
						if ("EEEEE".equals(cmsresult)) {
							tmpMap.put("CMSRESULTMSG", "신청확인중");
						} else {
							tmpMap.put("CMSRESULTMSG", CommonUtil.err_code(cmsresult.substring(1, 5)));
						}
					}
					tmpList.add(tmpMap);
				}
				aplcPayment = tmpList;
			}
			if (paymentHist != null) {
				List tmpList = new ArrayList();
				for (int i = 0; i < paymentHist.size(); i++) {
					Map<String, Object> tmpMap = (Map) paymentHist.get(i);
					String cmsresult = (String) tmpMap.get("CMSRESULT");
					if (StringUtils.isNotEmpty(cmsresult)
							&& cmsresult.length() >= 5) {
						if ("EEEEE".equals(cmsresult)) {
							tmpMap.put("CMSRESULTMSG", "신청확인중");
						} else {
							tmpMap.put("CMSRESULTMSG", CommonUtil.err_code(cmsresult.substring(1, 5)));
						}
					}
					tmpList.add(tmpMap);
				}
				paymentHist = tmpList;
			}
			if (canclePayment != null) {
				List tmpList = new ArrayList();
				for (int i = 0; i < canclePayment.size(); i++) {
					Map tmpMap = (Map) canclePayment.get(i);
					String cmsresult = (String) tmpMap.get("CMSRESULT");
					if (StringUtils.isNotEmpty(cmsresult)
							&& cmsresult.length() >= 5) {
						if ("EEEEE".equals(cmsresult)) {
							tmpMap.put("CMSRESULTMSG", "신청확인중");
						} else {
							tmpMap.put("CMSRESULTMSG", CommonUtil.err_code(cmsresult.substring(1, 5)));
						}
					}
					tmpList.add(tmpMap);
				}
				canclePayment = tmpList;
			}
			mav.addObject("userName", param.getString("userName"));
			mav.addObject("aplcPayment", aplcPayment);
			mav.addObject("paymentHist", paymentHist);
			mav.addObject("canclePayment", canclePayment);
			mav.addObject("refundHist", refundHist);

			mav.setViewName("reader/billingAdmin/pop_paymentHist");
			return mav;
		} catch (Exception e) {
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

		try {
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);

			HashMap<String, Object> dbparam = new HashMap<String, Object>();

			dbparam.put("numId", param.getString("numId"));
			dbparam.put("levels", param.getString("levels"));
			dbparam.put("condition", param.getString("condition"));

			List billingInfo = generalDAO.getSqlMapClient().queryForList("reader.billingAdmin.billingInfo", dbparam);// 자동이체 정보

			Map<String, Object> temp = (Map) billingInfo.get(0);
			dbparam.put("readNo", (String) temp.get("READNO"));
			dbparam.put("agency_serial", (String) temp.get("REALJIKUK"));

			// 일시정지
			if ("2".equals(param.getString("levels"))) {
				dbparam.put("sgType", "033");
				generalDAO.getSqlMapClient().update("reader.readerManage.updateReaderSgType", dbparam); // 수금방법
																			// 수정
			} else if ("3".equals(param.getString("levels"))) {
				// 임의해지
				if ("EA99".equals(param.getString("condition"))) {
					dbparam.put("sgType", "012");
					// 삭제 및 정지해제
				} else {
					dbparam.put("sgType", "021");
				}
				generalDAO.getSqlMapClient().update("reader.readerManage.updateReaderSgType", dbparam); // 수금방법 수정

				// 수금테이블에 상태가 미수인 건 수금방법 수정 (박윤철 12.03.29)
				// 01. 수금 테이블 수정대상 조회
				List sugmList = generalDAO.getSqlMapClient().queryForList("reader.billingAdmin.getChgSugmTargetList", dbparam);

				for (int i = 0; i < sugmList.size(); i++) {
					Map<String, Object> cList = (Map) sugmList.get(i);
					dbparam.put("newsCd", cList.get("NEWSCD"));
					dbparam.put("yymm", cList.get("YYMM"));
					dbparam.put("seq", cList.get("SEQ"));

					// 02.수금 이력 생성
					generalDAO.getSqlMapClient().insert("collection.collection.insertReaderSugmHist", dbparam); // 수금정보히스토리업데이트

					// 03.수금 방법 수정
					generalDAO.getSqlMapClient().update("reader.billingAdmin.updateReaderSugm", dbparam); // 수금정보 업데이트
				}
			}

			generalDAO.getSqlMapClient().update("reader.billingAdmin.updateTblUserState", dbparam);

			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			mav.setViewName("common/message");
			mav.addObject("message", "처리 되었습니다.");
			mav.addObject("returnURL", "/reader/billingAdmin/billingList.do");
			return mav;

		} catch (Exception e) {
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		} finally {
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

		try {
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);

			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			dbparam.put("chgps", session.getAttribute(SESSION_NAME_ADMIN_USERID));

			dbparam.put("agency_serial", dbparam.get("chgps"));
			dbparam.put("numId", param.getString("numId"));
			dbparam.put("readNo", param.getString("readNo"));
			dbparam.put("sgType", "012");

			/*
			 * 자동이체 해지를 하면 구독정보 히스토리 업데이트 후 구독정보 해지
			 */
			List reader = generalDAO.queryForList("reader.readerManage.getReader", dbparam);
			for (int i = 0; i < reader.size(); i++) {
				Map<String, Object> list = (Map) reader.get(i);
				dbparam.put("newsCd", list.get("NEWSCD"));
				dbparam.put("seq", list.get("SEQ"));
				generalDAO.insert("reader.readerManage.insertreaderHist", dbparam);
			}

			generalDAO.update("reader.readerManage.closeNews", dbparam);// 구독 해지
			generalDAO.update("reader.billingAdmin.removePayment", dbparam);

			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			mav.setViewName("common/message");
			mav.addObject("message", "처리 되었습니다.");
			mav.addObject("returnURL", "/reader/billingAdmin/billingList.do");
			return mav;

		} catch (Exception e) {
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

		List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList");// 지국 목록
		List areaCode = generalDAO.queryForList("reader.common.retrieveAreaCode");// 전화번호 지역번호 조회
		List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode");// 핸도폰 앞자리 번호 조회
		List bankInfo = generalDAO.queryForList("reader.common.bankInfo");// 은행 정보 조회

		mav.addObject("agencyAllList", agencyAllList);
		mav.addObject("areaCode", areaCode);
		mav.addObject("mobileCode", mobileCode);
		mav.addObject("bankInfo", bankInfo);
		mav.addObject("now_menu", MENU_CODE_READER_BILLING);
		mav.addObject("memoList", "");
		mav.addObject("addView", "");
		mav.addObject("flag", "INS");

		mav.setViewName("reader/billingAdmin/billingInfo");
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
		HttpSession session = request.getSession();

		try {
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			
			System.out.println("=========================================> savePayment start");
			dbparam.put("bankInfo", param.getString("bankInfo") + "0000");

			dbparam.put("inType", param.getString("inType"));
			dbparam.put("userName", param.getString("userName"));
			dbparam.put("phone", param.getString("phone1") + "-" + param.getString("phone2") + "-" + param.getString("phone3"));
			//dbparam.put("zip1", param.getString("zip1"));
			//dbparam.put("zip2", param.getString("zip2"));
			dbparam.put("dlvZip", param.getString("dlvZip"));
			dbparam.put("addr1", param.getString("addr1"));
			dbparam.put("newaddr", param.getString("newaddr"));
			dbparam.put("addr2", param.getString("addr2"));
			dbparam.put("realJikuk", param.getString("realJikuk"));
			dbparam.put("busu", param.getString("busu"));
			dbparam.put("bankMoney", param.getString("bankMoney"));
			dbparam.put("bankName", param.getString("bankName"));
			dbparam.put("bankNum", param.getString("bankNum"));
			dbparam.put("saup", param.getString("saup"));
			dbparam.put("handy", param.getString("handy1") + "-" + param.getString("handy2") + "-" + param.getString("handy3"));
			dbparam.put("email", param.getString("email"));
			dbparam.put("memo", param.getString("memo"));
			dbparam.put("whoStep", "1");
			dbparam.put("dbMngNo", param.getString("dbMngNum"));
			dbparam.put("readNo", param.getString("readNo"));

			// 예약해지관련 
			String cancelDt = param.getString("cancelDt");
			dbparam.put("cancelMemo", param.getString("cancelMemo"));
			dbparam.put("cancelDt", param.getString("cancelDt"));
			dbparam.put("loginId", session.getAttribute(SESSION_NAME_ADMIN_USERID));
			dbparam.put("readerType", "일반");

			String numId = (String) generalDAO.getSqlMapClient().queryForObject("reader.billingAdmin.getUsersNumId");
			dbparam.put("numId", numId);

			// 자동이체 정보 등록
			generalDAO.insert("reader.billingAdmin.savePayment", dbparam);

			//
			if (!"".equals(cancelDt)) {
				generalDAO.insert("reader.billingAdmin.insertStopReserveData", dbparam);
			}

			mav.setViewName("common/message");
			mav.addObject("message", "처리 되었습니다.");
			mav.addObject("returnURL", "/reader/billingAdmin/billingList.do");
			return mav;
		} catch (Exception e) {
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
		try {
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			
			System.out.println("=========================================> updatePaymentFinal start");
			dbparam.put("bankInfo", param.getString("bankInfo") + "0000");
			dbparam.put("inType", param.getString("inType"));
			dbparam.put("userName", param.getString("userName"));
			dbparam.put("phone", param.getString("phone1") + "-" + param.getString("phone2") + "-" + param.getString("phone3"));
			//dbparam.put("zip1", param.getString("zip1"));
			//dbparam.put("zip2", param.getString("zip2"));
			dbparam.put("dlvZip", param.getString("dlvZip"));
			dbparam.put("addr1", param.getString("addr1"));
			dbparam.put("addr2", param.getString("addr2"));
			dbparam.put("newaddr", param.getString("newaddr"));
			dbparam.put("bdMngNo", param.getString("bdMngNo"));
			dbparam.put("jiSerial", param.getString("jiSerial"));
			dbparam.put("realJikuk", param.getString("realJikuk"));
			dbparam.put("busu", param.getString("busu"));
			dbparam.put("bankMoney", param.getString("bankMoney"));
			dbparam.put("bankName", param.getString("bankName"));
			dbparam.put("bankNum", param.getString("bankNum"));
			dbparam.put("saup", param.getString("saup"));
			dbparam.put("handy", param.getString("handy1") + "-" + param.getString("handy2") + "-" + param.getString("handy3"));
			dbparam.put("email", param.getString("email"));
			dbparam.put("memo", param.getString("memo"));
			dbparam.put("numId", param.getString("numId"));
			dbparam.put("addrSeq", param.getString("addrSeq"));
			if ("on".equals(param.getString("newYn"))) {
				dbparam.put("newYn", "Y");
			} else {
				dbparam.put("newYn", "N");
			}
			// 예약해지관련
			String cancelDt = param.getString("cancelDt");
			dbparam.put("cancelMemo", param.getString("cancelMemo"));
			dbparam.put("cancelDt", param.getString("cancelDt"));
			dbparam.put("loginId",	session.getAttribute(SESSION_NAME_ADMIN_USERID));
			dbparam.put("readerType", "일반");
			
			System.out.println("param.getString(serial) = "+param.getString("serial"));
			System.out.println("param.getString(inType) = "+param.getString("inType"));
			System.out.println("param.getString(readNo) = "+param.getString("readNo"));

			if ("기존".equals(param.getString("inType"))) {
				if ("".equals(param.getString("serial"))) { // 납부자번호가 없을때

					dbparam.put("readNo", param.getString("readNo"));
					List rederInfo = generalDAO.getSqlMapClient().queryForList("reader.billingAdmin.getReaderInfo", dbparam);// 고객 정보 조회(독자번호)

					if (rederInfo.size() == 0) { // 독자번호가 없을때
						mav.setViewName("common/message");
						mav.addObject("message", "해당 지국에 독자 정보가 존재하지 않습니다.\\n지국에 다시 확인해 주시기 바랍니다.");
						mav.addObject("returnURL", "/reader/billingAdmin/billingInfo.do?numId=" + param.getString("numId")+"&flag=UPT");
						return mav;
					} else if (rederInfo.size() == 1) { // 독자번호가 있을때
						Map temp = (Map) rederInfo.get(0);
						String readNo = (String) temp.get("READNO");
						dbparam.put("readNo", readNo);
						dbparam.put("chgps", session.getAttribute(SESSION_NAME_ADMIN_USERID));
						dbparam.put("agency_serial", dbparam.get("chgps"));
						dbparam.put("sgType", "021");

						// 메모등록
						if (!("").equals(param.getString("memo"))) { // null이 아닐때만 메모생성
							dbparam.put("READNO", param.getString("readNo"));
							dbparam.put("MEMO", param.getString("memo"));
							dbparam.put("CREATEID", (String) session.getAttribute(SESSION_NAME_ADMIN_USERID));

							generalDAO.getSqlMapClient().insert( "util.memo.insertMemo", dbparam); // 메모생성
						}

						// 예약해지등록
						if (!"".equals(cancelDt)) {
							int chkCnt = generalDAO.count("reader.billingAdmin.chkStopReserveReader", dbparam); // 해지예약여부 조회
							if (chkCnt < 1) {
								generalDAO.insert("reader.billingAdmin.insertStopReserveData", dbparam);
							}
						}

						List reader = generalDAO.getSqlMapClient().queryForList("reader.readerManage.getReader", dbparam);
						for (int i = 0; i < reader.size(); i++) {
							Map list = (Map) reader.get(i);
							dbparam.put("newsCd", list.get("NEWSCD"));
							dbparam.put("seq", list.get("SEQ"));
							generalDAO.getSqlMapClient().insert("reader.readerManage.insertreaderHist", dbparam);
						}

						// 수금타입변경
						generalDAO.getSqlMapClient().update("reader.readerManage.updateSgType", dbparam);

						// 자동이체 정보 최종 등록
						generalDAO.getSqlMapClient().update("reader.billingAdmin.updatePaymentFinal", dbparam);

						mav.setViewName("common/message");
						mav.addObject("message", "처리 되었습니다.");
						mav.addObject("returnURL", "/reader/billingAdmin/billingInfo.do?numId=" + param.getString("numId")+"&flag=SAVEOK");
						generalDAO.getSqlMapClient().getCurrentConnection().commit();
						return mav;
					} else if (rederInfo.size() > 1) {
						mav.setViewName("common/message");
						mav.addObject("message", "해당 지국에 동일 독자 정보가 " + rederInfo.size() + "개 존재합니다.\\n구독정보의 고객명, 주소정보와 동일하게 입력해 주시기 바랍니다.");
						mav.addObject("returnURL", "/reader/billingAdmin/billingInfo.do?numId=" + param.getString("numId")+"&flag=UPT");
						return mav;
					}
				} else {
					/*
					 * 지국변경 자동이체 a->b ① a 지국 독자 해지 ② b 지국에 신규 독자 생성 ③ b : a 자동이체
					 * 정보 카피 realjikuk ,readno 변경 ④ a : 자동이체 정보 ea99로 변경 시리얼 증가
					 * 
					 * 
					 * 지국변경 아니면 단순 수정...
					 */
					if (!param.getString("realJikuk").equals(param.getString("old_realJikuk"))) {
						dbparam.put("readNo", param.getString("readNo"));
						dbparam.put("old_realJikuk", param.getString("old_realJikuk"));

						// 신규데이터
						/* ① */
						dbparam.put("chgps", session.getAttribute(SESSION_NAME_ADMIN_USERID));
						dbparam.put("agency_serial", dbparam.get("chgps"));

						/*
						 * 자동이체 해지를 하면 구독정보 히스토리 업데이트 후 구독정보 해지
						 */

						List reader = generalDAO.getSqlMapClient().queryForList("reader.readerManage.getReader", dbparam);
						for (int i = 0; i < reader.size(); i++) {
							Map list = (Map) reader.get(i);
							dbparam.put("newsCd", list.get("NEWSCD"));
							dbparam.put("seq", list.get("SEQ"));
							generalDAO.getSqlMapClient().insert("reader.readerManage.insertreaderHist", dbparam);
						}
						generalDAO.getSqlMapClient().update("reader.readerManage.closeNews", dbparam);// 구독 해지
						/* ② */
						dbparam.put("newsCd", MK_NEWSPAPER_CODE);
						dbparam.put("agency_serial", param.getString("realJikuk"));
						dbparam.put("gno", "200");
						dbparam.put("bno", "000");
						dbparam.put("readNm", param.getString("userName"));
						dbparam.put("homeTel1", param.getString("phone1"));
						dbparam.put("homeTel2", param.getString("phone2"));
						dbparam.put("homeTel3", param.getString("phone3"));
						dbparam.put("mobile1", param.getString("handy1"));
						dbparam.put("mobile2", param.getString("handy2"));
						dbparam.put("mobile3", param.getString("handy3"));
						dbparam.put("dlvZip", param.getString("dlvZip"));
						dbparam.put("dlvAdrs1", param.getString("addr1"));
						dbparam.put("dlvAdrs2", param.getString("addr2"));
						dbparam.put("newaddr", param.getString("newaddr"));
						dbparam.put("bdMngNo", param.getString("bdMngNo"));
						dbparam.put("sgType", "021");
						dbparam.put("readTypeCd", "011");// 일반독자
						dbparam.put("uPrice", param.getString("bankMoney"));
						dbparam.put("qty", param.getString("busu"));
						dbparam.put("hjDt", DateUtil.getCurrentDate("yyyyMMdd"));
						dbparam.put("sgBgmm", param.getString("sgBgmm"));
						dbparam.put("aplcDt", DateUtil.getCurrentDate("yyyyMMdd"));
						dbparam.put("inps", session.getAttribute(SESSION_NAME_ADMIN_USERID));
						dbparam.put("chgPs", session.getAttribute(SESSION_NAME_ADMIN_USERID));
						dbparam.put("eMail", param.getString("email"));
						String readNo = (String) generalDAO.getSqlMapClient().queryForObject("reader.readerManage.getReadNo", dbparam);
						dbparam.put("readNo", readNo);
						// 통합독자생성
						generalDAO.getSqlMapClient().insert("reader.readerManage.insertTmreader", dbparam);
						// 구독정보 생성
						generalDAO.getSqlMapClient().insert("reader.readerManage.inserTmreaderNews", dbparam);

						// ③ 기존데이터를 신규로 복사하면서 관리지국 변경(tbl_users)
						generalDAO.getSqlMapClient().insert("reader.billingAdmin.cloneBankInfo2", dbparam);

						/* ④ */
						generalDAO.getSqlMapClient().update("reader.billingAdmin.updateChangeJikuk", dbparam);// 기존데이터 ea99 , SERIAL증가

						// 메모등록
						if (!("").equals(param.getString("memo"))) { // null이 아닐때만 메모생성
							dbparam.put("READNO", readNo);
							dbparam.put("MEMO", param.getString("memo"));
							dbparam.put("CREATEID", (String) session.getAttribute(SESSION_NAME_ADMIN_USERID));

							generalDAO.getSqlMapClient().insert("util.memo.insertMemo", dbparam); // 메모생성
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
						mav.addObject("returnURL", "/reader/billingAdmin/searchBilling.do?search_type=userName&status=ALL&search_key=" + param.getString("userName"));
						generalDAO.getSqlMapClient().getCurrentConnection().commit();
						return mav;

					} else {
						// parameters
						dbparam.put("readNm", param.getString("userName"));
						dbparam.put("homeTel1", param.getString("phone1"));
						dbparam.put("homeTel2", param.getString("phone2"));
						dbparam.put("homeTel3", param.getString("phone3"));
						dbparam.put("mobile1", param.getString("handy1"));
						dbparam.put("mobile2", param.getString("handy2"));
						dbparam.put("mobile3", param.getString("handy3"));
						dbparam.put("dlvZip", param.getString("dlvZip"));
						dbparam.put("dlvAdrs1", param.getString("addr1"));
						dbparam.put("dlvAdrs2", param.getString("addr2"));
						dbparam.put("newaddr", param.getString("newaddr"));
						dbparam.put("bdMngNo", param.getString("bdMngNo"));
						dbparam.put("uPrice", param.getString("bankMoney"));
						dbparam.put("qty", param.getString("busu"));
						dbparam.put("readNo", param.getString("readNo"));
						dbparam.put("old_realJikuk", param.getString("old_realJikuk"));
						dbparam.put("chgps", session.getAttribute(SESSION_NAME_ADMIN_USERID));
						dbparam.put("agency_serial", dbparam.get("chgps"));
						dbparam.put("readNo", param.getString("readNo"));

						// 정보수정을 위해서 시퀀스조회
						List reader = generalDAO.getSqlMapClient().queryForList("reader.readerManage.getReaderForOnlyDataUpdate", dbparam);
						for (int i = 0; i < reader.size(); i++) {
							Map list = (Map) reader.get(i);
							dbparam.put("newsCd", list.get("NEWSCD"));
							dbparam.put("seq", list.get("SEQ"));
							System.out.println("list_seq = "+ list.get("SEQ"));
							// 히스토리 입력
							generalDAO.getSqlMapClient().insert("reader.readerManage.insertreaderHistWithoutNewaddr", dbparam);
							// 정보수정_news테이블
							generalDAO.getSqlMapClient().update("reader.readerManage.updateReaderDataFor021", dbparam);
						}

						// 메모등록
						if (!("").equals(param.getString("memo"))) { // null이 아닐때만메모생성
							dbparam.put("READNO", param.getString("readNo"));
							dbparam.put("MEMO", param.getString("memo"));
							dbparam.put("CREATEID", (String) session.getAttribute(SESSION_NAME_ADMIN_USERID));

							generalDAO.getSqlMapClient().insert("util.memo.insertMemo", dbparam); // 메모생성
						}
						

						// 예약해지등록
						if (!"".equals(cancelDt)) {
							int chkCnt = generalDAO.count("reader.billingAdmin.chkStopReserveReader", dbparam); // 해지예약여부 조회
							if (chkCnt < 1) {
								generalDAO.insert("reader.billingAdmin.insertStopReserveData",dbparam);
							}
						}
						
						// 정보수정을 위해서 시퀀스조회
						System.out.println("boseq = "+param.getString("old_realJikuk"));
						System.out.println("opSeq = "+dbparam.get("seq"));
						
						dbparam.put("boseq", param.getString("old_realJikuk"));
						dbparam.put("readTypeCd", "011, 023");
						dbparam.put("sgType", "021");
						generalDAO.getSqlMapClient().update("reader.readerManage.updateReaderJusoTelData", dbparam);
						

						dbparam.put("numId", param.getString("numId"));
						
						generalDAO.getSqlMapClient().update("reader.billingAdmin.updatePayment", dbparam);// 자동이체정보 수정
					}
				}

				mav.setViewName("common/message");
				mav.addObject("message", "처리 되었습니다.");
				mav.addObject("returnURL", "/reader/billingAdmin/billingInfo.do?numId=" + param.getString("numId")+"&flag=SAVEOK");
				generalDAO.getSqlMapClient().getCurrentConnection().commit();
				return mav;
			} else {

				dbparam.put("inType", "기존");
				dbparam.put("userName", param.getString("userName"));
				dbparam.put("phone", param.getString("phone1") + "-" + param.getString("phone2") + "-" + param.getString("phone3"));
				dbparam.put("dlvZip", param.getString("dlvZip"));
				dbparam.put("addr1", param.getString("addr1"));
				dbparam.put("addr2", param.getString("addr2"));
				dbparam.put("newaddr", param.getString("newaddr"));
				dbparam.put("bdMngNo", param.getString("bdMngNo"));
				dbparam.put("jikuk", param.getString("realJikuk"));
				dbparam.put("busu", param.getString("busu"));
				dbparam.put("bankMoney", param.getString("bankMoney"));
				dbparam.put("bankName", param.getString("bankName"));
				dbparam.put("bankNum", param.getString("bankNum"));
				dbparam.put("saup", param.getString("saup"));
				dbparam.put( "handy", param.getString("handy1") + "-" + param.getString("handy2") + "-" + param.getString("handy3"));
				dbparam.put("email", param.getString("email"));
				dbparam.put("memo", "");
				dbparam.put("numId", param.getString("numId"));

				dbparam.put("newsCd", MK_NEWSPAPER_CODE);
				dbparam.put("agency_serial", param.getString("realJikuk"));
				dbparam.put("gno", "200");
				dbparam.put("bno", "000");
				dbparam.put("readNm", param.getString("userName"));
				dbparam.put("homeTel1", param.getString("phone1"));
				dbparam.put("homeTel2", param.getString("phone2"));
				dbparam.put("homeTel3", param.getString("phone3"));
				dbparam.put("mobile1", param.getString("handy1"));
				dbparam.put("mobile2", param.getString("handy2"));
				dbparam.put("mobile3", param.getString("handy3"));
				dbparam.put("dlvAdrs1", param.getString("addr1"));
				dbparam.put("dlvAdrs2", param.getString("addr2"));
				dbparam.put("sgType", "021");
				dbparam.put("readTypeCd", "011");// 일반독자
				dbparam.put("uPrice", param.getString("bankMoney"));
				dbparam.put("qty", param.getString("busu"));
				dbparam.put("hjDt", DateUtil.getCurrentDate("yyyyMMdd"));
				dbparam.put("sgBgmm", DateUtil.getWantDay(DateUtil.getCurrentDate("yyyyMMdd"), 2, 1).substring(0, 6));
				dbparam.put("aplcDt", DateUtil.getCurrentDate("yyyyMMdd"));
				dbparam.put("inps", session.getAttribute(SESSION_NAME_ADMIN_USERID));
				dbparam.put("chgPs", session.getAttribute(SESSION_NAME_ADMIN_USERID));
				dbparam.put("eMail", param.getString("email"));
				String readNo = (String) generalDAO.getSqlMapClient().queryForObject("reader.readerManage.getReadNo", dbparam);
				dbparam.put("readNo", readNo);
				// 통합독자생성
				generalDAO.getSqlMapClient().insert("reader.readerManage.insertTmreader", dbparam);
				// 구독정보 생성
				generalDAO.getSqlMapClient().insert("reader.readerManage.inserTmreaderNews", dbparam);
				// 자동이체정보 수정
				generalDAO.getSqlMapClient().update("reader.billingAdmin.updatePaymentFinal", dbparam);
				
				System.out.println("===========================> 신규121121");
				
				// 메모등록
				if (!("").equals(param.getString("memo"))) { // null이 아닐때만 메모생성
					dbparam.put("READNO", readNo);
					dbparam.put("MEMO", param.getString("memo"));
					dbparam.put("CREATEID", (String) session.getAttribute(SESSION_NAME_ADMIN_USERID));

					generalDAO.getSqlMapClient().insert("util.memo.insertMemo", dbparam); // 메모생성
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
			mav.addObject("returnURL", "/reader/billingAdmin/billingInfo.do?numId="+ param.getString("numId")+"&flag=SAVEOK");
			return mav;
		} catch (Exception e) {
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
		try {
			dbparam.put("numId", param.getString("numId"));
			dbparam.put("typeCd", param.getString("typeCd"));
			List callLog = generalDAO.queryForList("reader.billingAdmin.callLog", dbparam);

			// mav
			mav.addObject("param", param);
			mav.addObject("callLog", callLog);
			mav.setViewName("reader/billingAdmin/pop_callLog");
			return mav;

		} catch (Exception e) {
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
		try {
			dbparam.put("numId", param.getString("numId"));
			dbparam.put("typeCd", param.getString("typeCd"));
			dbparam.put("remk", param.getString("remk"));

			generalDAO.insert("reader.billingAdmin.insertCallLog", dbparam);

			// mav
			request.setAttribute("param", param);
			mav.setView(new RedirectView("/reader/billingAdmin/popRetrieveCallLog.do?numId="+ param.getString("numId") + "&typeCd="+ param.getString("typeCd")));
			return mav;

		} catch (Exception e) {
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
		try {
			dbparam.put("numId", param.getString("numId"));
			List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode");// 핸도폰 앞자리 번호 조회
			List bankInfo = generalDAO.queryForList("reader.common.bankInfo");// 은행정보 조회
			List billingInfo = generalDAO.queryForList("reader.billingAdmin.billingInfo", dbparam);// 자동이체 정보
			// mav
			mav.addObject("param", param);
			mav.addObject("mobileCode", mobileCode);
			mav.addObject("bankInfo", bankInfo);
			mav.addObject("billingInfo", billingInfo);
			mav.setViewName("reader/billingAdmin/pop_bankEdit");
			return mav;

		} catch (Exception e) {
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
		try {
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);

			dbparam.put("numId", param.getString("numId"));
			dbparam.put("bankName", param.getString("bankName"));
			dbparam.put("bankInfo", param.getString("bankInfo") + "0000");
			dbparam.put("bankNum", param.getString("bankNum"));
			dbparam.put("bankMoney", param.getString("bankMoney"));
			dbparam.put("saup", param.getString("saup"));
			dbparam.put("handy", param.getString("handy1") + "-" + param.getString("handy2") + "-" + param.getString("handy3"));
			dbparam.put("realJikuk", param.getString("realJikuk"));
			if ("EA21".equals(param.getString("tmp_status"))) {// 정상 사용중인 독자
																// 계좌번호 변경로직
				dbparam.put("status", "EA00");
				// 기존데이터를 신규로 복사하면서 EA13-로 등록
				generalDAO.getSqlMapClient().insert("reader.billingAdmin.cloneBankInfo", dbparam);
				// 기존데이터 시리얼 증가 EA00으로 변경
				generalDAO.getSqlMapClient().update("reader.billingAdmin.updateBankInfo", dbparam);
				mav.setViewName("common/message");
				mav.addObject("message", "처리 되었습니다.");
				mav.addObject("returnURL", "/reader/billingAdmin/searchBilling.do?search_type=userName&status=ALL&search_key="+ param.getString("userName"));
			} else {// 단순 정보 수정
				generalDAO.getSqlMapClient().update("reader.billingAdmin.updateBankInfo", dbparam);
				mav.setViewName("common/message");
				mav.addObject("message", "처리 되었습니다.");
				mav.addObject("returnURL", "/reader/billingAdmin/billingInfo.do?numId="+ param.getString("numId"));
			}
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			return mav;

		} catch (Exception e) {
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

	/**
	 * 신규신청 리스트(카드,자동이체,지로)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView aplcList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();

		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		Param param = new HttpServletParam(request);

		// 현재날짜
		Calendar rightNow = Calendar.getInstance();
		String year = String.valueOf(rightNow.get(Calendar.YEAR));
		String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));
		if (month.length() < 2)
			month = "0" + month;
		if (day.length() < 2)
			day = "0" + day;

		String fromDate = param.getString("fromDate", year + "-" + month + "-" + day); // 기간 from
		String toDate = param.getString("toDate", year + "-" + month + "-" + day); // 기간 to

		try {
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);

			dbparam.put("fromDate", StringUtil.replace(fromDate, "-", ""));
			dbparam.put("toDate", StringUtil.replace(toDate, "-", ""));
			dbparam.put("month", StringUtil.replace(fromDate, "-", "").substring(4, 6));
			dbparam.put("year", StringUtil.replace(toDate, "-", "").subSequence(0, 4));

			List aplc = generalDAO.queryForList("statistics.aplcStats.aplc", dbparam); // 카드 신규신청 리스트
			List card = generalDAO.queryForList("statistics.aplcStats.card", dbparam); // 지로 신규신청 리스트
			List edu = generalDAO.queryForList("statistics.aplcStats.edu", dbparam); // 교육용 리스트
			List tbl = generalDAO.queryForList("statistics.aplcStats.tbl", dbparam); // 자동이체 일반 신규신청 리스트
			List stu = generalDAO.queryForList("statistics.aplcStats.stu", dbparam); // 자동이체 학생 신규신청 리스트
			List count = generalDAO.queryForList("statistics.aplcStats.count", dbparam); // 신규신청 일계 월계 누계

			mav.addObject("card", card);
			mav.addObject("aplc", aplc);
			mav.addObject("edu", edu);
			mav.addObject("tbl", tbl);
			mav.addObject("stu", stu);
			mav.addObject("count", count);

			mav.addObject("fromDate", fromDate);
			mav.addObject("toDate", toDate);

			mav.addObject("now_menu", MENU_CODE_PRINT);
			mav.setViewName("reader/billingAdmin/aplcList");
			return mav;

		} catch (Exception e) {
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

	/**
	 * 신규신청 리스트(카드,자동이체,지로)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView aplcListExcel(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();

		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		Param param = new HttpServletParam(request);
		try {
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);

			dbparam.put("fromDate", StringUtil.replace(param.getString("fromDate"), "-", ""));
			dbparam.put("toDate", StringUtil.replace(param.getString("toDate"), "-", ""));

			if (!"".equals(param.getString("fromDate")) && !"".equals(param.getString("toDate"))) {
				dbparam.put("month", StringUtil.replace(param.getString("fromDate"), "-", "").substring(4, 6));
				dbparam.put("year", StringUtil.replace(param.getString("fromDate"), "-", "").subSequence(0, 4));

				List card = generalDAO.queryForList("statistics.aplcStats.card", dbparam); // 카드 신규신청 리스트
				List aplc = generalDAO.queryForList("statistics.aplcStats.aplc", dbparam); // 카드,지로 신규신청 리스트
				List edu = generalDAO.queryForList("statistics.aplcStats.edu", dbparam); // 교육용 신청 리스트
				List tbl = generalDAO.queryForList("statistics.aplcStats.tbl", dbparam); // 자동이체 일반 신규신청 리스트
				List stu = generalDAO.queryForList("statistics.aplcStats.stu", dbparam); // 자동이체 학생 신규신청 리스트
				List count = generalDAO.queryForList( "statistics.aplcStats.count", dbparam); // 신규신청 일계 월계 누계
				mav.addObject("card", card);
				mav.addObject("aplc", aplc);
				mav.addObject("edu", edu);
				mav.addObject("tbl", tbl);
				mav.addObject("stu", stu);
				mav.addObject("count", count);
				mav.addObject("fromDate", param.getString("fromDate"));
				mav.addObject("toDate", param.getString("toDate"));
			}

			String fileName = "aplcList_(" + DateUtil.getCurrentDate("yyyyMMdd") + ").xls";
			// Excel response
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
			response.setHeader("Content-Description", "JSP Generated Data");
			mav.setViewName("reader/billingAdmin/aplcListExcel");
			return mav;

		} catch (Exception e) {
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
		try {

			dbparam.put("fromDate", StringUtil.replace(param.getString("fromDate"), "-", ""));
			dbparam.put("toDate", StringUtil.replace(param.getString("toDate"), "-", ""));
			dbparam.put("status", param.getString("status"));

			List excel = generalDAO.queryForList("reader.billingAdmin.saveExcel", dbparam);

			// String fileName = "billingList_(" +
			// DateUtil.getCurrentDate("yyyyMMdd") + ").xls";
			String fileName = "일반자동이체독자리스트("+ StringUtil.replace(param.getString("fromDate"), "-", "") + "~" + StringUtil.replace(param.getString("toDate"), "-", "")	+ ").xls";

			// Excel response
			response.setHeader("Content-Disposition", "attachment; filename="+ fileName);
			response.setHeader("Content-Description", "JSP Generated Data");

			mav.addObject("excel", excel);
			mav.addObject("fromDate", param.getString("fromDate"));
			mav.addObject("toDate", param.getString("toDate"));
			mav.setViewName("reader/billingAdmin/billingListExcel");
			return mav;

		} catch (Exception e) {
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}

	/**
	 * 예약해지독자리스트
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView stopReserveList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();

		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		Param param = new HttpServletParam(request);

		// 현재날짜
		Calendar rightNow = Calendar.getInstance();

		String year = String.valueOf(rightNow.get(Calendar.YEAR));
		String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));

		if (month.length() < 2) {
			month = "0" + month;
		}
		if (day.length() < 2) {
			day = "0" + day;
		}
		
		//String toDay = year + "-" + month + "-" + day;
		//매달 1일
		String monthFirstDay = year + "-" + month + "-01";
		//매달 말일
		String monthLastDay = year + "-" + month + "-"+rightNow.getActualMaximum(Calendar.DATE);

		int pageNo = param.getInt("pageNo", 1);
		int pageSize = 20;
		int totalCount = 0;
		String fromDate = param.getString("fromDate", monthFirstDay);
		String toDate = param.getString("toDate", monthLastDay);
		String cancelYn = param.getString("cancelYn", "N");
		String opReadnm = param.getString("opReadnm");
		String opCounselor = param.getString("opCounselor", "");
		
		dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
		dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
		dbparam.put("fromDate", fromDate);
		dbparam.put("toDate", toDate);
		dbparam.put("cancelYn",cancelYn);
		dbparam.put("opReadnm", opReadnm);
		dbparam.put("opCounselor", opCounselor);

		try {
			List stopReserveList = generalDAO.queryForList("reader.billingAdmin.selectStopReserveList", dbparam);// 예약해지독자 리스트
			totalCount = generalDAO.count("reader.billingAdmin.selectStopReserveListCount", dbparam);// 예약해지독자 카운트
			
			List counselorList = generalDAO.queryForList("common.getCounselorList", dbparam);//상담원리스트

			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 20));
			mav.addObject("stopReserveList", stopReserveList);
			mav.addObject("counselorList", counselorList);
			mav.addObject("fromDate", fromDate);
			mav.addObject("toDate", toDate);
			mav.addObject("cancelYn",cancelYn);
			mav.addObject("opReadnm",opReadnm);
			mav.addObject("opCounselor",opCounselor);
			mav.setViewName("reader/billingAdmin/stopReserveList");
			return mav;
		} catch (Exception e) {
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		} finally {
		}
	}
	
	
	/**
	 * 예약해지독자리스트
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView stopReserveCancel(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		Param param = new HttpServletParam(request);
		HttpSession session = request.getSession();
		
		String numId = param.getString("numId");
		
		try {
			dbparam.put("loginId", session.getAttribute(SESSION_NAME_ADMIN_USERID));
			dbparam.put("numId", numId);
			
			//예약해지 취소
			generalDAO.update("reader.billingAdmin.stopReserveCancel", dbparam);
			
			mav.setViewName("common/message");
			mav.addObject("message", "처리 되었습니다.");
			mav.addObject("returnURL", "/reader/billingAdmin/stopReserveList.do");
			return mav;
		} catch (Exception e) {
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
	public ModelAndView stopReserveAccept(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		String readerType = param.getString("readerType");
		String fromDate = param.getString("fromDate");
		String toDate = param.getString("toDate");
		String opReadnm = param.getString("opReadnm");
		String opCounselor = param.getString("opCounselor");
		String cancelYn = param.getString("cancelYn");
		//System.out.println("readerType = "+readerType);
		
		try {
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);

			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			dbparam.put("chgps", session.getAttribute(SESSION_NAME_ADMIN_USERID));
			dbparam.put("agency_serial", session.getAttribute(SESSION_NAME_ADMIN_USERID));
			dbparam.put("numId", param.getString("numId"));
			dbparam.put("readNo", param.getString("readNo"));
			dbparam.put("sgType", "012");

			/*
			 * 자동이체 해지를 하면 구독정보 히스토리 업데이트 후 구독정보 해지
			 */
			List reader = generalDAO.queryForList("reader.readerManage.getReader", dbparam);
			for (int i = 0; i < reader.size(); i++) {
				Map list = (Map) reader.get(i);
				dbparam.put("newsCd", list.get("NEWSCD"));
				dbparam.put("seq", list.get("SEQ"));
				generalDAO.insert("reader.readerManage.insertreaderHist", dbparam);
			}

			generalDAO.update("reader.readerManage.closeNews", dbparam);// 구독 해지
			
			//자동이체테이블 해지처리
			if("일반".equals(readerType)) {
				generalDAO.update("reader.billingAdmin.removePayment", dbparam);
			} else if("학생".equals(readerType)) {
				generalDAO.update("reader.billingStuAdmin.removePayment", dbparam);
			}
			
			generalDAO.update("reader.billingAdmin.stopReserveDelete", dbparam);// 예약해지 정상해지처리
			 
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			mav.setViewName("common/message");
			mav.addObject("message", "처리 되었습니다.");
			mav.addObject("returnURL", "/reader/billingAdmin/stopReserveList.do?fromDate="+fromDate+"&toDate="+toDate+"&opReadnm="+opReadnm+"&cancelYn="+cancelYn+"&opCounselor="+opCounselor);
			return mav;

		} catch (Exception e) {
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
	
	
	
	/**
	 * 신규 독자 일보 프린트
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView ozAplcList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();

		try{
			// 구역
			String fromDate = param.getString("fromDate").replace("-", "");
			String toDate = param.getString("toDate").replace("-", "");
		
			
			mav.addObject("fromDate", fromDate); 
			mav.addObject("toDate", toDate);
			mav.addObject("year", fromDate.substring(0, 4)); 
			mav.addObject("month", fromDate.substring(4, 6));
			
			mav.setViewName("reader/billingAdmin/ozAplcList");
			return mav;
			
		}catch(Exception e){
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}

}
