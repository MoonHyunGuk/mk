<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.util.*" %>
<%@ page import="com.mkreader.util.StringUtil" %>
<%@page import="com.mkreader.util.DateUtil"%>
<head>
<title>독자현황리스트</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style>
	.txt { mso-number-format:'\@' }
</style>
<c:set var="totQty" value="0" />
<table cellpadding="3" cellspacing="1" border="1" width="400" bgcolor="#fff">
	<col width="200px">
	<col width="200px">
	<tr>
		<th>금액(원)</th>
		<th>부수(부)</th>
	</tr>
	<c:choose>
		<c:when test="${fn:length(readerListByUprice) > 0}">
			<c:forEach items="${readerListByUprice}" var="list"  varStatus="status" begin="0">
				<tr>
					<td><fmt:formatNumber type="number"  value="${list.UPRICE }" pattern="#,###" /></td>
					<td><fmt:formatNumber type="number"  value="${list.QTY }" pattern="#,###" /><c:set var="totQty" value="${totQty+list.QTY }"  /></td>
				</tr>
			</c:forEach>
			<tr>
				<th>합계</th>
				<th>${totQty }</th>
			</tr>
		</c:when>
		<c:otherwise>
			<tr><td colspan="2">조회된 결과가 없습니다.</td></tr>
		</c:otherwise>
	</c:choose>
</table>
		