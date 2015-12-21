<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript" src="/js/common.js"></script>
<table style="width: 1335px;" border="0" >
	<tr><td colspan="21" style="text-align: center; font-weight: bold; font-size: 16px">지대/본사입금현황</td></tr>
</table>
<br/>
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
<!-- 수도권 1팀 -->	
<c:if test="${'수도권1' eq type}">
	<table style="width: 1335px;" border="1" >
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
				<c:set var="CHARGE" value="${CHARGE + list.CHARGE}" />				<!-- 판매수수료 합계 -->
				<c:set var="GRAN" value="${GRAN + list.GRAN}" />							<!-- 배달장려금 합계 -->
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
				<c:set var="REALJIDAE" value="${REALJIDAE + list.J_PAYAMT}" />						<!-- 지대 합계 -->
				
				<tr style="background-color: <c:if test="${'1' eq list.CHK}"> #eeeebb </c:if><c:if test="${'1' ne list.CHK}"> #ffffff  </c:if>" >
				    <td><c:out value="${list.BOSEQ}" /></td>
					<td style="text-align: left"><c:out value="${list.NAME}" /></td>
					<td style="text-align: right;"><c:choose><c:when test="${not empty list.MISU}"><fmt:formatNumber value="${list.MISU}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right;"><c:choose><c:when test="${not empty list.CUSTOM}"><fmt:formatNumber value="${list.CUSTOM}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right;"><c:choose><c:when test="${not empty list.CHARGE}"><fmt:formatNumber value="${list.CHARGE}" type="number" /></c:when></c:choose></td>
					<td style="text-align: right;"><c:choose><c:when test="${not empty list.GRAN}"><fmt:formatNumber value="${list.GRAN}" type="number" /></c:when></c:choose></td>
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
</c:if>
<!-- //수도권 1팀 -->
<!-- 수도권 2팀 -->
<c:if test="${'수도권2' eq type or '지방판매' eq type }">
	<table style="width: 1255px;" border="1" >
		<tr>
			<th rowspan="2">코드</th>
			<th rowspan="2">지국명</th>
			<th rowspan="2">전월미수</th>
			<th rowspan="2">조정액</th>
			<th colspan="13">본사입금현황</th>
			<th rowspan="2">지대납입액</th>
			<th rowspan="2">완납수당</th>
			<th rowspan="2">지대실납입액</th>
			<th rowspan="2">보증금</th>
		</tr>
		<tr>
			<th>부수유지장려금</th>
			<th>학생장려금</th>
			<th>기타장려금<br/>/판매수수료</th>
			<th>판매VAT</th>
			<th>카드</th>
			<th>교육용</th>
			<th>자동<br>이체</th>
			<th>학생<br>배달</th>
			<th>소외<br>계층</th>
			<th>우편<br>요금</th>
			<th>본사<br>사원</th>
			<th>기타</th>
			<th>소계</th>
		</tr>
		<c:choose>
			<c:when test="${empty resultList}">
				<tr><td colspan="16"  >등록된 정보가 없습니다.</td></tr>
			</c:when>
		<c:otherwise>					
		<c:forEach items="${resultList}" var="list" varStatus="status">			
			<c:set var="MISU" value="${MISU + list.MISU}" />						<!-- 미수 합계 -->
			<c:set var="CUSTOM" value="${CUSTOM + list.CUSTOM}" />			<!-- 조정액 합계 -->
			<c:set var="BUSUGRANT" value="${BUSUGRANT + list.BUSUGRANT}" />			<!-- 부수유지장려금 합계 -->
			<c:set var="STUGRANT" value="${STUGRANT + list.STUGRANT}" />			<!-- 학생장려금 합계 -->
			<c:set var="ETCGRANT" value="${ETCGRANT + list.ETCGRANT}" />			<!-- 기타 합계 -->
			<c:set var="TMP6" value="${TMP6 + list.TMP6}" />							<!--판매수수료 합계 -->
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
			<c:set var="SUBTOTAL" value="${SUBTOTAL + list.SUBTOTAL}" />						<!-- 완납수당 합계 -->
			<c:set var="REALJIDAE" value="${REALJIDAE + list.J_PAYAMT}" />						<!-- 지대 합계 -->
		
			<tr style="background-color:<c:if test="${'1' eq list.CHK}">#eeeebb</c:if> <c:if test="${'1' ne list.CHK}">#ffffff </c:if>" >
			    <td><c:out value="${list.BOSEQ}" /></td>
				<td style="text-align: left">${list.NAME}</td>
				<td style="text-align: right;"><fmt:formatNumber value="${list.MISU}" type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${list.CUSTOM}" type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${list.BUSUGRANT}" type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${list.STUGRANT}" type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${list.ETCGRANT}" type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${list.TMP6}" type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${list.EDU}" type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${list.CARD}" type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${list.AUTOBILL}" type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${list.STU}" type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${list.NEGLECT}" type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${list.POST}" type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${list.OFFICE}" type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${list.ETC}" type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${list.SUBTOTAL}" type="number" /></td>
				<td style="text-align: right; color: #0066cc; font-weight: bold;"><fmt:formatNumber value="${list.JIDAE}" type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${list.CMPL}" type="number" /></td>						
				<td style="text-align: right; color: #0066cc; font-weight: bold;"><fmt:formatNumber value="${list.J_PAYAMT}" type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${list.DEPOSIT}" type="number" /></td>
			</tr>
			</c:forEach>
				<tr bgcolor="ccdbfb">
				    <td colspan="2"><strong>합 &nbsp; 계</strong></td>						
					<td style="text-align: right; background-color: #ccdbfb"><fmt:formatNumber value="${MISU}" type="number" /></td>
					<td style="text-align: right; background-color: #ccdbfb"><fmt:formatNumber value="${CUSTOM}" type="number" /></td>
					<td style="text-align: right; background-color: #ccdbfb"><fmt:formatNumber value="${BUSUGRANT}" type="number" /></td>
					<td style="text-align: right; background-color: #ccdbfb"><fmt:formatNumber value="${STUGRANT}" type="number" /></td>
					<td style="text-align: right; background-color: #ccdbfb"><fmt:formatNumber value="${ETCGRANT}" type="number" /></td>
					<td style="text-align: right; background-color: #ccdbfb"><fmt:formatNumber value="${TMP6}" type="number" /></td>
					<td style="text-align: right; background-color: #ccdbfb"><fmt:formatNumber value="${EDU}" type="number" /></td>
					<td style="text-align: right; background-color: #ccdbfb"><fmt:formatNumber value="${CARD}" type="number" /></td>
					<td style="text-align: right; background-color: #ccdbfb"><fmt:formatNumber value="${AUTOBILL}" type="number" /></td>
					<td style="text-align: right; background-color: #ccdbfb"><fmt:formatNumber value="${STU}" type="number" /></td>
					<td style="text-align: right; background-color: #ccdbfb"><fmt:formatNumber value="${NEGLECT}" type="number" /></td>
					<td style="text-align: right; background-color: #ccdbfb"><fmt:formatNumber value="${POST}" type="number" /></td>
					<td style="text-align: right; background-color: #ccdbfb"><fmt:formatNumber value="${OFFICE}" type="number" /></td>
					<td style="text-align: right; background-color: #ccdbfb"><fmt:formatNumber value="${ETC}" type="number" /></td>
					<td style="text-align: right; background-color: #ccdbfb"><fmt:formatNumber value="${SUBTOTAL}" type="number" /></td>
					<td style="text-align: right; background-color: #ccdbfb; color: #0066cc; font-weight: bold;"><fmt:formatNumber value="${JIDAE}" type="number" /></td>
					<td style="text-align: right; background-color: #ccdbfb"><fmt:formatNumber value="${CMPL}" type="number" /></td>						
					<td style="text-align: right; background-color: #ccdbfb; color: #0066cc; font-weight: bold;"><fmt:formatNumber value="${REALJIDAE}" type="number" /></td>
					<td style="text-align: right; background-color: #ccdbfb"><fmt:formatNumber value="${DEPOSIT}" type="number" /></td>
				</tr>
		</c:otherwise>
		</c:choose>
	</table>
</c:if>
<!-- //수도권 2팀 -->

