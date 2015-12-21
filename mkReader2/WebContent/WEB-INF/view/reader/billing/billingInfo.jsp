<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet">
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
//우편주소 팝업
function popAddr(){
	var fm = document.getElementById("billingInfoForm");
	
	var left = 0;
	var top = 30;
	var winStyle = "width=520,height=700,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
	newWin = window.open("", "pop_addr", winStyle);
	newWin.focus();
	
	fm.target = "pop_addr";
	fm.action = "/common/common/popNewAddr.do";
	fm.submit();
}
	
//우편주소팝업에서 우편주소 선택시 셋팅 펑션
function setAddr(zip , addr, newAddr, bdNm, dbMngNo){
	var fm = document.getElementById("billingInfoForm");
		
	fm.dlvZip.value = zip;
	fm.newaddr.value = newAddr;
	fm.addr1.value = addr;
	fm.addr2.value = bdNm;
	fm.bdMngNo.value = dbMngNo;
}
	
//부수에 따라 이체금액 셋팅
function setMoney(val){
	var bankMoney = document.getElementById("bankMoney");
	
	bankMoney.value = val * 15000;
}

//학생여부 체크
function controlMoney(){
	var stu = document.getElementById("stu");
	var busuVal = document.getElementById("busu").value;
	var bankMoney = document.getElementById("bankMoney");
	
	if(stu.checked == true){
		bankMoney.value = busuVal * 7500;
	}else{
		bankMoney.value = busuVal * 15000;
	}
}
	
	//최종 자동이체 등록
	function updatePaymentFinal(){
		var fm= document.getElementById("billingInfoForm");
		
		if(!cf_checkNull("userName", "구독자 성명/회사명")) { return false; }
		if(!cf_checkNull("dlvZip", "우편번호")) { return false; }
		if(!cf_checkNull("addr2", "상세주소")) { return false; }
		if(!cf_checkNull("newaddr", "새주소")) { return false; }
		if(!cf_checkNull("addr2", "상세주소")) { return false; }
		if(!cf_checkNull("bankMoney", "이체금액")) { return false; }
		if(!cf_checkNull("bankName", "예금주명/법인명")) { return false; }
		if(!cf_checkNull("bankInfo", "이체은행")) { return false; }
		if(!cf_checkNull("bankNum", "계좌번호")) { return false; }
		if(!cf_checkNull("saup", "주민등록번호/사업자등록번호")) { return false; }
		if(!cf_checkNull("handy2", "비상연락처")) { return false; }
		if(!cf_checkNull("handy3", "비상연락처")) { return false; }
		
		//011농협중앙회 , 012지역농협 구분
		if($("bankInfo").value =='011' || $("bankInfo").value =='012'){
			if($("bankNum").value.length == 11){
				$("bankInfo").value = '011';
			}else if($("bankNum").value.length == 14){
				$("bankInfo").value = '012';
			}else if($("bankNum").value.length == 13){
				if($("bankNum").value.substring(1,2) == 5){
					$("bankInfo").value = '012';
				}else{
					$("bankInfo").value = '011';
				}	
			}
		}
		if($("tmp_rdate").value != '' && ($("tmp_bankNum").value !='' && $("tmp_saup").value !='' && $("tmp_bank").value !='') ){
			if($("tmp_status").value == 'EA13' || $("tmp_status").value == 'EA13-' ){
				if($("tmp_bankNum").value != $("bankNum").value ){
					alert('계좌번호는 수정 불가합니다.');
					return;
				}
				if($("tmp_saup").value != $("saup").value ){
					alert('주민번호는 수정 불가합니다.');
					return;
				}
				if($("tmp_bank").value != $("bankInfo").value ){
					alert('이체은행은 수정 불가합니다.');
					return;
				}
			}else{
				if($("tmp_bankNum").value != $("bankNum").value ){
					alert('계좌번호는 수정 불가합니다. 계좌번호 변경 버튼을 이용해 주세요.');
					return;
				}
				if($("tmp_saup").value != $("saup").value ){
					alert('주민번호는 수정 불가합니다. 계좌번호 변경 버튼을 이용해 주세요.');
					return;
				}
				if($("tmp_bank").value != $("bankInfo").value ){
					alert('이체은행은 수정 불가합니다. 계좌번호 변경 버튼을 이용해 주세요.');
					return;
				}
			}
		}
		
		if(!confirm("수정된 내용을 저장하시겠습니까?")) {
			return false;
		}
		
		fm.target="_self";
		fm.action="/reader/billing/updatePaymentFinal.do";
		fm.submit();
		window.opener.fn_search();
		window.close();
	}
	
//통화기록 보기
function callLog(){
	var fm= document.getElementById("billingInfoForm");
	
	var left = (screen.width)?(screen.width - 830)/2 : 10;
	var top = (screen.height)?(screen.height - 600)/2 : 10;
	var winStyle = "width=400,height=500,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
	newWin = window.open("", "call_log", winStyle);
	newWin.focus();
	
	fm.target = "call_log";
	fm.action = "/reader/billing/popRetrieveCallLog.do?typeCd=1";
	fm.submit();
}

//계좌번호 변경 팝업
function popChangeBankNum(){
	var fm= document.getElementById("billingInfoForm");
	
	if($("tmp_status").value == 'EA13' || $("tmp_status").value == 'EA13-' ){
		alert("신규 CMS 확인중, 해지 신청중인 상태에서는 \n계좌번호 변경이 불가합니다."); 
		return;
	}
	var left = (screen.width)?(screen.width - 1330)/2 : 10;
	var top = (screen.height)?(screen.height - 200)/2 : 10;
	var winStyle = "width=400,height=500,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
	newWin = window.open("", "pop_addr", winStyle);
	newWin.focus();
	
	fm.target = "pop_addr";
	fm.action = "/reader/billing/popChangeBank.do";
	fm.submit();
}
	
	
//계좌번호 변경
function changeBankNum(bankMoney , bankName , bankInfo , bankNum , saup , handy1 , handy2 , handy3){
	var fm = document.getElementById("billingInfoForm");
	
	document.getElementById("bankMoney").value = bankMoney;
	document.getElementById("bankName").value = bankName;
	document.getElementById("bankInfo").value = bankInfo;
	document.getElementById("bankNum").value = bankNum;
	document.getElementById("saup").value = saup;
	document.getElementById("handy1").value = handy1;
	document.getElementById("handy2").value = handy2;
	document.getElementById("handy3").value = handy3;
	
	fm.target = "_self";
	fm.action = "/reader/billing/changeBank.do";
	fm.submit();
}
	
/**
 *	비고 더보기 클릭 이벤트
 **/
function fn_memo_view_more(readno) {
	var winW = (screen.width-300)/2;
	var winH = (screen.height-600)/2;
	var url = '/util/memo/popMemoList.do?readno='+readno;
	
	window.open(url, '', 'width=300px, height=600px, resizable=yes, status=no, toolbar=no, location=no, top='+winH+', left='+winW);
}
	
/**
 * 주소변경여부
 */
function fn_addr_chg() {
	var fm = document.getElementById("billingInfoForm");
	
	fm.addrChgYn.value = "Y";
}
	
/**
  *	 팝업닫기
  **/
function fn_popClose() {
	window.close();
}
	
var countCalllog = ${countCalllog};
jQuery.noConflict();
jQuery(document).ready(function($){ 
	if(countCalllog > 0) {
		$("#callLog").css("display", "block");
	}
});
</script>
</head>
<body>
<div class="box_Popup">
	<!-- title -->
	<div class="pop_title_box">일반독자 상세보기</div>
		<form id="billingInfoForm" name="billingInfoForm" action="" method="post">
			<input type="hidden" id="numId" name="numId" value="${billingInfo.NUMID }" />
			<input type="hidden" id="tmp_bankNum" name="tmp_bankNum" value="${billingInfo.BANK_NUM }" />
			<input type="hidden" id="tmp_saup" name="tmp_saup" value="${billingInfo.SAUP }" />
			<input type="hidden" id="tmp_status" name="tmp_status" value="${billingInfo.STATUS }" />
			<input type="hidden" id="tmp_rdate" name="tmp_rdate" value="${billingInfo.RDATE }" />
			<input type="hidden" id="inType" name="inType" value="기존" />
			<input type="hidden" id="addrChgYn" name="addrChgYn" value="N" />
			<input type="hidden" id="bdMngNo" name="bdMngNo" value="${billingInfo.BDMNGNO }" />
			
			<div class="box_list" style="width: 710px">
				<div style="width: 710px;  font-weight: bold; padding-bottom: 5px;"><b class="b03">* 필수 기재란 입니다.</b></div>
				<table class="tb_edit_left" style="width: 710px">
					<colgroup>
						<col width="180px">
						<col width="530px">
					</colgroup>
					<tr>
					 	<th><b class="b03">*</b> 구독자 성명/회사명</th>
						<td ><input type="text" id="userName" name="userName" value="${billingInfo.USERNAME }"></td>
					</tr>									
					<tr>
					 	<th>&nbsp;&nbsp; 전화번호</th>
						<td >
							<c:choose>
							<c:when test="${empty billingInfo.PHONE }">
								<c:set var="phone" value="${fn:split('02-0000-0000', '-') }"></c:set>	
							</c:when>
							<c:otherwise>
								<c:set var="phone" value="${fn:split(billingInfo.PHONE, '-') }"></c:set>
							</c:otherwise>
							</c:choose>
							<select id="phone1" name="phone1">
								<option value=""></option>
								<c:forEach items="${areaCode }" var="list">
									<option value="${list.CODE }" <c:if test="${list.CODE eq phone[0] }"> selected </c:if>>${list.CODE }</option>
								</c:forEach>
							</select> - 
							<input type="text" id="phone2" name="phone2" value="${phone[1] }" maxlength="4" style="width: 40px; ime-Mode:disabled" onkeypress="inputNumCom();"> - 
							<input type="text" id="phone3" name="phone3" value="${phone[2] }" maxlength="4" style="width: 40px; ime-Mode:disabled" onkeypress="inputNumCom();">
						</td>
					</tr>						 						
					<tr>
					 	<th><b class="b03">*</b> 우편번호 </th>
						<td >
							<input type="text" id="dlvZip" name="dlvZip" value="${billingInfo.DLVZIP }" style="width: 40px; vertical-align: middle;" readonly="readonly" />
							<a href="#fakeUrl" onclick="popAddr();"><img alt="우편번호찾기" src="/images/ico_search2.gif" style="border: 0; vertical-align: middle;" /></a>
						</td>	
					</tr>									
					<tr>
			 	<th><b class="b03">*</b> 도로명주소</th>
						<td >
							<input type="text" id="newaddr" name="newaddr" value="${billingInfo.NEWADDR}" style="width: 450px; vertical-align: middle; border: 0;" readonly="readonly" onchange="fn_addr_chg();"  />
						</td>
					</tr>							
					<tr>
					 	<th><b class="b03">*</b> 지번주소</th>
						<td >
							<input type="text" id="addr1" name="addr1" value="${billingInfo.ADDR1 }" style="width: 450px; vertical-align: middle; border: 0;" readonly="readonly"  />
						</td>
					</tr>														 	
					<tr>
					 	<th><b class="b03">*</b> 상세주소</th>
						<td>
							<input type="text" id="addr2" name="addr2" value="${billingInfo.ADDR2 }" style="width: 450px;" onchange="fn_addr_chg();"  />
						</td>
					</tr>	
					<tr>
					 	<th><img src="/images/ic_arr.gif" border="0" style="vertical-align: middle;"/> 구독부수</th>
						<td>
							<select id="busu" name="busu" onchange="setMoney(this.value);">
							<c:forEach begin="1" end="30" step="1" varStatus="i">
								<option value="${i.index }" <c:if test="${i.index eq billingInfo.BUSU }"> selected</c:if>>${i.index }</option>
							</c:forEach>
							</select>
						</td>
					</tr>	
					<tr>
					 	<th>&nbsp;&nbsp; 납부자번호</th>
						<td >
							<input type="text" id="jiSerial" name="jiSerial" value="${billingInfo.JIKUK}" size="6" readonly="readonly" />  
							<input type="text" id="serial" name="serial" value="${billingInfo.SERIAL}" readonly="readonly" style="width: 55px;" /> "매일경제신문사 기재란 입니다"
						</td>
					</tr>						 						 						 						 				 				 				 	
					<tr>
					 	<th>&nbsp;&nbsp; 독자번호</th>
						<td ><input type="text" id="readNo" name="readNo" value="${billingInfo.READNO }" readonly="readonly" style="width: 100px" /> "매일경제신문사 기재란 입니다"</td>
					</tr>
					<tr>
					 	<th>&nbsp;&nbsp; 신청일시</th>
					 	<c:choose>
					 	<c:when test="${billingInfo.WHOSTEP eq '1'}">
					 	<c:set var="step" value="본사"></c:set>
					 	</c:when>
					 	<c:when test="${billingInfo.WHOSTEP eq '2'}">
					 	<c:set var="step" value="지국"></c:set>
					 	</c:when>
					 	<c:otherwise>
					 	<c:set var="step" value="인터넷"></c:set>
					 	</c:otherwise>
					 	</c:choose>
						<td ><span> ${billingInfo.INDATE } <font class="b03"><b>[${step }]</b></font></span></td>
					</tr>
				</table>
				<div style="padding: 20px 0 5px 0; font-weight: bold; width: 710px;">납부자 정보</div>
				<table class="tb_edit_left" style="width: 710px">
					<colgroup>
						<col width="180px">
						<col width="530px">
					</colgroup>
				 	<tr>
				 		<th>&nbsp;&nbsp; 학생여부</th>
						<td><input type="checkbox" id="stu" name="stu" onclick="controlMoney();">학생이면 체크</td>
					</tr>
				 	<tr>
				 		<th><b class="b03">*</b> 이체금액</th>
						<td>
							<input type="text" id="bankMoney" name="bankMoney" value="${billingInfo.BANK_MONEY }" style="ime-Mode:disabled" onkeypress="inputNumCom();">
							<font class="b03" style="letter-spacing: -1px;">* 다부수 고객의 경우 모든 구독 정보의 단가합을 입력해주시기 바랍니다.</font>
						</td>
					</tr>
					<tr>
					 	<th><b class="b03">*</b> 예금주명/법인명</th>
						<td><input type="text" id="bankName" name="bankName" value="${billingInfo.BANK_NAME }" /></td>
					</tr>
					<tr>
					 	<th><b class="b03">*</b> 이체은행/계좌번호</th>
						<td>
							<input type="hidden" id="tmp_bank" name="tmp_bank" value="${billingInfo.BANK }" />
							<select id="bankInfo" name="bankInfo">
								<c:forEach items="${bankInfo }" var="list">
									<option value="${list.BANKNUM }" <c:if test="${list.BANKNUM eq billingInfo.BANK }"> selected</c:if> > ${list.BANKNAME }</option>
								</c:forEach>
							</select>&nbsp;
							<input type="text" id="bankNum" name="bankNum" value="${billingInfo.BANK_NUM }" maxlength="16" style="ime-Mode:disabled" onkeypress="inputNumCom();">
						</td>
					</tr>							
					<tr>
					 	<th><b class="b03">*</b> 주민등록번호/<Br/>사업자등록번호</th>
						<td><input type="text" id="saup" name="saup" value="${billingInfo.SAUP }"  maxlength="13" style="ime-Mode:disabled" onkeypress="inputNumCom();"><br>* 계좌번호 발급시기재된 주민번호</td>
					</tr>
					<tr>
					 	<th><b class="b03">*</b> 예금주 비상연락처</th>
						<td>
							<c:choose>
								<c:when test="${empty billingInfo.HANDY }">
									<c:set var="handy" value="${fn:split('010-0000-0000', '-') }"></c:set>	
								</c:when>
								<c:otherwise>
									<c:set var="handy" value="${fn:split(billingInfo.HANDY, '-') }"></c:set>
								</c:otherwise>
							</c:choose>
							<select id="handy1" name="handy1">
								<c:forEach items="${mobileCode }" var="list">
									<option value="${list.CODE }" <c:if test="${list.CODE eq handy[0] }"> selected </c:if>>${list.CODE }</option>
								</c:forEach>
							</select> - 
							<input type="text" id="handy2" name="handy2" value="${handy[1] }" maxlength="4" style="width: 40px; ime-Mode:disabled" onkeypress="inputNumCom();" /> - 
							<input type="text" id="handy3" name="handy3" value="${handy[2] }" maxlength="4" style="width: 40px; ime-Mode:disabled" onkeypress="inputNumCom();" />
						</td>
					</tr>						 						
					<tr>
					 	<th >&nbsp;&nbsp; 이메일</th>
						<td ><input type="text" id="email" name="email" value="${billingInfo.EMAIL }" style="width: 250px" /></td>
					</tr>						 
					<tr>
					 	<th>&nbsp;&nbsp;<font class="box_p">비고/통신란</font><br>&nbsp;&nbsp; "200자 내외 작성"</th>
						<td>
							<!-- memo list -->
							<c:forEach items="${memoList}" var="list" begin="0" end="2"  varStatus="status">
								<div style="padding: 5px 0; border-bottom: 1px solid #e5e5e5; width: 510px;">
									<div style="font-weight: bold; padding-bottom: 3px;">[${list.CREATE_ID}]&nbsp;${list.CREATE_DATE}</div>
									<div style="width: 510px; word-break: break-all;'">${list.MEMO}</div>
								</div>
							</c:forEach> 
							<c:if test="${fn:length(memoList) > 3}">
								<div style="padding: 3px 0; text-align: right; width: 510px;"><a href="#fakeUrl" onclick="fn_memo_view_more('${billingInfo.READNO }')"><img alt="더보기" title="더보기" src="/images/ico_more.gif" /></a></div>
							</c:if>
							<!-- //memo list -->
							<div style="padding-top: 3px;">
								<textarea id="memo" name="memo" style="width: 95%"></textarea>
							</div>
						</td>
					</tr>														 	
				</table>						
				<div style="width: 710px; text-align: right; padding-top: 10px;">
		 			<a href="#fakeUrl" onclick="callLog();"><img src="/images/call_memo.gif" style="vertical-align: middle" /></a>
		 			<span id="callLog" style="display:none"><img src="/images/icon_new.gif" border="0" align="top" /></span>
			  		<a href="#fakeUrl" onclick="updatePaymentFinal();"><img src="/images/bt_save.gif" style="vertical-align: middle" /></a>  
			  		<a href="#fakeUrl" onclick="fn_popClose();"><img src="/images/bt_close.gif" style="border: 0; vertical-align: middle" /></a>
			  		<c:if test="${not empty billingInfo.RDATE }"><a href="#fakeUrl" onclick="popChangeBankNum();"><img src="/images/change_bank.gif" style="vertical-align: middle" /></a></c:if>
		 		</div>
		 	</div>
		</form>
	</div>
</body>
</html>