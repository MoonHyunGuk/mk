/*------------------------------------------------------------------------------
 * NAME : DeadLineController 
 * DESC : 월 마감.
 * Author : pspkj
 *----------------------------------------------------------------------------*/
package com.mkreader.web.etc;

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
import com.mkreader.util.FileUtil;

public class DeadLineController extends MultiActionController implements
ISiteConstant, ICodeConstant {
	
private GeneralDAO generalDAO;
	
	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}
	
	/**
	 * 월 마감 초기화면
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView reteriveDeadLine(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		try{
			if(!"1000".equals(session.getAttribute(SESSION_NAME_MENU_AUTH)) || 
			  (session.getAttribute(SESSION_NAME_ADMIN_USERID) == null || "".equals(session.getAttribute(SESSION_NAME_ADMIN_USERID))) ||
			  !"SUPERADMIN".equals(session.getAttribute(SESSION_NAME_ADMIN_USERID) )){
				mav.setViewName("common/message");
				mav.addObject("message", MSG_LOGIN_NOT_AUTH);
				mav.addObject("returnURL", URI_LOGIN);
				return mav;
			}
		
			List lastDeadLine = generalDAO.queryForList("common.getLastSGYYMM2");
			List agencyList = generalDAO.queryForList("common.getAgencyList2");
			
			String tmpYYMMDD = DateUtil.getCurrentDate("yyyyMMdd");
			String nowYYMMDD = "";
			
			//1일부터 20일 까지
			if(1 < Integer.parseInt(tmpYYMMDD.substring(6,8)) && Integer.parseInt(tmpYYMMDD.substring(6,8)) <= 20 ){
				nowYYMMDD = DateUtil.getWantDay(tmpYYMMDD, 2, -1);
			//21일부터 말일	
			}else if(20 < Integer.parseInt(tmpYYMMDD.substring(6,8)) && Integer.parseInt(tmpYYMMDD.substring(6,8)) <= Integer.parseInt(DateUtil.getLastDay()) ){
				nowYYMMDD = tmpYYMMDD;
			}
			
			Map list = (Map) lastDeadLine.get(0);
			
			
			mav.addObject("nowYYMMDD" , nowYYMMDD);//현재 사용월분
			mav.addObject("yymm" , DateUtil.getWantDay((String)list.get("SGYYMM")+"01", 2, 1)); //미수생성월
			mav.addObject("lastDeadLine" , lastDeadLine);
			mav.addObject("agencyList" , agencyList);
			mav.addObject("now_menu", MENU_CODE_MANAGEMENT_MONTH_END);
			mav.setViewName("etc/deadLine");
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
	 * 월 마감 실행
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView executeDeadLine(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			
			if(!"1000".equals(session.getAttribute(SESSION_NAME_MENU_AUTH)) || 
			  (session.getAttribute(SESSION_NAME_ADMIN_USERID) == null || "".equals(session.getAttribute(SESSION_NAME_ADMIN_USERID))) ||
			  !"SUPERADMIN".equals(session.getAttribute(SESSION_NAME_ADMIN_USERID) )){
				mav.setViewName("common/message");
				mav.addObject("message", MSG_LOGIN_NOT_AUTH);
				mav.addObject("returnURL", URI_LOGIN);
				return mav;
			}
			
			HashMap dbparam = new HashMap();
			String text = "";
			String nLine = "\n";
			
			dbparam.put("curDate", param.getString("curDate"));
			dbparam.put("yymm", param.getString("yymm"));

			// 24개월전 결혼 미수처리 (2013.12.19 박윤철)
			// 수금 히스토리 입력
			generalDAO.insert("etc.deadLine.update2YearMisuHist", dbparam);
			// 수금 업데이트
			generalDAO.update("etc.deadLine.update2YearsMisu", dbparam);


			String boSeq[] = new String[param.getInt("boSeqSize",0)];
			
			for(int i=0 ; i < boSeq.length ; i++){
				
				boSeq[i] = param.getString("boSeq"+i);
				
				if(boSeq[i] !=null && !"".equals(boSeq[i])){
					text = text + boSeq[i]+"======================================================="+nLine;
					
					dbparam.put("boSeq", boSeq[i]);
					
					if("on".equals(param.getString("condition2"))){
						//미수 생성 본사 입금 이외
						String msg = (String)generalDAO.queryForObject("etc.deadLine.accountsReceivable" , dbparam);
						text = text + msg + nLine;
						if(msg.indexOf("FAIL" ) > -1 ){
							FileUtil.saveTxtFile(
									PATH_UPLOAD_DEADLINE_RESULT + "/" + param.getString("yymm"), 
									"deadLineFail" + DateUtil.getCurrentDate("yyyyMMddHHmmss")+".txt",
									msg,
									"UTF-8"
								);
							throw new Exception(msg);
						}
//						//본사입금 수금 처리 (본사입금제외 : 박윤철)
//						msg = (String)generalDAO.queryForObject("etc.deadLine.accountsReceivable2" , dbparam);
//						text = text + msg + nLine;
//						if(msg.indexOf("FAIL" ) > -1 ){
//							FileUtil.saveTxtFile(
//									PATH_UPLOAD_DEADLINE_RESULT + "/" + param.getString("yymm"), 
//									"deadLineFail" + DateUtil.getCurrentDate("yyyyMMddHHmmss")+".txt",
//									msg,
//									"UTF-8"
//								);
//							throw new Exception(msg);
//						}
					}
					if("on".equals(param.getString("condition3"))){
						//통계 등록
						String msg = (String)generalDAO.queryForObject("etc.deadLine.statisticsInsert" , dbparam);
						text = text + msg + nLine;
						if(msg.indexOf("FAIL" ) > -1 ){
							FileUtil.saveTxtFile(
									PATH_UPLOAD_DEADLINE_RESULT + "/" + param.getString("yymm"), 
									"deadLineFail" + DateUtil.getCurrentDate("yyyyMMddHHmmss")+".txt",
									msg,
									"UTF-8"
								);
							throw new Exception(msg);
						}
					}
					if("on".equals(param.getString("condition1"))){
						//배달번호 정렬
						List gnoList = generalDAO.queryForList("etc.deadLine.gnoList" , dbparam);
						for(int j=0 ; j < gnoList.size() ; j++){
							Map list = (Map)gnoList.get(j);
							dbparam.put("gno", list.get("GNO"));
							String msg = (String)generalDAO.queryForObject("etc.deadLine.deliverNumSort" , dbparam);
							text = text + msg + nLine;
							if(msg.indexOf("FAIL" ) > -1 ){
								FileUtil.saveTxtFile(
										PATH_UPLOAD_DEADLINE_RESULT + "/" + param.getString("yymm"), 
										"deadLineFail" + DateUtil.getCurrentDate("yyyyMMddHHmmss")+".txt",
										msg,
										"UTF-8"
									);
								throw new Exception(msg);
							}
						}
					}
					text = text + nLine;
				}
					
			}
			
			//수금년월 인설트
			generalDAO.insert("etc.deadLine.insertMonthClose" , dbparam);
			
			//수금 결과 파일 생성 upload/deadLine
			FileUtil.saveTxtFile(
					PATH_UPLOAD_DEADLINE_RESULT + "/" + param.getString("yymm"), 
					"deadLineResult" + DateUtil.getCurrentDate("yyyyMMddHHmmss")+".txt",
					text,
					"UTF-8"
				);
			
			mav.addObject("message", MSG_SUCSSES_DEADLINE);
			mav.addObject("returnURL", "/etc/deadLine/reteriveDeadLine.do");
			mav.setViewName("common/message");
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
