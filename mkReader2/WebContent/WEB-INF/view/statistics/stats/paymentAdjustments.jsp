<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
	
		frm.action = "./state.do";
		frm.submit();
		
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
			actUrl = "./ozState.do";
			window.open('','ozPaymentAdjustments','width=850, height=700, toolbar=no, menubar=no, location=no, status=no, resizable=1, scrollbar=no');

			frm.target = "ozPaymentAdjustments";
			frm.action = actUrl;
			frm.submit();
			frm.target ="";
			
		}else{
			alert('신문명을 체크해주세요.');
		}
	}

	var now = new Date();

	//기간설정
	var beforeDate = new Date("${fn:substring(yymm,0,4)}", parseInt("${fn:substring(yymm,4,6)}") - 1);
	var afterDate = new Date("${fn:substring(yymm,0,4)}", "${fn:substring(yymm,4,6)}" );
</script>
<div style="padding-bottom: 15px;"> 
	<span class="subTitle">당월입금</span>
</div>
<!-- search conditions --> 
<form id="frm" name="frm" method="post">
<input type="hidden" id="type" name="type" value="paymentAdjustments" />
<div>
	<!-- search conditions(left) -->
	<div style="float: left; width: 400px; padding-right: 10px;">
		<table class="tb_search" style="width: 400px;">
			<colgroup>
				<col width="80px">
				<col width="320px">
			</colgroup>
			<tr>
				<th>월 &nbsp; 분</th>
				<td>
					<select id="yymm" name="yymm" style="vertical-align: middle;">
						<script type="text/javascript">
							//선택범위는 현재의 25개월전부터 현재까지 뿌려줌 
							dd = now.getDate();
							var tmp = 0;
							if( dd > 20 ){
								tmp = -1;
							}else{
								tmp = 0;
							}
							for ( var i=25;i>tmp;i-- ){
								nowTime = new Date(now.getFullYear(),now.getMonth()-i);
								yyyy = nowTime.getFullYear();
								mm = nowTime.getMonth() + 1;
								mm = mm < 10 ? "0" + mm : mm;
								
								document.write("<option value='" + yyyy + mm + "'>"+ yyyy + "-" + mm + "</option>");
							}
						</script>
					</select>
					<a href="#fakeUrl" onclick="fn_search();"><img src="/images/bt_joh.gif" style="vertical-align: middle; border: 0;" /></a>
					<a href="#fakeUrl" onclick="ozPrint();"><img src="/images/bt_print.gif" style="vertical-align: middle; border: 0;" /></a> 
				</td>
			</tr>		
			<tr>
				<th>기 &nbsp; 간</th>
				<td>
					<script type="text/javascript">
						document.write("${fn:substring(yymm,0,4)}.${fn:substring(yymm,4,6)}.21 ~ ");
						document.write("${fn:substring(yymm2,0,4)}.${fn:substring(yymm2,4,6)}.<c:out value="${day2}" />");
					</script>
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
					<th></th>
					<th><input type="checkbox" id="controll" name="controll" onclick="checkControll();" style="border: 0;"> </th>
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
<!-- 합계 변수지정 start:: -->
<c:set var="SUM_MISU_AMT" value="0" />						<!-- 전월미수 - 미수 합계 -->
<c:set var="SUM_YUGA_SINSU" value="0" />					<!-- 신수 합계 -->
<c:set var="SUM_YUGA_MISU" value="0" />					<!-- 미수 합계 -->
<c:set var="MON_SUM_ETC1" value="0" />						<!-- 재무,결손,휴독 합계 -->
<c:set var="MON_SUM_SGBBCD011" value="0" />			<!-- 지로합계 -->
<c:set var="MON_SUM_SGBBCD012" value="0" />			<!-- 방문합계 -->
<c:set var="MON_SUM_SGBBCD013" value="0" />			<!-- 무통장합계 -->
<c:set var="MON_SUM_SGBBCD021" value="0" />			<!-- 자동이체합계 -->
<c:set var="MON_SUM_SGBBCD022" value="0" />			<!-- 카드합계 -->
<c:set var="MON_SUM_ETC2" value="0" />						<!-- 기타합계 -->
<!-- 합계 변수지정end:: -->
<!-- list -->		
<div class="box_list">
	<table class="tb_list_a" style="width: 1020px;">
		<colgroup>
			<col width="55px">
			<col width="85px">
			<col width="80px">
			<col width="55px">
			<col width="85px">
			<col width="80px">
			<col width="80px">
			<col width="70px">
			<col width="80px">
			<col width="80px">
			<col width="70px">
			<col width="70px">
			<col width="80px">
			<col width="65px">
		</colgroup>
		<tr>
			<th rowspan="2">
			<c:choose>
				<c:when test="${not empty boseq}">
					구역						    		
				</c:when>
				<c:otherwise>
					지국
				</c:otherwise>
			</c:choose>
			</th>
			<!--<td rowspan="2">전월미수</td>-->
			<th rowspan="2">당월수금<br />예정액</th>
			<th colspan="2">당월 입금내역</th>
			<th rowspan="2">총입금액</th>
			<th rowspan="2">미수총계</th>
			<th colspan="7">수금방법</th>
			<th rowspan="2">수금율</th>
		</tr>
		<tr>
			<th>신수</th>
			<th>재무,<br/>결손</th>
			<th>지로</th>
			<th>방문</th>
			<th>무통장</th>
			<th>자동이체</th>
			<th>카드</th>
			<th>기타</th>
			<th>계</th>
		</tr>
		<c:forEach var="list" items="${resultList}" varStatus="status">
		<tr>
			<!-- 구역 -->
			<td>${list.GROUPBYTYPE}</td>
			<!-- 전월미수 
			<td style="text-align: right;">
				<fmt:formatNumber value="${list.SUM_MISU_AMT}"  type="number" />
			</td>-->
			<!-- 당월수금예정액 -->
			<td style="text-align: right;"><fmt:formatNumber value="${list.MONTH_SUGUM}"  type="number" /></td>
			<!-- 신수 -->
			<td style="text-align: right;"><fmt:formatNumber value="${list.SUM_YUGA_SINSU}"  type="number" /></td>
			<!-- 재무,결손,휴독 -->
			<td style="text-align: right;"><fmt:formatNumber value="${list.MON_SUM_ETC1}"  type="number" /></td>
			<!-- 총입금액 -->
			<td style="text-align: right;"><fmt:formatNumber value="${list.SUM_YUGA_SINSU + list.MON_SUM_ETC1}"  type="number" /></td>
			<!-- 미수총계 -->
			<td style="text-align: right;"><fmt:formatNumber value="${list.MONTH_SUGUM - list.SUM_YUGA_SINSU - list.MON_SUM_ETC1}"  type="number" /><!-- <fmt:formatNumber value="${list.MON_SUM_MISU}"  type="number" /> --></td>
			<!-- 지로 -->
			<td style="text-align: right;"><fmt:formatNumber value="${list.MON_SUM_SGBBCD011}"  type="number" /></td>
			<!-- 방문-->
			<td style="text-align: right;"><fmt:formatNumber value="${list.MON_SUM_SGBBCD012}"  type="number" /></td>
			<!-- 통장입금 -->
			<td style="text-align: right;"><fmt:formatNumber value="${list.MON_SUM_SGBBCD013}"  type="number" /></td>
			<!-- 자동이체 -->
			<td style="text-align: right;"><fmt:formatNumber value="${list.MON_SUM_SGBBCD021}"  type="number" /></td>
			<!-- 카드 -->
			<td style="text-align: right;"><fmt:formatNumber value="${list.MON_SUM_SGBBCD022}"  type="number" /></td>
			<!-- 기타 -->
			<td style="text-align: right;"><fmt:formatNumber value="${list.MON_SUM_ETC2}"  type="number" /></td>
			<!-- 계 -->
			<td style="text-align: right;"><fmt:formatNumber value="${list.MON_SUM_SGBBCD011 + list.MON_SUM_SGBBCD012 + list.MON_SUM_SGBBCD013 + list.MON_SUM_SGBBCD021 + list.MON_SUM_SGBBCD022 + list.MON_SUM_ETC2}"  type="number" /></td>
			<!-- 수금율 -->
			<td style="text-align: right;">
				<c:choose>
					<c:when test="${(list.MONTH_SUGUM) > 0}">
						 <fmt:parseNumber var="tmp1" value="${list.SUM_YUGA_SINSU + list.MON_SUM_ETC1}" integerOnly="false"/>
						 <fmt:parseNumber var="tmp2" value="${list.MONTH_SUGUM}" integerOnly="false"/>
						 <fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						 <fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:when>
					<c:otherwise>
						<fmt:formatNumber value="0" maxFractionDigits="2" type="percent" />
					</c:otherwise>
				</c:choose> 
			</td>
		</tr>
		<c:set var="SUM_MISU_AMT" value="${SUM_MISU_AMT + list.SUM_MISU_AMT}" />				<!-- 전월미수 - 미수 합계 -->
		<c:set var="MONTH_SUGUM" value="${MONTH_SUGUM + list.MONTH_SUGUM}" />				<!-- 당월수금예정액 -->
		<c:set var="SUM_YUGA_SINSU" value="${SUM_YUGA_SINSU + list.SUM_YUGA_SINSU}" />			<!-- 신수 합계 -->
		<c:set var="MON_SUM_ETC1" value="${MON_SUM_ETC1 + list.MON_SUM_ETC1}" />							<!-- 재무,결손,휴독 합계 -->
		<c:set var="MON_SUM_MISU" value="${MON_SUM_MISU + list.MON_SUM_MISU}" />							<!-- 미수총계 합계 -->
		<c:set var="MON_SUM_SGBBCD011" value="${MON_SUM_SGBBCD011 + list.MON_SUM_SGBBCD011}" />				<!-- 지로합계 -->
		<c:set var="MON_SUM_SGBBCD012" value="${MON_SUM_SGBBCD012 + list.MON_SUM_SGBBCD012}" />				<!-- 방문합계 -->
		<c:set var="MON_SUM_SGBBCD013" value="${MON_SUM_SGBBCD013 + list.MON_SUM_SGBBCD013}" />				<!-- 무통장합계 -->
		<c:set var="MON_SUM_SGBBCD021" value="${MON_SUM_SGBBCD021 + list.MON_SUM_SGBBCD021}" />				<!-- 자동이체합계 -->
		<c:set var="MON_SUM_SGBBCD022" value="${MON_SUM_SGBBCD022 + list.MON_SUM_SGBBCD022}" />				<!-- 카드합계 -->
		<c:set var="MON_SUM_ETC2" value="${MON_SUM_ETC2 + list.MON_SUM_ETC2}" />							<!-- 기타합계 -->
		</c:forEach>
		
		<tr style="background-color: #ccdbfb">
			<td><strong>합계</strong></td>
			<!-- 전월미수 합계 
			<td style="text-align: right;">
				<fmt:formatNumber value="${SUM_MISU_AMT}"  type="number" />
			</td>-->
			<!-- 당월수금예정액 합계 -->
			<td style="text-align: right;"><fmt:formatNumber value="${MONTH_SUGUM}"  type="number" /></td>
			<!-- 신수 합계 -->
			<td style="text-align: right;"><fmt:formatNumber value="${SUM_YUGA_SINSU}"  type="number" /></td>
			<!-- 재무,결손,휴독 합계 -->
			<td style="text-align: right;"><fmt:formatNumber value="${MON_SUM_ETC1}"  type="number" /></td>
			<!-- 총입금액 합계 -->
			<td style="text-align: right;"><fmt:formatNumber value="${SUM_YUGA_SINSU + MON_SUM_ETC1}"  type="number" /></td>
			<!-- 미수총계 합계 -->
			<td style="text-align: right;"><fmt:formatNumber value="${MONTH_SUGUM - SUM_YUGA_SINSU - MON_SUM_ETC1}"  type="number" /><!-- <fmt:formatNumber value="${MON_SUM_MISU}"  type="number" /> --></td>
			<!-- 지로 합계 -->
			<td style="text-align: right;"><fmt:formatNumber value="${MON_SUM_SGBBCD011}"  type="number" /></td>
			<!-- 방문 합계 -->
			<td style="text-align: right;"><fmt:formatNumber value="${MON_SUM_SGBBCD012}"  type="number" /></td>
			<!-- 무통장 합계 -->
			<td style="text-align: right;"><fmt:formatNumber value="${MON_SUM_SGBBCD013}"  type="number" /></td>
			<!-- 자동이체 합계 -->
			<td style="text-align: right;"><fmt:formatNumber value="${MON_SUM_SGBBCD021}"  type="number" /></td>
			<!-- 카드 합계 -->
			<td style="text-align: right;"><fmt:formatNumber value="${MON_SUM_SGBBCD022}"  type="number" /></td>
			<!-- 기타 합계 -->
			<td style="text-align: right;"><fmt:formatNumber value="${MON_SUM_ETC2}"  type="number" /></td>
			<!-- 계 합계 -->
			<td style="text-align: right;"><fmt:formatNumber value="${MON_SUM_SGBBCD011 + MON_SUM_SGBBCD012 + MON_SUM_SGBBCD013 + MON_SUM_SGBBCD021 + MON_SUM_SGBBCD022 + MON_SUM_ETC2}"  type="number" /></td>
			<!-- 수금율 평균 -->
			<td style="text-align: right;">
				<c:choose>
					<c:when test="${(MONTH_SUGUM) > 0}">
						<fmt:parseNumber var="tmp1" value="${SUM_YUGA_SINSU + MON_SUM_ETC1}" integerOnly="false"/>
						<fmt:parseNumber var="tmp2" value="${MONTH_SUGUM}" integerOnly="false"/>
						<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:when>
					<c:otherwise>
						<fmt:formatNumber value="0" maxFractionDigits="2" type="percent" />
					</c:otherwise>
				</c:choose> 
			</td>
		</tr>
	</table>
</div>
<!-- //list -->
<!-- move to top button -->
<c:if test="${fn:length(resultList) > 25}"><div style="padding: 10px 0; text-align: right;"><a href="#" onclick="javascript:window.scroll(0,0);"><img alt="위로" title="위로" src="/images/ico_top.gif"></a></div></c:if>
<!-- //move to top button -->
<script>
	var yymm = document.frm.yymm;
	for(var i = 0; i < yymm.length ; i++){
		if(yymm[i].value != null && yymm[i].value == "${yymm}"){
			yymm[i].selected = true;
		}
	}
</script>

