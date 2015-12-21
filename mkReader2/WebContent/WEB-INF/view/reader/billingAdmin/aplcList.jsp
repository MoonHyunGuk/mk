<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
//독자일보 조회
function fn_retrieve(){
	var fm = document.getElementById("aplcListForm");
	var fromDate = document.getElementById("fromDate");
	var toDate = document.getElementById("toDate");
	
	if(fromDate.value == ''){
		alert("조회 시작 날짜를 입력해 주세요.");
		fromDate.focus();
		return;
	}
	if(toDate.value == ''){
		alert("조회 끝 날짜를 입력해 주세요.");
		toDate.focus();
		return;
	}

	var tmpFrom =  fromDate.value.split("-");
	var tmpTo =  toDate.value.split("-");
	
	if(tmpFrom[0] != tmpTo[0]){
		alert("조회 시작년도와 조회 끝년도가 다릅니다.");
		return;
	}
	if(tmpFrom[1] != tmpTo[1]){
		alert("조회 시작월과 끝월이 다릅니다.");
		return;
	}
	if(tmpFrom[0]+tmpFrom[1]+tmpFrom[2] > tmpTo[0]+tmpTo[1]+tmpTo[2] ){
		alert("조회 시작월이 끝월보다 큽니다.");
		return;
	}
	
	fm.target="_self";
	fm.action="/reader/billingAdmin/aplcList.do";
	fm.submit();
	jQuery("#prcssDiv").show();
}

//독자일보 엑셀 저장
function fn_saveExcel(){
	var fm = document.getElementById("aplcListForm");
	var fromDate = document.getElementById("fromDate");
	var toDate = document.getElementById("toDate");
	
	if(fromDate.value == ''){
		alert("조회 시작 날짜를 입력해 주세요.");
		fromDate.focus();
		return;
	}
	if(toDate.value == ''){
		alert("조회 끝 날짜를 입력해 주세요.");
		toDate.focus();
		return;
	}

	var tmpFrom =  fromDate.value.split("-");
	var tmpTo =  toDate.value.split("-");
	if(tmpFrom[0] != tmpTo[0]){
		alert("조회 시작년도와 조회 끝년도가 다릅니다.");
		return;
	}
	if(tmpFrom[1] != tmpTo[1]){
		alert("조회 시작월과 끝월이 다릅니다.");
		return;
	}
	if(Number(tmpFrom[0]+tmpFrom[1]+tmpFrom[2]) > Number(tmpTo[0]+tmpTo[1]+tmpTo[2]) ){
		alert("조회 시작월이 끝월보다 큽니다.");
		return;
	}

	fm.target="_self";
	fm.action="/reader/billingAdmin/aplcListExcel.do";
	fm.submit();
}

function fn_ozPrint(){
	var fm = document.getElementById("aplcListForm");

	var actUrl = "/reader/billingAdmin/ozAplcList.do";
	window.open('','ozBill','width=850, height=700, toolbar=no, menubar=no, location=no, status=no, resizable=1, scrollbar=no');

	fm.target ="ozBill";
	fm.action = actUrl;
	fm.submit();
	fm.target ="";
}
</script>
<div><span class="subTitle" style="font-size: 18px">신규 독자 일보</span></div>
<div style="width: 1020px; text-align: center; padding-bottom: 10px">	
	<b>[</b> ${fn:substring(fromDate,0,4 ) }년 ${fn:substring(fromDate,5,7 ) }월 ${fn:substring(fromDate,8,10 ) }일  ~ ${fn:substring(toDate,0,4 ) }년 ${fn:substring(toDate,5,7 ) }월 ${fn:substring(toDate,8,10 ) }일 <b>]</b>
</div>
<form id="aplcListForm" name="aplcListForm" method="post">
<!-- search conditions -->
<div class="box_white" style="padding: 10px 0; width: 1020px;">
	<input type="text" id="fromDate" name="fromDate"  value="${fromDate}" readonly="readonly" onclick="Calendar(this)" style="width: 75px; vertical-align: middle;" />
	&nbsp;&nbsp; ~ &nbsp;&nbsp; 
	<input type="text" id="toDate" name="toDate"  value="${toDate}" readonly="readonly" onclick="Calendar(this)" style="width: 75px; vertical-align: middle;" />
	&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="#fakeUrl" onclick="fn_retrieve();"><img src="/images/bt_joh.gif" style="vertical-align: middle; border: 0;" alt="조회" /></a>
	&nbsp;&nbsp;&nbsp;
	<a href="#fakeUrl" onclick="fn_saveExcel();"><img src="/images/bt_savexel.gif" style="vertical-align: middle; border: 0;" alt="엑셀저장" /></a>
	&nbsp;&nbsp;&nbsp;
	<span class="btnCss2" ><a class="lk2" onclick="fn_ozPrint();" style="font-weight: bold;">오즈출력</a></span>
</div>
<!-- //search conditions -->
<!-- list -->
<div class="box_list" style="padding-bottom: 0;">
	<table class="tb_list_a_5" style="width: 1020px">
		<colgroup>
			<col width="150px">
			<col width="60px">
			<col width="400px">
			<col width="100px">
			<col width="100px">
			<col width="90px">
			<col width="60px">
			<col width="60px">
		</colgroup>
		<tr>
			<th rowspan="2">독자명</th>
			<th rowspan="2">우편번호</th>
			<th rowspan="2">주소</th>
			<th rowspan="2" >연락처</th>
			<th rowspan="2">관리지국</th>
			<th rowspan="2">결제방법</th>
			<th colspan="2">부수</th>
		</tr>
		<tr>
			<th>일반</th>
			<th>학생</th>
		</tr>
		<c:choose>
			<c:when test="${(empty aplc) && (empty tbl) && (empty stu) && (empty edu) && (empty card)}">
				<tr>
					<td colspan="8">
						데이터가 없습니다.
					</td>
				</tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${aplc }" var="list">
					<tr>
						<td style="text-align: left">${list.USERNAME }</td>
						<td>${list.ZIP }</td>
						<td style="text-align: left">${list.ADDR }</td>
						<td>${list.HANDY }</td>
						<td>${list.BONM }</td>
						<td>${list.HJPATH }</td>
						<td>${list.BUSU }</td>
						<td></td>
					</tr>
				</c:forEach>
				<c:forEach items="${card }" var="list">
					<tr>
						<td style="text-align: left">${list.USERNAME }</td>
						<td>${list.ZIP }</td>
						<td style="text-align: left">${list.ADDR1 }</td>
						<td>${list.HANDY }</td>
						<td>${list.BONM }</td>
						<td>${list.HJPATH }</td>
						<td>${list.BUSU }</td>
						<td></td>
					</tr>
				</c:forEach>
				<c:forEach items="${edu }" var="list">
					<tr>
						<td style="text-align: left">${list.USERNAME }</td>
						<td>${list.ZIP }</td>
						<td style="text-align: left">${list.ADDR }</td>
						<td>${list.HANDY }</td>
						<td>${list.BONM }</td>
						<td>교육용</td>
						<td>${list.BUSU }</td>
						<td></td>
					</tr>
				</c:forEach>
				<c:forEach items="${tbl }" var="list">
					<tr>
						<td style="text-align: left">${list.USERNAME }</td>
						<td>${list.ZIP }</td>
						<td style="text-align: left">${list.ADDR }</td>
						<td>${list.HANDY }</td>
						<td>${list.BONM }</td>
						<td>자동이체(일반)</td>
						<td>${list.BUSU }</td>
						<td></td>
					</tr>
				</c:forEach>
				<c:forEach items="${stu }" var="list">
					<tr>
						<td style="text-align: left">${list.USERNAME }</td>
						<td>${list.ZIP }</td>
						<td style="text-align: left">${list.ADDR }</td>
						<td>${list.HANDY }</td>
						<td>${list.BONM }</td>
						<td>자동이체(학생)</td>
						<td></td>
						<td>${list.BUSU }</td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>
	<br />
	<div class="box_white"	style="padding: 10px">
		<table class="tb_list_a_5" style="width: 300px; float: right;">
			<colgroup>
				<col width="60px">
				<col width="80px">
				<col width="80px">
				<col width="80px">
			</colgroup>
			<tr>
				<th>구분</th>
				<th>일반</th>
				<th>학생</th>
				<th>계</th>
			</tr>
			<tr>
				<td><font class="b02">일계</font></td>
				<td>${count[0].SUMDAY }</td>
				<td>${count[0].SUMDAYSTU }</td>
				<td>${count[0].SUMDAY + count[0].SUMDAYSTU }</td>
			</tr>
			<tr>
				<td><font class="b02">월계</font></td>
				<td>${count[0].SUMMONTH }</td>
				<td>${count[0].SUMMONTHSTU }</td>
				<td>${count[0].SUMMONTH + count[0].SUMMONTHSTU }</td>
			</tr>
			<tr>
				<td><font class="b02">누계</font></td>
				<td>${count[0].SUMYEAR }</td>
				<td>${count[0].SUMYEARSTU }</td>
				<td>${count[0].SUMYEAR + count[0].SUMYEARSTU }</td>
			</tr>
		</table>
	</div>
</div>
<!-- list -->
</form>
<!-- move to top button -->
<c:if test="${fn:length(aplc) > 25}"><div style="padding: 10px 0; text-align: right;"><a href="#" onclick="javascript:window.scroll(0,0);"><img alt="위로" title="위로" src="/images/ico_top.gif"></a></div></c:if>
<!-- //move to top button -->
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