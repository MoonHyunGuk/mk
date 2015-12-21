<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript">
//페이징
function moveTo(where, seq) {
	var fm = document.getElementById("fm");
	
	fm.pageNo.value = seq;
	fm.target = "_self";
	fm.action = "/reader/billingAdmin/stopReserveList.do";
	fm.submit();	
}

/**
 * 자세히 보기
 */
function fn_detailView(numId, readerType){
	var fm = document.getElementById("fm");
	var url = "";
	
	if("일반" == readerType) {
		url = "/reader/billingAdmin/billingInfo.do" ;
	} else if("학생" == readerType) {
		url = "/reader/billingStuAdmin/billingInfo.do" ;
	}

	var left = (screen.width)?(screen.width - 750)/2 : 10;
	var top = (screen.height)?(screen.height - 850)/2 : 10;
	var winStyle = "width=750,height=850,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
	newWin = window.open("", "detailVeiw", winStyle);
	newWin.focus();
	
	fm.target = "detailVeiw";
	fm.action = url+"?numId="+numId;
	fm.submit();
}

/**
 * 납부이력보기
 */
function fn_paymentHist(numId , userName, readerType){
	var fm = document.getElementById("fm");
	var url = "";
	
	if("일반" == readerType) {
		url = "/reader/billingAdmin/popPaymentHist.do" ;
	} else if("학생" == readerType) {
		url = "/reader/billingStuAdmin/popPaymentHist.do" ;
	}
	
	var left = (screen.width)?(screen.width - 830)/2 : 10;
	var top = (screen.height)?(screen.height - 600)/2 : 10;
	var winStyle = "width=700,height=600,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
	newWin2 = window.open("", "paymentHist", winStyle);
	newWin2.focus();
	
	fm.target = "paymentHist";
	fm.numId.value = numId;
	fm.userName.value = userName;
	fm.action = url;
	fm.submit();
}

/**
 * 취소버튼 클릭이벤트
 */
function fn_cancel(numId) {
	var fm = document.getElementById("fm");
	
	if(!confirm("예약해지를 취소하시겠습니까?")) {return false;}
	
	fm.numId.value = numId;
	fm.action = "/reader/billingAdmin/stopReserveCancel.do";
	fm.submit();
}

//자동이체 해지
function fn_removePayment(numId , readNo, readerType){
	var fm = document.getElementById("fm");
	
	if(!confirm('자동이체 해지시 구독정보도 해지됩니다. 해지하시겠습니까?')){ return false;}
		
	fm.target = "_self";
	fm.numId.value = numId;
	fm.readNo.value = readNo;
	fm.readerType.value = readerType;
	fm.action = "/reader/billingAdmin/stopReserveAccept.do" ;
	fm.submit();
}

function fn_search() {
	var fm = document.getElementById("fm");
	
	fm.target = "_self";
	fm.action = "/reader/billingAdmin/stopReserveList.do" ;
	fm.submit();
}
</script>
<!-- title -->
<div><span class="subTitle"> 예약해지독자리스트</span></div>
<!-- //title -->
<!-- search conditions -->
<form method="post" name="fm" id="fm">
	<input type="hidden" name="numId" id="numId" />
	<input type="hidden" name="pageNo" id="pageNo" />
	<input type="hidden" name="userName" id="userName" />
	<input type="hidden" name="readNo" id="readNo" />
	<input type="hidden" name="readerType" id="readerType" />
	<input type="hidden" name="flag" id="flag" value="SAVEOK" />
	<div class="box_white" style="padding: 10px 0; width: 1020px; margin: 0 auto;">
		<span style="font-weight: bold; vertical-align: middle;">예약해지일</span>&nbsp;&nbsp;
		<input type="text" id="fromDate" name="fromDate"  value="${fromDate }" readonly="readonly" onclick="Calendar(this)" style="vertical-align: middle; width: 80px"/> ~ 
		<input type="text" id="toDate" name="toDate"  value="${toDate }" readonly="readonly" onclick="Calendar(this)" style="vertical-align: middle; width: 80px"/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<span style="font-weight: bold; vertical-align: middle;">상태</span>&nbsp;&nbsp;
		<select name="cancelYn" id="cancelYn" style="vertical-align: middle; width: 80px;">
			<option value="ALL" <c:if test="${cancelYn eq 'ALL'}">selected="selected"</c:if>>전체</option> 
			<option value="Y" <c:if test="${cancelYn eq 'Y'}">selected="selected"</c:if>>취소</option>
			<option value="D" <c:if test="${cancelYn eq 'D'}">selected="selected"</c:if>>해지</option>
			<option value="N" <c:if test="${cancelYn eq 'N'}">selected="selected"</c:if>>미확인</option>
			<!-- 
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		
		<b>접수자</b>&nbsp;&nbsp;
		<select name="realJikuk" id="realJikuk" style="vertical-align: middle; width: 80px;">
			<option value="">전체</option> 
			<option value="">관리자</option>
			 -->
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<span style="font-weight: bold; vertical-align: middle;">독자명</span>&nbsp;&nbsp;
		<input type="text" id="opReadnm" name="opReadnm"  value="${opReadnm }" style="vertical-align: middle; width: 100px" maxlength="15"  onkeypress="if(event.keyCode==13){fn_search();}"/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<span style="font-weight: bold; vertical-align: middle;">접수자</span>&nbsp;&nbsp;
		<select id="opCounselor" name="opCounselor" style="vertical-align: middle;">
			<option value="">전체</option>
			<c:forEach items="${counselorList }" var="list" varStatus="c">
				<option value="${list.ID }" <c:if test="${list.ID eq opCounselor}" >selected="selected"</c:if>>${list.NAME }</option>
			</c:forEach>
		</select>
		&nbsp;&nbsp;&nbsp;
		<a href="#fakeUrl" onclick="fn_search();"><img src="/images/bt_search.gif" style="vertical-align: middle; border: 0;" alt="검색"></a>
	</div>
</form>
<!-- //search conditions -->
<!-- list -->
<div class="box_list" style="width: 1020px; margin: 0 auto;">
	<table class="tb_list_a" style="width: 1020px">
		<colgroup>
			<col width="50px">
			<col width="90px">
			<col width="70px">
			<col width="70px">
			<col width="200px">
			<col width="180px">
			<col width="90px">
			<col width="80px">
			<col width="60px">
			<col width="40px">
			<col width="40px">
			<col width="50px">
		</colgroup>
		<tr>
			<th>독자<br/>구분</th>
			<th>독자명</th>
			<th>지국명</th>
			<th>금액</th>
			<th>주 &nbsp; 소</th>
			<th>메 &nbsp; 모</th>
			<th>연락처</th>
			<th>예약해지일</th>
			<th>접수자</th>
			<th>접수</th>
			<th>취소</th>
			<th>상태</th>
		</tr>
		<c:choose>
			<c:when test="${fn:length(stopReserveList) <1 }">
				<tr><td colspan="12" style="padding: 8px 0; font-weight: bold;">조회된 독자가 없습니다.</td></tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${stopReserveList }" var="list" varStatus="i">
					<tr <c:if test="${list.STDT ne null && list.CANCELYN eq 'N'}">style="background:#FFECEC"</c:if>>
						<td>${list.READERTYPE }</td>
						<td><a href="#fakeUrl" onclick="fn_detailView('${list.NUMID }','${list.READERTYPE }');">${list.READNM }</a></td>
						<td>${list.BOSEQNM }</td>
						<td><a href="#fakeUrl" onclick="fn_paymentHist('${list.NUMID }' , '${list.READNM }','${list.READERTYPE }');">${list.UPRICE }</a></td>
						<td>${list.ADDR }</td>
						<td>${list.MEMO }</td>
						<td>${list.MOBILE }</td>
						<td>${list.RESERVEDT }</td>
						<td>${list.INPSNM }</td>
						<c:choose>
							<c:when test="${list.CANCELYN eq 'N' && list.STDT eq null}">
								<td><img src="/images/check.gif" alt="확인" style="vertical-align:middle; border:0; cursor: pointer;" onclick="fn_removePayment('${list.NUMID }','${list.READNO }');" /></td>
								<td><img src="/images/cross.gif" alt="취소" style="vertical-align:middle; border:0; cursor: pointer;" onclick="fn_cancel('${list.NUMID}')" /></td>
							</c:when>
							<c:when test="${list.CANCELYN eq 'Y'}">
								<td colspan="2">${list.CANCELDT } <br/>(${list.CANCELPSNM })</td> 
							</c:when>
							<c:when test="${list.STDT ne null}">
								<td colspan="2">${list.STDT } <br/>(${list.CHGPSNM })</td> 
							</c:when>
						</c:choose>
						<td style=" ">
							<c:choose>
								<c:when test="${list.STDT eq null && list.CANCELYN eq 'N'}">미확인</c:when>
								<c:when test="${list.CANCELYN eq 'Y' }"><span style="color:red; font-weight: bold;">취소</span></c:when> 
								<c:when test="${list.STDT ne null && list.CANCELYN eq 'N'}"><span style="font-weight: bold;">해지</span></c:when>
							</c:choose>
						</td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>
	<%@ include file="/common/paging.jsp"%>
</div>