<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet">
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
/**
 *	 팝업닫기
 **/
function fn_popClose() {
	window.close();
}

jQuery(document).ready(function($){ 
	$("#prcssDiv").show();
});
</script>
</head>
<body>
<div class="box_Popup">
	<!-- title -->
	<div class="pop_title_box">독자정보</div>
	<!-- //title -->
	<div style="padding: 10px 0;">
		<!-- 히스토리정보 -->
		<div style="width: 800px; float: left; padding-right: 20px;">
			<div style="font-weight: bold; padding: 5px 0;">[독자히스토리]</div>
			<table class="tb_list_a" style="width: 800px">
				<colgroup>
					<col width="60px">
					<col width="200px">
					<col width="60px">
					<col width="80px">
					<col width="60px">
					<col width="80px">
					<col width="80px">
					<col width="80px">
					<col width="80px">
					<col width="20px">
				</colgroup>
				<tr>
					<th>배달구역</th>
					<th>주소</th>
					<th>수금타입</th>
					<th>가격</th>
					<th>부수</th>
					<th>수정일자</th>
					<th>수정인</th>
					<th>HINDT</th>
					<th>HINPS</th>
				</tr>
			</table>
			<div style="width: 800px; height: 480px; overflow-x: none; overflow-y: scroll; margin: 0 auto " >
				<table class="tb_list_a" style="width: 783px">
					<colgroup>
						<col width="60px">
						<col width="200px">
						<col width="60px">
						<col width="80px">
						<col width="60px">
						<col width="80px">
						<col width="80px">
						<col width="80px">
						<col width="63px">
					</colgroup>
					<c:forEach items="${readerHistoryList}" var="list"  varStatus="status">	
					<tr>
						<td>${list.GNO }-${list.BNO }</td>
						<td>${list.NEWADDR }${list.DLVADRS2 }</td>
						<td>${list.SGTYPE }</td>
						<td>${list.UPRICE }</td>
						<td>${list.QTY }</td>
						<td>${list.CHGDT }</td>
						<td>${list.CHGPS }</td>
						<td>${list.HINDT }</td>
						<td>${list.HINPS }</td>
					</tr>
					</c:forEach>
				</table>
			</div>
		</div>
		<!-- //히스토리정보 -->
		<!-- 수금정보 -->
		<div style="width: 660px; float: left;">
			<div style="font-weight: bold; padding: 5px 0;">[독자수금정보]</div>
			<table class="tb_list_a" style="width: 660px">
				<colgroup>
					<col width="60px">
					<col width="60px">
					<col width="60px">
					<col width="60px">
					<col width="80px">
					<col width="80px">
					<col width="80px">
					<col width="80px">
					<col width="80px">
					<col width="20px">
				</colgroup>
				<tr>
					<th>구독년월</th>
					<th>청구금액</th>
					<th>청구부수</th>
					<th>수금년월</th>
					<th>수금금액</th>
					<th>수납일자</th>
					<th>이체일자</th>
					<th>처리일자</th>
					<th colspan="2">수정</th>
				</tr>
			</table>
			<div style="width: 660px; height: 480px; overflow-x: none; overflow-y: scroll; margin: 0 auto " >
				<table class="tb_list_a" style="width: 643px">
					<colgroup>
						<col width="60px">
						<col width="60px">
						<col width="60px">
						<col width="60px">
						<col width="80px">
						<col width="80px">
						<col width="80px">
						<col width="81px">
						<col width="63px">
					</colgroup>
					<c:forEach items="${readerSugmList}" var="list"  varStatus="status">	
					<tr>
						<td>${list.YYMM }</td>
						<td>${list.BILLAMT }</td>
						<td>${list.BILLQTY }</td>
						<td>${list.SGYYMM }</td>
						<td>${list.AMT }</td>
						<td>${list.SNDT }</td>
						<td>${list.ICDT }</td>
						<td>${list.CLDT }</td>
						<td>${list.CHGPS }</td>
					</tr>
					</c:forEach>
				</table>
			</div>
		</div>
		<!-- //수금정보 -->
	</div>
	<!-- button -->
	<div style="width: 1480px; margin: 0 auto; text-align: right;  clear: both; padding-top: 5px;">
		<a href="#fakeUrl" onclick="fn_popClose();"><img src="/images/bt_close.gif" style="border: 0; vertical-align: middle"></a>
	</div>
	<!-- //button -->
</div>
</body>
</html>
