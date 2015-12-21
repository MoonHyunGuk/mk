<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript"> // 매체 종류 전체 선택/해제
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
			frm.action = "./sugmState.do";
			frm.submit();
			jQuery("#prcssDiv").show();
		}
	}

	function ozPrint(){

		actUrl = "/print/print/ozSugmState.do";
		window.open('','ozSugmState','width=1000, height=800, toolbar=no, menubar=no, location=no, status=no, resizable=1, scrollbars=no');

		frm.target = "ozSugmState";
		frm.action = actUrl;
		frm.submit();
		frm.target ="";
	}
	
</script>
<div><span class="subTitle">일일수금현황</span></div>
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
					<input type="text" id="fromYymmdd" name="fromYymmdd" value='<c:out value="${fromYymmdd}" />' readonly onclick="Calendar(this)" style="width: 85px"/> ~ 
					<input type="text" id="toYymmdd" name="toYymmdd" value='<c:out value="${toYymmdd}" />' readonly onclick="Calendar(this)" style="width: 85px"/>
				</td>
			</tr>
			<tr>
				<th>기 준 일</th>
				<td style="text-align: left; padding-left: 10px;">
					<input type="radio" id="dateGubun" name="dateGubun" value="cldt" <c:if test="${empty dateGubun or dateGubun eq 'cldt'}">checked="checked"</c:if> style="vertical-align: middle; border: 0;"/>&nbsp;처리일자
					<input type="radio" id="dateGubun" name="dateGubun" value="icdt" <c:if test="${dateGubun eq 'icdt'}">checked="checked"</c:if> style="vertical-align: middle; border: 0;"/>&nbsp;수금일자
				</td>
			</tr>
			<tr>
				<th>구 &nbsp; 역</th>
				<td style="text-align: left; padding-left: 10px;">
					<select id="fromGno" name="fromGno">
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
				<th>구 &nbsp; 분</th>
				<td style="text-align: left; padding-left: 10px;">
					<input type="radio" id="gubun" name="gubun" value="day" <c:if test="${empty gubun or gubun eq 'day'}">checked="checked"</c:if> style="vertical-align: middle; border: 0;"/>&nbsp;일자별
					<input type="radio" id="gubun" name="gubun" value="gno" <c:if test="${gubun eq 'gno'}">checked="checked"</c:if> style="vertical-align: middle; border: 0;"/>&nbsp;구역별
					&nbsp;
					<a href="#fakeUrl"  onclick="fn_search();"><img src="/images/bt_joh.gif" style="vertical-align: middle; border: 0;" /></a>
					<a href="#fakeUrl" onclick="ozPrint();"><img src="/images/bt_print.gif" style="vertical-align: middle; border: 0;"></a>
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
				<tr id=div1 style="display:none;"><td> <input type="checkbox" id="newsCd" name="newsCd" value="0" /> </td></tr>
			</table>
			<div style="width: 330px;height:115px;overflow-y:scroll;margin: 0 auto;">
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
							<input type="checkbox" id="newsCd" name="newsCd" value="${list.CODE}"  style="border: 0;"
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
								</c:choose>/>
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
</form>	
<!-- 합계 변수지정start:: -->
<c:set var="SUM_QTY_SGBBCD011" value="0" />					<!-- 지로건수 합계 -->
<c:set var="SUM_AMT_SGBBCD011" value="0" />					<!-- 지로금액 합계 -->
<c:set var="SUM_QTY_SGBBCD012" value="0" />					<!-- 방문건수 합계 -->
<c:set var="SUM_AMT_SGBBCD012" value="0" />					<!-- 방문금액 합계 -->
<c:set var="SUM_QTY_SGBBCD013" value="0" />					<!-- 통장건수 합계 -->
<c:set var="SUM_AMT_SGBBCD013" value="0" />					<!-- 통장금액 합계 -->
<c:set var="SUM_QTY_SGBBCD021" value="0" />					<!-- 자동건수 합계 -->
<c:set var="SUM_AMT_SGBBCD021" value="0" />					<!-- 자동금액 합계 -->
<c:set var="SUM_QTY_SGBBCD022" value="0" />					<!-- 카드건수 합계 -->
<c:set var="SUM_AMT_SGBBCD022" value="0" />					<!-- 카드금액 합계 -->
<c:set var="SUM_QTY_ETC1" value="0" />							<!-- 교육용,쿠폰건수 합계 -->
<c:set var="SUM_AMT_ETC1" value="0" />							<!-- 교육용,쿠폰금액 합계 -->
<c:set var="SUM_QTY_ETC3" value="0" />							<!-- 기타건수 합계 -->
<c:set var="SUM_AMT_ETC3" value="0" />							<!-- 기타금액 합계 -->
<c:set var="SUM_AMT" value="0" />								<!-- 합계금액 합계 -->
<c:set var="SUM_QTY_ETC2" value="0" />							<!-- 결손,재무,휴독,미수건수 합계 -->
<c:set var="SUM_AMT_ETC2" value="0" />							<!-- 결손,재무,휴독,미수금액 합계 -->
<!-- 합계 변수지정end:: -->
<!-- list -->
<div style="clear: both; padding: 15px 0 20px; width: 1020px">
	<table class="tb_list_a" style="widows: 1020px;">
		<colgroup>
			<c:choose>
				<c:when test="${gubun eq 'gno'}">
					<col width="89px">
					<col width="49px">
					<col width="49px">
					<col width="49px">
					<col width="49px">
					<col width="49px">
					<col width="49px">
					<col width="49px">
					<col width="49px">
					<col width="49px">
					<col width="49px">
					<col width="49px">
					<col width="49px">
					<col width="49px">
					<col width="49px">
					<col width="49px">
					<col width="49px">
					<col width="49px">
					<col width="49px">
					<col width="49px">
				</c:when>
				<c:otherwise>
					<col width="102px">
					<col width="51px">
					<col width="51px">
					<col width="51px">
					<col width="51px">
					<col width="51px">
					<col width="51px">
					<col width="51px">
					<col width="51px">
					<col width="51px">
					<col width="51px">
					<col width="51px">
					<col width="51px">
					<col width="51px">
					<col width="510px">
					<col width="51px">
					<col width="51px">
					<col width="51px">
					<col width="51px">
				</c:otherwise>
			</c:choose>
		</colgroup>
		<tr  bgcolor="f9f9f9" class="box_p" >
			<th rowspan="2">
				<c:if test="${empty dateGubun or dateGubun eq 'cldt'}">처리일자	</c:if>
				<c:if test="${dateGubun eq 'icdt'}">수금일자</c:if>
			</th>
			<c:if test="${gubun eq 'gno'}">
				<th rowspan="2">구 &nbsp; 역</th>
			</c:if>
			<th colspan="2">지 &nbsp; 로</th>
			<th colspan="2">방 &nbsp; 문</th>
			<th colspan="2">통 &nbsp; 장</th>
			<th colspan="2">자 &nbsp; 동</th>
			<th colspan="2">카 &nbsp; 드</th>
			<th colspan="2" <c:if test="${gubun ne 'gno'}">style="letter-spacing: -1px;"</c:if>>교육용,쿠폰</th>
			<th colspan="2">기 &nbsp; 타</th>
			<th colspan="2">입금합계</th>
			<th colspan="2">결손,재무</th>
		</tr>
		<tr>
			<th>건수</th>
			<th>금액</th>
			<th>건수</th>
			<th>금액</th>
			<th>건수</th>
			<th>금액</th>
			<th>건수</th>
			<th>금액</th>
			<th>건수</th>
			<th>금액</th>
			<th>건수</th>
			<th>금액</th>
			<th>건수</th>
			<th>금액</th>
			<th>건수</th>
			<th>금액</th>
			<th>건수</th>
			<th>금액</th>
		</tr>
		<c:forEach var="list" items="${resultList}" varStatus="status">
			<tr>
				<!-- 입금일자 -->
				<td><c:out value="${fn:substring(list.SEARCHDATE,0,4)}" />-<c:out value="${fn:substring(list.SEARCHDATE,4,6)}" />-<c:out value="${fn:substring(list.SEARCHDATE,6,8)}" /></td>
				<c:if test="${gubun eq 'gno'}">
				<!-- 구역 -->
					<td><c:out value="${list.GNO}" /></td>
				</c:if>
				<!-- 지로건수 -->
				<td style="text-align: right;"><c:out value="${list.SUM_QTY_SGBBCD011}" /></td>
				<!-- 지로금액 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.SUM_AMT_SGBBCD011}"  type="number" /></td>
				<!-- 방문건수 -->
				<td style="text-align: right;"><c:out value="${list.SUM_QTY_SGBBCD012}" /></td>
				<!-- 방문금액 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.SUM_AMT_SGBBCD012}"  type="number" /></td>
				<!-- 통장건수 -->
				<td style="text-align: right;"><c:out value="${list.SUM_QTY_SGBBCD013}" /></td>
				<!-- 통장금액 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.SUM_AMT_SGBBCD013}"  type="number" /></td>
				<!-- 자동건수 -->
				<td style="text-align: right;"><c:out value="${list.SUM_QTY_SGBBCD021}" /></td>
				<!-- 자동금액 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.SUM_AMT_SGBBCD021}"  type="number" /></td>
				<!-- 카드건수 -->
				<td style="text-align: right;"><c:out value="${list.SUM_QTY_SGBBCD022}" /></td>
				<!-- 카드금액 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.SUM_AMT_SGBBCD022}"  type="number" /></td>
				<!-- 교육용,쿠폰건수 -->
				<td style="text-align: right;"><c:out value="${list.SUM_QTY_ETC1}" /></td>
				<!-- 교육용,쿠폰금액 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.SUM_AMT_ETC1}"  type="number" /></td>
				<!-- 기타건수 -->
				<td style="text-align: right;"><c:out value="${list.SUM_QTY_ETC3}" /></td>
				<!-- 기타금액 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.SUM_AMT_ETC3}"  type="number" /></td>
				<!-- 합계건수 -->
				<td style="text-align: right;"><c:out value="${list.SUM_QTY_SGBBCD011 + list.SUM_QTY_SGBBCD012 + list.SUM_QTY_SGBBCD013 + list.SUM_QTY_SGBBCD021 + list.SUM_QTY_SGBBCD022 + list.SUM_QTY_ETC1 + list.SUM_QTY_ETC3}" /></td>
				<!-- 합계금액 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.SUM_AMT_SGBBCD011 + list.SUM_AMT_SGBBCD012 + list.SUM_AMT_SGBBCD013 + list.SUM_AMT_SGBBCD021 + list.SUM_AMT_SGBBCD022 + list.SUM_AMT_ETC1 + list.SUM_AMT_ETC3}"  type="number" /></td>
				<!-- 결손,재무,휴독,미수건수 -->
				<td style="text-align: right;"><c:out value="${list.SUM_QTY_ETC2}" /></td>
				<!-- 결손,재무,휴독,미수금액 -->
				<td style="text-align: right;"><fmt:formatNumber value="${list.SUM_AMT_ETC2}"  type="number" /></td>
			</tr>
			<c:set var="SUM_QTY_SGBBCD011" value="${SUM_QTY_SGBBCD011 + list.SUM_QTY_SGBBCD011}" />					<!-- 지로건수 합계 -->
			<c:set var="SUM_AMT_SGBBCD011" value="${SUM_AMT_SGBBCD011 + list.SUM_AMT_SGBBCD011}" />					<!-- 지로금액 합계 -->
			<c:set var="SUM_QTY_SGBBCD012" value="${SUM_QTY_SGBBCD012 + list.SUM_QTY_SGBBCD012}" />					<!-- 방문건수 합계 -->
			<c:set var="SUM_AMT_SGBBCD012" value="${SUM_AMT_SGBBCD012 + list.SUM_AMT_SGBBCD012}" />					<!-- 방문금액 합계 -->
			<c:set var="SUM_QTY_SGBBCD013" value="${SUM_QTY_SGBBCD013 + list.SUM_QTY_SGBBCD013}" />					<!-- 통장건수 합계 -->
			<c:set var="SUM_AMT_SGBBCD013" value="${SUM_AMT_SGBBCD013 + list.SUM_AMT_SGBBCD013}" />					<!-- 통장금액 합계 -->
			<c:set var="SUM_QTY_SGBBCD021" value="${SUM_QTY_SGBBCD021 + list.SUM_QTY_SGBBCD021}" />					<!-- 자동건수 합계 -->
			<c:set var="SUM_AMT_SGBBCD021" value="${SUM_AMT_SGBBCD021 + list.SUM_AMT_SGBBCD021}" />					<!-- 자동금액 합계 -->
			<c:set var="SUM_QTY_SGBBCD022" value="${SUM_QTY_SGBBCD022 + list.SUM_QTY_SGBBCD022}" />					<!-- 카드건수 합계 -->
			<c:set var="SUM_AMT_SGBBCD022" value="${SUM_AMT_SGBBCD022 + list.SUM_AMT_SGBBCD022}" />					<!-- 카드금액 합계 -->
			<c:set var="SUM_QTY_ETC1" value="${SUM_QTY_ETC1 + list.SUM_QTY_ETC1}" />						<!-- 교육용,쿠폰건수 합계 -->
			<c:set var="SUM_AMT_ETC1" value="${SUM_AMT_ETC1 + list.SUM_AMT_ETC1}" />						<!-- 교육용,쿠폰금액 합계 -->
			<c:set var="SUM_QTY_ETC2" value="${SUM_QTY_ETC2 + list.SUM_QTY_ETC2}" />						<!-- 결손,재무,휴독,미수건수 합계 -->
			<c:set var="SUM_AMT_ETC2" value="${SUM_AMT_ETC2 + list.SUM_AMT_ETC2}" />						<!-- 결손,재무,휴독,미수금액 합계 -->
			<c:set var="SUM_QTY_ETC3" value="${SUM_QTY_ETC3 + list.SUM_QTY_ETC3}" />						<!-- 기타건수 합계 -->
			<c:set var="SUM_AMT_ETC3" value="${SUM_AMT_ETC3 + list.SUM_AMT_ETC3}" />						<!-- 기타금액 합계 -->
			<c:set var="SUM_AMT" value="${SUM_AMT + list.SUM_AMT_SGBBCD011 + list.SUM_AMT_SGBBCD012 + list.SUM_AMT_SGBBCD013 + list.SUM_AMT_SGBBCD021 + list.SUM_AMT_SGBBCD022 + list.SUM_AMT_ETC1 + list.SUM_AMT_ETC3}" />						<!-- 기타금액 합계 -->
		</c:forEach>
		<tr style="background-color: #ccdbfb">
			<td <c:if test="${gubun eq 'gno'}">colspan="2"</c:if>><strong>합 &nbsp; 계</strong></td>
			<!-- 지로건수 -->
			<td style="text-align: right;"><c:out value="${SUM_QTY_SGBBCD011}" /></td>
			<!-- 지로금액 -->
			<td style="text-align: right;"><fmt:formatNumber value="${SUM_AMT_SGBBCD011}"  type="number" /></td>
			<!-- 방문건수 -->
			<td style="text-align: right;"><c:out value="${SUM_QTY_SGBBCD012}" /></td>
			<!-- 방문금액 -->
			<td style="text-align: right;"><fmt:formatNumber value="${SUM_AMT_SGBBCD012}"  type="number" /></td>
			<!-- 통장건수 -->
			<td style="text-align: right;"><c:out value="${SUM_QTY_SGBBCD013}" /></td>
			<!-- 통장금액 -->
			<td style="text-align: right;"><fmt:formatNumber value="${SUM_AMT_SGBBCD013}"  type="number" /></td>
			<!-- 자동건수 -->
			<td style="text-align: right;"><c:out value="${SUM_QTY_SGBBCD021}" /></td>
			<!-- 자동금액 -->
			<td style="text-align: right;"><fmt:formatNumber value="${SUM_AMT_SGBBCD021}"  type="number" /></td>
			<!-- 카드건수 -->
			<td style="text-align: right;"><c:out value="${SUM_QTY_SGBBCD022}" /></td>
			<!-- 카드금액 -->
			<td style="text-align: right;"><fmt:formatNumber value="${SUM_AMT_SGBBCD022}"  type="number" /></td>
			<!-- 교육용,쿠폰건수 -->
			<td style="text-align: right;"><c:out value="${SUM_QTY_ETC1}" /></td>
			<!-- 교육용,쿠폰금액 -->
			<td style="text-align: right;"><fmt:formatNumber value="${SUM_AMT_ETC1}"  type="number" /></td>
			<!-- 기타건수 -->
			<td style="text-align: right;"><c:out value="${SUM_QTY_ETC3}" /></td>
			<!-- 기타금액 -->
			<td style="text-align: right;"><fmt:formatNumber value="${SUM_AMT_ETC3}"  type="number" /></td>
			<!-- 합계건수 -->
			<td style="text-align: right;"><c:out value="${SUM_QTY_SGBBCD011 + SUM_QTY_SGBBCD012 + SUM_QTY_SGBBCD013 + SUM_QTY_SGBBCD021 + SUM_QTY_SGBBCD022 + SUM_QTY_ETC1 + SUM_QTY_ETC3}" /></td>
			<!-- 합계금액 -->
			<td style="text-align: right;"><fmt:formatNumber value="${SUM_AMT_SGBBCD011 + SUM_AMT_SGBBCD012 + SUM_AMT_SGBBCD013 + SUM_AMT_SGBBCD021 + SUM_AMT_SGBBCD022 + SUM_AMT_ETC1 + SUM_AMT_ETC3}"  type="number" /></td>
			<!-- 결손,재무,휴독,미수건수 -->
			<td style="text-align: right;"><c:out value="${SUM_QTY_ETC2}" /></td>
			<!-- 결손,재무,휴독,미수금액 -->
			<td style="text-align: right;"><fmt:formatNumber value="${SUM_AMT_ETC2}"  type="number" /></td>
		</tr>
		<tr style="background-color: #ccffcc">
			<td <c:if test="${gubun eq 'gno'}">colspan="2"</c:if>><strong>비 &nbsp; 율</strong></td>
			<!-- 지로 -->
			<td style="text-align: right;" colspan="2">
				<c:if test="${SUM_AMT ne '0'}">
					<fmt:parseNumber var="tmp1" value="${SUM_AMT_SGBBCD011}" integerOnly="false"/>
					<fmt:parseNumber var="tmp2" value="${SUM_AMT}" integerOnly="false"/>
					<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
					<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
				</c:if>
			</td>
			<!-- 방문건수 -->
			<td style="text-align: right;" colspan="2">
				<c:if test="${SUM_AMT ne '0'}">
					<fmt:parseNumber var="tmp1" value="${SUM_AMT_SGBBCD012}" integerOnly="false"/>
					<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
					<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
				</c:if>
			</td>
			<!-- 통장건수 -->
			<td style="text-align: right;" colspan="2">
				<c:if test="${SUM_AMT ne '0'}">
					<fmt:parseNumber var="tmp1" value="${SUM_AMT_SGBBCD013}" integerOnly="false"/>
					<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
					<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
				</c:if>
			</td>
			<!-- 자동건수 -->
			<td style="text-align: right;" colspan="2">
				<c:if test="${SUM_AMT ne '0'}">
					<fmt:parseNumber var="tmp1" value="${SUM_AMT_SGBBCD021}" integerOnly="false"/>
					<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
					<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
				</c:if>
			</td>
			<!-- 카드건수 -->
			<td style="text-align: right;" colspan="2">
				<c:if test="${SUM_AMT ne '0'}">
					<fmt:parseNumber var="tmp1" value="${SUM_AMT_SGBBCD022}" integerOnly="false"/>
					<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
					<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
				</c:if>
			</td>
			<!-- 교육용,쿠폰건수 -->
			<td style="text-align: right;" colspan="2">
				<c:if test="${SUM_AMT ne '0'}">
					<fmt:parseNumber var="tmp1" value="${SUM_AMT_ETC1}" integerOnly="false"/>
					<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
					<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
				</c:if>
			</td>
			<!-- 기타건수 -->
			<td style="text-align: right;" colspan="2">
				<c:if test="${SUM_AMT ne '0'}">
					<fmt:parseNumber var="tmp1" value="${SUM_AMT_ETC3}" integerOnly="false"/>
					<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
					<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
				</c:if>
			</td>
			<!-- 합계금액 -->
			<td style="text-align: right;" colspan="2">
				<c:if test="${SUM_AMT ne '0'}">
					<fmt:parseNumber var="tmp1" value="${SUM_AMT}" integerOnly="false"/>
					<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
					<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
				</c:if>
			</td>
			<!-- 결손,재무,휴독,미수건수 -->
			<td style="text-align: right;" colspan="2">&nbsp;</td>
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
