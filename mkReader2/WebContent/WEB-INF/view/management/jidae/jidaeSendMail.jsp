<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" type="text/css" href="/css/addStyle.css">
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/js/jquery.number.min.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel='stylesheet' type='text/css' href="/select2/select2.css"/>
<style>
#xlist {
	width: 100%;
	height: 500px;
	overflow-y: scroll;
	overflow-x: none;
}
</style>
<script type="text/javascript">
/**
 * 검색버튼 클릭이벤트
 */
 
jQuery(function(){
	//체크박스 전체 체크 및 해제
	jQuery("#controll").click(function(){
		if(jQuery(this).is(":checked")){
			jQuery("input:checkbox").each(function(){
				if(jQuery(this).attr("id") != "controll" && jQuery(this).is(":disabled") == false)
					jQuery(this).attr("checked",true);
			});
		}else{
			jQuery("input:checkbox").each(function(){
				if(jQuery(this).attr("id") != "controll")
					jQuery(this).attr("checked",false);
			});
		}
	});
	
	//지대통보서 검색
	jQuery("#search_btn").click(function(){
		jQuery("#search").attr("action","./jidaeSendMail.do").submit();
		jQuery("#prcssDiv").show(); 
		return false;	
	});
	
	//메일 전송
	jQuery("#sendMail_btn").click(function(){
		var array = new Array();
		jQuery("input:checkbox:checked").each(function(){
			if(jQuery(this).attr("id") != "controll")
				array[array.length] = jQuery(this).val();
		});
		if(array.length == 0){
			alert("지국을 선택해 주세요.");
			return false;
		}
		jQuery("#sendForm").find("input[name='boseq']").val(array);
		jQuery("#sendForm").attr("action","./excuteSendMail.do").submit();
		jQuery("#prcssDiv").show();
		return false;
	});
	
	var interval = 20000;
	
	jidaeMailingList = function(){
		var url = "./ajaxJidaeMailingListInfo.do";
		var param = {};
		jQuery.getJSON(url,param,function(data){
			jQuery("#mailingCount").html(data.jidaeMailingList.length);
		});
	};
	jidaeMailingList();
	var timer = setInterval(jidaeMailingList,interval);
});


</script>
<div style="padding-bottom: 5px;"><span class="subTitle">지대통보서 메일전송</span></div>
<form id= "search" name = "search" method="post">
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
		<th>월 분</th>
		<td>
			<select name="year" id="year" style="vertical-align: middle;">
				<option value="2014" <c:if test="${year == '2014'}">selected="selected"</c:if>>2014</option>
				<option value="2015" <c:if test="${year == '2015'}">selected="selected"</c:if>>2015</option>
				<option value="2016" <c:if test="${year == '2016'}">selected="selected"</c:if>>2016</option>
				<option value="2017" <c:if test="${year == '2017'}">selected="selected"</c:if>>2017</option>
				<option value="2018" <c:if test="${year == '2018'}">selected="selected"</c:if>>2018</option>
			</select>
			<span style="font-weight: bold; vertical-align: middle;">년</span> &nbsp;&nbsp;
			<select name="month" id="month" style="width: 40px; vertical-align: middle;">
				<c:forEach var="i" begin="1" end="12">
					<c:if test="${i < 10}">
						<c:set var="i" value="0${i}"/> 
					</c:if>
					<option value="${i}" <c:if test="${month == i}">selected="selected"</c:if>>${i}</option>
				</c:forEach>
			</select>
		</td>
		<th>부 서</th>
		<td>
			<select name="area1" id="area1">
				<option value = "">전체</option>
					<c:forEach items="${areaCb}" var="area"  varStatus="status">
						<option value="${area.CODE}"  <c:if test="${area.CODE eq area1}">selected</c:if>>${area.CNAME}</option>
				 	</c:forEach>
		  	</select>
		</td>
		<th>구 분</th>
		<td>
			<select name="agencyType"  id="agencyType">
				<option value = "">전체</option>
					<c:forEach items="${agencyTypeCb}" var="type"  varStatus="status">
						<option value="${type.CODE}"  <c:if test="${type.CODE eq agencyType}">selected</c:if>>${type.CNAME}</option>
				 	</c:forEach>
		  	</select>
		</td>
		<th>파 트</th>
		<td>
			<select name="part" id="part">
				<option value = "">전체</option>
					<c:forEach items="${partCb}" var="agcPart"  varStatus="status">
						<option value="${agcPart.CODE}"  <c:if test="${agcPart.CODE eq part}">selected</c:if>>${agcPart.CNAME}</option>
				 	</c:forEach>
		  	</select>
		</td>
	</tr>
	<tr>		
		<th>지 역</th>
		<td>
			<select name="agencyArea" id="agencyArea">
				<option value = "">전체</option>
					<c:forEach items="${agencyAreaCb}" var="agcArea"  varStatus="status">
						<option value="${agcArea.CODE}"  <c:if test="${agcArea.CODE eq agencyArea}">selected</c:if>>${agcArea.CNAME}</option>
				 	</c:forEach>
		  	</select>
		</td>
		<th>담당자</th>
		<td>
			<select name="manager"  id="manager">
				<option value = "">전체</option>
					<c:forEach items="${mngCb}" var="mng"  varStatus="status">
						<option value="${mng.MANAGER}"  <c:if test="${mng.MANAGER eq manager}">selected</c:if>>${mng.MANAGER} 담당</option>
				 	</c:forEach>
		  	</select>
		</td>
		<th>지국장</th>
		<td>
			<input type="text" id="opName2" name="opName2" maxlength="10"  value="<c:out value="${opName2}"/>"  style="width: 100px; vertical-align: middle;" />
		</td>
		<th>지국명</th>
		<td>
			<input id="txt" name="txt" type="text"  maxlength="10"  value="<c:out value="${txt}"/>"  style="width: 100px; vertical-align: middle;" />
		</td>
	</tr>
	<tr>
		<td colspan="8" style="border:0;">
			<div style="float: right;">
				<span>발송 예약 메일 건수 : <span id="mailingCount"></span>건</span>&nbsp;&nbsp;&nbsp;&nbsp;
				<span class="btnCss2"><a class="lk2" href="#" id="search_btn">조회</a></span>&nbsp;
				<span class="btnCss2"><a class="lk2" href="#" id="sendMail_btn">메일전송</a></span>
			</div>
		</td>
	</tr>
</table>
</form>

<form id="sendForm" name="sendForm" action="" method="post">
	<input type="hidden" name="year" value="${year}"/>
	<input type="hidden" name="month" value="${month}"/>
	<input type="hidden" name="boseq" value=""/>
</form>
<div>	
	<table class="tb_list_a_5" style="width: 1020px">
		<colgroup>
			<col width="20px">
			<col width="115px"/>
			<col width="120px"/>
			<col width="95px"/>
			<col width="120px"/>
			<col width="130px"/>
			<col width="90px"/>
			<col width="100px"/>
			<col width="200px"/>
			<col width="90px"/>
		</colgroup>
		<tr>
			<th><input type="checkbox" id="controll" style="vertical-align: middle;"></th>
			<th>지국코드</th>
			<th>지국명</th>
			<th>월분</th>
			<th>부서</th>
			<th>구분</th>
			<th>지역</th>
			<th>담당자</th>
			<th>이메일주소</th>
			<th>전송횟수</th>
		</tr>
	</table>
	<div id="xlist" style="padding-left:14px;width:1020px;">
		<table class="tb_list_a" width="100%">
			<colgroup>
				<col width="20px">
				<col width="113px"/>
				<col width="120px"/>
				<col width="95px"/>
				<col width="122px"/>
				<col width="130px"/>
				<col width="90px"/>
				<col width="100px"/>
				<col width="189px"/>
				<col width="74px"/>
			</colgroup>
			<c:forEach items="${jidaeDataList}" var="list" varStatus="i">
			<tr>
				<td><input type="checkbox" id="boSeq${i.index}" name="boSeq${i.index}" value="${list.BOSEQCODE}" <c:if test="${list.ISEMAIL == 'N'}">disabled="disabled"</c:if>/></td>
				<td>${list.BOSEQCODE}</td>
				<td>${list.BOSEQNM}</td>
				<td>${list.YYMM}</td>
				<td>${list.AREA1_NM }</td>
				<td>${list.TYPE_NM }</td>
				<td>${list.ZONE_NM }</td>
				<td>${list.MANAGER }</td>
				<td>${list.JIKUK_EMAIL}</td>
				<td>${list.MAIL_COUNT}</td>
			</tr>
			</c:forEach>
		</table>
	</div>
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