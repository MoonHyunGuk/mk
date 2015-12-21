<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript">
<!--
	function runforms1() {
		//document.forms1.target="dn"
		document.forms1.action="stat_stu_excel.do"
		document.forms1.submit();
		return;
	}
	//페이지 이동
	function moveTo(type, pageNo) {
		
		var frm = document.forms1;
	
		frm.pageNo.value = pageNo;
		frm.action = "stat_stu.do";
		frm.submit();
	}
//-->
</script>
<div><span class="subTitle">이체내역조회(학생)</span></div>
<form name="forms1" method="get" action="stat_stu.do">
<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />	
<!-- search conditions -->
<div class="box_white" style="width: 1020px; padding: 10px 0;">
	<select name="jikuk" style="vertical-align: middle;">
		<option value=''>전체</option>
		<c:forEach items="${jikukList}" var="list" varStatus="status">
			<c:if test="${not empty list.JIKUK_NAME}">
				<c:choose>
				<c:when test="${jikuk eq list.JIKUK}">
					<option value="${list.JIKUK}" selected>${list.JIKUK_NAME}</option>
				</c:when>
				<c:otherwise>
					<option value="${list.JIKUK}">${list.JIKUK_NAME}</option>
				</c:otherwise>
				</c:choose>
			</c:if>
		</c:forEach>
	</select>&nbsp;&nbsp;&nbsp;
	<input type="radio" name="chbx" value="all" style="vertical-align: middle; border: 0;" <c:if test="${chbx eq 'all'}"> checked</c:if>> 전체표시
	<input type="radio" name="chbx" value="off" style="vertical-align: middle; border: 0;" <c:if test="${chbx eq 'off'}"> checked</c:if>> 에러만 표시
	<input type="radio" name="chbx" value="on" style="vertical-align: middle; border: 0;" <c:if test="${chbx eq 'on'}"> checked</c:if>> 정상출금액만 표시
	&nbsp;&nbsp;&nbsp;
	<input type="text" name="sdate" value="<c:out value='${sdate}' />" readonly onclick="Calendar(this)" style="vertical-align: middle; width: 80px">~
	<input type="text" name="edate" value="<c:out value='${edate}' />" readonly onclick="Calendar(this)" style="vertical-align: middle; width: 80px">&nbsp;
	<a href="#fakeUrl" onclick="moveTo('1');"><img src="/images/bt_joh.gif" style="vertical-align: middle; border: 0;" alt="조회" /></a> 
	<a href="#fakeUrl" onclick="runforms1();"><img src="/images/bt_exel.gif" style="vertical-align: middle; border: 0;" alt="엑셀출력" /></a>
</div>
<!-- //search conditions -->
</form>
<!-- list -->			
<div class="box_list">	
	<table class="tb_list_a_5" style="width: 1020px">
		<colgroup>
			<col width="50px">
			<col width="150px">
			<col width="80px">
			<col width="50px">
			<col width="50px">
			<col width="380px">
			<col width="90px">
			<col width="170px">
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
				<tr><td colspan="8">등록된 정보가 없습니다.</td></tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${resultList}" var="list" varStatus="status">
					<tr>
					    <td ><c:out value="${list.JIKUK_NAME}" /></td>
						<td style="text-align: left"><a href="#fakeUrl" onclick="popMemberViewStu('${list.READNO}');"><c:out value="${list.USERNAME}" /></a></td>
						<td ><c:out value="${list.CODENUM}" /></td>
						<td><c:out value="${list.CMSDATE}" /></td>
						<td >
							<c:choose>
	                      	<c:when test="${list.CMSRESULT eq '00000'}">
	                      		<fmt:formatNumber value="${list.CMSMONEY}"  type="number" />
	                      	</c:when>
	                      	<c:otherwise>
	                      		0
	                      	</c:otherwise>
	                      	</c:choose>
						</td>
						<td style="text-align: left"><c:out value="${list.ADDR1}" /> <c:out value="${list.ADDR2}" /></td>
						<td style="text-align: left">
							<c:choose>
	                       	<c:when test="${fn:length(list.HANDY) > 5}">
	                       		<c:out value="${list.HANDY}" />
	                       	</c:when>
	                       	<c:otherwise>
	                       		<c:out value="${list.PHONE}" />
	                       	</c:otherwise>
	                       	</c:choose>
						</td>
						<td><c:out value="${list.ERR_CODE}" /></td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>
	<div style="padding-top: 10px; overflow: hidden;">
	<table class="tb_list_a_5" style="width: 400px; float: right;">
		<colgroup>
			<col width="120px">
			<col width="280px">
		</colgroup>
		<tr>
			<th>
				<c:choose>
				<c:when test="${empty jikuk}">전체 금액</c:when>
				<c:otherwise>${jikuk} 전체 금액</c:otherwise>
				</c:choose>
			</th>
			<td style="font-weight: bold;">건수 : <c:out value="${count}" /> &nbsp;&nbsp;&nbsp; 금액 : <fmt:formatNumber value="${totals}"  type="number" /></td>
		</tr>
	</table>
	</div>		
	<!-- 서치 넘버-->					
	<%@ include file="/common/paging.jsp"  %>
	<!-- 서치 넘버 끝-->
</div>

