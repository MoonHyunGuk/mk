<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script language="JavaScript" src="/js/mini_calendar.js"></script>
<script type="text/javascript">
	// 조회
	function serach(){

		// 벨리데이션 체크
		if(!validate()){
			return;
		}

		visitSugmListForm.target="_self";
		visitSugmListForm.action="/collection/manual/visitSugmFormList.do";
		visitSugmListForm.submit();
	}

	// 오즈 인쇄
	function print(){
		
		// 벨리데이션 체크
		if(!validate()){
			return;
		}

		actUrl = "/collection/manual/ozVisitSugmList.do";
		window.open('','ozVisitSugmList','width=850, height=700, toolbar=no, menubar=no, location=no, status=no, resizable=1, scrollbar=no');

		visitSugmListForm.target ="ozVisitSugmList";
		visitSugmListForm.action = actUrl;
		visitSugmListForm.submit();
		visitSugmListForm.target ="";

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
<div><span class="subTitle">방문수금 장부</span></div>
<form id="visitSugmListForm" name="visitSugmListForm" action="visitSugmList.do" method="post">
	<div>
		<!-- 조회조건 영역 -->	
		<table class="tb_search" style="width: 1020px">
			<colgroup>
				<col width="110px">
				<col width="1010px">
			</colgroup>
			<tr>
				<th>기 간</th>
				<td style="text-align: left;">
					&nbsp;
					<input type="text" id="fromDate" name="fromDate"  value="<c:out value='${sdate}' />" readonly onclick="Calendar(this)"  style="width: 80px; padding-left: 5px; vertical-align: middle;" />
					~ 
					<input type="text" id="toDate" name="toDate"  value="<c:out value='${sdate}' />" readonly onclick="Calendar(this)"  style="width: 80px; padding-left: 5px; vertical-align: middle;" />
					&nbsp;
					<a href="#fakeUrl" onclick="serach();"><img src="/images/bt_joh.gif" style="border: 0; vertical-align: middle;"></a>
					&nbsp;
					<a href="#fakeUrl" onclick="print();"><img src="/images/bt_print.gif"  style="border: 0; vertical-align: middle;"></a>
				</td>
			</tr>
		</table>
		<!--// 조회조건 영역 -->	
	</div>
	<!-- 리스트 영역 -->
	<div style="padding: 15px 0 20px 0;">
		<table class="tb_list_a_5">
			<colgroup>
				<col width="110px">
				<col width="170px">
				<col width="220px">
				<col width="170px">
				<col width="175px">
				<col width="175px">
			</colgroup>
			<tr>
				<th>일자</th>
				<th>독자번호</th>
				<th>독자명</th>
				<th>매체</th>
				<th>수금월분</th>
				<th>금액</th>
			</tr>
			<!-- 합계변수 지정 -->
				<c:set var="CNT_SNDT" value="0" />					<!-- 일자별 건수 -->
				<c:set var="CNT" value="0" />						<!-- 총건수 -->
				<c:set var="AMT_SNDT" value="0" />					<!-- 일자별 소계 -->			
				<c:set var="AMT" value="0" />						<!-- 총계 -->
			<!--// 합계변수 지정 -->
			<!-- 리스트 생성 -->
			<c:choose>
				<c:when test="${(empty visitSugmList)}">
					<tr>
						<td colspan="6">
							데이터가 없습니다.
						</td>
					</tr>
				</c:when>
				<c:otherwise>
					<c:forEach items="${visitSugmList}" var="list" varStatus="status">
						<!-- 합계 추출 -->
						<c:set var="CNT_SNDT" value="${CNT_SNDT + 1}" />	<!-- 총계 -->
						<c:set var="CNT" value="${CNT + 1}" />	<!-- 총계 -->
						<c:set var="AMT_SNDT" value="${AMT_SNDT + list.AMT}" />	<!-- 총계 -->
						<c:set var="AMT" value="${AMT + list.AMT}" />	<!-- 총계 -->
						<tr>
							<td>${list.SNDT}</td>
							<td>${list.READNO}</td>
							<td style="text-align: left;">${list.READNM}</td>
							<td>${list.NEWSNM}</td>
							<td>${list.YYMM}월분</td>
							<td style="text-align: right;">${list.AMT}</td>
						</tr>
	
						<c:if test="${(list.SNDT ne visitSugmList[status.index+1].SNDT) or status.last}">
							<tr style="background-color: #ffcccc">
								<td colspan="4"><strong>일자별 소계</strong></td>
								<td style="text-align: right; font-weight: bold;">
									총&nbsp;<fmt:formatNumber value="${CNT_SNDT}"  type="number" />&nbsp;건
								</td>
							    <td style="text-align: right; font-weight: bold;">
									<fmt:formatNumber value="${AMT_SNDT}"  type="number" />
								</td>
							</tr>
							<c:set var="CNT_SNDT" value="0" />					<!-- 일자별 건수 초기화 -->
							<c:set var="AMT_SNDT" value="0" />					<!-- 일자별 금액 소계 초기화 -->
						</c:if>
	
					</c:forEach>
				</c:otherwise>
			</c:choose>
			
			<tr style="background-color: #ccdbfb">
			    <td colspan="4" ><strong>합 &nbsp; 계</strong></td>
			    <!-- 금액 -->
		 		<td style="text-align: right; font-weight: bold;">
					총&nbsp;<fmt:formatNumber value="${CNT}"  type="number" />&nbsp;건  
				</td>
			    <td style="text-align: right; font-weight: bold;">
			    	<fmt:formatNumber value="${AMT}"  type="number" />
			    </td>
		  </tr>
			<!--// 리스트 생성 -->
		</table>
	</div>
	<!-- //리스트 영역 -->
</form>
