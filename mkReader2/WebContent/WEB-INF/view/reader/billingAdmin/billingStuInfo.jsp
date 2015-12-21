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
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel='stylesheet' type='text/css' href="/select2/select2.css"/>
<script type="text/javascript">
//우편주소 팝업
function popAddr(){
	var fm = document.getElementById("billingInfoForm");
	
	var left = 0;
	var top = 10;
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
	fn_addr_chg();
}
//지국정보 변경 컨트롤
function jikukControl(){
	$("jiSerial").value = $("realJikuk").value;	
}
//부수에 따라 이체금액 셋팅
function setMoney(){
	$("bankMoney").value = $("busu").value * 7500;
}

//자동이체 독자 등록
function savePayment(){
	var fm = document.getElementById("billingInfoForm");
	var handy2 = document.getElementById("handy2");
	var handy3 = document.getElementById("handy3");
	var bankInfoVal = document.getElementById("bankInfo").value;
	var bankNumVal = document.getElementById("bankNum").value;
	
	if(!cf_checkNull("stuSch", "대학명")) { return false; }
	if(!cf_checkNull("stuPart", "학과")) { return false; }
	if(!cf_checkNull("stuClass", "학년")) { return false; }
	if(!cf_checkNull("userName", "구독자 성명/회사명")) { return false; }
	if(!cf_checkNull("newaddr", "도로명주소")) { return false; }
	if(!cf_checkNull("addr1", "지번주소")) { return false; }
	if(!cf_checkNull("addr2", "상세주소")) { return false; }
	if(!cf_checkNull("bankMoney", "이체금액")) { return false; }
	if(!cf_checkNull("bankName", "예금주명/법인명")) { return false; }
	if(!cf_checkNull("bankInfo", "이체은행")) { return false; }
	if(!cf_checkNull("bankNum", "계좌번호")) { return false; }
	if(!cf_checkNull("saup", "생년월일/사업자등록번호")) { return false; }
	if(!cf_checkNull("handy2", "비상연락처")) { return false; }
	if(!cf_checkNull("handy3", "비상연락처")) { return false; }
	
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

	if(!confirm("등록한 내용을 저장하시겠습니까?")) { return false; }
	
	fm.target="_parent";
	fm.action="/reader/billingStuAdmin/savePayment.do";
	fm.submit();
	window.opener.fn_search();
	window.close();
}
	
	//자동이체 정보수정
	function updatePaymentFinal(){
		var frm = document.getElementById("billingInfoForm");
		
		if($("stuSch").value == '' ){
			alert('대학명을 입력해주세요.');
			$("stuSch").focus();
			return;
		}
		if($("stuPart").value == '' ){
			alert('학과를 입력해주세요.');
			$("stuPart").focus();
			return;
		}
		if($("stuClass").value == '' ){
			alert('학년을 입력해주세요.');
			$("stuClass").focus();
			return;
		}
		if($("userName").value == '' ){
			alert('구독자 성명/회사명을 입력해주세요.');
			$("userName").focus();
			return;
		}
	
		//if(!cf_checkNull("newaddr", "도로명주소")) { return false; }
		if(!cf_checkNull("addr1", "지번주소")) { return false; }
		if($("addr2").value == '' ){
			alert('상세주소를 입력해주세요.');
			$("addr2").focus();
			return;
		}
		if($("bankMoney").value == '' ){
			alert('이체금액을 입력해주세요.');
			$("bankMoney").focus();
			return;
		}
		if($("bankName").value == '' ){
			alert('예금주명/법인명 입력해주세요.');
			$("bankName").focus();
			return;
		}
		if($("bankInfo").value.length != 3 ){
			alert('이체 은행을 입력해주세요.');
			$("bankInfo").focus();
			return;
		}
		if($("bankNum").value == '' ){
			alert('계좌 번호를 입력해주세요.');
			$("bankNum").focus();
			return;
		}
		if($("saup").value == '' ){
			alert('생년월일\n사업자등록번호를 입력해주세요.');
			$("saup").focus();
			return;
		}
		if($("handy2").value == '' ){
			alert('비상연락처를 입력해주세요.');
			$("handy2").focus();
			return;
		}
		if($("handy3").value == '' ){
			alert('비상연락처를 입력해주세요.');
			$("handy3").focus();
			return;
		}
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
		//개인사업체의 경우 주민번호만 입력 가능
		if($("saup").value.length=='11'){
			if($("saup").value.substring(3,4) != 8){
				alert('개인사업체의 경우 주민번호를 입력해 주시기 바랍니다.');
				$("saup").focus();
				return;
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
		
		if($("jiSerial").value == ''){
			alert('지국을 선택해 주시기 바랍니다.');
			$("realJikuk").focus();
			return;
		}
		if($("rDate").checked == false){
			alert('지국통보여부 체크란을 체크해주시기 바랍니다.');
			$("rDate").focus();
			return;
		}
		if($("newYn").checked == true && $("rDate").checked == false ){
			alert('지국통보여부 체크란을 체크해주시기 바랍니다.');
			$("rDate").focus();
			return;
		}
		if($("tmp_rdate").value !='' && $("old_realJikuk").value !='' && ( $("realJikuk").value != $("old_realJikuk").value)  ){
			if($("tmp_status").value != 'EA00' && $("tmp_status").value != 'EA21' ){
				alert("신규 신청, 정상 상태에서만 지국 변경이 가능합니다."); 
				return;
			}
			if(confirm('지국을 변경 하시겠습니까?.') == false){
				return;
			}else{
				var sgBgmm = prompt('수금시작월을 입력해 주세요.\nex)201201', '');
				if ((sgBgmm == '') || (sgBgmm == null)){
		        	alert('수금시작월을 입력해 주세요.');
		        	return;
		        }else{
		        	if(sgBgmm.length != 6){
		        		alert('수금시작월을 YYYYMM 형태로 입력해 주세요.');
			        	return;
		        	}else{
		        		if( Number(sgBgmm.substring(4,6)) < 1 ||  Number(sgBgmm.substring(4,6)) > 12  ){
		        			alert('수금시작월을 YYYYMM 형태로 입력해 주세요.');
				        	return;
		        		}
		        	}
		        }
				$("sgBgmm").value = sgBgmm;
				frm.inType[0].checked = true;
			}
		}
	
		if(frm.inType[1].checked == true){
			if(confirm('신규 고객의 경우 해당 지국에 구독 정보가 자동 생성됩니다.\n기존독자의 경우 독자유형을 기존고객으로 변경 해주시기 바랍니다.\n계속 진행하시겠습니까?.') == false){
				return;
			}
		}else{
			if($("readNo").value == ''){
				alert('독자번호를 입력해 주시기 바랍니다.');
				$("readNo").focus();
				return;
			}
		}
		
		$("email").value;
		
		if(!confirm("수정된 내용을 저장하시겠습니까?")) { return false; }
		
		billingInfoForm.target="_self";
		billingInfoForm.action="/reader/billingStuAdmin/updatePaymentFinal.do";
		billingInfoForm.submit();
		window.opener.fn_search();
	}
	
//통화기록 보기
function callLog(){
	var fm = document.getElementById("billingInfoForm");
	
	var left = (screen.width)?(screen.width - 830)/2 : 10;
	var top = (screen.height)?(screen.height - 600)/2 : 10;
	var winStyle = "width=400,height=500,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
	newWin = window.open("", "call_log", winStyle);
	newWin.focus();
	
	fm.target = "call_log";
	fm.action = "/reader/billingStuAdmin/popRetrieveCallLog.do?typeCd=2";
	fm.submit();
}
	
//계좌번호 변경 팝업
function popChangeBankNum(){
	var fm = document.getElementById("billingInfoForm");
	var tmpStatus = document.getElementById("tmp_status").value;
	
	if(tmpStatus == 'EA13' || tmpStatus == 'EA13-' ){
		alert("신규 CMS 확인중, 해지 신청중인 상태에서는 \n계좌번호 변경이 불가합니다."); 
		return;
	}
	
	var left = (screen.width)?(screen.width - 1330)/2 : 10;
	var top = (screen.height)?(screen.height - 200)/2 : 10;
	var winStyle = "width=400,height=500,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
	newWin = window.open("", "pop_addr", winStyle);
	newWin.focus();
	
	fm.target = "pop_addr";
	fm.action = "/reader/billingStuAdmin/popChangeBank.do";
	fm.submit();
}

//계좌번호 변경
function changeBankNum(bankMoney , bankName , bankInfo , bankNum , saup , handy1 , handy2 , handy3){
	var fm = document.getElementById("billingInfoForm");
	
	fm.bankMoney.value = bankMoney;
	fm.bankName.value = bankName;
	fm.bankInfo.value = bankInfo;
	fm.bankNum.value = bankNum;
	fm.saup.value = saup;
	fm.handy1.value = handy1;
	fm.handy2.value = handy2;
	fm.handy3.value = handy3;
	
	fm.target = "_self";
	fm.action = "/reader/billingStuAdmin/changeBank.do";
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
	};
	//$("#bankInfo, #realJikuk").select2({minimumInputLength: 1});
	$("#realJikuk").select2({minimumInputLength: 1});
});
</script>
</head>
<body>
<div class="box_Popup">
	<!-- title --> 
	<div class="pop_title_box">자동이체 학생관리 <c:if test="${flag == 'INS' }">등록</c:if><c:if test="${flag == 'UPT' }">수정</c:if></div>
	<form id="billingInfoForm" name="billingInfoForm" action="" method="post">
	<input type="hidden" id="numId" name="numId" value="${billingInfo.NUMID }" />
	<input type="hidden" id="tmp_bankNum" name="tmp_bankNum" value="${billingInfo.BANK_NUM }" />
	<input type="hidden" id="tmp_saup" name="tmp_saup" value="${billingInfo.SAUP }" />
	<input type="hidden" id="tmp_status" name="tmp_status" value="${billingInfo.STATUS }" />
	<input type="hidden" id="tmp_rdate" name="tmp_rdate" value="${billingInfo.RDATE }" />
	<input type="hidden" id="old_realJikuk" name="old_realJikuk" value="${billingInfo.REALJIKUK }" />
	<input type="hidden" id="sgBgmm" name="sgBgmm" value="" />
	<input type="hidden" id="bdMngNo" name="bdMngNo" value="${billingInfo.BDMNGNO }" />
	<input type="hidden" id="addrChgYn" name="addrChgYn" value="N" />
	<!-- edit -->
	<div style="width: 710px; padding-top: 10px;">
		<div style="width: 710px;  font-weight: bold; padding-bottom: 3px;"><b class="b03">* 필수 기재란 입니다.</b></div>
		<table class="tb_edit_left" style="width: 710px">
			<colgroup>
				<col width="120px">
				<col width="235px">
				<col width="120px">
				<col width="235px">
			</colgroup>
			<tr>
				<th><b class="b03">*</b> 성명</th>
				<td><input type="text" id="userName" name="userName" value="${billingInfo.USERNAME }" style="width: 200px;" /></td>
			 	<th><b class="b03">*</b> 고객구분</th>
				<td>
					<c:choose>
						<c:when test="${empty billingInfo.READNO }">
							<input type="radio" id="inType" name="inType" value="기존"  <c:if test="${billingInfo.INTYPE eq '기존' }"> checked </c:if> style="vertical-align: middle; border: 0;" /> 기존고객 &nbsp;&nbsp;&nbsp;&nbsp; 
							<input type="radio" id="inType" name="inType" value="신규"  <c:if test="${billingInfo.INTYPE eq '신규' }"> checked </c:if> style="vertical-align: middle; border: 0;" /> 신규고객
						</c:when>
						<c:otherwise>
							<div style="padding: 4px 0;"><b class="b03">${billingInfo.INTYPE }</b></div>
							<div style="display: none;">
								<input type="radio" id="inType" name="inType" value="기존" <c:if test="${billingInfo.INTYPE eq '기존' }"> checked </c:if> style="vertical-align: middle; border: 0;" /> 기존고객 &nbsp;&nbsp;&nbsp;&nbsp; 
								<input type="radio" id="inType" name="inType" value="신규" <c:if test="${billingInfo.INTYPE eq '신규' }"> checked </c:if> style="vertical-align: middle; border: 0;" /> 신규고객
							</div>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr>
			 	<th>&nbsp;&nbsp;대학명</th>
				<td colspan="3"><input type="text" id="stuSch" name="stuSch" value="${billingInfo.STU_SCH }" style="width: 300px;" /></td>
			</tr>
			<tr>
			 	<th>&nbsp;&nbsp;학년/학과</th>
				<td colspan="3">
					<select id="stuClass" name="stuClass" style="vertical-align: middle;">
						<option value="1" <c:if test="${billingInfo.STU_CLASS eq '1'}">selected="selected"</c:if>>1학년</option>
						<option value="2" <c:if test="${billingInfo.STU_CLASS eq '2'}">selected="selected"</c:if>>2학년</option>
						<option value="3" <c:if test="${billingInfo.STU_CLASS eq '3'}">selected="selected"</c:if>>3학년</option>
						<option value="4" <c:if test="${billingInfo.STU_CLASS eq '4'}">selected="selected"</c:if>>4학년</option>
					</select>&nbsp;
					<input type="text" id="stuPart" name="stuPart" value="${billingInfo.STU_PART }" style="width: 300px; vertical-align: middle;" />
				</td>
			</tr>
			<tr>
			 	<th><b class="b03">*</b> 휴대폰</th>
				<td>
					<c:choose>
						<c:when test="${empty billingInfo.HANDY }">
							<c:set var="handy" value="${fn:split('010-0000-0000', '-') }"></c:set>	
						</c:when>
						<c:otherwise>
							<c:set var="handy" value="${fn:split(billingInfo.HANDY, '-') }"></c:set>
						</c:otherwise>
					</c:choose>
					<select id="handy1" name="handy1" style="vertical-align: middle;">
						<c:forEach items="${mobileCode }" var="list">
							<option value="${list.CODE }" <c:if test="${list.CODE eq handy[0] }"> selected </c:if>>${list.CODE }</option>
						</c:forEach>
					</select> - 
					<input type="text" id="handy2" name="handy2" value="${handy[1] }" maxlength="4" style="ime-Mode:disabled; width: 45px; vertical-align: middle;" onkeypress="inputNumCom();"> - 
					<input type="text" id="handy3" name="handy3" value="${handy[2] }" maxlength="4" style="ime-Mode:disabled; width: 45px; vertical-align: middle;" onkeypress="inputNumCom();">
				</td>
			 	<th> &nbsp;&nbsp;전화번호</th>
				<td >
					<c:choose>
						<c:when test="${empty billingInfo.PHONE }">
							<c:set var="phone" value="${fn:split('02-0000-0000', '-') }"></c:set>	
						</c:when>
						<c:otherwise>
							<c:set var="phone" value="${fn:split(billingInfo.PHONE, '-') }"></c:set>
						</c:otherwise>
					</c:choose>
					<select id="phone1" name="phone1" style="vertical-align: middle;">
						<option value=""></option>
						<c:forEach items="${areaCode }" var="list">
							<option value="${list.CODE }" <c:if test="${list.CODE eq phone[0] }"> selected </c:if>>${list.CODE }</option>
						</c:forEach>
					</select> - 
					<input type="text" id="phone2" name="phone2" value="${phone[1] }" maxlength="4" style="ime-Mode:disabled; width: 45px; vertical-align: middle;" onkeypress="inputNumCom();"> - 
					<input type="text" id="phone3" name="phone3" value="${phone[2] }" maxlength="4" style="ime-Mode:disabled; width: 45px; vertical-align: middle;" onkeypress="inputNumCom();">
				</td>
			</tr>						 						
			<tr>
			 	<th><b class="b03">*</b> 우편번호</th>
				<td >
					<input type="text" id="dlvZip" name="dlvZip" value="${billingInfo.DLVZIP }" style="width: 50px; vertical-align: middle;" readonly="readonly" />
					<a href="#fakeUrl" onclick="popAddr();"><img alt="우편번호찾기" src="/images/ico_search2.gif" style="border: 0; vertical-align: middle;" /></a>
				</td>
			 	<th><b class="b03">*</b> 지번주소</th>
				<td >
					<input type="text" id="addr1" name="addr1" value="${billingInfo.ADDR1 }" style="width: 210px; vertical-align: middle; border: 0;" readonly  />
				</td>
			</tr>					
			<tr>
			 	<th><b class="b03">*</b> 도로명주소</th>
				<td colspan="3">
					<input type="text" id="newaddr" name="newaddr" value="${billingInfo.NEWADDR }" style="width: 500px; vertical-align: middle; border: 0;" readonly onchange="fn_addr_chg();"  />
				</td>
			</tr>												 	
			<tr>
			 	<th><b class="b03">*</b> 상세주소</th>
				<td colspan="3">
					<input type="text" id="addr2" name="addr2" value="${billingInfo.ADDR2 }" style="width: 500px;" onchange="fn_addr_chg();" maxlength="100" />
				</td>
			</tr>	
			<tr>
			 	<th>&nbsp;&nbsp;납부자번호</th>
				<td colspan="3">
					<input type="text" id="jiSerial" name="jiSerial" value="${billingInfo.JIKUK}" readonly="readonly" style="width: 55px; vertical-align: middle; background-color:#f46f2e;" />  
					<input type="text" id="serial" name="serial" value="${billingInfo.SERIAL}" style="width: 100px; vertical-align: middle; background-color:#fff;" readonly="readonly" /> "매일경제신문사 기재란 입니다"
				</td>
			</tr>						 						 						 						 				 				 				 	
			<tr>
			 	<th><b class="b03">*</b> 독자번호</th>
				<td >
					<input type="text" id="readNo" name="readNo" value="${billingInfo.READNO }" style="width: 75px;" maxlength="9" />&nbsp;&nbsp;&nbsp;<span style="font-weight: bold; letter-spacing: -1px; color: #e74985">※기존고객은 필수</span>
				</td>
			 	<th>&nbsp;&nbsp;신청일시</th>
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
				<td ><div style="padding: 4px 0;"> ${billingInfo.INDATE } <font class="b03"><b>[${step }]</b></font></div></td>
			</tr>
		</table>
		<div style="padding-top: 8px">
			<table class="tb_edit_left" style="width: 710px;">
				<colgroup>
					<col width="120px">
					<col width="235px">
					<col width="120px">
					<col width="235px">
				</colgroup>
				<tr>
				 	<th>&nbsp;&nbsp;구독부수</th>
					<td colspan="3">
						<select id="busu" name="busu" onchange="setMoney();">
							<c:forEach begin="1" end="30" step="1" varStatus="i">
								<option value="${i.index }" <c:if test="${i.index eq billingInfo.BUSU }"> selected</c:if>>${i.index }</option>
							</c:forEach>
						</select>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="checkbox" id="rDate" name="rDate" style="border: 0; vertical-align: middle;" <c:if test="${not empty billingInfo.RDATE }">checked="checked"</c:if>> <span style="vertical-align: middle;">지국통보여부(<c:if test="${not empty billingInfo.RDATE }">${billingInfo.RDATE }</c:if>)</span>
						<select name="realJikuk" id="realJikuk" style="vertical-align: middle;  width: 100px;" <c:if test="${empty billingInfo.SERIAL}">onchange="jikukControl();"</c:if>>
							<option value=""></option>
							<c:forEach items="${agencyAllList }" var="list">
								<option value="${list.SERIAL }" <c:if test="${billingInfo.REALJIKUK eq list.SERIAL}">selected </c:if>>${list.NAME } </option>
							</c:forEach>
						</select>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="checkbox" id="newYn" name="newYn" style="border: 0; vertical-align: middle;"<c:if test="${billingInfo.NEWYN eq 'Y'}">checked</c:if>> <span style="vertical-align: middle;">본사신규등록</span>
					</td>
				</tr>		
				<tr>
				 	<th>&nbsp;&nbsp;이메일</th>
					<td><input type="text" id="email" name="email" value="${billingInfo.EMAIL }" style="width: 210px"></td>
					<th>&nbsp;&nbsp;추천교수</th>
					<td ><input type="text" id="stuProf" name="stuProf" value="${billingInfo.STU_PROF }" style="width: 100px;" /></td>
				</tr>
				<tr >
					<th>&nbsp;&nbsp;통화자</th>
					<td><input type="text" id="stuCaller" name="stuCaller" value="${billingInfo.STU_CALLER }" style="width: 100px;" /></td>
				 	<th>&nbsp;&nbsp;권유자</th>
					<td ><input type="text" id="stuAdm" name="stuAdm" value="${billingInfo.STU_ADM }" style="width: 100px;" /></td>
				 </tr>
			</table>  
		</div>	
		<!-- 예약해지관련 -->
		<c:if test="${billingInfo.STATUS eq 'EA21' }"> 
			<div style="padding: 20px 0 5px 0; font-weight: bold; width: 710px;">예약해지 정보</div>
			<table class="tb_edit_left" style="width: 710px">
				<colgroup>
					<col width="120px">
					<col width="590px">
				</colgroup>
				<tr>
					<th>&nbsp;&nbsp;예약해지일</th>
					<td>
						<input type="text" name="cancelDt" id="cancelDt" value="${stopReserveData.RESERVEDT }" style="width: 90px" readonly onclick="Calendar(this)" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<c:if test="${stopReserveData.RESERVEDT ne null }"><b>[${stopReserveData.INPS }] ${stopReserveData.INDT } </b></c:if>
					</td>
				</tr>
				<tr>
					<th>&nbsp;&nbsp;예약해지메모</th>
					<td><input type="text" name="cancelMemo" id="cancelMemo"  value="${stopReserveData.MEMO }" style="width: 500px"></td>
				</tr>
			</table>
		</c:if>
		<!--  //예약해지관련 -->
		<div style="padding: 20px 0 5px 0; font-weight: bold; width: 710px;">납부자 정보</div>
		<table class="tb_edit_left" style="width: 710px">
			<colgroup>
				<col width="120px">
				<col width="590px">
			</colgroup>
		 	<tr>
		 		<th><b class="b03">*</b> 이체금액</th>
				<td>
					<input type="text" id="bankMoney" name="bankMoney" value="${billingInfo.BANK_MONEY }" style="ime-Mode:disabled; width: 100px;" onkeypress="inputNumCom();">
					<font class="b03">* 다부수 고객의 경우 모든 구독 정보의 단가합을 입력해주시기 바랍니다.</font>
				</td>
			</tr>
			<tr>
			 	<th><b class="b03">*</b> 예금주명</th>
				<td><input type="text" id="bankName" name="bankName" value="${billingInfo.BANK_NAME }" style="width: 100px;" /></td>
			</tr>
			<tr>
			 	<th style="letter-spacing: -1px"><b class="b03">*</b> 이체 은행/<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계좌 번호</th>
				<td >
					<input type="hidden" id="tmp_bank" name="tmp_bank" value="${billingInfo.BANK }" />
					<select id="bankInfo" name="bankInfo" style="vertical-align: middle; width: 150px">
						<c:forEach items="${bankInfo }" var="list">
							<option value="${list.BANKNUM }" <c:if test="${list.BANKNUM eq billingInfo.BANK }"> selected</c:if> > ${list.BANKNAME }</option>
						</c:forEach>
					</select>
					<input type="text" id="bankNum" name="bankNum" value="${billingInfo.BANK_NUM }" maxlength="16" style="ime-Mode:disabled; width: 150px; vertical-align: middle;" onkeypress="inputNumCom();" />
					<b class="b03">※익월 5일 출금</b>
				</td>
			</tr>							
			<tr >
			 	<th ><b class="b03">*</b> 생년월일</th>
				<td ><input type="text" id="saup" name="saup" value="${billingInfo.SAUP }" maxlength="6"  style="ime-Mode:disabled; width: 70px" onkeypress="inputNumCom();">&nbsp;* 계좌번호 발급시기재된 생년월일[ex)1999년1월18일 -> 990118]</td>
			</tr>
			<tr >
			 	<th>&nbsp;&nbsp; <font class="box_p">비고/통신란</font><br>&nbsp;&nbsp; "200자 내외"</th>
				<td>
					<c:if test="${flag=='UPT' }">
						<!-- memo list -->
						<c:if test="${billingInfo.MEMO ne null}">
							<div style="padding: 5px 0; border-bottom: 1px solid #e5e5e5; width: 510px;">
								<div style="font-weight: bold; padding-bottom: 3px;">[독자메모]</div>
								<div style="width: 510px; word-break: break-all;">${billingInfo.MEMO }</div>
							</div>
						</c:if>
						<c:forEach items="${memoList}" var="list" begin="0" end="2"  varStatus="status">
							<div style="padding: 5px 0; border-bottom: 1px solid #e5e5e5; width: 510px;">
								<div style="font-weight: bold; padding-bottom: 3px;">[${list.CREATE_ID}]&nbsp;${list.CREATE_DATE}</div>
								<div style="width: 510px; word-break: break-all;'">${list.MEMO}</div>
							</div>
						</c:forEach>
						<c:if test="${fn:length(memoList) > 3}">
							<div style="padding: 3px 0; text-align: right; width: 510px"><a href="#fakeUrl" onclick="fn_memo_view_more('${billingInfo.READNO }')"><img alt="더보기" title="더보기" src="/images/ico_more.gif" /></a></div>
						</c:if>
						<!-- //memo list -->
					</c:if>
					<div style="padding-top: 3px;"><textarea id="memo" name="memo" style="width: 95%"></textarea></div>
				</td>
			</tr>														 	
		</table>						
		<div style="width: 710px; text-align: right; padding-top: 10px; overflow: hidden; border: 0px solid red">
			<c:choose>
				<c:when test="${flag=='UPT' }">
					<a href="#fakeUrl" onclick="callLog();"><img src="/images/call_memo.gif" style="vertical-align: middle; border: 0" alt="통화메모" /></a>
					<span id="callLog" style="display:none"><img src="/images/icon_new.gif" border="0" align="top"></span>
			  		<a href="#fakeUrl" onclick="updatePaymentFinal();"><img src="/images/bt_save.gif" style="vertical-align: middle; border: 0" alt="저장" /></a>  
			  		<c:if test="${not empty billingInfo.RDATE }"><a href="#fakeUrl" onclick="popChangeBankNum();"><img src="/images/change_bank.gif" style="vertical-align: middle; border: 0" /></a></c:if>
			  	</c:when>
	  			<c:when test="${flag=='INS' }">
	  				<a href="#fakeUrl" onclick="savePayment();"><img src="/images/bt_save.gif" style="border: 0; vertical-align: middle;" alt="저장"></a>
	  			</c:when>
		  	</c:choose>  
	  		<a href="#fakeUrl" onclick="fn_popClose();"><img src="/images/bt_close.gif" style="border: 0; vertical-align: middle"></a>
		</div>
	</div>
	</form>
</div>
</body>
</html>