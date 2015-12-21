<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel='stylesheet' type='text/css' href="/css/mkcrm.css" />
<script type="text/javascript" src="/js/common.js"></script>
<title>통화 내역</title>
<script type="text/javascript">
	//통화내역 저장(수정)
	function fn_saveLog(){
		var fm = document.getElementById("callLogForm");
		var remk = document.getElementById("remk");
		
		if(!cf_checkNull("remk", "통화기록")) { return false; }
		
		if( checkBytes((remk.value) > 300)){
			alert("통화기록은 300byte를 초과할수 없습니다.");
			remk.focus();
			return;
		}
		opener.document.getElementById("callLog").style.display = "inline";
		fm.target="_self";
		fm.action = "/reader/billingAdmin/saveCallLog.do";
		fm.submit();
	}
	//바이트 계산 function
	function checkBytes(expression ){
	 	var VLength=0;
	 	var temp = expression;
	 	var EscTemp;
	 	if(temp!="" & temp !=null) {
	 		for(var i=0;i<temp.length;i++){
	 			if (temp.charAt(i)!=escape(temp.charAt(i))){
	 				EscTemp=escape(temp.charAt(i));
 					if (EscTemp.length>=6){
 						VLength+=2;
 					}else{
 						VLength+=1;
 					}
 				}else{
 					VLength+=1;
 				}
 			}
 		}
 		return VLength;
 	}
</script>
</head>
<body>
<div class="box_Popup">
	<!-- title -->
	<div class="pop_title_box">통화메모</div>
		<form id="callLogForm" name="callLogForm" action="" method="post">
			<input type="hidden" id="typeCd" name="typeCd" value="${param.typeCd }" />
			<input type="hidden" id="numId" name="numId" value="${param.numId }" />
			<c:if test="${not empty callLog }">
				<div style="overflow: hidden; padding: 10px 0 0 0">
					<div class="b03" style="width: 380px;">[ 통화메모 기록 ]</div>
					<table class="tb_view" style="width: 380px;">
						<col width="100px;">
						<col width="280px;">
						<tr>
							<th>통화시간</th>
							<th>통화내용</th>
						</tr>
						<c:forEach items="${callLog }" var="list">
							<tr>
								<td>${list.INDATE }</td>
								<td>${list.REMK }</td>
							</tr>
						</c:forEach>
					</table>
				</div>
			</c:if>
			<!-- edit -->
			<div style="overflow: hidden; padding: 10px 0 0 0">
				<div class="b03" style="width: 380px;">[ 통화 메모 저장 ]</div>
				<table class="tb_view" style="width: 380px;">
					<col width="100px;">
					<col width="280px;">
					<tr>
						<th>통화내용</th>	
						<td><textarea id="remk" name="remk" style="width:260px"></textarea> </td>
					</tr>
				</table>
			</div>
			<!-- edit -->
			<div style="width: 370px; text-align: right; padding: 10px 0 0 0;">
				<a href="#fakeUrl" onclick="fn_saveLog();"><img src="/images/bt_save.gif" border="0"  style="vertical-align: middle;" alt="저장"></a>
				<a href="#fakeUrl" onclick="self.close()"><img src="/images/bt_cancle.gif" border="0" style="vertical-align: middle;" alt="닫기"></a>
			</div>
		</form>
	</div>
</body>
</html>