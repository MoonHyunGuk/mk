<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<head>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript">

	// 윈도우 닫기
	function winClose(){
		window.opener.endLoad();
		if($("errCd").value != "1"){
			window.opener.openButton();
		}
		window.close();
	}
</script>
</head>
<body>
<table cellpadding="0" cellspacing="0" width="100%" height="100%">
	<tr>
		<td align="center">
			${message}
			<input type="hidden" id="errCd" name="errCd" value="${errCd}"/>
		</td>
	</tr>
	<tr>
		<td align="center">
		<a href="javascript:winClose()">
			<img src="/images/close.gif" width="45" height="19" border="0">
		</a>
		</td>
	</tr>	
</table>
</body>