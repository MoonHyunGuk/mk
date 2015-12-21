<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/ajaxUtil.js" charset="UTF-8"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet">
<link type="text/css" href="/select2/select2.css" rel="stylesheet">
<title>매일경제 대학생 자동이체신청</title>
<script type="text/javascript">
	//우편주소 팝업
	function popAddr(){
		var fm = document.getElementById("billingForm");
		
		var left = (screen.width)?(screen.width - 1330)/2 : 10;
		var top = (screen.height)?(screen.height - 200)/2 : 10;
		var winStyle = "width=520,height=700,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		var newWin = window.open("", "pop_addr", winStyle);
		
		fm.target = "pop_addr";
		fm.action = "/reader/subscriptionForm/popNewAddr.do";
		fm.submit();
	}
	
	//우편주소팝업에서 우편주소 선택시 셋팅 펑션
	function setAddr(zip , addr , newAddr, bdNm, dbMngNo){
		jQuery("#zip1").val(zip.substring(0,3));
		jQuery("#zip2").val(zip.substring(3,6));
		jQuery("#addr1").val(addr);
		jQuery("#addr2").val(bdNm);
		jQuery("#addr3").val(newAddr);
		jQuery("#bdMngNo").val(dbMngNo);
	}
	
	//자동이체 독자 등록
	function fn_savePayment(){
		var fileNameVal = document.getElementById("fileName").value;
		var fm = document.getElementById("billingForm");
		var bankNum = document.getElementById("bankNum");
		var bankInfo = document.getElementById("bankInfo");
		var saup = document.getElementById("saup");

		if(!cf_checkNull("stuSch", "대학명")){ return false; }
		if(!cf_checkNull("stuPart", "학과")){ return false; }
		if(!cf_checkNull("stuClass", "학년")){ return false; }
		if(!cf_checkNull("stuCaller", "학번")){ return false; }
		if(!cf_checkNull("userName", "구독자 성명")){ return false; }
		if(!cf_checkNull("handy1", "휴대폰 번호")){ return false; }
		if(!cf_checkNull("handy2", "휴대폰 번호")){ return false; }
		if(!cf_checkNull("handy3", "휴대폰 번호")){ return false; }
		if(!cf_checkNull("zip1", "우편번호")){ return false; }
		if(!cf_checkNull("zip2", "우편번호")){ return false; }
		if(!cf_checkNull("addr2", "상세주소")){ return false; }
	
		 // 첨부파일 확장자 확인 (박윤철)
		if(!cf_checkNull("fileName", "파일첨부")) {
			return false;
		} else {
			if(fileNameVal.indexOf('jpg') == -1){
				if(fileNameVal.indexOf('JPG') == -1){
					alert('jpg 형식 파일만 입력 가능합니다.');
					//$("fileName").focus();
					return;
				}
			}
		}
		
		if(!cf_checkNull("bankMoney", "이체금액")){ return false; }
		if(!cf_checkNull("bankName", "예금주명")){ return false; }
		
		var bankInfo = document.getElementById("bankInfo");
		if(bankInfo.value == " ") {
			alert("이체은행을 선택해주세요"); 
			return false;
		}
		
		if(!cf_checkNull("bankNum", "계좌번호")){ return false; }
		if(!cf_checkNull("saup", "생년월일 또는 사업자번호")){ return false; }
	
		//011농협중앙회 , 012지역농협 구분
		if(bankInfo.value =='011' || bankInfo.value =='012'){
			if(bankNum.value.length == 11){
				bankInfo.value = '011';
			}else if(bankNum.value.length == 14){
				bankInfo.value = '012';
			}else if(bankNum.value.length == 13){
				if(bankNum.value.substring(1,2) == 5){
					bankInfo.value = '012';
				}else{
					bankInfo.value = '011';
				}	
			}
		}
		//개인사업체의 경우 주민번호만 입력 가능
		if(saup.value.length=='11'){
			if(saup.value.substring(3,4) != 8){
				alert('개인사업체의 경우 주민번호를 입력해 주시기 바랍니다.');
				saup.focus();
				return;
			}
		}
	
		//기업은행 평생계좌 신규등록 서비스 중단(2012.11.12 박윤철)
		if(bankInfo.value =='003') {
			var str = bankNum.value;
			str = str.replace(/^\s+|\s+$/g,"");
			if(str.length < 12){
				alert("본 계좌는 평생계좌로 \n자동이체 서비스가 중단되어 신청이 불가능합니다.");
				bankNum.focus();
				return;
			}
		}
		
		if(!confirm("구독신청 하시겠습니까?")){
			return;
		}
		
		/*
		var left = (screen.width)?(screen.width - 200)/2 : 10;
		var top = (screen.height)?(screen.height - 100)/2 : 10;
		var winStyle = "width=200,height=100,left="+ left + ",top=" + top +",titleBar=no , toolbar=no, menubar=no, location=no, status=no, resizeable=no, scrollbars=no";
		var newWin = window.open("", "message", winStyle);
		*/
		fm.target="processFrm";
		fm.action="/reader/subscriptionForm/savePaymentStu2.do";
		fm.submit();
		jQuery("#prcssDiv").show();
	}

	// 로딩 프레임 호출
	function startLoad(){
		document.getElementById("loader").style.display = "block";
	}
	
	function endLoad() {
		window.close();
	}
	
	//개인 또는 법인 클릭시 이벤트
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
	
	jQuery(document).ready(function($){
		$("#stuSch").select2();
		$("#bankInfo").select2();
	});
</script>
</head>
<body style="width: 750px; height: 100%; margin: 0 auto;">
<form id="billingForm" name="billingForm" method="post" enctype="multipart/form-data">
	<!-- title --> 
	<div style="border-bottom:7px solid #f68600; width: 740px;"><img src="/images/l_mk_blacklogo.png"  alt="매일경제" /></div>
	<!-- //title -->
	<div style="padding-top: 5px;">
		<div style="width: 730px; border: 5px solid #eaeaea; overflow: hidden;">
			<!-- 구독자정보 -->
			<div style="padding: 10px 0 3px 0; width: 680px; margin: 0 auto;"><img src="/images/t_apply_popt4.gif"  alt="구독자 정보" /></div>
			<table class="tb_edit_left_3" style="width: 680px; margin: 0 auto;">
				<colgroup> 
					<col width="110px" />
					<col width="230px" />
					<col width="110px" />
					<col width="230px" />
				</colgroup>
				<tr>
					<th><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp;대 학 명</th>
					<td>
						<select id="stuSch" name="stuSch" tabindex="1" style="width: 200px;">
							<option value="" selected>선택</option>
							<c:forEach items="${schoolInfo }" var="list">
								<option value="${list.CNAME }" > ${list.CNAME }</option>
							</c:forEach>
						</select>													
					</td>
					<th><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp;학&nbsp; &nbsp; &nbsp;번</th>
					<td>
						<input type="text" id="stuCaller" name="stuCaller" tabindex="4" maxlength="20" style="ime-Mode:disabled" onkeypress="inputNumCom();">
					</td>
				</tr>
				<tr>
					<th><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp;성&nbsp; &nbsp; &nbsp;명</th>
					<td colspan="3">
						<input type="text" id="userName" name="userName" tabindex="5" maxlength="12">
					</td>
				</tr>
				<tr>
					<th><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp;학&nbsp; &nbsp; &nbsp;과</th>
					<td><input type="text" id="stuPart" name="stuPart" tabindex="2" maxlength="20" /></td>
					<th><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp;학&nbsp; &nbsp; &nbsp;년</th>
					<td>
						<select id="stuClass" name="stuClass" style="width: 60px; " tabindex="3">
							<option value="" selected>선택</option> 
							<option value="1">1학년</option>
							<option value="2">2학년</option>
							<option value="3">3학년</option>
							<option value="4">4학년</option>
						</select>
					</td>
				</tr>
				<tr>
					<th><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp;휴 대 폰</th>
					<td>
						<select id="handy1" name="handy1" style="width: 50px;" tabindex="6">
							<option value="" selected>선택</option>
							<c:forEach items="${mobileCode }" var="list">
								<option value="${list.CODE }">${list.CODE }</option>
							</c:forEach>
						</select> - 
						<input type="text" id="handy2" name="handy2" maxlength="4" tabindex="7" style="ime-Mode:disabled; width: 40px" onkeypress="inputNumCom();">
						- <input type="text" id="handy3" name="handy3" maxlength="4" tabindex="8" style="ime-Mode:disabled; width: 40px" onkeypress="inputNumCom();">
					</td>
					<th>&nbsp;&nbsp;전화번호</th>
					<td>
						<select id="phone1" name="phone1" style="width: 50px;" tabindex="9">
							<option value="" selected>선택</option> 
							<c:forEach items="${areaCode }" var="list">
								<option value="${list.CODE }"> ${list.CODE }</option>
							</c:forEach>
						</select> - 
						<input type="text" id="phone2" name="phone2" maxlength="4" tabindex="10" style="ime-Mode:disabled; width: 40px" onkeypress="inputNumCom();">
						- <input type="text" id="phone3" name="phone3" maxlength="4" tabindex="11" style="ime-Mode:disabled; width: 40px" onkeypress="inputNumCom();">
					</td>
				</tr>
				<tr>
					<th><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp;우편번호</th>
					<td colspan="3">
						<input type="text" id="zip1" name="zip1" maxlength="3" tabindex="6" style="width: 30px;" readonly="readonly" onclick="popAddr();"/> - 
						<input type="text" id="zip2" name="zip2" maxlength="3" tabindex="7" style="width: 30px;" readonly="readonly" onclick="popAddr();"/>&nbsp;
						<a href="#fakeUrl" onclick="popAddr();"><img src="/images/bt_find_pose.gif"  alt="우편번호찾기" style="vertical-align: middle;" /></a>
					</td>
				</tr>
				<tr>
					<th><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp;도로명주소</th>
					<td colspan="3">
						<input type="text" id="addr3" name="addr3" size="41" tabindex="11" readonly style="cursor: hand;">
						<input type="hidden" id="bdMngNo" name="bdMngNo"><br />
					</td>
				</tr>
				<tr>
					<th><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp;상세주소</th>
					<td colspan="3">
						<input type="text" id="addr1" name="addr1" tabindex="8" style="width: 360px;" readonly="readonly"><br />
						<input type="text" id="addr2" name="addr2" tabindex="9" maxlength="100" style="width: 360px;margin-top:3px">
						<div style="font-weight: bold; color: red; padding-top: 3px;">※ 아파트는 동호수까지 입력해주셔야 정확한 배달이 가능합니다. </div>
						<div style="font-weight: bold; ">&nbsp;&nbsp;&nbsp;&nbsp;ex) 101동 1001호일때 :  101-1001가 아닌 101동 1001호로 입력</div>
					</td>
				</tr>
				<tr>
					<th><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp;구독부수</th>
					<td colspan="3"><input type="text" id="busu" name="busu" value="1" tabindex="16" size="3" readonly="readonly"></td>
				</tr>
				<!-- 박윤철 -->
				<tr>
					<th><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp;E - Mail </th>
					<td>
						<input type="text" id="email" name="email" tabindex=11 maxlength=40>
					</td>
					<th><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp;추천교수 </th>
					<td>
						<input type="text" id="stuProf" name="stuProf" tabindex="19" maxlength="8">
					</td>
				</tr>
				<tr>
					<th style="letter-spacing: -2px"><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp;재학증명서첨부 </th>
					<td colspan="3">
						<div> 
							<!-- <div style="position:absolute;left:310px;top:1px;height:20px;width:82px;background-image:url('/images/bt_imp_file.png');"></div>
							<div style="position:absolute;left:0px;top:0px;height:20px;width:500px;">
								<input type="text" name="fileName2" id="fileName2" size="45" readonly="readonly" onclick="setFileName();" style="cursor: hand;"> -->
							<!-- </div> -->
							<input type="file" name="fileName" id="fileName" value="" size="30" style="border:0 solid #fff;cursor:hand; width: 400px;">
						</div>
						<!-- <div style="position:relative; padding-top: 3px;"> -->
						<font color="#CC0000"> ※파일은 500KB 미만의 jpg 파일만 첨부 가능합니다.</font>
						<!--</div> -->
					</td>
				</tr>
			</table>
			<!-- //구독자정보 -->
			<!-- 납부자정보 -->
			<div style="padding: 8px 0 3px 0; width: 680px; margin: 0 auto;"><img src="/images/t_apply_popt5.gif"  alt="납부자정보" /></div>
			<table class="tb_edit_left_3" style="width: 680px; margin: 0 auto;">
				<colgroup> 
					<col width="110px" />
					<col width="230px" />
					<col width="110px" />
					<col width="230px" />
				</colgroup>
				<tr>
					<th><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp;이체금액</th>
					<td><input type="text" id="bankMoney" name="bankMoney" tabindex="20" maxlength="10" value="7500" readonly size="10"></td>
					<th><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp;개인/법인</th>
					<td>
						<input type="radio" name="saup_type" value="Y" style="border:none" checked="checked" onclick="changeSaup(this.value);"/>개인
						<input type="radio" name="saup_type" value="N" style="border:none" onclick="changeSaup(this.value);"/>법인
					</td>
				</tr>
				<tr>
					<th><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp;예 금 주</th>
					<td><input type="text" id="bankName" name="bankName" tabindex="13" maxlength="30"></td>
					<th><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp;<span id="saup_name">생년월일<br/><font style="font-size:10px;font-weight:normal;">(주민번호앞 6자리)</font></span></th>
					<td>
						<input type="text" id="saup" name="saup" style="ime-Mode:disabled; width: 60px" onkeypress="inputNumCom();" tabindex="16" maxlength="6"><br />
						 <div style="color:#CC0000; letter-spacing: -1px;">계좌번호 발급시 기재된  <span id="saup_txt">주민번호 앞 6자리</span></div> 
					</td>
				</tr>
				<tr>
					<th><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp;이체은행</th>
					<td colspan="3">
						<select id="bankInfo" name="bankInfo" tabindex="14" style="width: 200px">
							<c:forEach items="${bankInfo }" var="list">
								<option value="${list.BANKNUM }" > ${list.BANKNAME }</option>
							</c:forEach>
						</select>
						<br/><font color="#CC0000">농협은 농협중앙회와 지역농협으로 나뉩니다. 정확히 구분하여 신청바랍니다.</font>
					</td>
				</tr>
				<tr>
					<th><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp;계좌번호</th>
					<td colspan="3">
						<input type="text" id="bankNum" name="bankNum" size="41" style="ime-Mode:disabled" onKeyPress="inputNumCom();" tabindex="15" maxlength="16" />
					</td>
				</tr>
				<tr>
					<th>&nbsp;&nbsp;비&nbsp; &nbsp; &nbsp;고</th>
					<td colspan="3"><textarea id="memo" name="memo" tabindex="20" style="border:1px solid #cccccc; background-color: #ffffff; height:80px; width:430px;"></textarea></td>
				</tr>
			</table>
			<!-- //납부자정보 -->
			<div id="saveButton" style="text-align:center; width:100%; padding:5px 0;"><a href="#fakeUtrl" onclick="fn_savePayment();"><img src="/images/bt_apply_mkapply.gif" alt="구독신청" /></a></div>
		</div>
	</div>
	<div style="width:730px; text-align:left; font-size:12px; padding-top:7px; color:#6f6f6f; overflow: hidden;" >
		<div style="width: 100px; float: left; text-align: center; padding-top: 5px;"><img src="/images/mklogo.gif" width="74" height="29" border="0" vspace="10" hspace="10" ></div>
		<div style="width: 630px; float: left;">
			Copyright&copy; 2006. 매경인터넷(주). 
			서울특별시 중구 필동 1가 30-1 매경미디어센터 9층.<br/>
			매경인터넷은 회원의 허락없이 개인정보를 수집, 공개, 유출을 하지 않으며 회원정보의 보호를 위해 최선을 다합니다.<br/> 
			사업자 등록번호 : 201-81-25980 / 통신판매업
			신고 : 중구00083호 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;이용관련문의 : 02-2000-2000 
		</div>
	</div>	
</form>
<iframe name="processFrm" id="processFrm" frameborder="0" style="width: 1px; height: 1px"></iframe>
<!-- processing viewer -->
<div id="prcssDiv"  class="loingProcessDiv"><div><img src="/images/process4.gif"/></div></div>
<script type="text/javascript">
/** Jquery setting */
jQuery.noConflict();
jQuery(document).ready(function($) {
	$("#prcssDiv").hide();
});
</script>
<!-- //processing viewer --> 
</body>
</html>