<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript">
	//페이징
	function moveTo(where, seq) {
		if($("searchText").value  != '' || $("status").value  != '1'){
			$("pageNo").value = seq;
			employeeList.target = "_self";
			employeeList.action = "/reader/employee/searchEmployeeList.do";
			employeeList.submit();
		}else{
			$("pageNo").value = seq;
			employeeList.target = "_self";
			employeeList.action = "/reader/employee/retrieveEmployeeList.do";
			employeeList.submit();	
		}
	}
	//검색
	function search(){
		$("pageNo").value = '1';
		employeeList.target = "_self";
		employeeList.action = "/reader/employee/searchEmployeeList.do";
		employeeList.submit();
	}
	//독자 정보
	function info(readNm){
		employeeList.target = "_self";
		employeeList.action = "/reader/readerManage/searchReader.do?searchText="+readNm+"&searchType=4";
		employeeList.submit();
	}
</script>
<div><span class="subTitle">본사사원구독관리</span></div> 
<form id="employeeList" name="employeeList" action="" method="post">
<input type=hidden id="pageNo" name="pageNo" value="${param.pageNo}" />
<input type=hidden id="readNo" name="readNo" value="" />
<input type=hidden id="newsCd" name="newsCd" value="" />
<input type=hidden id="seq" name="seq" value="" />
	<!-- search condition -->
	<div class="box_white" style="padding: 10px 0; width: 1020px; margin: 0 auto;">
		<select id="searchKey" name="searchKey" style="vertical-align: middle;">
			<option value="readnm" <c:if test="${param.searchKey eq 'readnm' }"> selected </c:if>>성 명</option>
			<option value="company" <c:if test="${param.searchKey eq 'company' }"> selected </c:if>>회 사 명</option>
			<option value="office" <c:if test="${param.searchKey eq 'office' }"> selected </c:if>>부 서 명</option>
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="text" id="searchText" name="searchText" value="${param.searchText }" style="width: 140px; vertical-align: middle; " onkeydown="if(event.keyCode == 13){search(); }"/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<img src="/images/bt_search.gif" style="vertical-align: middle; border: 0; cursor: pointer;" onclick="search();">
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<select id="status" name="status" style="vertical-align: middle;">
			<option value="1" <c:if test="${param.status eq '1' }"> selected </c:if>>전체</option>
			<option value="2" <c:if test="${param.status eq '2' }"> selected </c:if>>정상</option>
			<option value="3" <c:if test="${param.status eq '3' }"> selected </c:if>>해지</option>
		</select>
	</div>
	<!-- //search condition -->
	<!-- counting -->
	<div style="padding: 10px 0 5px 0; width: 1020px; margin: 0 auto;">
		<font class="b02">정상 구독 부수 : ${count }</font>
	</div>
	<!-- //counting -->
	<div>
		<table class="tb_list_a" style="; width: 1020px; margin: 0 auto;">  
			<colgroup>
				<col width="70px"/>
				<col width="100px"/>
				<col width="115px"/>
				<col width="55px"/>
				<col width="55px" />
				<col width="250px"/>
				<col width="125px"/>
				<col width="40px"/>
				<col width="110px"/>
				<col width="80px"/>
			</colgroup>	
			<tr>
				<th>관리지국</th>
				<th>회사명</th>
				<th>부서명</th>
				<th>사번</th>
				<th>성명</th>
				<th>주 소</th>
				<th>휴대폰</th>
				<th>금액</th>
				<th>신청일<br/>(해지일)</th>
				<th>현재상태</th>
			</tr>
			<c:forEach items="${employeeList }" var="list" varStatus="i">
				<tr>
					<td>${list.JIKUKNM }</td>
					<td>${list.COMPANYNM }</td>
					<td>${list.OFFINM }</td>
					<td>${list.SABUN }</td>
					<td style="text-align: left;"><a href="#fakeUrl" onclick="info('${list.READNM }');">${list.READNM }</a></td>
					<td style="text-align: left;">${list.ADDR }</td>
					<td>${list.MOBILE }</td>
					<td>${list.UPRICE }</td>
					<c:choose>
						<c:when test="${list.BNO eq '999' }">
							<td>${list.INDT }<br/>(<font class="b03">${list.STDT }</font>)</td>
							<td><font class="b03">해지</font></td>
						</c:when>
						<c:otherwise>
							<td>${list.INDT }</td>
							<td>정상</td>
						</c:otherwise>
					</c:choose>
				</tr>
			</c:forEach>
		</table>
	</div>
	<%@ include file="/common/paging.jsp"%>
</form>