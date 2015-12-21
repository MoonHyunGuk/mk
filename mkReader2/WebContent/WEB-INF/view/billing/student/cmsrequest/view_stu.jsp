<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.util.CommonUtil"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<!-- title -->
<div><span class="subTitle">학생이체신청 신청결과</span></div>
<!-- //title -->
<div class="box_gray" style="font-weight: bold; padding: 10px 0; width: 1020px;">CMS file : <font class="b03"><c:out value="${filename}" /></font> 처리 결과 명세</div>
<div style="padding: 5px 0 10px 0;">
	<table class="tb_search" style="width: 1020px;">
		<col width="260px">
		<col width="760px">
		 <tr>
		 	<th>신청접수 일자</th>
			<td><fmt:formatNumber value="${fn:trim(cmsdate)}" type="number" /></td>
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
<form name="form1">
	<div style="padding: 5px 0; ">&nbsp;
		<select name="jikuk" size="1" style="width:120px;" onchange="window.open('view_stu.do?filename=${filename}&cmsdate=${cmsdate}&jikuk='+document.form1.jikuk.value+'&chbx=${chbx}','_self');">
			<option value=''>전체</option>
			<c:if test="${not empty jikukList}">
				<c:forEach items="${jikukList}" var="list" varStatus="status">
					<option value="${list.JIKUK}" <c:if test="${list.JIKUK eq jikuk}">selected</c:if>><c:out value="${list.JIKUK_NAME}" /></option>
				</c:forEach>
			</c:if>
		</select>
		<input type="radio" name="chbx" value="all" <c:if test="${chbx eq 'all'}"> checked</c:if> onclick="window.open('view_stu.do?filename=${filename}&cmsdate=${cmsdate}&jikuk='+document.form1.jikuk.value+'&chbx='+document.form1.chbx[0].value,'_self');">전체 표시
		<input type="radio" name="chbx" value="off" <c:if test="${chbx eq 'off'}"> checked</c:if> onclick="window.open('view_stu.do?filename=${filename}&cmsdate=${cmsdate}&jikuk='+document.form1.jikuk.value+'&chbx='+document.form1.chbx[1].value,'_self');"> 에러건만 표시
		<input type="radio" name="chbx" value="on" <c:if test="${chbx eq 'on'}"> checked</c:if> onclick="window.open('view_stu.do?filename=${filename}&cmsdate=${cmsdate}&jikuk='+document.form1.jikuk.value+'&chbx='+document.form1.chbx[2].value,'_self');"> 정상등록건만 표시			
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<a href="#fakeUrl" onclick="window.open('viewExcel_stu.do?filename=${filename}&cmsdate=${cmsdate}&jikuk='+document.form1.jikuk.value+'&chbx=${chbx}','_self');"><img src="/images/bt_exel.gif" border="0" align="absmiddle"></a>
	</div>	
</form>
<table class="tb_list_a_5" style="width: 1020px;">
	<col width="80px">
	<col width="80px">
	<col width="80px">
	<col width="160px">
	<col width="90px">
	<col width="75px">
	<col width="205px">
	<col width="250px">
	<tr>
		<td >일련번호</td>
	  	<td>신청일</td>
	  	<td>신청구분</td>
	  	<td>지국</td>
	  	<td>납부자번호</td>
	  	<td>독자번호</td>
	  	<td>독자</td>
		<td>불능코드</td>
	</tr>
	<c:choose>
		<c:when test="${empty resultList}">
			<tr><td colspan="8" align="center">등록된 정보가 없습니다.</td></tr>
		</c:when>
		<c:otherwise>
			<c:forEach items="${resultList}" var="list" varStatus="status">
	               <tr>
	                   <td><c:out value="${list.SERIALNO}" /></td>
	                   <td><c:out value="${list.RDATE}" /></td>
				    <td><c:out value="${list.CMSTYPE}" /></td>
				    <td>
				        <c:out value="${list.JIKUK_NAME}" />
				        <br>
				        (<c:out value="${list.JIKUK_TEL}" />)
				    </td>
				    <td style="text-align: left;">
						<c:out value="${list.CODENUM}" />
					</td>
					<td style="text-align: left;">
						<a href="#fakeUrl" onclick="popMemberViewStu('${list.READNO}');">
							<c:out value="${list.READNO}" />
						</a>
					</td>
					<td>
						<c:out value="${list.USERNAME}" /><br>
						<c:choose>
							<c:when test="${list.PHONE eq '--'}">
								(<c:out value="${list.HANDY}" />)
							</c:when>
							<c:when test="${list.HANDY eq '--'}">
								(<c:out value="${list.PHONE}" />)
							</c:when>									
							<c:otherwise>
								(<c:out value="${list.PHONE}" /> / <c:out value="${list.HANDY}" />)
							</c:otherwise>
						</c:choose>
					</td>
					<td>
					    <c:out value="${fn:substring(list.CMSRESULT, 1, 5)}" />
					    <br/>
					    <c:out value="${list.CMSRESULTMSG}" />
					</td>
				</tr>
			</c:forEach>
		</c:otherwise>
	</c:choose>
</table>
<div style="padding: 10px 0 20px 0; text-align: right;"><a href="#" onclick="history.go(-1);"><img src="/images/bt_back.gif" border="0" align="absmiddle"></a></div>
