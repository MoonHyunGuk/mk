<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<table width="100%" height="100%">
	<tr><td align=center valign=middle>
		<a href="/billing/zadmin/cmsbank/index.do"> 되돌아 가기 </a>
	
	</td></tr>
</table>
<SCRIPT LANGUAGE="JavaScript">
		alert('${strz}\n');
		//window.open('process21c.do?fname=${fname}','_self');
		window.location="view.do?numid=${numid}&filename=${filename}&cmsdate=${cmsdate}&pageNo=${pageNo}";
//-->
</SCRIPT>