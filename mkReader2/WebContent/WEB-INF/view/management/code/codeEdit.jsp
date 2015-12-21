<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- <script type="text/javascript" src="/js/jquery-1.9.1.js"></script>  -->
<link rel="stylesheet" type="text/css" href="/css/addStyle.css" />
<script type="text/javascript">
/**
 * 저장버튼 클릭 이벤트 펑션
 */
function fn_save(flag) {
	var fm = document.getElementById("fm");
	var url = "";
	var txt = "";
	
	if("INS" == flag) {
		url = "/management/code/insertCodeData.do";
		txt = "등록";
	} else if("UPT" == flag) {
		url = "/management/code/updateCodeData.do";
		txt = "수정";
	}
	
	cf_checkNull("code", "코드");
	cf_checkNull("cname", "코드명");
	
	if(!confirm("코드를 "+txt+"하시겠습니까?")) {
		return false;
	}
	
	fm.target = "_self";
	fm.action = url;
	fm.submit();
}

/**
 * 취소버튼 클릭 이벤트 펑션
 */
function fn_cancel() {
	var fm = document.getElementById("fm");
	
	fm.target = "_self";
	fm.action = "/management/code/codeDetailView.do";
	fm.submit();
}
</script>
<div style="padding-bottom: 15px;"> 
	<span class="subTitle">코드관리</span>
</div>
<form id="fm" name="fm" method="post" action="">
	<input type="hidden" name="flag" id="flag" value="${flag}" />
	<input type="hidden" name="subCode" id="subCode" value="${subCode}" />
	<input type="hidden" name="selCdclsf" id="selCdclsf" value="${selCdclsf}" />
<div>
	<!-- search box -->
	<div style="width: 867px; padding-bottom: 10px;">
		<table class="tb_search" style="width: 867px">
			<colgroup>
				<col width="167px">
				<col width="700px">
			</colgroup>
			<tr>
				<th>코드구분</th>
				<td>
					<c:forEach items="${codeStep1List}" var="list" varStatus="cnt">
						<c:if test="${list.CODE == selCdclsf}"><c:out value="${list.CNAME}" /></c:if>
					</c:forEach>
				</td>
			</tr>
		</table>
	</div>
	<!-- //search box -->
	<!-- code step2 list -->
	<div style="width: 289px; float: left; border: 0px solid #e5e5e5; height: 620px;">
		<div style="padding-bottom: 5px;">
			<div style="width: 282px; text-align: center; padding: 10px 0; background-color: #e5e5e5; font-weight: bold;">코드(명)</div>
		</div>
		<div style="width: 275px; border: 1px solid #e5e5e5; padding: 5px 0 5px 5px; overflow: hidden;">
			<div style="width: 275px; height: 610px; overflow-y: scroll; overflow-x: none;">
				<c:forEach items="${codeStep2List}" var="subList" varStatus="cnt">
					<div style="overflow: hidden; padding-bottom: 3px;">
						<div style="border: 2px solid #e5e5e5; padding: 10px 0; text-align: center; width: 250px; <c:if test="${subList.CODE eq subCode }">background-color: #b5772f; color:#fff; font-weight: bold;</c:if>" >${subList.CNAME}</div>
					</div>
				</c:forEach>
			</div>
		</div>
	</div>
	<!-- //code step2 list -->
	<!-- code detail view -->
	<div style="width: 576px; float: left; height: 720px;">
		<div style="padding-bottom: 5px;">
			<div style="width: 578px; text-align: center; padding: 10px 0; background-color: #e5e5e5; font-weight: bold;">상세보기</div>
		</div>
		<div style="width: 100%; border: 1px solid #e5e5e5; padding: 20px 0; height: 580px;">
			<table class="tb_search" style="width: 490px;">
				<colgroup>
					<col width="170px">
					<col width="320px">
				</colgroup>
				<tr>
					<th>코드구분</th>
					<td>
						<select name="cdclsf" id="cdclsf">
							<c:forEach items="${codeStep1List}" var="list" varStatus="cnt">
								<option value="${list.CODE}" <c:if test="${list.CODE == selCdclsf}">selected="selected"</c:if>>${list.CNAME}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th>코 드</th>
					<td><input name="code" id="code" value="${subCode}" style="width: 90%;" maxlength="6" /></td>
				</tr>
				<tr>
					<th>코드명</th>
					<td><input name="cname" id="cname" value="${codeView.CNAME}" style="width: 90%;" maxlength="20" /></td>
				</tr>
				<tr>
					<th>코드약어</th>
					<td><input name="yname" id="yname" value="${codeView.YNAME}" style="width: 90%;" maxlength="10" /></td>
				</tr>
				<tr>
					<th>비 고</th>
					<td><input name="remk" id="remk" value="${codeView.REMK}" style="width: 90%;" maxlength="25" /></td>
				</tr>
				<tr>
					<th>예약1</th>
					<td><input name="resv1" id="resv1" value="${codeView.RESV1}" style="width: 90%;" maxlength="10" /></td>
				</tr>
				<tr>
					<th>예약2</th>
					<td><input name="resv2" id="resv2" value="${codeView.RESV2}" style="width: 90%;" maxlength="10" /></td>
				</tr>
				<tr>
					<th>예약3</th>
					<td><input name="resv3" id="resv3" value="${codeView.RESV3}" style="width: 90%;" maxlength="10" /></td>
				</tr>
				<tr>
					<th>우선순위</th>
					<td><input name="resv3" id="resv3" value="${codeView.SORTFD}" style="width: 30px;" maxlength="3" /></td>
				</tr>
				<tr>
					<th>사용여부</th>
					<td>
						<select name="useyn" id="useyn">
							<option value="Y" <c:if test="${codeView.USEYN == 'Y'}">selected="selected"</c:if>>사용</option>
							<option value="N" >미사용</option>
						</select>
					</td>
				</tr>
			</table>
			<!-- button -->
			<div style="width: 490px; text-align: right; margin: 0 auto; padding-top: 10px; ">
				<span class="btnCss2"><a class="lk2" onclick="fn_save('${flag}');">저장</a></span>&nbsp;
				<span class="btnCss2"><a class="lk2" onclick="fn_cancel();">취소</a></span>
			</div>
			<!-- //button -->
		</div>
	</div>
	<!-- //code detail view -->
</div>
</form>