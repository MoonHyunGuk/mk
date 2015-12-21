<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>지국정보검색</title>
<script type="text/javascript" src="/js/common.js"></script>
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet">
<script type="text/javascript">
	//숫자만 입력 가능하도록 체크 키 다운시
	function inputNumCom(){
		var keycode = event.keyCode;
		 
		if ((event.keyCode<48) || (event.keyCode>57)){
			alert("숫자만 입력 가능합니다.");
			event.keyCode = 0;  // 이벤트 cancel
		}
	}

	
	//추가 구독, 매체 추가
	function extendReader(){
		var qty = document.getElementById("qty");
		var uPrice = document.getElementById("uPrice");
		var sgBgmm = document.getElementById("sgBgmm");
		var newsCd = document.getElementById("newsCd");
		var gbnVal =  document.getElementById("gbn").value;
		
		if(qty.value == ''){
			alert('추가 구독 부수를 입력해 주세요.');
			qty.focus();
			return;
		}
		if(uPrice.value == ''){
			alert('단가를 입력해 주세요.');
			uPrice.focus();
			return;
		}
		if(sgBgmm.value != '' && sgBgmm.value.length < 6){
			alert('유가년월을 정확히 입력해 주세요.');
			sgBgmm.focus();
			return;
		}
		var oform = opener.document.readerListForm;
		
		if(gbnVal == 'qty'){
			oform.newsCd.value = newsCd.value;
			oform.qty.value = qty.value ;
			oform.uPrice.value = uPrice.value ;
			oform.sgBgmm.value = sgBgmm.value ;
		}else if(gbnVal == 'newsCd'){
			oform.newsCd.value = newsCd.value;
			oform.qty.value = qty.value ;
			oform.uPrice.value = uPrice.value ;
			oform.sgBgmm.value = sgBgmm.value ;
		}else{
			return;
		}
		
		window.opener.extendReader();
		self.close();
	}
	
	function setSgBgmm(){
		var currentTime = new Date();
		var year = currentTime.getFullYear();
		var month = currentTime.getMonth() + 1;
		if(month > 1 && month < 10){
			month = '0'+month;
		}
		document.getElementById("sgBgmm").value = year.toString()+month.toString();
	}
	
	function clear(){
		document.getElementById("sgBgmm").value = '';
		return;
	}
</script>
</head>
<body onload="setSgBgmm();">
<div class="box_Popup">
	<!-- title -->
	<div class="pop_title_box">지국정보검색</div>
	<!-- //title -->
	<div style="padding-top: 5px">
	<form id="extendRdForm" name="extendRdForm" action="" method="post">
	<input type="hidden" id="gbn" name="gbn" value="${gbn }"/>
		<div style="padding: 5px 0;">
			<c:choose>
				<c:when test="${gbn eq 'qty' }"><font class="b03"><b>[ 추가 구독 ]</b></font></c:when>
				<c:otherwise><font class="b03"><b>[ 매체 추가 ]</b></font></c:otherwise>
			</c:choose>
		</div>
		<table class="tb_edit_4" style="width: 260px;" >
			<col width="90px">
			<col width="170px">
			<c:choose>
				<c:when test="${gbn eq 'qty' }">
					<tr>
						<th>신 문 명</th>
						<c:forEach items="${newSList }" var="list" varStatus="i">
							<c:if test="${list.CODE == newsCd }">
								<td><input type="hidden" name="newsCd" id="newsCd" value="${list.CODE }"/>${list.CNAME }</td>
							</c:if>
						</c:forEach>
					</tr>
				</c:when>
				<c:otherwise>
					<tr>
						<th>신 문 명</th>
						<td>
							<select name="newsCd" id="newsCd" >
								<c:forEach items="${newSList }" var="list" varStatus="i">
									<c:if test="${list.CODE != newsCd }">
										<option value="${list.CODE }" >${list.CNAME }</option>
									</c:if>
								</c:forEach>
							</select>
						</td>
					</tr>
				</c:otherwise>
			</c:choose>
			<tr>
				<th>추가부수</th>
				<td><input type="text" id="qty" name="qty" style="ime-Mode:disabled" onkeypress="inputNumCom();"/></td>
			</tr>
			<tr>
				<th>추가금액</th>
				<td ><input type="text" id="uPrice" name="uPrice" style="ime-Mode:disabled" onkeypress="inputNumCom();"/></td>
			</tr>
			<tr>
				<th>유가년월</th>
				<td><input type="text" id="sgBgmm" name="sgBgmm" value="" maxlength="6" style="ime-Mode:disabled" onkeypress="inputNumCom();" onclick="javascript:clear();"/></td>
			</tr>
		</table>
		<div style="padding-top: 10px; text-align: right; width: 260px; margin: 0 auto;">
			<a href="#fakeUrl" onclick="extendReader();"><img src="/images/bt_save.gif" border="0" alt="저장" /></a>
			<a href="#fakeUrl" onclick="self.close();"><img src="/images/bt_cancle.gif" border="0" alt="취소"/></a>
		</div>
		</form>
	</div>
</div>
</body>
</html>