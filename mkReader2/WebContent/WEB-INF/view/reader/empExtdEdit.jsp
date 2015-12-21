<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/js/ajaxUtil.js"></script>
<script type="text/javascript">
	// 숫자만 입력 가능하도록 체크 키 다운시
	function inputNumCom(){
		var keycode = event.keyCode;
		 
		if ((event.keyCode<48) || (event.keyCode>57)){
			alert("숫자만 입력 가능합니다.");
			event.keyCode = 0;  // 이벤트 cancel
		}
	}
	
	// 우편주소 팝업
	function popAddr(){
		var fm = document.getElementById("empExtdForm") ;
		
		var left = 0;
		var top = 30;
		var winStyle = "width=520,height=700,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		var newWin = window.open("", "pop_addr", winStyle);
		
		fm.target = "pop_addr";
		fm.action = "/common/common/popNewAddr.do";
		fm.submit();
	}

	//우편주소팝업에서 우편주소 선택시 셋팅 펑션
	function setAddr(zip , addr, newAddr, bdNm, bdMngNo){
		$("zip").value = zip;
		$("addr1").value = addr;
		$("addr2").value = bdNm;
		$("newaddr").value = newAddr;
		$("bdMngNo").value = bdMngNo;
	}
	
	// 사원확장 저장
	function saveEmpExtd(){
		// 벨리데이션 체크
		if(!validate()){
			return;
		}
		
		$("empExtdForm").target="_self";
		$("empExtdForm").action="/reader/empExtd/saveEmpExtd.do";
		$("empExtdForm").submit();
	}
	
	// 사원확장 벨리데이션 체크
	function validate(){
		var mediaCd = getRadioValue(document.empExtdForm.media);
		var readTypCd = getRadioValue(document.empExtdForm.readerTyp);
		var gubun = getRadioValue(document.empExtdForm.gubun);
		var displayCd = mediaCd+""+readTypCd+""+gubun;
		
		// 구독자 이름 입력여부 체크
		if($("readNm").value == ""){
			alert("구독자 성명는 필수 입력입니다.");
			$("readNm").focus();
			return false;
		}
		
		// 신문-일반 독자의 경우만 필수사항 체크
		if(displayCd == "111" || displayCd == "112"){
			// 우편번호 입력여부 체크
			if($("zip").value == ""){
				alert("우편번호는 필수 입력입니다.");
				$("zip").focus();
				return false;
			}
			
			// 주소 체크
			if($("addr1").value == ""){
				alert("주소는 필수 입력입니다.");
				$("addr1").focus();
				return false;
			}
			
			// 상세 주소체크
			if($("addr2").value == ""){
				alert("상세주소는 필수 입력입니다.");
				$("addr2").focus();
				return false;
			}
		}
		
		// 구독자 연락처 입력여부 체크
		if($("readTel").value == ""){
			alert("구독자 연락처는 필수 입력입니다.");
			$("readTel").focus();
			return false;
		}
		
		// 구독자 연락처 지역번호 확인
		if($("readTel").value.length < 9 && $("readTel").value.substring(0, 2) != "02" ){
			if(confirm("지역번호가 02가 맞습니까?")){
				$("readTel").value = "02"+$("readTel").value;
			}
		}
		
		if($("readTel").value.length < 9){
			alert("구독자 연락처를 확인해 주십시요.");
			$("readTel").focus();
			return false;
		}
		
		
		// 구독부수
		if($("qty").value == ""){
			alert("구독부수는 필수 입력입니다.");
			$("qty").focus();
			return false;
		}

		// 회사
		if($("empComp").value == ""){
			alert("회사은 필수 입력입니다.");
			$("empComp").focus();
			return false;
		}
		
		// 실국
		if($("empDept").value == ""){
			alert("실국은 필수 입력입니다.");
			$("empDept").focus();
			return false;
		}
		
		// 권유자 성명 입력여부 체크
		if($("empNm").value == ""){
			alert("권유자 성명은 필수 입력입니다.");
			$("empNm").focus();
			return false;
		}
		
		// 권유자 연락처 입력여부 체크
		if($("empTel").value == ""){
			alert("권유자 휴대폰번호는 필수 입력입니다.");
			$("empTel").focus();
			return false;
		}

		return true;
	}

	// 소속 부서 조회
	function changeEmpComp(){
		if($("empComp").value != ''){
			var url = "/reader/empExtd/ajaxOfficeNm.do?resv1="+$("empComp").value+"&resv3=1";
			sendAjaxRequest(url, "empExtdForm", "post", empDeptList);
		}else{
			$("empDept").options.length = 0;
			$("empDept").options[0] = new Option("선택", "");
			$("empTeam").options.length = 0;
			$("empTeam").options[0] = new Option("선택", "");
		}
	}

	function empDeptList(responseHttpObj) {
		if (responseHttpObj) {
			try {
				var result = eval("(" + responseHttpObj.responseText + ")");
				if (result) {
					setEmpDeptList(result);
				}
			} catch (e) {
				alert("오류 : " + e);
			}
		}
	}

	function setEmpDeptList(jsonObjArr) {
		if (jsonObjArr.length > 0) {
			$("empDept").options.length = 0;
			$("empDept").options[0] = new Option("선택", "");
			for ( var i = 0; i < jsonObjArr.length; i++) {
				$("empDept").options[i+1] = new Option(jsonObjArr[i].CNAME , jsonObjArr[i].CODE );
				if(jsonObjArr[i].CODE == '${empExtdInfo[0].EMPDEPTCD}'){
					$("empDept").options[i+1].selected = true;
				}
			}
		}
		changeEmpDept();

	}

	// 소속 팀 조회
	function changeEmpDept(){
		if($("empDept").value != ''){
			var url = "/reader/empExtd/ajaxOfficeNm.do?resv1="+$("empDept").value+"&resv3=2";
			sendAjaxRequest(url, "empExtdForm", "post", empTeamList);
		}else{
			$("empTeam").options.length = 0;
			$("empTeam").options[0] = new Option("선택", "");
		}
	}

	function empTeamList(responseHttpObj) {
		if (responseHttpObj) {
			try {
				var result = eval("(" + responseHttpObj.responseText + ")");
				if (result) {
					setEmpTeamList(result);
				}
			} catch (e) {
				alert("오류 : " + e);
			}
		}
	}

	function setEmpTeamList(jsonObjArr) {
		if (jsonObjArr.length > 0) {
			$("empTeam").options.length = 0;
			$("empTeam").options[0] = new Option("선택", "");
			for ( var i = 0; i < jsonObjArr.length; i++) {
				$("empTeam").options[i+1] = new Option(jsonObjArr[i].CNAME , jsonObjArr[i].CODE );
				if(jsonObjArr[i].CODE == '${empExtdInfo[0].EMPTEAMCD}'){
					$("empTeam").options[i+1].selected = true;
				}
			}
		}else{
			$("empTeam").options.length = 0;
			$("empTeam").options[0] = new Option("선택", "");
		}

	}
	
	
	// 화면 구성 세팅
	function setDisplay3333(){
		var mediaCd = getRadioValue(document.empExtdForm.media);
		var readTypCd = getRadioValue(document.empExtdForm.readerTyp);
		var gubun = getRadioValue(document.empExtdForm.gubun);
		var displayCd = mediaCd+""+readTypCd+""+gubun;
		
		// 신문-일반-개인
		if(displayCd == "111"){
			$("trGubun").style.display = "";
			$("trZip").style.display = "";
			$("trAddr1").style.display = "";
			$("trAddr2").style.display = "";
			$("trAddr3").style.display = "";
			$("trBoseq").style.display = "";
			$("trCompNm").style.display = "none";
			$("trAplc").style.display = "";
			$("spanNm").innerHTML = " 성 명";
			//$("divNtYn").style.display = "block";
		// 신문-일반-기업체
		}else if(displayCd == "112"){
			$("trGubun").style.display = "";
			$("trZip").style.display = "";
			$("trAddr1").style.display = "";
			$("trAddr2").style.display = "";
			$("trAddr3").style.display = "";
			$("trBoseq").style.display = "";
			$("trCompNm").style.display = "";
			$("trAplc").style.display = "";
			//$("divNtYn").style.display = "block";
			$("spanNm").innerHTML = " 성 명(담당자)";
		// 신문-학생-개인 or 기업체
		}else if(displayCd == "121" || displayCd == "122"){
			$("trGubun").style.display = "none";
			$("trZip").style.display = "none";
			$("trAddr1").style.display = "none";
			$("trAddr2").style.display = "none";
			$("trAddr3").style.display = "none";
			$("trBoseq").style.display = "";
			$("trCompNm").style.display = "none";
			$("trAplc").style.display = "none";
			$("aplcYn").checked = false;
			$("spanNm").innerHTML = " 성 명";
			//$("divNtYn").style.display = "none";
		// 전자판-일반-개인
		}else if(displayCd == "211" || displayCd == "311"){
			$("trGubun").style.display = "";
			$("trZip").style.display = "none";
			$("trAddr1").style.display = "none";
			$("trAddr2").style.display = "none";
			$("trAddr3").style.display = "none";
			$("trBoseq").style.display = "none";
			$("trCompNm").style.display = "none";
			$("trAplc").style.display = "none";
			$("aplcYn").checked = false;
			$("spanNm").innerHTML = " 성 명";
			//$("divNtYn").style.display = "none";
		// 전자판-일반-기업체	
		}else if(displayCd == "212" || displayCd == "312"){
			$("trGubun").style.display = "";
			$("trZip").style.display = "none";
			$("trAddr1").style.display = "none";
			$("trAddr2").style.display = "none";
			$("trAddr3").style.display = "none";
			$("trBoseq").style.display = "none";
			$("trCompNm").style.display = "";
			$("trAplc").style.display = "none";
			$("aplcYn").checked = false;
			$("spanNm").innerHTML = " 성 명(담당자)";
			//$("divNtYn").style.display = "none";
		// 전자판-학생-개인 or 기업체
		}else if(displayCd == "221" || displayCd == "222" || displayCd == "321" || displayCd == "322"){
			$("trGubun").style.display = "none";
			$("trZip").style.display = "none";
			$("trAddr1").style.display = "none";
			$("trAddr2").style.display = "none";
			$("trAddr3").style.display = "none";
			$("trBoseq").style.display = "none";
			$("trCompNm").style.display = "none";
			$("trAplc").style.display = "none";
			$("aplcYn").checked = false;
			$("spanNm").innerHTML = " 성 명";
			//$("divNtYn").style.display = "none";
		// 교육용
		}else if(displayCd.substr(0, 2) == "13" || displayCd.substr(0, 2) == "23" || displayCd.substr(0, 2) == "33"){
			$("trGubun").style.display = "none";
			$("trZip").style.display = "none";
			$("trAddr1").style.display = "none";
			$("trAddr2").style.display = "none";
			$("trAddr3").style.display = "none";
			$("trBoseq").style.display = "none";
			$("trCompNm").style.display = "";
			$("trAplc").style.display = "none";
			$("aplcYn").checked = false;
			$("spanNm").innerHTML = " 성 명(담당자)";
			//$("divNtYn").style.display = "none";
		}else{
			$("trGubun").style.display = "";
			$("trZip").style.display = "none";
			$("trAddr1").style.display = "none";
			$("trAddr2").style.display = "none";
			$("trAddr3").style.display = "none";
			$("trBoseq").style.display = "none";
			$("trCompNm").style.display = "none";
			$("trAplc").style.display = "none";
			$("spanNm").innerHTML = " 성 명";
			//$("divNtYn").style.display = "none";
		}
	}

	// 라디오박스 조회
	function getRadioValue(radioObj){
		if(radioObj != null){
			for(var i = 0; i < radioObj.length; i++){
				if(radioObj[i].checked){
	                    return radioObj[i].value;
	            }
	        }
	    }
        return null;
    }

	// 사원정보 검색
	function popEmp(){
		var left = (screen.width)?(screen.width - 1330)/2 : 10;
		var top = (screen.height)?(screen.height - 200)/2 : 10;
		var winStyle = "width=800,height=460,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=0";		
		var newWin = window.open("", "popEmpInfo", winStyle);
		$("empExtdForm").target = "popEmpInfo";
		$("empExtdForm").action = "/reader/empExtd/popEmpInfo.do";
		$("empExtdForm").submit();
	}

	// 콤보박스 초기화
	function onLoad(){
		changeEmpComp();
		$("memo").innerHTML = $("tmpMemo").value;
	}

	function setEmpValue(empNm, mobile, empNo){

		//$("empNo").value = empNo;
		$("empNm").value = empNm;
		$("empTel").value = mobile;
	}
	
/** Jquery setting */
var j = $.noConflict();

//화면 구성 세팅
function setDisplay(){
	var mediaCd = getRadioValue(document.empExtdForm.media);
	var readTypCd = getRadioValue(document.empExtdForm.readerTyp);
	var gubun = getRadioValue(document.empExtdForm.gubun);
	var displayCd = mediaCd+""+readTypCd+""+gubun;
	
	// 신문-일반-개인
	if(displayCd == "111"){
		j(".gubun").show();
		j(".addr").show();
		j(".boseq").show();
		j(".compNm").hide();
		j(".aplc").show();
		//j("#spanNm").innerHTML = " 성 명";
		//j("divNtYn").style.display = "block";
	// 신문-일반-기업체
	}else if(displayCd == "112"){
		j(".gubun").show();
		j(".trZip").show();
		j(".boseq").show();
		j(".compNm").show();
		j(".aplc").show();
		//j("#divNtYn").style.display = "block";
		//j("#spanNm").innerHTML = " 성 명(담당자)";
	// 신문-학생-개인 or 기업체
	}else if(displayCd == "121" || displayCd == "122"){
		j(".gubun").hide();
		j(".addr").hide();
		j(".boseq").show();
		j(".compNm").hide();
		j(".aplc").hide();
		j("#aplcYn").checked = false;
		j("#spanNm").innerHTML = " 성 명";
		//j("#divNtYn").hide();
	// 전자판-일반-개인
	}else if(displayCd == "211" || displayCd == "311"){
		j(".gubun").show();
		j(".addr").hide();
		j(".boseq").hide();
		j(".compNm").hide();
		j(".aplc").hide();
		j("#aplcYn").checked = false;
		j("#spanNm").innerHTML = " 성 명";
		//j("#divNtYn").hide();
	// 전자판-일반-기업체	
	}else if(displayCd == "212" || displayCd == "312"){
		j(".gubun").show();
		j(".addr").hide();
		j(".boseq").hide();
		j(".compNm").show();
		j(".aplc").hide();
		j("#aplcYn").checked = false;
		j("#spanNm").innerHTML = " 성 명(담당자)";
		//j("#divNtYn").hide();
	// 전자판-학생-개인 or 기업체
	}else if(displayCd == "221" || displayCd == "222" || displayCd == "321" || displayCd == "322"){
		j(".gubun").hide();
		j(".addr").hide();
		j(".boseq").hide();
		j(".compNm").hide();
		j(".aplc").hide();
		j("#aplcYn").checked = false;
		j("#spanNm").innerHTML = " 성 명";
		//j("#divNtYn").hide();
	// 교육용
	}else if(displayCd.substr(0, 2) == "13" || displayCd.substr(0, 2) == "23" || displayCd.substr(0, 2) == "33"){
		j(".gubun").hide();
		j(".addr").hide();
		j(".boseq").hide();
		j(".compNm").show();
		j(".aplc").hide();
		j("#aplcYn").checked = false;
		j("#spanNm").innerHTML = " 성 명(담당자)";
		//j("#divNtYn").hide();
	}else{
		j(".gubun").show();
		j(".addr").hide();
		j(".boseq").hide();
		j(".compNm").hide();
		j(".aplc").hide();
		j("#spanNm").innerHTML = " 성 명";
		//j("#divNtYn").hide();
	}
}

jQuery(document).ready(function($){
	onLoad();
	setDisplay();
});
</script>
<!-- title -->
<div><span class="subTitle">사원확장 리스트</span></div>
<!-- //title -->
<form id="empExtdForm" name="empExtdForm" action="" method="post">
	<input type="hidden" id="numId" name="numId" value="${empExtdInfo[0].NUMID}" />
	<input type="hidden" id="ntdt" name="ntdt" value="${empExtdInfo[0].NTDT}" />
	<input type="hidden" id="aplcNo" name="aplcNo" value="${empExtdInfo[0].APLCNO}" />
	<input type="hidden" id="tmpMemo" name="tmpMemo" value="${empExtdInfo[0].MEMO}" />
	<div style="width: 710px; font-weight: bold">
		<div style="float: left"><img src="/images/ic_arr.gif" border="0" style="vertical-align: middle;" /> 구독자 정보</div>
		<div style="float: right"><b class="b03">* 필수 기재란 입니다.</b></div>
	</div>
	<div style="clear: both;">
		<table class="tb_view_left">
			<colgroup>
				<col width="180px">
				<col width="530px">
			</colgroup>
			<tr>
			    <td colspan="2" style="background-color: #e5e5e5; text-align:center;">
			    	<input type="radio" id="media" name="media" value="1" <c:if test="${empExtdInfo[0].MEDIA eq '1' or empty empExtdInfo[0].MEDIA}">checked</c:if> onclick="setDisplay()"> 신문 &nbsp;&nbsp;&nbsp;&nbsp; 
			    	<input type="radio" id="media" name="media" value="2" <c:if test="${empExtdInfo[0].MEDIA eq '2' }">checked</c:if> onclick="setDisplay()" > e신문 &nbsp;&nbsp;&nbsp;&nbsp; 
			    	<input type="radio" id="media" name="media" value="3" <c:if test="${empExtdInfo[0].MEDIA eq '3' }">checked</c:if> onclick="setDisplay()" > 초판
			    </td>
			</tr>
			<tr>
			 	<th><b class="b03">*</b> 독자유형</th>
			    <td>
			    	<input type="radio" id="readerTyp" name="readerTyp" value="1" <c:if test="${empExtdInfo[0].READERTYP eq '1' or empty empExtdInfo[0].READERTYP}">checked</c:if> onclick="setDisplay()"> 일반 &nbsp;&nbsp;&nbsp;&nbsp; 
			    	<input type="radio" id="readerTyp" name="readerTyp" value="2" <c:if test="${empExtdInfo[0].READERTYP eq '2' }">checked</c:if> onclick="setDisplay()"> 학생 &nbsp;&nbsp;&nbsp;&nbsp;
			    	<input type="radio" id="readerTyp" name="readerTyp" value="3" <c:if test="${empExtdInfo[0].READERTYP eq '3' }">checked</c:if> onclick="setDisplay()"> 교육용
			    </td>
			</tr>
			<tr class="gubun" id="trGubun" <c:if test="${empExtdInfo[0].READERTYP eq '2' or empExtdInfo[0].READERTYP eq '3'}">style="display:none"</c:if>>
			 	<th class="gubun"><b class="b03">*</b> 신청구분</th>
			    <td class="gubun">
			    	<input type="radio" id="gubun" name="gubun" value="1" <c:if test="${(empExtdInfo[0].GUBUN eq '1' or empty empExtdInfo[0].GUBUN) and (empExtdInfo[0].READERTYP ne '2' or empExtdInfo[0].READERTYP ne '3')}">checked</c:if> onclick="setDisplay()"> 개인 &nbsp;&nbsp;&nbsp;&nbsp; 
			    	<input type="radio" id="gubun" name="gubun" value="2" <c:if test="${empExtdInfo[0].GUBUN eq '2' }">checked</c:if> onclick="setDisplay()"> 기업체
			    </td>
			</tr>
			<tr>
			 	<th><b class="b03">*</b> <font id="spanNm">성 명<c:if test="${empExtdInfo[0].GUBUN eq '2' or empExtdInfo[0].READERTYP eq '3'}">(담당자)</c:if></font> </th>
				<td ><input type="text" id="readNm" name="readNm" class="box_200" value="${empExtdInfo[0].READNM}"></td>
			</tr>
			<tr class="compNm" id="trCompNm" <c:if test="${empExtdInfo[0].GUBUN ne '2' }">style="display:none"</c:if>>
			 	<th class="compNm" > &nbsp;&nbsp;회사명</th>
				<td class="compNm" ><input type="text" id="compNm" name="compNm" class="box_200" value="${empExtdInfo[0].COMPNM}"></td>
			</tr>
			<tr class="addr" id="trZip" <c:if test="${empExtdInfo[0].MEDIA eq '2' or empExtdInfo[0].READERTYP eq '2'}">style="display:none"</c:if>>
			 	<th class="addr" ><b class="b03">*</b> 우편번호</th>
				<td class="addr" >
					<input type="text" class="box_80" id="zip" name="zip" value="${empExtdInfo[0].ZIP}" readonly/>
					<a href="javascript:popAddr();"><img src="/images/ico_search2.gif" border="0" style="vertical-align: middle;" /></a>
				</td>
			</tr>
			<tr class="addr" id="trAddr1" <c:if test="${empExtdInfo[0].MEDIA eq '2' or empExtdInfo[0].READERTYP eq '2' or empExtdInfo[0].READERTYP eq '3'}">style="display:none"</c:if>>
			 	<th class="addr" ><b class="b03">*</b> 도로명주소</th>
				<td class="addr" >
					<input type="text" id="newaddr" name="newaddr" class="box_350" style="border: 0;" readonly value="${empExtdInfo[0].NEWADDR}">
					<input type="hidden" id="bdMngNo" name="bdMngNo" value="${empExtdInfo[0].BDMNGNO}"><br/>
				</td>
			</tr>
			<tr class="addr" id="trAddr2" <c:if test="${empExtdInfo[0].MEDIA eq '2' or empExtdInfo[0].READERTYP eq '2' or empExtdInfo[0].READERTYP eq '3'}">style="display:none"</c:if>>
			 	<th class="addr" ><b class="b03">*</b> 지번주소</th>
				<td class="addr" >
					<input type="text" id="addr1" name="addr1" class="box_350" style="border: 0;" readonly value="${empExtdInfo[0].ADDR1}">
				</td>
			</tr>
			<tr class="addr" id="trAddr3" <c:if test="${empExtdInfo[0].MEDIA eq '2' or empExtdInfo[0].READERTYP eq '2' or empExtdInfo[0].READERTYP eq '3'}">style="display:none"</c:if>>
			 	<th class="addr" ><b class="b03">*</b> 상세주소</th>
				<td class="addr" >
					<input type="text" id="addr2" name="addr2" class="box_350" value="${empExtdInfo[0].ADDR2}">
				</td>
			</tr>
			<tr>
			 	<th><b class="b03">*</b> 구독자 연락처</th>
				<td>
					<input type="text" id="readTel" name="readTel" class="box_100" maxlength="12" value="${empExtdInfo[0].READTEL}" style="ime-Mode:disabled" onkeypress="inputNumCom();">
				</td>
			</tr>
			<tr class="boseq" id="trBoseq" <c:if test="${empExtdInfo[0].MEDIA eq '2'}">style="display:none"</c:if>>
			 	<th class="boseq"><b class="b03">*</b> 관리지국</th>
				<td class="boseq">
					<select name="boseq" id="boseq">
						<option value=""></option>
						<c:forEach items="${agencyAllList }" var="list">
							<option value="${list.SERIAL }" <c:if test="${empExtdInfo[0].BOSEQ eq list.SERIAL}">selected </c:if>>${list.NAME} </option>
						</c:forEach>
					</select>
					<c:if test="${not empty empExtdInfo[0].NTDT }">(${empExtdInfo[0].NTDT})</c:if>
				</td>
			</tr>
			<tr class="aplc" id="trAplc" <c:if test="${empExtdInfo[0].MEDIA eq '2' or empExtdInfo[0].READERTYP eq '2' or empExtdInfo[0].READERTYP eq '3'}">style="display:none"</c:if>>
			 	<th class="aplc"></th>
				<td class="aplc">
					<input class="aplc" type="checkbox" id="aplcYn" name="aplcYn" <c:if test="${not empty empExtdInfo[0].APLCNO }">checked</c:if>> 본사신청독자 입력
				</td>
			</tr>
			<tr>
			 	<th><b class="b03">*</b> 구독부수</th>
				<td><input type="text" id="qty" name="qty" class="box_100" value="${empExtdInfo[0].QTY}" style="ime-Mode:disabled" onkeypress="inputNumCom();" maxlength="3"></td>
			</tr>
		</table>
	</div>

	<div style="width: 710px; font-weight: bold; margin-top: 10px;">
		<div style="float: left"><img src="/images/ic_arr.gif" border="0" > 권유자 정보</div>
		<div style="float: right"><b class="b03">* 필수 기재란 입니다.</b></div>
	</div>

	<div style="clear: both;">
		<table class="tb_view_left">
			<colgroup>
				<col width="180px"/>
				<col width="530px"/>
			</colgroup>
			<tr>
			 	<th><b class="b03">*</b> 회 사</th>
				<td>
					<select id="empComp" name="empComp" style="width: 130px;" onchange="javascript:changeEmpComp();">
					<option value="">선택</option>				
					<c:forEach items="${companyCd }" var="list">
						<option value="${list.CODE }" <c:if test="${list.CODE eq empExtdInfo[0].EMPCOMPCD }"> selected </c:if>>${list.CNAME }</option>
					</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
			 	<th><b class="b03">*</b> 실 국</th>
				<td>
					<select id="empDept" name="empDept" style="width: 130px;"  onchange="javascript:changeEmpDept();">
						<option value="">선택</option>
					</select>
				</td>
			</tr>					
			<tr>
			 	<th><b class="b03">*</b> 부 서</th>
				<td >
					<select id="empTeam" name="empTeam" style="width: 130px;" >
						<option value="">선택</option>
					</select>
				</td>
			</tr>
			<!-- <tr bgcolor="ffffff">
			 	<td bgcolor="f9f9f9" class="box_p">&nbsp;&nbsp;권유자사번</td>
				<td ><input type="text" id="empNo" name="empNo" class="box_80" value="${empExtdInfo[0].EMPNM}">
				</td>
			</tr> -->
			<tr>
			 	<th><b class="b03">*</b> 권유자성명</th>
				<td>
					<input type="text" id="empNm" name="empNm" class="box_100" value="${empExtdInfo[0].EMPNM}" style="vertical-align: middle;" />
					<img alt="권유자성명찾기"  src="/images/ico_search2.gif" style="vertical-align: middle; border: 0; cursor: pointer;" onclick="popEmp();" />
				</td>
			</tr>
			<tr>
			 	<th><b class="b03">*</b> 권유자휴대폰</th>
				<td>
					<input type="text" id="empTel" name="empTel" class="box_100" maxlength="12" value="${empExtdInfo[0].EMPTEL}" style="ime-Mode:disabled" onkeypress="inputNumCom();">
				</td>
			</tr>
			<tr>
			 	<th>&nbsp;&nbsp; <font class="box_p">비고/통신란</font><br>&nbsp;&nbsp; "200자 내외 작성"</th>
				<td>
					<textarea id="memo" name="memo" class='box_l'></textarea>
				</td>
			</tr>	
		</table>
	</div>

	<div style="padding-top: 15px; text-align: right; width: 710px;">
  		<a href="javascript:saveEmpExtd();"><img src="/images/bt_save.gif" border="0" /></a>  
  		<a href="/reader/empExtd/empExtdList.do"><img src="/images/bt_back.gif" border="0" /></a>
  	</div>
</form>