<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" type="text/css" href="/css/addStyle.css">
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
/**
 * 조회버튼 클릭이벤트
 */
function fn_search() {
	var fm = document.getElementById("frm");
	
	fm.target = "_self";
	fm.action = "/management/readerRestore/readerRestore.do";
	fm.submit();
	jQuery("#prcssDiv").show();
}

/**
 * 독자정보
 */
function fn_detailView(readno, seq) {
	jQuery.ajax({
		type 		: "POST",
		url 		: "/management/readerRestore/selectReaderData.do",
		dataType 	: "json",
		data		: "readNo="+readno+"&seq="+seq,
		beforeSend	: function () {
			// 로딩프레임 호출
			//NProgress.start();
			jQuery("#prcssDiv").show();
        },
		success:function(data){
			var newscd = data.readerData[0].NEWSCD;
			var newaddr= data.readerData[0].NEWADDR;
			var dlvadr2 = data.readerData[0].DLVADRS2
			var stdt = data.readerData[0].STDT;
			var seq = data.readerData[0].SEQ;
			var bno = data.readerData[0].BNO;
			var readtypecd = data.readerData[0].READTYPECD;
			var stsayou = data.readerData[0].STSAYOU;
			var hjdt = data.readerData[0].HJDT;
			var gno = data.readerData[0].GNO;
			var readno = data.readerData[0].READNO;
			var readnm = data.readerData[0].READNM;
			var boseqnm = data.readerData[0].BOSEQNM;
			var qty = data.readerData[0].QTY;
			var dlvzip = data.readerData[0].DLVZIP;
			var boseq = data.readerData[0].BOSEQ;
			var sgtype = data.readerData[0].SGTYPE;

			var readtypecdnm = data.readTypeNm;
			var sgtypenm = data.sgTypeNm;
			
			jQuery("#readNm").html(readnm);
			jQuery("#readno").html(readno);
			jQuery("#boseqnm").html(boseqnm);
			jQuery("#newaddr").html(newaddr+dlvadr2);
			jQuery("#seq").html(seq);
			jQuery("#readtypecdnm").html(readtypecdnm);
			jQuery("#qty").html(qty);
			jQuery("#sgtype").html(sgtype);
			jQuery("#sgtypenm").html(sgtypenm);
			jQuery("#stdt").val(stdt);
			jQuery("#stsayou").val(stsayou);
			jQuery("#bno").val(bno);
			
			jQuery("#hdnReadno").val(readno);
			jQuery("#hdnSeq").val(seq);
			jQuery("#hdnSgtype").val(sgtype);
			jQuery("#hdnReadTypeCd").val(readtypecd);
			jQuery("#hdnNewsCd").val(newscd);
		},
		complete 	: function () {
			// 로딩 프레임제거
			//NProgress.done();
			jQuery("#prcssDiv").hide();
        },
		error    : function(r) { alert("ajax error") }
	}); //ajax end
}

/**
 * 수금정보보기
 */
function fn_selectSugmData(){
	var fm = document.getElementById("frm");
	var opReadnoVal = document.getElementById("hdnReadno").value;
	var opSeqVal = document.getElementById("hdnSeq").value;
	
	if("" == opReadnoVal) {
		alert("독자를 선택해주세요.");
		return false;
	}
	
	var left = (screen.width)?(screen.width - 1500)/2 : 10;
	var top = (screen.height)?(screen.height - 620)/2 : 10;
	var winStyle = "width=1500,height=620,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=0";
	var newWin = window.open("", "sugmVeiw", winStyle);
	
	fm.target = "sugmVeiw";
	fm.action = "/management/readerRestore/selectReaderSugmNHistoryData.do?readNo="+opReadnoVal+"&seq="+opSeqVal;
	fm.submit();
}

/**
 * 독자복구버튼 클릭 이벤트
 */
function fn_restore() {
	var fm = document.getElementById("frm");
	var sgtypeVal 		= document.getElementById("hdnSgtype").value;
	var readTypeCdVal 	= document.getElementById("hdnReadTypeCd").value;
	var readnoVal 		= document.getElementById("hdnReadno").value;
	var seqVal 			= document.getElementById("hdnSeq").value;
	var url 				="";
	
	if(!confirm("독자를 복구하시겠습니까?")) {
		return false;
	}
	
	alert(sgtypeVal+"/"+readTypeCdVal);
	
	//독자 납부방법별 처리 URL
	if( "011" == sgtypeVal || "012" == sgtypeVal || "013" == sgtypeVal) {	//지로, 방문, 통장입금독자
		if("011" == readTypeCdVal || "012" == readTypeCdVal || "013" == readTypeCdVal) { //일반
			url ="/management/readerRestore/restoreOnlyReaderNewsTable.do";		
		}
	} else if("021" == sgtypeVal) {	//일반 자동이체독자
		if("011" == readTypeCdVal || "012" == readTypeCdVal || "013" == readTypeCdVal) {
			url ="/management/readerRestore/restoreReaderUserTable.do";
		}
	} else if("022" == sgtypeVal) {	//카드이체독자
		if("011" == readTypeCdVal || "012" == readTypeCdVal || "013" == readTypeCdVal) { //일반
			url ="/management/readerRestore/restoreCardReaderNewsNTable.do";
		}
	} 
		
	if("" == url) {
		alert("자동복구가 지원되지 않는 독자입니다.");
		return false;
	}
	
	fm.target = "_self";
	fm.action = url;
	fm.submit(); 
	jQuery("#prcssDiv").show();
}
</script>
<div style="padding-bottom: 5px;"><span class="subTitle">독자복구</span></div>
<form id= "frm" name = "frm" method="post">
	<input type="hidden" name="hdnReadno" id="hdnReadno" />
	<input type="hidden" name="hdnSeq" id="hdnSeq" />
	<input type="hidden" name="hdnSgtype" id="hdnSgtype" />
	<input type="hidden" name="hdnReadTypeCd" id="hdnReadTypeCd" />
	<input type="hidden" name="hdnNewsCd" id="hdnNewsCd" />
	
	<!-- search conditions -->	
	<div style="padding-bottom: 8px;">
		<div class="box_gray_left" style="padding: 8px 0; width: 800px">
			<b>독자번호</b>&nbsp;
			<input type="text" name="opReaderNo" id="opReaderNo" value="${opReaderNo }" style="width: 100px;" maxlength="9" />
			&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="#fakeUrl" onclick="fn_search();"><img src="/images/bt_joh.gif" style="vertical-align: middle; border: 0" alt="조회"></a>   
		</div>
	</div>
	<!-- //search conditions -->
	<!-- reader list -->
	<div style="padding: 5px 0; font-weight: bold;">[독자]</div>
	<div style="width: 800px">
		<table class="tb_list_a" style="width: 800px">
			<colgroup>
				<col width="60px">
				<col width="150px">
				<col width="80px">
				<col width="80px">
				<col width="30px">
				<col width="300px">
				<col width="100px">
			</colgroup>
			<tr>
				<th>구역</th>
				<th>독자명</th>
				<th>SEQ</th>
				<th>매체명</th> 
				<th>부수</th>
				<th>주소</th>
				<th>확장/중지</th>
			</tr>
		</table>
	</div>
	<div style="width: 800px; height: 120px; overflow-x: none; overflow-y: scroll">
		<table class="tb_list_a" style="width: 783px">
			<colgroup>
				<col width="60px">
				<col width="150px">
				<col width="80px">
				<col width="80px">
				<col width="30px">
				<col width="300px">
				<col width="83px">
			</colgroup>
			<c:forEach items="${readerDataList}" var="list"  varStatus="status">
				<tr onclick="fn_detailView('${opReaderNo}', '${list.SEQ}')" style="cursor: pointer;">
					<td>${list.GNO }-${list.BNO}</td>
					<td>${list.READNM }</td>
					<td>${list.SEQ }</td>
					<td>${list.NEWSCD }</td>
					<td>${list.QTY }</td>
					<td>${list.NEWADDR} ${list.DLVADRS2}</td>
					<td>${list.HJDT }<br/><span style="color: red;">(${list.STDT })</span></td>
				</tr>	
			</c:forEach>
		</table>
	</div>
	<!-- //reader list -->
	<!-- reader info -->
	<div style="padding: 20px 0 5px 0; font-weight: bold;">[독자정보]</div>
	<div style="width: 800px;">
		<table class="tb_view" style="width: 800px;">
			<colgroup>
				<col width="105px">
				<col width="160px">
				<col width="105px">
				<col width="160px">
				<col width="105px">
				<col width="165px">
			</colgroup>
			<tr>
				<th>독자명</th>
				<td id="readNm" colspan="3"></td>
				<th>독자번호</th>
				<td id="readno"></td>
			</tr>
			<tr>
				<th>SEQ</th>
				<td id="seq"></td>
				<th>지국명</th>
				<td id="boseqnm"></td>
				<th>독자타입</th>
				<td id="readtypecdnm"></td>
			</tr>
			<tr>
				<th>부수</th>
				<td id="qty"></td>
				<th>수금방법(코드)</th>
				<td id="sgtype"></td>
				<th>수금방법</th>
				<td id="sgtypenm"></td>
			</tr>
			<tr>
				<th>주 소</th>
				<td colspan="5" id="newaddr"></td>
			</tr>
			<tr>
				<th>해지일자</th>
				<td><input type="text" name="stdt" id="stdt" maxlength="8" style="width: 100px;"> </td>
				<th>해지사유</th>
				<td><input type="text" name="stsayou" id="stsayou" maxlength="3" style="width: 40px;"></td>
				<th>구 역</th>
				<td><input type="text" name="bno" id="bno" maxlength="3" style="width: 40px;"></td>
			</tr>
		</table>
	</div>
	<!-- //reader info -->
	<!-- button -->
	<div style="width: 800px; text-align: right; padding-top: 10px;">
		<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="fn_selectSugmData();" style="text-decoration: none;">수금정보</a></span>
		&nbsp;
		<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="fn_restore();" style="text-decoration: none;">독자복구</a></span>
	</div>
	<!-- //button -->
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