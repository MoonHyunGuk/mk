<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
	function goforms() {
		var f = document.forms1;
		
		if ( !f.cmsfile.value ) {
			alert("파일을 첨부해 주시기 바랍니다.");
			f.cmsfile.focus();
			return;
		}
		f.submit();
		jQuery("#prcssDiv").show();
	}

	// 페이지 이동
	function moveTo(type, pageNo) {
		
		var frm = document.searchForm;

		frm.pageNo.value = pageNo;
		frm.action = "/billing/zadmin/cmsrequest/index.do";
		frm.submit();
	}
</script>
<div><span class="subTitle">신청결과(일반)</span></div>
<form name="forms1" method="post" action="input_db.do" onsubmit="return goforms();" enctype="multipart/form-data">
<!-- search conditions -->
<table class="tb_search" style="width: 1020px">
	<colgroup>
		<col width="200px">
		<col width="820px">
	</colgroup>
	<tr>
		<th>CMS file</th>
		<td>
			<input type="file" name="cmsfile" style="width:400px; vertical-align: middle;">&nbsp; &nbsp; &nbsp; &nbsp; 
		 	<a href="#fakeUrl" onclick="goforms();"><img src="/images/bt_eepl.gif" style="vertical-align: middle; border: 0;" alt="입력"></a> &nbsp; 
		 	<!-- <a href="#"><img src="/images/bt_cancle.gif" border="0" align="absmiddle"></a> -->
		</td>
	</tr>
</table>
<!-- search conditions -->
</form>	    
<!-- list -->
<div style="width: 1020px; margin: 0 auto; padding-top: 15px;">
	<table class="tb_list_a_5" style="width: 1020px">
		<colgroup>
			<col width="170px">
			<col width="120px">
			<col width="220px">
			<col width="170px">
			<col width="190px">
			<col width="150px">
		</colgroup>
		<tr>
		    <th>일련번호</th>
			<th>구분</th>
			<th>CMS DATE</th>
			<th>파일명</th>
			<th>입력일</th>
			<th>처리자</th>
		</tr>
		<c:choose>
			<c:when test="${empty resultList}">		<!-- 상품카운트가 없으면 상품갯수가 0개인것임. -->
				<tr><td colspan="7">등록된 정보가 없습니다.</td></tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${resultList}" var="list" varStatus="status">
					<tr class="mover_color">
						<td><a href="view.do?numid=${list.NUMID}&filename=${list.FILENAME}&cmsdate=${list.CMSDATE}&pageNo=${pageNo}"><c:out value="${list.NUMID}" /></a></td>
						<td><c:out value="${list.RTYPE}" /></td>
						<td><c:out value="${list.CMSDATE}" /></td>
						<td><a href="view.do?numid=${list.NUMID}&filename=${list.FILENAME}&cmsdate=${list.CMSDATE}&pageNo=${pageNo}"><c:out value="${list.FILENAME}" /></a></td>
						<td><c:out value="${list.INDATE}" /></td>
						<td><c:out value="${list.CHK_ID}" /></td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>
	<!-- 서치 넘버-->					
	<%@ include file="/common/paging.jsp"  %>
	<!-- 서치 넘버 끝-->
	<div style="width: 1020px; text-align: center; font-weight: bold;">총 <font class="b03">${t_count}개</font>의 결과가 검색 되었습니다.</div>
</div>				
<!-- //list -->				
<form name="searchForm" action="index.do" method="get">
	<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />
</form>
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
				
