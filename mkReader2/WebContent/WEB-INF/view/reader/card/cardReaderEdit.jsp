<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>카드독자 상세정보</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet">
<link rel='stylesheet' type='text/css' href="/select2/select2.css"/>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript">
	//우편주소 팝업
	function popAddr(){
		var fm = document.getElementById("cardReaderForm") ;

		var left = 0;
		var top = 30;
		var winStyle = "width=520,height=700,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		newWin = window.open("", "pop_addr", winStyle);

		fm.target = "pop_addr";
		fm.action = "/common/common/popNewAddr.do";
		fm.submit();
	}
	
	//우편주소팝업에서 우편주소 선택시 셋팅 펑션
	function setAddr(zip , addr, newAddr, bdNm, bdMngNo){
		var fm = document.getElementById("cardReaderForm") ;
		
		fm.zip.value = zip;
		fm.addr1.value = addr;
		fm.addr2.value = bdNm;
		fm.newaddr.value = newAddr;
		fm.bdMngNo.value = bdMngNo;
	}
	
	// 독자정보 저장
	function saveCardReader(){
		var fm = document.getElementById("cardReaderForm") ;
		// 벨리데이션 체크
		if(!validate()){ return; }
		
		if(!confirm("저장하시겠습니까?")){return false;}
		
		// 지국변경건 확인
		if($("noticeYn").checked) {
			fm.noticeYnVal.value = "1";
		} else {
			fm.noticeYnVal.value = "0";
		}
		
		fm.target="_self";
		fm.action="/reader/card/updateCardReaderData.do";
		fm.submit();
		window.opener.search();
	}
	
	// 벨리데이션
	function validate(){
		// 카드식별번호 입력 체크
		if(!cf_checkNull("cardSeq", "카드식별번호")){return false;};

		// 기존독자의 경우 독자번호 체크
		if(cf_checkValue("gubun", "기존")){ if(!cf_checkNull("readno", "기존고객의 경우 독자번호")){return false;}; }

		// 우편번호 체크
		if(!cf_checkNull("zip", "우편번호")){return false;};

		// 주소 체크
		if(!cf_checkNull("addr1", "주소")){return false;};

		// 상세 주소체크
		if(!cf_checkNull("addr2", "상세주소")){return false;};

		// 지국통보여부 체크 
		/*
		if(!$("noticeYn").checked){
			alert("지국 통보 후 지국통보 여부를 체크해 주시기 바랍니다.");
			return false;
		}
		*/

		// 부수 입력 체크
		if(!cf_checkNull("qty", "구독부수")){return false;};

		// 단가 입력 체크
		if(!cf_checkNull("uprice", "단가")){return false;};
		
		//18일~22일 카드 수금처리 불가능
		if(cf_getValue("boseq") != cf_getValue("oldBoseq")) {
			if(cf_getValue("chkJikukChgYN") == "N") {
				alert("카드수금처리기간(18일~22일)에는 지국 수정이 불가능합니다.");
				return false; 
			}
		}
		
		// 지국변경건 확인
		if($("noticeYn").checked && ($("oldBoseq").value != "" && $("boseq").value != $("oldBoseq").value)){
			if(!confirm("지국을 변경 하시겠습니까?")){
				return false;
			} else {
				if(!cf_checkNull("sgBgmm", "수금시작월")){return false;};
			}
		}
		return true;
	}
	
	/**
	*	지국변경시 수금시작월 입력란 보이기
	**/
	function fn_jikukChange() {
		if(cf_getValue("boseq") != cf_getValue("oldBoseq")) {
			jQuery("#divSgbg").show();
		} else {
			jQuery("#divSgbg").hide();
		}
	}

	/**
	  *	 팝업닫기
	  **/
	function fn_popClose() {
		window.close();
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
	
	//카드 변경기간체크
	function fn_cardChgError() {
		alert("카드수금일인 20일 2시 이후에 카드 변경이 가능합니다.");
		return false;
	}
	
	jQuery.noConflict();
	jQuery(document).ready(function($){
		$("#boseq").select2({minimumInputLength: 1});
		$("#divSgbg").hide();
		
		editCardNumber = function(){
			var winW = (screen.width-300)/2;
			var winH = (screen.height-600)/2;
			var url = "./popCardNumberEdit.do?cardSeq=${cardReaderInfo[0].CARD_SEQ }&userId=${cardReaderInfo[0].ID}&readNo=${cardReaderInfo[0].READNO}";
			window.open(url, '', 'width=300px, height=200px, resizable=yes, status=no, toolbar=no, location=no, top='+winH+', left='+winW);
		}
	});
</script>
</head>
<body>
<div class="box_Popup" style="width: 730px">
	<!-- title --> 
	<div class="pop_title_box">카드독자관리</div>
	<div style="font-weight: bold; padding: 10px 0 3px 0;"><b class="b03">* 필수 기재란 입니다.</b></div>
	<form id="cardReaderForm" name="cardReaderForm" method="post">
		<input type="hidden" name="status"   				id="status" 			value="${cardReaderInfo[0].STATUS}"/>
		<input type="hidden" name="userId"   			id="userId" 			value="${cardReaderInfo[0].ID}"/>
		<input type="hidden" name="aplcDt"   			id="aplcDt" 			value="${cardReaderInfo[0].APLCDT}"/>
		<input type="hidden" name="ntdt"     				id="ntdt"   			value="${cardReaderInfo[0].NTDT}" />
		<input type="hidden" name="oldNtdt" 				id="oldNtdt"  		value="${cardReaderInfo[0].NTDT}" />
		<input type="hidden" name="noticeYnVal" 		id="noticeYnVal"  	value="" />
		<input type="hidden" name="oldBoseq" 			id="oldBoseq"  		value="${cardReaderInfo[0].BOSEQ}" />
		<input type="hidden" name="oldReadNo" 		id="oldReadNo"  	value="${cardReaderInfo[0].READNO}" />
		<input type="hidden" name="bdMngNo" 			id="bdMngNo" 		value="${cardReaderInfo[0].BDMNGNO }" />
		<input type="hidden" name="gubun" 				id="gubun" 			value="${cardReaderInfo[0].GUBUN }" />
		<input type="hidden" name="cardSeq" 			id="cardSeq" 		value="${cardReaderInfo[0].CARD_SEQ }" />
		<input type="hidden" name="chkJikukChgYN" 	id="chkJikukChgYN" value="${chkJikukChgYN }">
		<!-- //조회값 -->
		<!-- edit -->
		<div style="width: 730px">
			<table class="tb_edit_left" style="width: 730px">
				<colgroup>
					<col width="150px">
					<col width="215px">
					<col width="150px">
					<col width="215px">
				</colgroup>
				<tr>
					<th><b class="b03">*</b> 독 자 명</th>
					<td><input type="text" id="readnm" name="readnm" style="width: 100px" value="${cardReaderInfo[0].USERNAME }"></td>
				 	<th>&nbsp;&nbsp;고객구분</th>
					<td>
						<b class="b03">${cardReaderInfo[0].GUBUN }</b>
					</td>
				</tr>
				<tr>
					<th>&nbsp;&nbsp;독 자 ID</th>
					<td style="font-weight: bold;"><div style="padding: 3px 0">${cardReaderInfo[0].ID}</div></td>
				 	<th>&nbsp;&nbsp;결합여부</th>
					<td>
						<c:choose>
							<c:when test="${cardReaderInfo[0].JOIN_YN eq 'Y'}">결합</c:when>
							<c:otherwise>일반</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
				 	<th><span id="chkReadno"><b class="b03" >*</b>&nbsp;독자번호</span></th>
					<td ><input type="text" id="readno" name="readno" style="width: 90px" value="${cardReaderInfo[0].READNO }" <c:if test="${cardReaderInfo[0].GUBUN eq '신규' }">readonly</c:if> maxlength="9" ></td>
					<th>&nbsp;&nbsp;카드식별번호</th>
					<td><b>${cardReaderInfo[0].CARD_SEQ }</b></td>
				</tr>
				<tr>
				 	<th>&nbsp;&nbsp; 전화번호</th>
					<td>
						<select id="telNo1" name="telNo1" style="vertical-align: middle;">
							<option value="">--</option>
							<c:forEach items="${areaCode }" var="list">
								<option value="${list.CODE }" <c:if test="${list.CODE eq cardReaderInfo[0].TELNO1 }">selected="selected"</c:if>> ${list.CODE }</option>
							</c:forEach>
						</select> - 
						<input type="text" id="telNo2" name="telNo2" maxlength="4" value="${cardReaderInfo[0].TELNO2}" style="ime-Mode:disabled; width: 45px; vertical-align: middle;" onkeypress="inputNumCom();"> - 
						<input type="text" id="telNo3" name="telNo3" maxlength="4" value="${cardReaderInfo[0].TELNO3}" style="ime-Mode:disabled; width: 45px; vertical-align: middle;" onkeypress="inputNumCom();">
					</td>
				 	<th>&nbsp;&nbsp;휴대폰번호</th>
					<td>
						<select id="handy1" name="handy1" style="vertical-align: middle;">
							<c:forEach items="${mobileCode }" var="list">
								<option value="${list.CODE }" <c:if test="${list.CODE eq cardReaderInfo[0].HANDY1 }"> selected </c:if>>${list.CODE }</option>
							</c:forEach>
						</select> - 
						<input type="text" id="handy2" name="handy2" maxlength="4" value="${cardReaderInfo[0].HANDY2}" style="ime-Mode:disabled; width: 45px; vertical-align: middle;" onkeypress="inputNumCom();"> - 
						<input type="text" id="handy3" name="handy3" maxlength="4" value="${cardReaderInfo[0].HANDY3}" style="ime-Mode:disabled; width: 45px; vertical-align: middle;" onkeypress="inputNumCom();">
					</td>
				</tr>
				<tr>
				 	<th><b class="b03">*</b> 지번주소</th>
					<td colspan="3">
						<input type="text" id="zip" name="zip" value="${cardReaderInfo[0].ZIP}" readonly="readonly" style="vertical-align: middle; width: 60px" />
						<c:if test="${cardReaderInfo[0].STATUS ne '4'}"><a href="#fakeUrl" onclick="popAddr();"><img src="/images/ico_search2.gif" style="vertical-align: middle;" alt="우편번호찾기" /></a></c:if>&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="text" id="addr1" name="addr1" value="${cardReaderInfo[0].ADDR1 }" style="width: 190px; vertical-align: middle; border: 0;" readonly="readonly"  />
					</td>
				</tr>
				<tr>
				 	<th><b class="b03">*</b> 도로명주소</th>
					<td colspan="3">
						<input type="text" id="newaddr" name="newaddr" value="${cardReaderInfo[0].NEWADDR}" style="width: 450px; vertical-align: middle; border: 0;" readonly="readonly" />
					</td>
				</tr>
				<tr>
				 	<th><b class="b03">*</b> 상세주소</th>
					<td colspan="3">
						<input type="text" id="addr2" name="addr2" value="${cardReaderInfo[0].ADDR2 }" style="width: 450px;" />
					</td>
				</tr>
				<tr>
				 	<th>&nbsp; 이 메 일</th>
					<td colspan="3">
						<input type="text" id="email" name="email" style="width: 250px" value="${cardReaderInfo[0].EMAIL}"  readonly="readonly"/>
					</td>
				</tr>
				<tr>
				 	<th><b class="b03">*</b> 지 &nbsp; &nbsp; 국</th>
					<td colspan="3">
						<input type="checkbox" id="noticeYn" name="noticeYn" style="border: 0; vertical-align: middle;" <c:if test="${not empty cardReaderInfo[0].NTDT }">checked</c:if>> 지국통보여부&nbsp;<c:if test="${not empty cardReaderInfo[0].NTDT }">(${cardReaderInfo[0].NTDT})</c:if>
						<select name="boseq" id="boseq" style="vertical-align: middle; width: 130px;" onchange="fn_jikukChange();">
							<option value="">선 택</option>
							<c:forEach items="${agencyAllList }" var="list">
								<option value="${list.SERIAL }" <c:if test="${cardReaderInfo[0].BOSEQ eq list.SERIAL}">selected </c:if>>${list.NAME}(${list.SERIAL }) </option>
							</c:forEach>
						</select>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="checkbox" id="newYn" name="newYn" style="border: 0; vertical-align: middle;" <c:if test="${cardReaderInfo[0].NEWYN eq 'Y'}">checked</c:if>> 본사신규등록
					</td>
				</tr>
				<tr id="divSgbg">
					<th><b class="b03">*</b> 수금시작월</th>
					<td colspan="3"><input type="text" id="sgBgmm" name="sgBgmm" maxlength="6" style="width: 80px"/> e.g) 201309</td>
				</tr>
				<tr>
					<th><b class="b03">*</b> 부 &nbsp; &nbsp; 수</th>
					<td colspan="3">
						<input type="text" id="qty" name="qty" value ="${cardReaderInfo[0].QTY}" style="width: 30px;" /> 부&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight: bold; color: red">※ 카드독자 부수/단가 수정시 독자화면 부수/단가도 같이 수정해야 합니다.</span>
					</td>
				</tr>
				<tr>
					<th><b class="b03">*</b> 단 &nbsp; &nbsp; 가</th>
					<td>
						<input type="text" id="uprice" name="uprice" value="${cardReaderInfo[0].UPRICE}" style="width: 80px" /> 원
					</td>
				 	<th> &nbsp; 관심분야</th>
					<td>
						<select id="intfldcd" name="intfldcd">
							<option value="">미선택</option>
							<c:forEach items="${intfldcdList }" var="list">
								<option value="${list.CODE }" <c:if test="${list.CODE eq cardReaderInfo[0].INTFLDCD }"> selected </c:if> > ${list.CNAME }</option>
							</c:forEach>
						</select>
					</td>
				</tr>	
				<tr >
				 	<th>&nbsp;&nbsp;<font class="box_p">비고/통신란</font><br>&nbsp;&nbsp;"200자 내외 작성"</th>
					<td colspan="3">
						<!-- memo list -->
						<c:if test="${cardReaderInfo[0].REMK ne null}">
						<div style="padding: 5px 0; border-bottom: 1px solid #e5e5e5; width: 510px;">
							<div style="font-weight: bold; padding-bottom: 3px;">[메 모]</div>
							<div style="width: 510px; word-break: break-all;">${cardReaderInfo[0].REMK }</div>
						</div>
					</c:if>
						<c:forEach items="${memoList}" var="list" begin="0" end="2"  varStatus="status">
							<div style="padding: 5px 0; border-bottom: 1px solid #e5e5e5; width: 510px;">
								<div style="font-weight: bold; padding-bottom: 3px;">[${list.CREATE_ID}]&nbsp;${list.CREATE_DATE}</div>
								<div style="width: 510px; word-break: break-all;'">${list.MEMO}</div>
							</div>
						</c:forEach> 
						<c:if test="${fn:length(memoList) > 3}">
							<div style="padding: 3px 0; text-align: right;"><a href="#fakeUrl" onclick="fn_memo_view_more('${cardReaderInfo[0].READNO }')"><img alt="더보기" title="더보기" src="/images/ico_more.gif" /></a></div>
						</c:if>
						<!-- //memo list -->
						<div style="padding-top: 3px;"><textarea id="remk" name="remk" style="width: 95%; height: 70px;"></textarea></div>
					</td>
				</tr>	
			</table>
			<div style="width: 730px; text-align: right; padding: 10px 0 20px 0;">
				<span class="btnCss2" ><a class="lk2" onclick="saveCardReader();" style="color: blue; font-weight: bold;">저장</a></span>
				<c:choose>
					<c:when test="${chkModifyYN eq 'Y' }"> 
						<span class="btnCss2" ><a class="lk2" onclick="editCardNumber();" style="color: green; font-weight: bold;">카드변경</a></span>
					</c:when>
					<c:otherwise>
						<span class="btnCss2" ><a class="lk2" onclick="fn_cardChgError();" style="font-weight: bold;">카드변경</a></span>
					</c:otherwise>
				</c:choose>
				<span class="btnCss2" ><a class="lk2" onclick="fn_popClose();" style="font-weight: bold;">닫기</a></span>
			</div>
		</div>
		</form>
</div>
</body>
</html>