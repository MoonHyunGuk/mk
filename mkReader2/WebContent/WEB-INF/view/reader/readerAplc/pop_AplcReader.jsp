<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>구독신청</title>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/js/jquery-ui-1.9.2.js"></script>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel='stylesheet' type='text/css' href="/select2/select2.css"/>
<link rel="stylesheet" type="text/css" href="/css/mkcrm.css">
<style>
#xlist {
	width: 100%;
	height: 190px;
	overflow-y: auto;
}
</style>
<script type="text/javascript">
//구독부수 조정시 단가 계산 펑션
function fn_controlPrice(qty){
	document.getElementById("uPrice").value = qty*15000;
}

// 신청경로 변경(확장자도 같이 변경해줘야함.)
function fn_changeHjPath(hjPathCd){
	if(hjPathCd =='005' || hjPathCd =='006' || hjPathCd =='007'){
		jQuery.ajax({
			type 		: "POST",
			url 		: "/reader/readerAplc/ajaxHjPsNmListForJquery.do",
			dataType 	: "json",
			data		: "hjPathCd="+hjPathCd,
			success:function(data){
				jQuery("#hjPsnm").empty();
				jQuery("#hjPsregCd").empty();
				for(var i=0;i<data.hjPsNmList.length;i++) {
					jQuery("#hjPsnm").append("<option value='"+data.hjPsNmList[i].HJPSNM+"'>"+data.hjPsNmList[i].HJPSNM+"</option>");
					jQuery("#hjPsregCd").append("<option value='"+data.hjPsNmList[i].HJPSREGCD+"'>"+data.hjPsNmList[i].HJPSREGCD+"</option>");
				}
			},
			error    : function(r) { alert("ajax error"); }
		}); //ajax end
		
	}else{
		jQuery("#hjPsnm").empty();
		jQuery("#hjPsregCd").empty();
	}
}

// 확장자 변경(확장자코드도 같이 변경해줘야함.)
function fn_sethjPregCd(){
	var selIdx=jQuery("#hjPsnm option").index(jQuery("#hjPsnm option:selected"));
	jQuery("#hjPsregCd option:eq("+selIdx+")").attr("selected", "selected");
}

//우편주소 팝업
function popAddr(){
	var fm = document.getElementById("apclReaderForm");
	
	var left = 0;
	var top = 30;
	var winStyle = "width=520,height=700,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
	var newWin = window.open("", "pop_addr", winStyle);
	newWin.focus();
	
	fm.target = "pop_addr";
	fm.action = "/common/common/popNewAddr.do";
	fm.submit();
}

//우편주소팝업에서 우편주소 선택시 셋팅 펑션
function setAddr(zip , addr, newAddr, bdNm, dbMngNo){
	var fm = document.getElementById("apclReaderForm");
	
	var dlvZip = document.getElementById("dlvZip");
	var allAddr = document.getElementById("allAddr");
	var dlvAdrs2 = document.getElementById("dlvAdrs2");
	var newaddr = document.getElementById("newaddr");
	newaddr.focus();
	
	dlvZip.value = zip.substring(0,3)+zip.substring(3,6);
	allAddr.value = newAddr+"("+addr+")";
	dlvAdrs2.value = bdNm;
	fm.newaddr.value = newAddr;
	fm.dlvAdrs1.value = addr;
	fm.bdMngNo.value = dbMngNo;
}
	
//신청정보 생성/수정시 VALIDATION
function validation(){
	
	// 부수
	if(!cf_checkNull("qty", "구독부수")){return false;};
	// 단가
	if(!cf_checkNull("uPrice", "단가")){return false;};
	// 수금방법
	if(!cf_checkNull("sgType", "수금방법")){return false;};
	// 구독 신문
	if(!cf_checkNull("newsCd", "구독 신문")){return false;};
	// 우편번호
	if(!cf_checkNull("dlvZip", "우편번호")){return false;};

	if(document.getElementById("hjpsRemk").value.length > 200){
		alert("비고란은 200바이트 이상 작성 하실 수 없습니다.");
		document.getElementById("hjpsRemk").focus();
		return;
	}

	document.getElementById("delYn").value = "";  // 취소여부 수정을 위한 구분자, validation시 초기화
	return true;
}
	
//신청정보 등록
function save(){
	var fm = document.getElementById("apclReaderForm");
	if(!validation()) return;
	
	if(confirm("신청 정보를 등록하시겠습니까? ")){
		fm.target="_self";
		fm.action="/reader/readerAplc/regAplc.do";
		fm.submit();
		//alert("정상적으로 등록하였습니다.");
		opener.fncAplcList();
		self.close();
	}
	
}
	
//신청정보 수정
function modify(){
	var fm = document.getElementById("apclReaderForm");
	if(!validation()) return;
	
	if(confirm("신청 정보를 수정하시겠습니까? ")){
		fm.target="_self";
		fm.action="/reader/readerAplc/modifyAplc.do";
		fm.submit();
		//alert("정상적으로 수정하였습니다.");
		opener.fncAplcList();
		self.close();
	}
}
	
//신청정보 수정
function modifyRemk(){
	var fm = document.getElementById("apclReaderForm");
	if(confirm("확장자 비고정보를 수정하시겠습니까? ")){
		fm.target="_self";
		fm.action="/reader/readerAplc/modifyHjRemk.do";
		fm.submit();
		//alert("정상적으로 수정하였습니다.");
		opener.fncAplcList();
		self.close();
	}
}

//신청정보 취소 및 재등록
function fn_delYn(delYn){
	var fm = document.getElementById("apclReaderForm");		
	if(!validation()) return;
	
	fm.delYn.value = delYn;			
	
	if(delYn == "Y"){
		if(confirm("신청 정보를 취소하시겠습니까? ")){
			fm.target="_self";
			fm.action="/reader/readerAplc/modifyAplc.do";
			fm.submit();
			//alert("취소 처리 되었습니다.");
			opener.fncAplcList();
			self.close();
		}
	}else{
		if(confirm("취소한 신청 정보를 복구하시겠습니까? ")){
			fm.target="_self";
			fm.action="/reader/readerAplc/modifyAplc.do";
			fm.submit();
			//alert("복구 처리 되었습니다.");
			opener.fncAplcList();
			self.close();
		}
	}		
}
	
/**
 * 지국선택시 hidden 값 설정
 */
function fn_jikukValSet(val) {
	var cutVals = val.split("^"); //지국명^지국코드^지국전화번호^지국핸드폰
	var fm = document.getElementById("apclReaderForm");
	
	fm.agName.value = cutVals[0];
	fm.boseq.value = cutVals[1];
	fm.tel.value = cutVals[2];
	fm.handy.value = cutVals[3];
}

jQuery.noConflict();
jQuery(document).ready(function($){
	//showCallLog(); 
	//$("#seljikuk").select2({minimumInputLength: 1});
});
</script>
</head>
<body>
<div class="box_Popup">
<div class="pop_title_box">본사신청독자 상세보기</div>
<form id="apclReaderForm" name="apclReaderForm" action="" method="post">
	<input type="hidden" id="aplcNo" name="aplcNo" value="${aplcNo}" />
	<input type="hidden" id="aplcDt" name="aplcDt" value="${aplcDt}" />
	<!-- 새주소관련 -->
	<input type="hidden" name="bdMngNo" id="bdMngNo" value="${AplcReader.BDMNGNO}" />
	<input type="hidden" name="dlvAdrs1" id="dlvAdrs1" value="${AplcReader.DLVADRS1}" />
	<input type="hidden" name="newaddr" id="newaddr" value="${AplcReader.NEWADDR}" />
	<!-- //새주소관련 -->
	<!-- hidden values -->
	<input type="hidden" id="delYn" name="delYn" value="" />
	<input type="hidden" id="inps" name="inps" value="${AplcReader.INPS}" />
	<input type="hidden" id="today" name="today" value="${TODAY}" />
	<!-- //hidden values -->
	
	<c:choose>
		<c:when test="${!empty AplcReader && boacptdt != null && AplcReader.BOACPTSTAT == '01' }"> <!-- 지국에서 확인하여 독자 등록이 완료된 신청건은 수정 불가 -->
			<div style="padding: 10px 0;">
			<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="e5e5e5" class="b_01">
				<tr><td bgcolor="f9f9f9" align="left"><font class="b02">▶ 독자정보</font></td></tr>
			</table>
			<table class="tb_view" style="width: 730px">
				<colgroup>
					<col width="80px">
					<col width="163px">
					<col width="80px">
					<col width="163px">
					<col width="80px">
					<col width="164px">
				</colgroup>
				<tr>
					<th><b class="b03">*</b>독 자 명</th>
					<td colspan="3"><input type="text" id="readNm" name="readNm" value="${AplcReader.READNM}" readonly /></td>
					<th>생년월일</th>
					<td><input type="text" id="bidt" name="bidt" value="${AplcReader.BIDT}" readonly /></td>
				</tr>
				<tr>
					<th>전화번호</th>
					<td>
						<select id="homeTel1" name="homeTel1" style="vertical-align: middle;">
							<c:forEach items="${areaCode }" var="list" >
								<c:if test="${list.CODE eq AplcReader.HOMETEL1}">
									<option value="${list.CODE }" selected>${list.CNAME }</option>
								</c:if>
							</c:forEach> 
						</select> 
						<input type="text" id="homeTel2" name="homeTel2" value="${AplcReader.HOMETEL2}" maxlength="4" style="ime-Mode:disabled; width: 45px; vertical-align: middle;" readonly />
						<input type="text" id="homeTel3" name="homeTel3" value="${AplcReader.HOMETEL3}" maxlength="4" style="ime-Mode:disabled; width: 45px; vertical-align: middle;" readonly />
					</td>
					<th>핸 드 폰</th>
					<td>
						<select id="mobile1" name="mobile1" style="vertical-align: middle;"> 
							<c:forEach items="${mobileCode }" var="list">
								<c:if test="${list.CODE eq AplcReader.MOBILE1}">
									<option value="${list.CODE }" selected>${list.CNAME }</option>
								</c:if>
							</c:forEach> 
						</select>  						
						<input type="text" id="mobile2" name="mobile2" value="${AplcReader.MOBILE2}" maxlength="4" style="ime-Mode:disabled; width: 45px; vertical-align: middle;" readonly /> 
						<input type="text" id="mobile3" name="mobile3" value="${AplcReader.MOBILE3}" maxlength="4" style="ime-Mode:disabled; width: 45px; vertical-align: middle;" readonly/>
					</td>
					<th>E-mail</th>
					<td><input type="text" id="eMail" name="eMail" value="${AplcReader.EMAIL}"  readonly /></td>
				</tr>
				<tr>
					<th>주소</th>
					<td colspan="5">
						<input type="text" id="dlvZip" name="dlvZip" value="${AplcReader.DLVZIP}" style="width: 70px"  maxlength="6" readonly/>&nbsp;
						<c:set var="addAddr" value=""/>
						<c:choose>
							<c:when test="${AplcReader.NEWADDR eq null}">
								<c:set var="addAddr" value="${AplcReader.DLVADRS1}"/>
							</c:when>
							<c:when test="${AplcReader.NEWADDR ne null}">
								<c:set var="addAddr" value="${AplcReader.NEWADDR}(${AplcReader.DLVADRS1})"/>
							</c:when>
						</c:choose>
				    	<input type="text" id="allAddr" name="allAddr" value="${addAddr}"  style="width: 535px; vertical-align: middle;" readonly/>
					</td>
				</tr>
				<tr>
					<th>상세주소</th>
					<td colspan="5"><input type="text" id="dlvAdrs2" name="dlvAdrs2" value="${AplcReader.DLVADRS2}"  style="width: 620px" readonly /></td>
				</tr>
				<tr>
					<th>담당지국 </th>
					<td>
						<input type="text" id="agName" name="agName" value="${AplcReader.JIKUK_NAME}" readonly style="width: 72px;" />
						<input type="text" id="boseq" name="boseq" value="${AplcReader.BOSEQ}"  readonly style="width: 72px;" />
					</td>
					<th>지국전화</th>
					<td><input type="text" id="tel" name="tel" value="${AplcReader.JIKUK_TEL}"  readonly /></td>
					<th>지국장HP</th>
					<td><input type="text" id="handy" name="handy" value="${AplcReader.JIKUK_HANDY}"  readonly /></td>
				</tr>
				<tr>
					<th>주거구분</th>
					<td>
						<select name="rsdTypeCd" id="rsdTypeCd">
							<c:forEach items="${rsdTypeList }" var="list">
								<c:if test="${list.CODE eq AplcReader.RSDTYPECD}">
									<option value="${list.CODE }" selected>${list.CNAME }</option>
								</c:if>
							</c:forEach>
						</select>
					</td>
					<th>직종</th>
					<td>
						<select name="taskCd" id="taskCd">
							<c:forEach items="${taskList }" var="list">
								<c:if test="${list.CODE eq AplcReader.TASKCD}">
									<option value="${list.CODE }" selected>${list.CNAME }</option>
								</c:if>
							</c:forEach>
						</select>
					</td>
					<th>관심분야</th>
					<td>
						<select name="intFldCd" id="intFldCd">
							<c:forEach items="${intFldList }" var="list">
								<c:if test="${list.CODE eq AplcReader.INTFLDCD}">
									<option value="${list.CODE }" selected>${list.CNAME }</option>
								</c:if>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
				</tr>
			</table>
			</div>
			<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="e5e5e5" class="b_01">
				<tr><td bgcolor="f9f9f9" align="left"><font class="b02">▶ 구독정보</font></td></tr>
			</table>
			<table class="tb_view" style="width: 730px">
				<colgroup>
					<col width="80px">
					<col width="163px">
					<col width="80px">
					<col width="163px">
					<col width="80px">
					<col width="164px">
				</colgroup>
				<tr>
					<th><b class="b03">*</b>신 문 명</th>
					<td>
						<select name="newsCd" id="newsCd">
							<c:forEach items="${newsList }" var="list">
								<c:if test="${list.CODE eq AplcReader.NEWSCD}">
									<option value="${list.CODE }" selected="selected">${list.CNAME }</option>
								</c:if>
							</c:forEach>
						</select>
					</td>
					<th><b class="b03">*</b>확장일자</th>
					<td><input type="text" id="hjDt" name="hjDt"  value="${AplcReader.HJDT}" style="width: 80px" readonly /></td>
					<th>독자유형</th>
					<td>
						<select name="readTypeCd" id="readTypeCd">
							<c:forEach items="${readTypeList }" var="list">
								<c:if test="${list.CODE eq AplcReader.READTYPECD}">
									<option value="${list.CODE }" selected>${list.CNAME }</option>
								</c:if>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th><b class="b03">*</b>구독부수</th>
					<td>			
						<c:choose>
							<c:when test="${empty AplcReader || AplcReader.QTY==null}">
								<input type="text" id="qty" name="qty"  value="1"  readonly style="ime-Mode:disabled; width: 30px" maxlength="3" />
							</c:when>
							<c:otherwise>			
				   				<input type="text" id="qty" name="qty" value="${AplcReader.QTY}" readonly style="ime-Mode:disabled; width: 30px;" maxlength="3" />
				   			</c:otherwise>
						</c:choose>
					</td>
					<th>유가년월</th>
					<td><input type="text" id="sgBgmm" name="sgBgmm" value="${AplcReader.SGBGMM}" maxlength="6" style="ime-Mode:disabled"  readonly /></td>
					<th>배달유형</th>
					<td>
						<select name="dlvTypeCd" id="dlvTypeCd">
							<c:forEach items="${dlvTypeList }" var="list">
								<c:if test="${list.CODE eq AplcReader.DLVTYPECD}">
									<option value="${list.CODE }" selected>${list.CNAME }</option>
								</c:if>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th>단&nbsp;&nbsp;&nbsp;&nbsp;가</th>
					<td><input type="text" id="uPrice" name="uPrice" value="${AplcReader.UPRICE}"  style="ime-Mode:disabled" readonly /></td>
					<th>신청경로</th>
					<td>
						<select name="hjPathCd" id="hjPathCd" onchange="fn_changeHjPath(this.value)">
							<c:forEach items="${hjPathList }" var="list">
								<c:if test="${list.CODE eq AplcReader.HJPATHCD}">
									<option value="${list.CODE }" selected>${list.CNAME }</option>
								</c:if>
							</c:forEach>
						</select>
					</td>
					<th>배달장소</th>
					<td>
						<select name="dlvPosiCd" id="dlvPosiCd">
							<c:forEach items="${dlvPosiCdList }" var="list">
								<c:if test="${list.CODE eq AplcReader.DLVPOSICD}">
									<option value="${list.CODE }" selected>${list.CNAME }</option>
								</c:if>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th><b class="b03">*</b>수금방법</th>
					<td>
						<select name="sgType" id="sgType">
							<c:forEach items="${sgTypeList }" var="list">
								<c:if test="${list.CODE eq AplcReader.SGTYPECD}">
									<option value="${list.CODE }" selected>${list.CNAME }</option>
								</c:if>
							</c:forEach> 
						</select>
					</td>
					<th>확 장 자</th>
					<td>
						<select name="hjPsnm" id="hjPsnm" onchange="fn_changeHjPath(this.value)">
								<option  value="${AplcReader.HJPSNM }" selected>${AplcReader.HJPSNM }</option>
						</select>
						<div style="display:none">
							<select name="hjPsregCd" id="hjPsregCd" >
								<option  value="${AplcReader.HJPSREGCD }" selected>${AplcReader.HJPSREGCD }</option>
							</select>
						</div>
					<td bgcolor="f9f9f9" align="center" colspan="2"></td>
				</tr>
				<tr>
					<th>비고</th>
					<td colspan="5">${AplcReader.REMK}</td>
				</tr>
			</table> 
			
			<div style="padding-top: 10px;">			
				<table class="tb_view" style="width: 730px">
					<colgroup>
						<col width="80px">
						<col width="650px">
					</colgroup>
					<tr>
						<th>확장자 비고 </th>
						<td>
							<textarea id="hjpsRemk" name="hjpsRemk" style="width: 95%; height: 40px">${AplcReader.REMK}</textarea>
						</td>
					</tr>
				</table>
				<div style="width: 730px; text-align: right; padding-top: 10px">
					<a href="javascript:modifyRemk();"><img src="/images/bt_modi.gif" border="0"  style="vertical-align: middle;" /></a>&nbsp;&nbsp;
					<a href="javascript:self.close()"><img src="/images/bt_close.gif" border="0" style="vertical-align: middle;" /></a>
				</div>
			</div>
		</c:when>
		<c:otherwise>			
		<!-- 신규신청건 / 기존 등록건에 대한 화면 -->
  			
			<br />
			<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="e5e5e5" class="b_01">
				<tr><td bgcolor="f9f9f9" align="left"><font class="b02">▶ 독자정보</font></td></tr>
			</table>
			<table class="tb_view" style="width: 730px">
				<colgroup>
					<col width="85px">
					<col width="158px">
					<col width="85px">
					<col width="158px">
					<col width="85px">
					<col width="159px">
				</colgroup>
				<tr>
					<th><b class="b03">*</b>독 자 명</th>
					<td colspan="3"><input type="text" id="readNm" name="readNm" value="${AplcReader.READNM}"/></td>
					<th>생년월일</th>
					<td><input type="text" id="bidt" name="bidt" value="${AplcReader.BIDT}" readonly onclick="Calendar(this)"/></td>
				</tr>
				<tr>
					<th>전화번호</th>
					<td>
						<select id="homeTel1" name="homeTel1" style="vertical-align: middle;">
						<c:forEach items="${areaCode }" var="list" >
							<option value="${list.CODE }" <c:if test="${list.CODE eq AplcReader.HOMETEL1}">selected</c:if>>${list.CODE }</option>
						</c:forEach> 
						</select> 
						<input type="text" id="homeTel2" name="homeTel2" value="${AplcReader.HOMETEL2}" maxlength="4" style="ime-Mode:disabled; width: 45px; vertical-align: middle;" onKeyPress="inputNumCom();"/>
						<input type="text" id="homeTel3" name="homeTel3" value="${AplcReader.HOMETEL3}" maxlength="4" style="ime-Mode:disabled; width: 45px; vertical-align: middle;" onKeyPress="inputNumCom();"/>
					</td>
					<th>핸 드 폰</th>
					<td>
						<select id="mobile1" name="mobile1" style="vertical-align: middle;"> 
						<c:forEach items="${mobileCode }" var="list">
							<option value="${list.CODE }" <c:if test="${list.CODE eq AplcReader.MOBILE1}">selected</c:if>>${list.CODE }</option>
						</c:forEach> 
						</select>  
						<input type="text" id="mobile2" name="mobile2" value="${AplcReader.MOBILE2}" maxlength="4" style="ime-Mode:disabled; width: 45px; vertical-align: middle;" onKeyPress="inputNumCom();"/> 
						<input type="text" id="mobile3" name="mobile3" value="${AplcReader.MOBILE3}" maxlength="4" style="ime-Mode:disabled; width: 45px; vertical-align: middle;" onKeyPress="inputNumCom();"/>
					</td>
					<th>E-mail</th>
					<td><input type="text" id="eMail" name="eMail" value="${AplcReader.EMAIL}" /></td>
				</tr>
				<tr>
					<th><b class="b03">*</b>주 소</th>
					<td colspan="5">
						<input type="text" id="dlvZip" name="dlvZip" value="${AplcReader.DLVZIP}"  maxlength="6" style="vertical-align: middle; width: 55px;" readonly="readonly"/>
						<a href="#fakeUrl" onclick="popAddr();"><img src="/images/ico_search2.gif" alt="우편번호찾기" style="vertical-align: middle;" /></a>&nbsp;
						<c:set var="addAddr" value=""/>
						<c:choose>
							<c:when test="${AplcReader.NEWADDR eq null}">
								<c:set var="addAddr" value="${AplcReader.DLVADRS1}"/>
							</c:when>
							<c:when test="${AplcReader.NEWADDR ne null}">
								<c:set var="addAddr" value="${AplcReader.NEWADDR}(${AplcReader.DLVADRS1})"/>
							</c:when>
						</c:choose>
				    	<input type="text" id="allAddr" name="allAddr" value="${addAddr}"  style="width: 535px; vertical-align: middle;" readonly/>
					</td>
				</tr>
				<tr>
					<th>상세주소</th>
					<td colspan="5"><input type="text" id="dlvAdrs2" name="dlvAdrs2" value="${AplcReader.DLVADRS2}" style="width: 624px" /></td>
				</tr>
				<tr>
					<th>담당지국 </th>
					<td>
						<select name="seljikuk" id="seljikuk" onchange="fn_jikukValSet(this.value);" class="custom-combobox">
							<option value=""></option>
							<c:forEach items="${agencyAllList }" var="list">
								<option value="${list.NAME}^${list.SERIAL}^${list.JIKUK_TEL}^${list.JIKUK_HANDY}" <c:if test="${AplcReader.BOSEQ eq list.SERIAL}">selected </c:if>>${list.NAME} </option>
							</c:forEach> 
						</select>
						<input type="hidden" id="agName" name="agName" value="${jikuk}" style="width: 72px;" />
						<input type="hidden" id="boseq" name="boseq" value="${AplcReader.BOSEQ}" style="width: 72px;"  />
					</td>
					<th>지국전화</th>
					<td><input type="text" id="tel" name="tel" value="${AplcReader.JIKUK_TEL}"  readonly /></td>
					<th>지국장HP</th>
					<td><input type="text" id="handy" name="handy" value="${AplcReader.JIKUK_HANDY}"  readonly /></td>
				</tr>
				<tr>
					<th>주거구분</th>
					<td>
						<select name="rsdTypeCd" id="rsdTypeCd">
								<option value="">- 선택 -</option>
							<c:forEach items="${rsdTypeList }" var="list">
								<option value="${list.CODE }" <c:if test="${list.CODE eq AplcReader.RSDTYPECD}">selected</c:if>>${list.CNAME }</option>
							</c:forEach>
						</select>
					</td>
					<th>직종</th>
					<td>
						<select name="taskCd" id="taskCd">
								<option value="">- 선택 -</option>
							<c:forEach items="${taskList }" var="list">
								<option value="${list.CODE }" <c:if test="${list.CODE eq AplcReader.TASKCD}">selected</c:if>>${list.CNAME }</option>
							</c:forEach>
						</select>
					</td>
					<th>관심분야</th>
					<td>
						<select name="intFldCd" id="intFldCd">
								<option value="">- 선택 -</option>
							<c:forEach items="${intFldList }" var="list">
								<option value="${list.CODE }" <c:if test="${list.CODE eq AplcReader.INTFLDCD}">selected</c:if>>${list.CNAME }</option>
							</c:forEach>
						</select>
					</td>
				</tr>
			</table>
			
			<p style="margin-top: 10px;">
			
			<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="e5e5e5" class="b_01">
				<tr><td bgcolor="f9f9f9" align="left"><font class="b02">▶ 구독정보</font></td></tr>
			</table>
			<table class="tb_view" style="width: 730px">
				<colgroup>
					<col width="80px">
					<col width="163px">
					<col width="80px">
					<col width="163px">
					<col width="80px">
					<col width="164px">
				</colgroup>
				<tr>
					<th><b class="b03">*</b>신 문 명 </th>
					<td>
						<select name="newsCd" id="newsCd">
							<c:forEach items="${newsList }" var="list">
								<option value="${list.CODE }" <c:if test="${list.CODE eq AplcReader.NEWSCD}">selected</c:if>>${list.CNAME }</option>
							</c:forEach>
						</select>
					</td>
					<th><b class="b03">*</b>확장일자</th>
					<td>
						<c:choose>
							<c:when test="${empty AplcReader || AplcReader.HJDT==null || AplcReader.HJDT=='--'}">
								<input type="text" id="hjDt" name="hjDt"  value="${TODAY}" readonly onclick="Calendar(this)"/>
							</c:when>
							<c:otherwise>			
				   				<input type="text" id="hjDt" name="hjDt"  value="${AplcReader.HJDT}" readonly onclick="Calendar(this)"/>
				   			</c:otherwise>
						</c:choose>
					</td>
					<th>독자유형</th>
					<td>
						<select name="readTypeCd" id="readTypeCd">
							<c:forEach items="${readTypeList }" var="list">
								<option value="${list.CODE }" <c:if test="${list.CODE eq AplcReader.READTYPECD}">selected</c:if>>${list.CNAME }</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th><b class="b03">*</b>구독부수</th>
					<td>			
						<c:choose>
							<c:when test="${empty AplcReader || AplcReader.QTY==null}">
								<input type="text" id="qty" name="qty"  value="1"  onkeyup="fn_controlPrice(this.value);" style="ime-Mode:disabled; width: 30px;" onkeypress="inputNumCom();" maxlength="3"/>
							</c:when>
							<c:otherwise>			
				   				<input type="text" id="qty" name="qty" value="${AplcReader.QTY}" onkeyup="fn_controlPrice(this.value);" style="ime-Mode:disabled; width: 30px;" onkeypress="inputNumCom();" maxlength="3"/>
				   			</c:otherwise>
						</c:choose>
					</td>
					<th>유가년월</th>
					<td><input type="text" id="sgBgmm" name="sgBgmm" value="${AplcReader.SGBGMM}" maxlength="6" style="ime-Mode:disabled" onkeypress="inputNumCom();" /></td>
					<th>배달유형</th>
					<td>
						<select name="dlvTypeCd" id="dlvTypeCd">
							<c:forEach items="${dlvTypeList }" var="list">
								<option value="${list.CODE }" <c:if test="${list.CODE eq AplcReader.DLVTYPECD}">selected</c:if>>${list.CNAME }</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th>단&nbsp;&nbsp;&nbsp;&nbsp;가</th>
					<td>			
						<c:choose>
							<c:when test="${empty AplcReader}">
								<input type="text" id="uPrice" name="uPrice"  value="15000"   style="ime-Mode:disabled" onkeypress="inputNumCom();"/>
							</c:when>
							<c:otherwise>			
				   				<input type="text" id="uPrice" name="uPrice" value="${AplcReader.UPRICE}"  style="ime-Mode:disabled" onkeypress="inputNumCom();"/>
				   			</c:otherwise>
						</c:choose>
					</td>
					<th>신청경로</th>
					<td>
						<select name="hjPathCd" id="hjPathCd" onchange="fn_changeHjPath(this.value)">
								<option value="">- 선택 -</option>
							<c:forEach items="${hjPathList }" var="list">
								<option value="${list.CODE }" <c:if test="${list.CODE eq AplcReader.HJPATHCD}">selected</c:if>>${list.CNAME }</option>
							</c:forEach>
						</select>
					</td>
					<th>배달장소</th>
					<td>
						<select name="dlvPosiCd" id="dlvPosiCd">
								<option value="">- 선택 -</option>
							<c:forEach items="${dlvPosiCdList }" var="list">
								<option value="${list.CODE }" <c:if test="${list.CODE eq AplcReader.DLVPOSICD}">selected</c:if>>${list.CNAME }</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th><b class="b03">*</b>수금방법</th>
					<td>
						<select name="sgType" id="sgType">
							<c:forEach items="${sgTypeList }" var="list">
							<option value="${list.CODE }" <c:if test="${list.CODE eq AplcReader.SGTYPECD}">selected</c:if>>${list.CNAME }</option>
							</c:forEach> 
						</select>
					</td>
					<th>확 장 자</th>
					<td colspan="3" >
						<select name="hjPsnm" id="hjPsnm" onchange="fn_sethjPregCd();" >
								<option  value="${AplcReader.HJPSNM }" selected>${AplcReader.HJPSNM }</option>
						</select>
						<div style="display:none">
							<select name="hjPsregCd" id="hjPsregCd" >
								<option  value="${AplcReader.HJPSREGCD }" selected>${AplcReader.HJPSREGCD }</option>
							</select>
						</div>
					</td>
				</tr>
				<tr>
					<th>비&nbsp;&nbsp;&nbsp;&nbsp;고</th>
					<td colspan="5">${AplcReader.REMK}</td>
				</tr>
			</table>
			<div style="padding-top: 10px;">			
				<table class="tb_view" style="width: 730px">
					<colgroup>
						<col width="80px">
						<col width="650px">
					</colgroup>
					<tr>
						<th>확장자 비고 </th>
						<td>
							<textarea id="hjpsRemk" name="hjpsRemk"  style="width: 95%; height: 60px;">${AplcReader.HJPS_REMK}</textarea>
						</td>
					</tr>
				</table>
			</div>
			<div style="width: 730px; text-align: right; padding-top: 10px;">
				<c:choose>
					<c:when test="${empty AplcReader}">   <!-- 신규 구독 신청건에대한 등록 버튼 활성화-->
							<a href="javascript:save();"><img src="/images/bt_eepl.gif" border="0" style="vertical-align: middle;" /></a>&nbsp;&nbsp;
							<a href="javascript:self.close()"><img src="/images/bt_close.gif" border="0" style="vertical-align: middle;" /></a>
					</c:when>
					<c:otherwise>			
							<a href="javascript:modify();"><img src="/images/bt_modi.gif" border="0" style="vertical-align: middle;" /></a>&nbsp;&nbsp;
							
							<c:choose>
								<c:when test="${AplcReader.DELYN == 'Y' }">		 <!-- 본사에서 취소한 신청내역일경우 복원(재등록) 버튼 활성화-->
									<a href="#fakeUrl" onclick="fn_delYn('N');"><img src="/images/bt_insert.gif" border="0" style="vertical-align: middle;" /></a>&nbsp;&nbsp;
								</c:when>
								<c:otherwise>													 <!-- 구독신청건에 대한 취소 버튼 활성화-->
									<a href="#fakeUrl" onclick="fn_delYn('Y');"><img src="/images/bt_cancle.gif" border="0" style="vertical-align: middle;" /></a>&nbsp;&nbsp;		
								</c:otherwise>
							</c:choose>
							
							<a href="javascript:self.close()"><img src="/images/bt_close.gif" border="0" style="vertical-align: middle;" /></a>
		   			</c:otherwise>
				</c:choose>
			</div>
  		</c:otherwise>
	</c:choose>
</form>
</div>
</body>
</html>
