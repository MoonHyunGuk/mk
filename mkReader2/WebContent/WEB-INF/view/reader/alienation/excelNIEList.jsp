<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.util.*" %>
<%@ page import="com.mkreader.util.StringUtil" %>
<%@page import="com.mkreader.util.DateUtil"%>
<head>
<title>NIE 독자 리스트</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style>
.txt {
	mso-number-format:'\@'
}
.tdbd {
  BORDER-RIGHT: black 1px solid;
  BORDER-TOP: black 1px solid; 
  BORDER-LEFT: black 1px solid; 
  BORDER-BOTTOM: black 1px solid;
}

</style>
	<table cellpadding=3 cellspacing=1 border=0 width=550 bgcolor=#fff>
		<tr>
			<td align="center" colspan="8"><b>NIE 독자 리스트</b></td>
		</tr>
	</table>
	<p style="top-margin:10px;">
	<table cellpadding=3 cellspacing=1 border=1 width=550 bgcolor=#fff>
		<tr class=bg_gray>
			<td><font class="b02">관리지국</font></td>
			<td><font class="b02">성명</font></td>
			<td><font class="b02">주소</font></td>
			<td><font class="b02">연락처</font></td>
			<td><font class="b02">부수</font></td>
			<td><font class="b02">금액</font></td>
			<td><font class="b02">신청일<br/>(해지일)</font></td>
			<td><font class="b02">독자번호</font></td>
			<td><font class="b02">현재상태</font></td>
		</tr>
		<c:choose>
			<c:when test="${(empty nieList) }">
				<tr>
					<td align="center" colspan="8">데이터가 없습니다.</td>
				</tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${nieList }" var="list">
					<tr>
						<td align="center">${list.JIKUKNM }</td>
						<td align="left">${list.READNM }</td>
						<td align="left">${list.ADDR }</td>
						<td align="center">${list.TEL }</td>
						<td align="center">${list.QTY }</td>
						<td align="center">${list.UPRICE }</td>
						<c:choose>
							<c:when test="${list.BNO eq '999' }">
								<td align="center">${list.INDT }<br/>(<font class="b03">${list.STDT }</font>)</td>
								<td align="center">${list.READNO }</td>
								<td align="center"><font class="b03">해지</font></td>
							</c:when>
							<c:otherwise>
								<td align="center">${list.INDT }</td>
								<td align="center">${list.READNO }</td>
								<td align="center">정상</td>
							</c:otherwise>
						</c:choose>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
		</table>
		