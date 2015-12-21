package com.mkreader.web.reader;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.util.Param;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;
import org.springframework.web.servlet.view.RedirectView;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.DateUtil;
import com.mkreader.util.Paging;
import com.mkreader.util.StringUtil;

public class ReaderMoveController extends MultiActionController implements ISiteConstant, ICodeConstant {

	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {

		this.generalDAO = generalDAO;
	}

	/**
	 * 독자이전 리스트
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView readerMoveList(HttpServletRequest request,HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		try {
			HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
			
			String readnm = param.getString("readnm");
			String out_boseqnm = param.getString("out_boseqnm");
			String in_boseqnm = param.getString("in_boseqnm");
			String status = param.getString("status");
			String sgyy = request.getParameter("sgyy");
			String sgmm = request.getParameter("sgmm");
			
			if(sgyy == null)sgyy = DateUtil.getDateFormat(new Date(),"yyyy");
			if(sgmm == null)sgmm = DateUtil.getDateFormat(new Date(),"MM");
			
			String sort = param.getString("sort");
			if(StringUtil.isNull(sort))sort = "DESC";

			
			Calendar rightNow = Calendar.getInstance();
			String year = String.valueOf(rightNow.get(Calendar.YEAR));
			String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
			String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));
			if (month.length() < 2)
				month = "0" + month;
			if (day.length() < 2)
				day = "0" + day;
			
			String startDate= param.getString("startDate", year + "-01-01");			//기간 from
			String endDate= param.getString("endDate", year + "-" + month + "-" + day);				//기간 to
			
			String sgyymm = sgyy + sgmm;
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 20;
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			int totalCount = 0;
			
			dbparam.put("readnm",readnm);
			dbparam.put("out_boseqnm",out_boseqnm);
			dbparam.put("in_boseqnm",in_boseqnm);
			dbparam.put("sgyymm",sgyymm);
			dbparam.put("status",status);
			dbparam.put("startDate",startDate);
			dbparam.put("endDate",endDate);
			dbparam.put("sort",sort);
			
			List readerMoveList = generalDAO.queryForList("readerMove.readerMoveList" , dbparam);// 독자리스트
			//List readerList = null;// 독자리스트
			totalCount = generalDAO.count("readerMove.readerMoveCount" , dbparam);
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 10));
			mav.addObject("readerMoveList", readerMoveList);
			
			mav.addObject("readnm", readnm);
			mav.addObject("out_boseqnm", out_boseqnm);
			mav.addObject("in_boseqnm", in_boseqnm);
			mav.addObject("sgyy",sgyy);
			mav.addObject("sgmm",sgmm);
			mav.addObject("status", status);
			mav.addObject("startDate",startDate);
			mav.addObject("endDate",endDate);
			mav.addObject("sort",sort);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
				
		mav.addObject("now_menu", MENU_CODE_READER_MOVE);
		mav.setViewName("/reader/readerMove/readerMoveList");
		return mav;
	}
	
	/**
	 * 독자이전 등록폼
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView readerMoveInsert(HttpServletRequest request,HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		String movedt = DateUtil.getCurrentDate("yyyy-MM-dd");
		String sgyy = DateUtil.getCurrentDate("yyyy");
		String sgmm = DateUtil.getCurrentDate("MM");
		mav.addObject("movedt",movedt);
		mav.addObject("now_menu", MENU_CODE_READER_MOVE);
		mav.addObject("sgyy",sgyy);
		mav.addObject("sgmm",sgmm);
		mav.setViewName("/reader/readerMove/readerMoveInsert");
		return mav;
	}
	
	public ModelAndView executeReaderMoveInsert(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		HttpSession session = request.getSession();
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		try {
			String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
			String adminId = (String) session.getAttribute(SESSION_NAME_ADMIN_USERID);
			String tempId = (StringUtils.isNotEmpty(jikuk))?jikuk:adminId;
			dbparam.put("inps",tempId);
			
			dbparam.put("readnm",param.getString("readnm"));
			dbparam.put("competentnm",param.getString("competentnm"));
			dbparam.put("handy1", param.getString("handy1"));
			dbparam.put("handy2", param.getString("handy2"));
			dbparam.put("handy3", param.getString("handy3"));
			dbparam.put("tel1", param.getString("tel1"));
			dbparam.put("tel2", param.getString("tel2"));
			dbparam.put("tel3", param.getString("tel3"));
			dbparam.put("out_zipcode",param.getString("out_zipcode"));
			dbparam.put("out_adrs1",param.getString("out_adrs1"));
			dbparam.put("out_adrs2",param.getString("out_adrs2"));
			dbparam.put("out_boseq",param.getString("out_boseq"));
			dbparam.put("out_boseqnm",param.getString("out_boseqnm"));
			dbparam.put("in_zipcode",param.getString("in_zipcode"));
			dbparam.put("in_adrs1",param.getString("in_adrs1"));
			dbparam.put("in_adrs2",param.getString("in_adrs2"));
			dbparam.put("in_boseq",param.getString("in_boseq"));
			dbparam.put("in_boseqnm",param.getString("in_boseqnm"));
			dbparam.put("movedt",StringUtil.replace(param.getString("movedt"), "-", ""));
			
			String sgyy = param.getString("sgyy");
			String sgmm = param.getString("sgmm");
			dbparam.put("sgyymm",sgyy + sgmm);
			
			dbparam.put("qty",param.getString("qty"));
			dbparam.put("sgtype", param.getString("sgtype"));
			generalDAO.insert("readerMove.readerMoveInsert", dbparam);
		} catch (Exception e) {
			e.printStackTrace();
		}
		mav.addObject("now_menu", MENU_CODE_READER_MOVE);
		mav.setView(new RedirectView("/reader/readerMove/readerMoveList.do"));
		return mav;
	}
	
	/**
	 * 독자이전 수정폼
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView readerMoveEdit(HttpServletRequest request,HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		try {
			String seq = param.getString("seq");
			HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
			dbparam.put("seq",seq);
			Map readerMove = (Map)generalDAO.queryForObject("readerMove.getReaderMove" , dbparam);
			String movedt = readerMove.get("MOVEDT").toString();
			movedt = movedt.substring(0,4) + "-" + movedt.substring(4,6) + "-" + movedt.substring(6,8);
			readerMove.put("MOVEDT", movedt);
			String sgyymm = readerMove.get("SGYYMM").toString();
			mav.addObject("readerMove",readerMove);
			mav.addObject("SGYY",sgyymm.substring(0,4));
			mav.addObject("SGMM",sgyymm.substring(4,6));
		} catch (Exception e) {
			e.printStackTrace();
		}
		mav.addObject("now_menu", MENU_CODE_READER_MOVE);
		mav.setViewName("/reader/readerMove/readerMoveEdit");
		return mav;
	}
	
	public ModelAndView executeReaderMoveEdit(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		HttpSession session = request.getSession();
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		try {
			String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
			String adminId = (String) session.getAttribute(SESSION_NAME_ADMIN_USERID);
			String tempId = (StringUtils.isNotEmpty(jikuk))?jikuk:adminId;
			dbparam.put("chgps",tempId);
			
			dbparam.put("seq",param.getString("seq"));
			dbparam.put("readnm",param.getString("readnm"));
			dbparam.put("competentnm",param.getString("competentnm"));
			dbparam.put("handy1", param.getString("handy1"));
			dbparam.put("handy2", param.getString("handy2"));
			dbparam.put("handy3", param.getString("handy3"));
			dbparam.put("tel1", param.getString("tel1"));
			dbparam.put("tel2", param.getString("tel2"));
			dbparam.put("tel3", param.getString("tel3"));
			dbparam.put("out_zipcode",param.getString("out_zipcode"));
			dbparam.put("out_adrs1",param.getString("out_adrs1"));
			dbparam.put("out_adrs2",param.getString("out_adrs2"));
			dbparam.put("out_boseq",param.getString("out_boseq"));
			dbparam.put("out_boseqnm",param.getString("out_boseqnm"));
			dbparam.put("in_zipcode",param.getString("in_zipcode"));
			dbparam.put("in_adrs1",param.getString("in_adrs1"));
			dbparam.put("in_adrs2",param.getString("in_adrs2"));
			dbparam.put("in_boseq",param.getString("in_boseq"));
			dbparam.put("in_boseqnm",param.getString("in_boseqnm"));
			dbparam.put("movedt",StringUtil.replace(param.getString("movedt"), "-", ""));
			
			String sgyy = param.getString("sgyy");
			String sgmm = param.getString("sgmm");
			dbparam.put("sgyymm",sgyy + sgmm);
			
			dbparam.put("qty",param.getString("qty"));
			dbparam.put("sgtype", param.getString("sgtype"));
			dbparam.put("status",param.getString("status"));
			generalDAO.insert("readerMove.readerMoveEdit", dbparam);
		} catch (Exception e) {
			e.printStackTrace();
		}
		mav.addObject("now_menu", MENU_CODE_READER_MOVE);
		mav.setView(new RedirectView("/reader/readerMove/readerMoveList.do"));
		return mav;
	}
	
	public ModelAndView executeReaderMoveDelete(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		try {
			dbparam.put("seq",param.getString("seq"));
			
			generalDAO.insert("readerMove.readerMoveDelete", dbparam);
		} catch (Exception e) {
			e.printStackTrace();
		}
		mav.addObject("now_menu", MENU_CODE_READER_MOVE);
		mav.setView(new RedirectView("/reader/readerMove/readerMoveList.do"));
		return mav;
	}
	
	/**
	 * 독자이전 리스트
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView readerMoveListForJikuk(HttpServletRequest request,HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		HttpSession session = request.getSession();
		try {
			HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
			String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);			
			String readnm = param.getString("readnm");
			String status = param.getString("status");
			String move_type = param.getString("move_type");
			if(StringUtil.isNull(move_type)){
				move_type = "ALL";
			}
			
			String sgyy = request.getParameter("sgyy");
			String sgmm = request.getParameter("sgmm");
			
			if(sgyy == null)sgyy = DateUtil.getDateFormat(new Date(),"yyyy");
			if(sgmm == null)sgmm = DateUtil.getDateFormat(new Date(),"MM");
			
			String sort = param.getString("sort");
			if(StringUtil.isNull(sort))sort = "DESC";

			
			Calendar rightNow = Calendar.getInstance();
			String year = String.valueOf(rightNow.get(Calendar.YEAR));
			String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
			String day = String.valueOf(rightNow.get(Calendar.DAY_OF_MONTH));
			if (month.length() < 2)
				month = "0" + month;
			if (day.length() < 2)
				day = "0" + day;
			
			String startDate= param.getString("startDate", year + "-01-01");			//기간 from
			String endDate= param.getString("endDate", year + "-" + month + "-" + day);				//기간 to
			
			String sgyymm = sgyy + sgmm;
			
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 20;
			dbparam.put("PAGE_NO", Integer.valueOf(pageNo));
			dbparam.put("PAGE_SIZE", Integer.valueOf(pageSize));
			int totalCount = 0;
			
			dbparam.put("out_boseq",jikuk);
			dbparam.put("in_boseq",jikuk);
			dbparam.put("readnm",readnm);
			dbparam.put("sgyymm",sgyymm);
			dbparam.put("status",status);
			dbparam.put("move_type",move_type);
			dbparam.put("startDate",startDate);
			dbparam.put("endDate",endDate);
			dbparam.put("sort",sort);
			
			List readerMoveList = generalDAO.queryForList("readerMove.readerMoveListForJikuk" , dbparam);// 독자리스트
			//List readerList = null;// 독자리스트
			totalCount = generalDAO.count("readerMove.readerMoveCountForJikuk" , dbparam);
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 10));
			mav.addObject("readerMoveList", readerMoveList);
			

			mav.addObject("move_type",move_type);
			mav.addObject("out_boseq",jikuk);
			mav.addObject("in_boseq",jikuk);
			mav.addObject("readnm", readnm);
			mav.addObject("status", status);
			mav.addObject("sgyy",sgyy);
			mav.addObject("sgmm",sgmm);
			mav.addObject("startDate",startDate);
			mav.addObject("endDate",endDate);
			mav.addObject("sort",sort);

		} catch (Exception e) {
			e.printStackTrace();
		}
		
				
		mav.addObject("now_menu", MENU_CODE_READER_MOVE);
		mav.setViewName("/reader/readerMove/readerMoveListForJikuk");
		return mav;
	}
	
	/**
	 * 독자이전 등록폼
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView readerMoveInsertForJikuk(HttpServletRequest request,HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		String movedt = DateUtil.getCurrentDate("yyyy-MM-dd");
		String sgyy = DateUtil.getCurrentDate("yyyy");
		String sgmm = DateUtil.getCurrentDate("MM");
		
		Calendar currentCal = Calendar.getInstance();
		
		Calendar standardCal = Calendar.getInstance();
		standardCal.set(Calendar.DATE,15);
		String standardWeek = String.valueOf(standardCal.get(Calendar.DAY_OF_WEEK));
		if(standardWeek.equals("7")){
			standardCal.set(Calendar.DATE,17);
		}else if(standardWeek.equals("1")){
			standardCal.set(Calendar.DATE,16);
		}
		
		String currentSgyymm = DateUtil.getCurrentDate("yyyyMM");
		
		if(currentCal.getTime().getTime() > standardCal.getTime().getTime()){
			standardCal.set(Calendar.MONTH,standardCal.get(Calendar.MONTH) + 1);
			currentSgyymm = DateUtil.getDateFormat(standardCal.getTime(),"yyyyMM");
		}

		
		
		mav.addObject("movedt",movedt);
		mav.addObject("now_menu", MENU_CODE_READER_MOVE);
		mav.addObject("sgyy",sgyy);
		mav.addObject("sgmm",sgmm);
		mav.addObject("currentSgyymm",currentSgyymm);
		mav.setViewName("/reader/readerMove/readerMoveInsertForJikuk");
		return mav;
	}
	
	public ModelAndView executeReaderMoveInsertForJikuk(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		HttpSession session = request.getSession();
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		try {
			String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
			String adminId = (String) session.getAttribute(SESSION_NAME_ADMIN_USERID);
			String tempId = (StringUtils.isNotEmpty(jikuk))?jikuk:adminId;
			dbparam.put("inps",tempId);
			
			dbparam.put("readnm",param.getString("readnm"));
			dbparam.put("competentnm",param.getString("competentnm"));
			dbparam.put("handy1", param.getString("handy1"));
			dbparam.put("handy2", param.getString("handy2"));
			dbparam.put("handy3", param.getString("handy3"));
			dbparam.put("tel1", param.getString("tel1"));
			dbparam.put("tel2", param.getString("tel2"));
			dbparam.put("tel3", param.getString("tel3"));
			dbparam.put("out_zipcode",param.getString("out_zipcode"));
			dbparam.put("out_adrs1",param.getString("out_adrs1"));
			dbparam.put("out_adrs2",param.getString("out_adrs2"));
			dbparam.put("out_boseq",param.getString("out_boseq"));
			dbparam.put("out_boseqnm",param.getString("out_boseqnm"));
			dbparam.put("in_zipcode",param.getString("in_zipcode"));
			dbparam.put("in_adrs1",param.getString("in_adrs1"));
			dbparam.put("in_adrs2",param.getString("in_adrs2"));
			dbparam.put("in_boseq",param.getString("in_boseq"));
			dbparam.put("in_boseqnm",param.getString("in_boseqnm"));
			dbparam.put("movedt",StringUtil.replace(param.getString("movedt"), "-", ""));
			
			String sgyy = param.getString("sgyy");
			String sgmm = param.getString("sgmm");
			dbparam.put("sgyymm",sgyy + sgmm);
			
			dbparam.put("qty",param.getString("qty"));
			dbparam.put("sgtype", param.getString("sgtype"));
			generalDAO.insert("readerMove.readerMoveInsertForJikuk", dbparam);
		} catch (Exception e) {
			e.printStackTrace();
		}
		mav.addObject("now_menu", MENU_CODE_READER_MOVE);
		mav.setView(new RedirectView("/reader/readerMove/readerMoveListForJikuk.do"));
		return mav;
	}
	
	/**
	 * 독자이전 수정폼
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView readerMoveEditForJikuk(HttpServletRequest request,HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		try {
			String seq = param.getString("seq");
			HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
			dbparam.put("seq",seq);
			Map readerMove = (Map)generalDAO.queryForObject("readerMove.getReaderMove" , dbparam);
			String movedt = readerMove.get("MOVEDT").toString();
			movedt = movedt.substring(0,4) + "-" + movedt.substring(4,6) + "-" + movedt.substring(6,8);
			readerMove.put("MOVEDT", movedt);
			String sgyymm = readerMove.get("SGYYMM").toString();
			
			Calendar currentCal = Calendar.getInstance();
			
			Calendar standardCal = Calendar.getInstance();
			standardCal.set(Calendar.DATE,15);
			String standardWeek = String.valueOf(standardCal.get(Calendar.DAY_OF_WEEK));
			if(standardWeek.equals("7")){
				standardCal.set(Calendar.DATE,17);
			}else if(standardWeek.equals("1")){
				standardCal.set(Calendar.DATE,16);
			}
			
			String currentSgyymm = DateUtil.getCurrentDate("yyyyMM");
			
			if(currentCal.getTime().getTime() > standardCal.getTime().getTime()){
				standardCal.set(Calendar.MONTH,standardCal.get(Calendar.MONTH) + 1);
				currentSgyymm = DateUtil.getDateFormat(standardCal.getTime(),"yyyyMM");
			}
			
			mav.addObject("readerMove",readerMove);
			mav.addObject("SGYY",sgyymm.substring(0,4));
			mav.addObject("SGMM",sgyymm.substring(4,6));
			mav.addObject("currentSgyymm",currentSgyymm);
		} catch (Exception e) {
			e.printStackTrace();
		}
		mav.addObject("now_menu", MENU_CODE_READER_MOVE);
		mav.setViewName("/reader/readerMove/readerMoveEditForJikuk");
		return mav;
	}
	
	public ModelAndView executeReaderMoveEditForJikuk(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		HttpSession session = request.getSession();
		HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
		try {
			String jikuk = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
			String adminId = (String) session.getAttribute(SESSION_NAME_ADMIN_USERID);
			String tempId = (StringUtils.isNotEmpty(jikuk))?jikuk:adminId;
			dbparam.put("chgps",tempId);
			
			dbparam.put("seq",param.getString("seq"));
			dbparam.put("readnm",param.getString("readnm"));
			dbparam.put("competentnm",param.getString("competentnm"));
			dbparam.put("handy1", param.getString("handy1"));
			dbparam.put("handy2", param.getString("handy2"));
			dbparam.put("handy3", param.getString("handy3"));
			dbparam.put("tel1", param.getString("tel1"));
			dbparam.put("tel2", param.getString("tel2"));
			dbparam.put("tel3", param.getString("tel3"));
			dbparam.put("out_zipcode",param.getString("out_zipcode"));
			dbparam.put("out_adrs1",param.getString("out_adrs1"));
			dbparam.put("out_adrs2",param.getString("out_adrs2"));
			dbparam.put("out_boseq",param.getString("out_boseq"));
			dbparam.put("out_boseqnm",param.getString("out_boseqnm"));
			dbparam.put("in_zipcode",param.getString("in_zipcode"));
			dbparam.put("in_adrs1",param.getString("in_adrs1"));
			dbparam.put("in_adrs2",param.getString("in_adrs2"));
			dbparam.put("in_boseq",param.getString("in_boseq"));
			dbparam.put("in_boseqnm",param.getString("in_boseqnm"));
			dbparam.put("movedt",StringUtil.replace(param.getString("movedt"), "-", ""));
			
			String sgyy = param.getString("sgyy");
			String sgmm = param.getString("sgmm");
			dbparam.put("sgyymm",sgyy + sgmm);
			
			dbparam.put("qty",param.getString("qty"));
			dbparam.put("sgtype", param.getString("sgtype"));
			generalDAO.insert("readerMove.readerMoveEditForJikuk", dbparam);
		} catch (Exception e) {
			e.printStackTrace();
		}
		mav.addObject("now_menu", MENU_CODE_READER_MOVE);
		mav.setView(new RedirectView("/reader/readerMove/readerMoveListForJikuk.do"));
		return mav;
	}
	
	
	/**
	 * 독자이전 리스트
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView readerMoveListSaveExcel(HttpServletRequest request,HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		try {
			HashMap<Object, Object> dbparam = new HashMap<Object, Object>();
			
			String readnm = param.getString("readnm");
			String out_boseqnm = param.getString("out_boseqnm");
			String in_boseqnm = param.getString("in_boseqnm");
			String sgyymm = param.getString("sgyymm");
			String status = param.getString("status");
			
			
			dbparam.put("readnm",readnm);
			dbparam.put("out_boseqnm",out_boseqnm);
			dbparam.put("in_boseqnm",in_boseqnm);
			dbparam.put("sgyymm",sgyymm);
			dbparam.put("status",status);
			
			
			List readerMoveList = generalDAO.queryForList("readerMove.readerMoveListSaveExcel" , dbparam);// 독자리스트
			//List readerList = null;// 독자리스트
			
			
			//String fileName = "billingList_(" + DateUtil.getCurrentDate("yyyyMMdd") + ").xls";
			String fileName = "readerMoveList.xls";
			
			//Excel response
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
			response.setHeader("Content-Description", "JSP Generated Data");
			
			mav.addObject("readerMoveList", readerMoveList);
			
			mav.addObject("readnm", readnm);
			mav.addObject("out_boseqnm", out_boseqnm);
			mav.addObject("in_boseqnm", in_boseqnm);
			mav.addObject("sgyymm", sgyymm);
			mav.addObject("status", status);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
				
		mav.addObject("now_menu", MENU_CODE_READER_MOVE);
		mav.setViewName("/reader/readerMove/readerMoveListSaveExcel");
		return mav;
	}
	
}