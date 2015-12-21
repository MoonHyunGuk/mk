<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ page import="com.mkreader.security.ISiteConstant" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript">
	function fn_insertSugm() {
		var fm = document.getElementById("fm");
		var fileVal = document.getElementById("readerfile");
		
		if ( !fileVal.value ) {
			alert("파일을 첨부해 주시기 바랍니다.");
			fileVal.focus();
			return;
		}else{
			if(fileVal.value.indexOf('xls') > -1){
				if(fileVal.value.indexOf('xlsx') > -1){
					fileVal.focus();
					alert('.xls 형식 파일만 입력 가능합니다.');
					return;
				}
			}else{
				fileVal.focus();
				alert('.xls 형식 파일만 입력 가능합니다.');
				return;
			}
		}
		
		fm.target = "_self";
		fm.action = "/management/abc/insertABCReaderList.do";
		fm.submit();
	}
</script>
<form id="fm" name="fm" action="" method="post" ENCTYPE="multipart/form-data">
<!-- title -->
<div><span class="subTitle">독자입력(ABC용)</span></div>
<!-- //title -->
<div style="width: 900px; padding-top: 10px">
	<table class="tb_search" style="width: 900px;">
		<col width="100px">
		<col width="800px">
		<tr>
			<th>독자입력</th>
			<td>	
				<b class="b03">* .xls 파일만 수금 등록 가능합니다.</b>	&nbsp; &nbsp; &nbsp; &nbsp;
				<input type="file" name="readerfile" id="readerfile" style="width:400px; vertical-align: middle;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
				<a href="#fakeUrl" onclick="fn_insertSugm();"><img src="/images/bt_eepl.gif" border="0" style="vertical-align: middle;"/></a>
			</td>
		</tr>
	</table> 
	<div style="text-align: right; padding: 10px 0 0 0;">
		<a href="/form/insert_form.xls" target="_self"><span style="color: blue; font-weight: bold; text-decoration: underline;">입력폼 다운</span></a>
	</div>
	<div style="text-align: left; padding-top: 20px; width: 840px">
		<div style="font-weight: bold; padding-bottom: 5px;">[입력 예시]</div>
		<table class="tb_list_a" style="width: 840px;">
			<tr>
				<th>구역</th>
				<th>순번</th>
				<th>독자번호</th>
				<th>독자명</th>
				<th>전화번호</th>
				<th>핸드폰</th>
				<th>우편번호</th>
				<th>주소</th>
				<th>상세주소</th>
				<th>신문명</th>
				<th>확장일</th>
				<th>구독부수</th>
				<th>단가</th>
				<th>수금방법</th>
				<th>지국번호</th>
				<th>비고</th>
			</tr>
			<tr>
				<td>101</td>
				<td>001</td>
				<td style="color: red">미입력</td>
				<td>홍길동</td>
				<td>02-123-0001</td>
				<td>010-1234-5678</td>
				<td>156090</td>
				<td>서울 중구 필동1가</td>
				<td>30-1</td>
				<td>매경</td>
				<td>20110201</td>
				<td>1</td>
				<td>15000</td>
				<td>통장</td>
				<td>511011</td>
				<td>비고</td>
			</tr>
		</table>
	</div>
</div>
</form>