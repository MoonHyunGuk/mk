<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<head>
<SCRIPT LANGUAGE="JavaScript" src="/js/mini_calendar.js"></SCRIPT>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/ajaxUtil.js" charset="UTF-8"></script>
<link rel='stylesheet' type='text/css' href='/css/mkcrm.css'>
<style>
#xlist {
	width: 100%;
	height: 190px;
	overflow-y: auto;
}
</style>
<script type="text/javascript">

	function searchMinwon(){
		if( $("tempSdate").value == '' ){
			alert('날짜를 선택해 주세요.');
			return;
		}
		if( $("tempEdate").value == '' ){
			alert('날짜를 선택해 주세요.');
			return;
		}
	
		var tempSdate =  $("tempSdate").value.split("-");
		var tempEdate =  $("tempEdate").value.split("-");
		$("sdate").value = tempSdate[0] + tempSdate[1] + tempSdate[2];
		$("edate").value = tempEdate[0] + tempEdate[1] + tempEdate[2];
		
		applyReaderForm.action="/reader/readerManage/retrieveApplyReader.do";
		applyReaderForm.target="_self";
		applyReaderForm.submit();
	}
	
	//신청자 정보 확인
	function detailView(index) {
		$("aplcNo").value = document.getElementById('tem_aplcNo'+index).innerHTML;
		$("aplcDt").value = document.getElementById('tem_aplcDt'+index).innerHTML;
		$("hjpsRemk").value = document.getElementById('tem_hjpsRemk'+index).innerHTML;
		$("seq").value = document.getElementById('tem_seq'+index).innerHTML;
		$("readNo").value = document.getElementById('tem_readNo'+index).innerHTML;
		$("boReadNo").value = document.getElementById('tem_boReadNo'+index).innerHTML;
		$("gnoNm").value = document.getElementById('tem_gno'+index).innerHTML;
		$("gno").value = document.getElementById('tem_gno'+index).innerHTML;
		$("bno").value = document.getElementById('tem_bno'+index).innerHTML;
		$("sno").value = document.getElementById('tem_sno'+index).innerHTML;
		$("readNm").value = document.getElementById('tem_readNm'+index).innerHTML;
		$("bidt").value = document.getElementById('tem_bidt'+index).innerHTML;
		$("homeTel1").value = document.getElementById('tem_homeTel1'+index).innerHTML;
		$("homeTel2").value = document.getElementById('tem_homeTel2'+index).innerHTML;
		$("homeTel3").value = document.getElementById('tem_homeTel3'+index).innerHTML;
		$("mobile1").value = document.getElementById('tem_mobile1'+index).innerHTML;
		$("mobile2").value = document.getElementById('tem_mobile2'+index).innerHTML;
		$("mobile3").value = document.getElementById('tem_mobile3'+index).innerHTML;
		$("eMail").value = document.getElementById('tem_eMail'+index).innerHTML;
		$("dlvZip").value = document.getElementById('tem_dlvZip'+index).innerHTML;
		$("dlvAdrs1").value = document.getElementById('tem_dlvAdrs1'+index).innerHTML;
		$("dlvAdrs2").value = document.getElementById('tem_dlvAdrs2'+index).innerHTML;
		$("rsdTypeCd").value = document.getElementById('tem_rsdTypeCd'+index).innerHTML;
		$("taskCd").value = document.getElementById('tem_taskCd'+index).innerHTML;
		$("intFldCd").value = document.getElementById('tem_intFldCd'+index).innerHTML;  
		$("newsCd").value = document.getElementById('tem_newsCd'+index).innerHTML;
		var hjDt = document.getElementById('tem_hjDt'+index).innerHTML;
		var aplcDt = document.getElementById('tem_aplcDt'+index).innerHTML;

		if(aplcDt != ''){
			$("hjDt2").value = aplcDt.substring(0,4) + "-" + aplcDt.substring(4,6) + "-" + aplcDt.substring(6,8);
		}
		if(hjDt != ''){
			$("hjDt").value = hjDt.substring(0,4) + "-" + hjDt.substring(4,6) + "-" + hjDt.substring(6,8);
		}
		
		$("readTypeCd").value = document.getElementById('tem_readTypeCd'+index).innerHTML;
		$("qty").value = document.getElementById('tem_qty'+index).innerHTML;
		$("uPrice").value = document.getElementById('tem_uPrice'+index).innerHTML;
		$("dlvTypeCd").value = document.getElementById('tem_dlvTypeCd'+index).innerHTML;
		$("spgCd").value = document.getElementById('tem_spgCd'+index).innerHTML;
		$("dlvPosiCd").value = document.getElementById('tem_dlvPosiCd'+index).innerHTML;
		$("sgType").value = document.getElementById('tem_sgType'+index).innerHTML;
		$("bnsBookCd").value = document.getElementById('tem_bnsBookCd'+index).innerHTML;
		$("remk").value = document.getElementById('tem_remk'+index).innerHTML;
		$("sgCycle").value = document.getElementById('tem_sgCycle'+index).innerHTML;
		if(document.getElementById('tem_sgBgmm'+index).innerHTML != ''){
			var sgBgmm = document.getElementById('tem_sgBgmm'+index).innerHTML;
			$("sgBgmm").value = sgBgmm.substring(0,4)+"-"+sgBgmm.substring(4,6);	
		}else{
			$("sgBgmm").value = '';
		}
		var hjPathCd = document.getElementById('tem_hjPathCd'+index).innerHTM;
		$("hjPathCd").value = document.getElementById('tem_hjPathCd'+index).innerHTML;
		$("hjPsnm").options[0] = new Option(document.getElementById('tem_hjPsnm'+index).innerHTML,document.getElementById('tem_hjPsnm'+index).innerHTML);
		$("hjPsregCd").options[0] = new Option(document.getElementById('tem_hjPsregCd'+index).innerHTML,document.getElementById('tem_hjPsregCd'+index).innerHTML);
	}
	//숫자만 입력 가능하도록 체크 키 다운시
	function inputNumCom(){
		var keycode = event.keyCode;
		 
		if ((event.keyCode<48) || (event.keyCode>57)){
			alert("숫자만 입력 가능합니다.");
			event.keyCode = 0;  // 이벤트 cancel
		}
	}
	
	// 신청경로 변경(확장자도 같이 변경해줘야함.)
	function changeHjPath(){
		if($("hjPathCd").value =='005' || $("hjPathCd").value =='006' || $("hjPathCd").value =='007'){
			$("boSeq").value = document.getElementById('tem_boSeq0').innerHTML;
			var url = "/reader/readerManage/ajaxHjPsNmList.do";
			sendAjaxRequest(url, "applyReaderForm", "post", hjPsNmList);
		}else{
			$("hjPsnm").options.length = 0;
			$("hjPsregCd").options.length = 0;
		}
		
	}
	function hjPsNmList(responseHttpObj) {
		if (responseHttpObj) {
			try {
				var result = eval("(" + responseHttpObj.responseText + ")");
				if (result) {
					setHjPsNmList(result);
				}
			} catch (e) {
				alert("오류 : " + e);
			}
		}
	}

	function setHjPsNmList(jsonObjArr) {
		$("hjPsnm").options.length = 0;
		$("hjPsregCd").options.length = 0;
		
		for( i=0 ; jsonObjArr.length > i ; i++){
			$("hjPsnm").options[i] = new Option(jsonObjArr[i].HJPSNM , jsonObjArr[i].HJPSNM );
		}
		for( i=0 ; jsonObjArr.length > i ; i++){
			$("hjPsregCd").options[i] = new Option(jsonObjArr[i].HJPSREGCD , jsonObjArr[i].HJPSREGCD );
		}
	}
	// 확장자 변경(확장자코드도 같이 변경해줘야함.)
	function sethjPregCd(){
		$("hjPsregCd").options[$("hjPsnm").selectedIndex].selected=true;
	}
	//우편주소 팝업
	function popAddr(){
		var left = (screen.width)?(screen.width - 1330)/2 : 10;
		var top = (screen.height)?(screen.height - 200)/2 : 10;
		var winStyle = "width=400,height=500,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		var newWin = window.open("", "pop_addr", winStyle);
		applyReaderForm.target = "pop_addr";
		applyReaderForm.action = "/reader/readerManage/popAddr.do?cmd=1";
		applyReaderForm.submit();
	}
	//우편주소팝업에서 우편주소 선택시 셋팅 펑션
	function setAddr(zip , addr){
		$("dlvZip").value = zip;
		$("dlvAdrs1").value = addr;
	}
	//독자정보 생성,수정
	function save(){
		if($("aplcNo").value == ''){
			alert('신규 생성할 독자를 선택해 주세요.');
			return;
		}
		
		// 취소처리가 아닌 경우에만 확인 (2013. 04. 24 박윤철)
		if($("boAcptStat").value != "03"){

			if($("gno").value == ''){
				alert('구역번호를 입력해 주세요.');
				$("gno").focus();
				return;
			}
			
			// 부수
			if($("qty").value == ''){
				alert('구독부수를 입력해 주세요.');
				$("qty").focus();
				return;
			}
			// 단가
			if($("uPrice").value == ''){
				alert('단가를 입력해 주세요.');
				$("uPrice").focus();
				return;
			}
			// 유가년월
			if($("sgBgmm").value == ''){
				alert('유가년월을 입력해 주세요.');
				$("sgBgmm").focus();
				return;
			}
			// 수금방법
			if($("sgType").value == ''){
				alert('수금방법을 선택해 주세요.');
				$("sgType").focus();
				return;
			}
			if($("newsCd").value == ''){
				alert('구독 신문을 선택해 주세요.');
				$("newsCd").focus();
				return;
			}
			if($("dlvZip").value == ''){
				alert('우편번호를 입력해 주세요.');
				$("dlvZip").focus();
				return;
			}
			if($("dlvAdrs2").value == ''){
				alert('상세주소를 입력해 주세요.');
				$("dlvAdrs2").focus();
				return;
			}
		}
		
		if($("boAcptStat").value == ''){
			alert('처리상태를 선택해 주세요.');
			$("boAcptStat").focus();
			return;
		}
		
		applyReaderForm.target="_self";
		applyReaderForm.action="/reader/readerManage/saveReader.do";
		applyReaderForm.submit();
		
		alert("등록 처리 되었습니다.");
		
		//window.opener.location ="/reader/readerManage/searchReader.do?searchType=4&searchText="+$("readNm").value ;
		window.opener.location ="/reader/readerManage/readerList.do" ;
		self.close();
	}
	
	window.attachEvent("onload", function(){detailView(0)});
</script>
</head>
<form id="applyReaderForm" name="applyReaderForm" action="" method="post">
	<input type="hidden" id="seq" name="seq" value="" />
	<input type="hidden" id="boSeq" name="boSeq" value="" />
	<input type="hidden" id="readNo" name="readNo" value="" />
	<input type="hidden" id="aplcNo" name="aplcNo" value="" />
	<input type="hidden" id="aplcDt" name="aplcDt" value="" />
	<input type="hidden" id="gbn" name="gbn" value="applyReader" />
	<input type=hidden id="sdate" name="sdate" value="" />
	<input type=hidden id="edate" name="edate" value="" />
	
	<table width="98%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td width="100%" valign="top">
			<p style="top-margin: 10px;">
				<table width="100%" cellpadding="1" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
					<tr bgcolor="ffffff">
						<td colspan="1" width="10%" align="center" bgcolor="f9f9f9">
							<font class="b02">신청일자</font>&nbsp;&nbsp;&nbsp;
						</td>
						<td bgcolor="ffffff" colspan="3" width="30%" align="center">
							<c:choose>
							<c:when test="${empty param.sdate && empty param.edate}">
								<input type="text" size="10" id="tempSdate" name="tempSdate" value="<c:out value='${sdate}' />" readonly onclick="Calendar(this)">&nbsp;&nbsp;&nbsp;~&nbsp;&nbsp;&nbsp;
								<input type="text" size="10" id="tempEdate" name="tempEdate" value="<c:out value='${edate}' />" readonly onclick="Calendar(this)">
							</c:when>
							<c:otherwise>
								<input type="text" size="10" id="tempSdate" name="tempSdate" value="<c:out value='${fn:substring(param.sdate,0,4)}-${fn:substring(param.sdate,4,6)}-${fn:substring(param.sdate,6,8)}' />" readonly onclick="Calendar(this)">&nbsp;&nbsp;&nbsp;~&nbsp;&nbsp;&nbsp;
								<input type="text" size="10" id="tempEdate" name="tempEdate" value="<c:out value='${fn:substring(param.edate,0,4)}-${fn:substring(param.edate,4,6)}-${fn:substring(param.edate,6,8)}' />" readonly onclick="Calendar(this)">
							</c:otherwise>
							</c:choose>
						</td>
						<td colspan="1" width="10%" align="center" bgcolor="f9f9f9">
							<font class="b02" >처리상태</font>
						</td>
						<td bgcolor="ffffff" colspan="2" width="20%" align="center">
							<select name="isCheck" id="isCheck" >
						      <option value="01" <c:if test="${param.isCheck eq '01'}"> selected </c:if>>확인</option>
						      <option value="02" <c:if test="${param.isCheck eq '02'}"> selected </c:if>>미확인</option>
						      <option value="03" <c:if test="${param.isCheck eq '03'}"> selected </c:if>>취소</option>
						    </select>
						</td>
						<td bgcolor="ffffff" colspan="1" width="10%" align="center">
							<a href="javascript:searchMinwon();"><img src="/images/bt_search.gif" border="0" align="absmiddle"></a>
						</td>
					</tr>
					<tr>
						<td colspan="8" rowspan="4" align="center" bgcolor="ffffff">
							<!--통합 내용출력자리-->
							<div id="xlist">
								<table width="100%" cellpadding="5" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
									<tr bgcolor="ffffff">
										<td align="center" width="5%"><font class="b02">순번</font></td>
										<td align="center" width="10%"><font class="b02">신청일자</font></td>
										<td align="center" width="15%"><font class="b02">독자명</font></td>
										<td align="center" width="10%"><font class="b02">확장자명</font></td>
										<td align="center" width="15%"><font class="b02">확장자휴대폰</font></td>
										<td align="center" width="35%"><font class="b02">확장자비고</font></td>
										<td align="center" width="10%"><font class="b02">처리상태</font></td>
									</tr>
									<c:forEach items="${ApplyReaderList }" varStatus="i" var="list">
										<span id="tem_readNo${i.index}" name="tem_readNo${i.index}" style="display:none">${list.READNO}</span><!--독자번호-->
										<span id="tem_aplcNo${i.index}" name="tem_aplcNo${i.index}" style="display:none">${list.APLCNO}</span><!--신청번호-->
										<span id="tem_aplcDt${i.index}" name="tem_aplcDt${i.index}" style="display:none">${list.APLCDT}</span><!--신청일자-->
										<span id="tem_newsCd${i.index}" name="tem_newsCd${i.index}" style="display:none">${list.NEWSCD}</span><!--신문코드-->
										<span id="tem_boSeq${i.index}" name="tem_boSeq${i.index}" style="display:none">${list.BOSEQ}</span><!--지국일련번호-->
										<span id="tem_boReadNo${i.index}" name="tem_boReadNo${i.index}" style="display:none">${list.BOREADNO}</span><!--지국독자번호-->
										<span id="tem_readTypeCd${i.index}" name="tem_readTypeCd${i.index}" style="display:none">${list.READTYPECD}</span><!--독자유형(일반학생기증투입강투)-->
										<span id="tem_readNm${i.index}" name="tem_readNm${i.index}" style="display:none"><c:out value="${list.READNM }"/></span><!--독자명-->
										<span id="tem_homeTel1${i.index}" name="tem_homeTel1${i.index}" style="display:none">${list.HOMETEL1}</span><!--전화번호1-->
										<span id="tem_homeTel2${i.index}" name="tem_homeTel2${i.index}" style="display:none">${list.HOMETEL2}</span><!--전화번호2-->
										<span id="tem_homeTel3${i.index}" name="tem_homeTel3${i.index}" style="display:none">${list.HOMETEL3}</span><!--전화번호3-->
										<span id="tem_mobile1${i.index}" name="tem_mobile1${i.index}" style="display:none">${list.MOBILE1}</span><!--휴대폰1-->
										<span id="tem_mobile2${i.index}" name="tem_mobile2${i.index}" style="display:none">${list.MOBILE2}</span><!--휴대폰2-->
										<span id="tem_mobile3${i.index}" name="tem_mobile3${i.index}" style="display:none">${list.MOBILE3}</span><!--휴대폰3-->
										<span id="tem_dlvZip${i.index}" name="tem_dlvZip${i.index}" style="display:none">${list.DLVZIP}</span><!--배달우편번호-->
										<span id="tem_dlvAdrs1${i.index}" name="tem_dlvAdrs1${i.index}" style="display:none">${list.DLVADRS1}</span><!--배달지주소1(우편주소)-->
										<span id="tem_dlvAdrs2${i.index}" name="tem_dlvAdrs2${i.index}" style="display:none">${list.DLVADRS2}</span><!--배달지주소2-->
										<span id="tem_dlvStrNm${i.index}" name="tem_dlvStrNm${i.index}" style="display:none">${list.DLVSTRNM}</span><!--배달거리명-->
										<span id="tem_dlvStrNo${i.index}" name="tem_dlvStrNo${i.index}" style="display:none">${list.DLVSTRNO}</span><!--배달거리번호-->
										<span id="tem_aptCd${i.index}" name="tem_aptCd${i.index}" style="display:none">${list.APTCD}</span><!--아파트코드-->
										<span id="tem_aptArea${i.index}" name="tem_aptArea${i.index}" style="display:none">${list.tem_APTAREA}</span><!--아파트평-->
										<span id="tem_aptDong${i.index}" name="tem_aptDong${i.index}" style="display:none">${list.APTDONG}</span><!--아파트동-->
										<span id="tem_aptHo${i.index}" name="tem_aptHo${i.index}" style="display:none">${list.APTHO}</span><!--아파트호-->
										<span id="tem_sgInfo${i.index}" name="tem_sgInfo${i.index}" style="display:none">${list.SGINFO}</span><!--수금지정보-->
										<span id="tem_sgTel1${i.index}" name="tem_sgTel1${i.index}" style="display:none">${list.SGTEL1}</span><!--수금자전화번호1-->
										<span id="tem_sgTel2${i.index}" name="tem_sgTel2${i.index}" style="display:none">${list.SGTEL2}</span><!--수금자전화번호2-->
										<span id="tem_sgTel3${i.index}" name="tem_sgTel3${i.index}" style="display:none">${list.SGTEL3}</span><!--수금자전화번호3-->
										<span id="tem_uPrice${i.index}" name="tem_uPrice${i.index}" style="display:none">${list.UPRICE}</span><!--단가-->
										<span id="tem_qty${i.index}" name="tem_qty${i.index}" style="display:none">${list.QTY}</span><!--부수-->
										<span id="tem_HJPS_HOMETEL1" name="tem_HJPS_HOMETEL1" style="display:none">${list.HOMETEL1}</span><!--확장자집전화1-->
										<span id="tem_HJPS_HOMETEL2" name="tem_HJPS_HOMETEL2" style="display:none">${list.HOMETEL2}</span><!--확장자집전화2-->
										<span id="tem_HJPS_HOMETEL3" name="tem_HJPS_HOMETEL3" style="display:none">${list.HOMETEL3}</span><!--확장자집전화3-->
										<span id="tem_HJPS_MOBILE1" name="tem_HJPS_MOBILE1" style="display:none">${list.MOBILE1}</span><!--확장자휴대폰1-->
										<span id="tem_HJPS_MOBILE2" name="tem_HJPS_MOBILE2" style="display:none">${list.MOBILE2}</span><!--확장자휴대폰2-->
										<span id="tem_HJPS_MOBILE3" name="tem_HJPS_MOBILE3" style="display:none">${list.MOBILE3}</span><!--확장자휴대폰3-->
										<span id="tem_BOACPTSTAT" name="tem_BOACPTSTAT" style="display:none">${list.BOACPTSTAT}</span><!--지국확인상태-->
										<span id="tem_BOACPTDT" name="tem_BOACPTDT" style="display:none">${list.BOACPTDT}</span><!--지국확인일자-->
										<span id="tem_DELYN" name="tem_DELYN" style="display:none">${list.DELYN}</span><!--삭제(취소)여부-->
										<span id="tem_bidt${i.index}" name="tem_bidt${i.index}" style="display:none">${list.BIDT}</span><!--생년월일-->
										<span id="tem_lusocLsfCd${i.index}" name="tem_lusocLsfCd${i.index}" style="display:none">${list.LUSOCLSFCD}</span><!--음양구분-->
										<span id="tem_offiNm${i.index}" name="tem_offiNm${i.index}" style="display:none">${list.OFFINM}</span><!--사무실명-->
										<span id="tem_eMail${i.index}" name="tem_eMail${i.index}" style="display:none">${list.EMAIL}</span><!--이메일-->
										<span id="tem_taskCd${i.index}" name="tem_taskCd${i.index}" style="display:none">${list.TASKCD}</span><!--직종코드-->
										<span id="tem_intFldCd${i.index}" name="tem_intFldCd${i.index}" style="display:none">${list.INTFLDCD}</span><!--관심코드-->
										<span id="tem_sgTypeCd${i.index}" name="tem_sgTypeCd${i.index}" style="display:none">${list.SGTYPECD}</span><!--관심코드-->
										<span id="tem_seq${i.index}" name="tem_seq${i.index}" style="display:none">${list.SEQ}</span><!--일련번호-->
										<span id="tem_gno${i.index}" name="tem_gno${i.index}" style="display:none">${list.GNO}</span><!--구역-->
										<span id="tem_bno${i.index}" name="tem_bno${i.index}" style="display:none">${list.BNO}</span><!--배달번호-->
										<span id="tem_sno${i.index}" name="tem_sno${i.index}" style="display:none">${list.SNO}</span><!--사이번호-->
										<span id="tem_sgType${i.index}" name="tem_sgType${i.index}" style="display:none">${list.SGTYPE}</span><!--수금방법-->
										<span id="tem_rsdTypeCd${i.index}" name="tem_rsdTypeCd${i.index}" style="display:none">${list.RSDTYPECD}</span><!--주거구분-->
										<span id="tem_dlvTypeCd${i.index}" name="tem_dlvTypeCd${i.index}" style="display:none">${list.DLVTYPECD}</span><!--배달유형(직배우송)-->
										<span id="tem_dlvPosiCd${i.index}" name="tem_dlvPosiCd${i.index}" style="display:none">${list.DLVPOSICD}</span><!--배달장소-->
										<span id="tem_hjPathCd${i.index}" name="tem_hjPathCd${i.index}" style="display:none">${list.HJPATHCD}</span><!--확장경로-->
										<span id="tem_hjTypeCd${i.index}" name="tem_hjTypeCd${i.index}" style="display:none">${list.HJTYPECD}</span><!--확장유형코드-->
										<span id="tem_hjPsregCd${i.index}" name="tem_hjPsregCd${i.index}" style="display:none">${list.HJPSREGCD}</span><!--확장자등록코드-->
										<span id="tem_hjPsnm${i.index}" name="tem_hjPsnm${i.index}" style="display:none">${list.HJPSNM}</span><!--확장자명-->
										<span id="tem_hjDt${i.index}" name="tem_hjDt${i.index}" style="display:none">${list.HJDT}</span><!--확장일자-->
										<span id="tem_sgBgmm${i.index}" name="tem_sgBgmm${i.index}" style="display:none">${list.SGBGMM}</span><!--수금시작월-->
										<span id="tem_sgEdmm${i.index}" name="tem_sgEdmm${i.index}" style="display:none">${list.SGEDMM}</span><!--수금종료월-->
										<span id="tem_sgCycle${i.index}" name="tem_sgCycle${i.index}" style="display:none">${list.SGCYCLE}</span><!--수금주기(1~12)-->
										<span id="tem_stdt${i.index}" name="tem_stdt${i.index}" style="display:none">${list.STDT}</span><!--중지일자-->
										<span id="tem_stSayou${i.index}" name="tem_stSayou${i.index}" style="display:none">${list.STSAYOU}</span><!--중지사유-->
										<span id="tem_remk${i.index}" name="tem_remk${i.index}" style="display:none">${list.REMK}</span><!--비고-->
										<span id="tem_hjpsRemk${i.index}" name="tem_hjpsRemk${i.index}" style="display:none">${list.HJPS_REMK}</span><!--확장자비고-->
										<span id="tem_inps${i.index}" name="tem_inps${i.index}" style="display:none">${list.INPS}</span><!--입력자-->
										<span id="tem_chgPs${i.index}" name="tem_chgPs${i.index}" style="display:none">${list.CHGPS}</span><!--변경자-->
										<span id="tem_spgCd${i.index}" name="tem_spgCd${i.index}" style="display:none">${list.SPGCD}</span><!--판촉물코드-->
										<span id="tem_bnsBookCd${i.index}" name="tem_bnsBookCd${i.index}" style="display:none">${list.BNSBOOKCD}</span><!--보너스북코드-->
									<tr bgcolor="ffffff" onclick="javascript:detailView('${i.index}')" style="cursor:hand;">
										<td height="3">${i.index}</td>
										<td height="3">${list.APLCDT }</td>
										<td height="3"><c:out value="${list.READNM }"/></td>
										<td height="3">${list.HJPSNM }</td>
										<c:choose>
										<c:when test="${not empty list.HJPS_MOBILE2 || not empty list.HJPS_MOBILE3}">
											<td height="3">${list.HJPS_MOBILE1 } - ${list.HJPS_MOBILE2 } - ${list.HJPS_MOBILE2 }</td>
										</c:when>
										<c:otherwise>
											<td></td>
										</c:otherwise>
										</c:choose>
										<td height="3">${list.HJPS_REMK }</td>
										<td height="3"><font class="b02"><font class="b03">${list.BOACPTNM }</font></td>
									</tr>
									</c:forEach>
								</table>
							</div>
						</td>
					</tr>
				</table>
		</td>
	</tr>
	<p style="margin-top: 10px;">
	<tr>
		<td>
			<p style="top-margin: 10px;">
			<table width="100%" cellpadding="1" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
				<tr bgcolor="ffffff">
					<td bgcolor="f9f9f9" width="12%" align="center"><font class="b02">확장자 비고 </font></td>
					<td>
						<textarea id="hjpsRemk" name="hjpsRemk" class='pop_box_l'></textarea>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	</table>
	<p style="margin-top: 10px;">
	
	<table width="98%" cellpadding="1" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
		<tr bgcolor="ffffff">
			<td bgcolor="f9f9f9" width="8%" align="center"><font class="b02">독자번호</font></td>
			<td width="20%">
				<input type="text" id="boReadNo" name="boReadNo" value="" style="text-align:right;padding-right:1px" class='box_n' readOnly />
			</td>
			<td  width="8%" bgcolor="f9f9f9" align="center"><font class="b02">구역명</font></td>
			<td width="17%"><input type="text" id="gnoNm" name="gnoNm" value="" style="text-align:right;padding-right:1px" class='box_n' readOnly/></td>
			<td  width="8%"bgcolor="f9f9f9" align="center"><b class="b03">*</b><font class="b02">구역배달</font></td>
			<td width="17%">
			<div align="center">
				<select id="gno" name="gno" style="width:60px">
					<c:forEach items="${guYukList }" var="list">
						<option value="${list.GU_NO }">${list.GU_NO }</option>
					</c:forEach>
				</select>  
				<input type="text" id="bno" name="bno" value="" style="width:50px" maxlength="3" style="ime-Mode:disabled" onKeyPress="inputNumCom();"/> 
				<input type="text" id="sno" name="sno" value="" style="width:30px" maxlength="2" style="ime-Mode:disabled" onKeyPress="inputNumCom();"/>
			</div>
			</td>
			<td  width="25%" bgcolor="f9f9f9" colspan="2" align="center"><font class="b02">독자비고</font></td>
		</tr>
		<tr bgcolor="ffffff">
			<td bgcolor="f9f9f9" align="center"><b class="b03">*</b><font class="b02">독 자 명</font></td>
			<td colspan="3"><input type="text" id="readNm" name="readNm" value="" class='box_n'/></td>
			<td bgcolor="f9f9f9" align="center"><font class="b02">생년월일</font></td>
			<td><input type="text" id="bidt" name="bidt" value="" class='box_n'  maxlength="8" style="ime-Mode:disabled" onKeyPress="inputNumCom();"/></td>
			<td colspan="2" rowspan="11"><textarea id="remk" name="remk" style="height:300px; width:100%;"></textarea></td>
		</tr>
		<tr bgcolor="ffffff">
			<td bgcolor="f9f9f9" align="center" ><font class="b02">전화번호</font></td>
			<td align="center" >
				<select id="homeTel1" name="homeTel1" class="box_50">
				<c:forEach items="${areaCode }" var="list" >
					<option value="${list.CODE }">${list.CODE }</option>
				</c:forEach> 
				</select> 
				<input type="text" id="homeTel2" name="homeTel2" value="" class='box_s5' maxlength="4" style="ime-Mode:disabled" onKeyPress="inputNumCom();"/>
				<input type="text" id="homeTel3" name="homeTel3" value="" class='box_s5' maxlength="4" style="ime-Mode:disabled" onKeyPress="inputNumCom();"/>
			</td>
			<td bgcolor="f9f9f9" align="center"><font class="b02">핸 드 폰</font></td>
			<td align="center">
				<select id="mobile1" name="mobile1" class="box_50"> 
				<c:forEach items="${mobileCode }" var="list">
					<option value="${list.CODE }">${list.CODE }</option>
				</c:forEach> 
				</select>  
				<input type="text" id="mobile2" name="mobile2" value="" class='box_s5' maxlength="4" style="ime-Mode:disabled" onKeyPress="inputNumCom();"/> 
				<input type="text" id="mobile3" name="mobile3" value="" class='box_s5' maxlength="4" style="ime-Mode:disabled" onKeyPress="inputNumCom();"/>
			</td>
			<td bgcolor="f9f9f9" align="center"><font class="b02">E-mail</font></td>
			<td><input type="text" id="eMail" name="eMail" value=""  class='box_n'/></td>
		</tr>
		<tr bgcolor="ffffff">
			<td bgcolor="f9f9f9" align="center"><b class="b03">*</b><font class="b02">우편번호</font></td>
			<td><input type="text" id="dlvZip" name="dlvZip" value=""  class='box_n3' maxlength="6" readOnly/>
				<input type="button" value="..." onClick="javascript:popAddr();"/>
			</td>
			<td colspan="4"><input type="text" id="dlvAdrs1" name="dlvAdrs1" value=""  class='box_n'/></td>
		</tr>
		<tr bgcolor="ffffff">
			<td bgcolor="f9f9f9" align="center"><b class="b03">*</b><font class="b02">상세주소</font></td>
			<td colspan="5"><input type="text" id="dlvAdrs2" name="dlvAdrs2" value=""  class='box_n'/></td>
		</tr>
		<tr bgcolor="ffffff">
			<td bgcolor="f9f9f9" align="center"><font class="b02">주거구분</font></td>
			<td>
				<select name="rsdTypeCd" id="rsdTypeCd" class='box_n'>
					<c:forEach items="${rsdTypeList }" var="list">
					<option value="${list.CODE }">${list.CNAME }</option>
					</c:forEach>
				</select>
			</td>
			<td bgcolor="f9f9f9" align="center"><font class="b02">직종</font></td>
			<td>
				<select name="taskCd" id="taskCd" class='box_n'>
					<c:forEach items="${taskList }" var="list">
					<option value="${list.CODE }">${list.CNAME }</option>
					</c:forEach>
				</select>
			</td>
			<td bgcolor="f9f9f9" align="center"><font class="b02">관심분야</font></td>
			<td>
				<select name="intFldCd" id="intFldCd" class='box_n'>
					<c:forEach items="${intFldList }" var="list">
					<option value="${list.CODE }">${list.CNAME }</option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr></tr>				
		<tr bgcolor="ffffff">
			<td bgcolor="f9f9f9" align="center"><b class="b03">*</b><font class="b02">신 문 명 </font></td>
			<td>
				<select name="newsCd" id="newsCd" class='box_n'>
					<c:forEach items="${newSList }" var="list">
					<option value="${list.CODE }">${list.CNAME }</option>
					</c:forEach>
				</select>
			</td>
			<td bgcolor="f9f9f9" align="center"><font class="b02">확장일자</font></td>
			<td><input type="text" id="hjDt" name="hjDt"  value="<c:out value='${sdate}' />" readonly onclick="Calendar(this)" class='box_n'/></td>
			<td bgcolor="f9f9f9" align="center"><font class="b02">독자유형</font></td>
			<td>
				<select name="readTypeCd" id="readTypeCd" class='box_n'>
					<c:forEach items="${readTypeList }" var="list">
					<option value="${list.CODE }">${list.CNAME }</option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr bgcolor="ffffff">
			<td bgcolor="f9f9f9" align="center"><b class="b03">*</b><font class="b02">구독부수</font></td>
			<td><input type="text" id="qty" name="qty" value="1" class='box_n'/>
			</td>
			<td bgcolor="f9f9f9" align="center"><b class="b03">*</b><font class="b02">유가년월</font></td>
			<td><input type="text" id="sgBgmm" name="sgBgmm" class='box_n' value="" maxlength="6" style="ime-Mode:disabled" onKeyPress="inputNumCom();" /></td>
			<td bgcolor="f9f9f9" align="center"><font class="b02">배달유형</font></td>
			<td>
				<select name="dlvTypeCd" id="dlvTypeCd" class='box_n'>
					<c:forEach items="${dlvTypeList }" var="list">
					<option value="${list.CODE }">${list.CNAME }</option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr bgcolor="ffffff">
			<td bgcolor="f9f9f9" align="center"><b class="b03">*</b><font class="b02">단&nbsp;&nbsp;&nbsp;&nbsp;가</font></td>
			<td><input type="text" id="uPrice" name="uPrice" class='box_n'/></td>
			<td bgcolor="f9f9f9" align="center"><font class="b02">신청경로</font></td>
			<td>
				<select name="hjPathCd" id="hjPathCd" class='box_n' onchange="javascript:changeHjPath()">
					<c:forEach items="${hjPathList }" var="list">
					<option value="${list.CODE }">${list.CNAME }</option>
					</c:forEach>
				</select>
			</td>
			<td bgcolor="f9f9f9" align="center"><font class="b02">배달장소</font></td>
			<td>
				<select name="dlvPosiCd" id="dlvPosiCd" class='box_n'>
					<c:forEach items="${dlvPosiCdList }" var="list">
					<option value="${list.CODE }">${list.CNAME }</option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr bgcolor="ffffff">
			<td bgcolor="f9f9f9" align="center"><b class="b03">*</b><font class="b02">수금방법</font></td>
			<td>
				<select name="sgType" id="sgType" class='box_s2'>
					<c:forEach items="${sgTypeList }" var="list">
					<option value="${list.CODE }">${list.CNAME }</option>
					</c:forEach> 
				</select>
				<input type="text" id="sgCycle" name="sgCycle" readonly class='box_s'/>
			</td>
			<td bgcolor="f9f9f9" align="center"><font class="b02">확 장 자</font></td>
			<td>
				<select name="hjPsnm" id="hjPsnm" class='box_n' onchange="javascript:sethjPregCd();" onclick="javascript:sethjPregCd();">
				</select>
				<div style="display:none">
					<select name="hjPsregCd" id="hjPsregCd" class='box_n' >
					</select>
				</div>
			</td>
			<td bgcolor="f9f9f9" align="center"><font class="b02">자 매 지 </font></td>
			<td>
				<select name="bnsBookCd" id="bnsBookCd" class='box_n'>
					<c:forEach items="${bnsBookList }" var="list" >
					<option value="${list.CODE }">${list.CNAME }</option>
					</c:forEach> 
				</select>
			</td>
		</tr>
		<tr bgcolor="ffffff">
			<td bgcolor="f9f9f9" align="center"><font class="b02">구독일자</font></td>
			<td><input type="text" id="hjDt2" name="hjDt2" value="<c:out value='${sdate}' />" readonly onclick="Calendar(this)" class='box_n'/></td>
			<td bgcolor="f9f9f9" align="center"><font class="b02">구독기간</font></td>
			<td><input type="text" id="term" name="term" value="" readonly/></td>
			<td bgcolor="f9f9f9" align="center"><font class="b02">판촉물</font></td>
			<td>
				<select name="spgCd" id="spgCd" class='box_n'>
					<c:forEach items="${SpgCdList }" var="list">
					<option value="${list.CODE }">${list.CNAME }</option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr bgcolor="ffffff">
			<td bgcolor="f9f9f9" align="right" colspan="4"><font class="b02">처리상태</font></td>
			<td bgcolor="f9f9f9" align="center" colspan="2">
				<select name="boAcptStat" id="boAcptStat" >
					<option value=""></option>
			      	<option value="01">확인</option>
			      	<option value="02">미확인</option>
			      	<option value="03">취소</option>
			    </select>
			</td>
			<td bgcolor="f9f9f9" align="center" colspan="2">
				<a href="javascript:save();"><img src="/images/bt_save.gif" border="0" align="absmiddle"></a>&nbsp;&nbsp;
					<a href="javascript:self.close()"><img src="/images/bt_cancle.gif" border="0" align="absmiddle"></a>
				</td>
		</tr>
	</table>

</form>
<script type="text/javascript">
 	 window.resizeTo(1000, 730);
</script>