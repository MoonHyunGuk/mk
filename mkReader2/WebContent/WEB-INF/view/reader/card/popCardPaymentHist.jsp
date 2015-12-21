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
<body>
<div class="box_Popup" style="width: 770px">
	<!-- title -->
	<div class="pop_title_box">카드청구이력</div>
	<!-- //title -->
	<form id="addrForm" name="addrForm" action="" method="post">
		<div style="padding: 10px 0;">
			<table class="tb_list_a" style="width: 770px">
				<col width="90px">
				<col width="90px">
				<col width="120px">
				<col width="120px">
				<col width="180px">
				<col width="150px">
				<tr>
				 	<th>청구월</th>
					<th>청구일</th>
					<th>청구금액</th>
					<th>입금금액</th>
					<th>반송사유</th>
					<th>청구결과</th>
				</tr>
			</table>
			<c:set var="thisYear" value="${thisYear }" />
			<div style="width: 770px; overflow-y: scroll; margin: 0 auto; overflow: hidden; height: 530px">
				<table class="tb_list_a" style="width: 753px">
					<col width="90px">
					<col width="90px">
					<col width="120px">
					<col width="120px">
					<col width="180px">
					<col width="133px">
					<c:choose>
						<c:when test="${empty paymentHist }">
							<tr><td colspan="5">카드 청구 내역이 아직 없습니다.</td></tr>
						</c:when>
						<c:otherwise>
							<c:forEach items="${paymentHist }" var="list">
								<tr <c:if test="${thisYear eq  fn:substring(list.BILLMON,0,4)}"> style="background-color: #E5FFED"</c:if>>
							    	<td <c:if test="${thisYear eq  fn:substring(list.BILLMON,0,4)}"> style="font-weight: bold;"</c:if>>
							    		${fn:substring(list.BILLMON,0,4)}년
							    		<c:choose>
							    			<c:when test="${fn:substring(list.BILLMON,4,5) eq '0'}">
							    				${fn:replace(fn:substring(list.BILLMON,4,6),0,'')}월
							    			</c:when>
							    			<c:otherwise>
							    				${fn:substring(list.BILLMON,4,6)}월
							    			</c:otherwise>
							    		</c:choose> 
							    	</td>
									<td>${fn:substring(list.ACCTDATE,0,4)}-${fn:substring(list.ACCTDATE,4,6)}-${fn:substring(list.ACCTDATE,6,8)}</td>
									<td><fmt:formatNumber value="${list.BILLINGAMT}" type="number" pattern="#,###.##" /></td>
									<td><fmt:formatNumber value="${list.PROCESSAMT}" type="number" pattern="#,###.##" /></td>
									<td>${list.REJECTMSG}</td>
									<td>
										<c:choose>
											<c:when test="${list.REJECTCODE eq '0000'}">
												<span style="color: green">정상처리</span>
											</c:when>
											<c:when test="${list.REJECTCODE ne '0000'}">
												<span style="color: red">처리불가</span>
											</c:when>
										</c:choose>
									</td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</table>
			</div>
		</div>
		<div style="text-align: right;"><a href="javascript:self.close();"><img src="/images/bt_close.gif" border="0" style="vertical-align: middle;" /></a></div>
	</form>
</div>
</body>
</html>