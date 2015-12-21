/*------------------------------------------------------------------------------
 * NAME : BiReaderController 
 * DESC : 비독자관리
 * Author : jyyoo
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

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

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

public class BiReaderController extends MultiActionController implements
	ISiteConstant, ICodeConstant {

	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {

			this.generalDAO = generalDAO;
	}
	
	/**
	 * 비독자 리스트
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView biReaderList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		
		ModelAndView mav = new ModelAndView();
 
		Calendar rightNow = Calendar.getInstance();
		String year = String.valueOf(rightNow.get(Calendar.YEAR));
		String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));
		if (month.length() < 2)
			month = "0" + month;
		if (day.length() < 2)
			day = "0" + day;

		String type = param.getString("type");
		String BI_READNM = param.getString("BI_READNM_S");
		String TEL1 = param.getString("TEL1_S");
		String TEL2 = param.getString("TEL2_S");
		String TEL3 = param.getString("TEL3_S");
		String ADDR = param.getString("ADDR_S");
		String ORGAN = param.getString("ORGAN_S");
		String OFFDEPT = param.getString("OFFDEPT_S");
		String OFFDUTY = param.getString("OFFDUTY_S");
		String GUBUN = param.getString("GUBUN_S");
		String BI_GROUP1 = param.getString("BI_GROUP1_S");
		String BI_GROUP2 = param.getString("BI_GROUP2_S");
		String BI_GROUP3 = param.getString("BI_GROUP3_S");
		String TODAY= year + month + day;			//현재일자

		int pageNo = param.getInt("pageNo", 1);
		int pageSize = 20;
		int totalCount = 0;
		int totalQty = 0;
		
		HashMap dbparam = new HashMap();
		
		dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
		dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
		
		dbparam.put("BI_READNM", BI_READNM); 
		dbparam.put("TEL1", TEL1);
		dbparam.put("TEL2", TEL2);
		dbparam.put("TEL3", TEL3);
		dbparam.put("ADDR", ADDR); 
		dbparam.put("ORGAN", ORGAN); 
		dbparam.put("OFFDEPT", OFFDEPT); 
		dbparam.put("OFFDUTY", OFFDUTY); 
		dbparam.put("GUBUN", GUBUN); 
		dbparam.put("BI_GROUP1", BI_GROUP1); 
		dbparam.put("BI_GROUP2", BI_GROUP2); 
		dbparam.put("BI_GROUP3", BI_GROUP3); 
		
		List biReaderList = generalDAO.queryForList("reader.biReader.BIRDR_LIST" , dbparam);  // 리스트 조회
		totalCount = generalDAO.count("reader.biReader.BIRDR_LIST_CNT" , dbparam); // 조건별 전체 건수 조회	
		
		List SECD6 = generalDAO.queryForList("reader.biReader.SECD6" , dbparam); // 1차그룹코드
		List SECD7 = generalDAO.queryForList("reader.biReader.SECD7" , dbparam); // 2차그룹코드
		List SECD8 = generalDAO.queryForList("reader.biReader.SECD8" , dbparam); // 3차그룹코드
		List SELCODE = generalDAO.queryForList("reader.biReader.SELCODE" , dbparam); // 비독자 구분코드

		mav.addObject("type", type);	
		mav.addObject("BI_READNM_S", BI_READNM);
		mav.addObject("TEL1_S", TEL1);
		mav.addObject("TEL2_S", TEL2);
		mav.addObject("TEL3_S", TEL3);
		mav.addObject("ADDR_S", ADDR);
		mav.addObject("ORGAN_S", ORGAN);
		mav.addObject("OFFDEPT_S", OFFDEPT);
		mav.addObject("OFFDUTY_S", OFFDUTY);
		mav.addObject("GUBUN_S", GUBUN);
		mav.addObject("BI_GROUP1_S", BI_GROUP1);
		mav.addObject("BI_GROUP2_S", BI_GROUP2);
		mav.addObject("BI_GROUP3_S", BI_GROUP3);
		mav.addObject("TODAY", TODAY); 
		
		mav.addObject("SECD6", SECD6);
		mav.addObject("SECD7", SECD7);
		mav.addObject("SECD8", SECD8);
		mav.addObject("SELCODE", SELCODE);
		
		mav.addObject("biReaderList", biReaderList);
		mav.addObject("totalCount", totalCount);
		
		mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 10));
		mav.addObject("now_menu", MENU_CODE_NON_READER);
		mav.setViewName("reader/biReader");
		return mav;
		
	}
	

	/**
	 * 비독자 리스트 엑셀 저장
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView excelBiReaderList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

			
			Param param = new HttpServletParam(request);
			ModelAndView mav = new ModelAndView();
	
			String BI_READNM = param.getString("BI_READNM_S");
			String TEL1 = param.getString("TEL1_S");
			String TEL2 = param.getString("TEL2_S");
			String TEL3 = param.getString("TEL3_S");
			String ADDR = param.getString("ADDR_S");
			String ORGAN = param.getString("ORGAN_S");
			String OFFDEPT = param.getString("OFFDEPT_S");
			String OFFDUTY = param.getString("OFFDUTY_S");
			String GUBUN = param.getString("GUBUN_S");
			String BI_GROUP1 = param.getString("BI_GROUP1_S");
			String BI_GROUP2 = param.getString("BI_GROUP2_S");
			String BI_GROUP3 = param.getString("BI_GROUP3_S");
			
		try{
			HashMap dbparam = new HashMap();
				
			dbparam.put("BI_READNM", BI_READNM); 
			dbparam.put("TEL1", TEL1);
			dbparam.put("TEL2", TEL2);
			dbparam.put("TEL3", TEL3);
			dbparam.put("ADDR", ADDR); 
			dbparam.put("ORGAN", ORGAN); 
			dbparam.put("OFFDEPT", OFFDEPT); 
			dbparam.put("OFFDUTY", OFFDUTY); 
			dbparam.put("GUBUN", GUBUN); 
			dbparam.put("BI_GROUP1", BI_GROUP1); 
			dbparam.put("BI_GROUP2", BI_GROUP2); 
			dbparam.put("BI_GROUP3", BI_GROUP3); 
			
			List biReaderList = generalDAO.queryForList("reader.biReader.BIRDR_LIST_EXCEL" , dbparam);  // 리스트 조회
			
			String fileName = "biReaderList_(" + DateUtil.getCurrentDate("yyyyMMdd") + ").xls";
			//Excel response
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName); 
			response.setHeader("Content-Description", "JSP Generated Data");

			mav.addObject("biReaderList" , biReaderList);
			mav.setViewName("reader/excelBiReaderList");
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
	 * 비독자 리스트 OZ라벨 인쇄
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ozBiReaderList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		
		ModelAndView mav = new ModelAndView();

		String type = param.getString("type");
		String BI_READNM = param.getString("BI_READNM_S");
		String TEL1 = param.getString("TEL1_S");
		String TEL2 = param.getString("TEL2_S");
		String TEL3 = param.getString("TEL3_S");
		String ADDR = param.getString("ADDR_S");
		String ORGAN = param.getString("ORGAN_S");
		String OFFDEPT = param.getString("OFFDEPT_S");
		String OFFDUTY = param.getString("OFFDUTY_S");
		String GUBUN = param.getString("GUBUN_S");
		String BI_GROUP1 = param.getString("BI_GROUP1_S");
		String BI_GROUP2 = param.getString("BI_GROUP2_S");
		String BI_GROUP3 = param.getString("BI_GROUP3_S");
		
		mav.addObject("BI_READNM", BI_READNM);
		mav.addObject("TEL1", TEL1);
		mav.addObject("TEL2", TEL2);
		mav.addObject("TEL3", TEL3);
		mav.addObject("ADDR", ADDR);
		mav.addObject("ORGAN", ORGAN);
		mav.addObject("OFFDEPT", OFFDEPT);
		mav.addObject("OFFDUTY", OFFDUTY);
		mav.addObject("GUBUN", GUBUN);
		mav.addObject("BI_GROUP1", BI_GROUP1);
		mav.addObject("BI_GROUP2", BI_GROUP2);
		mav.addObject("BI_GROUP3", BI_GROUP3);
		mav.addObject("type", type);		
		
		mav.setViewName("reader/oz/ozBiReaderList");
		return mav;
		
	}
	
	
	/**
	 * 비독자 2그룹코드 콤보리스트 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ajaxBiGroupList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();

		try{
			HashMap dbparam = new HashMap();
			String cdclsf = param.getString("BI_GROUP1");
			dbparam.put("cdclsf", cdclsf );
			
			List biGroupList = null;
	
			biGroupList = generalDAO.queryForList("reader.biReader.biGroupList", dbparam);

			mav.addObject("biGroupList", biGroupList);
			mav.setViewName("reader/ajaxBiGroupList");	
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
	 * 비독자 2그룹코드 콤보리스트 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ajaxBiGroupListByJson(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();

		try {
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			dbparam.put("cdclsf",  param.getString("cdclsf"));
			
			List<Map<String, Object>> biGroupList = null;
			Map<String, Object> biGroupMap = new HashMap<String, Object>();;
			int index = 0;
			
			biGroupList = generalDAO.queryForList("reader.biReader.biGroupList", dbparam);
			
			for(Map<String, Object> map : biGroupList) {
				for (Map.Entry<String, Object> entry : map.entrySet()) {
					String key = entry.getKey();
					Object value = entry.getValue();
					biGroupMap.put(key, value);
				}
				index++;
			}
			
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("biGroupList", JSONArray.fromObject(biGroupList));
			
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 비독자 2그룹코드 콤보리스트 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ajaxBiGroupList2(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();

		try{
			HashMap dbparam = new HashMap();
			String cdclsf = param.getString("BI_GROUP2");
			dbparam.put("cdclsf", cdclsf );
			
			List biGroupList = null;
	
			biGroupList = generalDAO.queryForList("reader.biReader.biGroupList", dbparam);

			mav.addObject("biGroupList", biGroupList);
			mav.setViewName("reader/ajaxBiGroupList");	
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
	 * 비독자 상세조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectBiReaderDataView(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();

		try{
			HashMap dbparam = new HashMap();
			String APLCDT = param.getString("APLCDT");
			String APLCNO = param.getString("APLCNO");
			dbparam.put("APLCDT", APLCDT );
			dbparam.put("APLCNO", APLCNO );
			
			Map biReaderData = (Map)generalDAO.queryForObject("reader.biReader.selectBiReaderDataView", dbparam);

			JSONObject jsonObject = new JSONObject();
			jsonObject.put("biReaderData", JSONArray.fromObject(biReaderData));
			
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
	
	
	/**
	 * 비독자 등록
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView regBiReader(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HashMap dbparam = new HashMap();
		HttpSession session = request.getSession();
		
		//비독자 정보 생성을 위한 param값
		
		dbparam.put("APLCDT" , param.getString("APLCDT"));           // 데이터 생성일
		dbparam.put("BI_GROUP1" , param.getString("BI_GROUP1"));   // 그룹코드1
		dbparam.put("BI_GROUP2" , param.getString("BI_GROUP2"));   // 그룹코드2
		dbparam.put("BI_GROUP3" , param.getString("BI_GROUP3"));   // 그룹코드3
		dbparam.put("BI_READNM" , param.getString("BI_READNM"));   // 이름
		dbparam.put("OFFZIP" , param.getString("OFFZIP"));  	    	// 사무실 우편번호
		dbparam.put("OFFADRS1" , param.getString("OFFADRS1"));   // 사무실주소1
		dbparam.put("OFFADRS2" , param.getString("OFFADRS2"));   // 사무실주소2
		dbparam.put("OFFDUTY" , param.getString("OFFDUTY"));       // 직책
		dbparam.put("OFFDEPT" , param.getString("OFFDEPT"));        // 부서
		dbparam.put("OFFTEL1" , param.getString("OFFTEL1"));         // 사무실전화번호1
		dbparam.put("OFFTEL2" , param.getString("OFFTEL2"));         // 사무실전화번호2
		dbparam.put("OFFTEL3" , param.getString("OFFTEL3"));         // 사무실전화번호3
		dbparam.put("OFFFAX1" , param.getString("OFFFAX1"));       // 사무실팩스1
		dbparam.put("OFFFAX2" , param.getString("OFFFAX2"));       // 사무실팩스2
		dbparam.put("OFFFAX3" , param.getString("OFFFAX3"));       // 사무실팩스3
		dbparam.put("MOBILE1" , param.getString("MOBILE1"));       // 휴대폰전화번호1
		dbparam.put("MOBILE2" , param.getString("MOBILE2"));       // 휴대폰전화번호2
		dbparam.put("MOBILE3" , param.getString("MOBILE3"));       // 휴대폰전화번호3
		dbparam.put("EMAIL" , param.getString("EMAIL"));			   // 이메일
		dbparam.put("HOMEZIP" , param.getString("HOMEZIP"));      // 집우편번호
		dbparam.put("HOMEADRS1" , param.getString("HOMEADRS1")); // 집주소1
		dbparam.put("HOMEADRS2" , param.getString("HOMEADRS2")); // 집주소2
		dbparam.put("HOMETEL1" , param.getString("HOMETEL1"));   // 집전화번호1
		dbparam.put("HOMETEL2" , param.getString("HOMETEL2"));   // 집전화번호2
		dbparam.put("HOMETEL3" , param.getString("HOMETEL3"));   // 집전화번호3
		dbparam.put("SMGUDOK" , param.getString("SMGUDOK"));	// 구독구분
		dbparam.put("ORGAN" , param.getString("ORGAN"));            // 소속기관
		dbparam.put("GUBUN" , param.getString("GUBUN"));		        // 구분코드
		dbparam.put("REMK" , param.getString("REMK"));                 // 비고

		dbparam.put("INPS" , (String)session.getAttribute(SESSION_NAME_ADMIN_USERID));          // 등록자(시스템 접속자 아이디)
		dbparam.put("CHGPS" , (String)session.getAttribute(SESSION_NAME_ADMIN_USERID));		   // 수정자(시스템 접속자 아이디)
	
		
		int BiReaderInfo = 0;
		BiReaderInfo = generalDAO.count("reader.biReader.BIRDR_DUPCHK" , dbparam);

		if(BiReaderInfo>0){
			mav.addObject("message", "이미 등록된 독자입니다.");
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/reader/biReader/biReaderList.do");
		}else{	

			try{
				generalDAO.insert("reader.biReader.INSERT_BIRDR_INFO", dbparam);
				mav.addObject("message", "정상적으로 등록 되었습니다.");
				
			}catch (Exception e){
				mav.addObject("message", "등록을 실패했습니다.");
				e.printStackTrace();
			}
			
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/reader/biReader/biReaderList.do");
		}
		return mav;
	
	}
	
	
	/**
	 * 비독자 일괄등록(excel)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView excelBiReaderIns(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
				
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		generalDAO.getSqlMapClient().startTransaction();
		generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
		
		MultipartHttpServletParam param = new MultipartHttpServletParam(request);
		
		try{
			
			MultipartFile excelFile = param.getMultipartFile("excelFile");		
						
			HashMap dbparam = new HashMap();

				if ( excelFile.isEmpty()) {	// 파일 첨부가 안되었으면 
					mav.setViewName("common/message");
					mav.addObject("message", "파일첨부가 되지 않았습니다.");
					mav.addObject("returnURL", "/reader/biReader/biReaderList.do");
					return mav;
				}
				
				Calendar rightNow = Calendar.getInstance();
				String year = String.valueOf(rightNow.get(Calendar.YEAR));
				String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
				String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));
				if (month.length() < 2)
					month = "0" + month;
				if (day.length() < 2)
					day = "0" + day;
				
				String BI_GROUP1 = param.getString("BI_GROUP1");   // 그룹코드1
				String BI_GROUP2 = param.getString("BI_GROUP2");   // 그룹코드2
				String BI_GROUP3 = param.getString("BI_GROUP3");   // 그룹코드3
				String APLCDT= year + month + day;			//현재일자

				FileUtil fileUtil = new FileUtil( getServletContext() );
				String strFile = fileUtil.saveUploadFile(
									excelFile, 
										PATH_PHYSICAL_HOME,
										PATH_UPLOAD_BI_READER_RESULT
									);
				
				if ( StringUtils.isEmpty(strFile) ) {
					mav.setViewName("common/message");
					mav.addObject("message", "파일 저장이 실패하였습니다. ");
					mav.addObject("returnURL", "/reader/biReader/biReaderList.do");
					return mav;
				}else{

					String fileName = PATH_PHYSICAL_HOME+PATH_UPLOAD_BI_READER_RESULT+ "/" + strFile;

					Workbook myWorkbook = Workbook.getWorkbook(new File(fileName)); // 파일을 읽어 와서...
				    Sheet mySheet = myWorkbook.getSheet(0);

				    int count=0;
				    int success=0;
				    int error=0;
				    				    
				    String msg = "";
				    String text = "";
					String nLine = "\n";
					
			    	String BI_READNM = "";
			    	String OFFZIP = "";
			    	String OFFADRS1 = "";
			    	String OFFADRS2 = "";
			    	String ORGAN = "";
			    	String OFFDUTY = "";
			    	String OFFDEPT = "";
			    	String OFFTEL1 = "";
			    	String OFFTEL2 = "";
			    	String OFFTEL3 = "";
			    	String OFFFAX1 = "";
			    	String OFFFAX2 = "";
			    	String OFFFAX3 = "";
			    	String MOBILE1 = "";
			    	String MOBILE2 = "";
			    	String MOBILE3 = "";
			    	String EMAIL = "";
			    	String HOMEZIP = "";
			    	String HOMEADRS1 = "";
			    	String HOMEADRS2 = "";
			    	String HOMETEL1 = "";
			    	String HOMETEL2 = "";
			    	String HOMETEL3 = "";
			    	String REMK = "";
			    	
				    for(int no=1 ; no < mySheet.getRows() ; no++){ // 행의 갯수 만큼 돌리고 
				    	
				    	for(int i=0 ; i < mySheet.getColumns() ; i++){
				    		Cell myCell = mySheet.getCell(i,no);
				    		if(i == 0){
				    			BI_READNM  = myCell.getContents();
				    		}else if(i == 1){
				    			OFFZIP  = myCell.getContents();
				    		}else if(i == 2){
				    			OFFADRS1  = myCell.getContents();
				    		}else if(i == 3){
				    			OFFADRS2  = myCell.getContents();
				    		}else if(i == 4){
				    			ORGAN  = myCell.getContents();
				    		}else if(i == 5){
				    			OFFDUTY  = myCell.getContents();
				    		}else if(i == 6){
				    			OFFDEPT  = myCell.getContents();
				    		}else if(i == 7){
				    			OFFTEL1  = myCell.getContents();
				    		}else if(i == 8){
				    			OFFTEL2  = myCell.getContents();
				    		}else if(i == 9){
				    			OFFTEL3  = myCell.getContents();
				    		}else if(i == 10){
				    			OFFFAX1  = myCell.getContents();
				    		}else if(i == 11){
				    			OFFFAX2  = myCell.getContents();
				    		}else if(i == 12){
				    			OFFFAX3  = myCell.getContents();
				    		}else if(i == 13){
				    			MOBILE1  = myCell.getContents();
				    		}else if(i == 14){
				    			MOBILE2  = myCell.getContents();
				    		}else if(i == 15){
				    			MOBILE3  = myCell.getContents();
				    		}else if(i == 16){
				    			EMAIL  = myCell.getContents();
				    		}else if(i == 17){
				    			HOMEZIP  = myCell.getContents();
				    		}else if(i == 18){
				    			HOMEADRS1  = myCell.getContents();
				    		}else if(i == 19){
				    			HOMEADRS2  = myCell.getContents();
				    		}else if(i == 20){
				    			HOMETEL1  = myCell.getContents();
				    		}else if(i == 21){
				    			HOMETEL2  = myCell.getContents();
				    		}else if(i == 22){
				    			HOMETEL3  = myCell.getContents();
				    		}else if(i == 23){
				    			REMK  = myCell.getContents();
				    		}
	
					    	dbparam.put("APLCDT" , APLCDT);           // 데이터 생성일
				    		dbparam.put("BI_GROUP1" , BI_GROUP1);   // 그룹코드1
				    		dbparam.put("BI_GROUP2" , BI_GROUP2);   // 그룹코드2
				    		dbparam.put("BI_GROUP3" , BI_GROUP3);   // 그룹코드3
				    		dbparam.put("BI_READNM" , BI_READNM);   // 이름
				    		dbparam.put("OFFZIP" , OFFZIP.replace("-", ""));  	    	// 직장우편번호
				    		dbparam.put("OFFADRS1" , OFFADRS1);   // 직장주소1
				    		dbparam.put("OFFADRS2" , OFFADRS2);   // 직장주소2
				    		dbparam.put("ORGAN" , ORGAN);            // 소속기관
				    		dbparam.put("OFFDUTY" , OFFDUTY);       // 직책
				    		dbparam.put("OFFDEPT" , OFFDEPT);        // 부서
				    		dbparam.put("OFFTEL1" , OFFTEL1);         // 직장전화번호1
				    		dbparam.put("OFFTEL2" , OFFTEL2);         // 직장전화번호2
				    		dbparam.put("OFFTEL3" , OFFTEL3);         // 직장전화번호3
				    		dbparam.put("OFFFAX1" , OFFFAX1);       // 팩스1
				    		dbparam.put("OFFFAX2" , OFFFAX2);       // 팩스2
				    		dbparam.put("OFFFAX3" , OFFFAX3);       // 팩스3
				    		dbparam.put("MOBILE1" , MOBILE1);       // 휴대폰전화번호1
				    		dbparam.put("MOBILE2" , MOBILE2);       // 휴대폰전화번호2
				    		dbparam.put("MOBILE3" , MOBILE3);       // 휴대폰전화번호3
				    		dbparam.put("EMAIL" , EMAIL);			   // 이메일
				    		dbparam.put("HOMEZIP" , HOMEZIP.replace("-", ""));      // 집우편번호
				    		dbparam.put("HOMEADRS1" , HOMEADRS1); // 집주소1
				    		dbparam.put("HOMEADRS2" , HOMEADRS2); // 집주소2
				    		dbparam.put("HOMETEL1" , HOMETEL1);   // 집전화번호1
				    		dbparam.put("HOMETEL2" , HOMETEL2);   // 집전화번호2
				    		dbparam.put("HOMETEL3" , HOMETEL3);   // 집전화번호3
				    		dbparam.put("REMK" , REMK);                 // 비고
				    		dbparam.put("SMGUDOK" , "N");             // 구독여부
	
				    		dbparam.put("INPS" , (String)session.getAttribute(SESSION_NAME_ADMIN_USERID));          // 등록자(시스템 접속자 아이디)
				    		dbparam.put("CHGPS" , (String)session.getAttribute(SESSION_NAME_ADMIN_USERID));		   // 수정자(시스템 접속자 아이디)	
				    	}
				    	
//				    	int BiReaderInfo = 0;
//						BiReaderInfo = generalDAO.count("reader.biReader.BIRDR_DUPCHK" , dbparam);
						
//				    	if(BiReaderInfo>0){
//							text = text + BI_READNM + "독자 그룹내 독자중복으로 등록실패" + nLine;
//							error++;
//						}else{
							generalDAO.getSqlMapClient().insert("reader.biReader.INSERT_BIRDR_INFO", dbparam);
							text = text + BI_READNM + "독자 등록 완료" + nLine;
							success++;
//						}
						count++;
				    }
				    msg = msg + text ;
				    msg = msg + nLine + count + "건 처리 완료[성공 : " + success + "건, 실패(독자중복) : " + error + "건]";
				    
				    //결과 메시지 파일로 저장
				    FileUtil.saveTxtFile(
							PATH_PHYSICAL_HOME+PATH_UPLOAD_BI_READER_RESULT , 
							"excelFile" + DateUtil.getCurrentDate("yyyyMMddHHmmss")+".txt",
							msg,
							"EUC-KR"
						);

				    generalDAO.getSqlMapClient().getCurrentConnection().commit();
				    mav.setViewName("common/message");
					mav.addObject("message", count + "건 처리 완료[성공 : " + success + "건, 실패(독자중복) : " + error + "건]");
					mav.addObject("returnURL", "/reader/biReader/biReaderList.do");
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
	 * 비독자정보 수정
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView modifyBiReader(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HashMap dbparam = new HashMap();
		HttpSession session = request.getSession();
		
		//비독자 정보 수정을 위한 param값
		
				dbparam.put("APLCDT" , param.getString("APLCDT"));           // 데이터 생성일
				dbparam.put("APLCNO" , param.getString("APLCNO"));          // 데이터 고유번호
				dbparam.put("BI_GROUP1" , param.getString("BI_GROUP1"));   // 그룹코드1
				dbparam.put("BI_GROUP2" , param.getString("BI_GROUP2"));   // 그룹코드2
				dbparam.put("BI_GROUP3" , param.getString("BI_GROUP3"));   // 그룹코드3
				dbparam.put("BI_READNM" , param.getString("BI_READNM"));   // 이름
				dbparam.put("OFFZIP" , param.getString("OFFZIP"));  	    	// 사무실 우편번호
				dbparam.put("OFFADRS1" , param.getString("OFFADRS1"));   // 사무실주소1
				dbparam.put("OFFADRS2" , param.getString("OFFADRS2"));   // 사무실주소2
				dbparam.put("OFFDUTY" , param.getString("OFFDUTY"));       // 직책
				dbparam.put("OFFDEPT" , param.getString("OFFDEPT"));        // 부서
				dbparam.put("OFFTEL1" , param.getString("OFFTEL1"));         // 사무실전화번호1
				dbparam.put("OFFTEL2" , param.getString("OFFTEL2"));         // 사무실전화번호2
				dbparam.put("OFFTEL3" , param.getString("OFFTEL3"));         // 사무실전화번호3
				dbparam.put("OFFFAX1" , param.getString("OFFFAX1"));       // 사무실팩스1
				dbparam.put("OFFFAX2" , param.getString("OFFFAX2"));       // 사무실팩스2
				dbparam.put("OFFFAX3" , param.getString("OFFFAX3"));       // 사무실팩스3
				dbparam.put("MOBILE1" , param.getString("MOBILE1"));       // 휴대폰전화번호1
				dbparam.put("MOBILE2" , param.getString("MOBILE2"));       // 휴대폰전화번호2
				dbparam.put("MOBILE3" , param.getString("MOBILE3"));       // 휴대폰전화번호3
				dbparam.put("EMAIL" , param.getString("EMAIL"));			   // 이메일
				dbparam.put("HOMEZIP" , param.getString("HOMEZIP"));      // 집우편번호
				dbparam.put("HOMEADRS1" , param.getString("HOMEADRS1")); // 집주소1
				dbparam.put("HOMEADRS2" , param.getString("HOMEADRS2")); // 집주소2
				dbparam.put("HOMETEL1" , param.getString("HOMETEL1"));   // 집전화번호1
				dbparam.put("HOMETEL2" , param.getString("HOMETEL2"));   // 집전화번호2
				dbparam.put("HOMETEL3" , param.getString("HOMETEL3"));   // 집전화번호3
				dbparam.put("SMGUDOK" , param.getString("SMGUDOK"));	// 구독구분
				dbparam.put("ORGAN" , param.getString("ORGAN"));            // 소속기관
				dbparam.put("GUBUN" , param.getString("GUBUN"));		        // 구분코드
				dbparam.put("REMK" , param.getString("REMK"));                 // 비고

				dbparam.put("CHGPS" , (String)session.getAttribute(SESSION_NAME_ADMIN_USERID));		   // 수정자(시스템 접속자 아이디)
		
			try{
				generalDAO.update("reader.biReader.UPDATE_BIRDR_INFO", dbparam); 		// 비독자정보 수정
				mav.addObject("message", "정상적으로 수정 되었습니다.");
				
			}catch (Exception e){
				mav.addObject("message", "수정을 실패했습니다.");
				e.printStackTrace();
			}
			
			mav.setViewName("common/message");
			mav.addObject("returnURL", "/reader/biReader/biReaderList.do");
			
			return mav;		
				
	}
	

	/**
	 * 비독자정보 삭제
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView delBiReader(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);		
		ModelAndView mav = new ModelAndView();
		HashMap dbparam = new HashMap();
		
		dbparam.put("APLCDT" , param.getString("APLCDT"));           // 데이터 생성일
		dbparam.put("APLCNO" , param.getString("APLCNO"));          // 데이터 고유번호
		
		
		try{
			if(generalDAO.delete("reader.biReader.DELETE_BIRDR_INFO", dbparam) > 0){
				mav.addObject("message", "정상적으로 삭제 되었습니다.");
			}
		}catch (Exception e){
			    mav.addObject("message", "삭제를 실패했습니다.");
			    e.printStackTrace();
		}
	
		mav.setViewName("common/message");
		mav.addObject("returnURL", "/reader/biReader/biReaderList.do");
		
		return mav;
	}
	
	
	/**
	 * 1차그룹 가져오기
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectBiGroup1List(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();

		try{
			HashMap dbparam = new HashMap();
			
			List SECD6 = generalDAO.queryForList("reader.biReader.SECD6" , dbparam); // 1차그룹코드
			
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("SECD6", JSONArray.fromObject(SECD6));
			
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
	
}