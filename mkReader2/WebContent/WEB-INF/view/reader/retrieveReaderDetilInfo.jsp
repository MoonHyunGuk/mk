<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>독자상세정보</title>
	<link rel="stylesheet" type="text/css" href="/css/mkcrm.css">
	<link rel="stylesheet" type="text/css" href="/css/addStyle.css"> 
	<script type="text/javascript" src="/js/prototype.js"></script>
	<script type="text/javascript" src="/js/common.js"></script>
	<script type="text/javascript" src="/js/ajaxUtil.js"></script>
	<script type="text/javascript">
		//작년 수금 금년 수금 리스트 변경 컨트롤
		function changSumgList(gbn){
			if (gbn == '1') {
				if(document.getElementById("pre01").style.display == 'block'){
					return;
				}else if(document.getElementById("now01").style.display == 'block'){
					for( var i = 1 ; i < 13 ; i++ ){
						if(i<10){
							i = '0'+ i;
						}
						document.getElementById("pre"+i).style.display  = 'block';
						document.getElementById("now"+i).style.display  = 'none';
					}
					return;
				}else if(document.getElementById("next01").style.display == 'block'){
					for(var  i = 1 ; i < 13 ; i++ ){
						if(i<10){
							i = '0'+ i;
						}
						document.getElementById("now"+i).style.display  = 'block';
						document.getElementById("next"+i).style.display  = 'none';
					}
				}
				return;
			}
			if (gbn == '2') {
				if(document.getElementById("pre01").style.display == 'block'){
					for( var i = 1 ; i < 13 ; i++ ){
						if(i<10){
							i = '0'+ i;
						}
						document.getElementById("now"+i).style.display  = 'block';
						document.getElementById("pre"+i).style.display  = 'none';
					}
					return;
				}else if(document.getElementById("now01").style.display == 'block'){
					for(var  i = 1 ; i < 13 ; i++ ){
						if(i<10){
							i = '0'+ i;
						}
						document.getElementById("next"+i).style.display  = 'block';
						document.getElementById("now"+i).style.display  = 'none';
					}
				}
				return;
			}
		}
	
		//  자세히 보기, 독자 수금정보 조회(ajax)
		function detailView(seq, readno, newscd, boseq) {
			
			clearField();
			
			for(var  i = 1 ; i < 13 ; i++ ){
				if(i<10){
					i = '0'+ i;
				}
				if(document.getElementById("pre01").style.display == 'block'){
					document.getElementById("now"+i).style.display  = 'none';
					document.getElementById("next"+i).style.display  = 'none';
				}else if(document.getElementById("now01").style.display == 'block'){
					document.getElementById("pre"+i).style.display  = 'none';
					document.getElementById("next"+i).style.display  = 'none';
				}else if(document.getElementById("next01").style.display == 'block'){
					document.getElementById("pre"+i).style.display  = 'none';
					document.getElementById("now"+i).style.display  = 'none';
				}
			}
	
			var url = "/collection/collection/ajaxCollectionList_org.do?seq="+seq+"&readNo="+readno+"&newsCd="+newscd+"&boSeq="+boseq;
			sendAjaxRequest(url, "readerListForm", "post", collectionList);
			
			var url = "/reader/minwon/ajaxDetailReaderInfo.do?seq="+seq+"&readNo="+readno+"&newsCd="+newscd;
			sendAjaxRequest(url, "readerListForm", "post", readerDtailInfo);
		}
		
		function clearField(){
			// 상세정보 클리어
			$("readno").value = "";
			$("gnonm").value = "";
			$("gno").value = "";
			$("readnm").value = "";
			$("bidt").value = "";
			$("hometel").value = "";
			$("mobile").value = "";
			$("email").value = "";
			$("dlvzip").value = "";
			//$("dlvadrs1").value = "";
			$("dlvadrs2").value = "";
			$("newaddr").value = "";
			$("rsdtypenm").value = "";
			$("tasknm").value = "";
			$("intflnm").value = "";
			$("newsnm").value = "";
			$("hjdt").value = "";
			$("readtypenm").value = "";
			$("qty").value = "";
			$("sumQty").value = "";
			$("sgbgmm").value = "";
			$("dlvtypenm").value = "";
			$("uprice").value = "";
			$("sumUprice").value = "";
			$("hjpathnm").value = "";
			$("dlvposinm").value = "";
			$("sgtypenm").value = "";
			$("hjpsnm").value = "";
			$("bnsbooknm").value = "";
			$("hjdt").value = "";
			$("term").value = "";
			$("spgnm").value = "";
			$("stdt").value = "";
			$("stsayounm").value = "";
			$("desc").value = "";
			
			//수금 정보 클리어
			for(var j=1 ; j < 13 ; j++){
				if(j < 10){
					seq ='0'+j;
				}else{
					seq = j;
				}
	
				$("preSnDt"+seq).value = '';
				$("preBillAmt"+seq).value = '';
				$("preAmt"+seq).value = '';
				$("preSgbbCd"+seq).value = '';
				$("nowSnDt"+seq).value = '';
				$("nowBillAmt"+seq).value = '';
				$("nowAmt"+seq).value = '';
				$("nowSgbbCd"+seq).value = '';
				$("nextSnDt"+seq).value = '';
				$("nextBillAmt"+seq).value = '';
				$("nextAmt"+seq).value = '';
				$("nextSgbbCd"+seq).value = '';
				$("sumgClam").innerHTML = '------------';
			}
			
			// 통화목록 클리어
			 while($("callListTbody").firstChild){
				 $("callListTbody").removeChild($("callListTbody").firstChild);
			 }
			
		}
	
		//상세정보 셋팅 펑션
		function readerDtailInfo(responseHttpObj) {
			if (responseHttpObj) {
				try {
					var result = responseHttpObj.responseText.evalJSON();
					if (result.readerInfo != "") {
						setReaderDetailInfo(result.readerInfo);
					}
					
					//메모리스트 세팅
					if(result.memoList != "") {
						setMemoList(result.memoList);
					}
	
					setReaderCallLog(result.callLog);					
	
				} catch (e) {
					alert("오류 : " + e);
				}
			}
		}
		
		
		function setReaderDetailInfo(jsonObj){
			$("readno").value = (jsonObj.READNO == null ? "" : jsonObj.READNO);
			$("gnonm").value = (jsonObj.GNONM == null ? "" : jsonObj.GNONM);
			$("gno").value = (jsonObj.GNO == null ? "" : jsonObj.GNO+"-"+jsonObj.BNO + (jsonObj.SNO == null ? "" : "-"+ jsonObj.SNO) );
			$("readnm").value = (jsonObj.READNM == null ? "" : jsonObj.READNM);
			$("bidt").value = (jsonObj.BIDT == null ? "" : jsonObj.BIDT);
			$("hometel").value = (jsonObj.HOMETEL == null ? "" : jsonObj.HOMETEL);
			$("mobile").value = (jsonObj.MOBILE == null ? "" : jsonObj.MOBILE);
			$("email").value = (jsonObj.EMAIL == null ? "" : jsonObj.EMAIL);
			$("dlvzip").value = (jsonObj.DLVZIP == null ? "" : jsonObj.DLVZIP);
			//$("dlvadrs1").value = (jsonObj.DLVADRS1 == null ? "" : jsonObj.DLVADRS1);
			$("dlvadrs2").value = (jsonObj.DLVADRS2 == null ? "" : jsonObj.DLVADRS2);
			$("newaddr").value = (jsonObj.NEWADDR == null ? "" : jsonObj.NEWADDR);
			$("rsdtypenm").value = (jsonObj.RSDTYPENM == null ? "" : jsonObj.RSDTYPENM);
			$("tasknm").value = (jsonObj.TASKNM == null ? "" : jsonObj.TASKNM);
			$("intflnm").value = (jsonObj.INTFLDNM == null ? "" : jsonObj.INTFLDNM);
			$("newsnm").value = (jsonObj.NEWSNM == null ? "" : jsonObj.NEWSNM);
			$("hjdt").value = (jsonObj.HJDT == null ? "" : jsonObj.HJDT);
			$("readtypenm").value = (jsonObj.READTYPENM == null ? "" : jsonObj.READTYPENM);
			$("qty").value = (jsonObj.QTY == null ? "" : jsonObj.QTY);
			if(jsonObj.QTY < jsonObj.SUMQTY) {
				$("sumQty").value = (jsonObj.SUMQTY == null ? "" : jsonObj.SUMQTY);
			}
			$("sgbgmm").value = (jsonObj.SGBGMM == null ? "" : jsonObj.SGBGMM);
			$("dlvtypenm").value = (jsonObj.DLVTYPENM == null ? "" : jsonObj.DLVTYPENM);
			$("uprice").value = (jsonObj.UPRICE == null ? "" : jsonObj.UPRICE);
			if(jsonObj.UPRICE < jsonObj.SUMUPRICE) {
				$("sumUprice").value = (jsonObj.SUMUPRICE == null ? "" : jsonObj.SUMUPRICE);
			}
			$("hjpathnm").value = (jsonObj.HJPATHNM == null ? "" : jsonObj.HJPATHNM);
			$("dlvposinm").value = (jsonObj.DLVPOSINM == null ? "" : jsonObj.DLVPOSINM);
			$("sgtypenm").value = (jsonObj.SGTYPENM == null ? "" : jsonObj.SGTYPENM);
			$("hjpsnm").value = (jsonObj.HJPSNM == null ? "" : jsonObj.HJPSNM);
			$("bnsbooknm").value = (jsonObj.BNSBOOKNM == null ? "" : jsonObj.BNSBOOKNM);
			$("hjdt").value = (jsonObj.HJDT == null ? "" : jsonObj.HJDT);
			$("term").value = (jsonObj.TERM == null ? "" : jsonObj.TERM+"개월");
			$("spgnm").value = (jsonObj.SPGNM == null ? "" : jsonObj.SPGNM);
			$("stdt").value = (jsonObj.STDT == null ? "" : jsonObj.STDT);
			$("stsayounm").value = (jsonObj.STSAYOUNM == null ? "" : jsonObj.STSAYOUNM); 
			//$("desc").value = (jsonObj.REMK == null ? "" : jsonObj.REMK);
			$("boseqNm").value = (jsonObj.JIKUKNM == null ? "" : jsonObj.JIKUKNM);
			$("stdtNm").value = (jsonObj.STDT == null ? "정상" : "해지");
		}
		
		function setReaderCallLog (jsonObjArr){
			if (jsonObjArr.length > 0) {
				for(var j=0 ; j < jsonObjArr.length ; j++){
					var tr = document.createElement("tr");
					var td1 = document.createElement("td");
					var td2 = document.createElement("td");
	
					tr.appendChild(td1);
					tr.appendChild(td2);
					
					td1.innerText = jsonObjArr[j].INDATE;
					td2.innerText = jsonObjArr[j].REMK;
					$("callListTbody").appendChild(tr);
				}
			}else{
				var tr = document.createElement("tr");
				var td1 = document.createElement("td");
				var td2 = document.createElement("td");
	
				tr.appendChild(td1);
				tr.appendChild(td2);
				
				td1.innerText = "";
				td2.innerText = "통화 기록이 없습니다.";
				$("callListTbody").appendChild(tr);
			}
		}
		
		//메모리스트 조회
		function setMemoList (jsonObjArr){
			var div_line = document.createElement("div");
			var div_head = document.createElement("div");
			var div_note = document.createElement("div");
			if (jsonObjArr.length > 0) {
				for(var j=0 ; j < jsonObjArr.length ; j++){
					div_note = document.createElement("div");//font-weight: bold;
					div_head = document.createElement("div");
					div_head.style.cssText = "font-weight: bold; padding-top: 3px";
					div_head.innerText = "["+jsonObjArr[j].CREATE_ID+"] "+jsonObjArr[j].CREATE_DATE ;
					div_note.innerText = jsonObjArr[j].MEMO;
					div_note.style.cssText = "border-bottom: 1px solid #e5e5e5; padding-bottom: 3px";
					$("desc").appendChild(div_head);
					$("desc").appendChild(div_note);
					$("desc").appendChild(div_line);
				}
			}else{
				div = document.createElement("div");
				div.innerText = "통화 기록이 없습니다.";
				$("desc").appendChild(div);
			}
			
		}
	
		//수금정보 셋팅 펑션
		function collectionList(responseHttpObj) {
			if (responseHttpObj) {
				try {
					var result = eval("(" + responseHttpObj.responseText + ")");
					if (result) {
						setCollectionList(result);
					}
				} catch (e) {
					alert("오류 : " + e);
				}
			}
		}
	
		function setCollectionList(jsonObjArr) {
			var nowYear = '${nowyymm12}'; //현재 사용월분
			var deadLineDt = nowYear+"20";
			//셋팅
			if (jsonObjArr.length > 0) {
				for(var j=1 ; j < 13 ; j++){
					if(j < 10){
						seq ='0'+j;
					}else{
						seq = j;
					}
					
					for ( var i = 0; i < jsonObjArr.length- 2; i++) {
						if($("preYear"+seq).value  ==  jsonObjArr[i].YYMM ){//데이터 존재
							$("preSnDt"+seq).value = jsonObjArr[i].SNDT;
							$("preBillAmt"+seq).value = jsonObjArr[i].BILLAMT;
							$("preAmt"+seq).value = jsonObjArr[i].AMT;
							$("preSgbbCd"+seq).value = jsonObjArr[i].SGBBNM;
						}
						if($("nowYear"+seq).value  ==  jsonObjArr[i].YYMM ){
							$("nowSnDt"+seq).value = jsonObjArr[i].SNDT;
							$("nowBillAmt"+seq).value = jsonObjArr[i].BILLAMT;
							$("nowAmt"+seq).value = jsonObjArr[i].AMT;
							$("nowSgbbCd"+seq).value = jsonObjArr[i].SGBBNM;
						}	
						if($("nextYear"+seq).value  ==  jsonObjArr[i].YYMM ){
							$("nextSnDt"+seq).value = jsonObjArr[i].SNDT;
							$("nextBillAmt"+seq).value = jsonObjArr[i].BILLAMT;
							$("nextAmt"+seq).value = jsonObjArr[i].AMT;
							$("nextSgbbCd"+seq).value = jsonObjArr[i].SGBBNM;
						}
					}
				}
				for ( var i = 0; i < jsonObjArr.length; i++) {
					if (i == jsonObjArr.length - 2) {
						$("sumgClam").innerHTML = jsonObjArr[i].thisYear;
						$("thisYearSumgClam").innerHTML = jsonObjArr[i].thisYear;
					}
					if (i == jsonObjArr.length - 1) {
						$("lastYearSumgClam").innerHTML = jsonObjArr[i].lastYear;
					}
				}
			}
	
		}
		
		//작년 금년 수금
		function sumgClam(gbn){
			if(gbn == 'last'){
				$("sumgClam").innerHTML = $("lastYearSumgClam").innerHTML;	
			}else{
				$("sumgClam").innerHTML = $("thisYearSumgClam").innerHTML;	
			}
		}
	
	</script>
</head>
<body>
<div class="box_Popup">
	<div class="pop_title_box">본사신청독자 상세보기</div>
	<div style="padding-top: 10px;">
	<form id="readerListForm" name="readerListForm" method="post">
		<!-- 페이징 처리 변수 -->
		<input type=hidden id="detailPageNo" name="detailPageNo" value="${param.pageNo}" />
		<!-- //페이징 처리 변수 -->
		<!--독자 상세정보-->
		<table width="100%" cellpadding="0" cellspacing="0"  border="0" style="padding-left: 10px;padding-right: 10px;">
			<tr>
				<td style="width: 590px;">
					<font class="b03"><b>[ 독자정보 ]</b></font> 
					<!-- 독자정보 -->
					<table class="tb_view" style="width: 590px">
						<colgroup>
							<col width="70px">
							<col width="126px">
							<col width="70px">
							<col width="126px">
							<col width="70px">
							<col width="127px">
						</colgroup>
						<tr>
						    <th>지 국</th>
							<td colspan="3"><input type="text" id="boseqNm" value="${readerInfo.JIKUKNM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
							<th>독자상태</th>
							<td>
								<input type="text" id="stdtNm" value="${readerInfo.STDTNM}" style="border: 0; width: 95%; font-weight: bold;" readonly="readonly"/>
							</td>
						</tr>
	  					<tr>
						    <th>독자번호</th>
							<td><input type="text" id="readno" value="${readerInfo.READNO}" style="border: 0; width: 95%;" readonly="readonly"/></td>
							<th>구역명</th>
							<td><input type="text" id="gnonm" value="${readerInfo.GNONM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
							<th>구역배달</th>
							<td><input type="text" id="gno" style="border: 0; width: 95%;" value='<c:out value="${readerInfo.GNO}"/>/<c:out value="${readerInfo.BNO}"/><c:out value="${readerInfo.SNO}"/>' readonly="readonly"/></td>
	  					</tr>
						<tr>
						    <th>독자명</th>
							<td colspan="3"><input type="text" id="readnm" value="${readerInfo.READNM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
							<th>생년월일</th>
							<td><input type="text" id="bidt" value="${readerInfo.BIDT}" style="border: 0; width: 95%;" readonly="readonly"/></td>
						</tr>
						<tr>
						    <th>전화번호</th>
							<td><input type="text" id="hometel" value="${readerInfo.HOMETEL}" style="border: 0; width: 95%;" readonly="readonly"/></td>
							<th>핸드폰</th>
							<td><input type="text" id="mobile" value="${readerInfo.MOBILE}" style="border: 0; width: 95%;" readonly="readonly"/></td>
							<th>E-mail</th>
							<td><input type="text" id="email" value="${readerInfo.EMAIL}" style="border: 0; width: 95%;" readonly="readonly"/></td>
						</tr>
						<tr>
						    <th>도로명주소</th>
							<td style="text-align: left;"><input type="text" id="dlvzip" value="${readerInfo.DLVZIP}" style="border: 0; width: 95%;" readonly="readonly"/></td>
							<td colspan="4"><input type="text" id="newaddr" value="${readerInfo.NEWADDR}" style="width: 98%; border: 0"  readonly="readonly"/></td>
						</tr>
						<tr>
						    <th>상세주소</th>
							<td colspan="5"><input type="text" id="dlvadrs2" value="${readerInfo.DLVADRS2}" style="width: 98%; border: 0" readonly="readonly"/></td>
						</tr>
						<tr>
							<th>주거구분</th>
							<td><input type="text" id="rsdtypenm" value="${readerInfo.RSDTYPENM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
							<th>직종</th>
							<td><input type="text" id="tasknm" value="${readerInfo.TASKNM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
							<th>관심분야</th>
							<td><input type="text" id="intflnm" value="${readerInfo.INTFLDNM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
						</tr>
					</table>
					<!-- 구독정보 -->
					<div style="padding: 10px 0 0 0"><font class="b03"><b>[ 구독정보 ]</b></font></div>
					<table class="tb_view" style="width: 590px">
						<colgroup>
							<col width="70px">
							<col width="126px">
							<col width="70px">
							<col width="126px">
							<col width="70px">
							<col width="127px">
						</colgroup>
					    <tr>
						    <th>신 문 명 </th>
							<td><input type="text" id="newsnm" value="${readerInfo.NEWSNM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
							<th>확장일자</th>
							<td><input type="text" id="hjdt" value="${readerInfo.HJDT}" style="border: 0; width: 95%;" readonly="readonly"/></td>
							<th>독자유형</th>
							<td><input type="text" id="readtypenm" value="${readerInfo.READTYPENM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
					    </tr>
					    <tr>
						    <th>구독부수</th>
							<td>
								<input type="text" id="qty" value="${readerInfo.QTY}" style="border: 0; width: 55px;" readonly="readonly"/>
								<input type="text" id="sumQty" name="sumQty" value="" style="color:blue; width: 55px; border: 0;" readonly="readonly">
							</td>
							<th>유가년월</th>
							<td><input type="text" id="sgbgmm" value="${readerInfo.SGBGMM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
							<th>배달유형</th>
							<td><input type="text" id="dlvtypenm" value="${readerInfo.DLVTYPENM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
					    </tr>
					    <tr>
						    <th>단&nbsp;&nbsp;&nbsp;&nbsp;가</th>
							<td>
								<input type="text" id="uprice" value="${readerInfo.UPRICE}" style="border: 0; width: 55px;" readonly="readonly"/>
								<input type="text" id="sumUprice" name="sumUprice" value="" style="color:blue; width:55px; border: 0;" readonly="readonly"/>
							</td>
							<th>신청경로</th>
							<td><input type="text" id="hjpathnm" value="${readerInfo.HJPATHNM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
							<th>배달장소</th>
							<td><input type="text" id="dlvposinm" value="${readerInfo.DLVPOSINM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
					    </tr>
					    <tr>
						    <th>수금방법</th>
							<td><input type="text" id="sgtypenm" value="${readerInfo.SGTYPENM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
							<th>확 장 자</th>
							<td><input type="text" id="hjpsnm" value="${readerInfo.HJPSNM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
							<th>자 매 지 </th>
							<td><input type="text" id="bnsbooknm" value="${readerInfo.BNSBOOKNM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
					    </tr>
					    <tr>
						    <th>구독일자</th>
							<td><input type="text" id="hjdt" value="${readerInfo.HJDT}" style="border: 0; width: 95%;" readonly="readonly"/></td>
							<th>구독기간</th>
							<td><input type="text" id="term" value="${readerInfo.TERM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
							<th>판촉물</th>
							<td><input type="text" id="spgnm" value="${readerInfo.SPGNM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
					    </tr>
					    <tr>
						    <th>해지일자</th>
							<td><input type="text" id="stdt" value="${readerInfo.STDT}" style="border: 0; width: 95%;" readonly="readonly"/></td>
							<th>해지사유</th>
							<td colspan="3"><input type="text" id="stsayounm" value="${readerInfo.STSAYOUNM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
					    </tr>
					</table>
					<!-- //구독정보 -->
					<!-- 통화기록 -->
					<div style="padding: 10px 0 0 0"><font class="b03"><b>[ 통화기록 ]</b></font></div>
					<table class="tb_view" style="width: 590px">
					<colgroup>
						<col width="100px">
						<col width="473px">
						<tr>
							<th>통화시간</th>
							<th>통화내용</th>
						</tr>
					</table>
					<div id="callList" style="width: 590px; height: 125px; float: left; overflow-y: scroll; overflow-x: none;">
					<table class="tb_view" style="width: 573px">
						<colgroup>
							<col width="101px">
							<col width="473px">
						</colgroup>
						<tbody id="callListTbody" style="background-color: white">
						</tbody>
					</table>
					</div>
					<!-- //통화기록 -->
				</td>
				<!--// 독자정보 -->
				<td width="40%" valign="top" align="left" style="padding-left: 10px;">
					<font class="b03"><b>[ 수금정보 ]</b></font>
					<!-- 수금정보 -->			
					<table width="100%" cellpadding="0" cellspacing="0"  border="0">
						<tr>
							<td style="position:relative;">
								<table width="100%" cellpadding="1" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
				    				
				    				<tr>
	  									<td width="20">
											<a href="javascript:changSumgList('1');"><img src="/images/bt_gf02.gif" style="width:45" alt="이전" border="0" align="absmiddle"/></a>
										</td>
										<td width="20">
											<a href="javascript:changSumgList('2');"><img src="/images/bt_gf03.gif" style="width:45" alt="다음" border="0" align="absmiddle"/></a>
										</td>
										<td width="40">	
											<a href="javascript:sumgClam('last');"><img src="/images/bt_money01.gif" alt="작년수금" border="0" align="absmiddle"/></a>
										</td>
										<td align="center">
											<span id="sumgClam" name="sumgClam" >------------</span>
											<span id="lastYearSumgClam" name="lastYearSumgClam" style="display:none;"></span>
											<span id="thisYearSumgClam" name="thisYearSumgClam" style="display:none;"></span>
										</td>
										<td width="40">
											<a href="javascript:sumgClam('now');"><img src="/images/bt_money02.gif" alt="금년수금" border="0" align="absmiddle"/></a>
										</td>
	  								</tr>
								</table>
								<table class="tb_sugm" style="width: 385px">
									<colgroup>
										<col width="50px">
										<col width="80px">
										<col width="80px">
										<col width="80px">
										<col width="95px">
									</colgroup>
	   								<tr>
										<th>년월</th>									
										<th>수금일자</th>
										<th id="chgColumn">금액</th>
										<th>수금액</th>
										<th colspan="2">방법</th>
									</tr>
								</table>
								<table class="tb_sugm" style="width: 385px">
									<colgroup>
										<col width="50px">
										<col width="80px">
										<col width="80px">
										<col width="80px">
										<col width="95px">
									</colgroup>
						<%for (int i=1 ; i< 13 ; i++){ 
							String seq = "";
							if(i<10){
								seq = "0"+i;
							}else{
								seq = Integer.toString(i);
							}
						%>
									<tr id="pre<%=seq %>" style="display:none;">
										<td>
											<b><%=(String)request.getAttribute("lastyymm"+seq) %></b>
											<input type="hidden" id="preYear<%=seq %>" name="preYear<%=seq %>" value="<%=(String)request.getAttribute("lastyymm"+seq) %>" />
										</td>
										<td><input type="text" id="preSnDt<%=seq %>" name="preSnDt<%=seq %>" style="width: 75px"  readonly="readonly"/></td>
										<td><input type="text" id="preBillAmt<%=seq %>" name="preBillAmt<%=seq %>" style="width: 75px"  readonly="readonly"/></td>
										<td><input type="text" id="preAmt<%=seq %>" name="preAmt<%=seq %>" style="width: 75px" readonly="readonly"/></td>
										<td colspan="2"><input type="text" name="preSgbbCd<%=seq %>" id="preSgbbCd<%=seq %>" style="width: 90px" readonly="readonly"/></td>
									</tr>
								<%} %>
								</table>
								<table class="tb_sugm" style="width: 385px">
									<colgroup>
										<col width="50px">
										<col width="80px">
										<col width="80px">
										<col width="80px">
										<col width="95px">
									</colgroup>
									<%for (int i=1 ; i< 13 ; i++){ 
	  										String seq = "";
	  										if(i<10){
	  											seq = "0"+i;
	  										}else{
	  											seq = Integer.toString(i);
	  										}
	  										if(i == 12){%>
	  											<tr id="now<%=seq %>" style="display:block; background-color: #f48d2e;">
	  										<%}else{%>
	  											<tr id="now<%=seq %>" style="display:block;">
	  										<%} %>
											<td style="width: 47px">
												<b><%=(String)request.getAttribute("nowyymm"+seq) %></b>
												<input type="hidden" id="nowYear<%=seq %>" name="nowYear<%=seq %>" value="<%=(String)request.getAttribute("nowyymm"+seq) %>" />
											</td>
											<td><input type="text" id="nowSnDt<%=seq %>" name="nowSnDt<%=seq %>" style="width: 75px" readonly="readonly"/></td>
											<td><input type="text" id="nowBillAmt<%=seq %>" name="nowBillAmt<%=seq %>" style="width: 75px" readonly="readonly"/></td>
											<td><input type="text" id="nowAmt<%=seq %>" name="nowAmt<%=seq %>" style="width: 75px" readonly="readonly"/></td>
											<td colspan="2"><input type="text" name="nowSgbbCd<%=seq %>" id="nowSgbbCd<%=seq %>" style="width: 90px" readonly="readonly"/></td>
										</tr>
								<%} %>
								</table>
								<table class="tb_sugm" style="width: 385px">
									<colgroup>
										<col width="50px">
										<col width="80px">
										<col width="80px">
										<col width="80px">
										<col width="95px">
									</colgroup>
									<%for (int i=1 ; i< 13 ; i++){ 
	  										String seq = "";
	  										if(i<10){
	  											seq = "0"+i;
	  										}else{
	  											seq = Integer.toString(i);
	  										}
	  								%>
									<tr id="next<%=seq %>" style="display:none;">
										<td style="width: 47px">
											<b><%=(String)request.getAttribute("nextyymm"+seq) %></b>
											<input type="hidden" id="nextYear<%=seq %>" name="nextYear<%=seq %>" value="<%=(String)request.getAttribute("nextyymm"+seq) %>" />
										</td>
										<td><input type="text" id="nextSnDt<%=seq %>" name="nextSnDt<%=seq %>" style="width: 75px" readonly="readonly"/></td>
										<td><input type="text" id="nextBillAmt<%=seq %>" name="nextBillAmt<%=seq %>" style="width: 75px" readonly="readonly"/></td>
										<td><input type="text" id="nextAmt<%=seq %>" name="nextAmt<%=seq %>" style="width: 75px" readonly="readonly"/></td>
										<td colspan="2"><input type="text" name="nextSgbbCd<%=seq %>" id="nextSgbbCd<%=seq %>" style="width: 90px" readonly="readonly"/></td>
									</tr>
								<%} %>
								</table>
							</td>
						</tr>
					</table>
					<!--// 수금정보 -->
					<!-- 비고 -->
					<div style="padding-top: 10px;"><font class="b03"><b>[ 비 고 ]</b></font></div> 
					<div><textarea id="desc" name="desc" rows="" cols="" readonly="readonly" style="border: 1px solid #e5e5e5; width: 380px; height: 190px"></textarea></div> 
					<!-- <div id="desc" style="width: 100%; height: 140px; float: left; overflow-y: scroll; padding-left: 10px;"> -->
						<!-- <textarea id="descArea" name="descArea" rows="8" cols="45" readonly="readonly"></textarea>  -->
					<!-- </div> -->
					<!-- //비고 -->
				</td>
			</tr>
		</table>
		<!--// 독자 상세정보-->					
		<div style="padding-top: 10px;">
			<!--통합 내용출력자리-->
			<table class="tb_list_a" style="width: 985px; margin: 0 auto">
				<colgroup>
					<col width="60px">
					<col width="70px">
					<col width="50px">
					<col width="100px">
					<col width="30px">
					<col width="80px">
					<col width="80px">
					<col width="255px">
					<col width="70px">
					<col width="55px">
					<col width="50px">
					<col width="30px">
					<col width="55px">
				</colgroup>
				<tr>
					<th>구역배달</th>
					<th>독자</th>
					<th>매체명</th>
					<th>독자명</th>
					<th>부수</th>
					<th>전화번호</th>
					<th>핸드폰</th>
					<th>주소</th>
					<th>확장/중지</th>
					<th>총수금</th>
					<th>미수액</th>
					<th>통화</th>
					<th>민원</th>
				</tr>
			</table>
			<div style="overflow-y: scroll; overflow-x: none; width: 985px; height: 130px; margin: 0 auto">
			<table class="tb_list_a" style="width: 968px;">
				<colgroup>
					<col width="60px">
					<col width="68px">
					<col width="50px">
					<col width="101px">
					<col width="30px">
					<col width="80px">
					<col width="80px">
					<col width="255px">
					<col width="70px">
					<col width="52px">
					<col width="50px">
					<col width="30px">
					<col width="38px">
				</colgroup>
				<c:choose>
					<c:when test="${empty readerList}">
						<tr>
							<td colspan="13" align="center">검색 결과가 없습니다.</td>
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach items="${readerList}" var="list" varStatus="i">
							<c:choose>
								<c:when test="${list.BNO eq '999'}">
									<c:if test="${flag==1 and i.first}">
										<script type="text/javascript">
											detailView('${list.SEQ}','${list.READNO}','${list.NEWSCD}', '${list.BOSEQ}');
										</script>
									</c:if>
									<tr onclick="detailView('${list.SEQ}','${list.READNO}','${list.NEWSCD}', '${list.BOSEQ}')" style="cursor:pointer; color: #e74985; background-color: #f9f9f9">
										<td>${list.GNO }-${list.BNO }</td>
										<td>${list.READNO }</td>
										<td>${list.NEWSNM }</td>
										<td><c:out value="${list.READNM }"/></td>
										<td>${list.QTY }</td>
										<td style="text-align: left;">${list.HOMETEL }</td>
										<td style="text-align: left;">${list.MOBILE }</td>
										<td style="text-align: left;">${list.ADDR }</td>
										<td>${fn:substring(list.STDT,0,4) }-${fn:substring(list.STDT,4,6) }-${fn:substring(list.STDT,6,8) }</td>
										<td><fmt:formatNumber value="${list.SUMCOLLECT }" type="number" /></td>
										<td><fmt:formatNumber value="${list.ACCOUNTDUE }" type="number" /></td>
										<td><fmt:formatNumber value="${list.CALL_CNT }" type="number" /></td>
										<td><fmt:formatNumber value="" type="number" /></td>
									</tr>
								</c:when>
								<c:otherwise>
									<c:if test="${flag==1 and i.first}">
										<script type="text/javascript">
											detailView('${list.SEQ}','${list.READNO}','${list.NEWSCD}', '${list.BOSEQ}');
										</script>
									</c:if>
									<tr onclick="detailView('${list.SEQ}','${list.READNO}','${list.NEWSCD}', '${list.BOSEQ}')" style="cursor: pointer;">
										<td>${list.GNO }-${list.BNO }</td>
										<td>${list.READNO }</td>
										<td>${list.NEWSNM }</td>
										<td style="text-align: left;"><c:out value="${list.READNM }"/></td>
										<td>${list.QTY }</td>
										<td style="text-align: left;">${list.HOMETEL }</td>
										<td style="text-align: left;">${list.MOBILE }</td>
										<td style="text-align: left;">${list.ADDR }</td>
										<td>${fn:substring(list.HJDT,0,4) }-${fn:substring(list.HJDT,4,6) }-${fn:substring(list.HJDT,6,8) }</td>
										<td><fmt:formatNumber value="${list.SUMCOLLECT }" type="number" /></td>
										<td><fmt:formatNumber value="${list.ACCOUNTDUE }" type="number" /></td>
										<td><fmt:formatNumber value="${list.CALL_CNT }" type="number" /></td>
										<td><fmt:formatNumber value="" type="number" /></td>
									</tr>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</table>
			</div>
		</div>
		<!--// 통합 내용출력자리-->
	<!-- main 끝-->
	</form>
	</div>
</div>
</body>
</html>
