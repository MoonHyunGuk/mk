<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
{
"READTYPECD":"${newsMap.READTYPECD}",
"READTYPENM":"${newsMap.READTYPENM}",
"BNO":"${newsMap.BNO}",
"DLVADRS1":"${newsMap.DLVADRS1}",
"DLVADRS2":"${newsMap.DLVADRS2}",
"ITEMS":
[
<c:forEach items="${sugmList}" var="list" varStatus="status">

{"YYYY":"${list.YYYY}","MM":"${list.MM}","SGYYMM":"${list.SGYYMM}","SNDT":"${list.SNDT}",
"BILLAMT":"${list.BILLAMT}","AMT":"${list.AMT}","SGBBCD":"${list.SGBBCD}","CNAME":"${list.CNAME}"
}
	<c:if test="${not status.last}">
	,
	</c:if>
</c:forEach>
]
}