<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript">
/*----------------------------------------------------------------------
 * Desc   : 조건별 리스트를 조회한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncAgencyList(){
	 var fm = document.getElementById("frmList");
	 
	 fm.action = "/management/adminManage/agencyList.do";
	 fm.target="_self";
	 fm.pageNo.value = "1";
	 fm.submit();
}

/*----------------------------------------------------------------------
 * Desc   : 지국 상세정보를 조회한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncAgencyInfo(numId){
	 var fm = document.getElementById("frmList");
	 
	 fm.numId.value = numId;
	 fm.target="_self";
	 fm.action = "/management/adminManage/agencyInfo.do";
	 fm.submit();
}

/*----------------------------------------------------------------------
 * Desc   : 페이징 펑션
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function moveTo(where, seq) {
	var fm = document.getElementById("frmList");
	
	fm.pageNo.value = seq;
	fm.target="_self";
	fm.action = "/management/adminManage/agencyList.do";
	fm.submit();
}

/*----------------------------------------------------------------------
 * Desc   : 검색조건별 검색문구 속성변경
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncTypeChange() {
	if($("type").value == "0"){ 
		$("txt").disabled = true;
		$("txt").value = "";
	}else if($("type").value == "1"){
		$("txt").disabled = false;
		$("txt").value = "";
		$("txt").maxLength     = "10";
		$("txt").style.imeMode = "auto"; 
	}else{			
		$("txt").disabled = false;
		$("txt").value = "";
		$("txt").maxLength     = "6";
		$("txt").style.imeMode = "disabled"; 
		}
 }
 
//자세히 보기
function fn_popAgencyInfo(numId){
	var fm = document.getElementById("frmList");
	var left = (screen.width)?(screen.width - 726)/2 : 10;
	var top = (screen.height)?(screen.height - 780)/2 : 10;
	var winStyle = "width=726,height=780,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
	newWin = window.open("", "detailVeiw", winStyle);
	newWin.focus();
	
	fm.target = "detailVeiw";
	fm.action = "/management/adminManage/agencyInfo.do?numId="+numId+"&flag=UPT";
	fm.submit();
}
</script>
<div><span class="subTitle">지국 관리</span></div>
<form id= "frmList" name = "frmList" method="post">
<input type=hidden id="type" name="type" value="1" />
<input type="hidden" name="numId" id="numId" />
<input type="hidden" name="flag" id="flag" />      
<input type=hidden id="pageNo" name="pageNo" value="${param.pageNo}" />
<!-- search conditions -->	
<table class="tb_search" style="width: 1020px">
	<colgroup>
		<col width="100px" />
		<col width="150px" />
		<col width="100px" />
		<col width="150px" />
		<col width="100px" />
		<col width="150px" />
		<col width="100px" />
		<col width="170px" />
	</colgroup>
	<tr>
		<th>부 서</th>
		<td>
			<select name="area1" id="area1">
				<option value = "">전체</option>
					<c:forEach items="${areaCb}" var="area"  varStatus="status">
						<option value="${area.CODE}"  <c:if test="${area.CODE eq area1}">selected</c:if>>${area.CNAME}</option>
				 	</c:forEach>
		 		<option value='0' <c:if test="${'0' eq area1}">selected</c:if>>미지정</option>
		  	</select>
		</td>
		<th>구 분</th>
		<td>
			<select name="agencyType"  id="agencyType">
				<option value = "">전체</option>
					<c:forEach items="${agencyTypeCb}" var="type"  varStatus="status">
						<option value="${type.CODE}"  <c:if test="${type.CODE eq agencyType}">selected</c:if>>${type.CNAME}</option>
				 	</c:forEach>
		 		<option value='0' <c:if test="${'0' eq agencyType}">selected</c:if>>미지정</option>
		  	</select>
		</td>
		<th>파 트</th>
		<td>
			<select name="part" id="part">
				<option value = "">전체</option>
					<c:forEach items="${partCb}" var="agcPart"  varStatus="status">
						<option value="${agcPart.CODE}"  <c:if test="${agcPart.CODE eq part}">selected</c:if>>${agcPart.CNAME}</option>
				 	</c:forEach>
		 	    <option value='0' <c:if test="${'0' eq part}">selected</c:if>>미지정</option>
		  	</select>
		</td>
		<th>지 역</th>
		<td>
			<select name="agencyArea" id="agencyArea">
				<option value = "">전체</option>
					<c:forEach items="${agencyAreaCb}" var="agcArea"  varStatus="status">
						<option value="${agcArea.CODE}"  <c:if test="${agcArea.CODE eq agencyArea}">selected</c:if>>${agcArea.CNAME}</option>
				 	</c:forEach>
		 		<option value='0' <c:if test="${'0' eq agencyArea}">selected</c:if>>미지정</option>
		  	</select>
		</td>
	</tr>
	<tr>
		<th>담당자</th>
		<td>
			<select name="manager"  id="manager">
				<option value = "">전체</option>
					<c:forEach items="${mngCb}" var="mng"  varStatus="status">
						<option value="${mng.NAME}"  <c:if test="${mng.NAME eq manager}">selected="selected"</c:if>>${mng.NAME}</option>
				 	</c:forEach>
		 	    <option value='0' <c:if test="${'0' eq manager}">selected="selected"</c:if>>미지정</option>
		  	</select>
		</td>
		<th>지국장</th>
		<td>
			<input type="text" id="opName2" name="opName2" maxlength="10"  value="<c:out value="${opName2}"/>"  style="width: 100px; vertical-align: middle;" />
		</td>
		<th>지국명</th>
		<td colspan="3">
			<input id="txt" name="txt" type="text"  maxlength="10"  value="<c:out value="${txt}"/>"  style="width: 100px; vertical-align: middle;" onkeypress="if(event.keyCode==13){fncAgencyList();}" />
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="#fakeUrl" onclick="fncAgencyList();"><img src="/images/bt_joh.gif" style="vertical-align: middle; border: 0" alt="조회" /></a>   
		</td>
	</tr>
</table>
<!-- //search conditions -->
</form>
<!-- list -->
<div style="padding-top: 15px">	
	<table class="tb_list_a_5" style="width: 1020px">
		<colgroup>
			<col width="115px"/>
			<col width="120px"/>
			<col width="65px"/>
			<col width="120px"/>
			<col width="130px"/>
			<col width="90px"/>
			<col width="140px"/>
			<col width="150px"/>
			<col width="90px"/>
		</colgroup>
	    <tr bgcolor="f9f9f9" align="center" class="box_p" >
            <th>부서</th>
            <th>구분</th>
            <th>지역</th>
            <th>지국번호</th>
            <th>지국명</th>
            <th>지국장</th>
            <th>전화번호</th>
            <th>지국장번호</th>
            <th>담당자</th>
	    </tr>

	<c:if test="${empty agencyList}">
        <tr>
            <td colspan="9" align="center">검색 결과가 없습니다.</td>
        </tr>
     </c:if>
     <c:if test="${!empty agencyList}">
		<c:forEach items="${agencyList}" var="list"  varStatus="status">
		<tr id="oTr<c:out value="${status.count}"/>"  style="cursor:pointer;" onclick="fn_popAgencyInfo('${list.NUMID}')"  class="mover">
			<td>${list.AREA1_NM }</td>
			<td>${list.TYPE_NM }</td>
			<td>${list.ZONE_NM }</td>
			<td>${list.SERIAL }</td>
			<td>${list.NAME }</td>
			<td>${list.NAME2 }</td>
			<td>${list.JIKUK_TEL }</td>
			<td>${list.JIKUK_HANDY }</td>
			<td>${list.MANAGER }</td>
		</tr>
		</c:forEach>
    </c:if>
    </table>
	<%@ include file="/common/paging.jsp"  %>
</div>