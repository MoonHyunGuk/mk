/*------------------------------------------------------------------------------
 * NAME : AlienationController.java 
 * DESC : 소외계층 구독 관리
 * Author : pspkj
 *----------------------------------------------------------------------------*/
package com.mkreader.web.reader;

import java.io.File;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.servlet.util.MultipartHttpServletParam;
import kr.reflexion.espresso.util.Param;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;
import org.springframework.web.servlet.view.RedirectView;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.DateUtil;
import com.mkreader.util.FileUtil;
import com.mkreader.util.Paging;
import com.mkreader.util.StringUtil;

public class AlienationController extends MultiActionController implements
ISiteConstant, ICodeConstant {

	private GeneralDAO generalDAO;
	
	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}
	/**
	 * 소외계층 리스트 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView retrieveAlienationList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			
			HashMap dbparam = new HashMap();
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 20;
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			int totalCount = 0;
			//소외계층코드
			dbparam.put("READTYPECD", "017");
			
			if(!"A".equals(loginType)){
				dbparam.put("boSeq", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));	
			}

			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" , dbparam); //지국 리스트
			List alienationList = generalDAO.queryForList("reader.alienation.alienationList", dbparam);
			totalCount = generalDAO.count("reader.alienation.alienationListCount" , dbparam);

			mav.addObject("now_menu", MENU_CODE_READER_ALIENATION);
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 10));
			mav.addObject("alienationList" , alienationList);
			mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("loginType" , loginType);
			mav.addObject("count" , generalDAO.count("reader.alienation.alienationCount" , dbparam));
			mav.setViewName("reader/alienation/alienationList");
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
	 * 소외계층 리스트 검색
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView searchAlienationList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		//조회조건
		mav.addObject("opBoSeq" , param.getString("opBoSeq"));
		mav.addObject("searchKey" , param.getString("searchKey"));
		mav.addObject("searchText" , param.getString("searchText"));
		mav.addObject("status" , param.getString("status"));
		
		try{
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			
			HashMap dbparam = new HashMap();
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 20;
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			int totalCount = 0;
			if(!"A".equals(loginType)){
				dbparam.put("boSeq", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));	
			}else{
				dbparam.put("boSeq", param.getString("opBoSeq"));	
			}
			dbparam.put("searchKey", param.getString("searchKey"));
			dbparam.put("searchText", param.getString("searchText"));
			dbparam.put("status", param.getString("status"));
			//소외계층독자코드
			dbparam.put("READTYPECD", "017");
			
			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" , dbparam); //지국 리스트
			List alienationList = generalDAO.queryForList("reader.alienation.searchAlienationList", dbparam);
			totalCount = generalDAO.count("reader.alienation.searchAlienationListCount" , dbparam);

			mav.addObject("now_menu", MENU_CODE_READER_ALIENATION);
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 10));
			mav.addObject("alienationList" , alienationList);
			mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("loginType" , loginType);
			mav.addObject("count" , generalDAO.count("reader.alienation.searchAlienationCount" , dbparam));
			mav.setViewName("reader/alienation/alienationList");
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
	 * 소외계층 리스트 엑셀 저장
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView excelAlienationList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			
			HashMap dbparam = new HashMap();
			
			if(!"A".equals(loginType)){
				dbparam.put("boSeq", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));	
			}else{
				dbparam.put("boSeq", param.getString("boSeq"));	
			}
			dbparam.put("searchKey", param.getString("searchKey"));
			dbparam.put("searchText", param.getString("searchText"));
			dbparam.put("status", param.getString("status"));
			//소외계층독자코드
			dbparam.put("READTYPECD", "017");
			
			List alienationList = generalDAO.queryForList("reader.alienation.excelAlienationList", dbparam);
			
			String fileName = "소외계층리스트(" + DateUtil.getCurrentDate("yyyyMMdd") + ").xls";
			//Excel response
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName); 
			response.setHeader("Content-Description", "JSP Generated Data");
		
			mav.addObject("now_menu", MENU_CODE_READER_ALIENATION);
			mav.addObject("alienationList" , alienationList);
			mav.setViewName("reader/alienation/excelAlienationList");
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
			
			mav.setView(new RedirectView("/reader/alienation/retrieveAlienationList.do"));
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
	 * 소외계층 독자 상세 정보
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView alienationInfo(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		
		try{
			HashMap dbparam = new HashMap();
			
			String flag = param.getString("flag");
			dbparam.put("boSeq", param.getString("boSeqSerial"));
			dbparam.put("readNo", param.getString("readNo"));
			dbparam.put("newsCd", param.getString("newsCd"));
			dbparam.put("seq", param.getString("seq"));
			//소외계층독자코드
			dbparam.put("READTYPECD", "017");

			List areaCode = generalDAO.queryForList("reader.common.retrieveAreaCode" );// 전화번호 지역번호 조회
			List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" );// 핸도폰 앞자리 번호 조회
			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" , dbparam); //지국 리스트
			List alienationInfo = generalDAO.queryForList("reader.alienation.alienationInfo", dbparam);
			
			//메모리스트 조회
			dbparam.put("READNO", param.getString("readNo"));
			List memoList  = generalDAO.queryForList("util.memo.getMemoListByReadno" , dbparam);
			
			mav.addObject("now_menu", MENU_CODE_READER_ALIENATION);
			mav.addObject("param" , param);
			mav.addObject("alienationInfo" , alienationInfo);
			mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("mobileCode" , mobileCode);
			mav.addObject("areaCode" , areaCode);
			mav.addObject("memoList" , memoList);
			mav.addObject("flag" , flag);
			
			mav.setViewName("reader/alienation/alienationInfo");
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
	 * 소외계층 구독 정보 수정
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
			dbparam.put("gno" , "500");
			dbparam.put("bno" , "000");
			dbparam.put("readTypeCd" , param.getString("readTypeCd"));
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
			dbparam.put("uPrice" , Integer.parseInt(param.getString("qty"))*7500);
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
			if(Integer.parseInt(DateUtil.getCurrentDate("yyyyMMdd").substring(6,8)) <= 15){
				dbparam.put("sgBgmm" , DateUtil.getCurrentDate("yyyyMMdd").substring(0,6));
			}else{
				dbparam.put("sgBgmm" , DateUtil.getWantDay(DateUtil.getCurrentDate("yyyyMMdd"), 2, 1).substring(0,6));	
			}
			dbparam.put("sgEdmm" , param.getString("sgEdmm"));
			dbparam.put("sgCycle" , param.getString("sgCycle"));
			dbparam.put("stSayou" , param.getString("stSayou"));
			dbparam.put("aplcNo" , param.getString("aplcNo"));
			dbparam.put("remk" , "");
			dbparam.put("inps" , session.getAttribute(SESSION_NAME_ADMIN_USERID));
			dbparam.put("chgps" , session.getAttribute(SESSION_NAME_ADMIN_USERID));
			dbparam.put("spgCd" , param.getString("spgCd"));
			dbparam.put("bnsBookCd" , param.getString("bnsBookCd"));
			dbparam.put("taskCd" , param.getString("taskCd"));
			dbparam.put("intFldCd" , param.getString("intFldCd"));
			dbparam.put("bidt" , param.getString("bidt"));
			dbparam.put("eMail" , param.getString("email"));
			dbparam.put("agency_serial", param.getString("boSeq"));
			
			if(param.getString("boSeq").equals(param.getString("oldBoseq"))){
				//단순 수정
				generalDAO.getSqlMapClient().update("reader.alienation.updateTmreader", dbparam);//tm_reader 수정
				generalDAO.getSqlMapClient().update("reader.alienation.updateNews", dbparam);//tm_reader_news 수정
				mav.addObject("boSeqSerial", param.getString("boSeq"));
				mav.addObject("readNo", param.getString("readNo"));
				mav.addObject("newsCd", param.getString("newsCd"));
				mav.addObject("seq", param.getString("seq"));
				mav.setView(new RedirectView("/reader/alienation/alienationInfo.do"));
			}else{
				//지국 변경
				generalDAO.getSqlMapClient().update("reader.readerManage.closeNews", dbparam);//기존 데이터 구독 해지
				
				dbparam.put("readNo", generalDAO.count("reader.alienation.getReadNo" , dbparam));//독자번호 새로 생성
				dbparam.put("sgBgmm", param.getString("sgBgmm"));//수금시작월 새로 셋팅
				dbparam.put("hjDt" , DateUtil.getCurrentDate("yyyyMMdd"));
				dbparam.put("indt" , DateUtil.getCurrentDate("yyyyMMdd"));
				dbparam.put("aplcDt" , DateUtil.getCurrentDate("yyyyMMdd"));
				
				generalDAO.getSqlMapClient().insert("reader.alienation.insertTmreader", dbparam); //통합독자생성
				generalDAO.getSqlMapClient().insert("reader.alienation.inserTmreaderNews", dbparam); //구독정보 생성
				
				mav.addObject("searchKey", "readnm");
				mav.addObject("searchText", param.getString("readNm"));
				mav.setView(new RedirectView("/reader/alienation/searchAlienationList.do"));
				
			}
			
			//value param
			if(!("").equals(param.getString("remk"))) {	//null이 아닐때만 메모생성
				dbparam.put("READNO", param.getString("readNo"));
				dbparam.put("MEMO", param.getString("remk"));
				dbparam.put("CREATEID",  (String)session.getAttribute(SESSION_NAME_ADMIN_USERID));
				
				generalDAO.getSqlMapClient().insert("util.memo.insertMemo", dbparam); //메모생성
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
	 * 소외계층 독자 수금 이력
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
		HttpSession session = request.getSession();
		
		try{
			HashMap dbparam = new HashMap();
			
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			
			dbparam.put("boSeq", param.getString("boSeqSerial"));	
			dbparam.put("readNo", param.getString("readNo"));
			dbparam.put("seq", param.getString("seq"));
			dbparam.put("newsCd", param.getString("newsCd"));
			
			List sugmList = generalDAO.queryForList("reader.alienation.collectionList", dbparam);
			mav.addObject("sugmList" , sugmList);
			
			mav.addObject("loginType" , loginType);
			mav.addObject("message", param.getString("message"));
			mav.addObject("gbn", param.getString("gbn"));
			mav.addObject("readNm", param.getString("readNm"));
			mav.addObject("seq", param.getString("seq"));
			mav.addObject("readNo", param.getString("readNo"));
			mav.addObject("qty", param.getString("qty"));
			mav.addObject("boSeq", param.getString("agent"));
			mav.setViewName("reader/pop_paymentHist");
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
	 * 소외계층 독자 수금 저장
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView saveSugm(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		MultipartHttpServletParam param = new MultipartHttpServletParam(request);
		MultipartFile sugmfile = param.getMultipartFile("sugmfile");
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			HashMap dbparam = new HashMap();
			
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			if("A".equals(loginType)){
				if ( sugmfile.isEmpty()) {	// 파일 첨부가 안되었으면 
					mav.setViewName("common/message");
					mav.addObject("message", "파일첨부가 되지 않았습니다.");
					mav.addObject("returnURL", "/reader/alienation/retrieveAlienationList.do");
					return mav;
				}
				
				Calendar now = Calendar.getInstance();
				int year = now.get(Calendar.YEAR);
				
				FileUtil fileUtil = new FileUtil( getServletContext() );
				String strFile = fileUtil.saveUploadFile(
										sugmfile, 
										PATH_PHYSICAL_HOME,
										PATH_UPLOAD_ALIENATION_RESULT + "/" + year
									);
				
				if ( StringUtils.isEmpty(strFile) ) {
					mav.setViewName("common/message");
					mav.addObject("message", "파일 저장이 실패하였습니다. ");
					mav.addObject("returnURL", "/reader/alienation/retrieveAlienationList.do");
					return mav;
				}else{
					String fileName = PATH_PHYSICAL_HOME+PATH_UPLOAD_ALIENATION_RESULT + "/" + year+"/"+strFile;

					Workbook myWorkbook = Workbook.getWorkbook(new File(fileName)); // 파일을 읽어 와서...
				    Sheet mySheet = myWorkbook.getSheet(0);

				    int count=0;
				    String msg = "";
				    String text = "";
					String nLine = "\n";
					
				    for(int no=1 ; no < mySheet.getRows() ; no++){ // 행의 갯수 만큼 돌리고 
				    	String yymm = "";
				    	String readNo = "";
				    	String boSeq = "";
				    	String qty = "";
				    	String uPrice = "";
				    	for(int i=0 ; i < mySheet.getColumns() ; i++){ 
				    		Cell myCell = mySheet.getCell(i,no);
				    		if(i == 0){
				    			yymm = myCell.getContents();
				    		}else if(i == 1){
				    			readNo = myCell.getContents();
				    		}else if(i == 2){
				    			boSeq = myCell.getContents();
				    		}else if(i == 3){
				    			qty = myCell.getContents();
				    		}else if(i == 4){
				    			uPrice = myCell.getContents();
				    		} 
				    	}
				    	dbparam.put("yymm", yymm);
			    		dbparam.put("boSeq", boSeq);	
			    		dbparam.put("readNo", readNo);
			    		dbparam.put("qty", qty);
			    		dbparam.put("uPrice", uPrice);
			    		
						List readerSeq = generalDAO.getSqlMapClient().queryForList("reader.alienation.getReaderSeq", dbparam);

						if(readerSeq.size() !=0 ){
							//독자 존재
							Map tem = (Map)readerSeq.get(0);
							dbparam.put("news_seq", tem.get("SEQ"));
							dbparam.put("seq", tem.get("SEQ"));
							dbparam.put("newsCd", MK_NEWSPAPER_CODE);
							dbparam.put("snDt", DateUtil.getCurrentDate("yyyyMMdd"));
							
							List collectionList = generalDAO.getSqlMapClient().queryForList("reader.alienation.collectionList", dbparam);
							
							System.out.println("dbparam ===================> "+dbparam);
							
							if(collectionList.size() != 0){
								//수금이력 존재
								Map tem2 = (Map)collectionList.get(0);
								
								if("044".equals(tem2.get("SGBBCD"))){
									//미수일땐 수금 업데이트 처리
									generalDAO.getSqlMapClient().update("reader.alienation.updateReaderSugm", dbparam);
									text = text + (String)dbparam.get("readNo") + " 독자 " + (String)dbparam.get("yymm") + " 월분 " + "수금등록 완료" + nLine;
								}else{
									//미수가 아니면 스킵
									text = text + (String)dbparam.get("readNo") + " 독자 " + (String)dbparam.get("yymm") + " 월분 " + "수금이력 존재" + nLine;	
								}
							}else{
								//수금 등록
								generalDAO.getSqlMapClient().insert("reader.alienation.saveSugm", dbparam);
								text = text + (String)dbparam.get("readNo") + " 독자 " + (String)dbparam.get("yymm") + " 월분 " + "수금등록 완료" + nLine;
								count ++;
							}
						}else{
							//독자 없음
							text = text + (String)dbparam.get("readNo") + " 독자 번호 없음" + nLine;
						}
				    }
				    msg = msg + text ;
				    msg = msg + nLine + count + "건 수금 등록 처리 완료";
				    //결과 메시지 파일로 저장
				    FileUtil.saveTxtFile(
							PATH_PHYSICAL_HOME+PATH_UPLOAD_ALIENATION_RESULT + "/" + year, 
							"sugmFinal" + DateUtil.getCurrentDate("yyyyMMddHHmmss")+".txt",
							msg,
							"EUC-KR"
						);

				    generalDAO.getSqlMapClient().getCurrentConnection().commit();
				    mav.setViewName("common/message");
					mav.addObject("message", MSG_SUCSSES_ALIENATION);
					mav.addObject("returnURL", "/reader/alienation/retrieveAlienationList.do");
					return mav;
				}
	
			}else{
				
				mav.setViewName("common/message");
				mav.addObject("message", MSG_LOGIN_NOT_AUTH_ADMIN);
				mav.setView(new RedirectView("/reader/alienation/retrieveAlienationList.do"));
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
	 * 소외계층 독자 입력 폼
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView alienationEdit(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			HashMap dbparam = new HashMap();
			
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			if("A".equals(loginType)){
				List areaCode = generalDAO.queryForList("reader.common.retrieveAreaCode" );// 전화번호 지역번호 조회
				List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" );// 핸도폰 앞자리 번호 조회
				List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" , dbparam); //지국 리스트
				
				mav.addObject("agencyAllList", agencyAllList);
				mav.addObject("areaCode", areaCode);
				mav.addObject("mobileCode", mobileCode);
				
				mav.addObject("now_menu", MENU_CODE_READER_ALIENATION);
				mav.setViewName("/reader/alienation/alienationEdit");
				return mav;
			}else{
				mav.setViewName("common/message");
				mav.addObject("message", MSG_LOGIN_NOT_AUTH_ADMIN);
				mav.addObject("returnURL", "/index.jsp");
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
	 * 교육용 독자 생성
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView createAlienation(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			HashMap dbparam = new HashMap();
			
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			if("A".equals(loginType)){
				String readNo =  (String)generalDAO.getSqlMapClient().queryForObject("reader.readerManage.getReadNo" , dbparam);
				dbparam.put("boSeq" , param.getString("boSeq"));
				dbparam.put("readNo" , readNo);
				dbparam.put("readNm" , param.getString("readNm"));
				dbparam.put("mobile1" , param.getString("mobile1"));
				dbparam.put("mobile2" , param.getString("mobile2"));
				dbparam.put("mobile3" , param.getString("mobile3"));
				dbparam.put("homeTel1" , param.getString("homeTel1"));
				dbparam.put("homeTel2" , param.getString("homeTel2"));
				dbparam.put("homeTel3" , param.getString("homeTel3"));
				dbparam.put("dlvZip" , param.getString("dlvZip1")+"-"+param.getString("dlvZip2"));
				dbparam.put("dlvAdrs1" , param.getString("dlvAdrs1"));
				dbparam.put("dlvAdrs2" , param.getString("dlvAdrs2"));
				dbparam.put("newaddr" , param.getString("newaddr"));
				dbparam.put("bdMngNo" , param.getString("bdMngNo"));
				dbparam.put("qty" , param.getString("qty"));
				dbparam.put("indt" , StringUtil.replace(param.getString("indt"), "-", ""));
				dbparam.put("remk" , param.getString("remk"));
				dbparam.put("uPrice" , param.getString("uPrice"));
				dbparam.put("newsCd" , MK_NEWSPAPER_CODE);
				dbparam.put("gno" , "500");
				dbparam.put("bno" , "000");
				dbparam.put("readTypeCd" , "017");
				dbparam.put("dlvStrNm" , "");
				dbparam.put("dlvStrNo" , "");
				dbparam.put("aptCd" , "");
				dbparam.put("aptDong" , "");
				dbparam.put("aptHo" , "");
				dbparam.put("sgType" , "023");
				dbparam.put("sgInfo" , "");
				dbparam.put("sgTel1" , "");
				dbparam.put("sgTel2" , "");
				dbparam.put("sgTel3" , "");
				dbparam.put("rsdTypeCd" , "");
				dbparam.put("dlvTypeCd" , "");
				dbparam.put("dlvPosiCd" , "");
				dbparam.put("hjPathCd" , "004");
				dbparam.put("hjTypeCd" , "");
				dbparam.put("hjPsregCd" , "");
				dbparam.put("hjPsnm" , "");
				dbparam.put("hjDt" , StringUtil.replace(param.getString("indt"), "-", ""));
				dbparam.put("indt" , StringUtil.replace(param.getString("indt"), "-", ""));
				dbparam.put("aplcDt" , StringUtil.replace(param.getString("indt"), "-", ""));
				if(Integer.parseInt(DateUtil.getCurrentDate("yyyyMMdd").substring(6,8)) <= 15){
					dbparam.put("sgBgmm" , DateUtil.getCurrentDate("yyyyMMdd").substring(0,6));
				}else{
					dbparam.put("sgBgmm" , DateUtil.getWantDay(DateUtil.getCurrentDate("yyyyMMdd"), 2, 1).substring(0,6));	
				}
				dbparam.put("sgEdmm" , "");
				dbparam.put("sgCycle" , "");
				dbparam.put("stSayou" , "");
				dbparam.put("aplcNo" , "");
				dbparam.put("remk" , param.getString("remk"));
				dbparam.put("inps" , session.getAttribute(SESSION_NAME_ADMIN_USERID));
				dbparam.put("spgCd" , "");
				dbparam.put("bnsBookCd" , "");
				dbparam.put("taskCd" , "");
				dbparam.put("intFldCd" , "");
				dbparam.put("bidt" , "");
				dbparam.put("eMail" , param.getString("eMail"));
				dbparam.put("agency_serial", param.getString("boSeq"));
				
				//통합독자생성
				generalDAO.getSqlMapClient().insert("reader.alienation.insertTmreader", dbparam); 
				//구독정보 생성
				generalDAO.getSqlMapClient().insert("reader.alienation.inserTmreaderNews", dbparam);
				
				if(!("").equals(param.getString("remk"))) {	//null이 아닐때만 메모생성
					dbparam.put("READNO", readNo);
					dbparam.put("MEMO", param.getString("remk"));
					dbparam.put("CREATEID",  (String)session.getAttribute(SESSION_NAME_ADMIN_USERID));
					
					generalDAO.getSqlMapClient().insert("util.memo.insertMemo", dbparam); //메모생성
				}
				
				
				generalDAO.getSqlMapClient().getCurrentConnection().commit();
				
				mav.addObject("seq" , "0001");
				mav.addObject("boSeqSerial" , param.getString("boSeq"));
				mav.addObject("readNo" , dbparam.get("readNo"));
				mav.addObject("newsCd" , dbparam.get("newsCd"));
				mav.setView(new RedirectView("/reader/alienation/alienationInfo.do"));
				return mav;
			}else{
				mav.setViewName("common/message");
				mav.addObject("message", MSG_LOGIN_NOT_AUTH_ADMIN);
				mav.addObject("returnURL", "/index.jsp");
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
	 * NI신문독자리스트 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView retrieveNIList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			
			HashMap dbparam = new HashMap();
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 20;
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			int totalCount = 0;
			//NI신문독자코드
			dbparam.put("READTYPECD", "018");
			
			if(!"A".equals(loginType)){
				dbparam.put("boSeq", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));	
			}

			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" , dbparam); //지국 리스트
			List alienationList = generalDAO.queryForList("reader.alienation.alienationList", dbparam);
			totalCount = generalDAO.count("reader.alienation.alienationListCount" , dbparam);

			mav.addObject("now_menu", MENU_CODE_READER_ALIENATION);
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 10));
			mav.addObject("alienationList" , alienationList);
			mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("loginType" , loginType);
			mav.addObject("count" , generalDAO.count("reader.alienation.alienationCount" , dbparam));
			mav.setViewName("reader/alienation/NIList");
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
	 * NI 리스트 검색
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView searchNIList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		//조회조건
		mav.addObject("opBoSeq" , param.getString("opBoSeq"));
		mav.addObject("searchKey" , param.getString("searchKey"));
		mav.addObject("searchText" , param.getString("searchText"));
		mav.addObject("status" , param.getString("status"));
		
		try{
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			
			HashMap dbparam = new HashMap();
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 20;
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			int totalCount = 0;
			if(!"A".equals(loginType)){
				dbparam.put("boSeq", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));	
			}else{
				dbparam.put("boSeq", param.getString("opBoSeq"));	
			}
			dbparam.put("searchKey", param.getString("searchKey"));
			dbparam.put("searchText", param.getString("searchText"));
			dbparam.put("status", param.getString("status"));
			//NI신문독자코드
			dbparam.put("READTYPECD", "018");
			
			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" , dbparam); //지국 리스트
			List alienationList = generalDAO.queryForList("reader.alienation.searchAlienationList", dbparam);
			totalCount = generalDAO.count("reader.alienation.searchAlienationListCount" , dbparam);

			mav.addObject("now_menu", MENU_CODE_READER_ALIENATION);
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 10));
			mav.addObject("alienationList" , alienationList);
			mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("loginType" , loginType);
			mav.addObject("count" , generalDAO.count("reader.alienation.searchAlienationCount" , dbparam));
			mav.setViewName("reader/alienation/NIList");
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
	 * NI 독자 상세 정보
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView niInfo(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		
		try{
			HashMap dbparam = new HashMap();
			
			String flag = param.getString("flag");
			dbparam.put("boSeq", param.getString("boSeqSerial"));
			dbparam.put("readNo", param.getString("readNo"));
			dbparam.put("newsCd", param.getString("newsCd"));
			dbparam.put("seq", param.getString("seq"));
			//NI신문독자코드
			dbparam.put("READTYPECD", "018");

			List areaCode = generalDAO.queryForList("reader.common.retrieveAreaCode" );// 전화번호 지역번호 조회
			List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" );// 핸도폰 앞자리 번호 조회
			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" , dbparam); //지국 리스트
			List alienationInfo = generalDAO.queryForList("reader.alienation.alienationInfo", dbparam);
			
			//메모리스트 조회
			dbparam.put("READNO", param.getString("readNo"));
			List memoList  = generalDAO.queryForList("util.memo.getMemoListByReadno" , dbparam);
			
			mav.addObject("now_menu", MENU_CODE_READER_ALIENATION);
			mav.addObject("param" , param);
			mav.addObject("alienationInfo" , alienationInfo);
			mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("mobileCode" , mobileCode);
			mav.addObject("areaCode" , areaCode);
			mav.addObject("memoList" , memoList);
			mav.addObject("flag" , flag);
			
			mav.setViewName("reader/alienation/NIInfo");
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
	 * NI 독자 생성
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView createNIReader(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			HashMap dbparam = new HashMap();
			
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			if("A".equals(loginType)){
				String readNo =  (String)generalDAO.getSqlMapClient().queryForObject("reader.readerManage.getReadNo" , dbparam);
				dbparam.put("boSeq" , param.getString("boSeq"));
				dbparam.put("readNo" , readNo);
				dbparam.put("readNm" , param.getString("readNm"));
				dbparam.put("mobile1" , param.getString("mobile1"));
				dbparam.put("mobile2" , param.getString("mobile2"));
				dbparam.put("mobile3" , param.getString("mobile3"));
				dbparam.put("homeTel1" , param.getString("homeTel1"));
				dbparam.put("homeTel2" , param.getString("homeTel2"));
				dbparam.put("homeTel3" , param.getString("homeTel3"));
				dbparam.put("dlvZip" , param.getString("dlvZip1")+"-"+param.getString("dlvZip2"));
				dbparam.put("dlvAdrs1" , param.getString("dlvAdrs1"));
				dbparam.put("dlvAdrs2" , param.getString("dlvAdrs2"));
				dbparam.put("newaddr" , param.getString("newaddr"));
				dbparam.put("bdMngNo" , param.getString("bdMngNo"));
				dbparam.put("qty" , param.getString("qty"));
				dbparam.put("indt" , StringUtil.replace(param.getString("indt"), "-", ""));
				dbparam.put("remk" , param.getString("remk"));
				dbparam.put("uPrice" , param.getString("uPrice"));
				dbparam.put("newsCd" , MK_NEWSPAPER_CODE);
				dbparam.put("gno" , "500");
				dbparam.put("bno" , "000");
				dbparam.put("readTypeCd" , "018");
				dbparam.put("dlvStrNm" , "");
				dbparam.put("dlvStrNo" , "");
				dbparam.put("aptCd" , "");
				dbparam.put("aptDong" , "");
				dbparam.put("aptHo" , "");
				dbparam.put("sgType" , "023");
				dbparam.put("sgInfo" , "");
				dbparam.put("sgTel1" , "");
				dbparam.put("sgTel2" , "");
				dbparam.put("sgTel3" , "");
				dbparam.put("rsdTypeCd" , "");
				dbparam.put("dlvTypeCd" , "");
				dbparam.put("dlvPosiCd" , "");
				dbparam.put("hjPathCd" , "004");
				dbparam.put("hjTypeCd" , "");
				dbparam.put("hjPsregCd" , "");
				dbparam.put("hjPsnm" , "");
				dbparam.put("hjDt" , StringUtil.replace(param.getString("indt"), "-", ""));
				dbparam.put("indt" , StringUtil.replace(param.getString("indt"), "-", ""));
				dbparam.put("aplcDt" , StringUtil.replace(param.getString("indt"), "-", ""));
				if(Integer.parseInt(DateUtil.getCurrentDate("yyyyMMdd").substring(6,8)) <= 15){
					dbparam.put("sgBgmm" , DateUtil.getCurrentDate("yyyyMMdd").substring(0,6));
				}else{
					dbparam.put("sgBgmm" , DateUtil.getWantDay(DateUtil.getCurrentDate("yyyyMMdd"), 2, 1).substring(0,6));	
				}
				dbparam.put("sgEdmm" , "");
				dbparam.put("sgCycle" , "");
				dbparam.put("stSayou" , "");
				dbparam.put("aplcNo" , "");
				dbparam.put("remk" , param.getString("remk"));
				dbparam.put("inps" , session.getAttribute(SESSION_NAME_ADMIN_USERID));
				dbparam.put("spgCd" , "");
				dbparam.put("bnsBookCd" , "");
				dbparam.put("taskCd" , "");
				dbparam.put("intFldCd" , "");
				dbparam.put("bidt" , "");
				dbparam.put("eMail" , param.getString("eMail"));
				dbparam.put("agency_serial", param.getString("boSeq"));
				
				//통합독자생성
				generalDAO.getSqlMapClient().insert("reader.alienation.insertTmreader", dbparam); 
				//구독정보 생성
				generalDAO.getSqlMapClient().insert("reader.alienation.inserTmreaderNews", dbparam);
				
				if(!("").equals(param.getString("remk"))) {	//null이 아닐때만 메모생성
					dbparam.put("READNO", readNo);
					dbparam.put("MEMO", param.getString("remk"));
					dbparam.put("CREATEID",  (String)session.getAttribute(SESSION_NAME_ADMIN_USERID));
					
					generalDAO.getSqlMapClient().insert("util.memo.insertMemo", dbparam); //메모생성
				}
				
				
				generalDAO.getSqlMapClient().getCurrentConnection().commit();
				
				mav.addObject("seq" , "0001");
				mav.addObject("boSeqSerial" , param.getString("boSeq"));
				mav.addObject("readNo" , dbparam.get("readNo"));
				mav.addObject("newsCd" , dbparam.get("newsCd"));
				mav.setView(new RedirectView("/reader/alienation/alienationInfo.do"));
				return mav;
			}else{
				mav.setViewName("common/message");
				mav.addObject("message", MSG_LOGIN_NOT_AUTH_ADMIN);
				mav.addObject("returnURL", "/index.jsp");
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
	 * NI계층 리스트 엑셀 저장
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView excelNiList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			
			HashMap dbparam = new HashMap();
			
			if(!"A".equals(loginType)){
				dbparam.put("boSeq", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));	
			}else{
				dbparam.put("boSeq", param.getString("boseq"));	
			}
			dbparam.put("searchKey", param.getString("searchKey"));
			dbparam.put("searchText", param.getString("searchText"));
			dbparam.put("status", param.getString("status"));
			//NI신문독자코드
			dbparam.put("READTYPECD", "018");
			
			List nieList = generalDAO.queryForList("reader.alienation.excelAlienationList", dbparam);
			
			String fileName = "NI구독리스트(" + DateUtil.getCurrentDate("yyyyMMdd") + ").xls";
			//Excel response
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName); 
			response.setHeader("Content-Description", "JSP Generated Data");
			
			System.out.println("3");		
			mav.addObject("now_menu", MENU_CODE_READER_ALIENATION);
			mav.addObject("nieList" , nieList);
			mav.setViewName("reader/alienation/excelNIEList");
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
	 * NI구독 중지
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView closeNINews(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		try{
			HashMap dbparam = new HashMap();
			dbparam.put("readNo", param.getString("readNo"));
			generalDAO.update("reader.readerManage.closeNews", dbparam);//구독 해지
			
			mav.setView(new RedirectView("/reader/alienation/retrieveNIList.do"));
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