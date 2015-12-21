<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
	function fn_goforms() {
	
		var fm = document.getElementById("forms1");
		var edifile = document.getElementById("edifile").value;
		var gubun = document.getElementsByName("gubun");
		var prcssDiv	 = document.getElementById("prcssDiv");

		var msg = "";
		var url ="";
		
		if ( edifile == '' || edifile == null ) {
			alert("파일을 첨부해 주시기 바랍니다.");
			fm.edifile.focus();
			return;
		}

		 if(gubun[0].checked){
			 url = "gr15process.do";
			msg = "직영지로" ;
		 }else if(gubun[1].checked){
			 url = "gr15AgencyProcess.do";
			msg = "수납대행지로" ;
		 }else{
			 url = "mr15Process.do";
			msg = "바코드수납" ;
		 }
		 
	 	con=confirm(msg+" 파일을 처리하시겠습니까?");
	 	
	    if(con==false){
	        return;
		}else{
			fm.target = "_self";
			fm.action = url;
			jQuery("#prcssDiv").show();
			fm.submit();
		}
	}
</script>
<div style="padding-bottom: 5px;"> 
	<span class="subTitle">자료업로드</span>
</div>
<form name="forms1" id="forms1" method="post" enctype="multipart/form-data">
<!-- form -->
<table class="tb_search" style="width: 1020px">
	<colgroup>
		<col width="260px">
		<col width="760px">
	</colgroup>
	<tr>
		<th>자료 구분</th>
		<td>
			<input type="radio" id="gubun" name="gubun" checked="checked" style="vertical-align: middle; border: 0" />&nbsp;직영지로(3146440)&nbsp;&nbsp;
			<input type="radio" id="gubun" name="gubun" style="vertical-align: middle; border: 0"  />&nbsp;수납대행지로&nbsp;&nbsp;
			<input type="radio" id="gubun" name="gubun" style="vertical-align: middle; border: 0" />&nbsp;바코드수납
		</td>
	</tr>
	<tr>
		<th>EDI file(GR15)</th>
		<td>
				<input type="file" name="edifile" id="edifile" style="width:400px; vertical-align: middle; ">&nbsp;
		 	<a href="#fakeUrl" onclick="fn_goforms();"><img src="/images/bt_eepl.gif" style="vertical-align: middle; border: 0;" alt="입력"></a> &nbsp; 
		 	<!-- <a href="#"><img src="/images/bt_cancle.gif" border="0" align="absmiddle"></a> -->
		</td>
	</tr>
</table>
<!-- form -->
</form>
<div style="padding: 15px 0 20px 0">* 이곳은 GR15 파일 작업공간 입니다. 받은 파일을 <font color="red">DB</font>로 변환하는 작업을 합니다.</div>
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