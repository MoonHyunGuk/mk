<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script type="text/javascript" src="/js/common.js"></script>
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet">
<script type="text/javascript">
	//숫자만 입력 가능하도록 체크 키 다운시http://localhost:8001/main/login.do
	function inputNumCom(){
		var keycode = event.keyCode;
		 
		if ((event.keyCode<48) || (event.keyCode>57)){
			alert("숫자만 입력 가능합니다.");
			event.keyCode = 0;  // 이벤트 cancel
		}
	}
	
	//다부수 중지
	function closeReader(){
		var qty = document.getElementById("qty");
		var uPrice = document.getElementById("uPrice");
		
		if(qty.value == ''){
			alert('해지 부수를 입력해 주세요.');
			qty.focus();
			return;
		}
		if(uPrice.value == ''){
			alert('차감 금액을 입력해 주세요.');
			uPrice.focus();
			return;
		}
		if( Number(qty.value) > Number(opener.document.getElementById("qty").value) ){
			alert('차감 부수가 실제 구독부수보다 큽니다. 다시 확인해 주시기 바랍니다.');
			$("qty").focus();
			return;
		}
		if( Number(uPrice.value) > Number(opener.document.getElementById("uPrice").value) ){
			alert('차감 금액이 실제 금액보다 큽니다. 다시 확인해 주시기 바랍니다.');
			$("uPrice").focus();
			return;
		}

		var oform = opener.document.readerListForm;
		
		oform.stQty.value = qty.value ;
		oform.uPrice.value = oform.uPrice.value - uPrice.value ;
		oform.target="_self";
		oform.action="/reader/readerManage/updateReaderData.do";
		oform.submit();
		self.close();
	}
</script>
</head>
<body>
<form id="extendRdForm" name="extendRdForm" action="" method="post">
	<p style="top-margin:30px;"/>
	<table width="100%" cellpadding="0" cellspacing="0"  border="0">
		<tr bgcolor="ffffff">
			<td>
			<font class="b03"><b>[ 다부수 중지 ]</b></font>
			</td>
		</tr>
	</table>
	<p style="top-margin:30px;"/>
	<table width="100%" cellpadding="5" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
		<tr bgcolor="ffffff">
			<td bgcolor="f9f9f9" width="40%" align="center"><font class="b02">차감 부수</font></td>
			<td ><input type="text" id="qty" name="qty" style="ime-Mode:disabled" onkeypress="inputNumCom();"/></td>
		</tr>
		<tr bgcolor="ffffff">
			<td bgcolor="f9f9f9" width="40%" align="center"><font class="b02">차감 금액</font></td>
			<td ><input type="text" id="uPrice" name="uPrice" style="ime-Mode:disabled" onkeypress="inputNumCom();"/></td>
		</tr>
	</table>
	<p style="top-margin:10px;"/>
	<table width="100%" cellpadding="0" cellspacing="0"  border="0">
		<tr bgcolor="ffffff">
			<td colspan="2" align="right">
				<a href="javascript:closeReader();"><img src="/images/bt_save.gif" border="0" align="absmiddle"/></a>
				<a href="javascript:self.close();"><img src="/images/bt_cancle.gif" border="0" align="absmiddle"/></a>
			</td>
		</tr>
	</table>
</form>
<script type="text/javascript">
 	 window.resizeTo(300, 300);
</script>
</body>
</html>