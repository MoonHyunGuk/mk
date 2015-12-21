<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel='stylesheet' type='text/css' href="/select2/select2.css"/>
<script type="text/javascript">
	//숫자만 입력 가능하도록 체크 키 다운시
	function inputNumCom(){
		var keycode = event.keyCode;
		 
		if ((event.keyCode<48) || (event.keyCode>57)){
			alert("숫자만 입력 가능합니다.");
			event.keyCode = 0;  // 이벤트 cancel
		}
	}
	//우편주소 팝업
	function popAddr(){
		var left = (screen.width)?(screen.width - 1330)/2 : 10;
		var top = (screen.height)?(screen.height - 200)/2 : 10;
		var winStyle = "width=400,height=500,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		var newWin = window.open("", "pop_addr", winStyle);
		billingForm.target = "pop_addr";
		billingForm.action = "/reader/readerManage/popAddr.do?cmd=4";
		billingForm.submit();
	}
	//우편주소팝업에서 우편주소 선택시 셋팅 펑션
	function setAddr(zip , addr){
		$("zip1").value = zip.substring(0,3);
		$("zip2").value = zip.substring(3,6);
		$("addr1").value = addr;
		$("addr2").value = '';
	}
	//지국정보 변경 컨트롤
	function jikukControl(){
		$("jiSerial").value = $("realJikuk").value;
	}
	//부수에 따라 이체금액 셋팅
	function setMoney(){
		$("bankMoney").value = $("busu").value * 15000;
	}
	//자동이체 독자 등록
	function savePayment(){
		if($("userName").value == '' ){
			alert('구독자 성명/회사명을 입력해주세요.');
			$("userName").focus();
			return;
		}
		if($("zip1").value == '' || $("zip2").value == ''){
			alert('우편번호를 입력해주세요.');
			$("zip1").focus();
			return;
		}
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
			alert('주민등록번호\n사업자등록번호를 입력해주세요.');
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
		billingForm.target="_self";
		billingForm.action="/reader/billingAdmin/savePayment.do";
		billingForm.submit();
	}

	jQuery.noConflict();
	jQuery(document).ready(function($){
		$("#realJikuk, #bankInfo").select2({minimumInputLength: 1});
	});
</script>
<!-- title -->
<div style="padding-bottom: 10px;"><span class="subTitle">일반독자 입력</span></div>
<!-- //title -->
<form id="billingForm" name="billingForm" action="" method="post">
	<div><b>구독자 정보</b></div>
	<div><b class="b03">* 필수 기재란 입니다.</b></div>
	<div class=box_gray_left style="width: 710px; padding: 10px 0;  text-align: center;">
		<input type="radio" id="inType" name="inType" value="기존" checked style="border: 0; vertical-align: middle;"> 기존고객 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
		<input type="radio" id="inType" name="inType" value="신규"  style="border: 0; vertical-align: middle;"> 신규고객
	</div>
	<!-- edit -->
	<div style="padding-top: 10px">
		<table class="tb_edit_left" style="width: 710px">
			<colgroup>
				<col width="180px">
				<col width="530px">
			</colgroup>
			<tr>
			 	<th><b class="b03">*</b> 구독자 성명/회사명</th>
				<td ><input type="text" id="userName" name="userName" style="width: 100px"></td>
			</tr>									
			<tr>
			 	<th style="padding-left: 23px"> 전화번호</th>
				<td>
					<select id="phone1" name="phone1" style="vertical-align: middle;">
						<option value=""></option>
						<c:forEach items="${areaCode }" var="list">
							<option value="${list.CODE }"> ${list.CODE }</option>
						</c:forEach>
					</select> - 
					<input type="text" id="phone2" name="phone2" maxlength="4" style="ime-Mode:disabled; vertical-align: middle; width: 50px" onkeypress="inputNumCom();"> - 
					<input type="text" id="phone3" name="phone3" maxlength="4" style="ime-Mode:disabled; vertical-align: middle; width: 50px" onkeypress="inputNumCom();">
				</td>
			</tr>						 						
			<tr>
			 	<th><b class="b03">*</b> 우편번호 </th>
				<td>
					<input type="text"  id="zip1" name="zip1" readonly style="vertical-align: middle; width: 40px" /> - 
					<input type="text"  id="zip2" name="zip2" readonly style="vertical-align: middle; width: 40px" /> 
					<a href="#fakeUrl" onclick="popAddr();"><img alt="우편번호찾기" src="/images/ico_search2.gif" style="border: 0; vertical-align: middle;" /></a>
				</td>
			</tr>
			<tr>
			 	<th><b class="b03">*</b> 지번주소</th>
				<td >
					<input type="text" id="addr1" name="addr1" style="width: 350px; vertical-align: middle; border: 0;" readonly />
				</td>
			</tr>														 	
			<tr>
			 	<th><b class="b03">*</b> 새주소</th>
				<td >
					<input type="text" id="newaddr" name="newaddr" style="width: 350px; vertical-align: middle;" />
				</td>
			</tr>		
			<tr>
			 	<th><b class="b03">*</b> 상세주소</th>
				<td >
					<input type="text" id="addr2" name="addr2" style="width: 350px; vertical-align: middle;" >
				</td>
			</tr>		
			<tr>
			 	<th></th>
				<td>
					<select name="realJikuk" id="realJikuk" style="width: 120px;" onchange="jikukControl();">
						<option value=""></option>
						<c:forEach items="${agencyAllList }" var="list">
							<option value="${list.SERIAL }" >${list.NAME } </option>
						</c:forEach>
					</select>
				</td>
			</tr>								 
			<tr>
			 	<th><img src="/images/ic_arr.gif" style="vertical-align: middle; border: 0;" alt=""> 구독부수</th>
				<td>
					<select id="busu" name="busu" onchange="setMoney();">
					<c:forEach begin="1" end="30" step="1" varStatus="i">
						<option value="${i.index }"> ${i.index }</option>
					</c:forEach>
					</select>
				</td>
			</tr>		
			<tr>
			 	<th style="padding-left: 23px">납부자번호</th>
				<td >
					<input type="text" id="jiSerial" name="jiSerial" size="6" readonly style="vertical-align: middle; width: 70px" class="box_m3">
					<input type="text" id="serial" name="serial" style="vertical-align: middle; width: 100px"readonly> "매일경제신문사 기재란 입니다"
				</td>
			</tr>						 						 						 						 				 				 				 	
			</table>  	
			
			<div style="padding: 20px 0 5px 0; font-weight: bold; width: 710px;">납부자 정보</div>
			<table class="tb_edit_left" style="width: 710px">
				<colgroup>
					<col width="180px">
					<col width="530px">
				</colgroup>
			 	<tr>
			 		<th><b class="b03">*</b> 이체금액</th>
					<td><input type="text" id="bankMoney" name="bankMoney" value="15000" style="ime-Mode:disabled; width: 100px; vertical-align: middle;" onkeypress="inputNumCom();"></td>
				</tr>
				<tr>
				 	<th><b class="b03">*</b> 예금주명/법인명</th>
					<td><input type="text" id="bankName" name="bankName" style="width: 100px; vertical-align: middle;"></td>
				</tr>
				<tr>
				 	<th><b class="b03">*</b> 이체 은행</th>
					<td>
						<select id="bankInfo" name="bankInfo" style="width: 200px;">
							<c:forEach items="${bankInfo }" var="list">
								<option value="${list.BANKNUM }" > ${list.BANKNAME }</option>
							</c:forEach>
						</select>
					</td>
				</tr>							
				<tr>
				 	<th><b class="b03">*</b> 계좌 번호</th>
					<td><input type="text" id="bankNum" name="bankNum" maxlength="16" style="ime-Mode:disabled; width: 250px; vertical-align: middle;" onkeypress="inputNumCom();"></td>
				</tr>
				<tr >
				 	<th><b class="b03">*</b> 주민등록번호/<br/>사업자등록번호</th>
					<td><input type="text" id="saup" name="saup" maxlength="13" style="ime-Mode:disabled; width: 250px; vertical-align: middle;" onkeypress="inputNumCom();"><br/>* 계좌번호 발급시기재된 주민번호</td>
				</tr>
				<tr>
				 	<th><b class="b03">*</b> 예금주 비상연락처</th>
					<td>
						<select id="handy1" name="handy1" style="vertical-align: middle;">
							<c:forEach items="${mobileCode }" var="list">
								<option value="${list.CODE }">${list.CODE }</option>
							</c:forEach>
						</select> - 
						<input type="text" id="handy2" name="handy2" maxlength="4" style="ime-Mode:disabled; vertical-align: middle; width: 45px" onkeypress="inputNumCom();"> - 
						<input type="text" id="handy3" name="handy3" maxlength="4" style="ime-Mode:disabled; vertical-align: middle; width: 45px" onkeypress="inputNumCom();">
					</td>
				</tr>						 						
				<tr>
				 	<th style="padding-left: 23px">이메일</th>
					<td ><input type="text" id="email" name="email" style="width: 250px"></td>
				</tr>						 
				<tr>
				 	<th style="padding-left: 23px"><font class="box_p">비고/통신란</font><br>&nbsp;&nbsp; "200자 내외 작성"</th>
					<td><textarea id="memo" name="memo" style="width: 95%;">${billingInfo[0].MEMO }</textarea></td>
				</tr>														 	
			</table>						
		</div> 
	<div style="width: 710px; text-align: right; padding: 10px 0 20px 0;"><a href="#fakeUrl" onclick="savePayment();"><img src="/images/bt_save.gif" style="vertical-align: middle; border: 0" alt="저장"></a></div>
</form>