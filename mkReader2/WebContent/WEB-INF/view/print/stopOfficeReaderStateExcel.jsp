<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

	<!-- 타이틀 -->
	<table cellpadding=3 cellspacing=1 border=0 width=550 bgcolor=#fff>
		<tr>
			<td align="center" height="20" colspan="9"><b>본사 신청 중지 현황</b></td>
		</tr>
	</table>
	<!--// 타이틀 -->
	<p style="top-margin:10px;">
	<!-- 조회기간 -->
	<table cellpadding=3 cellspacing=1 border=0 width=550 bgcolor=#fff>
		<tr>
			<td align="center" colspan="9"><b>[</b> ${fn:substring(fromDate,0,4 ) }년 ${fn:substring(fromDate,5,7 ) }월 ${fn:substring(fromDate,8,10 ) }일  ~ ${fn:substring(toDate,0,4 ) }년 ${fn:substring(toDate,5,7 ) }월 ${fn:substring(toDate,8,10 ) }일 <b>]</b></td>
		</tr>
	</table>
	<!--// 조회기간 -->
	<p style="margin-top:10px;">
	
	<!-- 리스트 영역 -->
	<table width="100%" cellpadding="5" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
		<tr bgcolor="ffffff">
			<td bgcolor="f9f9f9" align="center" width="5%"><font class="b02">지국번호</font></td>
			<td bgcolor="f9f9f9" align="center" width="6%"><font class="b02">지국명</font></td>
			<td bgcolor="f9f9f9" align="center" width="16%"><font class="b02">독자명</font></td>
			<td bgcolor="f9f9f9" align="center" width="35%"><font class="b02">주소</font></td>
			<td bgcolor="f9f9f9" align="center" width="10%"><font class="b02">연락처</font></td>
			<td bgcolor="f9f9f9" align="center" width="8%"><font class="b02">결제방법</font></td>
			<td bgcolor="f9f9f9" align="center" width="4%"><font class="b02">부수</font></td>
			<td bgcolor="f9f9f9" align="center" width="8%"><font class="b02">신청일</font></td>
			<td bgcolor="f9f9f9" align="center" width="8%"><font class="b02">중지일</font></td>
		</tr>
		
		<!-- 리스트 생성 -->
		<c:choose>
			<c:when test="${(empty stopOfficeReaderList)}">
				<tr bgcolor="ffffff">
					<td align="center" colspan="9">
						데이터가 없습니다.
					</td>
				</tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${stopOfficeReaderList}" var="list">
					<tr bgcolor="ffffff">
						<td align="center">${list.BOSEQ}</td>
						<td align="center">${list.JIKUKNM}</td>
						<td align="center">${list.READNM}</td>
						<td align="center">${list.ADDR}</td>
						<td align="center">${list.TEL}</td>
						<c:choose>
						<c:when test="${list.HJPATHCD eq 'AUTO'}">
							<td align="center">자동이체</td>
						</c:when>
						<c:otherwise>
							<td align="center">${list.HJPATHCD}</td>
						</c:otherwise>
						</c:choose>
						<td align="center">${list.QTY}</td>
						<td align="center">${list.APLCDT}</td>
						<td align="center">${list.STDT}</td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
		<!--// 리스트 생성 -->
	</table>
	<!--// 리스트 영역 -->
