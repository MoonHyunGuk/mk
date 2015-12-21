<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ page import="com.mkreader.security.ISiteConstant" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel="stylesheet" type="text/css" href="/select2/select2.css"/>
<script type="text/javascript">
 function fn_search() {
	var fm = document.getElementById("fm");
	var chkSgType = document.getElementsByName("sgtype");
	var stopBoseq = document.getElementById("stopBoseq");
	var abcBoseq = document.getElementById("abcBoseq");
	var sgTypeList = ""; 
	
	//수금지국 확인 
	if(stopBoseq.value == '') {
		alert("수금가져올지국을 선택해주세요");
		stopBoseq.focus();
		return false;
	}
	
	//수금방법 확인 
	var isSgTypeChk = false;
	for(var i=0;i<chkSgType.length;i++){
		if(chkSgType[i].checked == true) {
			sgTypeList += chkSgType[i].value+",";   
			isSgTypeChk = true;
		}
	}
	
	if(!isSgTypeChk) {
		alert("수금방법을 선택해 주세요.");
		return false;
	} else {
		sgTypeList = sgTypeList.substring(0, sgTypeList.length-1);
	}
	
	//abc실사지국 확인 
	if(abcBoseq.value == '') {
		alert("abc실사지국을 선택해주세요");
		abcBoseq.focus();
		return false;
	}
  
	fm.target = "_self";
	fm.sgTypeList.value = sgTypeList;
	fm.action = "/management/abc/selectStopReader.do";
	fm.submit();
	jQuery("#prcssDiv").show();
 }
 
 /**
  *	체크박스 컨트롤
  **/
 function fn_chkboxControll() {
	var chkAllSugmReader = document.getElementById("chkAllSugmReader");
	var obj = document.getElementsByName("chkSugmReader");
	var totUprice = "";
	var totQty = "";
	var cutVal = [];
	 
	jQuery("#totUprice").empty();
	jQuery("#totQty").empty();
	 
	if(chkAllSugmReader.checked) {
		for(var i=0; i< obj.length; i++) {
			obj[i].checked = true;
			cutVal = obj[i].value.split("@");
			totUprice = Number(totUprice) +Number(cutVal[2]);
			totQty = Number(totQty) + Number(cutVal[3]);
		}
		jQuery("#totUprice").append("선택된 총단가금액 : "+totUprice+" 원");
		jQuery("#totQty").append("선택된 총부수 : "+totQty+" 부");
	} else {
		for(var i=0; i< obj.length; i++) {
			obj[i].checked = false;
		}
	}
 }
 
 function fn_sugm_export() {
	 var fm = document.getElementById("fm");
	 var obj = document.getElementsByName("chkSugmReader");
	 var cutVal = [];
	 var readnoList = "";
	 var selectedCnt = 0;
	 
	 for(var i=0; i< obj.length; i++) {
		if(obj[i].checked) {
			cutVal = obj[i].value.split("@");
			readnoList += cutVal[0] + ",";
			selectedCnt++;
		}
	}
	 
	 if(readnoList.length > 0) {
		 readnoList = readnoList.substring(0, readnoList.length-1);
	 } else {
		 alert("수금가져올 독자를 선택해주세요.");
		 return false;
	 }
	 
	 fm.target = "_self";
	 fm.selectedCnt.value = selectedCnt;
	 fm.readnoList.value = readnoList;
	 fm.action = "/management/abc/exportSugmData.do";
	 fm.submit();
 }
 
 /**
  * 수금카운트
  **/
 function fn_sumPrice() {
	var obj = document.getElementsByName("chkSugmReader");
	var totUprice = 0;
	var totQty = 0;
	var cutVal = [];
	 
	for(var i=0; i< obj.length; i++) {
		if(obj[i].checked) {
			cutVal = obj[i].value.split("@");
			totUprice = Number(totUprice) +Number(cutVal[2]);
			totQty = Number(totQty) + Number(cutVal[3]);
		}
	}
	
	jQuery("#totUprice").empty();
	jQuery("#totQty").empty();
	jQuery("#totUprice").append("선택된 총수금금액 : "+totUprice+" 원");
	jQuery("#totQty").append("선택된 총부수 : "+totQty+" 부");
 }
 
jQuery.noConflict();
jQuery(document).ready(function($){
	$("#stopBoseq").select2({minimumInputLength: 1});
	$("#abcBoseq").select2({minimumInputLength: 1});
});
</script>
<!-- title -->
<div><span class="subTitle">중지독자</span></div>
<!-- //title -->
<form name="fm" id="fm" method="post">
<!-- hidden values -->
<input type="hidden" name="sgTypeList" id="sgTypeList">
<input type="hidden" name="sugmReaderCnt" id="sugmReaderCnt" value="${sugmReaderCnt }" />
<input type="hidden" name="stopReaderCnt" id="stopReaderCnt" value="${stopReaderCnt }" />
<input type="hidden" name="arryStopReaderNo" id="arryStopReaderNo" value="${arryStopReaderNo }"  />
<input type="hidden" name="selectedCnt" id="selectedCnt" />
<input type="hidden" name="readnoList" id="readnoList" />
<!-- //hidden values -->
<div>
	<div style="border: 0px solid red; overflow: hidden;"> 
		<div class="box_gray_left" style="padding: 5px 0; width: 500px; float: left;">
			<span style="font-weight: bold; vertical-align: middle; font-size: 1.2em;">[수금가져올지국]</span>&nbsp;&nbsp;
			<div style="padding: 10px 0;">
				<div style="padding: 3px 0 4px 0">
					<span style="font-weight: bold; vertical-align: middle;">지국명</span>&nbsp;
					<select name="stopBoseq" id="stopBoseq" style="width: 100px; vertical-align: middle;">
						<option value=""> 선택</option>
						<c:forEach items="${agencyAllList }" var="list">
							<option value="${list.SERIAL }" <c:if test="${stopBoseq eq list.SERIAL}">selected="selected" </c:if>>${list.NAME } </option>
						</c:forEach>
					</select>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="checkbox" name="sgtype" id="sgtype1"  value="011"  style="vertical-align: middle;" <c:forEach items="${arrySgType }" var="chkVal" ><c:if test="${011 eq chkVal}">checked="checked" </c:if></c:forEach>>&nbsp;<span style="font-weight: bold; vertical-align: middle;">지로</span>&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="checkbox" name="sgtype" id="sgtype2"  value="013"  style="vertical-align: middle;" <c:forEach items="${arrySgType }" var="chkVal" ><c:if test="${013 eq chkVal}">checked="checked" </c:if></c:forEach>>&nbsp;<span style="font-weight: bold; vertical-align: middle;">통장입금</span>
				</div>
			</div>
		</div>
		<div style=" width: 50px; float: left; padding: 0; text-align: center;"> &nbsp; 
		</div>
		<div class="box_gray_left" style="padding: 5px 0; width: 450px;  float: left;">
			<span style="font-weight: bold; vertical-align: middle; font-size: 1.2em;">[abc실사지국]</span>&nbsp;&nbsp;
			<div style="padding: 10px 0;">
				<span style="font-weight: bold; vertical-align: middle;">지국명</span>&nbsp;
				<select name="abcBoseq" id="abcBoseq" style="width: 100px; vertical-align: middle;">
					<option value=""> 선택</option>
					<c:forEach items="${agencyAllList }" var="list">
						<option value="${list.SERIAL }" <c:if test="${abcBoseq eq list.SERIAL}">selected="selected" </c:if>>${list.NAME } </option>
					</c:forEach>
				</select>
				&nbsp;&nbsp;
				<span class="btnCss2"><a class="lk2" onclick="fn_search();">조회</a></span>&nbsp;
			</div>
		</div>
	</div>
	<br />
	<div style="width: 1050px; border: 0px solid; overflow: hidden;">
		<div style=" width: 500px; float: left;">
			<div style=" width: 500px; text-align: center; padding: 3px 0; font-size: 1.2em; font-weight: bold;">[수금가져올독자]</div>
			<div style=" width: 500px; text-align: right; padding-bottom: 3px" >
				<c:if test="${sugmReaderCnt ne null }">총 ${sugmReaderCnt } 개</c:if>
			</div>
			<table class="tb_list_a" style="width: 500px">
				<col width="50px" />
				<col width="60px" />
				<col width="213px" />
				<col width="80px" />
				<col width="97px" />
				<tr>
					<th><input type="checkbox" name="chkAllSugmReader" id="chkAllSugmReader"  onclick="fn_chkboxControll();" style="vertical-align: middle;"/></th>
					<th>수금방법</th>
					<th>독자명</th>
					<th>가입일</th>
					<th>수금된<br/>총금액</th>
				</tr>
			</table>
			<div style="width: 500px; height: 450px; overflow-x:none; overflow-y: scroll;">
				<table class="tb_list_a" style="width: 483px">
					<col width="50px" />
					<col width="60px" />
					<col width="213px" />
					<col width="80px" />
					<col width="80px" />
					<c:choose>
						<c:when test="${getSugmReaderList ne null }" >
							<c:forEach items="${getSugmReaderList }" var="list" varStatus="i">
								<tr>
									<td><input type="checkbox" name="chkSugmReader"  value="${list.READNO}@${list.SEQ}@${list.UPRICE}@${list.QTY}" style="vertical-align: middle;" onclick="fn_sumPrice();" /></td>
									<td>${list.SGTYPENM }</td>
									<td>${list.READNM }</td>
									<td>${list.INDT }</td>
									<td><fmt:formatNumber value="${list.TOTAMT}"  type="number" /></td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="5" style="text-align: center;">조회된 독자가 없습니다.</td>
							</tr>
						</c:otherwise>
					</c:choose>
				</table>
			</div>
			<div style="padding-top: 10px; text-align: center;"> 
				<span style="font-weight: bold; vertical-align: middle; color: red"><span id="totUprice"></span></span>&nbsp; &nbsp; &nbsp; 
				<span style="font-weight: bold; vertical-align: middle; color: red"><span id="totQty"></span></span>
			</div>
		</div>
		<div style=" width: 50px; float: left; padding: 0; text-align: center;">
			<br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
			<img alt="이동" src="/images/ico/ico_r_arrow.png" style="width: 30px; cursor: pointer;" onclick="fn_sugm_export();" title="이동" />
		</div>
		<div style=" width: 450px; float: left;">
			<div style=" width: 450px; text-align: center; padding: 3px 0; font-size: 1.2em; font-weight: bold;">[중지독자]</div>
			<div style=" width: 450px; text-align: right;  padding-bottom: 3px" >
				<c:if test="${stopReaderCnt ne null }">총 ${stopReaderCnt } 개</c:if>
			</div>
			<table class="tb_search" style="width: 450px">
				<col width="50px" />
				<col width="183px" />
				<col width="40px" />
				<col width="80px" />
				<col width="97px" />
				<tr>
					<th>No</th>
					<th>독자명</th>
					<th>부수</th>
					<th>확장일</th>
					<th>해지일</th> 
				</tr>
			</table>
			<div style="width: 450px; height: 450px; overflow-x:none; overflow-y: scroll;">
				<table class="tb_list_a" style="width: 433px">
					<col width="50px" />
					<col width="183px" />
					<col width="40px" />
					<col width="80px" />
					<col width="80px" />
					<c:choose>
						<c:when test="${stopReaderList ne null }" >
							<c:forEach items="${stopReaderList }" var="list" varStatus="i">
								<tr>
									<td>${i.count}</td>
									<td>${list.READNM }</td>
									<td>${list.QTY }</td>
									<td>${list.HJDT }</td>
									<td>${list.STDT }</td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="5" style="text-align: center;">조회된 독자가 없습니다.</td>
							</tr>
						</c:otherwise>
					</c:choose>
				</table>
			</div>
		</div>
	</div>
</div>
</form>
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