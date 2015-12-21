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
td {
	font-size: 9pt;
	text-align: justify;
	line-height: 4.5mm
}
 
input {
	border-style: groove;
	font-size: 9pt
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
	//우편주소 팝업
	function popAddr(){
		var left = (screen.width)?(screen.width - 1330)/2 : 10;
		var top = (screen.height)?(screen.height - 200)/2 : 10;
		var winStyle = "width=400,height=500,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		var newWin = window.open("", "pop_addr", winStyle);
		billingForm.target = "pop_addr";
		billingForm.action = "/reader/subscriptionForm/popAddr.do";
		billingForm.submit();
	}
	//우편주소팝업에서 우편주소 선택시 셋팅 펑션
	function setAddr(zip , addr ){
		$("zip1").value = zip.substring(0,3);
		$("zip2").value = zip.substring(3,6);
		$("addr1").value = addr;
		$("addr2").value = '';
	}
	function setPrice(){
		$("bankMoney").value = $("busu").value * 7500;
	}
	//자동이체 독자 등록
	function savePayment(){
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
			alert('구독자 성명을 입력해주세요.');
			$("userName").focus();
			return;
		}
		if($("handy1").value == '' ){
			alert('휴대폰 번호를 입력해주세요.');
			$("handy1").focus();
			return;
		}
		if($("handy2").value == '' ){
			alert('휴대폰 번호를 입력해주세요.');
			$("handy2").focus();
			return;
		}
		if($("handy3").value == '' ){
			alert('휴대폰 번호를 입력해주세요.');
			$("handy3").focus();
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
			alert('예금주명 입력해주세요.');
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
			alert('주민등록번호를 입력해주세요.');
			$("saup").focus();
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
		
		var url = "/reader/subscriptionForm/savePaymentStu.do";
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
		billingForm.action="/reader/subscriptionForm/stuUseClauses.do";
		billingForm.submit();
			
	}
	
	
</script>
<form id="billingForm" name="billingForm" action="" method="post">
<table cellpadding="0" cellspacing="0" width="676" height="100%">
	<tr>
		<td width="676" valign="top" height="56">
		<p><img src="/images/logo.gif" width="284" height="56" border="0" style="cursor: hand;" onclick="javascript:useClauses();"></p>
		</td>
	</tr>
	<tr>
		<td width="676" valign="top">
			<table cellpadding="0" cellspacing="0" width="676">
				<tr>
					<td width="149">
					<p><a href="#"><img src="/images/m1.gif" width="149" height="35" border=0 onMouseOver='this.src="/images/m1_ov.gif"' onMOuseOut='this.src="/images/m1.gif"'></a></p>
					</td>
					<td width="149">
					<p><a href="/reader/subscriptionForm/retrieveBillingStu.do"><img src="/images/m2.gif" width="149" height="35" border=0 onMouseOver='this.src="/images/m2_ov.gif"' onMOuseOut='this.src="/images/m2.gif"'></a></p>
					</td>
					<td width="149"></td>
					<td width="149"></td>
					<td width="3%">
					<p>&nbsp;</p>
					</td>
					<td width="61">
					<p align="center"><a href="javascript:close()"><img
						src="/images/close.gif" width="45" height="19" border="0"></a></p>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td width="676" valign="top" height="100%">
			<table cellpadding="20" cellspacing="10" width="676" height="100%" bgcolor="#C3BDA7">
				<tr>
					<td width="666" bgcolor="white" valign="top">
						<table align="center" cellpadding="0" cellspacing="0" width="605">
							<tr>
								<td width="605" valign="top">
								<p><img src="/images/t2_stu.gif" width="605" height="29" border="0"></p>
								</td>
							</tr>
							<tr>
								<td width="605" valign="top">
								<p><b><font color="#CC0000"><img src="/images/i.gif" width="9" height="9" border="0"> 필수 기재란 입니다.</font></b></p>
								</td>
							</tr>
							<tr>
								<td width="605" valign="top">
									<table align="center" cellpadding="0" cellspacing="1" width="605">
										<tr>
											<td width="603" height="5" bgcolor="#AEA78B" colspan="2"></td>
										</tr>
										<tr>
											<td width="166" height="30" bgcolor="#DEDBCE">
												<p style="margin-left: 20px;"><font color="#CC0000"><b><img src="/images/i.gif" width="9" height="9" border="0"></b></font>
												<b>대학명</b></p>
											</td>
												<td width="436" height="30" bgcolor="#F4F1E7">
												<p style="margin-left: 10px;"><input type="text" id="stuSch" name="stuSch" tabindex=1 maxlength=30></p>
											</td>
										</tr>
										<tr>
											<td width="166" height="30" bgcolor="#DEDBCE">
												<p style="margin-left: 20px;"><font color="#CC0000"><b><img	src="/images/i.gif" width="9" height="9" border="0"></b></font>
												<b>학과<br></b></p>
											</td>
											<td width="436" height="30" bgcolor="#F4F1E7">
												<p style="margin-left: 10px;">
												<input type="text" id="stuPart" name="stuPart" tabindex=2 maxlength=8>
												</p>
											</td>
										</tr>				
										<tr>
											<td width="166" height="30" bgcolor="#DEDBCE">
												<p style="margin-left: 20px;"><font color="#CC0000"><b><img src="/images/i.gif" width="9" height="9" border="0"></b></font>
												<b>학년</b></p>
											</td>
											<td width="436" height="30" bgcolor="#F4F1E7">
												<p style="margin-left: 10px;">
												<input type="text" id="stuClass" name="stuClass" tabindex=3 maxlength=8 style="ime-Mode:disabled" onKeyPress="inputNumCom();"><font color="#CC0000">단, 4학년은 당해년도 12월까지 할인혜택 적용됩니다.</font>
												</p>
											</td>
										</tr>
										<tr>
											<td width="166" height="30" bgcolor="#DEDBCE">
												<p style="margin-left: 20px;"><font color="#CC0000"><b><img src="/images/i.gif" width="9" height="9" border="0"></b></font>
												<b>성명</b></p>
											</td>
											<td width="436" height="30" bgcolor="#F4F1E7">
												<p style="margin-left: 10px;">
												<input type="text" id="userName" name="userName" tabindex=4 maxlength=8>
												</p>
											</td>
										</tr>
										<tr>
											<td width="166" height="30" bgcolor="#DEDBCE">
												<p style="margin-left: 20px;"><font color="#CC0000"><b><img src="/images/i.gif" width="9" height="9" border="0"></b></font>
												<b>휴대폰</b></p>
											</td>
											<td width="436" height="30" bgcolor="#F4F1E7">
												<p style="margin-top: 4px; margin-left: 10px;">
												<select id="handy1" name="handy1" style="border-style: none;" tabindex=5>
													<option value="" selected>----</option>
													<c:forEach items="${mobileCode }" var="list">
														<option value="${list.CODE }">${list.CODE }</option>
													</c:forEach>
												</select>- 
												<input type="text" id="handy2" name="handy2" maxlength="4" size="4" tabindex=6 style="ime-Mode:disabled" onKeyPress="inputNumCom();">
												- <input type="text" id="handy3" name="handy3" maxlength="4" size="4" tabindex=7 style="ime-Mode:disabled" onKeyPress="inputNumCom();">
											</td>
										</tr>
										<tr>
											<td width="166" height="30" bgcolor="#DEDBCE">
												<p style="margin-left: 20px;">
												<b>&nbsp;&nbsp;&nbsp;전화번호</b></p>
											</td>
											<td width="436" height="30" bgcolor="#F4F1E7">
												<p style="margin-top: 4px; margin-left: 10px;">
												<select id="phone1" name="phone1" style="border-style: none;" tabindex=8>
													<option value="" selected>----</option>
													<c:forEach items="${areaCode }" var="list">
														<option value="${list.CODE }"> ${list.CODE }</option>
													</c:forEach>
												</select> - 
												<input type="text" id="phone2" name="phone2" maxlength="4" size="4" tabindex=9 style="ime-Mode:disabled" onKeyPress="inputNumCom();">
												- <input type="text" id="phone3" name="phone3" maxlength="4" size="4" tabindex=10 style="ime-Mode:disabled" onKeyPress="inputNumCom();">
											</td>
										</tr>
										<tr>
											<td width="166" height="30" bgcolor="#DEDBCE">
												<p style="margin-left: 20px;"><font color="#CC0000"><b><img src="/images/i.gif" width="9" height="9" border="0"></b></font>
												<b>우편번호</b></p>
											</td>
											<td width="436" height="30" bgcolor="#F4F1E7">
												<table cellpadding="0" cellspacing="0" width="90%"style="margin-left: 10px;">
													<tr>
														<td width="486">
															<p><input type="text" id="zip1" name="zip1" maxlength="3" size="3" tabindex=11 style="cursor: hand;" readonly> - 
															<input type="text" id="zip2" name="zip2" maxlength="3" size="3" tabindex=12 style="cursor: hand;" readonly>&nbsp;
															<a href="javascript:popAddr();"><img src="/images/zip_chk.gif" align="absmiddle" border="0" hspace="5" style="cursor: hand;"></a></p>
														</td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td width="166" height="30" bgcolor="#DEDBCE">
												<p style="margin-left: 20px;"><font color="#CC0000"><b><img src="/images/i.gif" width="9" height="9" border="0"></b></font>
												<b>상세주소</b></p>
											</td>
											<td width="436" height="30" bgcolor="#F4F1E7">
												<table cellpadding="0" cellspacing="0" width="90%" style="margin-left: 10px;">
													<tr>
														<td width="486">
															<p><input type="text" id="addr1" name="addr1" size="41" tabindex=13 readonly></p>
														</td>
													</tr>
													<tr>
														<td width="486">
															<p><input type="text" id="addr2" name="addr2" size="54" tabindex=14 tabindex=5 maxlength=100></p>
														</td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td width="166" height="30" bgcolor="#DEDBCE">
												<p style="margin-left: 20px;"><font color="#CC0000"><b><img src="/images/i.gif" width="9" height="9" border="0"></b></font>
												<b>구독부수</b></p>
											</td>
											<td width="436" height="30" bgcolor="#F4F1E7">
												<p style="margin-left: 10px;">
												<select id="busu" name="busu"  onchange="javascript:setPrice();" tabindex=15>
													<c:forEach begin="1" end="30" step="1" varStatus="i">
														<option value="${i.index }"> ${i.index }</option>
													</c:forEach>
												</select>
												</p>
											</td>
										</tr>
										<tr>
											<td width="166" height="30" bgcolor="#DEDBCE">
												<p style="margin-left: 20px;">
												<b>&nbsp;&nbsp;&nbsp;E-Mail<br></b></p>
											</td>
											<td width="436" height="30" bgcolor="#F4F1E7">
												<p style="margin-left: 10px;">
													<input type="text" id="email" name="email" tabindex=16 maxlength=40>
												</p>
											</td>
										</tr>
										<tr>
											<td width="166" height="30" bgcolor="#DEDBCE">
												<p style="margin-left: 20px;"><font color="#CC0000"><b><img src="/images/i.gif" width="9" height="9" border="0"></b></font>
												<b>추천교수</b></p>
											</td>
											<td width="436" height="30" bgcolor="#F4F1E7">
												<p style="margin-left: 10px;">
												<input type="text" id="stuProf" name="stuProf" tabindex=17 maxlength=8>
												</p>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="605" valign="top">
									<p>&nbsp;</p>
								</td>
							</tr>
							<tr>
								<td width="605" valign="top">
									<p><img src="/images/t2.gif" width="605" height="29" border="0"></p>
								</td>
							</tr>
							<tr>
								<td width="605" valign="top">
									<p>&nbsp;</p>
								</td>
							</tr>
							<tr>
								<td width="605" valign="top">
									<table align="center" cellpadding="0" cellspacing="1" width="605">
										<tr>
											<td width="603" height="5" bgcolor="#AEA78B" colspan="2"></td>
										</tr>
										<tr>
											<td width="166" height="30" bgcolor="#DEDBCE">
												<p style="margin-left: 20px;">
												<font color="#CC0000"><b><img src="/images/i.gif" width="9" height="9" border="0"></b></font>
												<b>이체 금액<br></b></p>
											</td>
											<td width="436" height="30" bgcolor="#F4F1E7">
												<p style="margin-left: 10px;">
												<input type="text" id="bankMoney" name="bankMoney" tabindex=18 maxlength=10 value="7500" readonly size="10"> 부수에 따라 자동 계산됩니다.</p>
											</td>
										</tr>
										<tr>
											<td width="166" height="30" bgcolor="#DEDBCE">
												<p style="margin-left: 20px;"><b><font color="#CC0000"><img src="/images/i.gif" width="9" height="9" border="0"></font>
												<b>예금주명</b></p>
											</td>
											<td width="436" height="30" bgcolor="#F4F1E7">
												<p style="margin-left: 10px;"><input type="text" id="bankName" name="bankName" tabindex=19 maxlength=30></p>
											</td>
										</tr>
										<tr>
											<td width="166" height="30" bgcolor="#DEDBCE">
												<p style="margin-left: 20px;"><b><font color="#CC0000"><img src="/images/i.gif" width="9" height="9" border="0"></font>
												<b>이체 은행</b></p>
											</td>
											<td width="436" height="30" bgcolor="#F4F1E7">
												<p style="margin-top: 4px; margin-left: 10px;">
													<select id="bankInfo" name="bankInfo" tabindex=20>
														<option value="" selected>----</option>
														<c:forEach items="${bankInfo }" var="list">
															<option value="${list.BANKNUM }" > ${list.BANKNAME }</option>
														</c:forEach>
													</select>
													<br/><font color="#CC0000">농협은 농협중앙회와 지역농협으로 나뉩니다. 정확히 구분하여 신청바랍니다.</font>
												</p>
											</td>
										</tr>
										<tr>
											<td width="166" height="30" bgcolor="#DEDBCE">
												<p style="margin-left: 20px;"><b><font color="#CC0000"><img src="/images/i.gif" width="9" height="9" border="0"></font>
												<b>계좌 번호</b></p>
											</td>
											<td width="436" height="30" bgcolor="#F4F1E7">
												<p style="margin-left: 10px;">
												<input type="text" id="bankNum" name="bankNum" size="41" style="ime-Mode:disabled" onKeyPress="inputNumCom();" tabindex=21 maxlength=16></p>
											</td>
										</tr>
										<tr>
											<td width="166" height="50" bgcolor="#DEDBCE">
												<p style="margin-left: 20px;"><b><font color="#CC0000"><img src="/images/i.gif" width="9" height="9" border="0"></font>
												<b>주민등록번호 /<br>&nbsp;&nbsp;&nbsp;사업자등록번호<br>
												</b></p>
											</td>
											<td width="436" height="50" bgcolor="#F4F1E7">
												<p style="margin-left: 10px;">
												<input type="text" id="saup" name="saup" size="41" style="ime-Mode:disabled" onKeyPress="inputNumCom();" tabindex=22 maxlength="13"><br>
												&quot; 계좌번호 발급시 기재된 주민번호 또는 사업자번호&nbsp;&quot;</p>
											</td>
										</tr>
										<tr>
											<td width="166" height="140" bgcolor="#DEDBCE">
											<p style="margin-left: 20px;"><b><font color="#CC0000"><img src="/images/i.gif" width="9" height="9" border="0"></font>
											<b>비고/통신란<br>&nbsp;&nbsp;</b>&quot; 200자 내외 작성 &quot;</p>
											</td>
											<td width="436" height="140" bgcolor="#F4F1E7">
												<textarea id="memo" name="memo" tabindex=23 style="border:1px solid #cccccc; background-color: #ffffff; height:130px; width:100%;"></textarea>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="605" valign="top">
								<p>&nbsp;</p>
								</td>
							</tr>
							<tr>
								<td width="605" valign="top">
									<p align="center">
									<a href="javascript:savePayment();"><img src="/images/bt2.gif" width="71" height="23" border="0" style="border: none;" tabindex=16></a>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>	
	<tr>
		<td bgcolor="#C3BDA7">
			<table cellpadding="0" cellspacing="0" width="636" align="center">
				<tr>
					<td width="130">
					<table align="center" cellpadding="0" cellspacing="0"
						bgcolor="white">
						<tr>
							<td>
								<p align="center">
								<img src="/images/mklogo.gif" width="74" height="29" border="0" vspace="10" hspace="10" ></p>
							</td>
						</tr>
					</table>
					</td>
					<td width="506" colspan="2">
					<table align="center" width="506" cellpadding="0" cellspacing="0">
						<tr>
							<td colspan="2" width="506">
								<p style="margin-top: 5px;">Copyright&copy; 2006. 매경인터넷(주).
								서울특별시 중구 필동 1가 30-1 매경미디어센터 9층.<br>
								매경인터넷은 회원의 허락없이 개인정보를 수집, 공개, 유출을 하지 않으며 회원정보의 <br>
								보호를 위해 최선을 다합니다.</p>
							</td>
						</tr>
						<tr>
							<td width="386">
								<p style="margin-bottom: 5px;">사업자 등록번호 : 201-81-25980 / 통신판매업
								신고 : 중구00083호 &nbsp;<br>
								이용관련문의 : 02-2000-2000&nbsp;</p>
							</td>
							<td width="120" valign="top">
							</td>
						</tr>
					</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
		
</form>