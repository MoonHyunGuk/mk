<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet">
<style type="text/css">
	.box_Popup{width: auto; padding: 10px;}
	.subTitle{
		font-family: NanumGothicWeb,dotum,Helvetica,sans-serif;
		font-weight: 900; font-size: 16px; letter-spacing: -1px; padding-bottom: 10px;}
	.tb_search {margin:0 auto; text-align:center; border-collapse:collapse; font:normal 12px Gulim, "굴림", Verdana, Geneva; }
	.tb_search th, .tb_search td {padding:8px 1px; }
	.tb_search th {text-align:center; border:1px solid #e5e5e5; background-color: #f9f9f9; font-weight: bold/*#e48764*//*#e16536 */;}
	.tb_search td {text-align:left; border:1px solid #e5e5e5; background-color: #fff; padding-left: 10px;}
	ul.tabs {
		margin: 0; padding: 0; float: left; list-style: none; height: 32px; border-bottom: 1px solid #eee; border-left: 1px solid #eee; width: 100%;
	    font-family:"dotum"; font-size:12px;
	}
	ul.tabs li {
	    float: left; text-align:center; cursor: pointer; width:82px; height: 31px; line-height: 31px; border: 1px solid #eee; border-left: none;
	    font-weight: bold; background: #f9f9f9; overflow: hidden; position: relative;
	}
	ul.tabs li.active {background: #FFFFFF; border-bottom: 1px solid #FFFFFF; color:darkred;}
	#container {width: 500px; margin-top: 10px;}
	.tab_container {border: 1px solid #eee; border-top: none; clear: both; float: left; width: 500px; background: #FFFFFF; margin-bottom: 10px;}
	.tab_content {padding: 5px; font-size: 12px; display: none; margin: 20px 10px;}
	.tab_content .tabValue {width: 300px;}
	.tab_content p {margin-top: 5px; clear: both;}
	.tab_content img {vertical-align: middle; border: 0; margin-left: 10px;}
	.tab_container .tab_content ul {width:100%; margin:0px; padding:0px;}
	.tab_container .tab_content ul li {padding:5px; list-style:none;}
	.clear {clear:both;}

	#box_list {width: 502px;}
	#box_list > p {text-align:left; font:normal 11px Gulim, "굴림", Verdana, Geneva;}
	#box_list > p > a {color: blue; font-weight: bold;}
	.tb_list_a_5 {text-align:center; border-collapse:collapse; font:normal 12px Gulim, "굴림", Verdana, Geneva; width: 520;}
	.tb_list_a_5 th {text-align:center; border:1px solid #eee; background-color: #f9f9f9; font-weight: bold; padding:5px 1px;}
	.tb_list_a_5 td {text-align:center; border:1px solid #eee; padding:5px 1px;}
	

</style>
<script type="text/javascript">
	$(function () {
		$("#prcssDiv").hide();
	    $(".tab_content").hide();

	    if($("#searchType").val() == null || $("#searchType").val() == "" ){
		    $(".tab_content:first").show();
		    $("#box_list").remove();
	    }else{
	    	var tabId = "tab"+$("#searchType").val();
	    	$("#"+tabId).show();    	
	        $("ul.tabs li").removeClass("active").css("color", "#333");
	    	$("[rel="+tabId+"]").addClass("active").css("color", "darkred");
	    };
	    
	    $("ul.tabs li").click(function () {
	        $("ul.tabs li").removeClass("active").css("color", "#333");
	        $(this).addClass("active").css("color", "darkred");

	        $(".tab_content").hide();
			$("#searchType").val($(this).attr("rel").replace("tab", ""));
	        var activeTab = $(this).attr("rel");
	        $("#" + activeTab).fadeIn();
	        $(".tabValue").val("");
	        $(".tabValue").focus();
	        $("#box_list").remove();
	    });
	    
	    $(".tabValue").bind("keydown", function(e){
            if(e.keyCode == 13){
            	searchAddr();
                return;
            }
        });

	});

	function searchAddr(){
        $("#pageNo").val(1);
		$("#prcssDiv").show();
		$("#addrSearchForm").submit();
	}

	//페이징
	function moveTo(where, seq){
		$("#pageNo").val(seq);
		$("#prcssDiv").show();
		$("#addrSearchForm").submit();
	}
	
	function validate(){
		if(!$("#searchValue").val()) {
			alert("검색어를 입력해 주세요");
			return;
		}
	}
	
	function setAddr(zip , addr , newAddr, bdNm, dbMngNo){
		
		window.opener.setAddr(zip , addr , newAddr, bdNm, dbMngNo);
		window.close();

		/*
		$(opener.document).find('#dlvZip').val(zip);
		$(opener.document).find('#dlvAdrs1').val(addr);
		$(opener.document).find('#dlvAdrs3').val(newAddr);
		$(opener.document).find('#dlvAdrs2').val(bdNm);*/
		
	}
	
</script>
<title>주소찾기</title>
</head>
<body>
<form id="addrSearchForm" name="addrSearchForm" action="/reader/subscriptionForm/searchNewAddr.do" method="post" target="_self" enctype="UTF-8">
	<input id="searchType" name="searchType" type="hidden" value="${searchType}"/>
	<input type="hidden" id="pageNo" name="pageNo" value="${param.pageNo}" />

	<!-- 팝업 DIV -->
	<div class="box_Popup">
		<!-- 타이틀 DIV -->
		<div style="padding-left: 5px; padding-bottom: 5px; border-bottom:7px solid #f68600;"> 
			<span class="subTitle">주소찾기</span>
		</div>
		<!--// 타이틀 DIV -->

		<!-- 조회조건 DIV -->
		<div id="container">
		    <ul class="tabs">
		        <li class="active" rel="tab1">도로명검색</li>
		        <li rel="tab2">건물명검색</li>
		        <li rel="tab3">지번검색</li>
		    </ul>
		    <div class="tab_container">
		        <!-- #tab1 -->
		        <div id="tab1" class="tab_content">
					<input type="text" name="searchValue1" id="searchValue1" class="tabValue" value="<c:if test="${searchType eq 1}">${searchValue}</c:if>"/>
					<a href="#" onclick="searchAddr();"><img src="/images/bt_search.gif"/></a>
					<p>* 새주소검색은 도로명 기준으로 검색됩니다.   예) 충무로 2</p>
		        </div>
		        <!-- #tab2 -->
		        <div id="tab2" class="tab_content">
					<input type="text" name="searchValue2" id="searchValue2" class="tabValue" value="<c:if test="${searchType eq 2}">${searchValue}</c:if>"/>
					<a href="#" onclick="searchAddr();"><img src="/images/bt_search.gif"/></a>
					<p>* 건물명으로 검색하세요.   예) 필동 매일경제신문사, 충무로 매일경제신문사</p>
		        </div>
		        <!-- #tab3 -->
		        <div id="tab3" class="tab_content">
					<input type="text" name="searchValue3" id="searchValue3" class="tabValue" value="<c:if test="${searchType eq 3}">${searchValue}</c:if>"/>
					<a href="#" onclick="searchAddr();"><img id="btnS" src="/images/bt_search.gif"/></a>
					<p>* 지번검색은 동,면을 기준으로 검색됩니다.</p>
					<p>* 번지까지 입력하시면 더욱 정확합니다.   예) 필동1가 51-5</p>
		        </div>
		    </div>
		</div>
	    <!-- .tab_container -->
		<!--// 조회조건 DIV -->
		
		<!-- // 리스트 DIV -->
		<div class="clear" id="box_list">
			<c:if test="${empty newAddrList}">
				<center><p>조회된 데이터가 없습니다.</p></center>
				<p>지번정보가 정확하지 않거나, 도로명 주소데이터가 없는 경우 조회 되지 않을 수 있습니다.</p>
				<p><a target="_blank" href="http://www.juso.go.kr/openIndexPage.do"><span style="font-weight: bold; color: blue; font-size: 1.4em; vertical-align: middle;">도로명주소 안내 시스템</span>&nbsp;<img src="/images/btn_go_dirc.gif" alt="바로가기" style="vertical-align: middle;"></a></p>
			</c:if>
			<c:if test="${not empty newAddrList}">
				<p>총 <c:out value="${totalCount}"/>건</p>
				<table class="tb_list_a_5 clear">
					<colgroup>
						<col width="60px">
						<col width="280px">
						<col width="180px">
					</colgroup>
					<tr>
						<th>우편번호</th>
						<th>도로명 주소</th>
						<th>지  번</th>
					</tr>
					<c:forEach items="${newAddrList}" var="list" varStatus="i">
					<tr class="mover" onclick="setAddr('${list.ZIP_CD}', '${list.ADDR}', '${list.ROADNM}', '${list.SGG_BD_NM}', '${list.BD_MNG_NO}')">
						<td style="text-align:center;">${fn:substring(list.ZIP_CD, 0, 3)}-${fn:substring(list.ZIP_CD, 3, 6)}</td>
						<td style="text-align:left;">${list.ROADNM}</td>
						<td style="text-align:left;">${list.ADDR}<c:if test="${!empty list.SGG_BD_NM}">, ${list.SGG_BD_NM}</c:if></td>
					</tr>
					</c:forEach>
				</table>
				<%@ include file="/common/paging.jsp"%>
			</c:if>
		</div>
	</div>
	<!--// 팝업 DIV -->
</form>
<div id="prcssDiv"  class="loingProcessDiv"><div><img src="/images/process4.gif"/></div></div>
</body>
</html>