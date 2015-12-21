<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
 <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

</head>
<body>
<script type="text/javascript" src="/js/common.js"></script>
<script language="JavaScript" type="text/javascript" src="/js/s_code.js"></script>
<script type="text/javascript">
var message = "<c:out value='${message}' />";

if (message) {
	alert(message);
	
}

var evant = "<c:out value='${evant}' />";
if (evant) {
	setEvent(event);
}

var returnURL = "<c:out value='${returnURL}' />";
var rtn_url = "<c:out value='${rtn_url}' />";

if (returnURL) {
	if ( rtn_url ) {
		self.location.href = returnURL + "?rtn_url=" + rtn_url;
	}
	else {
		self.location.href = returnURL;
	}
}

var imgFile = "<c:out value='${imgFile}' />";
var index = "<c:out value='${layOut}' />";

if (imgFile) {
	window.opener.layOut(index, imgFile);
	self.close();
}

var fileFile = "<c:out value='${fileFile}' />";

if (fileFile) {
	window.opener.addFile(fileFile);
	self.close();
}

var parentURL = "<c:out value='${parentURL}' />";
if ( parentURL ) {
	var frm = window.opener.document.getElementById("frm");
	frm.action = parentURL;
	frm.submit();
	self.close();
}

</script>
</body>
</html>
