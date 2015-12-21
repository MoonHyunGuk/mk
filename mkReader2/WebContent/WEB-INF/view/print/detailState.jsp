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
			return;
		}

		result = false;
		for(var i=0;i<frm.gubun.length;i++){
			if(frm.gubun[i].checked){
				result = true;
			}
		}
		if( !result ){
			alert('입금방법을 체크해주세요.');
			return;
		}
		

		if(${boseq} == "") {
			if(  result ){
				if ( confirm('많은 시간이 소요될 수도 있습니다.\n실행하시겠습니까?') ) {
					result = true;
				}else{
					result = false;
				}
			}
		}
	
		if( result ){
			frm.action = "./detailState.do";
			frm.submit();
			jQuery("#prcssDiv").show();
		}
		
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
		}else if( frm.newsCd.value != "" && frm.newsCd.checked ){
			result = true;
		}else{
			alert('신문명을 체크해주세요.');
			result = false;
			return;
		}

		result = false;
		for(var i=0;i<frm.gubun.length;i++){
			if(frm.gubun[i].checked){
				result = true;
			}
		}
		if( !result ){
			alert('입금방법을 체크해주세요.');
			return;
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
			actUrl = "/print/print/ozDetailState.do";
			window.open('','ozDetailState','width=1000, height=800, toolbar=no, menubar=no, location=no, status=no, resizable=1, scrollbars=no');

			frm.target = "ozDetailState";
			frm.action = actUrl;
			frm.submit();
			frm.target ="";
			//frm.action = "./detailState_excel.do";
			//frm.submit();
		}
	}
	
	
	function checkBoxEvent1(){
		var frm = document.frm;

		
		if( frm.gubunChk.checked ){
			for(var i=0;i<frm.gubun.length;i++){
				frm.gubun[i].checked = true;
			}
		}else {
			for(var i=0;i<frm.gubun.length;i++){
				frm.gubun[i].checked = false;
			}
		}
	}
	
	function checkBoxEvent2(){
		var frm = document.frm;
		if( frm.gubunChk.checked ){
			frm.gubunChk.checked = false;
		}
	}
</script>
<div><span class="subTitle">입금내역현황</span></div>
<!-- search conditions -->
<form id="frm" name="frm" method="post">
<div style="margin: 0 auto; width: 1020px;">
	<!-- search conditions(left) -->
	<div style="float: left; width: 400px; padding-right: 10px;">
		<table class="tb_edit_4" style="width: 400px;">
			<colgroup>
				<col width="80px">
				<col width="320px">
			</colgroup>
			<tr>
				<th>기 &nbsp; 간</th>
				<td style="text-align: left; padding-left: 10px;">
					<input type="text" id="fromYymmdd" name="fromYymmdd" value='<c:out value="${fromYymmdd}" />' readonly onclick="Calendar(this)" style="width: 85px; vertical-align: middle;"/> ~ 
					<input type="text" id="toYymmdd" name="toYymmdd" value='<c:out value="${toYymmdd}" />' readonly onclick="Calendar(this)" style="width: 85px; vertical-align: middle;"/>
					<a href="#fakeUrl" onclick="fn_search();"><img src="/images/bt_joh.gif" style="border:0; vertical-align: middle;"/></a>
				</td>
			</tr>
			<tr>
				<th>기 준 일</th>
				<td style="text-align: left; padding-left: 10px;">
					<input type="radio" id="dateGubun" name="dateGubun" value="icdt" style="border: 0; vertical-align: middle;" <c:if test="${empty dateGubun or dateGubun eq 'icdt'}">checked="checked"</c:if>/>&nbsp;수금일자
					<input type="radio" id="dateGubun" name="dateGubun" value="cldt" style="border: 0; vertical-align: middle;" <c:if test="${dateGubun eq 'cldt'}">checked="checked"</c:if>/>&nbsp;처리일자 
				</td>
			</tr>
			<tr>
				<th>구 &nbsp; 역</th>
				<td style="text-align: left; padding-left: 10px;">
					<select id="fromGno" name="fromGno" style="vertical-align: middle;">
						<c:forEach var="list" items="${gnoList}">
							<option value="${list.GNO}"<c:if test="${fromGno eq list.GNO}">selected</c:if>>
								<c:out value="${list.GNO}" />
							</option>
						</c:forEach>
					</select> 
					<select id="toGno" name="toGno" style="vertical-align: middle;">
						<c:forEach var="list" items="${gnoList}" varStatus="status">
							<option value="${list.GNO}"<c:if test="${toGno eq list.GNO or (empty toGno and status.last)}">selected</c:if>>
								<c:out value="${list.GNO}" />
							</option>
						</c:forEach>
					</select>
					<a href="#fakeUrl" onclick="ozPrint();"><img src="/images/bt_print.gif" style="border:0; vertical-align: middle;"/></a>
				</td>
			</tr>
			<tr>
				<th>입금방법</th>
				<td>
					<div style="overflow: hidden; ">
						<div style="float: left; width: 55px; text-align: left;">&nbsp;<input type="checkbox" id="gubunChk" name="gubunChk" onclick="checkBoxEvent1();" style="vertical-align: middle; border: 0;"/>&nbsp;전체</div>
						<div style="float: left; width: 80px; text-align: left;">&nbsp;<input type="checkbox" id="gubun" name="gubun" value="011" onclick="checkBoxEvent2();" style="vertical-align: middle; border: 0;"/>&nbsp;지로</div>
						<div style="float: left; width: 55px; text-align: left;">&nbsp;<input type="checkbox" id="gubun" name="gubun" value="012" onclick="checkBoxEvent2();" style="vertical-align: middle; border: 0;"/>&nbsp;방문</div>
						<div style="float: left; width: 65px; text-align: left;">&nbsp;<input type="checkbox" id="gubun" name="gubun" value="013" onclick="checkBoxEvent2();" style="vertical-align: middle; border: 0;"/>&nbsp;통장</div>
						<div style="float: left; width: 55px; text-align: left;">&nbsp;<input type="checkbox" id="gubun" name="gubun" value="021" onclick="checkBoxEvent2();" style="vertical-align: middle; border: 0;"/>&nbsp;자동</div>
					</div>
					<div style="overflow: hidden; clear: both; padding: 5px 0;">
						<div style="float: left; width: 55px; text-align: left;">&nbsp;<input type="checkbox" id="gubun" name="gubun" value="022" onclick="checkBoxEvent2();" style="vertical-align: middle; border: 0;"/>&nbsp;카드</div>
						<div style="float: left; width: 80px; text-align: left;">&nbsp;<input type="checkbox" id="gubun" name="gubun" value="023" onclick="checkBoxEvent2();" style="vertical-align: middle; border: 0;"/>&nbsp;본사입금</div>
						<div style="float: left; width: 55px; text-align: left;">&nbsp;<input type="checkbox" id="gubun" name="gubun" value="024" onclick="checkBoxEvent2();" style="vertical-align: middle; border: 0;"/>&nbsp;쿠폰</div>
						<div style="float: left; width: 65px; text-align: left;">&nbsp;<input type="checkbox" id="gubun" name="gubun" value="031" onclick="checkBoxEvent2();" style="vertical-align: middle; border: 0;"/>&nbsp;결손</div>
						<div style="float: left; width: 55px; text-align: left;">&nbsp;<input type="checkbox" id="gubun" name="gubun" value="032" onclick="checkBoxEvent2();" style="vertical-align: middle; border: 0;"/>&nbsp;재무</div>
					</div>
					<div style="overflow: hidden; clear: both;">
						<div style="float: left; width: 55px;; text-align: left;">&nbsp;<input type="checkbox" id="gubun" name="gubun" value="033" onclick="checkBoxEvent2();" style="vertical-align: middle; border: 0;"/>&nbsp;휴독</div>
						<div style="float: left; width: 80px;; text-align: left;">&nbsp;<input type="checkbox" id="gubun" name="gubun" value="044" onclick="checkBoxEvent2();" style="vertical-align: middle; border: 0;"/>&nbsp;미수</div>
						<div style="float: left; width: 55px;; text-align: left;">&nbsp;<input type="checkbox" id="gubun" name="gubun" value="088" onclick="checkBoxEvent2();" style="vertical-align: middle; border: 0;"/>&nbsp;기타</div>
						<div style="float: left; width: 65px;; text-align: left;">&nbsp;<input type="checkbox" id="gubun" name="gubun" value="099" onclick="checkBoxEvent2();" style="vertical-align: middle; border: 0;"/>&nbsp;월삭제</div>
						<div style="float: left; width: 55px;; text-align: left;">&nbsp;</div>
					</div>
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
					<th><input type="checkbox" id="controll" name="controll"  onclick="checkControll();" style="border: 0;"> </th>
					<th>코드</th>
					<th>신문명</th>
				</tr>
				<tr id=div1 style="display:none;"><td><input type="checkbox" id="newsCd" name="newsCd" value="0" /></td></tr>
			</table>
			<div style="width: 330px;height:132px;overflow-y:scroll;margin: 0 auto;">
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
							<input type="checkbox" id="newsCd" name="newsCd" value="${list.CODE}"   style="border: 0;"
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
<!-- //search conditions -->
<!-- 합계 변수지정start:: -->
<c:set var="BILLQTY" value="0" />					<!-- 건수 합계 -->
<c:set var="AMT" value="0" />						<!-- 금액 합계 -->

<c:set var="BILLQTY_GNO" value="0" />				<!-- 건수 합계 -->
<c:set var="AMT_GNO" value="0" />					<!-- 금액 합계 -->
<!-- 합계 변수지정end:: -->
<!-- list -->
<div style="padding: 15px 0 20px 0; overflow: hidden; clear: both;">
	<table class="tb_list_a" style="width: 1020px;">
		<colgroup>
			<col width="135px">
			<col width="165px">
			<col width="190px">
			<col width="65px">
			<col width="60px">
			<col width="65px">
			<col width="65px">
			<col width="65px">
			<col width="80px">
			<col width="130px">
		</colgroup>
		<tr>
			<th>독자번호</th>
			<th>독자명</th>
			<th>주 &nbsp; 소</th>
			<th>매 &nbsp; 체</th>
			<th>월 &nbsp; 분</th>
			<th>방 &nbsp; 법</th>
			<th>수 &nbsp; 량</th>
			<th>금 &nbsp; 액</th>
			<th>
			<c:if test="${empty dateGubun or dateGubun eq 'cldt'}">
			처리일자
			</c:if>
			<c:if test="${dateGubun eq 'icdt'}">
			수금일자
			</c:if>
			</th>
			<th>수금사항</th>
		</tr>
		<c:forEach var="list" items="${resultList}" varStatus="status">
			<tr>
				<!-- 독자번호 -->
				<td><c:out value="${list.GNO}" />-<c:out value="${list.READNO}" />-<c:out value="${list.BNO}" /></td>
				<!-- 독자명 -->
				<td style="text-align: left;"><c:out value="${list.READNM}" /></td>
				<!-- 주소 -->
				<td style="text-align: left;"><c:out value="${list.ADDR}" /></td>
				<!-- 매체 -->
				<td><c:out value="${list.NEWSCD_YNAME}" /></td>
				<!-- 월분 -->
				<td><c:out value="${list.YYMMSTR}" /></td>
				<!-- 방법 -->
				<td><c:out value="${list.SGBBCD_YNAME}" /></td>
				<!-- 수량 -->
				<td><c:out value="${list.BILLQTY}" /></td>
				<!-- 금액 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.AMT}"  type="number" /></td>
				<!-- 입금일자 -->
				<td><c:out value="${list.SEARCHDATE}" /></td>
				<!-- 수금사항 -->
				<td><c:out value="${list.THISYEARHISTORY}" /></td>
			</tr>
			<c:set var="BILLQTY" value="${BILLQTY + list.BILLQTY}" />			<!-- 건수 합계 -->
			<c:set var="AMT" value="${AMT + list.AMT}" />						<!-- 금액 합계 -->
			<c:set var="BILLQTY_GNO" value="${BILLQTY_GNO + list.BILLQTY}" />	<!-- 건수 합계 -->
			<c:set var="AMT_GNO" value="${AMT_GNO + list.AMT}" />				<!-- 금액 합계 -->
			<c:if test="${(list.GNO ne resultList[status.index+1].GNO) or status.last}">
				<tr style="background-color: #ffcccc">
					<td colspan="10">
						&nbsp; [${list.GNO}]구역 &nbsp; 수량 : ${BILLQTY_GNO} &nbsp; 금 &nbsp; 액 : <fmt:formatNumber value="${AMT_GNO}"  type="number" />
					</td>
				</tr>
			<c:set var="BILLQTY_GNO" value="0" />				<!-- 건수 합계 -->
			<c:set var="AMT_GNO" value="0" />					<!-- 금액 합계 -->
			</c:if>
		</c:forEach>
		<tr style="background-color: #ccdbfb">
			<td><strong>합 &nbsp; 계</strong></td>
			<!-- 독자명 -->
			<td>&nbsp;</td>
			<!-- 주소 -->
			<td>&nbsp;</td>
			<!-- 매체 -->
			<td>&nbsp;</td>
			<!-- 월분 -->
			<td>&nbsp;</td>
			<!-- 방법 -->
			<td>&nbsp;</td>
			<!-- 수량 -->
			<td>
			<c:out value="${BILLQTY}" />
			</td>
			<!-- 금액 -->
			<td style="text-align: right"><fmt:formatNumber value="${AMT}"  type="number" /></td>
			<!-- 입금일자 -->
			<td>&nbsp;</td>
			<!-- 수금사항 -->
			<td>&nbsp;</td>
		</tr>
</table>
</div>
<!-- //list -->
</form>
<!-- script -->
<c:choose>
	<c:when test="${empty gubun}">
		<script type="text/javascript">
			for(var i=0;i<frm.gubun.length;i++){
				frm.gubun[i].checked = true;
			}
		</script>
	</c:when>
	<c:otherwise>
		<c:forEach items="${gubun}" varStatus="counter">
			<script type="text/javascript">
				for(var i=0;i<frm.gubun.length;i++){
					if( frm.gubun[i].value == "<c:out value='${gubun[counter.index]}' />" ){
						frm.gubun[i].checked = true;
					}
				}
			</script>
		</c:forEach>
	</c:otherwise>
</c:choose>
<!-- script -->
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