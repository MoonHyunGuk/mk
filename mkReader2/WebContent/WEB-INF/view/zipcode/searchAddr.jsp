<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>매일경제 독자 프로그램</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet">
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
/**
 * 자세히 보기 
 */
function fn_chgJikuk(lwDngCd,bdMngNo, boseq,subSeq,boseqNm){
	var fm = document.getElementById("changeForm");

	var left = (screen.width)?(screen.width - 250)/2 : 10;
	var top = (screen.height)?(screen.height - 240)/2 : 10;
	var winStyle = "width=250,height=240,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=0";
	newWin = window.open("", "modifyVeiw", winStyle);
	newWin.focus();
	
	fm.target = "modifyVeiw";
	fm.lwDngCd.value = lwDngCd;
	fm.bdMngNo.value = bdMngNo;
	fm.boseq.value = boseq;
	fm.boseqNm.value = boseqNm;
	fm.subSeq.value = subSeq;
	fm.action = "/zipcode/changJikukView.do";
	fm.submit();
}

function moveTo(where,seq){
	jQuery("#pageNo").val(seq);
	jQuery("#frm").attr("target","_self").attr("action","./searchAddr.do").submit();
};

jQuery(document).ready(function($){
	$("#prcssDiv").hide();
	jQuery("input:text").each(function(){
		jQuery(this).keypress(function(event){
			if(event.keyCode == 13){
				fn_search(jQuery(this).attr("id").substring(jQuery(this).attr("id").length-1))
			}
		});
	});
	
	fn_search = function(type){
		if(jQuery("#keyword"+type).val() == ""){
			alert("검색어를 입력해 주세요.");
			jQuery("#keyword"+type).focus();
			return;
		}
		jQuery("input:text").each(function(){
			if(jQuery(this).attr("id") != "keyword" + type){
				jQuery(this).val("");
			}
		});
		jQuery("#type").val(type);
		jQuery("#pageNo").val(1);
		jQuery("#frm").attr("action","./searchAddr.do").submit();
		jQuery("#prcssDiv").show();
	};
	
});
</script>
</head>
<body>
<form id="changeForm" name="changeForm" method="post">
	<input type="hidden" id="lwDngCd" name="lwDngCd" value="" />
	<input type="hidden" id="bdMngNo" name="bdMngNo" value="" />
	<input type="hidden" id="boseq" name="boseq" value="" />
	<input type="hidden" id="boseqNm" name="boseqNm" value="" />
	<input type="hidden" id="subSeq" name="subSeq" value="" />
</form>
<div style="width: 1240px; margin: 0 auto; overflow: hidden;">
	<div style="width: 1200px; text-align: left; padding: 20px 0 10px 0 ; border: 0px solid red; overflow: hidden;"><b>지국찾기 -  </b>동(읍,면)으로 검색</div>
	<form id="frm" name="frm" method="post">
	<input type="hidden" id="type" name="type" value="${type}" />
	<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />
		<div style="width: 1205px; padding: 10px; border: 1px solid #e5e5e5; text-align: center; overflow: hidden;"> 
			<img src="/images/i.gif" width="9" height="9" border="0"> <b>지국명</b>
			<input type="text" id="keyword1" name="keyword1" size="26" value="${keyword1}"style="font-size:9pt; vertical-align: middle; ime-mode:active;">
			<img src="/images/bt_search.gif" style="border-style:none; vertical-align: middle;cursor:pointer;" onclick="fn_search('1');"/>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<img src="/images/i.gif" width="9" height="9" border="0"> <b>지번주소</b>
			<input type="text" id="keyword2" name="keyword2" size="26" value="${keyword2}" style="font-size:9pt; vertical-align: middle; ime-mode:active;">
			<img src="/images/bt_search.gif" style="border-style:none; vertical-align: middle;cursor:pointer;" onclick="fn_search('2');"/>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<img src="/images/i.gif" width="9" height="9" border="0"> <b>도로명주소</b>
			<input type="text" id="keyword3" name="keyword3" size="26" value="${keyword3}" style="font-size:9pt; vertical-align: middle; ime-mode:active;">
			<img src="/images/bt_search.gif" style="border-style:none; vertical-align: middle;cursor:pointer;" onclick="fn_search('3');"/>
		</div>
	</form>
	<!-- 조회결과 시작 -->
	<br/>
	<div style="float: left; width: 600px; border: 0px solid green;">
		<table class="tb_list_a" style="width: 580px; ">
			<colgroup>
				<col width="70px">
				<col width="102px">
				<col width="60px">
				<col width="320px">
			</colgroup> 
			<tr>
			    <th>지국명</th>
			    <th>연락처</th>
			    <th>우편번호</th>
			    <th>주 &nbsp;소</th>
			</tr>
		</table>
		<div style="width: 580px; border: 0px solid red;overflow:scroll;height:670px; margin: 0 auto;">
			<table class="tb_list_a" style="width: 563px;">
				<colgroup>
					<col width="70px">
					<col width="102px">
					<col width="60px">
					<col width="303px">
				</colgroup> 
				<c:if test="${fn:length(resultList) == 0}">
				<tr>
					<td colspan="4" style="text-align: center; height: 80px;">찾으시는 지국이 없습니다.</td>
				</tr>
				</c:if>
				<c:set var="checkRow2" value="0"/>
				<c:set var="beforeSerial" value=""/>
				<c:set var="beforeJikuk_tel" value=""/>
				<c:forEach items="${resultList}" var="result">
					<tr>
					<c:if test="${result.SERIAL == beforeSerial && result.JIKUK_TEL == beforeJikuk_tel}">
						<c:set var="checkRow2" value="${checkRow2 + 1}"/>
					</c:if>
					<c:if test="${result.SERIAL != beforeSerial || result.JIKUK_TEL != beforeJikuk_tel}">
						<c:set var="checkRow2" value="0"/>
					</c:if>
					<c:if test="${checkRow2 == 0}">
						<td rowspan="${result.PARTCNT2}" valign="top">
							<c:if test="${result.SUBNAME != NULL}">
								${result.NAME}(${result.SUBNAME})<br/>(${result.SERIAL})
							</c:if>
							<c:if test="${result.SUBNAME == NULL}">
								${result.NAME}<br/>(${result.SERIAL})
							</c:if>
						</td>
						<td rowspan="${result.PARTCNT2}" valign="top"><b>${result.JIKUK_TEL}</b><br>(${result.JIKUK_HANDY})</td>
					</c:if>
					<td valign="top">${result.ZIP}</td>
					<td style="text-align: left;">&nbsp;${result.TXT}</td>
					<c:set var="beforeSerial" value="${result.SERIAL}"/>
					<c:set var="beforeJikuk_tel" value="${result.JIKUK_TEL}"/>
				</tr>
				</c:forEach>
			</table>
		</div>
	</div>
	<div style="float: left; width: 630px; border: 0px solid green">
		<table class="tb_list_a" style="width: 620px;">
			<colgroup>
				<col width="60px">
				<!-- <col width="102px"> -->
				<col width="60px">
				<col width="220px">
				<col width="220px">
				<col width="60px">
			</colgroup> 
			<tr>
			  <th>지국명</th>
			     <!-- <th>연락처</th>-->
			    <th>우편번호</th>
			    <th>지번주소</th>
			    <th>도로명주소</th>
			    <th>지국변경</th>
			</tr>
			<c:if test="${fn:length(addressList) == 0}">
				<tr>
					<td colspan="5" style="text-align: center; height: 80px;">찾으시는 지국이 없습니다.</td>
				</tr>
			</c:if>
			<c:set var="checkRow2" value="0"/>
			<c:set var="beforeSerial" value=""/>
			<c:forEach items="${addressList}" var="address">
				<tr>
				<c:if test="${address.boseq == beforeSerial}">
					<c:set var="checkRow2" value="${checkRow2 + 1}"/>
				</c:if>
				<c:if test="${address.boseq != beforeSerial}">
					<c:set var="checkRow2" value="0"/>
				</c:if>
				<!--c:if test="${checkRow2 == 0}"-->
					<td valign="top">
							${address.boseqnm}<c:if test="${address.bunkukname != NULL}">(${address.bunkukname})</c:if><br/>(${address.boseq})
					</td>
				<!--/c:if-->
				<td valign="top">${address.zip_cd}</td>
				<td style="text-align: left;">&nbsp;${address.beopjeong_text}</td>
				<td style="text-align: left;">&nbsp;${address.road_text}</td>
				<td>
					<img alt="지국변경" src="/images/ico_search2.gif" onclick="fn_chgJikuk('${address.beopjeongdong_code}','${address.building_code}','${address.boseq}','${address.bunkukcd}','${address.boseqnm}<c:if test="${address.bunkukname != NULL}">(${address.bunkukname})</c:if>' )" style="cursor: pointer; vertical-align: middle;"/>
				</td>
			</tr>
			<c:set var="beforeSerial" value="${address.boseq}"/>
			</c:forEach>
		</table>
		<%@ include file="/common/paging.jsp"%>
	</div>
</div> 
<br/>
<!-- processing viewer -->
<div id="prcssDiv"  class="loingProcessDiv"><div><img src="/images/process4.gif"/></div></div>
</body>
</html>