<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
[
<c:forEach items="${hjPsNmList}" var="item" varStatus="status">

{"HJPSREGCD":"${item.HJPSREGCD}","HJPSNM":"${item.HJPSNM}"}
	<c:if test="${not status.last}">
	,
	</c:if>
</c:forEach>
]