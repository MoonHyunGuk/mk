<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
</head>
<body>
	<table style="border: 1px solid">
		<tr>
			<th>청구월</th>
			<th>아이디</th>
			<th>이름</th>
			<th>식별번호</th>
			<th>청구금액</th>
			<th>처리금액</th>
			<th>반송사유</th>
			<th>지국명</th>
			<th>지국코드</th>
			<th>주소</th>
			<th>연락처</th>
		</tr>
		<c:choose>
			<c:when test="${(empty cardPaymentResultList) }">
				<tr>
					<td colspan="11">데이터가 없습니다.</td>
				</tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${cardPaymentResultList }" var="list">
					<tr>
						<td>${list.BILLMON }</td>
						<td>${list.USERID }</td>
						<td>${list.USERNAME }</td>
						<td>${list.SEQNO }</td>
						<td>${list.BILLINGAMT }</td>
						<td>${list.PROCESSAMT }</td>
						<td>${list.REJECTMSG }</td>
						<td>${list.BOSEQNM }</td>
						<td>${list.BOSEQ }</td>
						<td>${list.ADDR }</td>
						<td>${list.TELNO }</td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>
</body>
</html>