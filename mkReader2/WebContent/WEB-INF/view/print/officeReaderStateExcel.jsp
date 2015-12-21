<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

	<!-- 타이틀 -->
	<table cellpadding=3 cellspacing=1 border=0 width=550 bgcolor=#fff>
		<tr>
			<td align="center" height="20" colspan="10"><b>본사 신청 구독 통계</b></td>
		</tr>
	</table>
	<!--// 타이틀 -->
	<p style="top-margin:10px;">
	<!-- 조회기간 -->
	<table cellpadding=3 cellspacing=1 border=0 width=550 bgcolor=#fff>
		<tr>
			<td align="center" colspan="10"><b>[</b> ${fn:substring(fromDate,0,4 ) }년 ${fn:substring(fromDate,5,7 ) }월 ${fn:substring(fromDate,8,10 ) }일  ~ ${fn:substring(toDate,0,4 ) }년 ${fn:substring(toDate,5,7 ) }월 ${fn:substring(toDate,8,10 ) }일 <b>]</b></td>
		</tr>
	</table>
	<!--// 조회기간 -->
	<p style="top-margin:10px;">
	<!-- 리스트 -->
	<table width="100%" cellpadding="5" cellspacing="1" border="1" bgcolor="e5e5e5" class="b_01">
		<tr bgcolor="ffffff">
			<td bgcolor="f9f9f9" align="center" width="10%" rowspan="2"><font class="b02">지국코드</font></td>
			<td bgcolor="f9f9f9" align="center" width="10%" rowspan="2"><font class="b02">지국명</font></td>
			<td bgcolor="f9f9f9" align="center" width="20%" colspan="2"><font class="b02">일반</font></td>
			<td bgcolor="f9f9f9" align="center" width="20%" colspan="2"><font class="b02">사원확장</font></td>
			<td bgcolor="f9f9f9" align="center" width="10%" rowspan="2"><font class="b02">교육</font></td>
			<td bgcolor="f9f9f9" align="center" width="30%" colspan="3"><font class="b02">계</font></td>
		</tr>
		<tr>
			<td bgcolor="f9f9f9" align="center" width="10%"><font class="b02">신청</font></td>
			<td bgcolor="f9f9f9" align="center" width="10%"><font class="b02">중지</font></td>
			<td bgcolor="f9f9f9" align="center" width="10%"><font class="b02">신청</font></td>
			<td bgcolor="f9f9f9" align="center" width="10%"><font class="b02">중지</font></td>
			<td bgcolor="f9f9f9" align="center" width="10%"><font class="b02">신청합계</font></td>
			<td bgcolor="f9f9f9" align="center" width="10%"><font class="b02">중지합계</font></td>
			<td bgcolor="f9f9f9" align="center" width="10%"><font class="b02">합계</font></td>
		</tr>
		
		<!-- 합계용 변수 지정 -->
		<c:set var="USERCNT" value="0" />
		<c:set var="STOPUSERCNT" value="0" />
		<c:set var="APLCCNT" value="0" />
		<c:set var="STOPAPLCCNT" value="0" />
		<c:set var="EDUCNT" value="0" />
		<c:set var="TOTALAPLCCNT" value="0" />
		<c:set var="TOTALSTOPCNT" value="0" />
		<c:set var="TOTALCNT" value="0" />
		<!--// 합계용 변수 지정 -->
		
		<!-- 리스트 생성 -->
		<c:choose>
			<c:when test="${(empty officelist)}">
				<tr bgcolor="ffffff">
					<td align="center" colspan="10">
						데이터가 없습니다.
					</td>
				</tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${officelist}" var="list" varStatus="status">	
					<c:set var="USERCNT" value="${USERCNT + list.USERCNT}" />
					<c:set var="STOPUSERCNT" value="${STOPUSERCNT + list.STOPUSERCNT}" />
					<c:set var="APLCCNT" value="${APLCCNT + list.APLCCNT}" />
					<c:set var="STOPAPLCCNT" value="${STOPAPLCCNT + list.STOPAPLCCNT}" />
					<c:set var="EDUCNT" value="${EDUCNT + list.EDUCNT}" />
					<c:set var="TOTALAPLCCNT" value="${TOTALAPLCCNT + list.TOTALAPLCCNT}" />
					<c:set var="TOTALSTOPCNT" value="${TOTALSTOPCNT + list.TOTALSTOPCNT}" />
					<c:set var="TOTALCNT" value="${TOTALCNT + list.TOTALCNT}" />
				</c:forEach>
				<c:forEach items="${officelist}" var="list">
					<tr bgcolor="ffffff">
						<td align="center">${list.JIKUK}</td>
						<td align="center">${list.JIKUKNM}</td>
						<td align="center">${list.USERCNT}</td>
						<td align="center">${list.STOPUSERCNT}</td>
						<td align="center">${list.APLCCNT}</td>
						<td align="center">${list.STOPAPLCCNT}</td>
						<td align="center">${list.EDUCNT}</td>
						<td align="center">${list.TOTALAPLCCNT}</td>
						<td align="center">${list.TOTALSTOPCNT}</td>
						<td align="center">${list.TOTALCNT}</td>
					</tr>
				</c:forEach>
				<tr bgcolor="ccdbfb" align="center">
					    <td colspan="2"><strong>합 &nbsp; 계</strong></td>						
						<td align="center">
							<c:choose>	<c:when test="${not empty USERCNT}"><fmt:formatNumber value="${USERCNT}" type="number" /></c:when>	</c:choose>
						</td>
						<td align="center">
							<c:choose>	<c:when test="${not empty STOPUSERCNT}"><fmt:formatNumber value="${STOPUSERCNT}" type="number" /></c:when>	</c:choose>
						</td>
						<td align="center">
							<c:choose>	<c:when test="${not empty APLCCNT}"><fmt:formatNumber value="${APLCCNT}" type="number" /></c:when>	</c:choose>
						</td>
						<td align="center">
							<c:choose>	<c:when test="${not empty STOPAPLCCNT}"><fmt:formatNumber value="${STOPAPLCCNT}" type="number" /></c:when>	</c:choose>
						</td>
						<td align="center">
							<c:choose>	<c:when test="${not empty EDUCNT}"><fmt:formatNumber value="${EDUCNT}" type="number" /></c:when>	</c:choose>
						</td>
						<td align="center">
							<c:choose>	<c:when test="${not empty TOTALAPLCCNT}"><fmt:formatNumber value="${TOTALAPLCCNT}" type="number" /></c:when>	</c:choose>
						</td>
						<td align="center">
							<c:choose>	<c:when test="${not empty TOTALSTOPCNT}"><fmt:formatNumber value="${TOTALSTOPCNT}" type="number" /></c:when>	</c:choose>
						</td>
						<td align="center">
							<c:choose>	<c:when test="${not empty TOTALCNT}"><fmt:formatNumber value="${TOTALCNT}" type="number" /></c:when>	</c:choose>
						</td>
					</tr>
			</c:otherwise>
		</c:choose>
		<!--// 리스트 생성 -->
	</table>
	<!--// 리스트 -->