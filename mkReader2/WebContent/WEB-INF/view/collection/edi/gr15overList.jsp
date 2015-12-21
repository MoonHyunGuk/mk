<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript">

	//페이지 이동
	function moveTo(pageNo) {
		
		var frm = document.forms1;

		frm.pageNo.value = pageNo;
		frm.action = "gr15overList.do";
		frm.submit();
		jQuery("#prcssDiv").show();
	}

</script>
<!-- title -->
<div><span class="subTitle">지로 과입금조회</span></div>
<!-- //title -->
<form name="forms1" method="post" action="gr15list.do">
<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />	
	<table class="tb_search" style="width: 1020px">
		<tr>
			<th>지로구분</th>
			<td>
				<select name="type"  style="width: 100px">
					<option <c:if test="${0 eq type}">selected</c:if>>전체</option>
					<option value = "1" <c:if test="${1 eq type}">selected</c:if>>직영지로</option>
			 		<option value = "2" <c:if test="${2 eq type}">selected</c:if>>수납대행</option>
			 		<option value = "3" <c:if test="${3 eq type}">selected</c:if>>바코드수납</option>
			  	</select>
			</td>
			<th>지로번호</th>
			<td>
				<select name="jiroNum"  style="width: 140px">
					<option value = "">전체</option>
						<c:forEach items="${jiroList}" var="list"  varStatus="status">
							<option value="${list.GIRO_NO}"  <c:if test="${list.GIRO_NO eq jiroNum}">selected</c:if>>${list.GIRO_NO}(${list.NAME})</option>
					 	</c:forEach>
			  	</select>
			</td>
			<th>일자별 검색</th>
			<td>
				<input type="text" class="box_80" size="10" name="sdate" value="<c:out value='${sdate}' />" readonly onclick="Calendar(this)">&nbsp;~
				<input type="text" class="box_80" size="10" name="edate" value="<c:out value='${edate}' />" readonly onclick="Calendar(this)">&nbsp;
	   			<a href="javascript:moveTo('1');"><img src="/images/bt_joh.gif" border="0" align="absmiddle"></a>
			</td>
		</tr>
	</table>
</form>
<c:set var="money1" value="0" />
<c:set var="charge1" value="0" />
<c:set var="echemoney1" value="0" />
<c:set var="overmoney1" value="0" />
<!-- list -->
<div style="margin: 0 auto; width: 1020px; padding-top: 15px">
	<table class="tb_list_a_5" style="width: 1020px">
		<tr>
			<th>지로번호</th>
			<th>지국번호</th>
			<th>지국명</th>
			<th>결재원수록내용</th>
			<th>지로입금액</th>
			<th>수수료</th>
			<th>이체금액</th>
			<th>과입금액</th>
			<th>작업일자</th>
		</tr>
		<c:choose>
			<c:when test="${empty resultList}">
				<tr><td colspan="9"  >등록된 정보가 없습니다.</td></tr>
			</c:when>
		<c:otherwise>
		<c:forEach items="${resultList}" var="list" varStatus="status">
			<c:set var="money1" value="${money1 + list.E_MONEY}" />
			<c:set var="charge1" value="${charge1 + list.E_CHARGE}" />
			<c:set var="echemoney1" value="${echemoney1 + list.E_MONEY - list.OVERMONEY}" />
			<c:set var="overmoney1" value="${overmoney1 + list.OVERMONEY}" />
			<tr >
			    <td><c:out value="${list.E_JIRO}" /></td>
				<td><c:out value="${list.E_JCODE}" /></td>
				<td><c:out value="${list.NAME}" /></td>
				<td><c:out value="${list.E_RCODE}" /></td>
				<td style="text-align: right;">
					<c:choose>
					<c:when test="${not empty list.E_MONEY}"><fmt:formatNumber value="${list.E_MONEY}" type="number" /> 원</c:when>
					<c:otherwise>0 원</c:otherwise>
					</c:choose>
				</td>
				<td style="text-align: right;">
					<c:choose>
					<c:when test="${not empty list.E_CHARGE}"><fmt:formatNumber value="${list.E_CHARGE}" type="number" /> 원</c:when>
					<c:otherwise>0 원</c:otherwise>
					</c:choose>
				</td>
				<td style="text-align: right;">
					<c:choose>
					<c:when test="${not empty list.E_MONEY && not empty list.E_CHARGE}"><fmt:formatNumber value="${list.E_MONEY - list.OVERMONEY}" type="number" /> 원</c:when>
					<c:otherwise>0 원</c:otherwise>
					</c:choose>
				</td>
				<td style="text-align: right;">
					<c:choose>
					<c:when test="${not empty list.OVERMONEY}"><fmt:formatNumber value="${list.OVERMONEY}" type="number" /> 원</c:when>
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
			<td colspan="4"><b>총 계</b></td>
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
			<td style="text-align: right;">
				<c:choose>
				<c:when test="${not empty overmoney1}"><fmt:formatNumber value="${overmoney1}" type="number" /> 원</c:when>
				<c:otherwise>0 원</c:otherwise>
				</c:choose>
			</td>
			<td></td>
		</tr>
	</c:otherwise>
	</c:choose>
</table>
</div>
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
