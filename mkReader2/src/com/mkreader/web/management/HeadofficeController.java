package com.mkreader.web.management;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import jxl.*;
import jxl.write.*;
import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.util.Param;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.DateUtil;

public class HeadofficeController extends MultiActionController implements
ISiteConstant, ICodeConstant {
	
public static Logger logger = Logger.getRootLogger();
	
	private GeneralDAO generalDAO;
	
	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}
	
	 
	/** 
	 * 본사사원수금처리 - 대상추출/임시입력 화면이동
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView tmpHeadofficeReader(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		String url	= "";
		 
		try{
			HashMap<String, Object> dbparam = new HashMap<String, Object>();
			
			String currentYYMM = DateUtil.getCurrentDate("yyyyMM");
			//String currentYYMM = "201402";
			dbparam.put("sugmYYMM",currentYYMM);
			
			int rowCnt = (Integer)generalDAO.queryForObject("management.headOffice.selectCurrentSugmYn", dbparam);
			
			List<Object> tmpSugmList = new ArrayList<Object>();
			if(rowCnt > 2) {
				tmpSugmList = generalDAO.queryForList("management.headOffice.selectTmpSugmList", dbparam);
			}
			
			mav.addObject("now_menu", MENU_CODE_MANAGEMENT_HEADOFFICE);
			mav.addObject("currentYYMM", currentYYMM);
			mav.addObject("tmpSugmList", tmpSugmList);
			mav.addObject("rowCnt", rowCnt);
			mav.setViewName("management/headoffice/tmp_sugm");
		} catch(Exception e){
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
		}	
		return mav;
	}
	
	
	/** 
	 * 본사사원수금처리 - 대상추출/임시입력
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView insertTmpSugmData(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HashMap dbparam = new HashMap();
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			String sugmYYMM = param.getString("sugmYYMM");
			String sugmYYMMDD = param.getString("sugmYYMMDD");
			
			dbparam.put("sugmYYMM",sugmYYMM);
			dbparam.put("sugmYYMMDD",sugmYYMMDD);
			
			//입시입력처리
			generalDAO.getSqlMapClient().insert("management.headOffice.insertTmEmpSugmTable", dbparam);
			
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			generalDAO.getSqlMapClient().endTransaction();
			
			mav.setViewName("common/message");
			mav.addObject("now_menu", MENU_CODE_MANAGEMENT_HEADOFFICE);
			mav.addObject("message", "본사사원 대상추출이 완료되었습니다.");
			mav.addObject("returnURL", "/management/headoffice/tmpHeadofficeReader.do");
		} catch(Exception e){
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			generalDAO.getSqlMapClient().endTransaction();
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", "본사사원 대상추출을 실패하였습니다.");
			mav.addObject("returnURL", "/management/headoffice/tmpHeadofficeReader.do");
		}	
		return mav;
	}
	
	
	/** 
	 * 전체지국입금현황 엑셀생성
	 * @param request
	 * @param response
	 * @return excelJikukTotalDown
	 * @throws Exception
	 */
	public ModelAndView createExcelFile(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HashMap dbparam = new HashMap();
		List jikukTmpSugmList = new ArrayList();
		List allJikukTmpSugmList	= new ArrayList();
		Map listMap = new HashMap(); 

		//절대경로
		String path = PATH_UPLOAD_RELATIVE_ROOT+"/tmpSugm/";
		
		//임시수금년월
		String sugmYYMM 	= param.getString("currentYYMM");
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
		savefileName	= path+sugmYYMM+".xls";
		
		WritableWorkbook workbook = Workbook.createWorkbook(new File(savefileName)); 
		WritableSheet sheet1	= workbook.createSheet("지국별입금현황", 0);
		WritableSheet sheet2 	= workbook.createSheet("전체지국입금현황", 1); 
		
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
		
		try{
			dbparam.put("sugmYYMM",sugmYYMM);
			
			//지국별입금현황
			jikukTmpSugmList  = generalDAO.getSqlMapClient().queryForList("management.headOffice.selectJikukTmpSugmList", dbparam);
			
			for(int i=0;i<jikukTmpSugmList.size();i++) {
				listMap = (Map) jikukTmpSugmList.get(i);
				label0 = new Label(0, i+1, (String)listMap.get("BOSEQ"));
				label1 = new Label(1, i+1, (String)listMap.get("BOSEQ_NM"));
				label2 = new Label(2, i+1, (String)listMap.get("AMT").toString());
				label3 = new Label(3, i+1, (String)listMap.get("BILLQTY").toString()); 
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
			//전체지국입금현황
			allJikukTmpSugmList  = generalDAO.getSqlMapClient().queryForList("management.headOffice.selectAllJikukTmpSugmList", dbparam);
			
			for(int i=0;i<allJikukTmpSugmList.size();i++) {
				listMap = (Map) allJikukTmpSugmList.get(i);
				label0 = new Label(0, i+1, (String)listMap.get("BOSEQ"));
				label1 = new Label(1, i+1, (String)listMap.get("BOSEQ_NM"));
				label2 = new Label(2, i+1, (String)listMap.get("AMT").toString());
				label3 = new Label(3, i+1, (String)listMap.get("BILLQTY").toString()); 
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
			response.setHeader("Content-Disposition", "attachment; filename=" + sugmYYMM+".xls" + ";");
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
			mav.addObject("now_menu", MENU_CODE_MANAGEMENT_HEADOFFICE);
			mav.addObject("returnURL", "/management/headoffice/tmpHeadofficeReader.do");
		} catch(Exception e){
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", "입금현황추출을 실패하였습니다.");
			mav.addObject("returnURL", "/management/headoffice/tmpHeadofficeReader.do");
		}	
		return mav;
	}
	
	
	/**
	 * 사원리스트 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView userList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		HashMap<String, Object> dbparam = new HashMap<String, Object>();
			
		List<Object> partList = new ArrayList<Object>();
		//부서조회
		partList = generalDAO.queryForList("management.headOffice.selectPartList", dbparam);
		
		mav.addObject("partList", partList);
		mav.addObject("now_menu", MENU_CODE_MANAGEMENT_HEADOFFICE2);
		mav.setViewName("management/headoffice/userList");
		return mav;
	}
	
	/**
	 * 부서별 사원리스트 조회
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectChildList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		
		try {
			Map<String, Object> childListMap = new HashMap<String, Object>();
			
			String compcd  = param.getString("compcd");
			int index = 0;
			
			dbparam.put("COMPCD", compcd);
			
			List<Map<String, Object>> childList = generalDAO.queryForList("management.headOffice.selectTmpUserList", dbparam);
			
			
			for(Map<String, Object> map : childList) {
				for (Map.Entry<String, Object> entry : map.entrySet()) {
					String key = entry.getKey();
					Object value = entry.getValue();
					childListMap.put(key, value);
				}
				index++;
			}
			
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("childList", JSONArray.fromObject(childList));
			
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}
