<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet">
<script type="text/javascript"src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/ajaxUtil.js" charset="UTF-8"></script>
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
		var fm = document.getElementById("alienationInfoForm");
		
		var left = 0;
		var top = 30;
		var winStyle = "width=520,height=700,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		var newWin = window.open("", "pop_addr", winStyle);
		
		fm.target = "pop_addr";
		fm.action = "/common/common/popNewAddr.do";
		fm.submit();
	}
	
	//우편주소팝업에서 우편주소 선택시 셋팅 펑션
	function setAddr(zip , addr, newAddr, bdNm, dbMngNo){
		var fm = document.getElementById("alienationInfoForm");
		
		var dlvZip1 = document.getElementById("dlvZip1") ;
		var dlvZip2 = document.getElementById("dlvZip2") ;
		var dlvAdrs1 = document.getElementById("dlvAdrs1") ;
		var dlvAdrs2 = document.getElementById("dlvAdrs2") ;
		var newaddr = document.getElementById("newaddr");
		
		dlvZip1.value = zip.substring(0,3);
		dlvZip2.value = zip.substring(3,6);
		newaddr.value = newAddr;
		dlvAdrs1.value = addr;
		dlvAdrs2.value = bdNm;
		fm.bdMngNo.value = dbMngNo;
		fn_addr_chg();
	}
	
	//소외계층 정보 수정
	function fn_update(){
		var fm = document.getElementById("alienationInfoForm");
		
		if($("bno").value == '999'){
			alert('해지독자는 수정 불가 합니다.');
			return;
		}
		if(!cf_checkNull("readNm", "독자명")) { return false; }
		
		if($("mobile1").value == '' || $("mobile2").value == '' || $("mobile3").value == ''){
			alert('휴대폰 번호를 작성해 주세요.');
			$("mobile2").focus();
			return;
		}
		
		if(!cf_checkNull("dlvZip1", "우편번호")) { return false; }
		if(!cf_checkNull("dlvAdrs2", "상세주소")) { return false; }
		
		if($("check").checked == false){
			alert('지국통보여부 체크란을 체크해주시기 바랍니다.');
			$("check").focus();
			return;
		}
		
		if(!cf_checkNull("boSeq", "지국")) { return false; }
		if(!cf_checkNull("qty", "부수")) { return false; }
		
		if( checkBytes($("remk").value) > 300){
			alert("독자비고는 300byte를 초과할수 없습니다.");
			$("remk").focus();
			return;
		}
		if( $("oldBoseq").value != $("boSeq").value){
			if(confirm('지국을 변경 하시겠습니까?.') == false){
				return;
			}
			var sgBgmm = prompt('수금시작월을 입력해 주세요.\nex)201201', '');
			if ((sgBgmm == '') || (sgBgmm == null)){
	        	alert('수금시작월을 입력해 주세요.');
	        	return;
	        }else{
	        	if(sgBgmm.length != 6){
	        		alert('수금시작월을 YYYYMM 형태로 입력해 주세요.');
		        	return;
	        	}else{
	        		if( Number(sgBgmm.substring(4,6)) < 1 ||  Number(sgBgmm.substring(4,6)) > 12  ){
	        			alert('수금시작월을 YYYYMM 형태로 입력해 주세요.');
			        	return;
	        		}
	        	}
	        }
			$("sgBgmm").value = sgBgmm;
		}
		
		if(!confirm("수정된 내용을 저장하시겠습니까?")) {
			return false;
		}
				
		fm.target = "_self";
		fm.action = "/reader/alienation/update.do";
		fm.submit();
		window.opener.fn_search();
		window.close();
	}
	
	//저장
	function fn_create() {
		var fm = document.getElementById("alienationInfoForm");
		
		if(!cf_checkNull("readNm", "독자명")) { return false; }
		
		if(($("mobile1").value == '' || $("mobile2").value == '' || $("mobile3").value == '') && ($("homeTel1").value == '' || $("homeTel2").value == '' || $("homeTel3").value == '')){
			alert('연락처를 최소 한개 이상 작성해 주세요.');
			$("mobile2").focus();
			return;
		}
		
		if(!cf_checkNull("dlvZip1", "우편번호")) { return false; }
		if(!cf_checkNull("dlvAdrs2", "상세주소")) { return false; }

		if(!cf_checkNull("boSeq", "지국")) { return false; }
		if(!cf_checkNull("qty", "부수")) { return false; }
		if(!cf_checkNull("uPrice", "단가")) { return false; }
		
		if( checkBytes($("remk").value) > 300){
			alert("독자비고는 300byte를 초과할수 없습니다.");
			$("remk").focus();
			return;
		}
		
		if(!confirm('NI독자 정보를 생성하시겠습니까?')){
			return;
		}
		
		fm.target = "_self";
		fm.action = "/reader/alienation/createNIReader.do";
		fm.submit();
		window.opener.fn_search();
		window.close();
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
	
	//화면 로딩 셋팅
	function setOnLoad(){
		<c:choose>
		<c:when test="${empty alienationInfo[0].INDT }">
			var currentTime = new Date();
			var year = currentTime.getFullYear();
			var month = currentTime.getMonth() + 1;
			if (month < 10) month = "0" + month;
			var day = currentTime.getDate();
			if (day < 10) day = "0" + day;
			$("indt").value = year + '-' + month + '-' + day; // 신청일자	
		</c:when>
		<c:otherwise>
		$("indt").value = '${alienationInfo[0].INDT}'; // 신청일자
		</c:otherwise>
		</c:choose>
	}
	
	function callLog(){
		var left = (screen.width)?(screen.width - 830)/2 : 10;
		var top = (screen.height)?(screen.height - 600)/2 : 10;
		var winStyle = "width=400,height=500,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		var newWin = window.open("", "call_log", winStyle);
		alienationInfoForm.target = "call_log";
		alienationInfoForm.action = "/reader/readerManage/popRetrieveCallLog.do?gbn=alienation";
		alienationInfoForm.submit();
	}
	
	/**
	 *	비고 더보기 클릭 이벤트
	 **/
	function fn_memo_view_more(readno) {
		var winW = (screen.width-300)/2;
		var winH = (screen.height-600)/2;
		var url = '/util/memo/popMemoList.do?readno='+readno;
		
		window.open(url, '', 'width=300px, height=600px, resizable=yes, status=no, toolbar=no, location=no, top='+winH+', left='+winW);
	}
	
	/**
	 * 돌아가기버튼 클릭 이벤트
	 **/
	function fn_back_list() {
		var fm = document.getElementById("alienationInfoForm");
		
		fm.target = "_self";
		fm.action = "/reader/alienation/retrieveAlienationList.do";
		fm.submit();
	}
	
	/**
	 * 주소변경여부
	 */
	function fn_addr_chg() {
		var fm = document.getElementById("alienationInfoForm");
		
		fm.addrChgYn.value = "Y";
	}
	
	/**
	  *	 팝업닫기
	  **/
	function fn_popClose() {
		window.close();
	}
	
	window.attachEvent("onload", setOnLoad);
</script>
</head>
<body>
<div class="box_Popup">
	<!-- title --> 
	<div class="pop_title_box">NIE신문독자 정보 <c:if test="${flag == 'INS' }">등록</c:if><c:if test="${flag == 'UPT' }">수정</c:if></div>
	<form id="alienationInfoForm" name="alienationInfoForm" action="" method="post">
		<input type="hidden" id="bno" name="bno" value="${alienationInfo[0].BNO }">
		<input type="hidden" id="readNo" name="readNo" value="${alienationInfo[0].READNO }">
		<input type="hidden" id="newsCd" name="newsCd" value="${alienationInfo[0].NEWSCD }">
		<input type="hidden" id="seq" name="seq" value="${alienationInfo[0].SEQ }">
		<input type="hidden" id="oldBoseq" name="oldBoseq" value="${alienationInfo[0].BOSEQ }">
		<input type="hidden" id="sgBgmm" name="sgBgmm" value="">
		<input type="hidden" id="addrChgYn" name="addrChgYn" value="N">
		<input type="hidden" id="bdMngNo" name="bdMngNo" value="${alienationInfo[0].BDMNGNO }" />
		<input type="hidden" id="readTypeCd" name="readTypeCd" value="018" />
		
		<!-- edit -->
		<div class="box_list" style="width: 710px;">
			<table class="tb_edit_left" style="width: 710px">
				<colgroup>
					<col width="180px">
					<col width="530px">
				</colgroup>
				<tr>
				 	<th>&nbsp;&nbsp;  성명</th>
					<td ><input type="text" id="readNm" name="readNm" value="${alienationInfo[0].READNM }" style="width: 350px"></td>
				</tr>	
				<tr>
				 	<th>&nbsp;&nbsp; 휴대폰</th>
					<td >
						<select id="mobile1" name="mobile1" style="vertical-align: middle;">
							<option value=""></option>
							<c:forEach items="${mobileCode }" var="list">
								<option value="${list.CODE }" <c:if test="${list.CODE eq alienationInfo[0].MOBILE1 }"> selected </c:if>>${list.CODE }</option>
							</c:forEach>
						</select> - 
						<input type="text" id="mobile2" name="mobile2" value="${alienationInfo[0].MOBILE2 }" maxlength="4" style="ime-Mode:disabled; width: 45px; vertical-align: middle;" onkeypress="inputNumCom();"> - 
						<input type="text" id="mobile3" name="mobile3" value="${alienationInfo[0].MOBILE3 }" maxlength="4" style="ime-Mode:disabled; width: 45px; vertical-align: middle;" onkeypress="inputNumCom();">
					</td>
				</tr>
				<tr>
				 	<th>&nbsp;&nbsp; 전화번호</th>
					<td>
						<select id="homeTel1" name="homeTel1" style="vertical-align: middle;">
							<option value=""></option>
							<c:forEach items="${areaCode }" var="list">
								<option value="${list.CODE }" <c:if test="${list.CODE eq alienationInfo[0].HOMETEL1 }"> selected </c:if>>${list.CODE }</option>
							</c:forEach>
						</select> - 
						<input type="text" id="homeTel2" name="homeTel2" value="${alienationInfo[0].HOMETEL2 }" maxlength="4" style="ime-Mode:disabled; width: 40px; vertical-align: middle;" onkeypress="inputNumCom();"> - 
						<input type="text" id="homeTel3" name="homeTel3" value="${alienationInfo[0].HOMETEL3 }" maxlength="4" style="ime-Mode:disabled; width: 40px; vertical-align: middle;" onkeypress="inputNumCom();">
					</td>
				</tr>
				<tr>
				 	<th>&nbsp;&nbsp; 우편번호</th>
				 	<td>
						<input type="text" id="dlvZip1" name="dlvZip1" style="vertical-align: middle; width: 40px" value="${fn:substring(alienationInfo[0].DLVZIP , 0, 3) }" readonly="readonly" /> - 
						<input type="text" id="dlvZip2" name="dlvZip2" style="vertical-align: middle; width: 40px" value="${fn:substring(alienationInfo[0].DLVZIP , 3, 6) }" readonly="readonly" />&nbsp; 
						<a href="#fakeUrl" onclick="popAddr();"><img alt="우편번호찾기" src="/images/ico_search2.gif" style="border: 0; vertical-align: middle;" /></a>
				</td>
			</tr>														 	
			<tr>
			 	<th>&nbsp;&nbsp; 도로명주소</th>
				<td >
					<input type="text" id="newaddr" name="newaddr" value="${alienationInfo[0].NEWADDR }" style="width: 450px; vertical-align: middle; border: 0;" readonly onchange="fn_addr_chg();"  />
				</td>
			</tr>							 	
			<tr>
			 	<th>&nbsp;&nbsp; 지번주소</th>
				<td >
					<input type="text" id="dlvAdrs1" name="dlvAdrs1" value="${alienationInfo[0].DLVADRS1 }" style="width: 450px; vertical-align: middle; border: 0;" readonly  />
				</td>
			</tr>														 	
			<tr>
			 	<th>&nbsp;&nbsp; 상세주소</th>
			 	<td >
			 		<input type="text" id="dlvAdrs2" name="dlvAdrs2" value="${alienationInfo[0].DLVADRS2 }" style="width: 450px" />
			 	</td>
				
			</tr>
			<tr>
			 	<th>&nbsp;&nbsp; 지국통보여부</th>
			 	<td>
			 		<input type="checkbox" id="check" name="check" style="border: 0; vertical-align: middle;" <c:if test="${not empty alienationInfo[0].INDT }">checked</c:if>> 지국통보여부(<c:if test="${not empty alienationInfo[0].INDT }">${alienationInfo[0].INDT }</c:if>)
			 		<select id="boSeq" name="boSeq">
					<option value=""></option>
						<c:forEach items="${agencyAllList }" var="list">
							<option value="${list.SERIAL }" <c:if test="${alienationInfo[0].BOSEQ eq list.SERIAL}">selected </c:if>>${list.NAME } </option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<c:choose>
				<c:when test="${flag=='INS' }">
					<tr>
					 	<th>단가</th>
						<td >
							<input type="text" id="uPrice" name="uPrice" value="" >
						</td>
					</tr>
				</c:when>
			</c:choose>
				<tr>
				 	<th><img src="/images/ic_arr.gif" style="border: 0; vertical-align: middle" alt="" /> 구독부수</th>
					<td >
						<select id="qty" name="qty">
							<c:choose>
								<c:when test="${flag=='UPT' }">
									<option value="${alienationInfo[0].QTY }" >${alienationInfo[0].QTY }</option>
								</c:when>
				  				<c:when test="${flag=='INS' }">
									<c:forEach begin="1" end="30" step="1" varStatus="i">
										<option value="${i.index }" >${i.index }</option>
									</c:forEach>
								</c:when>
						  	</c:choose>
						</select>
					</td>
				</tr>	
				<tr>
				 	<th>&nbsp;&nbsp; 이메일</th>
					<td ><input type="text" id="email" name="email" value="${alienationInfo[0].EMAIL }" style="width: 200px;" /></td>
				</tr>
				<tr>
				 	<th>&nbsp;&nbsp; 독자번호</th>
					<td ><input type="text" id="readNo" name="readNo" value="${alienationInfo[0].READNO }" style="width: 200px;" readonly="readonly" /></td>
				</tr>
				<tr>
				 	<th>&nbsp;&nbsp; 신청일시</th>
					<td>
						<c:if test="${flag == 'INS' }">
							<input type="text" id="indt" name="indt" value="<c:out value='${sdate}' />"  onclick="Calendar(this)" style="width: 200px;" readonly="readonly" />
						</c:if>
						<c:if test="${flag == 'UPT' }"><div style="padding: 4px 0;">${fn:substring(alienationInfo[0].HJDT, 0, 4)}-${fn:substring(alienationInfo[0].HJDT, 4, 6)}-${fn:substring(alienationInfo[0].HJDT, 6, 8)}</div></c:if>
					</td>
				</tr>
				<tr>
				 	<th>&nbsp;&nbsp; <font class="box_p">비고/통신란</font><br>&nbsp;&nbsp; "200자 내외 작성"</th>
					<td>
						<!-- memo list -->
						<c:forEach items="${memoList}" var="list" begin="0" end="2"  varStatus="status">
							<div style="padding: 5px 0; border-bottom: 1px solid #e5e5e5; width: 510px;">
								<div style="font-weight: bold; padding-bottom: 3px;">[${list.CREATE_ID}]&nbsp;${list.CREATE_DATE}</div>
								<div style="width: 510px; word-break: break-all;'">${list.MEMO}</div>
							</div>
						</c:forEach> 
						<c:if test="${fn:length(memoList) > 3}">
							<div style="padding: 3px 0; text-align: right;"><a href="#fakeUrl" onclick="fn_memo_view_more('${alienationInfo[0].READNO }')"><img alt="더보기" title="더보기" src="/images/ico_more.gif" /></a></div>
						</c:if>
						<!-- //memo list -->
						<div style="padding-top: 3px;"><textarea id="remk" name="remk" style="width: 95%"></textarea></div>
					</td>
				</tr>
			</table>						
			<div style="width: 710px; text-align: right; padding-top: 10px;">
				<c:choose>
					<c:when test="${flag=='UPT' }">
						<a href="#fakeUrl" onclick="callLog();"><img src="/images/call_memo.gif" style="border: 0; vertical-align: middle" alt="통화메모" /></a>
						<span id="callLog" style="display:none"><img src="/images/icon_new.gif" border="0" align="top"></span>
				  		<a href="#fakeUrl" onclick="fn_update();"><img src="/images/bt_save.gif" style="border: 0; vertical-align: middle" alt="저장" /></a>
				  	</c:when>
				  	<c:when test="${flag=='INS' }">
		  				<a href="#fakeUrl" onclick="fn_create();"><img src="/images/bt_save.gif" style="border; vertical-align: middle;"></a>  
		  			</c:when>
			  	</c:choose>  
		  		<a href="#fakeUrl" onclick="fn_popClose();"><img src="/images/bt_close.gif" style="border: 0; vertical-align: middle" /></a>  
			</div>
		</div>
	</form>
</div>
</body>
</html>
