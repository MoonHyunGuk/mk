<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.util.*" %>
<%@ page import="com.mkreader.util.StringUtil" %>
<%@page import="com.mkreader.util.DateUtil"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<body>
	<table border="1">
		<tr>
			<td style="text-align: center; font-weight: bold; background-color: #eeeeee">SEQ</td>
			<td style="text-align: center; font-weight: bold; background-color: #eeeeee">회사명</td>
			<td style="text-align: center; font-weight: bold; background-color: #eeeeee">회사그룹명</td>
			<td style="text-align: center; font-weight: bold; background-color: #eeeeee">회사코드</td>
			<td style="text-align: center; font-weight: bold; background-color: #eeeeee">독자명</td>
			<td style="text-align: center; font-weight: bold; background-color: #eeeeee">우편번호</td>
			<td style="text-align: center; font-weight: bold; background-color: #eeeeee">주소</td>
			<td style="text-align: center; font-weight: bold; background-color: #eeeeee">집전화</td>
			<td style="text-align: center; font-weight: bold; background-color: #eeeeee">핸드폰</td>
			<td style="text-align: center; font-weight: bold; background-color: #eeeeee">지국코드</td>
			<td style="text-align: center; font-weight: bold; background-color: #eeeeee">지국명</td>
			<td style="text-align: center; font-weight: bold; background-color: #eeeeee">가격</td>
			<td style="text-align: center; font-weight: bold; background-color: #eeeeee">부수</td>
			<td style="text-align: center; font-weight: bold; background-color: #eeeeee">독자코드</td>
			<td style="text-align: center; font-weight: bold; background-color: #eeeeee">사용여부</td>
			<td style="text-align: center; font-weight: bold; background-color: #eeeeee">확장일</td>
			<td style="text-align: center; font-weight: bold; background-color: #eeeeee">비고</td>
			<td style="text-align: center; font-weight: bold; background-color: #eeeeee">구독일련번호</td>
			<td style="text-align: center; font-weight: bold; background-color: #eeeeee">구독년월</td>
			<td style="text-align: center; font-weight: bold; background-color: #eeeeee">수금방법</td>
			<td style="text-align: center; font-weight: bold; background-color: #eeeeee">청구금액</td>
			<td style="text-align: center; font-weight: bold; background-color: #eeeeee">청구부수</td>
		</tr>
		<c:forEach items="${educationList }" var="list">
			<tr>
				<td>${list.SEQ }</td>
				<td>${list.COMPANYNM }</td>
				<td>${list.COMPANY_TEMP }</td>
				<td>${list.COMPANYCD }</td>
				<td>${list.READNM }</td>
				<td>${list.DLVZIP }</td>
				<td>${list.ADDRESS }</td>
				<td>${list.HOMETEL }</td>
				<td>${list.MOBILE }</td>
				<td>${list.BOSEQ }</td>
				<td>${list.AGENTNM }</td>
				<td>${list.UPRICE }</td>
				<td>${list.QTY }</td>
				<td>${list.READNO }</td>
				<td>${list.DELYN }</td>
				<td>${list.HJDT }</td>
				<td>${list.REMK }</td>
				<td>${list.SEQ_1 }</td>
				<td>${list.YYMM }</td>
				<td>${list.SGBBCD }</td>
				<td>${list.BILLAMT }</td>
				<td>${list.BILLQTY }</td>
			</tr>
		</c:forEach>
	</table>
</body>
</html>