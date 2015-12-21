<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ page import="com.mkreader.security.ISiteConstant" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script type="text/javascript">
	//수금파일 입력
	function insertSugm(){
		var f = document.generateSugmForm;

		if ( !f.sugmfile.value ) {
			alert("파일을 첨부해 주시기 바랍니다.");
			f.sugmfile.focus();
			return;
		}else{
			if(f.sugmfile.value.indexOf('xls') > -1){
				if(f.sugmfile.value.indexOf('xlsx') > -1){
					f.sugmfile.focus();
					alert('.xls 형식 파일만 입력 가능합니다.');
					return;
				}
			}else{
				f.sugmfile.focus();
				alert('.xls 형식 파일만 입력 가능합니다.');
				return;
			}
		}
		
		generateSugmForm.target="_self";
		generateSugmForm.action="/etc/generateSugm/generateSugm.do";
		generateSugmForm.submit();
	}
	
	function aaa(){
		alert(${result});
	}
</script>

<form id="generateSugmForm" name="generateSugmForm" action="" method="post" ENCTYPE="multipart/form-data">
	<table width="100%" cellpadding="0" cellspacing="0"  border="0">
		<tr bgcolor="ffffff" style="height: 30px;">
			<td style="font-weight:900; font-size:medium; font-family:fantasy;">수금 생성(임시)</td>
		</tr>	
	</table>
	<p style="top-margin:10px;">
	<table width="100%" cellpadding="5" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
		<tr bgcolor="ffffff">
			<td colspan="11" align="right">
				<table width="100%" cellpadding="5" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
					<tr bgcolor="ffffff">
						<td bgcolor="f9f9f9" align="center"><font class="b02">수금 등록</font></td>
						<td>	
							<b class="b03">* .xls 파일만 수금 등록 가능합니다.</b>	&nbsp; &nbsp; &nbsp; &nbsp;
							<a href="<%=ISiteConstant.PATH_UPLOAD_GENERATE_RESULT%>/sample.jpg" target="_blank">샘플파일 보기</a>	&nbsp; &nbsp; &nbsp; &nbsp;
							<input type="file" name="sugmfile" id="sugmfile" class="box_250" style='width:400px;'>	&nbsp; &nbsp; &nbsp; &nbsp; 
							<a href="javascript:insertSugm();"><img src="/images/bt_eepl.gif" border="0" align="absmiddle"></a>
						</td>
					</tr>
					<c:if test="${not empty result}">
						<tr>
							<td colspan="2" align="center" bgcolor="ffffff">
							<a href="javascript:aaa();"><b>---- 생성 결과 ----</b></a>
								<textarea rows="35" cols="120"><c:out value="${result}"/></textarea>
							</td>
						</tr>
					</c:if>
				</table> 
			</td>
		</tr>
	</table>
			
</form>