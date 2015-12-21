<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript">
	function runforms1() {
		document.forms1.action="gr15list_excel.do"
		document.forms1.submit();
		return;
	}
	//페이지 이동
	function moveTo(type, pageNo) {
		var frm = document.forms1;
	
		frm.pageNo.value = pageNo;
		frm.action = "ediList.do";
		frm.submit();
		jQuery("#prcssDiv").show();
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
<!-- 타이틀 DIV -->
<div style="padding-left: 5px; padding-bottom: 5px;"> 
	<span class="subTitle">지국별 상세조회</span>
</div>
<!--// 타이틀 DIV -->
<form name="forms1" method="get" action="gr15list.do">
<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />	
	<table class="tb_search" style="width: 1020px;">
		<col width="11%">
		<col width="17%">
		<col width="11%">
		<col width="22%">
		<col width="11%">
		<col width="28%">
		<tr>
			<th>지로구분</th>
			<td>
				<select name="type"   style="width: 100px;">
					<option <c:if test="${0 eq type}">selected</c:if>>전체</option>
					<option value = "1" <c:if test="${1 eq type}">selected</c:if>>직영지로</option>
			 		<option value = "2" <c:if test="${2 eq type}">selected</c:if>>수납대행</option>
			 		<option value = "3" <c:if test="${3 eq type}">selected</c:if>>바코드수납</option>
			  	</select>
			</td>
			<th>지국별 검색</th>
			<td>
			<!--  
				<div class="ui-widget">
					<label for="tags"></label>
					<input id="tags" onkeyup="fn_get_jikuk_list(this.value)" />
				</div>
				-->
				<select name="jikuk" size="1">
					<option value=''>전체</option>
					<c:forEach items="${jikukList}" var="list" varStatus="status">
						<c:if test="${not empty list.NAME}">
							<c:choose>
							<c:when test="${jikuk eq list.USERID}">
								<option value="${list.USERID}" selected>${list.NAME}&nbsp;(${list.USERID})</option>
							</c:when>
							<c:otherwise>
								<option value="${list.USERID}">${list.NAME}&nbsp;(${list.USERID})</option>
							</c:otherwise>
							</c:choose>
						</c:if>
					</c:forEach>
				</select>
			</td>
			<th>일자별 검색</th>
			<td>
				<input type="text" class="box_100" size="10" name="edate" value="<c:out value='${edate}' />" readonly onclick="Calendar(this)">
				<a href="javascript:moveTo('1');"><img src="/images/bt_joh.gif" border="0" align="absmiddle"></a>&nbsp;
				<!-- <a href="javascript:goPrint();"><img src="/images/bt_print03.jpg" border="0" alt="내역서인쇄" align="absmiddle"></a>&nbsp; -->
			</td>
		</tr>
	</table>
<!-- //search conditions -->
</form>
<!-- list -->
<div style="width: 1020px; padding-top: 10px; margin: 0 auto;">
	<div style="text-align: right; color: red; width: 1020px; padding-bottom: 5px">※ 구독월분은 지로파일에 기재된 지로 생성 구독월분의 기간(시작~마지막월분)입니다.</div>
	<table class="tb_list_a_5" style="width: 1020px">
		<colgroup>
			<col width="70px">
			<col width="140px">
			<col width="60px">
			<col width="75px">
			<col width="130px">
			<col width="210px">
			<col width="70px">
			<col width="75px">
			<col width="50px">
			<col width="80px">
			<col width="60px">
		</colgroup>
		<tr>
			<th>지국</th>
			<th>고객조회번호</th>
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
				<tr><td colspan="11">등록된 정보가 없습니다.</td></tr>
			</c:when>
			<c:otherwise>
			<c:forEach items="${resultList}" var="list" varStatus="status">
				<tr>
					<td><c:out value="${list.JIKUK_NAME}" />(<c:out value="${list.E_JCODE}" />)</td>
					<td><c:out value="${list.E_CHECK}" /></td>
				    <td><c:out value="${list.GNO}" />-<c:out value="${list.BNO}" /></td>
					<td><c:out value="${list.READNO}" /></td>
					<td style="text-align: left"><c:out value="${list.READNM}" /></td>
					<td style="text-align: left"><c:out value="${list.DLVADRS1}" />&nbsp;<c:out value="${list.DLVADRS2}" /></td>
					<td style="text-align: right">
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
	<!-- total -->
	<div style="padding-top: 15px">		
		<table class="tb_list_a_5" style="width: 1020px">
			<colgroup>
				<col width="150px">
				<col width="190px">
				<col width="240px">
				<col width="200px">
				<col width="240px">
			</colgroup>
			<tr bgcolor="f9f9f9" align="center" class="box_p" >
				<td></td>
				<td>EDI 건수</td>
				<td>수납금액</td>
				<td>수수료</td>
				<td>이체금액</td>
			</tr>
			<c:if test="${not empty resultList}">
			<tr>
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
			<tr>
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
	<!-- //total -->
</div>
<!-- //list -->
<div style="padding: 10px 0; text-align: right;"><a href="#" onclick="javascript:window.scroll(0,0);"><img alt="위로" title="위로" src="/images/ico_top.gif"></a></div>
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
