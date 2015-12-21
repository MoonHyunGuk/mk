package com.mkreader.web.management;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.util.Param;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;

public class JikukController extends MultiActionController implements
ISiteConstant, ICodeConstant {
	
public static Logger logger = Logger.getRootLogger();
	
	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {

			this.generalDAO = generalDAO;
	}
	
	/**
	 * 지국리스트
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView jikukList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		
		mav.addObject("now_menu", MENU_CODE_MANAGEMENT_AGENCY);
		mav.setViewName("management/jikuk/jikukList");
		return mav;
	}
	
	
	/**
	 * 지국조회(폐국,통합지국)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView selectjikukReaderList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView();
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		HttpSession session = request.getSession();
		Param param = new HttpServletParam(request);
		
		List<Object> cardReaderList = new ArrayList<Object>();				//카드독자
		List<Object> eduReaderList = new ArrayList<Object>();				//교육용독자
		List<Object> alienationReaderList = new ArrayList<Object>();		//소외계층독자
		List<Object> transferReaderList = new ArrayList<Object>();			//일반자동이체독자
		List<Object> transferStuReaderList = new ArrayList<Object>();	//학생자동이체독자
		List<Object> zipcodeList = new ArrayList<Object>();					//우편번호
		
		String jikukCode = "";
		String combineJikukCode = "";
		int zipcodeCnt = 0;
		
		try{
			String loginType = (String)session.getAttribute(SESSION_NAME_LOGIN_TYPE);

			dbparam.put("JIKUKNAME", param.getString("opJikukNm"));
			dbparam.put("COMBINEJIKUKNAME", param.getString("opCombineJikukNm"));
			
			//폐국지국코드 찾기
			jikukCode = (String)generalDAO.queryForObject("management.jikuk.getJiKukCode", dbparam);
			//통합지국코드 찾기
			combineJikukCode = (String)generalDAO.queryForObject("management.jikuk.getCombineJiKukCode", dbparam);
			
			dbparam.put("BOSEQ", jikukCode);
			
			cardReaderList 			= generalDAO.queryForList("management.jikuk.selectCardReaderList", dbparam);
			eduReaderList 				= generalDAO.queryForList("management.jikuk.selectEduReaderList", dbparam);
			alienationReaderList 		= generalDAO.queryForList("management.jikuk.selectAlienationReaderList", dbparam);
			transferReaderList 		= generalDAO.queryForList("management.jikuk.selectTransferReaderList", dbparam);
			transferStuReaderList 	= generalDAO.queryForList("management.jikuk.selectTransferStuReaderList", dbparam);
			zipcodeList					= generalDAO.queryForList("management.jikuk.selectZipcodeList", dbparam);
			zipcodeCnt					= generalDAO.count("management.jikuk.getZipcodeCount", dbparam);

			mav.addObject("now_menu", MENU_CODE_MANAGEMENT_AGENCY);
			mav.addObject("loginType" , loginType);
			mav.addObject("cardReaderList" , cardReaderList);
			mav.addObject("eduReaderList" , eduReaderList);
			mav.addObject("alienationReaderList" , alienationReaderList);
			mav.addObject("transferReaderList" , transferReaderList);
			mav.addObject("transferStuReaderList" , transferStuReaderList);
			mav.addObject("zipcodeList", zipcodeList);
			mav.addObject("opJikukNm", param.getString("opJikukNm"));
			mav.addObject("jikukCode", jikukCode);
			mav.addObject("opCombineJikukNm", param.getString("opCombineJikukNm"));
			mav.addObject("combineJikukCode", combineJikukCode);
			mav.addObject("zipcodeCnt", zipcodeCnt);
			
			mav.setViewName("management/jikuk/jikukList");
		} catch(Exception e) {
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
		}
		return mav;
	}
	
	
	/**
	 * 지국통합프로세스
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView combineJikukProcess(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		//Setting
		ModelAndView mav = new ModelAndView();
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		Param param = new HttpServletParam(request);
		
		//parameters
		dbparam.put("cardGno", param.getString("cardGno")); 
		dbparam.put("eduGno", param.getString("eduGno"));
		dbparam.put("alienationGno", param.getString("alienationGno"));
		dbparam.put("transferGno", param.getString("transferGno"));
		dbparam.put("transferStuGno", param.getString("transferStuGno"));
		//폐국지국코드
		dbparam.put("closeJikukCode", param.getString("closejikukCode"));
		dbparam.put("BOSEQ", param.getString("closejikukCode"));
		//폐국지국명
		dbparam.put("closeJikukNm", param.getString("opJikukNm"));
		//통합지국코드
		dbparam.put("combineJikukCode", param.getString("combineJikukCode"));
		//통합지국명
		dbparam.put("combineJikukNm", param.getString("opCombineJikukNm"));
		dbparam.put("txtClosed", "(폐국)");
		//구역변경여부
		dbparam.put("bnoChgYn", param.getString("bnoChgYn"));
		
		try {
			generalDAO.getSqlMapClient().startTransaction();
			generalDAO.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			//독자백업
			readerBackupProcess(dbparam);
		
			//카드독자 이전
			cardReaderTransProcess(dbparam);
			
			//교육용독자 이전
			eduReaderTransProcess(dbparam);
			
			//소외계층독자 이전
			alienationReaderTransProcess(dbparam);
			
			//일반자동이체 이전
			transferReaderTransProcess(dbparam);
		
			//학생자동이체 이전
			transferStuReaderTransProcess(dbparam);
			
			//우편번호 이전
			generalDAO.getSqlMapClient().update("management.jikuk.updateZipcodeData", dbparam);
			
			//폐국지국 정보등록
			generalDAO.getSqlMapClient().update("management.jikuk.deleteCloseJikukData", dbparam);
			
			mav.addObject("now_menu", MENU_CODE_MANAGEMENT_AGENCY);
			mav.setViewName("management/jikuk/jikukList");
			generalDAO.getSqlMapClient().getCurrentConnection().commit();
			generalDAO.getSqlMapClient().endTransaction();
		} catch(Exception e) {
			e.printStackTrace();
			generalDAO.getSqlMapClient().getCurrentConnection().rollback();
			generalDAO.getSqlMapClient().endTransaction();
			mav.setViewName("common/message");
			mav.addObject("message", "지국통폐합을 완료하지 못했습니다. 다시한번 확인해 주십시오.");
			mav.addObject("returnURL", "/index.jsp");
		}
		return mav;
	}
	
	/**
	 * 카드독자 이전
	 * @param dbparam
	 * @return
	 * @throws Exception
	 */
	public void readerBackupProcess(HashMap<Object, Object> dbparam) throws Exception {
		
		//카드독자백업 
		generalDAO.getSqlMapClient().insert("management.jikuk.insertBackupCardReaders", dbparam);
		
		//교육용독자백업
		generalDAO.getSqlMapClient().insert("management.jikuk.insertBackupEduReaders", dbparam);
		
		//소외계층백업
		generalDAO.getSqlMapClient().insert("management.jikuk.insertBackupAlienationReaders", dbparam);	
		
		//일반자동이체백업
		generalDAO.getSqlMapClient().insert("management.jikuk.insertBackupTransferReaders", dbparam);
	
		//학생자동이체백업
		generalDAO.getSqlMapClient().insert("management.jikuk.insertBackupTransferStuReaders", dbparam);
		
	}
	
	
	
	/**
	 * 카드독자 이전
	 * @param dbparam
	 * @return
	 * @throws Exception
	 */
	public void cardReaderTransProcess(HashMap<Object, Object> dbparam) throws Exception {
		
		//카드독자 수금이전
		int result = (int)generalDAO.getSqlMapClient().update("management.jikuk.updateCardReaderSugmData", dbparam);
		
		//카드독자 이전
		int result2 = (int)generalDAO.getSqlMapClient().update("management.jikuk.updateCardReaderData", dbparam);
		
		//카드테이블 이전
		int result3 = (int)generalDAO.getSqlMapClient().update("management.jikuk.updateCardTableData", dbparam);
		
		//카드수금상세테이블 이전
		int result4 = (int)generalDAO.getSqlMapClient().update("management.jikuk.updateCardSugmDetailData", dbparam);
	}
	
	/**
	 * 교육용독자 이전
	 * @param dbparam
	 * @return
	 * @throws Exception
	 */
	public void eduReaderTransProcess(HashMap<Object, Object> dbparam) throws Exception {
		
		//교육용독자 수금이전
		int result = (int)generalDAO.getSqlMapClient().update("management.jikuk.updateEduReaderSugmData", dbparam);
		
		//교육용독자 이전
		int result2 = (int)generalDAO.getSqlMapClient().update("management.jikuk.updateEduReaderData", dbparam);
		
		//교육용테이블 이전
		int result3 = (int)generalDAO.getSqlMapClient().update("management.jikuk.updateEduTableData", dbparam);
	}
	
	/**
	 * 소외계층독자 이전
	 * @param dbparam
	 * @return
	 * @throws Exception
	 */
	public void alienationReaderTransProcess(HashMap<Object, Object> dbparam) throws Exception {
		
		//소외계층독자 수금이전
		int	result = (int)generalDAO.getSqlMapClient().update("management.jikuk.updateAlienationReaderData", dbparam);
	}
	
	/**
	 * 일반자동이체 이전
	 * @param dbparam
	 * @return
	 * @throws Exception
	 */
	public void transferReaderTransProcess(HashMap<Object, Object> dbparam) throws Exception {
		
		//일반자동이체 수금이전
		int result = (int)generalDAO.getSqlMapClient().update("management.jikuk.updateTransferReaderSugmData", dbparam);
		
		//일반자동이체독자 이전
		int result2 = (int)generalDAO.getSqlMapClient().update("management.jikuk.updateTransferReaderData", dbparam);
		
		//일반자동이체 이전
		int result3 = (int)generalDAO.getSqlMapClient().update("management.jikuk.updateTransferTableData", dbparam);
	}
	
	/**
	 * 학생자동이체 이전
	 * @param dbparam
	 * @return
	 * @throws Exception
	 */
	public void transferStuReaderTransProcess(HashMap<Object, Object> dbparam) throws Exception {
		
		//학생자동이체 수금이전
		int result = (int)generalDAO.getSqlMapClient().update("management.jikuk.updateTransferStuReaderSugmData", dbparam);
		
		//학생자동이체독자 이전
		int result2 = (int)generalDAO.getSqlMapClient().update("management.jikuk.updateTransferStuReaderData", dbparam);
		
		//학생자동이체 이전
		int result3 = (int)generalDAO.getSqlMapClient().update("management.jikuk.updateTransferStuTableData", dbparam);
	}
}

