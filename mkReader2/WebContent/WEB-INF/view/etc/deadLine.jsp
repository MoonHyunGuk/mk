<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<style>
#xlist {
	width: 100%;
	height: 500px;
	overflow-y: scroll;
	overflow-x: none;
}
</style>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/ajaxUtil.js" charset="UTF-8"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
	//배달번호 조정 구역코드 전체 선택/해지
	function checkControll(){
		//전체선택 1 , 전체해제 2
		var getObj = document.getElementsByTagName("input");
		var count = 0;
		if($("controll").checked == true){
			 for(var i=0; i < getObj.length; i++){
		        if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("boSeq") > -1 ){
		        	$("boSeq"+count).checked = true;
		        	count++;
		        }
		    }
		}else{
			for(var i=0; i < getObj.length; i++){
		        if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("boSeq") > -1 ){
		        	$("boSeq"+count).checked = false;
		        	count++;
		        }
		    }
		}
	}
	
	//월마감 실행
	function executeDeadLine(){
		var fm = document.getElementById("deadLineForm");
		var getObj = document.getElementsByTagName("input");
		var count = 0;
		
		if(!confirm('월 마감 실행 시 많은 시간이 소요될 수도 있습니다.\n실행하시겠습니까?')){
			return false;
		}
		
		for(var i=0; i < getObj.length; i++){
			if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("boSeq") > -1 ){
				count++;
			}
		}
		
		fm.boSeqSize.value = count;
		fm.action="/etc/deadLine/executeDeadLine.do";
		fm.target="_self";
		fm.submit();
		jQuery("#prcssDiv").show();
	}
</script>
<!-- title -->
<div><span class="subTitle">월마감</span></div>
<!-- //title -->
<form id="deadLineForm" name="deadLineForm" action="" method="post">
<input type="hidden" id="boSeqSize" name="boSeqSize" value=""/>
<input type="hidden" id="curDate" name="curDate" value="${fn:substring(lastDeadLine[0].NOWSGYYMM,0,4) }${fn:substring(lastDeadLine[0].NOWSGYYMM,4,6) }20" />
<div style="width: 195px; float: left; padding-right: 10px;">
	<div id="xlist">
		<table class="tb_list_a" style="width: 175px">
			<colgroup>
				<col width="20px">
				<col width="60px">
				<col width="95px">
			</colgroup>
			<tr>
				<th><input type="checkbox" id="controll" name="controll" checked onclick="javascript:checkControll();" style="vertical-align: middle;"></th>
				<th>지국코드</th>
				<th>지국명</th>
			</tr>
			<c:forEach items="${agencyList }" var="list" varStatus="i">
			<tr>
				<td><input type="checkbox" id="boSeq${i.index }" name="boSeq${i.index }" value="${list.BOSEQ }" checked/></td>
				<td>${list.BOSEQ }</td>
				<td>${list.BONM }</td>
			</tr>
			</c:forEach>									
		</table>
	</div>
</div>
<div style="float: left; width: 200px;  padding-right: 10px;">
	<table class="tb_list_a" style="width: 200px">
		<tr>
			<th>마감작업내역</th>
		</tr>
		<tr>
			<td height="163" style="height: 163px; text-align: left;">
				<div style="padding-left: 10px;"><input type="checkbox" id="condition1" name="condition1" value="on" checked> 배달번호조정</div>
				<div style="padding: 10px 0 10px 10px"><input type="checkbox" id="condition2" name="condition2" value="on" checked> 미수생성</div>
				<div style="padding-left: 10px;"><input type="checkbox" id="condition3" name="condition3" value="on" checked> 통계계산</div>
			</td>
		</tr>
	</table>
</div>
<div  style="width: 300px; float: left;">
	<div style="font-weight: bold; padding-bottom: 5px">[월마감 정보]</div>
	<table class="tb_list_a_5" style="width: 300px">
		<colgroup>
			<col width="100px">
			<col width="200px">
		</colgroup>
		<tr>
			<th>최종마감월분</th>
			<td style="text-align: left; padding-left: 10px">${fn:substring(lastDeadLine[0].SGYYMM,0,4) }-${fn:substring(lastDeadLine[0].SGYYMM,4,6) }</td>
		</tr>
		<tr>
			<th>전월마감일자</th>
			<td style="text-align: left; padding-left: 10px">${lastDeadLine[0].REGDATE }</td>
		</tr>
		<tr>
			<th>현재사용월분</th>
			<td style="text-align: left; padding-left: 10px">${fn:substring(nowYYMMDD,0,4) }-${fn:substring(nowYYMMDD,4,6) }</td>
		</tr>
		<tr>
			<th>마감기준일자</th>
			<td style="text-align: left; padding-left: 10px">${fn:substring(lastDeadLine[0].NOWSGYYMM,0,4) }-${fn:substring(lastDeadLine[0].NOWSGYYMM,4,6) }-20</td>
		</tr>
		<tr>
			<th>미수생성월</th>
			<td style="text-align: left; padding-left: 10px"><input type="text" id="yymm" name="yymm" value="${fn:substring(yymm,0,6) }" maxlength="6"></td>
		</tr>
	</table>
	<div style="clear: both; padding-top: 10px;">
		<div><a href="javascript:executeDeadLine();"><img src="/images/bt_sil.gif" border="0" align="right"></a></div>
	</div>
</div>
<!-- progress 
<div id="progress" style="display:none">
	<img src="/images/progress.gif" ><br>
	잠시만 기다리십시오.<br>마감작업 처리 중 입니다.
</div>
-->
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
</form>