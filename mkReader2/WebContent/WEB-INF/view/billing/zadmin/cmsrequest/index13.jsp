<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.security.ICodeConstant" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
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
		frm.action = "/billing/zadmin/cmsrequest/index13.do";
		frm.submit();
	}
	
	
	/**
	 *  에러내용 팝업 이벤트
	 */
	function fn_popErrorView(numId, filename) {
		var width="960";
		var height="400";
		var url = "err13.do?numid="+numId+"&filename="+filename;

		var LeftPosition=(screen.width)?(screen.width-width)/2:100;
		var TopPosition=(screen.height)?(screen.height-height)/2:100;
		
		winOpts = "scrollbars=1,toolbar=no,location=no,directories=no,width="+width+",height="+height+",resizable=no,left="+LeftPosition+",top="+TopPosition;
		var obj = window.open(url,'errorView',winOpts);
	}
</script>
<div><span class="subTitle">이체신청(일반)</span></div>
<form name="forms1" method="post" action="process13b.do">
<!-- search conditions -->
<table class="tb_search" style="width: 1020px">
	<colgroup>
		<col width="120px">
		<col width="130px">
		<col width="120px">
		<col width="130px">
		<col width="120px">
		<col width="400px">
	</colgroup>
	<tr>
		<th>기관식별코드</th>
		<td><input type="text" maxlength="10" name="ccode" value="<%= ICodeConstant.MK_COMPANY_CODE %>" onkeydown="onlyNumber();" style="width: 90px;"></td>	
		<th>File명</th>
		<td><input type="text" maxlength="4" name="eanum" value="EB13" readonly="readonly" style="width: 90px; border: 0;"></td>
		<th>신청접수일</th>
		<td>
			<input type="text" maxlength="6" name="rdate" onkeydown="onlyNumber();" style="width: 100px;vertical-align: middle;">&nbsp;<b>예)060815</b>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="#fakeUrl" onclick="goforms();"><img src="/images/bt_eepl.gif" style="border: 0; vertical-align: middle;" alt="입력"></a>&nbsp;
			<!-- 
			<a href="#fakeUrl" onclick="reset();">
			<img src="/images/bt_cancle.gif" border="0" align="absmiddle"> 
			</a>
			-->
		</td>
	</tr>
</table>
<!-- //search conditions -->
<!-- list -->
<div style="width: 1020px; margin: 0 auto; padding-top: 15px;">
	<table class="tb_list_a_5" style="width: 1020px">
		<colgroup>
		 	<col width="180px">
		 	<col width="250px">
		 	<col width="230px">
		 	<col width="180px">
		 	<col width="180px">
		</colgroup>
		<tr>
		    <th>일련번호</th>
			<th>데이터 생성일</th>
			<th>생성 파일명</th>
			<th>에러내용</th>
			<th>처리자</th>
		</tr>
		<c:choose>
			<c:when test="${empty resultList}">
				<tr><td colspan="6">등록된 정보가 없습니다.</td></tr>
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
					<tr class="mover_color">
					    <td><a href="view13.do?numid=${list.NUMID}&fname=${filename}"><c:out value="${list.NUMID}" /></a></td>
						<td><c:out value="${list.LOGDATE}" /></td>
						<td><a href="view13.do?numid=${list.NUMID}&fname=${filename}"><c:out value="${filename}" /></a></td>
						<td><a href="#fakeUrl" onclick="fn_popErrorView('${list.NUMID}', '${filename}');"><c:out value="${filename}" /></a></td>
						<td><c:out value="${list.ADMINID}" /></td>
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
</form>
<form name="searchForm" action="index.do" method="get">
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

