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

/**
 * 독자상세보기
 */
function popMemberView(readno){
	var width="600";
	var height="655";
	LeftPosition=(screen.width)?(screen.width-width)/2:100;
	TopPosition=(screen.height)?(screen.height-height)/2:100;
	url="/billing/zadmin/popup/view.do?readno=" + readno;
	winOpts = "scrollbars=1,toolbar=no,location=no,directories=no,width="+width+",height="+height+",resizable=no,left="+LeftPosition+",top="+TopPosition;
	var obj = window.open(url,'popup',winOpts);
}
</script>
</head>
<body>
<div class="box_Popup">
	<!-- title --> 
	<div class="pop_title_box">일반이체신청 에러내용</div>
	<!-- //title -->
	<div style="padding-top: 10px;">
		<div class="box_gray" style="font-weight: bold; padding: 10px 0; width: 920px;">CMS file : <font class="b03"><c:out value="${filename}" /></font> 에러 결과 명세</div>
		<div style="padding-top: 10px;">
			<table class="tb_list_a_5" style="width: 920px;">
				<col width="100px">
				<col width="130px">
				<col width="240px">
				<col width="460px">
				<tr>
				    <th>구독자DB번호</th>
					<th>구독자번호(11자리)</th>
					<th>구독자이름</th>
					<th>기초데이터 에러 내용</th>
				</tr>
				<c:choose>
					<c:when test="${not empty resultList}">
						<c:forEach var="list" items="${resultList}" varStatus="status">
							<tr>
							    <td ><c:out value="${list.NUM}" /></td>
								<td ><a href="javascript:popMemberView('<c:out value="${list.READNO}" />');"><c:out value="${list.SERIAL}" /></a></td>
								<td align="left"><c:out value="${list.USERNAME}" /></td>
								<td>
									<span style="font-size:9pt;">
										<c:out value="${list.ERRMSG}" />
									</span>
								</td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td colspan="4"><p align="center">결과가 없습니다.</p></td>
						</tr>
					</c:otherwise>
				</c:choose>
			</table>
		</div>
	</div>
	<div style="text-align: right; padding-top: 10px; width: 920px; margin: 0 auto;"><a href="#fakeUrl" onclick="fn_popClose();"><img src="/images/bt_close.gif" style="border: 0; vertical-align: middle"></a></div>
</div>
</body>
</html>
