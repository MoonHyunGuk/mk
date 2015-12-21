<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<head>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/ajaxUtil.js" charset="UTF-8"></script>
<title>매일경제 자동이체</title>
<style> 
<!--
td {font-size: 9pt;
	text-align: justify;
	line-height: 4.5mm}
 
img {border:none}
.table_style1 td {padding:5px 10px}
input {border:1px solid #CCC }
.td_style1 {background:#f0f1f3; border-top:1px solid #dcdcdc}
.td_style2 {border-top:1px solid #dcdcdc}
.td_style11 {border-top:2px solid #0d1a49; background:#f0f1f3}
.td_style22 {border-top:2px solid #0d1a49; background:#fff}

#loader {
	display:none;
	position:absolute;
	left:expression( (document.body.clientWidth/2)+250);
	margin-left:-550px;
	width:474px;
	height:40px;
	top:50%;
	background-color: white;
	text-align: center;
	padding: 50px;
	border: 2px solid orangered;
	z-index: 1;
}
-->
</style>
</head>
<script type="text/javascript">
	//숫자만 입력 가능하도록 체크 키 다운시
	function inputNumCom(){
		var keycode = event.keyCode;
		 
		if ((event.keyCode<48) || (event.keyCode>57)){
			alert("숫자만 입력 가능합니다.");
			event.keyCode = 0;  // 이벤트 cancel
		}
	}
	//우편번호 팝업
	function popAddr(){
		var left = (screen.width)?(screen.width - 1330)/2 : 10;
		var top = (screen.height)?(screen.height - 200)/2 : 10;
		var winStyle = "width=520,height=700,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		var newWin = window.open("", "pop_addr", winStyle);
		billingForm.target = "pop_addr";
		billingForm.action = "/reader/subscriptionForm/popNewAddr.do";
		billingForm.submit();
	}
	//우편번호팝업에서 우편주소 선택시 셋팅 펑션
	function setAddr(zip , addr , newAddr, bdNm, dbMngNo){
		$("zip1").value = zip.substring(0,3);
		$("zip2").value = zip.substring(3,6);
		$("addr1").value = addr;
		$("addr2").value = bdNm;
		$("addr3").value = newAddr;
		$("bdMngNo").value = dbMngNo;
	}
	function setPrice(){
		$("bankMoney").value = $("busu").value * 15000;
	}
	//자동이체 독자 등록
	function savePayment(){
		
		if($("userName").value == '' ){
			alert('구독자 성명을 입력해주세요.');
			$("userName").focus();
			return;
		}
		if($("birth").value != '' && $("birth").value.length<8 ){
			alert('생년월일을 정확히 입력해 주세요.');
			$("birth").focus();
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
		if($("handy1").value == '' ){
			alert('비상연락처를 입력해주세요.');
			$("handy1").focus();
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
		
		//기업은행 평생계좌 신규등록 서비스 중단(2012.11.12 박윤철)
		if($("bankInfo").value =='003') {
			var str = $("bankNum").value;
			str = str.replace(/^\s+|\s+$/g,"");
			if(str.length < 12){
				alert("본 계좌는 평생계좌로 \n자동이체 서비스가 중단되어 신청이 불가능합니다.");
				$("bankNum").focus();
				return;
			}
		}

		startLoad();
		closeButton();

		var url = "/reader/subscriptionForm/savePayment.do";
		sendAjaxRequest(url, "billingForm", "post", message);
	}
	//자동이체 독자 등록 완료 메시지
	function message(responseHttpObj) {
		if (responseHttpObj) {
			try {
				var result = eval("(" + responseHttpObj.responseText + ")");
				if (result) {
					alert(result[0].message);
					self.close();
				}
			} catch (e) {
				alert("오류 : " + e);
			}
		}
	}
	//이용 약관
	function useClauses(){
		billingForm.target="_self";
		billingForm.action="/reader/subscriptionForm/useClauses.do";
		billingForm.submit();
			
	}
	
	// 저장 버튼 비활성화
	function closeButton(){
		$("saveButton").style.display = "none";
	}
	
	// 저장 버튼활성화
	function openButton(){
		$("saveButton").style.display = "block";
	}
	
	// 로딩 프레임 호출
	function startLoad(){
		$("loader").style.display = "block";
	}

	// 로딩 프레임 중지
	function endLoad(){
		$("loader").style.display = "none";
	}
	
	function changeSaup(value){
		if(value == "Y"){
			document.getElementById("saup_name").innerHTML = "생년월일<br/><font style=\"font-size:9px;font-weight:normal;\">(주민번호앞 6자리)</font>";
			document.getElementById("saup_txt").innerText = "주민번호 앞 6자리";
			document.getElementById("saup").value = "";
			document.getElementById("saup").maxLength = "6";
			
		}else{
			document.getElementById("saup_name").innerHTML = "사업자번호";
			document.getElementById("saup_txt").innerText = "사업자번호, 개인사업자의 경우 개인으로 등록";
			document.getElementById("saup").maxLength = "10";
			document.getElementById("saup").value = "";
		}
	}
	
</script>

<div id="loader" name="loader">
	<img src="/images/ajax-loader.gif" alt="로딩이미지" /><br/><br/><br/>
	<font style="font-size: small; font-weight: bolder; ">구독신청 접수가 완료 되었습니다.<br/><br/>
	</font>
</div>
<form id="billingForm" name="billingForm" action="" method="post">
<table cellpadding="0" cellspacing="0" width="676" border="0">
	<tr>
		<td width="676"  height="56"  style="padding:8px 15px 2px; border-bottom:7px solid #f68600; background:#FFFFFFF"><img src="/images/l_mk_blacklogo.png"  alt="매일경제" />
		</td>
	</tr>
	<tr>
		<td style="text-align:right; padding-top:10px"><a href="javascript:close()"><img src="/images/bt_pop_close.gif"  alt="닫기" /></a></td>
	</tr>
	<tr>
		<td>

            <table cellpadding="20" cellspacing="10" width="676" height="100%" bgcolor="#eaeaea">
				<tr>
					<td width="666" bgcolor="white" valign="top">	
						<h1><img src="/images/t_apply_popt4.gif"  alt="구독자 정보" /></h1>
						<table align="center" cellpadding="0" cellspacing="0" width="605" class="table_style1">
							<colgroup>
							<col width="25%" />
							<col width="75%" />
							</colgroup>
							<tr>
								<td  class="td_style11" colspan="2" align="center">
									<input type="radio" id="inType" name="inType" style="border-style: none;" value="기존">기존고객&nbsp;&nbsp;&nbsp;&nbsp;
									<input type="radio" id="inType" name="inType" style="border-style: none;" value="신규" checked>신규고객
								</td>
							</tr>
							<tr>
								<td class="td_style1"><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp;  <strong>구독자명</strong></td>
								<td class="td_style2"><input type="text" id="userName" name="userName" tabindex=1 maxlength=30></td>
							</tr>

							<tr>
								<td class="td_style1"><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp;  <strong>생년월일</strong></td>
								<td class="td_style2"><input type="text" id="birth" name="birth" tabindex=2 maxlength=8 style="ime-Mode:disabled" onKeyPress="inputNumCom();"> &nbsp; ex)20120101</td>
							</tr>
							<tr>
								<td class="td_style1">&nbsp;&nbsp; <strong>전화번호</strong></td>
								<td class="td_style2">
									<select id="phone1" name="phone1" style="border-style: none;" tabindex=3>
										<option value="" selected>----</option>
										<c:forEach items="${areaCode }" var="list">
											<option value="${list.CODE }"> ${list.CODE }</option>
										</c:forEach>
									</select> - 
									<input type="text" id="phone2" name="phone2" maxlength="4" size="4" tabindex=4 style="ime-Mode:disabled" onKeyPress="inputNumCom();">
									- <input type="text" id="phone3" name="phone3" maxlength="4" size="4" tabindex=5 style="ime-Mode:disabled" onKeyPress="inputNumCom();">
								</td>
							</tr>
							<tr>
								<td class="td_style1"><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp;  <strong>우편번호</strong></td>
								<td class="td_style2">
									<input type="text" id="zip1" name="zip1" maxlength="3" size="3" tabindex=6 style="cursor: hand;" readonly> - 
									<input type="text" id="zip2" name="zip2" maxlength="3" size="3" tabindex=7 style="cursor: hand;" readonly>&nbsp;
									<a href="javascript:popAddr();"><img src="/images/bt_find_pose.gif"  alt="우편번호찾기" style="vertical-align: middle;" /></a>
								</td>
							</tr>
							<tr>
								<td class="td_style1">
									<img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>
									&nbsp; <strong>도로명주소</strong>
								</td>
								<td class="td_style2">
									<input type="text" id="addr3" name="addr3" size="41" tabindex="11" readonly style="cursor: hand;">
									<input type="hidden" id="bdMngNo" name="bdMngNo"><br />
								</td>
							</tr>
							<tr>
								<td class="td_style1"><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp;  <strong>상세주소</strong></td>
									<td class="td_style2">
									<input type="text" id="addr1" name="addr1" tabindex="8" style="width: 360px;" readonly="readonly"><br />
									<input type="text" id="addr2" name="addr2" tabindex="9" maxlength="100" style="margin-top:3px; width: 360px;">
									<div style="font-weight: bold; color: red; padding-top: 3px;">※ 아파트는 동호수까지 입력해주셔야 정확한 배달이 가능합니다. </div>
									<div style="font-weight: bold; ">&nbsp;&nbsp;&nbsp;&nbsp;ex) 101동 1001호일때 :  101-1001가 아닌 101동 1001호로 입력</div>
								</td>
							</tr>
							<tr>
								<td class="td_style1"><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp;  <strong>구독부수</strong></td>
								<td class="td_style2">
									<select id="busu" name="busu"  onchange="javascript:setPrice();" tabindex=10>
										<c:forEach begin="1" end="30" step="1" varStatus="i">
											<option value="${i.index }"> ${i.index }</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<td class="td_style1"><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp; &nbsp; <strong>E - Mail</strong> </td>
								<td class="td_style2"><input type="text" id="email" name="email" tabindex=11 maxlength=40></td>
							</tr>
						</table>
					
						<h1><img src="/images/t_apply_popt5.gif"  alt="납부자 정보" /></h1>
						<table align="center" cellpadding="0" cellspacing="0" width="605" class="table_style1">
							<colgroup>
							<col width="25%" />
							<col width="75%" />
							</colgroup>
							
							<tr>
								<td class="td_style11"><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp; <strong>이체금액</strong></td>
								<td class="td_style22">
									<input type="text" id="bankMoney" name="bankMoney" tabindex=12 maxlength=10 value="15000" readonly size="10"> 부수에 따라 자동 계산됩니다.
								</td>
							</tr>
							<tr>
								<td class="td_style1"><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp; <strong>예금주/법인명</strong></td>
								<td class="td_style2"><input type="text" id="bankName" name="bankName" tabindex="13" maxlength="30"></td>
							</tr>
							<tr>
								<td class="td_style1"><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp; <strong>이체은행</strong></td>
								<td class="td_style2">
									<select id="bankInfo" name="bankInfo" tabindex=14>
										<option value="" selected>----</option>
										<c:forEach items="${bankInfo }" var="list">
											<option value="${list.BANKNUM }" > ${list.BANKNAME }</option>
										</c:forEach>
									</select>
									<br/><font color="#CC0000">농협은 농협중앙회와 지역농협으로 나뉩니다. 정확히 구분하여 신청바랍니다.</font>
								</td>
							</tr>
							<tr>
								<td class="td_style1"><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp; <strong>계좌번호</strong></td>
								<td class="td_style2">
									<input type="text" id="bankNum" name="bankNum" size="41" style="ime-Mode:disabled" onKeyPress="inputNumCom();" tabindex=15 maxlength=16>
								</td>
							</tr>
							<tr>
								<td class="td_style1"><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp; <strong>개인/법인</strong></td>
								<td class="td_style2">
									<input type="radio" name="saup_type" value="Y" style="border:none" checked="checked" onclick="changeSaup(this.value);"/>개인
									<input type="radio" name="saup_type" value="N" style="border:none" onclick="changeSaup(this.value);"/>법인
								</td>
							</tr>
							<tr>
								<td class="td_style1"><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp; <strong id="saup_name">생년월일<br/><font style="font-size:9px;font-weight:normal;">(주민번호앞 6자리)</font></strong></td>
								<td class="td_style2">
									<input type="text" id="saup" name="saup" size="41" style="ime-Mode:disabled" onKeyPress="inputNumCom();" tabindex=16 maxlength="6"><br>
									&quot; 계좌번호 발급시 기재된 <span id="saup_txt">주민번호 앞 6자리</span>&nbsp;&quot;
								</td>
							</tr>
							<tr>
								<td class="td_style1"><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp; <strong>예금주 비상연락처</strong></td>
								<td class="td_style2">
									<select id="handy1" name="handy1" style="border-style: none;" tabindex=17>
										<option value="" selected>----</option>
										<c:forEach items="${mobileCode }" var="list">
											<option value="${list.CODE }">${list.CODE }</option>
										</c:forEach>
									</select>- 
									<input type="text" id="handy2" name="handy2" maxlength="4" size="4" tabindex=18 style="ime-Mode:disabled" onKeyPress="inputNumCom();">
									- <input type="text" id="handy3" name="handy3" maxlength="4" size="4" tabindex=19 style="ime-Mode:disabled" onKeyPress="inputNumCom();">
								</td>
							</tr>
							
							<tr>
								<td class="td_style1">&nbsp;&nbsp; <strong>비 &nbsp; &nbsp; &nbsp; 고</strong>
								</td>
								<td class="td_style2"><textarea id="memo" name="memo" tabindex=20 style="border:1px solid #cccccc; background-color: #ffffff; height:130px; width:100%;"></textarea></td>
							</tr>
						</table>

						<div id="saveButton" style="text-align:center; width:100%; padding-top:10px"><a href="javascript:savePayment();"><img src="/images/bt_apply_mkapply.gif" alt="구독신청"></a></div>

					</td>
				</tr>
			</table>
		
		</td>
	</tr>
</table>

<div style="width:676px; text-align:left; font-size:12px; padding-top:7px; color:#6f6f6f; padding-left: 50px;" >
	<table >
		<tr>
			<td>
				<img src="/images/mklogo.gif" width="74" height="29" border="0" vspace="10" hspace="10" >
			</td>
			<td>
				Copyright&copy; 2006. 매경인터넷(주).
				서울특별시 중구 필동 1가 30-1 매경미디어센터 9층.<br>
				매경인터넷은 회원의 허락없이 개인정보를 수집, 공개, 유출을 하지 않으며 회원정보의 <br>
				보호를 위해 최선을 다합니다.<br/>
				사업자 등록번호 : 201-81-25980 / 통신판매업
				신고 : 중구00083호 &nbsp;<br>
				이용관련문의 : 02-2000-2000
			</td>
		</tr>
	</table>
</div>	
		
</form>