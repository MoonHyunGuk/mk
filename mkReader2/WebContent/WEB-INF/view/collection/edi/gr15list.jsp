<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript">
	function runforms1() {
		var frm = document.forms1;

		frm.action="gr15list_excel.do"
		frm.submit();
		return;
	}
	//페이지 이동
	function moveTo(pageNo) {
		var frm = document.forms1;
		
		frm.pageNo.value = pageNo;
		frm.action = "gr15list.do";
		frm.submit();
		jQuery("#prcssDiv").show();
	}
</script>
<!-- title -->
<div><span class="subTitle">자료조회</span></div>
<!-- //title -->
<form name="forms1" method="post">
	<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />	
<!-- search conditions -->	
<div style="width: 1020px; margin: 0 auto;">
	<table class="tb_search" style="width: 1020px">
		<colgroup>
			<col width="110px">
			<col width="120px">
			<col width="110px">
			<col width="160px">
			<col width="110px">
			<col width="410px">
		</colgroup>
		<tr>
			<th>지로구분</th>
			<td>
				<select name="type" id="type">
					<option <c:if test="${0 eq type}">selected</c:if>>전체</option>
					<option value = "1" <c:if test="${1 eq type}">selected</c:if>>직영지로</option>
			 		<option value = "2" <c:if test="${2 eq type}">selected</c:if>>수납대행</option>
			 		<option value = "3" <c:if test="${3 eq type}">selected</c:if>>바코드수납</option>
			  	</select>
			</td>
			<th>지로번호</th>
			<td>
				<select name="jiroNum" id="jiroNum" style="width: 145px">
					<option value = "">전체</option>
						<c:forEach items="${jiroList}" var="list"  varStatus="status">
							<option value="${list.GIRO_NO}"  <c:if test="${list.GIRO_NO eq jiroNum}">selected</c:if>>${list.GIRO_NO}(${list.NAME})</option>
					 	</c:forEach>
			  	</select>
			</td>
			<th>일자별 검색</th>
			<td>
				<input type="text" name="sdate" style="width: 85px; vertical-align: middle;" value="<c:out value='${sdate}' />" readonly="readonly" onclick="Calendar(this)">&nbsp;~
				<input type="text" name="edate" style="width: 85px; vertical-align: middle;" value="<c:out value='${edate}' />" readonly="readonly" onclick="Calendar(this)">&nbsp;
				<a href="#fakeUrl" onclick="moveTo('1');"><img src="/images/bt_joh.gif" style="vertical-align: middle; border: 0;" alt="조회" /></a>&nbsp;
	   			<a href="#fakeUrl" onclick="runforms1();"><img src="/images/bt_exel.gif" style="vertical-align: middle; border: 0;" alt="엑셀출력" /></a>&nbsp;
			</td>
		</tr>
	</table>
</div>
<!-- //search conditions -->
</form>
<c:set var="count1" value="0" />
<c:set var="money1" value="0" />
<c:set var="charge1" value="0" />
<c:set var="echemoney1" value="0" />
<!-- list -->
<div style="width: 1020px; padding-top: 15px; margin: 0 auto;">
	<table class="tb_list_a_5" style="width: 1020px">
		<colgroup>
			<col width="120px">
			<col width="125px">
			<col width="105px">
			<col width="85px">
			<col width="160px">
			<col width="130px">
			<col width="160px">
			<col width="135px">
		</colgroup>
		<tr>
			<th>지로번호</th>
			<th>지국번호</th>
			<th>지국명</th>
			<th>건수</th>
			<th>지로입금액</th>
			<th>수수료</th>
			<th>이체금액</th>
			<th>작업일자</th>
		</tr>
			<c:choose>
				<c:when test="${empty resultList}">
					<tr><td colspan="8" >등록된 정보가 없습니다.</td></tr>
				</c:when>
			<c:otherwise>
			<c:forEach items="${resultList}" var="list" varStatus="status">
				<c:set var="count1" value="${count1 + list.COUNT}" />
				<c:set var="money1" value="${money1 + list.MONEY}" />
				<c:set var="charge1" value="${charge1 + list.CHARGE}" />
				<c:set var="echemoney1" value="${echemoney1 + list.MONEY - list.CHARGE}" />
				<tr>
				    <td><c:out value="${list.E_JIRO}" /></td>
					<td><c:out value="${list.E_JCODE}" /></td>
					<td><c:out value="${list.NAME}" /></td>
					<td>
						<c:choose>
							<c:when test="${not empty list.COUNT}"><fmt:formatNumber value="${list.COUNT}" type="number" /></c:when>
							<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
					<td style="text-align: right;">
						<c:choose>
							<c:when test="${not empty list.MONEY}"><fmt:formatNumber value="${list.MONEY}" type="number" /> 원</c:when>
							<c:otherwise>0 원</c:otherwise>
						</c:choose>
					</td>
					<td style="text-align: right;">
						<c:choose>
							<c:when test="${not empty list.CHARGE}"><fmt:formatNumber value="${list.CHARGE}" type="number" /> 원</c:when>
							<c:otherwise>0 원</c:otherwise>
						</c:choose>
					</td>
					<td style="text-align: right;">
						<c:choose>
							<c:when test="${not empty list.MONEY && not empty list.CHARGE}"><fmt:formatNumber value="${list.MONEY - list.CHARGE}" type="number" /> 원</c:when>
							<c:otherwise>0 원</c:otherwise>
						</c:choose>
					</td>
					<td>
						<c:choose>
							<c:when test="${not empty list.E_EDATE and fn:length(list.E_EDATE) >= 8}">
								<c:out value="${fn:substring(list.E_EDATE,0,4)}-${fn:substring(list.E_EDATE,4,6)}-${fn:substring(list.E_EDATE,6,8)}" />
							</c:when>
							<c:otherwise>
								<c:out value="${list.E_EDATE}" />
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
			</c:forEach>
			<tr>
			    <td></td>
				<td></td>
				<td>정상 계</td>
				<td>
					<c:choose>
					<c:when test="${not empty count1}"><fmt:formatNumber value="${count1}" type="number" /></c:when>
					<c:otherwise>0</c:otherwise>
					</c:choose>
				</td>
				<td style="text-align: right;">
					<c:choose>
					<c:when test="${not empty money1}"><fmt:formatNumber value="${money1}" type="number" /> 원</c:when>
					<c:otherwise>0 원</c:otherwise>
					</c:choose>
				</td>
				<td style="text-align: right;">
					<c:choose>
					<c:when test="${not empty charge1}"><fmt:formatNumber value="${charge1}" type="number" /> 원</c:when>
					<c:otherwise>0 원</c:otherwise>
					</c:choose>
				</td>
				<td style="text-align: right;">
					<c:choose>
					<c:when test="${not empty echemoney1}"><fmt:formatNumber value="${echemoney1}" type="number" /> 원</c:when>
					<c:otherwise>0 원</c:otherwise>
					</c:choose>
				</td>
				<td></td>
			</tr>
			<tr>
			    <td></td>
				<td></td>
				<td>오류 계</td>
				<td>
					<c:choose>
					<c:when test="${not empty errcount}"><fmt:formatNumber value="${errcount}" type="number" /></c:when>
					<c:otherwise>0</c:otherwise>
					</c:choose>
				</td>
				<td style="text-align: right;">
					<c:choose>
					<c:when test="${not empty summoney}"><fmt:formatNumber value="${summoney}" type="number" /> 원</c:when>
					<c:otherwise>0 원</c:otherwise>
					</c:choose>
				</td>
				<td style="text-align: right;">
					<c:choose>
					<c:when test="${not empty sumcharge}"><fmt:formatNumber value="${sumcharge}" type="number" /> 원</c:when>
					<c:otherwise>0 원</c:otherwise>
					</c:choose>
				</td>
				<td style="text-align: right;">
					<c:choose>
					<c:when test="${not empty summ}"><fmt:formatNumber value="${summ}" type="number" /> 원</c:when>
					<c:otherwise>0 원</c:otherwise>
					</c:choose>
				</td>
				<td></td>
			</tr>
			<c:set var="count1" value="${count1 + errcount}" />
			<c:set var="money1" value="${money1 + summoney}" />
			<c:set var="charge1" value="${charge1 + sumcharge}" />
			<c:set var="echemoney1" value="${echemoney1 + summ}" />
			<tr>
			    <td></td>
				<td></td>
				<td>총 계</td>
				<td>
					<c:choose>
					<c:when test="${not empty count1}"><fmt:formatNumber value="${count1}" type="number" /></c:when>
					<c:otherwise>0</c:otherwise>
					</c:choose>
				</td>
				<td style="text-align: right;">
					<c:choose>
					<c:when test="${not empty money1}"><fmt:formatNumber value="${money1}" type="number" /> 원</c:when>
					<c:otherwise>0 원</c:otherwise>
					</c:choose>
				</td>
				<td style="text-align: right;">
					<c:choose>
					<c:when test="${not empty charge1}"><fmt:formatNumber value="${charge1}" type="number" /> 원</c:when>
					<c:otherwise>0 원</c:otherwise>
					</c:choose>
				</td>
				<td style="text-align: right;">
					<c:choose>
					<c:when test="${not empty echemoney1}"><fmt:formatNumber value="${echemoney1}" type="number" /> 원</c:when>
					<c:otherwise>0 원</c:otherwise>
					</c:choose>
				</td>
				<td></td>
			</tr>
		</c:otherwise>
		</c:choose>
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