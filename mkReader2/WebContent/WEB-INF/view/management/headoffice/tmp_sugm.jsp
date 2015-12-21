<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link rel="stylesheet" type="text/css" href="/css/addStyle.css">
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
/**
 * 임시수금처리 버튼 클릭이벤트
 */
function fn_tmp_sugm_process(rowCnt) {
	var fm = document.getElementById("fm");
	var sugmYYMM = document.getElementById("sugmYYMM").value;
	var sugmYYMMDD = document.getElementById("sugmYYMMDD").value;
	
	//처리여부확인
	if(rowCnt > 0) {
		alert(sugmYYMM+"임시입력은 이미 처리 되었습니다.");	
		return false;
	}
	
	if(!confirm(sugmYYMMDD+"로 임시입력을 실행하시겠습니까?")) {
		return false;
	}
	
	fm.target = "_self";
	fm.action = "/management/headoffice/insertTmpSugmData.do";
	fm.submit();
	jQuery("#prcssDiv").show();
}

/**
 * 지국별입금현황
 */
function fn_jikuk_down() {
	var fm = document.getElementById("fm");
	var currentYYMM = document.getElementById("currentYYMM").value;
	
	if(currentYYMM == null || currentYYMM == '') {
		alert("대상추출전에는 엑셀다운이 불가합니다.");
		return false;
	}
	
	if(!confirm("본사사원수금현황 엑셀파일을 다운하시겠습니까?")) {
		return false;
	}
	
	fm.target = "_self";
	fm.action = "/management/headoffice/createExcelFile.do";
	fm.submit();
}
</script>
<div style="padding-bottom: 5px;"><span class="subTitle">대상추출/임시입력</span></div>
<c:choose>
	<c:when test="${rowCnt < 1}">
		<form name="fm" id="fm" method="post">
			<input type="hidden" name="currentYYMM" id="currentYYMM" value="">
			<div style="width: 400px;">
				<table class="tb_edit_left" style="width: 400px">
					<colgroup>
						<col width="150px">
						<col width="250px">
					</colgroup>
					<tr>
						<th>입력년월</th>
						<td style="font-weight: bold; size: 15px">
							${currentYYMM } 
							<input type="hidden" name="sugmYYMM" id="sugmYYMM"  value="${currentYYMM }" />
						</td>
					</tr>
					<tr>
						<th>월급출금일</th>
						<td><input type="text" name="sugmYYMMDD" id="sugmYYMMDD"  value="${currentYYMM }25" style="width: 80px;" maxlength="8" /></td>
					</tr>
				</table>
			</div>
		</form>
		<div style="width: 400px; text-align: right; padding-top: 10px;">
			<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="fn_tmp_sugm_process('${rowCnt}');" style="text-decoration: none;">임시입력</a></span>
		</div>		
	</c:when>
	<c:otherwise>
		<form name="fm" id="fm" method="post">
			<input type="hidden" name="currentYYMM" id="currentYYMM" value="${currentYYMM }">
		</form>
		<div class="box_gray_left" style="font-weight: bold; font-size: 20px; padding: 30px 0; width: 900px">
			<div>${currentYYMM }월분 본사사원 임시입력은 완료 되었습니다.</div>
			<div style="padding-top: 20px;">수금처리는 월급일에 처리됩니다. 엑셀파일 다운이 가능합니다.</div>
		</div>
		<div style="width: 900px; text-align: right; padding-top: 10px;">
			<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="fn_jikuk_down();" style="text-decoration: none;">엑셀다운</a></span>
		</div>	
		<div style="width: 917px; padding-top: 10px;">
			<table class="tb_list_a" style="width: 900px; margin: 0;">
				<colgroup>
					<col width="100px">
					<col width="100px">
					<col width="100px">
					<col width="100px">
					<col width="100px">
					<col width="100px">
					<col width="100px">
					<col width="100px">
				</colgroup>
				<tr>
					<th>지국명</th> 
					<th>독자명</th>
					<th>독자번호</th>
					<th>신문명</th>
					<th>월분</th>
					<th>청구액</th>
					<th>부수</th>
					<th>수금예정액</th>
				</tr>
			</table>
			<c:set var="totAmt" value="0" />
			<c:set var="totQty" value="0" />
			<div style="width: 917px; height: 400px; overflow-y: scroll; margin: 0; padding: 0;">
				<table class="tb_list_a" style="width: 900px; margin: 0;">
					<colgroup>
						<col width="100px">
						<col width="100px">
						<col width="100px">
						<col width="100px">
						<col width="100px">
						<col width="100px">
						<col width="100px">
						<col width="100px">
					</colgroup>
					<c:forEach items="${tmpSugmList }" var="list">
						<tr>
							<td>${list.JIKUKNM}</td>
							<td>${list.READNM}</td>
							<td>${list.READNO}</td>
							<td>${list.NEWSCDNM}</td>
							<td>${list.YYMM}</td>
							<td>${list.BILLAMT}</td>
							<td>${list.BILLQTY}</td>
							<td>${list.AMT}</td>
						</tr>
						<c:set var="totAmt" value="${totAmt+list.BILLAMT}" />
						<c:set var="totQty" value="${totQty+list.BILLQTY}" />
					</c:forEach>
				</table>
			</div> 
			<div style="width: 917px; text-align: right; padding-top: 10px; font-weight: bold;">
				총부수 : <span style="color: green; font-weight: bold"><fmt:formatNumber value="${totQty }"  type="number"/></span>&nbsp;부&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;총금액 : <span style="color: red;  font-weight: bold"><fmt:formatNumber value="${totAmt }"  type="number"/></span>&nbsp;원
			</div>
	</c:otherwise>
</c:choose>
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