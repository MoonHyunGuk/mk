package com.mkreader.web.management;

import java.io.File;
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
import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.servlet.util.MultipartHttpServletParam;
import kr.reflexion.espresso.util.Param;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.DateUtil;
import com.mkreader.util.FileUtil;
import com.mkreader.web.output.BillOutputController;

public class AbcController extends MultiActionController implements
ISiteConstant, ICodeConstant {

	public static Logger logger = Logger.getRootLogger();
	
	private GeneralDAO generalDAO;
	
	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}
	
	/**
	 * 지국 리스트 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView insertABCReader(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		
		ModelAndView mav = new ModelAndView();
		
		mav.addObject("now_menu", MENU_CODE_MANAGEMENT_ABC);
		mav.setViewName("management/abc/insertReader");
		return mav;
	} 
	
	/**
	 * 수금 이력 생성
	 * 
	 * @category 수금이력 생성
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView insertABCReaderList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		System.out.println("insertABCReaderList start >>>");
		
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
			HashMap dbparam = new HashMap();
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			
			// ADMIN 권한인 경우
			if ( readerfile.isEmpty()) {	// 파일 첨부가 안되었으면 
				mav.setViewName("common/message");
				mav.addObject("message", "파일첨부가 되지 않았습니다.");
				mav.addObject("returnURL", "/etc/generateSugm/moveGenerateSugmPage.do");
				return mav;
			}
			
			Calendar now = Calendar.getInstance();
			int year = now.get(Calendar.YEAR);
			
			FileUtil fileUtil = new FileUtil( getServletContext() );
			String strFile = fileUtil.saveUploadFile(
									readerfile, 
									PATH_PHYSICAL_HOME,
									PATH_UPLOAD_ABC + "/" + year
								);
			
			if ( StringUtils.isEmpty(strFile) ) {
				mav.setViewName("common/message");
				mav.addObject("message", "파일 저장이 실패하였습니다. ");
				mav.addObject("returnURL", "/etc/generateSugm/moveGenerateSugmPage.do");
				return mav;
				
			// start 수금 생성
			}else{
				String fileName = PATH_PHYSICAL_HOME+PATH_UPLOAD_ABC + "/" + year+"/"+strFile;
				
				Workbook myWorkbook = Workbook.getWorkbook(new File(fileName)); // 파일을 읽어 와서...
			    Sheet mySheet = myWorkbook.getSheet(0);

		    	String readNo = "";				// 독자번호
		    	String readNm= "";				// 독자명
		    	String boseq = "";				// 지국번호
		    	String seq = "";					// 일렬번호
		    	String newsCd = "";				// 신문코드
		    	String newsNm = "";			// 신문명
		    	String sgtype = "";				// 수금방법코드
		    	String sgtypeNm = "";			// 수금방법코드
		    	String qty = "";					// 부수
		    	String uPrice = "";				// 단가
		    	String gno = "";					// 구역번호
		    	String bno = "";					// 배달순번
		    	String tel = "";						// 전화번호
		    	String[] telArray = null;			// 전화번호
		    	String mp = "";					// 핸드폰
		    	String[] mpArray = null;			// 핸드폰
		    	String zipcode = "";				// 우편번호
		    	String addr1 = "";				// 주소
		    	String addr2 = "";				// 상세주소
		    	String hjdt = "";					// 확장일
		    	String remk = "";					// 비고
		    	String stdt = "";					// 비고

		    	System.out.println(mySheet.getRows()+"행");
		    	
			    for(int no=1 ; no < mySheet.getRows() ; no++){ // 행의 갯수 만큼 돌리고 
			    	// 셀별로 데이터 추출
			    	for(int i=0 ; i < mySheet.getColumns() ; i++){ 
			    		Cell myCell = mySheet.getCell(i, no);
			    		if(i == 0){	// 구역번호
			    			gno = myCell.getContents();
			    		}else if(i == 1){	// 배달순번
			    			bno = myCell.getContents();
			    		}else if(i == 2){	// 독자번호
			    			readNo = myCell.getContents();
			    		}else if(i == 3){	// 독자명
			    			readNm = myCell.getContents();
			    		}else if(i == 4){	// 전화번호
			    			tel = myCell.getContents();
			    			telArray = tel.split("-");
			    		}else if(i == 5){	// 핸드폰
			    			mp = myCell.getContents();
			    			mpArray = mp.split("-");
			    		}else if(i == 6){
			    			zipcode = myCell.getContents();
			    		}else if(i == 7){
			    			addr1 = myCell.getContents();
			    		}else if(i == 8){
			    			addr2 = myCell.getContents();
			    		}else if(i == 9){
			    			newsNm = myCell.getContents();
			    			//신문코드 조회
			    			System.out.println("newsNm = "+newsNm);
			    			dbparam.put("newsNm", newsNm);
			    			newsCd = (String)generalDAO.queryForObject("management.abcManage.selectNewsCode", dbparam);
			    			System.out.println("newsCd = "+newsCd);
			    		}else if(i == 10){
			    			hjdt = myCell.getContents();
			    			if(Integer.parseInt(hjdt.substring(0, 4)) < 2009) {
			    				hjdt = "2009"+hjdt.substring(4, 8);
			    			} 
			    			System.out.println("hjdt = "+hjdt);
			    		}else if(i == 11){
			    			qty = myCell.getContents();
			    		}else if(i == 12){
			    			uPrice = myCell.getContents();
			    		}else if(i == 13){
			    			sgtypeNm = myCell.getContents();
			    			dbparam.put("sgtypeNm", sgtypeNm);
			    			sgtype = (String)generalDAO.queryForObject("management.abcManage.selectSugmCode", dbparam);
			    			System.out.println("sgtype = "+sgtype);
			    		}else if(i == 14){
			    			boseq = myCell.getContents();
			    		}else if(i == 15){
			    			remk = myCell.getContents();
			    		}else if(i == 16){
			    			stdt = myCell.getContents();
			    		}
		    		
			    	}

			    	dbparam.put("gno", gno);
			    	dbparam.put("bno", bno);
			    	dbparam.put("readNo", readNo);
			    	dbparam.put("readNm", readNm);
			    	if(tel.length() > 5) {
				    	dbparam.put("tel1", telArray[0]);
				    	dbparam.put("tel2", telArray[1]);
				    	dbparam.put("tel3", telArray[2]);
			    	} else  {
			    		dbparam.put("tel1", "");
				    	dbparam.put("tel2", "");
				    	dbparam.put("tel3", "");
			    	}
			    	if(mp.length() > 5) {
				    	dbparam.put("mp1", mpArray[0]);
				    	dbparam.put("mp2", mpArray[1]);
				    	dbparam.put("mp3", mpArray[2]);
			    	} else {
			    		dbparam.put("mp1", "");
				    	dbparam.put("mp2", "");
				    	dbparam.put("mp3", "");
			    	}
			    	dbparam.put("zipcode", zipcode);
			    	dbparam.put("addr1", addr1);
			    	dbparam.put("addr2", addr2);
			    	dbparam.put("newsCd", newsCd);
			    	dbparam.put("hjdt", hjdt);
			    	dbparam.put("qty", qty);
			    	dbparam.put("uPrice", uPrice);
			    	dbparam.put("sgtype", sgtype);
			    	dbparam.put("remk", remk);
			    	dbparam.put("boseq", boseq);
			    	dbparam.put("stdt", stdt);
			    	
			    	System.out.println("readnm= "+readNm);
			    	
			    	generalDAO.insert("management.abcManage.inserTmreaderNews", dbparam);
			    	
			    	System.out.println(dbparam.get("readNo")+" 처리완료");

			    }
			    mav.setViewName("common/message");
				mav.addObject("message", "독자 생성이 완료 되었습니다.");
				mav.addObject("returnURL", "/management/abc/insertABCReader.do");
			}
		}catch(Exception e){
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			mav.setViewName("common/message");
			mav.addObject("message",  "독자 생성을 실패하였습니다.");
			mav.addObject("returnURL", "/management/abc/insertABCReader.do");
		}finally{
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			generalDAO.getSqlMapClient().endTransaction();
		}
		return mav;
	}
	
	
	/**
	 * 중지독자 화면
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView stopReader(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HashMap dbparam = new HashMap();
		
		List<Object> agencyAllList = null;
		List<Object> sugmTypeList = null;
		agencyAllList = generalDAO.queryForList("reader.common.agencyListByAlive", dbparam);// 지국 목록 
		//sugmTypeList = generalDAO.queryForList("common.getSugmTypeList", dbparam);// 수금방법리스트
		
		mav.addObject("agencyAllList" , agencyAllList);
		mav.addObject("sugmTypeList" , sugmTypeList);
		mav.setViewName("management/abc/stopReader");
		return mav;
	} 
	
	/**
	 * 중지독자 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectStopReader(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HashMap dbparam = new HashMap();
		
		List<Object> agencyAllList = null;
		List<Object> sugmTypeList = null;
		List<Object> stopReaderList = null;
		List<Object> getSugmReaderList = null;
		
		
		String stopBoseq = param.getString("stopBoseq");
		String abcBoseq = param.getString("abcBoseq");
		String sgTypeList = param.getString("sgTypeList");
		String[] arrySgType = sgTypeList.split(",");
		
		agencyAllList = generalDAO.queryForList("reader.common.agencyListByAlive", dbparam);// 지국 목록 
		sugmTypeList = generalDAO.queryForList("common.getSugmTypeList", dbparam);// 수금방법리스트
		
		dbparam.put("stopBoseq", stopBoseq);
		dbparam.put("sgTypeList", sgTypeList);
		dbparam.put("abcBoseq", abcBoseq);
		
		System.out.println("sgTypeList = "+sgTypeList);
		System.out.println("arrySgType = "+arrySgType[0]);
		
		getSugmReaderList 	= generalDAO.queryForList("management.abcManage.selectGetSugmReaderList",  dbparam);	// 수금가져올독자 리스트
		
		int sugmReaderCnt = getSugmReaderList.size();
		
		dbparam.put("maxRow", sugmReaderCnt);
		stopReaderList 		= generalDAO.queryForList("management.abcManage.selectABCReaderListFromAbcJikuk",  dbparam);	//  독자 리스트
		
		int stopReaderCnt = stopReaderList.size();
		
		Map mapStopReader = null; 
		String arryStopReaderNo ="";
		
		for(int i=0;i<stopReaderList.size();i++) {
			mapStopReader = (Map)stopReaderList.get(i);
			//printBoseq += "'"+agencyListMap.get("USERID")+"',";
			arryStopReaderNo += mapStopReader.get("READNO")+",";
			mapStopReader = null;
		}
		
		if(arryStopReaderNo.length() > 1) {
			arryStopReaderNo = arryStopReaderNo.substring(0, arryStopReaderNo.length()-1);
		}
		
		mav.addObject("agencyAllList" , agencyAllList);
		mav.addObject("sugmTypeList" , sugmTypeList);
		mav.addObject("stopBoseq" , stopBoseq);
		mav.addObject("abcBoseq" , abcBoseq);
		mav.addObject("sgTypeList" , sgTypeList);
		mav.addObject("arrySgType", arrySgType);
		mav.addObject("getSugmReaderList", getSugmReaderList);
		mav.addObject("stopReaderList", stopReaderList);
		mav.addObject("sugmReaderCnt", sugmReaderCnt);
		mav.addObject("stopReaderCnt", stopReaderCnt);
		mav.addObject("arryStopReaderNo", arryStopReaderNo);
		mav.setViewName("management/abc/stopReader");
		return mav;
	}
	
	
	/**
	 * 수금정보 이동
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView exportSugmData(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		 
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HashMap dbparam = new HashMap();
		
		List<Object> agencyAllList = null;
		List<Object> stopReaderList = null;
		
		//수금가져올 독자수
		String sugmReaderCnt = request.getParameter("sugmReaderCnt");
		//체크된 독자수
		String selectedCnt = request.getParameter("selectedCnt");
		//체크된 독자번호
		String selectedReadeNoList = request.getParameter("readnoList");
		
		String stopBoseq = param.getString("stopBoseq");
		String abcBoseq = param.getString("abcBoseq");
		String sgTypeList = param.getString("sgTypeList");
		
		int rowCnt = Integer.parseInt(selectedCnt);
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
		
			String[] arrySugmReader = new String[Integer.parseInt(sugmReaderCnt)];
			
			arrySugmReader = selectedReadeNoList.split(",");
			
			agencyAllList = generalDAO.queryForList("reader.common.agencyListByAlive", dbparam);// 지국 목록 

			/*
			System.out.println("sugmReaderCnt = "+sugmReaderCnt);
			System.out.println("stopReaderCnt = "+stopReaderCnt);
			System.out.println("selectedCnt = "+selectedCnt);
			System.out.println("selectedReadeNoList = "+selectedReadeNoList);
			System.out.println("rowCnt = "+rowCnt);
			*/
			
			String sugmReaderNo = "";
			String abcReaderNo = "";
			for(int up=0;up<rowCnt;up++) {
				sugmReaderNo= arrySugmReader[up];
				
				//System.out.println("uptSugmReaderNo = "+uptSugmReaderNo);
				//System.out.println("uptStopReaderNo = "+uptStopReaderNo);
				
				dbparam.put("stopBoseq", stopBoseq);
				dbparam.put("abcBoseq", abcBoseq); 
				dbparam.put("sugmReaderNo", sugmReaderNo);		//수금가져올독자
				
				System.out.println("export sugm=========================>"+up);
				System.out.println("stopBoseq = "+stopBoseq);
				System.out.println("abcBoseq = "+abcBoseq);
				System.out.println("sugmReaderNo = "+sugmReaderNo);
				
				//독자정보 업데이트
				generalDAO.update("management.abcManage.updateAbcReaderDataFromSugmReader", dbparam);
				//수금정도 업데이트
				generalDAO.update("management.abcManage.updateAbcReaderSugmFromSugmReader", dbparam);
				
				stopReaderList 		= generalDAO.queryForList("management.abcManage.selectABCReaderListFromAbcJikuk",  dbparam);	//  독자 리스트
			}
			
		} catch(Exception e) {
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			mav.setViewName("common/message");
			mav.addObject("message",  "수금 이동을 실패하였습니다.");
			mav.addObject("returnURL", "/management/abc/stopReader.do");
		} finally {
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			generalDAO.getSqlMapClient().endTransaction();
		}
		
		mav.addObject("stopBoseq",stopBoseq);
		mav.addObject("abcBoseq",abcBoseq);
		mav.addObject("agencyAllList", agencyAllList);
		mav.addObject("stopReaderList",stopReaderList); 
		mav.setViewName("management/abc/stopReader");
		return mav;
	}
	
	
	/**
	 * 중지독자 화면
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView restorationReader(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		try {
			HashMap dbparam = new HashMap();
			String boseq = param.getString("boseq");
			String readnm = param.getString("readnm");
			String sgtype = param.getString("sgtype");
			String readertype = param.getString("readertype");
			if(readertype.equals(""))readertype = "2";
			
			String minqty = param.getString("minqty");
			String maxqty = param.getString("maxqty");
			
			Calendar startCal = Calendar.getInstance();
			Calendar endCal = Calendar.getInstance();
			startCal.set(startCal.get(Calendar.YEAR) -2,11,1);
			String startYYMM = DateUtil.getDateFormat(startCal.getTime(),"yyyyMM");
			String endYYMM = DateUtil.getDateFormat(endCal.getTime(),"yyyyMM");
			
			List<String> yymmList = new ArrayList<String>();
			int index = 0;
			while(true){
				startCal.add(Calendar.MONTH, index);
				if(index == 0)index = 1;
				yymmList.add(DateUtil.getDateFormat(startCal.getTime(),"yyyyMM"));
				if(DateUtil.getDateFormat(startCal.getTime(),"yyyyMM").equals(DateUtil.getDateFormat(endCal.getTime(),"yyyyMM")))
					break;
			}

			dbparam.put("boseq",boseq);
			dbparam.put("readnm",readnm);
			dbparam.put("sgtype",sgtype);
			dbparam.put("readertype",readertype);
			dbparam.put("minqty", minqty);
			dbparam.put("maxqty", maxqty);
			dbparam.put("startYYMM",startYYMM);
			dbparam.put("endYYMM", endYYMM);
			
			List<HashMap<String,String>> readerList = new ArrayList<HashMap<String,String>>();
			if(!boseq.equals("")){
				readerList = generalDAO.queryForList("management.abcManage.restorationReaderList", dbparam);// 독자목록
			}
			
			
			mav.addObject("boseq",boseq);
			mav.addObject("readnm",readnm);
			mav.addObject("sgtype",sgtype);
			mav.addObject("readertype",readertype);
			mav.addObject("readerList",readerList);
			mav.addObject("minqty",minqty);
			mav.addObject("maxqty",maxqty);
			mav.addObject("yymmList",yymmList);
			mav.setViewName("management/abc/restorationReader");
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mav;
	}
	
	public ModelAndView getReaderInfo(HttpServletRequest request,HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		JSONObject jsonObject = new JSONObject();
		try {
			HashMap dbparam = new HashMap();
			String readno = param.getString("readno");
			String seq = param.getString("seq");
			String boseq = param.getString("boseq");
			String newscd = param.getString("newscd");
			
			Calendar startCal = Calendar.getInstance();
			Calendar endCal = Calendar.getInstance();
			startCal.set(startCal.get(Calendar.YEAR) -2,11,1);
			String startYYMM = DateUtil.getDateFormat(startCal.getTime(),"yyyyMM");
			String endYYMM = DateUtil.getDateFormat(endCal.getTime(),"yyyyMM");
			
			dbparam.put("readno", readno);
			dbparam.put("seq", seq);
			dbparam.put("boseq",boseq);
			dbparam.put("newscd",newscd);
			dbparam.put("startYYMM",startYYMM);
			dbparam.put("endYYMM", endYYMM);
			
			HashMap<String,String> readerInfo = (HashMap<String,String>)generalDAO.queryForObject("management.abcManage.getReaderInfo",dbparam);
			
			List<HashMap<String,String>> sugmList = generalDAO.queryForList("management.abcManage.getReaderSugmList",dbparam);
			JSONArray sugmArray = JSONArray.fromObject(sugmList);
			
			jsonObject = JSONObject.fromObject(readerInfo);
			jsonObject.put("SUGMLIST",sugmArray);
			
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public ModelAndView updateReaderInfo(HttpServletRequest request,HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("result",false);
		try {
			generalDAO.getSqlMapClient().startTransaction();					
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			HashMap dbparam = new HashMap();
			String readno = param.getString("readno");
			String seq = param.getString("seq");
			String readnm = param.getString("readnm");
			String hjdt = param.getString("hjdt");
			String sgbgmm = param.getString("sgbgmm");
			String qty = param.getString("qty");
			String uprice = param.getString("uprice");
			String stdt = param.getString("stdt");
			String newaddr = param.getString("newaddr");
			String dlvzip = param.getString("dlvzip");
			String dlvadrs1 = param.getString("dlvadrs1");
			String dlvadrs2 = param.getString("dlvadrs2");
			String boseq = param.getString("boseq");
			String newscd = param.getString("newscd");
			String sgtype = param.getString("sgtype");
			String sugmList = param.getString("sugmList");
			String stsayou = param.getString("stsayou");
			String readtypecd = param.getString("readtypecd");
			String gno = param.getString("gno");
			String bno = param.getString("bno");
			String sno = param.getString("sno");
			String hometel1 = param.getString("hometel1");
			String hometel2 = param.getString("hometel2");
			String hometel3 = param.getString("hometel3");
			
			String mobile1 = param.getString("mobile1");
			String mobile2 = param.getString("mobile2");
			String mobile3 = param.getString("mobile3");
			
			dbparam.put("readno", readno);
			dbparam.put("seq", seq);
			dbparam.put("readnm",readnm);
			dbparam.put("hjdt", hjdt);
			dbparam.put("sgbgmm", sgbgmm);
			dbparam.put("qty", qty);
			dbparam.put("uprice", uprice);
			dbparam.put("stdt", stdt);
			dbparam.put("stsayou", stsayou);
			dbparam.put("newaddr", newaddr);
			dbparam.put("dlvzip", dlvzip);
			dbparam.put("dlvadrs1", dlvadrs1);
			dbparam.put("dlvadrs2", dlvadrs2);
			dbparam.put("boseq",boseq);
			dbparam.put("newscd",newscd);
			dbparam.put("sgtype", sgtype);
			dbparam.put("readtypecd",readtypecd);
			dbparam.put("gno", gno);
			dbparam.put("bno",bno);
			dbparam.put("sno",sno);
			dbparam.put("stsayou", stsayou);
			dbparam.put("hometel1", hometel1);
			dbparam.put("hometel2", hometel2);
			dbparam.put("hometel3", hometel3);
			
			dbparam.put("mobile1", mobile1);
			dbparam.put("mobile2", mobile2);
			dbparam.put("mobile3", mobile3);
			
			
			generalDAO.update("management.abcManage.updateReaderInfo",dbparam);
			
			sugmList = StringEscapeUtils.unescapeJava(sugmList);
			sugmList = sugmList.substring(1,sugmList.length()-1);
			
			JsonParser parser = new JsonParser();
		    JsonArray array = parser.parse(sugmList).getAsJsonArray();
		    JsonObject json = null;
		    String sgbbcd = null;
		    String cldt = null;
		    for(int i=0;i<array.size();i++){
		    	json = array.get(i).getAsJsonObject();
		    	sgbbcd = json.get("sgbbcd").getAsString();
		    	cldt =  StringUtils.trim(json.get("cldt").getAsString());
		    	if(sgbbcd.equals(""))continue;
		    	dbparam.put("sgbbcd", sgbbcd);
		    	dbparam.put("cldt", cldt);
		    	dbparam.put("billamt", json.get("billamt").getAsString());
		    	dbparam.put("amt",json.get("amt").getAsString());
		    	dbparam.put("billqty",json.get("billqty").getAsString());
		    	dbparam.put("yymm", json.get("yymm").getAsString());
		    	dbparam.put("sgyymm","");
		    	if(!cldt.equals("")){
		    		dbparam.put("sgyymm",cldt.substring(0,6));
		    	}
		    	HashMap<String,String> map = (HashMap<String,String>)generalDAO.queryForObject("management.abcManage.getSugmInfo", dbparam);
		    	if(map != null){
			    	generalDAO.update("management.abcManage.updateSugmInfo",dbparam);
		    	}else{
		    		generalDAO.insert("management.abcManage.insertSugmInfo",dbparam);
		    	}

		    }
		    jsonObject.put("result",true);
		    
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
		}finally{
			generalDAO.getSqlMapClient().endTransaction();
		}
		return null;
	}
	
	/**
	 * 통계관리 화면
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView statisticsManage(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		try {
			
			Calendar startCal = Calendar.getInstance();
			Calendar endCal = Calendar.getInstance();
			startCal.set(startCal.get(Calendar.YEAR) -2,1,1);
			List<String> yymmList = new ArrayList<String>();
			while(true){
				yymmList.add(DateUtil.getDateFormat(startCal.getTime(),"yyyyMM"));
				startCal.add(Calendar.MONTH, 1);
				if(DateUtil.getDateFormat(startCal.getTime(),"yyyyMM").equals(DateUtil.getDateFormat(endCal.getTime(),"yyyyMM")))
					break;
			}
			
			HashMap dbparam = new HashMap();
			mav.addObject("yymmList",yymmList);
			mav.setViewName("management/abc/statisticsManage");
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mav;
	}
	
	/**
	 * 수금월별 통계 삭제
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView insertStatistics(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("result",false);
		Param param = new HttpServletParam(request);
		try {
			String boseq = param.getString("boseq");
			String yymm = param.getString("yymm");
			HashMap dbparam = new HashMap();
			dbparam.put("boseq",boseq);
			Calendar cal = Calendar.getInstance();
			cal.set(Calendar.YEAR,Integer.parseInt(yymm.substring(0,4)));
			cal.set(Calendar.MONTH,Integer.parseInt(yymm.substring(4,6))-2);
			dbparam.put("yymm",DateUtil.getDateFormat(cal.getTime(),"yyyyMM"));
			int deleteStatistics = generalDAO.delete("management.abcManage.deleteStatistics",dbparam);
			dbparam.put("yymm",yymm);
			String message = (String)generalDAO.queryForObject("management.abcManage.insertStatistics",dbparam);
			if(message.indexOf("SUCCESS") > -1)
				jsonObject.put("result",true);
		} catch (Exception e) {
			e.printStackTrace();
		}
		//jsp로 값을 보낸다.
		response.setContentType( "text/xml; charset=UTF-8" );
		response.getWriter().print(jsonObject);
		return null;
	}
	
	public ModelAndView deleteReaderInfo(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("result",false);
		Param param = new HttpServletParam(request);
		try {
			String boseq = param.getString("boseq");
			String readno = param.getString("readno");
			String seq = param.getString("seq");
			HashMap dbparam = new HashMap();
			dbparam.put("boseq",boseq);
			dbparam.put("readno",readno);
			dbparam.put("seq",seq);
			
			generalDAO.delete("management.abcManage.deleteReaderSugm",dbparam);
			generalDAO.delete("management.abcManage.deleteReaderInfo",dbparam);
			jsonObject.put("result",true);
		} catch (Exception e) {
			e.printStackTrace();
		}
		//jsp로 값을 보낸다.
		response.setContentType( "text/xml; charset=UTF-8" );
		response.getWriter().print(jsonObject);
		return null;
	}
	
	
	/**
	 * 데이터싱크 화면
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView dataSync(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HashMap dbparam = new HashMap();
		
		List<Object> agencyAllList = null;
		List<Object>dbTableList = null;
		
		String abcBoseq = param.getString("abcBoseq");
		
		System.out.println("abcBoseq = "+abcBoseq);
		
		dbparam.put("abcBoseq", abcBoseq);
		
		agencyAllList = generalDAO.queryForList("reader.common.agencyListByAlive", dbparam);// 지국 목록
		dbTableList = generalDAO.queryForList("management.abcManage.selectDBTableList", dbparam); // 테이블 리스트
		
		//독자수 카운트
		int readerCnt = (Integer)generalDAO.queryForObject("management.abcManage.selectReaderTotCnt", dbparam);
		//수금수 카운트
		int readerSugmCnt = (Integer)generalDAO.queryForObject("management.abcManage.selectReaderSugmTotCnt", dbparam);
		
		mav.addObject("abcBoseq" , abcBoseq);
		mav.addObject("readerCnt" , readerCnt);
		mav.addObject("readerSugmCnt" , readerSugmCnt);
		mav.addObject("agencyAllList" , agencyAllList);
		mav.addObject("dbTableList" , dbTableList);
		
		mav.setViewName("management/abc/dataSync");
		return mav;
	}
	
	/**
	 * 데이터싱크 화면
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView tableBackup(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HashMap dbparam = new HashMap();
		
		String backupTableNm = param.getString("backupTableNm");
		
		System.out.println("backupTableNm = "+backupTableNm);
		
		dbparam.put("backupTableNm", "TM_READER_NEWS_"+backupTableNm);
		dbparam.put("backupSugmTableNm", "TM_READER_SUGM_"+backupTableNm);
		
		try {
			generalDAO.getSqlMapClient().startTransaction();					
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			//news table 생성
			generalDAO.update("management.abcManage.createReaderNewsTable", dbparam);
			
			//sugm table 생성
			generalDAO.update("management.abcManage.createReaderSugmTable", dbparam);
		} catch (Exception e) {
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			generalDAO.getSqlMapClient().endTransaction();
		}
	
		mav.addObject("returnURL", "/management/abc/dataSync.do");
		return mav;
	}
	
	
	/**
	 * 데이터 삭제
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView tableDataDelete(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HashMap dbparam = new HashMap();
		
		String abcBoseq = param.getString("abcBoseq");
		
		System.out.println("abcBoseq(데이터삭제) = "+abcBoseq);
		
		dbparam.put("abcBoseq", abcBoseq);
		
		try {
			generalDAO.getSqlMapClient().startTransaction();					
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			//news table 데이터삭제
			generalDAO.delete("management.abcManage.deleteNewsTableData", dbparam);
			//sugm table 데이터삭제
			generalDAO.delete("management.abcManage.deleteSugmTableData", dbparam);
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			mav.setViewName("common/message");
			mav.addObject("message", "데이터 삭제가 완료 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			mav.setViewName("common/message");
			mav.addObject("message", "데이터 삭제가 실패되었습니다.");
		} finally {
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			generalDAO.getSqlMapClient().endTransaction();
		}
		
		mav.addObject("returnURL", "/management/abc/dataSync.do?abcBoseq="+abcBoseq);
		return mav;
	}
	
	/**
	 * 데이터 동기화
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView tableDataSync(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HashMap dbparam = new HashMap();
		
		String abcBoseq = param.getString("abcBoseq");
		
		System.out.println("abcBoseq(데이터동기화) = "+abcBoseq);
		
		dbparam.put("abcBoseq", abcBoseq);
		
		try {
			generalDAO.getSqlMapClient().startTransaction();					
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			//news table 데이터 동기화
			generalDAO.insert("management.abcManage.syncNewsTableData", dbparam);
			//sugm table 데이터 동기화
			generalDAO.insert("management.abcManage.syncSugmTableData", dbparam);
			
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			mav.setViewName("common/message");
			mav.addObject("message", "데이터 동기화가 완료 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			mav.setViewName("common/message");
			mav.addObject("message", "데이터 동기화가 실패되었습니다.");
		} finally {
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			generalDAO.getSqlMapClient().endTransaction();
		}
		
		mav.addObject("returnURL", "/management/abc/dataSync.do?abcBoseq="+abcBoseq);
		return mav;
	}
	
	/**
	 * 데이터 동기화
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView statisticsInfo(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		//월분 
				Calendar rightNow = Calendar.getInstance();
				int day = rightNow.get(Calendar.DAY_OF_MONTH);
				if( day > 20 ){
					rightNow.add(2, 0);
				}else{
					rightNow.add(2, -1);
				}
				String year = String.valueOf(rightNow.get(Calendar.YEAR));
				String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
				if (month.length() < 2)
					month = "0" + month;
				
				// param
				Param param = new HttpServletParam(request);
				
				//월분
				String yymm = param.getString("yymm", year + month);
				
				
				String year2 = yymm.substring(0,4);
				String month2 = String.valueOf(Integer.parseInt(yymm.substring(4,6) )+ 1);
				String day2;
				if(yymm.equals(year + month) && day > 21){
					month2 = String.valueOf(Integer.parseInt(yymm.substring(4,6) ));
					day2 = String.valueOf(day);
				}else{
					day2 = "20";
				}
				if(month2.equals("13")){
					month2 = "1";
					 year2 = String.valueOf(Integer.parseInt(year2)+1);
				}
				if (month2.length() < 2) {
					month2 = "0" + month2;
				}

				String yymm2 = year2 + month2;
						
				//뉴스코드(최초에 매일경제값셋팅)
				String newsCd[] = param.getStringValues("newsCd",MK_NEWSPAPER_CODE);
				if(newsCd.length == 0) newsCd = new String[] {MK_NEWSPAPER_CODE};  // 최초 매일경제값 세팅(param.getStringValues 가 제대로 안되서 추가)
				
				
				if( yymm.length() != 6 ) {
					ModelAndView mav = new ModelAndView();
					mav.setViewName("common/message");
					mav.addObject("message", "월분을 확인 해 주세요.");
					mav.addObject("returnURL", "/management/abc/statisticsInfo.do");
					return mav;
				}
				
				
				String boseq = param.getString("boseq");
				
				// db query parameter
				HashMap dbparam = new HashMap();
				dbparam.put("BOSEQ",boseq);
				dbparam.put("USEYN","Y");
				dbparam.put("CDCLSF",MK_NEWSPAPER_CODE);
				
				//신문명리스트
				List newsCodeList = new ArrayList<HashMap<String,String>>();
				newsCodeList.add("");
				
				newsCodeList = generalDAO.queryForList("statistics.stats.getNewsCodeList", dbparam);
				
				// db query parameter
				dbparam = new HashMap();
				dbparam.put("YYMM",yymm);
				dbparam.put("NEWSCD",newsCd);
				dbparam.put("BOSEQ",boseq);
				dbparam.put("TYPE","peruse");
				
				// excute query(기준에 따라 나눈다.)
				List resultList =  generalDAO.queryForList("statistics.stats.getStateList", dbparam);

				
				String printBoseq = "";
				List<Object> agencyAllList = generalDAO.queryForList("reader.common.agencyListByAlive" );
				Map agencyListMap = null;
				
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
				
				// mav
				ModelAndView mav = new ModelAndView();
				mav.setViewName("management/abc/statisticsInfo");
				mav.addObject("now_menu", ICodeConstant.MENU_CODE_STATISTICS);
				
				mav.addObject("yymm", yymm);
				mav.addObject("yymm2", yymm2);
				mav.addObject("day2", day2);
				mav.addObject("newsCd", newsCd);
				mav.addObject("stats", "1");
				mav.addObject("boseq", boseq);
				mav.addObject("agencyAllList",agencyAllList);
				mav.addObject("printBoseq",printBoseq);
			
				mav.addObject("newsCodeList", newsCodeList);
				mav.addObject("resultList", resultList);
				
				return mav;
	} 
}
