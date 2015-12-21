<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.util.*" %>
<head>
<title>발송연락처리스트</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style>
	.txt { mso-number-format:'\@' }
</style>
<table cellpadding="3" cellspacing="1" border="1">
	<tr>
		<td>NAME</td>
		<td>SERIAL</td>
		<td>USERNAME</td>
		<td>PHONENUM</td>
		<td>USERNAME_1</td>
		<td>PHONENUM_1</td>
		<td>USERNAME_2</td>
		<td>PHONENUM_2</td>
	</tr>
	<c:forEach items="${deliveryList }" var="list">
		<tr>
			<td>${list.NAME }</td>
			<td>${list.SERIAL }</td>
			<td>${list.USERNAME }</td>
			<td>${list.PHONENUM }</td>
			<td>${list.USERNAME_1 }</td>
			<td>${list.PHONENUM_1 }</td>
			<td>${list.USERNAME_2 }</td>
			<td>${list.PHONENUM_2 }</td>
		</tr>
	</c:forEach>
</table>
