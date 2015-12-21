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
<script type="text/javascript" >
	// 리스트
	function dataList(){
		var frm = document.frm;
	
		frm.action = "./dataList.do";
		frm.submit();
	}
	
	function formProcess(){
		
		oEditors.getById["cont"].exec("UPDATE_CONTENTS_FIELD", []);

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
		frm.action = "./dataProcess.do";
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
<div><span class="subTitle">자료실 <c:if test="${type eq 'write'}">등록</c:if><c:if test="${type eq 'modify'}">수정</c:if></span></div>
<form id="frm" name="frm" method="post" enctype="multipart/form-data">
<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />
<input type="hidden" id="search_key" name="search_key" value="${search_key}" />
<input type="hidden" id="search_type" name="search_type" value="${search_type}" />
<input type="hidden" id="type" name="type" value="${type}" />
<input type="hidden" id="seq" name="seq" value="${seq}" />
<!-- edit -->
<div class="box_list" style="padding-top: 5px; width: 1020px; margin: 0 auto;">
	<table class="tb_search" style="width: 1020px;">
		<colgroup>
			<col width="120px">
			<col width="590px">
			<col width="120px">
			<col width="190px">
		</colgroup>
			<tr>
				<th>제목</th>
				<td colspan="3">
					<input type="text" id="titl" name="titl" size="50" maxlength="500" value="${result.TITL}" />
				</td>
				<th>게시판구분</th>
				<td>
					<select id="typecd" name="typecd">
						<option value="1"<c:if test="${result.TYPECD eq '1'}"> selected</c:if>>전체공지</option>
						<option value="2"<c:if test="${result.TYPECD eq '2'}"> selected</c:if>>직영공지</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>작성자</th>
				<td colspan="5">
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
				<td colspan="5">
					<textarea name="cont" id="cont" style="width:875px; height: 350px;">${result.CONT}</textarea>
					<script type="text/javascript">
						var oEditors = [];
						nhn.husky.EZCreator.createInIFrame({
							oAppRef: oEditors,
							elPlaceHolder: "cont",
							sSkinURI: "/smarteditor/SmartEditor2Skin.html",
							fCreator: "createSEditor2",
							htParams :{fOnBeforeUnload : function(){
				                      								}
				            		  } 
						});
					</script>
				</td>
			</tr>
			<tr>
				<th>첨부파일</th>
				<td colspan="5">
					<input type="file" name="save_fnm" class="box_250" style="width:400px;">	&nbsp; &nbsp; &nbsp; &nbsp; 
					<c:choose>
					<c:when test="${empty result.FILE_PATH or empty result.REAL_FNM}">
						&nbsp;
					</c:when>
					<c:otherwise>
						<a href="#fakeUrl" onclick="downfile('${result.FILE_PATH}/','${result.REAL_FNM}');">
							<img src="/images/ico_save_blue.png" style="vertical-align: middle;" />
							${result.SAVE_FNM} &nbsp;
						</a>	
						<a href="#fakeUrl" onclick="fileDelete();"><img src="/images/cross.gif" border="0" style="vertical-align: middle;" /></a>
					</c:otherwise>
					</c:choose>
				</td>
			</tr>
		</table>
	</div>
	<!-- button -->
	<div style="text-align: right; width: 1020px; padding-bottom: 20px; margin: 0 auto;">
		<a href="#fakeUrl" onclick="dataList();"><img src="/images/bt_back.gif" border="0" ></a>
		<c:choose>
		<c:when test="${type eq 'write'}">
			<a href="#fakeUrl" onclick="formProcess();"><img src="/images/bt_save.gif" border="0"></a>
		</c:when>
		<c:when test="${type eq 'modify'}">
			<a href="#fakeUrl" onclick="formProcess();"><img src="/images/bt_modi.gif" border="0"></a>
		</c:when>
		</c:choose>
	</div>
</form>
	
<iframe name=TaskFrame id=TaskFrame style="width: 0; height: 0" src="about:blank" frameBorder="0"></iframe>
			
