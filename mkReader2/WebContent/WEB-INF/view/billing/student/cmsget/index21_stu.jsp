<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.security.ICodeConstant" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">

	function onlyNumber()
	{
		if(
			(event.keyCode < 48 || event.keyCode > 57) 
				&& (event.keyCode < 96 || event.keyCode > 105) 
				&& event.keyCode != 8
		) {
			event.returnValue=false;
		}
	}

	function goforms() {

		var f = document.forms1;

		if ( !f.ccode.value ) {
			alert("기관식별코드를 입력해주시기 바랍니다.");
			f.ccode.focus();
			return ;
		}
		else if ( !f.eanum.value ) {
			alert("File명을 입력해주시기 바랍니다.");
			f.eanum.focus();
			return ;
		}
		else if ( !f.cbank.value ) {
			alert("주거래은행점코드를 입력해주시기 바랍니다.");
			f.cbank.focus();
			return ;
		}
		else if ( !f.cbank_num.value ) {
			alert("입금계좌번호를 입력해주시기 바랍니다.");
			f.cbank_num.focus();
			return ;
		}
		else if ( !f.rdate.value ) {
			alert("신청접수일을 입력해주시기 바랍니다.");
			f.rdate.focus();
			return ;
		}
		else if ( f.rdate.value.length != 6) {
			alert("신청접수일은 6자리(YYMMDD)로 입력해주시기 바랍니다.");
			f.rdate.focus();
			return ;
		}

		f.submit();
		jQuery("#prcssDiv").show();
	}

	// 페이지 이동
	function moveTo(type, pageNo) {
		
		var frm = document.searchForm;

		frm.pageNo.value = pageNo;
		frm.action = "/billing/student/cmsget/index21_stu.do";
		frm.submit();
	}
	
	/**
	 *  에러내용 팝업 이벤트
	 */
	function fn_popErrorView(numId, filename) {
		var width="960";
		var height="400";
		var url = "err21_stu.do?numid="+numId+"&filename="+filename;
		
		var LeftPosition=(screen.width)?(screen.width-width)/2:100;
		var TopPosition=(screen.height)?(screen.height-height)/2:100;
		
		winOpts = "scrollbars=1,toolbar=no,location=no,directories=no,width="+width+",height="+height+",resizable=no,left="+LeftPosition+",top="+TopPosition;
		var obj = window.open(url,'errorView',winOpts);
	}
</script>
<div><span class="subTitle">이체청구(학생)</span>
</div>
<form name="forms1" method="post" action="process21b_stu.do" onsubmit="return goforms();"> 
<!-- search conditions --> 
<table class="tb_search" style="width: 1020px">
	<colgroup>
		<col width="120px">
		<col width="130px">
		<col width="120px">
		<col width="130px">
		<col width="120px">
		<col width="130px">
		<col width="120px">
		<col width="150px">
	</colgroup>
	<tr>
		<th>기관식별코드</th>
		<td><input type="text" maxlength="10" name="ccode" style="width: 100px;" value="<%= ICodeConstant.MK_COMPANY_CODE %>" onkeydown="return onlyNumber();"></td>
		<th>File명</th>
		<td><input type="text" maxlength="4" name="eanum" style="width: 100px;" value="EB21" readonly></td>
		<th>주거래은행점코드</th>
		<td><input type="text" maxlength="7" name="cbank" style="width: 100px;" value="<%= ICodeConstant.MK_MAIN_BANK_NUMBER %>" onkeydown="return onlyNumber();"></td>
		<th>입금계좌번호</th>
		<td><input type="text" maxlength="16" name="cbank_num" style="width: 120px;" value="<%= ICodeConstant.MK_ACCOUNT_NUMBER %>" onkeydown="return onlyNumber();"></td>
	</tr>
	<tr>
		<th>신청 접수일</th>
		<td colspan="3"><input type="text" maxlength="6" name="rdate" style="width: 85px;" onkeydown="return onlyNumber();"> 예) 050815 <-2005년 8월 15일&nbsp; &nbsp; &nbsp; &nbsp;</td>
		<th>출금일선택</th>
		<td colspan="3">
			<select name="sdate" style="vertical-align: middle;">
				<option value="05">5일</option>
				<!-- <option value="17">17일</option> -->
			</select>&nbsp;
			<a href="#fakeUrl" onclick="goforms();"><img src="/images/bt_eepl.gif" style="border: 0; vertical-align: middle;" alt="입력"></a> &nbsp; 
		<!-- <a href="#"><img src="/images/bt_cancle.gif" border="0" align="absmiddle"></a> -->
		</td>
	</tr>			 			 						 						 						 								 						 		
</table>
<!-- //search conditions --> 
</form>
<!-- list -->
<div style="width: 1020px; margin: 0 auto; padding-top: 15px;">
	<table class="tb_list_a_5" style="width: 1020px">
		<colgroup>
			<col width="120px">
			<col width="180px">
			<col width="160px">
			<col width="70px">
			<col width="140px">
			<col width="130px">
			<col width="130px">
			<col width="90px">
		</colgroup>
	 	<tr>
		    <th>일련번호</th>
			<th>데이터 생성일</th>
			<th>생성 파일명</th>
			<th>건수</th>
			<th>금액</th>
			<th>에러내용</th>
			<th>처리자</th>
			<th>엑셀다운</th>
		</tr>
		<c:choose>
			<c:when test="${t_count == 0}">
				<tr><td colspan="8">등록된 정보가 없습니다.</td></tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${resultList}" var="list" varStatus="status">
					<c:choose>
					<c:when test="${fn:substring(list.MEMO, 19, 20) == 'E'}">
						<c:set var="filename" value="${fn:substring(list.MEMO, 19, 27)}" />
					</c:when>
					<c:otherwise>
						<c:set var="filename" value="${fn:substring(list.MEMO, 20, 28)}" />
					</c:otherwise>
					</c:choose>
	                <tr>
	                    <td><a href="view21_stu.do?numid=${list.NUMID}&fname=${filename}"><c:out value="${list.NUMID}" /></a></td>
	                    <td><c:out value="${list.LOGDATE}" /></td>
	                    <td><a href="view21_stu.do?numid=${list.NUMID}&fname=${filename}"><c:out value="${filename}" /></a></td>
	                    <td>
	                        <c:choose>
	                        <c:when test="${not empty list.COUNTS}"><fmt:formatNumber value="${fn:trim(list.COUNTS)}" type="number" /></c:when>
	                        <c:otherwise>0</c:otherwise>
	                        </c:choose>
	                    </td>
	                    <td>
	                       	<c:choose>
	                       	<c:when test="${not empty list.MONEY}"><fmt:formatNumber value="${fn:trim(list.MONEY)}" type="number" /></c:when>
	                       	<c:otherwise>0</c:otherwise>
	                       	</c:choose>
	                    </td>
	                    <td><a href="#fakeUrl" onclick="fn_popErrorView('${list.NUMID}','${filename}')"><c:out value="${filename}" /></a></td>
						<td><c:out value="${list.ADMINID}" /></td>
						<td><a href="process21b_stu_excel.do?numid=${list.NUMID}&fname=${filename}">다운</a></td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>
	<!-- 서치 넘버-->					
	<%@ include file="/common/paging.jsp"  %>
	<!-- 서치 넘버 끝-->
	<div style="width: 1020px; text-align: center; font-weight: bold;">총 <font class="b03">${t_count}개</font>의 결과가 검색 되었습니다.</div>
</div>
<form name="searchForm" action="index21_stu.do" method="get">
	<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />
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
