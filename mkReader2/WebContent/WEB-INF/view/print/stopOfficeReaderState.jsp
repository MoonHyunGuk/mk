<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript">
	// 조회
	function fn_search(){

		// 벨리데이션 체크
		if(!validate()){
			return;
		}

		stopOfficeReaderListForm.target="_self";
		stopOfficeReaderListForm.action="/print/print/stopOfficeReaderList.do";
		stopOfficeReaderListForm.submit();
	}

	// 엑셀 저장
	function saveExcel(){

		// 벨리데이션 체크
		if(!validate()){
			return;
		}

		stopOfficeReaderListForm.target="_self";
		stopOfficeReaderListForm.action="/print/print/stopOfficeReaderListExcel.do";
		stopOfficeReaderListForm.submit();
	}
	
	// 벨리데이션 체크
	function validate(){
		if($("fromDate").value == ''){
			alert("조회 시작 날짜를 입력해 주세요.");
			$("fromDate").focus();
			return false;
		}
		if($("toDate").value == ''){
			alert("조회 종료 날짜를 입력해 주세요.");
			$("toDate").focus();
			return false;
		}
		var tmpFrom =  $("fromDate").value.split("-");
		var tmpTo =  $("toDate").value.split("-");

		if(tmpFrom[0]+tmpFrom[1]+tmpFrom[2] > tmpTo[0]+tmpTo[1]+tmpTo[2] ){
			alert("조회 시작일이 종료일보다 큽니다.");
			return false;
		}
		
		if($("searchTyp").value == ""){
			$("searchVal").value = "";
		}
		
		return true;
	}
	
	// 날짜 셋팅
	function setDate(){
		$("fromDate").value = '${fromDate }'; 
		$("toDate").value = '${toDate }'	;
		setSerathValue();
	}
	
	// 추가 조회 조건
	function setSerathValue(){
		if($("searchTyp").value == ""){
			$("tdSearchVal").style.display = "none"; 
			$("searchVal").style.display = "none"; 
		}else{
			$("tdSearchVal").style.display = "block"; 
			$("searchVal").style.display = "block"; 
		} 
	}
	
	window.attachEvent("onload", setDate);

</script>
<div><span class="subTitle">본사신청중지현황</span></div>
<form id="stopOfficeReaderListForm" name="stopOfficeReaderListForm" action="stopOfficeReaderList.do" method="post">
<!-- search conditions -->
<table class="tb_search" style="width: 1020px">
		<colgroup>
			<col width="150px">
			<col width="440px">
			<col width="430px">
		</colgroup>
		<tr>
			<th>기 간</th>
			<td style="border-right: 0px">
				<div style="float: left;">
					<input type="text" id="fromDate" name="fromDate"  value="<c:out value='${sdate}' />" readonly="readonly" onclick="Calendar(this)" style="width: 75px; vertical-align: middle;" />
					~ 
					<input type="text" id="toDate" name="toDate"  value="<c:out value='${sdate}' />" readonly="readonly" onclick="Calendar(this)"  style="width: 75px; vertical-align: middle;" />
					&nbsp;&nbsp;
					<select id="searchTyp" name="searchTyp" onchange="setSerathValue()" style="vertical-align: middle;">
						<option value="" <c:if test="${empty param.searchTyp || param.searchTyp eq ''}">selected</c:if>>전체</option>
						<option value="readNm" <c:if test="${param.searchTyp eq 'readNm'}">selected</c:if>>독자명</option>
					</select>&nbsp;&nbsp;
				</div>
				<div id="tdSearchVal" style="width: 140px; display:none; float: left; overflow: hidden;"><input type="text" id="searchVal" name="searchVal" value="<c:out value='${param.searchVal}'/>" style="vertical-align: middle; width: 135px"></div>
			</td>
			<td style="border-left:0px; text-align: left;">
				<a href="#fakeUrl" onclick="fn_search();"><img src="/images/bt_joh.gif" style="vertical-align: middle; border: 0;" alt="조회" /></a>
				&nbsp;
				<a href="#fakeUrl" onclick="saveExcel();"><img src="/images/bt_savexel.gif" style="vertical-align: middle; border: 0;" alt="엑셀저장"></a>
			</td>
	</tr>
</table>
<!-- //search conditions -->
<!-- 리스트 영역 -->
<div style="padding-top: 10px">
	<table class="tb_list_a_5" style="width: 1020px;">
		<colgroup>
			<col width="65px">
			<col width="60px">
			<col width="160px">
			<col width="355px">
			<col width="100px">
			<col width="80px">
			<col width="40px">
			<col width="80px">
			<col width="80px">
		</colgroup>
		<tr>
			<th>지국번호</th>
			<th>지국명</th>
			<th>독자명</th>
			<th>주소</th>
			<th>연락처</th>
			<th>결제방법</th>
			<th>부수</th>
			<th>신청일</th>
			<th>중지일</th>
		</tr>
		
		<!-- 리스트 생성 -->
		<c:choose>
			<c:when test="${(empty stopOfficeReaderList)}">
				<tr>
					<td colspan="9">
						데이터가 없습니다.
					</td>
				</tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${stopOfficeReaderList}" var="list">
					<tr class="mover_color">
						<td>${list.BOSEQ}</td>
						<td>${list.JIKUKNM}</td>
						<td>${list.READNM}</td>
						<td>${list.ADDR}</td>
						<td>${list.TEL}</td>
						<c:choose>
						<c:when test="${list.HJPATHCD eq 'AUTO'}">
							<td>자동이체</td>
						</c:when>
						<c:otherwise>
							<td>${list.HJPATHCD}</td>
						</c:otherwise>
						</c:choose>
						<td>${list.QTY}</td>
						<td>${list.APLCDT}</td>
						<td>${list.STDT}</td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
		<!--// 리스트 생성 -->
	</table>
</div>
<!--// 리스트 영역 -->
</form>
<!-- move to top button -->
<c:if test="${fn:length(stopOfficeReaderList) > 25}"><div style="padding: 10px 0; text-align: right;"><a href="#" onclick="javascript:window.scroll(0,0);"><img alt="위로" title="위로" src="/images/ico_top.gif"></a></div></c:if>
<!-- //move to top button -->