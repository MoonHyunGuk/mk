<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title> 
<link rel="stylesheet" type="text/css" href="/css/mkcrm.css">
<style type="text/css">
body{font-size:12px;font-family:돋움,Dotum,AppleGothic,sans-serif;} 
</style>
</head> 
<body>
<div class="box_Popup">
	<!-- title --> 
	<div class="pop_title_box">독자비고 리스트</div>
	<!-- //title -->
	<div style="overflow-x: none; overflow-y: scroll; width: 270px; height: 545px; padding: 5px; border: 0px solid blue">
		<c:forEach items="${memoList}" var="list"  varStatus="status">
			<div style="padding-bottom: 7px;">
				<div class="box_gray" style="width: 240px; padding: 5px">
					<div style="padding: 5px 0; font-weight: bold;">[${list.CREATE_ID}]&nbsp;${list.CREATE_DATE}</div>
					<div style="text-align: left; width: 235px; word-break:break-all">${list.MEMO}</div>
				</div>
			</div>
		</c:forEach>
	</div>
</div>
</body>
</html>