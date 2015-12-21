<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" type="text/css" href="/css/addStyle.css">
<link rel="stylesheet" type="text/css" href="/css/mkcrm.css">
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
function fn_update() {
	var fm = document.getElementById("fm");
	
	 if(!confirm("저장하시겠습니까?")) {
		 return false;
	 }
	
	fm.target="_self";
	fm.action="/management/agencyManage/agencyDeliverySave.do";
	fm.submit();
}

jQuery(document).ready(function($){
});
</script>
<div style="padding-bottom: 5px;"><span class="subTitle">발송문자수신등록</span></div>
<form name="fm" id="fm" method="post">
	<div style="width: 720px; padding-left: 15px;">
		<table class="tb_view_left" style="width: 310px">
			<colgroup>
				<col width="70px">
				<col width="115px">
				<col width="125px">
			</colgroup>
			<tr>
				<th>&nbsp;</th> 
				<th>성 명</th>
				<th>연락처</th>
			</tr>
			<tr> 
				<th>1</th>
				<td>${deliveryNm1}
					<input type="hidden" name="deliveryNm1" id="deliveryNm1"  value="${deliveryNm1}"  />
				</td>
				<td>${deliveryNum1}
					<input type="hidden" name="deliveryNum1" id="deliveryNum1"  value="${deliveryNum1}" />
				</td> 
			</tr>
			<tr>
				<th>2</th>
				<td><input type="text" name="deliveryNm2" id="deliveryNm2"  value="${deliveryNm2}"  style="width: 100px" maxlength="8" /></td>
				<td><input type="text" name="deliveryNum2" id="deliveryNum2"  value="${deliveryNum2}" style="width: 110px" maxlength="13" onblur="cf_phone_number_mark(this.value, 'deliveryNum2')"/></td>
			</tr>
			<tr>
				<th>3</th>
				<td><input type="text" name="deliveryNm3" id="deliveryNm3"  value="${deliveryNm3}"  style="width: 100px" maxlength="8" /></td>
				<td><input type="text" name="deliveryNum3" id="deliveryNum3"  value="${deliveryNum3}" style="width: 110px" maxlength="13" onblur="cf_phone_number_mark(this.value, 'deliveryNum3')"/></td>
			</tr>
		</table>
		<!-- button -->					
		<div style="width: 310px; text-align: right; padding-top: 10px;">    	
		   	<a href="#fakeUrl" onclick="fn_update()"><img src="/images/bt_save.gif" style="border: 0; vertical-align: middle; "></a>
		</div>
		<!-- button -->	
	</div>
</form>
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