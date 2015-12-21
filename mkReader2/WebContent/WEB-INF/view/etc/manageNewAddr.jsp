<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ page import="com.mkreader.security.ISiteConstant" %>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
	// 새주소 파일 업로드
	function uploadFile(){
		
		// 파일첨부 확인
		if(!$("newAddrDataFile").value) {
			$("newAddrDataFile").focus();
			alert("파일을 첨부해 주시기 바랍니다.");
			return;
		}else if($("newAddrDataFile").value.indexOf(".txt") < -1){
			$("newAddrDataFile").focus();
			alert(".txt 형식의 파일만 입력 가능합니다.");
			return;
		}

		$("insertNewAddrForm").target = "_self";
		$("insertNewAddrForm").action = "/management/adminManage/insertNewAddrDataFile.do";
		$("insertNewAddrForm").submit() ;
		jQuery("#prcssDiv").show();
	}
</script>
<title>새주소 데이터 입력</title>
<!-- 타이틀 DIV -->
<div style="padding-left: 5px; padding-bottom: 5px;"> 
	<span class="subTitle">새주소 데이터 입력</span>
</div>
<!--// 타이틀 DIV -->

<!-- 새주소 입력 폼 -->
<form id="insertNewAddrForm" name="insertNewAddrForm" action="" method="post" enctype="multipart/form-data">
	<c:if test="${loginType eq 'A'}">
		<table class="tb_edit_left" style="margin-top: 5px; width: 800px;">
			<tr>
				<th>파일업로드</th>
				<td>
					<input type="file" name="newAddrDataFile" id="newAddrDataFile" style="width: 500px; vertical-align: middle;"> 
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="javascript:uploadFile();"><img src="/images/bt_eepl.gif" style="vertical-align: middle;"></a>
				</td>
			</tr>
		</table>
	</c:if>
</form>
<div style="width: 800px;">
	<div style="padding: 10px 0; font-weight: bold; color: blue; text-align: right;">
		<a href="http://www.juso.go.kr/support/AddressBuild.do" target="_blank"><u>전체주소 다운받기</u></a>
	</div>
	<div style="color: red; text-align: right;">※ 전체주소 파일을 다운받으면 됨</div>
</div>
<!--// 새주소 입력 폼 -->
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