<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
	// 매체 종류 전체 선택/해제
	function checkControll(){
		var frm = document.frm;
		//전체선택 1 , 전체해제 2
		if(frm.controll.checked == true){
			if( frm.newsCd.length > 0 ){
				for(var i=0;i<frm.newsCd.length;i++){
					frm.newsCd[i].checked = true;
				}
			}			
		}else{
			if( frm.newsCd.length > 0 ){
				for(var i=0;i<frm.newsCd.length;i++){
					frm.newsCd[i].checked = false;
				}
			}	
		}
	}


	function fn_search(){
		var frm = document.frm;
		var result = false;
	
		if( frm.newsCd.length > 0 ){
			for(var i=0;i<frm.newsCd.length;i++){
				if(frm.newsCd[i].checked){
					result = true;
				}
			}
			if(!result){
				alert('신문명을 체크해주세요.');
				return;
			}
		}else if( frm.newsCd.value != "" && frm.newsCd.checked ){
			result = true;
		}else{
			alert('신문명을 체크해주세요.');
			return;
		}
			
		frm.action = "./delivery.do";
		frm.submit();
		jQuery("#prcssDiv").show();
	}
	
	function ozPrint(){
		var frm = document.frm;
		var result = false;

		if( frm.newsCd.length > 0 ){
			for(var i=0;i<frm.newsCd.length;i++){
				if(frm.newsCd[i].checked){
					result = true;
				}
			}
			if(!result){
				alert('신문명을 체크해주세요.');
				return;
			}
		}else if( frm.newsCd.value != "" && frm.newsCd.checked ){
			result = true;
		}else{
			alert('신문명을 체크해주세요.');
			return;
		}

		if( result ){
			actUrl = "./ozDelivery.do";
			window.open('','ozDelivery','width=850, height=700, toolbar=no, menubar=no, location=no, status=no, resizable=1, scrollbar=no');

			frm.target ="ozDelivery";
			frm.action = actUrl;
			frm.submit();
			frm.target ="";
			
		}else{
			alert('신문명을 체크해주세요.');
			return;
		}
	}

	var now = new Date();

	//기간설정
	var beforeDate = new Date("${fn:substring(yymm,0,4)}", parseInt("${fn:substring(yymm,4,6)}") - 1);
	var afterDate = new Date("${fn:substring(yymm,0,4)}", "${fn:substring(yymm,4,6)}" );

	var yymm1After = new Date("${fn:substring(yymm,0,4)}", "${fn:substring(yymm,4,6)}" );
	var yymm2After = new Date("${fn:substring(yymm,0,4)}", parseInt("${fn:substring(yymm,4,6)}") + 1 );
	var yymm3After = new Date("${fn:substring(yymm,0,4)}", parseInt("${fn:substring(yymm,4,6)}") + 2 );
	var yymm4After = new Date("${fn:substring(yymm,0,4)}", parseInt("${fn:substring(yymm,4,6)}") + 3 );
	var yymm5After = new Date("${fn:substring(yymm,0,4)}", parseInt("${fn:substring(yymm,4,6)}") + 4 );
	var yymm6After = new Date("${fn:substring(yymm,0,4)}", parseInt("${fn:substring(yymm,4,6)}") + 5 );
	
	
</script>
<div style="padding-bottom: 15px;"> 
	<span class="subTitle">배부현황</span>
</div>
<!-- search conditions -->
<form id="frm" name="frm" method="post">
<div>
	<!-- search conditions(left) -->
	<div style="float: left; width: 400px; padding-right: 10px;">
		<table class="tb_search" style="width: 400px;">
			<colgroup>
				<col width="80px">
				<col width="320px">
			</colgroup>
			<tr>
				<th>기준월분</th>
				<td>
					${fn:substring(yymm,0,4)}-${fn:substring(yymm,4,6)} &nbsp;&nbsp;&nbsp;&nbsp;
					<a href="#fakeUrl" onclick="fn_search();"><img src="/images/bt_joh.gif" style="vertical-align: middle; border: 0" /></a>
					<a href="#fakeUrl" onclick="ozPrint();"><img src="/images/bt_print.gif" style="vertical-align: middle; border: 0" /></a> 
				</td>
			</tr>		
		</table>
	</div>
	<!-- //search conditions(left) -->
	<!-- search conditions(right) -->
	<div style="float: left;">
		<div style="border: 1px solid #e5e5e5; padding: 5px; width: 340px">
			<table class="tb_list_a" style="width: 330px">
				<colgroup>
					<col width="25px;">
					<col width="65px;">
					<col width="80px;">
					<col width="170px;">
				</colgroup>
				<tr>
					<th>&nbsp;</th>
					<th><input type="checkbox" id="controll" name="controll"  onclick="checkControll();" style="border: 0;"> </th>
					<th>코드</th>
					<th>신문명</th>
				</tr>
				<tr id=div1 style="display:none;"><td><input type="checkbox" id="newsCd" name="newsCd" value="0" /></td></tr>
			</table>
			<div style="width: 330px;height:98px;overflow-y:scroll;margin: 0 auto;">
			<table class="tb_list_a" style="width: 313px">
				<colgroup>
					<col width="25px;">
					<col width="65px;">
					<col width="80px;">
					<col width="153px;">
				</colgroup>
				<c:forEach var="list" items="${newsCodeList}" varStatus="status">
					<tr>
						<td>${status.count}</td>
						<td> 
							<input type="checkbox" id="newsCd" name="newsCd" value="${list.CODE}" style="border: 0;" 
								<c:choose>
								<%-- 매일경제 기본으로 체크 --%>
								<c:when test="${empty newsCd}">
									<c:if test="${list.CODE eq '100'}"> checked
									</c:if>
								</c:when>
								<%-- 폼으로 넘어온 값 체크--%>
								<c:otherwise>
									<c:forEach items="${newsCd}" varStatus="counter">
										<c:if test="${newsCd[counter.index] eq list.CODE}"> checked
										</c:if>
									</c:forEach>
								</c:otherwise>
								</c:choose>
							/>
						</td>
						<td><c:out value="${list.YNAME}" /></td>
						<td><c:out value="${list.CNAME}" /></td>
					</tr>			
				</c:forEach>
			</table>
			</div>
		</div>
	</div>
</div>
</form>
<!-- //search conditions -->
<!-- 합계 변수지정start:: -->
<c:set var="READTYPECD011" value="0" />			<!-- 정기합계 -->
<c:set var="SUM_QTY1" value="0" />				<!-- 준유가(1개월)합계 -->
<c:set var="SUM_QTY2" value="0" />				<!-- 준유가(2개월)합계 -->
<c:set var="SUM_QTY3" value="0" />				<!-- 준유가(3개월)합계 -->
<c:set var="SUM_QTY4" value="0" />				<!-- 준유가(4개월)합계 -->
<c:set var="SUM_QTY5" value="0" />				<!-- 준유가(5개월)합계 -->
<c:set var="SUM_QTY6" value="0" />				<!-- 준유가(6개월)합계 -->
<c:set var="SUM_QTY7" value="0" />				<!-- 기타합계 -->
<c:set var="READTYPECD013" value="0" />			<!-- 학생본사합계 -->
<c:set var="READTYPECD012" value="0" />			<!-- 학생지국합계 -->
<c:set var="READTYPECD015" value="0" />			<!-- 교육합계 -->
<c:set var="READTYPECD014" value="0" />			<!-- 병독합계 -->
<c:set var="READTYPECD014" value="0" />			<!-- 병독합계 -->
<c:set var="READTYPECD016" value="0" />			<!-- 본사직원합계 -->
<c:set var="SUM_ALL_PRICE" value="0" />			<!-- 유가총합계 -->
<c:set var="READTYPECD021" value="0" />			<!-- 기증합계 -->
<c:set var="READTYPECD022" value="0" />			<!-- 홍보합계 -->
<c:set var="SUM_MISU_AMT" value="0" />			<!-- 이전에 미수된 금액 합계 -->
<c:set var="SUM_YUGA_SINSU" value="0" />		<!-- 신수합계 -->
<c:set var="SUM_YUGA_MISU" value="0" />		<!-- 미수합계 -->
<c:set var="SUM_ETC_FINANCE" value="0" />		<!-- 재무 합계 -->
<c:set var="SUM_ETC_LOSS" value="0" />			<!-- 결손 합계 -->
<c:set var="SUM_ETC_LEAVE" value="0" />			<!-- 휴독 합계 -->
<c:set var="SUM_NET_PRICE" value="0" />			<!-- 정가 합계 -->
<c:set var="SUM_FIX_PRICE" value="0" />			<!-- 비정가 합계 -->
<!-- 합계 변수지정end:: -->
<!-- list -->
<div class="box_list">
	<table class="tb_list_a" style="width: 1020px;" >
		<colgroup>
			<col width="40px"> 
			<col width="45px">
			<col width="25px">
			<col width="25px">
			<col width="25px">
			<col width="25px">
			<col width="25px">
			<col width="25px">
			<col width="45px">
			<col width="50px">
			<col width="40px">
			<col width="40px">
			<col width="40px">
			<col width="40px">
			<col width="40px">
			<col width="40px">
			<col width="45px">
			<col width="45px">
			<col width="40px">
			<col width="40px">
			<col width="60px">
			<col width="40px">
			<col width="40px">
			<col width="40px">
			<col width="45px">
			<col width="55px">
		</colgroup>
		<tr>
			<th rowspan="2">
				<c:choose>
					<c:when test="${not empty boseq}">구역</c:when>
					<c:otherwise>지국</c:otherwise>
				</c:choose>
			</th>
		    <th colspan="10">일반독자</th>
		    <th colspan="3">학생독자</th>
		    <th colspan="3">기타독자</th>
		    <th rowspan="2">유가<br/>합계</th>
		    <th colspan="2">무가독자</th>
		    <th rowspan="2">배부수</th>
		    <th rowspan="2">재무</th>
		    <th rowspan="2">결손</th>
		    <th rowspan="2">휴독</th>
		    <th colspan="2">구독료</th>
		</tr>
		<tr>
		    <th>정기</th>
		    <th><div id="td_mon1"></div></th>
		    <th><div id="td_mon2"></div></th>
		    <th><div id="td_mon3"></div></th>
		    <th><div id="td_mon4"></div></th>
		    <th><div id="td_mon5"></div></th>
		    <th><div id="td_mon6"></div></th>
		    <th>기타</th>
		    <th>준유가</th>
		    <th>계</th>
		    <th>본사</th>
		    <th>지국</th>
		    <th>계</th>
		    <th>교육</th>
		    <th>병독</th>
		    <th>본사<br />직원</th>
		    <th>기증</th>
		    <th>홍보</th>
		    <th>정가</th>
		    <th>비정가</th>
		</tr>
		<c:forEach var="list" items="${resultList}" varStatus="status">
			<tr>
				<!-- 구역 -->
				<td>${list.GROUPBYTYPE}</td>
				<!-- 정기 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.READTYPECD011}"  type="number" /></td>
				<!-- 준유가(1개월) -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.SUM_QTY1}"  type="number" /></td>
				<!-- 준유가(2개월) -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.SUM_QTY2}"  type="number" /></td>
				<!-- 준유가(3개월) -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.SUM_QTY3}"  type="number" /></td>
				<!-- 준유가(4개월) -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.SUM_QTY4}"  type="number" /></td>
				<!-- 준유가(5개월) -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.SUM_QTY5}"  type="number" /></td>
				<!-- 준유가(6개월) -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.SUM_QTY6}"  type="number" /></td>
				<!-- 기타 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.SUM_QTY7}"  type="number" /></td>
				<!-- 준유가 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.SUM_QTY1 + list.SUM_QTY2 + list.SUM_QTY3 + list.SUM_QTY4 + list.SUM_QTY5 + list.SUM_QTY6 + list.SUM_QTY7}"  type="number" /></td>
				<!-- 계 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.READTYPECD011 + list.SUM_QTY1 + list.SUM_QTY2 + list.SUM_QTY3 + list.SUM_QTY4 + list.SUM_QTY5 + list.SUM_QTY6 + list.SUM_QTY7}"  type="number" /></td>
				<!-- 본사 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.READTYPECD013}"  type="number" /></td>
				<!-- 지국 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.READTYPECD012}"  type="number" /></td>
				<!-- 계 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.READTYPECD013 + list.READTYPECD012}"  type="number" /></td>
				<!-- 교육 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.READTYPECD015}"  type="number" /></td>
				<!-- 병독 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.READTYPECD014}"  type="number" /></td>
				<!-- 본사직원 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.READTYPECD016}"  type="number" /></td>
				<!-- 유가합계 -->
				<td style="text-align: right;">
					<c:set var="SUM_PRICE" value="${list.READTYPECD011 + list.SUM_QTY1 + list.SUM_QTY2 + list.SUM_QTY3 + list.SUM_QTY4 + list.SUM_QTY5 + list.SUM_QTY6 + list.SUM_QTY7 + list.READTYPECD013 + list.READTYPECD012 + list.READTYPECD015 + list.READTYPECD014 + list.READTYPECD016}" />
					<fmt:formatNumber value="${SUM_PRICE}"  type="number" />
				</td>
				<!-- 기증 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.READTYPECD021}"  type="number" /></td>
				<!-- 홍보 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.READTYPECD022}"  type="number" /></td>
				<!-- 배부수 -->
				<td style="text-align: right;"><fmt:formatNumber value="${SUM_PRICE + list.READTYPECD021 + list.READTYPECD022}"  type="number" /></td>
				<!-- 재무 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.SUM_ETC_FINANCE}"  type="number" /></td>
				<!-- 결손 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.SUM_ETC_LOSS}"  type="number" /></td>
				<!-- 휴독 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.SUM_ETC_LEAVE}"  type="number" /></td>
				<!-- 정가 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.SUM_LIST_PRICE + list.READTYPECD013 + list.READTYPECD012 + list.READTYPECD015 + list.READTYPECD016}"  type="number" /></td>
				<!-- 비정가 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.READTYPECD011 + list.SUM_QTY1 + list.SUM_QTY2 + list.SUM_QTY3 + list.SUM_QTY4 + list.SUM_QTY5 + list.SUM_QTY6 + list.SUM_QTY7 - list.SUM_LIST_PRICE + list.READTYPECD014}"  type="number" /></td>
			</tr>
			<c:set var="READTYPECD011" value="${READTYPECD011 + list.READTYPECD011}" />			<!-- 정기합계 -->
			<c:set var="SUM_QTY1" value="${SUM_QTY1 + list.SUM_QTY1}" />						<!-- 준유가(1개월)합계 -->
			<c:set var="SUM_QTY2" value="${SUM_QTY2 + list.SUM_QTY2}" />						<!-- 준유가(2개월)합계 -->
			<c:set var="SUM_QTY3" value="${SUM_QTY3 + list.SUM_QTY3}" />						<!-- 준유가(3개월)합계 -->
			<c:set var="SUM_QTY4" value="${SUM_QTY4 + list.SUM_QTY4}" />						<!-- 준유가(4개월)합계 -->
			<c:set var="SUM_QTY5" value="${SUM_QTY5 + list.SUM_QTY5}" />						<!-- 준유가(5개월)합계 -->
			<c:set var="SUM_QTY6" value="${SUM_QTY6 + list.SUM_QTY6}" />						<!-- 준유가(6개월)합계 -->
			<c:set var="SUM_QTY7" value="${SUM_QTY7 + list.SUM_QTY7}" />						<!-- 기타합계 -->
			<c:set var="READTYPECD013" value="${READTYPECD013 + list.READTYPECD013}" />			<!-- 학생본사합계 -->
			<c:set var="READTYPECD012" value="${READTYPECD012 + list.READTYPECD012}" />			<!-- 학생지국합계 -->
			<c:set var="READTYPECD015" value="${READTYPECD015 + list.READTYPECD015}" />			<!-- 교육합계 -->
			<c:set var="READTYPECD014" value="${READTYPECD014 + list.READTYPECD014}" />			<!-- 병독합계 -->
			<c:set var="READTYPECD016" value="${READTYPECD016 + list.READTYPECD016}" />			<!-- 본사직원합계 -->
			<c:set var="SUM_ALL_PRICE" value="${SUM_ALL_PRICE + SUM_PRICE}" />					<!-- 유가총합계 -->
			<c:set var="READTYPECD021" value="${READTYPECD021 + list.READTYPECD021}" />			<!-- 기증합계 -->
			<c:set var="READTYPECD022" value="${READTYPECD022 + list.READTYPECD022}" />			<!-- 홍보합계 -->
			<c:set var="SUM_ETC_FINANCE" value="${SUM_ETC_FINANCE + list.SUM_ETC_FINANCE}" />	<!-- 재무 합계 -->
			<c:set var="SUM_ETC_LOSS" value="${SUM_ETC_LOSS + list.SUM_ETC_LOSS}" />			<!-- 결손 합계 -->
			<c:set var="SUM_ETC_LEAVE" value="${SUM_ETC_LEAVE + list.SUM_ETC_LEAVE}" />			<!-- 휴독 합계 -->
			<c:set var="SUM_NET_PRICE" value="${SUM_NET_PRICE + list.SUM_LIST_PRICE + list.READTYPECD013 + list.READTYPECD012 + list.READTYPECD015 + list.READTYPECD016}" />			<!-- 정가 합계 -->
			<c:set var="SUM_FIX_PRICE" value="${SUM_FIX_PRICE + list.READTYPECD011 + list.SUM_QTY1 + list.SUM_QTY2 + list.SUM_QTY3 + list.SUM_QTY4 + list.SUM_QTY5 + list.SUM_QTY6 + list.SUM_QTY7 - list.SUM_LIST_PRICE + list.READTYPECD014}" />								<!-- 비정가 합계 -->
		 </c:forEach>
		<tr style="background-color: #ccdbfb">
		    <td><strong>합계</strong></td>
		    <!-- 정기합계 -->
		    <td style="text-align: right;"><fmt:formatNumber value="${READTYPECD011}"  type="number" /></td>
		    <!-- 준유가(1개월)합계 -->
		    <td style="text-align: right;"><fmt:formatNumber value="${SUM_QTY1}"  type="number" /></td>
		    <!-- 준유가(2개월)합계 -->
		    <td style="text-align: right;"><fmt:formatNumber value="${SUM_QTY2}"  type="number" /></td>
		    <!-- 준유가(3개월)합계 -->
		    <td style="text-align: right;"><fmt:formatNumber value="${SUM_QTY3}"  type="number" /></td>
		    <!-- 준유가(4개월)합계 -->
		    <td style="text-align: right;"><fmt:formatNumber value="${SUM_QTY4}"  type="number" /></td>
		    <!-- 준유가(5개월)합계 -->
		    <td style="text-align: right;"><fmt:formatNumber value="${SUM_QTY5}"  type="number" /></td>
		    <!-- 준유가(6개월)합계 -->
		    <td style="text-align: right;"><fmt:formatNumber value="${SUM_QTY6}"  type="number" /></td>
		    <!-- 기타합계 -->
		    <td style="text-align: right;"><fmt:formatNumber value="${SUM_QTY7}"  type="number" /></td>
		    <!-- 준유가합계 -->
		    <td style="text-align: right;"><fmt:formatNumber value="${SUM_QTY1 + SUM_QTY2 + SUM_QTY3 + SUM_QTY4 + SUM_QTY5 + SUM_QTY6 + SUM_QTY7}"  type="number" /></td>
		    <!-- 일반독자 계의 합계 -->
		    <td style="text-align: right;"><fmt:formatNumber value="${READTYPECD011 + SUM_QTY1 + SUM_QTY2 + SUM_QTY3 + SUM_QTY4 + SUM_QTY5 + SUM_QTY6 + SUM_QTY7}"  type="number" /></td>
		    <!-- 학생본사합계 -->
		    <td style="text-align: right;"><fmt:formatNumber value="${READTYPECD013}"  type="number" /></td>
		    <!-- 학생지국합계 -->
		    <td style="text-align: right;"><fmt:formatNumber value="${READTYPECD012}"  type="number" /></td>
		    <!-- 학생독자 계의 합계 -->
		    <td style="text-align: right;"><fmt:formatNumber value="${READTYPECD013 + READTYPECD012}"  type="number" /></td>
		    <!-- 교육합계 -->
		    <td style="text-align: right;"><fmt:formatNumber value="${READTYPECD015}"  type="number" /></td>
		    <!-- 병독합계 -->
		    <td style="text-align: right;"><fmt:formatNumber value="${READTYPECD014}"  type="number" /></td>
		    <!-- 본사직원합계 -->
		    <td style="text-align: right;"><fmt:formatNumber value="${READTYPECD016}"  type="number" /></td>
		    <!-- 유가합계 -->
		    <td style="text-align: right;"><fmt:formatNumber value="${SUM_ALL_PRICE}"  type="number" /></td>
		    <!-- 기증합계 -->
		    <td style="text-align: right;"><fmt:formatNumber value="${READTYPECD021}"  type="number" /></td>
		    <!-- 홍보합계 -->
		    <td style="text-align: right;"><fmt:formatNumber value="${READTYPECD022}"  type="number" /></td>
		    <!-- 배부수합계 -->
		    <td style="text-align: right;"><fmt:formatNumber value="${SUM_ALL_PRICE + READTYPECD021 + READTYPECD022}"  type="number" /></td>
		    <!-- 재무 합계 -->
		    <td style="text-align: right;"><fmt:formatNumber value="${SUM_ETC_FINANCE}"  type="number" /></td>
		    <!-- 결손 합계 -->
		    <td style="text-align: right;"><fmt:formatNumber value="${SUM_ETC_LOSS}"  type="number" /></td>
		    <!-- 휴독 합계 -->
		    <td style="text-align: right;"><fmt:formatNumber value="${SUM_ETC_LEAVE}"  type="number" /></td>
		    <!-- 정가 합계 -->
		    <td style="text-align: right;"><fmt:formatNumber value="${SUM_NET_PRICE}"  type="number" /></td>
		    <!-- 비정가 합계 -->
		    <td style="text-align: right;"><fmt:formatNumber value="${SUM_FIX_PRICE}"  type="number" /></td>
		</tr>
	</table>
</div>
<!-- //list -->
<!-- move to top button -->
<c:if test="${fn:length(resultList) > 25}"><div style="padding: 10px 0; text-align: right;"><a href="#" onclick="javascript:window.scroll(0,0);"><img alt="위로" title="위로" src="/images/ico_top.gif"></a></div></c:if>
<!-- //move to top button -->
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




