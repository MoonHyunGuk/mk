<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.mkreader.dao.GeneralDAO"%>
<%@ page import="kr.reflexion.espresso.servlet.util.*" %>
<%@ page import="kr.reflexion.espresso.util.*" %>
<%@ page import="org.springframework.web.context.*"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="org.springframework.web.context.support.*"%>
<head>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/ajaxUtil.js" charset="UTF-8"></script>
<title>매일경제 지로 신청</title>
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
	function setAddr(zip , addr){
		$("zip1").value = zip.substring(0,3);
		$("zip2").value = zip.substring(3,6);
		$("addr1").value = addr;
		$("addr2").value = '';
	}

	//신규 신청 독자 등록
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
		if($("phone1").value == '' ){
			alert('전화번호를 입력해주세요.');
			$("phone1").focus();
			return;
		}
		if($("phone2").value == '' ){
			alert('전화번호를 입력해주세요.');
			$("phone2").focus();
			return;
		}
		if($("phone2").value == '' ){
			alert('전화번호를 입력해주세요.');
			$("phone2").focus();
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
		if($("intFldCd").value == '' ){
			alert('관심분야를 입력해주세요.');
			$("intFldCd").focus();
			return;
		}
		
		var url = "/reader/subscriptionForm/saveAplc.do";
		sendAjaxRequest(url, "billingForm", "post", message);
	}
	// 완료 메시지
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
</script>
<body>
<form id="billingForm" name="billingForm" action="" method="post">
<table cellpadding="0" cellspacing="0" width="676" height="100%">
	<tr>
		<td width="676" valign="top" height="56">
		<p><img src="/images/mklogo.gif" width="100" height="56" border="0">
		</td>
	</tr>
	<tr>
		<td width="676" valign="top">
			<table cellpadding="0" cellspacing="0" width="676">
				<tr>
					<td width="149">
					<p><img src="/images/m1.gif" width="149" height="35" border=0 onMouseOver='this.src="/images/m1_ov.gif"' onMOuseOut='this.src="/images/m1.gif"'></p>
					</td>
					<td width="149">
					</td>
					<td width="149"></td>
					<td width="149"></td>
					<td width="3%">
					<p>&nbsp;</p>
					</td>
					<td width="61">
					<p align="center"><a href="javascript:close()"><img src="/images/close.gif" width="45" height="19" border="0"></a></p>
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
								<p><img src="/images/t1.gif" width="605" height="29" border="0"></p>
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
												<p style="margin-left: 20px;"><font color="#CC0000"><b><img src="/images/i.gif" width="9" height="9" border="0"></b></font>
												<b>구독자명</b></p>
											</td>
												<td width="436" height="30" bgcolor="#F4F1E7">
												<p style="margin-left: 10px;"><input type="text" id="userName" name="userName" tabindex=1 maxlength=30 value="${param.userName}"></p>
											</td>
										</tr>
										<tr>
											<td width="166" height="30" bgcolor="#DEDBCE">
												<p style="margin-left: 20px;"><font color="#CC0000"><b><img	src="/images/i.gif" width="9" height="9" border="0"></b></font>
												<b>생년월일<br></b></p>
											</td>
											<td width="436" height="30" bgcolor="#F4F1E7">
												<p style="margin-left: 10px;">
												<input type="text" id="birth" name="birth" tabindex=2 maxlength=8 style="ime-Mode:disabled" onKeyPress="inputNumCom();">ex)20120101
												</p>
											</td>
										</tr>				
										<tr>
											<td width="166" height="30" bgcolor="#DEDBCE">
												<p style="margin-left: 20px;"><font color="#CC0000"><b><img src="/images/i.gif" width="9" height="9" border="0"></b></font>
												<b>전화번호</b></p>
											</td>
											<td width="436" height="30" bgcolor="#F4F1E7">
												<p style="margin-top: 4px; margin-left: 10px;">
												<select id="phone1" name="phone1" style="border-style: none;" tabindex=3>
													<option value="" selected>----</option>
													<c:forEach items="${areaCode }" var="list">
														<option value="${list.CODE }"> ${list.CODE }</option>
													</c:forEach>
												</select> - 
												<input type="text" id="phone2" name="phone2" value="${param.phone2}" maxlength="4" size="4" tabindex=4 style="ime-Mode:disabled" onKeyPress="inputNumCom();">
												- <input type="text" id="phone3" name="phone3" value="${param.phone3}" maxlength="4" size="4" tabindex=5 style="ime-Mode:disabled" onKeyPress="inputNumCom();">
											</td>
										</tr>
										<tr>
											<td width="166" height="30" bgcolor="#DEDBCE">
												<p style="margin-left: 20px;"><b><font color="#CC0000"><img src="/images/i.gif" width="9" height="9" border="0"></font>
												<b>휴대폰<br></b></p>
											</td>
											<td width="436" height="30" bgcolor="#F4F1E7">
												<p style="margin-top: 4px; margin-left: 10px;">
												<select id="handy1" name="handy1" style="border-style: none;" tabindex=6>
													<option value="" selected>----</option>
													<c:forEach items="${mobileCode }" var="list">
														<option value="${list.CODE }">${list.CODE }</option>
													</c:forEach>
												</select>- 
												<input type="text" id="handy2" name="handy2" value="${param.handy2}" maxlength="4" size="4" tabindex=7 style="ime-Mode:disabled" onKeyPress="inputNumCom();">
												- <input type="text" id="handy3" name="handy3" value="${param.handy3}" maxlength="4" size="4" tabindex=8 style="ime-Mode:disabled" onKeyPress="inputNumCom();">
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
															<p><input type="text" id="zip1" name="zip1" maxlength="3" size="3" tabindex=9 style="cursor: hand;" readonly> - 
															<input type="text" id="zip2" name="zip2" maxlength="3" size="3" tabindex=10 style="cursor: hand;" readonly>&nbsp;
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
															<p><input type="text" id="addr1" name="addr1" value="${param.addr1}" size="41" tabindex=11 readonly style="cursor: hand;" onClick='goPost();'></p>
														</td>
													</tr>
													<tr>
														<td width="486">
															<p><input type="text" id="addr2" name="addr2" value="${param.addr2}" size="54" tabindex=12 maxlength=100></p>
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
												<select id="busu" name="busu" tabindex=13>
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
												<font color="#CC0000"><b><img src="/images/i.gif" width="9" height="9" border="0"></b></font>
												<b>E-Mail<br></b></p>
											</td>
											<td width="436" height="30" bgcolor="#F4F1E7">
												<p style="margin-left: 10px;">
													<input type="text" id="email" name="email" tabindex=14 maxlength=40>
												</p>
											</td>
										</tr>
										<tr>
											<td width="166" height="30" bgcolor="#DEDBCE">
												<p style="margin-left: 20px;"><font color="#CC0000"><b><img src="/images/i.gif" width="9" height="9" border="0"></b></font>
												<b>관심분야</b></p>
											</td>
											<td width="436" height="30" bgcolor="#F4F1E7">
												<p style="margin-top: 4px; margin-left: 10px;">
												<select id="intFldCd" name="intFldCd" style="border-style: none;" tabindex=15>
													<option value="" selected>선택</option>
													<c:forEach items="${intFldList }" var="list">
														<option value="${list.CODE }"> ${list.CNAME }</option>
													</c:forEach>
												</select>
											</td>
										</tr>
										<tr>
											<td width="166" height="140" bgcolor="#DEDBCE">
											<p style="margin-left: 20px;"><b><font color="#CC0000"><img src="/images/i.gif" width="9" height="9" border="0"></font>
											<b>비고/통신란<br>&nbsp;&nbsp;</b>&quot; 200자 내외 작성 &quot;</p>
											</td>
											<td width="436" height="140" bgcolor="#F4F1E7">
												<textarea id="memo" name="memo" tabindex=16 style="border:1px solid #cccccc; background-color: #ffffff; height:130px; width:100%;"></textarea>
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
					<td>
					<center>Copyright© 2006. 매경인터넷(주). 서울특별시 중구 필동 1가 30-1 매경미디어센터 9층.</center>
					</td>
					
				</tr>
			</table>
		</td>
	</tr>
</table>

</form>
</body>