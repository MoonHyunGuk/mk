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

		officeReaderListForm.target="_self";
		officeReaderListForm.action="/print/print/officeReaderState.do";
		officeReaderListForm.submit();
	}

	// 엑셀 저장
	function saveExcel(){

		// 벨리데이션 체크
		if(!validate()){
			return;
		}

		officeReaderListForm.target="_self";
		officeReaderListForm.action="/print/print/officeReaderStateExcel.do";
		officeReaderListForm.submit();
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
		return true;
	}
	
	// 날짜 셋팅
	function setDate(){
		$("fromDate").value = '${fromDate }'; 
		$("toDate").value = '${toDate }'	;
	}

	window.attachEvent("onload", setDate);

</script>
<div><span class="subTitle">본사신청구독통계</span></div>
<form id="officeReaderListForm" name="officeReaderListForm" action="officeReaderState.do" method="post">
<!-- search conditions -->
<table class="tb_search" style="width: 1020px;">
	<colgroup>
		<col width="150px">
		<col width="870px">
	</colgroup>
	<tr>
		<th>기 간</th>
		<td>
			<input type="text" id="fromDate" name="fromDate"  value="<c:out value='${sdate}' />" readonly="readonly" onclick="Calendar(this)" style="width: 75px; vertical-align: middle;"/>
			~ 
			<input type="text" id="toDate" name="toDate"  value="<c:out value='${sdate}' />" readonly="readonly" onclick="Calendar(this)" style="width: 75px; vertical-align: middle;"/>
			&nbsp;&nbsp;
			<a href="#fakeUrl" onclick="fn_search();"><img src="/images/bt_joh.gif" style="vertical-align: middle; border: 0;" alt="조회"></a>
			&nbsp;
			<a href="#fakeUrl" onclick="saveExcel();"><img src="/images/bt_savexel.gif" style="vertical-align: middle; border: 0;" alt="엑셀저장"></a>
		</td>
	</tr>
</table>
<!--// search conditions -->	
<!-- 합계용 변수 지정 -->
<c:set var="USERCNT" value="0" />
<c:set var="STOPUSERCNT" value="0" />
<c:set var="APLCCNT" value="0" />
<c:set var="STOPAPLCCNT" value="0" />
<c:set var="EDUCNT" value="0" />
<c:set var="TOTALAPLCCNT" value="0" />
<c:set var="TOTALSTOPCNT" value="0" />
<c:set var="TOTALCNT" value="0" />
<!--// 합계용 변수 지정 -->
<!-- 리스트 영역 -->
<div style="padding-top: 10px">
	<table class="tb_list_a_5" style="width: 1020px;">
		<colgroup>
			<col width="110px">
			<col width="110px">
			<col width="100px">
			<col width="100px">
			<col width="100px">
			<col width="100px">
			<col width="100px">
			<col width="100px">
			<col width="100px">
			<col width="100px">
		</colgroup>
		<tr>
			<th rowspan="2">지국코드</th>
			<th rowspan="2">지국명</th>
			<th colspan="2">일반</th>
			<th colspan="2">사원확장</th>
			<th rowspan="2">교육</th>
			<th colspan="3">계</th>
		</tr>
		<tr>
			<th>신청</th>
			<th>중지</th>
			<th>신청</th>
			<th>중지</th>
			<th>신청합계</th>
			<th>중지합계</th>
			<th>합계</th>
		</tr>
		<!-- 리스트 생성 -->
		<c:choose>
			<c:when test="${(empty officelist)}">
				<tr>
					<td colspan="10">
						데이터가 없습니다.
					</td>
				</tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${officelist}" var="list" varStatus="status">	
					<c:set var="USERCNT" value="${USERCNT + list.USERCNT}" />
					<c:set var="STOPUSERCNT" value="${STOPUSERCNT + list.STOPUSERCNT}" />
					<c:set var="APLCCNT" value="${APLCCNT + list.APLCCNT}" />
					<c:set var="STOPAPLCCNT" value="${STOPAPLCCNT + list.STOPAPLCCNT}" />
					<c:set var="EDUCNT" value="${EDUCNT + list.EDUCNT}" />
					<c:set var="TOTALAPLCCNT" value="${TOTALAPLCCNT + list.TOTALAPLCCNT}" />
					<c:set var="TOTALSTOPCNT" value="${TOTALSTOPCNT + list.TOTALSTOPCNT}" />
					<c:set var="TOTALCNT" value="${TOTALCNT + list.TOTALCNT}" />
				</c:forEach>
				<c:forEach items="${officelist}" var="list">
					<tr>
						<td>${list.JIKUK}</td>
						<td>${list.JIKUKNM}</td>
						<td>${list.USERCNT}</td>
						<td>${list.STOPUSERCNT}</td>
						<td>${list.APLCCNT}</td>
						<td>${list.STOPAPLCCNT}</td>
						<td>${list.EDUCNT}</td>
						<td>${list.TOTALAPLCCNT}</td>
						<td>${list.TOTALSTOPCNT}</td>
						<td>${list.TOTALCNT}</td>
					</tr>
				</c:forEach>
				<tr>
				    <td colspan="2" style="background-color: #ccdbfb"><strong>합 &nbsp; 계</strong></td>						
					<td style="background-color: #ccdbfb">
						<c:choose>	<c:when test="${not empty USERCNT}"><fmt:formatNumber value="${USERCNT}" type="number" /></c:when>	</c:choose>
					</td>
					<td style="background-color: #ccdbfb">
						<c:choose>	<c:when test="${not empty STOPUSERCNT}"><fmt:formatNumber value="${STOPUSERCNT}" type="number" /></c:when>	</c:choose>
					</td>
					<td style="background-color: #ccdbfb">
						<c:choose>	<c:when test="${not empty APLCCNT}"><fmt:formatNumber value="${APLCCNT}" type="number" /></c:when>	</c:choose>
					</td>
					<td style="background-color: #ccdbfb">
						<c:choose>	<c:when test="${not empty STOPAPLCCNT}"><fmt:formatNumber value="${STOPAPLCCNT}" type="number" /></c:when>	</c:choose>
					</td>
					<td style="background-color: #ccdbfb">
						<c:choose>	<c:when test="${not empty EDUCNT}"><fmt:formatNumber value="${EDUCNT}" type="number" /></c:when>	</c:choose>
					</td>
					<td style="background-color: #ccdbfb">
						<c:choose>	<c:when test="${not empty TOTALAPLCCNT}"><fmt:formatNumber value="${TOTALAPLCCNT}" type="number" /></c:when>	</c:choose>
					</td>
					<td style="background-color: #ccdbfb">
						<c:choose>	<c:when test="${not empty TOTALSTOPCNT}"><fmt:formatNumber value="${TOTALSTOPCNT}" type="number" /></c:when>	</c:choose>
					</td>
					<td style="background-color: #ccdbfb">
						<c:choose>	<c:when test="${not empty TOTALCNT}"><fmt:formatNumber value="${TOTALCNT}" type="number" /></c:when>	</c:choose>
					</td>
				</tr>
			</c:otherwise>
		</c:choose>
		<!--// 리스트 생성 -->
	</table>
</div>
<!--// 리스트 영역 -->
</form>
<!-- move to top button -->
<c:if test="${fn:length(officelist) > 25}"><div style="padding: 10px 0; text-align: right;"><a href="#" onclick="javascript:window.scroll(0,0);"><img alt="위로" title="위로" src="/images/ico_top.gif"></a></div></c:if>
<!-- //move to top button -->