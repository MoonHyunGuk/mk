<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet">
</head>
<body>
<div class="box_Popup">
	<!-- title -->
	<div class="pop_title_box">학생자동이체독자 CMS내역</div>
	<!-- //title -->
	<div style="padding-top: 5px">
		<div class="box_gray" style="font-weight: bold; padding: 10px 0; width: 660px;">${userName }님의 cms 기록</div>
			<form id="addrForm" name="addrForm" action="" method="post">
				<div style="padding: 5px 0;">
				<table class="tb_search" style="width: 660px;">
					<col width="170px">
					<col width="160px">
					<col width="170px">
					<col width="160px">
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
				<table class="tb_list_a_5" style="width: 660px;">
					<col width="100px">
					<col width="100px">
					<col width="150px">
					<col width="310px">
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
	 			<div style="padding-top:10px;">
				<c:if test="${not empty refundHist }">
					<table class="tb_list_a_5" style="width: 660px;">
						<col width="100px">
						<col width="100px">
						<col width="150px">
						<col width="310px">
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
				</c:if>
				</div>
				<div style="width: 660px; padding-top: 5px; text-align: right; margin: 0 auto;"><a href="#fakeUrl" onclick="self.close(); return false;"><img src="/images/bt_close.gif" border="0" alt="닫기" /></a></div>
		</form>
	</div>
</div>
</body>
</html>
