<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>자동이체 거래내역 리스트</title>
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet"> 
<style type="text/css">
.header_logo {position:absolute; left:23px; top:20px}
</style>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript">
/**
 * 변경 버튼 클릭 이벤트
 */
function fn_upt_bankNum() {
	var fm = document.getElementById("bankNumFm");
	var bankInfoVal = cf_getValue("newBankInfo");
	var bankNumVal = cf_getValue("newBankNum");
	
	if(!cf_checkNull("newBankName", "예금주명/법인명")) { return false; }
	if(!cf_checkNull("newBankInfo", "이체은행")) { return false; }
	if(!cf_checkNull("newBankNum", "계좌번호")) { return false; }
	
	//011농협중앙회 , 012지역농협 구분
	if(bankInfoVal =='011' || bankInfoVal =='012'){
		if(bankNumVal.length == 11){
			bankInfoVal = '011';
		}else if(bankNumVal.length == 14){
			bankInfoVal = '012';
		}else if(bankNumVal.length == 13){
			if(bankNumVal.substring(1,2) == 5){
				bankInfoVal = '012';
			}else{
				bankInfoVal = '011';
			}	
		}
	}
	
	if(!confirm("등록한 내용을 저장하시겠습니까?")) {
		return false;
	}
	
	fm.target="_self";
	fm.action="/reader/subscriptionForm/updateBankNum.do";
	fm.submit();
}

/**
 * 팝업창 닫기
 */
function fn_window_close() {
	window.close();
}
</script>
</head>
<body>
<div class="box_Popup">
	<!-- header -->
	<div style="background:url(http://img.mk.co.kr/payment/bg_pay_top.gif) repeat-x 0 0;  height:45px; overflow: hidden; border-bottom: 2px solid #e3e3e3">
		<div class="header_logo"><img src="/images/logo/logo_mk.gif" alt="매일경제"/></div>	
	</div>
	<!-- //header -->
	<div style="overflow: hidden;">
		<div style="float: left; width: 190px; text-align: left;">
			<div><img alt="" src="/images/gif/logo_mypage.gif"></div>
			<div style="border: 1px solid #c5c5c5; width: 178px; padding: 15px 0; text-align: center;"><strong>${bankNm }</strong>&nbsp;님</div>
		</div>
		<div style="float: left; height: 369px">
			<div style="font-size: 1.3em; color: #747474; font-weight: bold; padding: 20px 10px 10px 10px ;">자동이체 결제계좌 상세내역</div>
			<!-- 기존계좌 -->
			<div style="border-top: 2px solid #020202; width: 500px">
				<table class="tb_view" style="width: 500px;">
					<colgroup>
						<col width="150px">
						<col width="350px">
					</colgroup>
				 	<tr>
				 		<th>은행명</th>
				 		<td>${readerData.BANKNM }</td>
				 	</tr>
				 	<tr>
				 		<th>독자명</th>
				 		<td>${readerData.USERNAME}</td>
				 	</tr>
				 	<tr>
				 		<th>예금주명/법인명</th>
				 		<td>${readerData.BANK_NAME }</td>
				 	</tr>
				 	<tr>
				 		<th>계좌번호</th>
				 		<td>${readerData.BANK_NUM }</td>
				 	</tr>
				</table>
			</div>	
			<!-- //기존계좌 -->
			<br /><br />
			<c:if test="${readerData.STATUS eq 'EA00'}">
				<div class="box_white" style="color: red; font-weight: bold; padding: 20px 0; width: 500px;">계좌번호 변경완료</div>
				<div style="text-align: right; padding-top: 130px; width: 500px">
					<span class="btnCss2"><a class="lk2" onclick="fn_window_close();">닫기</a></span>
				</div>	
		 	</c:if>
			<c:if test="${readerData.STATUS eq 'EA21'}">
			<!-- 변경계좌 -->
			<div style="font-size: 1.2em; color: #747474; font-weight: bold; padding: 20px 10px 5px 5px ;">[변경계좌]</div>
			<form method="post" name="bankNumFm" id="bankNumFm">
				<input type="hidden" name="readerType" id="readerType" value="${readerType }" />
				<input type="hidden" name="boseq" id="boseq" value="${boseq }" />
				<input type="hidden" name="readNo" id="readNo" value="${readNo }" />
				<input type="hidden" name="numId" id="numId" value="${readerData.NUMID }" />
				
				<div style="border-top: 2px solid #020202">
					<table class="tb_view" style="width: 500px;">
						<colgroup>
							<col width="150px">
							<col width="350px">
						</colgroup>
					 	<tr>
					 		<th>은행명</th>
					 		<td>
					 			<select id="newBankInfo" name="newBankInfo" style="width: 180px; vertical-align: middle;">
									<c:forEach items="${bankInfo }" var="list">
										<option value="${list.BANKNUM }" <c:if test="${list.BANKNUM eq readerData.BANK }"> selected</c:if> > ${list.BANKNAME }</option>
									</c:forEach>
								</select>
							</td>
					 	</tr>
					 	<tr>
					 		<th>예금주명/법인명</th>
					 		<td><input type="text" id="newBankName" name="newBankName" value="${readerData.BANK_NAME }" style="width: 250px"></td>
					 	</tr>
					 	<tr>
					 		<th>계좌번호</th>
					 		<td><input type="text" id="newBankNum" name="newBankNum" value="" maxlength="16" style="ime-Mode:disabled; width: 250px; vertical-align: middle;" onkeypress="inputNumCom();"/></td>
					 	</tr>
					</table>
				</div>
			</form>
			<!-- //변경계좌 -->
			<!-- button -->
			<div style="text-align: right; padding-top: 10px;">
				<span class="btnCss2"><a class="lk2" onclick="fn_upt_bankNum();" style="color: blue; font-weight: bold;">변경</a></span>
			</div>	
			<!-- //button -->
			</c:if>
		</div>
		<!-- notice -->
		<div style="padding: 20px 0 0 0; clear: both;">
			<div style="border-top: 2px solid #020202; padding: 10px 0 0 5px; font-size: 1.0em; text-align: center;"> 
				Copyright© 2006. 매경인터넷(주). 서울특별시 중구 필동 1가 30-1 매경미디어센터 9층.<br/>
				매경인터넷은 회원의 허락없이 개인정보를 수집, 공개, 유출을 하지 않으며 회원정보의 보호를 위해 최선을 다합니다.<br/>
				사업자 등록번호 : 201-81-25980 / 통신판매업 신고 : 중구00083호&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;이용관련문의 : 02-2000-2000
			</div>
		</div>
		<!-- //notice -->
	</div>
</div>
</body>
</html>