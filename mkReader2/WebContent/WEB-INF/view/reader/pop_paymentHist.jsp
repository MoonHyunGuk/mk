<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet">
<script type="text/javascript">
	<c:if test="${not empty message}">
		alert('${message}');
	</c:if>
	var now = new Date();
	
	//수금 저장
	function saveSgum(){
		if($("sndt").value == ''){
			alert('수금일을 입력해 주세요.');
			$("sndt").focus();
			return;
		}
		if($("billAmt").value == ''){
			alert('금액을 입력해 주세요.');
			$("billAmt").focus();
			return;
		}
		if($("amt").value == ''){
			alert('수금금액을 입력해 주세요.');
			$("amt").focus();
			return;
		}
		if(Number($("billAmt").value) < Number($("amt").value)){
			alert('청구액 보다 수금금액이 클수 없습니다.');
			$("amt").focus();
			return;
		}
		sugmForm.target="_self";
		sugmForm.action="/reader/education/popSaveSugm.do";
		sugmForm.submit();
	}
	
	//숫자만 입력 가능하도록 체크 키 다운시
	function inputNumCom(){
		var keycode = event.keyCode;
		 
		if ((event.keyCode<48) || (event.keyCode>57)){
			alert("숫자만 입력 가능합니다.");
			event.keyCode = 0;  // 이벤트 cancel
		}
	}
</script>
</head>
<body>
<div class="box_Popup">
	<!-- title -->
	<div class="pop_title_box">
		<c:choose>
			<c:when test="${gbn eq 'alienation' }">소외계층 독자 수금 이력</c:when>
			<c:otherwise>교육용 독자 수금 이력</c:otherwise>
		</c:choose>
	</div>
	<!-- //title -->
	<form id="sugmForm" name="sugmForm" action="" method="post">
		<input type="hidden" id="readNm" name="readNm" value="${readNm }"/>
		<input type="hidden" id="seq" name="seq" value="${seq }"/>
		<input type="hidden" id="readNo" name="readNo" value="${readNo }"/>
		<input type="hidden" id="qty" name="qty" value="${qty }"/>
		<input type="hidden" id="boSeq" name="boSeq" value="${boSeq }"/>
		<!-- head -->
		<div style="padding-top: 10px"><div style="width: 478px; padding: 5px 0;" class="box_gray"><b>${param.readNm }</b>님의 수금 이력</div></div>
		<!-- //head -->
		<div style="padding: 10px 0;">
			<table class="tb_list_a" style="width: 480px">
				<col width="70px">
				<col width="90px">
				<col width="90px">
				<col width="115px">
				<col width="115px">
				<tr>
				 	<th>년    월</th>
					<th>수금일자</th>
					<th>금    액</th>
					<th>수 금 액</th>
					<th>수금방법</th>
				</tr>
			</table>
			<div style="width: 480px; overflow-y: scroll; overflow-x: none; height: 510px">
				<table class="tb_list_a" style="width: 463px">
					<col width="70px">
					<col width="90px">
					<col width="90px">
					<col width="115px">
					<col width="98px">
					<c:forEach items="${sugmList }" var="list">
						<tr>
						 	<td>${fn:substring(list.YYMM,0,4) }-${fn:substring(list.YYMM,4,6) }</td>
							<td>${fn:substring(list.SNDT,0,4) }-${fn:substring(list.SNDT,4,6) }-${fn:substring(list.SNDT,6,8) }</td>
							<td>${list.BILLAMT }</td>
							<td>${list.AMT }</td>
							<td>${list.SGBBNM }</td>
						</tr>
					</c:forEach>
				</table>
			</div>
			<div>
				<c:choose>
					<c:when test="${loginType eq 'A'}">
						<table width="100%" cellpadding="1" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
							<!--tr bgcolor="" align="center" class="box_p" >
							 	<td align="center">년    월</td>
								<td align="center">수금일자</td>
								<td align="center">금    액</td>
								<td align="center">수 금 액</td>
								<td align="center">&nbsp;</td>
							</tr>
							<tr bgcolor="f9f9f9" align="center" class="box_p" >
							 	<td align="center">
							 		<select class="box_100" id="yymm" name="yymm">
										<script>
											//선택범위는 현재의 25개월전부터 현재까지 뿌려줌 
											dd = now.getDate();
											for ( var i=25;i>-13;i-- ){
												nowTime = new Date(now.getFullYear(),now.getMonth()-i);
												yyyy = nowTime.getFullYear();
												mm = nowTime.getMonth() + 1;
												mm = mm < 10 ? "0" + mm : mm;
												
												yyyy2 = now.getFullYear();
												mm2 = now.getMonth()+1
												mm2 = mm2 < 10 ? "0" + mm2 : mm2;
												if(yyyy == yyyy2 && mm == mm2){
													document.write("<option value='" + yyyy + mm + "' selected>"+ yyyy + "-" + mm + "</option>");
												}else{
													document.write("<option value='" + yyyy + mm + "'>"+ yyyy + "-" + mm + "</option>");	
												}
											}
										</script>
									</select>
							 	</td>
								<td align="center"><input type="text" id="sndt" name="sndt" maxlength="8" class='box_n3' value="<c:out value='${sdate}' />" readonly onClick="Calendar(this)" class='box_n3'/></td>
								<td align="center"><input type="text" id="billAmt" name="billAmt" class='box_n3' style="ime-Mode:disabled" onKeyPress="inputNumCom();"/></td>
								<td align="center"><input type="text" id="amt" name="amt" class='box_n3' style="ime-Mode:disabled" onKeyPress="inputNumCom();"/></td>
								<td ><a href="javascript:saveSgum();"><img src="/images/bt_eepl.gif" border="0" align="absmiddle"></a></td>
							</tr-->
						</table>
					</c:when>
				</c:choose>
			</div>
		</div>
		<div style="text-align: right;"><a href="javascript:self.close();"><img src="/images/bt_close.gif" border="0" style="vertical-align: middle;" /></a></div>
	</form>
</div>
</body>
</html>