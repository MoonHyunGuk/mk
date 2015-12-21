<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<script type="text/javascript"  src="/js/mini_calendar.js"></script>
<script type="text/javascript" >
	// 조회
	function goSearch(type, pageNo) {
		
		var frm = document.frm;

		frm.pageNo.value = pageNo;
		frm.action = "ediErrList.do";
		frm.submit();
	}
</script>
<div><span class="subTitle">오류조회</span></div>
<!-- search conditions -->
<div>
	<form name="frm" method="post">
	<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />	
		<table class="tb_search" style="width: 1020px;">
			<colgroup>
				<col width="110px">
				<col width="230px">
				<col width="110px">
				<col width="570px">
			</colgroup>
			<tr>
				<th>지로번호</th>
				<td style="text-align: left; padding-left: 10px">
					<select name="jiroNum"  style="width: 170px;">
						<option value = "">전체</option>
							<c:forEach items="${jiroList}" var="list"  varStatus="status">
								<option value="${list.GIRO_NO}"  <c:if test="${list.GIRO_NO eq jiroNum}">selected</c:if>>${list.GIRO_NO}(${list.NAME})</option>
						 	</c:forEach>
				  	</select>
				</td>
				<th>일자별 검색</th>
				<td style="text-align: left; padding-left: 10px">
					<input type="text" name="sdate" value="<c:out value='${sdate}' />" style="width: 100px; vertical-align: middle;" readonly onclick="Calendar(this)">&nbsp;~
					<input type="text" name="edate" value="<c:out value='${edate}' />" style="width: 100px; vertical-align: middle;" readonly onclick="Calendar(this)">&nbsp;&nbsp;&nbsp;&nbsp;
		   			<img src="/images/bt_joh.gif" style="vertical-align: middle; border: 0; cursor: pointer;" onclick="goSearch('1');">&nbsp;
				</td>
			</tr>
		</table>
	</form>
</div>
<!-- //search conditions -->
<!-- list -->
<div style="padding: 15px 0;">
	<table class="tb_list_a" style="width: 1020px;">
		<colgroup>
			<col width="70px">
			<col width="75px">
			<col width="90px">
			<col width="70px">
			<col width="70px">
			<col width="310px">
			<col width="45px">
			<col width="45px">
			<col width="70px">
			<col width="90px">
			<col width="70px">
		</colgroup>
		<tr>
			<th>지로<br>번호</th>
			<th>일련<br>번호</th>
			<th>수납점</th>
			<th>수납<br>일자</th>
			<th>지국</th>
			<th>결재원수록내용(고객조회번호)</th>
			<th>S</th>
			<th>R</th>
			<th>수납<br>금액</th>
			<th>수수료</th>
			<th>생성<br>일자</th>
		</tr>
		<c:choose>
			<c:when test="${empty errList}">
			<tr>
				<td colspan="13">등록된 정보가 없습니다.</td>
			</tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${errList}" var="list" varStatus="status">
					<input type="hidden" name="e_sdate" value="<c:out value='${list.E_SDATE}' />" />
					<input type="hidden" name="e_edate" value="<c:out value='${list.E_EDATE}' />" />
					<input type="hidden" name="e_number" value="<c:out value='${list.E_NUMBER}' />" />
					<input type="hidden" name="e_rcode" value="<c:out value='${list.E_RCODE}' />" />
					<input type="hidden" name="e_wdate" value="<c:out value='${list.E_WDATE}' />" />
					<input type="hidden" name="e_numid" value="<c:out value='${list.E_NUMID}' />" />
					<input type="hidden" name="e_money" value="<c:out value='${list.E_MONEY}' />" />
					<input type="hidden" name="e_check" value="<c:out value='${list.E_CHECK}' />" />
					<tr class="mover_color">
						<td><c:out value="${list.E_JIRO}" /></td>
						<td><c:out value="${list.E_NUMID}" /></td>
						<td><c:out value="${list.E_INFO}" /></td>
						<td><c:out value="${list.E_SDATE}" /></td>
						<td><c:out value="${list.E_JCODE}" /></td>
						<td><c:out value="${list.E_CHECK}" /></td>
						<td><c:out value="${list.E_SGUBUN}" /></td>
						<td><c:out value="${list.E_JGUBUN}" /></td>
						<td style="text-align: right;"><fmt:formatNumber value="${list.E_MONEY}" type="number" /> 원</td>
						<td style="text-align: right;"><fmt:formatNumber value="${list.E_CHARGE}" type="number" /> 원</td>
						<td><c:out value="${list.E_WDATE}" /></td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>
</div>
<!-- //list -->
<!-- etc -->
<div>
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
		<c:if test="${not empty errList}">				
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
		</c:if>
</table>
</div>
<div style="padding: 10px 0 20px 0">※ 금융결재원 e-GIRO사이트에서 오류 미처리건에 대한 자세한 내용을 확인하실수 있습니다.(지로수납내역=&gt; 장표수납건별검색 =&gt; 고객조회번호 입력후 조회)</div>
<!-- //etc -->
