<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>지국정보검색</title>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/ajaxUtil.js"></script>
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet">
<style>
	.empTr {
	    background: #FFFFFF;
	    cursor: hand;
    }

</style>
<script type="text/javascript">
	function fn_search(){

		$("empInfoForm").target="_self";
		$("empInfoForm").action="/reader/empExtd/popSearchEmp.do";
		$("empInfoForm").submit();
	}

	/*----------------------------------------------------------------------
	 * Desc   : 페이징
	 * Auth   : 박윤철
	 *----------------------------------------------------------------------*/
	function moveTo(where, seq) {
	
		$("pageNo").value = seq;
		$("empInfoForm").target = "_self";
		$("empInfoForm").action = "/reader/empExtd/popSearchEmp.do";
		$("empInfoForm").submit();
	}
	
	//  부모창에 값 세팅
	function setValue(empNm, mobile, empNo){

		window.opener.setEmpValue(empNm, mobile, empNo);
		window.close();
	}
	
	//회사명에 따른 부서명 셋팅
	function deptList(){
		if($("company").value != ''){
			var url = "/reader/employeeAdmin/ajaxOfficeNm.do?resv1="+$("company").value;
			sendAjaxRequest(url, "empInfoForm", "post", officeList);
		}else{
			$("dept").options.length = 0;
			$("dept").options[0] = new Option("전체", "");
		}
	}
	//회사명에 따른 부서명 셋팅
	function officeList(responseHttpObj) {
		if (responseHttpObj) {
			try {
				var result = eval("(" + responseHttpObj.responseText + ")");
				if (result) {
					setOfficeNm(result);
				}
			} catch (e) {
				alert("오류 : " + e);
			}
		}
	}
	//회사명에 따른 부서명 셋팅
	function setOfficeNm(jsonObjArr) {
		if (jsonObjArr.length > 0) {
			$("dept").options.length = 0;
			$("dept").options[0] = new Option("전체", "");
			for ( var i = 0; i < jsonObjArr.length; i++) {
				$("dept").options[i+1] = new Option(jsonObjArr[i].CNAME , jsonObjArr[i].CODE );
			}
		}
		
	}
	
	function onLoad(){
		$("empNm").focus();
		
		/*if($("empNm").value != ""){
			search();
		}*/
	}

	window.attachEvent("onload", onLoad);
</script>
</head>
<body>
<div class="box_Popup">
	<!-- title -->
	<div class="pop_title_box">사원정보찾기</div>
	<!-- //title -->
	<div style="padding-top: 5px;">
	<form id="empInfoForm" name="empInfoForm" method="post">
	<input type=hidden id="pageNo" name="pageNo" value="${param.pageNo}" />
		<table class="tb_search" style="width: 780px;">
			<col width="60px">
			<col width="120px">
			<col width="60px">
			<col width="160px">
			<col width="60px">
			<col width="320px">
			<tr>
				<th>회 사</th>
				<td>
					<select id="company" name="company"  onchange="deptList();">
						<option value="">전체</option>
						<c:forEach items="${company}" var="list">
							<option value="${list.CODE }" <c:if test="${list.CODE eq companyCd}"> selected </c:if>>${list.CNAME } </option>
						</c:forEach>
					</select>
				</td>
				<th>부 서</th>
				<td >
					<select id="dept" name="dept">
						<option value="">전체</option>
						<c:forEach items="${dept}" var="list">
							<option value="${list.CODE }" <c:if test="${list.CODE eq deptCd}"> selected </c:if>>${list.CNAME } </option>
						</c:forEach>
					</select>
				</td>
				<th>성 명</th>
				<td>
					<input type="text" name="empNm" id="empNm" style="width: 200px; vertical-align: middle;" value="${empNm}" onkeydown="javascript:if(event.keyCode == '13') {fn_search('1');return false;}"/>
					<a href="#fakeUrl" onclick="fn_search()"><img src="/images/bt_search.gif" border="0" style="vertical-align: middle;" alt="검색" /></a>
				</td>
			</tr>
		</table>
		<div style="padding-top: 5px;">
			<table class="tb_list_a" style="width: 780px;">
			<colgroup>
	      		<col width="20%"/>
	     		<col width="20%"/>
	           	<col width="15%"/>
	           	<col width="15%"/>
	           	<col width="15%"/>
	           	<col width="15%"/>
			</colgroup>
			<tr>
				<th>회사</th>
				<th>부서</th>
				<th>성명</th>
				<th>사번</th>
				<th>전화번호</th>
				<th>휴대폰번호</th>
			</tr>
			<c:choose>
				<c:when test="${empty empList}">
	     			<tr>
				    	<td colspan="6">직원정보가 없습니다.</td>
					</tr>
				</c:when>
	    		<c:otherwise>
					<c:forEach var="list" items="${empList}" varStatus="i">
						<tr class="empTr" onclick="setValue('${list.EMPNAME}', '${list.MOBILE}', '${list.EMPNO}')" class="mover" >
							<td align="left">${list.COMPANYNM}</td>
							<td align="left">${list.DEPTNM}</td>
							<td align="left">${list.EMPNAME}</td>
							<td>${list.EMPNO}</td>
							<td>${list.TELNO}</td>
							<td>${list.MOBILE}</td>
						</tr>
					</c:forEach>
	    		</c:otherwise>
	    	</c:choose>
		</table>
		<div><%@ include file="/common/paging.jsp"%></div>
		<div style="width: 780px; margin: 0 auto; text-align: right;"><a href="#fakeUrl" onclick="window.close();"><img src="/images/bt_cancle.gif" border="0"></a></div>
	</form>
	</div>
</div>
</body>
</html>