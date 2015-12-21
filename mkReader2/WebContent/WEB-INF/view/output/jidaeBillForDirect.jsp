<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript">
function fn_click_save() {
	var fm = document.getElementById("fm");
	fm.target="_self";
	fm.action = "/output/billOutput/jidaeCapture.do";
	fm.submit();
} 

/**
 * 오즈출력
 */
function fn_ozPrint(boseq){
	var fm = document.getElementById("fm");
	
	actUrl = "/output/billOutput/ozJidaePrint.do";
	window.open('','ozJidae','width=850, height=700, toolbar=no, menubar=no, location=no, status=no, resizable=1, scrollbar=no');

	fm.target = "ozJidae";
	fm.action = actUrl;
	fm.printBoseq.value = boseq;
	fm.submit();
	fm.target = "_self";
}

/**
 * 지대조회
 */
function fn_jidae_search() {
	var fm = document.getElementById("fm");
	
	fm.taget = "_self";
	fm.action = "/output/billOutput/selectJidaeViewForDirect.do";
	fm.submit();
}
</script>
<div><span class="subTitle">지대납부금통지서(직영)</span></div>
<form id="fm" name="fm" method="post">
<input type="hidden" name="orgBoseq" id="orgBoseq" value="${orgBoseq }">
<input type="hidden" name="printBoseq" id="printBoseq" value="">
<input type="hidden" name="chkJisaYn" id="chkJisaYn" value="${chkJisaYn }">
<!-- search conditions --> 
	<input type="hidden" name="boseq" id="boseq" value="${boseq }" />
	<div id="selectConditionBox" class="box_gray_left" style="width: 800px; text-align: center; padding: 10px 20px;">
		<span style="font-weight: bold; vertical-align: middle;">월분</span> &nbsp;&nbsp;
		<select name="opYYMM" id="opYYMM" style="width: 100px; vertical-align: middle;" onchange="fn_jidae_search();"> 
			<c:forEach var="list"  items="${yymmList}" varStatus="i">
				<option value="${list}" <c:if test="${opYYMM eq list}">selected="selected"</c:if>>${fn:substring(list,0,4)}년 ${fn:substring(list,4,6)}월</option>
			</c:forEach>
		</select>
	</div>
	<br/>
<div style="width: 800px; padding: 20px; border: 1px solid #e5e5e5;">
	<div style="width: 800px;">
		<div style="width: 800px; text-align: left; padding-bottom: 10px; font-weight: bold; font-size: 1.3em;">(&nbsp;${jidaerData.MONTH }&nbsp;월분)</div>
		<table class="tb_edit_4" style="width: 800px">
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
				<td>수도권1팀</td>
				<th>지국장명</th>
				<td>${jidaerData.AGENCYNM}</td>
			</tr>
		</table>
		<!-- 지대내역 -->
		<div style="padding-top: 10px;">
			<div style="font-weight: bold; font-size: 15px; padding-bottom: 3px">1. 지대내역</div>
			<table class="tb_edit_4" style="width: 800px">
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
					<th>전월미수</th>
					<td><fmt:formatNumber value="${jidaerData.MISU}" pattern="#,###" /></td>
					<th>당월조정액</th>
					<td><fmt:formatNumber value="${jidaerData.CUSTOM}" pattern="#,###" /></td>
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
					<td><fmt:formatNumber value="${jidaerData.ETCGRANT+jidaerData.BANK+jidaerData.EDU+jidaerData.GIRO+jidaerData.CARD+jidaerData.AUTOBILL+jidaerData.STU+jidaerData.TMP1+jidaerData.TMP6+jidaerData.TMP3}" pattern="#,###" /></td>
				</tr>
			</table>
		</div>
		<!-- //지대내역 -->
		<!-- 당월지대납부내역 -->
		<div style="padding-top: 10px;">
			<div style="font-weight: bold; font-size: 15px; padding-bottom: 3px">2. 당월 지대 납부내역</div>
			<table class="tb_edit_4" style="width: 800px">
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
			<table class="tb_edit_4" style="width: 800px">
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
