<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet">
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
//페이지 이동
function moveTo(where, seq) {
	var fm = document.getElementById("cardDtlPaymentForm");
	
	fm.pageNo.value = seq;
	fm.target = "_self";
	fm.action = "/reader/card/cardReaderSugmList.do";
	fm.submit();	
} 

// 조회
function fn_search(){
	var fm = document.getElementById("cardDtlPaymentForm");
	//$("pageNo").value = '1';
	
	fm.pageNo.value = "1";
	fm.target = "_self";
	fm.action = "/reader/card/cardReaderSugmListJikuk.do";
	fm.submit();
	jQuery("#prcssDiv").show();
}

/*----------------------------------------------------------------------
 * Desc   : 독자 상세보기
 * Auth   : 박윤철
 *----------------------------------------------------------------------*/
function detailVeiw(readno){
	var fm = document.getElementById("cardDtlPaymentForm");
	 
	var left = (screen.width)?(screen.width - 830)/2 : 10;
	var top = (screen.height)?(screen.height - 760)/2 : 10;
	var winStyle = "width=1024,height=768,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
	newWin = window.open("", "detailReaderInfo", winStyle);
	newWin.focus();
	
	fm.target = "detailReaderInfo"; 
	fm.action = "/reader/minwon/popReaderDetailInfo.do?readno="+readno;
	fm.submit();
}
</script>
<!-- title -->
<div><span class="subTitle">카드독자 수금</span></div>
<!-- //title -->
<form id="cardDtlPaymentForm" name="cardDtlPaymentForm" method="post" enctype="multipart/form-data">
	<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />
	<div class="box_white" style="width: 1020px; padding: 10px 0; margin: 0 auto">
		<c:if test="${loginType ne 'B' }">
			<font class="b02">지 국</font>&nbsp;&nbsp;
			<select name="realJikuk" id="realJikuk" style="width: 140px; vertical-align: middle; ">
				<option value="">전체</option>
				<c:forEach items="${agencyAllList }" var="list">
					<option value="${list.SERIAL }" <c:if test="${realJikuk eq list.SERIAL}">selected </c:if>>${list.NAME } </option>
				</c:forEach>
			</select>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		</c:if>
		<font class="b02">청구월분</font>&nbsp;&nbsp;
		<select name="yymm" id="yymm" style="vertical-align: middle;">
			<c:if test="${empty cardPaymentYymmList}">
				<option value="">청구이력없음</option>
			</c:if>
			<c:forEach items="${cardPaymentYymmList }" var="list">
				<option value="${list.YYMM }" <c:if test="${yymm eq list.YYMM}">selected </c:if>>
					<fmt:parseDate value="${list.YYMM}" var='tempYymm' pattern="yyyymm" scope="page"/>
					<fmt:formatDate value="${tempYymm}" type="date" pattern="yyyy-mm" />
				</option>
			</c:forEach>
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<font class="b02">수금처리결과</font>&nbsp;&nbsp;
		<select name="status" id="status" style="vertical-align: middle;">
			<option value="all" <c:if test="${status eq 'all'}">selected </c:if>>전체</option>
			<option value="on" <c:if test="${status eq 'on'}">selected </c:if>>정상출금</option>
			<option value="err" <c:if test="${status eq 'err'}">selected </c:if>>에러</option>
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<a href="#fakeUrl" onclick="fn_search();"><img src="/images/bt_joh.gif" style="vertical-align: middle;" /></a> 				
	</div>
	<div style="width: 1020px; margin: 0 auto; padding-top: 15px">			
	<table class="tb_list_a_5" style="width: 1020px">
		<colgroup>
			<col width="65px"/>
			<col width="90px"/>
			<col width="65px"/>
			<col width="100px"/>
			<col width="75px"/>
			<col width="100px"/>
			<col width="200px"/>
			<col width="90px"/>
			<col width="75px"/>
			<col width="90px"/>
			<col width="110px"/>
		</colgroup>	
		<tr>
			<th>식별번호</th>
			<th>독자ID</th>
			<th>청구월분</th>
			<th>지국</th>
			<th>독자번호</th>
			<th>독자명</th>
			<th>독자주소</th>
			<th>수금총액</th>
			<th>수금처리월</th>
			<th>수금처리액</th>
			<th>수금처리결과</th>
		</tr>
		<c:choose>
			<c:when test="${empty cardReaderSugmList}">
				<tr bgcolor="ffffff" align="center">
					<td colspan="11"  align="center" >등록된 정보가 없습니다.</td>
				</tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${cardReaderSugmList}" var="list" varStatus="i">
					<c:if test="${list.CARD_SEQ ne prev_row}"><c:set var="check_row" value="0" /></c:if>
					<c:if test="${list.CARD_SEQ eq prev_row}"><c:set var="check_row" value="${check_row + 1}" /></c:if>

					<tr bgcolor="ffffff" align="center">
						<c:if test="${check_row == 0}">
							<td align="right" valign="top" rowspan="<c:out value='${list.PARTCNT}'/>" >${list.CARD_SEQ}</td>
							<td align="left" valign="top" rowspan="<c:out value='${list.PARTCNT}'/>" >${list.ID}</td>
							<td align="center" valign="top" rowspan="<c:out value='${list.PARTCNT}'/>" >${list.YYMM}</td>
							<td align="center" valign="top" rowspan="<c:out value='${list.PARTCNT}'/>" >${list.JIKUKNAME}</td>
							<td align="center" valign="top" rowspan="<c:out value='${list.PARTCNT}'/>" >
								<a href="javascript:detailVeiw('${list.READNO}');">${list.READNO}</a>
							</td>
							<td align="left" valign="top" rowspan="<c:out value='${list.PARTCNT}'/>" >${list.READNM}</td>
							<td align="left" valign="top" rowspan="<c:out value='${list.PARTCNT}'/>" >${list.ADDR}</td>
							<td align="center" valign="top" rowspan="<c:out value='${list.PARTCNT}'/>" >${list.BILLAMT}</td>
						</c:if>
						<td align="left">${list.SGYYMM}</td>
						<td align="left">${list.AMT}</td>
						<td align="center">${list.SUGM_RESULT}</td>
					</tr>
					<c:set var="prev_row"><c:out value="${list.CARD_SEQ}" /></c:set>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>
	</div>
	<%@ include file="/common/paging.jsp"  %>
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