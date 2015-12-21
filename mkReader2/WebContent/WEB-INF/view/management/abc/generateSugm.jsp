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
<!-- title -->
<div><span class="subTitle">수금생성(ABC)</span></div>
<!-- //title -->
<div style="width: 900px; padding-top: 10px">
	<table class="tb_search" style="width: 900px;">
		<col width="100px">
		<col width="800px">
		<tr>
			<th>수금 등록</th>
			<td>	
				<b class="b03">* .xls 파일만 수금 등록 가능합니다.</b>	&nbsp; &nbsp; &nbsp; &nbsp;
				<input type="file" name="sugmfile" id="sugmfile" style="width:400px; vertical-align: middle;">&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
				<a href="javascript:insertSugm();"><img src="/images/bt_eepl.gif" border="0" style="vertical-align: middle;"></a>
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
	<div style="text-align: right; padding: 10px 0 0 0;">
		<a href="/form/sugm_form.xls" target="_self"><span style="color: blue; font-weight: bold; text-decoration: underline;">입력폼 다운</span></a>
	</div>
	<div style="text-align: left; padding-top: 20px; width: 700px">
			<div style="font-weight: bold; padding-bottom: 5px;">[입력 예시]</div>
			<table class="tb_list_a" style="width: 700px;">
				<tr>
					<th>독자번호</th>
					<th>지국번호</th>
					<th>일렬번호</th>
					<th>신문코드</th>
					<th>수금방법</th>
					<th>수금시작월</th>
					<th>수금종료월</th>
					<th>구독부수</th>
					<th>단가</th>
					<th>구역</th>
				</tr>
				<tr>
					<td>090616767</td>
					<td>512004</td>
					<td>0001</td>
					<td>100</td>
					<td>012</td>
					<td>201201</td>
					<td>201402</td>
					<td>1</td>
					<td>15000</td>
					<td>111</td>
				</tr>
			</table>
		</div>
</div>
</form>