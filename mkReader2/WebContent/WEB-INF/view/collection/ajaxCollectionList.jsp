<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
[
<c:forEach items="${collectionList}" var="item" varStatus="status">

{"YYMM":"${item.YYMM}","SNDT":"${item.ICDT}", "CLDT":"${item.CLDT}","BILLAMT":"${item.BILLAMT}","AMT":"${item.AMT}","SGBBCD":"${item.SGBBCD}","SGBBNM":"${item.SGBBNM }"},
</c:forEach>
{"thisYear":"${thisYear}"},{"lastYear":"${lastYear}"}
]