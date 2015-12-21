<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
	//페이지 이동
	function moveTo(where, seq) {
		var fm = document.getElementById("cardDtlPaymentForm");
		
		fm.target = "_self";
		fm.pageNo.value = seq;
		fm.action = "/reader/card/cardReaderSugmList.do";
		fm.submit();	
	}

	// 조회
	function fn_search(){
		var fm = document.getElementById("cardDtlPaymentForm");
		
		fm.target = "_self";
		fm.pageNo.value = "1";
		fm.action = "/reader/card/cardReaderSugmList.do";
		fm.submit();
		jQuery("#prcssDiv").show();
	}
	
	// mcash 카드신청 파일 업로드
	function uploadFile(){
		var fm = document.getElementById("cardDtlPaymentForm");
		var cardReaderfile = document.getElementById("cardReaderfile");
		
		// 파일첨부 확인
		if(!cardReaderfile.value) {
			cardReaderfile.focus();
			alert("파일을 첨부해 주시기 바랍니다.");
			return;
		}else if(cardReaderfile.value.indexOf(".xsl") < -1){
			cardReaderfile.focus();
			alert(".xsl 형식의 파일만 입력 가능합니다.");
			return;
		}
		
		fm.target = "_self";
		fm.action = "/reader/card/uploadCardPaymentFile.do";
		fm.submit() ;
		jQuery("#prcssDiv").show();
	}
	
	/**
	 * 카드독자 입금처리 프로세스 
	 **/
	function  fn_cardReaderSugmProcess() {
		var frm = document.getElementById("cardDtlPaymentForm");
		
		if(!confirm("수금처리를 진행하시겠습니까?")) {return;}
		
		frm.target="_self";
		frm.action = "/reader/card/updateCardPaymentToSugm.do";
		frm.submit();
		jQuery("#prcssDiv").show();
	}

	/*----------------------------------------------------------------------
	 * Desc   : 독자 상세보기
	 * Auth   : 박윤철
	 *----------------------------------------------------------------------*/
    function detailVeiw(readno){
		 var fm = document.getElementById("cardDtlPaymentForm");

		var left = (screen.width)?(screen.width - 830)/2 : 10;
		var top = (screen.height)?(screen.height - 760)/2 : 10;
		var winStyle = "width=1024,height=768,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		window.open("", "detailReaderInfo", winStyle);
		
		fm.target = "detailReaderInfo"; 
		fm.action = "/reader/minwon/popReaderDetailInfo.do?readno="+readno;
		fm.submit();
    }
	
</script>
<!-- title -->
<div><span class="subTitle">카드독자 수금</span></div> 
<!-- //title -->
<form id="cardDtlPaymentForm" name="cardDtlPaymentForm" method="post">
<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />	
<!-- search condition -->
	<div class="box_white" style="padding: 10px 0;">
		<font class="b02">지 국</font>&nbsp;
		<select name="realJikuk" id="realJikuk" style="width: 100px; vertical-align: middle;">
			<option value="">전체</option>
			<c:forEach items="${agencyAllList }" var="list">
				<option value="${list.SERIAL }" <c:if test="${realJikuk eq list.SERIAL}">selected </c:if>>${list.NAME } </option>
			</c:forEach>
		</select>&nbsp;&nbsp;&nbsp;
		<font class="b02">청구월분</font>&nbsp;
		<select name="yymm" id="yymm" style="vertical-align: middle;">
			<c:if test="${empty cardPaymentYymmList}">
				<option value="">청구이력없음</option>
			</c:if>
			<c:forEach items="${cardPaymentYymmList }" var="list">
				<option value="${list.YYMM }" <c:if test="${yymm eq list.YYMM}">selected </c:if>>
					<fmt:parseDate value="${list.YYMM}" var='tempYymm' pattern="yyyymm" scope="page"/>
					<fmt:formatDate value="${tempYymm}" type="date" pattern="yyyy-mm" />
				</option>
			</c:forEach>
		</select>&nbsp;&nbsp;&nbsp;
		<font class="b02">수금처리결과</font>&nbsp;
		<select name="opStatus" id="opStatus" style="vertical-align: middle;">
			<option value="all" <c:if test="${opStatus eq 'all'}">selected </c:if>>전체</option>
			<option value="on" <c:if test="${opStatus eq 'on'}">selected </c:if>>정상출금</option>
			<option value="err" <c:if test="${opStatus eq 'err'}">selected </c:if>>에러</option>
		</select>&nbsp;&nbsp;&nbsp;
		<font class="b02">독자ID</font>&nbsp;
		<input type="text" name="opUserId" id="opUserId" value="${opUserId }" style="width: 100px; vertical-align: middle;" maxlength="25" />&nbsp;&nbsp;&nbsp;
		<font class="b02">독자번호</font>&nbsp;
		<input type="text" name="opReadNo" id="opReadNo" value="${opReadNo }" style="width: 90px; vertical-align: middle;" maxlength="9" />
		&nbsp;&nbsp;&nbsp;<span class="btnCss2" ><a class="lk2" onclick="fn_search();" style="font-weight: bold;">조회</a></span>
		<c:if test="${loginType eq 'A'}">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<span class="btnCss2" ><a class="lk2" onclick="fn_cardReaderSugmProcess();" style="font-weight: bold;">수금처리</a></span>
		</c:if>
	</div> 
	<!-- 
	<c:if test="${loginType eq 'A'}">
		<div style="padding-top: 10px">
			<div class="box_white" style="padding: 10px 0; overflow: hidden;">
				<font class="b02">파일업로드</font>
				<input type="file" name="cardReaderfile" id="cardReaderfile" style="width: 400px; vertical-align: middle;"> &nbsp;
				<a href="#fakeUrl" onclick="uploadFile();"><img src="/images/bt_eepl.gif" style="vertical-align: middle; border: 0;" alt="파일업로드"></a>
			</div>
		</div>
	</c:if>
	 -->
	<div style="padding-top: 15px;">		
	<table class="tb_list_a" style="width: 100%;">  
		<colgroup>
			<col width="80px">
			<col width="100px">
			<col width="100px">
			<col width="120px">
			<col width="100px">
			<col width="100px">
			<col width="100px">
			<col width="130px">
			<col width="190px">
			<col/>
		</colgroup>	
		<tr>
			<th>식별번호</th>
			<th>독자ID</th>
			<th>청구월분</th>
			<th>지국</th>
			<th>독자번호</th>
			<th>수금총액</th>
			<th>수금월</th>
			<th>수금처리액</th>
			<th>수금처리결과</th>
		</tr>
		<c:choose>
			<c:when test="${empty cardReaderSugmList}">
				<tr><td colspan="9" >등록된 정보가 없습니다.</td></tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${cardReaderSugmList}" var="list" varStatus="i">
					<c:if test="${list.CARD_SEQ ne prev_row}"><c:set var="check_row" value="0" /></c:if>
					<c:if test="${list.CARD_SEQ eq prev_row}"><c:set var="check_row" value="${check_row + 1}" /></c:if>
					<tr>
						<c:if test="${check_row == 0}">
							<td style="text-align: right;" rowspan="<c:out value='${list.PARTCNT}'/>" >${list.CARD_SEQ}</td>
							<td style="text-align: left;" rowspan="<c:out value='${list.PARTCNT}'/>" >${list.ID}</td>
							<td rowspan="<c:out value='${list.PARTCNT}'/>" >${list.YYMM}</td>
							<td rowspan="<c:out value='${list.PARTCNT}'/>" >${list.JIKUKNAME}</td>
							<td rowspan="<c:out value='${list.PARTCNT}'/>" >
								<a href="#fakeUrl" onclick="detailVeiw('${list.READNO}');">${list.READNO}</a>
							</td>
							<td rowspan="<c:out value='${list.PARTCNT}'/>" >${list.BILLAMT}</td>
						</c:if>
						<td>${list.YYMM}</td>
						<td>${list.AMT}</td>
						<td>${list.SUGM_RESULT}</td>
					</tr>
					<c:set var="prev_row"><c:out value="${list.CARD_SEQ}" /></c:set>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>
	<%@ include file="/common/paging.jsp"  %>
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
