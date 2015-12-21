<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/ajaxUtil.js" ></script>
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
		alienationEditForm.target = "pop_addr";
		alienationEditForm.action = "/reader/readerManage/popAddr.do?cmd=4";
		alienationEditForm.submit();
	}
	//우편주소팝업에서 우편주소 선택시 셋팅 펑션
	function setAddr(zip , addr){
		$("dlvZip1").value = zip.substring(0,3);
		$("dlvZip2").value = zip.substring(3,6);
		$("dlvAdrs1").value = addr;
		$("dlvAdrs2").value = '';
	}
	//저장
	function create(){
		if($("readNm").value == ''){
			alert('독자명을 작성해 주세요.');
			$("readNm").focus();
			return;
		}
		if(($("mobile1").value == '' || $("mobile2").value == '' || $("mobile3").value == '') && ($("homeTel1").value == '' || $("homeTel2").value == '' || $("homeTel3").value == '')){
			alert('연락처를 최소 한개 이상 작성해 주세요.');
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
		if($("uPrice").value == ''){
			alert('단가를 입력해 주시기 바랍니다.');
			$("uPrice").focus();
			return;
		}
		if( checkBytes($("remk").value) > 300){
			alert("독자비고는 300byte를 초과할수 없습니다.");
			$("remk").focus();
			return;
		}
		if(confirm('소외계층 독자 정보를 생성하시겠습니까?') == false){
			return;
		}
		alienationEditForm.target = "_self";
		alienationEditForm.action = "/reader/alienation/createAlienation.do";
		alienationEditForm.submit();
		
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
	//
	function setPrice(){
		$("uPrice").value = $("qty").value * 7500;
	}
	//화면 로딩 셋팅
	function setOnLoad(){
		var currentTime = new Date();
		var year = currentTime.getFullYear();
		var month = currentTime.getMonth() + 1;
		if (month < 10) month = "0" + month;
		var day = currentTime.getDate();
		if (day < 10) day = "0" + day;
		$("indt").value = year + '-' + month + '-' + day; // 신청일자	
		$("uPrice").value = 7500 ;
	}
	
	window.attachEvent("onload", setOnLoad);
</script>
<!-- title -->
<div><span class="subTitle">소외계층 독자 등록</span></div>
<!-- //title -->
<form id="alienationEditForm" name="alienationEditForm" action="" method="post">
<div style="width: 710px;">
	<table class="tb_edit_left" style="width: 710px">
		<colgroup>
			<col width="170px;">
			<col width="540px;">
		</colgroup>
		<tr>
		 	<th>성명</th>
			<td><input type="text" id="readNm" name="readNm" value="" style="width: 200px"></td>
		</tr>	
		<tr>
		 	<th>휴대폰</th>
			<td >
				<select id="mobile1" name="mobile1" style="vertical-align: middle;">
					<option value=""></option>
					<c:forEach items="${mobileCode }" var="list">
						<option value="${list.CODE }" >${list.CODE }</option>
					</c:forEach>
				</select> - 
				<input type="text" id="mobile2" name="mobile2" value="" maxlength="4" style="ime-Mode:disabled; vertical-align: middle; width: 45px;" onkeypress="inputNumCom();"> - 
				<input type="text" id="mobile3" name="mobile3" value="" maxlength="4" style="ime-Mode:disabled; vertical-align: middle; width: 45px;" onkeypress="inputNumCom();">
			</td>
		</tr>
		<tr>
		 	<th>전화번호</th>
			<td>
				<select id="homeTel1" name="homeTel1" style="vertical-align: middle;">
					<option value=""></option>
					<c:forEach items="${areaCode }" var="list">
						<option value="${list.CODE }" >${list.CODE }</option>
					</c:forEach>
				</select> - 
				<input type="text" id="homeTel2" name="homeTel2" value="" maxlength="4" style="ime-Mode:disabled; vertical-align: middle; width: 45px;" onkeypress="inputNumCom();"> - 
				<input type="text" id="homeTel3" name="homeTel3" value="" maxlength="4" style="ime-Mode:disabled; vertical-align: middle; width: 45px;" onkeypress="inputNumCom();">
			</td>
		</tr>
		<tr>
		 	<th>우편번호</th>
		 	<td>
				<input type="text" id="dlvZip1" name="dlvZip1" value="" readonly style="width: 45px; vertical-align: middle;"> - 
				<input type="text" id="dlvZip2" name="dlvZip2" value="" readonly style="width: 45px; vertical-align: middle;"> 
				<a href="#fakeUrl" onclick="popAddr();"><img src="/images/bt_postnum.gif" style="vertical-align: middle;" border="0;" alt="우편번호 찾기"></a>
			</td>
		</tr>
		<tr>
		 	<th>상세주소</th>
		 	<td >
		 		<input type="text" id="dlvAdrs1" name="dlvAdrs1" value="" readonly style="width: 250px"><br/>
		 		<input type="text" id="dlvAdrs2" name="dlvAdrs2" value="" style="width: 250px">
		 	</td>
			
		</tr>
		<tr>
		 	<th>관리 지국</th>
		 	<Td>
		 		<select id="boSeq" name="boSeq">
					<option value=""></option>
					<c:forEach items="${agencyAllList }" var="list">
						<option value="${list.SERIAL }">${list.NAME } </option>
					</c:forEach>
				</select>
			</Td>
		</tr>
		
		<tr>
		 	<th>구독부수</th>
			<td >
				<select id="qty" name="qty" onchange="setPrice();">
					<c:forEach begin="1" end="30" step="1" varStatus="i">
						<option value="${i.index }" >${i.index }</option>
					</c:forEach>
				</select>
			</td>
		</tr>	
		<tr>
		 	<th>단가</th>
			<td >
				<input type="text" id="uPrice" name="uPrice" value="" >
			</td>
		</tr>
		<tr>
		 	<th>이메일</th>
			<td ><input type="text" id="eMail" name="eMail" value="" style="width: 200px"></td>
		</tr>
		<tr>
		 	<th>독자번호</th>
			<td ><input type="text" id="readNo" name="readNo" value="" style="width: 200px" readonly></td>
		</tr>
		<tr>
		 	<th>신청일시</th>
			<td ><input type="text" id="indt" name="indt" value="<c:out value='${sdate}' />" readonly onclick="Calendar(this)" style="width: 200px"/></td>
		</tr>
		<tr>
		 	<th><font class="box_p">비고/통신란</font><br>"200자 내외 작성"</th>
			<td >
				<textarea id="remk" name="remk" class="box_l" style="width: 98%"></textarea>
			</td>
		</tr>
	</table>
	<div style="padding-top: 10px; text-align: right;">									
  		<a href="#fakeUrl" onclick="create();"><img src="/images/bt_save.gif" style="border; vertical-align: middle;"></a>  
  		<a href="#fakeUrl" onclick="history.back(-1);"><img src="/images/bt_back.gif" style="border; vertical-align: middle;"></a>
  	</div>
</div>
</form>
