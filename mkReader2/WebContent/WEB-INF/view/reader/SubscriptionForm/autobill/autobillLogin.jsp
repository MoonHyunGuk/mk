<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${titleTxt }</title>
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet"> 
<style type="text/css">
.loginDivBox {border-top: 2px solid #ff821e ; margin: 0 auto; background-color: #f5f5f5; padding: 15px 0;}
.loginInputBox {width: 380px; margin: 0 auto; text-align: center; }
.loginBtn {border: 1px solid #da670c; background-color: #ff821e; width: 200px; padding: 5px 0; margin: 0 auto; color: #fff; font-weight: bold; font-size: 1.2em; cursor: pointer;}
</style>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
function fn_login() {
	var fm = document.getElementById("autobillFm");
//	var bankNumCodeVal = $("#bacnkNumCode").val();
	var flag = $("#flag").val();
	var url = "";
	
//	if($("#codeTypeB").is(":checked")) { 			//개인회원
//		if(bankNumCodeVal.length < 6 || bankNumCodeVal.length > 6) {
//			alert("생년월일을 확인해주세요.생년월일은 6자리입니다."); 
//			return false;
//		}
//	} else if($("#codeTypeC").is(":checked")) {	//기업회원
//		if(bankNumCodeVal.length < 10 || bankNumCodeVal.length > 10) {
//			alert("사업자번호를 확인해주세요.사업자번호는 10자리입니다.");
//			return false;
//		}
//	}
	
	if("sugm" == flag) {		//거래내역 리스트
		url = "/reader/subscriptionForm/autobillLoginProcess.do"
	} else if("bankNum" == flag) {	//계좌변경
		url = "/reader/subscriptionForm/bankNumChgLoginProcess.do"
	}
	
	fm.taget = "_self";
	fm.action = url;
	fm.submit();
} 

//입력창 워터마크
function fn_inputBox_waterMark() {
	var bankNmVal = "";
	var bankNumCodeVal = "";
	
	$("#bankNm").css("color","#c8c8c8");
	$("#bankNumCode").css("color","#c8c8c8");
	$("#bankNm").val("예금주명 입력");
	$("#bankNumCode").val("계좌번호 입력");
	
	$("#bankNm").focus(function(){
		bankNmVal = this.value;
		if(bankNmVal != "예금주명 입력" &&bankNmVal.length > 1) {
		} else {
			$("#bankNm").val("");
			$("#bankNm").css("color","#000");
		}
	});
	$("#bankNm").focusout(function(){
		bankNmVal = this.value;
		if(bankNmVal.length < 3) {
			$("#bankNm").css("color","#c8c8c8");
			$("#bankNm").val("예금주명 입력");
		}
	});
	$("#bankNumCode").focus(function(){
		bankNumCodeVal = this.value; 
		if(bankNumCodeVal != "계좌번호 입력" && bankNumCodeVal.length > 1) { 
		} else {
			$("#bankNumCode").val("");
			$("#bankNumCode").css("color","#000");
		}
	});
	$("#bankNumCode").focusout(function(){
		bankNumCodeVal = this.value;
		if(bankNumCodeVal.length < 3) {
			$("#bankNumCode").css("color","#c8c8c8");
			$("#bankNumCode").val("계좌번호 입력");
		}
	});
}

$(document).ready(function($) {
	fn_inputBox_waterMark();
});
</script> 
</head> 
<body>
<div class="box_Popup"> 
	<!-- header -->
	<div style="background-color: #3d4c63; padding: 10px 0; overflow: hidden; border-bottom: 2px solid #e3e3e3">
		<div style="padding-left: 20px;"><img src="/images/logo/logo_mk.png" alt="매일경제"/></div>	
	</div>
	<!-- //header -->
	<br/> 
	<div style="overflow: hidden; padding: 58px 0 55px 0;">  
		<div style="width: 100%; text-align: center;"> 
			<div style="width: 400px; text-align: center; padding: 12px 0 10px 0; margin: 0 auto; font-size: 2.3em; background-color: #3d4c63; font-weight: bold; color: #fff">구독자 정보조회</div>
		</div>
		<form name="autobillFm" id="autobillFm" method="post">
			<input type="hidden" name="flag" id="flag" value="${flag }" />
			<div class="loginDivBox" style="width: 400px;"> 
				<div class="loginInputBox" style="padding: 10px 0 15px 0;"><input type="text" name="bankNm" id="bankNm" style="width: 190px; padding: 5px;"></div>
				<div class="loginInputBox" ><input type="text" name="bankNumCode" id="bankNumCode" style="width: 190px; padding: 5px;" maxlength="15" onkeypress="inputNumCom();"></div>
				<div class="loginInputBox" style="padding: 10px 0; color: red;"><strong>※ 계좌번호는 -를 제외한 번호만 입력해주십시오.</strong></div>
				<div class="loginInputBox" style="padding: 5px 0 10px 0;">
					<div class="loginBtn" onclick="fn_login();">로그인</div> 
				</div>		 
			</div>
		</form>
	</div>
	<!-- notice -->
	<div style="padding: 20px 0 0 0; clear: both; text-align: center;">
		<div style="border-top: 2px solid #020202; padding: 10px 0 0 5px; font-size: 1.0em"> 
			Copyright© 2006. 매경인터넷(주). 서울특별시 중구 필동 1가 30-1 매경미디어센터 9층.<br/>
			매경인터넷은 회원의 허락없이 개인정보를 수집, 공개, 유출을 하지 않으며 회원정보의 보호를 위해 최선을 다합니다.<br/>
			사업자 등록번호 : 201-81-25980 / 통신판매업 신고 : 중구00083호&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;이용관련문의 : 02-2000-2000
		</div>
	</div>
	<!-- //notice -->
</div>
</body>
</html>  