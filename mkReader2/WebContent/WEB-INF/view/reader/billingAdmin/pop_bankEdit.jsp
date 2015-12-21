<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel='stylesheet' type='text/css' href="/css/mkcrm.css" />
<link rel='stylesheet' type='text/css' href="/select2/select2.css"/>
<title>납부자 정보 변경</title>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<script type="text/javascript">
//정보 변경 체크
function fn_info_change_check() {
	if(	$("#tmp_bankName").val() == $("#bankName").val() &&	$("#tmp_bankMoney").val() == $("#bankMoney").val() && 		
		$("#tmp_bank").val() == $("#bankInfo").val() && $("#tmp_bankNum").val() == $("#bankNum").val() && 
		$("#tmp_saup").val() == $("#saup").val() && $("#handy1").val()+$("#handy2").val()+$("#handy3").val()  == $("#tmp_handy").val() ) {
		return false;
	} else {
		return true;
	}
}
//자동이체 납부자 정보 변경
function save(){
	//정보 변경 체크
	if(!fn_info_change_check()) {alert("변경된 정보가 없습니다."); return;}
	
	//011농협중앙회 , 012지역농협 구분
	if($("#bankInfo").val() =='011' || $("#bankInfo").val() =='012'){
		if($("#bankNum").val().length == 11){
			$("#bankInfo").val("011");
		} else if($("#bankNum").val().length == 14) {
			$("#bankInfo").val("012");
		} else if($("#bankNum").val().length == 13) {
			if($("#bankNum").val().substring(1,2) == 5){
				$("#bankInfo").val("012");
			}else{
				$("#bankInfo").val("011");
			}	
		}
	}
	
	//개인사업체의 경우 주민번호만 입력 가능
	if($("#saup").val().length=='11'){
		if($("#saup").val().substring(3,4) != 8){
			alert('개인사업체의 경우 주민번호를 입력해 주시기 바랍니다.');
			$("#saup").focus();
			return;
		}
	}
	
	window.opener.changeBankNum($("#bankMoney").val() , $("#bankName").val() , $("#bankInfo").val() , $("#bankNum").val() , $("#saup").val() , $("#handy1").val() , $("#handy2").val() , $("#handy3").val());
	self.close();
}

$(document).ready(function($){ 
	$("#bankInfo").select2({minimumInputLength: 1});
});
</script>
</head>
<div class="box_Popup">
	<!-- title -->
	<div class="pop_title_box">계좌 정보 변경</div>
	<form id="changeBankForm" name="changeBankForm" action="" method="post">
		<input type="hidden" id="numId" name="numId" value="${param.numId }" />
		<input type="hidden" id="tmp_bankMoney" name="tmp_bankMoney" value="${billingInfo[0].BANK_MONEY }" />
		<input type="hidden" id="tmp_bankName" name="tmp_bankName" value="${billingInfo[0].BANK_NAME }" />
		<input type="hidden" id="tmp_bankNum" name="tmp_bankNum" value="${billingInfo[0].BANK_NUM }" />
		<input type="hidden" id="tmp_saup" name="tmp_saup" value="${billingInfo[0].SAUP }" />
		<!-- edit -->				
		<br/>
		<table class="tb_edit_left" style="width: 383px">
			<colgroup>
				<col width="133px">
				<col width="250px">
			</colgroup>
			<tr>
			 	<th><b class="b03">*</b> 이체금액</th>
				<td ><input type="text" id="bankMoney" name="bankMoney" value="${billingInfo[0].BANK_MONEY }" style="width: 100px" onkeypress="inputNumCom();" /></td>
			</tr>
			<tr>
			 	<th><b class="b03">*</b> 예금주명/법인명</th>
				<td ><input type="text" id="bankName" name="bankName" value="${billingInfo[0].BANK_NAME }"  style="width: 100px" /></td>
			</tr>
			<tr>
			 	<th><b class="b03">*</b> 이체 은행</th>
				<td >
					<input type="hidden" id="tmp_bank" name="tmp_bank" value="${billingInfo[0].BANK }" />
					<select id="bankInfo" name="bankInfo" style="width: 180px">
					<c:forEach items="${bankInfo }" var="list">
						<option value="${list.BANKNUM }" <c:if test="${list.BANKNUM eq billingInfo[0].BANK }"> selected</c:if> > ${list.BANKNAME }</option>
					</c:forEach>
					</select>
				</td>
			</tr>							
			<tr>
			 	<th><b class="b03">*</b> 계좌 번호</th>
				<td ><input type="text" id="bankNum" name="bankNum" value="${billingInfo[0].BANK_NUM }" maxlength="16" style="ime-Mode:disabled; width: 150px" onkeypress="inputNumCom();" /></td>
			</tr>
			<tr>
			 	<th><b class="b03">*</b> 주민등록번호/<br/>사업자등록번호</th>
				<td ><input type="text" id="saup" name="saup" value="${billingInfo[0].SAUP }" maxlength="13" style="ime-Mode:disabled; width: 130px" onkeypress="inputNumCom();"/><br>* 계좌번호 발급시기재된 주민번호</td>
			</tr>
			<tr>
			 	<th style="letter-spacing: -1px"><b class="b03">*</b> 예금주 비상연락처</th>
				<td >
					<c:choose>
						<c:when test="${empty billingInfo[0].HANDY }">
							<c:set var="handy" value="${fn:split('010-0000-0000', '-') }"></c:set>	
						</c:when>
						<c:otherwise>
							<c:set var="handy" value="${fn:split(billingInfo[0].HANDY, '-') }"></c:set>
						</c:otherwise>
					</c:choose>
					<input type="hidden" id="tmp_handy" name="tmp_handy" value="${handy[0] }${handy[1] }${handy[2] }"/>
					<select id="handy1" name="handy1">
					<c:forEach items="${mobileCode }" var="list">
						<option value="${list.CODE }" <c:if test="${list.CODE eq handy[0] }"> selected </c:if>>${list.CODE }</option>
					</c:forEach>
					</select> - 
					<input type="text" id="handy2" name="handy2" value="${handy[1] }" maxlength="4" style="ime-Mode:disabled; width: 40px" onkeypress="inputNumCom();"/> - 
					<input type="text" id="handy3" name="handy3" value="${handy[2] }" maxlength="4" style="ime-Mode:disabled; width: 40px" onkeypress="inputNumCom();"/>
				</td>
			</tr>
		</table>	
	</form>
	<div style="width: 383px; margin: 0 auto; text-align: right; padding: 10px 0 0 0">
		<a href="#fakeUrl" onclick="fn_save();"><img src="/images/bt_save.gif" alt="저장" style="border: 0; vertical-align: middle;"></a>
		<a href="#fakeUrl" onclick="self.close();"><img src="/images/bt_cancle.gif" alt="취소" style="border: 0; vertical-align: middle;"></a>
	</div>
</div>
