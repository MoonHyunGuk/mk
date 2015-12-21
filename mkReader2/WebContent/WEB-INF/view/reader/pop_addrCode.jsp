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
<script type="text/javascript">
	function setAddrCode(){
		var tmp = $("code").value.split(':');
		window.opener.setAddrCode(tmp[0] , tmp[1]);
		self.close();
		
	}
</script>
</head>
	<table width="100%">
		<tr>
			<Td align="center">
				<select id="code" name="code" class="box_n" onChange="javascript:setAddrCode();"/>
				<c:forEach items="${addrList }" var="list">
					<option value="${list.CODE}:${list.NAME}">${list.CODE}:${list.NAME}</option>	
				</c:forEach>
			</Td>
		</tr>
	</table>