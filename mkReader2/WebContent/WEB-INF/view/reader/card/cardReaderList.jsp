<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ page import="com.mkreader.security.ISiteConstant" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel='stylesheet' type='text/css' href="/select2/select2.css"/>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript">
	//페이징
	function moveTo(where, seq) {
		var fm = document.getElementById("cardReaderListForm");
		
		fm.pageNo.value = seq;
		fm.target = "_self";
		fm.action = "/reader/card/cardReaderList.do";
		fm.submit();	
	}

	//검색
	function search(loginType){
		var fm = document.getElementById("cardReaderListForm");

		fm.pageNo.value = "1";
		fm.target = "_self";
		fm.flag.value = "search";
		fm.action = "/reader/card/cardReaderList.do";
		fm.submit();
		jQuery("#prcssDiv").show();
	}
	
	// 조회 벨리데이션
	function validate(){
		var fromDate = document.getElementById("fromDate").value;
		var toDate = document.getElementById("toDate").value;
		
		if(fromDate > toDate){
			alert("조회 시작일이 종료일 이후입니다.");
			return false;
		}
		return true;
	}
	
	// mcash 카드신청 파일 업로드
	function uploadFile(){
		var fm = document.getElementById("cardReaderListForm");
		var cardReaderfile = document.getElementById("cardReaderfile");
		
		// 파일첨부 확인
		if(!cardReaderfile.value) {
			cardReaderfile.focus();
			alert("파일을 첨부해 주시기 바랍니다.");
			return;
		}else if(cardReaderfile.value.indexOf(".xsl") < -1 || cardReaderfile.value.indexOf(".XSL") < -1){
			cardReaderfile.focus();
			alert(".xsl 형식의 파일만 입력 가능합니다.");
			return;
		}
		
		fm.target = "_self";
		fm.action = "/reader/card/uploadCardReaderFile.do";
		fm.submit() ;
		jQuery("#prcssDiv").show();
	}
	
	//자세히 보기
	function detailVeiw(cardSeq, readNo){
		var fm = document.getElementById("cardReaderListForm");
		if(readNo != ""){
			fm.readNo.value = readNo;
		}
		
		var left = (screen.width)?(screen.width - 750)/2 : 10;
		var top = (screen.height)?(screen.height - 770)/2 : 10;
		var winStyle = "width=750,height=770,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=0";
		newWin = window.open("", "detailVeiw", winStyle);
		newWin.focus();
		
		fm.cardSeq.value = cardSeq;
		fm.target = "detailVeiw";
		fm.action = "/reader/card/cardReaderEdit.do";
		fm.submit();
		
	}
	
	// 이체내역 조회
	function detailPaymentHist(cardSeq, readNo){
		var fm = document.getElementById("cardReaderListForm");
		
		var left = (screen.width)?(screen.width - 800)/2 : 10;
		var top = (screen.height)?(screen.height - 650)/2 : 10;
		var winStyle = "width=800,height=650,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=0";
		newWin = window.open("", "cardPaymentHist", winStyle);
		newWin.focus();
		
		fm.cardSeq.value = cardSeq;
		fm.readNo.value = readNo;
		fm.target="cardPaymentHist";
		fm.action = "/reader/card/popCardPaymentList.do";
		fm.submit();
	}
	
	// 카드 결제 해지 처리
	function fn_stopCard(cardSeq, readNo, aplcDt, userId, boseq, type){
		var fm = document.getElementById("cardReaderListForm");
		
		if(cf_getValue("chkModifyYN") != "Y") { 
			alert("카드수금처리기간(19일~20일 오후2시이전)에는 독자해지가 불가능합니다.");
			return false; 
		} 
		
		if(type == "card"){
			if(!confirm("카드결제 중지처리 하시겠습니까?")){ return; }
		}else{
			if(!confirm("구독 중지처리 하시겠습니까?")){ return; }
		}
		
		fm.cardSeq.value = cardSeq;
		fm.readNo.value = readNo;
		fm.aplcDt.value = aplcDt;
		fm.stopType.value = type;
		fm.userId.value = userId;
		fm.boseq.value = boseq;
		fm.target="_self";
		fm.action = "/reader/card/stopCardReader.do";
		fm.submit();
	}

	/*----------------------------------------------------------------------
	 * Desc   : 독자 상세보기
	 * Auth   : 박윤철
	 *----------------------------------------------------------------------*/
    function detailReader(readno){
		var fm = document.getElementById("cardReaderListForm");

		var left = (screen.width)?(screen.width - 1024)/2 : 10;
		var top = (screen.height)?(screen.height - 820)/2 : 10;
		var winStyle = "width=1024,height=828,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=0";
		var newWin = window.open("", "detailReaderInfo", winStyle);
		newWin.focus();
		
		fm.target = "detailReaderInfo"; 
		fm.action = "/reader/minwon/popReaderDetailInfo.do?readno="+readno;
		fm.submit();
    }
	
	jQuery.noConflict();
	jQuery(document).ready(function($){
		$("#realJikuk").select2({minimumInputLength: 1});
	});
</script>
<!-- title -->
<div><span class="subTitle">카드독자 리스트</span></div>
<!-- //title -->
<form id="cardReaderListForm" name="cardReaderListForm" action="" method="post" enctype="multipart/form-data">
	<input type=hidden id="pageNo" name="pageNo" value="${param.pageNo}" />
	<input type=hidden id="flag" name="flag" value="${flag }" />
	<input type=hidden id="cardSeq" name="cardSeq" value="" />
	<input type=hidden id="readNo" name="readNo" value="" />
	<input type=hidden id="userId" name="userId" value="" />
	<input type=hidden id="aplcDt" name="aplcDt" value="" />
	<input type=hidden id="stopType" name="stopType" value="" />
	<input type=hidden id="boseq" name="boseq" value="" />
	<input type=hidden id="chkModifyYN" name="chkModifyYN" value="${chkModifyYN }" />
	<input type=hidden id="chkJikukChgYN" name="chkJikukChgYN" value="${chkJikukChgYN }" />
	
<!-- search condition -->
	<div class="box_white" style="padding: 10px 0; width: 1020px; margin: 0 auto;">
		<c:if test="${loginType eq 'A'}">
			<font class="b02">지 국</font>&nbsp;
			<select name="realJikuk" id="realJikuk" style="width: 100px; vertical-align: middle;">
				<option value="">전체</option>
				<c:forEach items="${agencyAllList }" var="list">
					<option value="${list.SERIAL }" <c:if test="${realJikuk eq list.SERIAL}">selected </c:if>>${list.NAME } </option>
				</c:forEach>
			</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<!-- 
			<font class="b02">조 회 일</font>
			<input type="text" id="fromDate" name="fromDate"  value="<c:out value='${fromDate}' />" readonly="readonly" style="text-align: center; width: 85px; vertical-align: middle;" onclick="Calendar(this)" /> ~ 
			<input type="text" id="toDate" name="toDate"  value="<c:out value='${toDate}' />" readonly="readonly" style="text-align: center; width: 85px;  vertical-align: middle;" onclick="Calendar(this)"/>
			&nbsp;&nbsp;&nbsp;
			 -->
		</c:if>
		<font class="b02">상 태</font>&nbsp;
		<select name="status" id="status" style="vertical-align: middle;">
			<option value="all" <c:if test="${status eq 'all'}">selected </c:if>>전체</option>
			<option value="0" <c:if test="${status eq '0'}">selected </c:if>>신청</option>
			<option value="1" <c:if test="${status eq '1'}">selected </c:if>>정상</option>
			<option value="2" <c:if test="${status eq '2'}">selected </c:if>>해지신청</option>
			<option value="4" <c:if test="${status eq '4'}">selected </c:if>>해지</option>
		</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<select name="search_type" id="search_type" style="vertical-align: middle;">
			<option value="userName" <c:if test="${search_type eq 'userName'}">selected </c:if>>독자명</option>
			<option value="readNo" <c:if test="${search_type eq 'readNo'}">selected </c:if>>독자번호</option>
			<option value="readerId" <c:if test="${search_type eq 'readerId'}">selected </c:if>>독자ID</option>
			<option value="cardSeq" <c:if test="${search_type eq 'cardSeq'}">selected </c:if>>카드식별번호</option>
			<option value="opAddr" <c:if test="${search_type eq 'opAddr'}">selected </c:if>>주소</option>
			<option value="opHandy" <c:if test="${search_type eq 'opHandy'}">selected </c:if>>핸드폰</option>
		</select>&nbsp;&nbsp;
		<input type="text" name="search_key" id="search_key" value="${search_key }"  style="width: 140px; vertical-align: middle;" onkeydown="if(event.keyCode == 13){search(); }"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<img src="/images/bt_search.gif" style="vertical-align: middle; border: 0; cursor: pointer;" onclick="search('${loginType}');" alt="조회" />
	</div>
	<!-- 
	<c:if test="${loginType eq 'A'}">
		<div style="padding-top: 10px; width: 1020px; margin: 0 auto;">
			<div class="box_white" style="padding: 10px 0; overflow: hidden;">
				<font class="b02">파일업로드</font>
				<input type="file" name="cardReaderfile" id="cardReaderfile" class="box_250" style="width:400px;"> &nbsp;
				<a href="#fakeUrl" onclick="uploadFile();"><img src="/images/bt_eepl.gif" style="vertical-align: middle; border: 0;" alt="파일업로드"></a>
			</div>
		</div>
	</c:if>
	-->
	<div style="padding-top: 15px;">
	<table class="tb_list_a" style="width: 1020px">  
		<colgroup>
			<col width="45px">
			<col width="45px">
			<col width="100px">
			<col width="70px">
			<col width="75px">
			<col width="40px">
			<col width="60px">
			<col width="240px">
			<col width="90px">
			<col width="70px">
			<col width="50px">
			<col width="50px">
			<col width="50px">
		</colgroup>	
		<tr>
			<th>식별<br/>번호</th>
			<th>구분</th>
			<th>독자명</th>
			<th>독자번호</th>
			<th>지 국</th>
			<th>부수</th>
			<th>금 액</th>
			<th>주 &nbsp; &nbsp; &nbsp; 소</th>
			<th>전화번호</th>
			<th>신청일</th>
			<th>카드<br/>해지</th>
			<th>상 태</th>
			<th>삭제</th>
		</tr>
		<c:forEach items="${cardReaderList}" var="list" varStatus="i">
			<tr class="mover_color">
				<td>${list.CARD_SEQ}</td>
				<td>
					${list.GUBUN}<br/>
					<c:choose>
						<c:when test="${list.JOIN_YN eq 'Y'}">(결합)</c:when>
						<c:otherwise>(일반)</c:otherwise>
					</c:choose>
				</td>
				<c:choose>
					<c:when test="${loginType eq 'A'}">
						<td><a href="#fakeUrl" onclick="detailVeiw('${list.CARD_SEQ}', '${list.READNO}');"> ${list.USERNAME}</a><br/>(${list.ID})</td>
						<td><a href="#fakeUrl" onclick="detailReader('${list.READNO}');">${list.READNO}</a></td>
					</c:when>
					<c:otherwise>
						<td> ${list.USERNAME}<br/>(${list.ID})</td>
						<td>${list.READNO}</td>
					</c:otherwise>
				</c:choose>
				<td>${list.JIKUKNAME}</td>
				<td>${list.QTY}</td>
				<td><a href="#fakeUrl" onclick="detailPaymentHist('${list.CARD_SEQ}', '${list.READNO}');"> ${list.UPRICE}</a></td>
				<td style="text-align: left;"><c:if test="${list.NEWADDR ne null}" >${list.NEWADDR } <br/></c:if><b>(${list.ADDR1 })</b> ${list.ADDR2 }</td> 
				<td>
					${list.TELNO1}-${list.TELNO2}-${list.TELNO3}<br/> 
					${list.HANDY1}-${list.HANDY2}-${list.HANDY3}
				</td>
				<td>
					${list.APLCDT}
					<c:if test="${list.STATUS eq '2' or list.STATUS eq '4' }">
						<br/><font color="red">(${list.STDT})</font>
					</c:if>
				</td>
				<td>
					<c:if test="${list.STATUS ne '4' }">
						<a href="#fakeUrl" onclick="fn_stopCard('${list.CARD_SEQ}', '${list.READNO}', '${list.APLCDT}', '${list.ID}','${list.BOSEQ }','card');"><img src="/images/ico/ico_del_card.gif"  style="vertical-align: middle; width: 24px" alt="카드해지"/></a>
					</c:if>
				</td>
				<td>
					<c:choose>
						<c:when test="${list.STATUS eq '1' }">
							<font color="green"><b>정 상</b></font>
						</c:when>
						<c:when test="${list.STATUS eq '2' }">
							<font color="grey"><b>해 지<br/>신 청</b></font>
						</c:when>
						<c:when test="${list.STATUS eq '3' }">
							해 지<br/>요 청
						</c:when>
						<c:when test="${list.STATUS eq '4' }">
							<font color="red"><b>해 지</b></font>
						</c:when>
						<c:otherwise>
							<font color="blue"><b>신 청</b></font>
						</c:otherwise>
					</c:choose>
				</td>		
				<td>
					<c:if test="${list.STATUS ne '4' }">
						<a href="#fakeUrl" onclick="fn_stopCard('${list.CARD_SEQ}', '${list.READNO}', '${list.APLCDT}', '${list.ID}', '${list.BOSEQ }', 'reader');"><img src="/images/ico/ico_del_accouny.gif"  style="vertical-align: middle; width: 24px" alt="독자해지"/></a>
					</c:if>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/common/paging.jsp"%>
	</div>
</form>
<!-- processing viewer -->
<div id="prcssDiv"  class="loingProcessDiv"><div><img src="/images/process4.gif"/></div></div>
<script type="text/javascript">
/** Jquery setting */
jQuery.noConflict();
jQuery(document).ready(function($) {
	$("#prcssDiv").hide();
});
</script>
<!-- //processing viewer --> 
