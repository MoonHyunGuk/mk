package com.mkreader.web.common;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.util.Param;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrQuery.ORDER;
import org.apache.solr.client.solrj.impl.BinaryResponseParser;
import org.apache.solr.client.solrj.impl.HttpSolrClient;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrDocument;
import org.apache.solr.common.SolrDocumentList;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.Paging;
import com.mkreader.util.StringUtil;

public class CommonController extends MultiActionController implements
ISiteConstant, ICodeConstant {
	
	private GeneralDAO generalDAO;

	public void setGeneralDAO(GeneralDAO generalDAO) {
	
			this.generalDAO = generalDAO;
	}
	
	/**
	 * 수금년월 입력 팝업 호출
	 * 
	 * @category 수금년월 입력팝업 호출
	 * @return
	 * @throws Exception
	 */

	public ModelAndView popInsertSgbgmm(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();

		mav.setViewName("common/pop_InsertSgbgmm");
		return mav;
	}

	/**
	 * 도로명주소 적용 새주소찾기
	 * 
	 * @category 새주소 팝업 호출(도로명주소)
	 * @author ycpark
	 * @return
	 * @throws Exception
	 */

	public ModelAndView popNewAddr(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView();

		mav.setViewName("common/pop_newAddr");
		return mav;
	}

	/**
	 * 새주소 검색
	 * 
	 * @param request
	 * @param response
	 * @category 새주소 검색
	 * @author ycpark
	 * @return
	 * @throws Exception
	 */	
	public ModelAndView searchNewAddr(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String solrUrl = "http://mk150.mk.co.kr:8983/solr/zipcode";
		HttpSolrClient client = new HttpSolrClient(solrUrl);
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);

		try{

			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 10;
			int totalCount = 0;
			client.setParser(new BinaryResponseParser());
			

			String searchType = param.getString("searchType", "1");
			String searchValue = StringUtil.notNull(param.getString("searchValue"+searchType));

			// searchType{1:도로명주소, 2:건물명, 3:지번주소}
			String searchField = null;
			if(searchType.equals("1")){
				searchField = "road_text";
			}else if(searchType.equals("2")){
				searchField = "road_text";
			}else{
				searchField = "beopjeong_text";
			}
			List<HashMap<String,String>> newAddrList = new ArrayList<HashMap<String,String>>();
			
			SolrQuery query = new SolrQuery();
			
			query.set("q",searchField+":\""+searchValue+"\"");
			query.addSort("boseqnm",ORDER.asc);
			query.addSort("beopjeong_text",ORDER.asc);
			query.addSort("bonbeon",ORDER.asc);

			QueryResponse queryRes = client.query(query);
			SolrDocumentList docs = queryRes.getResults();
			totalCount = (int)docs.getNumFound();
			
			query.setStart((pageNo-1)*pageSize);
			query.setRows(pageSize);
			queryRes = client.query(query);
			docs = queryRes.getResults();
			ListIterator<SolrDocument> enu = docs.listIterator();
			SolrDocument doc = null;
			JSONObject json = null;
			String temp[]= null;
			while(enu.hasNext()){
				doc = enu.next();
				json = JSONObject.fromObject(doc);
				newAddrList.add((HashMap<String,String>)JSONObject.toBean(json,HashMap.class));
				for(HashMap<String,String> tempAddr:newAddrList){
					temp = StringUtils.split(tempAddr.get("road_text"));
					
					tempAddr.put("beopjeong_text",tempAddr.get("beopjeong_text").replaceAll(temp[0],""));
					tempAddr.put("beopjeong_text",tempAddr.get("beopjeong_text").replaceAll(temp[1],""));
					if(!tempAddr.get("beopjeongdong_code").substring(8,10).equals("00"))
						tempAddr.put("beopjeong_text",tempAddr.get("beopjeong_text").replaceAll(temp[2],""));
					tempAddr.put("beopjeong_text",tempAddr.get("beopjeong_text").trim());
				}
			}

			mav.addObject("totalCount", totalCount);
			mav.addObject("searchValue", searchValue);
			mav.addObject("searchType", searchType);
			mav.addObject("param", param);
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, pageSize));
			mav.addObject("newAddrList" , newAddrList);
			mav.setViewName("common/pop_newAddr");
		}catch (Exception e) {
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
		}finally{
			try {
				client.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		return mav;
	}

	/**
	 * 숫자체크
	 * 
	 * @category 숫자인지 여부 체크
	 * @return boolean
	 * @author ycpark
	 * @throws Exception
	 */
	public boolean checkNumeric(String value) throws Exception {
		if(StringUtils.isNumeric(value)){
			return true;
		}else{
			return false;
		}

	}
	
	/**
	 * 한글체크
	 * @param text
	 * @return
	 */
	public boolean isHangul(String text) {
		int text_count = text.length();
		
		final int HANGUL_UNICODE_START = 0xAC00;
		final int HANGUL_UNICODE_END = 0xD7AF;
 
		int is_hangul_count = 0;
		boolean chkHangulYn = false;
 
		for (int i = 0; i < text_count; i++) {
			char syllable = text.charAt(i);
 
			if ((HANGUL_UNICODE_START <= syllable) && (syllable <= HANGUL_UNICODE_END)) {
				chkHangulYn = true;
				break;
			}
		}
		return chkHangulYn;
	}
	
}
