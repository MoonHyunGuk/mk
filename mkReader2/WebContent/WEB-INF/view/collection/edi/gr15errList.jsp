<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript">
<!--
	// 조회
	function goSearch(type, pageNo) {
		
		var frm = document.frm;

		frm.pageNo.value = pageNo;
		frm.action = "gr15errList.do";
		frm.submit();
	}

	// 수정
	function goModify() {
		var frm = document.frm;
		
		frm.action = "modifyError.do";
		frm.submit();
	}
//-->
</script>
<!-- title -->
<div><span class="subTitle">오류조회</span></div>
<!-- //title -->
<form name="frm" method="post">
<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />	
	<table class="tb_search" style="width: 1035px">
		<col width="11%">
		<col width="19%">
		<col width="11%">
		<col width="19%">
		<col width="11%">
		<col width="29%">
		<tr>
			<th>지로구분</th>
			<td>
				<select name="type" style="width: 100px;">
					<option <c:if test="${0 eq type}">selected</c:if>>전체</option>
					<option value = "1" <c:if test="${1 eq type}">selected</c:if>>직영지로</option>
			 		<option value = "2" <c:if test="${2 eq type}">selected</c:if>>수납대행</option>
			 		<option value = "3" <c:if test="${3 eq type}">selected</c:if>>바코드수납</option>
			  	</select>
			</td>
			<th>지로번호</th>
			<td>
				<select name="jiroNum" style="width: 140px;">
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
	   			<a href="javascript:goSearch('1');"><img src="/images/bt_joh.gif" border="0" align="absmiddle"></a>&nbsp;
			</td>
		</tr>
	</table>
	
	<p style="margin-top:20px;">	
	<table class="tb_list_a" style="width: 1035px;">
		  <tr>
		    <th>지로<br>번호</th>
		    <th>일련<br>번호</th>
			<th>수납점</th>
			<th>수납<br>일자</th>
			<th>지국</th>
			<th>임의19자리</th>
			<th>결재원수록내용</th>
			<th>S</th>
			<th>R</th>
			<th>수납<br>금액</th>
			<th>수수료</th>
			<th>생성<br>일자</th>
			<th>수정</th>
		</tr>
		<c:choose>
		<c:when test="${empty errList}">
			<tr>
				<td colspan="13" >등록된 정보가 없습니다.</td>
			</tr>
		</c:when>
		<c:otherwise>
			<c:forEach items="${errList}" var="list" varStatus="status">
				<tr style="display: none;">
					<td colspan="13" >
					<input type="hidden" name="e_sdate" value="<c:out value='${list.E_SDATE}' />" />
					<input type="hidden" name="e_edate" value="<c:out value='${list.E_EDATE}' />" />
					<input type="hidden" name="e_number" value="<c:out value='${list.E_NUMBER}' />" />
					<input type="hidden" name="e_rcode" value="<c:out value='${list.E_RCODE}' />" />
					<input type="hidden" name="e_wdate" value="<c:out value='${list.E_WDATE}' />" />
					<input type="hidden" name="e_numid" value="<c:out value='${list.E_NUMID}' />" />
					<input type="hidden" name="e_money" value="<c:out value='${list.E_MONEY}' />" />
					<input type="hidden" name="e_check" value="<c:out value='${list.E_CHECK}' />" />
					</td>
				</tr>
				<tr>
				    <td><c:out value="${list.E_JIRO}" /></td> 
				    <td><c:out value="${list.E_NUMID}" /></td>
					<td><c:out value="${list.E_INFO}" /></td>
					<td><c:out value="${list.E_SDATE}" /></td>
					<td>
						<c:out value="${list.COUNT}" />
						<select name="e_jcode" id="e_jcode" style="width: 120px;">
							<option value="">선택</option>
							<c:forEach items="${agencyList}" var="aList" varStatus="status">
								<option value="${aList.SERIAL}" <c:if test="${list.E_JCODE eq aList.SERIAL}">selected</c:if>><c:out value="${aList.SERIAL}" />(<c:out value="${aList.NAME}" />)</option>
							</c:forEach>
						</select>
					</td>
					<td>
						<input type="text" name="NCustNo" size="19" maxlength="19" value="<c:out value='${list.E_RCODE}' />" />
					</td>
					<td><c:out value="${list.E_CHECK}" /></td>
					<td><c:out value="${list.E_SGUBUN}" /></td>
					<td><c:out value="${list.E_JGUBUN}" /></td>
					<td align="right"><fmt:formatNumber value="${list.E_MONEY}" type="number" /> 원</td>
					<td align="right"><fmt:formatNumber value="${list.E_CHARGE}" type="number" /> 원</td>
					<td><c:out value="${list.E_WDATE}" /></td>
					<td>
						<input type="checkbox" name="ErrCK" value="<c:out value='${list.E_NUMID}' />" />
					</td>
				</tr>
			</c:forEach>
			<tr>
				<td colspan="13" style="text-align: right;">
					<input type="button" value="수정완료" onclick="goModify();" />&nbsp;&nbsp;&nbsp;
				</td>
			</tr>
		</c:otherwise>
		</c:choose>
	</table>
</form>

