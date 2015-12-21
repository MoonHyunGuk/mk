/*------------------------------------------------------------------------------
 * NAME : EmpExtdController 
 * DESC : 사원확장 컨트롤러
 * Author : ycpark
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
import jxl.DateCell;
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

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.DateUtil;
import com.mkreader.util.FileUtil;
import com.mkreader.util.Paging;
import com.mkreader.util.StringUtil;

public class EmpExtdController extends MultiActionController
implements ISiteConstant, ICodeConstant {

	private GeneralDAO generalDAO;
	
	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}
	
	/**
	 * 사원확장 리스트
	 * 
	 * @param request
	 * @param response
	 * @author ycpark
	 * @category 사원확장 리스트
	 * @return
	 * @throws Exception
	 */

	public ModelAndView empExtdList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		try{
			HashMap dbparam = new HashMap();
			
			//현재날짜
			Calendar rightNow = Calendar.getInstance();
//			Calendar preweek = Calendar.getInstance();
//			preweek.add(Calendar.DATE, -7);
//
//			String preYear = String.valueOf(preweek.get(Calendar.YEAR));
//			String preMonth = String.valueOf(preweek.get(Calendar.MONTH) + 1);
//			String preDay = String.valueOf(preweek.get(Calendar.DAY_OF_MONTH));
//
//			if (preMonth.length() < 2){
//				preMonth = "0" + preMonth;
//			}
//			if (preDay.length() < 2){
//				preDay = "0" + preDay;
//			}
			
			String year = String.valueOf(rightNow.get(Calendar.YEAR));
			String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
			String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));

			if (month.length() < 2){
				month = "0" + month;
			}
			if (day.length() < 2){
				day = "0" + day;
			}

			String fromDate= param.getString("fromDate", year + "-01-01");						//기간 from
			String toDate= param.getString("toDate", year + "-" + month + "-" + day);				//기간 to

			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 20;
			int totalCount = 0;
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			dbparam.put("dateType","1");
			dbparam.put("fromDate", StringUtil.replace(fromDate, "-", ""));
			dbparam.put("toDate", StringUtil.replace(toDate, "-", ""));
			
			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" );// 지국 목록
			List companyCd = generalDAO.queryForList("reader.common.retrieveCompany"); //회사명조회
			
			List empExtdList = generalDAO.queryForList("reader.empExtd.getEmpExtdList", dbparam);
			totalCount = generalDAO.count("reader.empExtd.empExtdListCount" , dbparam);
			
			List totalEmpExtdCount = generalDAO.queryForList("reader.empExtd.getTotalCount" , dbparam);

			mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("companyCd" , companyCd);
			mav.addObject("fromDate", fromDate);
			mav.addObject("toDate", toDate);
			mav.addObject("totalEmpExtdCount", totalEmpExtdCount);
			mav.addObject("empExtdList", empExtdList);
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 10));
			mav.addObject("now_menu", MENU_CODE_EMP_EXTD);
			mav.setViewName("reader/empExtdList");
			
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
	 * 사원확장 리스트 조회
	 * 
	 * @param request
	 * @param response
	 * @author ycpark
	 * @category 사원확장 리스트 조회
	 * @return
	 * @throws Exception
	 */
	public ModelAndView searchEmpExtd(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		try{
			HashMap dbparam = new HashMap();
			
			//현재날짜
			Calendar rightNow = Calendar.getInstance();
			
			String year = String.valueOf(rightNow.get(Calendar.YEAR));
			String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
			String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));

			if (month.length() < 2){
				month = "0" + month;
			}
			if (day.length() < 2){
				day = "0" + day;
			}

			String fromDate= param.getString("fromDate", year + "-" + month + "-" + day);		//기간 from
			String toDate= param.getString("toDate", year + "-" + month + "-" + day);				//기간 to
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 20;
			int totalCount = 0;

			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			dbparam.put("media", param.getString("media"));
			dbparam.put("readerTyp", param.getString("readerTyp"));
			dbparam.put("gubun", param.getString("gubun"));
			dbparam.put("status", param.getString("status"));
			dbparam.put("boseq", param.getString("boseq"));
			dbparam.put("empComp", param.getString("empComp"));
			dbparam.put("empDept", param.getString("empDept"));
			dbparam.put("empTeam", param.getString("empTeam"));
			dbparam.put("dateType", param.getString("dateType"));
			dbparam.put("fromDate", StringUtil.replace(fromDate, "-", ""));
			dbparam.put("fromDate", StringUtil.replace(fromDate, "-", ""));
			dbparam.put("toDate", StringUtil.replace(toDate, "-", ""));
			dbparam.put("search_type", param.getString("search_type"));
			dbparam.put("search_value", param.getString("search_value"));
			
			
			System.out.println("dbparam>>"+dbparam);
			List empExtdList = generalDAO.queryForList("reader.empExtd.getEmpExtdList", dbparam);
			totalCount = generalDAO.count("reader.empExtd.empExtdListCount" , dbparam);

			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" );// 지국 목록
			List companyCd = generalDAO.queryForList("reader.common.retrieveCompany"); //회사명조회
			dbparam.put("resv1", param.getString("empComp"));
			dbparam.put("resv3", "1");
			List deptCd = generalDAO.queryForList("reader.empExtd.retrieveCode", dbparam); //부서명조회
			dbparam.put("resv1", param.getString("empDept"));
			dbparam.put("resv3", "2");
			List teamCd = generalDAO.queryForList("reader.empExtd.retrieveCode", dbparam); //팀명조회
			
			List totalEmpExtdCount = generalDAO.queryForList("reader.empExtd.getTotalCount" , dbparam);
			
			mav.addObject("media", param.getString("media"));
			mav.addObject("readerTyp", param.getString("readerTyp"));
			mav.addObject("gubun", param.getString("gubun"));
			mav.addObject("boseq", param.getString("boseq"));
			mav.addObject("empComp", param.getString("empComp"));
			mav.addObject("empDept", param.getString("empDept"));
			mav.addObject("empTeam", param.getString("empTeam"));
			mav.addObject("status", param.getString("status"));
			mav.addObject("dateType", param.getString("dateType"));
			mav.addObject("fromDate", fromDate);
			mav.addObject("toDate", toDate);
			mav.addObject("search_type", param.getString("search_type"));
			mav.addObject("search_value", param.getString("search_value"));
			mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("teamCd" , teamCd);
			mav.addObject("deptCd" , deptCd);
			mav.addObject("companyCd" , companyCd);
			mav.addObject("totalEmpExtdCount", totalEmpExtdCount);
			mav.addObject("empExtdList", empExtdList);
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 10));
			mav.addObject("now_menu", MENU_CODE_EMP_EXTD);
			mav.setViewName("reader/empExtdList");
			
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
	 * 사원확장 등록 페이지 오픈
	 * 
	 * @param request
	 * @param response
	 * @author ycpark
	 * @category 사원확장 등록 팝업 호출
	 * @return
	 * @throws Exception
	 */
	public ModelAndView empExtdEdit(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		try{
			HashMap dbparam = new HashMap();
			
			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" );// 지국 목록
			List areaCode = generalDAO.queryForList("reader.common.retrieveAreaCode" );// 전화번호 지역번호 조회
			List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" );// 휴대폰 앞자리 번호 조회
			List companyCd = generalDAO.queryForList("reader.common.retrieveCompany"); //회사명조회
			//List officeCd = generalDAO.queryForList("reader.common.retrieveOffice"); //부서명조회

			mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("areaCode" , areaCode);
			mav.addObject("mobileCode" , mobileCode);
			mav.addObject("companyCd" , companyCd);
			mav.addObject("now_menu", MENU_CODE_EMP_EXTD);
			mav.setViewName("reader/empExtdEdit");
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
	 * 사원확장 상세정보 페이지 오픈
	 * 
	 * @param request
	 * @param response
	 * @author ycpark
	 * @category 사원확장 상세정보 페이지 오픈
	 * @return
	 * @throws Exception
	 */
	public ModelAndView empExtdInfo(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		try{
			HashMap dbparam = new HashMap();

			dbparam.put("numId", param.getInt("numId"));

			List agencyAllList = generalDAO.queryForList("reader.common.agencyAllList" );// 지국 목록
			List areaCode = generalDAO.queryForList("reader.common.retrieveAreaCode" );// 전화번호 지역번호 조회
			List mobileCode = generalDAO.queryForList("reader.common.retrieveMobileCode" );// 휴대폰 앞자리 번호 조회
			List companyCd = generalDAO.queryForList("reader.common.retrieveCompany"); //회사명조회
			//List officeCd = generalDAO.queryForList("reader.common.retrieveOffice"); //부서명조회
			
			List empExtdInfo = generalDAO.queryForList("reader.empExtd.getEmpExtdInfo", dbparam );	// 사원확장 정보

			mav.addObject("empExtdInfo" , empExtdInfo);
			mav.addObject("agencyAllList" , agencyAllList);
			mav.addObject("areaCode" , areaCode);
			mav.addObject("mobileCode" , mobileCode);
			mav.addObject("companyCd" , companyCd);
			mav.addObject("now_menu", MENU_CODE_EMP_EXTD);
			mav.setViewName("reader/empExtdEdit");
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
	 * 사원확장 등록
	 * 
	 * @param request
	 * @param response
	 * @author ycpark
	 * @category 사원확장 등록
	 * @return
	 * @throws Exception
	 */
	public ModelAndView saveEmpExtd(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		try{
			HashMap dbparam = new HashMap();	
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);

			// 파라미터 세팅
			dbparam.put("media", param.getString("media"));			// 매체
			dbparam.put("readerTyp", param.getString("readerTyp"));	// 독자유형
			dbparam.put("gubun", param.getString("gubun"));			// 신청구분
			dbparam.put("readNm", param.getString("readNm"));		// 독자명
			dbparam.put("compNm", param.getString("compNm"));		// 회사명(담당자)

			//String readTel = param.getString("readTel1")+param.getString("readTel2")+param.getString("readTel3");
			dbparam.put("readTel", param.getString("readTel"));
			dbparam.put("qty", param.getString("qty"));				// 구독부수
			dbparam.put("empComp", param.getString("empComp"));		// 권유자소속회사
			dbparam.put("empDept", param.getString("empDept"));		// 권유자소속부서
			dbparam.put("empTeam", param.getString("empTeam"));		// 권유자소속팀
			dbparam.put("empNm", param.getString("empNm"));			// 권유자
			dbparam.put("empNo", param.getString("empNo"));			// 권유자사번
			// 권유자 연락처
			//String empTel = param.getString("empTel1")+param.getString("empTel2")+param.getString("empTel3");
			dbparam.put("empTel", param.getString("empTel"));
			dbparam.put("memo", param.getString("memo"));			// 비고 및 전달사항

			String aplcYn = "";
			if("on".equals(param.getString("aplcYn"))){
				aplcYn = "Y";
			}else{
				aplcYn = "N";
			}

			dbparam.put("loginId" , (String)session.getAttribute(SESSION_NAME_ADMIN_USERID)); // 로그인아이디
			
			// 신문-일반 인 경우
			if("1".equals(param.getString("media")) && "1".equals(param.getString("readerTyp"))){
				
				dbparam.put("zip", param.getString("zip"));				// 우편번호
				dbparam.put("addr1", param.getString("addr1"));			// 구독자 주소
				dbparam.put("addr2", param.getString("addr2"));			// 구독자 상세주소
				dbparam.put("addr2", param.getString("addr2"));			// 구독자 상세주소
				dbparam.put("newaddr", param.getString("newaddr"));		// 구독자 도로명주소
				dbparam.put("bdMngNo", param.getString("bdMngNo"));		// 구독자 건물관리번호
				dbparam.put("boseq", param.getString("boseq"));			// 관리지국
				
				// 본사신청독자입력 인 경우
				if("Y".equals(aplcYn)){

					dbparam.put("status", "3");								// 사원확장 상태(3: 정상)
					dbparam.put("newsCd", "100");							// 신문코드(100: 매일경제)
					dbparam.put("readTypeCd", "011");						// 독자유형코드(011: 일반)
					dbparam.put("sgType", "011");							// 수금방법코드(011: 지로)
					//dbparam.put("hjDt", "011");							// 확장일
					dbparam.put("hjPathCd", "005");							// 확장경로(005: 사원확장)
					//dbparam.put("hjPsregCd", "005");						// 확장자 등록코드
					dbparam.put("flag", "1");
	
					// 구독자 연락처
					String readTel1 = "";
					String readTel2 = "";
					String readTel3 = "";
					
					// 구독자 연락처 2번째 숫자가 1이 아니면 집전화 또는 사무실 전화
					if(!"1".equals(param.getString("readTel").substring(1,2))){

						if(param.getString("readTel").length() == 9){
							readTel1 = param.getString("readTel").substring(0, 2);
							readTel2 = param.getString("readTel").substring(2, 5);
							readTel3 = param.getString("readTel").substring(5, 9);
						}else if(param.getString("readTel").length() == 10){
							if("02".equals(param.getString("readTel").substring(0, 2))){
								readTel1 = param.getString("readTel").substring(0, 2);
								readTel2 = param.getString("readTel").substring(2, 6);
								readTel3 = param.getString("readTel").substring(6, 10);
							}else{
								readTel1 = param.getString("readTel").substring(0, 3);
								readTel2 = param.getString("readTel").substring(3, 6);
								readTel3 = param.getString("readTel").substring(6, 10);
							}
						}else if(param.getString("readTel").length() == 11){
							readTel1 = param.getString("readTel").substring(0, 3);
							readTel2 = param.getString("readTel").substring(3, 7);
							readTel3 = param.getString("readTel").substring(7, 11);
						}else{

						}

						dbparam.put("homeTel1", readTel1);	// 구독자 전화번호1
						dbparam.put("homeTel2", readTel2);	// 구독자 전화번호2
						dbparam.put("homeTel3", readTel3);	// 구독자 전화번호3
					}else{
						
						if(param.getString("readTel").length() == 10){
							readTel1 = param.getString("readTel").substring(0, 3);
							readTel2 = param.getString("readTel").substring(3, 6);
							readTel3 = param.getString("readTel").substring(6, 10);
						}else if(param.getString("readTel").length() == 11){
							readTel1 = param.getString("readTel").substring(0, 3);
							readTel2 = param.getString("readTel").substring(3, 7);
							readTel3 = param.getString("readTel").substring(7, 11);
						}else{

						}

						dbparam.put("readTel1", readTel1);	// 구독자 전화번호1
						dbparam.put("readTel2", readTel2);	// 구독자 전화번호2
						dbparam.put("readTel3", readTel3);	// 구독자 전화번호3
					}

					// 최초입력건 
					if("".equals(param.getString("aplcNo"))){
						// 1.1.1 독자 신청 테이블 입력(신청테이블의 신청번호를 획득하기 위해 먼저 입력)
						String aplcDt = (String)generalDAO.getSqlMapClient().queryForObject("reader.empExtd.getAplcDt" , dbparam);
						dbparam.put("aplcDt", aplcDt);
						String aplcNo = (String)generalDAO.getSqlMapClient().queryForObject("reader.empExtd.getAplcNo" , dbparam);
						dbparam.put("aplcNo", aplcNo);
						// 신청번호
						generalDAO.getSqlMapClient().insert("reader.empExtd.insertAplcInfo", dbparam);
					}
					
					// 1.1.2 numid가 없는 경우 -> 최초 입력건
					if(param.getString("numId") == null || "".equals(param.getString("numId"))){
						dbparam.put("status", "1");
						dbparam.put("aplcNo", param.getString("aplcNo"));
						dbparam.put("ntDt", param.getString("ntDt"));
						dbparam.put("ntPs", param.getString("ntPs"));
						// 사원확장 테이블 입력
						generalDAO.getSqlMapClient().insert("reader.empExtd.insertEmpExtd", dbparam);
						// 1.1.3 numid가 있는경우 -> 접수건
					}else{
						dbparam.put("aplcNo", param.getString("aplcNo"));
						// 사원확장 테이블 업데이트
						dbparam.put("ntDt", param.getString("ntDt"));
						dbparam.put("ntPs", param.getString("ntPs"));
						dbparam.put("numId", param.getString("numId"));
						generalDAO.getSqlMapClient().update("reader.empExtd.updateEmpExtd", dbparam);
					}
					
				// 본사신청 독자가 아닌경우
				}else{						
					dbparam.put("zip", param.getString("zip"));				// 우편번호
					dbparam.put("addr1", param.getString("addr1"));			// 구독자 주소
					dbparam.put("addr2", param.getString("addr2"));			// 구독자 상세주소
					dbparam.put("boseq", param.getString("boseq"));			// 관리지국
					
					// 1.1.2 numid가 없는 경우 -> 최초 입력건
					if(param.getString("numId") == null || "".equals(param.getString("numId"))){
						dbparam.put("aplcNo", param.getString("aplcNo"));
						// 사원확장 테이블 입력
						dbparam.put("status", "1");
						System.out.println("saveEmpExtd>>>>"+dbparam);
						generalDAO.getSqlMapClient().insert("reader.empExtd.insertEmpExtd", dbparam);
						// 1.1.3 numid가 있는경우 -> 접수건
					}else{
						dbparam.put("aplcNo", param.getString("aplcNo"));
						// 사원확장 테이블 업데이트
						dbparam.put("numId", param.getString("numId"));
						generalDAO.getSqlMapClient().update("reader.empExtd.updateEmpExtd", dbparam);
					}
				}
				
			// 신문- 일반이 아닌경우		
			}else{
				dbparam.put("zip", param.getString("zip"));				// 우편번호
				dbparam.put("addr1", param.getString("addr1"));			// 구독자 주소
				dbparam.put("addr2", param.getString("addr2"));			// 구독자 상세주소
				dbparam.put("boseq", param.getString("boseq"));			// 관리지국
				
				// 1.1.2 numid가 없는 경우 -> 최초 입력건
				if(param.getString("numId") == null || "".equals(param.getString("numId"))){
					dbparam.put("aplcNo", param.getString("aplcNo"));
					// 사원확장 테이블 입력
					dbparam.put("boseq", param.getString("boseq"));			// 관리지국
					dbparam.put("status", "3");
					dbparam.put("ntDt", "");
					dbparam.put("ntPs", "");
					dbparam.put("flag", "2");
					generalDAO.getSqlMapClient().insert("reader.empExtd.insertEmpExtd", dbparam);
				}else{
					System.out.println("신문-일반이 아닌 경우-업데이트"+dbparam);
					dbparam.put("aplcNo", param.getString("aplcNo"));
					// 사원확장 테이블 업데이트
					dbparam.put("boseq", param.getString("boseq"));			// 관리지국
					dbparam.put("numId", param.getString("numId"));
					dbparam.put("status", "3");
					dbparam.put("ntDt", "");
					dbparam.put("ntPs", "");
					dbparam.put("flag", "2");
					generalDAO.getSqlMapClient().update("reader.empExtd.updateEmpExtd", dbparam);
				}
			}

			generalDAO.getSqlMapClient().getCurrentConnection().commit();

			mav.setViewName("common/message");
			mav.addObject("message", "사원확장 등록 처리가 완료 되었습니다.");
			mav.addObject("returnURL", "/reader/empExtd/empExtdList.do");
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
	 * 사원확장 중지 처리
	 * 
	 * @param request
	 * @param response
	 * @author ycpark
	 * @category 사원확장 중지 처리
	 * @return
	 * @throws Exception
	 */
	public ModelAndView deleteEmpExtd(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		HttpSession session = request.getSession();
		HashMap dbparam = new HashMap();
		
		try{
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);

			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			if("A".equals(loginType)){

				dbparam.put("numId", param.getString("numId"));
				dbparam.put("status", "4");	

				// 사원 확장 업데이트
				generalDAO.getSqlMapClient().update("reader.empExtd.deleteEmpExtd", dbparam);
				// 커밋
				generalDAO.getSqlMapClient().getCurrentConnection().commit();
				mav.addObject("message", "중지처리 되었습니다.");
				mav.setViewName("common/message");
				mav.addObject("returnURL", "/reader/empExtd/empExtdList.do");
				return mav;				
			}else{
				mav.setViewName("common/message");
				mav.addObject("message", MSG_LOGIN_NOT_AUTH_ADMIN);
				mav.addObject("returnURL", "/reader/empExtd/empExtdList.do");
				return mav;
			}
			
		}catch(Exception e){
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/reader/empExtd/empExtdList.do");
			return mav;
		}finally{
			generalDAO.getSqlMapClient().endTransaction();
		}
	}
		
	/**
	 * 사원확장 등록 파일 처리
	 * 
	 * @param request
	 * @param response
	 * @author ycpark
	 * @category 사원확장 등록 파일 처리
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView uploadEmpExtdFile(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		System.out.println("uploadCardReaderFile start");

		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		HashMap dbparam = new HashMap();
		
		try{
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			MultipartHttpServletParam param = new MultipartHttpServletParam(request);
			MultipartFile empExtdFile = param.getMultipartFile("empExtdFile");
			
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);
			String loginId = (String)session.getAttribute(SESSION_NAME_ADMIN_USERID);
			
			// 본사 권한 확인
			if("A".equals(loginType)){
				// 파일 첨부 여부 확인
				if(!empExtdFile.isEmpty()){

					Calendar now = Calendar.getInstance();
					FileUtil fileUtil = new FileUtil( getServletContext() );
					String fileUploadPath = fileUtil.saveUploadFile(empExtdFile, 
											PATH_PHYSICAL_HOME,
											PATH_DIR_CARD
										);
					
					// 파일 처리
					if(StringUtils.isNotEmpty(fileUploadPath)) {
					
						String fileName = PATH_PHYSICAL_HOME+PATH_DIR_CARD+"/"+fileUploadPath;
						
						Workbook myWorkbook = Workbook.getWorkbook(new File(fileName)); // 파일을 읽어 와서...
					    Sheet mySheet = myWorkbook.getSheet(0);

				    	// Data 추출
				    	for(int no=1 ; no < mySheet.getRows() ; no++){

				    		String media = "";				// 매체구분
						    String readerTyp = "";			// 독자유형
						    String gubun = "";				// 신청구분
						    String readNm = "";				// 구독자명
						    String compNm = "";				// 회사명
						    String zip = "";				// 우편번호
						    String addr1 = "";				// 구독자 주소
						    String addr2 = "";				// 구독자 상세주소
						    String readTel = "";			// 구독자 연락처
						    String qty = "";				// 구독부수
						    String aplcDt = "";				// 신청일
						    String empComp = "";			// 권유자 소속회사
						    String empDept = "";			// 권유자 소속지국
						    String empTeam = "";			// 권유자 소속부서
					    	String empNm = "";				// 권유자명
					    	String empTel = ""; 			// 권유자 연락처
					    	String boseq = "";				// 지국코드
					    	String resv1 = "";
				    		
				    		for(int i=0 ; i < mySheet.getColumns() ; i++){ 
					    		Cell myCell = mySheet.getCell(i, no);
					    		if(i == 0){								// 매체구분
					    			media = myCell.getContents();
					    		}else if(i == 1){						// 신청구분
					    			gubun = myCell.getContents();
					    		}else if(i == 2){						// 독자유형
					    			readerTyp = myCell.getContents();
					    		}else if(i == 3){						// 독자명
					    			readNm = myCell.getContents();
					    		}else if(i == 4){						// 회사명
					    			compNm = myCell.getContents();
					    		}else if(i == 5){						// 우편번호
					    			zip = myCell.getContents();
					    		}else if(i == 6){						// 주소1
					    			addr1 = myCell.getContents();
					    		}else if(i == 7){						// 주소2
					    			addr2 = myCell.getContents();
					    		}else if(i == 8){						// 구독자연락처
					    			readTel = myCell.getContents();
					    		}else if(i == 9){						// 부수
					    			qty = myCell.getContents();
					    		}else if(i == 10){						// 신청일
					    			aplcDt = myCell.getContents();
					    		}else if(i == 11){						// 지국코드
					    			boseq = myCell.getContents();
					    		}else if(i == 12){						// 회사명
					    			empComp = myCell.getContents();
					    		}else if(i == 13){						// 실국명
					    			empDept = myCell.getContents();
					    		}else if(i == 14){						// 부서명
					    			empTeam = myCell.getContents();
					    		}else if(i == 15){				    	// 권유자성명
					    			empNm = myCell.getContents();
					    		}else if(i == 16){						// 권유자휴대폰
					    			empTel = myCell.getContents();					    			
					    		}
				    		}
				    		
				    		dbparam.put("readNm", readNm);
				    		dbparam.put("compNm", compNm);
				    		dbparam.put("zip", zip.replace("-", ""));
				    		dbparam.put("addr1", addr1);
				    		dbparam.put("addr2", addr2);
				    		dbparam.put("readTel", readTel.replace("-", ""));
				    		dbparam.put("qty", qty);
				    		dbparam.put("regDt", aplcDt);
				    		dbparam.put("boseq", boseq);
				    		dbparam.put("empNm", empNm);
				    		dbparam.put("empTel", empTel.replace("-", ""));

				    		// 신문-일반 인경우 신청상태
				    		if("신문".equals(media) && "일반".equals(readerTyp)){
				    			dbparam.put("status", "0");
				    		// 신문-일반이 아닌경우 정상
				    		}else{
				    			dbparam.put("status", "3");				    			
				    		}

				    		// 사원확장 테이블 입력용 parameter 세팅
				    		if(media.equals("전자판")){
				    			dbparam.put("media", "2");				    			
				    		}else{
				    			dbparam.put("media", "1");
				    		}
				    		
				    		if(gubun.equals("기업체")){
				    			dbparam.put("gubun", "2");
				    		}else{
				    			dbparam.put("gubun", "1");
				    		}
				    		
				    		if(readerTyp.equals("학생")){
				    			dbparam.put("readerTyp", "2");
				    			dbparam.put("gubun", "");
				    		}else if(readerTyp.equals("교육용") || readerTyp.equals("교육")){
				    			dbparam.put("readerTyp", "3");
				    			dbparam.put("gubun", "");
				    		}else{
				    			dbparam.put("readerTyp", "1");
				    		}

				    		if( !"".equals(empComp)){				    			
					    		dbparam.put("cdclsf", "9000");
					    		dbparam.put("cname", empComp.replace(" ", ""));
					    		resv1 = (String)generalDAO.getSqlMapClient().queryForObject("reader.empExtd.nameToCode" , dbparam);
					    		dbparam.put("empComp", resv1);
					    		dbparam.put("resv1", resv1);
				    		}

				    		if( !"".equals(empDept)){
					    		dbparam.put("resv3", "1");
					    		dbparam.put("cdclsf", "90002");
					    		dbparam.put("cname", empDept.replace(" ", ""));
					    		resv1 = (String)generalDAO.getSqlMapClient().queryForObject("reader.empExtd.nameToCode" , dbparam);
					    		dbparam.put("empDept", resv1);
					    		dbparam.put("resv1", resv1);
				    		}
				    		
				    		if( !"".equals(empTeam)){
					    		dbparam.put("resv3", "2");
					    		dbparam.put("cdclsf", "90002");
					    		dbparam.put("cname", empTeam.replace(" ", ""));
					    		dbparam.put("empTeam", (String)generalDAO.getSqlMapClient().queryForObject("reader.empExtd.nameToCode" , dbparam));
				    		}

				    		// 사원 확장 테이블 입력
				    		System.out.println("insertEmpExtd>>>"+dbparam);
				    		generalDAO.getSqlMapClient().insert("reader.empExtd.insertEmpExtd",  dbparam);
				    	}

				    	generalDAO.getSqlMapClient().getCurrentConnection().commit();
					// 저장 실패시 에러 처리
					}else{

						mav.setViewName("common/message");
						mav.addObject("message", "파일저장이 실패하였습니다.");
						mav.addObject("returnURL", "/reader/empExtd/empExtdList.do");
						return mav;
					}
				
				// 파일 미첨부시 에러 처리
				}else{

					mav.setViewName("common/message");
					mav.addObject("message", "파일첨부가 되지 않았습니다.");
					mav.addObject("returnURL", "/reader/empExtd/empExtdList.do");
					return mav;
				}
				
			}

			mav.setViewName("common/message");
			mav.addObject("message", "사원확장 등록처리가 완료 되었습니다.");
			mav.addObject("returnURL", "/reader/empExtd/empExtdList.do");
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
	 * 사원확장 등록 팝업 호출
	 * 
	 * @param request
	 * @param response
	 * @author ycpark
	 * @category 사원확장 등록 팝업 호출
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView popEmpExtd(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		try{
			HashMap dbparam = new HashMap();
			
			List companyCd = generalDAO.queryForList("reader.common.retrieveCompany"); //회사명조회
			//List officeCd = generalDAO.queryForList("reader.common.retrieveOffice"); //부서명조회
			
			mav.addObject("companyCd" , companyCd);
			mav.setViewName("reader/popEmpExtd");
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
	 * 조직명 조회 ajax
	 * 
	 * @param request
	 * @param response
	 * @category 조직명 조회 ajax
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ajaxOfficeNm(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		try{
			HashMap dbparam = new HashMap();
			dbparam.put("resv1", param.getString("resv1"));
			dbparam.put("resv3", param.getString("resv3"));
			List office = generalDAO.queryForList("reader.empExtd.retrieveCode" , dbparam); //조직명 리스트

			mav.addObject("office" , office);
			mav.setViewName("reader/ajaxOfficeNm");
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
	 * 조직명 조회 Jqeury ajax
	 * 
	 * @param request
	 * @param response
	 * @category 조직명 조회 ajax
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ajaxOfficeNmForJqeury(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		try{
			HashMap dbparam = new HashMap();
			dbparam.put("resv1", param.getString("resv1"));
			dbparam.put("resv3", param.getString("resv3"));
			List officeList = generalDAO.queryForList("reader.empExtd.retrieveCode" , dbparam); //리스트
			
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("office", JSONArray.fromObject(officeList));
			//jsp로 값을 보낸다.
			response.setContentType( "text/xml; charset=UTF-8" );
			response.getWriter().print(jsonObject);
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 사원확장 현황
	 * 
	 * @param request
	 * @param response
	 * @category 사원확장 현황
	 * @return
	 * @throws Exception
	 */
	public ModelAndView empExtdStat(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		try{
			HashMap dbparam = new HashMap();
			
			//현재날짜
			Calendar rightNow = Calendar.getInstance();
			
			String year = String.valueOf(rightNow.get(Calendar.YEAR));
			String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
			String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));

			if (month.length() < 2){
				month = "0" + month;
			}
			if (day.length() < 2){
				day = "0" + day;
			}

			String fromDate= param.getString("fromDate", year+"-01-01");									//기간 from
			String toDate= param.getString("toDate", year + "-" + month + "-" + day);						//기간 to
			String toDay= year + "." + month + "." + day;
			
			dbparam.put("fromDate", StringUtil.replace(fromDate, "-", ""));
			dbparam.put("toDate", StringUtil.replace(toDate, "-", ""));
			dbparam.put("chbx", param.getString("chbx", "all"));

			List empExtdStat = generalDAO.queryForList("reader.empExtd.getEmpExtdStat" , dbparam); 			// 사원확장 현황

			dbparam.put("deptCd", param.getString("deptCd", "83100"));   									// 기본 값 : 편집국
			List empExtdTeamStat = generalDAO.queryForList("reader.empExtd.getEmpExtdTeamStat" , dbparam);  // 부서별 현황
			
			List getEmpExtdTop = generalDAO.queryForList("reader.empExtd.getEmpExtdTop" , dbparam);  		// 개인실적 우수자

			mav.addObject("getEmpExtdTop" , getEmpExtdTop);
			mav.addObject("empExtdTeamStat" , empExtdTeamStat);
			mav.addObject("empExtdStat" , empExtdStat);
			mav.addObject("deptCd" , param.getString("deptCd", "83100"));
			mav.addObject("chbx" , param.getString("chbx", "all"));
			mav.addObject("fromDate", fromDate);
			mav.addObject("toDate", toDate);
			mav.addObject("toDay", toDay);
			mav.addObject("now_menu", MENU_CODE_EMP_EXTD);
			mav.setViewName("reader/empExtdStat");
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
	 * 부서별 사원 확장 통계  (AJAX)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @category 부서별 사원 확장 통계(AJAX)
	 * @throws Exception
	 */
	public ModelAndView empExtdStatAjax(HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		request.setCharacterEncoding("utf-8");

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();

		try{
			
			HashMap dbparam = new HashMap();
			
			//현재날짜
			Calendar rightNow = Calendar.getInstance();
			
			String year = String.valueOf(rightNow.get(Calendar.YEAR));
			String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
			String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));

			if (month.length() < 2){
				month = "0" + month;
			}
			if (day.length() < 2){
				day = "0" + day;
			}

			String fromDate= param.getString("fromDate", year+"-01-01");									//기간 from
			String toDate= param.getString("toDate", year + "-" + month + "-" + day);						//기간 to
			String toDay= year + "." + month + "." + day;
			
			dbparam.put("fromDate", StringUtil.replace(fromDate, "-", ""));
			dbparam.put("toDate", StringUtil.replace(toDate, "-", ""));
			dbparam.put("chbx", param.getString("chbx", "all"));
			
			dbparam.put("deptCd", param.getString("deptCd"));					// 부서
			
			// 지국목록 조회
			List empExtdTeamStat = generalDAO.queryForList("reader.empExtd.getEmpExtdTeamStat" , dbparam); // 부서별 현황 (기본- 편집국)
			
			
			//쿼리 결과를 jsonArray로 만들어 준다
			JSONArray jsonArray = JSONArray.fromObject(empExtdTeamStat);
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("empExtdTeamStat", jsonArray);
			
			//jsonArray를 jsonObject로 만들어 준다
			JSONObject jsonObject = JSONObject.fromObject(map);
			
			response.setContentType( "text/xml; charset=UTF-8" );
			
			//jsp로 값을 보낸다.
			response.getWriter().print(jsonObject);
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 사원확장 통계 엑셀 저장
	 * 
	 * @param request
	 * @param response
	 * @category 사원확장 통계 엑셀 저장
	 * @return
	 * @throws Exception
	 */
	public ModelAndView excelEmpExtdStat(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		try{
			HashMap dbparam = new HashMap();
			
			//현재날짜
			Calendar rightNow = Calendar.getInstance();
			
			String year = String.valueOf(rightNow.get(Calendar.YEAR));
			String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
			String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));

			if (month.length() < 2){
				month = "0" + month;
			}
			if (day.length() < 2){
				day = "0" + day;
			}

			String fromDate= param.getString("fromDate", year+"-01-01");									//기간 from
			String toDate= param.getString("toDate", year + "-" + month + "-" + day);						//기간 to
			String toDay= year + "." + month + "." + day;
			
			dbparam.put("fromDate", StringUtil.replace(fromDate, "-", ""));
			dbparam.put("toDate", StringUtil.replace(toDate, "-", ""));
			dbparam.put("chbx", param.getString("chbx", "all"));
			List empExtdStat = generalDAO.queryForList("reader.empExtd.getEmpExtdStat" , dbparam); 			// 사원확장 현황

			dbparam.put("deptCd", param.getString("deptCd", "83100"));   									// 기본 값 : 편집국
			List empExtdTeamStat = generalDAO.queryForList("reader.empExtd.getEmpExtdTeamStat" , dbparam);  // 부서별 현황
			
			List getEmpExtdTop = generalDAO.queryForList("reader.empExtd.getEmpExtdTop" , dbparam);  		// 개인실적 우수자

			String fileName = "사원확장통계_"+fromDate+"_"+toDate+".xls";
			//Excel response
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName); 
			response.setHeader("Content-Description", "JSP Generated Data");
			
			mav.addObject("getEmpExtdTop" , getEmpExtdTop);
			mav.addObject("empExtdTeamStat" , empExtdTeamStat);
			mav.addObject("empExtdStat" , empExtdStat);
			mav.addObject("deptCd" , param.getString("deptCd", "83100"));
			mav.addObject("fromDate", fromDate);
			mav.addObject("toDate", toDate);
			mav.addObject("toDay", toDay);
			mav.addObject("now_menu", MENU_CODE_EMP_EXTD);
			mav.setViewName("reader/excelEmpExtdStat");
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
	 * 사원확장리스트 엑셀 저장
	 * 
	 * @param request
	 * @param response
	 * @category 사원확장리스트 엑셀 저장
	 * @return
	 * @throws Exception
	 */
	public ModelAndView excelEmpExtdList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		
		try{
			HashMap dbparam = new HashMap();
			
			//현재날짜
			Calendar rightNow = Calendar.getInstance();
			
			String year = String.valueOf(rightNow.get(Calendar.YEAR));
			String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
			String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));

			if (month.length() < 2){
				month = "0" + month;
			}
			if (day.length() < 2){
				day = "0" + day;
			}

			String fromDate= param.getString("fromDate", year + "-" + month + "-" + day);			//기간 from
			String toDate= param.getString("toDate", year + "-" + month + "-" + day);				//기간 to
			
			dbparam.put("media", param.getString("media"));
			dbparam.put("readerTyp", param.getString("readerTyp"));
			dbparam.put("gubun", param.getString("gubun"));
			dbparam.put("status", param.getString("status"));
			dbparam.put("boseq", param.getString("boseq"));
			dbparam.put("empComp", param.getString("empComp"));
			dbparam.put("empDept", param.getString("empDept"));
			dbparam.put("empTeam", param.getString("empTeam"));
			dbparam.put("dateType", param.getString("dateType"));
			dbparam.put("fromDate", StringUtil.replace(fromDate, "-", ""));
			dbparam.put("fromDate", StringUtil.replace(fromDate, "-", ""));
			dbparam.put("toDate", StringUtil.replace(toDate, "-", ""));
			dbparam.put("search_type", param.getString("search_type"));
			dbparam.put("search_value", param.getString("search_value"));

			List empExtdList = generalDAO.queryForList("reader.empExtd.getEmpExtdListExcel", dbparam);
			List totalEmpExtdCount = generalDAO.queryForList("reader.empExtd.getTotalCount" , dbparam);

			String fileName = "사원확장리스트_"+fromDate+"_"+toDate+".xls";
			//Excel response
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName); 
			response.setHeader("Content-Description", "JSP Generated Data");
			
			mav.addObject("fromDate", fromDate);
			mav.addObject("toDate", toDate);
			mav.addObject("totalEmpExtdCount", totalEmpExtdCount);
			mav.addObject("empExtdList", empExtdList);
			mav.addObject("now_menu", MENU_CODE_EMP_EXTD);
			mav.setViewName("reader/excelEmpExtdList");
			
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
	 * 사원정보 조회 팝업 호출
	 * 
	 * @param request
	 * @param response
	 * @category 사원정보 조회 팝업 호출
	 * @return
	 * @throws Exception
	 */
	public ModelAndView popEmpInfo(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);

		List company = generalDAO.queryForList("reader.common.retrieveCompany"); //회사명조회
		
		mav.addObject("empNm", param.getString("empNm"));
		mav.addObject("company" , company);
		mav.setViewName("reader/popEmpInfo");
		return mav;
	}
	
	/**
	 * 사원정보 조회
	 * 
	 * @param request
	 * @param response
	 * @category 사원정보 조회
	 * @return
	 * @throws Exception
	 */
	public ModelAndView popSearchEmp(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	
		ModelAndView mav = new ModelAndView();
		
		HashMap dbparam = new HashMap();
		Param param = new HttpServletParam(request);
		
		try{
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 10;
			int totalCnt = 0;

			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));

			dbparam.put("empNm", param.getString("empNm"));
			dbparam.put("company", param.getString("company"));
			dbparam.put("dept", param.getString("dept"));
			List company = generalDAO.queryForList("reader.common.retrieveCompany"); //회사명조회
			dbparam.put("resv1", param.getString("company"));
			List dept = generalDAO.queryForList("reader.common.retrieveOffice" , dbparam); //부서명 리스트
			List empList = generalDAO.queryForList("reader.empExtd.retrieveEmpList", dbparam);
			totalCnt = generalDAO.count("reader.empExtd.retrieveEmpListCount" , dbparam);

			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCnt, pageSize, 10));
			mav.addObject("empNm" , param.getString("empNm"));
			mav.addObject("companyCd" , param.getString("company"));
			mav.addObject("deptCd" , param.getString("dept"));
			mav.addObject("totalCnt", totalCnt);
			mav.addObject("dept" , dept);
			mav.addObject("company" , company);
			mav.addObject("empList" , empList);
			mav.setViewName("reader/popEmpInfo");
			return mav;

		}catch(Exception e){
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
			return mav;
		}
	}

}
