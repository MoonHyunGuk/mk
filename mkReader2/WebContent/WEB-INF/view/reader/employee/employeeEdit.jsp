<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/ajaxUtil.js"></script>
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
		var left = (screen.width)?(screen.width - 1330)/2 : 10;
		var top = (screen.height)?(screen.height - 200)/2 : 10;
		var winStyle = "width=400,height=500,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		var newWin = window.open("", "pop_addr", winStyle);
		employeeEditForm.target = "pop_addr";
		employeeEditForm.action = "/reader/readerManage/popAddr.do?cmd=4";
		employeeEditForm.submit();
	}
	//우편주소팝업에서 우편주소 선택시 셋팅 펑션
	function setAddr(zip , addr){
		$("dlvZip1").value = zip.substring(0,3);
		$("dlvZip2").value = zip.substring(3,6);
		$("dlvAdrs1").value = addr;
		$("dlvAdrs2").value = '';
	}
	//회사명에 따른 부서명 셋팅
	function Office(){
		if($("company").value != ''){
			var url = "/reader/employeeAdmin/ajaxOfficeNm.do?resv1="+$("company").value;
			sendAjaxRequest(url, "employeeEditForm", "post", officeList);
		}else{
			$("offiNm").options.length = 0;
		}
	}
	//회사명에 따른 부서명 셋팅
	function officeList(responseHttpObj) {
		if (responseHttpObj) {
			try {
				var result = eval("(" + responseHttpObj.responseText + ")");
				if (result) {
					setOfficeNm(result);
				}
			} catch (e) {
				alert("오류 : " + e);
			}
		}
	}
	//회사명에 따른 부서명 셋팅
	function setOfficeNm(jsonObjArr) {
		if (jsonObjArr.length > 0) {
			$("offiNm").options.length = 0;
			for ( var i = 0; i < jsonObjArr.length; i++) {
				$("offiNm").options[i] = new Option(jsonObjArr[i].CNAME , jsonObjArr[i].CODE );
			}
		}
		
	}
	//본사 독자 생성
	function saveReader(){
		if($("company").value == ''){
			alert('회사명을 선택해 주세요.');
			$("company").focus();
			return;
		}
		if($("offiNm").value == ''){
			alert('부서명을 선택해 주세요.');
			$("offiNm").focus();
			return;
		}
		if($("sabun").value == ''){
			alert('사번을 작성해 주세요.');
			$("sabun").focus();
			return;
		}
		if($("sabun").value.length < 6 ){
			alert('사번을 정확히 작성해 주세요.');
			$("sabun").focus();
			return;
		}
		if($("readNm").value == ''){
			alert('독자명을 작성해 주세요.');
			$("readNm").focus();
			return;
		}
		if($("mobile1").value == '' || $("mobile2").value == '' || $("mobile3").value == ''){
			alert('휴대폰 번호를 작성해 주세요.');
			$("mobile2").focus();
			return;
		}
		if($("dlvZip1").value == ''){
			alert('우편번호를 작성해 주세요.');
			$("dlvZip1").focus();
			return;
		}
		if($("dlvAdrs2").value == ''){
			alert('상세주소를 작성해 주세요.');
			$("dlvAdrs2").focus();
			return;
		}
		if($("check").checked == false){
			alert('지국통보여부 체크란을 체크해주시기 바랍니다.');
			$("check").focus();
			return;
		}
		if($("boSeq").value == ''){
			alert('지국을 선택해 주시기 바랍니다.');
			$("boSeq").focus();
			return;
		}
		if($("qty").value == ''){
			alert('부수를 선택해 주시기 바랍니다.');
			$("qty").focus();
			return;
		}
		if( checkBytes($("remk").value) > 300){
			alert("독자비고는 300byte를 초과할수 없습니다.");
			$("remk").focus();
			return;
		}
		if(confirm('본사 직원 독자를 생성하시겠습니까?') == false){
			return;
		}
		employeeEditForm.target="_self";
		employeeEditForm.action="/reader/employeeAdmin/SaveEmployee.do";
		employeeEditForm.submit();
	}
	//바이트 계산 function
	function checkBytes(expression ){
	 	var form = $("searchForm");
	 	var VLength=0;
	 	var temp = expression;
	 	var EscTemp;
	 	if(temp!="" & temp !=null) {
	 		for(var i=0;i<temp.length;i++){
	 			if (temp.charAt(i)!=escape(temp.charAt(i))){
	 				EscTemp=escape(temp.charAt(i));
 					if (EscTemp.length>=6){
 						VLength+=2;
 					}else{
 						VLength+=1;
 					}
 				}else{
 					VLength+=1;
 				}
 			}
 		}

 		return VLength;
 	}
	//신청일시 셋팅
	function setIndt(){
		if($("indt").value == ""){
			var currentTime = new Date();
			var year = currentTime.getFullYear();
			var month = currentTime.getMonth() + 1;
			if (month < 10) month = "0" + month;
			var day = currentTime.getDate();
			if (day < 10) day = "0" + day;
			$("indt").value = year + '-' + month + '-' + day; // 신청일자
		}
	}
	
	window.attachEvent("onload", setIndt);
</script>
<!-- title -->
<div><span class="subTitle">본사독자 입력</span></div>
<!-- //title -->
<form id="employeeEditForm" name="employeeEditForm" action="" method="post">
<!-- edit -->
<div style="width: 710px;">
	<table class="tb_edit_left" style="width: 710px">
		<colgroup>
			<col width="170px">
			<col width="540px">
		</colgroup>
		<tr>
		 	<th>회사명</th>
			<td>
				<select id="company" name="company" onchange="Office();">
					<option value=""></option>
					<c:forEach items="${company }" var="list">
						<option value="${list.CODE }">${list.CNAME } </option>
					</c:forEach>
				</select>
			</td>
		</tr>									
		<tr>
		 	<th>부서명</th>
			<td>
				<select id="offiNm" name="offiNm" style="width: 180px">
				</select>
			</td>
		</tr>						 						
		<tr>
		 	<th>사번</th>
			<td ><input type="text" id="sabun" name="sabun" value="" maxlength="6" style="ime-Mode:disabled; width: 200px" onkeypress="inputNumCom();"></td>
		</tr>														 	
		<tr>
		 	<th>성명</th>
			<td ><input type="text" id="readNm" name="readNm" value="" style="width: 200px"></td>
		</tr>	
		<tr>
		 	<th> 휴대폰</th>
			<td >
				<select id="mobile1" name="mobile1" style="vertical-align: middle;">
					<c:forEach items="${mobileCode }" var="list">
						<option value="${list.CODE }" >${list.CODE }</option>
					</c:forEach>
				</select> - 
				<input type="text" id="mobile2" name="mobile2" value="" maxlength="4" style="ime-Mode:disabled; vertical-align: middle; width: 45px" onkeypress="inputNumCom();"> - 
				<input type="text" id="mobile3" name="mobile3" value="" maxlength="4" style="ime-Mode:disabled; vertical-align: middle; width: 45px" onkeypress="inputNumCom();">
			</td>
		</tr>
		<tr>
		 	<th>전화번호</th>
			<td>
				<select id="homeTel1" name="homeTel1"  style="vertical-align: middle;">
					<option value=""></option>
					<c:forEach items="${areaCode }" var="list">
						<option value="${list.CODE }" <c:if test="${list.CODE eq employeeInfo[0].HOMETEL1 }"> selected </c:if>>${list.CODE }</option>
					</c:forEach>
				</select> - 
				<input type="text" id="homeTel2" name="homeTel2" value="" maxlength="4" style="vertical-align: middle;ime-Mode:disabled; width: 45px" onkeypress="inputNumCom();"> - 
				<input type="text" id="homeTel3" name="homeTel3" value="" maxlength="4" style="vertical-align: middle;ime-Mode:disabled; width: 45px" onkeypress="inputNumCom();">
			</td>
		</tr>
		<tr>
		 	<th>우편번호</th>
		 	<td>
				<input type="text" id="dlvZip1" name="dlvZip1" value="" readonly style="width: 45px; vertical-align: middle;"> - 
				<input type="text" id="dlvZip2" name="dlvZip2" value="" readonly style="width: 45px; vertical-align: middle;"> 
				<a href="#fakeUrl" onclick="popAddr();"><img src="/images/bt_postnum.gif" style="border: 0; vertical-align: middle;" alt="우편번호 찾기"></a>
			</td>
		</tr>
		<tr>
		 	<th>상세주소</th>
		 	<td >
		 		<input type="text" id="dlvAdrs1" name="dlvAdrs1" value="" readonly style="width: 250px;"><br/>
		 		<input type="text" id="dlvAdrs2" name="dlvAdrs2" value=""  style="width: 250px;">
		 	</td>
			
		</tr>
		<tr>
		 	<th>지국통보여부</th>
		 	<td>
		 		<input type="checkbox" id="check" name="check" style="border: 0; vertical-align: middle;"> 지국통보여부
		 		<select id="boSeq" name="boSeq" style="vertical-align: middle;">
				<option value=""></option>
					<c:forEach items="${agencyAllList }" var="list">
						<option value="${list.SERIAL }">${list.NAME } </option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
		 	<th><img src="/images/ic_arr.gif" style="border: 0; vertical-align: m</th>"> 구독부수</th>
			<td >
				<select id="qty" name="qty">
					<c:forEach begin="1" end="30" step="1" varStatus="i">
						<option value="${i.index }" >${i.index }</option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
		 	<th>이메일</th>
			<td ><input type="text" id="email" name="email" value="" style="width: 200px"></td>
		</tr>
		<tr>
		 	<th>독자번호</th>
			<td ><input type="text" id="readNo" name="readNo" value="" style="width: 200px" readonly><b class="b03">* 독자번호는 자동 생성됩니다.</b></td>
		</tr>
		<tr>
		 	<th>신청일시</th>
			<td ><input type="text" id="indt" name="indt" value="${employeeInfo[0].INDT}" readonly onclick="Calendar(this)" style="width: 200px"/></td>
		</tr>
		<tr>
		 	<th><font class="box_p">비고/통신란</font><br> "200자 내외 작성"</th>
			<td><textarea id="remk" name="remk" class="box_l" style="width: 98%"></textarea></td>
		</tr>
	</table>				
	<div style="padding-top: 10px; text-align: right;">
		<a href="#fakeUrl" onclick="saveReader();"><img src="/images/bt_save.gif" style="vertical-align:middle; border:0" ></a>  
		<a href="#fakeUrl" onclick="history.back();"><img src="/images/bt_back.gif" style="vertical-align:middle; border:0" ></a>
	</div>
</div>		
</form>