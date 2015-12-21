<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.security.ISiteConstant"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:forEach var="list" items="${noticeList}" varStatus="status" begin="0" end="1">
    <tr>
	  <td style="word-break:break-all;" align="left"><img src="/images/ico/ico_new.png"  style="vertical-align: middle;"/> <span style="margin-top: 5px; font-weight: bold; vertical-align: middle;"><a href="/community/bbs/noticeView.do?seq=${list.SEQ}">${list.TITL}<br/>[${list.INDT}]</a></span></td>
	</tr>
</c:forEach>