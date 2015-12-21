<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<script type="text/javascript">
	// 페이지 이동
	function moveTo(type, pageNo) {
		
		var frm = document.searchForm;

		frm.pageNo.value = pageNo;
		frm.action = "/billing/branch/cmsget/index.do";
		frm.submit();
	}
</script>
<div><span class="subTitle">출금신청내역(일반독자)</span></div>
<form name="searchForm" action="index.do" method="get">
<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />
<!-- list -->
<div class="box_list" style="padding-top: 0; width: 1020px; margin: 0 auto;">
	<table class="tb_list_a_5" style="width: 1020px;">
		<colgroup>
			<col width="170px">
			<col width="115px">
			<col width="220px">
			<col width="175px">
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
			<c:when test="${empty resultList}">
				<tr>
					<td colspan="6">등록된 정보가 없습니다.</td>
				</tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${resultList}" var="list" varStatus="status">
				<tr>
					<td><a href="view.do?numid=${list.NUMID}&filename=${list.FILENAME}&cmsdate=${list.OUT_DATE}"><c:out value="${list.NUMID}" /></a></td>
					<td><c:out value="${list.RTYPE}" /></td>
					<td><a href="view.do?numid=${list.NUMID}&filename=${list.FILENAME}&cmsdate=${list.OUT_DATE}"><c:out value="${list.OUT_DATE}" /></a></td>
					<td><a href="view.do?numid=${list.NUMID}&filename=${list.FILENAME}&cmsdate=${list.OUT_DATE}"><c:out value="${list.FILENAME}" /></a></td>
					<td ><c:out value="${list.INDATE}" /></td>
					<td ><c:out value="${list.CHK_ID}" /></td>
				</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
		<tr>
			<td colspan="4" style="height: 2px">&nbsp;</td>
		</tr>
	</table>
	<%@ include file="/common/paging.jsp"  %>
</div>
<!-- //list -->
</form>
