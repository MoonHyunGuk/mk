<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.util.CommonUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<!-- title -->
<div><span class="subTitle">계좌확인내역 처리결과(일반)</span></div>
<!-- //title -->
<div class="box_gray" style="font-weight: bold; padding: 10px 0; width: 1020px;">CMS file : <font class="b03"><c:out value="${filename}" /></font> 처리 결과 명세</div>
<div style="padding: 5px 0 10px 0;">
	<table class="tb_search" style="width: 1020px;">
		<col width="260px">
		<col width="775px">
		<tr>
		 	<th>신청접수 일자</th>
			<td><c:out value="${cmsdate}" /></td>
		 </tr>
		 <tr>
		 	<th>총 등록의뢰 건</th>
			<td><fmt:formatNumber value="${fn:trim(totals)}" type="number" /> 건</td>
		 </tr>
		 <tr>
		 	<th>신규 등록</th>
			<td><fmt:formatNumber value="${fn:trim(noErrnum1)}" type="number" /> 건</td>
		 </tr>
		 <tr>
		 	<th>신규 등록 에러</th>
			<td><fmt:formatNumber value="${fn:trim(Errnum1)}" type="number" /> 건</td>
		 </tr>
		  <tr>
		 	<th>해지 등록</th>
			<td><fmt:formatNumber value="${fn:trim(noErrnum2)}" type="number" /> 건</td>
		 </tr>
		  <tr>
		 	<th>해지 등록 에러</th>
			<td><fmt:formatNumber value="${fn:trim(Errnum2)}" type="number" /> 건</td>
		 </tr>
	</table>
</div>		
<table class="tb_list_a_5" style="width: 1020px;">
	<col width="110px">
	<col width="110px">
	<col width="100px">
	<col width="130px">
	<col width="200px">
	<col width="270px">
	<tr>
	  	<td>일련번호</td>
	  	<td>신청일</td>
	  	<td>신청구분</td>
	  	<td>지국명</td>
	  	<td>납부자번호<br>성명</td>
	  	<td>불능코드</td>
	 </tr>
	<c:choose>
		<c:when test="${empty resultList}">
			<tr><td colspan="7" >등록된 정보가 없습니다.</td></tr>
		</c:when>
		<c:otherwise>
			<c:forEach items="${resultList}" var="list" varStatus="status">
	               <tr>
	                   <td><c:out value="${list.SERIALNO}" /></td>
	                   <td><c:out value="${list.RDATE}" /></td>
				    <td><c:out value="${list.CMSTYPE}" /></td>
				    <td><c:out value="${list.JIKUK_NAME}" /></td>
					<td style="text-align: left;">
						<a href="#fakeUrl" onclick="popMemberView('${list.READNO}');">
							<c:out value="${list.CODENUM}" />
							<br>
							<c:out value="${list.BANK_NAME}" />
						</a>
					</td>
					<td>
                      	<c:out value="${fn:substring(list.CMSRESULT, 1, 5)}" />
                      	<br />
                      	<c:out value="${list.CMSRESULTMSG}" />
                   </td>
				</tr>
			</c:forEach>
		</c:otherwise>
	</c:choose>
</table>
<div style="padding: 10px 0 20px 0; text-align: right; width: 1020px; margin: 0 auto;"><a href="#" onclick="history.go(-1);"><img src="/images/bt_back.gif" border="0"  alt="돌아가기" /></a></div>
