<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ page import="com.mkreader.security.ISiteConstant" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript">
	//페이징
	function moveTo(where, seq) {
		$("pageNo").value = seq;
		boardForm.target = "_self";
		boardForm.action = "/community/bbs/retrieveBoard.do";
		boardForm.submit();	
	}
	
	// 게시글 작성창 호출
	function write() {
		var left = (screen.width)?(screen.width - 1000)/2 : 10;
		var top = (screen.height)?(screen.height - 800)/2 : 10;
		var winStyle = "width=1000,height=800,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		var newWin = window.open("", "editor", winStyle);
		boardForm.target="editor";
		boardForm.action = "/community/bbs/popEditor.do";
		boardForm.submit();
	}

	function form(type, seq){
		$("type").value = type;
		$("seq").value = seq;
		boardForm.target = "_self";
		boardForm.action = "/community/bbs/retrieveEditor.do";
		boardForm.submit();	
	}

	function view(seq){
		$("seq").value = seq;
		boardForm.target = "_self";
		boardForm.action = "/community/bbs/viewBoard.do";
		boardForm.submit();	
	}

</script>
<div><span class="subTitle">직원게시판</span></div>
<form id="boardForm" name="boardForm" action="" method="post" enctype="multipart/form-data">
	<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />										
	<input type="hidden" id="seq" name="seq" value="" />										
	<input type="hidden" id="type" name="type" value="" />	
	<div class="box_gray" style="padding: 10px 0; width: 1020px;">
		<select id="search_type" name="search_type" style="vertical-align: middle;">
			<option value="TITLE" <c:if test="${search_type eq 'TITLE'}">selected</c:if>>제목</option>
			<option value="INPS" <c:if test="${search_type eq 'INPS'}">selected</c:if>>게시자</option>
		</select> 
		<input type="text" id="search_key" name="search_key" value="${search_key}" onkeypress="if(event.keyCode==13){javascript:moveTo('list','1');}" style="width: 150px; vertical-align: middle;" /> 
		<a href="javascript:moveTo('list','1');"><img src="/images/bt_search.gif" border="0" style="vertical-align: middle;" /></a>
	</div>									
<div class="box_list" style="padding-bottom: 0; width: 1020px; margin: 0 auto;">
	<table class="tb_list_a_5" style="width: 1020px;">
		<colgroup>
			<col width="80px">
			<col width="640px">
			<col width="80px">
			<col width="140px">
			<col width="80px">
		</colgroup>
		<tr>
			<th>번 호</th>
			<th>제 목</th>
			<th>작성자</th>
			<th>게시일</th>
			<th>조회수</th>
		</tr>
		<c:choose>
			<c:when test="${empty resultList}">
				<tr><td colspan="5">등록된 정보가 없습니다.</td></tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${resultList}" var="list" varStatus="status">
					<tr onclick="view('${list.SEQ}')"  class="mover">
						<td>${totalCount + 1 - list.RNUM}</td>
						<td align="left" >&nbsp;&nbsp;<font class="s_menu">${list.TITLE}</font></td>
						<td>${list.INPSNM}</td>
						<td>${list.INDT}</td>
						<td>${list.CNT}</td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>
	<%@ include file="/common/paging.jsp"%>
	<div style="text-align: right;"><a href="javascript:form('write')"><img src="/images/bt_insert.gif" border="0" align="right"></a></div>
</div>
</form>
