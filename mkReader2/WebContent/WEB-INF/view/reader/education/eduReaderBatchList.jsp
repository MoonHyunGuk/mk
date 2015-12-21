<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ page import="com.mkreader.security.ISiteConstant" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<link rel="stylesheet" type="text/css" href="/css/addStyle.css" />
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
/**
 * 검색버튼 클릭 펑션
 */
function fn_search(){
	var searchTextVal = document.getElementById("searchText").value;
	
	//null 체크
	if(searchTextVal == '' || searchTextVal == null) {
		alert("값을 입력하세요.");
		return false;
	}
	
	jQuery("#prcssDiv").show();
	educationForm.target = "_self";
	educationForm.action = "/reader/education/searchEduReaderBatchList.do";
	educationForm.submit();
}

/**
 * 체크박스 전체 선택/해지
 */
function fn_chkboxClick(val) {
	var eduChkList = document.getElementsByName("eduChk");
	
	if(val) {	//전체 선택시
		for(var i=0; i<eduChkList.length; i++) {
			eduChkList[i].checked = true;
		}	
	} else {
		for(var i=0; i<eduChkList.length; i++) {
			eduChkList[i].checked = false;
		}
	}
}

/**
 * 개별 체크 해지시 전체선택 박스 체크해지
 */
function fn_allChkboxChecked(val) {
	if(!val) { //체크해지시
		document.getElementById("allChkbox").checked = false;
	} 
}

/**
 * 체크박스 선택 값 체크
 * @param name : 체크박스 name
 * @returns {String}
 */
function fn_checkBoxChk(name) {
	var checkObj = document.getElementsByName(name);
	var checkObjLen = checkObj.length;
	var result = '';
	var qtyCnt = 0;
	var cutNm = '';
	
	if(checkObjLen > 0) {
		for(var i=0;i<checkObjLen;i++) {
			if(checkObj[i].checked == true) {
				result += "'"+checkObj[i].value + "',";
			}
		}
	} 
	
	if(result.length > 1) {
		result = result.substring(0, result.length-1);
	}
	return result;
}
  
/**
 * 독자일괄해지 버튼 클릭 펑션
 */
function fn_all_cancel() {
	var fm = document.getElementById("educationForm");
	var chkList = fn_checkBoxChk("eduChk");
	var cancelDate = document.getElementById("cancelDate").value;
	
	if(chkList.length < 1) {
		alert("해지할 독자를 선택해 주세요.");
		return false;
	}
	
	if(!cf_checkNull("cancelDate", "해지일")) {return false;}
	if(!cf_checkNull("cancelMemo", "메모")) {return false;}
	
	
	
	/*
	if(!confirm("선택한 교육용 독자를 "+cancelDate+"일로 해지 하시겠습니까?")){
		return false;
	}
	
	fm.chkList.value = chkList;
	fm.target = "_self";
	fm.action = "/reader/education/deleteEduReaderBatch.do"
	fm.submit();
	*/
	
}

/**
 * 일괄등록 입력 버튼 클릭 펑션
 */
function fn_insert_edureaders(){
	var fm = document.getElementById("educationForm");;
	var readersfile = document.getElementById("readersfile").value;
	
	if(readersfile == null || readersfile == '') {
		alert("파일을 첨부해 주시기 바랍니다.");
		fm.readersfile.focus();
		return false;
	} else {
		if(readersfile.indexOf("xls") > -1) {
			if(readersfile.indexOf("xlsx") > -1) {
				alert(".xls 형식 파일만 입력 가능합니다.");
				fm.readersfile.focus();
				return false;
			}
		} else {
			alert(".xls 형식 파일만 입력 가능합니다.");
			fm.readersfile.focus();
			return false;
		}
	}
	
	var left = (screen.width)?(screen.width - 1200)/2 : 10;
	var top = (screen.height)?(screen.height - 800)/2 : 10;
	var winStyle = "width=1200,height=800,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=0";
	var newWin = window.open("", "pop_review", winStyle);
	fm.target = "pop_review";
	fm.action = "/reader/education/reviewEduReadersForExcel.do";
	fm.submit();
}

/** Jquery setting */
jQuery.noConflict();
jQuery(document).ready(function($) {
	$("#prcssDiv").hide();
});
</script>
<form id="educationForm" name="educationForm" action="" method="post" ENCTYPE="multipart/form-data">
	<input type="hidden" id="chkList" name="chkList" value="" />
	<input type="hidden" id="readNo" name="readNo" value="" />
	<div style="padding-bottom: 15px;"> 
		<span class="subTitle">교육용 구독관리(일괄작업)</span>
	</div>
	<!-- search condition -->
	<div style="width: 500px; float: left; padding-right: 10px;">
		<table class="tb_search" style="width: 500px;">
			<colgroup>
				<col width="50px">
				<col width="450px">
			</colgroup>
			<tr>
				<th>검색<br />조건</th>
				<td>
					<select id="status" name="status" style="vertical-align: middle;" onchange="fn_search();">
						<option value="1" <c:if test="${param.status eq '1' }"> selected </c:if>>전 체</option>
						<option value="2" <c:if test="${param.status eq '2' }"> selected </c:if>>정 상</option>
						<option value="3" <c:if test="${param.status eq '3' }"> selected </c:if>>해 지</option>
					</select>
					&nbsp;&nbsp;
					<select id="searchKey" name="searchKey" style="vertical-align: middle;" >
						<option value="readnm" <c:if test="${param.searchKey eq 'readnm' }"> selected </c:if>>성 명</option>
						<option value="company" <c:if test="${param.searchKey eq 'company' }"> selected </c:if>>회 사 명</option>
						<option value="readno" <c:if test="${param.searchKey eq 'readno' }"> selected </c:if>>독자번호</option>
					</select>
					&nbsp;&nbsp;
					<input type="text" id="searchText" name="searchText" value="${param.searchText}" style="width: 150px; vertical-align: middle;" value="${param.searchText }" onkeydown="if(event.keyCode == 13){fn_search(); }"/>
					&nbsp;&nbsp;
					<a href="#fakeUrl" onclick="fn_search();"><img src="/images/bt_search.gif" style="vertical-align: middle; border: 0; cursor: pointer;" ></a>
				</td>
			</tr>
		</table>
	</div>
	<div style="width: 510px; float: left;">
		<table class="tb_search" style="width: 510px;">
		<colgroup>
				<col width="50px">
				<col width="460px">
			</colgroup>
			<tr>
				<th>일괄<br />등록</th>
				<td>
					<input type="file" name="readersfile" id="readersfile" style="width:340px; vertical-align: middle;">&nbsp; &nbsp; 
					<a href="#fakeUrl" onclick="fn_insert_edureaders();"><img src="/images/bt_eepl.gif" style="vertical-align: middle; border: 0;"></a>
				</td>
			</tr>
		</table>
	</div>
	<!-- //search condition -->
	<div style="padding-top: 3px; text-align: right; clear: both; border: 0px solid">
		<b class="b03">* .xls 파일만 등록 가능합니다.</b>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<img alt="일괄등록폼" title="일괄등록폼" src="/images/ico_excel.png" style="vertical-align: middle; border: 0;"> <a href="/form/reader_batch_form.xls" target="_self" style="font-weight: bold; color: #000">일괄등록폼다운</a>&nbsp;
	</div>
	<!-- list -->
	<div class="box_list">
		<!-- 해지 설정 -->
		<div style="padding: 5px 0 5px 0; overflow: hidden;">
			<table class="tb_search" style="width: 1020px; float: right;">
				<colgroup>
					<col width="80px">
					<col width="100px">
					<col width="80px">
					<col width="680px">
				</colgroup>
				<tr>
					<th>해지일</th>
					<td><input type="text" id="cancelDate" name="cancelDate"  value="" readonly="readonly" onclick="Calendar(this)" style="width: 75px; padding: 5px;"/></td>
					<th>메 모</th>
					<td>
						<div style="float: left;"><input type="text" id="cancelMemo" name="cancelMemo"  value="" style="width: 570px; vertical-align: middle; padding: 5px;" maxlength="200"/>&nbsp;&nbsp;</div>
						<div style="float: left;"><div class="btnCss4"><a class="lk3" href="#fakeUrl" onclick="fn_all_cancel();" style="text-decoration: none;">독자일괄해지</a></div></div>
					</td>
				</tr>
			</table>
		</div>
		<!-- //해지 설정 -->
		<table class="tb_list_a" style="width: 1020px;">  
			<colgroup>
				<col width="30px">
				<col width="60px">
				<col width="120px">
				<col width="140px">
				<col width="290px">
				<col width="105px">
				<col width="35px">
				<col width="40px">
				<col width="85px">
				<col width="65px">
				<col width="50px">
			</colgroup>	
			<tr>
				<th><input type="checkbox" name="allChkbox"  id="allChkbox"  style="border: 0;" onclick="fn_chkboxClick(this.checked)" /></th>
				<th>지국</th>
				<th>회사명</th>
				<th>독자명</th>
				<th>주소</th>
				<th>연락처</th>
				<th>부수</th>
				<th>단가</th>
				<th>신청일<br/>(해지일)</th>
				<th>독자번호</th>
				<th>상태</th>
			</tr>
		</table>
		<div style="width: 1020px; height: 550px; overflow-y: scroll; overflow-x: none; border-bottom: 1px solid #e5e5e5">
		<table class="tb_list_a" style="width: 1003px;">  
			<colgroup>
				<col width="30px">
				<col width="60px">
				<col width="120px">
				<col width="140px">
				<col width="290px">
				<col width="105px">
				<col width="35px">
				<col width="40px">
				<col width="85px">
				<col width="65px">
				<col width="33px">
			</colgroup>	
			<c:choose>
				<c:when test="${fn:length(educationList) < 1}">
					<tr><td colspan="11" style="padding: 10px 0; font-weight: bold;">조회된 독자가 없습니다.</td></tr>
				</c:when>
				<c:otherwise>
					<c:forEach items="${educationList }" var="list" varStatus="cnt">
						<tr class="mover_color">
							<td>
								<c:if test="${list.DELYN ne 'Y' }"> 
									<input type="checkbox" name="eduChk"  id="eduChk_${list.ROWNUM}" value="${list.READNO}"  style="border: 0;" onclick="fn_allChkboxChecked(this.checked)" />
								</c:if>
							</td>
							<td style="text-align: left;">${list.AGENTNM}</td>	
							<td style="text-align: left;"><div style="width: 110px;">${list.COMPANY_TEMP}</div></td>
							<td style="text-align: left;"><div style="width: 130px;">&nbsp;&nbsp;${list.READNM}</div></td>
							<td style="text-align: left;"><div style="width: 280px;">${list.DLVADRS1} ${list.DLVADRS2}</div></td>
							<td>${list.TEL }</td>
							<td>${list.QTY }<input type="hidden" name="qty" id="qty_${list.ROWNUM}" value="${list.QTY }" /></td>
							<td>${list.UPRICE }</td>
							<c:choose>
								<c:when test="${list.DELYN eq 'Y' }">
									<td>${list.HJDT }<br/>(<font class="b03">${list.STDT }</font>)</td>
									<td>${list.READNO }</td>
									<td><font class="b03">해지</font></td>
								</c:when>
								<c:otherwise>
									<td>${list.HJDT }</td>
									<td>${list.READNO }</td>
									<td>정상</td>
								</c:otherwise>
							</c:choose>
							<!-- 
							<td><a href="#fakeUrl" onclick="del('${list.SEQ }','${list.READNO }','${list.BOSEQ }');"><img src="/images/bt_imx.gif" alt="삭제" style="vertical-align: middle; border: 0;"/></a></td>
							 -->
						</tr>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</table> 
		</div>
	</div>
	<!-- //list -->
</form>
<!-- processing viewer --> 
<div id="prcssDiv"  class="loingProcessDiv"><div><img src="/images/process4.gif"/></div></div>
<!-- //processing viewer --> 