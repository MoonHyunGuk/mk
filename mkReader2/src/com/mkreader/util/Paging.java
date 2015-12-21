package com.mkreader.util;

import java.util.HashMap;
import java.util.Map;

/**
 * 페이징 정보를 계산하는 클래스
 * 
 * @author 한영준
 * @since 2007.07.15
 * @version 1.03 (2008.07.29 보이는 page 개수 반환되게 수정)
 * @version 1.04 (2009.06.27 버그수정, 변수 추가)
 * @version 1.05 (2009.08.11 lows 값 버그 수정)
 */
public class Paging {

	public static final Integer TEN = new Integer(10);
	public static final Integer CHILD_EVENT = new Integer(4);
	public static final Integer CHILD_AFTER_EVENT = new Integer(5);
  
	public static final String CURRENT = "current";
  
	public static final String MIN = "min";
  
	public static final String MAX = "max";
  
	public static final String LAST = "last";
  
	public static final String COUNT = "count";
  
	public static final String ROWSPERPAGE = "rowsPerPage";
	
	public static final String PAGESIZE = "pageSize";
	
	public static final String LOWS = "lows";
	
	/**
	 * 페이징 정보 계산 (일반적인 게시판 형태)
	 * 
	 * @param pageNo		현재 페이지 번호
	 * @param count			전체 게시물 수
	 * @return Map			페이징 정보를 계산한 결과 java.util.Map
	 */
	public static Map getPageMap(int pageNo, int count) {

		Map pageMap = new HashMap();

		int min = 0;
		int max = 0;
		int last = 0;
		int lows = 0;
		
		if (count == 0) {
			last = 1;
		}
		else if (count > 0 && (count % 10) == 0) {
			last = count / 10;
		}
		else {
			last = count / 10 + 1;
		}

		if ((pageNo % 10) == 0) {
			min = pageNo - 9;
			max = pageNo;
		}
		else {
			min = ((pageNo / 10) * 10) + 1;
			max = ((pageNo / 10) + 1) * 10;
			
			if (max > last) {
				max = last;
			}
		}
		
		if (count > 0) {
			if (pageNo == last) {
				lows = (count % 10) == 0 ? 10 : (count % 10);
			}
			else {
				lows = 10;
			}
		}
		
		pageMap.put(CURRENT, new Integer(pageNo));
		pageMap.put(MIN, new Integer(min));
		pageMap.put(MAX, new Integer(max));
		pageMap.put(LAST, new Integer(last));
		pageMap.put(COUNT, new Integer(count));
		pageMap.put(ROWSPERPAGE, TEN);
		pageMap.put(PAGESIZE, TEN);
		pageMap.put(LOWS, new Integer(lows));

		return pageMap;
	}
	
	/**
	 * 페이징 정보 계산 (일반적인 게시판 형태)
	 * 
	 * @param pageNo				현재 페이지 번호
	 * @param count					전체 게시물 수
	 * @param pageSize				한 페이지에 보일 게시물 수
	 * @param showPagePerDocument	한 화면에 보일 페이지 수 (아래쪽에 보이는 페이지 숫자 개수)
	 * @return Map					페이징 정보를 계산한 결과 java.util.Map
	 */
	public static Map getPageMap(int pageNo, int count, int pageSize, int showPagePerDocument) {

		Map pageMap = new HashMap();

		int min = 0;
		int max = 0;
		int last = 0;
		int lows = 0;
		
		// 한 페이지에 보여질 게시물 수만 지정하고 싶으면 기본으로 페이지 수는 10이 된다.
		if (showPagePerDocument == 0) {
			showPagePerDocument = 10;
		}

		// 전체 게시물 수가 한 페이지에 보여질 게시물 수 로 나눴을때 정확히 나눠 떨어지면
		if (count == 0) {
			last = 1;
		}
		else if (count > 0 && (count % pageSize) == 0) {
			last = count / pageSize;
		}
		else {
			last = count / pageSize + 1;
		}
		
		// ex) 5개의 페이지가 보이는 게시판에서 현재 페이지가 5의 배수일때
		if ((pageNo % showPagePerDocument) == 0) {
			min = pageNo - showPagePerDocument + 1;
			max = pageNo;
		}
		else {
			min = ((pageNo / showPagePerDocument) * showPagePerDocument) + 1;
			max = ((pageNo / showPagePerDocument) + 1) * showPagePerDocument;
			
			if (max > last) {
				max = last;
			}
		}
		
		// 현재 페이지의 실제 데이터 갯수
		if (count > 0) {
			if (pageNo == last) {
				lows = (count % pageSize) == 0 ? pageSize : (count % pageSize);
			}
			else {
				lows = pageSize;
			}
		}
		
		pageMap.put(CURRENT, new Integer(pageNo));
		pageMap.put(MIN, new Integer(min));
		pageMap.put(MAX, new Integer(max));
		pageMap.put(LAST, new Integer(last));
		pageMap.put(COUNT, new Integer(count));
		pageMap.put(ROWSPERPAGE, new Integer(pageSize));
		pageMap.put(PAGESIZE, new Integer(showPagePerDocument));
		pageMap.put(LOWS, new Integer(lows));

		return pageMap;
	}
}