<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.util.CommonUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<!-- title -->
<div><span class="subTitle">학생청구결과 처리결과</span></div>
<!-- //title -->
<div class="box_gray" style="font-weight: bold; padding: 10px 0; width: 1020px;">CMS file : <font class="b03"><c:out value="${filename}" /></font> 처리 결과 명세</div>
<div style="padding: 5px 0 10px 0;">
	<table class="tb_search" style="width: 1020px;">
		<col width="260px">
		<col width="760px">
		<tr >
			<th>출금 일자</th>
			<td><c:out value="${out_date}" /></td>
		</tr>
		<tr >
			<th>총 출금의뢰 건</th>
			<td><fmt:formatNumber value="${fn:trim(noErrnum1+Errnum1)}" type="number" /> 건</td>
		</tr>
		<tr >
			<th>출금이체 성공건</th>
			<td><fmt:formatNumber value="${fn:trim(noErrnum1)}" type="number" /> 건</td>
		</tr>
		<tr >
			<th>출금이체 에러건</th>
			<td><fmt:formatNumber value="${fn:trim(Errnum1)}" type="number" /> 건</td>
		</tr>
	</table>
</div>			
<form name="form1">
<div style="width: 1020px; margin: 0 auto; padding-bottom: 5px;">
	<select name="jikuk" size="1" onchange="window.open('view_stu.do?filename=${filename}&cmsdate=${out_date}&pageNo=${pageNo}&numid=${numid}&jikuk='+document.form1.jikuk.value,'_self');">
		<option value=''>전체</option>
		<c:if test="${not empty jikukList}">
			<c:forEach items="${jikukList}" var="list" varStatus="status">
				<option value="${list.JIKUK}" <c:if test="${list.JIKUK eq jikuk}">selected</c:if>><c:out value="${list.JIKUK_NAME}" /></option>
			</c:forEach>
		</c:if>
	</select>
</div>
</form>
 <c:set var="totalmoney" value="0" />
<table class="tb_list_a_5" style="width: 1020px">
	<col width="125px">
	<col width="170px">
	<col width="325px">
	<col width="145px">
	<col width="160px">
	<col width="105px">
	<tr>
	  	<td>일련번호</td>
	  	<td>출금의뢰금액</td>
	  	<td>출금결과</td>
	  	<td>지국명</td>
	  	<td>납부자번호</td>
	  	<td>월분</td>
	 </tr>
	<c:choose>
		<c:when test="${empty resultList}">
			<tr><td colspan="6">등록된 정보가 없습니다.</td></tr>
		</c:when>
		<c:otherwise>					
			<c:forEach items="${resultList}" var="list" varStatus="status">
				<c:set var="totalmoney" value="${totalmoney + list.CMSMONEY}" />
	               <tr>
	                   <td><a href="javascript:popMemberViewStu('${list.READNO}');"><c:out value="${list.SERIALNO}" /></a></td>
	                   <td align="right"><fmt:formatNumber value="${list.CMSMONEY}" type="number" /></td>
				    <td><c:out value="${list.CMSRESULTMSG}" /></td>
					<td><c:out value="${list.JIKUK_NAME}" /></td>
					<td><c:out value="${list.CODENUM}" /></td>
					<td><c:out value="${list.SUBSMONTH}" /></td>
				</tr>
			</c:forEach>
		</c:otherwise>
	</c:choose>
</table>
<div style="padding-top: 5px" >			
	<table class="tb_search" style="width: 1020px;">
		<col width="50%">
		<col width="50%">
		<tr>
			<th>
				<c:choose>
				<c:when test="${empty jikuk}">전체 금액</c:when>
				<c:otherwise>${jikuk} 금액</c:otherwise>
				</c:choose>
			</th>
			<td>금액 : <fmt:formatNumber value="${totalmoney}"  type="number" /></td>
		</tr>
</table>
<div style="padding: 10px 0 20px 0; text-align: right; width: 1020px; margin: 0 auto;"><a href="#" onclick="history.go(-1);"><img src="/images/bt_back.gif" border="0" align="absmiddle"></a></div>

