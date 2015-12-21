<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<style type="text/css">
ul.sort1{float:right;margin:0 13px 0 0;}
ul.sort1 li{float:left;display:block;color:#868686;font-size:11px;width:68px;text-align:center;cursor:pointer;height:22px;line-height:24px}
ul.sort1 li.person, ul.sort1 li.archive, ul.sort1 li.best{background:url(/images/bg_opt.gif) 0 -26px repeat-x;border:solid 1px #dfded8;-moz-border-radius-topleft:5px;-moz-border-radius-topright:0px;-moz-border-radius-bottomleft:5px;-moz-border-radius-bottomright:0px;-webkit-border-top-left-radius:5px;-webkit-border-top-right-radius:0px;-webkit-border-bottom-left-radius:5px;-webkit-border-bottom-right-radius:0px;border-top-left-radius:5px;border-top-right-radius:0px;border-bottom-left-radius:5px;border-bottom-right-radius:0px}
 ul.sort1 li.view,
 ul.sort1 li.new,
 ul.sort1 li.before,
 ul.sort1 li.object{background:url(/images/bg_opt.gif) 0 -26px repeat-x;border:solid 1px #dfded8;border-left:0px}
 ul.sort1 li.pop,
 ul.sort1 li.cre,
 ul.sort1 li.basic,
 ul.sort1 li.popular{background:url(/images/bg_opt.gif) 0 -26px repeat-x;margin-left:-1px;border:solid 1px #dfded8;-moz-border-radius-topleft:0px;-moz-border-radius-topright:5px;-moz-border-radius-bottomleft:0px;-moz-border-radius-bottomright:5px;-webkit-border-top-left-radius:0px;-webkit-border-top-right-radius:5px;-webkit-border-bottom-left-radius:0px;-webkit-border-bottom-right-radius:5px;border-top-left-radius:0px;border-top-right-radius:5px;border-bottom-left-radius:0px;border-bottom-right-radius:5px}
 ul.sort1 li.pop.select,
 ul.sort1 li.archive.select,
 ul.sort1 li.person.select,
 ul.sort1 li.object.select,
 ul.sort1 li.new.select,
 ul.sort1 li.before.select,
 ul.sort1 li.best.select,
 ul.sort1 li.popular.select{background:url(/images/bg_opt.gif) 0 0 repeat-x;border:1px
solid #4b4b4a;font-weight:bold;color:#fff}
 ul.sort1 li.cre.select, ul.sort1 li.basic.select{background:url(/images/bg_opt.gif) 0 0 repeat-x;border:1px
solid #4b4b4a;font-weight:bold;color:#fff}
 ul.sort1 li.view.select{background:url(/images/bg_opt.gif) 0 0 repeat-x;border:1px
solid #4b4b4a;font-weight:bold;color:#fff;border-left:0px}
</style>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/js/mini_calendar.js"></script>

<script>
jQuery.noConflict();
jQuery(document).ready(function($){
	$("#btnInsert").click(function(){
		$(location).attr("href","/reader/readerMove/readerMoveInsert.do"); 
	});
	
	$("#btnList").click(function(){
		$("#frmList").attr("action","/reader/readerMove/readerMoveList.do").submit();
	});
	
	$("#btnSaveExcel").click(function(){
		$("#frmList").attr("action","/reader/readerMove/readerMoveListSaveExcel.do").submit();
	});
	$("#sortDESC").click(function(){
		$("#sort").val("DESC");
		$("#frmList").attr("action","/reader/readerMove/readerMoveList.do").submit();
	});
	$("#sortASC").click(function(){
		$("#sort").val("ASC");
		$("#frmList").attr("action","/reader/readerMove/readerMoveList.do").submit();
	});
});
function editReaderMove(seq){
	jQuery("#seq").val(seq);
	jQuery("#frmEdit").attr("action","/reader/readerMove/readerMoveEdit.do").submit();
}
function moveTo(type, pageNo) {
	
	var frm = document.frmList;

	frm.pageNo.value = pageNo;
	frm.action = "readerMoveList.do";
	frm.submit();
	jQuery("#prcssDiv").show();
}
</script>
<div><span class="subTitle">독자이전 리스트</span></div>
<form id="frmEdit" name="frmEdit" method="post">
	<input type="hidden" name="seq" id="seq"/>
</form>
<form id= "frmList" name="frmList" method="post" action="">
<input type="hidden" name="pageNo" id="pageNo" value="${pageNo}"/>
<input type="hidden" name="sort" id="sort" value="${sort}"/>
<!-- search conditions -->
<div>
	<table class="tb_search" style="width: 1020px;">
		<colgroup>
			<col width="100px">
			<col width="240px">
			<col width="100px">
			<col width="240px">
			<col width="100px">
			<col width="240x">
		</colgroup>
		<tr>
			<th>독자명</th>
			<td><input id="readnm" name="readnm" type="text"  maxlength="15"   value="<c:out value="${readnm}"/>"   style="width: 150px;ime-mode:active;"  /></td>
			<th>전출지국</th>
			<td><input id="out_boseqnm" name="out_boseqnm" type="text"  maxlength="15"   value="<c:out value="${out_boseqnm}"/>"   style="width: 150px;ime-mode:active;"/></td>
			<th>전입지국</th>
			<td><input id="in_boseqnm" name="in_boseqnm" type="text"  maxlength="15"   value="<c:out value="${in_boseqnm}"/>"   style="width: 150px;ime-mode:active;" /></td>
		</tr>
		<tr>
			<th>수금년월</th>
			<td>
				<select name="sgyy" id="sgyy">
					<option value=""<c:if test="${sgyy == ''}"> selected="selected"</c:if>>전체</option>
					<option value="2014"<c:if test="${sgyy == '2014'}"> selected="selected"</c:if>>2014</option>
					<option value="2015"<c:if test="${sgyy == '2015'}"> selected="selected"</c:if>>2015</option>
					<option value="2016"<c:if test="${sgyy == '2016'}"> selected="selected"</c:if>>2016</option>
					<option value="2017"<c:if test="${sgyy == '2017'}"> selected="selected"</c:if>>2017</option>
					<option value="2018"<c:if test="${sgyy == '2018'}"> selected="selected"</c:if>>2018</option>
			  	</select>년
		         <select name="sgmm" id="sgmm">
		         	<option value=""<c:if test="${sgmm == ''}"> selected="selected"</c:if>>전체</option>
					<option value="01"<c:if test="${sgmm == '01'}"> selected="selected"</c:if>>01</option>
					<option value="02"<c:if test="${sgmm == '02'}"> selected="selected"</c:if>>02</option>
					<option value="03"<c:if test="${sgmm == '03'}"> selected="selected"</c:if>>03</option>
					<option value="04"<c:if test="${sgmm == '04'}"> selected="selected"</c:if>>04</option>
					<option value="05"<c:if test="${sgmm == '05'}"> selected="selected"</c:if>>05</option>
					<option value="06"<c:if test="${sgmm == '06'}"> selected="selected"</c:if>>06</option>
					<option value="07"<c:if test="${sgmm == '07'}"> selected="selected"</c:if>>07</option>
					<option value="08"<c:if test="${sgmm == '08'}"> selected="selected"</c:if>>08</option>
					<option value="09"<c:if test="${sgmm == '09'}"> selected="selected"</c:if>>09</option>
					<option value="10"<c:if test="${sgmm == '10'}"> selected="selected"</c:if>>10</option>
					<option value="11"<c:if test="${sgmm == '11'}"> selected="selected"</c:if>>11</option>
					<option value="12"<c:if test="${sgmm == '12'}"> selected="selected"</c:if>>12</option>
			  	</select>월
			</td>
			<th>접수일자</th>
			<td>
				<input type="text" id="startDate" name="startDate"  value="${startDate}" readonly="readonly" onclick="Calendar(this)" style="width: 75px;"/>
					&nbsp; ~ &nbsp; 
				<input type="text" id="endDate" name="endDate"  value="${endDate}" readonly="readonly" onclick="Calendar(this)"  style="width: 75px;"/>
				
			</td>
			<th>처리상태</th>
			<td>
				<select name="status"  style="width: 100px;">
					<option value="" <c:if test="${status == ''}">selected</c:if>>전체</option>
					<option value="1" <c:if test="${status == '1'}">selected</c:if>>처리중</option>
			 	    <option value="2" <c:if test="${status == '2'}">selected</c:if>>완료</option>
			 	    <option value="3" <c:if test="${status == '3'}">selected</c:if>>재이전</option>
			 	    <option value="4" <c:if test="${status == '4'}">selected</c:if>>취소</option>
			  	</select>
			</td>
		</tr>
		<tr>
			<td style="text-align: right;" colspan="6">
				<img src="/images/bt_joh.gif" alt="조회" id="btnList"  style="vertical-align: middle;cursor: pointer;"/>
				&nbsp;
				<img src="/images/bt_insert.gif" alt="등록" id="btnInsert" style="vertical-align: middle;cursor: pointer;"/>
				&nbsp;
				<img src="/images/bt_savexel.gif" alt="엑셀저장" id="btnSaveExcel" style="vertical-align: middle;cursor: pointer;"/>
				
			</td>
		</tr>
	</table>
</div>
<!-- //search conditions -->
</form>

<div style="padding-top: 15px;">
	<div>
      <ul class="sort1">
        <li class="lSort new<c:if test="${sort == 'DESC'}"> select</c:if>" id="sortDESC">최신순</li>
        <li class="lSort before<c:if test="${sort == 'ASC'}"> select</c:if>" id="sortASC">과거순</li>
      </ul>
   </div>
	<table class="tb_list_a" style="width: 1020px">  
		<colgroup>
			<col width="70px">
			<col width="120px">
			<col width="90px">
			<col width="380px">
			<col width="70px">
			<col width="70px">
			<col width="30px">
			<col width="50px">
			<col width="70px">
			<col width="70px">
		</colgroup>	
		<tr>
			<th>접수일자</th>
			<th>독자명</th>
			<th>전화번호</th>
			<th>주 &nbsp; &nbsp; &nbsp; 소</th>
			<th>전출지국</th>
			<th>전입지국</th>
			<th>부수</th>
			<th>수금월</th>
			<th>이전일자</th>
			<th>상 태</th>
		</tr>
		<c:forEach items="${readerMoveList}" var="list"  varStatus="status">
			<tr class="mover_color" style="cursor:pointer;" id="${list.SEQ}" onclick="editReaderMove(this.id);">
				<td>${list.INDT}</td>
				<td><div style="text-align:left;padding-left:5px;width:115px;text-overflow: ellipsis;white-space: nowrap;overflow: hidden;">${list.READNM}</div></td>
				<td><div style="text-align:left;padding-left:3px;height:15px;"><c:if test="${list.TEL2 != null}">${list.TEL1}-${list.TEL2}-${list.TEL3}</c:if></div><div style="text-align: left;padding-left:3px;height:15px;"><c:if test="${list.HANDY2 != null}">${list.HANDY1}-${list.HANDY2}-${list.HANDY3}</c:if></div></td>
				<td><div style="height:15px;border-bottom:1px solid gray;text-align:left;padding-left:5px;text-overflow: ellipsis;white-space: nowrap;overflow: hidden;width:370px;">${list.OUT_ADRS1}${list.OUT_ADRS2}</div><div style="height:15px;text-align: left;padding-left:5px;text-overflow: ellipsis;white-space: nowrap;overflow: hidden;width:370px;background-color:mistyrose;">${list.IN_ADRS1}${list.IN_ADRS2}</div></td>
				<td><div style="width:65px;text-overflow: ellipsis;white-space: nowrap;overflow: hidden;">${list.OUT_BOSEQNM}</div></td>
				<td><div style="width:65px;text-overflow: ellipsis;white-space: nowrap;overflow: hidden;">${list.IN_BOSEQNM}</div></td>
				<td>${list.QTY}</td>
				<td><font color="red">${list.SGYYMM}</font></td>
				<td>${list.MOVEDT}</td>
				<td>
				<b><c:if test="${list.STATUS == '1'}"><font color="blue">처리중</font></c:if><c:if test="${list.STATUS == '2'}"><font color="green">완료</font><br/><span style="font-weight: normal;">${list.CHGDT }</span></c:if><c:if test="${list.STATUS == '3'}"><font color="orange">재이전</font></c:if><c:if test="${list.STATUS == '4'}"><font color="red">취소</font></c:if></b>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/common/paging.jsp"%>
	</div>