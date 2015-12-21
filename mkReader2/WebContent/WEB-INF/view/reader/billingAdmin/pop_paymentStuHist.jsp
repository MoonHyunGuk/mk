<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet">
</head>
<div class="box_Popup">
	<!-- title -->
	<div class="pop_title_box">학생독자 CMS내역 상세보기</div>
	<!-- //title -->
	<form id="addrForm" name="addrForm" action="" method="post">
		<!-- head -->
		<div style="padding: 10px 0;">
			<table class="tb_list_a_5" style="width: 660px; margin: 0 auto">
			<col width="220px">
			<col width="160px">
			<col width="220px">
			<col width="160px">
			<tr><th colspan="4">${userName }님의 cms 기록</th></tr>
			    <c:forEach items="${aplcPayment }" var="list">
				 	<tr>
					 	<th>cms 의뢰신청접수 일자</th>
						<td>${list.CMSDATE }</td>
						<th>결과값</th>
						<td>${list.CMSRESULTMSG }</td>
					</tr>
				</c:forEach>
				<c:forEach items="${canclePayment }" var="list">
					<c:if test="${not empty canclePayment }">
						<tr>
							<th>cms 해지 신청접수 일자</th>
							<td>${list.CMSDATE }</td>
							<th>결과값</th>
							<td>${list.CMSRESULTMSG }</td>
						</tr>
					</c:if>
					</c:forEach>
			</table>  	
		</div>
		<!-- //head -->			
		<div style="padding-bottom: 10px;">
			<table class="tb_list_a" style="width: 660px">
				<col width="100px">
				<col width="100px">
				<col width="230px">
				<col width="230px">
				<tr>
				 	<th>구독년월</th>
					<th>이체 신청일</th>
					<th>이체 신청 금액</th>
					<th>이체 신청 결과</th>
				</tr>
				<c:choose>
					<c:when test="${empty paymentHist }">
						<tr><td colspan="4">자동이체 내역이 아직 없습니다.</td></tr>
	 				</c:when>
	 				<c:otherwise>
	 					<c:forEach items="${paymentHist }" var="list">
	 						<tr>
						    	<td>${list.SUBSMONTH }</td>
								<td>${list.CMSDATE }</td>
								<td><fmt:formatNumber value="${list.CMSMONEY}" type="number" pattern="#,###.##" /></td>
								<td>${list.CMSRESULTMSG }</td>
							</tr>
	 					</c:forEach>
	 				</c:otherwise>
				</c:choose>
			</table>
			<c:if test="${not empty refundHist }">
				<div style="padding-top: 10px;">
					<table class="tb_list_a" style="width: 660px">
						<col width="130px">
						<col width="100px">
						<col width="200px">
						<col width="230px">
						<tr>
		                    <th>지국명</th>
							<th>환불일</th>
							<th>환불 금액</th>
							<th>환불 계좌</th>
		                </tr>
		                <c:forEach items="${refundHist }" var="list">
		                	<tr>
						    	<td>${list.JIKUK_NAME }</td>
								<td>${list.REFUND_DATE }</td>
								<td><fmt:formatNumber value="${list.REFUND_PRICE }" type="number" pattern="#,###.##" /></td>
								<td>${list.BANK_NAME } ${list.BANK_NUM }</td>
							</tr>
		                </c:forEach>
					</table>
				</div>
			</c:if>
		</div>
		<div style="text-align: right;">
			<a href="javascript:self.close();"><img src="/images/bt_close.gif" border="0" style="vertical-align: middle;" /></a>
		</div>
	</form>
</div>
</html>