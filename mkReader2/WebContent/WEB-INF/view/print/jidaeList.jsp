<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/js/jquery.number.min.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel='stylesheet' type='text/css' href="/select2/select2.css"/>
<script type="text/javascript" >
//페이지 이동
function moveTo(pageNo) {
	
	var frm = document.getElementById("forms1");
	
	//if(!(cf_checkNull("type", "구분"))){return false;}

	frm.pageNo.value = pageNo;
	frm.action = "/print/print/jidaeList.do";
	frm.submit();
	jQuery("#prcssDiv").show();
}

/**
 * 오즈출력
 */
function fn_ozPrint(type){
	var fm = document.getElementById("forms1");
	
	actUrl = "/print/print/ozJidaeListPrint.do";
	window.open('','ozJidae','width=850, height=700, toolbar=no, menubar=no, location=no, status=no, resizable=1, scrollbar=no');

	fm.target = "ozJidae";
	fm.action = actUrl;
	fm.submit();
	fm.target = "";
}

/**
 * 엑셀저장
 */
function fn_excelDown(){
	var fm = document.getElementById("forms1");
	
	fm.target = "_self";
	fm.action = "/print/print/excelJidaeList.do";
	fm.submit();
}

jQuery(document).ready(function($){
	$("#txt").select2({minimumInputLength: 1});
});
</script>
<div><span class="subTitle">지대/본사입금현황</span></div>
<form name="forms1" id="forms1" method="post" >
<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />
<!-- search conditions -->
<table class="tb_search" style="width: 1020px; float: left;">
	<c:choose>
		<c:when test="${chkAdminMngYn == 'Y'}">
			<colgroup>
				<col width="80px">
				<col width="125px">
				<col width="80px">
				<col width="135px">
				<col width="80px">
				<col width="120px"> 
				<col width="80px">
				<col width="320px">
			</colgroup>
			<tr>
				<th>구 분</th> 
				<td>
					<select name="type" id="type" style="width: 100px;">
						<option value="" <c:if test="${'' eq type}">selected</c:if>>선택</option>
						<option value="수도권1" <c:if test="${'수도권1' eq type}">selected</c:if>>수도권1팀</option>
						<option value="수도권2" <c:if test="${'수도권2' eq type}">selected</c:if>>수도권2팀</option>
						<option value="지방판매" <c:if test="${'지방판매' eq type}">selected</c:if>>지방판매팀</option>
						<option value="관리부" <c:if test="${'관리부' eq type}">selected</c:if>>관리부</option>
					</select>
				</td>
				<th>담당자</th>
				<td>
					<select name="manager" style="width: 110px;">
						<option value="" <c:if test="${'' eq manager}">selected</c:if>>전체</option>
							<c:forEach items="${mngCb}" var="mng"  varStatus="status">
								<option value="${mng.MANAGER}"  <c:if test="${mng.MANAGER eq manager}">selected</c:if>>${mng.MANAGER} 담당</option>
						 	</c:forEach>
				 	    <option value="0" <c:if test="${'0' eq manager}">selected</c:if>>미지정</option>
				  	</select>
				</td>
				<th>월분</th>
				<td>
					<select name="fromYymm" style="width: 90px;">
							<c:forEach items="${yymm}" var="YM"  varStatus="status">
								<option value="${YM.YYMM}"  <c:if test="${YM.YYMM eq fromYymm}">selected</c:if>><c:out value="${fn:substring(YM.YYMM,0,4)}-${fn:substring(YM.YYMM,4,6)}" /></option>
						 	</c:forEach>
			  		</select>
				</td>
				<th>지국명</th>
				<td>
					<select name="txt" id="txt" style="width: 85px; vertical-align: middle;">
						<option value="${printBoseq }"> 전체</option> 
						<c:forEach items="${agencyAllList }" var="list">
							<option value="${list.SERIAL }" <c:if test="${txt eq list.SERIAL}">selected </c:if>>${list.NAME } </option>
						</c:forEach>
					</select>
		   			<a href="#fakeUrl" onclick="moveTo('1');"><img src="/images/bt_joh.gif" style="vertical-align: middle; border: 0;" alt="조회"></a>
			   		<c:if test="${'수도권2' eq type or '지방판매' eq type }">
			   			<a href="#fakeUrl"  onclick="fn_excelDown();"><img src="/images/bt_savexel.gif" style="vertical-align: middle;" alt="엑셀저장"></a>
			   			<a href="#fakeUrl"  onclick="fn_ozPrint();"><img src="/images/bt_pprint.gif" style="vertical-align: middle;" alt="인쇄"></a>
			   		</c:if>
				</td>
			</tr>
		</c:when>
		<c:when test="${chkSellerYn == 'Y' }">
			<colgroup>
				<col width="120px">
				<col width="380px">
				<col width="120px">
				<col width="400px">
			</colgroup>
			<tr>
				<th>월분</th>
				<td>
					<select name="fromYymm" style="width: 100px;">
							<c:forEach items="${yymm}" var="YM"  varStatus="status">
								<option value="${YM.YYMM}"  <c:if test="${YM.YYMM eq fromYymm}">selected</c:if>><c:out value="${fn:substring(YM.YYMM,0,4)}-${fn:substring(YM.YYMM,4,6)}" /></option>
						 	</c:forEach>
			  		</select>
				</td>
				<th>지국명</th>
				<td>
					<select name="txt" id="txt" style="width: 100px; vertical-align: middle;">
						<option value="${printBoseq }"> 전체</option> 
						<c:forEach items="${agencyAllList }" var="list">
							<option value="${list.SERIAL }" <c:if test="${txt eq list.SERIAL}">selected </c:if>>${list.NAME } </option>
						</c:forEach>
					</select>&nbsp;
		   			<a href="#fakeUrl" onclick="moveTo('1');"><img src="/images/bt_joh.gif" style="vertical-align: middle; border: 0;" alt="조회"></a>&nbsp;
		   			<a href="#fakeUrl"  onclick="fn_ozPrint();"><img src="/images/bt_pprint.gif" style="vertical-align: middle;" alt="인쇄"></a>
		   			<a href="#fakeUrl"  onclick="fn_excelDown();"><img src="/images/bt_savexel.gif" style="vertical-align: middle;" alt="엑셀저장"></a>
				</td>
			</tr>
		</c:when>
	</c:choose>
</table>
<!-- //search conditions -->
</form>
<!-- 합계 변수지정start:: -->
<c:set var="MISU" value="0" />					<!-- 미수 합계 -->
<c:set var="CUSTOM" value="0" />			<!-- 조정액 합계 -->
<c:set var="CHARGE" value="0" />				<!-- 판매수수료 합계 -->
<c:set var="GRAN" value="0" />				<!-- 배달장려금 합계 -->
<c:set var="EDU" value="0" />					<!-- 교육용 합계 -->
<c:set var="CARD" value="0" />				<!-- 카드 합계 -->
<c:set var="AUTOBILL" value="0" />			<!-- 자동이체 합계 -->
<c:set var="STU" value="0" />					<!-- 학생배달 합계 -->
<c:set var="NEGLECT" value="0" />			<!-- 소외계층 합계 -->
<c:set var="POST" value="0" />					<!-- 우편요금 합계 -->
<c:set var="OFFICE" value="0" />				<!-- 본사사원 합계 -->
<c:set var="BANK" value="0" />					<!-- 통장 합계 -->
<c:set var="GIRO" value="0" />					<!-- 지로입금 합계 -->
<c:set var="JIDAE" value="0" />					<!-- 지대 합계 -->
<c:set var="DEPOSIT" value="0" />				<!-- 보증금 합계 -->
<c:set var="CMPL" value="0" />				<!-- 완납수당 합계 -->
<c:set var="ECONOMY" value="0" />			<!-- 이코노미 합계 -->
<c:set var="CITY" value="0" />					<!-- 씨티 합계 -->
<!-- 합계 변수지정end:: -->
<!-- list -->
<div class="box_list" style="width: 1020px; overflow-x:scroll;">		
<!-- 수도권 1팀 -->	
<c:if test="${'수도권1' eq type}">
	<div id="jidaeList" style="display:block;  width:1335px;">
		<table class="tb_list_a_5" style="width: 1335px">
			<colgroup>
				<col width="60px">
				<col width="60px">
				<col width="70px">
				<col width="95px">
				<col width="80px">
				<col width="80px">
				<col width="80px">
				<col width="80px">
				<col width="80px">
				<col width="80px">
				<col width="80px">
				<col width="80px">
				<col width="80px">
				<col width="80px">
				<col width="100px">
				<col width="70px">
				<col width="80px">
			</colgroup>
			<tr>
				<th rowspan="2">코드</th>
				<th rowspan="2">지국명</th>
				<th rowspan="2">전월미수</th>
				<th rowspan="2">조정액</th>
				<th colspan="10">본사입금현황</th>
				<th rowspan="2">지대실납입액</th>
				<th rowspan="2">이코노미</th>
				<th rowspan="2">씨티</th>
			</tr>
			<tr>
				<th>판매<br>수수료</th>
				<th>배달<br>장려금</th>
				<th>교육용</th>
				<th>카드</th>
				<th>자동<br>이체</th>
				<th>학생<br>배달</th>
				<th>소외<br>계층</th>
				<th>본사<br>사원</th>
				<th>통장</th>
				<th>지로</th>
			</tr>
			<c:choose>
				<c:when test="${empty resultList}">
					<tr><td colspan="17" >등록된 정보가 없습니다.</td></tr>
				</c:when>
				<c:otherwise>
				<c:forEach items="${resultList}" var="list" varStatus="status">		
					<c:set var="MISU" value="${MISU + list.MISU}" />				<!-- 전월미수 합계 -->
					<c:set var="CUSTOM" value="${CUSTOM + list.CUSTOM}" />				<!-- 조정액 합계 -->
					<c:set var="CHARGE" value="${CHARGE + list.TMP6}" />				<!-- 판매수수료 합계 -->
					<c:set var="GRAN" value="${GRAN + list.ETCGRANT}" />							<!-- 배달장려금 합계 -->
					<c:set var="EDU" value="${EDU + list.EDU}" />									<!-- 교육용 합계 -->
					<c:set var="CARD" value="${CARD + list.CARD}" />							<!-- 카드 합계 -->
					<c:set var="AUTOBILL" value="${AUTOBILL + list.AUTOBILL}" />			<!-- 자동이체 합계 -->
					<c:set var="STU" value="${STU + list.STU}" />									<!-- 학생배달 합계 -->
					<c:set var="NEGLECT" value="${NEGLECT + list.NEGLECT}" />				<!-- 소외계층 합계 -->
					<c:set var="POST" value="${POST + list.POST}" />							<!-- 우편요금 합계 -->
					<c:set var="OFFICE" value="${OFFICE + list.OFFICE}" />						<!-- 본사사원 합계 -->
					<c:set var="BANK" value="${BANK + list.BANK}" />							<!-- 통장 합계 -->
					<c:set var="GIRO" value="${GIRO + list.GIRO}" />								<!-- 지로입금 합계 -->
					<c:set var="JIDAE" value="${JIDAE + list.JIDAE}" />							<!-- 지대 합계 -->
					<c:set var="ECONOMY" value="${ECONOMY + list.ECONOMY}" />		<!-- 이코노미 합계 -->
					<c:set var="CITY" value="${CITY + list.CITY}" />								<!-- 씨티 합계 -->
					<tr style="background-color: <c:if test="${'1' eq list.CHK}"> #eeeebb </c:if><c:if test="${'1' ne list.CHK}"> #ffffff  </c:if>" >
					    <td><c:out value="${list.BOSEQ}" /></td>
						<td style="text-align: left"><c:out value="${list.NAME}" /></td>
						<td style="text-align: right;"><c:choose><c:when test="${not empty list.MISU}"><fmt:formatNumber value="${list.MISU}" type="number" /></c:when></c:choose></td>
						<td style="text-align: right;"><c:choose><c:when test="${not empty list.CUSTOM}"><fmt:formatNumber value="${list.CUSTOM}" type="number" /></c:when></c:choose></td>
						<td style="text-align: right;"><c:choose><c:when test="${not empty list.TMP6}"><fmt:formatNumber value="${list.TMP6}" type="number" /></c:when></c:choose></td>
						<td style="text-align: right;"><c:choose><c:when test="${not empty list.ETCGRANT}"><fmt:formatNumber value="${list.ETCGRANT}" type="number" /></c:when></c:choose></td>
						<td style="text-align: right;"><c:choose><c:when test="${not empty list.EDU}"><fmt:formatNumber value="${list.EDU}" type="number" /></c:when></c:choose></td>
						<td style="text-align: right;"><c:choose><c:when test="${not empty list.CARD}"><fmt:formatNumber value="${list.CARD}" type="number" /></c:when></c:choose></td>
						<td style="text-align: right;"><c:choose><c:when test="${not empty list.AUTOBILL}"><fmt:formatNumber value="${list.AUTOBILL}" type="number" /></c:when>	</c:choose></td>
						<td style="text-align: right;"><c:choose><c:when test="${not empty list.STU}"><fmt:formatNumber value="${list.STU}" type="number" /></c:when></c:choose></td>
						<td style="text-align: right;"><c:choose><c:when test="${not empty list.NEGLECT}"><fmt:formatNumber value="${list.NEGLECT}" type="number" /></c:when></c:choose></td>
						<td style="text-align: right;"><c:choose><c:when test="${not empty list.OFFICE}"><fmt:formatNumber value="${list.OFFICE}" type="number" /></c:when></c:choose></td>
						<td style="text-align: right;"><c:choose><c:when test="${not empty list.BANK}"><fmt:formatNumber value="${list.BANK}" type="number" /></c:when></c:choose></td>
						<td style="text-align: right;"><c:choose><c:when test="${not empty list.GIRO}"><fmt:formatNumber value="${list.GIRO}" type="number" /></c:when></c:choose></td>
						<td style="text-align: right; color: #0066cc; font-weight: bold"><c:choose><c:when test="${not empty list.JIDAE}"><fmt:formatNumber value="${list.JIDAE}" type="number" /></c:when></c:choose></td>
						<td style="text-align: right;"><c:choose><c:when test="${not empty list.ECONOMY}"><fmt:formatNumber value="${list.ECONOMY}" type="number" /></c:when></c:choose></td>
						<td style="text-align: right;"><c:choose><c:when test="${not empty list.CITY}"><fmt:formatNumber value="${list.CITY}" type="number" /></c:when></c:choose></td>
					</tr>
				</c:forEach>
				<tr>
				    <td colspan="2" style="background-color: #ccdbfb"><strong>합 &nbsp; 계</strong></td>
				    <td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty MISU}"><fmt:formatNumber value="${MISU}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty CUSTOM}"><fmt:formatNumber value="${CUSTOM}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty CHARGE}"><fmt:formatNumber value="${CHARGE}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty GRAN}"><fmt:formatNumber value="${GRAN}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty EDU}"><fmt:formatNumber value="${EDU}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty CARD}"><fmt:formatNumber value="${CARD}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty AUTOBILL}"><fmt:formatNumber value="${AUTOBILL}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty STU}"><fmt:formatNumber value="${STU}" type="number" /></c:when>	</c:choose></td>
					<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty NEGLECT}"><fmt:formatNumber value="${NEGLECT}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty OFFICE}"><fmt:formatNumber value="${OFFICE}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty BANK}"><fmt:formatNumber value="${BANK}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty GIRO}"><fmt:formatNumber value="${GIRO}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right; background-color: #ccdbfb; color: #0066cc; font-weight: bold;"><c:choose><c:when test="${not empty JIDAE}"><fmt:formatNumber value="${JIDAE}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty ECONOMY}"><fmt:formatNumber value="${ECONOMY}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty CITY}"><fmt:formatNumber value="${CITY}" type="number" /></c:when></c:choose></td>
				</tr>
				</c:otherwise>
			</c:choose>
		</table>
	</div>
</c:if>
<!-- //수도권 1팀 -->
<!-- 수도권 2팀 -->
<c:if test="${'수도권2' eq type or '지방판매' eq type }">
	<div id="jidaeList" style="display:block;  width:1255px; ">
		<table class="tb_list_a_5" style="width: 1255px">
			<colgroup>
				<col width="60px">
				<col width="60px">
				<col width="70px">
				<col width="95px">
				<col width="80px">
				<col width="80px">
				<col width="80px">
				<col width="80px">
				<col width="80px">
				<col width="80px">
				<col width="80px">
				<col width="80px">
				<col width="80px">
				<col width="100px">
				<col width="70px">
				<col width="80px">
			</colgroup>
			<tr>
				<th rowspan="2">코드</th>
				<th rowspan="2">지국명</th>
				<th rowspan="2">전월미수</th>
				<th rowspan="2">조정액</th>
				<th colspan="9">본사입금현황</th>
				<th rowspan="2">지대실납입액</th>
				<th rowspan="2">완납수당</th>
				<th rowspan="2">보증금</th>
			</tr>
			<tr>
				<th style="letter-spacing: -1px">판매장려금</th>
				<th>교육용</th>
				<th>카드</th>
				<th>자동<br>이체</th>
				<th>학생<br>배달</th>
				<th>소외<br>계층</th>
				<th>우편<br>요금</th>
				<th>본사<br>사원</th>
				<th>기타</th>
			</tr>
			<c:choose>
				<c:when test="${empty resultList}">
					<tr><td colspan="16"  >등록된 정보가 없습니다.</td></tr>
				</c:when>
			<c:otherwise>					
			<c:forEach items="${resultList}" var="list" varStatus="status">			
				<c:set var="MISU" value="${MISU + list.MISU}" />						<!-- 미수 합계 -->
				<c:set var="CUSTOM" value="${CUSTOM + list.CUSTOM}" />			<!-- 조정액 합계 -->
				<c:set var="SUMCHARGE" value="${list.BUSUGRANT+list.STUGRANT+list.ETCGRANT+list.TMP6 }" />
				<c:set var="CHARGE" value="${CHARGE + SUMCHARGE}" />			<!-- 판매수수료 합계 -->
				<c:set var="EDU" value="${EDU + list.EDU}" />								<!-- 교육용 합계 -->
				<c:set var="CARD" value="${CARD + list.CARD}" />						<!-- 카드 합계 -->
				<c:set var="AUTOBILL" value="${AUTOBILL + list.AUTOBILL}" />		<!-- 자동이체 합계 -->
				<c:set var="STU" value="${STU + list.STU}" />								<!-- 학생배달 합계 -->
				<c:set var="NEGLECT" value="${NEGLECT + list.NEGLECT}" />			<!-- 소외계층 합계 -->
				<c:set var="POST" value="${POST + list.POST}" />						<!-- 우편요금 합계 -->
				<c:set var="OFFICE" value="${OFFICE + list.OFFICE}" />					<!-- 본사사원 합계 -->
				<c:set var="ETC" value="${ETC + list.ETC}" />						<!-- 기타 합계 -->
				<c:set var="JIDAE" value="${JIDAE + list.JIDAE}" />						<!-- 지대 합계 -->
				<c:set var="DEPOSIT" value="${DEPOSIT + list.DEPOSIT}" />			<!-- 보증금 합계 -->
				<c:set var="CMPL" value="${CMPL + list.CMPL}" />						<!-- 완납수당 합계 -->
			
				<tr style="background-color:<c:if test="${'1' eq list.CHK}">#eeeebb</c:if> <c:if test="${'1' ne list.CHK}">#ffffff </c:if>" >
				    <td><c:out value="${list.BOSEQ}" /></td>
					<td style="text-align: left"><c:out value="${list.NAME}" /></td>
					<td style="text-align: right;"><c:choose><c:when test="${not empty list.MISU}"><fmt:formatNumber value="${list.MISU}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right;"><c:choose><c:when test="${not empty list.CUSTOM}"><fmt:formatNumber value="${list.CUSTOM}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right;"><c:choose><c:when test="${not empty SUMCHARGE}"><fmt:formatNumber value="${SUMCHARGE}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right;"><c:choose><c:when test="${not empty list.EDU}"><fmt:formatNumber value="${list.EDU}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right;"><c:choose><c:when test="${not empty list.CARD}"><fmt:formatNumber value="${list.CARD}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right;"><c:choose><c:when test="${not empty list.AUTOBILL}"><fmt:formatNumber value="${list.AUTOBILL}" type="number" /></c:when>	</c:choose></td>
					<td style="text-align: right;"><c:choose><c:when test="${not empty list.STU}"><fmt:formatNumber value="${list.STU}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right;"><c:choose><c:when test="${not empty list.NEGLECT}"><fmt:formatNumber value="${list.NEGLECT}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right;"><c:choose><c:when test="${not empty list.POST}"><fmt:formatNumber value="${list.POST}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right;"><c:choose><c:when test="${not empty list.OFFICE}"><fmt:formatNumber value="${list.OFFICE}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right;"><c:choose><c:when test="${not empty list.ETC}"><fmt:formatNumber value="${list.ETC}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right; color: #0066cc; font-weight: bold;"><c:choose><c:when test="${not empty list.JIDAE}"><fmt:formatNumber value="${list.JIDAE}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right;"><c:choose><c:when test="${not empty list.CMPL}"><fmt:formatNumber value="${list.CMPL}" type="number" /></c:when></c:choose></td>						
					<td style="text-align: right;"><c:choose><c:when test="${not empty list.DEPOSIT}"><fmt:formatNumber value="${list.DEPOSIT}" type="number" /></c:when></c:choose></td>
				</tr>
				</c:forEach>
					<tr bgcolor="ccdbfb">
					    <td colspan="2"><strong>합 &nbsp; 계</strong></td>						
						<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty MISU}"><fmt:formatNumber value="${MISU}" type="number" /></c:when></c:choose></td>
						<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty CUSTOM}"><fmt:formatNumber value="${CUSTOM}" type="number" /></c:when></c:choose></td>
						<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty CHARGE}"><fmt:formatNumber value="${CHARGE}" type="number" /></c:when></c:choose></td>
						<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty EDU}"><fmt:formatNumber value="${EDU}" type="number" /></c:when></c:choose></td>
						<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty CARD}"><fmt:formatNumber value="${CARD}" type="number" /></c:when></c:choose></td>
						<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty AUTOBILL}"><fmt:formatNumber value="${AUTOBILL}" type="number" /></c:when></c:choose></td>
						<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty STU}"><fmt:formatNumber value="${STU}" type="number" /></c:when>	</c:choose></td>
						<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty NEGLECT}"><fmt:formatNumber value="${NEGLECT}" type="number" /></c:when></c:choose></td>
						<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty POST}"><fmt:formatNumber value="${POST}" type="number" /></c:when></c:choose></td>
						<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty OFFICE}"><fmt:formatNumber value="${OFFICE}" type="number" /></c:when></c:choose></td>
						<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty ETC}"><fmt:formatNumber value="${ETC}" type="number" /></c:when></c:choose></td>
						<td style="text-align: right; background-color: #ccdbfb; color: #0066cc; font-weight: bold;"><c:choose>	<c:when test="${not empty JIDAE}"><fmt:formatNumber value="${JIDAE}" type="number" /></c:when></c:choose></td>
						<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty CMPL}"><fmt:formatNumber value="${CMPL}" type="number" /></c:when>	</c:choose></td>						
						<td style="text-align: right; background-color: #ccdbfb"><c:choose><c:when test="${not empty DEPOSIT}"><fmt:formatNumber value="${DEPOSIT}" type="number" /></c:when></c:choose></td>
					</tr>
			</c:otherwise>
			</c:choose>
		</table>
	</div>
</c:if>
<!-- //수도권 2팀 -->
</div>
<div style="padding-top: 5px; width: 1020px"><div class="box_gray" style="padding: 5px 0;"><b>※ 노란색 음영표시 : 보증금 대체 지국<br></b></div></div>
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
