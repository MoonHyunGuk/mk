<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel='stylesheet' type='text/css' href="/select2/select2.css"/>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script>
jQuery.noConflict();
jQuery(document).ready(function($){
	$("#btnInsert").click(function(){
		$(location).attr("href","/reader/readerMove/readerMoveInsert.do");
	});
});

var popupType = null;
function popAddr1(type){
	popupType = type;
	var fm = document.getElementById("addrForm");
	
	var left = (screen.width)?(screen.width - 1330)/2 : 10;
	var top = (screen.height)?(screen.height - 200)/2 : 10;
	var winStyle = "width=800,height=460,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=0";		
	var newWin = window.open("", "pop_AgSearch", winStyle);
	
	fm.target = "pop_AgSearch";
	fm.action = "/reader/readerAplc/popAgSearch.do?cmd=1";
	fm.submit();
}
//우편주소팝업에서 우편주소 선택시 셋팅 펑션	(직장 주소)
function setAgValue(zip, addr, boseq, jikuk, tel, handy){
	document.getElementById(popupType + "_zipcode").value = zip;
	document.getElementById(popupType + "_adrs1").value = addr;
	document.getElementById(popupType + "_boseq").value=boseq;
	document.getElementById(popupType + "_boseqnm").value=jikuk;
}

function insert(){
	if(jQuery.trim(jQuery("#readnm").val()) == ""){
		alert("독자명을 입력해주세요.");
		jQuery("#readnm").focus();
		return;
	}
	if(jQuery.trim(jQuery("#competentnm").val()) == ""){
		alert("담당자명을 입력해주세요.");
		jQuery("#competentnm").focus();
		return;
	}
	if(jQuery.trim(jQuery("#out_adrs1").val()) == ""){
		alert("전출지 주소를 입력해주세요.");
		jQuery("#out_adrs1").focus();
		return;
	}
	if(jQuery.trim(jQuery("#out_adrs2").val()) == ""){
		alert("전출지 상세주소를 입력해주세요.");
		jQuery("#out_adrs2").focus();
		return;
	}
	if(jQuery.trim(jQuery("#in_adrs1").val()) == ""){
		alert("전입지 주소를 입력해주세요.");
		jQuery("#in_adrs1").focus();
		return;
	}
	if(jQuery.trim(jQuery("#in_adrs2").val()) == ""){
		alert("전입지 상세주소를 입력해주세요.");
		jQuery("#in_adrs2").focus();
		return;
	}
	if(jQuery.trim(jQuery("#qty").val()) == ""){
		alert("이전부수를 입력해주세요.");
		jQuery("#qty").focus();
		return;
	}
	if(Number(jQuery("#qty").val()) < 2){
		alert("1부는 유가이전 대상이 아닙니다.");
		jQuery("#qty").focus();
		return;
	}
	
	if(Number(jQuery("#sgyy").val() + jQuery("#sgmm").val()) < Number('${currentSgyymm}')){
		alert("※ 다부수독자 이전처리 등록은 전월 16일 ~ 해당수금월 15일 까지입니다. (15일이 휴일인 경우 그 다음날까지 입력 가능합니다.)");
		jQuery("#sgmm").focus();
		return;
	}
	
	
	jQuery("#insertForm").attr("action","/reader/readerMove/executeReaderMoveInsertForJikuk.do").submit();
}

</script>

<div><span class="subTitle">독자이전  등록</span></div>
<form id="addrForm" name="addrForm" method="post">
</form>
<form id="insertForm" name="insertForm" method="post">
<div style="width: 720px; padding-left: 15px;">
<div style="padding: 10px 0 5px 0;"><b><img src="/images/left_icon.gif" style="vertical-align: middle;" alt=""  /> 독자 정보</b></div>
<table class="tb_search" style="width: 720px;">
		<colgroup>
			<col width="110px">
			<col width="250px">
			<col width="110px">
			<col width="250px">
		</colgroup>
		<tr>
		    <th>독자명</th>
			<td style="text-align: left; padding-left: 10px"><input type="text" size="20" name="readnm" id="readnm"></td>
			<th>담당자명</th>
			<td style="text-align: left; padding-left: 10px"><input type="text" size="20" name="competentnm" id="competentnm"></td>
	    </tr>
	    <tr>
		    <th>전화번호</th>
			<td style="text-align: left; padding-left: 10px">
				<select name="tel1">
					<option value="02">02</option>
					<option value="031">031</option>
					<option value="032">032</option>
					<option value="033">033</option>
					<option value="041">041</option>
					<option value="042">042</option>
					<option value="043">043</option>
					<option value="044">044</option>
					<option value="051">051</option>
					<option value="052">052</option>
					<option value="053">053</option>
					<option value="054">054</option>
					<option value="055">055</option>
					<option value="061">061</option>
					<option value="062">062</option>
					<option value="063">063</option>
					<option value="064">064</option>
					<option value="070">070</option>
			 	</select>
		         - <input name="tel2" type="text"  style="width:45px; ime-Mode:disabled;" maxlength="4" value="" onkeypress="inputNumCom();">
		         - <input name="tel3" type="text"  style="width:45px; ime-Mode:disabled;" maxlength="4" value="" onkeypress="inputNumCom();">
			</td>
			<th>핸드폰번호</th>
			<td style="text-align: left; padding-left: 10px">
				<select name="handy1">
					<option value="010">010</option>
					<option value="011">011</option>
					<option value="016">016</option>
					<option value="017">017</option>
					<option value="018">018</option>
					<option value="019">019</option>
			 	</select>
		         - <input name="handy2" type="text"  style="width:45px; ime-Mode:disabled;" maxlength="4" value="" onkeypress="inputNumCom();">
		         - <input name="handy3" type="text"  style="width:45px; ime-Mode:disabled;" maxlength="4" value="" onkeypress="inputNumCom();">
			</td>
	    </tr>
	</table>


<div style="padding: 10px 0 5px 0;"><b><img src="/images/left_icon.gif" style="vertical-align: middle;" alt=""  /> 전출지 정보</b></div>
	<table class="tb_search" style="width: 720px;">
		<colgroup>
			<col width="110px">
			<col width="610px">
		</colgroup>
		<tr>
		    <th>주 소</th>
			<td>
				<input type="text" id="out_zipcode" name="out_zipcode" value=""  maxlength="6" style="width: 60px;ime-mode:active; vertical-align: middle;" readonly="readonly" />
				<a href="#fakeUrl" onclick="popAddr1('out');"><img alt="우편번호찾기" src="/images/ico_search2.gif" style="border: 0; vertical-align: middle;" /></a>
				&nbsp;<input type="text" id="out_adrs1" name="out_adrs1" style="width: 406px;ime-mode:active; vertical-align: middle;" readonly="readonly" /><br />
				<input id="out_adrs2" name="out_adrs2" type="text"  maxlength="45"  style="width: 500px;ime-mode:active; vertical-align: middle;" />
			</td>
	    </tr>
	    <tr>
		    <th>관할지국</th>
			<td>
				<input type="text" size="20" name="out_boseqnm" id="out_boseqnm" readOnly="readonly"/>
				<input type="hidden" name="out_boseq" id="out_boseq"/>
			</td>
	    </tr>
	</table>
	
	<div style="padding: 10px 0 5px 0;"><b><img src="/images/left_icon.gif" style="vertical-align: middle;" alt=""  /> 전입지 정보</b></div>
	<table class="tb_search" style="width: 720px;">
		<colgroup>
			<col width="110px">
			<col width="610px">
		</colgroup>
		<tr>
		    <th>주 소</th>
			<td>
				<input type="text" id="in_zipcode" name="in_zipcode" value=""  maxlength="6" style="width: 60px;ime-mode:active; vertical-align: middle;" readonly="readonly" />
				<a href="#fakeUrl" onclick="popAddr1('in');"><img alt="우편번호찾기" src="/images/ico_search2.gif" style="border: 0; vertical-align: middle;" /></a>
				&nbsp;<input type="text" id="in_adrs1" name="in_adrs1" style="width: 406px;ime-mode:active; vertical-align: middle;" readonly="readonly" /><br />
				<input id="in_adrs2" name="in_adrs2" type="text"  maxlength="45"  style="width: 500px;ime-mode:active; vertical-align: middle;" />
			</td>
	    </tr>
	    <tr>
		    <th>관할지국</th>
			<td>
				<input type="text" size="20" name="in_boseqnm" id="in_boseqnm" readOnly="readonly"/>
				<input type="hidden" name="in_boseq" id="in_boseq"/>
			</td>
	    </tr>
	</table>
	
	<div style="padding: 10px 0 5px 0;"><b><img src="/images/left_icon.gif" style="vertical-align: middle;" alt=""  /> 구독 정보</b></div>
	<table class="tb_search" style="width: 720px;">
		<colgroup>
			<col width="110px">
			<col width="610px">
		</colgroup>
		<tr>
		    <th>이전일</th>
			<td>
				<input type="text" id="movedt" name="movedt"  value="<c:out value='${movedt}' />" readonly="readonly" style="text-align: center; width: 85px;  vertical-align: middle;" onclick="Calendar(this)"/>
			</td>
	    </tr>
	    <tr>
		    <th>수금월</th>
			<td>
				<select name="sgyy" id="sgyy">
					<option value="2014"<c:if test="${sgyy == '2014'}"> selected="selected"</c:if>>2014</option>
					<option value="2015"<c:if test="${sgyy == '2015'}"> selected="selected"</c:if>>2015</option>
					<option value="2016"<c:if test="${sgyy == '2016'}"> selected="selected"</c:if>>2016</option>
					<option value="2017"<c:if test="${sgyy == '2017'}"> selected="selected"</c:if>>2017</option>
					<option value="2018"<c:if test="${sgyy == '2018'}"> selected="selected"</c:if>>2018</option>
			  	</select>년
		         <select name="sgmm" id="sgmm">
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
			  	<br/>
			  	<div style="color:red;font-size:10px;">※ 다부수독자 이전처리 등록은 전월 16일 ~ 해당수금월 15일 까지입니다. (15일이 휴일인 경우 그 다음날까지 입력 가능합니다.)</div>
			</td>
	    </tr>
	    <tr>
		    <th>이전부수</th>
			<td>
				<input type="text" size="5" name="qty" id="qty" style="width:45px; ime-Mode:disabled;" onkeypress="inputNumCom();">부&nbsp;&nbsp;&nbsp;<font style="color:red;">*1부는 유가이전 대상이 아닙니다.</font>
			</td>
	    </tr>

	    <tr>
		    <th>수금방법</th>
			<td>
				<select name="sgtype" id="sgtype">
					<option value="011">지로</option>
					<option value="022">카드</option>
					<option value="021">자동이체</option>
					<option value="023">본사입금</option>
				</select>
			</td>
	    </tr>
	</table>
</div>
</form>
<div style="width: 720px; text-align: right; padding-top: 10px; padding-left: 15px;">
  	<a href="#fakeUrl" onclick="insert()"><img src="/images/bt_insert.gif" style="border: 0; vertical-align: middle; "></a>
</div>