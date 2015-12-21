<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
[
<c:forEach items="${newsList}" var="list" varStatus="status">

{"READNO":"${list.READNO}","NEWSCD":"${list.NEWSCD}","SEQ":"${list.SEQ}","GNO":"${list.GNO}","BNO":"${list.BNO}","READNM":"${list.READNM}"
,"DLVADRS1":"${list.DLVADRS1}","DLVADRS2":"${list.DLVADRS2}","SGTYPE":"${list.SGTYPE}","UPRICE":"${list.UPRICE}","QTY":"${list.QTY}"
}
	<c:if test="${not status.last}">
	,
	</c:if>
</c:forEach>
]