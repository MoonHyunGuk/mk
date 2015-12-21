<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

	<p style="top-margin:10px;">
	
	<!-- 타이틀 -->
	<table cellpadding=3 cellspacing=1 border=0 width=550 bgcolor=#fff>
		<tr>
			<td colspan="10"></td>
		</tr>		
		<tr>
			<td align="center" height="20" colspan="10"><b>학생 CMS신청 처리 결과 (<c:out value="${filename}" />)</b></td>
		</tr>
	</table>
	<!--// 타이틀 -->
	
	<p style="top-margin:10px;">

	<!-- 리스트 영역 -->
	<table width="100%" cellpadding="5" cellspacing="1" border="1" bgcolor="e5e5e5" class="b_01">
		<tr bgcolor="f9f9f9" align="center" class="box_p" >
		  	<td>일련번호</td>
		  	<td>신청일</td>
		  	<td>신청구분</td>
		  	<td>지국</td>
		  	<td>지국전화번호</td>
		  	<td>납부자번호</td>
		  	<td>독자번호</td>
		  	<td>독자명</td>
		  	<td>독자전화번호</td>
			<td>불능사유</td>
		</tr>
	
		<c:choose>
		<c:when test="${empty resultList}">
			<tr bgcolor="ffffff" align="center">
				<td colspan="10" align="center">등록된 정보가 없습니다.</td>
			</tr>
		</c:when>
		<c:otherwise>
			<c:forEach items="${resultList}" var="list" varStatus="status">
                <tr bgcolor="ffffff" align="center">
                    <td><c:out value="${list.SERIALNO}" /></td>
                    <td><c:out value="${list.RDATE}" /></td>
				    <td><c:out value="${list.CMSTYPE}" /></td>
				    <td><c:out value="${list.JIKUK_NAME}" /></td>
				    <td><c:out value="${list.JIKUK_TEL}" /></td>
					<td align="left"><c:out value="${list.CODENUM}" /></td>
					<td><c:out value="${list.READNO}" /></td>
					<td><c:out value="${list.USERNAME}" /></td>
					<td>								
						<c:choose>
							<c:when test="${list.PHONE eq '--'}">
								<c:out value="${list.HANDY}" />
							</c:when>
							<c:when test="${list.HANDY eq '--'}">
								<c:out value="${list.PHONE}" />
							</c:when>									
							<c:otherwise>
								<c:out value="${list.PHONE}" /> / <c:out value="${list.HANDY}" />
							</c:otherwise>
						</c:choose>
					</td>
					<td><c:out value="${list.CMSRESULTMSG}" /></td>
				</tr>
			</c:forEach>
		</c:otherwise>
		</c:choose>
	</table>
