<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" type="text/css" href="/css/addStyle.css">
<link rel="stylesheet" type="text/css" href="/css/mkcrm.css">
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
/***
 * 엑셀다운
 * type : A=전체, O=지국장만
 */
function fn_excelDown(type) {
	var fm = document.getElementById("fm");
	
	fm.target="_self";
	fm.printType.value = type;
	fm.action = "/management/adminManage/excelDeliveryList.do";
	fm.submit();
}
</script>
<div style="padding-bottom: 5px;"><span class="subTitle">발송문자수신리스트</span></div>
<form name="fm" id="fm" method="post">
	<input type="hidden" id="printType" name="printType" />
	<div style="width: 920px; padding-left: 15px; border: 0px solid">
		<table class="tb_list_a" style="width: 898px; margin: 0; margin-left: 2px">
			<colgroup>
				<col width="110px">
				<col width="110px">
				<col width="110px">
				<col width="110px">
				<col width="110px">
				<col width="110px">
				<col width="110px">
				<col width="110px">
				<col width="18px">
			</colgroup>
			<tr>
				<th>지국명</th> 
				<th>지국코드</th>
				<th>성 명1</th>
				<th>연락처1</th>
				<th>성 명2</th>
				<th>연락처2</th>
				<th>성 명3</th>
				<th>연락처3</th>
				<th>&nbsp;</th>
			</tr>
		</table>
		<div style="width: 900px; height: 420px; overflow-y: scroll; margin: 0; padding: 0;">
			<table class="tb_list_a" style="width: 880px"> 
				<colgroup>
					<col width="110px">
					<col width="110px">
					<col width="110px">
					<col width="110px">
					<col width="110px">
					<col width="110px">
					<col width="110px">
					<col width="110px">
				</colgroup>
				<c:forEach items="${deliveryNumList }" var="list">
					<tr> 
						<td>${list.NAME }</td>
						<td>${list.SERIAL }</td>
						<td>${list.DELIVERY_NM1}</td> 
						<td>${list.DELIVERY_NUM1}</td>
						<td>${list.DELIVERY_NM2}</td>
						<td>${list.DELIVERY_NUM2}</td>
						<td>${list.DELIVERY_NM3}</td>
						<td>${list.DELIVERY_NUM3}</td>
					</tr>
				</c:forEach>
			</table>
		</div>
		<!-- button -->					
		<div style="width: 900px; text-align: right; padding-top: 10px;">    	
		   	<span class="btnCss4"><a class="lk3" onclick="fn_excelDown('A');">EXCEL출력</a></span>
		   	<span class="btnCss4"><a class="lk3" onclick="fn_excelDown('O');"  style="font-size: 0.9em">EXCEL출력(지국장만)</a></span>
		</div>
		<!-- button -->	
	</div>
</form>
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