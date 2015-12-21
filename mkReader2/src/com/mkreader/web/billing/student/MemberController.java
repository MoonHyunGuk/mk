package com.mkreader.web.billing.student;

import java.io.IOException;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Iterator;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.servlet.util.MultipartHttpServletParam;
import kr.reflexion.espresso.util.Param;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.support.DefaultMultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.Paging;
import com.mkreader.util.FileUtil;



public class MemberController extends MultiActionController implements
		ISiteConstant {

	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {

		this.generalDAO = generalDAO;
	}
	
	
	
	/**
	 * 학생독자 입력
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView input_stu(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		//메뉴펼치기
		String show_hidden5 = "display";
		
		//db 지국정보 가져오기
		
		//이체시작월
		Calendar now = Calendar.getInstance();
		String year = now.get(Calendar.YEAR) + "";
		String month = now.get(Calendar.MONTH)+1 + "";
		int day = now.get(Calendar.DAY_OF_MONTH);
				
		String chdate = "";
		//1~10일 신청 매월17일 청구, 11~말일 신청 익월5일 청구 
		if( day < 11 ){
			if( month.length() == 1 ){
				month = "0" + month;
			}
			chdate = year + "-" + month + "-17";
		}else{
			now.add ( now.MONTH, 1 ); //익월
			
			month = now.get(Calendar.MONTH)+1 + "";
			if( month.length() == 1 ){
				month = "0" + month;
			}
			chdate = year + "-" + month + "-05";
		}


		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.addObject("show_hidden5",show_hidden5);
		mav.addObject("chdate",chdate);
		mav.setViewName("billing/student/member/input_stu");
		return mav;
	}
	
	/**
	 * 학생독자 입력 프로세스
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView input_db_stu(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		String intype = param.getString("intype");
		String gubun = param.getString("gubun");
		String username = param.getString("username");
		
		String tel_1 = param.getString("tel_1");
		String tel_2 = param.getString("tel_2");
		String tel_3 = param.getString("tel_3");
		String telephone = tel_1 + "-" + tel_2 + "-" + tel_3;
		
		String zip1 = param.getString("zip1");
		String zip2 = param.getString("zip2");
		String addr1 = param.getString("addr1");
		String addr2 = param.getString("addr2");
		
		String jikuk = param.getString("user_number1");
		String serial = param.getString("user_number2");
		
		String bank_username = param.getString("bank_username");
		String bank = param.getString("bank");
		if( (bank + "0000").length() > 6 ){
			bank = (bank + "0000").substring(0,6);
		}
		String bank_num = param.getString("bank_num");
		bank_num = bank_num.replace("-","");
		bank_num = bank_num.replace("ㅡ","");
		bank_num = bank_num.replace(" ","");
		bank_num = bank_num.trim();
		
		String bank_own = param.getString("bank_own");
		String bank_money = param.getString("bank_money");
		
		String sdate = param.getString("sdate");
		
		String handy_1 = param.getString("handy_1");
		String handy_2 = param.getString("handy_2");
		String handy_3 = param.getString("handy_3");
		String handy = handy_1 + "-" + handy_2 + "-" + handy_3;
		
		String email = param.getString("email");
		String busu = param.getString("busu");
		
		String memo = param.getString("memo");
		
		String stu_sch = param.getString("stu_sch");
		String stu_part = param.getString("stu_part");
		String stu_class = param.getString("stu_class");
		String stu_prof = param.getString("stu_prof");
		
		String stu_adm = param.getString("stu_adm");
		String stu_caller = param.getString("stu_caller");
		
		//시티은행처리
		if ( "270000,530000".contains(bank) ){		//bank의 값이 270000,530000 의 값중 포함된 것이 있다면
			if( bank_num.trim().length() == 11 ){
				bank = "270000";
			}else{
				bank = "530000";
			}
		}
		
		//dbparam
		HashMap dbparam = new HashMap();
		dbparam.put("INTYPE", intype);
		dbparam.put("JIKUK", jikuk);
		dbparam.put("SERIAL", serial);
		dbparam.put("USERNAME", username);
		dbparam.put("TELEPHONE", telephone);
		dbparam.put("ZIP1", zip1);
		dbparam.put("ZIP2", zip2);
		dbparam.put("ADDR1", addr1);
		dbparam.put("ADDR2", addr2);
		dbparam.put("BANK_USERNAME", bank_username);
		dbparam.put("BANK", bank);
		dbparam.put("BANK_NUM", bank_num);
		dbparam.put("BANK_OWN", bank_own);
		dbparam.put("HANDY", handy);
		dbparam.put("SDATE", sdate);
		dbparam.put("EMAIL", email);
		dbparam.put("BUSU", busu);
		dbparam.put("GUBUN", gubun);
		dbparam.put("BANK_MONEY", bank_money);
		dbparam.put("MEMO", memo);
		dbparam.put("STU_SCH", stu_sch);
		dbparam.put("STU_PART", stu_part);
		dbparam.put("STU_CLASS", stu_class);
		dbparam.put("STU_PROF", stu_prof);
		dbparam.put("STU_ADM", stu_adm);
		dbparam.put("STU_CALLER", stu_caller);
		
		//db insert
		generalDAO.insert("", dbparam);

		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("common/message");
		mav.addObject("message", "정상적으로 입력 되었습니다.");
		mav.addObject("returnURL", "./list_stu.do?username=" + username + "&bank_username=" + bank_username + "&bank=" + bank);
		return mav;
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
		int numid = param.getInt("numid");
		String view = param.getString("view");
		String view2 = param.getString("view2");
		int page = param.getInt("page");
		String orderby = param.getString("orderby");
		String orders = param.getString("orders");
		String searchkey = param.getString("searchkey");
		String searchtype = param.getString("searchtype");
		String search_state = param.getString("search_state");
		
		
		//dbparam
		HashMap dbparam = new HashMap();
		dbparam.put("NUMID", numid);
	
		Map result = (Map)generalDAO.queryForObject("billing.student.member.getUserInfo", dbparam);
		
		//지국정보
		if( result != null ){
			if( "EA21".equals(result.get("status")) ){
				dbparam.put("SERIAL", result.get("jikuk"));
			}
		}
		List jikukList = generalDAO.queryForList("billing.student.member.getJikukList");
		
		List bankList = generalDAO.queryForList("billing.student.member.getBankList");
		// mav
		ModelAndView mav = new ModelAndView();
		mav.addObject("result", result);
		mav.addObject("jikukList", jikukList);
		mav.addObject("bankList", bankList);
		mav.addObject("numid", numid);
		mav.addObject("view", view);
		mav.addObject("view2", view2);
		mav.addObject("page", page);
		mav.addObject("orderby", orderby);
		mav.addObject("orders", orders);
		mav.addObject("searchkey", searchkey);
		mav.addObject("searchtype", searchtype);
		mav.addObject("search_state", search_state);
		
		mav.setViewName("billing/student/member/view_stu");
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
		int numid = param.getInt("numid");
		String intype = param.getString("intype");
		String gubun = param.getString("gubun");
		
		String username = param.getString("username");
		String tel_1 = param.getString("tel_1");
		String tel_2 = param.getString("tel_2");
		String tel_3 = param.getString("tel_3");
		String telephone = tel_1 + "-" + tel_2 + "-" + tel_3;
		
		String zip1 = param.getString("zip1");
		String zip2 = param.getString("zip2");
		String addr1 = param.getString("addr1");
		String addr2 = param.getString("addr2");
		
		String jikuk = param.getString("user_number1");
		String serial = param.getString("user_number2");
		
		String bank_username = param.getString("bank_username");
		String bank = param.getString("bank");
		bank = bank + "0000";
		if( bank.length() > 6 ){
			bank = bank.substring(0, 6);
		}
		String bank_num = param.getString("bank_num");
		String bank_own = param.getString("bank_own");
		String bank_money = param.getString("bank_money");
		
		String sdate = param.getString("sdate");
		String rdate = param.getString("rdate");
		
		String handy_1 = param.getString("handy_1");
		String handy_2 = param.getString("handy_2");
		String handy_3 = param.getString("handy_3");
		String handy = handy_1 + "-" + handy_2 + "-" + handy_3;
		
		String email = param.getString("eamil");
		String busu = param.getString("busu");
		
		String memo = param.getString("memo");
		String search_state = param.getString("search_state");
		
		String stu_sch = param.getString("stu_sch");
		String stu_part = param.getString("stu_part");
		String stu_class = param.getString("stu_class");
		String stu_prof = param.getString("stu_prof");
		
		String stu_adm = param.getString("stu_adm");
		String stu_caller = param.getString("stu_caller");
		
		String readno = param.getString("readno");
		
		String view = param.getString("view");
		
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
		dbparam.put("NUMID", numid);
		
		Map result = (Map)generalDAO.queryForObject("billing.student.member.getUserInfo", dbparam);
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
					top_serial =  (String)generalDAO.queryForObject("billing.student.member.getTopSerial", dbparam);
					
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
		
		dbparam = new HashMap();
		dbparam.put("INTYPE", intype);
		dbparam.put("JIKUK", jikuk);
		dbparam.put("GUBUN", gubun);
		dbparam.put("SERIAL", serial);
		dbparam.put("USERNAME", username);
		dbparam.put("TELEPHONE", telephone);
		dbparam.put("ZIP1", zip1);
		dbparam.put("ZIP2", zip2);
		dbparam.put("ADDR1", addr1);
		dbparam.put("ADDR2", addr2);
		dbparam.put("BANK_USERNAME", bank_username);
		dbparam.put("BANK", bank);
		dbparam.put("BANK_NUM", bank_num);
		dbparam.put("BANK_MONEY", bank_money);
		dbparam.put("BANK_OWN", bank_own);
		dbparam.put("HANDY", handy);
		dbparam.put("SDATE", sdate);
		dbparam.put("READNO", readno);
		dbparam.put("RDATE", rdate);
		dbparam.put("EMAIL", email);
		dbparam.put("BUSU", busu);
		dbparam.put("MEMO", memo);
		dbparam.put("STU_SCH", stu_sch);
		dbparam.put("STU_PART", stu_part);
		dbparam.put("STU_CLASS", stu_class);
		dbparam.put("STU_PROF", stu_prof);
		dbparam.put("STU_ADM", stu_adm);
		dbparam.put("STU_CALLER", stu_caller); 
		dbparam.put("NUMID", numid);
		
		int updateResult = generalDAO.update("billing.student.member.updateMeberInfo", dbparam);
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("common/message");

		if( updateResult > 0 ){
			mav.addObject("message", serial_str + "정상적으로 수정 되었습니다.");
			if( StringUtils.isNotEmpty(view) ){
				mav.addObject("returnURL", "./view_stu.do?numid=" + numid);
			}else{
				mav.addObject("returnURL", "./list_stu.do?username=" + username + "&bank_username=" + bank_username + "&bank=" + bank);
			}
		}else{
			mav.addObject("message", "수정되지 않았습니다.");
			mav.addObject("returnURL", "./list_stu.do?username=" + username + "&bank_username=" + bank_username + "&bank=" + bank);
		}
		
		return mav;
	}
	
	
}
