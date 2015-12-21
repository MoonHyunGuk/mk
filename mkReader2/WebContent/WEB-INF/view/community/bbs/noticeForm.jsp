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
<!-- 스마트 에디터 -->
<script type="text/javascript" src="/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">
	// 리스트
	function noticeList(){
		var frm = document.frm;
	
		frm.action = "./noticeList.do";
		frm.submit();
	}
	
	function formProcess(){
		var frm = document.getElementById("frm");
		var title = document.getElementById("titl");
		var cont = document.getElementById("cont");

		oEditors.getById["cont"].exec("UPDATE_CONTENTS_FIELD", []);

		if( title.value == "" ){
			alert("제목을 입력해 주세요.");
			title.focus();
			return;
		}else if(cont.value == "" ){
			alert("내용을 입력해 주세요.");
			cont.focus();
			return;
		}
		
		frm.target = "_self";
		frm.action = "./formProcess.do";
		frm.submit();
	}
	
	function downfile(file_path,file_name){
		TaskFrame.location.href = "/common/download_file.jsp?file_path=" + file_path + "&file_name=" + file_name ;
	}
	
	function fileDelete(){
		var frm = document.frm;
		if(confirm('파일을 삭제하시겠습니까?')){
			frm.action = "./fileDelete.do";
			frm.submit();
		}
	}
</script>
<div><span class="subTitle">공지사항 <c:if test="${type eq 'write'}">등록</c:if><c:if test="${type eq 'modify'}">수정</c:if></span></div>
<form id="frm" name="frm" method="post" enctype="multipart/form-data">
<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />
<input type="hidden" id="search_key" name="search_key" value="${search_key}" />
<input type="hidden" id="search_type" name="search_type" value="${search_type}" />
<input type="hidden" id="type" name="type" value="${type}" />
<input type="hidden" id="seq" name="seq" value="${seq}" />
<!-- edit -->
<div class="box_list">
	<table class="tb_search" style="width: 1020px;">
		<colgroup>
			<col width="120px">
			<col width="590px">
			<col width="120px">
			<col width="190px">
		</colgroup>
		<tr>
			<th>제목</th>
			<td>
				<input type="text" id="titl" name="titl" style="width: 80%" maxlength="500" value="${result.TITL}" />
			</td>
			<th>게시판구분</th>
			<td>
				<select id="typecd" name="typecd">
					<option value="1"<c:if test="${result.TYPECD eq '1'}"> selected</c:if>>전체공지</option>
					<option value="2"<c:if test="${result.TYPECD eq '2'}"> selected</c:if>>직영공지</option>
					<option value="5"<c:if test="${result.TYPECD eq '5'}"> selected</c:if>>청약공지</option>
					<option value="6"<c:if test="${result.TYPECD eq '6'}"> selected</c:if>>지방공지</option>
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
			<td colspan="3">
				<textarea name="cont" id="cont" style="width:875px; height: 400px;">${result.CONT}</textarea>
				<script type="text/javascript">
					var oEditors = [];
					nhn.husky.EZCreator.createInIFrame({
						oAppRef: oEditors,
						elPlaceHolder: "cont",
						sSkinURI: "/smarteditor/SmartEditor2Skin.html",
						fCreator: "createSEditor2",
						htParams :{fOnBeforeUnload : function(){}} 
					});
				</script>
			</td>
		</tr>
		<tr>
			<td>첨부파일</td>
			<td colspan="3">
				<input type="file" name="save_fnm" style="width:400px;">	&nbsp; &nbsp; &nbsp; &nbsp; 
				<c:choose>
				<c:when test="${empty result.FILE_PATH or empty result.REAL_FNM}">
					&nbsp;
				</c:when>
				<c:otherwise>
					<a href="#fakeUrl" onclick="downfile('${result.FILE_PATH}/','${result.REAL_FNM}');">
						<img src="/images/ico_save_blue.png" style="border: 0; vertical-align: middle;" />
						${result.SAVE_FNM} &nbsp;
					</a>
					<a href="#fakeUrl" onclick="fileDelete();;"><img src="/images/cross.gif"" border="0" alt="삭제" style="vertical-align: middle;"></a>	
				</c:otherwise>
				</c:choose>
			</td>
		</tr>
	</table>
	<!-- button -->
	<div style="text-align: right; width: 1020px; padding-top: 10px;">
		<a href="#fakeUrl" onclick="noticeList();"><img src="/images/bt_back.gif" style="vertical-align: middle; border: 0;" alt="돌아가기" /></a>
		<c:choose>
		<c:when test="${type eq 'write'}">
			&nbsp;<a href="#fakeUrl" onclick="formProcess();"><img src="/images/bt_save.gif" style="vertical-align: middle; border: 0;" alt="저장" /></a> 
		</c:when>
		<c:when test="${type eq 'modify'}">
			&nbsp;<a href="#fakeUrl" onclick="formProcess();"><img src="/images/bt_modi.gif" style="vertical-align: middle; border: 0;" alt="수정" /></a> 
		</c:when>
		</c:choose>
	</div>
	<!-- //button -->
</div>
</form>
<!-- //edit -->
	
<iframe name=TaskFrame id=TaskFrame style="width: 0; height: 0" src="about:blank" frameBorder=0></iframe>
			
