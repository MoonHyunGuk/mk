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
/**
 * 테이블 백업 이벤트
 */
function fn_backup() {
	var fm = document.getElementById("fm");
	var backupTableNm = document.getElementById("backupTableNm");
	
	if(backupTableNm.value == null || backupTableNm.value == "") {
		alert("백업테이블명을 입력해주세요.");
		backupTableNm.focus();
		return false;
	}
	
	if(!confirm("테이블백업을 진행하시겠습니까?")) {
		return false;
	}
	
	fm.target = "_self";
	fm.action = "/management/abc/tableBackup.do";
	fm.submit();
	jQuery("#prcssDiv").show();
}

/**
 * 조회버튼 이벤트
 */
function fn_search() {
	var fm = document.getElementById("fm");
	var abcBoseq = document.getElementById("abcBoseq");
	
	if(abcBoseq.value == null || abcBoseq.value == "") {
		alert("실사지국을 선택해주세요.");
		abcBoseq.focus();
		return false;
	}
	
	fm.target = "_self";
	fm.action = "/management/abc/dataSync.do";
	fm.submit();
}

/**
 * 데이터 삭제 이벤트
 */
function fn_dataDelete() {
	var fm = document.getElementById("fm");
	var abcBoseq = document.getElementById("abcBoseq");
	
	if(abcBoseq.value == null || abcBoseq.value == "") {
		alert("실사지국을 선택해주세요.");
		abcBoseq.focus();
		return false;
	}
	
	if(!confirm("데이터 삭제를 진행하시겠습니까?")) {
		return false;
	}
	
	fm.target = "_self";
	fm.action = "/management/abc/tableDataDelete.do";
	fm.submit();
	jQuery("#prcssDiv").show();
}

/**
 * 데이터 동기화 이벤트
 */
function fn_dataSync() {
	var fm = document.getElementById("fm");
	var abcBoseq = document.getElementById("abcBoseq");
	
	if(abcBoseq.value == null || abcBoseq.value == "") {
		alert("실사지국을 선택해주세요.");
		abcBoseq.focus();
		return false;
	}
	
	if(!confirm("데이터 동기화를 진행하시겠습니까?")) {
		return false;
	}
	
	fm.target = "_self";
	fm.action = "/management/abc/tableDataSync.do";
	fm.submit();
	jQuery("#prcssDiv").show();
}

jQuery.noConflict();
jQuery(document).ready(function($){
	$("#abcBoseq").select2({minimumInputLength: 1});
});
</script>
<!-- title -->
<div><span class="subTitle">데이터싱크</span></div>
<!-- //title -->
<form name="fm" id="fm" method="post">
<div>
	<!-- 백업 -->
	<div style="overflow: hidden; border-right: 1px solid #e5e5e5; width: 390px; margin-top: 10px; height: 540px; float: left;">
		<div style="padding: 5px 0 15px 0; width: 350px; text-align: center;">
			<span style="font-weight: bold; vertical-align: middle; font-size: 1.2em;">[독자/수금 테이블 백업]</span>
		</div>
		<div style="padding-bottom: 20px">
			<table class="tb_list_a" style="width: 350px;">
				<col width="50px">
				<col width="300px">
				<tr> 
					<th>No.</th>
					<th>테이블명</th>
				</tr>
			</table>
			<div style="width: 350px; height: 330px; overflow-y: scroll; margin: 0 auto">
				<table class="tb_list_a" style="width: 333px;">
					<col width="50px">
					<col width="283px">
					<c:forEach items="${dbTableList }" var="list" varStatus="i">
						<tr>
							<td>${i.count }</td>
							<td style="text-align: left;">&nbsp;&nbsp;${list.TNAME }</td>
						</tr>
					</c:forEach> 
				</table>
			</div>
		</div>
		<div class="box_white" style="width: 338px; padding: 10px 0 10px 10px; margin: 0 auto">
			<span style="font-weight: bold; vertical-align: middle;">백업테이블명</span>
			<input type="text" name="backupTableNm" id="backupTableNm" maxlength="15"  style="width: 200px; vertical-align: middle;" />
		</div>
		<div style="width: 350px; margin: 0 auto; text-align: center; padding: 20px 0 0 0">
			<span class="btnCss4" ><a class="lk3" onclick="fn_backup();">테이블 백업</a></span>
		</div>
	</div>
	<!-- //백업 -->
	<div style="float: left; overflow: hidden;">
		<div class="box_gray_left" style="padding: 10px 0; width: 600px; margin: 0 auto;">
			<span style="font-weight: bold; vertical-align: middle;">실사지국</span>&nbsp;
			<select name="abcBoseq" id="abcBoseq" style="width: 100px; vertical-align: middle;">
				<option value=""> 선택</option>
				<c:forEach items="${agencyAllList }" var="list">
					<option value="${list.SERIAL }" <c:if test="${abcBoseq eq list.SERIAL}">selected="selected" </c:if>>${list.NAME } </option>
				</c:forEach>
			</select>
			&nbsp;&nbsp;
			<span class="btnCss2"><a class="lk2" onclick="fn_search();">조회</a></span>&nbsp;
		</div>
		<!-- 데이터 삭제 -->
		<div style="float: left; width: 330px; overflow: hidden; border-right: 1px solid #e5e5e5; margin-top: 10px; height: 500px; float: left;">
			<div style="padding: 5px 0 10px 0; width: 300px; text-align: center;">
				<span style="font-weight: bold; vertical-align: middle;">[데이터 삭제]</span>
			</div>
			<br />
			<div class="box_white" style="width: 200px; padding: 10px 0 10px 10px; margin: 0 auto">
				<span style="font-weight: bold; vertical-align: middle;">독자리스트&nbsp;:&nbsp;<span id="readerCnt" >${readerCnt }</span> 명</span>
			</div>
			<br /><br />
			<div class="box_white" style="width: 200px; padding: 10px 0 10px 10px; margin: 0 auto">
				<span style="font-weight: bold; vertical-align: middle;">독자수금&nbsp;:&nbsp;<span id="readerCnt">${readerSugmCnt }</span> 개</span>
			</div>
			<div style="width: 300px; margin: 0 auto; text-align: center; padding: 20px 0 0 0">
				<span class="btnCss4" ><a class="lk3" onclick="fn_dataDelete();">데이터 삭제</a></span>
			</div>
		</div>
		<!-- //데이터 삭제 -->
		<!-- 데이터 동기화 -->
		<div style="float: left; width: 320px; overflow: hidden; margin-top: 10px; height: 500px; float: left;">
			<div style="padding: 5px 0 10px 0; width: 300px; text-align: center;">
				<span style="font-weight: bold; vertical-align: middle;">[데이터 동기화]</span>
			</div>
			<br />
			<div class="box_white" style="width: 200px; padding: 10px 0 10px 10px; margin: 0 auto">
				<span style="font-weight: bold; vertical-align: middle;">독자리스트&nbsp;:&nbsp;<span id="syncReaderCnt" >0</span> 명</span>
			</div>
			<br /><br />
			<div class="box_white" style="width: 200px; padding: 10px 0 10px 10px; margin: 0 auto">
				<span style="font-weight: bold; vertical-align: middle;">독자수금&nbsp;:&nbsp;<span id="syncReaderCnt">0</span> 개</span>
			</div>
			<div style="width: 300px; margin: 0 auto; text-align: center; padding: 20px 0 0 0">
				<span class="btnCss4" ><a class="lk3" onclick="fn_dataSync();">데이터 동기화</a></span>
			</div>
		</div>
		<!-- //데이터 동기화 -->
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