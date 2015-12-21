package com.mkreader.web;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.util.Param;

import org.apache.commons.lang.StringUtils;
import org.springframework.orm.ibatis.SqlMapClientTemplate;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;
import org.springframework.web.servlet.view.RedirectView;

import com.ibatis.sqlmap.engine.impl.SqlMapClientImpl;
import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;



public class MigrationController extends MultiActionController implements
		ISiteConstant, ICodeConstant {

	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {

		this.generalDAO = generalDAO;
	}
	
	/**
	 * 자동이체독자이전
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView reader(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		// db query parameter		
		HashMap dbparam = new HashMap();
		
		//step1
		List tmp_list = generalDAO.queryForList("migration.getTmReaderNewsList");
		Map tmp_map = null;

		int i=0;
		for(i=0;i<tmp_list.size();i++){
			tmp_map = (Map)tmp_list.get(i);
			if( tmp_map != null ){
				dbparam.put("READNO", tmp_map.get("READNO") );
				//구독정보 테이블에 자동이체인 것들 중지
				generalDAO.update("migration.updateTmRederNews", dbparam);
				//system.out.println("migration.updateTmRederNews");
				//system.out.println("dbparam == " + "READNO" + tmp_map.get("READNO") );
				
				//수금 테이블에 자동이체이면서 미수인 건들 결손처리
				generalDAO.update("migration.updateTmRederSugm", dbparam);
				//system.out.println("migration.updateTmRederSugm");
				//system.out.println("dbparam == " + "READNO" + tmp_map.get("READNO") );
			}
		}
		
		System.out.println("==================step1 i = " + i);
	    

		//step 2
		List tmp_list1 = generalDAO.queryForList("migration.getTblUsersList");
		for(i=0;i<tmp_list1.size();i++){
			tmp_map = (Map)tmp_list1.get(i);
			if( tmp_map != null){
				
				BigDecimal numid     = (BigDecimal)tmp_map.get("NUMID");
				String birthd        = (String)tmp_map.get("BIRTHD");
				String JIKUK         = (String)tmp_map.get("JIKUK");
				String READNO        = (String)tmp_map.get("READNO");
				String USERNAME      = (String)tmp_map.get("USERNAME");
				String PHONE      	 = (String)tmp_map.get("PHONE");
				String HANDY     	 = (String)tmp_map.get("HANDY");
				String ZIP1          = (String)tmp_map.get("ZIP1");
				String ZIP2          = (String)tmp_map.get("ZIP2");
				String ADDR1         = (String)tmp_map.get("ADDR1");
				String ADDR2         = (String)tmp_map.get("ADDR2");
				String BANK_MONEY    = (String)tmp_map.get("BANK_MONEY");
				String BUSU          = (String)tmp_map.get("BUSU");
				String SDATESTR      = (String)tmp_map.get("SDATESTR");
				String BIRTHDSTR     = (String)tmp_map.get("BIRTHDSTR");
				Date sdate     		 = (Date)tmp_map.get("SDATE");
				Date rdate     		 = (Date)tmp_map.get("RDATE");
				
				
				String saup = (String)tmp_map.get("SAUP");
				String juminnum = "";
				String saupja = "";
				
				// 주민번호 & 사업자번호
				if( StringUtils.isNotEmpty(saup) ){
					if ( saup.length() == 13) {
						juminnum = saup;		//-- 주민등록번호
					} else {
						saupja = saup;			//-- 사업자등록번호
					}
				}
				
				int maxReadno = (Integer)generalDAO.queryForObject("migration.getTmReaderMaxReadno");
				
				dbparam = new HashMap();
				dbparam.put("MAXREADNO",maxReadno);
				
				dbparam.put("BIRTHD", birthd    );
				dbparam.put("RDATE", rdate     );
				dbparam.put("JIKUK", JIKUK     );
				dbparam.put("READNO", READNO    );
				dbparam.put("USERNAME", USERNAME  );
				
				if ( StringUtils.isNotEmpty(PHONE)) {
					String[] hometelArr = PHONE.split("-");
					if ( hometelArr != null && hometelArr.length > 0 ) {
						if ( hometelArr.length >= 1)		dbparam.put("HOMETEL1", hometelArr[0]  );
						if ( hometelArr.length >= 2)		dbparam.put("HOMETEL2", hometelArr[1]  );
						if ( hometelArr.length >= 3)		dbparam.put("HOMETEL3", hometelArr[2]  );
					}
				}
				if ( StringUtils.isNotEmpty(HANDY)) {
					String[] mobileArr = HANDY.split("-");
					if ( mobileArr != null && mobileArr.length > 0 ) {
						if ( mobileArr.length >= 1)		dbparam.put("MOBILE1", mobileArr[0]  );
						if ( mobileArr.length >= 2)		dbparam.put("MOBILE2", mobileArr[1]  );
						if ( mobileArr.length >= 3)		dbparam.put("MOBILE3", mobileArr[2]  );
					}
				}
				dbparam.put("ZIP1", ZIP1      );
				dbparam.put("ZIP2", ZIP2      );
				dbparam.put("ZIP", ZIP1+ZIP2      );
				dbparam.put("ADDR1", (StringUtils.isNotEmpty(ADDR1) && ADDR1.length() > 100) ? ADDR1.substring(0, 100) : ADDR1     );
				dbparam.put("ADDR2", (StringUtils.isNotEmpty(ADDR2) && ADDR2.length() > 100) ? ADDR2.substring(0, 100) : ADDR2     );
				dbparam.put("BANK_MONEY", BANK_MONEY);
				dbparam.put("BUSU", BUSU      );
				if ( StringUtils.isNotEmpty(SDATESTR) && SDATESTR.length() >= 6) {
					dbparam.put("SDATESTR6", SDATESTR.substring(0, 6)     );
				}
				if ( StringUtils.isNotEmpty(SDATESTR) && SDATESTR.length() >= 8) {
					dbparam.put("SDATESTR8", SDATESTR     );
				}

				dbparam.put("JUMINNUM", juminnum     );
				dbparam.put("SAUPJA", saupja     );
				dbparam.put("BIRTHDSTR", BIRTHDSTR     );
				
				//-- 통합독자 테이블에 신규로 등록
				generalDAO.insert("migration.insertTmReader", dbparam);
				//System.out.println("migration.insertTmReader");
				//System.out.println("dbparam == " + dbparam.toString());

				//-- 구독정보 테이블에 신규로 등록
				generalDAO.insert("migration.insertTmReaderNews_ilban", dbparam);
				//System.out.println("migration.insertTmReaderNews_ilban");
				//System.out.println("dbparam == " + dbparam.toString());
				
				dbparam = new HashMap();
				dbparam.put("READNO", maxReadno );
				dbparam.put("NUMID", numid );
				
				//-- 자동이체독자정보(학생본사) 테이블에 readno를 넣어준다
				generalDAO.update("migration.updateTblUsers", dbparam);
				//system.out.println("migration.updateTblUsers");
				//system.out.println("dbparam == " + dbparam.toString());
			}
		}
		
		System.out.println("==================step2 i = " + i);
		
		
		//step 3
		List tmp_list2 = generalDAO.queryForList("migration.getTblUsersStuList");
		for(i=0;i<tmp_list2.size();i++){
			tmp_map = (Map)tmp_list2.get(i);
			if( tmp_map != null){
				
				BigDecimal numid     = (BigDecimal)tmp_map.get("NUMID");
				String birthd        = (String)tmp_map.get("BIRTHD");
				String JIKUK         = (String)tmp_map.get("JIKUK");
				String READNO        = (String)tmp_map.get("READNO");
				String USERNAME      = (String)tmp_map.get("USERNAME");
				String PHONE      	 = (String)tmp_map.get("PHONE");
				String HANDY     	 = (String)tmp_map.get("HANDY");
				String ZIP1          = (String)tmp_map.get("ZIP1");
				String ZIP2          = (String)tmp_map.get("ZIP2");
				String ADDR1         = (String)tmp_map.get("ADDR1");
				String ADDR2         = (String)tmp_map.get("ADDR2");
				String BANK_MONEY    = (String)tmp_map.get("BANK_MONEY");
				String BUSU          = (String)tmp_map.get("BUSU");
				String SDATESTR      = (String)tmp_map.get("SDATESTR");
				String BIRTHDSTR     = (String)tmp_map.get("BIRTHDSTR");
				Date sdate  	     = (Date)tmp_map.get("SDATE");
				Date rdate 		     = (Date)tmp_map.get("RDATE");
				
				
				String saup = (String)tmp_map.get("SAUP");
				String juminnum = "";
				String saupja = "";
				
				// 주민번호 & 사업자번호
				if( StringUtils.isNotEmpty(saup) ){
					if ( saup.length() == 13) {
						juminnum = saup;		//-- 주민등록번호
					} else {
						saupja = saup;			//-- 사업자등록번호
					}
				}
				
				int maxReadno = (Integer)generalDAO.queryForObject("migration.getTmReaderMaxReadno");
				
				dbparam = new HashMap();
				dbparam.put("MAXREADNO",maxReadno);
				
				dbparam.put("BIRTHD", birthd    );
				dbparam.put("RDATE", rdate     );
				dbparam.put("JIKUK", JIKUK     );
				dbparam.put("READNO", READNO    );
				dbparam.put("USERNAME", USERNAME  );
				
				if ( StringUtils.isNotEmpty(PHONE)) {
					String[] hometelArr = PHONE.split("-");
					if ( hometelArr != null && hometelArr.length > 0 ) {
						if ( hometelArr.length >= 1)		dbparam.put("HOMETEL1", hometelArr[0]  );
						if ( hometelArr.length >= 2)		dbparam.put("HOMETEL2", hometelArr[1]  );
						if ( hometelArr.length >= 3)		dbparam.put("HOMETEL3", hometelArr[2]  );
					}
				}
				if ( StringUtils.isNotEmpty(HANDY)) {
					String[] mobileArr = HANDY.split("-");
					if ( mobileArr != null && mobileArr.length > 0 ) {
						if ( mobileArr.length >= 1)		dbparam.put("MOBILE1", mobileArr[0]  );
						if ( mobileArr.length >= 2)		dbparam.put("MOBILE2", mobileArr[1]  );
						if ( mobileArr.length >= 3)		dbparam.put("MOBILE3", mobileArr[2]  );
					}
				}
				dbparam.put("ZIP1", ZIP1      );
				dbparam.put("ZIP2", ZIP2      );
				dbparam.put("ZIP", ZIP1+ZIP2      );
				dbparam.put("ADDR1", (StringUtils.isNotEmpty(ADDR1) && ADDR1.length() > 100) ? ADDR1.substring(0, 100) : ADDR1     );
				dbparam.put("ADDR2", (StringUtils.isNotEmpty(ADDR2) && ADDR2.length() > 100) ? ADDR2.substring(0, 100) : ADDR2     );
				dbparam.put("BANK_MONEY", BANK_MONEY);
				dbparam.put("BUSU", BUSU      );
				if ( StringUtils.isNotEmpty(SDATESTR) && SDATESTR.length() >= 6) {
					dbparam.put("SDATESTR6", SDATESTR.substring(0, 6)     );
				}
				if ( StringUtils.isNotEmpty(SDATESTR) && SDATESTR.length() >= 8) {
					dbparam.put("SDATESTR8", SDATESTR     );
				}

				dbparam.put("JUMINNUM", juminnum     );
				dbparam.put("SAUPJA", saupja     );
				dbparam.put("BIRTHDSTR", BIRTHDSTR     );
				
				//-- 통합독자 테이블에 신규로 등록
				generalDAO.insert("migration.insertTmReader", dbparam);
				//system.out.println("migration.insertTmReader");
				//system.out.println("dbparam == " + dbparam.toString());

				//-- 구독정보 테이블에 신규로 등록
				generalDAO.insert("migration.insertTmReaderNews_haksaeng", dbparam);
				//system.out.println("migration.insertTmReaderNews_haksaeng");
				//system.out.println("dbparam == " + dbparam.toString());
				
				dbparam = new HashMap();
				dbparam.put("READNO", maxReadno );
				dbparam.put("NUMID", numid );
				
				//-- 자동이체독자정보(학생본사) 테이블에 readno를 넣어준다
				generalDAO.update("migration.updateTblUsersStu", dbparam);
				//system.out.println("migration.updateTblUsersStu");
				//system.out.println("dbparam == " + dbparam.toString());
			}
		}
		
		System.out.println("==================step3 i = " + i);

		
		// mav
		ModelAndView mav = new ModelAndView();
		mav.setViewName("admin/main");
		
		return mav;
	}
}
