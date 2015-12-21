/*------------------------------------------------------------------------------
 * NAME : EdiElectController
 * DESC : 수금 - 전자수납관리
 * Author : jyyoo
 *----------------------------------------------------------------------------*/
package com.mkreader.web.collection;

import java.io.File;
import java.io.FileInputStream;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Iterator;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.servlet.util.MultipartHttpServletParam;
import kr.reflexion.espresso.util.Param;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.CommonUtil;
import com.mkreader.util.FileUtil;
import com.mkreader.util.Paging;



public class EdiElectController extends MultiActionController implements
		ISiteConstant {
	
	public static Logger logger = Logger.getRootLogger();

	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {

		this.generalDAO = generalDAO;
	}
	
	
	
	/**
	 * 전자수납번호 관리(GR65) 목록
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView gr65List(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		int pagesize = 15;
		int conternp = 10;
		String thisorder = "";
		String orderby = "";
		
		// param
		Param param = new HttpServletParam(request);
		int pageNo = param.getInt("pageNo", 1);			// 리스트의 몇번째 페이지인지 읽음
		String view = param.getString("view", "0");
		String view2 = param.getString("view2", "0");
		
		String search_key = param.getString("search_key");
		String search_type = param.getString("search_type");
		search_type = "txt";
	
		String strget1 = "view="+view+"&search_key="+search_key+"&search_type="+search_type+"&pageNo="+pageNo;
		String strget2 = "orders="+thisorder+"&orderby="+orderby;
		
		
		// db query parameter		
		HashMap dbparam = new HashMap();
		dbparam.put("PAGE_NO", pageNo);
		dbparam.put("PAGE_SIZE", pagesize);
		
		// excute query
		// 지국 목록
		List agencyList = generalDAO.queryForList("common.getAgencyList");
				
		List resultList = generalDAO.queryForList("collection.ediElect.getGR65LogList", dbparam);
		logger.debug("===== collection.ediElect.getGR65LogList");
		
		int t_count = (Integer) generalDAO.queryForObject("collection.ediElect.getGR65LogCount");
		logger.debug("===== collection.ediElect.getGR65LogCount");
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("collection/edi/gr65List");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_COLLECTION_EDI);
		mav.addObject("show_hidden3", "display");
		
		mav.addObject("pageNo", pageNo);
		mav.addObject("view", view);
		mav.addObject("view2", view2);
		mav.addObject("search_key", search_key);
		mav.addObject("search_type", search_type);
		mav.addObject("strget1", strget1);
		mav.addObject("strget2", strget2);
		mav.addObject("jcode", param.getString("jcode"));
		
		mav.addObject("agencyList", agencyList);
		mav.addObject("resultList", resultList);
		mav.addObject("t_count", t_count);
		mav.addObject("pageInfo", Paging.getPageMap(pageNo, t_count, pagesize, 10));
		
		return mav;
	}
	
	
	/**
	 * GR65파일 다운로드
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView view65(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
				
		// param
		Param param = new HttpServletParam(request);
		String numid = param.getString("numid");
		String fname = param.getString("fname");
		String yyyy = param.getString("yyyy");
		
		// db query parameter		
		HashMap dbparam = new HashMap();
		dbparam.put("numid", numid);
		
		Map resultMap = (Map) generalDAO.queryForObject("collection.ediElect.getGR65LogInfo", dbparam);
		logger.debug("===== collection.ediElect.getGR65LogInfo");

		String fileName = PATH_UPLOAD_RELATIVE_EDI_GR65 + "/" + yyyy + "/" + fname;
		int LINEBYTE =Integer.parseInt(resultMap.get("COUNTS").toString().trim());
		LINEBYTE = (LINEBYTE + 2) * 320;
		
		File f = new File(fileName);
		FileInputStream fis = new FileInputStream(f);
		byte[] b = new byte[LINEBYTE];

		String data ="";
		
		fis.read(b);
		data =   new String(b);
		// & 가 &amp;로 변환되어 읽어옴. 자바에서 변환되는지 view65에서 변환되는지 미확인 체크 필요 
		
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("collection/edi/view65");
		mav.addObject("now_menu", MENU_CODE_COLLECTION_EDI);

		mav.addObject("resultMap", resultMap);
		mav.addObject("data", data);
		mav.addObject("fname", fname);
		
		return mav;
	}
	
	
	
	/**
	 * 전자수납번호 (GR65) 파일생성
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView process65(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		// param
		Param param = new HttpServletParam(request);
		
		String fileType = "GR6533";
		String rdate = param.getString("rdate");
		String jcode = param.getString("jcode");
		
		String fdate = rdate;
		
		int errorch = 0;
		String error_str = "";

		String header_str = "";
		String data_str = "";
		String trailer_str = "";
		
		
		HashMap dbparam = new HashMap();
		
		// mav
		ModelAndView mav = new ModelAndView();
		
		// 현재날짜 (yyyymmdd)
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		String nowDate = df.format(cal.getTime());
		
		// 입력된 날짜 (yyyymmdd)
		String chedckdate = nowDate.substring(0, 2) + rdate;
		
		if ( nowDate.compareTo(chedckdate) != 0 ) {
			
			mav.setViewName("common/message");
			mav.addObject("message", "고지생성일은 현재일자만 가능합니다.");
			mav.addObject("returnURL", "/collection/ediElect/gr65List.do");
			return mav;
		}
		else {
			
			// Header Record 생성
			String fileDate = "";
			if ( rdate.length() > 4 ) {
				fileDate = rdate.substring(rdate.length()-4);
			}
			
			header_str = 	fileType					  		          // (1) 업무 구분("GR6533")
								+ CODE_EDI_LAYOUT_HEADER    // (2) 데이터구분 구분(Header Record 식별부호 "11")  // (2) 일련번호 ("00000000" 고정값)
								+ "90"								     // (3) 발행기관분류코드 (일반장표 : "90")
								+ MK_JIRO_NUMBER				     // (4) 지로번호 (직영지로번호 : "3146440")
								+ "매일경제신문사  "                // (5) 이용기관명
								+ chedckdate		  			         // (6) 전송일자 ("YYYYMMDD", File 이름과 동일한 날짜)
								;
			
			for ( int i = 0; i < 279; i++ ) {
				header_str += " ";
			}
			
			byte[] temp = header_str.getBytes();
			int header = temp.length;

			if ( StringUtils.isEmpty(header_str) || header != 320 ) {
				errorch = 1;
				error_str = " 헤더값 길이 오류";
			}

			// Tailer data를 위한 Data Record 사용 변수 정의
			int serialno =0;
			long totalmoney = 0;
			
			List resultList = null;
			Map resultMap = null;
			
			// 미수목록 추출
			dbparam = new HashMap();
			dbparam.put("jcode", jcode);
			dbparam.put("gu", "구 ");
			dbparam.put("apt", "아파트");
			resultList = generalDAO.queryForList("collection.ediElect.getSugmList", dbparam);
			logger.debug("===== collection.ediElect.getSugmList");
			
			
			serialno = 0;
			totalmoney = 0;
			String tmp = "";
			String data_tmp = "";
			
			try {
				// transaction start
				generalDAO.getSqlMapClient().startTransaction();					
				generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
				if ( resultList != null && resultList.size() > 0 ) {
					Iterator iter = resultList.iterator();
					
					while ( iter.hasNext() ) {
						resultMap = (Map) iter.next();
						
						String boseq = (String) resultMap.get("BOSEQ");
						String giroNo = (String) resultMap.get("GIRO_NO");
						String readNm = (String) resultMap.get("READNM");
						String addr = (String) resultMap.get("ADDR");
						String yymm = (String) resultMap.get("YYMM");
						BigDecimal billamt = (BigDecimal) resultMap.get("BILLAMT");
						String gubun = (String) resultMap.get("GUBUN");
						String period = (String) resultMap.get("PERIOD");
						String months = (String) resultMap.get("MONTHS");
						String expire = (String) resultMap.get("EXPIRE");
						String readband = (String) resultMap.get("READBAND");	

						// Data Record 생성
						String temp_str = "";
	
						// 1. 업무구분(6)
						temp_str = fileType;
					        	
						serialno++;
						
						// 2. Data 구분(2)
						temp_str += CODE_EDI_LAYOUT_DATA;
						
						// 3. 일련번호(7)
						tmp = "0000000" + serialno;
						temp_str += tmp.substring(tmp.length()-7);

						// 4. 고객조회번호(20)
						temp_str += readband;
						
						// 5. 납기내 금액(12)
						tmp = "000000000000" + Integer.parseInt(billamt.toString());
						temp_str += tmp.substring(tmp.length()-12);
						
						// 6. 납기후 금액(12)
						temp_str += tmp.substring(tmp.length()-12);
						
						// 7. 데이터 형식구분(1)
						temp_str += "A";
						
						// 8. 납기일(8)
						temp_str += expire+"10";
						
						// 9. 고지마감일(8)
						temp_str += expire+"10";
						
						// 10. 지로번호(7)
						temp_str += giroNo;
						
						// 11. 전자납부번호(14)
						temp_str += readband.substring(0,13)+" " ;
						
						// 12. 고객관리번호(30)
						for ( int i = 0; i < 30; i++ ) {
							temp_str += " ";
						}
						
						// 13. 고지(발행)형태(1)
						temp_str += gubun ;
						
						// 14. 기타구분코드(2)
						temp_str += "00" ;
						
						// 15. 납부자성명(16)
						tmp = readNm;
						for ( int i = 0; i < 16; i++ ) {
							tmp += " ";
						}
						temp_str += strCut(tmp, null, 16, 0, true, true);
						
						// 16. 주민등록번호(13)
						for ( int i = 0; i < 13; i++ ) {
							temp_str += " ";
						}
						
						// 17. 납부년월(회)차 (6)
						temp_str += yymm ;
						
						// 18. 고객주소(80)
						tmp = addr;
						for ( int i = 0; i < 80; i++ ) {
							tmp += " ";
						}
						temp_str += strCut(tmp, null, 80, 0, true, true);
						
						// 19. 처리결과코드(2)
						temp_str += "  ";
						
						// 20. 납부우선순위(1)
						temp_str += "0";
						
						// 21. 체납기간(8)
						temp_str += period;
						
						// 22. 체납개월수(3)
						temp_str += months;
						
						// 23. 기타고지정보 건수(2)
						temp_str += "00";
						
						// 24. 기타고지정보(40), Filler(19)
						for ( int i = 0; i < 59; i++ ) {
							temp_str += " ";
						}
						
						if(temp_str.getBytes().length != 320) {
							System.out.println("전자수납 오류 독자 = "+temp_str);
						}
						
						data_tmp += temp_str;
						
						if(serialno % 10000 == 0){
							data_str += data_tmp;
							System.out.println("GR65 File "+serialno+"Line Completed !");
							data_tmp = "";
						}else if(resultList.size() == serialno){
							data_str += data_tmp;
							System.out.println("GR65 File "+serialno+"Last Line Completed !");
						}
						
						totalmoney += Integer.parseInt(billamt.toString());
						
					}
				}
				// Data Record 생성 끝 - DB로 부터 추출
				
				// Trailer Record 생성 
				trailer_str = "";
				trailer_str += fileType;									// (1)업무구분
				trailer_str += CODE_EDI_LAYOUT_TRAILER;		// (2)데이터구분
				tmp = "0000000" + serialno;
				trailer_str += tmp.substring(tmp.length()-7);		// (3)총 건수
				tmp = "00000000000000" + totalmoney; 
				trailer_str += tmp.substring(tmp.length()-14);	// (4)납기내 금액합계
				trailer_str += tmp.substring(tmp.length()-14);	// (5)납기후 금액합계
				
				for ( int i = 0; i < 277; i++ ) {
					trailer_str += " ";									// FILLER(63)
				}
				
				if ( trailer_str.length() != 320 ) {
					errorch = 1;
					error_str = error_str + " Trailer 레코드 길이 오류 ";
				}
				// Tailer Record 생성 끝
				
				// 전체 Record 연결
				String text = header_str + data_str + trailer_str;
	
				// 파일생성
				if ( StringUtils.isNotEmpty(text) ) {
					
					Calendar now = Calendar.getInstance();
					String year = Integer.toString(now.get(Calendar.YEAR));
					
					try {
						FileUtil.saveTxtFile(
								PATH_UPLOAD_RELATIVE_EDI_GR65 + "/" + year.substring(0, 2) + rdate.substring(0, 2), 
								"GR65" + rdate.substring(2, 6), 
								text,
								ENCODING_TYPE_CMS
							);
					} catch(Exception e) {
						mav.setViewName("common/message");
						mav.addObject("message", "파일생성 실패");
						mav.addObject("returnURL", "/collection/gr65List.do");
						return mav;
					}
				}
				else {
					mav.setViewName("common/message");
					mav.addObject("message", "파일생성할 데이터가 없습니다.");
					mav.addObject("returnURL", "/collection/gr65List.do");
					return mav;
				}
				
				if ( serialno == 0 ) {
					mav.setViewName("common/message");
					mav.addObject("message", "생성될 데이터가 없습니다.");
					mav.addObject("returnURL", "/collection/gr65List.do");
					return mav;
				}
				else {
					HttpSession session = request.getSession();
					
					dbparam = new HashMap();
					dbparam.put("counts", serialno);
					dbparam.put("filedt", chedckdate);
					dbparam.put("filename", "GR65" + rdate.substring(2, 6));
					dbparam.put("money", totalmoney);
					dbparam.put("userid", session.getAttribute(SESSION_NAME_ADMIN_USERID));
					generalDAO.getSqlMapClient().insert("collection.ediElect.insertGR65Log", dbparam);
					logger.debug("===== collection.ediElect.insertGR65Log");

					// 파일생성으로 연것에 파일로 씀
					if ( errorch == 0 ) {
						error_str = "정상출력";
						
						// transaction commit
						generalDAO.getSqlMapClient().getCurrentConnection().commit();
					}
					else {
						// transaction rollback
						generalDAO.getSqlMapClient().getCurrentConnection().rollback();
					}
				}
			}
			catch (Exception e) {
				// transaction rollback
				generalDAO.getSqlMapClient().getCurrentConnection().rollback();
				System.out.println("serialno:"+serialno ) ;
				e.printStackTrace();
				error_str = "정상적으로 처리되지 않았습니다.";
			}
			finally {
				// transaction end
				generalDAO.getSqlMapClient().endTransaction();
			}
			
			mav.setViewName("collection/edi/process65b");
			mav.addObject("now_menu", ICodeConstant.MENU_CODE_COLLECTION_EDI);
			mav.addObject("fname", "GR65" + rdate.substring(2, 6));
			mav.addObject("jcode", jcode);
			mav.addObject("serialno", serialno);
			mav.addObject("error_str", error_str);
			return mav;
		}
	}
	
		


	public String strCut(String szText, String szKey, int nLength, int nPrev, boolean isNotag, boolean isAdddot){  // 문자열 자르기
	    
	    String r_val = szText;
	    int oF = 0, oL = 0, rF = 0, rL = 0; 
	    int nLengthPrev = 0;
	    Pattern p = Pattern.compile("<(/?)([^<>]*)?>", Pattern.CASE_INSENSITIVE);  // 태그제거 패턴
	   
	    if(isNotag) {r_val = p.matcher(r_val).replaceAll("");}  // 태그 제거
	    r_val = r_val.replaceAll("&amp;", "&");
	    //r_val = r_val.replaceAll("(!/|\r|\n|&nbsp;)", "");  // 공백제거옵션
	 
	    try {
	      byte[] bytes = r_val.getBytes("UTF-8");     // 바이트로 보관 
	      if(szKey != null && !szKey.equals("")) {
	        nLengthPrev = (r_val.indexOf(szKey) == -1)? 0: r_val.indexOf(szKey);  // 일단 위치찾고
	        nLengthPrev = r_val.substring(0, nLengthPrev).getBytes("MS949").length;  // 위치까지길이를 byte로 다시 구한다
	        nLengthPrev = (nLengthPrev-nPrev >= 0)? nLengthPrev-nPrev:0;    // 좀 앞부분부터 가져오도록한다.
	      }
	    
	      // x부터 y길이만큼 잘라낸다. 한글안깨지게.
	      int j = 0;
	 
	      if(nLengthPrev > 0) while(j < bytes.length) {
	        if((bytes[j] & 0x80) != 0) {
	          oF+=2; rF+=3; if(oF+2 > nLengthPrev) {break;} j+=3;
	        } else {if(oF+1 > nLengthPrev) {break;} ++oF; ++rF; ++j;}
	      }
	      
	      j = rF;
	 
	      while(j < bytes.length) {
	        if((bytes[j] & 0x80) != 0) {
	          if(oL+2 > nLength) {break;} oL+=2; rL+=3; j+=3;
	        } else {if(oL+1 > nLength) {break;} ++oL; ++rL; ++j;}
	      }
	 
	      r_val = new String(bytes, rF, rL, "UTF-8");  // charset 옵션
	 
	      //if(isAdddot && rF+rL+3 <= bytes.length) {r_val+="...";}  // ...을 붙일지말지 옵션 
	    } catch(UnsupportedEncodingException e){ e.printStackTrace(); }   
	    
	    return r_val;
	  }
	
}
