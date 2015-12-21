<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript">
	//페이징
	function moveTo(where, seq) {
		$("pageNo").value = seq;
		billingListForm.target = "_self";
		billingListForm.action = "/reader/billing/searchBilling.do";
		billingListForm.submit();
	}
	
	//검색
	function fn_search(){
		$("pageNo").value = '1';
		billingListForm.target = "_self";
		billingListForm.action = "/reader/billing/searchBilling.do";
		billingListForm.submit();
	}
	
	//자세히 보기
	function fn_detailVeiw(numId){
		var fm = document.getElementById("billingListForm");

		var left = (screen.width)?(screen.width - 750)/2 : 10;
		var top = (screen.height)?(screen.height - 800)/2 : 10;
		var winStyle = "width=750,height=800,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		newWin = window.open("", "detailVeiw", winStyle);
		newWin.focus();
		
		fm.target = "detailVeiw";
		fm.action = "/reader/billing/billingInfo.do?numId="+numId;
		fm.submit();
	}
	
	//납부이력보기
	function paymentHist(numId , userName){

		$("numId").value = numId;
		$("userName").value = userName;
		var left = (screen.width)?(screen.width - 830)/2 : 10;
		var top = (screen.height)?(screen.height - 600)/2 : 10;
		var winStyle = "width=700,height=600,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		var newWin = window.open("", "paymentHist", winStyle);
		billingListForm.target = "paymentHist";
		billingListForm.action = "/reader/billing/popPaymentHist.do";
		billingListForm.submit();
	}
</script>
<div><span class="subTitle">자동이체독자(일반독자)</span></div>
<form id="billingListForm" name="billingListForm" action="" method="post">
	<input type=hidden id="pageNo" name="pageNo" value="${param.pageNo}" />
	<input type="hidden" id="numId" name="numId" value="" />
	<input type="hidden" id="levels" name="levels" value="" />
	<input type="hidden" id="readNo" name="readNo" value="" />
	<input type="hidden" id="condition" name="condition" value="" />
	<input type="hidden" id="userName" name="userName" value="" />
	<!-- search condition -->
	<div class="box_white" style="padding: 10px 0; width: 1020px; margin: 0 auto;">
		<select name="search_type" id="search_type" style="vertical-align: middle;">
			<option value="userName" <c:if test="${search_type eq 'userName'}">selected </c:if>>구독자 이름</option>
			<option value="bankNum" <c:if test="${search_type eq 'bankNum'}">selected </c:if>>계좌번호(-없이)</option>
			<option value="bankName" <c:if test="${search_type eq 'bankName'}">selected </c:if>>납부자 이름</option>
			<option value="unique" <c:if test="${search_type eq 'unique'}">selected </c:if>>납부자번호</option>
			<option value="saup" <c:if test="${search_type eq 'saup'}">selected </c:if>>납부자 주민번호</option>
		</select>&nbsp;&nbsp;&nbsp;
		<input type="text" name="search_key" id="search_key" value="${search_key }" style="width: 140px; vertical-align: middle" onkeydown="if(event.keyCode == 13){fn_search(); }"/>
		&nbsp;&nbsp;&nbsp;
		<select name="status" id="status"  style="vertical-align: middle;">
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
		</select>&nbsp;&nbsp;&nbsp;&nbsp;
		<img src="/images/bt_search.gif" style="vertical-align: middle; border: 0; cursor: pointer;" onclick="fn_search();" alt="검색">
	</div>
	<br />
	<!-- //search condition -->
	<table class="tb_list_a" style=" width: 1020px; margin: 0 auto;">  
		<colgroup>
			<col width="100px">
			<col width="90px">
			<col width="95px">
			<col width="70px">
			<col width="300px">
			<col width="120px">
			<col width="120px">
			<col width="120px">
		</colgroup>
		<tr>
			<th>독자구분</th>
			<th>이 름</th>
			<th>지국명</th>
			<th>금액</th>
			<th>주 소</th>
			<th>전화번호</th>
			<th>신청일<br/>(해지일)</th>
			<th>현재상태</th>
		</tr>
		<c:forEach items="${billingList }" var="list" varStatus="i">
			<c:set var="cutAddr" value="${fn:split(list.FULLADDR,'|') }"/>
			<c:set var="dlvZip" value="${cutAddr[0] }" /> 
			<c:set var="addr1" value="${cutAddr[1] }" />
			<c:set var="addr2" value="${cutAddr[2] }" />
			<c:set var="newAddr" value="${cutAddr[3] }" />
			<tr>
				<td>${list.INTYPE }</td>
				<td style="text-align: left">
					<a href="#fakeUrl" onclick="fn_detailVeiw('${list.NUMID }');">${list.USERNAME }</a>
				</td>
				<td>${list.JIKUKNM }</td>
				<td>
					<c:choose>
						<c:when test="${list.STATUS eq '' }">
							<a href="javascript:alert('자료가 없습니다.');">${list.BANK_MONEY }</a>
						</c:when>
						<c:when test="${list.STATUS eq 'EA00' }">
							<a href="javascript:alert('자료가 없습니다.');">${list.BANK_MONEY }</a>
						</c:when>
						<c:otherwise>
							<a href="javascript:javascript:paymentHist('${list.NUMID }','${list.USERNAME }');">${list.BANK_MONEY }</a>
						</c:otherwise>
					</c:choose>
				</td>
				<td style="text-align: left">
					<c:if test="${newAddr ne null }">${newAddr }<br /></c:if>
					<c:if test="${addr2 ne null }"><b>(${addr1 })</b> ${addr2 }</c:if>
				</td>
				<td style="text-align: left">${list.HANDY }</td>
				<td>${list.INDATE }<c:if test="${not empty list.R_OUT_DATE }"><br/>(<font class="b03">${list.R_OUT_DATE }</font>)</c:if></td>

				<c:set var="txtout" value=""/>
				<c:choose>
				<c:when test="${list.STATUS eq '' }">
					<td>비정규신규 신청</td>
				</c:when>
				<c:when test="${list.STATUS eq 'EA00' }">
					<td>신규 신청</td>
				</c:when>
				<c:when test="${list.STATUS eq 'EA13' }">
					<td>신규 CMS확인중</td>
				</c:when>
				<c:when test="${list.STATUS eq 'EA14' }">
					<td>신청 오류</td>
				</c:when>
				<c:when test="${list.STATUS eq 'EA14-' }">
					<td>해지 오류</td>
				</c:when>
				<c:when test="${list.STATUS eq 'EA21' }">
					<td>정상</td>
				</c:when>
				<c:when test="${list.STATUS eq 'EA13-' }">
					<td>해지 신청중</td>
				</c:when>
				<c:when test="${list.STATUS eq 'EB13-' }">
					<td>해지(계좌변경)</td>
				</c:when>
				<c:when test="${list.STATUS eq 'EA13-e' }">
					<td>해지 오류</td>
				</c:when>
				<c:when test="${list.STATUS eq 'EA99' }">
					<td>정상 해지</td>
				</c:when>
				<c:when test="${list.STATUS eq 'XX' }">
					<td>삭제</td>
				</c:when>
				<c:otherwise>
					<td></td>
				</c:otherwise>
				</c:choose>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/common/paging.jsp"%>
</form>