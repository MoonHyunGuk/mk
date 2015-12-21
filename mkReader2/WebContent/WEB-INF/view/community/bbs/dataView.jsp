<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.security.ISiteConstant"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!-- 스마트 에디터 -->
<script type="text/javascript" src="/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>

<%
	String userGb = "";
	if ( null != session.getAttribute(ISiteConstant.SESSION_NAME_ADMIN_LEVELS) ){
		userGb = (String)session.getAttribute(ISiteConstant.SESSION_NAME_ADMIN_LEVELS).toString();
	}
%>
<script type="text/javascript">
	// 리스트
	function dataList(){
		var frm = document.searchForm;

		frm.action = "./dataList.do";
		frm.submit();
	}
	function form(type){
		if( type == 'delete' ){
			if( confirm('삭제하시겠습니까?')){
			}else{
				return;
			}
		}
		var frm = document.searchForm;
		frm.type.value = type;
		frm.action = "./dataForm.do";
		frm.submit();
	
	}
		
	function downfile(file_path,file_name){
		TaskFrame.location.href = "/common/download_file.jsp?file_path=" + file_path + "&file_name=" + file_name ;
	}
</script>
<form name="searchForm" action="dataList.do" method="post">
	<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />
	<input type="hidden" id="search_key" name="search_key" value="${search_key}" />
	<input type="hidden" id="search_type" name="search_type" value="${search_type}" />
	<input type="hidden" id="seq" name="seq" value="${seq}" />
	<input type="hidden" id="type" name="type" value="" />							
</form>
<div><span class="subTitle">자료실(상세)</span></div>
<!-- edit -->
<div class="box_list">
	<table class="tb_edit_4" style="width: 1020px">
		<colgroup>
			<col width="110px">
			<col width="230px">
			<col width="110px">
			<col width="230px">
			<col width="110px">
			<col width="230px">
		</colgroup>
		<tr>
			<th>제목</th>
			<td colspan="3">${result.TITL}</td>
			<th>조회</th>
			<td>${result.CNT}</td>
		</tr>
		<tr>
			<th>작성자</th>
			<td>${result.INPS}</td>
			<th>첨부파일</th>
			<td>
				<c:choose>
					<c:when test="${empty result.FILE_PATH or empty result.REAL_FNM}">
						&nbsp;
					</c:when>
					<c:otherwise>
						<a href="javascript:downfile('${result.FILE_PATH}/','${result.SAVE_FNM}');">
							<img src="/images/ico_save_blue.png" style="vertical-align: middle; border: 0;">
							${result.REAL_FNM}
						</a>	
					</c:otherwise>
				</c:choose>
			</td>
			<th>등록일</th>
			<td>${result.INDT}</td>
		</tr>
		<tr>
			<th>내용</th>
			<td colspan="5" style="text-align: left;"><div style="padding: 10px;">${fn:replace(result.CONT, "<br>", "")}</div></td>
		</tr>
	</table>
</div>
<!-- //edit -->
<!-- button -->
<div style="text-align: right;">
	<a href="#" onclick="dataList();"><img src="/images/bt_back.gif" border="0"></a> &nbsp;
	<%
	if ("9".equals(userGb) ){
	%>
		<a href="javascript:form('modify');"><img src="/images/bt_modi.gif" border="0"></a> &nbsp;
		<a href="javascript:form('delete');"><img src="/images/bt_delete.gif" border="0"></a> &nbsp;
	<%
	}
	%>
</div>
<!-- button -->
<iframe name=TaskFrame id=TaskFrame style="width: 0; height: 0" src="about:blank"></iframe>
			
