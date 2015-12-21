package com.mkreader.web.management;

import java.io.File;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
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
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.apache.log4j.Logger;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.mkreader.dao.GeneralDAO;
import com.mkreader.jidaemailing.JidaeMailingBatch;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.CommonUtil;
import com.mkreader.util.ConnectionUtil;
import com.mkreader.util.FileUtil;
import com.mkreader.util.MailUtil;
import com.mkreader.util.SecurityUtil;
import com.mkreader.util.StringUtil;
import com.mkreader.web.output.BillOutputController;

public class JidaeController extends MultiActionController implements
ISiteConstant, ICodeConstant {
	
public static Logger logger = Logger.getRootLogger();
	
	private GeneralDAO generalDAO;
	
	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}
	
	
	/**
	 * 지대통지서리스트
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView jidaeList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession(true);
		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		
		Calendar cal = Calendar.getInstance();
		int intYear =  cal.get(cal.YEAR);
		int intMonth = cal.get(cal.MONTH);
		String strYear = Integer.toString(intYear);
		String strMonth = Integer.toString(intMonth);
		
		String printBoseq = "";
		List<Object> agencyAllList = null;
		Map agencyListMap = null;
		
		//로그인 아이디
		String userId = String.valueOf(session.getAttribute( SESSION_NAME_ADMIN_USERID) );
		dbparam.put("userId", userId);
		
		//영업담당여부체크
		String chkSellerYn = (String) generalDAO.queryForObject("management.jidae.chkSellerYn", dbparam);
		
		//관리자, 관리팀여부체크
		String chkAdminMngYn = (String) generalDAO.queryForObject("management.jidae.chkAdminMngYn", dbparam);
		
		//영업담당일때만 지국조회
		if("Y".equals(chkSellerYn)) { 
			//담당코드 가져오기
			String localCode = (String) generalDAO.queryForObject("management.jidae.selectLocalCodeBySeller", dbparam);
			
			dbparam.put("localCode", localCode);
			//지국목록
			agencyAllList = generalDAO.queryForList("reader.common.agencyListByLocalCode", dbparam);// 지국 목록 
			
			//전체지국 출력용
			for(int i=0;i<agencyAllList.size();i++) {
				agencyListMap = (Map)agencyAllList.get(i);
				//printBoseq += "'"+agencyListMap.get("USERID")+"',";
				printBoseq += agencyListMap.get("USERID")+",";
				agencyListMap = null;
			}
			
			if(printBoseq.length() > 1) {
				printBoseq = printBoseq.substring(0, printBoseq.length()-1);
			}
		} else if("Y".equals(chkAdminMngYn)){
			//지국목록
			agencyAllList = generalDAO.queryForList("reader.common.agencyListByAlive" );
			
			//전체지국 출력용
			for(int i=0;i<agencyAllList.size();i++) {
				agencyListMap = (Map)agencyAllList.get(i);
				//printBoseq += "'"+agencyListMap.get("USERID")+"',";
				printBoseq += agencyListMap.get("USERID")+",";
				agencyListMap = null;
			}
			
			if(printBoseq.length() > 1) {
				printBoseq = printBoseq.substring(0, printBoseq.length()-1);
			}
		}
		
		//마지막 지대년월가져오기
		String lastYYMM = (String)generalDAO.queryForObject("management.jidae.getJidaeLastYymm");
		String lastYear = "";
		String lastMonth = "";
		
		if(lastYYMM != null) {
			lastYear = lastYYMM.substring(0, 4);
			lastMonth = lastYYMM.substring(4, 6);
		}
		
		mav.addObject("now_menu", MENU_CODE_MANAGEMENT_JIDAE);
		mav.addObject("agencyAllList" , agencyAllList);
		mav.addObject("opYear" , lastYear);
		mav.addObject("opMonth" , lastMonth);
		mav.addObject("thisYear", strYear);
		mav.addObject("thisMonth" , strMonth);
		mav.addObject("printAllBoseq" , printBoseq);
		mav.setViewName("management/jidae/jidaeList");
		return mav;
	}
	

	/** 
	 * 지국통지서 조회
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectJidaeDataView(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession(true);
		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		
		try{
			String boseq = param.getString("boseq");
			String opYear = param.getString("opYear");
			String opMonth = param.getString("opMonth");
			String yymm = opYear+opMonth;
			
			String printBoseq = "";
			String url = "";
			List<Object> agencyAllList = null;
			Map agencyListMap = null;
			
			// 달력***************************************************
			Calendar cal = Calendar.getInstance();
			int intYear =  cal.get(cal.YEAR);
			int intMonth = cal.get(cal.MONTH);
			String strYear = Integer.toString(intYear);
			String strMonth = Integer.toString(intMonth);
			//*********************************************************
			
			if(boseq.substring(0, 1).equals("5") && !boseq.substring(0, 2).equals("52")) {
				url = "management/jidae/jidaeListForDirect";
			} else {
				url ="management/jidae/jidaeList";
			}
			
			dbparam.put("boseq", boseq);
			dbparam.put("yymm", yymm);
			
			//로그인 아이디
			String userId = String.valueOf(session.getAttribute( SESSION_NAME_ADMIN_USERID) );
			dbparam.put("userId", userId);
			
			//영업담당여부체크
			String chkSellerYn = (String) generalDAO.queryForObject("management.jidae.chkSellerYn", dbparam);
			
			//관리자, 관리팀여부체크
			String chkAdminMngYn = (String) generalDAO.queryForObject("management.jidae.chkAdminMngYn", dbparam);
			
			//영업담당일때만 지국조회
			if("Y".equals(chkSellerYn)) { 
				//담당코드 가져오기
				String localCode = (String) generalDAO.queryForObject("management.jidae.selectLocalCodeBySeller", dbparam);
				
				dbparam.put("localCode", localCode);
				//지국목록
				agencyAllList = generalDAO.queryForList("reader.common.agencyListByLocalCode", dbparam);// 지국 목록 
				
				//전체지국 출력용
				for(int i=0;i<agencyAllList.size();i++) {
					agencyListMap = (Map)agencyAllList.get(i);
					printBoseq += agencyListMap.get("USERID")+",";
					agencyListMap = null;
				}
				
				if(printBoseq.length() > 1) {
					printBoseq = printBoseq.substring(0, printBoseq.length()-1);
				}
			} else if("Y".equals(chkAdminMngYn)){
				//지국목록
				agencyAllList = generalDAO.queryForList("reader.common.agencyListByAlive" );
				
				//전체지국 출력용
				for(int i=0;i<agencyAllList.size();i++) {
					agencyListMap = (Map)agencyAllList.get(i);
					printBoseq += agencyListMap.get("USERID")+",";
					agencyListMap = null;
				}
				
				if(printBoseq.length() > 1) {
					printBoseq = printBoseq.substring(0, printBoseq.length()-1);
				}
			}
			
			//정보조회
			Map jidaerData = (Map)generalDAO.queryForObject("management.jidae.selectJidaeNoticeByJikuk", dbparam);
			
			mav.addObject("now_menu", MENU_CODE_MANAGEMENT_JIDAE);
			mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("opYear" , opYear);
			mav.addObject("opMonth" , opMonth);
			mav.addObject("thisYear" , strYear);
			mav.addObject("thisMonth" , strMonth);
			mav.addObject("boseq" , boseq);
			mav.addObject("printAllBoseq" , printBoseq);
			mav.addObject("jidaerData" , jidaerData);
			mav.setViewName(url);
		} catch(Exception e){
			e.printStackTrace();
		}	
		return mav;
	}
	
	
	/** 
	 * 지국통지서 오즈출력
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ozJidaePrint(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		
		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		ModelAndView mav = new ModelAndView();
		
		try {
			String boseq = param.getString("boseq"); 
			String yymm = param.getString("opYear")+param.getString("opMonth");
			String printAllBoseq = param.getString("printAllBoseq");
			String ozType = "";
			
			//전체지국버튼클릭 여부확인
			if("".equals(printAllBoseq) || printAllBoseq == null) {
				dbparam.put("boseq", boseq);
			} else {
				dbparam.put("boseq", printAllBoseq);
				boseq = printAllBoseq;
			}
			dbparam.put("yymm", yymm);
			
			if(boseq.substring(0, 1).equals("5") && !boseq.substring(0, 2).equals("52")) {
				ozType = "/reader/jidaeNotice.ozr";
			} else if (boseq.substring(0, 1).equals("5") && boseq.substring(0, 2).equals("52")){
				//ozType ="/reader/jidaeNotice_store.ozr";
				ozType ="/reader/jidaeNotice2.ozr";
			} else {
				ozType ="/reader/jidaeNotice2.ozr";
			}
			
			mav.addObject("now_menu", MENU_CODE_MANAGEMENT_JIDAE);
			mav.addObject("boseq" , boseq);
			mav.addObject("yymm" , yymm);
			mav.addObject("ozType" , ozType);
			mav.addObject("printAllBoseq" , printAllBoseq);
			mav.setViewName("management/jidae/ozJidae");
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return mav;
	}
	
	
	/**
	 * 지대입력화면(2팀)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView jidaeUpload(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		
		mav.addObject("now_menu", MENU_CODE_MANAGEMENT_JIDAE);
		mav.setViewName("management/jidae/jidaeUpload");
		return mav;
	}
	 
	/**
	 * 지대입력화면(1팀)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView jidaeUploadForDirect(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		
		mav.addObject("now_menu", MENU_CODE_MANAGEMENT_JIDAE);
		mav.setViewName("management/jidae/jidaeUploadForDirect");
		return mav;
	}
	
	
	/**
	 * 지대 엑셀 업로드(1팀)
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView jidaeExcelUploadForDirect(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			MultipartHttpServletParam param = new MultipartHttpServletParam(request);
			MultipartFile readerfile = param.getMultipartFile("readerfile");
		    
//			int count=0;
//			String msg = "";
//		    String text = "";
//			String nLine = "\n";			// 라인변경
//			String ts = "\t";				// 탭여백
			
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			
			// ADMIN 권한인 경우
			if ( readerfile.isEmpty()) {	// 파일 첨부가 안되었으면 
				mav.setViewName("common/message");
				mav.addObject("message", "파일첨부가 되지 않았습니다.");
				mav.addObject("returnURL", "/management/jidae/jidaeUploadForDirect.do");
				return mav;
			}
			
			Calendar now = Calendar.getInstance();
			int year = now.get(Calendar.YEAR);
			
			FileUtil fileUtil = new FileUtil( getServletContext() );
			String strFile = fileUtil.saveUploadFile(
									readerfile, 
									PATH_PHYSICAL_HOME,
									PATH_UPLOAD_JIDAE + "/" + year
								);
			
			if ( StringUtils.isEmpty(strFile) ) {
				mav.setViewName("common/message");
				mav.addObject("message", "파일 저장이 실패하였습니다. ");
				mav.addObject("returnURL", "/management/jidae/jidaeUploadForDirect.do");
				return mav;
				
			// start 수금 생성
			}else{
				String fileName = PATH_PHYSICAL_HOME+PATH_UPLOAD_JIDAE + "/" + year+"/"+strFile;
				
				Workbook myWorkbook = Workbook.getWorkbook(new File(fileName)); // 파일을 읽어 와서...
			    Sheet mySheet = myWorkbook.getSheet(0);

		    	String type = "수도권1부";			// 지국구분
		    	String boseq= "";						// 지국번호
		    	String yymm = "";					// 월분
		    	String custom = "";					// 당월조정액
		    	String misu = "";						// 전월이월액
		    	String etcgrant = "";					// 기타장려금
		    	String edu = "";						// 교육용
		    	String card = "";						// 카드
		    	String autobill = "";					// 자동이체
		    	String stu = "";						// 학생배달
		    	String bank = "";						// 통장
		    	String giro = "";						// 지로
		    	String jRealamt = "";					// 당월실납입액
		    	String economy = "";				// 이코노미
		    	String city = "";						// 씨티 
		    	
		    	String temp1		= "";				//소외계층
		    	String temp2		= "";				//
		    	String temp3		= "";				//사원구독
		    	String temp4		= "";				//
		    	String temp5		= "";				//
		    	String temp6		= "";				//VAT

		    	System.out.println(mySheet.getRows()+"행");
		    	
			    for(int no=3 ; no < mySheet.getRows() ; no++){ // 행의 갯수 만큼 돌리고 
			    	// 셀별로 데이터 추출
			    	for(int i=0 ; i < mySheet.getColumns() ; i++){ 
			    		Cell myCell = mySheet.getCell(i, no);
			    		if(i == 0){	
			    			boseq = myCell.getContents().trim();			//지국코드
			    		}else if(i == 2){	
			    			yymm = myCell.getContents().trim();			//년월
			    		}else if(i == 3){	
			    			custom = myCell.getContents().trim();			//조정금액
			    		}else if(i == 4){	
			    			temp6 = myCell.getContents().trim();			//판매수수료
			    		}else if(i == 5){	
			    			etcgrant = myCell.getContents().trim();		//배달장려금
			    		}else if(i == 6){
			    			edu = myCell.getContents().trim();				//교육용
			    		}else if(i == 7){
			    			card = myCell.getContents().trim();				//카드
			    		}else if(i == 8){
			    			autobill = myCell.getContents().trim();			//자동이체
			    		}else if(i == 9){ 
			    			stu = myCell.getContents().trim();				//학생배달
			    		}else if(i == 10){
			    			temp1 = myCell.getContents().trim();			//소외계층
			    		}else if(i == 11){
			    			temp3 = myCell.getContents().trim();			//본사사원
			    		}else if(i == 12){
			    			bank = myCell.getContents().trim();				//통장
			    		}else if(i == 13){
			    			giro = myCell.getContents().trim();				//지로+바코드
			    		}else if(i == 14){
			    			jRealamt = myCell.getContents().trim();		//지대
			    		}else if(i == 15){
			    			economy = myCell.getContents().trim();		//이코노미
			    		}else if(i == 16){
			    			city = myCell.getContents().trim();				//씨티
			    		}else if(i == 17){
			    			misu = myCell.getContents().trim();				//미수
			    		}
			    	}

			    	dbparam.put("type", type);
			    	dbparam.put("boseq", boseq);
			    	dbparam.put("yymm", yymm);
			    	dbparam.put("custom", custom);
			    	dbparam.put("tmp6", temp6);
			    	dbparam.put("etcgrant", etcgrant);
			    	dbparam.put("edu", edu);
			    	dbparam.put("card", card);
			    	dbparam.put("autobill", autobill);
			    	dbparam.put("stu", stu);
			    	dbparam.put("tmp1", temp1);
			    	dbparam.put("tmp3", temp3);
			    	dbparam.put("bank", bank);
			    	dbparam.put("giro", giro);
			    	dbparam.put("jRealamt", jRealamt);
			    	dbparam.put("economy", economy);
			    	dbparam.put("city", city);
			    	dbparam.put("misu", misu);

			    	System.out.println("dbparam => "+dbparam);
			    	generalDAO.insert("management.jidae.insertJidaeNoticeDataForDirect", dbparam);
			    	
			    	System.out.println("지대통지서(1팀) 엑셀업로드 처리완료");

			    }
			    mav.setViewName("common/message");
				mav.addObject("message", "지대통지서(1팀) 엑셀업로드가 완료 되었습니다.");
				mav.addObject("returnURL", "/management/jidae/jidaeUploadForDirect.do");
			}
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
		}catch(Exception e){
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			mav.setViewName("common/message");
			mav.addObject("message",  "지대통지서(1팀) 엑셀업로드를실패하였습니다.");
			mav.addObject("returnURL", "/management/jidae/jidaeUploadForDirect.do");
		}finally{
			generalDAO.getSqlMapClient().endTransaction();
		}
		return mav;
	}
	
	
	/**
	 * 지대 엑셀 업로드(2팀)
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView JidaeExcelUpload(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		BillOutputController billOutput = new BillOutputController();
		
		try{
			MultipartHttpServletParam param = new MultipartHttpServletParam(request);
			MultipartFile readerfile = param.getMultipartFile("readerfile");
		    
//			int count=0;
//			String msg = "";
//		    String text = "";
//			String nLine = "\n";			// 라인변경
//			String ts = "\t";				// 탭여백
			
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			
			// ADMIN 권한인 경우
			if ( readerfile.isEmpty()) {	// 파일 첨부가 안되었으면 
				mav.setViewName("common/message");
				mav.addObject("message", "파일첨부가 되지 않았습니다.");
				mav.addObject("returnURL", "/management/jidae/jidaeUpload.do");
				return mav;
			}
			
			Calendar now = Calendar.getInstance();
			int year = now.get(Calendar.YEAR);
			
			FileUtil fileUtil = new FileUtil( getServletContext() );
			String strFile = fileUtil.saveUploadFile(
									readerfile, 
									PATH_PHYSICAL_HOME,
									PATH_UPLOAD_JIDAE + "/" + year
								);
			
			if ( StringUtils.isEmpty(strFile) ) {
				mav.setViewName("common/message");
				mav.addObject("message", "파일 저장이 실패하였습니다. ");
				mav.addObject("returnURL", "/management/jidae/jidaeUpload.do");
				return mav;
				
			// start 수금 생성
			}else{
				String fileName = PATH_PHYSICAL_HOME+PATH_UPLOAD_JIDAE + "/" + year+"/"+strFile;
				
				Workbook myWorkbook = Workbook.getWorkbook(new File(fileName)); // 파일을 읽어 와서...
			    Sheet mySheet = myWorkbook.getSheet(0);

		    	String type = "";						// 지국구분
		    	String boseq= "";						// 지국번호
		    	String yymm = "";					// 월분
		    	String misu = "";						// 전월이월액
		    	String custom = "";					// 당월조정액
		    	String busugrant = "";				// 부수유지장려금
		    	String stugrant = "";					// 학생장려금
		    	String etcgrant = "";					// 기타장려금
		    	String edu = "";						// 교육용
		    	String card = "";						// 카드
		    	String autobill = "";					// 자동이체
		    	String stu = "";						// 학생배달
		    	String subtotal = "";					// 소계
		    	String jRealamt = "";					// 당월실납입액
		    	String jOverdate = "";				// 납기후지대
		    	String jOkgrant1 = "";				// 완납장려금
		    	String jOkgrant2 = "";				// 완납장려금
		    	String jDuedate = "";				// 납기내지대
		    	String jPayamt = "";					// 당월지대납입액 
		    	String dMisu = "";					// 전월이월액
		    	String dHappen = "";				// 당월발생액
		    	String dMinus = "";					// 당월감소액
		    	String dBalance = "";				// 보증금잔액
		    	String temp1		= "";				//소외계층
		    	String temp2		= "";				//
		    	String temp3		= "";				//사원구독
		    	String temp4		= "";				//
		    	String temp5		= "";				//기타, 지로&바코드
		    	String temp6		= "";				//VAT
		    	String temp7		= ""; 		    	//보증금대체

		    	System.out.println(mySheet.getRows()+"행");
		    	
			    for(int no=0 ; no < mySheet.getRows() ; no++){ // 행의 갯수 만큼 돌리고 
			    	// 셀별로 데이터 추출
			    	for(int i=0 ; i < mySheet.getColumns() ; i++){ 
			    		Cell myCell = mySheet.getCell(i, no);
			    		if(i == 0){	
			    			boseq = myCell.getContents().trim();
			    		}else if(i == 1){	
			    			yymm = myCell.getContents().trim();
			    		}else if(i == 2){	
			    			if(boseq.substring(0, 2).equals("52")) {
			    				type = "관리부";
			    			} else {
			    				type = myCell.getContents().trim();
			    			}
			    		}else if(i == 3){	
			    			misu = myCell.getContents().trim();
			    		}else if(i == 4){	
			    			custom = myCell.getContents().trim();
			    		}else if(i == 5){	
			    			busugrant = myCell.getContents().trim();
			    		}else if(i == 6){
			    			stugrant = myCell.getContents().trim();
			    		}else if(i == 7){
			    			etcgrant = myCell.getContents().trim();
			    		}else if(i == 8){
			    			card = myCell.getContents().trim();
			    		}else if(i == 9){ 
			    			edu = myCell.getContents().trim();
			    		}else if(i == 10){
			    			autobill = myCell.getContents().trim();
			    		}else if(i == 11){
			    			stu = myCell.getContents().trim();
			    		}else if(i == 12){
			    			subtotal = myCell.getContents().trim();
			    		}else if(i == 13){
			    			jRealamt = myCell.getContents().trim();
			    		}else if(i == 14){
			    			jOverdate = myCell.getContents().trim();
			    		}else if(i == 15){
			    			jOkgrant1 = myCell.getContents().trim();
			    		}else if(i == 16){
			    			jOkgrant2 = myCell.getContents().trim();
			    		}else if(i == 17){
			    			jDuedate = myCell.getContents().trim();
			    		}else if(i == 18){
			    			jPayamt = myCell.getContents().trim();
			    		}else if(i == 19){
			    			dMisu = myCell.getContents().trim();
			    		}else if(i == 20){
			    			dHappen = myCell.getContents().trim();
			    		}else if(i == 21){
			    			dMinus = myCell.getContents().trim();
			    		}else if(i == 22){
			    			dBalance = myCell.getContents().trim();
			    		}else if(i == 23){
			    			temp1 = myCell.getContents().trim();
			    		}else if(i == 24){
			    			temp2 = myCell.getContents().trim();
			    		}else if(i == 25){
			    			temp3 = myCell.getContents().trim();
			    		}else if(i == 26){
			    			temp4 = myCell.getContents().trim();
			    		}else if(i == 27){
			    			temp5 = myCell.getContents().trim();
			    		}else if(i == 28){
			    			temp6 = myCell.getContents().trim();
			    		}else if(i == 29) {
			    			temp7 = myCell.getContents().trim();
			    		}
		    		
			    	}

			    	dbparam.put("type", type);
			    	dbparam.put("boseq", boseq);
			    	dbparam.put("yymm", yymm);
			    	dbparam.put("misu", misu);
			    	dbparam.put("custom", custom);
			    	dbparam.put("busugrant", busugrant);
			    	dbparam.put("stugrant", stugrant);
		    		dbparam.put("etcgrant", etcgrant);
			    	dbparam.put("edu", edu);
			    	dbparam.put("card", card);
			    	dbparam.put("autobill", autobill);
			    	dbparam.put("stu", stu);
			    	dbparam.put("subtotal", subtotal);
			    	dbparam.put("jRealamt", jRealamt);
			    	dbparam.put("jOverdate", jOverdate);
			    	dbparam.put("jOkgrant1", jOkgrant1);
			    	dbparam.put("jOkgrant2", jOkgrant2);
			    	dbparam.put("jDuedate", jDuedate);
			    	dbparam.put("jPayamt", jPayamt);
			    	dbparam.put("dMisu", dMisu);
			    	dbparam.put("dHappen", dHappen);
			    	dbparam.put("dMinus", dMinus);
			    	dbparam.put("dBalance",dBalance);
			    	dbparam.put("tmp1",temp1);
			    	dbparam.put("tmp2",temp2);
			    	dbparam.put("tmp3",temp3);
			    	dbparam.put("tmp4",temp4);
			    	dbparam.put("tmp5",temp5);
			    	dbparam.put("tmp6",temp6);
			    	dbparam.put("tmp7",temp7);

			    	System.out.println("dbparam => "+dbparam);
			    	generalDAO.insert("management.jidae.insertJidaeNoticeData", dbparam);
			    	
			    	System.out.println("지대통지서(2팀) 엑셀업로드 처리완료");

			    }
			    generalDAO.getSqlMapClient().getCurrentConnection().commit();
			    mav.setViewName("common/message");
				mav.addObject("message", "지대통지서(2팀) 엑셀업로드가 완료 되었습니다.");
				mav.addObject("returnURL", "/management/jidae/jidaeUpload.do");
			}
		}catch(Exception e){
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			mav.setViewName("common/message");
			mav.addObject("message",  "지대통지서(2팀) 엑셀업로드를실패하였습니다.");
			mav.addObject("returnURL", "/management/jidae/jidaeUpload.do");
		}finally{
			generalDAO.getSqlMapClient().endTransaction();
		}
		return mav;
	}
	
	
	
	/**
	 * 지대 이메일 전송
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView jidaeSendMail(HttpServletRequest request,HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		try {
			Param param = new HttpServletParam(request);
			HashMap dbparam = new HashMap();
			
			String year = StringUtil.notNull(param.getString("year"));
			String month = StringUtil.notNull(param.getString("month"));
			
			String area1 = param.getString("area1");
			String manager = param.getString("manager");
			String txt = param.getString("txt");
			String opName2 = param.getString("opName2");
			String agencyType = param.getString("agencyType");
			String agencyArea = param.getString("agencyArea");
			String part = param.getString("part");
			
			String lastJidaeYYMM = (String)generalDAO.queryForObject("management.jidae.getJidaeLastYymm", dbparam);
			String strYear = lastJidaeYYMM.substring(0,4);
			String strMonth = lastJidaeYYMM.substring(4,6);

			if(year.equals(""))
				year = strYear;
			if(month.equals(""))
				month = strMonth;
			
			dbparam.put("yymm",year + month);
			dbparam.put("area1", area1);
			dbparam.put("manager", manager);
			dbparam.put("txt", txt);
			dbparam.put("opName2", opName2);
			dbparam.put("agencyType", agencyType);
			dbparam.put("agencyArea", agencyArea);
			dbparam.put("part", part);
			dbparam.put("send_type","M");
			
			List<HashMap<String,String>> jidaeDataList = generalDAO.queryForList("management.jidae.searchJidaeNotice", dbparam);
			for(HashMap<String,String> m:jidaeDataList){
				if(!MailUtil.isEmail(m.get("JIKUK_EMAIL"))){
					m.put("ISEMAIL","N");
				}
			}
			
			logger.debug("===== management.adminManage.getCode");
			List areaCb = generalDAO.queryForList("management.adminManage.getCode" , "002");  // 부서 조회
			
			logger.debug("===== management.adminManage.getCode");
			List agencyTypeCb = generalDAO.queryForList("management.adminManage.getCode" , "017");  // 지국구분 조회
			
			logger.debug("===== management.adminManage.getCode");
			List partCb = generalDAO.queryForList("management.adminManage.getCode" , "018");  // 파트 조회
			
			logger.debug("===== management.adminManage.getCode");
			List agencyAreaCb = generalDAO.queryForList("management.adminManage.getCode" , "019");  // 지역 조회

			
			logger.debug("===== management.adminManage.getManager");
			List mngCb = generalDAO.queryForList("management.adminManage.getManager");  // 담당자 조회

			mav.addObject("areaCb", areaCb);
			mav.addObject("mngCb", mngCb);
			mav.addObject("agencyTypeCb", agencyTypeCb);
			mav.addObject("agencyAreaCb", agencyAreaCb);
			mav.addObject("partCb", partCb);
			

			mav.addObject("area1", area1);
			mav.addObject("manager", manager);
			mav.addObject("agencyType", agencyType);
			mav.addObject("part", part);
			mav.addObject("agencyArea", agencyArea);
			mav.addObject("txt", txt);
			mav.addObject("opName2", opName2);

			mav.addObject("year",year);
			mav.addObject("month",month);
			mav.addObject("jidaeDataList",jidaeDataList);
			mav.addObject("now_menu", MENU_CODE_MANAGEMENT_JIDAE);

			
		} catch (Exception e) {
			e.printStackTrace();
		}
		mav.setViewName("management/jidae/jidaeSendMail");
		return mav;
	}
	
	public ModelAndView excuteSendMail(HttpServletRequest request,HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		try {
			Param param = new HttpServletParam(request);
			HttpSession session = request.getSession(true);
			String userId = String.valueOf(session.getAttribute( SESSION_NAME_ADMIN_USERID));
			
			HashMap dbparam = new HashMap();
			
			String year = param.getString("year");
			String month = param.getString("month");
			String boseq = param.getString("boseq");
			
			dbparam.put("yymm",year + month);
			dbparam.put("boseq",boseq);
			
			List<HashMap<String,String>> jidaeDataList = generalDAO.queryForList("management.jidae.searchJidaeNotice", dbparam);
			
			String fileName = PATH_PHYSICAL_HOME + "/common/jidae_template.html";
			
			String template = FileUtils.readFileToString(new File(fileName), "UTF-8");
			String content = null;

			String title = "지대 납부금 통지서(" + year + "년 " + month + "월분)";
			String tempFile = PATH_PHYSICAL_HOME + "/temp/" + title + ".html";
			
			String defaultTitle = "[매일경제\b지대통보서]\f%s지국\b" + year + "년\b" + month + "월\b지대통보서를\b%s로\b발송했습니다";
			String messageTitle = null;
			String messageParam = null;
			int successCount = 0;
			int failCount = 0;
			for(HashMap<String,String> map:jidaeDataList){
				map.put("YEAR",year);
				map.put("MONTH",month);
				map.put("USERID",userId);
			}
//				if(!MailUtil.isEmail(map.get("JIKUK_EMAIL")))continue;
//				if(map.get("TMP1") != null && !map.get("TMP1").equals("")) map.put("TMP1NM","소외계층,NIE");
//				if(map.get("TMP2") != null && !map.get("TMP2").equals("")) map.put("TMP2NM","우편요금");
//				if(map.get("TMP3") != null && !map.get("TMP3").equals("")) map.put("TMP3NM","사원구독");
//				if(map.get("TMP4") != null && !map.get("TMP4").equals("")) map.put("TMP4NM","기타");
//				if(map.get("TMP5") != null && !map.get("TMP5").equals("")) map.put("TMP5NM","");
//				if(map.get("TMP6") != null && !map.get("TMP6").equals("")) map.put("TMP6NM","판매수수료(VAT)");
//				
//				if(map.get("JIDAE_BANK1") != null && !map.get("JIDAE_BANK1").equals("")) map.put("JIDAE_BANK1NM","농협");
//				if(map.get("JIDAE_BANK2") != null && !map.get("JIDAE_BANK2").equals("")) map.put("JIDAE_BANK2NM","우리은행");
//				if(map.get("JIDAE_BANK3") != null && !map.get("JIDAE_BANK3").equals("")) map.put("JIDAE_BANK3NM","국민은행");
//				if(map.get("JIDAE_BANK4") != null && !map.get("JIDAE_BANK4").equals("")) map.put("JIDAE_BANK4NM","우체국");
//
//				content = replaceField(template,"${boseqnm}",map.get("BOSEQNM"));
//				content = replaceField(content,"${boseqcode}",map.get("BOSEQCODE"));
//				content = replaceField(content,"${year}",(map.get("YYMM")).substring(0,4));
//				content = replaceField(content,"${month}",(map.get("YYMM")).substring(4,6));
//				content = replaceField(content,"${type}",map.get("TYPE"));
//				content = replaceField(content,"${agencynm}",map.get("AGENCYNM"));
//				content = replaceField(content,"${misu}",numberFormat(map.get("MISU")));
//				content = replaceField(content,"${custom}",numberFormat(map.get("CUSTOM")));
//				content = replaceField(content,"${busugrant}",numberFormat(map.get("BUSUGRANT")));
//				content = replaceField(content,"${tmp1nm}",map.get("TMP1NM"));
//				content = replaceField(content,"${tmp1}",numberFormat(map.get("TMP1")));
//				content = replaceField(content,"${stugrant}",numberFormat(map.get("STUGRANT")));
//				content = replaceField(content,"${tmp2nm}",map.get("TMP2NM"));
//				content = replaceField(content,"${tmp2}",numberFormat(map.get("TMP2")));
//				content = replaceField(content,"${etcgrant}",numberFormat(map.get("ETCGRANT")));
//				content = replaceField(content,"${tmp3nm}",map.get("TMP3NM"));
//				content = replaceField(content,"${tmp3}",numberFormat(map.get("TMP3")));
//				content = replaceField(content,"${card}",numberFormat(map.get("CARD")));
//				content = replaceField(content,"${tmp4nm}",map.get("TMP4NM"));
//				content = replaceField(content,"${tmp4}",numberFormat(map.get("TMP4")));
//				content = replaceField(content,"${edu}",numberFormat(map.get("EDU")));
//				content = replaceField(content,"${tmp5nm}",map.get("TMP5NM"));
//				content = replaceField(content,"${tmp5}",numberFormat(map.get("TMP5")));
//				content = replaceField(content,"${autobill}",numberFormat(map.get("AUTOBILL")));
//				content = replaceField(content,"${tmp6nm}",map.get("TMP6NM"));
//				content = replaceField(content,"${tmp6}",numberFormat(map.get("TMP6")));
//				content = replaceField(content,"${stu}",numberFormat(map.get("STU")));
//				content = replaceField(content,"${subtotal}",numberFormat(map.get("SUBTOTAL")));
//				content = replaceField(content,"${j_realamt}",numberFormat(map.get("J_REALAMT")));
//				content = replaceField(content,"${j_overdate}",numberFormat(map.get("J_OVERDATE")));
//				content = replaceField(content,"${j_okgrant1}",numberFormat(map.get("J_OKGRANT1")));
//				content = replaceField(content,"${j_okgrant2}",numberFormat(map.get("J_OKGRANT2")));
//				content = replaceField(content,"${j_duedate}",numberFormat(map.get("J_DUEDATE")));
//				content = replaceField(content,"${j_payamt}",numberFormat(map.get("J_PAYAMT")));
//				content = replaceField(content,"${d_misu}",numberFormat(map.get("D_MISU")));
//				content = replaceField(content,"${d_happen}",numberFormat(map.get("D_HAPPEN")));
//				content = replaceField(content,"${d_minus}",numberFormat(map.get("D_MINUS")));
//				content = replaceField(content,"${d_balance}",numberFormat(map.get("D_BALANCE")));
//				content = replaceField(content,"${jidae_bank1nm}",map.get("JIDAE_BANK1NM"));
//				content = replaceField(content,"${jidae_bank1}",map.get("JIDAE_BANK1"));
//				content = replaceField(content,"${jidae_bank2nm}",map.get("JIDAE_BANK2NM"));
//				content = replaceField(content,"${jidae_bank2}",map.get("JIDAE_BANK2"));
//				content = replaceField(content,"${jidae_bank3nm}",map.get("JIDAE_BANK3NM"));
//				content = replaceField(content,"${jidae_bank3}",map.get("JIDAE_BANK3"));
//				content = replaceField(content,"${jidae_bank4nm}",map.get("JIDAE_BANK4NM"));
//				content = replaceField(content,"${jidae_bank4}",map.get("JIDAE_BANK4"));
//				
//				FileUtils.writeStringToFile(new File(tempFile), content,"utf-8");
//				if(MailUtil.sendMail(map.get("JIKUK_EMAIL"), title, content, tempFile)){
//					dbparam.put("content",content);
//					dbparam.put("boseq",map.get("BOSEQCODE"));
//					dbparam.put("yymm",map.get("YYMM"));
//					dbparam.put("send_addr", map.get("JIKUK_EMAIL"));
//					dbparam.put("sender",userId);
//					dbparam.put("send_type","M");
//					generalDAO.insert("management.jidae.insertJidaeMailData", dbparam);
//					messageTitle = String.format(defaultTitle, map.get("BOSEQNM"),map.get("JIKUK_EMAIL"));
//					messageParam = "tel=" + map.get("NAME2") + "," + map.get("JIKUK_HANDY") + "," + messageTitle + ",0220002000";
//					sendSms(messageParam);
//					FileUtils.forceDeleteOnExit(new File(tempFile));
//					successCount++;
//				}else{
//					failCount++;
//				}
//			}
			JidaeMailingBatch.setJidaeMailingList(jidaeDataList);
			if(!JidaeMailingBatch.isRun){
				Thread t = new JidaeMailingBatch();
				t.start();
			}
			
			mav.addObject("message", "지대통보서 메일전송 예약이 완료되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			mav.addObject("message", "지대통보서 메일전송이 실패하였습니다.");
		}
		mav.addObject("now_menu", MENU_CODE_MANAGEMENT_JIDAE);
		mav.setViewName("common/message");
		mav.addObject("returnURL", "/management/jidae/jidaeSendMail.do");
		return mav;
	}
	
	
	/**
	 * 지대 메시지 전송
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView jidaeSendSms(HttpServletRequest request,HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		try {
			Param param = new HttpServletParam(request);
			HashMap dbparam = new HashMap();
			
			String year = StringUtil.notNull(param.getString("year"));
			String month = StringUtil.notNull(param.getString("month"));
			
			String area1 = param.getString("area1");
			String manager = param.getString("manager");
			String txt = param.getString("txt");
			String opName2 = param.getString("opName2");
			String agencyType = param.getString("agencyType");
			String agencyArea = param.getString("agencyArea");
			String part = param.getString("part");

			String lastJidaeYYMM = (String)generalDAO.queryForObject("management.jidae.getJidaeLastYymm", dbparam);
			String strYear = lastJidaeYYMM.substring(0,4);
			String strMonth = lastJidaeYYMM.substring(4,6);
			
			if(year.equals(""))
				year = strYear;
			if(month.equals(""))
				month = strMonth;
			
			dbparam.put("yymm",year + month);
			dbparam.put("area1", area1); 
			dbparam.put("manager", manager); 
			dbparam.put("txt", txt); 
			dbparam.put("opName2", opName2);
			dbparam.put("agencyType", agencyType); 
			dbparam.put("agencyArea", agencyArea);
			dbparam.put("part", part);
			dbparam.put("send_type","S");
			
			List<HashMap<String,String>> jidaeDataList = generalDAO.queryForList("management.jidae.searchJidaeNotice", dbparam);
			for(HashMap<String,String> m:jidaeDataList){
				if(!CommonUtil.checkPattern("phone", m.get("JIKUK_HANDY"))){
					m.put("ISHANDY","N");
				}
			}
			
			logger.debug("===== management.adminManage.getCode");
			List areaCb = generalDAO.queryForList("management.adminManage.getCode" , "002");  // 부서 조회
			
			logger.debug("===== management.adminManage.getCode");
			List agencyTypeCb = generalDAO.queryForList("management.adminManage.getCode" , "017");  // 지국구분 조회
			
			logger.debug("===== management.adminManage.getCode");
			List partCb = generalDAO.queryForList("management.adminManage.getCode" , "018");  // 파트 조회
			
			logger.debug("===== management.adminManage.getCode");
			List agencyAreaCb = generalDAO.queryForList("management.adminManage.getCode" , "019");  // 지역 조회

			
			logger.debug("===== management.adminManage.getManager");
			List mngCb = generalDAO.queryForList("management.adminManage.getManager");  // 담당자 조회

			mav.addObject("areaCb", areaCb);
			mav.addObject("mngCb", mngCb);
			mav.addObject("agencyTypeCb", agencyTypeCb);
			mav.addObject("agencyAreaCb", agencyAreaCb);
			mav.addObject("partCb", partCb);
			

			mav.addObject("area1", area1);
			mav.addObject("manager", manager);
			mav.addObject("agencyType", agencyType);
			mav.addObject("part", part);
			mav.addObject("agencyArea", agencyArea);
			mav.addObject("txt", txt);
			mav.addObject("opName2", opName2);

			mav.addObject("year",year);
			mav.addObject("month",month);
			mav.addObject("jidaeDataList",jidaeDataList);
			mav.addObject("now_menu", MENU_CODE_MANAGEMENT_JIDAE);

			
		} catch (Exception e) {
			e.printStackTrace();
		}
		mav.setViewName("management/jidae/jidaeSendSms");
		return mav;
	}
	
	
	public ModelAndView excuteSendSms(HttpServletRequest request,HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		try {
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			Param param = new HttpServletParam(request);
			HttpSession session = request.getSession(true);
			String userId = String.valueOf(session.getAttribute( SESSION_NAME_ADMIN_USERID) );
			
			HashMap dbparam = new HashMap();
			
			String year = param.getString("year");
			String month = param.getString("month");
			String boseq = param.getString("boseq");
			
			
			dbparam.put("yymm",year + month);
			dbparam.put("boseq",boseq);
			
			
			List<HashMap<String,String>> jidaeDataList = generalDAO.queryForList("management.jidae.searchJidaeNotice", dbparam);
			
			
			int successCount = 0;
			int failCount = 0;
			
			String jidaeDefaultUrl = getApplicationContext().getMessage("sms.jidae.url",null,Locale.getDefault());
			String shortUrl = null;
			String jidaeUrl = null;
			
			JsonObject jsonObject = null;
			
			JsonParser jsonParser = new JsonParser();
			JsonObject returnJson = null;
			
			String successMessage = "SMS가 발송되었습니다.";
			String message = null;
			
			String messageParam = null;
			JsonObject paramJson = null;
			String defaultTitle = "[매일경제\b지대통보서]\f%s지국\b" + year + "년\b" + month + "월\b지대통보서\f";
			String messageTitle = null;
			for(HashMap<String,String> map:jidaeDataList){
				paramJson = new JsonObject();
				paramJson.addProperty("boseq",map.get("BOSEQCODE"));
				paramJson.addProperty("yymm",year + month);
				messageTitle = String.format(defaultTitle, map.get("BOSEQNM"));
				jidaeUrl = jidaeDefaultUrl + "?key=" + SecurityUtil.encode(paramJson.toString());
				
				shortUrl = getShortUrlForNaver(jidaeUrl);
				if(shortUrl == null){
					failCount++;
				}else{
					List<NameValuePair> params = new ArrayList<NameValuePair>();
					params.add(new BasicNameValuePair("tel",map.get("NAME2") + "," + map.get("JIKUK_HANDY") + "," + messageTitle + shortUrl + ",0220002000"));
					message = ConnectionUtil.sendRequest(getApplicationContext().getMessage("sms.send.url",null,Locale.getDefault()),params,"EUC-KR");
					if(message.equals(successMessage)){
						dbparam.put("content",messageTitle + shortUrl);
						dbparam.put("boseq",map.get("BOSEQCODE"));
						dbparam.put("yymm",map.get("YYMM"));
						dbparam.put("send_addr", map.get("JIKUK_HANDY"));
						dbparam.put("sender",userId);
						dbparam.put("send_type","S");
						generalDAO.insert("management.jidae.insertJidaeMailData", dbparam);
						successCount++;
					}else{
						failCount++;
					}
				}
			}
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			mav.addObject("now_menu", MENU_CODE_MANAGEMENT_JIDAE);
			mav.setViewName("common/message");
			mav.addObject("message", "지대통보서 SMS전송이 완료되었습니다.\\r\\n성공 : " + successCount + "건\\r\\n실패 : " + failCount + "건");
			mav.addObject("returnURL", "/management/jidae/jidaeSendSms.do");
			
		} catch (Exception e) {
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			mav.setViewName("common/message");
			mav.addObject("message", "지대통보서 SMS전송이 실패하였습니다.");
			mav.addObject("returnURL", "/management/jidae/jidaeSendSms.do");
		}finally{
			generalDAO.getSqlMapClient().endTransaction();
		}
		return mav;
	}
	
	/**
	 * 지대 메일링 예약 건수 조회(AJAX)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ajaxJidaeMailingListInfo(HttpServletRequest request,HttpServletResponse response) throws Exception {
	
		ModelAndView mav = new ModelAndView();
		try{
			List<Map<String,String>> jidaeMailingList = JidaeMailingBatch.getJidaeMailingList();
			
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("jidaeMailingList", JSONArray.fromObject(jidaeMailingList));
			
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
	

	private String replaceField(String content,String str1,String str2){
		if(str2 == null){
			return StringUtils.replace(content, str1,"");
		}else{
			return StringUtils.replace(content, str1,str2);
		}
	}
	
	private String numberFormat(String num){
		if(num == null || num.equals(""))return "";
		int i = Integer.parseInt(num);
		NumberFormat formatter = NumberFormat.getNumberInstance();
		return formatter.format(i);
		
	}
	
	private String getShortUrlForGoogle(String longUrl){
		try {
			String shortenerKey = getApplicationContext().getMessage("sms.shortener.key",null,Locale.getDefault());
			String shortenerUrl = getApplicationContext().getMessage("sms.shortener.url",null,Locale.getDefault());
			
			JsonObject jsonObject = new JsonObject();
			jsonObject.addProperty("longUrl", longUrl);
			
			JsonParser jsonParser = new JsonParser();
			JsonObject returnJson = (JsonObject)jsonParser.parse(ConnectionUtil.sendRequest(shortenerUrl + shortenerKey, jsonObject.toString(),"application/json","UTF-8"));
			return returnJson.get("id").getAsString();
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	private String getShortUrlForNaver(String longUrl){
		try {
			String shortenerKey = getApplicationContext().getMessage("sms.shortener.key",null,Locale.getDefault());
			String shortenerUrl = getApplicationContext().getMessage("sms.shortener.url",null,Locale.getDefault());
			
			JsonParser jsonParser = new JsonParser();
			String result = ConnectionUtil.shortener(shortenerUrl + shortenerKey + "&url=" + longUrl,null);
			JsonObject returnJson = (JsonObject)jsonParser.parse(result);
			if(returnJson.get("message").getAsString().equals("ok")){
				return returnJson.get("result").getAsJsonObject().get("url").getAsString();
			}
			return null;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

}
