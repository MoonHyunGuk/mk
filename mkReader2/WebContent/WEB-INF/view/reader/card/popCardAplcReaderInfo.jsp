<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>카드구독신청독자 상세정보</title>
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet">
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel='stylesheet' type='text/css' href="/select2/select2.css"/>
<script type="text/javascript">
/**
 * 우편주소 팝업
 */
function popAddr(){
	var fm = document.getElementById("aplcReaderInfoFm");
	
	var left = 0;
	var top = 10;
	var winStyle = "width=520,height=700,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
	newWin = window.open("", "pop_addr", winStyle);
	newWin.focus();
	
	fm.target = "pop_addr";
	fm.action = "/common/common/popNewAddr.do";
	fm.submit();
}

/**
 * 우편주소팝업에서 우편주소 선택시 셋팅 펑션 
 */
function setAddr(zip , addr, newAddr, bdNm, dbMngNo){
	var fm = document.getElementById("aplcReaderInfoFm");
	
	var zipNo = document.getElementById("zipNo");
	var addr2 = document.getElementById("addr2");
	
	zipNo.value = zip;
	$("#newaddr").empty();
	$("#newaddr").append(newAddr);
	$("#addrOld").empty();
	$("#addrOld").append(addr);
	addr2.value = bdNm;

	fm.bdMngNo.value = dbMngNo;
	fm.addrDoro.value = newAddr;
	fm.addr1.value = addr;
}

/**
 *	 팝업닫기
 **/
function fn_popClose() {
	window.close();
}


/**
 * 저장버튼 클릭이벤트
 */
function fn_save() {
	var fm = document.getElementById("aplcReaderInfoFm");
	var gubun = document.getElementById("gubunCode").value;
	var orgSgTypeCd = document.getElementById("orgSgTypeCd").value;
	var readNoVal = document.getElementById("readNo").value;
	
	 //독자번호가 입력되었는데 독자구분이 신규일때 기존으로 바꾸도록 
	if(readNoVal.length == 9) {
		if("0" == gubun) {
			alert("독자구분을 확인해주세요.");
			return false;
		}
	} 
		
	if("1" == gubun) { //기존 독자일때는 독자번호가 필수
		if(!cf_checkNull("readNo", "독자번호")) { return false; }
	
		//독자번호 입력안했을때
		if(cf_getValue("readNoChkYn") == "N") {
			alert("독자번호를 확인해주세요.");
			return false;
		}
	}
	if(!cf_checkNull("telNo", "전화번호")) { return false; }
	if(!cf_checkNull("rcvTelNo", "핸드폰번호")) { return false; }
	if(!cf_checkNull("orderCnt", "부수")) { return false; }
	if(!cf_checkNull("orderAmt", "금액")) { return false; }
	if(!cf_checkNull("addrDoro", "도로명주소")) { return false; }
	if(!cf_checkNull("addr1", "지번주소")) { return false; }
	if(!cf_checkNull("addr2", "상세주소")) { return false; }
	if(!cf_checkNull("codeNo", "카드사")) { return false; }
	if(!cf_checkNull("acctNo", "카드번호")) { return false; }
	if(!cf_checkNull("expireDate", "유효기간")) { return false; }
	if(!cf_checkNull("boseq", "지국명")) { return false; }
	
	if(cf_getValue("boseq") == '000000') {
		alert("지국을 선택해 주세요.");
		return false;
	}
	
	if(orgSgTypeCd == "021") {
		alert("이전 수금방법이 자동이체 독자이므로 자동이체는 해지가 됩니다.");
	}
	
	if(!confirm("저장하시겠습니까?")){return false;}
	
	fm.target = "_self";
	fm.action = "/reader/card/createCardReader.do";
	fm.submit();
	$("#prcssDiv").show();
	window.opener.fn_aplc_data_update();
}

/**
 * 해지버튼 클릭이벤트
 */
function fn_delete() {
	var fm = document.getElementById("aplcReaderInfoFm");
	
	if(!confirm("신청해지하시겠습니까?")){return false;}
	
	fm.target = "_parent";
	fm.action = "/reader/card/deleteCardAplcReader.do";
	fm.submit();
	$("#prcssDiv").show();
	window.opener.fn_aplc_data_update();
}

/**
 * 독자구분시 독자번호 추가 이벤트
 */
function fn_chk_readerType() {
	var fm = document.getElementById("aplcReaderInfoFm");
	var gubun = document.getElementById("gubunCode").value;
	var boseq = document.getElementById("boseq").value;
	
	if("0" == gubun && boseq.length < 4) { //신규일때
		$("#divReadno").hide();
	} else {
		$("#divReadno").show();
		if(boseq.length > 5 && boseq != "000000") {
			fm.readNoChkYn.value = "Y";
		} else {
			fm.readNoChkYn.value = "N";
		}
	}
}

/**
 * 본사신규등록여부
 */
function fn_chg_newYn() {
	var fm = document.getElementById("aplcReaderInfoFm");
	var newYnChk = document.getElementById("newYn").checked;
	
	if(newYnChk) { //체크되었을때(본사신규등록)
		fm.	newYn.value = "Y";
	} else {
		fm.	newYn.value = "N";
	}
	
}

/*
 * 독자 상세보기
 **/
function fn_searchReader(){
	 var fm = document.getElementById("aplcReaderInfoFm");
	 
	 if(cf_getValue("readNo").length < 9) {
		 alert("독자번호를 입력해주세요!");
		 return false;
	 }
	 
	var left = (screen.width)?(screen.width - 680)/2 : 10;
	var top = (screen.height)?(screen.height - 820)/2 : 10;
	var winStyle = "width=680,height=820,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=0";
	newWin = window.open("", "detailReaderInfo", winStyle);
	newWin.focus();
	
	fm.target = "detailReaderInfo"; 
	fm.action = "/reader/card/popReaderInfos.do?readno="+cf_getValue("readNo");
	fm.submit();
}

jQuery(document).ready(function($){
	$("#prcssDiv").hide();
	$("#boseq").select2({minimumInputLength: 1});
	fn_chk_readerType();	
});
</script>
</head>
<body>
<form method="post" name="aplcReaderInfoFm" id="aplcReaderInfoFm">
	<input type="hidden" name="addrDoro" id="addrDoro" value="${aplcReaderInfo.ADDRDORO }" />
	<input type="hidden" name="addr1" id="addr1" value="${aplcReaderInfo.ADDR1 }" />
	<input type="hidden" name="userName" id="userName" value="${aplcReaderInfo.USERNAME }" />
	<input type="hidden" name="userNo" id="userNo" value="${aplcReaderInfo.USERNO }" />
	<input type="hidden" name="seqNo" id="seqNo" value="${aplcReaderInfo.SEQNO }" />
	<input type="hidden" name="userId" id="userId" value="${aplcReaderInfo.USERID }" />
	<input type="hidden" name="email" id="email" value="${aplcReaderInfo.EMAIL }" />
	<input type="hidden" name="bdMngNo" id="bdMngNo" value="${aplcReaderInfo.BDMNGNO }" />
	<input type="hidden" name="insDate" id="insDate" value="${aplcReaderInfo.INSDATE }" />
	<input type="hidden" name="joinYn" id="joinYn" value="${aplcReaderInfo.JOIN_YN }" />
	<input type="hidden" name="telNo" id="telNo" value="${aplcReaderInfo.TELNO }" />
	<input type="hidden" name="bigo" id="bigo"  value="${aplcReaderInfo.BIGO }" />
	<!-- 기존독자 팝업 선택값 -->
	<input type="hidden" name="newsCd" id="newsCd"  value="" />
	<input type="hidden" name="seq" id="seq"  value="" />
	<input type="hidden" name="orgSgTypeCd" id="orgSgTypeCd"  value="" />
	<input type="hidden" name="readTypeCd" id="readTypeCd" value="" />
	<input type="hidden" name="orgboSeq" id="orgboSeq" value="" />
	<input type="hidden" name="readNoChkYn" id="readNoChkYn"  value="N" />
	<!-- //기존독자 팝업 선택값 -->
	
	<div class="box_Popup" style="width: 610px;">
		<!-- title -->
		<div class="pop_title_box">카드구독독자 신청관리</div>
		<div style="width: 610px; padding-top: 15px;">
			<table class="tb_search" style="width: 610px">
				<colgroup>
					<col width="100px">
					<col width="205px">
					<col width="100px">
					<col width="205px">
				</colgroup>
				<tr>
				 	<th>독자구분</th>
					<td>
						<select name="gubunCode" id="gubunCode" style="vertical-align: middle; width: 60px" onchange="fn_chk_readerType();">
							<option value="0" <c:if test="${aplcReaderInfo.GUBUNCODE eq '0'}">selected="selected"</c:if>>신규</option>
							<option value="1" <c:if test="${aplcReaderInfo.GUBUNCODE eq '1'}">selected="selected"</c:if>>기존</option>
						</select>
					</td>
				 	<th>결합구분</th>
					<td>
						<c:choose>
							<c:when test="${aplcReaderInfo.JOIN_YN eq 'Y'}">결합</c:when>
							<c:otherwise>일반</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr> 
				 	<th>독 자 명</th>
					<td colspan="3">${aplcReaderInfo.USERNAME }&nbsp;<b>(${aplcReaderInfo.USERID})</b></td>
				</tr>
				<tr id="divReadno"> 
				 	<th><b class="b03">*</b> 독자번호</th>
					<td colspan="3">
						<input type="text" id="readNo" name="readNo" value="${aplcReaderInfo.READNO }" style="width: 80px; vertical-align: middle;" maxlength="9" />
						<img alt="독자찾기" src="/images/ico_search2.gif" onclick="fn_searchReader()" style="cursor: pointer; vertical-align: middle;"> 
					</td>
				</tr>
				<tr>
					<th><b class="b03">*</b> 핸드폰번호</th>
					<td><input type="text" name="rcvTelNo" id="rcvTelNo"  value="${aplcReaderInfo.RCVTELNO }"  maxlength="13" style="width: 110px" /></td>
				 	<th><b class="b03">*</b> 전화번호</th>
					<td><input type="text" name="telNo" id="telNo"  value="${aplcReaderInfo.TELNO }"  maxlength="13" style="width: 110px" /></td>
				</tr> 
				<tr>
				 	<th><b class="b03">*</b> 부&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;수</th>
					<td><input type="text" name="orderCnt" id="orderCnt"  value="${aplcReaderInfo.ORDERCNT }" maxlength="3" style="width: 25px"/></td>
				 	<th><b class="b03">*</b> 금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</th>
					<td><input type="text" name="orderAmt" id="orderAmt"  value="${aplcReaderInfo.ORDERAMT }" maxlength="7"  style="width: 100px" /></td>
				</tr>
				<tr>
				 	<th><b class="b03">*</b> 지번주소</th>
					<td colspan="3">
						<input type="text" name="zipNo" id="zipNo"  value="${aplcReaderInfo.ZIPNO }" style="width: 50px; vertical-align: middle;" maxlength="6"  readonly="readonly"/>&nbsp;
						<a href="#fakeUrl" onclick="popAddr();"><img alt="우편번호찾기" src="/images/ico_search2.gif" style="border: 0; vertical-align: middle;" /></a>&nbsp;&nbsp;&nbsp;&nbsp;
						<span id="addrOld" >${aplcReaderInfo.ADDR1 }</span>
					</td>
				</tr>
				<tr>
				 	<th><b class="b03">*</b> 도로명주소</th>
					<td colspan="3"><span id="newaddr" >${aplcReaderInfo.ADDRDORO }</span></td>
				</tr>
				<tr>
				 	<th><b class="b03">*</b> 상세주소</th>
					<td colspan="3"><input type="text" name="addr2" id="addr2"  value="${aplcReaderInfo.ADDR2 }" style="width: 450px" /></td>
				</tr>
				<tr>
				 	<th>비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</th>
					<td colspan="3">
						<c:choose>
							<c:when test="${aplcReaderInfo.USESTATE eq '0'}">
								<textarea name="remk" id="remk" rows="5" cols="54" style="width: 450px">${aplcReaderInfo.BIGO }</textarea>
							</c:when>
							<c:otherwise>
								<div style="width: 450px">${aplcReaderInfo.BIGO }</div>
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
				 	<th><b class="b03">*</b> 카드사</th>
					<td colspan="3">
						<select name="codeNo" id="codeNo" style="vertical-align: middle;  width: 100px;">
							<option value="">선택</option>
							<option value="00" <c:if test="${aplcReaderInfo.CODENO eq '00'}">selected="selected"</c:if>>숨김</option>
							<c:forEach items="${cardCorpList}" var="cardlist">
								<option value="${cardlist.CODE }" <c:if test="${aplcReaderInfo.CODENO eq cardlist.CODE}">selected="selected"</c:if>>${cardlist.CNAME } </option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
				 	<th><b class="b03">*</b> 카드번호</th>
					<td><input type="text" name="acctNo" id="acctNo"  value="${aplcReaderInfo.ACCTNO }" /></td>
				 	<th><b class="b03">*</b> 유효기간</th>
					<td><input type="text" name="expireDate" id="expireDate"  value="${aplcReaderInfo.EXPIREDATE }" maxlength="6" style="width: 55px" />&nbsp;&nbsp;<span style="color:red">ex)&nbsp;15년 7월&nbsp;&gt;&nbsp;201507</span></td>
				</tr>
				<tr>
				 	<th>신청일</th>
					<td>${aplcReaderInfo.INSDATE }</td>
				 	<th>해지일</th>
					<td>
						<c:if test="${aplcReaderInfo.USESTATE eq '0'}">
							<span class="btnCss2"><a class="lk2" onclick="fn_delete();" style="color: red; font-weight: bold;">해지</a></span>
						</c:if>
						<c:if test="${aplcReaderInfo.CANCELDATE ne null}">
							${aplcReaderInfo.CANCELDATE }&nbsp;[${aplcReaderInfo.CANCELID }]
						</c:if>
					</td>
				</tr>
				<tr>
				 	<th><b class="b03">*</b> 지국명</th> 
					<td colspan="3">
						<select name="boseq" id="boseq" style="vertical-align: middle;  width: 100px;">
							<option value="">선택</option>
							<c:forEach items="${agencyList }" var="list">
								<option value="${list.SERIAL }" <c:if test="${aplcReaderInfo.OFFICECODE eq list.SERIAL}">selected="selected"</c:if>>${list.NAME } </option>
							</c:forEach>
						</select>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="checkbox" name="newYn" id="newYn"  value="N"  style="vertical-align: middle;" onchange="fn_chg_newYn();" />&nbsp;&nbsp;<span style="vertical-align: middle;">본사신규등록</span> 
					</td>
				</tr>
			</table>  	
		</div>
		<!-- button -->
		<div style="width: 610px; text-align: right; padding-top: 10px;">
			<c:if test="${aplcReaderInfo.OFFICECODE eq '000000'}">
  				<span class="btnCss2" ><a class="lk2" onclick="fn_save();" style="color: blue; font-weight: bold;">저장</a></span>
  			</c:if>
  			<span class="btnCss2"><a class="lk2" onclick="fn_popClose();">닫기</a></span>
		</div>
		<!-- //button -->
	</div>
</form>
<!-- processing viewer -->
<div id="prcssDiv"  class="loingProcessDiv"><div><img src="/images/process4.gif"/></div></div>
<!-- //processing viewer --> 
</body>
</html>
