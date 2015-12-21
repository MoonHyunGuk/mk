<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ page import="com.mkreader.security.ISiteConstant" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel='stylesheet' type='text/css' href="/select2/select2.css"/>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript">
//페이징
function moveTo(where, seq) {
	var fm = document.getElementById("cardReaderListForm");
	
	fm.pageNo.value = seq;
	fm.target = "_self";
	fm.action = "/reader/card/cardReaderList.do";
	fm.submit();	
}

/**
 * 조회 버튼 클릭 이벤트
 */
function fn_search() {
	var fm = document.getElementById("payFm");
	
	fm.pageNo.value = "1";
	fm.target = "_self";
	fm.action = "/reader/card/cardPaymentList.do";
	fm.submit();
	jQuery("#prcssDiv").show();
}

function fn_excelDown() {
	var fm = document.getElementById("payFm");
	
	fm.target = "_self";
	fm.action = "/reader/card/cardPaymentByMonthToExcel.do";
	fm.submit();
	jQuery("#prcssDiv").show();
	setTimeout(function () {        // 타이머
		jQuery("#prcssDiv").hide();
     }, 90000);
}

jQuery.noConflict();
jQuery(document).ready(function($){
});
</script>
<!-- title -->
<div><span class="subTitle">카드 결제 내역리스트</span></div>
<!-- //title -->
<form id="payFm" name="payFm" method="post" >
	<input type=hidden id="pageNo" name="pageNo" value="${param.pageNo}" />
<!-- search condition -->
	<div class="box_white" style="padding: 10px 0; width: 1020px; margin: 0 auto;">
		<font class="b02">조 회 일</font>&nbsp;&nbsp; 
		<select id="fromYear" name="fromYear" style="vertical-align: middle;">
			<c:forEach begin="${billMonthInfo.FROMYEAR }" end="${billMonthInfo.TOYEAR }" step="1" var="fYear">
				<option value="${fYear }"  <c:if test="${fromYear eq fYear}">selected="selected" </c:if>>${fYear }</option>
			</c:forEach>
		</select> <font class="b02">년</font>
		<select id="fromMonth" name="fromMonth" style="vertical-align: middle;">
			<c:forEach begin="1" end="12" step="1" var="fMonth">
				<option value="${fMonth }" <c:if test="${fromMonth eq fMonth}">selected="selected" </c:if>>${fMonth }</option>
			</c:forEach>
		</select> <font class="b02">월</font> &nbsp;&nbsp;~&nbsp;&nbsp; 
		<select id="toYear" name="toYear" style="vertical-align: middle;">
			<c:forEach begin="${billMonthInfo.FROMYEAR }" end="${billMonthInfo.TOYEAR }" step="1" var="tYear">
				<option value="${tYear }"  <c:if test="${toYear eq tYear}">selected="selected" </c:if>>${tYear }</option>
			</c:forEach>
		</select> <font class="b02">년</font>
		<select id="toMonth" name="toMonth" style="vertical-align: middle;">
			<c:forEach begin="1" end="12" step="1" var="tMonth">
				<option value="${tMonth }"  <c:if test="${toMonth eq tMonth}">selected="selected" </c:if>>${tMonth }</option>
			</c:forEach>
		</select> <font class="b02">월</font> 
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
		<img src="/images/bt_search.gif" style="vertical-align: middle; border: 0; cursor: pointer;" onclick="fn_search();" alt="조회">&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; 
		<img src="/images/bt_savexel.gif" style="vertical-align: middle; border: 0; cursor: pointer;" onclick="fn_excelDown();" alt="엑셀다운">
	</div>
	<div style="padding-top: 15px;">
	<c:set var="totCnt" value="0"/>
	<c:set var="totBillAmt" value="0"/>
	<c:set var="totProcessAmt" value="0"/>
	<c:set var="okTotCnt" value="0"/>						<!-- 정상 -->
	<c:set var="okTotBillAmt" value="0"/>					<!-- 정상 -->
	<c:set var="okTotProcessAmt" value="0"/>				<!-- 정상 -->
	<c:set var="returnTotCnt" value="0"/>					<!-- 승인반송 -->
	<c:set var="returnTotBillAmt" value="0"/>				<!-- 승인반송 -->
	<c:set var="returnTotProcessAmt" value="0"/>			<!-- 승인반송 -->
	<c:set var="cancelTotCnt" value="0"/>					<!-- 승인취소 -->
	<c:set var="cancelTotBillAmt" value="0"/>				<!-- 승인취소 -->
	<c:set var="cancelTotProcessAmt" value="0"/>			<!-- 승인취소 -->
	<c:set var="buyReturnTotCnt" value="0"/>				<!-- 매입반송 -->
	<c:set var="buyReturnTotBillAmt" value="0"/>			<!-- 매입반송 -->
	<c:set var="buyReturnTotProcessAmt" value="0"/>	<!-- 매입반송 -->
	<c:set var="exceptTotCnt" value="0"/>					<!-- 청구제외 -->
	<c:set var="exceptTotBillAmt" value="0"/>				<!-- 청구제외 -->
	<c:set var="exceptTotProcessAmt" value="0"/>			<!-- 청구제외 -->
	<c:choose>
		<c:when test="${cardPayList ne null}">
			<table class="tb_list_a_5" style="width: 1020px">  
				<colgroup>
					<col width="100px">
					<col width="100px">
					<col width="320px">
					<col width="100px">
					<col width="100px">
					<col width="150px">
					<col width="150px">
				</colgroup>	
				<tr>
					<th>청구월</th>
					<th>청구일</th>
					<th>메세지</th>
					<th>상태</th>
					<th>건수</th>
					<th>청구액</th>
					<th>입금액</th>
				</tr>
				<c:choose>
					<c:when test="${fn:length(cardPayList) > 0}">
						<c:forEach items="${cardPayList}" var="list" varStatus="i">
							<c:set var="totCnt" value="${totCnt +  list.BILLINGCNT}" />
							<c:set var="totBillAmt" value="${totBillAmt +  list.BILLINGAMT}" />
							<c:set var="totProcessAmt" value="${totProcessAmt +  list.PROCESSAMT}" />
							<tr>
								<td>${list.BILLMON}</td>
								<td>${list.ACCTDATE}</td>
								<td>${list.REJECTMSG}</td>
								<td>
									<c:choose>
										<c:when test="${list.REJECTCODE eq '0000'}"><span style="color: blue">처리완료</span></c:when>
										<c:when test="${list.REJECTCODE ne '0000'}"><span style="color: red">처리불능</span></c:when>
									</c:choose>
								</td>
								<td><fmt:formatNumber value="${list.BILLINGCNT}"  type="number" /></td>
								<td><fmt:formatNumber value="${list.BILLINGAMT}"  type="number" /></td>
								<td><fmt:formatNumber value="${list.PROCESSAMT}"  type="number" /></td>
							</tr>
							<c:choose>
								<c:when test="${list.REJECTCODENM eq 'OK'}">
									<c:set var="okTotCnt" value="${okTotCnt + list.BILLINGCNT}"/>							
									<c:set var="okTotBillAmt" value="${okTotBillAmt + list.BILLINGAMT}" />				
									<c:set var="okTotProcessAmt" value="${okTotProcessAmt + list.PROCESSAMT}" />	
								</c:when>
								<c:when test="${list.REJECTCODENM eq 'EXCEPT'}">
									<c:set var="exceptTotCnt" value="${exceptTotCnt + list.BILLINGCNT}"/>							
									<c:set var="exceptTotBillAmt" value="${exceptTotBillAmt +  list.BILLINGAMT}" />				
									<c:set var="exceptTotProcessAmt" value="${exceptTotProcessAmt +  list.PROCESSAMT}" />	
								</c:when>
								<c:when test="${list.REJECTCODENM eq 'CANCEL'}">
									<c:set var="cancelTotCnt" value="${cancelTotCnt+list.BILLINGCNT}"/>							
									<c:set var="cancelTotBillAmt" value="${cancelTotBillAmt +  list.BILLINGAMT}" />				
									<c:set var="cancelTotProcessAmt" value="${cancelTotProcessAmt +  list.PROCESSAMT}" />	
								</c:when>
								<c:when test="${list.REJECTCODENM eq 'BUYRETURN'}">
									<c:set var="buyReturnTotCnt" value="${buyReturnTotCnt+list.BILLINGCNT}"/>							
									<c:set var="buyReturnTotBillAmt" value="${buyReturnTotBillAmt +  list.BILLINGAMT}" />				
									<c:set var="buyReturnTotProcessAmt" value="${buyReturnTotProcessAmt +  list.PROCESSAMT}" />	
								</c:when>
								<c:otherwise>
									<c:set var="returnTotCnt" value="${returnTotCnt+list.BILLINGCNT}"/>							
									<c:set var="returnTotBillAmt" value="${returnTotBillAmt +  list.BILLINGAMT}" />				
									<c:set var="returnTotProcessAmt" value="${returnTotProcessAmt +  list.PROCESSAMT}" />	
								</c:otherwise>
							</c:choose>
						</c:forEach>
						<tr>
							<th colspan="4"  style="padding: 8px 0; color: blue">정 상</th>
							<th style="color: blue"><fmt:formatNumber value="${okTotCnt }"  type="number" /> 개</th>
							<th style="color: blue"><fmt:formatNumber value="${okTotBillAmt }"  type="number" /> 원</th>
							<th style="color: blue"><fmt:formatNumber value="${okTotProcessAmt }"  type="number" /> 원</th>
						</tr>
						<tr>
							<th colspan="4"  style="padding: 8px 0;">승인반송</th>
							<th><fmt:formatNumber value="${returnTotCnt }"  type="number" /> 개</th>
							<th><fmt:formatNumber value="${returnTotBillAmt }"  type="number" /> 원</th>
							<th><fmt:formatNumber value="${returnTotProcessAmt }"  type="number" /> 원</th>
						</tr>
						<tr>
							<th colspan="4"  style="padding: 8px 0;">승인취소</th>
							<th><fmt:formatNumber value="${cancelTotCnt }"  type="number" /> 개</th>
							<th><fmt:formatNumber value="${cancelTotBillAmt }"  type="number" /> 원</th>
							<th><fmt:formatNumber value="${cancelTotProcessAmt }"  type="number" /> 원</th>
						</tr>
						<tr>
							<th colspan="4"  style="padding: 8px 0;">매입반송</th>
							<th><fmt:formatNumber value="${buyReturnTotCnt }"  type="number" /> 개</th>
							<th><fmt:formatNumber value="${buyReturnTotBillAmt }"  type="number" /> 원</th>
							<th><fmt:formatNumber value="${buyReturnTotProcessAmt }"  type="number" /> 원</th>
						</tr>
						<tr>
							<th colspan="4"  style="padding: 8px 0;">청구제외</th>
							<th><fmt:formatNumber value="${exceptTotCnt }"  type="number" /> 개</th>
							<th><fmt:formatNumber value="${exceptTotBillAmt }"  type="number" /> 원</th>
							<th><fmt:formatNumber value="${exceptTotProcessAmt }"  type="number" /> 원</th>
						</tr>
						<tr>
							<th colspan="4"  style="padding: 8px 0;">총 합 계</th>
							<th><fmt:formatNumber value="${totCnt }"  type="number" /> 개</th>
							<th><fmt:formatNumber value="${totBillAmt }"  type="number" /> 원</th>
							<th><fmt:formatNumber value="${totProcessAmt }"  type="number" /> 원</th>
						</tr>	
					</c:when>
					<c:otherwise>
						<tr>
							<td colspan="7">조회된 결제내역이 없습니다.</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</table>
		</c:when>
		<c:otherwise>
			<div style="border: 1px solid #c0c0c0; text-align: center; padding: 300px 0; width: 1020px; margin: 0 auto">
				<div style="padding: 5px 0; font-weight: bold;">카드 승인중입니다.</div>
				<img src="/images/gif/loading_bar.gif" />
			</div>
		</c:otherwise>
	</c:choose>
	</div>
</form>
<br />
<!-- processing viewer -->
<div id="prcssDiv"  class="loingProcessDiv"><div><img src="/images/process4.gif"/></div></div>
<script type="text/javascript">
/** Jquery setting */
jQuery.noConflict();
jQuery(document).ready(function($) {
	$("#prcssDiv").hide();
});
</script>
<!-- //processing viewer --> 
