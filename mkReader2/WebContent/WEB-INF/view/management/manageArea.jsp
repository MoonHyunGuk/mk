<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel='stylesheet' type='text/css' href="/select2/select2.css"/>
<script type="text/javascript" src="/nprogress/nprogress.js"></script>
<link rel='stylesheet' type='text/css' href="/nprogress/nprogress.css"/>
<script type="text/javascript">
var $j = jQuery.noConflict();
$j(document).ready(function($){
	// 지국명 자동완성 적용(select2.js)
	//$j("#rightBoseq").select2({minimumInputLength: 1});

	// 지국변경시 지국관할 주소 자동 검색
	$j("#rightBoseq").change(function(){
		if($j("#rightBoseq").val() != ""){
			searchAddr("tbl2");
		}else{
			return;
		}
	});

	// 클릭으로 지국 지정
	$j(".moveTd").on('click', moveTr);

	// 버튼으로 지정
	$j("#moveRight").click(function(){
		// 대상지국이 없는 경우 리턴
		if($j("#rightBoseq").val() == ""){
			alert("지정할 대상 지국이 없습니다.");
			return;
		}

		$j("#tbl1").find("input:checkbox[name='selChk']:checked").each(function(){
			// 지국업데이트 ajax 호출
			updateMngJikuk($j(this).parent().parent().children().find("input:hidden[name='bdMngNo']").val(), $j("#rightBoseq").val());
			// table 이동
			$j("#tbl2").find(".trHeader").after($j(this).prop("checked", false).parent().parent().css($j(this).parent().parent().is(".tbl1")?{"background-color":"#f5f5f5"}:{"background-color":""}));
		});
		
		// 이동 후 체크 해제
		$j(".allChk").prop("checked", false);
	});

	// 버튼으로 지국 지정 취소
	$j("#moveLeft").click(function(){
		// 체크된 tr 지국지정 취소
		$j("#tbl2").find("input:checkbox[name='selChk']:checked").each(function(){
			// 지국업데이트 ajax 호출
			updateMngJikuk($j(this).parent().parent().children().find("input:hidden[name='bdMngNo']").val(), "");
			// table 이동
			$j("#tbl1").find(".trHeader").after($j(this).prop('checked', false).parent().parent().css($j(this).parent().parent().is(".tbl2")?{"background-color":"#f5f5f5"}:{"background-color":""}));			
		});

		// 이동 후 체크 해제
		$j(".allChk").prop("checked", false);
	});

	// 전체체크 박스선택
	$j(".allChk").click(function(){
		var curTable = "#"+$j(this).parent().parent().parent().parent().attr("id");
		$j(curTable).find("input:checkbox[name='selChk']").prop("checked", this.checked);
	});

	// 엔터키 입력시 조회
	$("#searchValue").keydown(function(e){
        if(e.keyCode == 13){
        	if($("#searchValue").val() == ""){
        		$j("#tbl1").find("tr:not(.trHeader)").remove();
        	}else{
        		searchAddr("tbl1");
        	}
        }
    });
	
	// 조회버튼 클릭시 조회
	$("#searchBtn").click(function(){
    	if($("#searchValue").val() == ""){
    		$j("#tbl1").find("tr:not(.trHeader)").remove();      		
    	}else{
        	searchAddr("tbl1");
    	}
	});

});

/**
 * 단건 이동
 * 클릭으로 지국 지정
 */
function moveTr(){
	var curTable = $j(this).parent().parent().parent().attr("id");

	// 현재 테이블 기준으로 지국지정인지 지정취소인지 판단
	if(curTable=="tbl1"){
		// 대상 지국이 없는경우 리턴
		if($j("#rightBoseq").val() == ""){
			alert("지정할 대상 지국이 없습니다.");
			$j("#rightBoseq").focus();
			return;
		}

		// 지국업데이트 ajax 호출
		updateMngJikuk($j(this).parent().find("[name='bdMngNo']").val(), $j("#rightBoseq").val());
		// table 이동
		$j("#tbl2").find(".trHeader").after($j(this).parent().css($j(this).parent().is("."+curTable)?{"background-color":"#f5f5f5"}:{"background-color":""}));
	}else{
		// 지국업데이트 ajax 호출
		updateMngJikuk($j(this).parent().find("[name='bdMngNo']").val(), "");
		// table 이동
		$j("#tbl1").find(".trHeader").after($j(this).parent().css($j(this).parent().is("."+curTable)?{"background-color":"#f5f5f5"}:{"background-color":""}));
	}
}

/**
 * 주소 검색
 * 현재는 table 기준으로 주소 검색 과 지국검색 구분
 */
function searchAddr(tableId){
	var paramData;
	// 조회타입에 따라 조회 파라미터 설정
	if(tableId == "tbl1"){
		// 검색확인
		if(!checkValidAddr($j("#searchValue").val())){
			return;
		}

		paramData = "searchValue="+$j("#searchValue").val()+"&type="+tableId;
		
	}else{
		paramData = "boseq="+$j("#rightBoseq").val()+"&type="+tableId;
	}

	// ajax 호출
	$j.ajax({
		type   		: "POST",
		url    		: "/management/adminManage/searchMngArea.do",
		dataType 	: "json",
		data   		: paramData,
		beforeSend	: function () {
			// 로딩프레임 호출
			//NProgress.start();
			$j("#prcssDiv").show();
        },
		success		: function(data){
			// 테이블 내용 삭제
			$j("#"+tableId).find("tr:not(.trHeader)").remove();

			// 로우 생성(JSON)
			for(var i = 0; i < data.length; i++){
				var tmpTr = '<tr class="mover '+tableId+'"><td><input type="checkbox" name="selChk"></td>';
				tmpTr += '<td class="moveTd"><input type="hidden" name="bdMngNo" value='+data[i].BD_MNG_NO+'>'+data[i].ZIP_CD+'</td>';
				tmpTr += '<td class="moveTd leftTd">'+data[i].ADDR+'</td>';
				tmpTr += '<td class="moveTd leftTd">'+data[i].ROADNM+'</td></tr>';
				$j("#"+tableId).find(".trHeader").after(tmpTr);
			}

			// 클릭 이벤트 재설정
			$j(".moveTd").off('click', moveTr);
			$j(".moveTd").on('click', moveTr);
		},
		complete 	: function () {
			// 로딩 프레임제거
			//NProgress.done();
			$j("#prcssDiv").hide();
        },
		error		:function(request,status,error){
		    alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
}

/**
 * 관할지국 업데이트
 */
function updateMngJikuk(bdMngNo, boseq){
	// ajax 호출
	$j.ajax({
		type		: "POST",
		url			: "/management/adminManage/updateMngJikuk.do",
		dataType 	: "json",
		async  		: false,
		data   		: "bdMngNo="+bdMngNo+"&boseq="+boseq,
		beforeSend	: function () {
			// 로딩프레임 호출
			NProgress.start();
        },
		success		: function(data){
		},
		complete	: function () {
			// 로딩 프레임제거
			NProgress.done();
			//$j("#prcssDiv").hide();
        },
		error		:function(request,status,error){
		    alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
}

// 검색주소 유효성 체크
function checkValidAddr(checkSearchStr){
	var lotStr1, lotStr2;
	if(checkSearchStr.indexOf(" ") > 0){
		if(checkSearchStr.indexOf("-") > 0){
			lotStr1 = checkSearchStr.substring(checkSearchStr.indexOf(" "), checkSearchStr.indexOf("-"));
			if(!checkComplexStr(lotStr1)){
				return false;
			}
			lotStr2 = checkSearchStr.substring(checkSearchStr.indexOf("-")+1);
			if(!checkComplexStr(lotStr2)){
				return false;
			}
		}
	}
	
	return true;
}

// ','와 '~'이 동시에 존재 하는 경우
function checkComplexStr(checkComplexStr){
	if(checkComplexStr.indexOf(",") > 0){
		if(checkComplexStr.indexOf("~") > 0){
			alert("올바른 검색 조건이 아닙니다. \n ','와 '~'은 동시에 사용할수 없습니다.");
			return false;
		}
	}
	return true;
}

</script>

<style type="text/css">
	.moveTd {cursor: w-resize ;}
	.leftTd {text-align: left !important; padding-left: 5px !important;}
	
	
</style>

<div style="padding-bottom: 15px;"> 
	<span class="subTitle">지국별 지역할당</span>
</div>

<form id="mngAreaForm" name="mngAreaForm" action="/management/adminManage/searchMngArea.do" method="post" target="_self" enctype="UTF-8">

<div>
	<!-- 좌측정렬 div -->
	<div style="width: 1000px; padding-bottom: 10px; float: left">
		<!-- 미지정 div (left) -->
		<div class="area" style="width: 450px; float: left;">
			<!-- 주소조회 -->
			<table class="tb_search" style="width: 450px;">
				<colgroup>
					<col width="450px">
				</colgroup>
				<tr style="height: 40px;">
					<td>
						<input type="text" name="searchValue" id="searchValue" style="width: 300px;vertical-align: middle;"/>&nbsp; &nbsp;
						<a href="#"><img id="searchBtn" style="border: 0; vertical-align: middle;" src="/images/bt_search.gif"/></a>
					</td>
				</tr>
			</table>
			<!--// 주소조회 -->

			<!-- 주소조회결과 -->
			<table class="tb_list_a" id="tbl1" style="width: 450px; margin-top: 10px;">
				<colgroup>
					<col width="20px">
					<col width="70px">
					<col width="180px">
					<col width="180px">
				</colgroup>
				<tr class="trHeader">
					<th><input type="checkbox" class="allChk"></th>
					<th>우편번호</th>
					<th>지번</th>
					<th>도로명주소</th>
				</tr>
			</table>
			<!--// 주소조회결과 -->
		</div>
		<!--// 미지정 div (left) -->

		<!-- 이동 버튼 div (center) -->
		<div style="width: 100px; float: left; text-align: center; padding-top: 200px;">
			<input id="moveRight" type="button" value=" &gt; "/><br/><br/>
			<input id="moveLeft" type="button" value=" &lt; "/>
		</div>
		<!--// 이동 버튼 div (center) -->

		<!-- 지국관할지역 div (right) -->
		<div class="area" style="width: 450px; float: right;">
			<!-- 지국관할지역조회 -->
			<table class="tb_search" style="width: 450px;">
				<colgroup>
					<col width="100px">
					<col width="350px">
				</colgroup>
				<tr style="height: 40px;">
					<th>대상지국</th>
					<td>
						<select type="text" name="rightBoseq" id="rightBoseq" style="vertical-align: middle; width:80px;">					
							<option value=""></option>
							<c:forEach items="${agencyAllList}" var="list">
								<option value="${list.SERIAL}">${list.NAME}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
			</table>
			<!--// 지국관할지역조회 -->

			<!-- 지국관할지역조회결과 -->
			<table class="tb_list_a" id="tbl2" style="width: 450px; margin-top: 10px;">
				<colgroup>
					<col width="20px">
					<col width="70px">
					<col width="180px">
					<col width="180px">
				</colgroup>
				<tr class="trHeader">
					<th><input type="checkbox" class="allChk"></th>
					<th>우편번호</th>
					<th>지번</th>
					<th>도로명주소</th>
				</tr>
			</table>
			<!--// 지국관할지역조회결과 -->

		</div>
		<!--// 지국관할지역 div (right) -->
	</div>
	<!--// 좌측정렬 div -->
</div>
<!-- processing viewer -->
<div id="prcssDiv"  class="loingProcessDiv" style="display: none"><div><img src="/images/process4.gif"/></div></div>
</form>