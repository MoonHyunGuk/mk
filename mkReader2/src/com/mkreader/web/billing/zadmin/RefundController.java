package com.mkreader.web.billing.zadmin;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Calendar;
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
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.Paging;
import com.mkreader.util.PagingUtil;



public class RefundController extends MultiActionController implements
		ISiteConstant {

	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {

		this.generalDAO = generalDAO;
	}
	
	
	
	/**
	 * 환불 내역 조회 리스트
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView list(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		//메뉴펼치기
		String show_hidden5 = "display";
		
		int pagesize = 30;
		int conternp = 10;
		
		//parameter
		Param param = new HttpServletParam(request);
		int pageNo = param.getInt("pageNo", 1);
		String idid = param.getString("idid");
		String numid = param.getString("numid");
		int page = param.getInt("page");
		String jikuk = param.getString("jikuk");
		String chbx = param.getString("chbx", "off");
		String filename = param.getString("filename");
		String sdate = param.getString("sdate");
		String edate = param.getString("edate");
		int startpage = param.getInt("startpage", 1);
		int typecd = param.getInt("typecd", 1);
		
		
		String EACH_filename = "";
		if( filename.length() > 4 ){
			EACH_filename = "EA21" + filename.substring(filename.length() - 4); 
		}
		
		//이번달의 월말값 계산
		if( StringUtils.isEmpty(sdate) ){
			Calendar cal = Calendar.getInstance();
			String year = cal.get(Calendar.YEAR) + "";
			String month = cal.get(Calendar.MONTH)+1 + "";
			if( month.length() == 1 ){
				month = "0" + month;
			}
			//마지막날짜구하기
			int intLastDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
			sdate = year + "-" + month + "-01";
			edate = year + "-" + month + "-" + intLastDay;
			
		}
		//cmsdate
		String s_cmsdate = "";
		String e_cmsdate = "";
		if ( StringUtils.isNotEmpty(sdate) && StringUtils.isNotEmpty(edate) ){
			String sdate_tmp = sdate.replace("-", ""); 
			String edate_tmp = edate.replace("-", "");
			s_cmsdate = sdate_tmp.substring(sdate_tmp.length() - 6);
			e_cmsdate = edate_tmp.substring(edate_tmp.length() - 6);
		}
		
		//dbparam
		HashMap dbparam = new HashMap();
		dbparam.put("SDATE", sdate);
		dbparam.put("EDATE", edate);
		dbparam.put("JIKUK", jikuk);
		
		//지국정보
		List jikukList = generalDAO.queryForList("billing.student.refund.getStatStuJikukList", dbparam);
		
		Map jikukMap = null;
		String thisji = "";
		String jinam = "";
		
		if( jikukList != null ){
			for( int i=0 ; i < jikukList.size(); i++ ){
				jikukMap = (Map)jikukList.get(i);
				//지국코드
				thisji = (String)jikukMap.get("JIKUK");
				dbparam = new HashMap();
				dbparam.put("SERIAL", thisji);
				
				jinam = (String)generalDAO.queryForObject("billing.student.refund.getJikukName", dbparam);
				
				jikukMap.put("THISJI", thisji);
				jikukMap.put("JINAM", jinam);
				jikukList.set(i, jikukMap);
				
			}
		}
		
		dbparam = new HashMap();
		dbparam.put("SDATE", sdate);
		dbparam.put("EDATE", edate);
		dbparam.put("JIKUK", jikuk);
		dbparam.put("TYPECD", typecd);
		if( jikuk.length() > 4 ){
			dbparam.put("JIKUK_CHECK", "Y");
		}
		
		//paging
		Map result = (Map)generalDAO.queryForObject("billing.student.refund.getRefundPriceResult", dbparam);
		BigDecimal count = null;
		BigDecimal totals = null;
		int totpage = 0;
		int notinidx = 0;
		
		if( result != null ){
			count = (BigDecimal)result.get("COUNT");
		}
		if( count.intValue() > 0 ){
			totals = (BigDecimal)result.get("REFUND_PRICE");
		}
		
		totpage = ((count.intValue() - 1) / pagesize) + 1;
		notinidx = (pageNo - 1) * pagesize;

		dbparam.put("PAGE_NO",pageNo);
		dbparam.put("PAGE_SIZE",pagesize);
		
		//리스트
		List resultList = generalDAO.queryForList("billing.student.refund.getResultList2", dbparam);
		
		//테이블명 정하는 방법
		String userName = "";
		Map resultMap = null;
		Map tmpMap = null;
		String TB = "";
		if( resultList != null ){
			for( int i=0 ; i<resultList.size() ; i++ ){
				resultMap = null;
				tmpMap = null;
				resultMap = (Map)result.get(i);
				if( resultMap != null ){
					if( "학생".equals(resultMap.get("GUBUN"))){
						TB = "TBL_USERS_STU";
					}else{
						TB = "TBL_USERS";
					}
					dbparam.put("TB", TB);
					dbparam.put("NUMID", resultMap.get("USERNUMID"));
					tmpMap = (Map)generalDAO.queryForObject("billing.student.refund.getUserInfo", dbparam);
					resultMap.put("USERNAME", tmpMap.get("USERNAME"));
					resultList.set(i, resultMap);
				}
			}
		}
		
		//paging
		//String link = " [ <a href='list.do?chbx=" + chbx + "&sdate=" + sdate + "&edate=" + edate;
		//String paging = PagingUtil.CreatePaging(startpage, totpage, conternp, gotopage, link);

		// mav
		ModelAndView mav = new ModelAndView();
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_BILLING);
		mav.addObject("show_hidden5",show_hidden5);
		mav.addObject("jikukList",jikukList);
		mav.addObject("resultList",resultList);
		mav.addObject("jikuk",jikuk);
		mav.addObject("sdate",sdate);
		mav.addObject("edate",edate);
		//paging
		mav.addObject("count",count);
		mav.addObject("totals",totals);
		mav.addObject("conternp",conternp);
		mav.addObject("startpage",startpage);
		mav.addObject("conternp",conternp);
		mav.addObject("totpage",totpage);
		mav.addObject("pageNo",pageNo);
		//mav.addObject("paging",paging);
		mav.addObject("pageInfo", Paging.getPageMap(pageNo, count.intValue(), pagesize, 10));
		mav.setViewName("billing/zadmin/refund/list");
		return mav;
	}
	
	/**
	 * 환불내역 insert
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView input(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		Param param = new HttpServletParam(request);
		int gotopage = param.getInt("page", 1);
		String idid = param.getString("idid");
		String numid = param.getString("numid");
		int page = param.getInt("page");
		String jikuk = param.getString("jikuk");
		String chbx = param.getString("chbx", "off");
		String filename = param.getString("filename");
		String sdate = param.getString("sdate");
		String edate = param.getString("edate");
		int startpage = param.getInt("startpage", 1);
		int typecd = param.getInt("typecd", 1);
		
		//insert parameter
		//String gubun 		= param.getString("gubun");
		String gubun 		= "일반";
		String jikuk_name 	= param.getString("jikuk_name");
		String jikuk_code 	= param.getString("jikuk_code");
		String usernumid 	= param.getString("usernumid");
		String username 	= param.getString("username");
		String jumin 		= param.getString("jumin");
		String bank_name 	= param.getString("bank_name");
		String bank_num 	= param.getString("bank_num");
		int refund_price	= param.getInt("refund_price");
		String refund_date 	= param.getString("refund_date");

		//gubun에 따른 table이 틀려짐
		String dbtb = "";
		String txt = "";
		if ( "학생".equals(gubun) ){
			dbtb = "tbl_users_stu";
		}else{
			dbtb = "tbl_users";
		}
		
		//dbparam
		HashMap dbparam = new HashMap();
		dbparam.put("DBTB", dbtb);
		dbparam.put("USERNAME", username);
		dbparam.put("JIKUK", jikuk_code);
		dbparam.put("BANK_NUM", bank_num);

		
		
		//이미 등록되 있는 numid번호 불러오기
		Object numid_input = generalDAO.queryForObject("billing.student.refund.getNumid", dbparam);
		if( numid_input != null ){
			txt = "자동변환";
		}else{
			dbparam = new HashMap();
			dbparam.put("DBTB", dbtb);
			dbparam.put("USERNAME", username);
			dbparam.put("JIKUK", jikuk_code);
			
			numid_input = generalDAO.queryForObject("billing.student.refund.getNumid", dbparam);
			if( numid_input != null ){
				txt = "자동변환";
			}
		}
		if( numid_input == null ){
			numid_input = usernumid;
			txt = "X";
		}
		//insert query
		dbparam = new HashMap();
		dbparam.put("CHASU", 1);
		dbparam.put("GUBUN", gubun);
		dbparam.put("USERNUMID", numid_input);
		dbparam.put("USERNAME", username);
		dbparam.put("JUMIN", jumin);
		dbparam.put("JIKUK", jikuk_code);
		dbparam.put("JIKUK_NAME", jikuk_name);
		dbparam.put("BANK_NAME", bank_name);
		dbparam.put("BANK_NUM", bank_num);
		dbparam.put("REFUND_PRICE", refund_price);
		dbparam.put("REFUND_DATE", refund_date);
		dbparam.put("TXT", txt);
		dbparam.put("TYPECD", typecd);
		
		
		generalDAO.insert("billing.student.refund.insertRefund", dbparam);

		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("common/message");
		mav.addObject("message", "자료가 정상적으로 등록 되었습니다.");
		mav.addObject("returnURL", "./list.do");
		return mav;
	}
	
	
}
