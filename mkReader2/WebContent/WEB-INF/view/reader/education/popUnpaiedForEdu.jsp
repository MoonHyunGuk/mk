<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet">
<script type="text/javascript">
/**
 * 엑셀다운 버튼 클릭 이벤트
 */
function fn_excelDown() {
	var unpaiedYYMM = document.getElementById("unpaiedYYMM").value;
	
	if(!confirm(unpaiedYYMM+"월분 미수를 출력하시겠습니까?")) { return false; }
	
	window.opener.fn_uppaied_excelDown(unpaiedYYMM);
	window.close();
}
</script>
</head>
<body>
<div class="box_Popup">
	<!-- title --> 
	<div class="pop_title_box">교육용 독자 미수 출력</div>
	<div style="padding-top: 10px;">
		<form name="fm" id="fm" action="" method="post">
		<table class="tb_search" width="300px;">
			<col width="100px">
			<col width="200px">
			<tr>
				<th>미수월</th>
				<td><input type="text" name="unpaiedYYMM" id="unpaiedYYMM" maxlength="6"  style="width: 55px" onkeydown="javascript:if(event.keyCode=='13'){fn_excelDown();}" /></td>
			</tr>
		</table>
		<div style="padding: 5px 5px 10px 0; text-align: right;"><b class="b03">2013년9월(8월달미수까지 출력) -&gt; 201309</b></div>
		</form>
	</div>
	<div style="text-align: right;">
		<span class="btnCss2"><a href="#fakeUrl" onclick="fn_excelDown();">엑셀다운</a></span>&nbsp;
	</div>
</div>
</body>
</html>