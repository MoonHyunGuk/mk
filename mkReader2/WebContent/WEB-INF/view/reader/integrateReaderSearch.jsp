<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ page import="com.mkreader.security.ISiteConstant" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">

	var xmlHttp;
	var completeDiv;
	var inputField;
	var nameTable;
	var nameTableBody;
	
	/*----------------------------------------------------------------------
	 * Desc   : 독자정보를 조회 한다.
	 * Auth   : 박윤철
	 *----------------------------------------------------------------------*/
	function fn_search(){

		if(!chkValidation()){return;}

		$("pageNo").value = "1";
		integSearchForm.action="/reader/minwon/integReaderSearch.do";
		integSearchForm.target="_self";
		integSearchForm.submit();
		jQuery("#prcssDiv").show();
	}

	/*----------------------------------------------------------------------
	 * Desc   : 유효성 체크
	 * Auth   : 박윤철
	 *----------------------------------------------------------------------*/
	function chkValidation(){
		if($("searchValue").value == "" && $("addr").value == "" && $("jikukName").value == "" && $("readTypCb").value == "" && $("sgTypeCb").value == "" && $("dateType").value == ""){
			if($("area1").value == "" && $("area").value == "" && $("agencyType").value == "" && $("part").value == "" && $("agencyArea").value == "" && $("manager").value == ""){
				alert("최소 1개 이상의 조회 조건이 필요 합니다.");
				return false;
			}
		}else if($("dateType").value != ""){
			if($("fromDate").value == "" || $("toDate").value == ""){
				alert("조회기간을 입력해 주세요.");
				return false;
			}
		}
		return true;
	}
	
	/*----------------------------------------------------------------------
	 * Desc   : 독자 상세보기
	 * Auth   : 박윤철
	 *----------------------------------------------------------------------*/
    function detailView(readno){
    	
		 $("readno").value = readno;
		 
		var left = (screen.width)?(screen.width - 830)/2 : 10;
		var top = (screen.height)?(screen.height - 790)/2 : 10;
		var winStyle = "width=1024,height=820,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=0";
		var newWin = window.open("", "detailReaderInfo", winStyle);
		
		integSearchForm.target = "detailReaderInfo"; 
		integSearchForm.action = "/reader/minwon/popReaderDetailInfo.do";
		integSearchForm.submit();
    }

	/*----------------------------------------------------------------------
	 * Desc   : 페이징 펑션
	 * Auth   : 박윤철
	 *----------------------------------------------------------------------*/
	function moveTo(where, seq) {
		
		$("pageNo").value = seq;
		integSearchForm.action="/reader/minwon/integReaderSearch.do";
		integSearchForm.target="_self";
		integSearchForm.submit();
		jQuery("#prcssDiv").show();
	}
	
	/*----------------------------------------------------------------------
	 * Desc   : 2차콤보 세팅
	 * Auth   : 박윤철
	 *----------------------------------------------------------------------*/
	function setCombo(typ){

		if( typ=="area1" ){
			if( $("area1").value == "002" ){
				$("area").style.visibility = "visible" ;
			}else{
				$("area").value = "";
				$("area").style.visibility = "hidden" ;
			}
		}else if( typ == "agencyType" ){
			if( $("agencyType").value == "101" || $("agencyType").value == "102" ){
				$("part").style.visibility = "visible" ;
			}else{
				$("part").value = "" ;
				$("part").style.visibility = "hidden" ;
			}
		}else if( typ == "dateType"){
			if ( $("dateType").value == "" ){
				$("fromDate").value = "";
				$("toDate").value = "";
				$("fromToArea").style.visibility = "hidden" ;			
			}else{
				$("fromToArea").style.visibility = "visible" ;			
			}
		}
		
	}

	/*----------------------------------------------------------------------
	 * Desc   : 화면 초기화 (콤보 세팅)
	 * Auth   : 박윤철
	 *----------------------------------------------------------------------*/
	function setOnload(){
		setCombo("area1");
		setCombo("agencyType");
		setCombo("dateType");
		$("searchValue").focus();
		
	}
	
	/*----------------------------------------------------------------------
	 * Desc   : 지국명 자동완성 호출
	 * Auth   : 박윤철
	 *----------------------------------------------------------------------*/
	 function findJikuk() {
		// 엔터키 입력시 조회
		if(event.keyCode=="13"){
			if(inputField.value.length > 0){
				clearJikuk();
				search();
				return;
			}
		// 방향키 입력시 상하이동
		}else if(event.keyCode=="40"){
			if($("jikukNameTableBody").firstChild != null){
				$("jikukNameTableBody").firstChild.firstChild.focus();
				return;
			}
		}
		
		// 기타키 입력시 자동완성 호출
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
    	clearJikuk();
        var size = autoComplete.jikukNamelist.length;
        
        setOffsets();
        var row, cell, txtNode;

        for (var i = 0; i < size; i++) {
            var nextNode = autoComplete.jikukNamelist[i].NAME;

            row = document.createElement("tr");
            cell = document.createElement("td");
            
            cell.setAttribute = function() {this.className='mouseOut';};
            cell.setAttribute("border", "0");
            cell.onblur = function() {this.className='mouseOut';};
            cell.onfocus = function() {this.className='mouseOver'; inputField.value = this.firstChild.nodeValue;};
            cell.onmouseout = function() {this.className='mouseOut';};
            cell.onmouseover = function() {this.className='mouseOver'; inputField.value = this.firstChild.nodeValue;};
            
            cell.onkeyup = function() { changeNode(this.parentNode);};
            cell.onclick = function() { populateName(this);};

            txtNode = document.createTextNode(nextNode);
            cell.appendChild(txtNode);
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
        search();
    }
    
	//window.attachEvent("onload", setOnload);
	
	/** Jquery setting */
	jQuery.noConflict();
	jQuery(document).ready(function($) {
		setOnload();
		$("#prcssDiv").hide();
	});
</script>
<div><span class="subTitle">통합독자리스트</span></div>
<form id="integSearchForm" name="integSearchForm" action="" method="post" enctype="multipart/form-data">
<!-- search conditions -->
<div>
 	<table class="tb_search" style="width: 1020px">
 		<colgroup>
			<col width="70px">
			<col width="170px">
			<col width="70px">
			<col width="170px">
			<col width="70px">
			<col width="100px">
			<col width="70px">
			<col width="120px">
			<col width="70px">
			<col width="110px">
 		</colgroup>
		<tr>
			<th>부 서</th>
			<td style="padding-left: 3px">
				<select name="area1" id="area1" onchange="setCombo('area1')" style="width: 80px">
					<option value = "">전체</option>
					<c:forEach items="${areaCb}" var="area"  varStatus="status">
						<option value="${area.CODE}"  <c:if test="${area.CODE eq param.area1}">selected</c:if>>${area.CNAME}</option>
				 	</c:forEach>
			  	</select>
				<select name="area" id="area" style="visibility:hidden;">
					<option value = "">전체</option>
					<c:forEach items="${areaCb2}" var="area2"  varStatus="status">
						<option value="${area2.CODE}"  <c:if test="${area2.CODE eq param.area}">selected</c:if>>${area2.CNAME}</option>
				 	</c:forEach>
			  	</select>
			</td>
			<th>지국구분</th>
			<td>
				<select name="agencyType" id="agencyType" onchange="setCombo('agencyType')"  style="width: 80px">
					<option value = "">전체</option>
					<c:forEach items="${agencyTypeCb}" var="agcType"  varStatus="status">
						<option value="${agcType.CODE}"  <c:if test="${agcType.CODE eq param.agencyType}">selected</c:if>>${agcType.CNAME}</option>
				 	</c:forEach>
			  	</select>&nbsp;
				<select name="part" id="part" style="visibility:hidden ;">
					<option value = "">전체</option>
					<c:forEach items="${partCb}" var="agcPart"  varStatus="status">
						<option value="${agcPart.CODE}"  <c:if test="${agcPart.CODE eq param.part}">selected</c:if>>${agcPart.CNAME}</option>
				 	</c:forEach>
			  	</select>
			</td>
			<th>지 역</th>
			<td>
				<select name="agencyArea" id="agencyArea" style="width: 70px;">
					<option value = "">전체</option>
					<c:forEach items="${agencyAreaCb}" var="agcArea"  varStatus="status">
						<option value="${agcArea.CODE}"  <c:if test="${agcArea.CODE eq param.agencyArea}">selected</c:if>>${agcArea.CNAME}</option>
				 	</c:forEach>
				</select>
			</td>
			<th>담당자</th>
			<td >
				<select name="manager" id="manager" style="width: 100px;">
					<option value = "">전체</option>
						<c:forEach items="${mngCb}" var="mng"  varStatus="status">
							<option value="${mng.MANAGER}"  <c:if test="${mng.MANAGER eq param.manager}">selected</c:if>>${mng.MANAGER} 담당</option>
					 	</c:forEach>
			 	    <option value='0' <c:if test="${0 eq manager}">selected</c:if>>미지정</option>
			  	</select>
			</td>
			<th>지국명</th>
			<td>
				<input name="jikukName" id="jikukName" type="text" value="<c:out value="${param.jikukName}"/>" size="10" onkeyup="findJikuk()"/>
			    <div style="position:absolute;" id="jikukNamePopup" >
			        <table id="jikukNameTable" bgcolor="#FFFAFA" border="0" cellspacing="0" cellpadding="0">            
			            <tbody id="jikukNameTableBody"></tbody>
			        </table>
			    </div>	
			</td>
		</tr>
		<tr>
			<th>독자유형</th>
			<td>
				<select name="readTypCb" id="readTypCb" class='box_90'>
					<option value = "">전체</option>
					<c:forEach items="${readTypCb}" var="readTyp">
						<option value="${readTyp.CODE}" <c:if test="${readTyp.CODE eq param.readTypCb}">selected</c:if>>${readTyp.CNAME}</option>
					</c:forEach>
				</select>
			</td>
			<th>수금방법</th>
			<td>
				<select name="sgTypeCb" id="sgTypeCb">
					<option value = "">전체</option>
					<c:forEach items="${sgTypeCb}" var="sgType">
						<option value="${sgType.CODE}" <c:if test="${sgType.CODE eq param.sgTypeCb}">selected</c:if>>${sgType.CNAME}</option>
					</c:forEach> 
				</select>
			</td>
			<th>구독상태</th>
			<td>
				<select id="status" name="status">
					<option value="1" <c:if test="${empty param.status or param.status eq '1' }"> selected </c:if>>전체</option>
					<option value="2" <c:if test="${param.status eq '2' }"> selected </c:if>>정상</option>
					<option value="3" <c:if test="${param.status eq '3' }"> selected </c:if>>중지</option>
				</select>
			</td>
			<th>조회기간</th>
			<td colspan="3">
				<select id="dateType" name="dateType" onchange="setCombo('dateType')" >
					<option value="" <c:if test="${empty param.dateType }"> selected </c:if>>선택</option>
					<option value="1" <c:if test="${param.dateType eq '1' }"> selected </c:if>>확장일</option>
					<option value="2" <c:if test="${param.dateType eq '2' }"> selected </c:if>>중지일</option>
				</select>
				&nbsp;
				<span id="fromToArea" style="visibility: hidden;">
				<input type="text" id="fromDate" name="fromDate"  value="<c:out value='${param.fromDate}' />" readonly="readonly" onclick="Calendar(this)" style="text-align: center; width: 55px"/>
				~ 
				<input type="text" id="toDate" name="toDate"  value="<c:out value='${param.toDate}' />" readonly="readonly" onclick="Calendar(this)" style="text-align: center; width: 55px"/>
				</span>
			</td>
		</tr>
		<tr>
			<th>신문명</th>
			<td>
				<select name="newsCd" id="newsCd" class='box_90'>
					<c:forEach items="${newsCb}" var="newsCd" varStatus="i">
						<option value="${newsCd.CODE }" <c:if test="${newsCd.CODE eq param.newsCd}">selected</c:if>>${newsCd.CNAME }</option>
					</c:forEach>
				</select>
			</td>
			<th>주 소</th>
			<td colspan="2">
				<input type="text" id="addr" name="addr" value="<c:out value='${param.addr}'/>" onkeydown="if(event.keyCode == 13){fn_search();}"style="width: 95%;"></input>
			</td>
			<td colspan="5" >
				<select id="searchType" name="searchType" class="box_90" style="vertical-align: middle;">
					<option value="all" <c:if test="${empty param.searchType || param.searchType eq 'all'}"> selected </c:if>>통합검색</option>
					<option value="readnm" <c:if test="${param.searchType eq 'readnm' }"> selected </c:if>>독자명</option>
					<option value="readno" <c:if test="${param.searchType eq 'readno' }"> selected </c:if>>독자번호</option>
					<option value="telno" <c:if test="${param.searchType eq 'telno' }"> selected </c:if>>전화번호</option>
				</select>
				&nbsp;&nbsp;
				<input type="text" id="searchValue" name="searchValue" onkeydown="if(event.keyCode == 13){fn_search(); }" value="<c:out value='${param.searchValue}' />" style="width: 265px; vertical-align: middle;"></input>
				&nbsp;&nbsp;
				<a href="#fakeUrl" onclick="fn_search();"><img src="/images/bt_search.gif" style="border: 0; vertical-align: middle;"></a>
			</td>
		</tr>
	</table>
</div>
<!-- //search conditions -->
<!-- count -->
<div style="font-weight: bold; padding: 15px 0 5px 10px;">
	◆ 조회건수 : <c:out value="${totalCount}"/>건
</div>
<!-- //count -->
<!-- list -->
<div class="box_list" style="padding-top: 0; margin: 0 auto;">
	<table class="tb_list_a_5" style="width: 1020px">
		<colgroup>
			<col width="80px">
			<col width="80px">
			<col width="60px">
			<col width="160px">
			<col width="45px">
			<col width="105px">
			<col width="105px">
			<col width="305px">
			<col width="80px">
		</colgroup>
		<tr>
			<th>지국</th>
			<th>독자번호</th>
			<th>매체명</th>
			<th>독자명</th>
			<th>부수</th>
			<th>전화번호</th>
			<th>핸드폰</th>
			<th>주소</th>
			<th>확장/중지</th>
		</tr>
		<c:choose>
			<c:when test="${empty readerList}">
				<tr>
					<td colspan="9">검색 결과가 없습니다.</td>
				</tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${readerList }" var="list" varStatus="i">
					<tr class="mover" onclick="detailView('${list.READNO}')" style="<c:if test="${list.BNO eq '999' }">color:#e74985;</c:if>" >
						<td>${list.JIKUKNM}</td>
						<td>${list.READNO}</td>
						<td>${list.NEWSNM}</td>
						<td><c:out value="${list.READNM}"/></td>
						<td>${list.QTY}</td>
						<td>${list.HOMETEL}</td>
						<td>${list.MOBILE}</td>
						<td>${list.ADDR}</td>
						<td>${fn:substring(list.HJDT,0,4) }-${fn:substring(list.HJDT,4,6) }-${fn:substring(list.HJDT,6,8) }</td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>
	<div><%@ include file="/common/paging.jsp"%></div>
	<input type=hidden id="pageNo" name="pageNo" value="${param.pageNo}" />
	<input type=hidden id="readno" name="readno" value="" />
</div>
<!-- //list -->
</form>
<!-- processing viewer -->
<div id="prcssDiv"  class="loingProcessDiv"><div><img src="/images/process4.gif"/></div></div>
<!-- //processing viewer --> 