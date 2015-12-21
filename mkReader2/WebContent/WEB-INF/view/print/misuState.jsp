<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
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
		}else if( frm.newsCd.value != "" && frm.newsCd.checked ){
			result = true;
		}else{
			alert('신문명을 체크해주세요.');
			result = false;
		}

		<c:if test="${empty boseq}">
			if(  result ){
				if ( confirm('많은 시간이 소요될 수도 있습니다.\n실행하시겠습니까?') ) {
					result = true;
				}else{
					result = false;
				}
			}
		</c:if>
	
		if( result ){
			
			frm.action = "./misuState.do";
			frm.submit();
		}
		jQuery("#prcssDiv").show();
		
	}

	function ozPrint(){
		actUrl = "/print/print/ozMisuState.do";
		window.open('','ozMisuState','width=1000, height=800, toolbar=no, menubar=no, location=no, status=no, resizable=1, scrollbars=no');

		frm.target = "ozMisuState";
		frm.action = actUrl;
		frm.submit();
		frm.target ="";
	}

	
</script>
<div><span class="subTitle">미수독자명단</span></div>
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
				<th>기 &nbsp; 간</th>
				<td style="text-align: left; padding-left: 10px;">
					<select id="fromYymm" name="fromYymm">
						<c:forEach var="list" items="${yymm}">
							<option value="${list.YYMM}"<c:if test="${fromYymm eq list.YYMM}">selected</c:if>>	<c:out value="${list.YYMM2}" /></option>
						</c:forEach>
					</select>&nbsp;~&nbsp;
				    <select id="toYymm" name="toYymm">
						<c:forEach var="list" items="${yymm}">
							<option value="${list.YYMM}"<c:if test="${toYymm eq list.YYMM}">selected</c:if>>	<c:out value="${list.YYMM2}" /></option>
						</c:forEach>
					</select>
				</td>
			</tr>	
			<tr>
				<th>구 &nbsp; 역</th>
				<td style="text-align: left; padding-left: 10px;">
					<select  id="fromGno" name="fromGno">
						<c:forEach var="list" items="${gnoList}">
							<option value="${list.GNO}"<c:if test="${fromGno eq list.GNO}">selected</c:if>>
								<c:out value="${list.GNO}" />
							</option>
						</c:forEach>
					</select> 
					<select id="toGno" name="toGno">
						<c:forEach var="list" items="${gnoList}" varStatus="status">
							<option value="${list.GNO}"<c:if test="${toGno eq list.GNO or (empty toGno and status.last)}">selected</c:if>>
								<c:out value="${list.GNO}" />
							</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th>미수개월</th>
				<td style="text-align: left; padding-left: 10px;">
					<select id="gubun" name="gubun">
							<option value="1" <c:if test="${gubun eq '1'}">selected</c:if>>1개월 이상</option>
							<option value="2" <c:if test="${gubun eq '2'}">selected</c:if>>2개월 이상</option>
							<option value="3" <c:if test="${gubun eq '3'}">selected</c:if>>3개월 이상</option>
							<option value="4" <c:if test="${gubun eq '4'}">selected</c:if>>4개월 이상</option>
							<option value="5" <c:if test="${gubun eq '5'}">selected</c:if>>5개월 이상</option>
							<option value="6" <c:if test="${gubun eq '6'}">selected</c:if>>6개월 이상</option>
							<option value="7" <c:if test="${gubun eq '7'}">selected</c:if>>7개월 이상</option>
							<option value="8" <c:if test="${gubun eq '8'}">selected</c:if>>8개월 이상</option>
							<option value="9" <c:if test="${gubun eq '9'}">selected</c:if>>9개월 이상</option>
							<option value="10" <c:if test="${gubun eq '10'}">selected</c:if>>10개월 이상</option>
							<option value="11" <c:if test="${gubun eq '11'}">selected</c:if>>11개월 이상</option>
							<option value="12" <c:if test="${gubun eq '12'}">selected</c:if>>12개월 이상</option>
					</select>
				</td>
			</tr>		
			<tr>
				<th>중지독자</th>
				<td style="text-align: left; padding-left: 10px;">
					<font class="b02"><input type="checkbox" id="streader" name="streader"  value="1" style="vertical-align: middle; border: 0;" <c:if test="${streader eq '1'}">checked</c:if> /> 중지독자 포함</font>
					&nbsp;
					<img src="/images/bt_joh.gif" style="vertical-align: middle; border: 0; cursor: pointer;" onclick="fn_search();" />
					<img src="/images/bt_print.gif" style="vertical-align: middle; border: 0; cursor: pointer;" onclick="ozPrint();">
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
					<th width="20"></th>
					<th><input type="checkbox" id="controll" name="controll"  onclick="checkControll();" style="border: 0;"> </th>
					<th>코드</th>
					<th>신문명</th>
				</tr>
				<tr id=div1 style="display:none;">
					<td colspan="4"><input type="checkbox" id="newsCd" name="newsCd" value="0" /></td>
				</tr>
			</table>
			<div style="width: 330px; height:98px;overflow-y:scroll; overflow-x:none; margin: 0 auto;">
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
								<input type="checkbox" id="newsCd" name="newsCd" value="${list.CODE}" style="border: 0"
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
<c:set var="reader" value="0" />					
<c:set var="readerQty" value="0" />						
<c:set var="stu" value="0" />					
<c:set var="stuQty" value="0" />						
<c:set var="etc" value="0" />					
<c:set var="etcQty" value="0" />						
<c:set var="total" value="0" />					
<c:set var="totalQty" value="0" />						
<c:forEach var="list" items="${resultList}" varStatus="status">
	<c:if test="${list.READTYPENM == '일반'}">
		    <c:set var="reader" value="${reader + 1}" />	
			<c:set var="readerQty" value="${readerQty + list.QTY}" />		
	</c:if>
	<c:if test="${list.READTYPENM == '학생(지국)' || list.READTYPENM == '학생(본사)'}">
		    <c:set var="stu" value="${stu + 1}" />	
			<c:set var="stuQty" value="${stuQty + list.QTY}" />		
	</c:if>
	<c:if test="${list.READTYPENM != '일반' && list.READTYPENM != '학생(지국)' && list.READTYPENM != '학생(본사)'}">
		 <c:set var="etc" value="${etc + 1}" />	
		<c:set var="etcQty" value="${etcQty + list.QTY}" />				
	</c:if>
	<c:set var="total" value="${total + 1}" />	
	<c:set var="totalQty" value="${totalQty + list.QTY}" />		
</c:forEach>
<!-- count -->
<div style="clear: both; width: 1020px; text-align: left; font-weight: bold; padding: 20px 0 5px 0">
	◆ 일반: <fmt:formatNumber value="${readerQty}" type="number" />부&nbsp;&nbsp;&nbsp;학생: <fmt:formatNumber value="${stuQty}" type="number" />부&nbsp;&nbsp;&nbsp;기타: <fmt:formatNumber value="${etcQty}" type="number" />부&nbsp;&nbsp;&nbsp;총부수: <fmt:formatNumber value="${totalQty}" type="number" />부
</div>
<!-- //count -->
<!-- 합계 변수지정start:: -->
<c:set var="BILLQTY" value="0" />					<!-- 건수 합계 -->
<c:set var="AMT" value="0" />						<!-- 금액 합계 -->
<!-- 합계 변수지정end:: -->
<!-- list -->
<div>
	<table class="tb_list_a" style="width: 1020px;">
		<colgroup>
			<col width="110px">
			<col width="60px">
			<col width="85px">
			<col width="65px">
			<col width="85px">
			<col width="65px">
			<col width="60px">
			<col width="60px">
			<col width="65px">
			<col width="70px">
			<col width="85px">
			<col width="85px">
			<col width="110px">
		</colgroup>
		<tr>
			<th>독자번호</th>
			<th>구분</th>
			<th>독자명</th>
			<th>주소</th>
			<th>전화</th>
			<th>매체</th>
			<th>부수</th>
			<th>단가</th>
			<th>수금</th>
			<th>확 장</th>						    
			<th>유가월</th>
			<th>미수금</th>
			<th>수금사항</th>
		</tr>
		<!-- 합계 변수지정end:: -->
		<c:forEach var="list" items="${resultList}" varStatus="status">
		<tr class="mover_color">
			<td><c:out value="${list.READNO}" /><br /><c:out value="${list.GNO}" />-<c:out value="${list.BNO}" /></td>
			<td><c:out value="${list.READTYPENM}" /></td>
			<td style="text-align: left"><c:out value="${list.READNM}" /></td>
			<td style="text-align: left"><c:out value="${list.DLVADRS1}" /></td>
			<td style="text-align: left"><c:out value="${list.MOBILE}" /><br><c:out value="${list.HOMETEL}" /></td>
			<td><c:out value="${list.NEWSNM}" /></td>
			<td><fmt:formatNumber value="${list.QTY}" type="number" /></td>
			<td style="text-align: right"><fmt:formatNumber value="${list.UPRICE}" type="number" /></td>
			<td><c:out value="${list.SGTYPENM}" /></td>
			<td>
				<c:if test="${fn:length(list.HJDT) == 8}">
				<c:out value="${fn:substring(list.HJDT,2,4)}" />/<c:out value="${fn:substring(list.HJDT,4,6)}" />/<c:out value="${fn:substring(list.HJDT,6,8)}" />
				</c:if><br>
				<c:out value="${list.HJPSNM}" />
			</td>
			<td>
				<c:if test="${fn:length(list.SGBGMM) == 6}">
				<c:out value="${fn:substring(list.SGBGMM,2,4)}" />/<c:out value="${fn:substring(list.SGBGMM,4,6)}" />
				</c:if>
			</td>
			<td style="text-align: right"><fmt:formatNumber value="${list.MISUAMT}" type="number" /></td>
			<td><c:out value="${list.SGHIST}" /></td>
		</tr>
		<c:set var="BILLQTY" value="${BILLQTY + list.QTY}" />		<!-- 건수 합계 -->
		<c:set var="AMT" value="${AMT + list.MISUAMT}" />		<!-- 금액 합계 -->
		</c:forEach>
		<tr style="background-color: #ccdbfb">
			<td><strong>합 &nbsp; 계</strong></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td><fmt:formatNumber value="${BILLQTY}"  type="number" /></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td style="text-align: right"><fmt:formatNumber value="${AMT}"  type="number" /></td>
			<td>&nbsp;</td>
		</tr>
	</table>
</div>
<!-- //list -->
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