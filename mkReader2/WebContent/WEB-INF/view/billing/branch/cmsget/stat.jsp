<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">

	function runforms1() {
		//document.forms1.target="dn"
		document.forms1.action="stat_excel.do"
		document.forms1.submit();
		return;
	}
	//페이지 이동
	function moveTo(type, pageNo) {
		
		var frm = document.forms1;
	
		frm.pageNo.value = pageNo;
		frm.action = "stat.do";
		frm.submit();
		jQuery("#prcssDiv").show();
	}
</script>
<div><span class="subTitle">이체내역조회(일반독자)</span></div>
<form name="forms1" method="get" action="stat.do">
<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />
<input type="hidden" id="jikuk" name="jikuk" value="${jikuk}" />
<!-- search conditions -->
<div class="box_white" style="padding: 10px 0; width: 1020px; margin: 0 auto;">
	<input type="radio" name="chbx" value="all" <c:if test="${chbx eq 'all'}"> checked</c:if> style="border: 0; vertical-align: middle;" />&nbsp;전체표시&nbsp;
	<input type="radio" name="chbx" value="off" <c:if test="${chbx eq 'off'}"> checked</c:if> style="border: 0; vertical-align: middle;" />&nbsp;에러만 표시&nbsp;
	<input type="radio" name="chbx" value="on" <c:if test="${chbx eq 'on'}"> checked</c:if> style="border: 0; vertical-align: middle;" />&nbsp;정상출금액만 표시&nbsp;&nbsp;&nbsp;&nbsp; 
	<input type="text" name="sdate" value="<c:out value='${sdate}' />" readonly onclick="Calendar(this)" style="vertical-align: middle; width: 85px;">&nbsp;~&nbsp; 
	<input type="text" name="edate" value="<c:out value='${edate}' />" readonly onclick="Calendar(this)" style="vertical-align: middle; width: 85px;">&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="#fakeUrl" onclick="moveTo('1');"><img src="/images/bt_joh.gif" style="vertical-align: middle; border: 0;"></a> &nbsp; 
   <a href="#fakeUrl" onclick="runforms1();"><img src="/images/bt_exel.gif" style="vertical-align: middle; border: 0;"></a> 
</div>
<!-- //search conditions -->
</form>
<!-- list -->
<div class="box_list" style="width: 1020px; margin: 0 auto;">
	<table class="tb_list_a_5" style="width: 1020px">
		<colgroup>
			<col width="65px">
			<col width="130px">
			<col width="90px">
			<col width="60px">
			<col width="55px">
			<col width="340px">
			<col width="100px">
			<col width="180px">
		</colgroup>
		<tr>
			<th>지국명</th>
			<th>독자명</th>
			<th>독자번호</th>
			<th>청구일</th>
			<th>금액</th>
			<th>주소</th>
			<th>전화번호/HP</th>
			<th>결과</th>
		</tr>
		<c:choose>
			<c:when test="${empty resultList}">
				<tr>
					<td colspan="8">등록된 정보가 없습니다.</td>
				</tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${resultList}" var="list" varStatus="status">
					<tr bgcolor="ffffff" align="center">
						<td><c:out value="${list.JIKUK_NAME}" /></td>
						<td style="text-align: left;">
							<a href="#fakeUrl" onclick="popMemberView('${list.READNO}');"><c:out value="${list.USERNAME}" /></a>
						</td>
						<td>
							<c:out value="${list.CODENUM}" /><!-- ABC 수정(2012.05.16: 박윤철 CODENUM -> READNO) -->
						</td>
						<td><c:out value="${list.CMSDATE}" /></td>
						<td>
							<c:choose>
								<c:when test="${list.CMSRESULT eq '00000'}"><fmt:formatNumber value="${list.CMSMONEY}"  type="number" /></c:when>
								<c:otherwise>0</c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: left;"><c:out value="${list.ADDR1}" /> <c:out value="${list.ADDR2}" /></td>
						<td style="text-align: left;">
							<c:choose>
								<c:when test="${fn:length(list.HANDY) > 5}"><c:out value="${list.HANDY}" /></c:when>
								<c:otherwise><c:out value="${list.PHONE}" /></c:otherwise>
							</c:choose>
						</td>
						<td><c:out value="${list.ERR_CODE}" /></td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>
	<div style="padding: 10px 0;">
		<table class="tb_search">
			<col width="510px">
			<col width="510px">
			<tr>
				<th>전체금액</th>
				<th>건수 : <c:out value="${count}" /> &nbsp;&nbsp;&nbsp; 금액 : <fmt:formatNumber value="${totals}"  type="number" /></th>
			</tr>
		</table>
	</div> 						
	<!-- 서치 넘버-->					
	<%@ include file="/common/paging.jsp"  %>
	<!-- 서치 넘버 끝-->
</div>
<!-- //list -->
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
