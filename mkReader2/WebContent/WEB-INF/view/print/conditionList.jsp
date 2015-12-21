<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/validator.js"></script>
<script type="text/javascript">
	// 매체 종류 전체 선택/해제
	function checkControll(){
		var frm = document.frm;
		//전체선택 1 , 전체해제 2
		if(frm.controll.checked == true){
			if( frm.newsCd.length > 0 ){
				for(var i=0;i<frm.newsCd.length;i++){
					frm.newsCd[i].checked = true;
				}
			}			
		}else{
			if( frm.newsCd.length > 0 ){
				for(var i=0;i<frm.newsCd.length;i++){
					frm.newsCd[i].checked = false;
				}
			}	
		}
	}

	//숫자만 입력가능하도록 처리
	function onlyNumber()
	{
		if(
			(event.keyCode < 48 || event.keyCode > 57) 
				&& (event.keyCode < 96 || event.keyCode > 105) 
				&& event.keyCode != 8 && event.keyCode != 9 && event.keyCode != 46
		) {
			event.returnValue=false;
		}
	}

	function isValidate(frm) {
		
		var result = false;
		
		if( frm.newsCd.length > 0 ){
			for(var i=0;i<frm.newsCd.length;i++){
				if(frm.newsCd[i].checked){
					result = true;
				}
			}
		}else if( frm.newsCd.value != "" && frm.newsCd.checked ){
			result = true;
		}else{
			alert('신문명을 체크해주세요.');
			result = false;
		}

		if ( result ) {
			var listType = frm.listType.options[frm.listType.selectedIndex].value;

			if ( listType == "3" ) {			// 구독가격
				if ( ! frm.hiddenOpt1Text1.value ) {
					alert("구독가격 최소값을 입력해 주세요.(원 단위)");
					frm.hiddenOpt1Text1.focus();
					return false;
				} else if ( ! isNumber(frm.hiddenOpt1Text1.value) ) {
					alert("구독가격 최소값은 숫자만 입력 가능합니다.");
					frm.hiddenOpt1Text1.value = "";
					frm.hiddenOpt1Text1.focus();
					return false; 
				} else if ( ! frm.hiddenOpt1Text2.value ) {
					alert("구독가격 최대값을 입력해 주세요.(원 단위)");
					frm.hiddenOpt1Text2.focus();
					return false;
				} else if ( ! isNumber(frm.hiddenOpt1Text2.value) ) {
					alert("구독가격 최대값은 숫자만 입력 가능합니다.");
					frm.hiddenOpt1Text2.value = "";
					frm.hiddenOpt1Text2.focus();
					return false;
				} else if ( Number(frm.hiddenOpt1Text1.value) > Number(frm.hiddenOpt1Text2.value) ) {
					alert("구독가격 최소값이 최대값보다 클 수 없습니다. 다시 입력해주세요.");
					frm.hiddenOpt1Text1.value = "";
					frm.hiddenOpt1Text2.value = "";
					frm.hiddenOpt1Text1.focus();
					return false;
				}
				/*
			} else if ( listType == "4" ) {		// 확장자별
				if ( ! frm.hiddenOpt2Text3.value ) {
					alert("확장자를 입력해 주세요.");
					frm.hiddenOpt2Text3.focus();
					return false;
				}
				*/
			} else if ( listType == "5" ) {		// 유가월별
				if ( ! frm.hiddenOpt1Text1.value ) {
					alert("유가월을 입력해 주세요.(ex:201201)");
					frm.hiddenOpt1Text1.focus();
					return false;
				} else if ( ! isNumber(frm.hiddenOpt1Text1.value) ) {
					alert("유가월은 숫자만 입력 가능합니다.");
					frm.hiddenOpt1Text1.value = "";
					frm.hiddenOpt1Text1.focus();
					return false;
				} else if ( frm.hiddenOpt1Text1.value.length != 6 ) {
					alert("유가월은 숫자 6자리로 입력해 주세요.");
					frm.hiddenOpt1Text1.focus();
					return false;
				}
				/*
			} else if ( listType == "6" ) {		// 독자유형
				if ( frm.hiddenOpt2Sel2.selectedIndex == 0 ) {
					alert("독자유형을 선택해 주세요.");
					frm.hiddenOpt2Sel2.focus();
					return false;
				}
			} else if ( listType == "7" ) {		// 수금방법
				if ( frm.hiddenOpt2Sel1.selectedIndex == 0 ) {
					alert("수금방법을 선택해 주세요.");
					frm.hiddenOpt2Sel1.focus();
					return false;
				}
				*/
			} else if ( listType == "14" ) {		// 수금개월
				if ( ! frm.hiddenOpt1Text1.value ) {
					alert("수금개월을 입력해 주세요.(개월 단위)");
					frm.hiddenOpt1Text1.focus();
					return false;
				} else if ( ! isNumber(frm.hiddenOpt1Text1.value) ) {
					alert("수금개월은 숫자만 입력 가능합니다.");
					frm.hiddenOpt1Text1.value = "";
					frm.hiddenOpt1Text1.focus();
					return false;
				}
			} else if ( listType == "16" ) {		// 다부수
				if ( ! frm.hiddenOpt1Text1.value ) {
					alert("부수를 입력해 주세요.(부 단위)");
					frm.hiddenOpt1Text1.focus();
					return false;
				} else if ( ! isNumber(frm.hiddenOpt1Text1.value) ) {
					alert("부수는 숫자만 입력 가능합니다.");
					frm.hiddenOpt1Text1.value = "";
					frm.hiddenOpt1Text1.focus();
					return false;
				}
			}

			return true;
		}
		else {
			return false;
		}		
	}
	
	// 조회
	function search(){
		var frm = document.frm;
	
		if( isValidate(frm) ){			
			frm.action = "./conditionList.do";
			frm.submit();
		}
	}

	// 조건영역에서 동적으로 사용되는 element 처리함수 
	function setHiddenOptionDisplay(yyyymmddName, hiddenOpt1Name, hiddenOpt2Name, tr1, tr2, sel1, sel2, sel3, sel4, text1, text2, text3) {

		document.getElementById("windbar").style.display = "none";
		document.getElementById("info1").style.display = "none";		
		
		// setting 
		if ( document.getElementById("yyyymmddName") ) {
			document.getElementById("yyyymmddName").innerHTML = yyyymmddName;	
		}
		if ( document.getElementById("hiddenOpt1Name") ) {
			document.getElementById("hiddenOpt1Name").innerHTML = hiddenOpt1Name;
		}
		if ( document.getElementById("hiddenOpt2Name") ) {
			document.getElementById("hiddenOpt2Name").innerHTML = hiddenOpt2Name;
		}
		if ( document.getElementById("hiddenOpt1Tr") ) {
			document.getElementById("hiddenOpt1Tr").style.display = (tr1 == true) ? "block" : "none";
					}
		if ( document.getElementById("hiddenOpt2Tr") ) {
			document.getElementById("hiddenOpt2Tr").style.display = (tr2 == true) ? "block" : "none";
		}
		if ( document.getElementById("hiddenOpt2Sel1") ) {
			document.getElementById("hiddenOpt2Sel1").style.display = (sel1 == true) ? "block" : "none";
		}
		if ( document.getElementById("hiddenOpt2Sel2") ) {
			document.getElementById("hiddenOpt2Sel2").style.display = (sel2 == true) ? "block" : "none";
		}
		if ( document.getElementById("hiddenOpt2Sel3") ) {
			document.getElementById("hiddenOpt2Sel3").style.display = (sel3 == true) ? "block" : "none";
		}
		if ( document.getElementById("hiddenOpt2Sel4") ) {
			document.getElementById("hiddenOpt2Sel4").style.display = (sel4 == true) ? "block" : "none";
		}
		if ( document.getElementById("hiddenOpt1Text1") ) {
			document.getElementById("hiddenOpt1Text1").style.display = (text1 == true) ? "block" : "none";		// 숫자형만 입력가능
		}
		if ( document.getElementById("hiddenOpt1Text2") ) {	
			document.getElementById("hiddenOpt1Text2").style.display = (text2 == true) ? "block" : "none";		// 숫자형만 입력가능
		}
		if ( document.getElementById("hiddenOpt2Text3") ) {
			document.getElementById("hiddenOpt2Text3").style.display = (text3 == true) ? "block" : "none";		// 문자형도 가능
		}
	}

	// 명단타입 변경시 조건 변경처리
	function changeListType(listType, initilize) {

		if ( initilize ) {
			document.getElementById("hiddenOpt2Sel1").selectedIndex = 0;
			document.getElementById("hiddenOpt2Sel2").selectedIndex = 0;
			document.getElementById("hiddenOpt2Sel3").selectedIndex = 0;
			document.getElementById("hiddenOpt2Sel4").selectedIndex = 0;
			document.getElementById("hiddenOpt1Text1").value = "";
			document.getElementById("hiddenOpt1Text2").value = "";
			document.getElementById("hiddenOpt2Text3").value = "";
		}

		if ( listType == "1" ) {			setHiddenOptionDisplay("확장일자", "", 		"",	false, false, false, false, false, false, false, false, false);	// 확장일자
		} else if ( listType == "3" ) {		setHiddenOptionDisplay("구독일자", "구독가격", "",	true, false, false, false, false, false, true, true, false);		// 구독가격
												document.getElementById("windbar").style.display = "block";
		} else if ( listType == "4" ) {		setHiddenOptionDisplay("구독일자", "", "신청경로<br />확장자명", false, true, false, false, true, true, false, false, false);	// 확장자별
		} else if ( listType == "5" ) {		setHiddenOptionDisplay("구독일자", "유가월", 	"", true, false, false, false, false, false, true, false, false);	// 유가월별
												document.getElementById("info1").style.display = "block";
		} else if ( listType == "6" ) {		setHiddenOptionDisplay("구독일자", "", "독자유형", false, true, false, true, false, false, false, false, false);	// 독자유형
		} else if ( listType == "7" ) {		setHiddenOptionDisplay("구독일자", "", "수금방법", false, true, true, false, false, false, false, false, false);	// 수금방법
		} else if ( listType == "14" ) {	setHiddenOptionDisplay("처리일자", "수금개월", "",	true, false, false, false, false, false, true, false, false);	// 수금개월
		} else if ( listType == "16" ) {	setHiddenOptionDisplay("구독일자", "다부수", 	"",	true, false, false, false, false, false, true, false, false);	// 다부수
		} else if ( listType == "17" || listType == "18" || listType == "19" || listType == "20" || listType == "21") {	
											// 재무,결손,휴독,선불,미수독자
											setHiddenOptionDisplay("처리일자", "", 		"",	false, false, false, false, false, false, false, false, false);	// 
		} else {							setHiddenOptionDisplay("구독일자", "", 		"",	false, false, false, false, false, false, false, false, false);	// others
		}
	}

	// 오즈 출력
	function ozPrint() {
		actUrl = "/print/print/ozConditionList.do";
		window.open('','ozConditionList','width=1000, height=800, toolbar=no, menubar=no, location=no, status=no, resizable=1, scrollbars=no');

		frm.target = "ozConditionList";
		frm.action = actUrl;
		frm.submit();
		frm.target ="";
	}
	

	window.onload = function () {
		var listType = "${listType}";

		changeListType(listType, false);

		<c:if test="${not empty resultList }" > 
			document.getElementById("list").style.display = "block";
		</c:if>
	}

	
	var now = new Date();

	//기간설정
	var beforeDate = new Date("${fn:substring(yymm,0,4)}", parseInt("${fn:substring(yymm,4,6)}") - 1);
	var afterDate = new Date("${fn:substring(yymm,0,4)}", "${fn:substring(yymm,4,6)}" );
	
	
</script>
<div><span class="subTitle">조건별명단</span></div>
<!-- search conditions -->
<form id="frm" name="frm" method="post">
<div>
	<!-- search conditions(left) -->
	<div style="float: left; width: 400px; padding-right: 10px;">
		<table class="tb_search" style="width: 400px;">
			<colgroup>
				<col width="80px">
				<col width="320px">
			</colgroup>
			<tr>
				<th>명단타입</th>
				<td style="text-align: left; padding-left: 10px;">
					<select id="listType" name="listType" onchange="changeListType(this.value, true);" style="vertical-align: middle;">
						<option value="1" <c:if test="${listType eq '1'}">selected</c:if>>확장일자</option>
						<option value="2" <c:if test="${listType eq '2'}">selected</c:if>>구역독자</option>
						<option value="3" <c:if test="${listType eq '3'}">selected</c:if>>구독가격</option>
						<option value="4" <c:if test="${listType eq '4'}">selected</c:if>>신청경로</option>
						<option value="5" <c:if test="${listType eq '5'}">selected</c:if>>유가월별</option>
						<option value="6" <c:if test="${listType eq '6'}">selected</c:if>>독자유형</option>
						<option value="7" <c:if test="${listType eq '7'}">selected</c:if>>수금방법</option>
						<!-- <option value="8" <c:if test="${listType eq '8'}">selected</c:if>>주거구분</option> -->
						<!-- <option value="9" <c:if test="${listType eq '9'}">selected</c:if>>배달장소</option> -->
						<!-- <option value="10" <c:if test="${listType eq '10'}">selected</c:if>>판촉물</option> -->
						<option value="11" <c:if test="${listType eq '11'}">selected</c:if>>구독일자</option>
						<!-- <option value="12" <c:if test="${listType eq '12'}">selected</c:if>>휴대폰</option> -->
						<!-- <option value="13" <c:if test="${listType eq '13'}">selected</c:if>>비고내용</option> -->
						<option value="14" <c:if test="${listType eq '14'}">selected</c:if>>수금개월</option>
						<!-- <option value="15" <c:if test="${listType eq '15'}">selected</c:if>>주소코드</option> -->														
						<option value="16" <c:if test="${listType eq '16'}">selected</c:if>>다부수독자</option>
						<option value="17" <c:if test="${listType eq '17'}">selected</c:if>>재무독자</option>
						<option value="18" <c:if test="${listType eq '18'}">selected</c:if>>결손독자</option>
						<option value="19" <c:if test="${listType eq '19'}">selected</c:if>>휴독독자</option>
						<option value="20" <c:if test="${listType eq '20'}">selected</c:if>>선불독자</option>
						<option value="21" <c:if test="${listType eq '21'}">selected</c:if>>미수독자</option>
					</select>
					&nbsp;
					<img src="/images/bt_joh.gif" style="vertical-align: middle; border: 0; cursor: pointer;" onclick="search();" /> 
					<img src="/images/bt_print.gif" style="vertical-align: middle; border: 0; cursor: pointer;" onclick="ozPrint();">
				</td>
			</tr>
			<tr>
				<th>확장일자</th>
				<td style="text-align: left; padding-left: 10px;">
					<input type="text" id="fromYyyymmdd" name="fromYyyymmdd" value='<c:out value="${fromYyyymmdd}" />' readonly onclick="Calendar(this)" style="width: 80px;"/> ~ 
					<input type="text" id="toYyyymmdd" name="toYyyymmdd" value='<c:out value="${toYyyymmdd}" />' readonly onclick="Calendar(this)" style="width: 80px;"/>
				</td>
			</tr>
			<tr>
				<th>구 &nbsp; 역</th>
				<td style="text-align: left; padding-left: 10px;">
					<select id="fromGno" name="fromGno">
						<c:forEach var="list" items="${gnoList}">
							<option value="${list.GNO}"<c:if test="${fromGno eq list.GNO}">selected</c:if>>
								<c:out value="${list.GNO}" />
							</option>
						</c:forEach>
					</select> 
					<select  id="toGno" name="toGno">
						<c:forEach var="list" items="${gnoList}" varStatus="status">
							<option value="${list.GNO}"<c:if test="${toGno eq list.GNO or (empty toGno and status.last)}">selected</c:if>>
								<c:out value="${list.GNO}" />
							</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr id="hiddenOpt1Tr" style="display:none;">
				<td id="hiddenOpt1Name"></td>
				<td style="text-align: left; padding-left: 10px;">
					<input type="text" id="hiddenOpt1Text1" name="hiddenOpt1Text1" value="${hiddenOpt1Text1}" maxlength="7" onkeydown="return onlyNumber();" />
					<span id="windbar">~</span>
					<span id="info1">(201201 -&gt; 2012년 1월)</span>
					<input type="text"  id="hiddenOpt1Text2" name="hiddenOpt1Text2" value="${hiddenOpt1Text2}" maxlength="7" onkeydown="return onlyNumber();" />
				</td>
			</tr>
			<tr id="hiddenOpt2Tr" style="display:none;">
				<td id="hiddenOpt2Name"></td>
				<td style="text-align: left; padding-left: 10px;">
					<select id="hiddenOpt2Sel1" name="hiddenOpt2Sel1">
						<option value="">전체</option>
						<c:forEach items="${sgTypeList}" var="list">
							<option value="${list.CODE}" <c:if test="${list.CODE eq hiddenOpt2Sel1}">selected</c:if>>${list.CNAME}</option>
						</c:forEach>
					</select>
					<select id="hiddenOpt2Sel2" name="hiddenOpt2Sel2">
						<option value="">전체</option>
						<c:forEach items="${readerTypeList}" var="list">
							<option value="${list.CODE}" <c:if test="${list.CODE eq hiddenOpt2Sel2}">selected</c:if>>${list.CNAME}</option>
						</c:forEach>
					</select>
					<select  id="hiddenOpt2Sel3" name="hiddenOpt2Sel3" onchange="search();">
						<option value="">전체</option>
						<c:forEach items="${hjTypeList}" var="list">
							<option value="${list.CODE}" <c:if test="${list.CODE eq hiddenOpt2Sel3}">selected</c:if>>${list.CNAME}</option>
						</c:forEach>
					</select>
					<select id="hiddenOpt2Sel4" name="hiddenOpt2Sel4">
						<option value="">전체</option>
						<c:forEach items="${hjPsNmList}" var="list">
							<option value="${list.CNAME}" <c:if test="${list.CNAME eq hiddenOpt2Sel4}">selected</c:if>>${list.CNAME}</option>
						</c:forEach>
					</select>
					<input type="text" id="hiddenOpt2Text3" name="hiddenOpt2Text3" value="${hiddenOpt2Text3}" maxlength="50" />
				</td>
			</tr>
			<tr>
				<th>정렬방식</th>
				<td style="text-align: left; padding-left: 10px;">
					<input type="radio" id="gubun" name="order" checked="checked" value="gno" <c:if test="${empty order or order eq 'gno'}">checked="checked"</c:if> style="vertical-align: middle; border: 0" />&nbsp;구역별
					<input type="radio" id="gubun" name="order" value="readno" <c:if test="${order eq 'readno'}">checked="checked"</c:if>  style="vertical-align: middle; border: 0"/>&nbsp;독자번호별
					<input type="radio" id="gubun" name="order" value="hjdt" <c:if test="${order eq 'hjdt'}">checked="checked"</c:if> style="vertical-align: middle; border: 0" />&nbsp;확장일자별
					<br />
					<input type="radio" id="gubun" name="order" value="aplcdt" <c:if test="${order eq 'aplcdt'}">checked="checked"</c:if>  style="vertical-align: middle; border: 0"/>&nbsp;구독일자별
					<input type="radio" id="gubun" name="order" value="uprice" <c:if test="${order eq 'uprice'}">checked="checked"</c:if>  style="vertical-align: middle; border: 0"/>&nbsp;구독단가별
				</td>
			</tr>																												
		</table>
	</div>
	<!-- //search conditions(left) -->
	<!-- search conditions(right) -->
	<div style="float: left;">
		<div style="border: 1px solid #e5e5e5; padding: 5px; width: 340px">
			<table class="tb_list_a" style="width: 330px">
				<colgroup>
					<col width="25px;">
					<col width="65px;">
					<col width="80px;">
					<col width="170px;">
				</colgroup>
				<tr>
					<th width="20"></th>
					<th><input type="checkbox" id="controll" name="controll"  onclick="checkControll();" style="border: 0;"> </th>
					<th>코드</th>
					<th>신문명</th>
				</tr>
				<tr  id=div1 style="display:none;">
					<td colspan="4"><input type="checkbox" id="newsCd" name="newsCd" value="0" /></td>
				</tr>
			</table>
			<div style="width: 330px; height:115px;overflow-y:scroll; border: 0px solid red; margin: 0 auto;">
			<table class="tb_list_a" style="width: 313px">
				<colgroup>
					<col width="25px;">
					<col width="65px;">
					<col width="80px;">
					<col width="153px;">
				</colgroup>
				<c:forEach var="list" items="${newsCodeList}" varStatus="status">
					<tr>
						<td>${status.count}</td>
						<td>
							<input type="checkbox" id="newsCd" name="newsCd" value="${list.CODE}"   style="border: 0;"
								<c:choose>
								<%-- 매일경제 기본으로 체크 --%>
								<c:when test="${empty newsCd}">
									<c:if test="${list.CODE eq '100'}"> checked
									</c:if>
								</c:when>
								<%-- 폼으로 넘어온 값 체크--%>
								<c:otherwise>
									<c:forEach items="${newsCd}" varStatus="counter">
										<c:if test="${newsCd[counter.index] eq list.CODE}"> checked
										</c:if>
									</c:forEach>
								</c:otherwise>
								</c:choose>
							/>
						</td>
						<td><c:out value="${list.YNAME}" /></td>
						<td><c:out value="${list.CNAME}" /></td>
					</tr>			
				</c:forEach>
			</table>
			</div>
		</div>
	</div>
	<!-- //search conditions(right) -->
</div>
</form>
<!-- //search conditions -->
<c:set var="reader" value="0" />					
<c:set var="readerQty" value="0" />						
<c:set var="stu" value="0" />					
<c:set var="stuQty" value="0" />						
<c:set var="etc" value="0" />					
<c:set var="etcQty" value="0" />						
<c:set var="total" value="0" />					
<c:set var="totalQty" value="0" />		
<c:forEach var="list" items="${resultList}" varStatus="status">
	<c:if test="${list.READTYPENM == '일반'}">
		    <c:set var="reader" value="${reader + 1}" />	
			<c:set var="readerQty" value="${readerQty + list.QTY}" />		
	</c:if>
	<c:if test="${list.READTYPENM == '학생(지국)' || list.READTYPENM == '학생(본사)'}">
		    <c:set var="stu" value="${stu + 1}" />	
			<c:set var="stuQty" value="${stuQty + list.QTY}" />		
	</c:if>
	<c:if test="${list.READTYPENM != '일반' && list.READTYPENM != '학생(지국)' && list.READTYPENM != '학생(본사)'}">
		 <c:set var="etc" value="${etc + 1}" />	
		<c:set var="etcQty" value="${etcQty + list.QTY}" />				
	</c:if>
	<c:set var="total" value="${total + 1}" />	
	<c:set var="totalQty" value="${totalQty + list.QTY}" />		
 </c:forEach>
 <!-- count -->
 <div style="clear: both; width: 1020px; text-align: left; font-weight: bold; padding: 20px 0 5px 0">
 	◆ 일반: <fmt:formatNumber value="${readerQty}" type="number" />부&nbsp;&nbsp;&nbsp;학생: <fmt:formatNumber value="${stuQty}" type="number" />부&nbsp;&nbsp;&nbsp;기타: <fmt:formatNumber value="${etcQty}" type="number" />부&nbsp;&nbsp;&nbsp;총부수: <fmt:formatNumber value="${totalQty}" type="number" />부
 </div>
 <!-- //count -->
<!-- list -->
<div style="width: 1020px;">
	<div id="list" style="display:none; overflow-x: auto; overflow-y: scroll; height: 400px;">
	<table class="tb_list_a" style="width:1330px">
		<colgroup>
			<col width="135px;">
			<col width="80px;">
			<col width="180px;">
			<col width="240px;">
			<col width="100px;">
			<col width="100px;">
			<col width="50px;">
			<col width="40px;">
			<col width="60px;">
			<col width="40px;">
			<col width="65px;">
			<col width="90px;">
			<col width="70px;">
			<col width="90px;">
		</colgroup>
		<tr>
		    <th>독자번호</th>
		    <th>구분</th>
		    <th>독자명</th>
		    <th>주소</th>
		    <th>전화번호</th>
		    <th>휴대폰</th>
		    <th>매체</th>
		    <th>부수</th>
		    <th>단가</th>
		    <th>수금</th>
		    <th>확장자</th>
		    <th>확장일자</th>
		    <th>유가월</th>
			<th>수금사항</th>
		</tr>
		<c:forEach var="list" items="${resultList}" varStatus="status">
			<tr> 
				<td style="text-align: left;"><c:out value="${list.GNO}" />-<c:out value="${list.READNO}" />-<c:out value="${list.BNO}" /></td>
				<td><c:out value="${list.READTYPENM}" /></td>
				<td style="text-align: left;">&nbsp;<c:out value="${list.READNM}" /></td>
			    <td style="text-align: left;"><c:out value="${list.DLVADRS1}" />&nbsp;<c:out value="${list.DLVADRS2}" /></td>
			    <td style="text-align: left;"><c:out value="${list.HOMETEL1}" />-<c:out value="${list.HOMETEL2}" />-<c:out value="${list.HOMETEL3}" /></td>
			    <td style="text-align: left;"><c:out value="${list.MOBILE1}" />-<c:out value="${list.MOBILE2}" />-<c:out value="${list.MOBILE3}" /></td>
			    <td><c:out value="${list.NEWSNM}" /></td>
			    <td><fmt:formatNumber value="${list.QTY}" type="number" /></td>
			    <td><fmt:formatNumber value="${list.UPRICE}" type="number" /></td>
			    <td><c:out value="${list.SGTYPENM}" /></td>
			    <td><c:out value="${list.HJPSNM}" /></td>							    
			    <td>
			    	<c:if test="${fn:length(list.HJDT) == 8}">
			    		<c:out value="${fn:substring(list.HJDT,2,4)}" />/<c:out value="${fn:substring(list.HJDT,4,6)}" />/<c:out value="${fn:substring(list.HJDT,6,8)}" />
			    	</c:if>
			    </td>
			    <td>
			    	<c:if test="${fn:length(list.SGBGMM) == 6}">
			    		<c:out value="${fn:substring(list.SGBGMM,2,4)}" />/<c:out value="${fn:substring(list.SGBGMM,4,6)}" />
			    	</c:if>
			    </td>
			    <td><c:out value="${list.SGHIST}" /></td>
			</tr>
		 </c:forEach>
	</table>
	</div>			
</div>
<!-- //list -->

