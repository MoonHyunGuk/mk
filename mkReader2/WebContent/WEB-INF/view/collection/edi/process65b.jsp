<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<table width="100%" height="100%">
	<tr><td align=center valign=middle>
	
	<a href="/collection/ediElect/gr65List.do"> 되돌아 가기 </a>
	
	</td></tr>
</table>
<SCRIPT LANGUAGE="JavaScript">
		alert('${error_str}\n처리건수 : ${serialno}건\n');
		//window.open('process21c.do?fname=${fname}','_self');
		window.location="gr65List.do?jcode=${jcode}";
//-->
</SCRIPT>