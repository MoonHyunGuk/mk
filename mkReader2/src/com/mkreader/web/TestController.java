package com.mkreader.web;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;
import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.util.Param;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.DateUtil;
import com.mkreader.util.FileUtil;
import com.mkreader.util.StringUtil;


public class TestController extends MultiActionController implements
		ISiteConstant, ICodeConstant {

	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {

		this.generalDAO = generalDAO;
	}
	//본사 직원 구독정보 등록
	public ModelAndView insertEmployee(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();

		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			//엑셀 파일 읽기
			String fileName = "C:/MK_Reader/workspace/MK_Reader/wwwroot/uploadedfile/first2.xls";

			Workbook myWorkbook = Workbook.getWorkbook(new File(fileName)); // 파일을 읽어 와서...
		    Sheet mySheet = myWorkbook.getSheet(0);
		    HashMap dbparam = new HashMap();
		    int count=0;

		    for(int no=1;no<38;no++){ // 행의 갯수 만큼 돌리고 
		    	String company = "";
			    String office = "";
			    String readNm = "";
			    String sabun = "";
			    String hometel1 = "";
			    String hometel2 = "";
			    String hometel3 = "";
			    String mobile1 = "";
			    String mobile2 = "";
			    String mobile3 = "";
			    String dlvZip1 = "";
			    String dlvZip2 = "";
			    String dlvAdrs1 = "";
			    String dlvAdrs2 = "";
			    String boSeq = "";
			    
		    	for(int i=0;i<mySheet.getColumns();i++){ // 열의 갯수 만큼 돌려서
		    		Cell myCell = mySheet.getCell(i,no); // 셀의 행과 열의 정보를 가져온 후...
		    		if(i == 0){
		    			String tem = myCell.getContents();
		    			if(tem.indexOf("신문")>-1){
		    				company = "900001";
		    			}else if(tem.indexOf("MB")>-1){
		    				company = "900002";
		    			}else if(tem.indexOf("출판")>-1){
		    				company = "900004";
		    			}else if(tem.indexOf("닷")>-1){
		    				company = "900003";
		    			}else{
		    				company="";
		    			}
		    		}else if(i == 1){
		    			String tem = myCell.getContents().replace(" ", "");
		    			if(tem.indexOf("경리국")>-1){office = "000001";}
		    			else if(tem.indexOf("공무국")>-1){office = "000002";}
		    			else if(tem.indexOf("광고마케팅국")>-1){office = "000003";}
						else if(tem.indexOf("기획실")>-1){office = "000004";}
						else if(tem.indexOf("기획제작부")>-1){office = "000005";}
						else if(tem.indexOf("논설위원실")>-1){office = "000006";}
						else if(tem.indexOf("뉴스속보국")>-1){office = "000007";}
						else if(tem.indexOf("독자마케팅국")>-1){office = "000008";}
						else if(tem.indexOf("매경아카데미")>-1){office = "000009";}
						else if(tem.indexOf("사업국")>-1){office = "000010";}
						else if(tem.indexOf("시설관리국")>-1){office = "000011";}
						else if(tem.indexOf("임원실")>-1){office = "000012";}
						else if(tem.indexOf("전산실")>-1){office = "000013";}
						else if(tem.indexOf("전산제작국")>-1){office = "000014";}
						else if(tem.indexOf("정진기재단")>-1){office = "000015";}
						else if(tem.indexOf("조사부")>-1){office = "000016";}
						else if(tem.indexOf("주간국")>-1){office = "000017";}
						else if(tem.indexOf("총무국")>-1){office = "000018";}
						else if(tem.indexOf("편집국")>-1){office = "000019";}
						else if(tem.indexOf("경영지원국")>-1){office = "000020";}
						else if(tem.indexOf("기획실")>-1){office = "000021";}
						else if(tem.indexOf("논설실")>-1){office = "000022";}
						else if(tem.indexOf("미디어사업국")>-1){office = "000023";}
						else if(tem.indexOf("보도국")>-1){office = "000024";}
						else if(tem.indexOf("제작국")>-1){office = "000025";}
						else if(tem.indexOf("편성국")>-1){office = "000026";}
						else if(tem.indexOf("AD마케팅국")>-1){office = "000027";}
						else if(tem.indexOf("기술국")>-1){office = "000035";}
						else if(tem.indexOf("비즈국")>-1){office = "000036";}
						else if(tem.indexOf("임원실")>-1){office = "000037";}
						else if(tem.indexOf("경영관리팀")>-1){office = "000028";}
						else if(tem.indexOf("교육센터")>-1){office = "000029";}
						else if(tem.indexOf("뉴스센터")>-1){office = "000030";}
						else if(tem.indexOf("마케팅센터")>-1){office = "000031";}
						else if(tem.indexOf("미디어전략-R&D센터")>-1){office = "000032";}
						else if(tem.indexOf("은퇴경제센터")>-1){office = "000033";}
						else if(tem.indexOf("출판관리영업팀")>-1){office = "000034";}
						else {office="";}
		    		}else if(i == 2){
		    			readNm = myCell.getContents();
		    		}else if(i == 3){
		    			sabun = myCell.getContents();
		    		}else if(i == 4){
		    			String homeTel = myCell.getContents();
		    			String tmp[] = homeTel.split("-");
		    			if(tmp.length==0 || tmp.length==1){
		    				hometel1 = "";
		    				hometel2 = "";
		    				hometel3 = "";
		    			}else if(tmp.length==2){
		    				hometel1 = "02";
		    				hometel2 = tmp[0].replace(" ", "");
		    				hometel3 = tmp[1].replace(" ", "");
		    			}else if(tmp.length==3){
		    				hometel1 = tmp[0].replace(" ", "");
		    				hometel2 = tmp[1].replace(" ", "");
		    				hometel3 = tmp[2].replace(" ", "");
		    			}
	    			}else if(i == 5){
		    			String mobile = myCell.getContents();
		    			String tmp[] = mobile.split("-");
		    			
		    			if(tmp.length==0 || tmp.length==1){
		    				mobile1 = "";
		    				mobile2 = "";
		    				mobile3 = "";
		    			}else if(tmp.length==2){
		    				mobile1 = "010";
		    				mobile2 = tmp[0].replace(" ", "");
		    				mobile3 = tmp[1].replace(" ", "");
		    			}else if(tmp.length==3){
		    				mobile1 = tmp[0].replace(" ", "");
		    				mobile2 = tmp[1].replace(" ", "");
		    				mobile3 = tmp[2].replace(" ", "");
		    			}
		    		}else if(i == 6){
		    			String dlvZip = myCell.getContents();
		    			String tmp[] = dlvZip.split("-");
		    			dlvZip1 = tmp[0];
		    			dlvZip2 = tmp[1];
		    		}else if(i == 7){
		    			String dlvAdrs = myCell.getContents();
		    			int tmp = 0;
		    			if(dlvAdrs.indexOf("동 ") > -1){
		    				tmp = dlvAdrs.indexOf("동 ");
		    				dlvAdrs1 = dlvAdrs.substring(0,tmp+1);
		    				dlvAdrs2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("리 ") > -1){
		    				tmp = dlvAdrs.indexOf("리 ");
		    				dlvAdrs1 = dlvAdrs.substring(0,tmp+1);
		    				dlvAdrs2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("가 ") > -1){
		    				tmp = dlvAdrs.indexOf("가 ");
		    				dlvAdrs1 = dlvAdrs.substring(0,tmp+1);
		    				dlvAdrs2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("읍 ") > -1){
		    				tmp = dlvAdrs.indexOf("읍 ");
		    				dlvAdrs1 = dlvAdrs.substring(0,tmp+1);
		    				dlvAdrs2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("로 ") > -1){
		    				tmp = dlvAdrs.indexOf("로 ");
		    				dlvAdrs1 = dlvAdrs.substring(0,tmp+1);
		    				dlvAdrs2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("구 ") > -1){
		    				tmp = dlvAdrs.indexOf("구 ");
		    				dlvAdrs1 = dlvAdrs.substring(0,tmp+1);
		    				dlvAdrs2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("대 ") > -1){
		    				tmp = dlvAdrs.indexOf("대 ");
		    				dlvAdrs1 = dlvAdrs.substring(0,tmp+1);
		    				dlvAdrs2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("길 ") > -1){
		    				tmp = dlvAdrs.indexOf("길 ");
		    				dlvAdrs1 = dlvAdrs.substring(0,tmp+1);
		    				dlvAdrs2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("도 ") > -1){
		    				tmp = dlvAdrs.indexOf("도 ");
		    				dlvAdrs1 = dlvAdrs.substring(0,tmp+1);
		    				dlvAdrs2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("군 ") > -1){
		    				tmp = dlvAdrs.indexOf("군 ");
		    				dlvAdrs1 = dlvAdrs.substring(0,tmp+1);
		    				dlvAdrs2 = dlvAdrs.substring(tmp+2);
		    			}else{
		    				if(dlvAdrs.indexOf("구 ") > -1){
			    				tmp = dlvAdrs.indexOf("구 ");
			    				dlvAdrs1 = dlvAdrs.substring(0,tmp+1);
			    				dlvAdrs2 = dlvAdrs.substring(tmp+2);
		    				}else{
		    					dlvAdrs1 = "";
			    				dlvAdrs2 = "";
		    				}
		    			}
		    		}else if(i == 8){
		    		}else if(i == 9){
		    			boSeq = myCell.getContents();
		    		}else if(i == 10){
		    			
		    		}
                }

		    	dbparam.put("newsCd" , "100");
				dbparam.put("boSeq" , boSeq);
				dbparam.put("gno" , "300");
				dbparam.put("bno" , "000");
				dbparam.put("readTypeCd" , "016");
				dbparam.put("readNm" , readNm);
				dbparam.put("offiNm" , office);
				dbparam.put("company" , company);
				dbparam.put("sabun" , sabun);
				dbparam.put("homeTel1" , hometel1);
				dbparam.put("homeTel2" , hometel2);
				dbparam.put("homeTel3" , hometel3);
				dbparam.put("mobile1" , mobile1);
				dbparam.put("mobile2" , mobile2);
				dbparam.put("mobile3" , mobile3);
				dbparam.put("dlvZip" , dlvZip1+dlvZip2);
				dbparam.put("dlvAdrs1" , dlvAdrs1);
				dbparam.put("dlvAdrs2" , dlvAdrs2);
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
				dbparam.put("uPrice" , "4500");
				dbparam.put("qty" , "1");
				dbparam.put("stQty" , "");
				dbparam.put("rsdTypeCd" , "");
				dbparam.put("dlvTypeCd" , "");
				dbparam.put("dlvPosiCd" , "");
				dbparam.put("hjPathCd" , "004");
				dbparam.put("hjTypeCd" , "");
				dbparam.put("hjPsregCd" , "");
				dbparam.put("hjPsnm" , "");
				dbparam.put("hjDt" , "20120210");
				dbparam.put("indt" , "20120210");
				dbparam.put("aplcDt" , "20120210");
				dbparam.put("sgBgmm" , "201202");
				dbparam.put("sgEdmm" , "");
				dbparam.put("sgCycle" , "");
				dbparam.put("stSayou" , "");
				dbparam.put("aplcNo" , "");
				dbparam.put("remk" , "");
				dbparam.put("inps" , "SYSTEM");
				dbparam.put("spgCd" , "");
				dbparam.put("bnsBookCd" , "");
				dbparam.put("taskCd" , "");
				dbparam.put("intFldCd" , "");
				dbparam.put("bidt" , "");
				dbparam.put("eMail" , "");
				dbparam.put("agency_serial", boSeq);
		    	
	   			dbparam.put("readNo" , generalDAO.getSqlMapClient().queryForObject("reader.readerManage.getReadNo" , dbparam) );
	   			
	   			generalDAO.getSqlMapClient().insert("reader.readerManage.insertTmreader", dbparam); //통합독자생성
				generalDAO.getSqlMapClient().insert("reader.readerManage.inserTmreaderNews", dbparam); //구독정보 생성
				
				generalDAO.getSqlMapClient().getCurrentConnection().commit();
				count++;
		    }
		    
		    
			System.out.println(count+"건완료~~~~~");
		    
		    mav.setViewName("admin/main");
			return mav;
		}catch(Exception ex){
			ex.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			 mav.setViewName("admin/main");
			 return mav;
		}finally{
			generalDAO.getSqlMapClient().endTransaction();
		}

	}
	
	//교육용 구독정보 등록
	public ModelAndView insertEducation(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();

		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			//엑셀 파일 읽기
			String fileName = "C:/MK_Reader/workspace/mkReader/WebContent/uploadedfile/education/education2.xls";
			
			System.out.println("교육용 구독정보 등록 시작 ===============================================");

			Workbook myWorkbook = Workbook.getWorkbook(new File(fileName)); // 파일을 읽어 와서...
		    Sheet mySheet = myWorkbook.getSheet(0);
		    HashMap dbparam = new HashMap();
		    int count=0;
		    for(int no=1;no<mySheet.getRows();no++){ // 행의 갯수 만큼 돌리고 
		    	String SEQ      = "";
		    	String COMPANYNM= "";
		    	String COMPANYTEMP= "";
		    	String COMPANYCD= "";
		    	String READNM   = ""; 
		    	String DLVZIP   = "";
		    	String dlvAdrs1 = "";
				String dlvAdrs2 = "";
		    	String HOMETEL1 = "";
		    	String HOMETEL2 = "";
		    	String HOMETEL3 = "";
		    	String MOBILE1  = "";
		    	String MOBILE2  = "";
		    	String MOBILE3  = "";
		    	String BOSEQ    = "";
		    	String UPRICE   = ""; 
		    	String QTY      = ""; 
		    	String READNO   = "";
		    	String REMK   = "";
		    	String HJDT   = "";
		    	String SGBGMM   = "";
			    
		    	for(int i=0;i<mySheet.getColumns();i++){ // 열의 갯수 만큼 돌려서
		    		Cell myCell = mySheet.getCell(i,no); // 셀의 행과 열의 정보를 가져온 후...
		    		if(i == 0){
		    			SEQ = myCell.getContents();
		    		}else if(i == 1){
		    			String tem = myCell.getContents();
		    			if(tem.indexOf(" ") > -1){
		    				COMPANYNM =   tem.substring( 0, tem.indexOf(" "));
		    				COMPANYTEMP = tem;
		    			}else{
		    				COMPANYNM =   tem;
		    				COMPANYTEMP = tem;
		    			}
		    			
		    		}else if(i == 2){
		    			COMPANYCD = myCell.getContents();
		    		}else if(i == 3){
		    			READNM = myCell.getContents();
		    		}else if(i == 4){
		    			String zipcode = myCell.getContents();
//		    			String tmp[] = zipcode.split("-");
//		    			DLVZIP = tmp[0]+ tmp[1];
		    			DLVZIP = zipcode.replace("-", "");
	    			}else if(i == 5){
		    			String dlvAdrs = myCell.getContents();
		    			int tmp = 0;
		    			if(dlvAdrs.indexOf("동 ") > -1){
		    				tmp = dlvAdrs.indexOf("동 ");
		    				dlvAdrs1 = dlvAdrs.substring(0,tmp+1);
		    				dlvAdrs2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("리 ") > -1){
		    				tmp = dlvAdrs.indexOf("리 ");
		    				dlvAdrs1 = dlvAdrs.substring(0,tmp+1);
		    				dlvAdrs2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("가 ") > -1){
		    				tmp = dlvAdrs.indexOf("가 ");
		    				dlvAdrs1 = dlvAdrs.substring(0,tmp+1);
		    				dlvAdrs2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("읍 ") > -1){
		    				tmp = dlvAdrs.indexOf("읍 ");
		    				dlvAdrs1 = dlvAdrs.substring(0,tmp+1);
		    				dlvAdrs2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("로 ") > -1){
		    				tmp = dlvAdrs.indexOf("로 ");
		    				dlvAdrs1 = dlvAdrs.substring(0,tmp+1);
		    				dlvAdrs2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("구 ") > -1){
		    				tmp = dlvAdrs.indexOf("구 ");
		    				dlvAdrs1 = dlvAdrs.substring(0,tmp+1);
		    				dlvAdrs2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("대 ") > -1){
		    				tmp = dlvAdrs.indexOf("대 ");
		    				dlvAdrs1 = dlvAdrs.substring(0,tmp+1);
		    				dlvAdrs2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("길 ") > -1){
		    				tmp = dlvAdrs.indexOf("길 ");
		    				dlvAdrs1 = dlvAdrs.substring(0,tmp+1);
		    				dlvAdrs2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("도 ") > -1){
		    				tmp = dlvAdrs.indexOf("도 ");
		    				dlvAdrs1 = dlvAdrs.substring(0,tmp+1);
		    				dlvAdrs2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("군 ") > -1){
		    				tmp = dlvAdrs.indexOf("군 ");
		    				dlvAdrs1 = dlvAdrs.substring(0,tmp+1);
		    				dlvAdrs2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("촌 ") > -1){
		    				tmp = dlvAdrs.indexOf("촌 ");
		    				dlvAdrs1 = dlvAdrs.substring(0,tmp+1);
		    				dlvAdrs2 = dlvAdrs.substring(tmp+2);
		    			}else{
	    					dlvAdrs1 = dlvAdrs;
		    				dlvAdrs2 = "";
		    			}
	    			}else if(i == 6){
		    			String homeTel = myCell.getContents();
		    			String tmp[] = homeTel.split("-");
		    			if(tmp.length==0 || tmp.length==1){
		    				HOMETEL1 = "";
		    				HOMETEL2 = "";
		    				HOMETEL3 = "";
		    			}else if(tmp.length==2){
		    				HOMETEL1 = "02";
		    				HOMETEL2 = tmp[0].replace(" ", "");
		    				HOMETEL3 = tmp[1].replace(" ", "");
		    			}else if(tmp.length==3){
		    				HOMETEL1 = tmp[0].replace(" ", "");
		    				HOMETEL2 = tmp[1].replace(" ", "");
		    				HOMETEL3 = tmp[2].replace(" ", "");
		    			}
	    			}else if(i == 7){
		    			String homeTel = myCell.getContents();
		    			String tmp[] = homeTel.split("-");
		    			if(tmp.length==0 || tmp.length==1){
		    				MOBILE1 = "";
		    				MOBILE2 = "";
		    				MOBILE3 = "";
		    			}else if(tmp.length==2){
		    				MOBILE1 = "";
		    				MOBILE2 = tmp[0].replace(" ", "");
		    				MOBILE3 = tmp[1].replace(" ", "");
		    			}else if(tmp.length==3){
		    				MOBILE1 = tmp[0].replace(" ", "");
		    				MOBILE2 = tmp[1].replace(" ", "");
		    				MOBILE3 = tmp[2].replace(" ", "");
		    			}
	    			}else if(i == 8){
	    			}else if(i == 9){
	    				BOSEQ = myCell.getContents().replace(" ", "");
	    			}else if(i == 10){
	    			}else if(i == 11){
	    				HJDT = myCell.getContents();
	    			}else if(i == 12){
	    				QTY = myCell.getContents();
	    			}else if(i == 13){
	    				UPRICE = myCell.getContents();
	    			}else if(i == 14){
	    				SGBGMM = myCell.getContents();
	    			}else if(i == 15){
	    				REMK = myCell.getContents();
	    			}else if(i == 16){
	    			}
                }

		    	dbparam.put("seq",SEQ);
		    	dbparam.put("companynm",COMPANYNM);
		    	dbparam.put("companytemp",COMPANYTEMP);
		    	dbparam.put("company",COMPANYCD);
		    	dbparam.put("readNm",READNM);
		    	dbparam.put("dlvZip",DLVZIP);
		    	dbparam.put("dlvAdrs1",dlvAdrs1);
		    	dbparam.put("dlvAdrs2",dlvAdrs2);
		    	dbparam.put("homeTel1",HOMETEL1);
		    	dbparam.put("homeTel2",HOMETEL2);
		    	dbparam.put("homeTel3",HOMETEL3);
		    	dbparam.put("mobile1",MOBILE1);
		    	dbparam.put("mobile2",MOBILE2);
		    	dbparam.put("mobile3",MOBILE3);
		    	dbparam.put("boSeq",BOSEQ);
		    	dbparam.put("agency_serial",BOSEQ);
		    	dbparam.put("uPrice",UPRICE);
		    	dbparam.put("qty",QTY);
		    	dbparam.put("readNo",READNO);  
		    	dbparam.put("remk",REMK);  
		    	dbparam.put("hjDt",HJDT);
		    	dbparam.put("aplcDt",HJDT);
		    	
		    	/*교육용 독자 기본 파라미터값*/
		    	dbparam.put("newsCd","100");  			// 신문코드 (100: 매일경제)
		    	dbparam.put("gno","400");  				// 구역번호 (400: 교육용독자용)
		    	dbparam.put("bno","000");		
		    	dbparam.put("readTypeCd","015");		// 독자유형 (015: 교육용독자)
		    	dbparam.put("sgType","023");			// 수금방법 (023: 본사입금)
		    	dbparam.put("hjPathCd","004");			// 확장경로 (004: 본사전화)
		    	dbparam.put("rsdTypeCd","099");			// 주거구분 (099: 기타)
		    	dbparam.put("sgBgmm",SGBGMM);			// 유가년월
	   			
	   			dbparam.put("readNo" , generalDAO.getSqlMapClient().queryForObject("reader.readerManage.getReadNo" , dbparam) );
	   			
	   			generalDAO.getSqlMapClient().insert("reader.readerManage.insertTmreader", dbparam); //통합독자생성
				generalDAO.getSqlMapClient().insert("reader.education.inserTmreaderNews", dbparam); //구독정보 생성
		    	
		    	//교육용 TEMP 데이터 등록]
		    	System.out.println("파람"+dbparam);
		    	generalDAO.getSqlMapClient().insert("reader.education.insertEducation2", dbparam); //구독정보 생성
				generalDAO.getSqlMapClient().getCurrentConnection().commit();
				count++;
				
				System.out.println("교육용 구독정보 등록 끝 ===============================================");
		    }
		    mav.setViewName("admin/main");
			return mav;
		}catch(Exception ex){
			ex.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			 mav.setViewName("admin/main");
			 return mav;
		}finally{
			generalDAO.getSqlMapClient().endTransaction();
		}

	}
	
	//교육용 구독정보 tm_reader_news 등록
	public ModelAndView insertEducation2(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			int count = 0;
			List list = generalDAO.getSqlMapClient().queryForList("reader.education.list" );

			for(int i=0 ; i< list.size() ; i++){
				Map tem = (Map)list.get(i);
				HashMap dbparam = new HashMap();
		    	dbparam.put("seq", tem.get("SEQ"));
				dbparam.put("newsCd" , "100");
				dbparam.put("boSeq" , tem.get("BOSEQ"));
				dbparam.put("gno" , "400");
				dbparam.put("bno" , "000");
				dbparam.put("readTypeCd" , "015");
				dbparam.put("readNm" , tem.get("READNM"));
				dbparam.put("homeTel1" , tem.get("HOMETEL1"));
				dbparam.put("homeTel2" , tem.get("HOMETEL2"));
				dbparam.put("homeTel3" , tem.get("HOMETEL3"));
				dbparam.put("mobile1" , tem.get("MOBILE1"));
				dbparam.put("mobile2" , tem.get("MOBILE2"));
				dbparam.put("mobile3" , tem.get("MOBILE3"));
				dbparam.put("dlvZip" , tem.get("DLVZIP"));
				dbparam.put("dlvAdrs1" , tem.get("DLVADRS1"));
				dbparam.put("dlvAdrs2" , tem.get("DLVADRS2"));
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
				dbparam.put("uPrice" , tem.get("UPRICE"));
				dbparam.put("qty" , tem.get("QTY"));
				dbparam.put("stQty" , "");
				dbparam.put("rsdTypeCd" , "");
				dbparam.put("dlvTypeCd" , "");
				dbparam.put("dlvPosiCd" , "");
				dbparam.put("hjPathCd" , "004");
				dbparam.put("hjTypeCd" , "");
				dbparam.put("hjPsregCd" , "");
				dbparam.put("hjPsnm" , "");
				dbparam.put("hjDt" , "20120217");
				dbparam.put("indt" , "20120217");
				dbparam.put("aplcDt" , "20120217");
				dbparam.put("sgBgmm" , "201202");
				dbparam.put("sgEdmm" , "");
				dbparam.put("sgCycle" , "");
				dbparam.put("stSayou" , "");
				dbparam.put("aplcNo" , "");
				dbparam.put("remk" , "");
				dbparam.put("inps" , "SYSTEM");
				dbparam.put("spgCd" , "");
				dbparam.put("bnsBookCd" , "");
				dbparam.put("taskCd" , "");
				dbparam.put("intFldCd" , "");
				dbparam.put("bidt" , "");
				dbparam.put("eMail" , "");
				dbparam.put("agency_serial", tem.get("BOSEQ"));
	   			
   				dbparam.put("readNo" , generalDAO.getSqlMapClient().queryForObject("reader.readerManage.getReadNo" , dbparam) );
	   			
	   			//generalDAO.getSqlMapClient().insert("reader.readerManage.insertTmreader", dbparam); //통합독자생성
				//generalDAO.getSqlMapClient().insert("reader.readerManage.inserTmreaderNews", dbparam); //구독정보 생성
				//generalDAO.getSqlMapClient().update("reader.education.updateEducation2", dbparam); //구독정보 생성
				//generalDAO.getSqlMapClient().getCurrentConnection().commit();
				count++;
	   		}	

		    
		    mav.setViewName("admin/main");
			return mav;
		}catch(Exception ex){
			ex.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			 mav.setViewName("admin/main");
			 return mav;
		}finally{
			generalDAO.getSqlMapClient().endTransaction();
		}

	}
	
	//소외계층 구독정보 tm_reader_news 등록
	public ModelAndView insertNeglected(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			//엑셀 파일 읽기
			String fileName = "C:/MK_Reader/workspace/MK_Reader/wwwroot/uploadedfile/2012소외계층명단.xls";

			Workbook myWorkbook = Workbook.getWorkbook(new File(fileName)); // 파일을 읽어 와서...
		    Sheet mySheet = myWorkbook.getSheet(0);
		    HashMap dbparam = new HashMap();
		    int count=0;
		    System.out.println(mySheet.getRows());
		    for(int no=1;no<mySheet.getRows();no++){ // 행의 갯수 만큼 돌리고 
		    	String readNm = "";
		    	String dlvZip = "";
		    	String addr1 = "";
		    	String addr2 = "";
		    	String home1 = "";
		    	String home2 = "";
		    	String home3 = "";
		    	String mobile1 = "";
		    	String mobile2 = "";
		    	String mobile3 = "";
		    	String boSeq = "";
		    	
		    	for(int i=0;i<mySheet.getColumns();i++){ // 열의 갯수 만큼 돌려서
		    		Cell myCell = mySheet.getCell(i,no); // 셀의 행과 열의 정보를 가져온 후...
		    		if(i == 0){
		    			readNm = myCell.getContents();
		    		}else if(i == 1){
		    			String zipcode = myCell.getContents();
		    			String tmp[] = zipcode.split("-");
		    			dlvZip = tmp[0]+ tmp[1];
		    		}else if(i == 2){
		    			String dlvAdrs = myCell.getContents();
		    			int tmp = 0;
		    			if(dlvAdrs.indexOf("동 ") > -1){
		    				tmp = dlvAdrs.indexOf("동 ");
		    				addr1 = dlvAdrs.substring(0,tmp+1);
		    				addr2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("리 ") > -1){
		    				tmp = dlvAdrs.indexOf("리 ");
		    				addr1 = dlvAdrs.substring(0,tmp+1);
		    				addr2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("가 ") > -1){
		    				tmp = dlvAdrs.indexOf("가 ");
		    				addr1 = dlvAdrs.substring(0,tmp+1);
		    				addr2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("읍 ") > -1){
		    				tmp = dlvAdrs.indexOf("읍 ");
		    				addr1 = dlvAdrs.substring(0,tmp+1);
		    				addr2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("로 ") > -1){
		    				tmp = dlvAdrs.indexOf("로 ");
		    				addr1 = dlvAdrs.substring(0,tmp+1);
		    				addr2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("구 ") > -1){
		    				tmp = dlvAdrs.indexOf("구 ");
		    				addr1 = dlvAdrs.substring(0,tmp+1);
		    				addr2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("대 ") > -1){
		    				tmp = dlvAdrs.indexOf("대 ");
		    				addr1 = dlvAdrs.substring(0,tmp+1);
		    				addr2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("길 ") > -1){
		    				tmp = dlvAdrs.indexOf("길 ");
		    				addr1 = dlvAdrs.substring(0,tmp+1);
		    				addr2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("도 ") > -1){
		    				tmp = dlvAdrs.indexOf("도 ");
		    				addr1 = dlvAdrs.substring(0,tmp+1);
		    				addr2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("군 ") > -1){
		    				tmp = dlvAdrs.indexOf("군 ");
		    				addr1 = dlvAdrs.substring(0,tmp+1);
		    				addr2 = dlvAdrs.substring(tmp+2);
		    			}else if(dlvAdrs.indexOf("촌 ") > -1){
		    				tmp = dlvAdrs.indexOf("촌 ");
		    				addr1 = dlvAdrs.substring(0,tmp+1);
		    				addr2 = dlvAdrs.substring(tmp+2);
		    			}else{
		    				addr1 = dlvAdrs;
		    				addr2 = "";
		    			}
	    			}else if(i == 3){
		    			String homeTel = myCell.getContents();
		    			String tmp[] = homeTel.split("-");
		    			if(tmp.length==0 || tmp.length==1){
		    				home1 = "";
		    				home2 = "";
		    				home3 = "";
		    			}else if(tmp.length==2){
		    				home1 = "02";
		    				home2 = tmp[0].replace(" ", "");
		    				home3 = tmp[1].replace(" ", "");
		    			}else if(tmp.length==3){
		    				home1 = tmp[0].replace(" ", "");
		    				home2 = tmp[1].replace(" ", "");
		    				home3 = tmp[2].replace(" ", "");
		    			}
	    			}else if(i == 4){
		    			String homeTel = myCell.getContents();
		    			String tmp[] = homeTel.split("-");
		    			if(tmp.length==0 || tmp.length==1){
		    				mobile1 = "";
		    				mobile2 = "";
		    				mobile3 = "";
		    			}else if(tmp.length==2){
		    				mobile1 = "";
		    				mobile2 = tmp[0].replace(" ", "");
		    				mobile3 = tmp[1].replace(" ", "");
		    			}else if(tmp.length==3){
		    				mobile1 = tmp[0].replace(" ", "");
		    				mobile2 = tmp[1].replace(" ", "");
		    				mobile3 = tmp[2].replace(" ", "");
		    			}
	    			}else if(i == 5){
	    			}else if(i == 6){
	    				boSeq = myCell.getContents();
	    			}
		    		
                }
		    	System.out.println("======>"+count);
	    		System.out.println("======>"+readNm);
	    		System.out.println("======>"+dlvZip);
	    		System.out.println("======>"+addr1);
	    		System.out.println("======>"+addr2);
	    		System.out.println("======>"+home1);
	    		System.out.println("======>"+home2);
	    		System.out.println("======>"+home3);
	    		System.out.println("======>"+mobile1);
	    		System.out.println("======>"+mobile2);
	    		System.out.println("======>"+mobile3);
	    		System.out.println("======>"+boSeq);
	    		
				dbparam.put("newsCd" , "100");
				dbparam.put("boSeq" , boSeq);
				dbparam.put("gno" , "500");
				dbparam.put("bno" , "000");
				dbparam.put("readTypeCd" , "017");
				dbparam.put("readNm" , readNm);
				dbparam.put("homeTel1" , home1);
				dbparam.put("homeTel2" , home2);
				dbparam.put("homeTel3" , home3);
				dbparam.put("mobile1" , mobile1);
				dbparam.put("mobile2" , mobile2);
				dbparam.put("mobile3" , mobile3);
				dbparam.put("dlvZip" , dlvZip);
				dbparam.put("dlvAdrs1" , addr1);
				dbparam.put("dlvAdrs2" , addr2);
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
				dbparam.put("uPrice" , "7500");
				dbparam.put("qty" , "1");
				dbparam.put("stQty" , "");
				dbparam.put("rsdTypeCd" , "");
				dbparam.put("dlvTypeCd" , "");
				dbparam.put("dlvPosiCd" , "");
				dbparam.put("hjPathCd" , "004");
				dbparam.put("hjTypeCd" , "");
				dbparam.put("hjPsregCd" , "");
				dbparam.put("hjPsnm" , "");
				dbparam.put("hjDt" , "20120301");
				dbparam.put("indt" , "20120301");
				dbparam.put("aplcDt" , "20120301");
				dbparam.put("sgBgmm" , "201203");
				dbparam.put("sgEdmm" , "");
				dbparam.put("sgCycle" , "");
				dbparam.put("stSayou" , "");
				dbparam.put("aplcNo" , "");
				dbparam.put("remk" , "");
				dbparam.put("inps" , "SYSTEM");
				dbparam.put("spgCd" , "");
				dbparam.put("bnsBookCd" , "");
				dbparam.put("taskCd" , "");
				dbparam.put("intFldCd" , "");
				dbparam.put("bidt" , "");
				dbparam.put("eMail" , "");
				dbparam.put("agency_serial", boSeq);
	   			
   				dbparam.put("readNo" , generalDAO.getSqlMapClient().queryForObject("reader.readerManage.getReadNo" , dbparam) );
	   			
	   			generalDAO.getSqlMapClient().insert("reader.readerManage.insertTmreader", dbparam); //통합독자생성
				generalDAO.getSqlMapClient().insert("reader.readerManage.inserTmreaderNews", dbparam); //구독정보 생성
				//generalDAO.getSqlMapClient().update("reader.education.updateEducation2", dbparam); //구독정보 생성
				generalDAO.getSqlMapClient().getCurrentConnection().commit();
				count++;
		    	System.out.println(	count+"건 완료.");
	   		}	

			    
			    mav.setViewName("admin/main");
				return mav;
			}catch(Exception ex){
				ex.printStackTrace();
				generalDAO.getSqlMapClient().getCurrentConnection().rollback();
				 mav.setViewName("admin/main");
				 return mav;
			}finally{
				generalDAO.getSqlMapClient().endTransaction();
			}

		}
	//통계
	public ModelAndView insertStatics(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();

		try{
			String text = "";
			String nLine = "\n";
			
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			HashMap dbparam = new HashMap();
			
			
			List agencyList = generalDAO.queryForList("common.getAgencyList2");
			for(int j=1 ; j<25 ;j++){
				String yymm = DateUtil.getWantDay(DateUtil.getCurrentDate("yyyyMMdd"), 2, -j).substring(0,6);
				dbparam.put("yymm", yymm);
				for(int i=0 ; i<agencyList.size() ; i++){
					Map tem = (Map)agencyList.get(i);
					dbparam.put("boSeq", tem.get("BOSEQ"));
					String msg = (String)generalDAO.queryForObject("etc.deadLine.statisticsInsert2" , dbparam);
				}
			}
			
			
		    
		    mav.setViewName("admin/main");
			return mav;
		}catch(Exception ex){
			ex.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			 mav.setViewName("admin/main");
			 return mav;
		}finally{
			generalDAO.getSqlMapClient().endTransaction();
		}

	}
		
	/*
	public void insertTest() throws Exception {

		DataSource ds = null;
		Connection conn = null;
		DatabaseMetaData metaData = null;
		OracleConnection oraConn = null;
		
		
		System.out.println("\n\n[insertTest]\n");
		
		
		
		try {
//			generalDAO.getSqlMapClient().startTransaction();
//			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);

//			ds = generalDAO.getDataSource();
//			conn = ds.getConnection();
//			conn.setAutoCommit(false);
			
			//generalDAO.setUserConnection(conn);
			

			
//			metaData = conn.getMetaData(); 
//			oraConn = (OracleConnection)metaData.getConnection();
			
//			Context ctx = new InitialContext();
//			ds = (DataSource)ctx.lookup("datasource_mkreader");
//			conn = ds.getConnection();
			
			
//			Driver myDriver = (Driver)Class.forName("jeus.jdbc.pool.Driver").newInstance();
//			conn = myDriver.connect("jdbc:jeus:pool:oraclePool", null);
			
			
//			conn.setAutoCommit(false);
			generalDAO.startTransaction();
			generalDAO.setAutoCommit(false);
			
			System.out.println("setAutoCommit = false");
			
			int cnt = (Integer) generalDAO.queryForObject("admin.getTestCount");
			System.out.println("cnt1 : " + cnt);
			
			// db query parameter		
			HashMap dbparam = new HashMap();
			
			dbparam = new HashMap();
			dbparam.put("COL_A", "a");
			dbparam.put("COL_B", "b");
			dbparam.put("COL_C", "c");			
			generalDAO.insert("admin.insertTest", dbparam);
			System.out.println("admin.insertTest");
			//conn.commit();
			
			cnt = (Integer) generalDAO.queryForObject("admin.getTestCount");
			System.out.println("cnt2 : " + cnt);
			
			generalDAO.update("admin.updateTest");
			System.out.println("admin.updateTest");
			//oraConn.commit();
			
			dbparam = new HashMap();
			dbparam.put("COL_A", "d");
			dbparam.put("COL_B", "e");			
			generalDAO.insert("admin.insertTest", dbparam);
			System.out.println("admin.insertTest");
			//oraConn.commit();
			
			generalDAO.commitTransaction();
		}
		catch (Exception e) {
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			System.out.println("testttttttttttttttttt");
//			if ( conn != null ) {
//				int cnt = (Integer) generalDAO.queryForObject("admin.getTestCount");
//				System.out.println("cnt3 : " + cnt);
//				
//				System.out.println("rollback");
//				conn.rollback();
//				
//				cnt = (Integer) generalDAO.queryForObject("admin.getTestCount");
//				System.out.println("cnt4 : " + cnt);
//			}
			
			e.printStackTrace();
		}
		finally {
			generalDAO.endTransaction();
			generalDAO.setAutoCommit(true);
//			if ( conn != null ) {
//				System.out.println("setAutoCommit = true");
////				conn.setAutoCommit(true);
//				//generalDAO.setUserConnection(conn);
//				
//			}
//			generalDAO.getSqlMapClient().endTransaction();			
		}
	}
	*/
	
	public ModelAndView ttransationTest(HttpServletRequest request,
			HttpServletResponse response) throws Exception  {
		
		Param param = new HttpServletParam(request);
			
		SqlMapClient sqlMapClient = null;
		
		try {
			
			// transaction start
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			int cnt = (Integer) generalDAO.queryForObject("admin.getTestCount");
			System.out.println("cnt try 1 : " + cnt);
			
			// db query parameter		
			HashMap dbparam = new HashMap();
			
			dbparam = new HashMap();
			dbparam.put("COL_A", "A");
			dbparam.put("COL_B", "B");
			dbparam.put("COL_C", "C");			
			generalDAO.getSqlMapClient().insert("admin.insertTest", dbparam);
			System.out.println("admin.insertTest");
			
			cnt = (Integer) generalDAO.getSqlMapClient().queryForObject("admin.getTestCount");
			System.out.println("cnt try 2 : " + cnt);
			
			generalDAO.getSqlMapClient().update("admin.updateTest");
			System.out.println("admin.updateTest");
			
			//generalDAO.getSqlMapClient().getCurrentConnection().commit();
			
			cnt = (Integer) generalDAO.getSqlMapClient().queryForObject("admin.getTestCount");
			System.out.println("cnt try3 : " + cnt);
			
			dbparam = new HashMap();
			dbparam.put("COL_A", "d");
			dbparam.put("COL_B", "e");			
			generalDAO.getSqlMapClient().insert("admin.insertTest", dbparam);
			System.out.println("admin.insertTest");
			
			cnt = (Integer) generalDAO.getSqlMapClient().queryForObject("admin.getTestCount");
			System.out.println("cnt try4 : " + cnt);
			
			// transaction commit
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			
			cnt = (Integer) generalDAO.getSqlMapClient().queryForObject("admin.getTestCount");
			System.out.println("cnt try5 : " + cnt);

//		insertTest();
		}
		catch (Exception e) {
			// transaction rollback
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
		}
		finally {
			// transaction end
			generalDAO.getSqlMapClient().endTransaction();
		}

		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("admin/main");
		
		return mav;
	}
	
	
	public ModelAndView ttransationTest2(HttpServletRequest request,
			HttpServletResponse response) throws Exception  {
		
		Param param = new HttpServletParam(request);
			
		
		try {
			
			int cnt = (Integer) generalDAO.queryForObject("admin.getTestCount");
			System.out.println("cnt11 : " + cnt);
			
			// db query parameter		
			HashMap dbparam = new HashMap();
			
			dbparam = new HashMap();
			dbparam.put("COL_A", "1");
			dbparam.put("COL_B", "2");
			dbparam.put("COL_C", "3");			
			generalDAO.insert("admin.insertTest", dbparam);
			System.out.println("admin.insertTest");
			//conn.commit();
			
			int cnt1 = (Integer) generalDAO.queryForObject("admin.getTestCount");
			System.out.println("cnt22 : " + cnt1);
			

//		insertTest();
		}
		catch (Exception e) {
			int cnt = (Integer) generalDAO.queryForObject("admin.getTestCount");
			System.out.println("cnt33 : " + cnt);
		}
		finally {
			
			int cnt = (Integer) generalDAO.queryForObject("admin.getTestCount");
			System.out.println("cnt44 : " + cnt);
		}

		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("admin/main");
		
		return mav;
	}
	
	
	public ModelAndView test(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		
		
		String str = "매일경제　　　　";
		System.out.println("1 : " + "A" + str + "B");
		System.out.println("2 : " + "A" + new String(str.getBytes("MS949"),"UTF-8") + "B");
		System.out.println("3 : " + "A" + new String(str.getBytes("UTF-8"),"MS949") + "B");
		System.out.println("4 : " + "A" + new String(str.getBytes("MS949")) + "B");
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("admin/main");
		
		return mav;
	}
	
	
	
	
	/**
	 * 관리자 메인
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView main(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		int no = param.getInt("no", 1);
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("admin/main");
		if ( no == 1 ) 		{	mav.addObject("now_menu", ICodeConstant.MENU_CODE_READER);		}
		else if ( no == 2 ) {	mav.addObject("now_menu", ICodeConstant.MENU_CODE_COLLECTION);	}
		else if ( no == 3 ) {	mav.addObject("now_menu", ICodeConstant.MENU_CODE_OUTPUT);		}
		else if ( no == 4 ) {	mav.addObject("now_menu", ICodeConstant.MENU_CODE_PRINT);		}
		else if ( no == 5 ) {	mav.addObject("now_menu", ICodeConstant.MENU_CODE_STATISTICS);	}
		else if ( no == 6 ) {	mav.addObject("now_menu", ICodeConstant.MENU_CODE_ETC);			}
		else if ( no == 7 ) {	mav.addObject("now_menu", ICodeConstant.MENU_CODE_COMMUNITY);	}
		else 				{	}//mav.addObject("now_menu", ICodeConstant.MENU_CODE_MANAGEMENT);	}
		
		return mav;
	}
	
	
	/**
	 * 관리자 메인
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView urlParamTest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		String topMenuId = param.getString("topMenuId");
		String topMenuNm = param.getString("topMenuNm");
		String subMenuId = param.getString("subMenuId");
		
		System.out.println("topMenuId1 = "+topMenuId);
		System.out.println("topMenuNm1 = "+topMenuNm);
		System.out.println("subMenuId1 = "+subMenuId);
		
		mav.addObject("topMenuId", topMenuId);
		mav.addObject("topMenuNm", topMenuNm);
		mav.addObject("subMenuId", subMenuId);
		
		mav.setViewName("main/leftMenu");
		
		return mav;
	}
}
