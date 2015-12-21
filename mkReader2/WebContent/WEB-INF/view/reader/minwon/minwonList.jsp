<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ page import="com.mkreader.security.ISiteConstant" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript"  src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
/*----------------------------------------------------------------------
 * Desc   : 페이징
 * Auth   : 박윤철
 *----------------------------------------------------------------------*/
function moveTo(where, seq) {
	var fm = document.getElementById("minwonListForm");

	fm.pageNo.value = seq;
	fm.target = "_self";
	fm.action = "/reader/minwon/retrieveMinwonList.do";
	fm.submit();
}

/*----------------------------------------------------------------------
 * Desc   : 민원리스트 조회
 * Auth   : 박윤철
 *----------------------------------------------------------------------*/
function fn_search(){
	var fm = document.getElementById("minwonListForm");
	
	fm.target = "_self";
	fm.action = "/reader/minwon/retrieveMinwonList.do";
	fm.submit();
}
	
/*----------------------------------------------------------------------
 * Desc   : 민원 등록
 * Auth   : 박윤철
 *----------------------------------------------------------------------*/
function saveMinwon(type){
	var fm = document.getElementById("minwonListForm");
	
	if(validation()){ return; }

	// 타입1인 경우 재등록이 가능하도록 MinwonNo를 클리어
	if(type == "1"){
		fm.minwonNo.value = "";
	}else if(type == "2"){
		fm.spcialYn.value = "Y";
	}

	fm.target = "_self";
	fm.action = "/reader/minwon/saveMinwon.do";
	fm.submit();
	return;
}
	
	/*----------------------------------------------------------------------
	 * Desc   : 민원 삭제
	 * Auth   : 박윤철
	 *----------------------------------------------------------------------*/
function deleteMinwon(){
	var fm = document.getElementById("minwonListForm");

	if(confirm("등록된 민원을 삭제 하시겠습니까?")){
		fm.target = "_self";
		fm.action = "/reader/minwon/deleteMinwon.do";
		fm.submit();
	}
	return;
}
	
/*----------------------------------------------------------------------
 * Desc   : 민원 유효성 체크
 * Auth   : 박윤철
 *----------------------------------------------------------------------*/
function validation(){
	if(!cf_checkNull("addr", "독자주소")) { return false; }
	
	if(document.getElementById("minwonDesc").value.length > 250){
		alert("민원상세는 250자 까지 입력 가능합니다.");
		return false;
	}
}
	
/*----------------------------------------------------------------------
 * Desc   : 오즈 출력
 * Auth   : 박윤철
 *----------------------------------------------------------------------*/
function fn_oz_print(){
	var fm = document.getElementById("minwonListForm");
	
	if(!cf_checkNull("morningWorker", "조출당직")) { return false; }
	if(!cf_checkNull("lunchWorker", "점심당직")) { return false; }
	if(!cf_checkNull("dinnerWorker", "저녁당직")) { return false; }
	
	var actUrl = "/reader/minwon/ozMinwonList.do";
	winOpts = window.open('','ozMinwonList','width=1000, height=800, toolbar=no, menubar=no, location=no, status=no, resizable=1, scrollbars=no');
	winOpts.focus();
	
	fm.target = "ozMinwonList";
	fm.action = actUrl;
	fm.submit();
}
	
/*----------------------------------------------------------------------
 * Desc   : 민원보고서 출력
 * Auth   : 박윤철
 *----------------------------------------------------------------------*/
function printMinwonDetail(){
	var fm = document.getElementById("minwonListForm");
	
	var actUrl2 = "/reader/minwon/ozMinwonDetail.do";
	winOpts2 = window.open('','ozMinwonDetail','width=1000, height=800, toolbar=no, menubar=no, location=no, status=no, resizable=1, scrollbars=no');
	winOpts2.focus();

	fm.target = "ozMinwonDetail";
	fm.action = actUrl2;
	fm.submit();
}
	
	
	/*----------------------------------------------------------------------
	 * Desc   : 지국명 자동완성 호출
	 * Auth   : 박윤철
	 *----------------------------------------------------------------------*/
	function findJikuk() {
		// 방향키 입력시 상하이동
		if(event.keyCode=="40"){
			if($("jikukNameTableBody").firstChild != null){
				$("jikukNameTableBody").firstChild.firstChild.focus();
				return;
			}
		}
		
		// 기타키 입력시 자동완성 호출
		$("boseq").value = "";
		$("jikukTel").value = "";
		$("jikukHp").value = "";
		initVars();
	    
	    if(inputField.value.length > 0) {
	    	createXMLHttpRequest();
	        var url = "/reader/minwon/retrieveJikukAutocomplete.do";
	        xmlHttp.open("POST", url, true);
	        xmlHttp.onreadystatechange = callback;
	        xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8;");
	        xmlHttp.send("jikukName="+$("jikukName").value+"&rownum=15");
	    }else{
	    	clearJikuk();
	    }
	}
	
	// 변수 세팅
	function initVars() {

	    inputField = document.getElementById("jikukName");
	    nameTable = document.getElementById("jikukNameTable");
	    completeDiv = document.getElementById("jikukNamePopup");
	    nameTableBody = document.getElementById("jikukNameTableBody");
	}
	
	// XML Request생성
	function createXMLHttpRequest() {

	    if (window.ActiveXObject) {
	        xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
	    }else if (window.XMLHttpRequest) {
	        xmlHttp = new XMLHttpRequest();     
	    }
	}
	
	//json으로 요청값을 받을때
	function callback() {

		if (xmlHttp.readyState == 4) {
	    	if (xmlHttp.status == 200) {
	            var result = xmlHttp.responseText;
	            var autoComplete = eval('(' + result + ')');
	           
	            setNames(autoComplete);
	        }else if(xmlHttp.status == 204){//데이터가 존재하지 않을 경우
	        	clearJikuk();
	        }else{
	        	clearJikuk();
	        }
	    }
	}
	
	/*----------------------------------------------------------------------
	 * Desc   : 지국명 자동완성 목록 초기화
	 * Auth   : 박윤철
	 *----------------------------------------------------------------------*/
	function clearJikuk() {
	    var ind = nameTableBody.childNodes.length;
	    for (var i = ind - 1; i >= 0 ; i--) {
	         nameTableBody.removeChild(nameTableBody.childNodes[i]);
	    }
	    completeDiv.style.border = "none";
	}
	
	/*----------------------------------------------------------------------
	 * Desc   : 지국명 입력창에 선택값 입력
	 * Auth   : 박윤철
	 *----------------------------------------------------------------------*/
	function setNames(autoComplete) {
		$("boseq").value = "";
		$("jikukTel").value = "";
		$("jikukHp").value = "";
		clearJikuk();
	    var size = autoComplete.jikukNamelist.length;
	    
	    setOffsets();
	    var row, cell, txtNode, boseqNode, hpNode, telNo;
	
	    for (var i = 0; i < size; i++) {
	        var nextNode = autoComplete.jikukNamelist[i].NAME;
	        var nextNode1 = autoComplete.jikukNamelist[i].BOSEQ;
	        var nextNode2 = autoComplete.jikukNamelist[i].JIKUK_HANDY;
	        var nextNode3 = autoComplete.jikukNamelist[i].JIKUK_TEL;
	        
	        row = document.createElement("tr");
	        cell = document.createElement("td");
	        
	        boseqNode = document.createElement("input");
	        boseqNode.setAttribute("type", "hidden");
	        boseqNode.setAttribute("value", nextNode1);

	        hpNode = document.createElement("input");
	        hpNode.setAttribute("type", "hidden");
	        hpNode.setAttribute("value", nextNode2);
	        
	        telNo = document.createElement("input");
	        telNo.setAttribute("type", "hidden");
	        telNo.setAttribute("value", nextNode3);
	        
	        cell.setAttribute = function() {this.className='mouseOut';};
	        cell.setAttribute("border", "0");
	        cell.onblur = function() {this.className='mouseOut';};
	        cell.onfocus = function() {this.className='mouseOver';
	        						   inputField.value = this.childNodes[0].nodeValue;
	        						   $("boseq").value = this.childNodes[1].value;
	        						   $("jikukHp").value = this.childNodes[2].value;
	        						   $("jikukTel").value = this.childNodes[3].value;
	        						   };
	        cell.onmouseout = function() {this.className='mouseOut';};
	        cell.onmouseover = function() { this.className='mouseOver';
	        								inputField.value = this.childNodes[0].nodeValue;
	 	        						    $("boseq").value = this.childNodes[1].value;
		        						    $("jikukHp").value = this.childNodes[2].value;
		        						    $("jikukTel").value = this.childNodes[3].value;
	        							   };
	        
	        cell.onkeyup = function() { changeNode(this.parentNode);};
	        cell.onclick = function() { populateName(this);};
	
	        txtNode = document.createTextNode(nextNode);
	        
	        cell.appendChild(txtNode);
	        cell.appendChild(boseqNode);
	        cell.appendChild(hpNode);
	        cell.appendChild(telNo);
	        row.appendChild(cell);
	        nameTableBody.appendChild(row);
	    }
	}
	
	/*----------------------------------------------------------------------
	 * Desc   : 키코드에 따른 노드이동 및 지국명입력란 입력
	 * Auth   : 박윤철
	 *----------------------------------------------------------------------*/
	function changeNode(node){
		// 다운키 입력시 이벤트
		if(event.keyCode=="40"){
			if(node.nextSibling != null){
				node.nextSibling.firstChild.focus();
			}else{
				$("jikukName").focus();
			}
		// 업키 입력시 이벤트
		}else if(event.keyCode=="38"){
			if(node.previousSibling != null){
				node.previousSibling.firstChild.focus();
			}else{
				$("jikukName").focus();
			}
		// 엔터키 입력시 이벤트
		}else if(event.keyCode=="13"){
			clearJikuk();
			$("jikukName").focus();
		}
		return false;
	 }
	
/*----------------------------------------------------------------------
 * Desc   : div 위치지정
 * Auth   : 박윤철
 *----------------------------------------------------------------------*/
function setOffsets() {
    var end = inputField.offsetWidth;
    var left = calculateOffsetLeft(inputField);
    var top = calculateOffsetTop(inputField) + inputField.offsetHeight;
    completeDiv.style.border = "black 1px solid";
    completeDiv.style.left = left + "px";
    completeDiv.style.top = top + "px";
    nameTable.style.width = end + "px";
}

function calculateOffsetLeft(field) {
  	return calculateOffset(field, "offsetLeft");
}

function calculateOffsetTop(field) {
  	return calculateOffset(field, "offsetTop");
}

function calculateOffset(field, attr) {
	var offset = 0;
  	while(field) {
		offset += field[attr]; 
		field = field.offsetParent;
	}
  	return offset;
}

function populateName(cell) {
    inputField.value = cell.firstChild.nodeValue;
    clearJikuk();
}
	
	/*----------------------------------------------------------------------
	 * Desc   : 통화시간 입력란 포커스 이동
	 * Auth   : 박윤철
	 *----------------------------------------------------------------------*/
	function chageFocus(){

		if($("callTm1").value.length > 1 ){
			$("callTm2").focus();
		}
	}
	
	/*----------------------------------------------------------------------
	 * Desc   : 통화시간 24형태로 전환
	 * Auth   : 박윤철
	 *----------------------------------------------------------------------*/
	function chage24(){
		if($("callTm1").value.length < 2 ){
			$("callTm1").value = "0"+$("callTm1").value;
		}	 
	}
	
	function chgCallTm(){
		if( $("callTm2").value == "" ){
			if(event.keyCode == 8){
				$('callTm1').value = "";
				$('callTm1').focus();
			}
		}
	}

	/*----------------------------------------------------------------------
	 * Desc   : 민원상세정보 조회
	 * Auth   : 박윤철
	 *----------------------------------------------------------------------*/
	function retrieveMinwonDetail(minwonNo, minwonDt, boseq, readnm, tel, addr, minwonCd1, minwonCd2, minwonNm2, jikukName, jikukTel, jikukHp, callPs, minwonDesc, callTm, toDayYn){

		clearField();
		
		$("buttonCtl1").style.display = "none";
		$("buttonCtl2").style.display = "block";
		if(toDayYn == "Y"){
			$("buttonCtl3").style.display = "block";
		}else{
			$("buttonCtl3").style.display = "none";
		}
		
		$("minwonNo").value = minwonNo;
		$("minwonDt").value = minwonDt;
		$("boseq").value = boseq;
			
		$("readNm").value = readnm;
		$("telNo").value = tel;
		$("addr").value = addr;
		$("jikukName").value = jikukName;
		$("jikukTel").value = jikukTel;
		$("jikukHp").value = jikukHp;
		$("minwonDesc").value = $("minwonDesc"+minwonDesc).value;
		$("callTm1").value = callTm.substring(0,2);
		$("callTm2").value = callTm.substring(2,4);

		$("minwonCd1").value = minwonCd1;
		$("minwonCd2").options.length = 0;
		$("minwonCd2").options[0] = new Option(minwonNm2, minwonCd2);

		document.minwonListForm.callPs[callPs-1].checked = true;
	}

	/*----------------------------------------------------------------------
	 * Desc   : 등록 필드 초기화
	 * Auth   : 박윤철
	 *----------------------------------------------------------------------*/
	function clearField(type){

		$("buttonCtl1").style.display = "block";
		$("buttonCtl2").style.display = "none";
		$("buttonCtl3").style.display = "none";
		
		$("minwonDt").value = "";
		$("minwonNo").value = "";
		$("readNm").value = "";
		$("telNo").value = "";
		$("addr").value = "";
		$("jikukName").value = "";
		$("boseq").value = "";
		$("jikukTel").value = "";
		$("jikukHp").value = "";
		$("minwonDesc").value = "";
		$("callTm1").value = "";
		$("callTm2").value = "";
		
		$("minwonCd1").value = "001";

		if(type == "1"){
			fn_chgCombo();
		}
		
		document.minwonListForm.callPs[0].checked = true;
		document.minwonListForm.callPs[1].checked = false;
		document.minwonListForm.callPs[2].checked = false;
	}

	/*----------------------------------------------------------------------
	 * Desc   : 상세 민원 구분 조회
	 * Auth   : 박윤철
	 *----------------------------------------------------------------------*/
	function fn_chgCombo(){

		createXMLHttpRequest();
		
		$("minwonCd2").options.length = 0;
		
        var url = "/reader/minwon/retrieveMinwonCd2List.do";
        xmlHttp.open("POST", url, true);
        xmlHttp.onreadystatechange = minwonCd2List;
        xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8;");
        xmlHttp.send("minwonCd1="+$("minwonCd1").value);
	}
	
	function minwonCd2List() {

		if (xmlHttp.readyState == 4){
			if (xmlHttp.status == 200) {
				try {
					var result = xmlHttp.responseText;
					var jsonObjArr = eval("(" + result + ")");
					if (jsonObjArr) {
						setMinwonCd2(jsonObjArr);
					}
				} catch (e) {
					alert("오류 : " + e);
				}
			}
		}
	}

	function setMinwonCd2(jsonObjArr){

		for( var i=0 ; i < jsonObjArr.minwonCd2List.length; i++){
			$("minwonCd2").options[i] = new Option((i+1)+"."+jsonObjArr.minwonCd2List[i].CNAME , jsonObjArr.minwonCd2List[i].CODE );
		}
	}
	
//우편주소 팝업(직장 주소)
function popAddr(){
	var left = (screen.width)?(screen.width - 1330)/2 : 10;
	var top = (screen.height)?(screen.height - 200)/2 : 10;
	var winStyle = "width=800,height=460,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=0";		
	newWin = window.open("", "pop_AgSearch", winStyle);
	newWin.focus();
	
	minwonListForm.target = "pop_AgSearch";
	minwonListForm.action = "/reader/readerAplc/popAgSearch.do?cmd=1";
	minwonListForm.submit();
}

//우편주소팝업에서 우편주소 선택시 셋팅 펑션	(직장 주소)
function setAgValue(zip, addr, boseq, jikuk, tel, handy){
	var fm = document.getElementById("minwonListForm");
	fm.boseq.value = boseq;
	fm.jikukName.value = jikuk;
	fm.jikukHp.value = handy;
	fm.jikukTel.value = tel;
}
	
//	window.attachEvent("onload", fn_chgCombo);
jQuery.noConflict();
jQuery(document).ready(function($){
	fn_chgCombo();
});
</script>
<!-- title -->
<div><span class="subTitle">독자민원관리</span></div>
<!-- //title -->
<form id="minwonListForm" name="minwonListForm" action="" method="post" enctype="multipart/form-data">
	<input type=hidden id="pageNo" name="pageNo" value="${param.pageNo}" />
	<input type=hidden id="minwonNo" name="minwonNo" value="" />
	<input type=hidden id="minwonDt" name="minwonDt" value="" />
	<input type=hidden id="spcialYn" name="spcialYn" value="" />
<!-- search conditions -->
<div class="box_white" style="padding: 10px 0;  width: 1020px; margin: 0 auto;">
	<font class="b02">접수일자</font>&nbsp;&nbsp;
	<input type="text" id="fromDate" name="fromDate"  value="<c:out value='${fromDate}' />" readonly="readonly" onclick="Calendar(this)" style="width: 85px; vertical-align: middle;"/> ~ 
	<input type="text" id="toDate" name="toDate"  value="<c:out value='${toDate}' />" readonly="readonly" onclick="Calendar(this)" style="width: 85px; vertical-align: middle;"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<select name="search_type" id="search_type" style="vertical-align: middle;">
		<option value="userName" <c:if test="${empty param.search_type or param.search_type eq 'userName'}">selected </c:if> >독자명</option>
		<option value="addr" <c:if test="${param.search_type eq 'addr'}">selected </c:if>>주소</option>
		<option value="telNo" <c:if test="${param.search_type eq 'telNo'}">selected </c:if>>전화번호</option>
		<option value="jikukNm" <c:if test="${param.search_type eq 'jikukNm'}">selected </c:if>>관리지국</option>
		<option value="inPs" <c:if test="${param.search_type eq 'inPs'}">selected </c:if>>접수자</option>
	</select>
	&nbsp;&nbsp;
	<input type="text" id="search_value" name="search_value"  value="<c:out value='${param.search_value}'/>" onkeydown="if(event.keyCode == 13){fn_search();}" style="vertical-align: middle; width: 120px"/> 
	&nbsp;&nbsp;
	<a href="#fakeUrl" onclick="fn_search();"><img src="/images/bt_search.gif" style="vertical-align: middle; border: 0;" alt="검색"></a>
</div>
<!-- //search conditions -->
<!-- 민원등록 및 상세 -->
<div class="box_list" style=" width: 1020px; margin: 0 auto;">
	<table class="tb_list_a" style="width: 1020px;">
		<colgroup>
			<col width="90px">
			<col width="200px">
			<col width="90px">
			<col width="130px">
			<col width="90px">
			<col width="130px">
			<col width="90px">
			<col width="200px">
		</colgroup>
		<tr>
			<th>독 자 명</th>
			<td><input type="text" id="readNm" name="readNm"  value="" onkeypress="if(event.keyCode==13){$('telNo').focus();}" style="width: 95%"/></td>
			<th>연 락 처</th>
			<td><input type="text" id="telNo" name="telNo"  value="" style="ime-Mode:disabled; width: 95%" onkeypress="if(event.keyCode==13){$('addr').focus();}else{inputNumCom();}"/></td>
			<th><b class="b03">*</b>독자주소</th>
			<td colspan="3"><input type="text" id="addr" name="addr"  value="" style="width: 98%" onkeypress="if(event.keyCode==13){$('jikukName').focus();}"/></td>
		</tr> 
		<tr>
			<th>민원구분</th>
			<td colspan="3">
				<select id="minwonCd1" name="minwonCd1" style="width: 80px; vertical-align: middle;" onchange="fn_chgCombo();">
					<option value="000" selected="selected">-선택-</option>
					<option value="001">배달</option>
					<option value="002">해지</option>
					<option value="003">전화</option>
					<option value="004">학생</option>
					<option value="005">결제</option>
					<option value="006">기타</option>
				</select>
				&nbsp;
				<select id="minwonCd2" name="minwonCd2" style="width: 320px; vertical-align: middle;">
			  	</select> 
			</td>
			<th>지 국 명</th>
			<td>
				<input name="boseq" id="boseq" type="hidden" value=""/>
				<input name="jikukName" id="jikukName" type="text" value="" style="width: 60%; vertical-align: middle;" onkeyup="findJikuk()" onkeypress="if(event.keyCode==13){$('callTm1').focus();}"/>
			    <div style="position:absolute;" id="jikukNamePopup" >
			        <table id="jikukNameTable"  style="background-color: #fffafa; border:0px"> 
			            <tbody id="jikukNameTableBody"></tbody>
			        </table>
			    </div>
			    <img alt="지국찾기" src="/images/ico_search2.gif" style="vertical-align: middle; border: 0; cursor: pointer;" onclick="popAddr();" />
			</td>
			<th>지국전화</th>
			<td>
				<input type="text" id="jikukTel" name="jikukTel"  value="" size="8" readonly="readonly"/> 
				<input type="text" id="jikukHp" name="jikukHp"  value="" size="9" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<th rowspan="2">민원상세</th>
			<td colspan="3" rowspan="2">
				<textarea id="minwonDesc" name="minwonDesc" class="box_l" style="width: 98%"></textarea>
			</td>
			<th>통화시간</th>
			<td>
				<input type="text" id="callTm1" name="callTm1" maxlength="2" value="" style="ime-Mode:disabled; width: 30px" onblur="chage24()" onkeyup="chageFocus();" onkeypress="inputNumCom();"/>시 &nbsp;
				<input type="text" id="callTm2" name="callTm2" maxlength="2" value="" style="ime-Mode:disabled; width: 30px" onKeyDown="chgCallTm();" onkeypress="if(event.keyCode==13){$('callPs').focus();}else{inputNumCom();}" />분
			</td>
			<th>통 화 자</th>
			<td>
				<input type="radio" id="callPs" name="callPs" value="1" checked="checked" style="border: 0; vertical-align: middle;"/> 경리&nbsp;&nbsp;
				<input type="radio" id="callPs" name="callPs" value="2"  style="border: 0; vertical-align: middle;"/> 지국장&nbsp;&nbsp;
				<input type="radio" id="callPs" name="callPs" value="3"  style="border: 0; vertical-align: middle;"/> 직원&nbsp;&nbsp;
			</td>
		</tr>
		<tr>
			<td colspan="4" style="text-align: right;">
				<span id="buttonCtl1" style="display: block;">
					<a href="#fakeUrl" onclick="saveMinwon();"><img src="/images/bt_insert.gif" style="vertical-align:middle; border:0" alt=""></a>
					&nbsp;&nbsp;&nbsp;
				</span>
				<div id="buttonCtl2" style="display: none;">
					<span id="button2" style="float:right;">
						<a href="#fakeUrl" onclick="saveMinwon();"><img src="/images/bt_save.gif" style="vertical-align:middle; border:0" alt=""></a>
						&nbsp;&nbsp;&nbsp;
					</span>
					<span id="buttonCtl3" style="display: none; width: 80px; float:right;" >
						<a href="#fakeUrl" onclick="deleteMinwon();"><img src="/images/bt_delete.gif" style="vertical-align:middle; border:0" alt=""></a>
						&nbsp;&nbsp;&nbsp;
					</span>
					<span id="button1" style="float:right;">
						<a href="#fakeUrl" onclick="printMinwonDetail();"><img src="/images/bt_minwonPrint.gif" style="vertical-align:middle; border:0" alt=""></a>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<a href="#fakeUrl" onclick="clearField(1);"><img src="/images/bt_clear.gif" style="vertical-align:middle; border:0" alt=""></a>
						&nbsp;&nbsp;&nbsp;
						<a href="#fakeUrl" onclick="saveMinwon(1);"><img src="/images/bt_reInsert.gif" style="vertical-align:middle; border:0" alt=""></a>
						&nbsp;&nbsp;&nbsp;
					</span>
				</div>
			</td>
		</tr>
	</table>
</div>
<!--// 민원등록 및 상세 -->
<!-- 조회결과 -->
<div class="box_list" style="width: 1020px; margin: 0 auto; padding: 0">
	<div style="overflow: hidden; padding: 0 0 5px 0; ">
		<!-- count -->
		<div style="float: left; padding: 23px 0 0; width: 250px"><b>◆ 조회 건수 / 총 민원 : <c:out value="${minwonCnt}"/>건 / <c:out value="${totalCnt}"/>건</b></div>
		<!-- //count -->
		<!-- oz print -->
		<div style="float: left; width: 640px; padding-left: 130px">
			<table class="tb_view_left" style="width: 640px;">
				<col width="80px"> 
				<col width="130px">
				<col width="80px">
				<col width="130px">
				<col width="80px">
				<col width="200px">
				<tr>
					<th>조출당직</th>
					<td><input type="text" name="morningWorker" id="morningWorker" value="" maxlength="3" style="width: 60px; vertical-align: middle;" /> </td>
					<th>점심당직</th>
					<td><input type="text" name="lunchWorker" id="lunchWorker" value="" maxlength="7" style="width: 110px; vertical-align: middle;" /> </td>
					<th>저녁당직</th>
					<td>
						<input type="text" name="dinnerWorker" id="dinnerWorker" value="" maxlength="3"  style="width: 60px; vertical-align: middle;"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<a href="#fakeUrl" onclick="fn_oz_print();"><img src="/images/bt_print.gif" style="vertical-align: middle; border: 0;" alt="출력"></a> 
					</td>
				</tr>
			</table>
		</div>
		<!-- //oz print -->
	</div>
	<table class="tb_list_a_5" style="width: 1020px">
		<colgroup>
			<col width="80px">
			<col width="110px">
			<col width="315px">
			<col width="100px">
			<col width="95px">
			<col width="85px">
			<col width="65px">
			<col width="70px">
			<col width="70px">
			<col width="30px">
		</colgroup>
		<tr>
			<th>접수일시</th>
			<th>독 자 명</th>
			<th>주 &nbsp; &nbsp; &nbsp; 소</th>
			<th>연 락 처</th>	
			<th>민원구분</th>
			<th>지 국 명</th>
			<th>통화시간</th>
			<th>통 화 자</th>
			<th>접 수 자</th>
			<th>&nbsp;</th>
		</tr>
		<c:choose>
			<c:when test="${empty minwonList}">
				<tr><td colspan="10" align="center">검색 결과가 없습니다.</td></tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${minwonList}" var="list" varStatus="i">
					<tr class="mover" onclick="retrieveMinwonDetail('${list.MINWONNO}','${list.MINWONDT}', '${list.BOSEQ}', '${list.READNM}', '${list.TEL}', '${list.ADDR}', '${list.MINWONCD1}', '${list.MINWONCD2}', '${list.MINWONNM2}', '${list.NAME}', '${list.JIKUK_TEL}', '${list.JIKUK_HANDY}', '${list.CALLUSER}', '${i.index}', '${list.CALLTM}', '${list.TODAYYN}');" >
						<td>
							${list.MINWONTM}
							<input type="hidden" id="minwonDesc${i.index}" value="${list.MINWONDESC}"/>
						</td>
						<td style="text-align: left;">
							<c:choose>
								<c:when test="${fn:length(list.READNM) > 7}">
									${fn:substring(list.READNM, 0, 7)}...
								</c:when>
								<c:otherwise>
									${list.READNM}
								</c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: left;">
							<c:choose>
								<c:when test="${fn:length(list.ADDR) > 28}">
									${fn:substring(list.ADDR, 0, 28)}...
								</c:when>
								<c:otherwise>
									${list.ADDR}
								</c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: left;">${list.TEL}</td>
						<td style="text-align: left;">${list.MINWONNM3}</td>
						<td style="text-align: left;">${list.NAME}</td>
						<td>
						<c:choose>
							<c:when test="${empty list.CALLTM}">
							</c:when>
							<c:otherwise>
								${fn:substring(list.CALLTM, 0, 2)}:${fn:substring(list.CALLTM, 2, 4)}
							</c:otherwise>
						</c:choose>
						</td>
						<td>
						<c:choose>
							<c:when test="${empty list.CALLTM}">
							</c:when>
							<c:otherwise>
								${list.CALLUSERNM}
							</c:otherwise>
						</c:choose>
						<td>${list.INPS}</td>
						<td>
						<c:choose>
							<c:when test="${list.SPCLYN eq 'Y'}">
								<img src="/images/spclMinwon.gif" alt="악성민원" style="vertical-align:middle; border:0" alt=""/>
							</c:when>
							<c:otherwise>
							</c:otherwise>
						</c:choose>
						</td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>
	<%@ include file="/common/paging.jsp"%>
</div>
<!--// 조회결과 -->
</form>
