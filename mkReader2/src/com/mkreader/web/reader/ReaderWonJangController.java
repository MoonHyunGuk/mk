/*------------------------------------------------------------------------------
 * NAME : ReaderWonJangController 
 * DESC : 독자 원장
 * Author : pspkj
 *----------------------------------------------------------------------------*/
package com.mkreader.web.reader;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.util.Param;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.DateUtil;

public class ReaderWonJangController extends MultiActionController implements
ISiteConstant, ICodeConstant {
	
private GeneralDAO generalDAO;
	
	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}

	/**
	 * 독자 원장 초기화면
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView retrieveReaderWonJang(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		try{
				HashMap dbparam = new HashMap();
			
			if( session.getAttribute(SESSION_NAME_AGENCY_SERIAL) == null ){ //관리자
				String adminId = (String)session.getAttribute(SESSION_NAME_ADMIN_USERID);
				dbparam.put("adminId", adminId);
				if("kbk".equals(adminId) || "dwhan".equals(adminId) || "changwhui".equals(adminId) || "taejin".equals(adminId) || "hjin".equals(adminId)  
				|| "leesh2012".equals(adminId) || "dlehsduq".equals(adminId) || "asttaek".equals(adminId)  ){
					List agencyList = generalDAO.queryForList("reader.common.adminAgencyList" , dbparam); //지국 리스트
					mav.addObject("agency_serial", param.getString("agency"));
					mav.addObject("agencyList", agencyList);
					if("".equals(param.getString("agency")) ){
						if(agencyList.size() > 0){
							Map list = (Map)agencyList.get(0);
							dbparam.put("agency_serial", list.get("SERIAL"));	
						}
					}else{
						dbparam.put("agency_serial", param.getString("agency"));	
					}
				}else{
					List agencyList = generalDAO.queryForList("reader.common.agencyList" , dbparam); //지국 리스트
					mav.addObject("agency_serial", param.getString("agency"));
					mav.addObject("agencyList", agencyList);
					if("".equals(param.getString("agency")) ){
						if(agencyList.size() > 0){
							Map list = (Map)agencyList.get(0);
							dbparam.put("agency_serial", list.get("SERIAL"));	
						}
					}else{
						dbparam.put("agency_serial", param.getString("agency"));	
					}
				}
			}else{
				dbparam.put("agency_serial", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			}
			String newsCd[] = new String[param.getInt("neswCdSize",0)];
			for(int i=0 ; i < newsCd.length ; i++ ){
				if(!"".equals(param.getString("newsCd"+i)) && param.getString("newsCd"+i) != null){
					newsCd[i] = param.getString("newsCd"+i);
				}
			}

			dbparam.put("newsCd", newsCd);
						
			List gno = generalDAO.queryForList("reader.readerWonJang.retrieveGnoList", dbparam);//구역 조회
			List newSList = generalDAO.queryForList("reader.common.retrieveNewsList", dbparam);//신문코드 조회
			List readerType = generalDAO.queryForList("reader.common.retrieveReaderType", dbparam);//고객 유형 조회
			
			String minGno = "";
			String maxGno = "";
			
			Map gnoList = (Map)gno.get(0);
			minGno = (String)gnoList.get("MINGNO");
			maxGno = (String)gnoList.get("MAXGNO");

			mav.addObject("minGno" , minGno);
			mav.addObject("maxGno" , maxGno);
			mav.addObject("newSList" , newSList);
			mav.addObject("readerType" , readerType);
			mav.addObject("newsCd" , newsCd);
			mav.addObject("param" , param);
			mav.addObject("now_menu", MENU_CODE_J_READER_WONJANG);
			mav.setViewName("reader/readerWonJang");
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
	 * 독자 원장 조회
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView retrieveReaderList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		try{
			HashMap dbparam = new HashMap();
			if( session.getAttribute(SESSION_NAME_AGENCY_SERIAL) == null ){ //관리자
				String adminId = (String)session.getAttribute(SESSION_NAME_ADMIN_USERID);
				dbparam.put("adminId", adminId);
				if("kbk".equals(adminId) || "dwhan".equals(adminId) || "changwhui".equals(adminId) || "taejin".equals(adminId) || "hjin".equals(adminId)  
				|| "leesh2012".equals(adminId) || "dlehsduq".equals(adminId) || "asttaek".equals(adminId)  ){
					List agencyList = generalDAO.queryForList("reader.common.adminAgencyList" , dbparam); //지국 리스트
					mav.addObject("agency_serial", param.getString("agency"));
					mav.addObject("agencyList", agencyList);
					if("".equals(param.getString("agency")) ){
						if(agencyList.size() > 0){
							Map list = (Map)agencyList.get(0);
							dbparam.put("agency_serial", list.get("SERIAL"));	
						}
					}else{
						dbparam.put("agency_serial", param.getString("agency"));	
					}
				}else{
					List agencyList = generalDAO.queryForList("reader.common.agencyList" , dbparam); //지국 리스트
					mav.addObject("agency_serial", param.getString("agency"));
					mav.addObject("agencyList", agencyList);
					if("".equals(param.getString("agency")) ){
						if(agencyList.size() > 0){
							Map list = (Map)agencyList.get(0);
							dbparam.put("agency_serial", list.get("SERIAL"));	
						}
					}else{
						dbparam.put("agency_serial", param.getString("agency"));	
					}
				}
			}else{
				dbparam.put("agency_serial", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			}
			
			String newsCd[] = new String[param.getInt("neswCdSize",0)];
			String readTypeCd[] = new String[param.getInt("readerTypeSize",0)];
			
			for(int i=0 ; i < newsCd.length ; i++ ){
				if(!"".equals(param.getString("newsCd"+i)) && param.getString("newsCd"+i) != null){
					newsCd[i] = param.getString("newsCd"+i);
				}
			}
			for(int i=0 ; i < readTypeCd.length ; i++ ){
				if(!"".equals(param.getString("readerType"+i)) && param.getString("readerType"+i) != null){
					readTypeCd[i] = param.getString("readerType"+i);
				}
			}
			
			dbparam.put("minGno" , param.getString("minGno"));
			dbparam.put("maxGno" , param.getString("maxGno"));
			dbparam.put("newsCd", newsCd);
			dbparam.put("readTypeCd", readTypeCd);
						
			List readerList = generalDAO.queryForList("reader.readerWonJang.retrieveReaderList", dbparam);//독자원장 리스트 조회
			List newSList = generalDAO.queryForList("reader.common.retrieveNewsList", dbparam);//신문코드 조회
			List readerType = generalDAO.queryForList("reader.common.retrieveReaderType", dbparam);//고객 유형 조회
			
			mav.addObject("minGno" , param.getString("minGno"));
			mav.addObject("maxGno" , param.getString("maxGno"));
			mav.addObject("newSList" , newSList);
			mav.addObject("readerList" , readerList);
			mav.addObject("readerType" , readerType);
			mav.addObject("newsCd" , newsCd);
			mav.addObject("readTypeCd" , readTypeCd);
			mav.addObject("param" , param);
			
			mav.addObject("now_menu", MENU_CODE_J_READER_WONJANG);
			mav.setViewName("reader/readerWonJang");	
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
	 * 독자 원장 프린트
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView ozReaderWonJang(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		try{
			HashMap dbparam = new HashMap();

			String agency_serial = "";
			if( session.getAttribute(SESSION_NAME_AGENCY_SERIAL) == null ){ //관리자
				agency_serial = param.getString("agency");	
			}else{
				agency_serial = (String)session.getAttribute(SESSION_NAME_AGENCY_SERIAL);
			}
			
			String newsCdParam[] = new String[param.getInt("neswCdSize",0)];
			String newsCd = "";
			
			for(int i=0 ; i < newsCdParam.length ; i++ ){
				if(!"".equals(param.getString("newsCd"+i)) && param.getString("newsCd"+i) != null){
					newsCdParam[i] = param.getString("newsCd"+i);
					newsCd = newsCd + "'" + param.getString("newsCd"+i) + "',";	
				}
			}
			newsCd = newsCd + "''";
			
			String readTypeCdParam[] = new String[param.getInt("readerTypeSize",0)];
			String readTypeCd = "";
			for(int i=0 ; i < readTypeCdParam.length ; i++ ){
				if(!"".equals(param.getString("readerType"+i)) && param.getString("readerType"+i) != null){
					readTypeCdParam[i] = param.getString("readerType"+i);
					readTypeCd = readTypeCd + "'" + param.getString("readerType"+i) + "',";	
				}
			}
			readTypeCd = readTypeCd + "''";

			String print[] = new String[param.getInt("printSize",0)];
			String start[] = new String[param.getInt("printSize",0)];
			String end[] = new String[param.getInt("printSize",0)];
			String guyukSql=" AND (";

			for(int i=0 ; i < print.length ; i++ ){

				if(!"".equals(param.getString("print"+i)) && param.getString("print"+i) != null){
					if(!"".equals(param.getString("print"+i)) && param.getString("print"+i) != null){
						print[i] = param.getString("print"+i);
						start[i] = param.getString("start"+i);
						end[i] = param.getString("end"+i);
						guyukSql = guyukSql + "(GNO = '"+ print[i] +"' AND BNO BETWEEN LPAD('"+ start[i] +"', 3, '0')  AND LPAD('"+ end[i] +"', 3, '0') ) OR ";
					}
				}
				
			}
			guyukSql = guyukSql + " (GNO = '')) ";
			
			mav.addObject("agency_serial", agency_serial); //지국 번호
			mav.addObject("terms1", param.getString("terms1"));//명단 통계 구분 readerWonJang.xml retrieveStatistics여기 통계쿼리 따로있음
			mav.addObject("terms2", param.getString("terms2"));//독자명 구분  //셀렉트절 조건
			mav.addObject("terms3", param.getString("terms3"));//중지독자포함 //where절 조건
			mav.addObject("terms4", param.getString("terms4"));//전화번호2 인쇄//셀렉트절 조건
			mav.addObject("terms5", param.getString("terms5"));//비고인쇄//셀렉트절 조건
			mav.addObject("readTypeCd" , readTypeCd); //독자 유형 in조건
			mav.addObject("newsCd" , newsCd); //신문종류 in 조건
			mav.addObject("guyukSql" , guyukSql); //where절 동적 쿼리
			
			System.out.println("====>"+param.toString());
			
			String nowYYMM = (String)generalDAO.queryForObject("common.getLastSGYYMM", dbparam); //사용년월
			mav.addObject("nowYYMM", nowYYMM);
			
			if("".equals(param.getString("terms5"))){			
				mav.addObject("target", "readerWonJang");   //비고 출력 X
			}else{				
				mav.addObject("target", "readerWonJang2");		//비고 출력 
			}
			mav.setViewName("reader/oz/ozReaderWonJang");		
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
	 * 독자 원장 엑셀 저장
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView ExcelReaderList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		try{
			HashMap dbparam = new HashMap();
			if( session.getAttribute(SESSION_NAME_AGENCY_SERIAL) == null ){ //관리자
				String adminId = (String)session.getAttribute(SESSION_NAME_ADMIN_USERID);
				dbparam.put("adminId", adminId);
				if("kbk".equals(adminId) || "dwhan".equals(adminId) || "changwhui".equals(adminId) || "taejin".equals(adminId) || "hjin".equals(adminId)  
				|| "leesh2012".equals(adminId) || "dlehsduq".equals(adminId) || "asttaek".equals(adminId)  ){
					List agencyList = generalDAO.queryForList("reader.common.adminAgencyList" , dbparam); //지국 리스트
					mav.addObject("agency_serial", param.getString("agency"));
					mav.addObject("agencyList", agencyList);
					if("".equals(param.getString("agency")) ){
						if(agencyList.size() > 0){
							Map list = (Map)agencyList.get(0);
							dbparam.put("agency_serial", list.get("SERIAL"));	
						}
					}else{
						dbparam.put("agency_serial", param.getString("agency"));	
					}
				}else{
					List agencyList = generalDAO.queryForList("reader.common.agencyList" , dbparam); //지국 리스트
					mav.addObject("agency_serial", param.getString("agency"));
					mav.addObject("agencyList", agencyList);
					if("".equals(param.getString("agency")) ){
						if(agencyList.size() > 0){
							Map list = (Map)agencyList.get(0);
							dbparam.put("agency_serial", list.get("SERIAL"));	
						}
					}else{
						dbparam.put("agency_serial", param.getString("agency"));	
					}
				}
				
				
			}else{
				dbparam.put("agency_serial", session.getAttribute(SESSION_NAME_AGENCY_SERIAL));
			}
			
			dbparam.put("minGno" , param.getString("minGno"));
			dbparam.put("maxGno" , param.getString("maxGno"));
			dbparam.put("terms1", param.getString("terms1"));//명단 통계 구분
			dbparam.put("terms2", param.getString("terms2"));//독자명 구분
			dbparam.put("terms3", param.getString("terms3","no"));//중지독자포함
			dbparam.put("terms4", param.getString("terms4"));//전화번호2 인쇄
			dbparam.put("terms5", param.getString("terms5"));//비고인쇄
			
			String newsCd[] = new String[param.getInt("neswCdSize",0)];
			String newsNm[] = new String[param.getInt("neswCdSize",0)];
			String readTypeCd[] = new String[param.getInt("readerTypeSize",0)];
			
			for(int i=0 ; i < newsCd.length ; i++ ){
				if(!"".equals(param.getString("newsCd"+i)) && param.getString("newsCd"+i) != null){
					newsCd[i] = param.getString("newsCd"+i);
					dbparam.put("newsCd", newsCd[i]);
					newsNm[i] = (String)generalDAO.queryForObject("reader.common.retrieveNewsName", dbparam);//독자원장 신문볗 통계
					dbparam.remove("newsCd");
				}
			}

			for(int i=0 ; i < readTypeCd.length ; i++ ){
				if(!"".equals(param.getString("readerType"+i)) && param.getString("readerType"+i) != null){
					readTypeCd[i] = param.getString("readerType"+i);
				}
			}
			dbparam.put("newsCd", newsCd);
			dbparam.put("readTypeCd", readTypeCd);
			
			String nowYYMM = (String)generalDAO.queryForObject("common.getLastSGYYMM", dbparam);//사용년월
			dbparam.put("nowYYMM", nowYYMM);
				
			int size = 0;
			for(int i=0 ; i < param.getInt("printSize",0) ; i++ ){
				if(!"".equals(param.getString("print"+i)) && param.getString("print"+i) != null){
					dbparam.put("print", param.getString("print"+i));
					dbparam.put("start", param.getString("start"+i));
					dbparam.put("end", param.getString("end"+i));
					mav.addObject("printReaderList"+size , generalDAO.queryForList("reader.readerWonJang.readerWonJangList", dbparam));//독자원장 프린트 목록
					mav.addObject("gno"+size , param.getString("print"+i));
					size++;
					if(param.getString("terms1") !=null || !"".equals(param.getString("terms1"))){
						for(int j=0 ; j < newsCd.length ; j++){
							if(newsCd[j] != null){
								dbparam.put("tem_newsCd", newsCd[j]);
								mav.addObject("statistics"+size+j , generalDAO.queryForList("reader.readerWonJang.retrieveStatistics", dbparam));//독자원장 신문볗 통계
							}
						}	
					}
				}
			}

			String fileName = "readerList_(" + DateUtil.getCurrentDate("yyyyMMdd") + ").xls";
						
			//Excel response
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName); 
			response.setHeader("Content-Description", "JSP Generated Data");
			
			mav.addObject("size" , size);
			mav.addObject("nowYYMM" , nowYYMM);
			mav.addObject("newsCd" , newsCd);
			mav.addObject("newsNm" , newsNm);
			mav.addObject("terms1", param.getString("terms1"));//명단 통계 구분
			mav.addObject("terms2", param.getString("terms2"));//독자명 구분
			mav.addObject("terms3", param.getString("terms3"));//중지독자포함
			mav.addObject("terms4", param.getString("terms4"));//전화번호2 인쇄
			mav.addObject("terms5", param.getString("terms5"));//비고인쇄
			mav.setViewName("reader/readerWonJangExcel");	
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
