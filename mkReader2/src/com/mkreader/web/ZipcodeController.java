package com.mkreader.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map.Entry;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.reflexion.espresso.servlet.util.HttpServletParam;
import kr.reflexion.espresso.util.Param;
import net.sf.json.JSONObject;

import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrQuery.ORDER;
import org.apache.solr.client.solrj.impl.BinaryResponseParser;
import org.apache.solr.client.solrj.impl.HttpSolrClient;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrDocument;
import org.apache.solr.common.SolrDocumentList;
import org.apache.solr.common.SolrInputDocument;
import org.apache.solr.common.SolrInputField;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.mkreader.dao.GeneralDAO;
import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;
import com.mkreader.util.Paging;
import com.mkreader.util.StringUtil;

public class ZipcodeController extends MultiActionController implements ISiteConstant, ICodeConstant {
	
	private GeneralDAO generalDAO;
	
	private final String solrUrl = "http://mk150.mk.co.kr:8983/solr/zipcode";

	public void setGeneralDAO(GeneralDAO generalDAO) {
			this.generalDAO = generalDAO;
	}
	
	/**
	 * 지국/주소찾기
	 * @param request
	 * @param response
	 * @return
	 */
	public ModelAndView searchAddr(HttpServletRequest request,HttpServletResponse response){
		ModelAndView mav = new ModelAndView();
		HttpSolrClient client = new HttpSolrClient(solrUrl);
		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		
		mav.setViewName("zipcode/searchAddr");
		try {
			Param param = new HttpServletParam(request);
			int pageNo = param.getInt("pageNo", 1);
			int pageSize = 15;
			int totalCount = 0;
			
			client.setParser(new BinaryResponseParser());
			
			String keyword1 = param.getString("keyword1");
			String keyword2 = param.getString("keyword2");
			String keyword3 = param.getString("keyword3");
			
			String type = param.getString("type","1");
			
			String keyword = null;
			String searchField1 = null;
			String searchField2 = null;
			if(type.equals("1")){
				keyword = keyword1;
				searchField1 = "boseqnm";
				searchField2 = "bunkukname";
			}else if(type.equals("2")){
				keyword = keyword2;
				searchField1 = "beopjeong_text";
			}else{
				keyword = keyword3;
				searchField1 = "road_text";
			}
			keyword = StringUtil.notNull(keyword);
			if(keyword.equals(""))return mav;
			List<HashMap<String,String>> resultList = new ArrayList<HashMap<String,String>>();
			
			if(!type.equals("3")){
				dbparam.put("TYPE", type);
				dbparam.put("SEARCHKEY1", keyword1);
				dbparam.put("SEARCHKEY2", keyword2);
				resultList = generalDAO.queryForList("admin.getJikukList",dbparam);
			}

			SolrQuery query = new SolrQuery();
			if(searchField2 != null){
				query.set("q",searchField1+":\""+keyword+"\"" + " OR " + searchField2 + ":\""+keyword+"\"");
			}else{
				query.set("q",searchField1+":\""+keyword+"\"");
			}
			
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
			List<HashMap<String,String>> addressList = new ArrayList<HashMap<String,String>>();
			while(enu.hasNext()){
				doc = enu.next();
				json = JSONObject.fromObject(doc);
				addressList.add((HashMap<String,String>)JSONObject.toBean(json,HashMap.class));
			}
			
			mav.addObject("resultList",resultList);
			mav.addObject("addressList", addressList);
			mav.addObject("type",type);
			mav.addObject("keyword1",keyword1);
			mav.addObject("keyword2",keyword2);
			mav.addObject("keyword3",keyword3); 
			mav.addObject("pageInfo", Paging.getPageMap(pageNo, totalCount, pageSize, 20));
			mav.addObject("pageNo",pageNo);
		} catch (Exception e) {
			e.printStackTrace();
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
	 * 주소 지국 변경화면
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView changJikukView(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		Param param = new HttpServletParam(request);
		HashMap<String,Object> dbparam = new HashMap<String,Object>();
		
		try {
			List agencyList = generalDAO.queryForList("reader.common.agencyListByLocalCodeForSelectBox" , dbparam); //지국 리스트
			
			mav.addObject("lwDngCd",param.getString("lwDngCd"));
			mav.addObject("bdMngNo",param.getString("bdMngNo"));
			mav.addObject("boseq",param.getString("boseq"));
			mav.addObject("boseqNm",param.getString("boseqNm"));
			mav.addObject("subSeq",param.getString("subSeq"));
			mav.addObject("agencyList",agencyList);
			mav.setViewName("zipcode/changeJikuk");
		} catch (Exception e) {
			e.printStackTrace();
			mav.setViewName("common/message");
			mav.addObject("message", MSG_ERROR_MESSAGE);
			mav.addObject("returnURL", "/index.jsp");
		}
		return mav;
	}
	
	/**
	 * 주소 지국 변경화면
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView updateJikukCode(HttpServletRequest request,HttpServletResponse response) throws Exception {
		Param param = new HttpServletParam(request);
		HashMap<String,Object> dbparam = new HashMap<String,Object>();
		response.setContentType( "text/json; charset=UTF-8" );
		String lwDngCd = param.getString("lwDngCd").trim();
		String bdMngNo = param.getString("bdMngNo").trim();
		String oldBoseq = param.getString("oldBoseq").trim();
		String newBoseq = param.getString("newBoseq").trim();
		String newSubSeq = param.getString("newSubSeq").trim();
		
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("flag",false);
		try {
			dbparam.put("lwDngCd", lwDngCd);
			dbparam.put("bdMngNo", bdMngNo);
			dbparam.put("oldBoseq", oldBoseq);
			dbparam.put("newBoseq", newBoseq);
			dbparam.put("newSubSeq", newSubSeq);
			generalDAO.getSqlMapClient().update("common.updateJikukCode", dbparam);
//			deleteAddress(lwDngCd,bdMngNo);
			addAddress(lwDngCd,bdMngNo);
			jsonObject.put("flag",true);
		} catch (Exception e) {
			e.printStackTrace();
		}
		response.getWriter().println(jsonObject.toString());
		return null;
	}
	
	
	/**
	 * 지국/주소찾기
	 * @param request
	 * @param response
	 * @return
	 */
	public ModelAndView searchAddrEmptyBoseq(HttpServletRequest request,HttpServletResponse response){
		ModelAndView mav = new ModelAndView();
		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		
		
		try {
			Param param = new HttpServletParam(request);
			
			String opType = param.getString("opType");
			String opText = param.getString("opText");
			
			dbparam.put("opText", opText);
			dbparam.put("opType", opType);
			
			//지국코드 없는 주소 조회
			List withoutBoseqList = generalDAO.queryForList("admin.getNewAddrWithoutBoseq",dbparam);
			
			System.out.println("opType = "+opType);
			System.out.println("opText = "+opText);
			System.out.println("withoutBoseqList = "+withoutBoseqList);
			
			mav.addObject("withoutBoseqList", withoutBoseqList);
			mav.addObject("opType",opType);
			mav.addObject("opText",opText);
			mav.setViewName("zipcode/searchAddr");
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
		}
		return mav;
	}
	
	
	/**
	 * 검색엔진/주소추가
	 * @param request
	 * @param response
	 * @return
	 */
	public void addAddress(String lwDngCd,String bdMngNo){
		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		HttpSolrClient client = new HttpSolrClient(solrUrl);
		try {
			dbparam.put("lwDngCd",lwDngCd);
			dbparam.put("bdMngNo",bdMngNo);
			HashMap<String,String> map = (HashMap<String,String>)generalDAO.queryForObject("admin.getNewAddrById",dbparam);
			SolrInputDocument doc = getSolrInputDocument(map);
			client.setParser(new BinaryResponseParser());
			client.add(doc);
			client.commit();
			client.close();
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			try {
				client.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}
	
	/**
	 * 검색엔진/주소삭제
	 * @param request
	 * @param response
	 * @return
	 */
	public void deleteAddress(String lwDngCd,String bdMngNo){
		HashMap<String, Object> dbparam = new HashMap<String, Object>();
		HttpSolrClient client = new HttpSolrClient(solrUrl);
		try {
			dbparam.put("lwDngCd",lwDngCd);
			dbparam.put("bdMngNo",bdMngNo);

			client.setParser(new BinaryResponseParser());
			client.deleteById(lwDngCd + bdMngNo);
			client.commit();
			client.close();
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			try {
				client.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}
	
	private SolrInputDocument getSolrInputDocument(HashMap<String,String> map){
		try {
			Set<Entry<String,String>> entrySet = map.entrySet();
			Iterator<Entry<String,String>> iter = entrySet.iterator();
			SolrInputDocument doc = new SolrInputDocument();
			Entry<String, String> entry = null;
			String key = null;
			SolrInputField field = null;
			while(iter.hasNext()){
				entry = iter.next();
				key = entry.getKey().toString().toLowerCase();
				field = new SolrInputField(key);
				field.setValue(entry.getValue(), 1f);
				if(!doc.containsKey(key))
					doc.put(key,field);
			}
			return doc;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
}
