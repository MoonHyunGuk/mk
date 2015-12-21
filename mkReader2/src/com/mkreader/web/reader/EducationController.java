/*------------------------------------------------------------------------------
 * NAME : EmployeeAdminController 
 * DESC : 본사직원 구독 관리
 * Author : pspkj
 *----------------------------------------------------------------------------*/
package com.mkreader.web.reader;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;
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
import jxl.write.Label;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

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

public class EducationController extends MultiActionController implements
ISiteConstant, ICodeConstant {

	private GeneralDAO generalDAO;
	
	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}

	/**
	 * 교육용 독자 리스트 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView retrieveEducationList(HttpServletRequest request,
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
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			
			if(LOGIN_TYPE_ADMIN.equals(loginType)){ //본사
				List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" , dbparam); //지국 리스트
				List companyList = generalDAO.queryForList("reader.education.companyList", dbparam);
				mav.addObject("agencyAllList" , agencyAllList);
				mav.addObject("companyList" , companyList);
			}else if(LOGIN_TYPE_BRANCH.equals(loginType)){// 지국
				dbparam.put("boSeq", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			}
			List educationList = generalDAO.queryForList("reader.education.educationList", dbparam);
	
			totalCount = generalDAO.count("reader.education.educationListCount" , dbparam);

			mav.addObject("now_menu", MENU_CODE_READER_EDUCATION);
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 10));
			mav.addObject("loginType" , loginType);
			mav.addObject("educationList" , educationList);
			mav.addObject("count" , generalDAO.count("reader.education.educationCount" , dbparam));
			mav.setViewName("reader/education/educationList");
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
	 * 교육용 독자 리스트 조회(일괄작업용)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView eduReaderBatchList(HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		
		try{
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			
			//지국 리스트
			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" , dbparam); 
			List companyList = generalDAO.queryForList("reader.education.companyList", dbparam);
			List<Object> educationList = new ArrayList<Object>();
			
			mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("companyList" , companyList);
			mav.addObject("now_menu", MENU_CODE_READER_EDUCATION);
			mav.addObject("loginType" , loginType);
			mav.addObject("educationList" , educationList);
			
			mav.setViewName("reader/education/eduReaderBatchList");
			
		}catch(Exception e){
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
		}
		
		return mav;
	}
	
	/**
	 * 교육용 독자 readNo 등록
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView updateReadNo(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			HashMap dbparam = new HashMap();
			int pageNo = param.getInt("pageNo", 1);
			
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			dbparam.put("boSeq", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			dbparam.put("readNo", param.getString("readNo"));
			dbparam.put("seq", param.getString("seq"));
			
			List readNoList = generalDAO.queryForList("reader.education.getReadNo", dbparam);
			if (readNoList.size() == 0){
				mav.setViewName("common/message");
				mav.addObject("message", param.getString("readNo")+" 독자번호가 존재하지 않습니다.\\n다시 확인해 주시기 바랍니다.");
				mav.addObject("returnURL", "/reader/education/retrieveEducationList.do");
				return mav;
			}else{
				generalDAO.update("reader.education.updateReadNo", dbparam);
			}

			mav.addObject("pageNo" , pageNo);
			mav.setView(new RedirectView("/reader/education/retrieveEducationList.do"));
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
	 * 교육용 독자 리스트 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView searchEducationList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		String getBoSeq	 = "";
		
		try{
			HashMap dbparam = new HashMap();
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 20;
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			int totalCount = 0;
			
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);

			if("A".equals(loginType)){
				dbparam.put("boSeq", param.getString("opBoSeq"));
			}else{
				dbparam.put("boSeq", (String)session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			}
			
			dbparam.put("companyCd", param.getString("companyCd"));
			dbparam.put("searchKey", param.getString("searchKey"));
			dbparam.put("searchText", param.getString("searchText"));
			dbparam.put("status", param.getString("status"));
			dbparam.put("expYn", param.getString("expYn"));
			
			System.out.println("dbparam = "+dbparam);
			
			List educationList = generalDAO.queryForList("reader.education.searchEducationList", dbparam);
			totalCount = generalDAO.count("reader.education.searchEducationListCount" , dbparam);
			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" , dbparam); //지국 리스트
			List companyList = generalDAO.queryForList("reader.education.companyList", dbparam);
			
			mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("companyList" , companyList);
			mav.addObject("expYn" , param.getString("expYn"));
			mav.addObject("opBoSeq" , param.getString("opBoSeq"));
			mav.addObject("boSeq" , param.getString("boSeq"));
			mav.addObject("companyCd" , param.getString("companyCd"));
			mav.addObject("now_menu", MENU_CODE_READER_EDUCATION);
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 10));
			mav.addObject("loginType" , loginType);
			mav.addObject("educationList" , educationList);
			mav.addObject("count" , generalDAO.count("reader.education.searchEducationCount" , dbparam));
			mav.setViewName("reader/education/educationList");
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
	 * 교육용 독자 리스트 조회(일괄작업용)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView searchEduReaderBatchList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		
		try{
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);

			dbparam.put("status", param.getString("status"));
			dbparam.put("searchKey", param.getString("searchKey"));
			dbparam.put("searchText", param.getString("searchText"));
			
			//독자리스트
			List educationList = generalDAO.queryForList("reader.education.searchEduReaderBathList", dbparam);

			//회사리스트
			List companyList = generalDAO.queryForList("reader.education.companyList", dbparam);
			
			mav.addObject("companyList" , companyList);
			mav.addObject("boSeq" , param.getString("boSeq"));
			mav.addObject("now_menu", MENU_CODE_READER_EDUCATION);
			mav.addObject("loginType" , loginType);
			mav.addObject("educationList" , educationList);
			
			mav.setViewName("reader/education/eduReaderBatchList");
		} catch(Exception e) {
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
		}
		return mav;
	}
	
	/**
	 * 교육용 독자 해지
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView deleteReader(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			HashMap dbparam = new HashMap();
			int pageNo = param.getInt("pageNo", 1);
			
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			if("A".equals(loginType)){
				dbparam.put("seq", param.getString("seq"));
				dbparam.put("readNo", param.getString("readNo"));
				dbparam.put("boSeq", param.getString("agent"));
				dbparam.put("chgps" , session.getAttribute(SESSION_NAME_ADMIN_USERID));
				
				generalDAO.getSqlMapClient().update("reader.education.deleteReader", dbparam);
				generalDAO.getSqlMapClient().update("reader.readerManage.closeNews", dbparam);//구독 해지
			
				generalDAO.getSqlMapClient().getCurrentConnection().commit();
				mav.addObject("pageNo" , pageNo);
				mav.setView(new RedirectView("/reader/education/retrieveEducationList.do"));
				return mav;	
			}else{
				mav.setViewName("common/message");
				mav.addObject("message", MSG_LOGIN_NOT_AUTH_ADMIN);
				mav.addObject("returnURL", "/reader/education/retrieveEducationList.do");
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
	 * 교육용 독자 해지(일괄 작업)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView deleteAllReader(HttpServletRequest request,	HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		HttpSession session = request.getSession(true);

		String arryEduChkList = param.getString("arryEduChkList");
		String opBoSeq = param.getString("opBoSeq");
		String companyCd = param.getString("companyCd");
		String expYn = param.getString("expYn");
		String status = param.getString("status");
		String searchKey = param.getString("searchKey");
		String searchText = param.getString("searchText");
		String arryEduList[] = new String[50];
		String arryEduData[] = new String[3];
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			System.out.println("arryEduChkList = "+arryEduChkList);
			System.out.println("opBoSeq = "+opBoSeq);
			System.out.println("companyCd = "+companyCd);
			System.out.println("expYn = "+expYn);
			System.out.println("status = "+status);
			System.out.println("searchKey = "+searchKey);
			System.out.println("searchText = "+searchText);
			
			//독자리스트 추출
			arryEduList = arryEduChkList.split(",");
			
			for(int i=0;i<arryEduList.length;i++) {
				//독자 데이터 추출
				arryEduData  = arryEduList[i].split("@");
				
				System.out.println("seq="+arryEduData[0]);
				System.out.println("readNo="+arryEduData[1]);
				System.out.println("boSeq="+arryEduData[2]);
				
				dbparam.put("seq", arryEduData[0]);
				dbparam.put("readNo", arryEduData[1]);
				dbparam.put("boSeq", arryEduData[2]);
				dbparam.put("chgps" , session.getAttribute(SESSION_NAME_ADMIN_USERID));
				
				generalDAO.getSqlMapClient().update("reader.education.deleteReader", dbparam);
				generalDAO.getSqlMapClient().update("reader.readerManage.closeNews", dbparam);//구독 해지
				arryEduData = null;
			}

			mav.addObject("opBoSeq", opBoSeq);
			mav.addObject("companyCd", companyCd);
			mav.addObject("expYn", expYn);
			mav.addObject("status", status);
			mav.setView(new RedirectView("/reader/education/searchEducationList.do"));
		}catch(Exception e){
			e.printStackTrace();
			System.out.println(e.getMessage());
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
		}finally{
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			generalDAO.getSqlMapClient().endTransaction();
		}
		return mav;
	}
	
	/**
	 * 교육용 독자 엑셀 저장
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView excelEducationList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			HashMap dbparam = new HashMap();
			
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			if("A".equals(loginType)){
				dbparam.put("boSeq", param.getString("opBoSeq"));	
			}else{
				dbparam.put("boSeq", (String)session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			}
			dbparam.put("companyCd", param.getString("companyCd"));
			dbparam.put("searchKey", param.getString("searchKey"));
			dbparam.put("searchText", param.getString("searchText"));
			dbparam.put("status", param.getString("status"));
			dbparam.put("expYn", param.getString("expYn"));
			
			List educationList = generalDAO.queryForList("reader.education.saveExcel", dbparam);

			String fileName = "educationList_(" + DateUtil.getCurrentDate("yyyyMMdd") + ").xls";
			//Excel response
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName); 
			response.setHeader("Content-Description", "JSP Generated Data");
			
			mav.addObject("loginType" , loginType);
			mav.addObject("educationList" , educationList);
			mav.setViewName("reader/excelEducationList");
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
	 * 교육용 독자 수금 이력
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
			if("A".equals(loginType)){
				dbparam.put("boSeq", param.getString("agent"));	
				
			}else{
				dbparam.put("boSeq", (String)session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			}
			dbparam.put("readNo", param.getString("readNo"));
			dbparam.put("news_seq", param.getString("news_seq"));
			
			List reader = generalDAO.queryForList("reader.education.getReader", dbparam);
			if(reader.size() !=0 ){
				Map tem = (Map)reader.get(0);
				
				dbparam.put("newsCd", tem.get("NEWSCD"));
				dbparam.put("readNo", tem.get("READNO"));
				dbparam.put("seq", tem.get("SEQ"));
				dbparam.put("boSeq", tem.get("BOSEQ"));
				
				List sugmList = generalDAO.queryForList("reader.education.collectionList", dbparam);
				mav.addObject("sugmList" , sugmList);
			}
			
			mav.addObject("loginType" , loginType);
			mav.addObject("message", param.getString("message"));
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
	 * 교육용 독자 수금 저장
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView saveSugm(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		//Param param = new HttpServletParam(request);

		

		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		System.out.println("교육용 독자 수금 저장============================>시작");
		try{
			MultipartHttpServletParam param = new MultipartHttpServletParam(request);
			MultipartFile sugmfile = param.getMultipartFile("sugmfile");
			
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			HashMap dbparam = new HashMap();
			
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			if("A".equals(loginType)){
				if ( sugmfile.isEmpty()) {	// 파일 첨부가 안되었으면 
					mav.setViewName("common/message");
					mav.addObject("message", "파일첨부가 되지 않았습니다.");
					mav.addObject("returnURL", "/reader/education/retrieveEducationList.do");
					return mav;
				}
				
				Calendar now = Calendar.getInstance();
				int year = now.get(Calendar.YEAR);
				
				FileUtil fileUtil = new FileUtil( getServletContext() );
				String strFile = fileUtil.saveUploadFile(
										sugmfile, 
										PATH_PHYSICAL_HOME,
										PATH_UPLOAD_EDUCATION_RESULT + "/" + year
									);
				
				if ( StringUtils.isEmpty(strFile) ) {
					mav.setViewName("common/message");
					mav.addObject("message", "파일 저장이 실패하였습니다. ");
					mav.addObject("returnURL", "/reader/education/retrieveEducationList.do");
					return mav;
				}else{
					String fileName = PATH_PHYSICAL_HOME+PATH_UPLOAD_EDUCATION_RESULT + "/" + year+"/"+strFile;
					
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
				    			if(readNo.length() < 9) {
				    				readNo = "0"+readNo;
				    			}
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
			    		
			    		System.out.println("yymm = "+yymm);
						System.out.println("boSeq = "+boSeq);
						System.out.println("qty = "+qty);
						System.out.println("uPrice = "+uPrice);
			    		
						List readerSeq = generalDAO.getSqlMapClient().queryForList("reader.education.getReaderSeq", dbparam);

						if(readerSeq.size() !=0 ){
							//독자 존재
							Map tem = (Map)readerSeq.get(0);
							dbparam.put("news_seq", tem.get("NEWS_SEQ"));
							dbparam.put("seq", tem.get("NEWS_SEQ"));
							dbparam.put("newsCd", MK_NEWSPAPER_CODE);
							dbparam.put("snDt", DateUtil.getCurrentDate("yyyyMMdd"));
							
							List collectionList = generalDAO.getSqlMapClient().queryForList("reader.education.collectionList", dbparam);
							if(collectionList.size() != 0){
								//수금이력 존재
								Map tem2 = (Map)collectionList.get(0);
								
								if("044".equals(tem2.get("SGBBCD"))){
									//미수일땐 수금 업데이트 처리
									generalDAO.getSqlMapClient().update("reader.education.updateReaderSugm", dbparam);
									text = text + (String)dbparam.get("readNo") + " 독자 " + (String)dbparam.get("yymm") + " 월분 " + "수금등록 완료" + nLine;
								}else{
									//미수가 아니면 스킵
									text = text + (String)dbparam.get("readNo") + " 독자 " + (String)dbparam.get("yymm") + " 월분 " + "수금이력 존재" + nLine;	
								}
							}else{
								//수금 등록
								generalDAO.getSqlMapClient().insert("reader.education.saveSugm", dbparam);
								text = text + (String)dbparam.get("readNo") + " 독자 " + (String)dbparam.get("yymm") + " 월분 " + "수금등록 완료" + nLine;
								count ++;
							}
							//System.out.println("text =============> "+text); 
						}else{
							//독자 없음
							text = text + (String)dbparam.get("readNo") + " 독자 번호 없음" + nLine;
						}
				    }
				    msg = msg + text ;
				    msg = msg + nLine + count + "건 수금 등록 처리 완료";
				    //결과 메시지 파일로 저장
				    FileUtil.saveTxtFile(
							PATH_PHYSICAL_HOME+PATH_UPLOAD_EDUCATION_RESULT + "/" + year, 
							"sugmFinal" + DateUtil.getCurrentDate("yyyyMMddHHmmss")+".txt",
							msg,
							"EUC-KR"
						);

				    generalDAO.getSqlMapClient().getCurrentConnection().commit();
				    mav.setViewName("common/message");
					mav.addObject("message", MSG_SUCSSES_EDUCATION);
					mav.addObject("returnURL", "/reader/education/retrieveEducationList.do");
					System.out.println("교육용 독자 수금 저장============================>끝");
					return mav;
				}
	
			}else{
				
				mav.setViewName("common/message");
				mav.addObject("message", MSG_LOGIN_NOT_AUTH_ADMIN);
				mav.setView(new RedirectView("/reader/education/retrieveEducationList.do"));
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
	 * 교육용 독자 일괄등록(엑셀미리보기)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView reviewEduReadersForExcel(HttpServletRequest request, HttpServletResponse response) throws Exception { 

		ModelAndView mav = new ModelAndView();
		Calendar now = Calendar.getInstance();
		int year 			= now.get(Calendar.YEAR);
		String[][] data 	= null;
		int count		= 0;
		
		try {
			MultipartHttpServletParam param = new MultipartHttpServletParam(request);
			MultipartFile readersfile = param.getMultipartFile("readersfile");
			
			//auto commit 해제
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			// 파일 첨부가 안되었을 경우
			if ( readersfile.isEmpty()) {	
				mav.setViewName("common/message");
				mav.addObject("message", "파일첨부가 되지 않았습니다.");
				mav.addObject("returnURL", "/reader/education/eduReaderBatchList.do");
				return mav;
			}
				
			FileUtil fileUtil = new FileUtil( getServletContext() );
			String strFile = fileUtil.saveUploadFile(readersfile, PATH_PHYSICAL_HOME, PATH_UPLOAD_EDUCATION_RESULT + "/" + year);
			
			//파일 업로드가 실패했을 경우
			if ( StringUtils.isEmpty(strFile) ) {
				mav.setViewName("common/message");
				mav.addObject("message", "파일 저장이 실패하였습니다. ");
				mav.addObject("returnURL", "/reader/education/eduReaderBatchList.do");
				return mav;
			}
			
			String fileName = PATH_PHYSICAL_HOME+PATH_UPLOAD_EDUCATION_RESULT + "/" + year+"/"+strFile;

			Workbook myWorkbook = Workbook.getWorkbook(new File(fileName)); 
		    Sheet mySheet = myWorkbook.getSheet(0);

		    //배열 초기값 설정
			data = new String[mySheet.getRows()][17];
			
			//엑셀값 가져오기
		    for(int no=1 ; no < mySheet.getRows() ; no++) { // 행의 갯수 만큼 돌리고 
		    	for(int i=0 ; i < 17 ; i++){ 
		    		Cell myCell = mySheet.getCell(i,no);
	    			data[no][i] = myCell.getContents().trim();
	    			
	    			System.out.println("data["+no+"]["+i+"] = "+data[no][i]);
	    			
	    			//회사코드가 null일 경우
	    			if("".equals(data[no][0])) {break;}
		    	}//for end
		    	//회사코드가 null일 경우
		    	if("".equals(data[no][0])) {break;} else { count++; }
		    }//for end

			mav.addObject("data", data);
			mav.addObject("totalrows", mySheet.getRows()-1);
			mav.addObject("rows", count);
			mav.addObject("uploadedFileName", fileName);
			mav.setViewName("/reader/education/reviewEduReaderBatchList");
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
	 * 교육용 독자 일괄등록
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView insertEduReadersForExcel(HttpServletRequest request,	HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		Param param = new HttpServletParam(request);
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		
		//변수
		int seq 			= 0;
		int count		=	1;
		String[][] data 	= null;
		String msg 		= "";
		String text 		= "";
		String nLine 	= "\n";
		String uploadedFileName	= "";
		
		try {
				uploadedFileName = param.getString("uploadedFileName");
				String fileName = uploadedFileName;

				Workbook myWorkbook = Workbook.getWorkbook(new File(fileName)); 
			    Sheet mySheet = myWorkbook.getSheet(0);

			    //배열 초기값 설정
				data = new String[mySheet.getRows()][17];
				
				//엑셀값 가져오기
			    for(int no=1 ; no < mySheet.getRows() ; no++) { // 행의 갯수 만큼 돌리고 
			    	for(int i=0 ; i < 17 ; i++){ 
			    		Cell myCell = mySheet.getCell(i,no);
		    			data[no][i] = myCell.getContents().trim();
		    			
		    			System.out.println("data["+no+"]["+i+"] = "+data[no][i]);
		    			
		    			//회사코드가 null일 경우
		    			if("".equals(data[no][0])) {break;}
			    	}//for end
			    	//회사코드가 null일 경우
			    	if("".equals(data[no][0])) {break;} else { count++; }
			    }//for end
			    
			    //시퀀스값 가져오기
			    seq =Integer.parseInt( generalDAO.queryForObject("reader.education.getSeq").toString());
			    
			    //테이블에 data insert
			    for(int no=1 ; no < mySheet.getRows() ; no++){ // 행의 갯수 만큼 돌리고 
			    	//파라미터값 초기화
			    	dbparam = new HashMap<Object, Object>();
			    	
				    dbparam.put("seq" , seq);
			    	dbparam.put("readNo" , generalDAO.getSqlMapClient().queryForObject("reader.readerManage.getReadNo" , dbparam));
			    	dbparam.put("delYn" , "N");													//사용여부
			    	dbparam.put("company" , data[no][0]);									//회사코드
			    	dbparam.put("teamNm" , data[no][1]);									//관리팀명
			    	dbparam.put("readNm" , data[no][2]);										//성명
			    	dbparam.put("mobile1" , data[no][3]);										//핸드폰 앞자리
					dbparam.put("mobile2" , data[no][4]);										//핸드폰 중간자리
					dbparam.put("mobile3" , data[no][5]);										//핸드폰 끝자리
					dbparam.put("homeTel1" , data[no][6]);									//전화 앞자리
					dbparam.put("homeTel2" , data[no][7]);									//전화 중간자리
					dbparam.put("homeTel3" , data[no][8]);									//전화 끝자리
					dbparam.put("dlvZip" , data[no][9]);										//우편번호
					dbparam.put("dlvAdrs1" , data[no][10]);									//주소
					dbparam.put("dlvAdrs2" , data[no][11]);									//상세주소
					dbparam.put("boSeq" , data[no][12]);										//지국코드
					dbparam.put("qty" , data[no][13]);											//부수
					dbparam.put("uPrice" , data[no][14]);										//가격
					dbparam.put("indt" , StringUtil.replace(data[no][15], "-", ""));		//신청일
					dbparam.put("remk" , data[no][16]);										//비고
					dbparam.put("newsCd" , MK_NEWSPAPER_CODE);
					dbparam.put("gno" , "400");
					dbparam.put("bno" , "000");
					dbparam.put("readTypeCd" , "015");
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
					dbparam.put("stQty" , "");
					dbparam.put("rsdTypeCd" , "");
					dbparam.put("dlvTypeCd" , "");
					dbparam.put("dlvPosiCd" , "");
					dbparam.put("hjPathCd" , "004");
					dbparam.put("hjTypeCd" , "");
					dbparam.put("hjPsregCd" , "");
					dbparam.put("hjPsnm" , "");
					dbparam.put("hjDt" , StringUtil.replace(data[no][15], "-", ""));
					dbparam.put("indt" , StringUtil.replace(data[no][15], "-", ""));
					dbparam.put("aplcDt" , StringUtil.replace(data[no][15], "-", ""));
					// 7일까지 당월, 8일부터 다음월로 유가년월 지정 (2012.07.03 박윤철)
					if(Integer.parseInt(DateUtil.getCurrentDate("yyyyMMdd").substring(6,8)) < 8){
						dbparam.put("sgBgmm" , DateUtil.getCurrentDate("yyyyMMdd").substring(0,6));
					}else{
						dbparam.put("sgBgmm" , DateUtil.getWantDay(DateUtil.getCurrentDate("yyyyMMdd"), 2, 1).substring(0,6));	
					}
					dbparam.put("sgEdmm" , "");
					dbparam.put("sgCycle" , "");
					dbparam.put("stSayou" , "");
					dbparam.put("aplcNo" , "");
					dbparam.put("remk" , data[no][16]);
					dbparam.put("inps" , session.getAttribute(SESSION_NAME_ADMIN_USERID));
					dbparam.put("spgCd" , "");
					dbparam.put("bnsBookCd" , "");
					dbparam.put("taskCd" , "");
					dbparam.put("intFldCd" , "");
					dbparam.put("bidt" , "");
					dbparam.put("eMail" , "");
					dbparam.put("agency_serial", data[no][12]);
					
					generalDAO.getSqlMapClient().insert("reader.education.insertEducation" , dbparam);
					generalDAO.getSqlMapClient().insert("reader.readerManage.insertTmreader", dbparam); //통합독자생성
					generalDAO.getSqlMapClient().insert("reader.readerManage.inserTmreaderNews", dbparam); //구독정보 생성
					//시퀀스값 증가
					seq ++;
			    }
			    	
			    generalDAO.getSqlMapClient().getCurrentConnection().commit();
			    	
			    msg = msg + text ;
			    msg = msg + nLine + count + "건  등록 처리 완료";
			    //결과 메시지 파일로 저장
			    /*
			    FileUtil.saveTxtFile(
						PATH_PHYSICAL_HOME+PATH_UPLOAD_EDUCATION_RESULT + "/" + year, 
						"sugmFinal" + DateUtil.getCurrentDate("yyyyMMddHHmmss")+".txt",
						msg,
						"EUC-KR"
					);
					*/

			    generalDAO.getSqlMapClient().getCurrentConnection().commit();
			    mav.setViewName("common/message");
				mav.addObject("message", MSG_SUCSSES_EDUCATION);
				mav.addObject("returnURL", "/reader/education/eduReaderBatchList.do");
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
	 * 교육용 독자 일괄등록
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 
	public ModelAndView insertEduReadersForExcel(HttpServletRequest request,	HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		Calendar now = Calendar.getInstance();
		
		//변수
		int seq 			= 0;
		int year 			= now.get(Calendar.YEAR);
		int count		=	1;
		String[][] data 	= null;
		String msg 		= "";
		String text 		= "";
		String nLine 	= "\n";
		
		try {
			MultipartHttpServletParam param = new MultipartHttpServletParam(request);
			MultipartFile readersfile = param.getMultipartFile("readersfile");
			
			//auto commit 해제
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			// 파일 첨부가 안되었을 경우
			if ( readersfile.isEmpty()) {	
				mav.setViewName("common/message");
				mav.addObject("message", "파일첨부가 되지 않았습니다.");
				mav.addObject("returnURL", "/reader/education/eduReaderBatchList.do");
				return mav;
			}
				
			FileUtil fileUtil = new FileUtil( getServletContext() );
			String strFile = fileUtil.saveUploadFile(readersfile, PATH_PHYSICAL_HOME, 	PATH_UPLOAD_EDUCATION_RESULT + "/" + year);
			
			//파일 업로드가 실패했을 경우
			if ( StringUtils.isEmpty(strFile) ) {
				mav.setViewName("common/message");
				mav.addObject("message", "파일 저장이 실패하였습니다. ");
				mav.addObject("returnURL", "/reader/education/eduReaderBatchList.do");
				return mav;
			} else {
				String fileName = PATH_PHYSICAL_HOME+PATH_UPLOAD_EDUCATION_RESULT + "/" + year+"/"+strFile;

				Workbook myWorkbook = Workbook.getWorkbook(new File(fileName)); 
			    Sheet mySheet = myWorkbook.getSheet(0);

			    //배열 초기값 설정
				data = new String[mySheet.getRows()][17];
				
				//엑셀값 가져오기
			    for(int no=1 ; no < mySheet.getRows() ; no++) { // 행의 갯수 만큼 돌리고 
			    	for(int i=0 ; i < 17 ; i++){ 
			    		Cell myCell = mySheet.getCell(i,no);
		    			data[no][i] = myCell.getContents().trim();
		    			
		    			System.out.println("data["+no+"]["+i+"] = "+data[no][i]);
		    			
		    			//회사코드가 null일 경우
		    			if("".equals(data[no][0])) {break;}
			    	}//for end
			    	//회사코드가 null일 경우
			    	if("".equals(data[no][0])) {break;}
			    }//for end
			    
			    //시퀀스값 가져오기
			    seq =Integer.parseInt( generalDAO.queryForObject("reader.education.getSeq").toString());
			    
			    //테이블에 data insert
			    for(int no=1 ; no < mySheet.getRows() ; no++){ // 행의 갯수 만큼 돌리고 
			    	//파라미터값 초기화
			    	dbparam = new HashMap<Object, Object>();
			    	
				    dbparam.put("seq" , seq);
			    	dbparam.put("readNo" , generalDAO.getSqlMapClient().queryForObject("reader.readerManage.getReadNo" , dbparam));
			    	dbparam.put("delYn" , "N");													//사용여부
			    	dbparam.put("company" , data[no][0]);									//회사코드
			    	dbparam.put("teamNm" , data[no][1]);									//관리팀명
			    	dbparam.put("readNm" , data[no][2]);										//성명
			    	dbparam.put("mobile1" , data[no][3]);										//핸드폰 앞자리
					dbparam.put("mobile2" , data[no][4]);										//핸드폰 중간자리
					dbparam.put("mobile3" , data[no][5]);										//핸드폰 끝자리
					dbparam.put("homeTel1" , data[no][6]);									//전화 앞자리
					dbparam.put("homeTel2" , data[no][7]);									//전화 중간자리
					dbparam.put("homeTel3" , data[no][8]);									//전화 끝자리
					dbparam.put("dlvZip" , data[no][9]);										//우편번호
					dbparam.put("dlvAdrs1" , data[no][10]);									//주소
					dbparam.put("dlvAdrs2" , data[no][11]);									//상세주소
					dbparam.put("boSeq" , data[no][12]);										//지국코드
					dbparam.put("qty" , data[no][13]);											//부수
					dbparam.put("uPrice" , data[no][14]);										//가격
					dbparam.put("indt" , StringUtil.replace(data[no][15], "-", ""));		//신청일
					dbparam.put("remk" , data[no][16]);										//비고
					dbparam.put("newsCd" , MK_NEWSPAPER_CODE);
					dbparam.put("gno" , "400");
					dbparam.put("bno" , "000");
					dbparam.put("readTypeCd" , "015");
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
					dbparam.put("stQty" , "");
					dbparam.put("rsdTypeCd" , "");
					dbparam.put("dlvTypeCd" , "");
					dbparam.put("dlvPosiCd" , "");
					dbparam.put("hjPathCd" , "004");
					dbparam.put("hjTypeCd" , "");
					dbparam.put("hjPsregCd" , "");
					dbparam.put("hjPsnm" , "");
					dbparam.put("hjDt" , StringUtil.replace(data[no][15], "-", ""));
					dbparam.put("indt" , StringUtil.replace(data[no][15], "-", ""));
					dbparam.put("aplcDt" , StringUtil.replace(data[no][15], "-", ""));
					// 7일까지 당월, 8일부터 다음월로 유가년월 지정 (2012.07.03 박윤철)
					if(Integer.parseInt(DateUtil.getCurrentDate("yyyyMMdd").substring(6,8)) < 8){
						dbparam.put("sgBgmm" , DateUtil.getCurrentDate("yyyyMMdd").substring(0,6));
					}else{
						dbparam.put("sgBgmm" , DateUtil.getWantDay(DateUtil.getCurrentDate("yyyyMMdd"), 2, 1).substring(0,6));	
					}
					dbparam.put("sgEdmm" , "");
					dbparam.put("sgCycle" , "");
					dbparam.put("stSayou" , "");
					dbparam.put("aplcNo" , "");
					dbparam.put("remk" , data[no][16]);
					dbparam.put("inps" , session.getAttribute(SESSION_NAME_ADMIN_USERID));
					dbparam.put("spgCd" , "");
					dbparam.put("bnsBookCd" , "");
					dbparam.put("taskCd" , "");
					dbparam.put("intFldCd" , "");
					dbparam.put("bidt" , "");
					dbparam.put("eMail" , "");
					dbparam.put("agency_serial", data[no][12]);
					
					generalDAO.getSqlMapClient().insert("reader.education.insertEducation" , dbparam);
					generalDAO.getSqlMapClient().insert("reader.readerManage.insertTmreader", dbparam); //통합독자생성
					generalDAO.getSqlMapClient().insert("reader.readerManage.inserTmreaderNews", dbparam); //구독정보 생성
					//시퀀스값 증가
					seq ++;
					count++;
			    }
			    	
			    generalDAO.getSqlMapClient().getCurrentConnection().commit();
			    	
			    msg = msg + text ;
			    msg = msg + nLine + count + "건  등록 처리 완료";
			    //결과 메시지 파일로 저장
			    FileUtil.saveTxtFile(
						PATH_PHYSICAL_HOME+PATH_UPLOAD_EDUCATION_RESULT + "/" + year, 
						"sugmFinal" + DateUtil.getCurrentDate("yyyyMMddHHmmss")+".txt",
						msg,
						"EUC-KR"
					);

			    generalDAO.getSqlMapClient().getCurrentConnection().commit();
			    mav.setViewName("common/message");
				mav.addObject("message", MSG_SUCSSES_EDUCATION);
				mav.addObject("returnURL", "/reader/education/eduReaderBatchList.do");
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
	*/
	/**
	 * 교육용 독자 입력 폼
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView educationEdit(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			HashMap dbparam = new HashMap();
			
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			if("A".equals(loginType)){
				List companyList = generalDAO.queryForList("reader.education.companyList" , dbparam);
				List teamNmList = generalDAO.queryForList("reader.education.teamNmList" , dbparam);
				List areaCode = generalDAO.queryForList("reader.common.retrieveAreaCode" );// 전화번호 지역번호 조회
				List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" );// 핸도폰 앞자리 번호 조회
				List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" , dbparam); //지국 리스트
				
				mav.addObject("teamNmList", teamNmList);
				mav.addObject("agencyAllList", agencyAllList);
				mav.addObject("companyList", companyList);
				mav.addObject("areaCode", areaCode);
				mav.addObject("mobileCode", mobileCode);
				
				mav.addObject("now_menu", MENU_CODE_READER_EDUCATION);
				mav.setViewName("/reader/educationEdit");
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
	
	public ModelAndView createEducation(HttpServletRequest request,
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
				dbparam.put("seq" , generalDAO.queryForObject("reader.education.getSeq"));
				dbparam.put("boSeq" , param.getString("boSeq"));
				dbparam.put("readNo" , generalDAO.getSqlMapClient().queryForObject("reader.readerManage.getReadNo" , dbparam));
				dbparam.put("delYn" , param.getString("delYn"));
				dbparam.put("company" , param.getString("company"));
				dbparam.put("readNm" , param.getString("readNm"));
				dbparam.put("mobile1" , param.getString("mobile1"));
				dbparam.put("mobile2" , param.getString("mobile2"));
				dbparam.put("mobile3" , param.getString("mobile3"));
				dbparam.put("homeTel1" , param.getString("homeTel1"));
				dbparam.put("homeTel2" , param.getString("homeTel2"));
				dbparam.put("homeTel3" , param.getString("homeTel3"));
				dbparam.put("dlvZip" , param.getString("dlvZip1")+param.getString("dlvZip2"));
				dbparam.put("dlvAdrs1" , param.getString("dlvAdrs1"));
				dbparam.put("dlvAdrs2" , param.getString("dlvAdrs2"));
				dbparam.put("newaddr" , param.getString("newaddr"));
				dbparam.put("bdMngNo" , param.getString("bdMngNo"));
				dbparam.put("qty" , param.getString("qty"));
				dbparam.put("indt" , StringUtil.replace(param.getString("indt"), "-", ""));
				dbparam.put("remk" , param.getString("remk"));
				dbparam.put("teamNm" , param.getString("teamNm"));
				dbparam.put("uPrice" , param.getString("uPrice"));
				
				dbparam.put("newsCd" , MK_NEWSPAPER_CODE);
				dbparam.put("gno" , "400");
				dbparam.put("bno" , "000");
				dbparam.put("readTypeCd" , "015");
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
				dbparam.put("stQty" , "");
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
				// 7일까지 당월, 8일부터 다음월로 유가년월 지정 (2012.07.03 박윤철)
				if(Integer.parseInt(DateUtil.getCurrentDate("yyyyMMdd").substring(6,8)) < 8){
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
				dbparam.put("eMail" , "");
				dbparam.put("agency_serial", param.getString("boSeq"));
				
				
				generalDAO.getSqlMapClient().insert("reader.education.insertEducation" , dbparam);
				generalDAO.getSqlMapClient().insert("reader.readerManage.insertTmreader", dbparam); //통합독자생성
				generalDAO.getSqlMapClient().insert("reader.readerManage.inserTmreaderNews", dbparam); //구독정보 생성
				
				generalDAO.getSqlMapClient().getCurrentConnection().commit();
				
				mav.addObject("seq" , dbparam.get("seq"));
				mav.addObject("agent" , param.getString("boSeq"));
				mav.addObject("readNo" , dbparam.get("readNo"));
				mav.setView(new RedirectView("/reader/education/educationInfo.do"));
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
	 * 교육용 독자 정보
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView educationInfo(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			HashMap dbparam = new HashMap();
			
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			if("A".equals(loginType)){
				String flag = param.getString("flag");
				dbparam.put("seq", param.getString("seq"));
				dbparam.put("boSeq", param.getString("agent"));
				dbparam.put("readNo", param.getString("readNo"));
				
				List educationInfo = generalDAO.queryForList("reader.education.educationInfo" , dbparam);
				List companyList = generalDAO.queryForList("reader.education.companyList" , dbparam);
				List teamNmList = generalDAO.queryForList("reader.education.teamNmList" , dbparam);
				List areaCode = generalDAO.queryForList("reader.common.retrieveAreaCode" );// 전화번호 지역번호 조회
				List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" );// 핸도폰 앞자리 번호 조회
				List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" , dbparam); //지국 리스트
				
				//메모리스트 조회
				dbparam.put("READNO", param.getString("readNo"));
				List memoList  = generalDAO.queryForList("util.memo.getMemoListByReadno" , dbparam);
				
				mav.addObject("teamNmList", teamNmList);
				mav.addObject("agencyAllList", agencyAllList);
				mav.addObject("educationInfo", educationInfo);
				mav.addObject("companyList", companyList);
				mav.addObject("areaCode", areaCode);
				mav.addObject("mobileCode", mobileCode);
				mav.addObject("memoList", memoList);
				mav.addObject("flag", flag);
				//mav.addObject("now_menu", MENU_CODE_READER_EDUCATION);
				mav.setViewName("/reader/education/educationInfo");
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
	 * 교육용 독자 정보 수정
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
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			if("A".equals(loginType)){
				dbparam.put("seq" , param.getString("seq"));
				dbparam.put("oldBoseq" , param.getString("oldBoseq"));
				dbparam.put("boSeq" , param.getString("boSeq"));
				dbparam.put("readNo" , param.getString("readNo"));
				dbparam.put("delYn" , param.getString("delYn"));
				dbparam.put("company" , param.getString("company"));
				dbparam.put("readNm" , param.getString("readNm"));
				dbparam.put("mobile1" , param.getString("mobile1"));
				dbparam.put("mobile2" , param.getString("mobile2"));
				dbparam.put("mobile3" , param.getString("mobile3"));
				dbparam.put("homeTel1" , param.getString("homeTel1"));
				dbparam.put("homeTel2" , param.getString("homeTel2"));
				dbparam.put("homeTel3" , param.getString("homeTel3"));
				dbparam.put("dlvZip" , param.getString("dlvZip1")+param.getString("dlvZip2"));
				dbparam.put("dlvAdrs1" , param.getString("dlvAdrs1"));
				dbparam.put("dlvAdrs2" , param.getString("dlvAdrs2"));
				dbparam.put("newaddr" , param.getString("newaddr"));
				dbparam.put("bdMngNo" , param.getString("bdMngNo"));
				dbparam.put("qty" , param.getString("qty"));
				dbparam.put("remk" , "");
				dbparam.put("teamNm" , param.getString("teamNm"));
				dbparam.put("uPrice" , param.getString("uPrice"));
				dbparam.put("chgps" , session.getAttribute(SESSION_NAME_ADMIN_USERID));
				dbparam.put("aplcDt" , StringUtil.replace(param.getString("indt"), "-", ""));
				dbparam.put("newsCd" , "100");
				
				//value param
				if(!("").equals(param.getString("remk"))) {	//null이 아닐때만 메모생성
					dbparam.put("READNO", param.getString("readNo"));
					dbparam.put("MEMO", param.getString("remk"));
					dbparam.put("CREATEID",  (String)session.getAttribute(SESSION_NAME_ADMIN_USERID));
					
					generalDAO.getSqlMapClient().insert("util.memo.insertMemo", dbparam); //메모생성
				}
				
				// 단순 수정
				if(param.getString("boSeq").equals(param.getString("oldBoseq"))){
					
					generalDAO.getSqlMapClient().update("reader.education.updateEducationInfo" , dbparam); // 교육용독자정보 수정

					dbparam.put("seq" , param.getString("newsSeq")); 		// (2012.07.04 박윤철)
					
					generalDAO.getSqlMapClient().insert("reader.education.insertreaderHist", dbparam); //구독정보히스토리 인서트 (2012.07.04 박윤철)
					generalDAO.getSqlMapClient().update("reader.education.updateNews", dbparam); //구독정보 수정 (2012.07.04 박윤철)
				    
				    if(!param.getString("qty").equals(param.getString("oldQty")) && !param.getString("qty").equals(param.getString("oldQty"))){
				    	
				    	// 해당 독자 미수분 확인
				    	List collectionList = generalDAO.queryForList("reader.education.collectionList", dbparam);//수금정보 조회
				    	
				    	for(int k = 0 ; k < collectionList.size() ; k ++){
				    		Map cList = (Map)collectionList.get(k);
					    	// 미수가 있는 경우 수금 업데이트
					    	if( "023".equals(cList.get("SGGBCD")) && "044".equals(cList.get("SGBBCD")) ){
					    		dbparam.put("yymm" ,cList.get("YYMM") );
					    		dbparam.put("sgbbCd" ,cList.get("SGBBCD") );
					    		dbparam.put("agency_serial" ,cList.get("BOSEQ") );
					    		dbparam.put("billAmt" , param.getString("uPrice") );
					    		dbparam.put("qty" , param.getString("qty"));
					    		
					    		generalDAO.getSqlMapClient().insert("reader.education.insertReaderSugmHist", dbparam); //수금정보히스토리업데이트
					    		generalDAO.getSqlMapClient().update("reader.education.updateReaderSugm2", dbparam); //수금정보 업데이트
					    	}
	
				    	}
				    }
					
				}else{
					//지국 변경
					dbparam.put("gno" , "400");
					dbparam.put("bno" , "000");
					dbparam.put("readTypeCd" , "015");
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
					dbparam.put("stQty" , "");
					dbparam.put("rsdTypeCd" , "");
					dbparam.put("dlvTypeCd" , "");
					dbparam.put("dlvPosiCd" , "");
					dbparam.put("hjPathCd" , "004");
					dbparam.put("hjTypeCd" , "");
					dbparam.put("hjPsregCd" , "");
					dbparam.put("hjPsnm" , "");
					dbparam.put("hjDt" , DateUtil.getCurrentDate("yyyyMMdd"));
					dbparam.put("indt" , DateUtil.getCurrentDate("yyyyMMdd"));
					dbparam.put("aplcDt" , DateUtil.getCurrentDate("yyyyMMdd"));
					dbparam.put("sgEdmm" , "");
					dbparam.put("sgCycle" , "");
					dbparam.put("stSayou" , "");
					dbparam.put("aplcNo" , "");
					dbparam.put("remk" , "");
					dbparam.put("inps" , session.getAttribute(SESSION_NAME_ADMIN_USERID));
					dbparam.put("spgCd" , "");
					dbparam.put("bnsBookCd" , "");
					dbparam.put("taskCd" , "");
					dbparam.put("intFldCd" , "");
					dbparam.put("bidt" , "");
					dbparam.put("eMail" , "");
					dbparam.put("mvyn" , "Y");
					dbparam.put("agency_serial", param.getString("boSeq"));
					dbparam.put("boSeq", param.getString("oldBoseq"));
					
					generalDAO.getSqlMapClient().update("reader.education.deleteReader", dbparam);
					generalDAO.getSqlMapClient().update("reader.readerManage.closeNews", dbparam);//기존 데이터 구독 해지
					
					dbparam.put("readNo", generalDAO.count("reader.employeeAdmin.getReadNo" , dbparam));//독자번호 새로 생성
					dbparam.put("seq" , generalDAO.queryForObject("reader.education.getSeq"));
					
					dbparam.put("sgBgmm", param.getString("sgBgmm"));//수금시작월 새로 셋팅
					dbparam.put("boSeq" , param.getString("boSeq"));
					
					generalDAO.getSqlMapClient().insert("reader.education.insertEducation" , dbparam);
					generalDAO.getSqlMapClient().insert("reader.employeeAdmin.insertTmreader", dbparam); //통합독자생성
					generalDAO.getSqlMapClient().insert("reader.employeeAdmin.inserTmreaderNews", dbparam); //구독정보 생성
				}


				generalDAO.getSqlMapClient().getCurrentConnection().commit();

				mav.addObject("now_menu", MENU_CODE_READER_EDUCATION);
				mav.addObject("seq" , param.getString("seq"));
				mav.addObject("agent" , dbparam.get("boSeq"));
				mav.addObject("readNo" , dbparam.get("readNo"));
				mav.setView(new RedirectView("/reader/education/educationInfo.do"));
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
	 * 교육용 미수생성용 팝업
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView educationUnpaid(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try {
			mav.setViewName("/reader/education/popUnpaiedForEdu");
			return mav;
		} catch(Exception e) {
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}
	
	
	/**
	 * 교육용 미수 엑셀생성
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView educationUnpaiedExceldown(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try {
			HashMap dbparam = new HashMap();
			
			dbparam.put("unpaiedYYMM", param.getString("unpaiedYYMM"));
			List educationList = generalDAO.queryForList("reader.education.selectUnpaiedList", dbparam);

			String fileName = param.getString("unpaiedYYMM")+"월분교육용미수.xls";
			//Excel response
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName); 
			response.setHeader("Content-Description", "JSP Generated Data");
			
			mav.addObject("educationList" , educationList);
			mav.setViewName("reader/education/educationUnpaiedListForExcel");
			return mav;
		} catch(Exception e) {
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}

	/**
	 * 현황출력 엑셀다운
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView educationNowListExcelDown(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HashMap dbparam = new HashMap();
		HttpSession session 	= request.getSession();
		List allJikukNowList	= new ArrayList();
		List nowList				= new ArrayList();
		Map listMap 			= new HashMap(); 
		
		//절대경로
		String path = PATH_UPLOAD_RELATIVE_ROOT+"/education/";

		String fileName 		= "";
		String savefileName 	= "";
		String titleName		= "";
		
		Label label0 = null; 
		Label label1 = null;
		Label label2 = null;
		Label label3 = null;
		Label label4 = null;
		Label label5 = null;
		Label label6 = null;
		
		//저장파일명
		savefileName	= path+"education_now.xls";
		
		WritableWorkbook workbook = Workbook.createWorkbook(new File(savefileName)); 
		WritableSheet sheet1	= workbook.createSheet("전지국", 0);
		WritableSheet sheet2 	= workbook.createSheet("현황", 1); 
		
		sheet1.addCell(new Label(0,0, "지국코드"));
		sheet1.addCell(new Label(1,0, "지국명"));
		sheet1.addCell(new Label(2,0, "금액"));
		sheet1.addCell(new Label(3,0, "부수"));
		sheet1.addCell(new Label(4,0, "구역"));
		sheet1.addCell(new Label(5,0, "AREA"));
		sheet1.addCell(new Label(6,0, "PART"));
		
		sheet2.addCell(new Label(0,0, "지국코드"));
		sheet2.addCell(new Label(1,0, "지국명"));
		sheet2.addCell(new Label(2,0, "금액"));
		sheet2.addCell(new Label(3,0, "부수"));
		sheet2.addCell(new Label(4,0, "구역"));
		sheet2.addCell(new Label(5,0, "AREA"));
		sheet2.addCell(new Label(6,0, "PART"));
		
		try {
			
			//교육용독자현황
			allJikukNowList  = generalDAO.getSqlMapClient().queryForList("reader.education.selectNowList", dbparam);
			
			for(int i=0;i<allJikukNowList.size();i++) {
				listMap = (Map) allJikukNowList.get(i);
				label0 = new Label(0, i+1, (String)listMap.get("SERIAL"));
				label1 = new Label(1, i+1, (String)listMap.get("SERIAL_NM"));
				label2 = new Label(2, i+1, (String)listMap.get("AMT").toString());
				label3 = new Label(3, i+1, (String)listMap.get("QTY").toString()); 
				label4 = new Label(4, i+1, (String)listMap.get("ZONE"));
				label5 = new Label(5, i+1, (String)listMap.get("AREA1"));
				label6 = new Label(6, i+1, (String)listMap.get("PART"));
				
				sheet1.addCell(label0);
				sheet1.addCell(label1);
				sheet1.addCell(label2);
				sheet1.addCell(label3);
				sheet1.addCell(label4);
				sheet1.addCell(label5);
				sheet1.addCell(label6);
				listMap = null;
			}
			
			listMap = null;
			//교육용 독자현황(독자 있는지국만)
			nowList  = generalDAO.getSqlMapClient().queryForList("reader.education.selectNowListByAliveReader", dbparam);
			
			for(int i=0;i<nowList.size();i++) {
				listMap = (Map) nowList.get(i);
				label0 = new Label(0, i+1, (String)listMap.get("SERIAL"));
				label1 = new Label(1, i+1, (String)listMap.get("SERIAL_NM"));
				label2 = new Label(2, i+1, (String)listMap.get("AMT").toString());
				label3 = new Label(3, i+1, (String)listMap.get("QTY").toString()); 
				label4 = new Label(4, i+1, (String)listMap.get("ZONE"));
				label5 = new Label(5, i+1, (String)listMap.get("AREA1"));
				label6 = new Label(6, i+1, (String)listMap.get("PART"));
				
				sheet2.addCell(label0);
				sheet2.addCell(label1);
				sheet2.addCell(label2);
				sheet2.addCell(label3);
				sheet2.addCell(label4);
				sheet2.addCell(label5);
				sheet2.addCell(label6);
				listMap = null;
			}
			
			//엑셀파일 생성
			workbook.write();
			workbook.close();
			
			//파일 다운로드 -------------------------------------------------------------------------------------------------------------START
			File file = new File(savefileName);      // 파일 정의
			String contentType = request.getContentType();
			response.setContentType("x-msdownload");
			
			if(contentType == null) {
				if(request.getHeader("user-agent").indexOf("MSIE 5.5") != -1) {
					response.setContentType("doesn/matter;");
				} else {
					response.setContentType("application/octet-stream");
				}
			} else {
				response.setContentType(contentType);
			}
			
			response.setHeader("Content-Transfer-Encoding:", "binary");
			response.setHeader("Content-Disposition", "attachment; filename=education_now.xls" + ";");
			response.setHeader("Content-Length", ""+file.length());
			response.setHeader("Pragma", "no-cache;");
			response.setHeader("Expires", "-1;");

			byte b[] = new byte[1024];
			BufferedInputStream fin = new BufferedInputStream(new FileInputStream(file));
			BufferedOutputStream fout = new BufferedOutputStream(response.getOutputStream());
			
			try {
				int read =0;
				
				while ((read=fin.read(b)) != -1) {
					fout.write(b,0,read);
				}
			} catch (Exception e) {
			} finally {
				if(fout!=null) fout.close();
				if(fin!=null) fin.close();
				if(file.exists()) file.delete();
			}
			//파일 다운로드 -------------------------------------------------------------------------------------------------------------END
			mav.setViewName("common/message");
			mav.addObject("now_menu", MENU_CODE_READER_EDUCATION);
			mav.addObject("returnURL", "/reader/education/retrieveEducationList.do");
		} catch(Exception e){
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", "현황출력을 실패하였습니다.");
			mav.addObject("now_menu", MENU_CODE_READER_EDUCATION);
			mav.addObject("returnURL", "/reader/education/retrieveEducationList.do");
		}
		return mav;
	}
}