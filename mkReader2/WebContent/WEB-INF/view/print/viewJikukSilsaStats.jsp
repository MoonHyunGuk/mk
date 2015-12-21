<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
	function fn_goforms() {
	
		var fm = document.getElementById("forms1");
		var silsaFile = document.getElementById("silsaFile").value;
		var readtypecd = jQuery("input[name=readtypecd]:checked").val();
		
		var prcssDiv	 = document.getElementById("prcssDiv");

		var url ="uploadJikukSilsa.do";
		
		if ( silsaFile == '' || silsaFile == null ) {
			alert("파일을 첨부해 주시기 바랍니다.");
			fm.edifile.focus();
			return;
		}
		
		if(readtypecd == null){
			alert("독자 구분을 선택해 주시기 바랍니다.");
			fm.readtypecd.focus();
			return;
		}
		
		 
		fm.target = "_self";
		fm.action = url;
		jQuery("#prcssDiv").show();
		fm.submit();
	}
	
	function fn_search(){
		var form = document.getElementById("searchForm");
		
		if(jQuery("#searchForm select").val() == ""){
			alert("지국을 선택해 주시기 바랍니다.");
			form.boseq.focus();
			return;
		}
		var url = "viewJikukSilsaStats.do";
		form.target = "_self";
		form.action = url;
		jQuery("#prcssDiv").show();
		form.submit();
	}
</script>
<div style="padding-bottom: 5px;"> 
	<span class="subTitle">자료업로드</span>
</div>
<form name="forms1" id="forms1" method="post" enctype="multipart/form-data">
<!-- form -->
<table class="tb_search" style="width: 1020px">
	<colgroup>
		<col width="260px">
		<col width="760px">
	</colgroup>
	<tr>
		<th>연도 구분</th>
		<td>
			<select name="yyyy">
			<c:forEach var="yyyy" begin="1999" end="2020" step="1">
				<option value="${yyyy}" <c:if test="${yyyy == '2013'}">selected=selected</c:if>>${yyyy}년</option>
			</c:forEach>
			</select>
		</td>
	</tr>
	<tr>
		<th>독자 구분</th>
		<td>
			<input type="radio" name="readtypecd" id="edu" value="교육용"/><label for="edu">교육용</label>
			<input type="radio" name="readtypecd" id="stu" value="본사학생"/><label for="stu">본사학생</label>
			<input type="radio" name="readtypecd" id="sawon" value="사원"/><label for="sawon">사원</label>
			<input type="radio" name="readtypecd" id="so" value="소외계층"/><label for="so">소외계층</label>
			<input type="radio" name="readtypecd" id="auto" value="자동이체"/><label for="auto">자동이체</label>
			<input type="radio" name="readtypecd" id="card" value="카드"/><label for="card">카드</label>
		</td>
	</tr>
	<tr>
		<th>Excel 파일</th>
		<td>
				<input type="file" name="silsaFile" id="silsaFile" style="width:400px; vertical-align: middle; ">&nbsp;
		 	<a href="#fakeUrl" onclick="fn_goforms();"><img src="/images/bt_eepl.gif" style="vertical-align: middle; border: 0;" alt="입력"></a> &nbsp;
		 	<!-- <a href="#"><img src="/images/bt_cancle.gif" border="0" align="absmiddle"></a> -->
		</td>
	</tr>
</table>
<!-- form -->
</form>
<br/>
<div style="padding-bottom: 5px;"> 
	<span class="subTitle">지국별 본사 수금 부수 현황</span>
</div>
<form name="searchForm" id="searchForm" method="post" action="">
<!-- search conditions -->
<table class="tb_search" style="width: 1020px;">
	<colgroup>
		<col width="150px">
		<col width="870px">
	</colgroup>
	<tr>
		<th>지국</th>
		<td>
			<select name="boseq" style="width: 120px;">
				<option value = "">전체</option>
				<c:forEach var="agency" items="${agencyAllList}">
					<option value="${agency.SERIAL}" <c:if test="${agency.SERIAL == boseq}">selected="selected"</c:if>>${agency.NAME}</option>
				</c:forEach>
		  	</select>
		  	<select name="yyyy">
			<c:forEach var="yyyy" begin="1999" end="2020" step="1">
				<option value="${yyyy}" <c:if test="${yyyy == '2013'}">selected=selected</c:if>>${yyyy}년</option>
			</c:forEach>
			</select>
			<a href="#fakeUrl" onclick="fn_search();"><img src="/images/bt_joh.gif" style="vertical-align: middle; border: 0;" alt="조회"></a>
		</td>
	</tr>
</table>
</form>
<div style="padding-top: 10px">
	<table class="tb_list_a_5" style="width: 1020px;">
		<colgroup>
			<col width="210px">
			<col width="110px">
			<col width="100px">
			<col width="100px">
			<col width="100px">
			<col width="100px">
			<col width="100px">
			<col width="200px">
		</colgroup>
		<tr>
			<th rowspan="2">월분</th>
			<th colspan="6">본사독자</th>
			<th rowspan="2">합계</th>
		</tr>
		<tr>
			<th>교육용</th>
			<th>본사학생</th>
			<th>사원</th>
			<th>소외계층</th>
			<th>자동이체</th>
			<th>카드</th>
		</tr>
		<c:forEach var="index" begin="1" end="12">
		<tr>
			<td>${index}</td>
			<td>
				<c:set var="qty" value="0"/>
				<c:forEach var="temp" items="${silsaList}">
					<fmt:parseNumber var="mm" value="${temp.YYYYMM}"/>
					<c:if test="${temp.READTYPECD == '교육용' && mm == index}">
						<fmt:parseNumber var="qty" value="${temp.QTY}"/>
					</c:if>
				</c:forEach>
				${qty}
			</td>
			<td>
				<c:set var="qty" value="0"/>
				<c:forEach var="temp" items="${silsaList}">
					<fmt:parseNumber var="mm" value="${temp.YYYYMM}"/>
					<c:if test="${temp.READTYPECD == '본사학생' && mm == index}">
						<fmt:parseNumber var="qty" value="${temp.QTY}"/>
					</c:if>
				</c:forEach>
				${qty}
			</td>
			<td>
				<c:set var="qty" value="0"/>
				<c:forEach var="temp" items="${silsaList}">
					<fmt:parseNumber var="mm" value="${temp.YYYYMM}"/>
					<c:if test="${temp.READTYPECD == '사원' && mm == index}">
						<fmt:parseNumber var="qty" value="${temp.QTY}"/>
					</c:if>
				</c:forEach>
				${qty}
			</td>
			<td>
				<c:set var="qty" value="0"/>
				<c:forEach var="temp" items="${silsaList}">
					<fmt:parseNumber var="mm" value="${temp.YYYYMM}"/>
					<c:if test="${temp.READTYPECD == '소외계층' && mm == index}">
						<fmt:parseNumber var="qty" value="${temp.QTY}"/>
					</c:if>
				</c:forEach>
				${qty}
			</td>
			<td>
				<c:set var="qty" value="0"/>
				<c:forEach var="temp" items="${silsaList}">
					<fmt:parseNumber var="mm" value="${temp.YYYYMM}"/>
					<c:if test="${temp.READTYPECD == '자동이체' && mm == index}">
						<fmt:parseNumber var="qty" value="${temp.QTY}"/>
					</c:if>
				</c:forEach>
				${qty}
			</td>
			<td>
				<c:set var="qty" value="0"/>
				<c:forEach var="temp" items="${silsaList}">
					<fmt:parseNumber var="mm" value="${temp.YYYYMM}"/>
					<c:if test="${temp.READTYPECD == '카드' && mm == index}">
						<fmt:parseNumber var="qty" value="${temp.QTY}"/>
					</c:if>
				</c:forEach>
				${qty}
			</td>
			<td>
				<c:set var="qty" value="0"/>
				<c:set var="sum" value="0"/>
				<c:forEach var="temp" items="${silsaList}">
					<fmt:parseNumber var="mm" value="${temp.YYYYMM}"/>
					<c:if test="${mm == index}">
						<fmt:parseNumber var="qty" value="${temp.QTY}"/>
						<c:set var="sum" value="${sum + qty}"/>
					</c:if>
				</c:forEach>
				${sum}
			</td>
		</tr>
		</c:forEach>
		<tr>
			<td>평균</td>
			<td>
				<c:set var="qty" value="0"/>
				<c:set var="sum" value="0"/>
				<c:forEach var="temp" items="${silsaList}">
					<c:if test="${temp.READTYPECD == '교육용'}">
						<fmt:parseNumber var="qty" value="${temp.QTY}"/>
						<c:set var="sum" value="${sum + qty}"/>
					</c:if>
				</c:forEach>
				<fmt:formatNumber var="f" value="${sum/12}" type="number" maxFractionDigits="0"/>
				${f}
			</td>
			<td>
				<c:set var="qty" value="0"/>
				<c:set var="sum" value="0"/>
				<c:forEach var="temp" items="${silsaList}">
					<c:if test="${temp.READTYPECD == '본사학생'}">
						<fmt:parseNumber var="qty" value="${temp.QTY}"/>
						<c:set var="sum" value="${sum + qty}"/>
					</c:if>
				</c:forEach>
				<fmt:formatNumber var="f" value="${sum/12}" type="number" maxFractionDigits="0"/>
				${f}
			</td>
			<td>
				<c:set var="qty" value="0"/>
				<c:set var="sum" value="0"/>
				<c:forEach var="temp" items="${silsaList}">
					<c:if test="${temp.READTYPECD == '사원'}">
						<fmt:parseNumber var="qty" value="${temp.QTY}"/>
						<c:set var="sum" value="${sum + qty}"/>
					</c:if>
				</c:forEach>
				<fmt:formatNumber var="f" value="${sum/12}" type="number" maxFractionDigits="0"/>
				${f}
			</td>
			<td>
				<c:set var="qty" value="0"/>
				<c:set var="sum" value="0"/>
				<c:forEach var="temp" items="${silsaList}">
					<c:if test="${temp.READTYPECD == '소외계층'}">
						<fmt:parseNumber var="qty" value="${temp.QTY}"/>
						<c:set var="sum" value="${sum + qty}"/>
					</c:if>
				</c:forEach>
				<fmt:formatNumber var="f" value="${sum/12}" type="number" maxFractionDigits="0"/>
				${f}
			</td>
			<td>
				<c:set var="qty" value="0"/>
				<c:set var="sum" value="0"/>
				<c:forEach var="temp" items="${silsaList}">
					<c:if test="${temp.READTYPECD == '자동이체'}">
						<fmt:parseNumber var="qty" value="${temp.QTY}"/>
						<c:set var="sum" value="${sum + qty}"/>
					</c:if>
				</c:forEach>
				<fmt:formatNumber var="f" value="${sum/12}" type="number" maxFractionDigits="0"/>
				${f}
			</td>
			<td>
				<c:set var="qty" value="0"/>
				<c:set var="sum" value="0"/>
				<c:forEach var="temp" items="${silsaList}">
					<c:if test="${temp.READTYPECD == '카드'}">
						<fmt:parseNumber var="qty" value="${temp.QTY}"/>
						<c:set var="sum" value="${sum + qty}"/>
					</c:if>
				</c:forEach>
				<fmt:formatNumber var="f" value="${sum/12}" type="number" maxFractionDigits="0"/>
				${f}
			</td>
			<td>
				<c:set var="qty" value="0"/>
				<c:set var="sum" value="0"/>
				<c:forEach var="temp" items="${silsaList}">
					<fmt:parseNumber var="qty" value="${temp.QTY}"/>
					<c:set var="sum" value="${sum + qty}"/>
				</c:forEach>
				<fmt:formatNumber var="f" value="${sum/12}" type="number" maxFractionDigits="0"/>
				${f}
			</td>
		</tr>
	</table>
</div>
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