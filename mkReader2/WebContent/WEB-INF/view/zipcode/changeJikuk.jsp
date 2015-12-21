<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>매일경제 독자 프로그램</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet">
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel='stylesheet' type='text/css' href="/select2/select2.css"/>
<script type="text/javascript">
jQuery(document).ready(function($){
	var lwDngCd = "${lwDngCd}";
	var bdMngNo = "${bdMngNo}";
	var oldBoseq = "${boseq}";
	var oldSubSeq = "${subSeq}";
	var newBoseq = "";
	var newBoseqNm = "";
	var newSubSeq = "";
	
	$("#chgBoseq").select2({minimumInputLength: 1});
	
	jQuery("#changeBtn").click(function(){
		var url = "/zipcode/updateJikukCode.do";
		var date = new Date();
		var param = {oldBoseq:oldBoseq,newBoseq:newBoseq,newSubSeq:newSubSeq,lwDngCd:lwDngCd,bdMngNo:bdMngNo,currentDate:date.getTime()};
		if(oldBoseq == newBoseq && oldSubSeq == newSubSeq) {
			alert("같은 지국을 선택하였습니다. 확인해주세요.");
			return;
		}
		if(newBoseq == ""){
			alert("지국을 선택해 주세요");
			return;
		}
		if(!confirm("${boseqNm}지국에서 "+newBoseqNm+"지국으로 변경하시겠습니까?")){
			return;
		}
		jQuery.getJSON(url,param,function(data){
			if(data.flag == true){
				alert("지국 변경이 완료되었습니다.");
			}else{
				alert("내부 오류로 지국변경이 완료되지 않았습니다. 다시 시도해 주십시요.");
			}
			opener.fn_search(opener.document.getElementById("type").value);
			window.close();
		});
	});
	
	jQuery("#chgBoseq").change(function(){
		var tempSeq = $(this).val();
		newBoseq = tempSeq.split("_")[0];
		newSubSeq = tempSeq.split("_")[1];
		newBoseqNm = $(this).children("option:selected").text();
	});
});
</script>
</head>
<body>
<div style="width: 210px; margin: 0 auto; overflow: hidden; padding: 15px">
	<div style="background-color: #f68600; width: 184px; padding: 8px 20px 5px 10px; font-weight: bold;">지국변경</div>
	<div style="width: 200px; text-align: left;  border: 2px solid #f68600; overflow: hidden; padding: 30px 5px">
		<div style="border: 1px solid; padding: 10px 5px; text-align: center; width: 170px; margin: 0 auto">
			<b>현재지국명 : ${boseqNm }</b>
		</div>
		<div style="padding-top: 15px; width: 180px; margin: 0 auto;">
			<select id="chgBoseq" name="chgBoseq" style="width: 110px; padding: 3px; vertical-align: middle;">
				<option value="">지국선택</option>
				<c:forEach items="${agencyList}" var="list" varStatus="status">
					<option value="${list.AGENCYID}_${list.SUBSEQ}">${list.AGENCYNM}</option>
				</c:forEach>
			</select>
			<span class="btnCss2"><a class="lk2" id="changeBtn">변경</a></span>
		</div>
	</div>
</div> 
</body>
</html>