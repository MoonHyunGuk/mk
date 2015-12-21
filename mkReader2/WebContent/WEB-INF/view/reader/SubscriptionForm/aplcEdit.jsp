<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
<title>매일경제 지로 신청</title>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/ajaxUtil.js" charset="UTF-8"></script>
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
.td_style22 {border-top:2px solid #0d1a49; background:#ffffff}

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
<body>
<script type="text/javascript">
	//우편주소 팝업
	function popAddr(){
		var left = (screen.width)?(screen.width - 1330)/2 : 10;
		var top = (screen.height)?(screen.height - 200)/2 : 10;
		var winStyle = "width=520,height=700,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		var newWin = window.open("", "pop_addr", winStyle);
		newWin.focus();
		
		billingForm.target = "pop_addr";
		billingForm.action = "/reader/subscriptionForm/popNewAddr.do";
		billingForm.submit();
	}
	//우편주소팝업에서 우편주소 선택시 셋팅 펑션
	function setAddr(zip , addr , newAddr, bdNm, dbMngNo){
		var fm = document.getElementById("billingForm");
		
		fm.zip1.value = zip.substring(0,3);
		fm.zip2.value = zip.substring(3,6);
		fm.addr1.value = addr;
		fm.addr2.value = bdNm;
		fm.addr3.value = newAddr;
		fm.bdMngNo.value = dbMngNo;
	}

	//신규 신청 독자 등록
	function savePayment(){
		
		if(!cf_checkNull("userName", "구독자 성명")){return false;};
		if(!cf_checkNull("zip1", "우편번호")){return false;};
		if(!cf_checkNull("zip2", "우편번호")){return false;};
		if(!cf_checkNull("addr2", "상세주소")){return false;};
		if(!cf_checkNull("phone1", "전화번호")){return false;};
		if(!cf_checkNull("phone2", "전화번호")){return false;};
		if(!cf_checkNull("handy1", "휴대폰 ")){return false;};
		if(!cf_checkNull("handy2", "휴대폰 ")){return false;};
		if(!cf_checkNull("handy3", "휴대폰 ")){return false;};
		if(!cf_checkNull("intFldCd", "관심분야 ")){return false;};

		if($("birth").value != '' && $("birth").value.length<8 ){
			alert('생년월일을 정확히 입력해 주세요.');
			$("birth").focus();
			return;
		}
			
		startLoad();
		closeButton();
		
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
	
	// 저장 버튼 비활성화
	function closeButton(){
		document.getElementById("saveButton").style.display = "none";
	}
	
	// 저장 버튼활성화
	function openButton(){
		document.getElementById("saveButton").style.display = "block";
	}
	
	// 로딩 프레임 호출
	function startLoad(){
		document.getElementById("loader").style.display = "block";
	}

	// 로딩 프레임 중지
	function endLoad(){
		document.getElementById("loader").style.display = "none";
	}
	
</script>
<div id="loader" name="loader">
	<img src="/images/ajax-loader.gif" alt="로딩이미지" /><br/><br/><br/>
	<font style="font-size: small; font-weight: bolder; ">접수가 완료 되었습니다.<br/><br/>
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
		<td width="676" valign="top" height="100%">
			<table cellpadding="20" cellspacing="10" width="676" height="100%" bgcolor="#eaeaea">
				<tr>
					<td width="666" bgcolor="white" valign="top">
						<h1><img src="/images/t_apply_popt1.gif"  alt="일반 구독자 정보" /></h1>
						
						<table align="center" cellpadding="0" cellspacing="0" width="605" class="table_style1">
							<colgroup>
							<col width="22%" />
							<col width="78%" />
							</colgroup>
							<tr>
								<td class="td_style11">
									<img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>
									&nbsp; <strong>구독자명</strong>
								</td>
								<td class="td_style22">
									<input type="text" id="userName" name="userName" tabindex=1 maxlength=30>
								</td>
							</tr>
							
							<tr>
								<td class="td_style1">
									<img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>
									&nbsp; <strong>생년월일</strong>
								</td>
								<td class="td_style2">
									<input type="text" id="birth" name="birth" tabindex=2 maxlength=8 style="ime-Mode:disabled" onkeypress="inputNumCom();">  &nbsp;  ex)20120101
								</td>
							</tr>
							<tr>
								<td class="td_style1">
									<img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>
									&nbsp; <strong>전화번호</strong>
								</td>
								<td class="td_style2">
									<select id="phone1" name="phone1" tabindex=3>
										<option value="" selected>----</option>
										<c:forEach items="${areaCode }" var="list">
											<option value="${list.CODE }"> ${list.CODE }</option>
										</c:forEach>
									</select> - 
									<input type="text" id="phone2" name="phone2" maxlength="4" size="4" tabindex="4" style="ime-Mode:disabled" onkeypress="inputNumCom();">
									- <input type="text" id="phone3" name="phone3" maxlength="4" size="4" tabindex="5" style="ime-Mode:disabled" onkeypress="inputNumCom();">
								</td>
							</tr>
							<tr>
								<td class="td_style1">
									<img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>
									&nbsp; <strong>휴 대 폰</strong>
								</td>
								<td class="td_style2">
									<select id="handy1" name="handy1" tabindex=6>
										<option value="" selected>----</option>
										<c:forEach items="${mobileCode }" var="list">
											<option value="${list.CODE }">${list.CODE }</option>
										</c:forEach>
									</select>- 
									<input type="text" id="handy2" name="handy2" maxlength="4" size="4" tabindex="7"style="ime-Mode:disabled" onkeypress="inputNumCom();">
									- <input type="text" id="handy3" name="handy3" maxlength="4" size="4" tabindex="8" style="ime-Mode:disabled" onkeypress="inputNumCom();">
								</td>
							</tr>
							
							<tr>
								<td class="td_style1">
									<img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>
									&nbsp; <strong>우편번호</strong>
								</td>
								<td class="td_style2"><input type="text" id="zip1" name="zip1" maxlength="3" size="3" tabindex=9 style="cursor: hand;" readonly> - 
								<input type="text" id="zip2" name="zip2" maxlength="3" size="3" tabindex=10 style="cursor: hand;" readonly>&nbsp;
								<a href="#fakeUrl" onclick="popAddr();"><img src="/images/bt_find_pose.gif"  alt="우편번호 찾기" style="vertical-align: middle;"></a></td>
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
								<td class="td_style1">
									<img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>
									&nbsp; <strong>상세주소</strong>
								</td>
								<td class="td_style2">
									<input type="text" id="addr1" name="addr1" size="41" tabindex="12" readonly style="cursor: hand;"><br />
									<input type="text" id="addr2" name="addr2" size="54" tabindex="13" maxlength=100 style="margin-top:3px">
								</td>
							</tr>
							<tr>
								<td class="td_style1">
									<img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>
									&nbsp; <strong>구독부수</strong>
								</td>
								<td class="td_style2">
									<select id="busu" name="busu" tabindex=14>
										<c:forEach begin="1" end="30" step="1" varStatus="i">
											<option value="${i.index }"> ${i.index }</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<td class="td_style1">
									<img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>
									&nbsp; &nbsp;<strong>E - Mail</strong>
								</td>
								<td class="td_style2">
									<input type="text" id="email" name="email" tabindex=15 maxlength=40>
								</td>
							</tr>
							<tr>
								<td class="td_style1">
									<img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>
									&nbsp; <strong>관심분야</strong>
								</td>
								<td class="td_style2">
									<select id="intFldCd" name="intFldCd" style="border-style: none;" tabindex=16>
										<option value="" selected>선택</option>
										<c:forEach items="${intFldList }" var="list">
											<option value="${list.CODE }"> ${list.CNAME }</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<td class="td_style1">
									<img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/> 
									&nbsp; <strong>비 &nbsp; &nbsp; &nbsp; 고</strong>
								</td>
								<td class="td_style2"> 
									<textarea id="memo" name="memo" tabindex=16 style="border:1px solid #cccccc; background-color: #ffffff; height:130px; width:100%;"></textarea>
								</td>
							</tr>
						</table>
						<div id="saveButton" style="text-align:center; width:100%; padding-top:10px"><a href="javascript:savePayment();"><img src="/images/bt_apply_mkapply.gif" alt="구독신청"></a></div>
						
					</td>
				</tr>
			</table>

		</td>
	</tr>		
</table>
		
<div style="width:676px; text-align:center; font-size:12px; padding-top:7px; color:#6f6f6f">
	Copyright© 2012. (주)매경닷컴. 서울특별시 중구 필동 1가 30-1 매경미디어센터 9층.
</div>
</form>
</body>
</html>