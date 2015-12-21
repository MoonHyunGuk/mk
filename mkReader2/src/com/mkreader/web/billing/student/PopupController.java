package com.mkreader.web.billing.student;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.util.Param;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ISiteConstant;



public class PopupController extends MultiActionController implements
		ISiteConstant {

	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {

		this.generalDAO = generalDAO;
	}
	
	/**
	 * 고객정보 상세
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView view_stu(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		//parameter
		Param param = new HttpServletParam(request);
		String readno = param.getString("readno");
		
		//dbparam
		HashMap dbparam = new HashMap();
		dbparam.put("READNO", readno);
	
		Map result = (Map)generalDAO.queryForObject("billing.student.popup.getUserInfo", dbparam);
		
		//지국정보
		if( result != null ){
			if( "EA21".equals(result.get("status")) ){
				dbparam.put("SERIAL", result.get("jikuk"));
			}
		}
		List jikukList = generalDAO.queryForList("billing.student.popup.getJikukList");
		
		List bankList = generalDAO.queryForList("billing.student.popup.getBankList");
		
		//통화기록리스트
		dbparam.put("TYPECD", "2");
		List callList = generalDAO.queryForList("billing.student.popup.getCallList", dbparam);
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.addObject("result", result);
		mav.addObject("jikukList", jikukList);
		mav.addObject("bankList", bankList);
		mav.addObject("callList", callList);
		mav.addObject("readno", readno);
		
		mav.setViewName("billing/student/popup/view_stu");
		return mav;
	}
	
	/**
	 * 고객수정 프로세스
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView view_db_stu(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		//parameter
		Param param = new HttpServletParam(request);
		String readno = param.getString("readno");
		String bank = param.getString("bank");
		bank = bank + "0000";
		if( bank.length() > 6 ){
			bank = bank.substring(0, 6);
		}
		String bank_own = param.getString("bank_own");
		String bank_num = param.getString("bank_num");
		
		
		//시티은행처리
		if( StringUtils.isNotEmpty(bank) ){
			if ( "270000,530000".contains(bank) && "0".equals(bank.substring(0,1)) ){		//bank의 값이 270000,530000 의 값중 포함된 것이 있다면
				if( bank_num.trim().length() == 11 ){
					bank = "270000";
				}else{
					bank = "530000";
				}
			}
		}
		
		HashMap dbparam = new HashMap();
		dbparam.put("READNO", readno);
		
		Map result = (Map)generalDAO.queryForObject("billing.student.popup.getUserInfo", dbparam);
		String status = "";
		
		/*
		String O_jikuk = "";
		String O_serial = "";
		String top_serial = "";
		String serial_str = "";
		if( result != null ){
			String serail_str = "";
			if( jikuk.length() == 6 && serial.length() != 5 ){
				O_jikuk = jikuk.trim();
				O_serial = serial.trim();
				if( StringUtils.isEmpty(O_jikuk) ){
					O_jikuk = "";
				}
				
				if( StringUtils.isEmpty(O_serial) && O_serial.length() == 6 ){
					dbparam.put("JIKUK", O_jikuk);
					top_serial =  (String)generalDAO.queryForObject("billing.student.popup.getTopSerial", dbparam);
					
					if( StringUtils.isEmpty(top_serial) ){
						top_serial = "10000";
					}else if( top_serial.length() != 5 ){
						top_serial = "10000";
					}else if( Integer.valueOf(top_serial) < 10000 ){
						top_serial = "10000";
					}
					
					serial = Integer.valueOf(top_serial) + 1 + "";
					serial_str = "시리얼 자동할당을 실행하였습니다.\n";
				}
			}
		}
		*/
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("common/message");
		
		if( result != null ){
			status = (String)result.get("STATUS");
			status = status.trim();
			if( "EA21".equals(status) || "EA13".equals(status)){
				mav.addObject("message", status + "상태는 수정이 불가합니다.");
				mav.addObject("returnURL", "./view_stu.do?readno=" + readno);
				return mav;
			}
		}
		dbparam = new HashMap();
		
		dbparam.put("BANK", bank);
		dbparam.put("BANK_NUM", bank_num);
		dbparam.put("BANK_OWN", bank_own);
		dbparam.put("READNO", readno);
		
		int updateResult = generalDAO.update("billing.student.popup.updateMeberInfo", dbparam);
		

		if( updateResult > 0 ){
			mav.addObject("message", "정상적으로 수정 되었습니다.");
		}else{
			mav.addObject("message", "수정되지 않았습니다.");
		}
		
		mav.addObject("returnURL", "./view_stu.do?readno=" + readno);
		return mav;
	}
	
	
}
