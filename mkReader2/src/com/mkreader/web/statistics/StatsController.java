package com.mkreader.web.statistics;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.util.Param;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.DateUtil;



public class StatsController extends MultiActionController implements
		ISiteConstant {

	private GeneralDAO generalDAO;
 
	public void setGeneralDAO(GeneralDAO generalDAO) {

		this.generalDAO = generalDAO;
	}
	
	/**
	 * 통계조회 (통계일람, 당월입금, 총입금현황, 유가배부현황
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView state(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		//월분 
		Calendar rightNow = Calendar.getInstance();
		int day = rightNow.get(Calendar.DAY_OF_MONTH);
		if( day > 20 ){
			rightNow.add(2, 0);
		}else{
			rightNow.add(2, -1);
		}
		String year = String.valueOf(rightNow.get(Calendar.YEAR));
		String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		if (month.length() < 2)
			month = "0" + month;
		
		// param
		Param param = new HttpServletParam(request);
		
		//월분
		String yymm = param.getString("yymm", year + month);
		
		
		String year2 = yymm.substring(0,4);
		String month2 = String.valueOf(Integer.parseInt(yymm.substring(4,6) )+ 1);
		String day2;
		if(yymm.equals(year + month) && day > 21){
			month2 = String.valueOf(Integer.parseInt(yymm.substring(4,6) ));
			day2 = String.valueOf(day);
		}else{
			day2 = "20";
		}
		if(month2.equals("13")){
			month2 = "1";
			 year2 = String.valueOf(Integer.parseInt(year2)+1);
		}
		if (month2.length() < 2) {
			month2 = "0" + month2;
		}

		String yymm2 = year2 + month2;
				
		//뉴스코드(최초에 매일경제값셋팅)
		String newsCd[] = param.getStringValues("newsCd",MK_NEWSPAPER_CODE);
		if(newsCd.length == 0) newsCd = new String[] {MK_NEWSPAPER_CODE};  // 최초 매일경제값 세팅(param.getStringValues 가 제대로 안되서 추가)
		//통계타입
		String type = param.getString("type","peruse");
		//기준
		String stats = "";
		
		/* 실시간조회를 위해 주석처리(ABC)*/
		if( ("paymentAdjustments".equals(type) ) && (year + month).equals(yymm) ){   
			stats = "2";
		}else{	
			stats = "1";	
		}	
		/**/
		//stats = "2";  // 실시간조회를 위해 구분자 '2'로 세팅 
		
		
		if( yymm.length() != 6 ) {
			ModelAndView mav = new ModelAndView();
			mav.setViewName("common/message");
			mav.addObject("message", "월분을 확인 해 주세요.");
			mav.addObject("returnURL", "/statistics/stats/" + type + ".do");
			return mav;
		}
		
		
		//지국 일 경우 지국에 대한 정보만 보여준다.
		HttpSession session = request.getSession();
		String boseq = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		// db query parameter
		HashMap dbparam = new HashMap();
		dbparam.put("BOSEQ",boseq);
		dbparam.put("USEYN","Y");
		dbparam.put("CDCLSF",MK_NEWSPAPER_CODE);
		
		//신문명리스트
		List newsCodeList = null;
		
		if( StringUtils.isEmpty(boseq) ){
			newsCodeList = generalDAO.queryForList("statistics.stats.getNewsCodeList", dbparam);
		}else{
			newsCodeList = generalDAO.queryForList("statistics.stats.getNewsJikukCodeList", dbparam);
		}
		
		// db query parameter
		dbparam = new HashMap();
		dbparam.put("YYMM",yymm);
		dbparam.put("NEWSCD",newsCd);
		dbparam.put("BOSEQ",boseq);
		dbparam.put("TYPE",type);
		
		// excute query(기준에 따라 나눈다.)
		List resultList = null;
		//월마감기준
		if( "1".equals(stats) ){
			resultList = generalDAO.queryForList("statistics.stats.getStateList", dbparam);
			logger.debug("===== statistics.stats.getStateList");
		}
		//실시간 기준
		else{

				//X개월 후
				String sgyymm1After = DateUtil.getWantDay(yymm + "01", 2, 1);
				if( sgyymm1After.length() == 8 ){
					sgyymm1After = sgyymm1After.substring(0,6);
				}
				String sgyymm2After = DateUtil.getWantDay(yymm + "01", 2, 2);
				if( sgyymm2After.length() == 8 ){
					sgyymm2After = sgyymm2After.substring(0,6);
				}
				String sgyymm3After = DateUtil.getWantDay(yymm + "01", 2, 3);
				if( sgyymm3After.length() == 8 ){
					sgyymm3After = sgyymm3After.substring(0,6);
				}
				String sgyymm4After = DateUtil.getWantDay(yymm + "01", 2, 4);
				if( sgyymm4After.length() == 8 ){
					sgyymm4After = sgyymm4After.substring(0,6);
				}
				String sgyymm5After = DateUtil.getWantDay(yymm + "01", 2, 5);
				if( sgyymm5After.length() == 8 ){
					sgyymm5After = sgyymm5After.substring(0,6);
				}
				String sgyymm6After = DateUtil.getWantDay(yymm + "01", 2, 6);
				if( sgyymm6After.length() == 8 ){
					sgyymm6After = sgyymm6After.substring(0,6);
				}
				String sgyymm7After = DateUtil.getWantDay(yymm + "01", 2, 7);
				if( sgyymm7After.length() == 8 ){
					sgyymm7After = sgyymm7After.substring(0,6);
				}
				
				String fromYymmdd = yymm + "21";											//기간 from
				String toYymmdd = DateUtil.getWantDay(yymm + day2, 2, 1);					//기간 to
				
				dbparam.put("SGYYMM",yymm);
				dbparam.put("NEWSCD",newsCd);
				dbparam.put("BOSEQ",boseq);
				dbparam.put("SGYYMM1AFTER",sgyymm1After);
				dbparam.put("SGYYMM2AFTER",sgyymm2After);
				dbparam.put("SGYYMM3AFTER",sgyymm3After);
				dbparam.put("SGYYMM4AFTER",sgyymm4After);
				dbparam.put("SGYYMM5AFTER",sgyymm5After);
				dbparam.put("SGYYMM6AFTER",sgyymm6After);
				dbparam.put("SGYYMM7AFTER",sgyymm7After);
				dbparam.put("FROMYYMMDD",fromYymmdd);
				dbparam.put("TOYYMMDD",toYymmdd);
				dbparam.put("CODE_SUGM_AMT",CODE_SUGM_AMT);
				
				resultList = generalDAO.queryForList("statistics.stats.getPeruseList", dbparam);      // 조회시점 월 기준 실시간 조회 쿼리(평상시 '당월입금' 통계만 해당됨)
				//resultList = generalDAO.queryForList("statistics.stats.getRealtimeStat", dbparam);     // 과거월포함 실시간 조회가능 쿼리(ABC용)
				logger.debug("===== statistics.stats.getStateList");
			
		}
		
		
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("statistics/stats/" + type);
		String menuType= "";
		if("peruse".equals(type)) {
			menuType = ICodeConstant.MENU_CODE_STATISTICS;
		} if("paymentAdjustments".equals(type)) {
			menuType = ICodeConstant.MENU_CODE_STATISTICS_MONTH;
		} if("paymentStats".equals(type)) {
			menuType = ICodeConstant.MENU_CODE_STATISTICS_INCOMING;
		} if("bill".equals(type)) {
			menuType = ICodeConstant.MENU_CODE_STATISTICS_BILL;
		}
		mav.addObject("now_menu", menuType);
		
		mav.addObject("yymm", yymm);
		mav.addObject("yymm2", yymm2);
		mav.addObject("day2", day2);
		mav.addObject("newsCd", newsCd);
		mav.addObject("stats", stats);
		mav.addObject("boseq", boseq);
	
		mav.addObject("newsCodeList", newsCodeList);
		mav.addObject("resultList", resultList);
		
		return mav;
	}
	

	/**
	 * 배부현황
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView delivery(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		//월분 
		Calendar rightNow = Calendar.getInstance();
		int day = rightNow.get(Calendar.DAY_OF_MONTH);
		if( day > 20 ){
			rightNow.add(2, 0);
		}else{
			rightNow.add(2, -1);
		}
		String year = String.valueOf(rightNow.get(Calendar.YEAR));
		String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
		if (month.length() < 2)
			month = "0" + month;
		
		// param
		Param param = new HttpServletParam(request);
		
		//월분
		String yymm = param.getString("yymm", year + month);
				
		//뉴스코드(최초에 매일경제값셋팅)
		String newsCd[] = param.getStringValues("newsCd",MK_NEWSPAPER_CODE);
		if(newsCd.length == 0) newsCd = new String[] {MK_NEWSPAPER_CODE};  // 최초 매일경제값 세팅(param.getStringValues 가 제대로 안되서 추가)
		if( yymm.length() != 6 ) {
			ModelAndView mav = new ModelAndView();
			mav.setViewName("common/message");
			mav.addObject("message", "월분을 확인 해 주세요.");
			mav.addObject("returnURL", "/statistics/stats/delivery.do");
			return mav;
		}
		
		
		//지국 일 경우 지국에 대한 정보만 보여준다.
		HttpSession session = request.getSession();
		String boseq = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		// db query parameter
		HashMap dbparam = new HashMap();
		dbparam.put("BOSEQ",boseq);
		dbparam.put("USEYN","Y");
		dbparam.put("CDCLSF",MK_NEWSPAPER_CODE);
		
		//신문명리스트
		List newsCodeList = null;
		
		if( StringUtils.isEmpty(boseq) ){
			newsCodeList = generalDAO.queryForList("statistics.stats.getNewsCodeList", dbparam);
		}else{
			newsCodeList = generalDAO.queryForList("statistics.stats.getNewsJikukCodeList", dbparam);
		}
		
		// db query parameter
		dbparam = new HashMap();
		dbparam.put("YYMM",yymm);
		dbparam.put("NEWSCD",newsCd);
		dbparam.put("BOSEQ",boseq);
		
		// excute query
		List resultList = null;
		
		dbparam.put("NEWSCD",newsCd);
		dbparam.put("BOSEQ",boseq);
		dbparam.put("CODE_SUGM_AMT",CODE_SUGM_AMT);
		
		resultList = generalDAO.queryForList("statistics.stats.getDeliveryList", dbparam);
		logger.debug("===== statistics.stats.getDeliveryList");
			
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("statistics/stats/delivery");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_STATISTICS_DELIVERY);
		
		mav.addObject("yymm", yymm);
		mav.addObject("newsCd", newsCd);
		mav.addObject("boseq", boseq);
	
		mav.addObject("newsCodeList", newsCodeList);
		mav.addObject("resultList", resultList);
		
		return mav;
	}
	
	/**
	 * OZ 통계 인쇄 (통계일람, 당월입금, 총입금현황, 유가현황)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ozState(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		//월분 
				Calendar rightNow = Calendar.getInstance();
				int day = rightNow.get(Calendar.DAY_OF_MONTH);
				if( day > 20 ){
					rightNow.add(2, 0);
				}else{
					rightNow.add(2, -1);
				}
				String year = String.valueOf(rightNow.get(Calendar.YEAR));
				String month = String.valueOf(rightNow.get(Calendar.MONTH) + 1);
				if (month.length() < 2)
					month = "0" + month;
				
				// param
				Param param = new HttpServletParam(request);
				
				//월분
				String yymm = param.getString("yymm", year + month);
				
				
				String year2 = yymm.substring(0,4);
				String month2 = String.valueOf(Integer.parseInt(yymm.substring(4,6) )+ 1);
				String day2;
				if(yymm.equals(year + month) && day > 21){
					month2 = String.valueOf(Integer.parseInt(yymm.substring(4,6) ));
					day2 = String.valueOf(day);
				}else{
					day2 = "20";
				}
				if(month2.equals("13")){
					month2 = "1";
					 year2 = String.valueOf(Integer.parseInt(year2)+1);
				}
				if (month2.length() < 2) {
					month2 = "0" + month2;
				}

				String yymm2 = year2 + month2;

		
		// 매체구분
		String newsCdParam[] = param.getStringValues("newsCd",MK_NEWSPAPER_CODE);
		if(newsCdParam.length == 0) newsCdParam = new String[] {MK_NEWSPAPER_CODE};  // 최초 매일경제값 세팅(param.getStringValues 가 제대로 안되서 추가)
		String newsCd = "";

		for(int i=0 ; i < newsCdParam.length ; i++ ){
			if(!"".equals(newsCdParam[i]) &&newsCdParam[i] != null){
				newsCd = newsCd + "'" + newsCdParam[i] + "',";
				logger.debug("로그 확인 newsCd["+i+"] : " + newsCdParam[i]);		
			}
		}
		newsCd = newsCd + "''" ;
		
		//통계타입
		String type = param.getString("type","peruse");
		//기준
		String stats = "";			// 1:월마감기준, 그외 실시간기준
		if( ("paymentAdjustments".equals(type) ) && (year + month).equals(yymm) ){
			stats = "2";
		}else{
			stats = "1";
		}
		
		if( yymm.length() != 6 ) {
			ModelAndView mav = new ModelAndView();
			mav.setViewName("common/message");
			mav.addObject("message", "월분을 확인 해 주세요.");
			mav.addObject("returnURL", "/statistics/stats/" + type + ".do");
			return mav;
		}
		
		//지국 일 경우 지국에 대한 정보만 보여준다.
		HttpSession session = request.getSession();
		String boseq = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		String fromYymmdd = yymm + "21";											//기간 from
		String toYymmdd = DateUtil.getWantDay(yymm + day2, 2, 1);					//기간 to
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("statistics/stats/ozStats");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_STATISTICS);
		
		mav.addObject("type",type);
		mav.addObject("CODE_SUGM_AMT",CODE_SUGM_AMT);
		mav.addObject("STATS",stats);
		mav.addObject("YYMM",yymm);
		mav.addObject("NEWSCD",newsCd);
		mav.addObject("BOSEQ",boseq);
		mav.addObject("FROMYYMMDD",fromYymmdd);
		mav.addObject("TOYYMMDD",toYymmdd);
		
		return mav;
		
	}


	/**
	 * OZ 통계 인쇄 (배부현황)
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView ozDelivery(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		// param
		Param param = new HttpServletParam(request);
		
		// 매체구분
		String newsCdParam[] = param.getStringValues("newsCd",MK_NEWSPAPER_CODE);
		if(newsCdParam.length == 0) newsCdParam = new String[] {MK_NEWSPAPER_CODE};  // 최초 매일경제값 세팅(param.getStringValues 가 제대로 안되서 추가)
		String newsCd = "";

		for(int i=0 ; i < newsCdParam.length ; i++ ){
			if(!"".equals(newsCdParam[i]) &&newsCdParam[i] != null){
				newsCd = newsCd + "'" + newsCdParam[i] + "',";
				logger.debug("로그 확인 newsCd["+i+"] : " + newsCdParam[i]);		
			}
		}
		newsCd = newsCd + "''" ;
				
		//지국 일 경우 지국에 대한 정보만 보여준다.
		HttpSession session = request.getSession();
		String boseq = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("statistics/stats/ozDelivery");
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_STATISTICS_DELIVERY);
		
		mav.addObject("CODE_SUGM_AMT",CODE_SUGM_AMT);
		mav.addObject("NEWSCD",newsCd);
		mav.addObject("BOSEQ",boseq);
		
		return mav;
		
	}
	
	
	/**
	 * 독자현황
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView readerTypeList(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		// param
		Param param = new HttpServletParam(request);
		
		//월분 
		HttpSession session = request.getSession();
		String boseq = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		// db query parameter
		HashMap<String,Object> dbparam = new HashMap<String,Object>();
		dbparam.put("boseq",boseq);
		dbparam.put("opStartDate", param.getString("opStartDate").replaceAll("-", ""));
		dbparam.put("opEndDate", param.getString("opEndDate").replaceAll("-", ""));
		
		List readerListByUprice = null;
		 
		//독자조회
		readerListByUprice = generalDAO.queryForList("statistics.stats.getReaderTypeList", dbparam);
		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.addObject("readerListByUprice", readerListByUprice);
		mav.addObject("opStartDate", param.getString("opStartDate"));
		mav.addObject("opEndDate", param.getString("opEndDate"));
		mav.addObject("now_menu", ICodeConstant.MENU_CODE_STATISTICS_COST);
		mav.setViewName("statistics/stats/readerType");
		return mav;
	}
	
	
	/**
	 * 교육용 독자 엑셀 저장
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	public ModelAndView readerTypeListForExcel(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		Param param = new HttpServletParam(request);
		ModelAndView mav = new ModelAndView();
		HttpSession session = request.getSession();
		
		try{
			String boseq = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
			
			// db query parameter
			HashMap<String,Object> dbparam = new HashMap<String,Object>();
			dbparam.put("boseq",boseq); 
			dbparam.put("opStartDate", param.getString("opStartDate").replaceAll("-", ""));
			dbparam.put("opEndDate", param.getString("opEndDate").replaceAll("-", ""));
			
			List readerListByUprice = null;
			 
			//독자조회
			readerListByUprice = generalDAO.queryForList("statistics.stats.getReaderTypeList", dbparam);

			String fileName = "stat_reader_list(" + param.getString("opStartDate") + "~"+param.getString("opEndDate") + ").xls";

			//Excel response
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName); 
			response.setHeader("Content-Description", "JSP Generated Data"); 
			
			mav.addObject("readerListByUprice" , readerListByUprice);
			mav.setViewName("statistics/stats/excelReaderType");
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


