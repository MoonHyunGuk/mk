<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.security.ISiteConstant"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!-- 스마트 에디터 -->
<script type="text/javascript" src="/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/JavaScript">
	// 목록으로 이동
	function moveList() {
		editorForm.target = "_self";
		editorForm.action = "/community/bbs/retrieveBoard.do";
		editorForm.submit();
	}
	
	// 저장
	function save(type, seq){
		if(!validate()){
			return;
		}
		
		$("type").value = type;
		$("seq").value = seq;
		oEditors.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);
		editorForm.target = "_self";
		editorForm.action = "/community/bbs/saveCont.do";
		editorForm.submit();
	}
	
	// 벨리데이션
	function validate(){
		if($("title").value == ""){
			alert("제목은 필수 입력 입니다.")
			return false;
		}
		return true;
	}
	
	// 파일 다운로드
	function downfile(file_path,file_name){
		TaskFrame.location.href = "/common/download_file.jsp?file_path=" + file_path + "&file_name=" + file_name ;
	}
	
	// 파일 삭제
	function fileDelete(seq){
		if(confirm('파일을 삭제하시겠습니까?')){
			$("seq").value = seq;
			editorForm.action = "/community/bbs/deleteFileBoard.do";
			editorForm.submit();
		}
	}

</script>
<div><span class="subTitle">직원게시판 <c:if test="${type eq 'write'}">등록</c:if><c:if test="${type eq 'modify'}">수정</c:if></span></div>
<form id="editorForm" name="editorForm" action="" method="post" enctype="multipart/form-data">
<input type="hidden" id="seq" name="seq" value="" />										
<input type="hidden" id="type" name="type" value="" />	
	<div class="box_list"  style="width: 1020px; margin: 0 auto; padding-top: 5px">
		<table class="tb_search" style="width: 1020px;">
			<colgroup>
				<col width="120px">
				<col width="900px">
			</colgroup>
			<tr>
				<th>제 목</th>
				<td><input type="text" id="title" name="title" value="${result.TITLE}" style="width: 90%;" /></td>
			</tr>
			<tr>
				<th>작 성 자</th>
				<td>
					<c:choose>
						<c:when test="${type eq 'write'}">
							${userNm}
						</c:when>
						<c:otherwise>
							${result.INPSNM}
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr>
				<th>내용</th>
				<td>
					<textarea name="content" id="content" style="width:875px; height: 280px;">${result.CONTENTS}</textarea>
					<script type="text/javascript">
						var oEditors = [];
						nhn.husky.EZCreator.createInIFrame({
							oAppRef: oEditors,
							elPlaceHolder: "content",
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
				<th>파일첨부</th>
				<td>
					<c:choose>
						<c:when test="${empty result.FILENM}">
							<input type="file" name="fileNm" id="fileNm" class="box_250" style='width:400px;'>
						</c:when>
						<c:otherwise>
							<a href="javascript:downfile('${filePath}','${result.FILENM}')"><font style="vertical-align: top;">${result.REALNM}</font></a>
							<a href="javascript:fileDelete('${result.SEQ}');"><img src="/images/cross.gif" border="0"></a>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
		</table>
	</div>
</form>
<div style="width: 1020px; margin: 0 auto; text-align: right; padding-bottom: 20px;">
	<c:choose>
		<c:when test="${type eq 'write'}">
			<a href="javascript:save('write')"><img src="/images/bt_save.gif" border="0"></a> &nbsp;
		</c:when>
		<c:when test="${type eq 'modify' and result.INPS eq loginId }">
			<a href="javascript:save('modify', '${result.SEQ}')"><img src="/images/bt_save.gif" border="0"></a>
			<a href="javascript:save('delete', '${result.SEQ}')"><img src="/images/bt_delete.gif" border="0"></a>
		</c:when>
		<c:otherwise>
		</c:otherwise>
	</c:choose>
	<a href="javascript:moveList()"><img src="/images/bt_cancle.gif" border="0"></a> &nbsp;
</div>