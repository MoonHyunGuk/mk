<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.security.ISiteConstant"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String userGb = "";
	if ( null != session.getAttribute(ISiteConstant.SESSION_NAME_ADMIN_LEVELS) ){
		userGb = (String)session.getAttribute(ISiteConstant.SESSION_NAME_ADMIN_LEVELS).toString();
	}
%>
<script type="text/javascript">
	// 페이지 이동
	function moveTo(type, pageNo) {
		
		var frm = document.searchForm;

		frm.pageNo.value = pageNo;
		frm.action = "./dataList.do";
		frm.submit();
	}
	function dataView(seq){
		var frm = document.searchForm;

		frm.seq.value = seq;
		frm.action = "./dataView.do";
		frm.submit();
	}
	function downfile(file_path,file_name){
		TaskFrame.location.href = "/common/download_file.jsp?file_path=" + file_path + "&file_name=" + file_name ;
	}
	function form(type){
		var frm = document.searchForm;
		frm.type.value = type;
		frm.action = "./dataForm.do";
		frm.submit();
	}
</script>
<div><span class="subTitle">자료실</span></div>
<!-- search conditions -->
<form name="searchForm" action="dataList.do" method="post">
<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />										
<input type="hidden" id="seq" name="seq" value="" />
<input type="hidden" id="type" name="type" value="" />
	<div class="box_gray" style="padding: 10px 0; width: 1020px;">
		<select id="search_type" name="search_type" style="vertical-align: middle;">
			<option value="TITL" <c:if test="${search_type eq 'TITL'}">selected</c:if>>제목</option>
		</select> &nbsp; 
		<input type="text" id="search_key" name="search_key" value="${search_key}" onkeypress="if(event.keyCode==13){moveTo('list','1');}" style="vertical-align: middle; width: 150px">&nbsp;  
		<a href="#fakeUrl" onclick="moveTo('list','1');"><img src="/images/bt_search.gif" style="vertical-align: middle; border: 0;"></a>
	</div>
</form>
<!-- //search conditions -->
<!-- list -->
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
			<th>번호</th>
			<th>제 목</th>
			<th>첨부</th>
			<th>등록일</th>
			<th>조회</th>												
		</tr>
		<c:choose>
			<c:when test="${empty resultList}">
			<tr>
				<td colspan="5" >등록된 정보가 없습니다.</td>
			</tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${resultList}" var="list" varStatus="status">
					<tr>
						<td>${t_count + 1 - list.RNUM}</td>
						<td style="text-align: left;">
							<div style="padding-left: 10px;"><font class="s_menu"><a href="#fakeUrl" onclick="dataView('${list.SEQ}')">${list.TITL }</a></font></div>
						</td>
						<td>
							<c:choose>
								<c:when test="${empty list.FILE_PATH or empty list.REAL_FNM}">&nbsp;</c:when>
								<c:otherwise>
									<a href="#fakeUrl" onclick="downfile('${list.FILE_PATH}/','${list.REAL_FNM}');"><img src="/images/ico_save_blue.png" style="vertical-align: middle;border: 0" alt="'${list.REAL_FNM}" /></a>	
								</c:otherwise>
							</c:choose>
						</td>
						<td>${list.INDT}</td>
						<td><fmt:formatNumber value="${list.CNT}"  type="number" /></td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>
</div>
<!-- //list -->
<!-- 서치 넘버-->					
<div><%@ include file="/common/paging.jsp"  %></div>
<!-- 서치 넘버 끝-->
<% if ("9".equals(userGb) ){ %>
	<div style="text-align: right;"><a href="#fakeUrl" onclick="form('write');"><img src="/images/bt_insert.gif" style="vertical-align: middle; border: 0;"></a> &nbsp;</div>
<% } %>
<iframe name=TaskFrame id=TaskFrame style="width: 0; height: 0" src="about:blank"></iframe>
			
