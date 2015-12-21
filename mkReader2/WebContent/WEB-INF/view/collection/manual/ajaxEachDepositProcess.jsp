<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
{
"MSG":"${MSG}",
"ITEMS":
[
<c:forEach items="${successList}" var="list" varStatus="status">

{"READNO":"${list.READNO}","READNM":"${list.READNM}","DLVADRS1":"${list.DLVADRS1}","DLVADRS2":"${list.DLVADRS2}",
"NEWSNM":"${list.NEWSNM}","YYMM":"${list.YYMM}","AMT":"${list.AMT}","SGBBNM":"${list.SGBBNM}","SEQ":"${list.SEQ}"
}
	<c:if test="${not status.last}">
	,
	</c:if>
</c:forEach>
]
}