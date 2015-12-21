<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" type="text/css" href="/css/addStyle.css">
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
function fn_insertJidae() {
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
	fm.action = "/management/jidae/jidaeExcelUploadForDirect.do";
	fm.submit();
	jQuery("#prcssDiv").show();
}
</script>
<div style="padding-bottom: 5px;"><span class="subTitle">지대입력(엑셀) - 1팀</span></div>
<form id= "fm" name = "fm" method="post" ENCTYPE="multipart/form-data">
<div style="width: 900px; padding-top: 10px">
	<table class="tb_search" style="width: 900px;">
		<col width="100px">
		<col width="800px">
		<tr>
			<th>지대통지서입력</th>
			<td>	
				<b class="b03">* .xls 파일만 수금 등록 가능합니다.</b>	&nbsp; &nbsp; &nbsp; &nbsp;
				<input type="file" name="readerfile" id="readerfile" style="width:400px; vertical-align: middle;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
				<a href="#fakeUrl" onclick="fn_insertJidae();"><img src="/images/bt_eepl.gif" border="0" style="vertical-align: middle;"/></a>
			</td>
		</tr> 
	</table> 
	<div style="text-align: left; padding-top: 20px; width: 1000px;">
		<div style="font-weight: bold; padding-bottom: 5px;">[입력 순번]</div>
		<div><img src="/images/jidae_no1.jpg" style="width: 1000px; vertical-align: middle;" /></div>
		<!-- 
		<table class="tb_list_a" style="width: 910px;"> 
			<colgroup>
				<col width="50px">
				<col width="50px">
				<col width="50px">
				<col width="50px">
				<col width="50px">
				<col width="50px">
				<col width="60px">
				<col width="50px">
				<col width="50px">
				<col width="50px">
				<col width="50px">
				<col width="50px">
				<col width="50px">
				<col width="50px">
				<col width="50px">
				<col width="50px">
				<col width="50px">
				<col width="50px"> 
			</colgroup>
			<tr>
				<td>1</td>
				<td>2</td>
				<td>3</td>
				<td>4</td>
				<td>5</td>
				<td>6</td>
				<td>7</td>
				<td>8</td>
				<td>9</td>
				<td>10</td>
				<td>11</td>
				<td>12</td>
				<td>13</td>
				<td>14</td>
				<td>15</td>
				<td>16</td>
				<td>17</td>
				<td>18</td>
			</tr>
			<tr>
				<th>지국<br/>번호</th>
				<th>지국명</th>
				<th>월분</th>
				<th>조정<br/>금액</th>
				<th>판매<br/>수수료</th>
				<th>배달<br/>장려금</th>
				<th>부수유지<br/>장려금</th>
				<th>교육용</th>
				<th>카드</th>
				<th>자동<br/>이체</th>
				<th>학생<br/>배달</th>
				<th>소외<br/>계층</th>
				<th>본사<br/>사원</th>
				<th>통장</th>
				<th>지로</th>
				<th>지대</th>
				<th>이코<br/>노미</th>
				<th>씨티</th>
			</tr>
		</table>
		 -->
	</div>
</div>
</form>
<br/>
<!-- processing viewer -->
<div id="prcssDiv"  class="loingProcessDiv"><div><img src="/images/process4.gif"/></div></div>
<script type="text/javascript">
/** Jquery setting */
jQuery.noConflict();
jQuery(document).ready(function($) {
	$("#prcssDiv").hide();
});
</script>
<!-- //processing viewer --> 