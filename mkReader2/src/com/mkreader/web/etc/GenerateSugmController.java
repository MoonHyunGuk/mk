/*------------------------------------------------------------------------------
 * NAME : EmployeeAdminController 
 * DESC : 본사직원 구독 관리
 * Author : pspkj
 *----------------------------------------------------------------------------*/
package com.mkreader.web.etc;

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
import com.mkreader.web.output.BillOutputController;

public class GenerateSugmController extends MultiActionController implements
ISiteConstant, ICodeConstant {

	private GeneralDAO generalDAO;
	
	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}
	
	/**
	 * 수금 생성
	 * 
	 * @category 수금 생성
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView moveGenerateSugmPage(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			HashMap dbparam = new HashMap();
			
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			
			mav.addObject("now_menu", MENU_CODE_MANAGEMENT_ABC);
			mav.setViewName("management/abc/generateSugm");
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
	 * 수금 이력 생성
	 * 
	 * @category 수금이력 생성
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView generateSugm(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		System.out.println("generateSugm start >>>");
		
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		BillOutputController billOutput = new BillOutputController();
		
		try{
			MultipartHttpServletParam param = new MultipartHttpServletParam(request);
			MultipartFile sugmfile = param.getMultipartFile("sugmfile");
		    
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
			if("A".equals(loginType)){
				if ( sugmfile.isEmpty()) {	// 파일 첨부가 안되었으면 
					mav.setViewName("common/message");
					mav.addObject("message", "파일첨부가 되지 않았습니다.");
					mav.addObject("returnURL", "/etc/generateSugm/moveGenerateSugmPage.do");
					return mav;
				}
				
				Calendar now = Calendar.getInstance();
				int year = now.get(Calendar.YEAR);
				
				FileUtil fileUtil = new FileUtil( getServletContext() );
				String strFile = fileUtil.saveUploadFile(
										sugmfile, 
										PATH_PHYSICAL_HOME,
										PATH_UPLOAD_GENERATE_RESULT + "/" + year
									);
				
				if ( StringUtils.isEmpty(strFile) ) {
					mav.setViewName("common/message");
					mav.addObject("message", "파일 저장이 실패하였습니다. ");
					mav.addObject("returnURL", "/etc/generateSugm/moveGenerateSugmPage.do");
					return mav;
					
				// start 수금 생성
				}else{
					String fileName = PATH_PHYSICAL_HOME+PATH_UPLOAD_GENERATE_RESULT + "/" + year+"/"+strFile;
					
					Workbook myWorkbook = Workbook.getWorkbook(new File(fileName)); // 파일을 읽어 와서...
				    Sheet mySheet = myWorkbook.getSheet(0);

			    	String readNo = "";				// 독자번호
			    	String jikuk = "";				// 지국번호
			    	String seq = "";				// 일렬번호
			    	String newsCd = "";				// 신문코드
			    	String sgtype = "";				// 수금방법코드
			    	String sgbgmm = "";				// 수금시작월
			    	String sgedmm = "";				// 수금종료월
			    	String qty = "";				// 부수
			    	String uPrice = "";				// 단가
			    	String endDt = "";				// 종료일
			    	String gno = "";				// 구역번호

//			    	System.out.println(mySheet.getRows()+"행");
			    	
				    for(int no=1 ; no < mySheet.getRows() ; no++){ // 행의 갯수 만큼 돌리고 
				    	// 셀별로 데이터 추출
				    	for(int i=0 ; i < mySheet.getColumns() ; i++){ 
				    		Cell myCell = mySheet.getCell(i, no);
				    		if(i == 0){
				    			readNo = myCell.getContents();
				    		}else if(i == 1){
				    			jikuk = myCell.getContents();
				    		}else if(i == 2){
				    			seq = myCell.getContents();
				    		}else if(i == 3){
				    			newsCd = myCell.getContents();
				    		}else if(i == 4){
				    			sgtype = myCell.getContents();
				    		}else if(i == 5){
				    			sgbgmm = myCell.getContents();
				    		}else if(i == 6){
				    			sgedmm = myCell.getContents();
				    		}else if(i == 7){
				    			qty = myCell.getContents();
				    		}else if(i == 8){
				    			uPrice = myCell.getContents();
				    		}else if(i == 9){
				    			gno = myCell.getContents();
				    		}
			    		
				    	}
				    	
						// 수금 생성

				    	// 수금종료월이 없으면 당월
				    	if(sgedmm == null || "".equals(sgedmm)){
				    		String month = String.valueOf(now.get(Calendar.MONTH));
				    		if(month.length() < 2){
				    			month = "0" + month;
				    		}
				    		endDt = year+""+month;
				    	}else{
				    		endDt = sgedmm;
				    	}

				    	dbparam.put("sgedmm", endDt);
				    	dbparam.put("sgtype", sgtype);
				    	dbparam.put("sggbCd", sgtype);
				    	dbparam.put("sgbgmm", sgbgmm);
				    	dbparam.put("readNo", readNo);
				    	dbparam.put("jikuk", jikuk);
				    	dbparam.put("seq", seq);
				    	dbparam.put("newsCd", newsCd);
				    	dbparam.put("qty", qty);
				    	dbparam.put("uPrice", uPrice);
				    	dbparam.put("price", uPrice);
			    		dbparam.put("gno", gno);

			    		// 미수생성용 랜덤변수
			    		int rannum044 = (int)(Math.random()*2)+1;
			    		System.out.println("미수건수"+rannum044);
				    	//이전 수금 삭제
				    	//generalDAO.getSqlMapClient().delete("etc.generateSugm.deleteSugm", dbparam);
				    	//text = text+"-------------- 독자번호"+ readNo+" 수금 생성 결과 --------------"+nLine; 
				    	//text = text+ readNo + ts +"이전 및 이후 수금 총"+d1+"건 삭제 완료"+nLine;
				    	
				    	// 생성 기간 확인				    			
			    		String[] loop = billOutput.getYYMM(sgbgmm.substring(0, 4) , sgbgmm.substring(4, 6), endDt.substring(0, 4) , endDt.substring(4, 6)) ;
			    		String standardDt = "";
			    		boolean sugmDtChk = true;
			    		List retrieveSugmDt = null;
				    	// 수금 생성 (생성기간)
				    	for(int m = 0 ; m < loop.length ; m ++){
				    		
				    		System.out.println("loop"+loop[m].replace("-", ""));
					    	dbparam.put("yymm", loop[m].replace("-", ""));		
					    	dbparam.put("price", uPrice);
					    	dbparam.put("sgtype", sgtype);
				    		// 해당 지국의 당월분 수금일 확인
					    	String chkMM = (String)dbparam.get("yymm");
					    	chkMM = chkMM.substring(4, 6);
					    	System.out.println("chkMM = "+ chkMM);
					    	if(chkMM.equals("12")) {//12월은 당월수금이 없으므로 다음년 수금년월 가져와야함
					    		retrieveSugmDt = generalDAO.getSqlMapClient().queryForList("etc.generateSugm.retrieveSugmDtForZero", dbparam);
					    	} else {
					    		retrieveSugmDt = generalDAO.getSqlMapClient().queryForList("etc.generateSugm.retrieveSugmDt", dbparam);
					    	}
					    	
				    		// 해당 지국이 당월 수금이 존재 하는 경우만 수금 생성
				    		if(retrieveSugmDt.size() > 0){
				    			
				    			// 당월 수금일 중 랜덤으로 1택
					    		int rannum =  (int)(Math.random()*retrieveSugmDt.size());
					    		Map cList = (Map)retrieveSugmDt.get(rannum);
					    		
					    		//바로전 수금 날짜 저장
					    		if(m==0)  {standardDt= (String)cList.get("SNDT");  cList = (Map)retrieveSugmDt.get(0);}
					    		
					    		System.out.println("=================================");
					    		
					    		//바로전 수금이 현재가져온 처리 날짜보다 작거나 같을때
					    		/*
				    			if(Integer.parseInt(standardDt) < Integer.parseInt((String)cList.get("SNDT"))) {
					    			dbparam.put("sndt", cList.get("SNDT"));
					    			standardDt= (String)cList.get("SNDT");
				    			}else{
				    				if(retrieveSugmDt.size() > 0) {
					    				rannum = (int)(Math.random()*retrieveSugmDt.size());
							    		cList = (Map)retrieveSugmDt.get(rannum);
							    		dbparam.put("sndt", cList.get("SNDT"));
						    			standardDt= (String)cList.get("SNDT");
						    			System.out.println("re_chk_sndt = "+cList.get("SNDT"));
				    				} else {
						    			dbparam.put("sndt", standardDt);
						    			standardDt= (String)cList.get("SNDT");
						    			System.out.println("len0_sndt = "+cList.get("SNDT"));
						    		}
				    			}
				    			*/
					    		if(retrieveSugmDt.size() > 0) {
				    				rannum = (int)(Math.random()*retrieveSugmDt.size());
						    		cList = (Map)retrieveSugmDt.get(rannum);
						    		dbparam.put("sndt", cList.get("SNDT"));
					    			standardDt= (String)cList.get("SNDT");
					    			System.out.println("re_chk_sndt = "+cList.get("SNDT"));
			    				} else {
					    			dbparam.put("sndt", standardDt);
					    			standardDt= (String)cList.get("SNDT");
					    			System.out.println("len0_sndt = "+cList.get("SNDT"));
					    		}
					    		
				    			// 기존 수금 존재 여부 확인
				    			List collectionList = generalDAO.getSqlMapClient().queryForList("etc.generateSugm.collectionList", dbparam);
				    			
				    			// 기존 수금이력 존재시 업데이트
				    			if(!collectionList.isEmpty()){
				    				System.out.println("기존 수금이력 존재시 =======================>");
				    				Map vList = (Map)collectionList.get(0);
				    				// 수금 방법이 미수이면 업데이트
				    				if(vList.get("SGBBCD").equals("044")){
				    					// 수금 방법 랜덤 (재무 및 미수 일괄 처리용)
				    					int random = (int)(Math.random()*100);
				    					
				    					// 재무 및 미수 일괄 처리 기간용 랜덤변수
				    					int misuRan = 0;
				    					
				    					dbparam.put("price", uPrice);
				    					if(random > 97){
				    						dbparam.put("sgtype", "032");
				    						dbparam.put("price", "0");
				    						dbparam.put("misuRan", (int)(Math.random()*3));
				    						System.out.println("재무2"+dbparam);
				    						generalDAO.getSqlMapClient().update("etc.generateSugm.updateCollectionChg", dbparam);
				    						
				    					}else if(random >= 53 && random < 58){
				    						dbparam.put("misuRan", (int)(Math.random()*3*-1));
				    						
				    						if("012".equals(sgtype)){
				    							dbparam.put("sgtype", "013");
				    							System.out.println("통장입금 2"+dbparam);
				    							List retrieveSugmDt2 = generalDAO.getSqlMapClient().queryForList("etc.generateSugm.retrieveSugmDt", dbparam);
				    							int rannum2 = (int)(Math.random()*retrieveSugmDt.size());
				    							Map cList2 = (Map)retrieveSugmDt.get(rannum2);
				    							dbparam.put("sndt", cList2.get("SNDT"));
				    							
				    						}else if("013".equals(sgtype)){
				    							dbparam.put("sgtype", "012");
				    							System.out.println("방문 2"+dbparam);
				    							List retrieveSugmDt2 = generalDAO.getSqlMapClient().queryForList("etc.generateSugm.retrieveSugmDt", dbparam);
				    							int rannum2 = (int)(Math.random()*retrieveSugmDt.size());
				    							Map cList2 = (Map)retrieveSugmDt.get(rannum2);
				    							dbparam.put("sndt", cList2.get("SNDT"));
				    						}
				    						
				    						System.out.println("수금방법변경2"+dbparam);
				    						generalDAO.getSqlMapClient().update("etc.generateSugm.updateCollectionChg", dbparam);
				    					}else{
				    						generalDAO.getSqlMapClient().update("etc.generateSugm.updateCollection", dbparam);
				    					}
				    					// 미수가 아닌경우 패스
				    				}// 수금 방법이 미수이면 업데이트(end)
				    				// 기존 수금이력 미존재시 생성
				    			}else{
				    				System.out.println("일단 생성후 업데이트 처리 ====================>");
				    				// 일단 생성후 업데이트 처리
				    				generalDAO.getSqlMapClient().insert("etc.generateSugm.insertCollection", dbparam);
				    				
				    				// 수금 방법 랜덤 (재무 및 미수 일괄 처리용)
				    				int random = (int)(Math.random()*100);
				    				
				    				// 재무 및 미수 일괄 처리 기간용 랜덤변수
				    				//dbparam.put("price", uPrice);
				    				int misuRan = (int)(Math.random()*3*-1);
				    				System.out.println("m="+m);
				    				System.out.println("rannum044="+rannum044);
				    				System.out.println("loop.length="+ String.valueOf((loop.length)-rannum044));
				    				rannum044 = 0;
				    				if(m < (loop.length)-rannum044){
				    					if(random > 97){
				    						dbparam.put("sgtype", "032");
				    						dbparam.put("price", "0");
				    						dbparam.put("misuRan", (int)(Math.random()*2));
				    						System.out.println("재무1"+dbparam);
				    						generalDAO.getSqlMapClient().update("etc.generateSugm.updateCollectionChg", dbparam);
				    						
				    					}else if(random >= 53 && random < 58){
				    						dbparam.put("misuRan", (int)(Math.random()*3*-1));
				    						
				    						/*
				    						if("012".equals(sgtype)){
				    							dbparam.put("sgtype", "013");
				    							System.out.println("통장입금1"+dbparam);
				    							List retrieveSugmDt2 = generalDAO.getSqlMapClient().queryForList("etc.generateSugm.retrieveSugmDt", dbparam);
				    							int rannum2 = (int)(Math.random()*retrieveSugmDt.size());
				    							Map cList2 = (Map)retrieveSugmDt.get(rannum2);
				    							dbparam.put("sndt", cList2.get("SNDT"));
				    						}else if("013".equals(sgtype)){
				    							dbparam.put("sgtype", "012");
				    							System.out.println("방문1 "+dbparam);
				    							List retrieveSugmDt2 = generalDAO.getSqlMapClient().queryForList("etc.generateSugm.retrieveSugmDt", dbparam);
				    							int rannum2 = (int)(Math.random()*retrieveSugmDt.size());
				    							Map cList2 = (Map)retrieveSugmDt.get(rannum2);
				    							dbparam.put("sndt", cList2.get("SNDT"));
				    						} 
				    						*/
				    						if("013".equals(sgtype)){
				    							dbparam.put("sgtype", "012");
				    							System.out.println("방문1 "+dbparam);
				    							List retrieveSugmDt2 = generalDAO.getSqlMapClient().queryForList("etc.generateSugm.retrieveSugmDt", dbparam);
				    							int rannum2 = (int)(Math.random()*retrieveSugmDt.size());
				    							Map cList2 = (Map)retrieveSugmDt.get(rannum2);
				    							dbparam.put("sndt", cList2.get("SNDT"));
				    						} 
				    						
				    						System.out.println("수금방법변경1"+dbparam);
				    						generalDAO.getSqlMapClient().update("etc.generateSugm.updateCollectionChg", dbparam);
				    					}else{
				    						generalDAO.getSqlMapClient().update("etc.generateSugm.updateCollection", dbparam);
				    					}
				    				}else{
				    					System.out.println("마지막월 미수 처리1"+dbparam);
				    					
							    		dbparam.put("sgtype", "044");
							    		dbparam.put("tempSndt", loop[m].replace("-", "")+"20" );
							    		dbparam.put("sndt", "");
							    		dbparam.put("price", "0");
				    					generalDAO.getSqlMapClient().insert("etc.generateSugm.updateCollection", dbparam);
				    				
				    				}
//					    			text = text + (String)dbparam.get("readNo")+ts+"독자"+ts+(String)dbparam.get("yymm")+ts+"월분"+ts+"수금등록 완료"+nLine;
//					    			count ++;
				    			}
					    		/*
					    		if(dbparam.get("sndt") == null || "".equals(dbparam.get("sndt")) ){
					    			dbparam.put("sndt", cList.get("SNDT"));
					    			standardDt= (String)cList.get("SNDT");
					    		}else if( (Integer.parseInt((String)dbparam.get("tempSndt"))-Integer.parseInt((String)dbparam.get("sndt"))) < 15 ){
					    			dbparam.put("sndt", dbparam.get("sndt"));
					    			standardDt= (String)cList.get("SNDT");
					    		}else{
					    		}
					    		*/

				    		}else{
				    			/*
				    			String tmpSugmDt = (String)dbparam.get("tempSndt");
					    	
					    		if(loop[m].replace("-", "").equals("201212")) {
					    			dbparam.put("sgtype", "032");
						    		dbparam.put("tempSndt", loop[m].replace("-", "")+"21" );
						    		dbparam.put("sndt", "");
						    		dbparam.put("price", "0");
		    						System.out.println("재무2"+dbparam);
		    						generalDAO.getSqlMapClient().insert("etc.generateSugm.insertCollection", dbparam);
						    	} else {
					    			
						    	}
					    		generalDAO.getSqlMapClient().insert("etc.generateSugm.insertCollection", dbparam);
					    		*/
						    		
				    			System.out.println("마지막월 미수 처리2"+dbparam);
					    		dbparam.put("sgtype", "044");
					    		dbparam.put("tempSndt", loop[m].replace("-", "")+"21" );
					    		dbparam.put("sndt", "");
					    		dbparam.put("price", "0");
					    		generalDAO.getSqlMapClient().insert("etc.generateSugm.insertCollection", dbparam);
				    		}
				    		
				    	}
				    	System.out.println(dbparam.get("readNo")+" 처리완료");

				    }
//				    msg = msg + text ;
//				    msg = msg + nLine + "총" + count + "건 수금 등록 처리 완료";
//				    
//				    System.out.println(">>>>>>>>>>>>>>> result >>>>>>>>>>>>>>> \n"+msg);
				    
//				    //결과 메시지 파일로 저장
//				    FileUtil.saveTxtFile(
//							PATH_PHYSICAL_HOME+PATH_UPLOAD_GENERATE_RESULT + "/" + year, 
//							"sugmFinal" + DateUtil.getCurrentDate("yyyyMMddHHmmss")+".txt",
//							msg,
//							"EUC-KR"
//						);

				    generalDAO.getSqlMapClient().getCurrentConnection().commit();
				    mav.setViewName("common/message");
					mav.addObject("message", "수금 생성이 완료 되었습니다.");
					mav.addObject("returnURL", "/etc/generateSugm/moveGenerateSugmPage.do");
					return mav;
				}
	
			}else{
				
				mav.setViewName("common/message");
				mav.addObject("message", MSG_LOGIN_NOT_AUTH_ADMIN);
				mav.setView(new RedirectView("/etc/generateSugm/moveGenerateSugmPage.do"));
				return mav;
			}
						
		}catch(Exception e){
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/etc/generateSugm/moveGenerateSugmPage.do");
			return mav;
		}finally{
			generalDAO.getSqlMapClient().endTransaction();
		}
	}

}