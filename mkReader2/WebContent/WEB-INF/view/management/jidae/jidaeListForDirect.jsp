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
	fm.target ="";
}

jQuery(document).ready(function($){
	$("#boseq").select2({minimumInputLength: 1});
});
</script>
<div style="padding-bottom: 5px;"><span class="subTitle">지국별지대통지서</span></div>
<form id= "fm" name = "fm" method="post">
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
					<td>${jidaerData.BOSEQNM }</td>
					<th>코드번호</th>
					<td>${jidaerData.BOSEQCODE }</td>
				</tr>
				<tr>
					<th>소&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;속</th>
					<td>수도권1부</td>
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
						<td style="font-weight: bold;"><fmt:formatNumber value="${jidaerData.CUSTOM}" pattern="#,###" /></td>
					</tr>
					<tr>
						<th colspan="4">본사 입금 현황</th>
					</tr>
					<tr>
						<th>배&nbsp;&nbsp;&nbsp;달&nbsp;&nbsp;&nbsp;장&nbsp;&nbsp;&nbsp;려&nbsp;&nbsp;&nbsp;금</th>
						<td><fmt:formatNumber value="${jidaerData.ETCGRANT}" pattern="#,###" /></td> 
						<th>통&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;장</th>
						<td><fmt:formatNumber value="${jidaerData.BANK}" pattern="#,###" /></td>
					</tr>
					<tr>
						<th>교&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;육&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;용</th>
						<td><fmt:formatNumber value="${jidaerData.EDU}" pattern="#,###" /></td>
						<th>지&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;로</th>
						<td><fmt:formatNumber value="${jidaerData.GIRO}" pattern="#,###" /></td>
					</tr>
					<tr>
						<th>카&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;드</th>
						<td><fmt:formatNumber value="${jidaerData.CARD}" pattern="#,###" /></td>
						<th></th>
						<td></td>
					</tr>
					<tr> 
						<th>자&nbsp;&nbsp;&nbsp;동&nbsp;&nbsp;&nbsp;이&nbsp;&nbsp;&nbsp;체</th>
						<td><fmt:formatNumber value="${jidaerData.AUTOBILL}" pattern="#,###" /></td>
						<th></th>
						<td></td>
					</tr>
					<tr> 
						<th>학&nbsp;&nbsp;&nbsp;생&nbsp;&nbsp;&nbsp;배&nbsp;&nbsp;&nbsp;달</th>
						<td><fmt:formatNumber value="${jidaerData.STU}" pattern="#,###" /></td>
						<th></th>
						<td></td> 
					</tr>
					<tr> 
						<th>소외계층,NIE</th>
						<td><fmt:formatNumber value="${jidaerData.TMP1}" pattern="#,###" /></td>
						<th>판매수수료(VAT)</th>
						<td><fmt:formatNumber value="${jidaerData.TMP6}" pattern="#,###" /></td>
					</tr>
					<tr>
						<th>본&nbsp;&nbsp;&nbsp;사&nbsp;&nbsp;&nbsp;사&nbsp;&nbsp;&nbsp;원</th>
						<td><fmt:formatNumber value="${jidaerData.TMP3}" pattern="#,###" /></td>
						<th>소&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계</th>
						<td style="font-weight: bold; color: blue"><fmt:formatNumber value="${jidaerData.ETCGRANT+jidaerData.BANK+jidaerData.EDU+jidaerData.GIRO+jidaerData.CARD+jidaerData.AUTOBILL+jidaerData.STU+jidaerData.TMP1+jidaerData.TMP6+jidaerData.TMP3}" pattern="#,###" /></td>
					</tr>
				</table>
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
						<th>당월지대납입액</th>
						<td  style="font-weight: bold; color: #bc0546"><fmt:formatNumber value="${jidaerData.J_REALAMT}" pattern="#,###" /></td>
						<th></th>
						<td></td> 
					</tr>
				</table>
			</div>
			<!-- //당월지대납부내역 -->
			<!-- 보증금 현황 -->
			<div style="padding-top: 10px;">
				<div style="font-weight: bold; font-size: 15px; padding-bottom: 3px">3. 기타</div>
				<table class="tb_edit_4_gray" style="width: 800px">
					<colgroup>
						<col width="200px">
						<col width="200px">
						<col width="200px">
						<col width="200px">
					</colgroup>
					<tr>
						<th>항&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</th>
						<th>이 코 노 미</th>
						<th>씨&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;티</th>
						<th>&nbsp;</th>
					</tr>
					<tr>
						<th style="height: 15px">금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</th>
						<td><fmt:formatNumber value="${jidaerData.ECONOMY}" pattern="#,###" /></td>
						<td><fmt:formatNumber value="${jidaerData.CITY}" pattern="#,###" /></td>
						<td></td>
					</tr>
				</table>
			</div>
			<!-- //보증금 현황 -->
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