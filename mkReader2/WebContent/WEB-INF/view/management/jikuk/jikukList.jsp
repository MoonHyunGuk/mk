<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" type="text/css" href="/css/addStyle.css">
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
/**
 * 지국 조회
 */
function fn_selectJikukReaderList() {
	var fm = document.getElementById("frm");
	
	//폐국지국명
	if(!cf_checkNull("opJikukNm", "폐국지국명")) {return false;};
	
	//통합지국명
	if(!cf_checkNull("opCombineJikukNm", "통합지국명")) {return false;};
	
	fm.target = "_self";
	fm.action = "/management/jikuk/selectjikukReaderList.do";
	fm.submit();
}

/**
 * 전체통폐합 버튼 클릭 이벤트
 */
function fn_combine_jikuk(type) {
	var fm = document.getElementById("frm");
	var opJikukNm = document.getElementById("opJikukNm").value;
	var combineJikukNm = document.getElementById("opCombineJikukNm").value;
	var bnoChgYn = "";
	var alertTxt = "";

	if("gnoY" == type) { //구역변경시
		//카드독자 구역
		if(!cf_checkNull("cardGno", "카드독자 구역")) {return false;};
		
		//교육용독자 구역
		if(!cf_checkNull("eduGno", "교육용독자 구역")) {return false;};
		
		//소외계층독자 구역
		if(!cf_checkNull("alienationGno", "소외계층독자 구역")) {return false;};
		
		//일반자동이체독자 구역
		if(!cf_checkNull("transferGno", "일반자동이체독자 구역")) {return false;};
		
		//학생자동이체독자 구역
		if(!cf_checkNull("transferStuGno", "학생자동이체독자 구역")) {return false;};
		
		bnoChgYn = "Y";
		alertTxt = "구역변경으로 ";
	} else { //구역 그대로 이전시
		bnoChgYn = "N";
		alertTxt = "구역변경없이 ";
	}
	
	if(!confirm(opJikukNm+"지국(폐국)을 "+alertTxt+combineJikukNm+"지국과 통합하시겠습니까?")) {return false;}
	
	fm.target = "_self";
	fm.action = "/management/jikuk/combineJikukProcess.do";
	fm.bnoChgYn.value = bnoChgYn;
	fm.submit();
	jQuery("#prcssDiv").show();
}
</script>
<div style="padding-bottom: 5px;"><span class="subTitle">지국통폐합</span></div>
<form id= "frm" name = "frm" method="post">
<input type="hidden" name="closejikukCode" id="closejikukCode" value="${jikukCode}" /> 
<input type="hidden" name="combineJikukCode" id="combineJikukCode" value="${combineJikukCode}" />
<input type="hidden" name="bnoChgYn" id="bnoChgYn" />
<!-- search conditions -->	
<div style="padding-bottom: 8px;">
	<table class="tb_search" style="width: 1020px">
		<colgroup>
			<col width="160px">
			<col width="351px">
			<col width="160px">
			<col width="351px">
		</colgroup>
		<tr>
			<th>폐국지국명</th>
			<td>
				<input type="text"   id="opJikukNm" name="opJikukNm" maxlength="10"  value="<c:out value="${opJikukNm}"/>"  style="width: 80px; vertical-align: middle;">
				<input type="text"  value="<c:out value="${jikukCode}"/>"  style="width: 60px; vertical-align: middle; background-color: #e5e5e5" readonly="readonly">
			</td>
			<th>통합지국명</th>
			<td>
				<input type="text"   id="opCombineJikukNm" name="opCombineJikukNm" maxlength="10"  value="<c:out value="${opCombineJikukNm}"/>"  style="width: 80px; vertical-align: middle;">
				<input type="text"  value="<c:out value="${combineJikukCode}"/>"  style="width: 60px; vertical-align: middle; background-color: #e5e5e5" readonly="readonly">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="#fakeUrl" onclick="fn_selectJikukReaderList();"><img src="/images/bt_joh.gif" style="vertical-align: middle; border: 0" alt="조회"></a>   
			</td>
		</tr>
	</table>
</div>
<!-- //search conditions -->
<c:set var="cardReaderCount" value="0" />
<c:set var="eduReaderCount" value="0" />
<c:set var="alienationReaderCount" value="0" />
<c:set var="transferReaderCount" value="0" />
<c:set var="transferStuReaderCount" value="0" />
<div style="width: 1020px; margin: 0 auto; overflow: hidden;">
	<div style="width: 720px; padding: 10px 10px 0 10px;  border: 1px solid #e5e5e5; float: left;">
		<div style="width: 720px; overflow: hidden; padding-bottom: 5px;">
			<!-- 카드독자 -->
			<div style="width: 230px; padding: 0 10px 0 6px; float: left;;">
				<div class="pop_title">폐국카드독자</div>
				<div style="padding: 10px 0 5px 0;">
					<div class="box_gray" style="width: 220px; padding: 5px 0; font-weight: bold;">
						이전할 구역 <input type="text" name="cardGno" id="cardGno" maxlength="3" style="width: 40px;">
					</div>
				</div>
				<table class="tb_list" style="width: 220px;">
					<colgroup>
						<col width="70px">
						<col width="150px">
					</colgroup>
					<tr>
						<th>독자번호</th>
						<th>성 명</th>
					</tr>
				</table>
				<div style="width: 220px; height: 230px; overflow-x: none; overflow-y: scroll;">
				<table class="tb_list" style="width: 203px;">
					<colgroup>
						<col width="70px">
						<col width="133px">
					</colgroup>
					<c:forEach items="${cardReaderList}" var="list"  varStatus="status">
					<tr>
						<td>${list.READNO}</td>
						<td style="text-align: left; <c:if test='${list.USEYN eq "Y" }'>color: #ff0000;</c:if>">${list.READNM}<c:if test='${list.USEYN eq "Y" }'>(해지)</c:if></td>
					</tr>
					<c:set var="cardReaderCount" value="${cardReaderCount+1}" />
					</c:forEach>
				</table>
				</div>
			</div>
			<!--// 카드독자 -->
			<!-- 교육용독자 -->
			<div style="width: 230px; padding-right: 10px; float: left;">
				<div class="pop_title">폐국교육용독자</div>
				<div style="padding: 10px 0 5px 0;">
					<div class="box_gray" style="width: 220px; padding: 5px 0; font-weight: bold;">
						이전할 구역 <input type="text" name="eduGno" id="eduGno" maxlength="3" style="width: 40px;">
					</div>
				</div>
				<table class="tb_list" style="width: 220px;">
					<colgroup>
						<col width="70px">
						<col width="150px">
					</colgroup>
					<tr>
						<th>독자번호</th>
						<th>성 명</th>
					</tr>
				</table>
				<div style="width: 220px; height: 230px; overflow-x: none; overflow-y: scroll;">
				<table class="tb_list" style="width: 203px;">
					<colgroup>
						<col width="70px">
						<col width="133px">
					</colgroup>
					<c:forEach items="${eduReaderList}" var="list"  varStatus="status">
					<tr>
						<td>${list.READNO}</td>
						<td style="text-align: left; <c:if test='${list.USEYN eq "Y" }'>color: #ff0000;</c:if>">${list.READNM}<c:if test='${list.USEYN eq "Y" }'>(해지)</c:if></td>
					</tr>
					<c:set var="eduReaderCount" value="${eduReaderCount+1}" />
					</c:forEach>
				</table>
				</div>
			</div>
			<!--// 교육용독자 -->
			<!-- 소외계층독자 -->
			<div style="width: 230px; float: left;">
				<div class="pop_title">폐국소외계층독자</div>
				<div style="padding: 10px 0 5px 0;">
					<div class="box_gray" style="width: 220px; padding: 5px 0; font-weight: bold;">
						이전할 구역 <input type="text" name="alienationGno" id="alienationGno" maxlength="3" style="width: 40px;">
					</div>
				</div>
				<table class="tb_list" style="width: 220px;">
					<colgroup>
						<col width="70px">
						<col width="150px">
					</colgroup>
					<tr>
						<th>독자번호</th>
						<th>성 명</th>
					</tr>
				</table>
				<div style="width: 220px; height: 230px; overflow-x: none; overflow-y: scroll;">
				<table class="tb_list" style="width: 203px;">
					<colgroup>
						<col width="70px">
						<col width="133px">
					</colgroup>
					<c:forEach items="${alienationReaderList}" var="list"  varStatus="status">
					<tr>
						<td>${list.READNO}</td>
						<td style="text-align: left; <c:if test='${list.USEYN eq "Y" }'>color: #ff0000;</c:if>">${list.READNM}<c:if test='${list.USEYN eq "Y" }'>(해지)</c:if></td>
					</tr>
					<c:set var="alienationReaderCount" value="${alienationReaderCount+1}" />
					</c:forEach>
				</table>
				</div>
			</div>
			<!--// 소외계층독자 -->
		</div>
		<div style="width: 720px; clear: both;  overflow: hidden; border-top: 1px solid #e5e5e5; padding: 5px 0 10px 0; ">
			<!-- 일반자동이체독자 -->
			<div style="width: 230px; padding: 0 10px 0 6px; float: left">
				<div class="pop_title">폐국일반자동이체독자</div>
				<div style="padding: 10px 0 5px 0;">
					<div class="box_gray" style="width: 220px; padding: 5px 0; font-weight: bold;">
						이전할 구역 <input type="text" name="transferGno" id="transferGno" maxlength="3" style="width: 40px;">
					</div>
				</div>
				<table class="tb_list" style="width: 220px;">
					<colgroup>
						<col width="70px">
						<col width="150px">
					</colgroup>
					<tr>
						<th>독자번호</th>
						<th>성 명</th>
					</tr>
				</table>
				<div style="width: 220px; height: 230px; overflow-x: none; overflow-y: scroll;">
				<table class="tb_list" style="width: 203px;">
					<colgroup>
						<col width="70px">
						<col width="133px">
					</colgroup>
					<c:forEach items="${transferReaderList}" var="list"  varStatus="status">
					<tr>
						<td>${list.READNO}</td>
						<td style="text-align: left; <c:if test='${list.USEYN eq "Y" }'>color: #ff0000;</c:if>">${list.READNM}<c:if test='${list.USEYN eq "Y" }'>(해지)</c:if></td>
					</tr>
					<c:set var="transferReaderCount" value="${transferReaderCount+1}" />
					</c:forEach>
				</table>
				</div>
			</div>
			<!--// 일반자동이체독자 -->
			<!-- 학생자동이체독자 -->
			<div style="width: 230px; padding-right:10px; float: left;">
				<div class="pop_title">폐국학생자동이체독자</div>
				<div style="padding: 10px 0 5px 0;">
					<div class="box_gray" style="padding: 5px 0; font-weight: bold;">
						이전할 구역 <input type="text" name="transferStuGno" id="transferStuGno" maxlength="3" style="width: 40px;">
					</div>
				</div>
				<table class="tb_list" style="width: 220px;">
					<colgroup>
						<col width="70px">
						<col width="150px">
					</colgroup>
					<tr>
						<th>독자번호</th>
						<th>성 명</th>
					</tr>
				</table>
				<div style="width: 220px; height: 230px; overflow-x: none; overflow-y: scroll;">
				<table class="tb_list" style="width: 203px;">
					<colgroup>
						<col width="70px">
						<col width="133px">
					</colgroup>
					<c:forEach items="${transferStuReaderList}" var="list"  varStatus="status">
					<tr>
						<td>${list.READNO}</td>
						<td style="text-align: left; <c:if test='${list.USEYN eq "Y" }'>color: #ff0000;</c:if>">${list.READNM}<c:if test='${list.USEYN eq "Y" }'>(해지)</c:if></td>
					</tr>
						<c:set var="transferStuReaderCount" value="${transferStuReaderCount+1}" />
					</c:forEach>
				</table>
				</div>
			</div>
			<!--// 학생자동이체독자 -->
			<!-- total -->
			<div style="width: 230px; float: left;">
				<div class="pop_title">폐국독자수</div>
				<div style="overflow: hidden; padding-top: 10px">
					<table class="tb_edit" style="width: 220px;">
						<colgroup>
							<col width="150px">
							<col width="70px">
						</colgroup>
						<tr>
							<th>카드독자수</th>
							<td><span style="color: #ff0000; font-weight: bold;">${cardReaderCount}</span>명</td>
						</tr>
						<tr>
							<th>교육용독자수</th>
							<td><span style="color: #ff0000; font-weight: bold;">${eduReaderCount}</span>명</td>
						</tr>
						<tr>
							<th>소외계층독자수</th>
							<td><span style="color: #ff0000; font-weight: bold;">${alienationReaderCount}</span>명</td>
						</tr>
						<tr>
							<th>일반자동이체독자수</th>
							<td><span style="color: #ff0000; font-weight: bold;">${transferReaderCount}</span>명</td>
						</tr>
						<tr>
							<th>학생자동이체독자수</th>
							<td><span style="color: #ff0000; font-weight: bold;">${transferStuReaderCount}</span>명</td>
						</tr>
					</table>
					<br />
					<table class="tb_edit" style="width: 220px;">
						<colgroup>
							<col width="150px">
							<col width="70px">
						</colgroup>
						<tr>
							<th>우편번호갯수</th>
							<td><span style="color: #ff0000; font-weight: bold;">${zipcodeCnt}</span>개</td>
						</tr>
					</table>
				</div>
				<div style="padding-top: 20px;">
					<div style="width: 220px; background-color: #ececec; border: 1px solid #e5e5e5; padding: 15px 10px; text-align: center;">
						<div class="btnCss4">
							<a class="lk3" href="#fakeUrl" onclick="fn_combine_jikuk('gnoY');" style="text-decoration: none;">독자통합(구역O)</a>
						</div>
						<div class="btnCss4" style="padding-top: 10px">
							<a class="lk3" href="#fakeUrl" onclick="fn_combine_jikuk('gnoN');" style="text-decoration: none;">독자통합(구역X)</a>
						</div>
					</div>
				</div>
			</div>
			<!-- //total -->
		</div>
	</div>
	<div style="width: 6px; float: left;">&nbsp;</div>
	<div style="width: 240px; float: left;  border: 1px solid #e5e5e5; padding: 18px 15px 15px 15px;">
		<div class="pop_title">폐국우편번호</div>
		<div style="padding-top: 10px;">
			<table class="tb_list" style="width: 240px;">
				<colgroup>
					<col width="70px">
					<col width="170px">
				</colgroup>
				<tr>
					<th>우편번호</th>
					<th>주 소</th>
				</tr>
			</table>
			<div style="width: 240px; height: 608px; overflow-x: none; overflow-y: scroll;">
			<table class="tb_list" style="width: 223px;">
				<colgroup>
					<col width="70px">
					<col width="163px">
				</colgroup>
				<c:forEach items="${zipcodeList}" var="list"  varStatus="status">
				<tr>
					<td>${list.ZIP}</td>
					<td style="text-align: left;">${list.TXT}</td>
				</tr>
				</c:forEach>
			</table>
			</div>
		</div>
	</div>
</div>
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