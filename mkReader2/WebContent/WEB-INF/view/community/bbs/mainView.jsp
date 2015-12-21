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
	// 리스트
	function noticeList(){
		var frm = document.searchForm;

		frm.action = "./mainList.do";
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
		frm.action = "./mainForm.do";
		frm.submit();
	
	}
		
	function downfile(file_path,file_name){
		TaskFrame.location.href = "/common/download_file.jsp?file_path=" + file_path + "&file_name=" + file_name ;
	}
</script>
<div><span class="subTitle">메인알림 상세보기</span></div>
<form name="searchForm" action="mainList.do" method="post">
<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />
<input type="hidden" id="search_key" name="search_key" value="${search_key}" />
<input type="hidden" id="search_type" name="search_type" value="${search_type}" />
<input type="hidden" id="seq" name="seq" value="${seq}" />
<input type="hidden" id="type" name="type" value="" />	
<!-- edit -->
<div class="box_list" style="width: 1020px; margin: 0 auto; padding-top: 5px;">
	<table class="tb_search" style="width: 1020px;">
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
						<img src="/images/ic_disk.gif" border="0" align="absmiddle">
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
			<td colspan="5">
				${result.CONT}
			</td>
		</tr>
	</table>
	<!-- button -->
	<div style="text-align: right; width: 1020px; padding-top: 10px; margin: 0 auto;">
		<a href="#" onclick="noticeList();"><img src="/images/bt_back.gif" border="0"></a> &nbsp;
		<%
		if ("9".equals(userGb) ){
		%>
			<a href="javascript:form('modify');"><img src="/images/bt_modi.gif" border="0"></a>
			<a href="javascript:form('delete');"><img src="/images/bt_delete.gif" border="0"></a>
		<%
		}
		%>
	</div>
	<!-- //button -->
</div>
<!-- //edit -->
</form>
	
<iframe name=TaskFrame id=TaskFrame style="width: 0; height: 0" src="about:blank" frameBorder=0></iframe>
			
