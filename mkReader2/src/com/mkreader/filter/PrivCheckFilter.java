package com.mkreader.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;

import com.mkreader.security.ISiteConstant;

/**
 * 
 * 관리자 인증을 위해 URI 패턴을 체크하여
 * 해당 권한을 가진 사용자만 접근하도록 처리한다.
 * <pre>
 * Web.xml에서 다음과 같이 셋팅하여 처리
 * 
 	&lt;filter&gt;
		&lt;filter-name&gt;privCheck&lt;/filter-name&gt;
		&lt;filter-class&gt;
			com.miraeasset.fund.filter.PrivCheckFilter
		&lt;/filter-class&gt;
	&lt;/filter&gt;
	&lt;filter-mapping&gt;
		&lt;filter-name&gt;privCheck&lt;/filter-name&gt;
		&lt;url-pattern&gt;*.do&lt;/url-pattern&gt;
	&lt;/filter-mapping&gt;
	
 * </pre>
 * 
 */
public class PrivCheckFilter implements Filter, ISiteConstant {

	protected FilterConfig filterConfig = null;

	/**
	 * initialization method
	 */
	public void init(FilterConfig filterConfig) throws ServletException {
		// this.filterConfig = filterConfig;
		// filterConfig.getInitParameter("encoding");
	}

	/**
	 * Check URI. If it is valid then return true. Else return false. 
	 * 
	 * @param request
	 * @return boolean
	 */
	private boolean isValidToAuthenticate(HttpServletRequest request) {

		String uri = request.getRequestURI().toLowerCase();
		
		return (
				//(request.getRequestURI().toLowerCase().indexOf("admin") > -1 ) &&
				
				!request.getRequestURI().equalsIgnoreCase(URI_LOGIN) &&
				!request.getRequestURI().equalsIgnoreCase(URI_LOGIN_PROCESS) &&
				!request.getRequestURI().equalsIgnoreCase(URI_LOGOUT) &&
				(uri.indexOf("/reader/subscriptionform/") <= -1) &&
				(uri.indexOf("/mobile/jidae/") <= -1) &&
				(uri.indexOf("/mobile/") <= -1) &&
				(uri.indexOf("/zipcode/") <= -1) && 
				(uri.indexOf("pop") <= -1) );
	}

	
	/**
	 * Filtering URI
	 * 
	 */
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		
		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpSession session = httpRequest.getSession(false);

		boolean isAuthenticate = false;
		// 관리자 페이지 인증
		
		String amdinSessionId = "";
		String agencySessionId = "";
		String amdinSessionPriv = "";

		if (isValidToAuthenticate(httpRequest) && session != null) {
			
			amdinSessionId = (String) session.getAttribute(SESSION_NAME_ADMIN_USERID);
			agencySessionId = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
			amdinSessionPriv = (String) session.getAttribute(SESSION_NAME_MENU_AUTH);
			
			if ( StringUtils.isNotEmpty(amdinSessionId) || StringUtils.isNotEmpty(agencySessionId) ) {

				if ( checkMenuPriv(httpRequest, amdinSessionPriv) ) {
					isAuthenticate = true;
				}
			}
		}
		

		//isAuthenticate = true;
		if (isAuthenticate || !isValidToAuthenticate(httpRequest)) {
			chain.doFilter(request, response);
		} else {
			String url = URI_LOGIN;
			
			if ( StringUtils.isNotEmpty(amdinSessionId) || StringUtils.isNotEmpty(agencySessionId) ) {
				url += "?message=autherror";
			}
			HttpServletResponse httpResponse = (HttpServletResponse)response;
			httpResponse.sendRedirect(url);
		}
	}
	
	
	/**
	 * Analysis URI. After get menu id from that. 
	 * 
	 * @param request
	 * @return
	 */
	private boolean checkMenuPriv(HttpServletRequest request, String privCode) {

		boolean priv = false;
		
		if ( StringUtils.isNotEmpty(privCode) ) {
			String uri = request.getRequestURI().toLowerCase();
			
			if ( urlMatch_common(request, uri) ) {				// 모든 권한으로 이용할 수 있는 공통 메뉴이면
				priv = true;
			} 
			
			if ( !priv && urlMatch_admin(request, uri) ) {				// 관리자 권한으로 이용할 수 있는 메뉴이면
				if ( privCode.equals(AUTH_CODE_ADMIN) ) {
					priv = true;
				}
			} 
			
			if ( !priv && urlMatch_agency(request, uri) ) {				// 지국 권한으로 이용할 수 있는 메뉴이면
				if ( privCode.equals(AUTH_CODE_AGENCY) ) {
					priv = true;
				}
			}
		}

		return priv;
	}
	
	// URI 사용권한 - 전체
	private boolean urlMatch_common(HttpServletRequest request, String uri) {
		
		boolean urlMatch = false;
		
		if (uri.indexOf("admin/main.do") > -1) {							// 메인 - 본사 관리자
			urlMatch = true;
		}
		else if (uri.indexOf("agency/main.do") > -1) {						// 메인 - 지국 사용자
			urlMatch = true;
		}
		else if (uri.indexOf("billing/zadmin/cmsrequest/main.do") > -1) {	// 메인 - 자동이체
			urlMatch = true;
		}
		else if (uri.indexOf("reader/readermanage/") > -1) { 	// 메인 - 독자
			urlMatch = true;
		}
		else if (uri.indexOf("reader/minwon/") > -1) { 	// 메인 - 독자
			urlMatch = true;
		}
		else if (uri.indexOf("collection/collection/") > -1) { 	// 메인 - 독자
			urlMatch = true;
		}
		else if (uri.indexOf("collection/edi/") > -1) {				// 수금입력 - EDI관리
			urlMatch = true;
		}
		else if (uri.indexOf("reader/delivery/") > -1) { 	// 배달명단
			urlMatch = true;
		}
		else if (uri.indexOf("reader/readerwonjang/") > -1) { 	// 독자원장
			urlMatch = true;
		}
		else if (uri.indexOf("statistics/stats/") > -1) { 	// 통계
			urlMatch = true;
		}
		else if (uri.indexOf("reader/subscriptionform/") > -1) { 	// mk.co.kr에서 들어오는 신청
			urlMatch = true;
		}
		else if (uri.indexOf("community/bbs/") > -1) { 	// 커뮤니티 게시판
			urlMatch = true;
		}
		else if (uri.indexOf("reader/education/") > -1) { 	// 교육용 독자
			urlMatch = true;
		}
		else if (uri.indexOf("reader/alienation/") > -1) { 	// 소외계층 독자
			urlMatch = true;
		}
		else if (uri.indexOf("print/print/") > -1) { 			// 현황조회
			urlMatch = true;
		}
		else if (uri.indexOf("reader/card/") > -1) { 		// 카드 독자 (2012.12.27 박윤철)
			urlMatch = true;
		}
		//임시
		else if (uri.indexOf("migration/") > -1) { 	// 마이그레이션
			urlMatch = true;
		}
		else if (uri.indexOf("test/") > -1) { 	// 테스트
			urlMatch = true;
		}
		else if(uri.indexOf("common/ajax/") > -1) { //지국 ajax리스트
			urlMatch = true;
		}
		else if (uri.indexOf("common/") > -1) { 	// 공통
			urlMatch = true;
		}
		else if (uri.indexOf("util/memo/") > -1) { 	// 메모
			urlMatch = true;
		}
		else if (uri.indexOf("admin/ajaxresultbill.do") > -1) {		// 메인
			urlMatch = true;
		}
		else if (uri.indexOf("admin/ajaxresultbillstu.do") > -1) {				// 메인
			urlMatch = true;
		}
		else if (uri.indexOf("admin/ajaxgiroediinfo.do") > -1) {				// 메인
			urlMatch = true;
		}
		else if (uri.indexOf("mobile/") > -1) {				// 메인
			urlMatch = true;
		}
		else if(uri.indexOf("reader/readermove/") > -1){	//독자이전
			urlMatch = true;
		}
		return urlMatch;
	}
	
	// URI 사용권한 - 본사
	private boolean urlMatch_admin(HttpServletRequest request, String uri) {

		boolean urlMatch = false;

		if (uri.indexOf("billing/zadmin/cmsrequest/") > -1) {		// 자동이체 - 일반
			urlMatch = true;
		} 
		else if (uri.indexOf("billing/zadmin/cmsget/") > -1) {		// 자동이체 - 일반
			urlMatch = true;
		}
		else if (uri.indexOf("billing/zadmin/refund/") > -1) {		// 자동이체 학생
			urlMatch = true;
		}
		else if (uri.indexOf("billing/zadmin/cmsbank/") > -1) {		// 자동이체 - 일반
			urlMatch = true;
		}
		else if (uri.indexOf("billing/student/cmsrequest/") > -1) {	// 자동이체 - 학생
			urlMatch = true;
		} 
		else if (uri.indexOf("billing/student/cmsget/") > -1) {		// 자동이체 - 학생
			urlMatch = true;
		}
		else if (uri.indexOf("billing/student/refund/") > -1) {		// 자동이체 학생
			urlMatch = true;
		}
		else if (uri.indexOf("billing/student/popup/") > -1) {		// 자동이체 독자상세뷰
			urlMatch = true;
		}
		else if (uri.indexOf("reader/readeraplc/") > -1) { 	// 독자 - 독자신청
			urlMatch = true;
		}
		else if (uri.indexOf("reader/bireader/") > -1) {   	// 비독자관리
			urlMatch = true;
		}
		else if (uri.indexOf("management/adminmanage/") > -1) {		// 관리 - 지국/코드관리(본사)
			urlMatch = true;
		}
		else if (uri.indexOf("collection/edielect/") > -1) {				// 수금 - 전자수납관리
			urlMatch = true;
		}
		else if (uri.indexOf("reader/billingadmin/") > -1) { 	// 독자 - 자동이체 일반
			urlMatch = true;
		}
		else if (uri.indexOf("reader/billingstuadmin/") > -1) { 	// 독자 - 자동이체 일반
			urlMatch = true;
		}
		else if (uri.indexOf("reader/employeeadmin/") > -1) { 	// 독자 - 본사 직원
			urlMatch = true;
		}
		else if (uri.indexOf("reader/empextd/") > -1) { 	// 독자 - 사원 확장
			urlMatch = true;
		}
		else if (uri.indexOf("etc/deadline/") > -1) { 	// 기타 - 월 마감
			urlMatch = true;
		}
		else if (uri.indexOf("etc/generatebno/") > -1) { 	// 기타 - 배달번호 생성(ABC)
			urlMatch = true;
		}
		else if (uri.indexOf("etc/generatesugm/") > -1) { 	// 기타 - 수금일괄 생성(ABC)
			urlMatch = true;
		}
		else if (uri.indexOf("management/code/") > -1) { 	// 관리 - 코드관리
			urlMatch = true;
		}
		else if (uri.indexOf("management/jikuk/") > -1) { 	// 관리 - 지국통폐합관리
			urlMatch = true;
		}
		else if (uri.indexOf("management/readerrestore/") > -1) { 	// 관리 - 독자복구
			urlMatch = true;
		}
		else if (uri.indexOf("management/headoffice/") > -1) { 	// 관리 - 본사사원수금처리
			urlMatch = true;
		}
		else if (uri.indexOf("print/print/") > -1) { 	// 관리 - 본사사원수금처리
			urlMatch = true;
		}
		else if (uri.indexOf("generatesugm/") > -1) { 	// 관리 - ABC용
			urlMatch = true;
		}
		else if (uri.indexOf("management/abc/") > -1) { 	// 관리 - ABC용
			urlMatch = true;
		}
		else if (uri.indexOf("management/jidae/") > -1) { 	// 관리 - 지대관리
			urlMatch = true;
		}
		else if(uri.indexOf("reader/readermove/") > -1){	//독자이전
			urlMatch = true;
		}
		return urlMatch;
	}
	
	// URI 사용권한 - 지국
	private boolean urlMatch_agency(HttpServletRequest request, String uri) {

		boolean urlMatch = false;
		
		if (uri.indexOf("management/codemanage/") > -1) {	    // 관리 - 코드관리(지국)
			urlMatch = true;
		}
		else if (uri.indexOf("management/agencymanage/") > -1) { 	// 관리 - 지국관리(지국)
			urlMatch = true;
		}
		else if (uri.indexOf("output/billoutput/") > -1) { 	// 관리 - 고지서 출력(지국)
			urlMatch = true;
		}
		else if (uri.indexOf("billing/branch/cmsbank/") > -1) { 	// 자동이체 - 지국
			urlMatch = true;
		}
		else if (uri.indexOf("billing/branch/cmsget/") > -1) { 		// 자동이체 - 지국
			urlMatch = true;
		}
		else if (uri.indexOf("billing/branch/cmsrequest/") > -1) { 		// 자동이체 - 지국
			urlMatch = true;
		}
		else if (uri.indexOf("billing/zadmin/popup/") > -1) {		// 자동이체 독자상세뷰
			urlMatch = true;
		}
		else if (uri.indexOf("collection/manual/") > -1) {				// 수금입력 - 수동입금
			urlMatch = true;
		}
		else if (uri.indexOf("collection/edibranch/") > -1) {			// 수금입력 - EDI입금
			urlMatch = true;
		}
		else if (uri.indexOf("reader/billing/") > -1) { 	// 독자 - 자동이체 일반
			urlMatch = true;
		}
		else if (uri.indexOf("reader/billingstu/") > -1) { 	// 독자 - 자동이체 학생
			urlMatch = true;
		}
		else if (uri.indexOf("etc/deliverynumsort/") > -1) { 	// 기타작업 - 배달번호 정렬
			urlMatch = true;
		}
		else if (uri.indexOf("reader/employee/") > -1) { 	// 독자 - 본사 직원
			urlMatch = true;
		}
		else if(uri.indexOf("reader/readermove/") > -1){	//독자이전
			urlMatch = true;
		}
		return urlMatch;
	}

	
	public void destroy() {
	}

}
