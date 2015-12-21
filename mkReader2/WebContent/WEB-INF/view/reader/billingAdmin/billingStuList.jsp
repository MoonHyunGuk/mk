<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel='stylesheet' type='text/css' href="/select2/select2.css"/>
<script type="text/javascript">
//페이징
function moveTo(where, seq) {
	var fm = document.getElementById("billingListForm");
	var realJikuk = document.getElementById("realJikuk").value;
	var search_key = document.getElementById("search_key").value;
	var status = document.getElementById("status").value;

	if(realJikuk  != "" || search_key  != "" || status != "EA00"){
		fm.pageNo.value = seq;
		fm.target = "_self";
		fm.action = "/reader/billingStuAdmin/searchBilling.do";
		fm.submit();
	}else{
		fm.pageNo.value = seq;
		fm.target = "_self";
		fm.action = "/reader/billingStuAdmin/billingList.do";
		fm.submit();	
	}
}

//검색
function fn_search(){
	var fm = document.getElementById("billingListForm");
	var search_type = document.getElementById("search_type").value;
	
	if(search_type== 'jikuk' ){
		document.getElementById("realJikuk").value = "";
	}
	fm.pageNo.value = "1";
	fm.target = "_self";
	fm.action = "/reader/billingStuAdmin/searchBilling.do";
	fm.submit();
}
	
//자세히 보기
function detailVeiw(numId){
	var fm = document.getElementById("billingListForm");

	var left = (screen.width)?(screen.width - 750)/2 : 10;
	var top = (screen.height)?(screen.height - 850)/2 : 10;
	var winStyle = "width=750,height=850,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
	newWin = window.open("", "detailVeiw", winStyle);
	newWin.focus();
	
	fm.target = "detailVeiw";
	fm.action = "/reader/billingStuAdmin/billingInfo.do?numId="+numId;
	fm.submit();
}

//납부이력보기
function paymentHist(numId , userName){
	var fm = document.getElementById("billingListForm");

	var left = (screen.width)?(screen.width - 700)/2 : 10;
	var top = (screen.height)?(screen.height - 600)/2 : 10;
	var winStyle = "width=700,height=600,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
	newWin = window.open("", "paymentHist", winStyle);
	newWin.focus();
	
	fm.target = "paymentHist";
	fm.numId.value = numId;
	fm.userName.value = userName;
	fm.action = "/reader/billingStuAdmin/popPaymentHist.do";
	fm.submit();
}
	
//일시정지, 일시정지 해제, 임의 해지
function fn_pauseControll(numId , levels , condition){
	var fm = document.getElementById("billingListForm");
	
	if(levels == '2' && condition == ''){ //일시정지
		if(!confirm('자동이체 일시정지 처리시 휴독으로 변경됩니다. 처리하시겠습니까?')){ return; }
	}else if(levels == '3' && condition == ''){ //일시정지 해제
		if(!confirm('자동이체 일시정지 해제 처리하시겠습니까?')){ return; }
	}else if(levels == '3' && condition == 'EA99'){ //임의 해지
		if(!confirm('자동이체 임의 해지 하시겠습니까?')){ return; }
	}else if(levels == '3' && condition == 'XX'){ //삭제
		if(!confirm('자동이체 삭제 하시겠습니까?')){ return; }
	}else{
		return;
	}
	
	fm.numId.value = numId;
	fm.levels.value = levels;
	fm.condition.value = condition;
	fm.target = "_self";
	fm.action = "/reader/billingStuAdmin/pauseControll.do";
	fm.submit();
}

//자동이체 해지
function fn_removePayment(numId , readNo){
	var fm = document.getElementById("billingListForm");
	
	if(!confirm('자동이체 해지시 구독정보도 해지됩니다. 해지하시겠습니까?')){
		 return false;
	}
	
	fm.numId.value = numId;
	fm.readNo.value = readNo;
	fm.target = "_self";
	fm.action = "/reader/billingStuAdmin/removePayment.do";
	fm.submit();
}

//excel 저장
function fn_saveExcel(){
	var fm = document.getElementById("billingListForm");
	
	if(!cf_checkNull("fromDate", "조회 시작 날짜")) { return false; }
	if(!cf_checkNull("toDate", "조회 끝 날짜")) { return false; }
	
	var tmpFrom =  document.getElementById("fromDate").value.split("-");
	var tmpTo =  document.getElementById("toDate").value.split("-");
	
	if(Number(tmpFrom[0]+tmpFrom[1]+tmpFrom[2]) > Number(tmpTo[0]+tmpTo[1]+tmpTo[2]) ){
		alert("조회 시작월이 끝월보다 큽니다.");
		return;
	}
	
	fm.target="_self";
	fm.action="/reader/billingStuAdmin/saveExcel.do";
	fm.submit();
}

jQuery.noConflict();
jQuery(document).ready(function($){
	$("#realJikuk").select2({minimumInputLength: 1});
});
</script>
<!-- title -->
<div><span class="subTitle">학생독자 리스트</span></div>
<!-- //title -->
<form id="billingListForm" name="billingListForm" action="" method="post">
<input type=hidden id="pageNo" name="pageNo" value="${param.pageNo}" />
<input type="hidden" id="numId" name="numId" value="" />
<input type="hidden" id="levels" name="levels" value="" />
<input type="hidden" id="readNo" name="readNo" value="" />
<input type="hidden" id="condition" name="condition" value="" />
<input type="hidden" id="userName" name="userName" value="" />
<input type="hidden" id="flag" name="flag" value="UPT" />
<!-- search conditions -->
<div class="box_white" style="padding: 10px 0; width: 1020px; margin: 0 auto;">
	<select name="realJikuk" id="realJikuk" style="vertical-align: middle; width: 110px;">
		<option value="">전체 지국 보기</option>
		<c:forEach items="${agencyAllList }" var="list">
			<option value="${list.SERIAL }" <c:if test="${realJikuk eq list.SERIAL}">selected </c:if>>${list.NAME } </option>
		</c:forEach>
	</select>&nbsp;&nbsp;&nbsp;
	<select name="search_type" id="search_type" style="vertical-align: middle;">
		<option value="userName" <c:if test="${search_type eq 'userName'}">selected </c:if>>구독자 이름</option>
		<option value="jikuk" <c:if test="${search_type eq 'jikuk'}">selected </c:if>>지국명</option>
		<option value="bankNum" <c:if test="${search_type eq 'bankNum'}">selected </c:if>>계좌번호(-없이)</option>
		<option value="bankName" <c:if test="${search_type eq 'bankName'}">selected </c:if>>납부자 이름</option>
		<option value="unique" <c:if test="${search_type eq 'unique'}">selected </c:if>>납부자번호</option>
		<option value="saup" <c:if test="${search_type eq 'saup'}">selected </c:if>>납부자 주민번호</option>
		<option value="stuSch" <c:if test="${search_type eq 'saup'}">selected </c:if>>대학교</option>
		<option value="stuProf" <c:if test="${search_type eq 'saup'}">selected </c:if>>추천교수</option>
	</select>&nbsp;&nbsp;&nbsp;
	<input type="text" name="search_key" id="search_key" value="${search_key }" onkeydown="if(event.keyCode == 13){fn_search(); }" style="vertical-align: middle; width: 140px" />
	&nbsp;&nbsp;&nbsp;
	<select name="status" id="status" style="vertical-align: middle;">
		<option value="ALL" <c:if test="${status eq 'ALL'}">selected </c:if>>전체</option>
		<option value="EA00" <c:if test="${status eq 'EA00'}">selected </c:if>>신규신청</option>
		<option value="EA13" <c:if test="${status eq 'EA13'}">selected </c:if>>신규CMS확인중</option>
		<option value="EA14" <c:if test="${status eq 'EA14'}">selected </c:if>>신청오류</option>
		<option value="EA14-" <c:if test="${status eq 'EA14-'}">selected </c:if>>해지오류</option>
		<option value="EA21" <c:if test="${status eq 'EA21'}">selected </c:if>>정상</option>
		<option value="EA13-" <c:if test="${status eq 'EA13-'}">selected </c:if>>해지신청중</option>
		<option value="EB13-" <c:if test="${status eq 'EB13-'}">selected </c:if>>해지(계좌변경)</option>
		<option value="EA13-e" <c:if test="${status eq 'EA13-e'}">selected </c:if>>해지오류</option>
		<option value="EA99" <c:if test="${status eq 'EA99'}">selected </c:if>>정상해지</option>
		<option value="XX" <c:if test="${status eq 'XX'}">selected </c:if>>삭제</option>
	</select>
	<a href="#fakeUrl" onclick="fn_search();"><img src="/images/bt_search.gif" style="vertical-align: middle; border: 0;" alt="검색"></a>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="text" id="fromDate" name="fromDate"  value="${sdate}" readonly onclick="Calendar(this);" style="vertical-align: middle; width: 80px"/> ~ 
	<input type="text" id="toDate" name="toDate"  value="${sdate}" readonly onclick="Calendar(this);" style="vertical-align: middle; width: 80px"/>
	<a href="#fakeUrl" onclick="fn_saveExcel();"><img src="/images/bt_savexel.gif" style="vertical-align: middle; border: 0;" alt="엑셀저장"></a>
</div>
<!-- //search conditions -->
<!-- list -->
<div style="padding: 15px 0 20px 0;">
	<table class="tb_list_a" style="width: 1020px;">
		<colgroup>
			<col width="70px">
			<col width="120px">
			<col width="120px">
			<col width="40px">
			<col width="50px">
			<col width="185px">
			<col width="90px">
			<col width="40px">
			<col width="75px">
			<col width="65px">
			<col width="60px">
			<col width="70px">
			<col width="35px">
		</colgroup>
		<tr>
			<th>관리지국</th>
			<th>대학명</th>
			<th>학과</th>
			<th>학년</th>
			<th>성명</th>
			<th>주소</th>
			<th>휴대폰</th>
			<th>금액</th>
			<th>신청일<br/>(해지일)</th>
			<th>일시정지</th>
			<th>해지</th>
			<th>현재상태</th>
			<th>삭제</th>
		</tr>
		<c:forEach items="${billingList }" var="list" varStatus="i">
			<c:set var="cutAddr" value="${fn:split(list.FULLADDR,'|') }"/>
			<c:set var="dlvZip" value="${cutAddr[0] }" /> 
			<c:set var="addr1" value="${cutAddr[1] }" />
			<c:set var="addr2" value="${cutAddr[2] }" />
			<c:set var="newAddr" value="${cutAddr[3] }" />
			<tr class="mover_color">
				<td>${list.JIKUKNM }</td>
				<td style="text-align: left">${list.STU_SCH }</td>
				<td style="text-align: left">${list.STU_PART }</td>
				<td>${list.STU_CLASS }</td>
				<td style="text-align: left"><a href="#fakeUrl" onclick="detailVeiw('${list.NUMID }','${list.READNO }' );">${list.USERNAME }</a></td>
				<td style="text-align: left">${newAddr } <br/><b>(${addr1})</b> ${addr2 }</td>
				<td>${list.HANDY }</td>
				<td>
					<c:choose>
						<c:when test="${list.STATUS eq '' }">
							<a href="#fakeUrl"  onclick="paymentHist('${list.NUMID }' , '${list.USERNAME }');">${list.BANK_MONEY }</a>
						</c:when>
						<c:when test="${list.STATUS eq 'EA00' }">
							<a href="#fakeUrl" onclick="paymentHist('${list.NUMID }' , '${list.USERNAME }');">${list.BANK_MONEY }</a>
						</c:when>
						<c:otherwise>
							<a href="#fakeUrl" onclick="paymentHist('${list.NUMID }' , '${list.USERNAME }');">${list.BANK_MONEY }</a>
						</c:otherwise>
					</c:choose>
				</td>
				<td>${list.INDATE }<c:if test="${not empty list.R_OUT_DATE }"><br/>(<font class="b03">${list.R_OUT_DATE }</font>)</c:if></td>
				<c:set var="txtout" value=""/>
				<c:choose>
					<c:when test="${list.STATUS eq '' }">
						<td></td>
						<td></td>
						<td>비정규신규 신청</td>
						<td></td>
					</c:when>
					<c:when test="${list.STATUS eq 'EA00' }">
						<td></td>
						<c:choose>
							<c:when test="${not empty list.RDATE }">
								<td>
									<a href="#fakeUrl" onclick="fn_pauseControll('${list.NUMID }' , '3' , 'EA99')">임의해지</a>
								</td>
								<td>신규 신청</td>
								<td></td>
							</c:when>
							<c:otherwise>
								<td></td>
								<td>신규 신청</td>
								<td><a href="#fakeUrl" onclick="fn_pauseControll('${list.NUMID }' , '3' , 'XX')"><img src="/images/bt_imx.gif" alt="삭제" style="vertical-align: middle; border: 0;"/></a></td>
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:when test="${list.STATUS eq 'EA13' }">
						<td></td>
						<td></td>
						<td>신규 CMS확인중</td>
						<td></td>
					</c:when>
					<c:when test="${list.STATUS eq 'EA14' }">
						<td></td>
						<c:if test="${not empty list.RDATE }">
							<td><a href="#fakeUrl" onclick="fn_pauseControll('${list.NUMID }' , '3' , 'EA99')">임의해지</a></td>
						</c:if>
						<td>신청 오류</td>
						<td></td>
					</c:when>
					<c:when test="${list.STATUS eq 'EA14-' }">
						<td></td>
						<c:if test="${not empty list.RDATE }">
							<td><a href="#fakeUrl" onclick="fn_pauseControll('${list.NUMID }' , '3' , 'EA99')">임의해지</a></td>
						</c:if>
						<td>해지 오류</td>
						<td></td>
					</c:when>
					<c:when test="${list.STATUS eq 'EA21' }">
						<c:choose>
							<c:when test="${list.LEVELS eq '2' }">
								<td><a href="#fakeUrl" onclick="fn_pauseControll('${list.NUMID }' , '3' , '');">일시정지<BR/>해제</a></td>
							</c:when>
							<c:otherwise>
								<td></td>
							</c:otherwise>
						</c:choose>
						<td><a href="#fakeUrl" onclick="fn_removePayment('${list.NUMID }','${list.READNO }');">해지</a></td>
						<td>정상</td>
						<td></td>
					</c:when>
					<c:when test="${list.STATUS eq 'EA13-' }">
						<td></td>
						<c:if test="${not empty list.RDATE  }">
							<td></td>	
						</c:if>
						<td>해지 신청중</td>
						<td></td>
					</c:when>
					<c:when test="${list.STATUS eq 'EB13-' }">
						<td></td>
						<td></td>	
						<td>해지(계좌변경)</td>
						<td></td>
					</c:when>
					<c:when test="${list.STATUS eq 'EA13-e' }">
						<td></td>
						<td></td>	
						<td>해지 오류</td>
						<td></td>
					</c:when>
					<c:when test="${list.STATUS eq 'EA99' }">
						<td></td>
						<td></td>	
						<td>정상 해지</td>
						<td></td>
					</c:when>
					<c:when test="${list.STATUS eq 'XX' }">
						<td></td>
						<td></td>	
						<td>삭제</td>
						<td></td>
					</c:when>
					<c:otherwise>
						<td></td>
						<td></td>	
						<td></td>
						<td></td>
					</c:otherwise>
				</c:choose>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/common/paging.jsp"%>
</div>
</form>