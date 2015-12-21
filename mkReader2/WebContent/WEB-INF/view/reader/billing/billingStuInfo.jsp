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
		var fm = document.getElementById("billingInfoForm");
		
		var left = 0;
		var top = 10;
		var winStyle = "width=520,height=700,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		var newWin = window.open("", "pop_addr", winStyle);
		
		fm.target = "pop_addr";
		fm.action = "/common/common/popNewAddr.do";
		fm.submit();
	}
	
	//우편주소팝업에서 우편주소 선택시 셋팅 펑션
	function setAddr(zip , addr, newAddr, bdNm, dbMngNo){
		var fm = document.getElementById("billingInfoForm");
		
		var zip1 = document.getElementById("zip1");
		var zip2 = document.getElementById("zip2");
		var addr1 = document.getElementById("addr1");
		var addr2 = document.getElementById("addr2");
		var newaddr = document.getElementById("newaddr");
		
		zip1.value = zip.substring(0,3);
		zip2.value = zip.substring(3,6);
		newaddr.value = newAddr;
		addr1.value = addr;
		addr2.value = bdNm;
		fm.bdMngNo.value = dbMngNo;
	}
	
	//부수에 따라 이체금액 셋팅
	function setMoney(){
		$("bankMoney").value = $("busu").value * 7500;
	}
	
	//최종 자동이체 등록
	function updatePaymentFinal(){
		var fm = document.getElementById("billingInfoForm");
		
		if(!cf_checkNull("stuSch", "대학명")) { return false; }
		if(!cf_checkNull("stuPart", "학과")) { return false; }
		if(!cf_checkNull("stuClass", "학년")) { return false; }
		if(!cf_checkNull("userName", "구독자 성명/회사명")) { return false; }
		if(!cf_checkNull("zip1", "우편번호")) { return false; }
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
		
		if(!confirm("수정된 내용을 저장하시겠습니까?")) {
			return false;
		}
	
		fm.target="_self";
		fm.action="/reader/billingStu/updatePaymentFinal.do";
		fm.submit();
		window.opener.fn_search();
		window.close();
	}
	
	//통화기록 보기
	function callLog(){
		var fm = document.getElementById("billingInfoForm");
		
		var left = (screen.width)?(screen.width - 830)/2 : 10;
		var top = (screen.height)?(screen.height - 600)/2 : 10;
		var winStyle = "width=400,height=500,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		var newWin = window.open("", "call_log", winStyle);
		
		fm.target = "call_log";
		fm.action = "/reader/billingStu/popRetrieveCallLog.do?typeCd=2";
		fm.submit();
	}
	
	//계좌번호 변경 팝업
	function popChangeBankNum(){
		var fm = document.getElementById("billingInfoForm");
		
		if($("tmp_status").value == 'EA13' || $("tmp_status").value == 'EA13-' ){
			alert("신규 CMS 확인중, 해지 신청중인 상태에서는 \n계좌번호 변경이 불가합니다."); 
			return;
		}
		var left = (screen.width)?(screen.width - 1330)/2 : 10;
		var top = (screen.height)?(screen.height - 200)/2 : 10;
		var winStyle = "width=400,height=500,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		var newWin = window.open("", "pop_addr", winStyle);
		
		fm.target = "pop_addr";
		fm.action = "/reader/billingStu/popChangeBank.do";
		fm.submit();
	}
	
	//계좌번호 변경
	function changeBankNum(bankMoney , bankName , bankInfo , bankNum , saup , handy1 , handy2 , handy3){
		$("bankMoney").value = bankMoney;
		$("bankName").value = bankName;
		$("bankInfo").value = bankInfo;
		$("bankNum").value = bankNum;
		$("saup").value = saup;
		$("handy1").value = handy1;
		$("handy2").value = handy2;
		$("handy3").value = handy3;
		
		billingInfoForm.target = "_self";
		billingInfoForm.action = "/reader/billingStu/changeBank.do";
		billingInfoForm.submit();
	}
	function showCallLog(){
		<c:if test="${not (countCalllog eq 0) }">
		document.getElementById('callLog').style.display = "inline" ;
		</c:if>
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
	window.attachEvent("onload", showCallLog);
</script>
</head>
<body>
<div class="box_Popup">
	<!-- title --> 
	<div class="pop_title_box">학생독자 상세보기</div>
		<form id="billingInfoForm" name="billingInfoForm" action="" method="post">
			<input type="hidden" id="numId" name="numId" value="${billingInfo[0].NUMID }" />
			<input type="hidden" id="tmp_bankNum" name="tmp_bankNum" value="${billingInfo[0].BANK_NUM }" />
			<input type="hidden" id="tmp_saup" name="tmp_saup" value="${billingInfo[0].SAUP }" />
			<input type="hidden" id="tmp_status" name="tmp_status" value="${billingInfo[0].STATUS }" />
			<input type="hidden" id="tmp_rdate" name="tmp_rdate" value="${billingInfo[0].RDATE }" />
			<input type="hidden" id="inType" name="inType" value="기존" />
			<input type="hidden" id="addrChgYn" name="addrChgYn" value="N" />
			<input type="hidden" id="bdMngNo" name="bdMngNo" value="${billingInfo[0].BDMNGNO }" />
			<!-- edit -->
			<div style="width: 710px; padding-top: 10px;">
				<div style="width: 710px; font-weight: bold; padding-bottom: 3px;"><b class="b03">* 필수 기재란 입니다.</b></div>
				<table class="tb_edit_left" style="width: 710px">
					<colgroup>
						<col width="180px">
						<col width="530px">
					</colgroup>
					<tr>
					 	<th><img src="/images/ic_arr.gif" style="vertical-align: middle" /> 대학명</th>
						<td><input type="text" id="stuSch" name="stuSch" value="${billingInfo[0].STU_SCH }" /></td>
					</tr>
					 <tr>
					 	<th><img src="/images/ic_arr.gif" style="vertical-align: middle" /> 학년/학과</th>
						<td><input type="text" id="stuClass" name="stuClass" value="${billingInfo[0].STU_CLASS }" style="width: 20px;" maxlength="2" /> <b>학년</b>&nbsp;&nbsp;<input type="text" id="stuPart" name="stuPart" value="${billingInfo[0].STU_PART }" /></td>
					</tr>
					<tr>
					 	<th><b class="b03">*</b> 성명</th>
						<td><input type="text" id="userName" name="userName" value="${billingInfo[0].USERNAME }" /></td>
					</tr>	
					<tr >
					 	<th><b class="b03">*</b> 휴대폰</th>
						<td >
							<c:choose>
								<c:when test="${empty billingInfo[0].HANDY }">
									<c:set var="handy" value="${fn:split('010-0000-0000', '-') }"></c:set>	
								</c:when>
								<c:otherwise>
									<c:set var="handy" value="${fn:split(billingInfo[0].HANDY, '-') }"></c:set>
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
					 	<th>전화번호</th>
						<td>
							<c:choose>
								<c:when test="${empty billingInfo[0].PHONE }">
									<c:set var="phone" value="${fn:split('02-0000-0000', '-') }"></c:set>	
								</c:when>
								<c:otherwise>
									<c:set var="phone" value="${fn:split(billingInfo[0].PHONE, '-') }"></c:set>
								</c:otherwise>
							</c:choose>
							<select id="phone1" name="phone1">
								<option value=""></option>
								<c:forEach items="${areaCode }" var="list">
									<option value="${list.CODE }" <c:if test="${list.CODE eq phone[0] }"> selected </c:if>>${list.CODE }</option>
								</c:forEach>
							</select> - 
							<input type="text" id="phone2" name="phone2" value="${phone[1] }" maxlength="4" style="ime-Mode:disabled; width: 40px" onkeypress="inputNumCom();" /> - 
							<input type="text" id="phone3" name="phone3" value="${phone[2] }" maxlength="4" style="ime-Mode:disabled; width: 40px" onkeypress="inputNumCom();" />
						</td>
					</tr>						 						
					<tr>
					 	<th><b class="b03">*</b> 우편번호 </th>
						<td >
							<input type="text"  id="zip1" name="zip1" value="${billingInfo[0].ZIP1 }" readonly="readonly" style="width: 40px; vertical-align: middle;" /> - 
							<input type="text"  id="zip2" name="zip2" value="${billingInfo[0].ZIP2 }" readonly="readonly" style="width: 40px; vertical-align: middle;" /> 
							<a href="#fakeUrl" onclick="popAddr();"><img alt="우편번호찾기" src="/images/ico_search2.gif" style="border: 0; vertical-align: middle;" /></a>
						</td>
					</tr>														 	
					<tr>
					 	<th><b class="b03">*</b> 도로명주소</th>
						<td >
							<input type="text" id="newaddr" name="newaddr" value="${billingInfo[0].NEWADDR }" style="width: 450px; vertical-align: middle; border: 0;" readonly onchange="fn_addr_chg();"  />
						</td>
					</tr>												 	
					<tr>
					 	<th><b class="b03">*</b> 지번주소</th>
						<td >
							<input type="text" id="addr1" name="addr1" value="${billingInfo[0].ADDR1 }" style="width: 450px; vertical-align: middle; border: 0;" readonly  />
						</td>
					</tr>														 	
					<tr>
					 	<th><b class="b03">*</b> 상세주소</th>
						<td>
							<input type="text" id="addr2" name="addr2" value="${billingInfo[0].ADDR2 }" style="width: 450px;" onchange="fn_addr_chg();"  />
						</td>
					</tr>								 	
					<tr>
					 	<th><img src="/images/ic_arr.gif" style="vertical-align: middle"> 구독부수</th>
						<td>
							<select id="busu" name="busu" onchange="setMoney();">
							<c:forEach begin="1" end="30" step="1" varStatus="i">
								<option value="${i.index }" <c:if test="${i.index eq billingInfo[0].BUSU }"> selected</c:if>>${i.index }</option>
							</c:forEach>
							</select>
						</td>
					</tr>		
					<tr>
					 	<th>&nbsp;&nbsp; 이메일</th>
						<td><input type="text" id="email" name="email" value="${billingInfo[0].EMAIL }" style="width: 250px;" /></td>
					</tr>
					<tr >
					 	<th><img src="/images/ic_arr.gif" style="vertical-align: middle"> 추천교수</th>
						<td><input type="text" id="stuProf" name="stuProf" value="${billingInfo[0].STU_PROF }" style="width: 100px;" /></td>
					 </tr>
					<tr >
					 	<th><img src="/images/ic_arr.gif" style="vertical-align: middle"> 권유자</th>
						<td><input type="text" id="stuAdm" name="stuAdm" value="${billingInfo[0].STU_ADM }" style="width: 100px;" /></td>
					 </tr>
					<tr >
					 	<th><img src="/images/ic_arr.gif" style="vertical-align: middle"> 통화자</th>
						<td><input type="text" id="stuCaller" name="stuCaller" value="${billingInfo[0].STU_CALLER }" style="width: 100px;" /></td>
					</tr>
					<tr>
					 	<th>&nbsp;&nbsp; 납부자번호</th>
						<td >
							<input type="text" id="jiSerial" name="jiSerial" value="${billingInfo[0].JIKUK}" size="6" readonly="readonly" />  
							<input type="text" id="serial" name="serial" value="${billingInfo[0].SERIAL}" readonly="readonly" style="width: 55px;" /> "매일경제신문사 기재란 입니다"
						</td>
					</tr>						 						 						 						 				 				 				 	
					<tr>
					 	<th>&nbsp;&nbsp; 독자번호</th>
						<td ><input type="text" id="readNo" name="readNo" value="${billingInfo[0].READNO }" readonly="readonly" style="width: 100px;" /> "매일경제신문사 기재란 입니다"</td>
					</tr>
					<tr>
					 	<th>&nbsp;&nbsp; 신청일시</th>
						<td ><span> ${billingInfo[0].INDATE } </span></td>
					</tr>
				</table>  
				<div style="padding: 20px 0 5px 0; font-weight: bold; width: 710px;">
					<div style="padding-bottom: 5px;">납부자 정보</div>
					<div><img src="/images/ic_arr.gif" style="border: 0; vertical-align: middle;" alt=""> <b class="b03">익월 5일 출금</b></div>
				</div>	
				<table class="tb_edit_left" style="width: 710px">
					<colgroup>
						<col width="180px">
						<col width="530px">
					</colgroup>
				 	<tr>
				 		<th><b class="b03">*</b> 이체금액</th>
						<td>
							<input type="text" id="bankMoney" name="bankMoney" value="${billingInfo[0].BANK_MONEY }" style="width: 100px; ime-Mode:disabled" onkeypress="inputNumCom();" />
							<font class="b03">* 다부수 고객의 경우 모든 구독 정보의 단가합을 입력해주시기 바랍니다.</font>
						</td>
					</tr>
		 					 	
					<tr>
					 	<th><b class="b03">*</b> 예금주명</th>
						<td><input type="text" id="bankName" name="bankName" value="${billingInfo[0].BANK_NAME }" style="width: 100px;" /></td>
					</tr>
					<tr>
					 	<th><b class="b03">*</b> 이체은행/계좌번호</th>
						<td>
							<input type="hidden" id="tmp_bank" name="tmp_bank" value="${billingInfo[0].BANK  }" />
							<select id="bankInfo" name="bankInfo">
							<c:forEach items="${bankInfo }" var="list">
								<option value="${list.BANKNUM }" <c:if test="${list.BANKNUM eq billingInfo[0].BANK  }"> selected</c:if> > ${list.BANKNAME }</option>
							</c:forEach>
							</select>&nbsp;
							<input type="text" id="bankNum" name="bankNum" value="${billingInfo[0].BANK_NUM }" maxlength="16" style="width: 140px; ime-Mode:disabled" onkeypress="inputNumCom();" />
						</td>
					</tr>							
					<tr>
					 	<th><b class="b03">*</b> 주민등록번호</th>
						<td><input type="text" id="saup" name="saup" value="${billingInfo[0].SAUP }" maxlength="13" style="width: 130px; ime-Mode:disabled" onkeypress="inputNumCom();">&nbsp;&nbsp;* 계좌번호 발급시기재된 주민번호</td>
					</tr>
					<tr>
					 	<th>&nbsp;&nbsp; <font class="box_p">비고/통신란</font><br>&nbsp;&nbsp; "200자 내외 작성"</th>
						<td>
							<!-- memo list -->
							<c:forEach items="${memoList}" var="list" begin="0" end="2"  varStatus="status">
								<div style="padding-bottom: 5px; border-bottom: 1px solid #e5e5e5"><b>[${list.CREATE_ID}]&nbsp;${list.CREATE_DATE}</b><br/>${list.MEMO}</div>
							</c:forEach>
							<c:if test="${fn:length(memoList) > 3}">
								<div style="padding: 3px 0; text-align: right;"><a href="#fakeUrl" onclick="fn_memo_view_more('${billingInfo[0].READNO }')"><img alt="더보기" title="더보기" src="/images/ico_more.gif" /></a></div>
							</c:if>
							<!-- //memo list -->
							<div style="padding-top: 3px;">
								<textarea id="memo" name="memo" style="width: 95%"></textarea>
							</div>
						</td>
					</tr>														 	
				</table>						
				<div style="width: 710px; text-align: right; padding-top: 10px;">
		  			<a href="#fakeUrl" onclick="callLog();"><img src="/images/call_memo.gif" style="vertical-align: middle"></a>
					<span id="callLog" style="display:none"><img src="/images/icon_new.gif" border="0" align="top" /></span>
			  		<a href="#fakeUrl" onclick="updatePaymentFinal();"><img src="/images/bt_save.gif" style="vertical-align: middle"></a>  
			  		<a href="#fakeUrl" onclick="fn_popClose();"><img src="/images/bt_close.gif" style="border: 0; vertical-align: middle"></a>
			  		<c:if test="${not empty billingInfo[0].RDATE }"><a href="#fakeUrl" onclick="popChangeBankNum();"><img src="/images/change_bank.gif" style="vertical-align: middle"></a></c:if>
				</div>
			</div>
		</form>
	</div>
</body>
</html>