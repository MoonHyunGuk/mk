<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet">
<script type="text/javascript">
/**
 *	 팝업닫기
 **/
function fn_popClose() {
	window.close();
}
</script>
</head>
<body>
<div class="box_Popup">
	<!-- title --> 
	<div class="pop_title_box">은행신청결과  에러내용</div>
	<!-- //title -->
	<div style="padding-top: 5px;">
		<div class="box_gray" style="font-weight: bold; padding: 10px 0; width: 920px;">CMS file : <font class="b03"><c:out value="${filename}" /></font> 에러 결과 명세</div>
		<div style="padding-top: 5px">
			<table class="tb_list_a_5" style="width: 920px;">
				<col width="100px">
				<col width="130px">
				<col width="240px">
				<col width="460px">
				<tr>
					<td >구독자DB번호</td>
					<td >구독자번호(11자리)</td>
					<td >구독자이름</td>
					<td>기초데이터 에러 내용</td>
				</tr>
				<c:choose>
					<c:when test="${not empty resultList}">
						<c:forEach var="list" items="${resultList}" varStatus="status">
							<tr onclick="popMemberView('<c:out value="${list.READNO}" />');" style="cursor: pointer;">
							    <td ><c:out value="${list.NUM}" /></td>
								<td ><c:out value="${list.SERIAL}" /></td>
								<td style="text-align: left;"><c:out value="${list.USERNAME}" /></td>
								<td>
									<p align="center">
										<span style="font-size:9pt;">
											<c:out value="${list.ERRMSG}" />
										</span>
									</p>
								</td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr><td colspan="4"><p align="center">결과가 없습니다.</p></td></tr>
					</c:otherwise>
				</c:choose>
			</table>
		</div>
	</div>
	<div style="padding: 10px 0 20px 0; text-align: right; width: 920px; margin: 0 auto;"><a href="#fakeUrl" onclick="fn_popClose();"><img src="/images/bt_close.gif" style="border: 0; vertical-align: middle"></a></div>
</div>
</body>
</html>
