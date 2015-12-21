/*------------------------------------------------------------------------------
 * NAME : CardController 
 * DESC : 카드독자관리
 * Author : ycpark
 *----------------------------------------------------------------------------*/
package com.mkreader.web.reader;

import java.io.File;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import jxl.Cell;
import jxl.DateCell;
import jxl.Sheet;
import jxl.Workbook;
import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.servlet.util.MultipartHttpServletParam;
import kr.reflexion.espresso.util.Param;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;
import org.springframework.web.servlet.view.RedirectView;

import payletter.security.PLParamV2;
import payletter.security.PLPayComV2;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.ConnectionUtil;
import com.mkreader.util.DateUtil;
import com.mkreader.util.FileUtil;
import com.mkreader.util.Paging;
import com.mkreader.util.StringUtil;

// 카드독자 관리 패키지
public class CardController extends MultiActionController implements
ISiteConstant, ICodeConstant {

	private GeneralDAO generalDAO;
	
	private static String[] noModifyDays = {"19","20"}; //카드출금일 2일전부터는 카드수정 및 지국 수정 금지
	private static String[] noJikukChangeDays = {"20","21","22"}; //카드 수금처리전 지국 수정 금지

	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}
	
	/**
	 * 카드출금일 2일전부터는 카드수정 및 지국 수정 금지
	 * @return
	 */
	public static String chkModifyDays() {
		//날짜계산
		Calendar cal = Calendar.getInstance();
		//오늘날짜 구하기
		int thisMonth = cal.get(Calendar.MONTH)+1;
		int toDay = cal.get(Calendar.DAY_OF_MONTH);
		String strToDay = Integer.toString(toDay);
		//현재시간 구하기
		int nowHour = cal.get(Calendar.HOUR_OF_DAY);
		//그달의 마지막날
		int lastOfDate = cal.getActualMaximum(Calendar.DATE);
		//주를  구함 1일요일 ,2월요일,3화요일,4수요일,5목요일,6금요일,7토요일
		int week = cal.get(Calendar.DAY_OF_WEEK);
		
		String chkModifyYN = "Y"; 
		
		//카드출금일 2일전인지 체크
		for(int m=0;m<noModifyDays.length;m++) {
			if(strToDay.equals(noModifyDays[m])) {
				if(noModifyDays[m].equals("20")) { //20일은 출금당일이라 2시 이후에는 카드 수정이 가능해야함
					if(nowHour<14) {	//오후2시 전에는 불가능
						chkModifyYN = "N";
						break;
					} else {
						chkModifyYN = "Y";
					}
				} else {
					chkModifyYN = "N";
					break;
				}
			} else {
				chkModifyYN = "Y";
			}
		}
		return chkModifyYN;
	}
	
	/**
	 * 카드 수금처리전인지 체크
	 * @return
	 */
	public static String chkCardSugmCofirmYn() {
		//날짜계산
		Calendar cal = Calendar.getInstance();
		//오늘날짜 구하기
		int thisMonth = cal.get(Calendar.MONTH)+1;
		int toDay = cal.get(Calendar.DAY_OF_MONTH);
		String strToDay = Integer.toString(toDay);
		//현재시간 구하기
		int nowHour = cal.get(Calendar.HOUR_OF_DAY);
		//그달의 마지막날
		int lastOfDate = cal.getActualMaximum(Calendar.DATE);
		//주를  구함 1일요일 ,2월요일,3화요일,4수요일,5목요일,6금요일,7토요일
		int week = cal.get(Calendar.DAY_OF_WEEK);
		
		String chkJikukChgYN = "Y";
		
		System.out.println("strToDay ===================================>"+strToDay);
		
		//카드 수금처리전인지 체크
		for(int j=0;j<noJikukChangeDays.length;j++) {
			if(strToDay.equals(noJikukChangeDays[j])) {
				chkJikukChgYN = "N"; 
				break;
			} 
		}
		return chkJikukChgYN;
	}

	/**
	 * 카드독자 리스트
	 * 
	 * @param request
	 * @param response
	 * @category 카드독자리스트조회
	 * @author ycpark
	 * @return
	 * @throws Exception
	 */
	public ModelAndView cardReaderList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		String opStatus = param.getString("status", "1");
		String flag = param.getString("flag", "");
		String search_type = param.getString("search_type");
		String search_key = param.getString("search_key");

		try{
			HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 15;
			int totalCount = 0;
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);

			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));

			if("A".equals(loginType)){
				dbparam.put("realJikuk" , param.getString("realJikuk"));
				mav.addObject("realJikuk", param.getString("realJikuk"));
			}else{
				dbparam.put("realJikuk", (String)session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
				mav.addObject("realJikuk", (String)session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			}
			
			dbparam.put("search_type" , search_type);
			dbparam.put("search_key" , search_key);
			dbparam.put("status" , opStatus);
			dbparam.put("flag" , flag);
			
			totalCount = generalDAO.count("reader.card.cardReaderListCount", dbparam);// 카드독자 리스트 카운트
			List cardReaderList = generalDAO.queryForList("reader.card.cardReaderList", dbparam);// 카드독자 리스트 조회
			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" , dbparam);// 지국 목록
			
			//카드출금일 2일전인지 체크
			String chkModifyYN = chkModifyDays();
			
			//카드 수금처리전인지 체크
			String chkJikukChgYN = chkCardSugmCofirmYn();
			
//			System.out.println("chkModifyYN = "+chkModifyYN);
//			System.out.println("chkJikukChgYN = "+chkJikukChgYN);
			
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 20));
			mav.addObject("cardReaderList" , cardReaderList);
			mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("search_type", search_type);
			mav.addObject("search_key", search_key);
			mav.addObject("status", opStatus);
			mav.addObject("flag", flag);
			mav.addObject("loginType" , loginType);			
			mav.addObject("chkModifyYN" , chkModifyYN);
			mav.addObject("chkJikukChgYN" , chkJikukChgYN);
			mav.addObject("now_menu", MENU_CODE_READER_CARD);
			mav.setViewName("reader/card/cardReaderList");
			
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
	 * 카드독자 등록 페이지 오픈
	 * 
	 * @param request
	 * @param response
	 * @category 카드독자 등록 페이지 오픈
	 * @author ycpark
	 * @return
	 * @throws Exception
	 */
	public ModelAndView cardReaderEdit(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		
		//조회값
		dbparam.put("realJikuk", param.getString("realJikuk"));
		dbparam.put("fromDate", param.getString("fromDate"));
		dbparam.put("toDate", param.getString("toDate"));
		dbparam.put("search_type", param.getString("search_type"));
		dbparam.put("search_key", param.getString("search_key"));
		dbparam.put("status", param.getString("status"));
		
		try{
			List agencyAllList = generalDAO.queryForList("reader.common.agencyListByAlive" );// 지국 목록
			List areaCode = generalDAO.queryForList("reader.common.retrieveAreaCode" );// 전화번호 지역번호 조회
			List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" );// 핸도폰 앞자리 번호 조회
			List intfldcdList = generalDAO.queryForList("reader.card.retrieveIntfldCode" );// 관심분야 코드 조회

			dbparam.put("cardSeq", param.getString("cardSeq"));
			dbparam.put("readNo", param.getString("readNo"));
			List cardReaderInfo	= generalDAO.queryForList("reader.card.retrieveCardReaderInfo", dbparam);// 독자 정보 조회
			
			//메모리스트 조회
			dbparam.put("READNO", param.getString("readNo"));
			List memoList  = generalDAO.queryForList("util.memo.getMemoListByReadno" , dbparam);
			
			//카드출금일 2일전인지 체크
			String chkModifyYN = chkModifyDays();
			
			//카드 수금처리전인지 체크
			String chkJikukChgYN = chkCardSugmCofirmYn();
			
			System.out.println("chkModifyYN = "+chkModifyYN);
			System.out.println("chkJikukChgYN = "+chkJikukChgYN);
			
			mav.addObject("cardReaderInfo" , cardReaderInfo);
			mav.addObject("intfldcdList" , intfldcdList);
			mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("areaCode" , areaCode);
			mav.addObject("mobileCode" , mobileCode);
			mav.addObject("memoList" , memoList);
			mav.addObject("chkModifyYN" , chkModifyYN);
			mav.addObject("chkJikukChgYN" , chkJikukChgYN);
			mav.addObject("now_menu", MENU_CODE_READER_CARD);
			
			//조회값
			mav.addObject("realJikuk", param.getString("realJikuk"));
			mav.addObject("fromDate", param.getString("fromDate"));
			mav.addObject("toDate", param.getString("toDate"));
			mav.addObject("search_type", param.getString("search_type"));
			mav.addObject("search_key", param.getString("search_key"));
			//mav.addObject("status", param.getString("status"));
			
			mav.setViewName("reader/card/cardReaderEdit");
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
	 * 카드독자 정보 저장
	 * 
	 * @param request
	 * @param response
	 * @category 카드독자 정보 저장
	 * @author ycpark
	 * @return
	 * @throws Exception
	 */
	public ModelAndView saveCardReader(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			HashMap<Object, Object> dbparam = new HashMap<Object, Object>();

			// 카드 독자정보 저장
			dbparam.put("gubun", param.getString("gubun"));
			dbparam.put("cardSeq", param.getString("cardSeq"));
			dbparam.put("readNo", param.getString("readno"));
			dbparam.put("readNm", param.getString("readnm"));
			dbparam.put("phone1", param.getString("phone1"));
			dbparam.put("phone2", param.getString("phone2"));
			dbparam.put("phone3", param.getString("phone3"));
			dbparam.put("handy1", param.getString("handy1"));
			dbparam.put("handy2", param.getString("handy2"));
			dbparam.put("handy3", param.getString("handy3"));
			dbparam.put("zip", param.getString("zip"));
			
			dbparam.put("newaddr", param.getString("newaddr"));
			dbparam.put("bdMngNo", param.getString("bdMngNo"));

			dbparam.put("addr1", param.getString("addr1"));
			dbparam.put("addr2", param.getString("addr2"));
			dbparam.put("boseq", param.getString("boseq"));
			dbparam.put("qty", param.getString("qty"));
			dbparam.put("uprice", param.getString("uprice"));
			dbparam.put("email", param.getString("email"));
			dbparam.put("intfldcd", param.getString("intfldcd"));
			dbparam.put("remk", param.getString("remk"));
			dbparam.put("userId", param.getString("userId"));
			if("on".equals(param.getString("newYn"))){
				dbparam.put("newYn" , "Y");	
			}else{
				dbparam.put("newYn" , "N");
			}

			dbparam.put("loginId", (String)session.getAttribute(SESSION_NAME_ADMIN_USERID));

			// 1.1. 지국통보일자가 있는 경우 -> 수정 건
			if(!param.getString("ntdt").isEmpty()){
				List rederInfo = generalDAO.getSqlMapClient().queryForList("reader.card.getReaderInfo" , dbparam);// 고객 정보 조회(독자 번호)
				// 1.1.1 독자번호 확인 -> 독자번호가 있는 경우
				if(!rederInfo.isEmpty()){
					// 1.1.1.1. 이전 지국번호와 현재지국번호가 다른 경우 -> 지국이전 건
					if(!param.getString("boseq").equals(param.getString("oldBoseq"))){
						// 1.1.1.1.1. 독자정보 테이블 히스토리 업데이트
						Map temp = (Map)rederInfo.get(0);
						dbparam.put("seq", (String)temp.get("SEQ"));
						dbparam.put("newsCd", (String)temp.get("NEWSCD"));
						dbparam.put("readTypeCd", (String)temp.get("READTYPECD"));
						dbparam.put("sgType", (String)temp.get("SGTYPE"));
						dbparam.put("hjPathCd", (String)temp.get("HJPATHCD"));

						generalDAO.getSqlMapClient().insert("reader.card.insertReaderHist", dbparam); //구독정보히스토리 업데이트
						// 1.1.1.1.2. 독자정보 해지처리
						dbparam.put("stSayou", "008");	// 해지사유 : 전출
						generalDAO.getSqlMapClient().update("reader.card.closeNews", dbparam);
						
						// 1.1.1.1.3. 독자테이블 생성
						dbparam.put("readNo", (String)generalDAO.getSqlMapClient().queryForObject("reader.readerManage.getReadNo" , dbparam));
						generalDAO.getSqlMapClient().insert("reader.card.insertTmReader", dbparam);
						
						// 1.1.1.1.4. 독자정보 테이블 생성
						dbparam.put("hjPathCd", "009");	// 확장경로 : 전입
						dbparam.put("gno", "600");
						dbparam.put("hjDt" , DateUtil.getCurrentDate("yyyyMMdd"));
						dbparam.put("aplcDt" , DateUtil.getCurrentDate("yyyyMMdd"));
						dbparam.put("sgBgmm" , param.getString("sgBgmm"));
						generalDAO.getSqlMapClient().insert("reader.card.insertTmReaderNews", dbparam);
						
						// 1.1.1.1.5. 카드독자 정보 중지처리
						dbparam.put("status", "4");
						dbparam.put("oldReadNo", param.getString("oldReadNo"));
						dbparam.put("stDt", DateUtil.getCurrentDate("yyyyMMdd"));
						generalDAO.getSqlMapClient().update("reader.card.closeCardReader",  dbparam);

						// 1.1.1.1.6 카드독자 신규 입력
						dbparam.put("status", "1");
						dbparam.put("aplcDt" , param.getString("aplcDt"));
						dbparam.put("ntDt", DateUtil.getCurrentDate("yyyyMMdd"));
						generalDAO.getSqlMapClient().insert("reader.card.insertCardReader",  dbparam);
						
					// 1.1.1.2. 이전 지국번호와 현재지국번호가 같은 경우 -> 정보수정 건
					}else{
						dbparam.put("status", "1");
						// 1.1.1.2.1. 카드독자정보 테이블 수정처리
						generalDAO.getSqlMapClient().update("reader.card.updateCardReader",  dbparam);

					}
				// 1.1.2. 독자번호가 없는 경우 -> 에러처리
				}else{
					mav.setViewName("common/message");
					//mav.addObject("now_menu", MENU_CODE_READER_CARD);
					mav.addObject("message", "해당 독자번호가 없습니다.");
					mav.addObject("returnURL", "/reader/card/cardReaderEdit.do?cardSeq="+param.getString("cardSeq"));
					return mav;
				}

			// 1.2. 지국통보일자가 없는 경우 -> 입력 건
			}else{

				// 1.2.1. 신청 구분이 '기존'인 경우
				if("기존".equals(param.getString("gubun"))){
					List rederInfo = generalDAO.getSqlMapClient().queryForList("reader.card.getReaderInfo" , dbparam);// 고객 정보 조회(독자 번호)
					// 1.2.1.1 독자번호 확인 -> 독자번호가 있는 경우
					if(!rederInfo.isEmpty()){
						// 1.2.1.1.1 독자정보 히스토리 입력 및 독자정보 테이블 수금방법 수정
						Map temp = (Map)rederInfo.get(0);
						dbparam.put("seq", (String)temp.get("SEQ"));
						dbparam.put("newsCd", (String)temp.get("NEWSCD"));
		
						// 수금방법이 자동이체인 경우 자동이체 해지신청 처리 학생은 - 일반으로 변경됨(박윤철 2013.09.05)
						String sgType = (String)temp.get("SGTYPE");
						String readTypeCd = (String)temp.get("READTYPECD");
						if("021".equals(sgType)){
							// 본사학생인경우 학생세팅, 학생자동이체 해지신청 처리
							if("013".equals(readTypeCd)){
								dbparam.put("stuYn", "Y");
								generalDAO.getSqlMapClient().update("reader.card.closeTblUsersStu",  dbparam);
							// 지국학생인 경우 학생 세팅, 일반 자동이체 해지신청 처리
							}else if("012".equals(readTypeCd)){
								dbparam.put("stuYn", "Y");
								generalDAO.getSqlMapClient().update("reader.card.closeTblUsers",  dbparam);																
							// 일반 자동이체인 경우 일반 자동이체만 해지신청 처리
							}else{
								generalDAO.getSqlMapClient().update("reader.card.closeTblUsers",  dbparam);								
							}
						}
					
						generalDAO.getSqlMapClient().insert("reader.card.insertReaderHist", dbparam);
						generalDAO.getSqlMapClient().update("reader.card.updateReaderNews",  dbparam);

						// 1.2.1.1.3 독자수금정보 히스토리 입력 및 독자수금 테이블 미수 수정
						generalDAO.getSqlMapClient().insert("reader.card.insertReaderSugmHist", dbparam);
						generalDAO.getSqlMapClient().update("reader.card.updateReaderSugm",  dbparam);
						// 1.2.1.1.3 카드독자정보 테이블 상태 수정(정상 처리)
						dbparam.put("status", "1");
						generalDAO.getSqlMapClient().update("reader.card.updateCardReadNo",  dbparam);

					// 1.2.1.2 독자번호가 없는 경우 에러처리
					}else{
						mav.setViewName("common/message");
						//mav.addObject("now_menu", MENU_CODE_READER_CARD);
						mav.addObject("message", "해당 독자번호가 없습니다.");
						mav.addObject("returnURL", "/reader/card/cardReaderEdit.do?cardSeq="+param.getString("cardSeq"));
						return mav;
					}
				// 1.2.2. 신청 구분이 '신규'인 경우
				}else{
					// 1.2.2.1. 지국통보 확인 -> 통보 후 이면 독자 입력
					if(!param.getString("noticeYn").isEmpty()){
						// 1.2.2.1.1 독자테이블 입력
						dbparam.put("readNo" , generalDAO.getSqlMapClient().queryForObject("reader.readerManage.getReadNo" , dbparam) );
						
						generalDAO.getSqlMapClient().insert("reader.card.insertTmReader", dbparam);
						// 1.2.2.1.2 독자정보 테이블 입력
						dbparam.put("newsCd", "100");
						dbparam.put("gno", "600");
						dbparam.put("readTypeCd", "011");
						dbparam.put("sgType", "022");
						dbparam.put("hjPathCd", "003");
						generalDAO.getSqlMapClient().update("reader.card.insertTmReaderNews",  dbparam);
						// 1.2.2.1.3 카드독자정보 테이블 상태 수정(정상 처리)
						dbparam.put("status", "1");
						dbparam.put("gubun", param.getString("gubun"));
						System.out.println("dbparam>>>>>>>"+dbparam);
						generalDAO.getSqlMapClient().update("reader.card.updateCardReadNo",  dbparam);

					// 1.2.2.2. 통보가 되지 않았으면 에러처리
					}else{
						mav.setViewName("common/message");
						//mav.addObject("now_menu", MENU_CODE_READER_CARD);
						mav.addObject("message", "지국 통보 확인 선택 후 저장 해 주시기 바랍니다.");
						mav.addObject("returnURL", "/reader/card/cardReaderEdit.do?cardSeq="+param.getString("cardSeq"));
						return mav;
					}
				}
			}

			generalDAO.getSqlMapClient().getCurrentConnection().commit();

			mav.setViewName("common/message");
			//mav.addObject("now_menu", MENU_CODE_READER_CARD);
			mav.addObject("message", "저장이 완료 되었습니다.");
			mav.addObject("returnURL", "/reader/card/cardReaderEdit.do?cardSeq="+param.getString("cardSeq"));
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
	 * 카드독자 정보 수정
	 * 
	 * @param request
	 * @param response
	 * @category 카드독자 정보 저장
	 * @author ycpark
	 * @return
	 * @throws Exception
	 */
	public ModelAndView updateCardReaderData(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
			
			String noticeYnVal = param.getString("noticeYnVal");	  	//지국통보여부체크
			String oldNtdt = param.getString("oldNtdt");				//지국통보일
			
			if("".equals(oldNtdt)) {
				oldNtdt = "0";
			} else {
				oldNtdt = "1";
			}
			
			System.out.println("oldNtdt = '"+oldNtdt+"'");
			
			// 카드 독자정보 저장
			dbparam.put("gubun", param.getString("gubun"));
			dbparam.put("cardSeq", param.getString("cardSeq"));
			dbparam.put("readNo", param.getString("readno"));
			dbparam.put("readNm", param.getString("readnm"));
			dbparam.put("telNo1", param.getString("telNo1"));
			dbparam.put("telNo2", param.getString("telNo2"));
			dbparam.put("telNo3", param.getString("telNo3"));
			dbparam.put("handy1", param.getString("handy1"));
			dbparam.put("handy2", param.getString("handy2"));
			dbparam.put("handy3", param.getString("handy3"));
			dbparam.put("zip", param.getString("zip"));
			
			dbparam.put("newaddr", param.getString("newaddr"));
			dbparam.put("bdMngNo", param.getString("bdMngNo"));

			dbparam.put("addr1", param.getString("addr1"));
			dbparam.put("addr2", param.getString("addr2"));
			dbparam.put("boseq", param.getString("boseq"));
			dbparam.put("qty", param.getString("qty"));
			dbparam.put("uprice", param.getString("uprice"));
			dbparam.put("email", param.getString("email"));
			dbparam.put("intfldcd", param.getString("intfldcd"));
			dbparam.put("remk", param.getString("remk"));
			dbparam.put("userId", param.getString("userId"));
			
			if("on".equals(param.getString("newYn"))){
				dbparam.put("newYn" , "Y");	
			}else{
				dbparam.put("newYn" , "N");
			}
			
			dbparam.put("homeTel1", param.getString("telNo1"));
			dbparam.put("homeTel2", param.getString("telNo2"));
			dbparam.put("homeTel3", param.getString("telNo3"));
			dbparam.put("mobile1", param.getString("handy1"));
			dbparam.put("mobile2", param.getString("handy2"));
			dbparam.put("mobile3", param.getString("handy3"));
			
			dbparam.put("noticeYnVal", noticeYnVal);
			dbparam.put("oldNtdt", oldNtdt);
			
			dbparam.put("loginId", (String)session.getAttribute(SESSION_NAME_ADMIN_USERID));

			// 1.1. 지국통보일자가 있는 경우 -> 수정 건
			List rederInfo = generalDAO.getSqlMapClient().queryForList("reader.card.getReaderInfo" , dbparam);// 고객 정보 조회(독자 번호)
			
			// 1.1.1.1. 이전 지국번호와 현재지국번호가 다른 경우 -> 지국이전 건
			if(!param.getString("boseq").equals(param.getString("oldBoseq"))){
				if(rederInfo.size() > 0) {
					// 1.1.1.1.1. 독자정보 테이블 히스토리 업데이트
					Map temp = (Map)rederInfo.get(0);
					dbparam.put("seq", (String)temp.get("SEQ"));
					dbparam.put("newsCd", (String)temp.get("NEWSCD"));
					dbparam.put("readTypeCd", (String)temp.get("READTYPECD"));
					dbparam.put("sgType", (String)temp.get("SGTYPE"));
					dbparam.put("hjPathCd", (String)temp.get("HJPATHCD"));
	
					generalDAO.getSqlMapClient().insert("reader.card.insertReaderHist", dbparam); //구독정보히스토리 업데이트
					// 1.1.1.1.2. 독자정보 해지처리
					dbparam.put("stSayou", "008");	// 해지사유 : 전출
					generalDAO.getSqlMapClient().update("reader.card.closeNews", dbparam);
					
					// 1.1.1.1.3. 독자테이블 생성
					dbparam.put("readNo", (String)generalDAO.getSqlMapClient().queryForObject("reader.readerManage.getReadNo" , dbparam));
					generalDAO.getSqlMapClient().insert("reader.card.insertTmReader", dbparam);
					
					// 1.1.1.1.4. 독자정보 테이블 생성
					dbparam.put("hjPathCd", "009");	// 확장경로 : 전입
					dbparam.put("gno", "600");
					dbparam.put("hjDt" , DateUtil.getCurrentDate("yyyyMMdd"));
					dbparam.put("aplcDt" , DateUtil.getCurrentDate("yyyyMMdd"));
					dbparam.put("sgBgmm" , param.getString("sgBgmm"));
					generalDAO.getSqlMapClient().insert("reader.card.insertTmReaderNews", dbparam);
					
					// 1.1.1.1.5. 카드독자 정보 중지처리
					dbparam.put("status", "4");
					dbparam.put("oldReadNo", param.getString("oldReadNo"));
					dbparam.put("stDt", DateUtil.getCurrentDate("yyyyMMdd"));
					generalDAO.getSqlMapClient().update("reader.card.closeCardReader",  dbparam);
	
					// 1.1.1.1.6 카드독자 신규 입력
					dbparam.put("status", "1");
					dbparam.put("aplcDt" , param.getString("aplcDt"));
					dbparam.put("ntDt", DateUtil.getCurrentDate("yyyyMMdd"));
					//generalDAO.getSqlMapClient().insert("reader.card.insertCardReader",  dbparam);
					generalDAO.getSqlMapClient().insert("reader.card.insertCardAplcReader",  dbparam);
					mav.addObject("message", "저장이 완료 되었습니다.");
				} else {
					mav.addObject("message", "독자가 중지되어 있는 독자입니다. 확인해주십시오.");
				}
				// 1.1.1.2. 이전 지국번호와 현재지국번호가 같은 경우 -> 정보수정 건
			}else{
					//dbparam.put("status", "1");
					// 1.1.1.2.1. 카드독자정보 테이블 수정처리
					generalDAO.getSqlMapClient().update("reader.card.updateCardReader",  dbparam);
					//독자테이블정보수정
					/*
					dbparam.put("dlvZip", param.getString("zip"));
					dbparam.put("newaddr", param.getString("newaddr"));
					dbparam.put("bdMngNo", param.getString("bdMngNo"));
					dbparam.put("dlvAdrs1", param.getString("addr1"));
					dbparam.put("dlvAdrs2", param.getString("addr2"));
					dbparam.put("sgType", "022");
					dbparam.put("uPrice", param.getString("uprice"));
					generalDAO.getSqlMapClient().update("reader.readerManage.updateReaderJusoTelData",  dbparam);
					mav.addObject("message", "저장이 완료 되었습니다.");
				 */
			}
			// 메모등록
			if (!("").equals(param.getString("remk"))) { // null이 아닐때만 메모생성
				dbparam.put("READNO", param.getString("readno"));
				dbparam.put("MEMO", param.getString("remk"));
				dbparam.put("CREATEID", (String) session.getAttribute(SESSION_NAME_ADMIN_USERID));

				generalDAO.getSqlMapClient().insert("util.memo.insertMemo", dbparam); // 메모생성
			}	
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/reader/card/cardReaderEdit.do?cardSeq="+param.getString("cardSeq")+"&readNo="+param.getString("readno"));
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
	 * 카드독자 중지 처리
	 * 
	 * @param request
	 * @param response
	 * @category 카드 독자 중지 처리
	 * @author ycpark
	 * @return
	 * @throws Exception
	 */
	public ModelAndView stopCardReader(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		Param param = new HttpServletParam(request);
		
		String opStatus = param.getString("status", "1");
		String search_type = param.getString("search_type");
		String search_key = param.getString("search_key");
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			HashMap<Object, Object> dbparam = new HashMap<Object, Object>();

			// 카드 독자정보 저장
			String stopType = param.getString("stopType");
			dbparam.put("aplcDt", param.getString("aplcDt"));
			dbparam.put("cardSeq", param.getString("cardSeq"));
			dbparam.put("readNo", param.getString("readNo"));
			dbparam.put("userId", param.getString("userId"));
			dbparam.put("loginId", (String)session.getAttribute(SESSION_NAME_ADMIN_USERID));
			
			List cardReaderListForStop = generalDAO.getSqlMapClient().queryForList("reader.card.retrieveCardReader", dbparam); // 고객 정보 조회
			// 등록 여부 및 상태 확인
			if(!cardReaderListForStop.isEmpty()){

				// 독자중지인지 결제 중지인지 확인
				if("reader".equals(stopType)){
					// 독자번호로 대상 독자 확인
					List rederInfo = generalDAO.getSqlMapClient().queryForList("reader.card.retrieveReaderInfo" , dbparam);// 고객 정보 조회(독자 번호)
					// 독자번호 확인 -> 독자번호가 있는 경우
					if(!rederInfo.isEmpty()){
						Map temp = (Map)rederInfo.get(0);
						dbparam.put("seq", (String)temp.get("SEQ"));
						dbparam.put("newsCd", (String)temp.get("NEWSCD"));
						String status = (String)temp.get("BNO");
						if( !"999".equals(status) ){
							// 독자 중지 처리
							generalDAO.getSqlMapClient().insert("reader.card.insertReaderHist", dbparam); //구독정보히스토리 업데이트
							generalDAO.getSqlMapClient().update("reader.card.closeNews", dbparam);	// 독자 중지처리
						}

						// 카드독자 정보 중지 처리
						dbparam.put("status", "4");
						generalDAO.getSqlMapClient().update("reader.card.stopCardReader", dbparam);
					// 해당 독자가 없는 경우
					}else{
						mav.setViewName("common/message");
						mav.addObject("now_menu", MENU_CODE_READER_CARD);
						mav.addObject("message", "해당 독자가 존재 하지 않습니다.");
						mav.addObject("returnURL", "/reader/card/cardReaderList.do");
						return mav;
					}
				}else{
					System.out.println("boseq===== "+param.getString("boseq"));
					dbparam.put("boseq", param.getString("boseq"));
					// 카드독자 정보 중지 처리
					generalDAO.getSqlMapClient().insert("reader.readerManage.insertreaderHistForStopCard", dbparam); //구독정보히스토리 업데이트
					generalDAO.getSqlMapClient().update("reader.readerManage.updateReaderSgTypeForTopCard", dbparam);	//수금방법 변경
					
					generalDAO.getSqlMapClient().insert("collection.collection.insertReaderSugmHistForStopCard", dbparam); //수금정보히스토리업데이트
					generalDAO.getSqlMapClient().update("collection.collection.updateReaderSugmForStopCard", dbparam); //수금정보 업데이트 
					
					dbparam.put("status", "4");
					generalDAO.getSqlMapClient().update("reader.card.stopCardReader", dbparam);
				}
				//카드신청테이블 상태 해지로 변환
				generalDAO.getSqlMapClient().update("reader.card.deleteTnewspaperUserData", dbparam);
				generalDAO.getSqlMapClient().update("reader.card.deleteTnewspaperHistUserData", dbparam);
				
			// 해당 카드 독자정보가 없는 경우
			}else{
				generalDAO.getSqlMapClient().getCurrentConnection().rollback();
				mav.setViewName("common/message");
				mav.addObject("now_menu", MENU_CODE_READER_CARD);
				mav.addObject("message", "해당 독자번호가 없습니다.");
				mav.addObject("returnURL", "/reader/card/cardReaderList.do");
				return mav;
			}
			
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
		    mav.setViewName("common/message");
			mav.addObject("message", "독자 중지 처리가 완료 되었습니다.");
			mav.addObject("returnURL", "/reader/card/cardReaderList.do");
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
	 * 카드독자 신청 파일 처리
	 * 
	 * @param request
	 * @param response
	 * @category 카드독자 신청 파일 처리
	 * @author ycpark
	 * @return
	 * @throws Exception
	 */
	public ModelAndView uploadCardReaderFile(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		System.out.println("uploadCardReaderFile start");
		
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		try{

			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);

			MultipartHttpServletParam param = new MultipartHttpServletParam(request);
			MultipartFile cardReaderfile = param.getMultipartFile("cardReaderfile");
			
			HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			String loginId = (String)session.getAttribute(SESSION_NAME_ADMIN_USERID);

			// 본사 권한 확인
			if("A".equals(loginType)){
				// 카드독자신청 파일 첨부 여부 확인
				if(cardReaderfile.isEmpty()){
					mav.setViewName("common/message");
					mav.addObject("message", "파일첨부가 되지 않았습니다.");
					mav.addObject("returnURL", "/reader/card/cardReaderList.do");
					return mav;
				}else{
					
					Calendar now = Calendar.getInstance();
					
					FileUtil fileUtil = new FileUtil( getServletContext() );
					String fileUploadPath = fileUtil.saveUploadFile(
											cardReaderfile, 
											PATH_PHYSICAL_HOME,
											PATH_DIR_CARD
										);
					
					if ( StringUtils.isEmpty(fileUploadPath) ) {
						mav.setViewName("common/message");
						mav.addObject("message", "파일 저장이 실패하였습니다. ");
						mav.addObject("returnURL", "/reader/card/cardReaderList.do");
						return mav;
						
					// 파일 처리 시작
					}else{
						String fileName = PATH_PHYSICAL_HOME+PATH_DIR_CARD+"/"+fileUploadPath;
						
						Workbook myWorkbook = Workbook.getWorkbook(new File(fileName)); // 파일을 읽어 와서...
					    Sheet mySheet = myWorkbook.getSheet(0);

				    	String userid = "";				// 사용자ID
				    	String readnm = "";				// 독자명
				    	String cardSeq = "";			// 카드식별번호
				    	String gubun = "";				// 신규,기존구분
				    	String boseq = "";				// 지국코드
				    	String zip = "";				// 우편번호
				    	
				    	/* 도로명 주소 추가 (20140207 박윤철) */
				    	String bdMngNo = "";			// 건물관리번호
				    	String roadAddr = "";			// 도로명주소
				    	
				    	String addr1 = "";				// 주소
				    	String addr2 = "";				// 상세주소
				    	String telno = "";				// 전화번호				    		
				    	String telno1 = "";				// 전화번호1
				    	String telno2 = "";				// 전화번호2
				    	String telno3 = "";				// 전화번호3
				    	String handy = "";				// 휴대폰번호
				    	String handy1 = "";				// 휴대폰번호1
				    	String handy2 = "";				// 휴대폰번호2
				    	String handy3 = "";				// 휴대폰번호3
				    	String email = "";				// 이메일
				    	String qty = "";				// 부수
				    	String intfld = "";			    // 관심분야
				    	Date aplcDt = null;				// 신청일
				    	Date stDt = null;				// 해지일
				    	String status = "";				// 신청상태
				    	String remk = "";				// 비고
					    
					    for(int no=1 ; no < mySheet.getRows() ; no++){
				    		// 셀별로 데이터 추출
				    		for(int i=0 ; i < mySheet.getColumns() ; i++){ 
					    		Cell myCell = mySheet.getCell(i, no);
					    		DateCell dateCell = null;
					    		if(i == 1){
					    			userid = myCell.getContents();
					    		}else if(i == 2){
					    			readnm = myCell.getContents();
					    		}else if(i == 3){
					    			cardSeq = myCell.getContents();
					    		}else if(i == 4){
					    			gubun = myCell.getContents();
					    		}else if(i == 5){
					    			boseq = myCell.getContents();
					    		}else if(i == 7){
					    			zip = myCell.getContents();
					    		}else if(i == 8){
					    			bdMngNo = myCell.getContents();
					    		}else if(i == 9){
					    			roadAddr = myCell.getContents();
					    		}else if(i == 10){
					    			addr1 = myCell.getContents();
					    		}else if(i == 11){
					    			addr2 = myCell.getContents();
					    		}else if(i == 12){
					    			telno = myCell.getContents();
					    		}else if(i == 13){
					    			handy = myCell.getContents();
					    		}else if(i == 14){
					    			email = myCell.getContents();
					    		}else if(i == 15){
					    			qty = myCell.getContents();
					    		}else if(i == 16){
					    			intfld = myCell.getContents();
					    		}else if(i == 17){
					    			dateCell = (DateCell)myCell ;
					    			aplcDt = dateCell.getDate();
		    						DateFormat df = new SimpleDateFormat("yyyyMMdd");
		    						String tempAplcDt =  df.format(aplcDt);
		    						dbparam.put("aplcDt", tempAplcDt);
					    		}else if(i == 18){
					    			if("Date".equals(myCell.getType().toString())){
					    				dateCell = (DateCell)myCell;
					    				stDt = dateCell.getDate();
			    						DateFormat df2 = new SimpleDateFormat("yyyyMMdd");
			    						String tempStDt =  df2.format(stDt);
			    						dbparam.put("stDt", tempStDt);
					    			}
					    		}else if(i == 19){
					    			status = myCell.getContents();
					    		}else if(i == 20){
					    			remk = myCell.getContents();
					    		}
					    	}
				    		System.out.println("============================>카드독자 정보");
				    		System.out.println("userid start = "+userid);
				    		System.out.println("readnm start = "+readnm);
				    		System.out.println("cardSeq start = "+cardSeq);
				    		System.out.println("gubun start = "+gubun);
				    		System.out.println("boseq start = "+boseq);
				    		System.out.println("zip start = "+zip);
				    		System.out.println("bdMngNo start = "+bdMngNo);
				    		System.out.println("roadAddr start = "+roadAddr);
				    		System.out.println("addr1 start = "+addr1);
				    		System.out.println("addr2 start = "+addr2);
				    		System.out.println("email start = "+email);
				    		System.out.println("qty start = "+qty);
				    		System.out.println("intfld start = "+intfld);
				    		System.out.println("status start = "+intfld);
				    		System.out.println("remk start = "+remk);
				    		System.out.println("loginId start = "+loginId);
				    		
					    	dbparam.put("userId", userid);
					    	dbparam.put("readNm", readnm);
					    	dbparam.put("cardSeq", cardSeq);
					    	dbparam.put("gubun", gubun);
					    	dbparam.put("boseq", boseq);
					    	dbparam.put("zip", zip);

					    	/* 도로명 주소 추가 (20140207 박윤철) */
					    	dbparam.put("bdMngNo", bdMngNo);
					    	dbparam.put("roadAddr", roadAddr);

					    	dbparam.put("addr1", addr1);
					    	dbparam.put("addr2", addr2);
					    	dbparam.put("email", email);
					    	dbparam.put("qty", qty);
					    	dbparam.put("intfld", intfld);
					    	dbparam.put("status", status);
					    	dbparam.put("remk", remk);
				    		dbparam.put("loginId", loginId);

					    	if(!telno.isEmpty()){
					    		if( "0".equals(telno.substring(0, 1)) ){
					    			String[] val = telno.split("-", 3);
					    			for( int i=0; i< val.length; i++){
					    				dbparam.put("telno"+(i+1), val[i] );					    				
					    			}
					    		}else{
					    			String val = "0"+telno ;
					    			if( !"01".equals(val.substring(0, 2)) ){
					    				if( val.length() == 9 ){
					    					dbparam.put("telno1", val.substring(0, 2));
						    				dbparam.put("telno2", val.substring(2, 5));
						    				dbparam.put("telno3", val.substring(5, 9));
					    				}else if( val.length() == 10 ){
					    					if( "02".equals(val.substring(0, 2)) ){
						    					dbparam.put("telno1", val.substring(0, 2));
							    				dbparam.put("telno2", val.substring(2, 6));
							    				dbparam.put("telno3", val.substring(6, 10));
					    						
					    					}else{
						    					dbparam.put("telno1", val.substring(0, 3));
							    				dbparam.put("telno2", val.substring(3, 6));
							    				dbparam.put("telno3", val.substring(6, 10));
					    					}
					    				}else if (val.length() == 11){
					    					dbparam.put("telno1", val.substring(0, 3));
						    				dbparam.put("telno2", val.substring(3, 7));
						    				dbparam.put("telno3", val.substring(7, 11));
					    				}
					    			}
					    		}
					    	}

					    	if(!handy.isEmpty()){
					    		if( "0".equals(handy.substring(0, 1)) ){
					    			String[] val = handy.split("-", 3);
					    			for( int i=0; i < val.length; i++){
					    				dbparam.put("handy"+(i+1), val[i] );
					    			}
					    		}else{
					    			String val = "0"+handy ;
				    				if( val.length() == 10 ){
				    					dbparam.put("handy1", val.substring(0, 3));
					    				dbparam.put("handy2", val.substring(3, 6));
					    				dbparam.put("handy3", val.substring(6, 10));
				    				}else if( val.length() == 11 ){
				    					dbparam.put("handy1", val.substring(0, 3));
					    				dbparam.put("handy2", val.substring(3, 7));
					    				dbparam.put("handy3", val.substring(7, 11));
					    			}
					    		}
					    	}
					    	
				    		// 추출 데이터 처리 시작
				    		// 1. 해지독자
				    		if( "해지".equals(status.substring(0,2)) ){
				    			System.out.println("----------------->해지");
				    			// 1.1. 기처리 확인 (해지)
				    			List cardReaderListForStop = generalDAO.getSqlMapClient().queryForList("reader.card.retrieveCardReaderForExcelUpload", dbparam);
				    			
			    				// 1.2.1 기존등록독자가 아닌경우 에러처리
			    				if(cardReaderListForStop.isEmpty()){
			    					System.out.println("에러 >> "+cardSeq+"번 카드독자 데이터 없음");
			    				// 1.2.1 기존등록독자인 경우 해지신청처리
			    				}else{
							    	Map temp = (Map)cardReaderListForStop.get(0);
							    	String tempStatus = (String)temp.get("STATUS");
							    	dbparam.put("readNo", (String)temp.get("READNO"));

							    	// 카드 독자 중지처리
							    	if("1".equals(tempStatus)){
//							    		// 독자번호로 대상 독자 확인
//										List rederInfo = generalDAO.getSqlMapClient().queryForList("reader.card.retrieveReaderInfo" , dbparam);// 고객 정보 조회(독자 번호)
//
//										// 독자번호 확인 -> 독자번호가 있는 경우
//										if(!rederInfo.isEmpty()){
//											Map temp2 = (Map)rederInfo.get(0);
//											dbparam.put("seq", (String)temp2.get("SEQ"));
//											dbparam.put("newsCd", (String)temp2.get("NEWSCD"));
//											String readerStatus = (String)temp2.get("BNO");
//											if( !"999".equals(status) ){
//												// 독자 중지 처리
//												generalDAO.getSqlMapClient().insert("reader.card.insertReaderHist", dbparam); //구독정보히스토리 업데이트
//												generalDAO.getSqlMapClient().update("reader.card.closeNews", dbparam);	// 독자 중지처리
//											}
//										// 해당 독자가 없는 경우
//										}else{
//											System.out.println("에러 >> "+cardSeq+"번 독자 데이터 없음");
//										}

										dbparam.put("status", "2");
										System.out.println("해지신청처리"+dbparam);
										generalDAO.getSqlMapClient().update("reader.card.closeCardReaderForExcel",  dbparam);
			    					}else{
			    						System.out.println("에러 >> "+cardSeq+"번 기처리 독자");
			    					}

			    				}
				    		// 해지처리 종료
				    		// 2. 신청독자
				    		}else if("정상".equals(status.substring(0,2))){
				    			System.out.println("----------------->정상인증");
			    				// 2.1 기처리 확인 (신청)
			    				List cardReaderListForAplc = generalDAO.getSqlMapClient().queryForList("reader.card.retrieveCardReader", dbparam);
			    				// 2.1.1. 등록독자가 없는경우 신청 처리
			    				if(cardReaderListForAplc.isEmpty()){
			    					
			    					// 기존 회원인 경우 독자번호 입력을 위해 신청처리
			    					if( "기존회원".equals(gubun)){
			    						dbparam.put("gubun", "기존");
			    						dbparam.put("status", "0");
			    						dbparam.put("readNo", null);
			    						generalDAO.getSqlMapClient().insert("reader.card.insertCardReader",  dbparam);

		    						// 신규 회원의 경우 정상처리
			    					}else if( "신규회원".equals(gubun)){
			    						dbparam.put("gubun", "신규");
			    						dbparam.put("status", "1");
			    						dbparam.put("newsCd", "100");
			    						dbparam.put("gno", "600");
			    						dbparam.put("hjPathCd", "003");
			    						dbparam.put("readTypeCd", "011");
			    						dbparam.put("sgType", "022");
			    						dbparam.put("rsdTypeCd", "099");
			    						dbparam.put("readNo" , generalDAO.getSqlMapClient().queryForObject("reader.readerManage.getReadNo" , dbparam) );
			    						//dbparam.put("newYn", "Y");
			    						
			    						System.out.println("upload File dbparam >>" + dbparam);
			    						
			    						
			    						generalDAO.getSqlMapClient().insert("reader.card.insertCardReaderFromFile",  dbparam);			    						
			    						// 독자테이블 입력
			    						generalDAO.getSqlMapClient().insert("reader.card.insertTmReader", dbparam);
			    						// 독자정보 테이블 입력
			    						generalDAO.getSqlMapClient().update("reader.card.insertTmReaderNewsFromFile",  dbparam);
			    						// 카드독자정보 테이블 상태 수정(정상 처리)
			    						generalDAO.getSqlMapClient().update("reader.card.completeCardReaderFromFile",  dbparam);

			    					}

			    				// 2.1.2. 기입력된 경우 에러처리
			    				}else{
			    					System.out.println("에러 >> "+cardSeq+"번 카드독자 데이터 있음");
			    				}
				    		} // 신청 처리 종료

				    	}	// 추출 데이터 처리 종료
				    	
					}	// 파일 처리 종료
					
				    generalDAO.getSqlMapClient().getCurrentConnection().commit();
				    mav.setViewName("common/message");
					mav.addObject("message", "카드독자 생성이 완료 되었습니다.");
					mav.addObject("returnURL", "/reader/card/cardReaderList.do");
					return mav;
				}

			}else{
				mav.setViewName("common/message");
				mav.addObject("message", MSG_LOGIN_NOT_AUTH_ADMIN);
				mav.setView(new RedirectView("/reader/card/cardReaderList.do"));
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
	 * 카드독자 수금 처리 결과 리스트
	 * 
	 * @param request
	 * @param response
	 * @category 카드독자 수금 처리 결과 리스트
	 * @author ycpark
	 * @return
	 * @throws Exception
	 */
	public ModelAndView cardReaderSugmList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 25;
			int totalCount = 0;
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			String opReadNo = param.getString("opReadNo");
			String opUserId = param.getString("opUserId");
			String opStatus = param.getString("opStatus");
			
			dbparam.put("realJikuk", param.getString("realJikuk"));				
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			dbparam.put("opReadNo", opReadNo);
			dbparam.put("opUserId", opUserId);
			dbparam.put("status", opStatus);
			
			List cardPaymentYymmList = generalDAO.queryForList("reader.card.cardPaymentYymm", dbparam);// 카드 청구월 조회
			
			if(!cardPaymentYymmList.isEmpty()){
				Map tempReader = (Map)cardPaymentYymmList.get(0);
				dbparam.put("yymm", param.getString("yymm", (String)tempReader.get("YYMM")) );
				mav.addObject("yymm" , param.getString("yymm", (String)tempReader.get("YYMM")) );
			}
			
			List cardReaderSugmList = generalDAO.queryForList("reader.card.cardReaderDtlPaymentList", dbparam);// 카드독자 리스트 조회
			totalCount = generalDAO.count("reader.card.cardReaderDtlPaymentTotCnt", dbparam);// 카드독자 리스트 카운트
			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" , dbparam);// 지국 목록
			
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 20));
			mav.addObject("cardReaderSugmList" , cardReaderSugmList);
			mav.addObject("cardPaymentYymmList" , cardPaymentYymmList);
			mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("status" , param.getString("status"));
			mav.addObject("totalCount" , totalCount);
			mav.addObject("loginType" , loginType);
			mav.addObject("opReadNo" , opReadNo);
			mav.addObject("opUserId" , opUserId);
			mav.addObject("opStatus" , opStatus);
			mav.addObject("now_menu", MENU_CODE_READER_CARD);
			mav.setViewName("reader/card/cardReaderDtlPaymentList");
			
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
	 * 카드독자 수금 처리 결과 리스트(지국)
	 * 
	 * @param request
	 * @param response
	 * @category 카드독자 수금 처리 결과 리스트(지국)
	 * @author ycpark
	 * @return
	 * @throws Exception
	 */
	public ModelAndView cardReaderSugmListJikuk(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 20;
			int totalCount = 0;
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			String jikuk = (String)session.getAttribute(SESSION_NAME_AGENCY_SERIAL);
			
			dbparam.put("realJikuk", jikuk);
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			dbparam.put("status", param.getString("status"));
			
			List cardPaymentYymmList = generalDAO.queryForList("reader.card.cardPaymentYymm", dbparam);// 카드 청구월 조회
			
			if(!cardPaymentYymmList.isEmpty()){
				Map tempReader = (Map)cardPaymentYymmList.get(0);
				dbparam.put("yymm", param.getString("yymm", (String)tempReader.get("YYMM")) );
				mav.addObject("yymm" , param.getString("yymm", (String)tempReader.get("YYMM")) );
			}
			
			List cardReaderSugmList = generalDAO.queryForList("reader.card.cardReaderDtlPaymentListJikuk", dbparam);// 카드독자 리스트 조회
			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" , dbparam);// 지국 목록
			
			mav.addObject("cardReaderSugmList" , cardReaderSugmList);
			mav.addObject("cardPaymentYymmList" , cardPaymentYymmList);
			mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("status" , param.getString("status"));
			mav.addObject("loginType" , loginType);
			mav.addObject("now_menu", MENU_CODE_READER_CARD);
			mav.setViewName("reader/card/cardReaderDtlPaymentListJikuk");
			
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
	 * 카드독자 수금 파일 처리
	 * 
	 * @param request
	 * @param response
	 * @category 카드독자 수금 파일 처리
	 * @author ycpark
	 * @return
	 * @throws Exception
	 */
	public ModelAndView uploadCardPaymentFile(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		System.out.println("uploadCardPaymentFile start");
		
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		try{

			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);

			MultipartHttpServletParam param = new MultipartHttpServletParam(request);
			MultipartFile cardReaderfile = param.getMultipartFile("cardReaderfile");
			
			HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			String loginId = (String)session.getAttribute(SESSION_NAME_ADMIN_USERID);

			// 본사 권한 확인
			if("A".equals(loginType)){
				// 카드독자신청 파일 첨부 여부 확인
				if(cardReaderfile.isEmpty()){
					mav.setViewName("common/message");
					mav.addObject("message", "파일첨부가 되지 않았습니다.");
					mav.addObject("returnURL", "/reader/card/cardReaderList.do");
					return mav;
				}else{
					
					FileUtil fileUtil = new FileUtil( getServletContext() );
					String fileUploadPath = fileUtil.saveUploadFile(
											cardReaderfile, 
											PATH_PHYSICAL_HOME,
											PATH_DIR_CARD
										);
					
					if ( StringUtils.isEmpty(fileUploadPath) ) {
						mav.setViewName("common/message");
						mav.addObject("message", "파일 저장이 실패하였습니다. ");
						mav.addObject("returnURL", "/reader/card/cardReaderList.do");
						return mav;
						
					// 파일 처리 시작
					}else{
						String fileName = PATH_PHYSICAL_HOME+PATH_DIR_CARD+"/"+fileUploadPath;
						
						Workbook myWorkbook = Workbook.getWorkbook(new File(fileName)); // 파일을 읽어 와서...
					    Sheet mySheet = myWorkbook.getSheet(0);

					    String yymm = "";				// 청구월
					    String userid = "";				// 독자ID
					    String userName = "";			// 독자명
				    	String cardSeq = "";			// 카드식별번호
				    	String billAmt = ""; 			// 청구금액
				    	String amt = ""; 				// 수금금액
				    	String payResult = ""; 			// 청구결과
				    	String boseq = ""; 				// 지국코드
				    	String cardCo = ""; 			// 카드사

					    for(int no=1 ; no < mySheet.getRows() ; no++){
				    		// 셀별로 데이터 추출
				    		for(int i=0 ; i < mySheet.getColumns() ; i++){ 
					    		Cell myCell = mySheet.getCell(i, no);
					    		if(i == 0){
					    			yymm = myCell.getContents();
					    		}else if(i == 1){
					    			userid = myCell.getContents();
					    		}else if(i == 2){
					    			userName = myCell.getContents();
					    		}else if(i == 3){
					    			cardSeq = myCell.getContents();
					    		}else if(i == 4){
					    			billAmt = myCell.getContents();
					    		}else if(i == 6){
					    			amt = myCell.getContents();
					    		}else if(i == 8){
					    			payResult = myCell.getContents();
					    		}else if(i == 10){
					    			boseq = myCell.getContents();
					    		}else if(i == 14){
					    			cardCo = myCell.getContents();
					    		}
					    	}

					    	dbparam.put("yymm", yymm);
					    	dbparam.put("userid", userid);
					    	dbparam.put("userName", userName);
					    	dbparam.put("cardSeq", cardSeq);
					    	dbparam.put("billAmt", billAmt);
				    		dbparam.put("payResult", payResult);
				    		dbparam.put("amt", amt);

					    	dbparam.put("boseq", boseq);
					    	dbparam.put("cardCo", cardCo);
					    	dbparam.put("loginId", loginId);
					    	dbparam.put("readNo", "");
					    	// 1.카드정보 조회
					    	List cardReaderInfo = generalDAO.getSqlMapClient().queryForList("reader.card.retrieveCardReaderInfo", dbparam);

					    	// 1.1. 카드정보가 조회 되지 않는 경우 -> 미등록건처리
					    	if(cardReaderInfo.size() > 0){

					    		Map temp = (Map)cardReaderInfo.get(0);
					    		
					    		String tempReadno = (String)temp.get("READNO");
					    		System.out.println("독자번호="+tempReadno);
					    		
					    		// 1.1.1. 카드정보에 독자번호 있는 경우
					    		if(!"".equals(tempReadno)){
							    	dbparam.put("readNo", tempReadno);	//독자번호
							    	int reamainMoney = Integer.parseInt(amt);	// 카드수금 잔액
							    	int calculateVal = 0;
							    	
						    		// 카드수금처리 이력 테이블에 인서트
							    	System.out.println("수금처리 이력>>>"+dbparam);
						    		generalDAO.getSqlMapClient().insert("reader.card.insertPayment", dbparam);
		
							    	// 독자정보 조회
						    		System.out.println("독자정보조회>>>"+dbparam);
							    	List readerInfo = generalDAO.getSqlMapClient().queryForList("reader.card.retrieveReaderInfo", dbparam);
							    	
							    	// 대상 독자 정보가 있는경우 수금처리
							    	if( readerInfo.size() > 0 ){
							    	
							    		// 수금입력
							    		for(int h=0; h < readerInfo.size(); h++ ){
							    			Map tempReader = (Map)readerInfo.get(h);
							    			dbparam.put("newsCd", (String)tempReader.get("NEWSCD"));
							    			dbparam.put("seq", (String)tempReader.get("SEQ"));
							    			dbparam.put("qty", (BigDecimal)tempReader.get("QTY"));
							    			BigDecimal tempUprice = (BigDecimal)tempReader.get("UPRICE");
							    			int uprice = Integer.parseInt(tempUprice.toString());
							    			dbparam.put("uprice", tempUprice.toString());
							    			String tmpBoseq = (String)tempReader.get("BOSEQ");

							    			if(!tmpBoseq.equals(boseq)){
							    				dbparam.put("boseq", tmpBoseq);
							    			}
							    			
							    			// 해당 월분 수금 생성 여부 확인
							    			List nowMisuList = generalDAO.getSqlMapClient().queryForList("reader.card.retrieveSugmNowYymm", dbparam);
		
							    			// 해당월분 수금이 없는 경우 미수 생성
							    			if(nowMisuList.isEmpty()){
							    				System.out.println("미수생성>>"+dbparam);
							    				generalDAO.getSqlMapClient().insert("reader.card.insertMisu", dbparam);
							    			}
		
							    			// 미수 조회 (지국 조건 제외함)
									    	List misuList = generalDAO.getSqlMapClient().queryForList("reader.card.retrieveMisuList", dbparam);
		
									    	if(!misuList.isEmpty()){
									    		String misuYymm = "";						// 미수월분
									    		// 미수 수금처리 시작
									    		System.out.println("수금처리시작");
										    	for( int i= 0; i < misuList.size(); i++ ){
									    			Map tempMisu = (Map)misuList.get(i);
									    			misuYymm = (String)tempMisu.get("YYMM");
									    			String seq = (String)tempMisu.get("SEQ");
									    			BigDecimal misuAmt = (BigDecimal)tempMisu.get("BILLAMT");
									    			int sugmMoney = Integer.parseInt(misuAmt.toString());
									    			System.out.println("misuAmt = "+misuAmt);
									    			System.out.println("reamainMoney = "+reamainMoney);
									    			
									    			dbparam.put("misuYymm", misuYymm);
							    					dbparam.put("seq", seq);
							    					dbparam.put("inputType", "sugm");

							    					//수금된 금액 나누기 단가가 0보다 클때
							    					if(uprice > 0) {
							    						calculateVal = reamainMoney/uprice;
							    					} else {
							    						calculateVal = 1;
							    					}
							    					
									    			if(reamainMoney > 0 && calculateVal > 0){
									    				
									    				//처음수금처리시 청구금액으로 처리
									    				dbparam.put("sugmMoney", sugmMoney);
									    				System.out.println("sugmMoney = "+sugmMoney);
									    				
									    				/*
									    				if( (i+1) == misuList.size()){
										    				dbparam.put("sugmMoney", reamainMoney);
										    				System.out.println("reamainMoney = "+reamainMoney);
										    			}else{
										    				dbparam.put("sugmMoney", sugmMoney);
										    				System.out.println("sugmMoney = "+sugmMoney);
										    			}
										    			*/
									    				
									    				generalDAO.getSqlMapClient().insert("reader.card.insertReaderSugmHist", dbparam);
									    				generalDAO.getSqlMapClient().update("reader.card.updateSugm", dbparam);
									    				if(!tmpBoseq.equals(boseq)){
									    					dbparam.put("sugmResult", "변경수금처리/"+boseq+"->"+tmpBoseq);
									    				}else{
									    					dbparam.put("sugmResult", "정상수금처리");										    				
									    				}
									    				dbparam.put("sugmResultCd", "0");
									    				generalDAO.getSqlMapClient().insert("reader.card.insertCardDtlPayment", dbparam);
									    				reamainMoney = reamainMoney-sugmMoney ;
									    			}
									    		}//for end
										    // 수금 처리 끝
									    	}
							    		}
		
							    		// 수금 처리 과입금 처리
								    	if(reamainMoney > 0){
								    		dbparam.put("seq", null);
								    		dbparam.put("misuYymm", null);
								    		dbparam.put("sugmMoney", reamainMoney);
								    		dbparam.put("sugmResultCd", "0");
								    		dbparam.put("sugmResult", "과입금");
						    				generalDAO.getSqlMapClient().insert("reader.card.insertCardDtlPayment", dbparam);
								    	}
							    		
							    	// 2. 수금대상이 없는 경우 에러 처리
							    	}else{
							    		dbparam.put("seq", null);
							    		dbparam.put("sugmMoney", amt);
							    		dbparam.put("sugmResultCd", "0");
							    		dbparam.put("sugmResult", "해당독자없음");
					    				generalDAO.getSqlMapClient().insert("reader.card.insertCardDtlPayment", dbparam);
							    	}
					    	
							    // 1.1.2. 카드정보에 매핑 독자번호가 없는 경우 에러처리
					    		}else{
					    			dbparam.put("seq", null);
						    		dbparam.put("sugmMoney", amt);
						    		dbparam.put("sugmResultCd", "0");
						    		dbparam.put("sugmResult", "독자번호없음");
				    				generalDAO.getSqlMapClient().insert("reader.card.insertCardDtlPayment", dbparam);
					    		}
					    	
				    		// 1.2. 카드독자가 없는 경우 에러처리 
					    	}else{
					    		dbparam.put("seq", null);
					    		dbparam.put("sugmMoney", amt);
					    		dbparam.put("sugmResultCd", "0");
					    		dbparam.put("sugmResult", "카드독자미등록건");
			    				generalDAO.getSqlMapClient().insert("reader.card.insertCardDtlPayment", dbparam);
					    	}
					    	
					    }	// 추출 데이터 처리 종료
					    	
					}	// 파일 처리 종료
				    generalDAO.getSqlMapClient().getCurrentConnection().commit();
				    mav.setViewName("common/message");
					mav.addObject("message", "수금 처리가 완료 되었습니다.");
					mav.addObject("returnURL", "/reader/card/cardReaderSugmList.do");
					return mav;
				}

			}else{
				mav.setViewName("common/message");
				mav.addObject("message", MSG_LOGIN_NOT_AUTH_ADMIN);
				mav.setView(new RedirectView("/reader/card/cardReaderSugmList.do"));
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
	
	/** 카드 결제 정보 조회
	 * 
	 * @param request
	 * @param response
	 * @category 카드 결제 정보 조회
	 * @author ycpark
	 * @return
	 * @throws Exception
	 */
	public ModelAndView popCardPaymentList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		//현재날짜
		Calendar rightNow = Calendar.getInstance();
		String thisYear = String.valueOf(rightNow.get(Calendar.YEAR));
		
		try{
			HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
			dbparam.put("cardSeq",  param.getString("cardSeq"));
			dbparam.put("readNo",  param.getString("readNo"));

			List paymentHist = generalDAO.queryForList("reader.card.selectCardPaymentHist" , dbparam); // 카드이체납부이력

			mav.addObject("paymentHist" , paymentHist);
			mav.addObject("thisYear" , thisYear);
			mav.setViewName("reader/card/popCardPaymentHist");
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
	 * 카드구독신청 리스트
	 * 
	 * @param request
	 * @param response
	 * @category 카드구독신청 리스트조회
	 * @author ycpark
	 * @return
	 * @throws Exception
	 */
	public ModelAndView cardAplcList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		//현재날짜
		Calendar rightNow = Calendar.getInstance();
		
		String year = String.valueOf(rightNow.get(Calendar.YEAR));
		String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		String prevMonth = String.valueOf(rightNow.get(Calendar.MONTH));
		String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));

		if (month.length() < 2){ 	month = "0" + month; 	}
		if (prevMonth.length() < 2){ 	prevMonth = "0" + prevMonth; 	}
		if (day.length() < 2){ 	day = "0" + day;	}

		String fromDate= param.getString("fromDate", year + "-" + prevMonth + "-" + day);		//기간 from
		String toDate= param.getString("toDate", year + "-" + month + "-" + day);				//기간 to
		
		String searchType = param.getString("searchType"); 			//조회조건
		String searchKey = param.getString("searchKey"); 				//조회조건
		
		//페이징 설정
		int pageNo = param.getInt("pageNo", 1);
		int pageSize = 13;
		int totalCount = 0;
		
		String opState = param.getString("opState", null);
		
		try{
			HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
			
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			dbparam.put("fromDate", fromDate);
			dbparam.put("toDate", toDate);
			dbparam.put("opState", opState);
			dbparam.put("searchType", searchType);
			dbparam.put("searchKey", searchKey);
			
			List<ArrayList<HashMap<String, String>>> cardAplcList = generalDAO.queryForList("reader.card.cardAplcList", dbparam);// 카드구독신청 리스트 조회
			totalCount = generalDAO.count("reader.card.cardAplcListCount", dbparam);// 카드구독신청 리스트 카운트

			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 20));
			mav.addObject("fromDate", fromDate);
			mav.addObject("toDate", toDate);
			mav.addObject("cardAplcList", cardAplcList);
			mav.addObject("totalCount", totalCount);
			mav.addObject("opState", opState);
			mav.addObject("searchType", searchType);
			mav.addObject("searchKey", searchKey);
			mav.setViewName("reader/card/cardAplcList");
		} catch(Exception e) {
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
		}
		return mav;
	}
	
	
	/** 카드구독신청 정보 조회
	 * 
	 * @param request
	 * @param response
	 * @category 카드구독신청 정보 조회
	 * @author 
	 * @return
	 * @throws Exception
	 */
	public ModelAndView cardAplcReaderInfo(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		
		try{
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			HashMap<String, Object> aplcReaderInfo = new HashMap<String, Object>();
			dbparam.put("seqNo",  param.getString("seqNo"));
			dbparam.put("userId",  param.getString("userId"));
			
			aplcReaderInfo = (HashMap<String, Object>)generalDAO.queryForObject("reader.card.selectCardAplcReader" , dbparam); // 카드이체납부이력
			List agencyList = generalDAO.queryForList("reader.common.agencyListByAlive" , dbparam);// 지국 목록
			
			// 카드회사리스트
			dbparam.put("CDCLSF",  "020");
			List cardCorpList = generalDAO.queryForList("common.getCommonCodeListByCdclsf" , dbparam);
			
			mav.addObject("aplcReaderInfo" , aplcReaderInfo);
			mav.addObject("agencyList" , agencyList);
			mav.addObject("cardCorpList" , cardCorpList);
			mav.setViewName("reader/card/popCardAplcReaderInfo");
		}catch(Exception e){
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
		}
		return mav;
	}
	
	
	
	/**
	 * 카드독자 신청 파일 처리
	 * 
	 * @param request
	 * @param response
	 * @category 카드독자 신청 파일 처리 
	 * @author ycpark
	 * @return
	 * @throws Exception 
	 */
	public ModelAndView createCardReader(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		Param param = new HttpServletParam(request);
		
		//현재날짜
		Calendar rightNow = Calendar.getInstance();
		
		String year = String.valueOf(rightNow.get(Calendar.YEAR));
		String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));

		if (month.length() < 2){ 	month = "0" + month; 	}
		if (day.length() < 2){ 	day = "0" + day;	}

		String toDay = year + month + day;		
		
		String gubun = param.getString("gubunCode"); 		// 신규,기존구분
		String seqNo = param.getString("seqNo");				//카드seq
		String userNo = param.getString("userNo");				//독자No
		String readNo =  param.getString("readNo");			//독자번호
		String userid = param.getString("userId");					//ID
		String readnm = param.getString("userName");			//독자명
		String boseq = param.getString("boseq");					//지국코드
		String telNo = param.getString("telNo");					//전화번호
		String rcvTelNo = param.getString("rcvTelNo");			//전화번호(수령인)
		String email = param.getString("email");					//이메일
		String qty = param.getString("orderCnt");					//부수
		String uprice = param.getString("orderAmt");			//금액
		String status =	"1";												//상태(null:신청, 1:정상, 2:해지신청, 3:해지요청, 4:해지)
		String insDate = param.getString("insDate");				//신청일
		String remk = param.getString("remk");					//비고
		String bdMngNo = param.getString("bdMngNo");		//빌딩관리번호
		String roadAddr = param.getString("addrDoro");		//도로명주소
		String addr1 = param.getString("addr1");					//지번주소
		String addr2 = param.getString("addr2");					//상세주소
		String zip = param.getString("zipNo");						//우편번호
		String newYn = param.getString("newYn", "N");		//본사신규등록여부
		String joinYn = param.getString("joinYn");				//결합여부
		String intfld = "";			   										// 관심분야
		
		String newsCd = param.getString("newsCd");					//신문코드
		String seq = param.getString("seq");								//독자SEQ
		String orgSgTypeCd = param.getString("orgSgTypeCd");		//기존독자 수금방법
		String readTypeCd =  param.getString("readTypeCd");		//기존독자 독자타입
		String orgboSeq = param.getString("orgboSeq");
		
		String telno1 = "";				// 전화번호1
    	String telno2 = "";				// 전화번호2
    	String telno3 = "";				// 전화번호3
    	String handy1 = "";				// 휴대폰번호1
    	String handy2 = "";				// 휴대폰번호2
    	String handy3 = "";				// 휴대폰번호3
		
		String chkTelNo = rcvTelNo.substring(0,2);
		
		//전화번호 자리수 체크
		if(telNo.length() > 8) {
			if(telNo.length() == 9) {
				telno1 = telNo.substring(0, 2);
				telno2 = telNo.substring(2, 5);
				telno3 = telNo.substring(5, 9);
			} else if(telNo.length() == 10) {
				telno1 = telNo.substring(0, 3);
				telno2 = telNo.substring(3, 6);
				telno3 = telNo.substring(6, 10);
			}  else if(telNo.length() == 11) {
				telno1 = telNo.substring(0, 3);
				telno2 = telNo.substring(3, 7);
				telno3 = telNo.substring(7, 11);
			}
		}
		
		//전화번호(수령인) 자리수 체크
		if(rcvTelNo.length() > 9) {
			if("01".equals(chkTelNo)) {
				if(rcvTelNo.length() == 10) {
					handy1 = rcvTelNo.substring(0, 3);
					handy2 = rcvTelNo.substring(3, 6);
					handy3 = rcvTelNo.substring(6, 10);
				} else if (rcvTelNo.length() == 11) {
					handy1 = rcvTelNo.substring(0, 3);
					handy2 = rcvTelNo.substring(3, 7);
					handy3 = rcvTelNo.substring(7, 11);
				}
			}
		}
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			System.out.println("============================>카드구독신청처리_start");

			HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
			String loginId = (String)session.getAttribute(SESSION_NAME_ADMIN_USERID);
			
//	    	System.out.println("============================>카드독자 정보");
//    		System.out.println("userid start = "+userid);
//    		System.out.println("readnm start = "+readnm);
//    		System.out.println("cardSeq start = "+cardSeq);
//    		System.out.println("gubun start = "+gubun);
//    		System.out.println("boseq start = "+boseq);
//    		System.out.println("zip start = "+zip);
//    		System.out.println("bdMngNo start = "+bdMngNo);
//    		System.out.println("roadAddr start = "+roadAddr);
//    		System.out.println("addr1 start = "+addr1);
//    		System.out.println("addr2 start = "+addr2);
//    		System.out.println("email start = "+email);
//    		System.out.println("qty start = "+qty);
//    		System.out.println("intfld start = "+intfld);
//    		System.out.println("status start = "+intfld);
//    		System.out.println("remk start = "+remk);
//    		System.out.println("loginId start = "+loginId);
//    		System.out.println("insDate = "+insDate.replaceAll("-", ""));
//    		System.out.println("ntDt = "+toDay);
//    		System.out.println("newYn = "+newYn);
//    		System.out.println("joinYn = "+joinYn);
//    		System.out.println("============================>카드독자 정보 END");
    		
	    	dbparam.put("userId", userid);
	    	dbparam.put("readNm", readnm);
	    	dbparam.put("cardSeq", seqNo);
	    	dbparam.put("gubun", gubun);
	    	dbparam.put("boseq", boseq);
	    	dbparam.put("zip", zip);
	    	dbparam.put("bdMngNo", bdMngNo);
	    	dbparam.put("newaddr", roadAddr);
	    	dbparam.put("addr1", addr1);
	    	dbparam.put("addr2", addr2);
	    	dbparam.put("email", email);
	    	dbparam.put("qty", qty);
	    	dbparam.put("uprice", uprice);
	    	dbparam.put("intfld", intfld);
	    	dbparam.put("status", status);
	    	dbparam.put("remk", remk);
	    	dbparam.put("aplcDt", insDate.replaceAll("-", "").substring(0, 8));
	    	dbparam.put("ntDt", toDay);
    		dbparam.put("loginId", loginId);
    		dbparam.put("newYn", newYn);
    		dbparam.put("userNo", userNo);
    		dbparam.put("homeTel1", telno1);
			dbparam.put("homeTel2", telno2);
			dbparam.put("homeTel3", telno3);
			dbparam.put("mobile1", handy1);
			dbparam.put("mobile2", handy2);
			dbparam.put("mobile3", handy3);
    		
			if( "1".equals(gubun)){	// 기존 회원인 경우 독자번호 입력을 위해 신청처리
				dbparam.put("gubun", "기존");
				dbparam.put("status", "1");
				dbparam.put("readNo", readNo);
				
				//카드독자테이블 입력
				generalDAO.getSqlMapClient().insert("reader.card.insertCardAplcReader",  dbparam);
				
				//독자테이블정보수정
				dbparam.put("dlvZip", zip);
				dbparam.put("newsCd", newsCd);
				dbparam.put("seq", seq);
				
				if("Y".equals(joinYn)) { //결합독자일때
					dbparam.put("readTypeCd", "023");
				} else {
					dbparam.put("readTypeCd", null);
				}
				
				generalDAO.getSqlMapClient().insert("reader.readerManage.insertreaderHistForCard", dbparam); //구독정보히스토리 업데이트
				generalDAO.getSqlMapClient().update("reader.card.updateReaderNewsForAplc",  dbparam);
				//generalDAO.getSqlMapClient().update("reader.readerManage.updateReaderJusoTelDataForCard",  dbparam);
				
				System.out.println("orgSgTypeCd =====> "+orgSgTypeCd);
				System.out.println("readTypeCd =====> "+readTypeCd);
				
				if("021".equals(orgSgTypeCd)) {	//이전수금이 자동이체일때
					String numId = "";
					dbparam.put("agency_serial", orgboSeq);
					if("013".equals(readTypeCd) ){//학생(본사)
						System.out.println("학생(본사)");
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
					dbparam.put("sgType", "022");
					//미수분존재시 자동이체로 수금구분 변경
					generalDAO.getSqlMapClient().update("reader.readerManage.updateSugm", dbparam);	//수금방법 수정	
				}
				
			}else if( "0".equals(gubun)){ 	// 신규 회원의 경우 정상처리
				dbparam.put("gubun", "신규");
				dbparam.put("status", "1");
				dbparam.put("newsCd", "100");
				dbparam.put("gno", "600");
				dbparam.put("hjPathCd", "003");
				if("Y".equals(joinYn)) { //결합독자일때
					dbparam.put("readTypeCd", "023");
				} else {
					dbparam.put("readTypeCd", "011");
				}
				dbparam.put("sgType", "022");
				dbparam.put("rsdTypeCd", "099");
				dbparam.put("readNo" , generalDAO.getSqlMapClient().queryForObject("reader.readerManage.getReadNo" , dbparam) );
				//dbparam.put("newYn", "Y");
				
				//generalDAO.getSqlMapClient().insert("reader.card.insertCardReader",  dbparam);
				generalDAO.getSqlMapClient().insert("reader.card.insertCardAplcReader",  dbparam);
				// 독자테이블 입력
				generalDAO.getSqlMapClient().insert("reader.card.insertTmReader", dbparam);
				// 독자정보 테이블 입력
				generalDAO.getSqlMapClient().update("reader.card.insertTmReaderNews",  dbparam);
				// 카드독자정보 테이블 상태 수정(정상 처리)
				generalDAO.getSqlMapClient().update("reader.card.completeCardReaderFromFile",  dbparam);
				
			} else {
				generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			}
			//카드신청테이블 지국코드 입력
			generalDAO.getSqlMapClient().update("reader.card.updateTnewspaperBoseq",  dbparam);
			generalDAO.getSqlMapClient().update("reader.card.updateTnewspaperHistBoseq",  dbparam);
			
			System.out.println("============================>카드구독신청처리_end");
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			mav.setViewName("common/message");
			mav.addObject("message", "처리 되었습니다."); 
			mav.addObject("returnURL", "/reader/card/cardAplcReaderInfo.do?seqNo="+seqNo+"&userId="+userid);
		} catch(Exception e) {
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
		}finally{
			generalDAO.getSqlMapClient().endTransaction();
		}
		return mav;
	}
	
	
	/**
	 * 카드 결제내역리스트
	 * 
	 * @param request
	 * @param response
	 * @category 
	 * @author ycpark
	 * @return
	 * @throws Exception 
	 */
	public ModelAndView cardPaymentList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		HashMap<String, String> dbparam = new HashMap<String, String>();
		
		//현재날짜
		Calendar rightNow = Calendar.getInstance();
		String toDay = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));

		//결재된 조회년월 조회
		HashMap<String, Object> billMonthInfo = (HashMap<String, Object>)generalDAO.queryForObject("reader.card.selectMaxMinBillMonth", dbparam);
		
		String getYear = (String)billMonthInfo.get("TOYEAR");
		String getMonth = (String)billMonthInfo.get("TOMONTH");
		getYear = getYear.trim();
		getMonth = getMonth.trim();
		
		String fromDate = "";
		String toDate = "";
		String tmpMonth ="";
			
		//조회시 조회일처리
		String fromYear =  param.getString("fromYear", getYear);
		String fromMonth =  param.getString("fromMonth",  getMonth);
		if (fromMonth.length() < 2){ 	tmpMonth = "0" + fromMonth; } else {tmpMonth=fromMonth;}
		fromDate = fromYear + tmpMonth;
		tmpMonth = "";	
	
		String toYear =  param.getString("toYear", getYear);
		String toMonth =  param.getString("toMonth", getMonth);
		if (toMonth.length() < 2){ 	tmpMonth = "0" + toMonth; } else {tmpMonth=toMonth;}
		toDate = toYear + tmpMonth;
		tmpMonth = "";
		
		try{
			fromDate = param.getString("fromDate", fromDate);
			toDate = param.getString("toDate", toDate);
			
			dbparam.put("fromDate",  fromDate);
			dbparam.put("toDate",  toDate);
			
			List cardPayList = generalDAO.queryForList("reader.card.selectCardPaymentList" , dbparam); // 카드결제내역리스트
			
			//카드 결재내역 리스트 총 갯수
			int paymentTotCnt =  (Integer)generalDAO.getSqlMapClient().queryForObject("reader.card.getCardPaymentTotalCount", dbparam);
			//카드 승인리스트 총 갯수
			int paidTotCnt =  (Integer)generalDAO.getSqlMapClient().queryForObject("reader.card.getCardPaidTotalCount", dbparam);
			
			//20일 승인중일때는 결제내역리스트 안보이게
			if("20".equals(toDay)) {
				if(paymentTotCnt < paidTotCnt) {
					cardPayList = null;
				}
			}
			
			mav.addObject("cardPayList" , cardPayList);
			mav.addObject("fromDate" , fromDate);
			mav.addObject("toDate" , toDate);
			mav.addObject("billMonthInfo", billMonthInfo);
			mav.addObject("fromYear", fromYear);
			mav.addObject("toYear", toYear);
			mav.addObject("fromMonth", Integer.parseInt(fromMonth));
			mav.addObject("toMonth", Integer.parseInt(toMonth));
			mav.addObject("paymentTotCnt", paymentTotCnt);
			mav.addObject("paidTotCnt", paidTotCnt);
			mav.setViewName("reader/card/cardPaymentResultList");
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
	 * 카드독자 신청 파일 처리
	 * 
	 * @param request
	 * @param response
	 * @category 카드독자 신청 파일 처리 
	 * @author ycpark
	 * @return
	 * @throws Exception 
	 */
	public ModelAndView deleteCardAplcReader(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		HttpSession session = request.getSession();
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		
		String userId = param.getString("userId");		
		String seqNo = param.getString("seqNo");
		String loginId = (String)session.getAttribute(SESSION_NAME_ADMIN_USERID);
		
		try {
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			dbparam.put("userId", userId);
			dbparam.put("cardSeq", seqNo);
			dbparam.put("loginId", loginId);
					
			generalDAO.getSqlMapClient().update("reader.card.deleteTnewspaperHistUserData", dbparam);
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			mav.setViewName("common/message");
			mav.addObject("message", "처리 되었습니다."); 
			mav.addObject("returnURL", "/reader/card/cardAplcReaderInfo.do?seqNo="+seqNo+"&userId="+userId);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		} finally {
			generalDAO.getSqlMapClient().endTransaction();
		}
		
		return mav;
	}
	
	/**
	 * 카드번호 변경
	 * 
	 * @param request
	 * @param response
	 * @category 카드번호 변경 처리 
	 * @author manito76
	 * @return
	 * @throws Exception 
	 */
	public ModelAndView popCardNumberEdit(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		HttpSession session = request.getSession();
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		
		String userId = param.getString("userId");
		String cardSeq = param.getString("cardSeq");
		String readNo = param.getString("readNo");

		String loginId = (String)session.getAttribute(SESSION_NAME_ADMIN_USERID);
		String loginName = (String)session.getAttribute(SESSION_NAME_ADMIN_NAME);
		try {
			dbparam.put("userId", userId);
			dbparam.put("cardSeq", cardSeq);
			dbparam.put("readNo", readNo);
			
			HashMap cardReader = (HashMap)generalDAO.queryForObject("reader.card.getCardNumberEditInfo", dbparam);// 독자 정보 조회
			
			
			String EncryptedData = "";
		    String strPGHostURL  = "";
		    PLParamV2 objPLParam = new PLParamV2();
		    objPLParam.EncKey = getApplicationContext().getMessage("key.mksm.KeyValue",null,Locale.getDefault());
		    objPLParam.KeyID  = getApplicationContext().getMessage("key.mksm.KeyID",null,Locale.getDefault());
		    objPLParam.KeyVer = getApplicationContext().getMessage("key.mksm.KeyVersion",null,Locale.getDefault());
		    objPLParam.SetParam("userid",cardReader.get("ID").toString());
		    objPLParam.SetParam("clientid","mksm");   // 고객사아이디 (페이레터에서 부여한 아이디)
		    objPLParam.SetParam("mallid","30009899");     // 상점아이디
		    objPLParam.SetParam("cpid","30009899");     // 상점아이디
		    objPLParam.SetParam("amt","1000");        // 결제금액

		    objPLParam.SetParam("returnurl","http://mk150.mk.co.kr/reader/card/popCardEditResult.do");  // 결제후 결과를 나타내주는 페이지 URL
		    objPLParam.SetParam("svcnm","빌키변경");      // 결제서비스명

		    // 선택 설정 데이터
		    objPLParam.SetParam("ordno","");      // 주문번호
		    objPLParam.SetParam("ordnm",cardReader.get("USERNAME").toString());      // 사용자명
		    objPLParam.SetParam("pname","빌키변경");      // 결제상품명
		    objPLParam.SetParam("etcparam",readNo + "|" + userId + "|" + cardSeq + "|" + cardReader.get("JOIN_YN").toString());   // 기타정보
		    objPLParam.SetParam("emailstate", "0");
		  	objPLParam.SetParam("amtm","빌키변경");                                       // 빌키만 받는 경우 금액란에 노출시킬 정보. (Ex. 개별 경매 최종 낙찰가)
		    objPLParam.SetParam("paytime", "빌키변경");                                       // 빌키만 받는 경우 결제시점에 노출시킬 정보. (Ex. 개별 경매 낙찰시 결제)
		    objPLParam.SetParam("billkey", cardReader.get("BATCHBILLKEY").toString());                                       // 신규 빌키를 생성하는 고객의 이전 빌키
		    objPLParam.SetParam("adminid", loginId);                                       // 빌키를 요청하는 고객사 관리자 아이디
		    strPGHostURL = "ATGAutoCard/CertCardAuthForm.asp";
		    EncryptedData = objPLParam.Encrypt();

		    // POQ 결제페이지로 이동
		    response.sendRedirect("https://pg1.payletter.com/PGSVC/" + strPGHostURL + "?clientparam=" + EncryptedData);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 카드번호 변경 완료
	 * 
	 * @param request
	 * @param response
	 * @category 카드번호 변경 처리 
	 * @author manito76
	 * @return
	 * @throws Exception 
	 */
	public ModelAndView popCardEditResult(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		HttpSession session = request.getSession();
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		String loginId = (String)session.getAttribute(SESSION_NAME_ADMIN_USERID);
		
		response.setContentType( "text/html; charset=UTF-8" );
		try {
			
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			//PLParam Component Instance생성
			PLParamV2 objPLParam = new PLParamV2();
			
			//암호화 키 관련 Property 추가	
			objPLParam.EncKey = getApplicationContext().getMessage("key.mksm.KeyValue",null,Locale.getDefault());
		    objPLParam.KeyID  = getApplicationContext().getMessage("key.mksm.KeyID",null,Locale.getDefault());
		    objPLParam.KeyVer = getApplicationContext().getMessage("key.mksm.KeyVersion",null,Locale.getDefault());
		    objPLParam.SetParam( "resultparam", request.getParameter("clientparam") );	 //페이레터의 암호화된 결제결과(clientparam)을 받아서 resultparam에 설정한다.
		    String strResult = objPLParam.GetParam("result");
		    String strerrMsg = objPLParam.GetParam("errmsg");
		    String cardno = objPLParam.GetParam("cardno");
			String billkey = objPLParam.GetParam("billkey");
			String etcparam = objPLParam.GetParam("etcparam");
			String temp[] = StringUtils.split(etcparam,"|");
			String readno = temp[0];
			String userId = temp[1];
			String cardSeq = temp[2];
			String joinYn = temp[3];
			if(strResult.equals("OK")){
				if(joinYn.equals("Y")){
					if(!dotcomBillkeyUpdate(billkey,userId)){
						response.getWriter().println("<script>alert('내부오류로 카드변경이 완료되지 않았습니다. 다시 시도해주십시요.');window.close();</script>");
						return null;
					}
				}
				
				cardno = cardno.substring(0,4) + "-" +  cardno.substring(4,8) + "-" + cardno.substring(8,12) + "-" + cardno.substring(12,16);
				dbparam.put("cardno",cardno);
				dbparam.put("billkey",billkey);
				dbparam.put("userId",userId);
				dbparam.put("cardSeq",cardSeq);
				int result = generalDAO.getSqlMapClient().update("reader.card.updateBillkey", dbparam);
				
				if(result == 0){
					response.getWriter().println("<script>alert('내부오류로 카드변경이 완료되지 않았습니다. 다시 시도해주십시요.');window.close();</script>");
					return null;
				}
				
				dbparam.put("READNO",readno);
				dbparam.put("MEMO", "카드변경 : " + cardno);
				dbparam.put("CREATEID", loginId);

				generalDAO.getSqlMapClient().insert("util.memo.insertMemo", dbparam); // 메모생성
				generalDAO.getSqlMapClient().getCurrentConnection().commit();
				response.getWriter().println("<script>alert('카드변경이 완료되었습니다.');window.close();</script>");
			}else{
				response.getWriter().println("<script>alert('"+strerrMsg+"');window.close();</script>");
			}
		} catch (Exception e) {
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			response.getWriter().println("<script>alert('내부오류로 카드변경이 완료되지 않았습니다. 다시 시도해주십시요.');window.close();</script>");
		}finally{
			generalDAO.getSqlMapClient().endTransaction();
		}
		return null;
	}
	
	private boolean dotcomBillkeyUpdate(String newBillkey,String userId){
		try {
			List<NameValuePair> params = new ArrayList<NameValuePair>();
			params.add(new BasicNameValuePair("billkey",newBillkey));
			params.add(new BasicNameValuePair("userid",userId));
			String message = ConnectionUtil.sendRequest("https://mcash.mk.co.kr/interface/UpdateBillkey.php",params,"EUC-KR");
			JSONObject jsonObject = JSONObject.fromObject(message);
			String returnMessage = jsonObject.getString("retmsg");
			if(!returnMessage.equals("OK"))
				return false;
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	
	
	/** 카드 결제 회
	 * 
	 * @param request
	 * @param response
	 * @category 카드 결제 정보 조회
	 * @author ycpark
	 * @return
	 * @throws Exception
	 */
	public ModelAndView updateCardPaymentToSugm(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		//현재날짜********************************************************************
		Calendar rightNow = Calendar.getInstance();
		String thisYear = String.valueOf(rightNow.get(Calendar.YEAR));
		String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		if (month.length() < 2){ 	month = "0" + month; 	}
		String thisMonth = thisYear+month;
		//******************************************************************************
		String loginId = (String)session.getAttribute(SESSION_NAME_ADMIN_USERID);
		//String loginId = "TEST";
		
		String readNo = "";
		String boseq = "";
		String strBillingAmt = "";
		String strProcessAmt = "";
		String seqNo = "";
		String mainKey = "";
		String userId = "";
		int billingAmt = 0;
		int processAmt = 0;
		
		String valReadNo = "";
		String valBoseq = "";
		String valNewsCd = "";
		String valSeq = "";
		String strUprice = "";
		String strBillAmt = "";
		String misuSgBbCd = "";
		String misuYymm = "";
		int uprice = 0;
		int sugmMoney = 0;
		int billAmt = 0;
		int remainMoney = 0;
		int totMinuCnt = 0;
		
		List misuList = null;
		
		try{
			HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
			dbparam.put("thisMonth",  thisMonth);

			// 카드이체납부이력
			List cardPaymentList = generalDAO.queryForList("reader.card.selectCardReaderPayResultToSugm" , dbparam); 
			
			Map<String, String> nowMisu = null;

			//카드 수금정보================================================================================================
			if(cardPaymentList.size() > 0) {
				for(int i=0;i<cardPaymentList.size();i++) {
					Map<String,Object> cardReaderData = (Map)cardPaymentList.get(i);
					if(!("").equals(cardReaderData)) {
						readNo = (String)cardReaderData.get("READNO");
						boseq = (String)cardReaderData.get("BOSEQ");
						seqNo = String.valueOf(cardReaderData.get("SEQNO"));
						mainKey = (String)cardReaderData.get("MAINKEY");
						userId = (String)cardReaderData.get("USERID");
						strBillingAmt = String.valueOf(cardReaderData.get("BILLINGAMT"));
						strProcessAmt = String.valueOf(cardReaderData.get("PROCESSAMT"));
						processAmt = Integer.parseInt(strProcessAmt);										//카드수금된금액
						
						dbparam.put("readNo", readNo);
						dbparam.put("boseq", boseq);
						
						remainMoney = processAmt; 			//남은금액 초기화
						
						//카드독자정보조회 *******************************************************************************************************************************************
						List cardReaderDetailList = generalDAO.queryForList("reader.card.selectReaderData", dbparam); 
						
						if(cardReaderDetailList.size()>0) { //카드 독자가 있을때
							for(int j=0;j<cardReaderDetailList.size();j++) { //카드독자리스트(다부수독자가 존재) 
								Map<String,Object> cardReaderDetailView = (Map)cardReaderDetailList.get(j);
								valReadNo = (String)cardReaderDetailView.get("READNO");
								valBoseq = (String)cardReaderDetailView.get("BOSEQ");
								valNewsCd = (String)cardReaderDetailView.get("NEWSCD");
								valSeq = (String)cardReaderDetailView.get("SEQ");
								strUprice = String.valueOf(cardReaderDetailView.get("UPRICE"));
								uprice = Integer.parseInt(strUprice);					//청구금액
								
								dbparam.put("valReadNo", valReadNo);
								dbparam.put("valBoseq", valBoseq);
								dbparam.put("valNewsCd", valNewsCd);
								dbparam.put("valSeq", valSeq);
								dbparam.put("yymm", thisMonth);
								dbparam.put("loginId", loginId );
								
								// 해당 월분 수금 생성 여부 확인
								nowMisu = (Map)generalDAO.getSqlMapClient().queryForObject("reader.card.selectSugmThisMonth", dbparam);
								
								if(nowMisu == null) { // 해당월분 미수가 없는 경우 미수 생성
									System.out.println("카드미수생성 => "+dbparam);
									generalDAO.getSqlMapClient().insert("reader.card.createSugmMisu", dbparam);
								} 
								
								//독자 전체미수갯수 조회
								totMinuCnt = (Integer)generalDAO.getSqlMapClient().queryForObject("reader.card.selectCardTotMisuCount", dbparam);
								
								//독자SEQ당 전체 미수조회
								misuList = generalDAO.getSqlMapClient().queryForList("reader.card.selectCardMisuListBySeq", dbparam);
								
								// 미수 수금처리 시작
								
								if(!misuList.isEmpty()) {
									for(int z=0;z<misuList.size();z++) {
										Map<String, Object> tempMisu = (Map)misuList.get(z);
										misuYymm = (String)tempMisu.get("YYMM");				//미수월										
										strBillAmt = String.valueOf(tempMisu.get("BILLAMT"));	//청구금액
										misuSgBbCd = (String)tempMisu.get("SGBBCD");			//수금방법
										billAmt = Integer.parseInt(strBillAmt);
										dbparam.put("misuYymm", misuYymm);
										
										//수금처리월이 미수일때만 수금처리
										//수금히스토리생성
										generalDAO.getSqlMapClient().insert("reader.card.createReaderSugmHist", dbparam);
										
										//입금금액계산
										dbparam.put("billTypeCd", "001"); //수금 정상처리
										if(totMinuCnt == 1) {
											sugmMoney = remainMoney;
											if(billAmt < remainMoney) {
												dbparam.put("billTypeCd", "002"); //수금 과입금처리
											} 
										} else {
											sugmMoney = billAmt;
											remainMoney = remainMoney - billAmt;
										}
										
										dbparam.put("sugmMoney",sugmMoney);
										//수금처리
										generalDAO.getSqlMapClient().update("reader.card.updateCardSugm", dbparam);
										totMinuCnt--;
										
										dbparam.put("readNo", valReadNo);
										dbparam.put("seq", valSeq);
										dbparam.put("boseq", valBoseq);
										dbparam.put("seqNo", seqNo);
										dbparam.put("mainKey", mainKey);
										dbparam.put("billMon", misuYymm);
										dbparam.put("userId", userId);
										dbparam.put("billingAmt", strBillingAmt);
										dbparam.put("processAmt", strProcessAmt);
										dbparam.put("loginId", loginId);
										dbparam.put("sugmResultCd", null);
										dbparam.put("sugmResult", "정상수금처리");
										generalDAO.getSqlMapClient().insert("reader.card.createCardDtlPayment", dbparam);
									}//for_end
								} else {//if_end
									dbparam.put("readNo", valReadNo);
									dbparam.put("seq", valSeq);
									dbparam.put("boseq", valBoseq);
									dbparam.put("seqNo", seqNo);
									dbparam.put("mainKey", mainKey);
									dbparam.put("billMon", thisMonth);
									dbparam.put("userId", userId);
									dbparam.put("billingAmt", strBillingAmt);
									dbparam.put("processAmt", strProcessAmt);
									dbparam.put("loginId", loginId);
									dbparam.put("sugmResult", "이미수금처리되어있음");
									dbparam.put("sugmResultCd", "0");
									generalDAO.getSqlMapClient().insert("reader.card.createCardDtlPayment", dbparam);
								}
							}
						} else { //카드독자가 없을때
							dbparam.put("readNo", readNo);
							dbparam.put("seq", null);
							dbparam.put("boseq", boseq);
							dbparam.put("seqNo", seqNo);
							dbparam.put("mainKey", mainKey);
							dbparam.put("billMon", thisMonth);
							dbparam.put("userId", userId);
							dbparam.put("billingAmt", strBillingAmt);
							dbparam.put("processAmt", strProcessAmt);
							dbparam.put("loginId", loginId);
							dbparam.put("sugmResult", "해당독자없음");
							dbparam.put("sugmResultCd", "0");
							generalDAO.getSqlMapClient().insert("reader.card.createCardDtlPayment", dbparam);
						}
						//카드독자정보조회 END *************************************************************************************************************************************
					}
				}
			}
			
			mav.setViewName("common/message");
			mav.addObject("message", "저장이 완료 되었습니다.");
			mav.addObject("returnURL", "/reader/card/cardReaderSugmList.do");
			return mav;
		}catch(Exception e){
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", "카드입금처리를 실패하였습니다.");
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	
	/**
	 * 카드단건 결제
	 * 
	 * @param request
	 * @param response
	 * @category 카드번호 변경 처리 
	 * @author manito76
	 * @return
	 * @throws Exception 
	 */
	public ModelAndView popCardOneOnlyPay(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		
		String userId = param.getString("userId");
		String cardSeq = param.getString("cardSeq");
		String readNo = param.getString("readNo");
		String amt = param.getString("amt");

		try {
			dbparam.put("userId", userId);
			dbparam.put("cardSeq", cardSeq);
			dbparam.put("readNo", readNo);
			
			HashMap cardReader = (HashMap)generalDAO.queryForObject("reader.card.getCardNumberEditInfo", dbparam);// 독자 정보 조회
			
			
			String EncryptedData = "";
		    String strPGHostURL  = "";
		    PLParamV2 objPLParam = new PLParamV2();
		    objPLParam.EncKey = getApplicationContext().getMessage("key.mksm2.KeyValue",null,Locale.getDefault());
		    objPLParam.KeyID  = getApplicationContext().getMessage("key.mksm2.KeyID",null,Locale.getDefault());
		    objPLParam.KeyVer = getApplicationContext().getMessage("key.mksm2.KeyVersion",null,Locale.getDefault());
		    objPLParam.SetParam("userid",cardReader.get("ID").toString());
		    objPLParam.SetParam("clientid","mksm2");   // 고객사아이디 (페이레터에서 부여한 아이디)
		    objPLParam.SetParam("mallid","POQCARD17");     // 상점아이디
		    objPLParam.SetParam("cpid","POQCARD17");     // 상점아이디
		    objPLParam.SetParam("amt",amt);        // 결제금액

		    objPLParam.SetParam("returnurl","http://localhost:8080/reader/card/popCardOneOnlyPayResult.do");  // 결제후 결과를 나타내주는 페이지 URL
		    objPLParam.SetParam("svcnm","단건결제");      // 결제서비스명

		    // 선택 설정 데이터
		    objPLParam.SetParam("ordno","");      // 주문번호
		    objPLParam.SetParam("ordnm",cardReader.get("USERNAME").toString());      // 사용자명
		    objPLParam.SetParam("pname","단건결제");      // 결제상품명
		    objPLParam.SetParam("etcparam",readNo + "|" + userId + "|" + cardSeq + "|" + cardReader.get("JOIN_YN").toString());   // 기타정보
		    objPLParam.SetParam("emailstate", "0");
		    strPGHostURL = "ATGKeyIN/KeyINPayForm.asp";
		    EncryptedData = objPLParam.Encrypt();

		    // POQ 결제페이지로 이동
		    response.sendRedirect("https://pg1.payletter.com/PGSVC/" + strPGHostURL + "?clientparam=" + EncryptedData);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 카드단건 결제
	 * 
	 * @param request
	 * @param response
	 * @category 카드번호 변경 처리 
	 * @author manito76
	 * @return
	 * @throws Exception 
	 */
	public ModelAndView popCardOneOnlyPayResult(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		String loginId = (String)session.getAttribute(SESSION_NAME_ADMIN_USERID);
		
		response.setContentType( "text/html; charset=UTF-8" );
		try {
			
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			//PLParam Component Instance생성
			PLParamV2 objPLParam = new PLParamV2();
			
			//암호화 키 관련 Property 추가	
			objPLParam.EncKey = getApplicationContext().getMessage("key.mksm.KeyValue",null,Locale.getDefault());
		    objPLParam.KeyID  = getApplicationContext().getMessage("key.mksm.KeyID",null,Locale.getDefault());
		    objPLParam.KeyVer = getApplicationContext().getMessage("key.mksm.KeyVersion",null,Locale.getDefault());
		    objPLParam.SetParam( "resultparam", request.getParameter("clientparam") );	 //페이레터의 암호화된 결제결과(clientparam)을 받아서 resultparam에 설정한다.
		    String strResult = objPLParam.GetParam("result");
		    String strerrMsg = objPLParam.GetParam("errmsg");
		    String cardno = objPLParam.GetParam("cardno");
			String billkey = objPLParam.GetParam("billkey");
			String etcparam = objPLParam.GetParam("etcparam");
			String temp[] = StringUtils.split(etcparam,"|");
			String readno = temp[0];
			String userId = temp[1];
			String cardSeq = temp[2];
			String joinYn = temp[3];
			if(strResult.equals("OK")){
				if(joinYn.equals("Y")){
					if(!dotcomBillkeyUpdate(billkey,userId)){
						response.getWriter().println("<script>alert('내부오류로 카드변경이 완료되지 않았습니다. 다시 시도해주십시요.');window.close();</script>");
						return null;
					}
				}
				
				cardno = cardno.substring(0,4) + "-" +  cardno.substring(4,8) + "-" + cardno.substring(8,12) + "-" + cardno.substring(12,16);
				dbparam.put("cardno",cardno);
				dbparam.put("billkey",billkey);
				dbparam.put("userId",userId);
				dbparam.put("cardSeq",cardSeq);
				int result = generalDAO.getSqlMapClient().update("reader.card.updateBillkey", dbparam);
				
				if(result == 0){
					response.getWriter().println("<script>alert('내부오류로 카드변경이 완료되지 않았습니다. 다시 시도해주십시요.');window.close();</script>");
					return null;
				}
				
				dbparam.put("READNO",readno);
				dbparam.put("MEMO", "카드변경 : " + cardno);
				dbparam.put("CREATEID", loginId);

				generalDAO.getSqlMapClient().insert("util.memo.insertMemo", dbparam); // 메모생성
				generalDAO.getSqlMapClient().getCurrentConnection().commit();
				response.getWriter().println("<script>alert('카드변경이 완료되었습니다.');window.close();</script>");
			}else{
				response.getWriter().println("<script>alert('"+strerrMsg+"');window.close();</script>");
			}
		} catch (Exception e) {
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			response.getWriter().println("<script>alert('내부오류로 카드변경이 완료되지 않았습니다. 다시 시도해주십시요.');window.close();</script>");
		}finally{
			generalDAO.getSqlMapClient().endTransaction();
		}
		return null;
	}
	
	
	/**
	 * 카드단건 결제 금액 설정
	 * 
	 * @param request
	 * @param response
	 * @category 카드단건 결제 처리 
	 * @author manito76
	 * @return
	 * @throws Exception 
	 */
	public ModelAndView popCardPayAmt(HttpServletRequest request,
	HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		try {
			String userId = param.getString("userId");
			String cardSeq = param.getString("cardSeq");
			String readNo = param.getString("readNo");
			String userName = param.getString("userName");
			String amt = param.getString("amt");
			mav.addObject("userId",userId);
			mav.addObject("cardSeq",cardSeq);
			mav.addObject("readNo",readNo);
			mav.addObject("userName",userName);
			mav.addObject("amt",amt);
			mav.setViewName("reader/card/popCardPayAmt");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return mav;
	}
	
	
	/**
	 * 카드월별승인내역리스트
	 * 
	 * @param request
	 * @param response
	 * @category 카드단건 결제 처리 
	 * @author manito76
	 * @return
	 * @throws Exception 
	 */
	public ModelAndView cardPaymentApproveList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
				
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		HashMap dbparam = new HashMap();

		//결재된 조회년월 조회
		HashMap<String, Object> billMonthInfo = (HashMap<String, Object>)generalDAO.queryForObject("reader.card.selectMaxMinBillMonth", dbparam);
		
		String getYear = (String)billMonthInfo.get("TOYEAR");
		String getMonth = (String)billMonthInfo.get("TOMONTH");
		getYear = getYear.trim();
		getMonth = getMonth.trim();
		
		String fromDate = "";
		String toDate = "";
			
		//조회시 조회일처리
		String fromYear =  param.getString("fromYear", getYear);
		String fromMonth =  param.getString("fromMonth",  getMonth);
		if (fromMonth.length() < 2){ 	fromMonth = "0" + fromMonth; }
		fromDate = fromYear + fromMonth;
		
		String toYear =  param.getString("toYear", getYear);
		String toMonth =  param.getString("toMonth", getMonth);
		if (toMonth.length() < 2){ 	toMonth = "0" + toMonth; }
		toDate = toYear + toMonth;
		
		try{
			fromDate = param.getString("fromDate", fromDate);
			toDate = param.getString("toDate", toDate);
			
			String userId = param.getString("userId");
			String userName = param.getString("userName");
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 25;
			int totalCount = 0;
			
			
			dbparam.put("fromDate",  fromDate);
			dbparam.put("toDate",  toDate);
			dbparam.put("userId",userId);
			dbparam.put("userName",userName);
			
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			dbparam.put("realJikuk" , param.getString("realJikuk"));
			
			List cardPayApproveList = generalDAO.queryForList("reader.card.selectCardPaymentApproveList" , dbparam); // 카드결제내역리스트
			
			totalCount = generalDAO.count("reader.card.selectCardPaymentApproveListCount", dbparam);// 카드독자 리스트 카운트
			

			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" , dbparam);// 지국 목록
			
			String currentDate = DateUtil.getCurrentDate("yyyyMMdd");
			
			mav.addObject("realJikuk",param.getString("realJikuk"));
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 20));
			mav.addObject("totalCount" , totalCount);
			mav.addObject("cardPayApproveList" , cardPayApproveList);
			mav.addObject("fromDate" , fromDate);
			mav.addObject("toDate" , toDate);
			mav.addObject("billMonthInfo", billMonthInfo);
			mav.addObject("fromYear", fromYear);
			mav.addObject("toYear", toYear);
			mav.addObject("fromMonth", Integer.parseInt(fromMonth));
			mav.addObject("toMonth", Integer.parseInt(toMonth));
			mav.addObject("agencyAllList",agencyAllList);
			mav.addObject("currentDate",currentDate);
			mav.addObject("userId",userId);
			mav.addObject("userName",userName);
			mav.setViewName("reader/card/cardPaymentApproveList");
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
	 * 카드번호 변경 완료
	 * 
	 * @param request
	 * @param response
	 * @category 카드번호 변경 처리 
	 * @author manito76
	 * @return
	 * @throws Exception 
	 */
	public ModelAndView popCardPaymentCancel(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		HttpSession session = request.getSession();
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		Param param = new HttpServletParam(request);
		
		response.setContentType( "text/html; charset=UTF-8" );
		try {
			
			//PLParam Component Instance생성
			PLPayComV2 payCancel = new PLPayComV2();
			
			String userId = StringUtil.notPureNull(param.getString("userId"));
			String pltid = param.getString("pltid");
			
			//암호화 키 관련 Property 추가	
			payCancel.EncKey = getApplicationContext().getMessage("key.mksm1.KeyValue",null,Locale.getDefault());
			payCancel.KeyID  = getApplicationContext().getMessage("key.mksm1.KeyID",null,Locale.getDefault());
			payCancel.KeyVer = getApplicationContext().getMessage("key.mksm1.KeyVersion",null,Locale.getDefault());
			
			payCancel.TxMode    = "real";                   // 수정불가
			payCancel.TxCmd     = "paycancel";              // 수정불가
			payCancel.ClientID  = "mksm1";
			payCancel.PGName    = "allthegate";
			payCancel.UserID    = userId;
			payCancel.UserIP    = request.getRemoteAddr();  // 사용자 IP
			payCancel.HOST      = "pg2.payletter.com:8009"; // 수정불가

	        // 취소할 거래의 페이레터 거래번호(PLTID) 설정
			payCancel.SetField("pltid", pltid);

	        // 거래 취소 트랜잭션을 수행한다.
	        int intRetVal = payCancel.StartAction();

	        //####################### 결제취소 실패 - 에러메세지 #######################
	        if(intRetVal != 0){
	        	StringBuffer message = new StringBuffer();
	        	message.append("승인취소 실패\\r\\n");
	        	message.append(payCancel.GetVal("errmsg"));
	            response.getWriter().println("<script>alert('"+message.toString()+"');window.close();</script>");
//	            response.getWriter().println("취소 실패<br>");
//	            response.getWriter().println("ErrCode:[" + intRetVal + "]<br>"); // 에러코드
//	            response.getWriter().println("ErrMsg:[" + strErrMsg + "]");      // 에러메세지
	            
	        }else{//####################### 결제취소 성공(이곳에서 결제취소 성공시 수행될 작업을 하면 됩니다.) #######################
	        	dbparam.put("pltid",payCancel.GetVal("pltid"));
	        	dbparam.put("userId",userId);
	        	dbparam.put("rejectcode","9998");
	        	dbparam.put("rejectmsg","승인취소");
	        	int result = generalDAO.getSqlMapClient().update("reader.card.setCardPayCancel", dbparam);
				
				if(result == 0){
					response.getWriter().println("<script>alert('내부오류로 승인취소가 완료되지 않았습니다. 다시 시도해주십시요.');window.close();</script>");
					return null;
				}
	        	response.getWriter().println("<script>alert('승인취소 성공');window.close();</script>");
//	        	String strPLTID  = payCancel.GetVal("pltid");
//	        	String strTID    = payCancel.GetVal("tid");
//	        	String strCID    = payCancel.GetVal("cid");
//	        	String strTXDate = payCancel.GetVal("txdate");
//	        	String strTXTime = payCancel.GetVal("txtime");
//
//	            response.getWriter().println("취소성공<br>");
//	            response.getWriter().println("PLTID:[" + strPLTID + "]<br>");  // 취소거래 페이레터거래번호(PLTID)
//	            response.getWriter().println("TID:[" + strTID + "]<br>");       // 취소거래번호
//	            response.getWriter().println("CID:[" + strCID + "]<br>");       // 취소승인번호
//	            response.getWriter().println("TXDATE:[" + strTXDate + "]<br>"); // 거래취소일자
//	            response.getWriter().println("TXTIME:[" + strTXTime + "]<br>"); // 거래취소시간
	        }

		} catch (Exception e) {
			e.printStackTrace();
			response.getWriter().println("<script>alert('내부오류로 카드취소가 완료되지 않았습니다. 다시 시도해주십시요.');window.close();</script>");
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
	public ModelAndView popReaderInfos(HttpServletRequest request,
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
			dbparam.put("NEWSCD", "100");

			List readerList = generalDAO.queryForList("reader.minwon.getReaderList", dbparam);		// 독자조회
			
			mav.addObject("flag" , "1");
			mav.addObject("param" , param);
			mav.addObject("readerList" , readerList);
			mav.setViewName("reader/card/popReaderCheck");
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
	
	public ModelAndView cardPaymentByMonthToExcel(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		String tmpMonth = "";
		String fromDate = "";
		String toDate = "";
		//조회시 조회일처리
		String fromYear =  param.getString("fromYear");
		String fromMonth =  param.getString("fromMonth");
		if (fromMonth.length() < 2){ 	tmpMonth = "0" + fromMonth; } else {tmpMonth=fromMonth;}
		fromDate = fromYear + tmpMonth;
		tmpMonth = "";	
	
		String toYear =  param.getString("toYear");
		String toMonth =  param.getString("toMonth");
		if (toMonth.length() < 2){ 	tmpMonth = "0" + toMonth; } else {tmpMonth=toMonth;}
		toDate = toYear + tmpMonth;
		tmpMonth = "";
		
		try{
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			fromDate = param.getString("fromDate", fromDate);
			toDate = param.getString("toDate", toDate);
			
			dbparam.put("fromDate",  fromDate);
			dbparam.put("toDate",  toDate);
			
			List cardPaymentResultList = generalDAO.queryForList("reader.card.selectCardPaymentResultListByMonth" , dbparam); // 카드결제내역리스트

			String fileName = "cardPaymentList_(" + DateUtil.getCurrentDate("yyyyMM") + ").xls";
			//Excel response
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName); 
			response.setHeader("Content-Description", "JSP Generated Data");
			mav.addObject("cardPaymentResultList" , cardPaymentResultList);
			mav.setViewName("reader/card/excelCardPaymentList");
			
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
