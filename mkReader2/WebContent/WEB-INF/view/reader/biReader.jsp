<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="com.mkreader.security.ISiteConstant" %>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/js/ajaxUtil.js" charset="UTF-8"></script>
<script type="text/javascript">
/*----------------------------------------------------------------------
 * Desc   : 조건별 리스트를 조회한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncBiReaderList(){
	 var frm = document.getElementById("frmList");
	 
	 frm.pageNo.value = "1";
	 frm.target = "_self";
	 frm.action = "/reader/biReader/biReaderList.do";
	 frm.submit();
}

/*----------------------------------------------------------------------
 * Desc   : 조건별 리스트를 엑셀로 출력한다.
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncBiReaderExcelList(){
	 var frm = document.getElementById("frmList");
	 
	 frm.target = "_self";
	 frm.action = "/reader/biReader/excelBiReaderList.do";
	 frm.submit();
}

/*----------------------------------------------------------------------
 * Desc   : 조건별 리스트를 OZ를 통해 라벨 인쇄한다.
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function ozPrint() {
	 var frm = document.getElementById("frmList");
	 
	actUrl = "/reader/biReader/ozBiReaderList.do";
	window.open('','ozBiReaderList','width=1000, height=800, toolbar=no, menubar=no, location=no, status=no, resizable=1, scrollbars=no');

	frm.target = "ozBiReaderList";
	frm.action = actUrl;
	frm.submit();
}


/*----------------------------------------------------------------------
 * Desc   : 조회범위에서 엔터키 누를경우 조건별 리스트를 조회한다.
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncKeySearch() {
	
	if ( event.keyCode == 13 ) {
		fncBiReaderList();
	}
}

/*----------------------------------------------------------------------
 * Desc   : 비독자 입력 영역의 내용을 초기화한다.
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncCancel() {
	jQuery("#APLCDT").val(jQuery("#TODAY").val());
	jQuery("#APLCNO").val("");
	jQuery("#BI_GROUP2").empty();
	jQuery("#BI_GROUP3").empty();
	jQuery("#BI_GROUP2").append("<option value=''>선택</option>");
	jQuery("#BI_GROUP3").append("<option value=''>선택</option>");
	jQuery("#BI_READNM").val("");
	jQuery("#OFFZIP").val("");
	jQuery("#OFFADRS1").val("");
	jQuery("#OFFADRS2").val("");
	jQuery("#OFFDUTY").val("");
	jQuery("#OFFDEPT").val("");
	jQuery("#OFFTEL1").val("");
	jQuery("#OFFTEL2").val("");
	jQuery("#OFFTEL3").val("");
	jQuery("#OFFFAX1").val("");
	jQuery("#OFFFAX2").val("");
	jQuery("#OFFFAX3").val("");
	jQuery("#MOBILE1").val("");
	jQuery("#MOBILE2").val("");
	jQuery("#MOBILE3").val("");
	jQuery("#EMAIL").val("");
	jQuery("#HOMEZIP").val("");
	jQuery("#HOMEADRS1").val("");
	jQuery("#HOMEADRS2").val("");
	jQuery("#HOMETEL1").val("");
	jQuery("#HOMETEL2").val("");
	jQuery("#HOMETEL3").val("");
	jQuery("#ORGAN").val("");
	jQuery("#GUBUN").val("");
	jQuery("#REMK").val("");
	 /*
	 $("BI_GROUP2").options.length = 0;
	 $("BI_GROUP3").options.length = 0;
	 $("BI_GROUP2").options[0] = new Option("선택" , "");
	 $("BI_GROUP3").options[0] = new Option("선택" , "");
	 $("BI_GROUP1").value = "";
	 $("BI_GROUP2").value = "";
	 $("BI_GROUP3").value = "";
	 $("BI_READNM").value = "";
	 $("APLCDT").value = $("TODAY").value;
	 $("APLCNO").value = "";
	 $("OFFZIP").value = "";
	 $("OFFADRS1").value = "";
	 $("OFFADRS2").value = "";
	 $("OFFTEL1").value = "";
	 $("OFFTEL2").value = "";
	 $("OFFTEL3").value = "";
	 $("MOBILE1").value = "";
	 $("MOBILE2").value = "";
	 $("MOBILE3").value = "";
	 $("ORGAN").value = "";
	 $("OFFDEPT").value = "";
	 $("OFFDUTY").value = "";
	 $("OFFFAX1").value = "";
	 $("OFFFAX2").value = "";
	 $("OFFFAX3").value = "";
	 $("EMAIL").value = "";
	 $("GUBUN").value = "";
	 $("HOMEZIP").value = "";
	 $("HOMEADRS1").value = "";
	 $("HOMEADRS2").value = "";
	 $("HOMETEL1").value = "";
	 $("HOMETEL2").value = "";
	 $("HOMETEL3").value = "";
	 $("REMK").value = "";
	 */
	 var smgudok = document.getElementsByName('SMGUDOK');
	 smgudok[0].checked = true;
	 
	 //1차 그룹 코드 가져오기
	 fn_select_group1();
}


/*----------------------------------------------------------------------
 * Desc   : 비독자 상세정보를 조회한다.
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fn_detailView(APLCDT, APLCNO) {
	 var frm = document.getElementById("frmList");

	frmList.controll.checked = false;
	document.all.Etable.style.display='none';
	document.all.Etable2.style.display='inline';
	 
	 jQuery.ajax({
		type 		: "POST",
		url 		: "/reader/biReader/selectBiReaderDataView.do",
		dataType 	: "json",
		data		: "APLCDT="+APLCDT+"&APLCNO="+APLCNO,
		success:function(result){
			jQuery("#APLCDT").val(result.biReaderData[0].APLCDT);
			jQuery("#APLCNO").val(result.biReaderData[0].APLCNO);
			jQuery("#BI_GROUP1").empty();
			jQuery("#BI_GROUP2").empty();
			jQuery("#BI_GROUP3").empty();
			jQuery("#BI_GROUP1").append("<option value='"+result.biReaderData[0].BI_GROUP1+"'>"+result.biReaderData[0].BI_GROUP_NM1+"</option>");
			jQuery("#BI_GROUP2").append("<option value='"+result.biReaderData[0].BI_GROUP2+"'>"+result.biReaderData[0].BI_GROUP_NM2+"</option>");
			jQuery("#BI_GROUP3").append("<option value='"+result.biReaderData[0].BI_GROUP3+"'>"+result.biReaderData[0].BI_GROUP_NM3+"</option>");
			jQuery("#BI_READNM").val(result.biReaderData[0].BI_READNM);
			jQuery("#OFFZIP").val(result.biReaderData[0].OFFZIP);
			jQuery("#OFFADRS1").val(result.biReaderData[0].OFFADRS1);
			jQuery("#OFFADRS2").val(result.biReaderData[0].OFFADRS2);
			jQuery("#OFFDUTY").val(result.biReaderData[0].OFFDUTY);
			jQuery("#OFFDEPT").val(result.biReaderData[0].OFFDEPT);
			jQuery("#OFFTEL1").val(result.biReaderData[0].OFFTEL1);
			jQuery("#OFFTEL2").val(result.biReaderData[0].OFFTEL2);
			jQuery("#OFFTEL3").val(result.biReaderData[0].OFFTEL3);
			jQuery("#OFFFAX1").val(result.biReaderData[0].OFFFAX1);
			jQuery("#OFFFAX2").val(result.biReaderData[0].OFFFAX2);
			jQuery("#OFFFAX3").val(result.biReaderData[0].OFFFAX3);
			jQuery("#MOBILE1").val(result.biReaderData[0].MOBILE1);
			jQuery("#MOBILE2").val(result.biReaderData[0].MOBILE2);
			jQuery("#MOBILE3").val(result.biReaderData[0].MOBILE3);
			jQuery("#EMAIL").val(result.biReaderData[0].EMAIL);
			jQuery("#HOMEZIP").val(result.biReaderData[0].HOMEZIP);
			jQuery("#HOMEADRS1").val(result.biReaderData[0].HOMEADRS1);
			jQuery("#HOMEADRS2").val(result.biReaderData[0].HOMEADRS2);
			jQuery("#HOMETEL1").val(result.biReaderData[0].HOMETEL1);
			jQuery("#HOMETEL2").val(result.biReaderData[0].HOMETEL2);
			jQuery("#HOMETEL3").val(result.biReaderData[0].HOMETEL3);
			jQuery("#ORGAN").val(result.biReaderData[0].ORGAN);
			jQuery("#GUBUN").val(result.biReaderData[0].GUBUN);
			jQuery("#REMK").val(result.biReaderData[0].REMK);

			if(result.biReaderData[0].SMGUDOK == 'N'){
				document.getElementsByName('SMGUDOK')[0].checked = true;
			}else{
				document.getElementsByName('SMGUDOK')[1].checked = true;
			}
		},
		error    : function(r) { alert("error"); }
	}); //ajax end
	
}


/*----------------------------------------------------------------------
 * Desc   : 상세정보를 조회한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncAplcInfo(aplcdt, aplcno,boacptdt){
	 
	 actUrl = "/reader/readerAplc/popAplcReader.do";
	
     window.open('','pop_AplcReader','width=750, height=435, toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=0');

	 frmList.aplcdt.value = aplcdt;
	 frmList.aplcno.value = aplcno;
	 frmList.boacptdt.value = boacptdt;
     
     frmList.target = "pop_AplcReader";
     frmList.action = actUrl;
     frmList.submit();
}


/*----------------------------------------------------------------------
 * Desc   : 페이징 펑션
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function moveTo(where, seq) {
	var frm = document.getElementById("frmList");
		
	frm.pageNo.value = seq;
	frm.target="_self";
	frm.action = "/reader/biReader/biReaderList.do";
	frm.submit();
}


/**
 * 1그룹코드 가져오기
 */
function fn_select_group1() {
	jQuery("#BI_GROUP1").empty();
	jQuery("#BI_GROUP1").append("<option value=''>선택</option>");
	jQuery.ajax({
		type 		: "POST",
		url 		: "/reader/biReader/selectBiGroup1List.do",
		dataType 	: "json",
		success:function(result){
			jQuery.each(result.SECD6, function(i) { 
				jQuery("#BI_GROUP1").append("<option value='"+result.SECD6[i].CODE+"'>"+result.SECD6[i].CNAME+"</option>");
			});
		},
		error    : function(r) { alert("error"); }
	}); //ajax end
}



/*----------------------------------------------------------------------
 * Desc   : 1그룹코드 변경시 2그룹 리스트 생성
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function chg_group2(val){
	jQuery("#BI_GROUP2").empty();
	jQuery("#BI_GROUP3").empty();
	jQuery("#BI_GROUP2").append("<option value=''>선택</option>");
	jQuery("#BI_GROUP3").append("<option value=''>선택</option>");
	jQuery.ajax({
		type 		: "POST",
		url 		: "/reader/biReader/ajaxBiGroupListByJson.do",
		dataType 	: "json",
		data		: "cdclsf="+val,
		success:function(result){
			jQuery.each(result.biGroupList, function(i) { 
				jQuery("#BI_GROUP2").append("<option value='"+result.biGroupList[i].CODE+"'>"+result.biGroupList[i].CNAME+"</option>");
			});
		},
		error    : function(r) { alert("error"); }
	}); //ajax end
}

/*----------------------------------------------------------------------
 * Desc   : 2그룹코드 변경시 3그룹 리스트 생성
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function chg_group3(val){
	jQuery("#BI_GROUP3").empty();
	jQuery("#BI_GROUP3").append("<option value=''>선택</option>");
	jQuery.ajax({
		type 		: "POST",
		url 		: "/reader/biReader/ajaxBiGroupListByJson.do",
		dataType 	: "json",
		data		: "cdclsf="+val,
		success:function(result){
			jQuery.each(result.biGroupList, function(i) { 
				jQuery("#BI_GROUP3").append("<option value='"+result.biGroupList[i].CODE+"'>"+result.biGroupList[i].CNAME+"</option>");
			});
		},
		error    : function(r) { alert("error"); }
	}); //ajax end
}

/*----------------------------------------------------------------------
 * Desc   : 신청정보 생성/수정시 VALIDATION
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function validation(){

	if(!cf_checkNull("BI_GROUP1", "1차그룹")){ return false; }
	
	//기타일경우 validation skip
	if(document.getElementById("BI_GROUP2").value == "" && document.getElementById("BI_GROUP1").value != "7003"){
		alert("2차그룹을 선택해 주세요.");
		document.getElementById("BI_GROUP2").focus();
		return;
	}
	//기타일경우 validation skip
	if( document.getElementById("BI_GROUP3").value == "" && document.getElementById("BI_GROUP2").value != "8004" && document.getElementById("BI_GROUP2").value != "8105" && document.getElementById("BI_GROUP1").value != "7003"){
		alert("3차그룹을 선택해 주세요.");
		document.getElementById("BI_GROUP3").focus();
		return;
	}
	
	if(!cf_checkNull("BI_READNM", "비독자 성명")){ return false; }
	if(!cf_checkNull("OFFZIP", "우편번호")){ return false; }
	if(!cf_checkNull("OFFADRS2", "상세주소")){ return false; }
	
	if(document.getElementById("OFFADRS2").value.length > 50){
		alert("상세주소란은 50바이트 이상 작성 하실 수 없습니다.");
		document.getElementById("OFFADRS2").focus();
		return;
	}
	
	if(document.getElementById("HOMEADRS2").value.length > 50){
		alert("상세주소란은 50바이트 이상 작성 하실 수 없습니다.");
		document.getElementById("HOMEADRS2").focus();
		return;
	}
	
	if(document.getElementById("REMK").value.length > 200){
		alert("비고란은 200바이트 이상 작성 하실 수 없습니다.");
		document.getElementById("REMK").focus();
		return;
	}
	return true;
}

/*----------------------------------------------------------------------
 * Desc   : 비독자 정보 등록
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncSave(){
	
	if(!validation()) return;
	
	if(confirm("비독자 정보를 등록하시겠습니까? ")){
		document.getElementById("APLCDT").value = document.getElementById("TODAY").value;	
		frmList.target="_self";
		frmList.action="/reader/biReader/regBiReader.do";
		frmList.submit();
	
	}
	
}

/*----------------------------------------------------------------------
 * Desc   : 비독자 정보 수정
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncModify(){
	
	 if(document.getElementById("APLCNO").value == ''){
		alert("수정할 비독자를 목록에서 선택해주세요.");
		return;
	}else{	 
	 
		if(!validation()) return;
		
		if(confirm("비독자 정보를 수정하시겠습니까? ")){
			
			frmList.target="_self";
			frmList.action="/reader/biReader/modifyBiReader.do";
			frmList.submit();
		}
	}
	
}

/*----------------------------------------------------------------------
 * Desc   : 비독자 정보 삭제
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncDelete(){

	if(document.getElementById("APLCNO").value == ''){
		alert("삭제할 비독자를 목록에서 선택해주세요.");
		return;
	}else{
	
		if(confirm("비독자 정보를 삭제하시겠습니까? ")){
			
			frmList.target="_self";
			frmList.action="/reader/biReader/delBiReader.do";
			frmList.submit();
			
		}
	}
	
}

/*----------------------------------------------------------------------
 * Desc   : 일괄등록 폼 활성화여부
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function checkControll(){
	var frm = document.getElementById("frmList");
	//전체선택 1 , 전체해제 2
	if(frm.controll.checked == true){
		document.all.Etable.style.display='inline';
		document.all.Etable2.style.display='none';
	}else{
		document.all.Etable.style.display='none';
		document.all.Etable2.style.display='inline';
	}
}


/*----------------------------------------------------------------------
 * Desc   : excel파일을 통해 비독자 일괄등록
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncExcelUpload() {
	
	if ( !frmList.excelFile.value ) {
		alert("파일을 첨부해 주시기 바랍니다.");
		frmList.excelFile.focus();
		return;
	}
	
	if(!cf_checkNull("BI_GROUP1", "1차그룹")){ return false; }

	//기타일경우 validation skip
	if(document.getElementById("BI_GROUP2").value == "" && document.getElementById("BI_GROUP1").value != "7003"){
		alert("2차그룹을 선택해 주세요.");
		document.getElementById("BI_GROUP2").focus();
		return;
	}
	//기타일경우 validation skip
	if( document.getElementById("BI_GROUP3").value == "" && document.getElementById("BI_GROUP2").value != "8004" && document.getElementById("BI_GROUP2").value != "8105" && document.getElementById("BI_GROUP1").value != "7003"){
		alert("3차그룹을 선택해 주세요.");
		document.getElementById("BI_GROUP3").focus();
		return;
	}

	frmList.action = "/reader/biReader/excelBiReaderIns.do";
 	con=confirm("첨부하신 정보를 일괄 등록하시겠습니까?");
    if(con==false){
        return;
	}else{
		frmList.submit();
	}	
    
}


/*----------------------------------------------------------------------
 * Desc   : 숫자만 입력가능하도록 제어한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function inputNumCom(){
	 var keycode = event.keyCode;
	 
	 if( !((48 <= keycode && keycode <=57) || keycode == 13 || keycode == 46) ){
	  alert("숫자만 입력 가능합니다.");
	  event.keyCode = 0;  // 이벤트 cancel
	 }
}
	

//우편주소 팝업(직장 주소)
function popAddr(){
	var fm = document.getElementById("frmList");
	
	var left = (screen.width)?(screen.width - 1330)/2 : 10;
	var top = (screen.height)?(screen.height - 200)/2 : 10;
	var winStyle = "width=800,height=460,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=0";		
	var newWin = window.open("", "pop_AgSearch", winStyle);
	
	fm.target = "pop_AgSearch";
	fm.action = "/reader/readerAplc/popAgSearch.do?cmd=1";
	fm.submit();
}
//우편주소팝업에서 우편주소 선택시 셋팅 펑션	(직장 주소)
function setAgValue(zip, addr, boseq, jikuk, tel, handy){
	document.getElementById("OFFZIP").value = zip;
	document.getElementById("OFFADRS1").value = addr;
}

// 우편주소 팝업(자택주소)
function popAddr2(){
	var fm = document.getElementById("frmList");
	
	var left = (screen.width)?(screen.width - 1330)/2 : 10;
	var top = (screen.height)?(screen.height - 200)/2 : 10;
	var winStyle = "width=400,height=500,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
	var newWin = window.open("", "pop_addr", winStyle);
	
	fm.target = "pop_addr";
	fm.action = "/reader/readerManage/popAddr.do?cmd=1";
	fm.submit();
}

//우편주소팝업에서 우편주소 선택시 셋팅 펑션(자택주소)
function setAddr(zip , addr){
	document.getElementById("HOMEZIP").value = zip;
	document.getElementById("HOMEADRS1").value = addr;
}

jQuery.noConflict();
jQuery(document).ready(function($){
});
</script>
<!-- title -->
<div><span class="subTitle">비독자관리</span></div>
<!-- //title -->
<form id= "frmList" name = "frmList" method="post" enctype="multipart/form-data">
	<input type=hidden id="pageNo" name="pageNo" value="${param.pageNo}" />
	<input type=hidden id="TODAY" name="TODAY"  value="${TODAY}" />
	<!-- 조회조건 -->
	<table class="tb_search" style="width: 1020px;">
		<col width="80px">
		<col width="195px">
		<col width="80px">
		<col width="195px">
		<col width="80px">
		<col width="195px">
		<col width="80px">
		<col width="195px">
		<tr>
			<th>1차그룹</th>
			<td>				
				<select name="BI_GROUP1_S" style="width: 150px;">
					<option value = "">전체</option>
						<c:forEach items="${SECD6}" var="secd6"  varStatus="status">
							<option value="${secd6.CODE}"  <c:if test="${secd6.CODE eq BI_GROUP1_S}">selected</c:if>>${secd6.CNAME}</option>
					 	</c:forEach>
			  	</select>
			</td>
			<th>2차그룹</th>
			<td>
				<select name="BI_GROUP2_S" style="width: 150px;">
					<option value = "">전체</option>
						<c:forEach items="${SECD7}" var="secd7"  varStatus="status">
							<option value="${secd7.CODE}"  <c:if test="${secd7.CODE eq BI_GROUP2_S}">selected</c:if>>${secd7.CNAME}</option>
					 	</c:forEach>
			  	</select> 
			</td>
			<th>3차그룹</th>
			<td>
				<select name="BI_GROUP3_S" style="width: 150px;">
					<option value = "">전체</option>
						<c:forEach items="${SECD8}" var="secd8"  varStatus="status">
							<option value="${secd8.CODE}"  <c:if test="${secd8.CODE eq BI_GROUP3_S}">selected</c:if>>${secd8.CNAME}</option>
					 	</c:forEach>
			  	</select>
			</td>
			<th>구분코드</th>
			<td>
				<select name="GUBUN_S" style="width: 150px;">
					<option value = "">전체</option>
						<c:forEach items="${SELCODE}" var="selcode"  varStatus="status">
							<option value="${selcode.CODE}"  <c:if test="${selcode.CODE eq GUBUN_S}">selected</c:if>>${selcode.CNAME}</option>
					 	</c:forEach>
			  	</select>
			</td>
		</tr>
		<tr>
			<th>성 명</th>
			<td>				
				<input id="BI_READNM_S" name="BI_READNM_S" type="text"  maxlength = "15"   value="<c:out value="${BI_READNM_S}"/>"   style="width: 150px;ime-mode:active;" onkeydown="fncKeySearch();" />
			</td>
			<th>전화번호</th>
			<td>
				<input name="TEL1_S" type="text" style="width:30px; ime-Mode:disabled; vertical-align: middle;" onkeypress="inputNumCom();" maxlength="3" value="<c:out value="${TEL1_S}"/>"  onkeydown="fncKeySearch();"> -
				<input name="TEL2_S" type="text" style="width:40px; ime-Mode:disabled; vertical-align: middle;" onkeypress="inputNumCom();" maxlength="4" value="<c:out value="${TEL2_S}"/>"  onkeydown="fncKeySearch();"> -
				<input name="TEL3_S" type="text" style="width:40px; ime-Mode:disabled; vertical-align: middle;" onkeypress="inputNumCom();" maxlength="4" value="<c:out value="${TEL3_S}"/>"  onkeydown="fncKeySearch();">
			</td>
			<th>주 소</th>
			<td>
				<input id="ADDR_S" name="ADDR_S" type="text" maxLength="20" value="${ADDR_S}" style="width: 150px;ime-mode:active"  onkeydown="fncKeySearch();">
			</td>
			<th>인쇄용지</th>
			<td>
				<select name="type" style="width: 150px;">
					<option value = "biReaderLabel"  <c:if test="${'biReaderLabel' eq type}">selected</c:if>>AnyLabel</option>
					<option value = "biReaderLabel2"  <c:if test="${'biReaderLabel2' eq type}">selected</c:if>>Formtec</option>
			  	</select>
			</td>
		</tr>
		<tr>
			<th>소속기관</th>
			<td>
				<input id="ORGAN_S" name="ORGAN_S" type="text" maxlength = "35" value="${ORGAN_S}" style="width: 150px; ime-mode:active" onkeydown="fncKeySearch();">
			</td>
			<th>부 서</th>
			<td>
				<input id="OFFDEPT_S" name="OFFDEPT_S" type="text"  maxlength = "35"  value="${OFFDEPT_S}" style=" ime-mode:active;"  onkeydown="fncKeySearch();">
			</td>
			<th>직 책</th>
			<td colspan ="3">    
              	<input id="OFFDUTY_S" name="OFFDUTY_S" type="text"  maxlength="35" value="${OFFDUTY_S}" style="width: 150px; ime-mode:active; vertical-align: middle;"  onkeydown="fncKeySearch();" />
              	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="#fakeUrl" onclick="fncBiReaderList()"><img src="/images/bt_joh.gif" style="vertical-align: middle;" alt="조회" /></a>
				<a href="#fakeUrl" onclick="fncBiReaderExcelList()"><img src="/images/bt_exel.gif" style="vertical-align: middle;" alt="excel 출력" /></a>
				<a href="#fakeUrl" onclick="ozPrint()"><img src="/images/bt_pprint.gif" style="vertical-align: middle;" alt="인쇄" /></a>
			</td>
		</tr>
	</table>
	<!-- //조회조건-->
	<div style="padding-top: 10px; width: 1020px; margin: 0 auto;">
		<div style="width: 600px; float: left; padding-right: 10px;">
			<table style="width: 600px;">
				<tr>
					<td align="left" height="22"><b><img src="/images/i.gif" border="0" align="top"> 비독자목록</b></td>
					<td align="right"><b>Total : ${totalCount} 건&nbsp;&nbsp;&nbsp;</b></td>
				</tr>
			</table>
			<table class="tb_list_a_5" style="width: 600px;">
				<col width="130px">
				<col width="350px">
				<col width="60px">
				<col width="60px">
			    <tr>
		            <th>성 명</th>
		            <th>주 소</th>
		            <th>우편번호</th>
		            <th>전화번호</th>
			    </tr>
				<c:if test="${empty biReaderList}">
			        <tr><td colspan="4">등록된 비독자 정보가 없습니다.</td></tr>
			    </c:if>
		     <c:if test="${!empty biReaderList}">
				<c:forEach items="${biReaderList}" var="list"  varStatus="i">
					<tr onclick="fn_detailView('${list.APLCDT}', '${list.APLCNO}')" class="mover">
						<td style="text-align:left;">${list.BI_READNM}</td>
						<td style="text-align:left;">${list.OFFADRS1} ${list.OFFADRS2}</td>
						<td>${list.OFFZIP}</td>
				        <c:if test="${!empty list.OFFTEL2}">
				        	<td style="text-align:left;"><c:out value="${list.OFFTEL1}"/>-<c:out value="${list.OFFTEL2}"/>-<c:out value="${list.OFFTEL3}"/></td>
				        </c:if>
			            <c:if test="${empty list.OFFTEL2 && !empty list.MOBILE2}">
			            	<td style="text-align:left;"><c:out value="${list.MOBILE1}"/>-<c:out value="${list.MOBILE2}"/>-<c:out value="${list.MOBILE3}"/></td>
			            </c:if>
			            <c:if test="${empty list.OFFTEL2 && empty list.MOBILE2}">
			            	<td style="text-align:left;"></td>
			            </c:if>
					</tr>
			    </c:forEach>
		    </c:if>
		    </table>
		    <!-- paging -->
			<div style="width: 600px; text-align: center;"><%@ include file="/common/paging.jsp"  %></div>
			<!-- //paging -->
		</div>
		<div style="float: left; width: 410px;">
			<div style="padding-bottom: 5px;">
				<table style="width: 410px;">
					<tr>
						<td style="text-align: left;"><b><img src="/images/i.gif" border="0" align="top"> 비독자입력</b></td>
						<td style="text-align: right;"><input type="checkbox" id="controll" name="controll"  onclick="javascript:checkControll();" style="vertical-align: middle;"> 일괄등록</td>
					</tr>
				</table>
			</div>
			<table class="tb_view" style="width: 410px;">
				<col width="70px">
				<col width="340px">
				<tr>
					<th>그 룹</th>
					<td>				
						<select name="BI_GROUP1" id="BI_GROUP1" style="width: 80px;" onchange="chg_group2(this.value);">
							<option value = "">선택</option>
								<c:forEach items="${SECD6}" var="secd6"  varStatus="status">
									<option value="${secd6.CODE}" <c:if test="${secd6.CODE eq BI_GROUP1}">selected</c:if>>${secd6.CNAME}</option>
							 	</c:forEach>
					  	</select>
					  	<select name="BI_GROUP2" id="BI_GROUP2" style="width: 95px;" onchange="chg_group3(this.value);">
							<option value = "">선택</option>
					  	</select> 
					  	<select name="BI_GROUP3" id="BI_GROUP3" style="width: 120px;">
							<option value = "">선택</option>
					  	</select>
					</td>
				</tr>
			</table>
			<div id="Etable" style="display:none;">
				<table class="tb_view" style="width: 410px; padding-bottom: 5px;">
					<col width="70px">
					<col width="340px">
	                <tr>
	                	<th>일괄등록</th>
						<td>				
							<input type="file" name="excelFile" id="excelFile" class="box_250" style="width:240px; vertical-align: middle;">
					 		<a href="#fakeUrl" onclick="fncExcelUpload();"><img src="/images/bt_eepl.gif" style="vertical-align: middle;" alt="" /></a>
						</td>
					</tr>
				</table>
				<div style="width: 410px; text-align: right;">
					<a href="<%=ISiteConstant.PATH_UPLOAD_BI_READER_RESULT%>/biReader_sample.xls" target="_blank">[일괄등록 양식 다운로드]</a>
				</div>
			</div>
			<div id="Etable2">
				<div style="padding: 5px 0;">
					<table class="tb_view" style="width: 410px;">
						<col width="70px">
						<col width="135px">
						<col width="70px">
						<col width="135px">
						<tr>
							<th>성 명</th>
							<td><input id="BI_READNM" name="BI_READNM" type="text"  maxlength="15"  style="width: 80px; ime-mode:active" /></td>
							<th>입력일자</th>
							<td>			
								<input id="APLCDT" name="APLCDT" type="text"  value="${TODAY}"  readonly="readonly"  style="width: 80px; ime-mode:active" />
								<input id="APLCNO" name="APLCNO" type="hidden" />
							</td>
						</tr>
					</table>
				</div>
				<div style="padding: 10px 0 5px 0;"><b><img src="/images/left_icon.gif" style="vertical-align: middle;" alt=""  /> 직 장</b></div>
				<table class="tb_view" style="width: 410px;">
					<col width="70px">
					<col width="135px">
					<col width="70px">
					<col width="135px">
					<tr>
						<th>주 소</th>
						<td colspan="3">				
							<input type="text" id="OFFZIP" name="OFFZIP" value=""  maxlength="6" style="width: 60px;ime-mode:active; vertical-align: middle;" readonly="readonly" />
							<a href="#fakeUrl" onclick="popAddr();"><img alt="우편번호찾기" src="/images/ico_search2.gif" style="border: 0; vertical-align: middle;" /></a>
							&nbsp;<input type="text" id="OFFADRS1" name="OFFADRS1" style="width: 200px;ime-mode:active; vertical-align: middle;" readonly="readonly" /><br />
							<input id="OFFADRS2" name="OFFADRS2" type="text"  maxlength="45"  style="width: 294px;ime-mode:active; vertical-align: middle;" />
						</td>
					</tr>
					<tr>
						<th>전 화</th>
						<td>				
							<input id="OFFTEL1" name="OFFTEL1" type="text" style="width:24px; ime-Mode:disabled; vertical-align: middle;" maxlength="3"  onkeypress="inputNumCom();" /> -
							<input id="OFFTEL2" name="OFFTEL2" type="text" style="width:29px; ime-Mode:disabled; vertical-align: middle;" maxlength="4"  onkeypress="inputNumCom();" /> -
							<input id="OFFTEL3" name="OFFTEL3" type="text" style="width:29px; ime-Mode:disabled; vertical-align: middle;" maxlength="4"  onkeypress="inputNumCom();" />
						</td>
						<th>휴대폰</th>
						<td>							
							<input id="MOBILE1" name="MOBILE1" type="text" style="width:24px; ime-Mode:disabled; vertical-align: middle;" maxlength="3"  onkeypress="inputNumCom();" /> -
							<input id="MOBILE2" name="MOBILE2" type="text" style="width:30px; ime-Mode:disabled; vertical-align: middle;" maxlength="4"  onkeypress="inputNumCom();" /> -
							<input id="MOBILE3" name="MOBILE3" type="text" style="width:30px; ime-Mode:disabled; vertical-align: middle;" maxlength="4"  onkeypress="inputNumCom();" />
						</td>
					</tr>
					<tr>
						<th>소속기관</th>
						<td><input id="ORGAN" name="ORGAN"  type="text"  maxlength="35"  style="width: 90px; ime-mode:active" /></td>
						<th>부 서</th>
						<td><input id="OFFDEPT" name="OFFDEPT"  type="text"  maxlength="35" style="width: 90px; ime-mode:active" /></td>
					</tr>
					<tr>
						<th>직 책</th>
						<td><input id="OFFDUTY" name="OFFDUTY" type="text"  maxlength="35"  style="width: 90px;ime-mode:active" /></td>
						<th>팩 스</th>
						<td>					
							<input id="OFFFAX1" name="OFFFAX1" type="text" style="width:24px; ime-Mode:disabled; vertical-align: middle;" maxlength="3"  onkeypress="inputNumCom();" /> -
							<input id="OFFFAX2" name="OFFFAX2" type="text" style="width:30px; ime-Mode:disabled; vertical-align: middle;" maxlength="4"  onkeypress="inputNumCom();" /> - 
							<input id="OFFFAX3" name="OFFFAX3" type="text" style="width:30px; ime-Mode:disabled; vertical-align: middle;" maxlength="4"  onkeypress="inputNumCom();" value="" />
						</td>
					</tr>
					<tr>
						<th>이메일</th>
						<td colspan="3"><input id="EMAIL" name="EMAIL" type="text"  maxlength="45"  style="width: 290px;ime-mode:active" /></td>
					</tr>
					<tr>
						<th>구독여부</th>
						<td>			
							<input type="radio" id="SMGUDOK" name="SMGUDOK" value="N" checked="checked" />No&nbsp;&nbsp;
							<input type="radio" id="SMGUDOK" name="SMGUDOK" value="Y"  />Yes
						</td>
						<th>구분코드</th>
						<td>				
							<select id="GUBUN" name="GUBUN">
								<option value = "">선택</option>
									<c:forEach items="${SELCODE}" var="selcode"  varStatus="status">
										<option value="${selcode.CODE}"  <c:if test="${selcode.CODE eq GUBUN}">selected="selected"</c:if>>${selcode.CNAME}</option>
								 	</c:forEach>
						  	</select>
						</td>
					</tr>
				</table>
				<div style="padding: 15px 0 5px 0;"><b><img src="/images/left_icon.gif" style="vertical-align: middle;" alt=""  /> 자 택</b></div>
				<table class="tb_view" style="width: 410px;">
					<col width="70px">
					<col width="135px">
					<col width="70px">
					<col width="135px">
					<tr>
						<th>자택주소</th>
						<td colspan="3">				
							<input type="text" id="HOMEZIP" name="HOMEZIP" value=""  size="3" maxlength="6" style="width: 60px; ime-mode:active; vertical-align: middle;" readonly="readonly" />
							<a href="#fakeUrl" onclick="popAddr2();"><img alt="우편번호찾기" src="/images/ico_search2.gif" style="border: 0; vertical-align: middle;" /></a>
							&nbsp;<input type="text" id="HOMEADRS1" name="HOMEADRS1" style="width: 200px; ime-mode:active; vertical-align: middle;" readonly="readonly" /><br />
							<input id="HOMEADRS2" name="HOMEADRS2" type="text"  maxlength="45"  style="width: 294px;ime-mode:active; vertical-align: middle;" />
						</td>
					</tr>
					<tr>
						<th>전 화</th>
						<td colspan="3">				
							<input id="HOMETEL1" name="HOMETEL1" type="text" style="width:24px; ime-Mode:disabled; vertical-align: middle;" maxlength="3"  onkeypress="inputNumCom();">-
							<input id="HOMETEL2" name="HOMETEL2" type="text" style="width:32px; ime-Mode:disabled; vertical-align: middle;" maxlength="4"  onkeypress="inputNumCom();" >-
							<input id="HOMETEL3" name="HOMETEL3" type="text" style="width:32px; ime-Mode:disabled; vertical-align: middle;" maxlength="4"  onkeypress="inputNumCom();" >
						</td>
					</tr>
				</table>
				<div style="padding-top: 10px;">
					<table class="tb_view" style="width: 410px;">
						<col width="70px">
						<col width="340px"> 
						<tr>
							<th>기 타</th>
							<td><textarea rows="2" cols="35" id="REMK" name="REMK" ></textarea></td>
						</tr>
					</table>
				</div>
				<!-- paging -->
				<div style="padding-top: 10px; text-align: right;">
					<a href="javascript:fncSave()"><img src="/images/bt_eepl.gif" border="0" alt="" /></a> 
					<a href="javascript:fncModify()"><img src="/images/bt_modi.gif" border="0" alt="" /></a>
					<a href="javascript:fncDelete()"><img src="/images/bt_delete.gif" border="0" alt="" /></a>
					<a href="javascript:fncCancel()"><img src="/images/bt_cancle.gif" border="0" alt="" /></a>
				</div>							
			    <!-- //paging -->
			</div>  
		</div>
	</div>
</form>