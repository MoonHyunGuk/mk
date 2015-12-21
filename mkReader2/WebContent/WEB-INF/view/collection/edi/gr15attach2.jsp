<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
	function goforms() {
	
		var f = document.forms1;
		
		if ( !f.edifile.value ) {
			alert("파일을 첨부해 주시기 바랍니다.");
			f.edifile.focus();
			return;
		}
		f.submit();
		jQuery("#prcssDiv").show();
	}
</script>
<div><span class="subTitle">타 지로 엑셀다운</span></div>
<form name="forms1" method="post" action="gr15process2_excel.do" enctype="multipart/form-data">
<div>
	<table class="tb_search" style="width: 1020px;">
		<colgroup>
			<col width="220px;">
			<col width="800px;">
		</colgroup>
		<tr>
			<th>EDI file(GR15)</th>
			<td style="text-align: left; padding-left: 10px;">
				<input type="file" name="edifile" class="box_250" style="width:400px; vertical-align: middle;">
			 	<img src="/images/bt_eepl.gif" style="vertical-align: middle; border: 0; cursor: pointer;" onclick="goforms();">&nbsp; &nbsp;
			 	<!-- <a href="#"><img src="/images/bt_cancle.gif" border="0" align="absmiddle"></a> -->
			</td>
		</tr>
	</table>
</div>
</form>
<div style="padding: 10px 0 20px 0">* 이곳은 GR15 파일 작업공간 입니다. 받은 파일을 <font color="red">Excel</font>로 변환하는 작업을 합니다. </div>
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