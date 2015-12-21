<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link rel="stylesheet" type="text/css" href="/css/addStyle.css">
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/js/jquery.number.min.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel='stylesheet' type='text/css' href="/select2/select2.css"/>
<script type="text/javascript">
/**
 * 검색버튼 클릭이벤트
 */
function fn_search() {
	var fm = document.getElementById("fm");
	var boseq = document.getElementById("boseq").value;
	
	if(boseq == null || boseq == '') {
		alert("지국을 선택하여 주세요.");
		return false;
	}
	
	fm.target = "_self";
	fm.action = "/management/jidae/selectJidaeDataView.do";
	fm.submit();
}

/**
 * 오즈출력
 */
function fn_ozPrint(type){
	var fm = document.getElementById("fm");
	var boseq = document.getElementById("boseq").value;
	
	//한개 지국 인쇄할때
	if("one" == type) {
		if("" == boseq || boseq == null) {
			alert("지국을 선택해주세요.");
			return false;
		} else {
			jQuery("#printAllBoseq").val("");
		}
	}
	
	actUrl = "/management/jidae/ozJidaePrint.do";
	window.open('','ozJidae','width=850, height=700, toolbar=no, menubar=no, location=no, status=no, resizable=1, scrollbar=no');

	fm.target = "ozJidae";
	fm.action = actUrl;
	fm.submit();
}

jQuery(document).ready(function($){
	$("#boseq").select2({minimumInputLength: 1});
});
</script>
<div style="padding-bottom: 5px;"><span class="subTitle">지국별지대통지서</span></div>
<form id= "fm" name = "fm" method="post">
	<input type="hidden" id="thisYear" name="thisYear" value="${opYear}" />
	<input type="hidden" id="printAllBoseq" name="printAllBoseq" value="${printAllBoseq}" />
	<div style="width: 835px; text-align: right;"><b>${opYear}년</b></div> 
	<div class="box_gray_left" style="width: 800px; text-align: center; padding: 10px 20px;">
		<span style="font-weight: bold; vertical-align: middle;">지국명</span> &nbsp;&nbsp;
		<select name="boseq" id="boseq" style="width: 100px; vertical-align: middle;">
			<option value=""> 선택</option>
			<c:forEach items="${agencyAllList }" var="list">
				<option value="${list.SERIAL }" <c:if test="${jidaerData.BOSEQCODE eq list.SERIAL}">selected </c:if>>${list.NAME } </option>
			</c:forEach>
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
		<span style="font-weight: bold; vertical-align: middle;">월분</span> &nbsp;&nbsp;
		<select name="opYear" id="opYear" style="width: 70px; vertical-align: middle; font-size: 1.2em">
			<c:forEach var="i" begin="2014" end="${thisYear}">
				<option value="${i}" <c:if test="${opYear eq i}">selected="selected"</c:if>>${i}년</option>
			</c:forEach> 
		</select>
		&nbsp;
		<select name="opMonth" id="opMonth" style="width: 60px; vertical-align: middle;">
			<c:forEach var="i" begin="1" end="12">
				<c:choose>
					<c:when test="${i < 10}">
						<c:set var="optVal" value="0${i}" />
					</c:when>
					<c:otherwise>
						<c:set var="optVal" value="${i}" />
					</c:otherwise>
				</c:choose>
				<option value="${optVal }" <c:if test="${opMonth eq optVal}">selected="selected"</c:if>>${i}월</option>
			</c:forEach>
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; 
		<span class="btnCss2"><a class="lk2" onclick="fn_search();">조회</a></span>&nbsp;
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
		<span class="btnCss2"><a class="lk2" onclick="fn_ozPrint('one');">인쇄</a></span>&nbsp;
		<span class="btnCss4"><a class="lk3" onclick="fn_ozPrint('all');">전지국인쇄</a></span>
	</div>
	<br/>
	<div style="width: 800px; padding: 20px; border: 1px solid #e5e5e5;">
		<div style="width: 800px; margin: 0 auto;"> 
			<table class="tb_edit_4_gray" style="width: 800px">
				<colgroup>
					<col width="150px">
					<col width="250px">
					<col width="150px">
					<col width="250px">
				</colgroup>
				<tr>
					<th>지 국 명</th>
					<td>${jidaerData.BOSEQNM}</td>
					<th>코드번호</th>
					<td>${jidaerData.BOSEQCODE}</td>
				</tr>
				<tr>
					<th>소&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;속</th>
					<td>${jidaerData.TYPE}</td>
					<th>지국장명</th>
					<td>${jidaerData.AGENCYNM}</td>
				</tr>
			</table>
			<!-- 지대내역 -->
			<div style="padding-top: 10px;">
				<div style="font-weight: bold; font-size: 15px; padding-bottom: 3px">1. 지대내역</div>
				<table class="tb_edit_4_gray" style="width: 800px">
					<colgroup>
						<col width="200px">
						<col width="200px">
						<col width="200px">
						<col width="200px">
					</colgroup>
					<tr>
						<th>구&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;분</th>
						<th>금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</th>
						<th>구&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;분</th>
						<th>금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</th>
					</tr>
					<tr>
						<th>전월이월액</th>
						<td><fmt:formatNumber value="${jidaerData.MISU}" pattern="#,###" /></td>
						<th>당월조정액</th>
						<td><fmt:formatNumber value="${jidaerData.CUSTOM}" pattern="#,###" /></td>
					</tr>
					<tr>
						<th colspan="3"><c:if test="${jidaerData.SUBTOTAL ne null}">지대 공제내역 및 공제금액</c:if>&nbsp;</th>
						<td><fmt:formatNumber value="${jidaerData.SUBTOTAL}" pattern="#,###" /></td>
					</tr>
					<tr>
						<th><c:if test="${jidaerData.BUSUGRANT ne null}">부수유지장려금</c:if>&nbsp;</th>
						<td><fmt:formatNumber value="${jidaerData.BUSUGRANT}" pattern="#,###" /></td>
						<th><c:if test="${jidaerData.TMP1 ne null}">소외계층,NIE</c:if></th>
						<td><fmt:formatNumber value="${jidaerData.TMP1}" pattern="#,###" /></td>
					</tr>
					<tr>
						<th><c:if test="${jidaerData.STUGRANT ne null}">학 생 장 려 금</c:if>&nbsp;</th>
						<td><fmt:formatNumber value="${jidaerData.STUGRANT}" pattern="#,###" /></td>
						<th><c:if test="${jidaerData.TMP2 ne null}">우&nbsp;&nbsp;&nbsp;편&nbsp;&nbsp;&nbsp;요&nbsp;&nbsp;&nbsp;금</c:if></th>
						<td><fmt:formatNumber value="${jidaerData.TMP2}" pattern="#,###" /></td>
					</tr>
					<tr>
						<th><c:if test="${jidaerData.ETCGRANT ne null}">기 타 장 려 금</c:if>&nbsp;</th>
						<td><fmt:formatNumber value="${jidaerData.ETCGRANT}" pattern="#,###" /></td>
						<th><c:if test="${jidaerData.TMP3 ne null}">사&nbsp;&nbsp;&nbsp;원&nbsp;&nbsp;&nbsp;구&nbsp;&nbsp;&nbsp;독</c:if></th>
						<td><fmt:formatNumber value="${jidaerData.TMP3}" pattern="#,###" /></td>
					</tr>
					<tr> 
						<th><c:if test="${jidaerData.CARD ne null}">카&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;드</c:if>&nbsp;</th>
						<td><fmt:formatNumber value="${jidaerData.CARD}" pattern="#,###" /></td>
						<th><c:if test="${jidaerData.TMP4 ne null}">기&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;타</c:if></th>
						<td><fmt:formatNumber value="${jidaerData.TMP4}" pattern="#,###" /></td>
					</tr>
					<tr>
						<th><c:if test="${jidaerData.EDU ne null}">교&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;육&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;용</c:if>&nbsp;</th>
						<td><fmt:formatNumber value="${jidaerData.EDU}" pattern="#,###" /></td>
						<th><c:if test="${jidaerData.TMP5 ne null}">지&nbsp;&nbsp;로&nbsp;/&nbsp;바&nbsp;&nbsp;코&nbsp;&nbsp;드</c:if></th>
						<td><fmt:formatNumber value="${jidaerData.TMP5}" pattern="#,###" /></td>
					</tr>
					<tr>
						<th><c:if test="${jidaerData.AUTOBILL ne null}">자&nbsp;&nbsp;&nbsp;동&nbsp;&nbsp;&nbsp;이&nbsp;&nbsp;&nbsp;체</c:if>&nbsp;</th>
						<td><fmt:formatNumber value="${jidaerData.AUTOBILL}" pattern="#,###" /></td>
						<th><c:if test="${jidaerData.TMP6 ne null}">판매수수료(VAT)</c:if></th>
						<td><fmt:formatNumber value="${jidaerData.TMP6}" pattern="#,###" /></td>
					</tr>
					<tr>
						<th><c:if test="${jidaerData.STU ne null}">학&nbsp;&nbsp;&nbsp;생&nbsp;&nbsp;&nbsp;배&nbsp;&nbsp;&nbsp;달</c:if>&nbsp;</th>
						<td><fmt:formatNumber value="${jidaerData.STU}" pattern="#,###" /></td>
						<th><c:if test="${jidaerData.TMP7 ne null}">보&nbsp;증&nbsp;금&nbsp;&nbsp;대&nbsp;체</c:if></th>
						<td><fmt:formatNumber value="${jidaerData.TMP7}" pattern="#,###" /></td> 
					</tr>
				</table>
				<c:if test="${jidaerData.TMP7 ne null}">
					<div style="padding-top: 3px">※적립보증금 지대 대체는 완납수당을 포함하여 공제하는 것을 원칙으로 합니다. 단 미수금 대체는 제외될수 있습니다.</div>
				</c:if>
			</div>
			<!-- //지대내역 -->
			<!-- 당월지대납부내역 -->
			<div style="padding-top: 10px;">
				<div style="font-weight: bold; font-size: 15px; padding-bottom: 3px">2. 당월 지대 납부내역</div>
				<table class="tb_edit_4_gray" style="width: 800px">
					<colgroup>
						<col width="200px">
						<col width="200px">
						<col width="200px">
						<col width="200px">
					</colgroup>
					<tr>
						<th>항&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</th>
						<th>금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</th>
						<th>항&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</th>
						<th>금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</th>
					</tr>
					<tr>
						<th>당월실납입액&nbsp;</th>
						<td style="font-weight: bold;"><fmt:formatNumber value="${jidaerData.J_REALAMT}" pattern="#,###" /></td>
						<th><c:if test="${jidaerData.J_OVERDATE ne null}">납 기 후 지 대</c:if></th>
						<td><fmt:formatNumber value="${jidaerData.J_OVERDATE}" pattern="#,###" /></td>
					</tr>
					<tr>
						<th><c:if test="${jidaerData.J_OKGRANT1 ne null}">완 납 장 려 금</c:if>&nbsp;</th>
						<td><fmt:formatNumber value="${jidaerData.J_OKGRANT1}" pattern="#,###" /></td>
						<th><c:if test="${jidaerData.J_OKGRANT2 ne null}">완 납 장 려 금</c:if></th>
						<td><fmt:formatNumber value="${jidaerData.J_OKGRANT2}" pattern="#,###" /></td>
					</tr>
					<tr>
						<th><c:if test="${jidaerData.J_DUEDATE ne null}">납 기 내 지 대</c:if>&nbsp;</th>
						<td style="font-weight: bold; color: blue"><fmt:formatNumber value="${jidaerData.J_DUEDATE}" pattern="#,###" /></td>
						<th><c:if test="${jidaerData.J_PAYAMT ne null}">당월지대납입액</c:if></th>
						<td style="font-weight: bold; color: #bc0546"><fmt:formatNumber value="${jidaerData.J_PAYAMT}" pattern="#,###" /></td>
					</tr>
				</table>
				<c:if test="${fn:substring(jidaerData.BOSEQCODE,0,2) ne '52'}">
					<div style="padding-top: 3px">※완납장려금은 소정 기일내에 송금하셔야 혜택을 받으실 수 있습니다.</div>
				</c:if>
			</div>
			<!-- //당월지대납부내역 --> 
			<!-- 보증금 현황 -->
			<div style="padding-top: 10px;">
				<div style="font-weight: bold; font-size: 15px; padding-bottom: 3px">3. 보증금 현황 <c:if test="${jidaerData.PREVMONTH ne null}"><span style="font-size: 0.7em; font-weight: normal;">(${jidaerData.PREVMONTH}월분 마감 및 마감기준)</span></c:if></div>
				<table class="tb_edit_4_gray" style="width: 800px">
					<colgroup>
						<col width="200px">
						<col width="200px">
						<col width="200px">
						<col width="200px">
					</colgroup>
					<tr>
						<th>전월이월액</th>
						<th>당월발생액</th>
						<th>당월감소액</th>
						<th>보증금잔액</th>
					</tr>
					<tr>
						<td style="height: 15px"><fmt:formatNumber value="${jidaerData.D_MISU}" pattern="#,###" /></td>
						<td><fmt:formatNumber value="${jidaerData.D_HAPPEN}" pattern="#,###" /></td>
						<td><fmt:formatNumber value="${jidaerData.D_MINUS}" pattern="#,###" /></td>
						<td><fmt:formatNumber value="${jidaerData.D_BALANCE}" pattern="#,###" /></td>
					</tr>
				</table>
			</div>
			<!-- //보증금 현황 -->
			<!-- 송금안내
			<div style="padding-top: 10px;">
				<div style="font-weight: bold; font-size: 15px; padding-bottom: 3px">4. 송금안내(예금주 : 매일경제신문사 장대환)</div>
				<table class="tb_edit_4" style="width: 800px">
					<colgroup>
						<col width="150px">
						<col width="250px">
						<col width="150px">
						<col width="250px">
					</colgroup>
					<tr>
						<th>은 행 명</th>
						<th>계 좌 번 호</th>
						<th>은 행 명</th>
						<th>계 좌 번 호</th>
					</tr>
					<tr>
						<th>국민은행</th>
						<td>068-01-0111-852</td>
						<th>우리은행</th>
						<td>050-055987-01-001</td>
					</tr>
					<tr>
						<th>농&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;협</th>
						<td>047-01-003083</td>
						<th>우 체 국</th>
						<td>012773-01-000022</td>
					</tr>
				</table>
			</div>
			 //송금안내 -->
			<!-- 통신란 
			<div style="padding-top: 10px;">
				<div style="font-weight: bold; font-size: 15px">5. 통신란</div>
				<div style="font-weight: bold; font-size: 14px; padding: 6px 0 3px 20px">- 독자관리 프로그램 조회 : http://mk150.mk.co.kr</div>
				<div style="font-weight: bold; font-size: 14px; padding: 3px 0 3px 20px">- 아이디(지국코드 번호), 비밀번호(주민번호 뒤 7자리)</div>
			</div>
			 통신란 -->
			<!-- bottom
			<div style="font-weight: bold; font-size: 15px; text-align: center;">
				<div style="padding: 15px 0;">상기 금액을 조정 통지하오니 상위할 경우 이의 신청하여 주시기 바랍니다.</div>
				<div>서울특별시 중구 퇴계로 190</div>
				<div style="padding: 3px 0">주식회사 매일경제신문사</div>
				<div>독자마케팅국장&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;인</div>
			</div>
			 //bottom -->
		</div>
	</div>
	<br/>
</form>
<br/>
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