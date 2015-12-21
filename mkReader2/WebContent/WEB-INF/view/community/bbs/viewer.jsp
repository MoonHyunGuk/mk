<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.security.ISiteConstant"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script type="text/JavaScript">
	// 목록으로 이동
	function moveList() {
		viewerForm.target = "_self";
		viewerForm.action = "/community/bbs/retrieveBoard.do";
		viewerForm.submit();
	}

	// 수정
	function form(type, seq){
		$("type").value = type;
		$("seq").value = seq;
		viewerForm.target = "_self";
		if(type == "delete"){
			if(!confirm("게시물을 삭제 하시겠습니까?")){
				return;
			}else{
				viewerForm.action = "/community/bbs/saveCont.do";
			}
		}else{
			viewerForm.action = "/community/bbs/retrieveEditor.do";
		}
		viewerForm.submit();
	}

	// 파일다운로드
	function downfile(file_path,file_name){
		TaskFrame.location.href = "/common/download_file.jsp?file_path=" + file_path + "&file_name=" + file_name ;
	}
</script>

<form id="viewerForm" name="viewerForm" action="" method="post" enctype="multipart/form-data">
	<input type="hidden" id="seq" name="seq" value="" />
	<input type="hidden" id="type" name="type" value="" />

	<table width="100%" cellpadding="0" cellspacing="0"  border="0">
		<tr bgcolor="ffffff">
			<td><img src="/images/tt_sub07_03.gif" border="0" align="absmiddle"></td>
		</tr>
	</table>

	<table width="100%" cellpadding="10" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01" style="margin-top: 10px;">
		<colgroup>
			<col width="10%" />
			<col width="52%" />
			<col width="10%" />
			<col width="10%" />
			<col width="10%" />
			<col width="8%"/>
		</colgroup>
		<tr bgcolor="f9f9f9" align="center" class="box_p">
			<td>작 성 자</td>
			<td bgcolor="ffffff" align="left">${result.INPSNM}</td>
			<td>작 성 일</td>
			<td bgcolor="ffffff" align="left">${result.INDT}</td>
			<td>조 회 수</td>
			<td bgcolor="ffffff" align="center">${result.CNT}</td>
		</tr>
		<tr bgcolor="f9f9f9" align="center" class="box_p">
			<td>제 목</td>
			<td colspan="5" bgcolor="ffffff" align="left">${result.TITLE}</td>
		</tr>
		<tr bgcolor="f9f9f9" align="center" class="box_p">
			<td>내 용</td>
			<td colspan="5" bgcolor="ffffff" align="left" style="line-height : 30%; margin-top: 10px;">${result.CONTENTS}</td>
		</tr>
		<tr bgcolor="f9f9f9" align="center" class="box_p">
			<td>첨부파일</td>
			<td colspan="5" align="left" bgcolor="ffffff">
				<c:if test="${not empty result.REALNM}">
					<a href="javascript:downfile('${filePath}','${result.FILENM}')">
						<img src="/images/ic_disk.gif" border="0" align="absmiddle">
						${result.REALNM}
					</a>
				</c:if>
			</td>
		</tr>
	</table>
	
	<table width="100%" cellpadding="0" cellspacing="0" border="0" style="margin-top: 10px;">
	<tr>
		<td height="50" align="right">
			<c:if test="${loginId eq result.INPS}">
				<a href="javascript:form('modify','${result.SEQ}');"><img src="/images/bt_modi.gif" border="0"></a> &nbsp;
				<a href="javascript:form('delete','${result.SEQ}');"><img src="/images/bt_delete.gif" border="0"></a> &nbsp;
			</c:if>
			<a href="javascript:moveList()"><img src="/images/bt_back.gif" border="0"></a> &nbsp;
		</td>
	</tr>
</table>

</form>

<IFRAME name=TaskFrame id=TaskFrame style="WIDTH: 0; HEIGHT: 0" src="about:blank" frameBorder=0></IFRAME>