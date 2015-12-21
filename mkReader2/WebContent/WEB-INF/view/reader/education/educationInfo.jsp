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
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript"  src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel='stylesheet' type='text/css' href="/select2/select2.css"/>
<script type="text/javascript">
	//우편주소 팝업
	/*
	function popAddr(){
		var left = (screen.width)?(screen.width - 1330)/2 : 10;
		var top = (screen.height)?(screen.height - 200)/2 : 10;
		var winStyle = "width=400,height=500,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		var newWin = window.open("", "pop_addr", winStyle);
		educationInfoForm.target = "pop_addr";
		educationInfoForm.action = "/reader/readerManage/popAddr.do?cmd=4";
		educationInfoForm.submit();
	}
	//우편주소팝업에서 우편주소 선택시 셋팅 펑션
	function setAddr(zip , addr){
		$("dlvZip1").value = zip.substring(0,3);
		$("dlvZip2").value = zip.substring(3,6);
		$("dlvAdrs1").value = addr;
		$("dlvAdrs2").value = '';
	}
	*/
	//우편주소 팝업
	function popAddr(){
		var fm = document.getElementById("educationInfoForm");
		
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
		var fm = document.getElementById("educationInfoForm");
			
		fm.dlvZip1.value = zip.substring(0,3);
		fm.dlvZip2.value = zip.substring(3,6);
		fm.newaddr.value = newAddr;
		fm.dlvAdrs1.value = addr;
		fm.dlvAdrs2.value = bdNm;
		fm.bdMngNo.value = dbMngNo;
	}
	
	
	
	//저장
	function fn_update(){
		var fm = document.getElementById("educationInfoForm");

		// 해지독자 체크
		if(cf_checkValue("delYn", "Y")){
			alert('해지독자는 수정 불가 합니다.');
			return;
		}
		// 회사명
		if(!cf_checkNull("company", "회사명")){return;};
		
		// 관리팀명
		if(!cf_checkNull("teamNm", "관리팀명")){return;};

		// 독자명		
		if(!cf_checkNull("readNm", "독자명")){return;};
		
		// 연락처 확인
		if(($("mobile1").value == '' || $("mobile2").value == '' || $("mobile3").value == '') && ($("homeTel1").value == '' || $("homeTel2").value == '' || $("homeTel3").value == '')){
			alert('연락처를 최소 한개 이상 작성해 주세요.');
			$("mobile2").focus();
			return;
		}
		
		// 우편번호
		if(!cf_checkNull("dlvZip1", "우편번호")){return;};
		
		// 상세주소
		if(!cf_checkNull("dlvAdrs2", "상세주소")){return;};
		
		// 우편번호
		if(!cf_checkNull("dlvZip1", "우편번호")){return;};
		
		// 구독부수 확인
		if(!cf_checkNull("boSeq", "지국")){return;};
		
		// 구독부수
		if(!cf_checkNull("qty", "구독부수")){return;};
		
		/*
		if($("delYn").value == 'Y'){
			alert('해지독자는 수정 불가 합니다.');
			return;
		}
		if($("company").value == ''){
			alert('회사명을 선택해 주세요.');
			$("company").focus();
			return;
		}
		if($("teamNm").value == ''){
			alert('관리팀명을 선택해 주세요.');
			$("teamNm").focus();
			return;
		}
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
		*/
		if( checkBytes($("remk").value) > 300){
			alert("독자비고는 300byte를 초과할수 없습니다.");
			$("remk").focus();
			return;
		}
		if( $("oldBoseq").value != $("boSeq").value){
			if(confirm('지국을 변경 하시겠습니까?.') == false){
				return;
			}else{
				if(!cf_popSgBgmm("sgBgmm")){return;};			
			}
		}
		
		// 교육용 독자 부수 수정 (2012.07.04 박윤철)
		if(($("oldQty").value != $("qty").value) || ($("oldUprice").value != $("uPrice").value)){
			
			// 기준월 (현재월)
			var currentMonth = new Date();
			var baseYear = currentMonth.getYear();
			var baseMonth = currentMonth.getMonth() + 1;
			if (baseMonth < 10) baseMonth = "0" + baseMonth;
			var baseDate = baseYear +"-"+ baseMonth ;
		
			// 당월 등록 독자만 수정 가능
			if( $("indt").value.substr(0,7) != baseDate){
				alert("당월 등록 독자만 부수/단가 수정 가능합니다.");				
				return;
			}

		}
		
		if(!confirm('교육용 독자 정보를 수정하시겠습니까?')) { return; 
		}
		fm.target = "_self";
		fm.action = "/reader/education/update.do";
		fm.submit();
		window.opener.fn_search();
		window.close();
	}
	
	//저장
	function fn_create(){
		var fm = document.getElementById("educationInfoForm");

		if($("company").value == ''){
			alert('회사명을 선택해 주세요.');
			$("company").focus();
			return;
		}
		if($("teamNm").value == ''){
			alert('관리팀명을 선택해 주세요.');
			$("teamNm").focus();
			return;
		}
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
		if(!confirm('교육용 독자 정보를 생성하시겠습니까?')) { return; }
		
		fm.target = "_self";
		fm.action = "/reader/education/createEducation.do";
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
		<c:when test="${empty educationInfo[0].HJDT }">
			var currentTime = new Date();
			var year = currentTime.getFullYear();
			var month = currentTime.getMonth() + 1;
			if (month < 10) month = "0" + month;
			var day = currentTime.getDate();
			if (day < 10) day = "0" + day;
			$("indt").value = year + '-' + month + '-' + day; // 신청일자	
		</c:when>
		<c:otherwise>
		$("indt").value = '${educationInfo[0].HJDT}'; // 신청일자
		</c:otherwise>
		</c:choose>
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
	  *	 팝업닫기
	  **/
	function fn_popClose() {
		window.close();
	}
	
	jQuery.noConflict();
	jQuery(document).ready(function($) {
		setOnLoad();
		$("#company, #boSeq").select2({minimumInputLength: 1});
	});
</script>
</head>
<body>
<div class="box_Popup">
	<!-- title --> 
	<div class="pop_title_box">교육용 독자 정보 <c:if test="${flag == 'INS' }">등록</c:if><c:if test="${flag == 'UPT' }">수정</c:if></div>
	<form id="educationInfoForm" name="educationInfoForm" action="" method="post">
		<input type="hidden" id="seq" name="seq" value="${educationInfo[0].SEQ }"/>
		<input type="hidden" id="readNo" name="readNo" value="${educationInfo[0].READNO }"/>
		<input type="hidden" id="oldQty" name="oldQty" value="${educationInfo[0].QTY }"/>
		<input type="hidden" id="oldUprice" name="oldUprice" value="${educationInfo[0].UPRICE }"/>
		<input type="hidden" id="oldBoseq" name="oldBoseq" value="${educationInfo[0].BOSEQ }"/>
		<input type="hidden" id="delYn" name="delYn" value="${educationInfo[0].DELYN }"/>
		<input type="hidden" id="newsSeq" name="newsSeq" value="${educationInfo[0].NEWS_SEQ }"/>
		<input type="hidden" id="bdMngNo" name="bdMngNo" value="${educationInfo[0].BDMNGNO }"/>
		<input type="hidden" id="sgBgmm" name="sgBgmm" value=""/>
		<!-- edit -->
		<div style="width: 710px; padding-top: 10px;">
			<table class="tb_edit_left" style="width: 710px">
				<colgroup>
					<col width="180px">
					<col width="530px">
				</colgroup>
				<tr>
				 	<th>&nbsp;&nbsp; 회사명</th>
					<td >
						<select id="company" name="company" style="width: 200px">
							<option value=""></option>
							<c:forEach items="${companyList }" var="list">
								<option value="${list.CODE }" <c:if test="${list.CODE eq educationInfo[0].COMPANYCD }"> selected </c:if>>${list.CNAME } </option>
							</c:forEach>
						</select>
					</td>
				</tr>		
				<tr>
				 	<th>&nbsp;&nbsp; 관리팀명</th>
					<td >
						<select id="teamNm" name="teamNm">
							<option value=""></option>
							<c:forEach items="${teamNmList }" var="list">
								<option value="${list.TEAMNM }" <c:if test="${list.TEAMNM eq educationInfo[0].TEAMNM }"> selected </c:if>>${list.TEAMNM } </option>
							</c:forEach>
						</select>
					</td>
				</tr>		
				<tr>
				 	<th>&nbsp;&nbsp;  성명</th>
					<td ><input type="text" id="readNm" name="readNm" value="${educationInfo[0].READNM }" style="width: 200px"></td>
				</tr>	
				<tr>
				 	<th>&nbsp;&nbsp; 휴대폰</th>
					<td >
						<select id="mobile1" name="mobile1" style="vertical-align: middle;">
							<option value=""></option>
							<c:forEach items="${mobileCode }" var="list">
								<option value="${list.CODE }" <c:if test="${list.CODE eq educationInfo[0].MOBILE1 }"> selected </c:if>>${list.CODE }</option>
							</c:forEach>
						</select> - 
						<input type="text" id="mobile2" name="mobile2" value="${educationInfo[0].MOBILE2 }" maxlength="4" style="ime-Mode:disabled; width: 45px; vertical-align: middle;" onkeypress="inputNumCom();"> - 
						<input type="text" id="mobile3" name="mobile3" value="${educationInfo[0].MOBILE3 }" maxlength="4" style="ime-Mode:disabled; width: 45px; vertical-align: middle;"  onkeypress="inputNumCom();">
					</td>
				</tr>
				<tr>
				 	<th>&nbsp;&nbsp; 전화번호</th>
					<td>
						<select id="homeTel1" name="homeTel1" style="vertical-align: middle;">
							<option value=""></option>
							<c:forEach items="${areaCode }" var="list">
								<option value="${list.CODE }" <c:if test="${list.CODE eq educationInfo[0].HOMETEL1 }"> selected </c:if>>${list.CODE }</option>
							</c:forEach>
						</select> - 
						<input type="text" id="homeTel2" name="homeTel2" value="${educationInfo[0].HOMETEL2 }" maxlength="4" style="ime-Mode:disabled; width: 45px; vertical-align: middle;"  onkeypress="inputNumCom();"> - 
						<input type="text" id="homeTel3" name="homeTel3" value="${educationInfo[0].HOMETEL3 }" maxlength="4" style="ime-Mode:disabled; width: 45px; vertical-align: middle;"  onkeypress="inputNumCom();">
					</td>
				</tr>
				<tr>
				 	<th>&nbsp;&nbsp; 우편번호</th>
				 	<td>
						<input type="text" id="dlvZip1" name="dlvZip1" value="${fn:substring(educationInfo[0].DLVZIP , 0, 3) }" style="width: 40px; vertical-align: middle;" readonly="readonly" /> - 
						<input type="text" id="dlvZip2" name="dlvZip2" value="${fn:substring(educationInfo[0].DLVZIP , 3, 6) }" style="width: 40px; vertical-align: middle;" readonly="readonly" /> 
						<a href="#fakeUrl" onclick="popAddr();"><img alt="우편번호찾기" src="/images/ico_search2.gif" style="border: 0; vertical-align: middle;" /></a>
					</td>
				</tr>
				<tr>
				 	<th>&nbsp;&nbsp; 새주소</th>
				 	<td >
				 		<input type="text" id="newaddr" name="newaddr" value="${educationInfo[0].NEWADDR }" style="width: 350px;" readonly="readonly" /><br/>
				 	</td>
				 </tr>
				<tr>
				 	<th>&nbsp;&nbsp; 지번주소</th>
				 	<td >
				 		<input type="text" id="dlvAdrs1" name="dlvAdrs1" value="${educationInfo[0].DLVADRS1 }" style="width: 350px;" readonly="readonly" /><br/>
				 	</td>
				 </tr>
				 <tr>
				 	<th>&nbsp;&nbsp; 상세주소</th>
				 	<td >
				 		<input type="text" id="dlvAdrs2" name="dlvAdrs2" value="${educationInfo[0].DLVADRS2 }" style="width: 350px;" />
				 	</td>
				</tr>
				<tr>
				 	<th>&nbsp;&nbsp; 관리 지국</th>
				 	<td>
				 		<select id="boSeq" name="boSeq" style="width: 150px">
							<option value=""></option>
							<c:forEach items="${agencyAllList }" var="list">
								<option value="${list.SERIAL }" <c:if test="${list.SERIAL eq educationInfo[0].BOSEQ }">selected</c:if>>${list.NAME } </option>
							</c:forEach>
						</select>
					</td>
				</tr>
				
				<tr>
				 	<th>&nbsp;&nbsp; 구독부수</th>
					<td >
						<input type="text" id="qty" name="qty" value="${educationInfo[0].QTY }">
					</td>
				</tr>	
				<tr>
				 	<th>&nbsp;&nbsp; 단가</th>
					<td >
						<input type="text" id="uPrice" name="uPrice" value="${educationInfo[0].UPRICE }">
					</td>
				</tr>
				<tr>
				 	<th>&nbsp;&nbsp; 독자번호</th>
					<td ><input type="text" id="readNo" name="readNo" value="${educationInfo[0].READNO }" style="width: 200px" readonly="readonly" /></td>
				</tr>
				<tr>
				 	<th>&nbsp;&nbsp; 신청일시</th>
					<td >
						<c:choose>
							<c:when test="${flag=='INS' }">			
								<input type="text" id="indt" name="indt" value="${sdate}" style="width: 80px" onclick="Calendar(this)" readonly="readonly" />
							</c:when>
							<c:when test="${flag=='UPT' }">
								<input type="text" id="indt" name="indt" value="${sdate}" style="width: 80px" readonly="readonly" />
							</c:when>
						</c:choose>
					</td>
				</tr>
				<tr>
				 	<th>&nbsp;&nbsp;비고/통신란<br/>&nbsp;&nbsp;"200자 내외 작성"</th>
					<td>
						<!-- memo list -->
						<c:forEach items="${memoList}" var="list" begin="0" end="2"  varStatus="status">
							<div style="padding: 5px 0; border-bottom: 1px solid #e5e5e5; width: 510px;">
								<div style="font-weight: bold; padding-bottom: 3px;">[${list.CREATE_ID}]&nbsp;${list.CREATE_DATE}</div>
								<div style="width: 510px; word-break: break-all;'">${list.MEMO}</div>
							</div>
						</c:forEach> 
						<c:if test="${fn:length(memoList) > 3}">
							<div style="padding: 3px 0; text-align: right;"><a href="#fakeUrl" onclick="fn_memo_view_more('${educationInfo[0].READNO }')"><img alt="더보기" title="더보기" src="/images/ico_more.gif" /></a></div>
						</c:if>
						<!-- //memo list -->
						<div style="padding-top: 3px;"><textarea id="remk" name="remk" style="width: 95%;"></textarea></div>
					</td>
				</tr>
			</table>						
			<div style="width: 710px; text-align: right; padding-top: 10px;">
				<c:choose>
					<c:when test="${flag=='UPT' }">			
			  			<a href="#fakeUrl" onclick="fn_update();"><img src="/images/bt_save.gif" style="border: 0; vertical-align: middle" alt="저장" /></a>
			  		</c:when>
			  		<c:when test="${flag=='INS' }">
			  			<a href="#fakeUrl" onclick="fn_create();"><img src="/images/bt_save.gif" style="border: 0; vertical-align: middle;"></a>
			  		</c:when>
			  	</c:choose>    
		  		<a href="#fakeUrl" onclick="fn_popClose();"><img src="/images/bt_close.gif" style="border: 0; vertical-align: middle" /></a>
			</div>
		</div>
	</form>
</div>
</body>
</html>