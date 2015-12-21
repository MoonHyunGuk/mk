<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript">
	//페이징
	function moveTo(where, seq) {
		if($("searchText").value  != '' || $("boSeq").value  != '' || $("status").value  != '1'){
			$("pageNo").value = seq;
			employeeList.target = "_self";
			employeeList.action = "/reader/employeeAdmin/searchEmployeeList.do";
			employeeList.submit();
		}else{
			$("pageNo").value = seq;
			employeeList.target = "_self";
			employeeList.action = "/reader/employeeAdmin/retrieveEmployeeList.do";
			employeeList.submit();	
		}
	}
	
	//검색
	function fn_search(){
		$("pageNo").value = '1';
		employeeList.target = "_self";
		employeeList.action = "/reader/employeeAdmin/searchEmployeeList.do";
		employeeList.submit();
	}
	
	//자세히 보기
	function detailVeiw(boSeq , readNo , newsCd , seq){
		var fm = document.getElementById("employeeList");
		
		var left = (screen.width)?(screen.width - 750)/2 : 10;
		var top = (screen.height)?(screen.height - 750)/2 : 10;
		var winStyle = "width=750,height=750,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		var newWin = window.open("", "detailVeiw", winStyle);
		
		fm.target = "detailVeiw";
		fm.action = "/reader/employeeAdmin/employeeInfo.do?boSeq="+boSeq+"&readNo="+readNo+"&newsCd="+newsCd+"&seq="+seq;
		fm.submit();
	}
	
	//본사구독리스트엑셀저장
	function excel(){
		employeeList.target="_self";
		employeeList.action = "/reader/employeeAdmin/employeeExcel.do";
		employeeList.submit();
	}
	
	//해지
	function closeNews(readNo){
		$("readNo").value = readNo;
		
		if(confirm('신문 구독을 중지 하시겠습니까?') == false){
			return;
		}
		
		employeeList.target="_self";
		employeeList.action = "/reader/employeeAdmin/closeNews.do";
		employeeList.submit();
	}
</script>
<!-- title -->
<div><span class="subTitle"> 본사독자 리스트</span></div>
<!-- //title -->
<form id="employeeList" name="employeeList" action="" method="post">
<input type=hidden id="pageNo" name="pageNo" value="${param.pageNo}" />
<input type=hidden id="readNo" name="readNo" value="" />
<input type=hidden id="newsCd" name="newsCd" value="" />
<input type=hidden id="seq" name="seq" value="" />
<input type=hidden id="boSeqSerial" name="boSeqSerial" value="" />
<input type=hidden id="flag" name="flag" value="UPT" />
<!-- search condition -->
<div class="box_white" style="padding: 10px 0; width: 1020px; margin: 0 auto;">
	<select id="boSeq" name="boSeq" onchange="fn_search();" style="vertical-align: middle;">
		<option value="">전 체 지 국 보 기</option>
		<c:forEach items="${agencyAllList }" var="list">
			<option value="${list.SERIAL }" <c:if test="${param.boSeq eq list.SERIAL }"> selected </c:if>>${list.NAME }</option>
		</c:forEach>
	</select>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<select id="searchKey" name="searchKey" style="vertical-align: middle;">
		<option value="readnm" <c:if test="${param.searchKey eq 'readnm' }"> selected </c:if>>성 명</option>
		<option value="company" <c:if test="${param.searchKey eq 'company' }"> selected </c:if>>회 사 명</option>
		<option value="office" <c:if test="${param.searchKey eq 'office' }"> selected </c:if>>부 서 명</option>
	</select>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="text" id="searchText" name="searchText" style="width: 140px; vertical-align: middle;" value="${param.searchText }" onkeydown="if(event.keyCode == 13){fn_search(); }"/>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="#fakeUrl" onclick="fn_search();"><img src="/images/bt_search.gif" style="border: 0; vertical-align: middle;" alt="검색"></a>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<select id="status" name="status" onchange="fn_search();"  style="vertical-align: middle;">
		<option value="1" <c:if test="${param.status eq '1' }"> selected </c:if>>전체</option>
		<option value="2" <c:if test="${param.status eq '2' }"> selected </c:if>>정상</option>
		<option value="3" <c:if test="${param.status eq '3' }"> selected </c:if>>해지</option>
	</select>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="#fakeUrl" onclick="excel();"><img src="/images/bt_savexel.gif" style="border: 0; vertical-align: middle;" alt="검색"></a>
</div>
<!-- //search condition -->
<!-- list -->
<div class="box_list" style="width: 1020px; margin: 0 auto;">
	<!-- counting -->
	<div style="padding-bottom: 3px"><font class="b02">정상 구독 부수 : ${count }</font></div>
	<!-- //counting -->
	<table class="tb_list_a" style="width: 1020px">
		<colgroup>
			<col width="75px">
			<col width="70px">
			<col width="115px">
			<col width="55px">
			<col width="90px">
			<col width="255px">
			<col width="105px">
			<col width="45px">
			<col width="85px">
			<col width="45px">
			<col width="75px">
		</colgroup>
		<!-- 
		<c:if test="${not (param.status eq '3') }">
			<tr><td colspan="11"></td></tr>
		</c:if>
		 -->
		<tr>
			<th>관리지국</th>
			<th>회사명</th>
			<th>부서명</th>
			<th>사번</th>
			<th>성명</th>
			<th>주소</th>
			<th>휴대폰</th>
			<th>금액</th>
			<th>신청일<br/>(해지일)</th>
			<th>해지</th>
			<th>현재상태</th>
		</tr>
		<c:forEach items="${employeeList }" var="list" varStatus="i">
			<tr class="mover_color">
				<td>${list.JIKUKNM }</td>
				<td>${list.COMPANYNM }</td>
				<td style="text-align: left">${list.OFFINM }</td>
				<td>${list.SABUN }</td>
				<td style="text-align: left"><a href="#fakeUrl" onclick="detailVeiw('${list.BOSEQ }','${list.READNO }','${list.NEWSCD }','${list.SEQ }');">${list.READNM }</a></td>
				<td style="text-align: left">${list.NEWADDR }<br/><b>(${list.DLVADRS1 })</b>${list.DLVADRS2 }</td>
				<td>${list.MOBILE }</td>
				<td>${list.UPRICE }</td>
				<c:choose>
					<c:when test="${list.BNO eq '999' }">
						<td>${list.INDT }<br/>(<font class="b03">${list.STDT }</font>)</td>
						<td></td>
						<td><font class="b03">해지</font></td>
					</c:when>
					<c:otherwise>
						<td>${list.INDT }</td>
						<td><a href="#fakeUrl" onclick="closeNews('${list.READNO }');">해지</a></td>
						<td>정상</td>
					</c:otherwise>
				</c:choose>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/common/paging.jsp"%>
</div>
</form>