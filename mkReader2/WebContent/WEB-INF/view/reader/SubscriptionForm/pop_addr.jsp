<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<link rel='stylesheet' type='text/css' href='/css/mkcrm.css'/>
<style>
#xlist {
	width: 100%;
	height: 360px;
	overflow-y: auto;
}
</style>
<script type="text/javascript">

	function search(){
		if($("search").value == ''){
			alert('검색할 주소를 입력해 주세요.');
			$("search").focus();
			return;
		}
		addrForm.target="_self";
		addrForm.action="/reader/subscriptionForm/searchAddr.do";
		addrForm.submit();
	}
	
	function setAddr(zip , addr){
		window.opener.setAddr(zip , addr);
		self.close();
	}
</script>
</head>
<form id="addrForm" name="addrForm" action="/reader/subscriptionForm/searchAddr.do" method="post">
	<input type="hidden" id="cmd" name="cmd" value="${cmd }"/>
	<table width="100%" cellpadding="3" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
		<tr bgcolor="ffffff">
			<td bgcolor="f9f9f9" width="12%" align="center"><font class="b02">주소</font></td>
			<td><input type="text" id="search" name="search" value="${search }" class="box_n" style="ime-Mode:active"/></td>
			<td align="center">
				<a href="javascript:search()"><img src="/images/bt_search.gif" border="0" align="absmiddle"/></a>
			</td>
		</tr>
		<tr bgcolor="ffffff">
			<td colspan="3" align="center">*주소검색은 동,면을 기준으로 검색됩니다.</td>
		</tr>
	</table>
	<p style="top-margin: 10px;">
	<c:if test="${not empty addrList }">
	<div id="xlist">
	<table width="100%" cellpadding="0" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
		<tr bgcolor="ffffff">
			<td bgcolor="f9f9f9" width="25%" align="center"><font class="b02">우편번호</font></td>
			<td bgcolor="f9f9f9" align="center" colspan="2"><font class="b02">상세주소</font></td>
		</tr>
		
		<c:forEach items="${addrList }" var="list" varStatus="i">
		<tr bgcolor="ffffff">
			<td align="center">${list.ZIP }</td>
			<td colspan="2">
				<a href="javascript:setAddr('${list.ZIP }' , '${list.ADDR }');" style="text-decoration:none">${list.TXT }</a>
			</td>
		</tr>
		</c:forEach>
		
	</table>
	</div>
	</c:if>
	</p>
</form>
