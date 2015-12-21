<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.security.ICodeConstant" %>
<%@ page import="com.mkreader.security.ISiteConstant" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
	function onlyNumber()
	{
		if(
			(event.keyCode < 48 || event.keyCode > 57) 
				&& (event.keyCode < 96 || event.keyCode > 105) 
				&& event.keyCode != 8
		) {
			event.returnValue=false;
		}
	}

	function goforms() {

		var f = document.forms1;

		if ( !f.rdate.value ) {
			alert("고지생성일을 입력해주시기 바랍니다.");
			f.rdate.focus();
			return ;
		}
		else if ( f.rdate.value.length != 6) {
			alert("고지생성일은 6자리(YYMMDD)로 입력해주시기 바랍니다.");
			f.rdate.focus();
			return ;
		}
		
	 	con=confirm(f.rdate.value + "일자로 고지자료를 생성하시겠습니까?");
	    if(con==false){
	        return;
		}else{
			f.submit();
		}	
	    jQuery("#prcssDiv").show();
	}

	// 페이지 이동
	function moveTo(type, pageNo) {
		
		var frm = document.searchForm;

		frm.pageNo.value = pageNo;
		frm.action = "/collection/ediElect/gr65List.do";
		frm.submit();
		jQuery("#prcssDiv").show();
	}
</script>
<!-- title -->
<div><span class="subTitle">전자수납 관리</span></div>
<!-- //title -->
<form name="searchForm" action="gr65List.do" method="get">
	<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />
</form>
<form name="forms1" method="post" action="process65.do" onsubmit="return goforms();"> 
	<!-- search conditions --> 
<table class="tb_search" style="width: 1020px">
	<colgroup>
		<col width="120px">
		<col width="300px">
		<col width="120px">
		<col width="480px">
	</colgroup>
	<tr>
		<th>고지 생성일</th>
		<td><input type="text" maxlength="6" name="rdate" style="width: 100px" onkeydown="return onlyNumber();"> 예) 120310 &lt;- 2012년 3월 10일</td>
		<th>대상지국</th>
		<td>
			<select name="jcode" id="jcode" style="width: 120px; vertical-align: middle;">
				<option value="">전체</option>
				<c:forEach items="${agencyList}" var="list" varStatus="status">
				<option value="${list.SERIAL}" <c:if test="${jcode eq list.SERIAL}">selected</c:if>><c:out value="${list.SERIAL}" />(<c:out value="${list.NAME}" />)</option>
				</c:forEach>
			</select>
			&nbsp; &nbsp; 
			<a href="#fakeUrl" onclick="goforms();"><img src="/images/bt_eepl.gif" style="vertical-align: middle; border: 0" alt="입력"></a> &nbsp; 
		</td>
	</tr>			 			 						 						 						 								 						 		
</table>
<!-- //search conditions -->
</form>
<!-- list -->			
<div style="width: 1020px; margin: 0 auto; padding-top: 15px;">
	<table class="tb_list_a_5" style="width: 1020px">
		<colgroup>
			<col width="160px">
			<col width="200px">
			<col width="200px">
			<col width="130px">
			<col width="200px">
			<col width="130px">
		</colgroup>
		<tr>
			<th>일련번호</th>
			<th>파일 생성일</th>
			<th>생성 파일명</th>
			<th>건수</th>
			<th>금액</th>
			<th>처리자</th>
		</tr>
		<c:choose>
			<c:when test="${empty resultList}">
				<tr><td colspan="6">등록된 정보가 없습니다.</td></tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${resultList}" var="list" varStatus="status">
				<tr class="mover_color">
					<td><a href="view65.do?numid=${list.NUMID}&fname=${list.FILENAME}&yyyy=${fn:substring(list.INDT,0,4)}"><c:out value="${list.NUMID}" /></a></td>
					<td><c:out value="${list.INDT}" /></td>
					<td>
						<a href="<%= ISiteConstant.PATH_UPLOAD_ABSOLUTE_EDI_GR65%>/${fn:substring(list.INDT,0,4)}/${list.FILENAME}"><c:out value="${list.FILENAME}" /></a>
					</td>
					<td>
						<c:choose>
							<c:when test="${not empty list.COUNTS}"><fmt:formatNumber value="${fn:trim(list.COUNTS)}" type="number" /></c:when>
							<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
					<td>
						<c:choose>
							<c:when test="${not empty list.MONEY}"><fmt:formatNumber value="${fn:trim(list.MONEY)}" type="number" /></c:when>
							<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
					<td><c:out value="${list.ADMINID}" /></td>
				</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>
	<!-- 서치 넘버-->					
	<%@ include file="/common/paging.jsp"  %>
	<!-- 서치 넘버 끝-->
	<div style="width: 1020px; text-align: center;">총 <font class="b03">${t_count}개</font>의 결과가 검색 되었습니다.</div>		
</div>
<!-- processing viewer -->
<div id="prcssDiv"  class="loingProcessDiv"><div><img src="/images/process4.gif"/></div></div>
<script type="text/javascript">
/** Jquery setting */
jQuery.noConflict();
jQuery(document).ready(function($) {
	$("#prcssDiv").hide();
});
</script>
<!-- //processing viewer --> 