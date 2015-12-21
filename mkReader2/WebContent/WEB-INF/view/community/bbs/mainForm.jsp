<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.security.ISiteConstant"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String admin_userid = (String) session.getAttribute(ISiteConstant.SESSION_NAME_ADMIN_USERID);
	String agency_userid 	= (String) session.getAttribute(ISiteConstant.SESSION_NAME_AGENCY_USERID);
	String login_type 	= (String) session.getAttribute(ISiteConstant.SESSION_NAME_LOGIN_TYPE);
	String loginid = (login_type.equals(ISiteConstant.LOGIN_TYPE_ADMIN)) ? admin_userid : agency_userid;
%>
<script type="text/javascript">
	// 리스트
	function mainList(){
		var frm = document.frm;
	
		frm.action = "./mainList.do";
		frm.submit();
	}
	
	function formProcess(){
		var frm = document.frm;
		if( frm.titl.value == "" ){
			alert("제목을 입력해 주세요.");
			frm.titl.focus();
			return;
		}else if( frm.cont.value == "" ){
			alert("내용을 입력해 주세요.");
			frm.cont.focus();
			return;
		}
		frm.action = "./formMainProcess.do";
		frm.submit();
	}
</script>
<div><span class="subTitle">메인알림 <c:if test="${type eq 'write'}">등록</c:if><c:if test="${type eq 'modify'}">수정</c:if></span></div>
<form id="frm" name="frm" method="post">
<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />
<input type="hidden" id="search_key" name="search_key" value="${search_key}" />
<input type="hidden" id="search_type" name="search_type" value="${search_type}" />
<input type="hidden" id="type" name="type" value="${type}" />
<input type="hidden" id="seq" name="seq" value="${seq}" />
<!-- edit -->
<div class="box_list" style="width: 1020px; margin: 0 auto; padding-top: 5px">
	<table class="tb_search" style="width: 1020px;">
		<colgroup>
			<col width="120px">
			<col width="590px">
			<col width="120px">
			<col width="190px">
		</colgroup>
		<tr>
			<th>제목</th>
			<td><input type="text" id="titl" name="titl" size="50" maxlength="500" value="${result.TITL}" /></td>
			<th>게시판구분</th>
			<td>
				<select id="typecd" name="typecd">
					<option value="3"<c:if test="${result.TYPECD eq '3'}"> selected</c:if>>직영알림</option>
					<!-- 
					<option value="4"<c:if test="${result.TYPECD eq '2'}"> selected</c:if>>직영공지</option>
					 -->
				</select>
			</td>
		</tr>
		<tr>
			<th>작성자</th>
			<td colspan="3">
				<c:choose>
				<c:when test="${type eq 'write'}">
					<c:out value="<%= loginid %>" />
					<input type="hidden" id="inps" name="inps" value="<c:out value="<%= loginid %>" />" />
				</c:when>
				<c:when test="${type eq 'modify'}">
					<c:out value="${result.INPS}" />
					<input type="hidden" id="chgps" name="chgps" value="<c:out value="<%= loginid %>" />" />
				</c:when>
				</c:choose>
			</td>
		</tr>
		<tr>
			<th>내용</th>
			<td colspan="3"><textarea name="cont" id="cont" style="width:860px; height: 150px;">${result.CONT}</textarea></td>
		</tr>
	</table>
	<!-- button -->
	<div style="text-align: right; width: 1020px; padding-top: 10px; margin: 0 auto;">
		<a href="javascript:mainList();"><img src="/images/bt_back.gif" border="0" ></a>
		<c:choose>
			<c:when test="${type eq 'write'}">
				<a href="javascript:formProcess();"><img src="/images/bt_save.gif" border="0"></a>
			</c:when>
			<c:when test="${type eq 'modify'}">
				<a href="javascript:formProcess();"><img src="/images/bt_modi.gif" border="0"></a>
			</c:when>
		</c:choose>
	</div>
	<!-- //button -->
</div>
</form>
<iframe name=TaskFrame id=TaskFrame style="width: 0; height: 0" src="about:blank" ></iframe>
			
