<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript">
	function runforms1() {
		var frm = document.forms1;

		frm.action="gr15list_excel.do"
		frm.submit();
		return;
	}
	//페이지 이동
	function moveTo(type, pageNo) {
		
		var frm = document.forms1;

		frm.pageNo.value = pageNo;
		frm.action = "ediList.do";
		frm.submit();

	}

	// 오즈 출력
	function goPrint() {
		var frm = document.forms1;
		
		if ( ! frm.edate.value ) {
			alert("일자를 선택해 주세요.");
			return;
		}

			actUrl = "ozEdiList.do";
			window.open('','ozEdiList','width=850, height=700, toolbar=no, menubar=no, location=no, status=no, resizable=1, scrollbar=no');
	
			frm.target = "ozEdiList";
			frm.action = actUrl;
			frm.submit();
			frm.target ="";
	}
</script>
<div><span class="subTitle">자료조회</span></div>
<!-- search conditions -->
<div>
	<form name="forms1" method="get" action="gr15list.do">
	<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />	
	<table class="tb_search" style="width: 1020px;">
		<colgroup>
			<col width="100px">
			<col width="210px">
			<col width="100px">
			<col width="210px">
			<col width="100px;"> 
			<col width="300px;">
		</colgroup>
		<tr>
			<th>수납구분</th>
			<td style="text-align: left; padding-left: 10px;">
				<select name="snType"  style="width: 120px;">
					<option <c:if test="${0 eq snType}">selected</c:if>>전체</option>
					<option value = "1" <c:if test="${1 eq snType}">selected</c:if>>금융결재원 지로 수납</option>
			 		<option value = "2" <c:if test="${2 eq snType}">selected</c:if>>바코드 수납</option>
			  	</select>
			</td>
			<th>지로번호</th>
			<td style="text-align: left; padding-left: 10px;">
				<select name="jiroNum"  style="width: 160px;">
					<option value = "">전체</option>
						<c:forEach items="${jiroList}" var="list"  varStatus="status">
							<option value="${list.GIRO_NO}"  <c:if test="${list.GIRO_NO eq jiroNum}">selected</c:if>>${list.GIRO_NO}(${list.NAME})</option>
					 	</c:forEach>
			  	</select>
			</td>
			<th>일자별 검색</th>
			<td>
				<input type="text" name="edate" value="<c:out value='${edate}' />" style="width: 80px; vertical-align: middle;" readonly onclick="Calendar(this)">&nbsp;&nbsp;&nbsp;&nbsp;
				<img src="/images/bt_joh.gif" style="vertical-align: middle; border: 0; cursor: pointer;" onclick="moveTo('1');">&nbsp;
	   			<img src="/images/bt_print03.jpg" alt="내역서인쇄" style="vertical-align: middle; border: 0; cursor: pointer;" onclick="goPrint();">
			</td>
		</tr>
	</table>
	</form>
</div>
<!-- //search conditions -->
<div style="padding: 5px 0 15px 0; text-align: right;">
	<span style="color:red;">※ 구독월분은 지로파일에 기재된 지로 생성 구독월분의 기간(시작~마지막월분)입니다.</span>
</div>
<div>
	<table class="tb_list_a" style="width: 1020px;">
		<colgroup>
			<col width="85px">
			<col width="120px">
			<col width="110px">
			<col width="195px">
			<col width="100px">
			<col width="100px">
			<col width="90px">
			<col width="110px">
			<col width="85px">
		</colgroup>
		<tr>
			<th>구역배달</th>
			<th>독자번호</th>
			<th>독자명</th>
			<th>주소</th>
			<th>입금액</th>
			<th>확장일자</th>
			<th>지명</th>
			<th>구독월분</th>
			<th>순번</th>
		</tr>
		<c:choose>
			<c:when test="${empty resultList}">
			<tr>
				<td colspan="10" >등록된 정보가 없습니다.</td>
			</tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${resultList}" var="list" varStatus="status">
					<tr class="mover_color">
						<td><c:out value="${list.GNO}" />-<c:out value="${list.BNO}" /></td>
						<td><c:out value="${list.READNO}" /></td>
						<td style="text-align: left;"><c:out value="${list.READNM}" /></td>
						<td style="text-align: left;"><c:out value="${list.DLVADRS1}" />&nbsp;<c:out value="${list.DLVADRS2}" /></td>
						<td style="text-align: right;">
						<c:choose>
							<c:when test="${not empty list.DEBIT_AMT}"><fmt:formatNumber value="${list.DEBIT_AMT}" type="number" /> 원</c:when>
							<c:otherwise>0 원</c:otherwise>
						</c:choose>
					</td>
					<td>
						<c:choose>
							<c:when test="${not empty list.HJDT and fn:length(list.HJDT) >= 8}">
								<c:out value="${fn:substring(list.HJDT,0,4)}-${fn:substring(list.HJDT,4,6)}-${fn:substring(list.HJDT,6,8)}" />
							</c:when>
							<c:otherwise>
								<c:out value="${list.HJDT}" />
							</c:otherwise>
						</c:choose>
					</td>
					<td><c:out value="${list.NEWSYNM}" /></td>
					<td>
						<c:out value="${list.STARTYYMM}" />~<c:out value="${list.ENDYYMM}" />
					</td>
					<td><c:out value="${list.E_NUMBER}" /></td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>
</div>
<div style="padding: 15px 0 20px 0">
	<table class="tb_list_a" style="width: 1020px;">
		<colgroup>
			<col width="70px">
			<col width="250px">
			<col width="250px">
			<col width="200px">
			<col width="250px">
		</colgroup>
		<tr>
			<th></th>
			<th>EDI 건수</th>
			<th>수납금액</th>
			<th>수수료</th>
			<th>이체금액</th>
		</tr>
		<c:if test="${not empty resultList}">
			<tr class="mover_color">
				<td>정상 계</td>
				<td>
					<c:choose>
						<c:when test="${not empty normalMap.CNT}"><fmt:formatNumber value="${normalMap.CNT}" type="number" /></c:when>
						<c:otherwise>0</c:otherwise>
					</c:choose>
				</td>
				<td style="text-align: right;">
					<c:choose>
						<c:when test="${not empty normalMap.SUM_MONEY}"><fmt:formatNumber value="${normalMap.SUM_MONEY}" type="number" /> 원</c:when>
						<c:otherwise>0 원</c:otherwise>
					</c:choose>
				</td>
				<td style="text-align: right;">
					<c:choose>
						<c:when test="${not empty normalMap.SUM_CHARGE}"><fmt:formatNumber value="${normalMap.SUM_CHARGE}" type="number" /> 원</c:when>
						<c:otherwise>0 원</c:otherwise>
					</c:choose>
				</td>
				<td style="text-align: right;">
					<c:choose>
						<c:when test="${not empty normalMap.SUM_TOTAL}"><fmt:formatNumber value="${normalMap.SUM_TOTAL}" type="number" /> 원</c:when>
						<c:otherwise>0 원</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr class="mover_color">
				<td>오류 계</td>
				<td>
					<c:choose>
						<c:when test="${not empty errorMap.CNT}"><fmt:formatNumber value="${errorMap.CNT}" type="number" /></c:when>
						<c:otherwise>0</c:otherwise>
					</c:choose>
				</td>
				<td style="text-align: right;">
					<c:choose>
						<c:when test="${not empty errorMap.SUM_MONEY}"><fmt:formatNumber value="${errorMap.SUM_MONEY}" type="number" /> 원</c:when>
						<c:otherwise>0 원</c:otherwise>
					</c:choose>
				</td>
				<td style="text-align: right;">
					<c:choose>
						<c:when test="${not empty errorMap.SUM_CHARGE}"><fmt:formatNumber value="${errorMap.SUM_CHARGE}" type="number" /> 원</c:when>
						<c:otherwise>0 원</c:otherwise>
					</c:choose>
				</td>
				<td style="text-align: right;">
					<c:choose>
						<c:when test="${not empty errorMap.SUM_TOTAL}"><fmt:formatNumber value="${errorMap.SUM_TOTAL}" type="number" /> 원</c:when>
						<c:otherwise>0 원</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<c:set var="count1" value="${normalMap.CNT + errorMap.CNT}" />
			<c:set var="money1" value="${normalMap.SUM_MONEY + errorMap.SUM_MONEY}" />
			<c:set var="charge1" value="${normalMap.SUM_CHARGE + errorMap.SUM_CHARGE}" />
			<c:set var="echemoney1" value="${money1 - charge1}" />
			<tr bgcolor="ffffff" align="center" class="mover_color">
				<td>총 계</td>
				<td>
					<c:choose>
						<c:when test="${not empty count1}"><fmt:formatNumber value="${count1}" type="number" /></c:when>
						<c:otherwise>0</c:otherwise>
					</c:choose>
				</td>
				<td style="text-align: right;">
					<c:choose>
						<c:when test="${not empty money1}"><fmt:formatNumber value="${money1}" type="number" /> 원</c:when>
						<c:otherwise>0 원</c:otherwise>
					</c:choose>
				</td>
				<td style="text-align: right;">
					<c:choose>
						<c:when test="${not empty charge1}"><fmt:formatNumber value="${charge1}" type="number" /> 원</c:when>
						<c:otherwise>0 원</c:otherwise>
					</c:choose>
				</td>
				<td style="text-align: right;">
					<c:choose>
						<c:when test="${not empty echemoney1}"><fmt:formatNumber value="${echemoney1}" type="number" /> 원</c:when>
						<c:otherwise>0 원</c:otherwise>
					</c:choose>
				</td>
			</tr>
		</c:if>
</table>
</div>



