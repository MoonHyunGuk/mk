<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.security.ICodeConstant" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
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

	// 페이지 이동
	function moveTo(type, pageNo) {
		
		var frm = document.searchForm;

		frm.pageNo.value = pageNo;
		frm.action = "/billing/zadmin/cmsbank/index12.do";
		frm.submit();
	}
	
	/**
	 *  에러내용 팝업 이벤트
	 */
	function fn_popErrorView(numId, filename) {
		var width="960";
		var height="400";
		var url = "err12.do?numid="+numId+"&filename="+filename;

		var LeftPosition=(screen.width)?(screen.width-width)/2:100;
		var TopPosition=(screen.height)?(screen.height-height)/2:100;
		
		winOpts = "scrollbars=1,toolbar=no,location=no,directories=no,width="+width+",height="+height+",resizable=no,left="+LeftPosition+",top="+TopPosition;
		var obj = window.open(url,'errorView',winOpts);
	}
</script>
<div><span class="subTitle">은행신청결과(일반)</span></div>
<form name="forms1" method="post" >
<!-- list -->	
<table class="tb_list_a_5" style="width: 1020px">
	<tr>
		<th>일련번호</th>
		<th>데이터 생성일</th>
		<th>생성 파일명</th>
		<th>에러내용</th>
		<th>처리자</th>
		<th>&nbsp;</th>
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
			<tr>
			    <td><a href="view12.do?numid=${list.NUMID}&fname=${filename}"><c:out value="${list.NUMID}" /></a></td>
				<td><c:out value="${list.LOGDATE}" /></td>
				<td><a href="view12.do?numid=${list.NUMID}&fname=${filename}"><c:out value="${filename}" /></a></td>
				<td><a href="#fakeUrl" onclick="fn_popErrorView('${list.NUMID}','${filename}');"><c:out value="${filename}" /></a></td>
				<td><c:out value="${list.ADMINID}" /></td>
				<td>&nbsp;</td>
			</tr>
			</c:forEach>
		</c:otherwise>
	</c:choose>
</table>
<!-- //list -->	
<!-- 서치 넘버-->					
<%@ include file="/common/paging.jsp"  %>
<!-- 서치 넘버 끝-->
<div style="width: 1020px; text-align: center; font-weight: bold;">	총 <font class="b03">${t_count}개</font>의 결과가 검색 되었습니다.</div>
</form>
<form name="searchForm" action="index.do" method="get">
	<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />
</form>



