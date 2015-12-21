<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript">
	//페이징
	function moveTo(where, seq) {
		$("pageNo").value = seq;
		billingListForm.target = "_self";
		billingListForm.action = "/reader/billingStu/searchBilling.do";
		billingListForm.submit();
	}
	
	//검색
	function fn_search(){
		
		$("pageNo").value = '1';
		billingListForm.target = "_self";
		billingListForm.action = "/reader/billingStu/searchBilling.do";
		billingListForm.submit();
	}
	
	//자세히 보기
	function detailVeiw(numId){
		var fm = document.getElementById("billingListForm");
		var left = (screen.width)?(screen.width - 750)/2 : 10;
		var top = (screen.height)?(screen.height - 750)/2 : 10;
		var winStyle = "width=750,height=750,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		var newWin = window.open("", "detailVeiw", winStyle);
		
		fm.target = "detailVeiw";
		fm.action = "/reader/billingStu/billingInfo.do?numId="+numId;
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
		billingListForm.action = "/reader/billingStu/popPaymentHist.do";
		billingListForm.submit();
	}
	
	//일시정지, 일시정지 해제, 임의 해지
	function pauseControll(numId , levels , condition){
		if(levels == '2' && condition == ''){ //일시정지
			if(confirm('자동이체 일시정지 하시겠습니까?') == false){
				return;
			}
		}else if(levels == '3' && condition == ''){ //일시정지 해제
			if(confirm('자동이체 일시정지 해제 하시겠습니까?') == false){
				return;
			}
		}else if(levels == '3' && condition == 'EA99'){ //임의 해지
			if(confirm('자동이체 임의 해지 하시겠습니까?') == false){
				return;
			}
		}else{
			return;
		}
		$("numId").value = numId;
		$("levels").value = levels;
		$("condition").value = condition;
		
		billingListForm.target = "_self";
		billingListForm.action = "/reader/billingStu/pauseControll.do";
		billingListForm.submit();
	}
	//자동이체 해지
	function removePayment(numId , readNo){
		if(confirm('해지하시겠습니까?') == true){
			$("numId").value = numId;
			$("readNo").value = readNo;
			billingListForm.target = "_self";
			billingListForm.action = "/reader/billingStu/removePayment.do";
			billingListForm.submit();
		}
	}
</script>
<div><span class="subTitle">자동이체독자(학생독자)</span></div>
<form id="billingListForm" name="billingListForm" action="" method="post">
	<input type=hidden id="pageNo" name="pageNo" value="${param.pageNo}" />
	<input type="hidden" id="numId" name="numId" value="" />
	<input type="hidden" id="levels" name="levels" value="" />
	<input type="hidden" id="readNo" name="readNo" value="" />
	<input type="hidden" id="condition" name="condition" value="" />
	<input type="hidden" id="userName" name="userName" value="" />
	<!-- search condition -->
	<div class="box_white" style="padding: 10px 0;  width: 1020px; margin: 0 auto;">
		<select name="search_type" id="search_type" style="vertical-align: middle;">
			<option value="userName" <c:if test="${search_type eq 'userName'}">selected </c:if>>구독자 이름</option>
			<option value="bankNum" <c:if test="${search_type eq 'bankNum'}">selected </c:if>>계좌번호(-없이)</option>
			<option value="bankName" <c:if test="${search_type eq 'bankName'}">selected </c:if>>납부자 이름</option>
			<option value="unique" <c:if test="${search_type eq 'unique'}">selected </c:if>>납부자번호</option>
			<option value="saup" <c:if test="${search_type eq 'saup'}">selected </c:if>>납부자 주민번호</option>
			<option value="stuSch" <c:if test="${search_type eq 'stuSch'}">selected </c:if>>대학교</option>
			<option value="stuProf" <c:if test="${search_type eq 'stuProf'}">selected </c:if>>추천교수</option>
		</select>&nbsp;&nbsp;&nbsp;
		<input type="text" name="search_key" id="search_key" value="${search_key }" style="width: 140px; vertical-align: middle;" onkeydown="if(event.keyCode == 13){fn_search(); }"/>
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
		<img src="/images/bt_search.gif" style="vertical-align: middle; border: 0; cursor: pointer;" onclick="fn_search();">
	</div>
	<!-- //search condition -->
	<br />
	<table class="tb_list_a" style=" width: 1020px; margin: 0 auto;">  
		<colgroup>
			<col width="110px">
			<col width="80px"> 
			<col width="55px">
			<col width="55px">
			<col width="55px">
			<col width="310px">
			<col width="90px">
			<col width="55px">
			<col width="100px">
			<col width="110px">
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
			<!-- th>일시정지</font></td>
			<th>해지</font></td-->
			<th>현재상태</th>
		</tr>
		<c:forEach items="${billingList }" var="list" varStatus="i">
			<tr>
				<td>${list.JIKUKNM }</td>
				<td>${list.STU_SCH }</td>
				<td>${list.STU_PART }</td>
				<td>${list.STU_CLASS }</td>
				<td style="text-align: left;"><a href="#fakeUrl" onclick="detailVeiw('${list.NUMID }');">${list.USERNAME }</a></td> 
				<td style="text-align: left;">${list.NEWADDR } <br/><b>(${list.ADDR1 })</b> ${list.ADDR2 }</td>
				<td>${list.HANDY }</td>
				<td>
					<c:choose>
						<c:when test="${list.STATUS eq '' }">
							<a href="#fakeUrl" onclick="paymentHist('${list.NUMID }' , '${list.USERNAME }');">${list.BANK_MONEY }</a>
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
						<!-- td></td>
						<td></td-->
						<td>비정규신규 신청</td>
					</c:when>
					<c:when test="${list.STATUS eq 'EA00' }">
						<!-- td></td-->
						<c:choose>
							<c:when test="${not empty list.RDATE }">
								<!-- td>
									<a href="#fakeUrl" onclick="pauseControll('${list.NUMID }' , '3' , 'EA99')">임의해지</a>
								</td-->
							</c:when>
							<c:otherwise>
								<!-- td></td-->
							</c:otherwise>
						</c:choose>
						
						<td>신규 신청</td>
					</c:when>
					<c:when test="${list.STATUS eq 'EA13' }">
						<!--td></td>
						<td></td-->
						<td>신규 CMS확인중</td>
					</c:when>
					<c:when test="${list.STATUS eq 'EA14' }">
						<!--td></td-->
						<c:if test="${not empty list.RDATE }">
							<!--td><a href="#fakeUrl" onclick="pauseControll('${list.NUMID }' , '3' , 'EA99')">임의해지</a></td-->
						</c:if>
						<td>신청 오류</td>
					</c:when>
					<c:when test="${list.STATUS eq 'EA14-' }">
						<!--td></td-->
						<c:if test="${not empty list.RDATE }">
							<!--td><a href="#fakeUrl" onclick="pauseControll('${list.NUMID }' , '3' , 'EA99')">임의해지</a></td-->
						</c:if>
						<td>해지 오류</td>
					</c:when>
					<c:when test="${list.STATUS eq 'EA21' }">
						<c:choose>
							<c:when test="${list.LEVELS eq '2' }">
								<!-- td><a href="#fakeUrl" onclick="pauseControll('${list.NUMID }' , '3' , '');">일시정지<BR/>해제</a></td-->
							</c:when>
							<c:otherwise>
								<!--td><a href="#fakeUrl" onclick="pauseControll('${list.NUMID }' , '2' , '');">일시정지</a></td-->
							</c:otherwise>
						</c:choose>
						<!--td><a href="#fakeUrl" onclick="javascript:removePayment('${list.NUMID }','${list.READNO }');">해지</a></td-->
						<td>정상</td>
					</c:when>
					<c:when test="${list.STATUS eq 'EA13-' }">
						<!--td></td-->
						<c:if test="${not empty list.RDATE  }">
							<!--td></td-->	
						</c:if>
						<td>해지 신청중</td>
					</c:when>
					<c:when test="${list.STATUS eq 'EB13-' }">
						<td>해지(계좌변경)</td>
					</c:when>
					<c:when test="${list.STATUS eq 'EA13-e' }">
						<!--td></td>
						<td></td-->	
						<td>해지 오류</td>
						
					</c:when>
					<c:when test="${list.STATUS eq 'EA99' }">
						<!--td></td>
						<td></td-->	
						<td>정상 해지</td>
					</c:when>
					<c:when test="${list.STATUS eq 'XX' }">
						<!--td></td>
						<td></td-->	
						<td>삭제</td>
					</c:when>
					<c:otherwise>
						<!--td></td>
						<td></td-->	
						<td></td>
					</c:otherwise>
				</c:choose>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/common/paging.jsp"%>
</form>