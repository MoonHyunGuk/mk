<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<link rel='stylesheet' type='text/css' href='/css/mkcrm.css'/>
<title>통화 내역</title>
<script type="text/javascript">
	//통화내역 저장(수정)
	function saveLog(){
		if($("remk").value == ''){
			alert("통화기록을 입력해 주세요.");
			$("remk").focus();
			return;
		}
		if( checkBytes($("remk").value) > 300){
			alert("통화기록은 300byte를 초과할수 없습니다.");
			$("remk").focus();
			return;
		}
		opener.document.getElementById('callLog').style.display = "inline" ;
		callLogForm.target="_self";
		callLogForm.action = "/reader/billing/saveCallLog.do";
		callLogForm.submit();
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
<form id="callLogForm" name="callLogForm" action="" method="post">
	<input type="hidden" id="typeCd" name="typeCd" value="${param.typeCd }" />
	<input type="hidden" id="numId" name="numId" value="${param.numId }" />
	<c:if test="${not empty callLog }">
		<font class="b03">[ 통화메모 기록 ]</font>
		<table width="100%" cellpadding="1" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
			<tr>
				<td width="18%" align="center"><font class="b02">통화시간</font></td>
				<td align="center"><font class="b02">통화내용</font></td>
			</tr>
			<c:forEach items="${callLog }" var="list">
				<tr bgcolor="ffffff">
					<td>
						${list.INDATE }
					</td>
					<td>
						${list.REMK }
					</td>
				</tr>
			</c:forEach>
		</table>
		<br/>
	</c:if>
	<font class="b03">[ 통화 메모 저장 ]</font>
	<table width="100%" cellpadding="1" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
		<tr bgcolor="ffffff">
			<td width="5%"><font class="b02">통화내용</font></td>	
			<td>
				<textarea id="remk" name="remk" class='box_l' style="width:99%;"></textarea>
			</td>
		</tr>
	</table>
	<p style="top-margin:10px;">
	<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="e5e5e5" class="b_01">
		<tr bgcolor="ffffff">
			<td align="right">
			<a href="javascript:saveLog();"><img src="/images/bt_save.gif" border="0" align="absmiddle"></a>
			<a href="javascript:self.close()"><img src="/images/bt_cancle.gif" border="0" align="absmiddle"></a>
			</td>
		</tr>
	</table>
	
</form>