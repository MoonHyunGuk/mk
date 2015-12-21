<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ page import="com.mkreader.security.ISiteConstant" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/js/mini_calendar2.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/jquery.gifplayer.js"></script>
<script type="text/javascript">
/*----------------------------------------------------------------------
 * Desc   : 독자정보를 조회 한다.
 * Auth   : 박윤철
 *----------------------------------------------------------------------*/
function fn_search(){
	 var fm = document.getElementById("integSearchForm");

	fm.action="/reader/minwon/selectTotalReaderSearch.do";
	fm.target="_self";
	fm.submit();
	jQuery("#prcssDiv").show();
}


//우편주소팝업에서 우편주소 선택시 셋팅 펑션
function setAddr(zip , addr, newAddr, bdNm, dbMngNo){
	var fm = document.getElementById("integSearchForm") ;
	
	fm.dlvZip.value = zip;
	fm.newaddr.value = newAddr;
	fm.dlvAdrs2.value = bdNm;
	fm.bdMngNo.value = dbMngNo;
	fm.dlvAdrs1.value = addr;
} 

//자세히 보기, 독자 수금정보 조회(ajax)
function fn_detailView(readNo, newsCd, seq, boSeq) {
	var fm = document.getElementById("integSearchForm");
	var totAddr = "";
	fm.desc.value = "";
	
	//독자정보조회
	jQuery.ajax({
		type 		: "POST",
		url 		: "/reader/readerManage/ajaxSelectReaderData.do",
		dataType 	: "json",
		data		: "readNo="+readNo+"&boSeq="+boSeq+"&seq="+seq+"&newsCd="+newsCd,
		success:function(data){
			var result = data.readerData;
			var guYukList = data.guYukList;
			var areaCodeList = data.areaCodeList;
			var mobileCodeList = data.mobileCodeList;
			
			//지국별 구역리스트
			jQuery("#gno").empty();
			if(guYukList.length > 0) {
				for(var g=0;g<guYukList.length;g++) {
					jQuery("#gno").append("<option value='"+guYukList[g].GU_NO+"'>"+guYukList[g].GU_NM+"</option>");
				}
			}
			
			//지국별 구역리스트
			jQuery("#homeTel1").empty();
			if(areaCodeList.length > 0) {
				for(var h=0;h<areaCodeList.length;h++) { 
					jQuery("#homeTel1").append("<option value='"+areaCodeList[h].CODE+"'>"+areaCodeList[h].CODE+"</option>");
				}
			}
			
			//지국별 구역리스트
			jQuery("#mobile1").empty();
			if(mobileCodeList.length > 0) {
				for(var m=0;m<mobileCodeList.length;m++) {
					jQuery("#mobile1").append("<option value='"+mobileCodeList[m].CODE+"'>"+mobileCodeList[m].CODE+"</option>");
				}
			}
			
			fm.boSeq.value = result.BOSEQ;
			fm.boSeqNm.value  = result.BOSEQNM;
			fm.seq.value = result.SEQ;
			fm.readNo.value = result.READNO;
			fm.readNoDiv.value = result.READNO;
			fm.gno.value = result.GNO;
			fm.readNm.value = result.READNM;
			fm.homeTel1.value = result.HOMETEL1;
			fm.homeTel2.value = result.HOMETEL2;
			fm.homeTel3.value = result.HOMETEL3;
			fm.mobile1.value = result.MOBILE1;
			fm.mobile2.value = result.MOBILE2;
			fm.mobile3.value = result.MOBILE3;
			fm.dlvZip.value = result.DLVZIP;
											
			if(result.NEWADDR.length < 1) {
				totAddr = result.DLVADRS1;
			} else {
				totAddr = result.NEWADDR+" <b>("+result.DLVADRS1+")</b>";
			}
			fm.newaddr.value = "&nbsp;"+totAddr;
			fm.dlvAdrs2.value = result.DLVADRS2;
			fm.newaddr.value = result.NEWADDR;
			fm.bdMngNo.value = result.BDMNGNO;
			fm.newsNm.value = result.NEWSNM;
			fm.oldGno.value = result.GNO;
			fm.readTypeCd.value =  result.READTYPECD;
			fm.oldReadTypeCd.value =  result.READTYPECD;
			fm.qty.value =  result.QTY;
			if(result.QTY != result.SUMQTY && result.SUMQTY>0) {
				fm.sumQty.value =  result.SUMQTY;
			} else {
				fm.sumQty.value =  "";
			}
			fm.oldQty.value =  result.QTY;
			fm.uPrice.value =  result.UPRICE;
			if(result.UPRICE != result.SUMUPRICE && result.SUMUPRICE != null) {
				fm.sumUprice.value = result.SUMUPRICE;
			} else {
				fm.sumUprice.value =  "";
			}
			
			fm.sgType.value =  result.SGTYPE;
			fm.oldSgType.value =  result.SGTYPE;
			fm.orgChgDt.value =  result.ORGCHGDT;
			fm.term.value = result.TERM+"개월";
			fm.stdt.value = jQuery.trim(result.STDT);
			fm.stSayou.value = result.STSAYOU;
			var chkStdt = jQuery.trim(result.STDT);
			if(chkStdt.length < 1) {
				fm.stdtNm.value = "정상";
				jQuery("#btnRecovery").hide();
			} else {
				fm.stdtNm.value = "해지";
				jQuery("#btnRecovery").show();
			}
	 		fm.sgBgmm.value = result.SGBGMM;
	 		fm.autoCnt.value = result.AUTOCNT;
	 		fm.cardCnt.value = result.CARDCNT;
		},
		error    : function(r) { alert("독자정보조회 에러"); }
	}); //ajax end
	
	//독자정보조회
	jQuery.ajax({
		type 		: "POST",
		url 		: "/reader/readerManage/ajaxSelectReaderSumgData.do",
		dataType 	: "json",
		data		: "readNo="+readNo+"&boSeq="+boSeq+"&seq="+seq+"&newsCd="+newsCd,
		success:function(data){
			var jsonSugmList = data.readerSugmData;
			var seqMonth = "";
			if(jsonSugmList.length >0) {
				for(var s=0; s<jsonSugmList.length; s++) {
					if(s<10) {
						seqMonth = "0"+s;
					} else {
						seqMonth = s;
					}
					jQuery("#nowSnDt"+seqMonth).val(jsonSugmList[s].SNDT);
					jQuery("#nowBillAmt"+seqMonth).val(jsonSugmList[s].BILLAMT);
					jQuery("#nowAmt"+seqMonth).val(jsonSugmList[s].AMT);
					jQuery("#nowSgbbCd"+seqMonth).val(jsonSugmList[s].SGBBCD);
				}
			}
		},
		error    : function(r) { alert("독자수금조회 에러"); }
	}); //ajax end
	
	//메모리스트 조회
	jQuery.ajax({
		type 		: "POST",
		url 		: "/util/memo/getAjaxMemoOfRecently.do",
		dataType 	: "json",
		data		: "readNo="+readNo,
		success:function(data){
			var jsonObjArr = data.memoList;
			
			var div_head = document.createElement("div");
			var div_note = document.createElement("div");
			if (jsonObjArr.length > 0) {
				for(var j=0 ; j < jsonObjArr.length ; j++){
					div_note = document.createElement("div");//font-weight: bold;
					div_head = document.createElement("div");
					//div_note.onclick = function() {fn_insert_note(jsonObjArr[j].MEMO);};
					div_head.style.cssText = "font-weight: bold; padding: 3px 0 0 3px;";
					div_note.style.cssText = "border-bottom: 1px solid #e0e0e0; padding: 0 0 3px 0";
					div_head.innerText = "["+jsonObjArr[j].CREATE_ID+"] "+jsonObjArr[j].CREATE_DATE;
					div_note.innerText = jsonObjArr[j].MEMO;
					jQuery("#desc").append(div_head);
					jQuery("#desc").append(div_note);
					//document.getElementById("remk").value = jsonObjArr[0].MEMO;
				}
			}else{
				div = document.createElement("div");
				div.innerText = "기록이 없습니다.";
				jQuery("desc").append(div);
			}
		},
		error    : function(r) { alert("독자메모조회 에러"); }
	}); //ajax end
}

/**
 * 
 */
function fn_recovery() {
	var fm = document.getElementById("integSearchForm");
	var autoCnt = document.getElementById("autoCnt").value;
	var cardCnt = document.getElementById("cardCnt").value;
}

/** Jquery setting */
jQuery.noConflict();
jQuery(document).ready(function($) {
	$("#prcssDivAuto").gifplayer();
	$("#prcssDiv").hide();
});
</script>
<div><span class="subTitle">통합독자리스트</span></div>
<form id="integSearchForm" name="integSearchForm" method="post" >
	<input type="hidden" name="boSeq" id="boSeq" />
	<input type="hidden" name="seq" id="seq" />
	<input type="hidden" name="readNo" id="readNo" />
	<input type="hidden" name="bdMngNo" id="bdMngNo" />
	<input type="hidden" name="oldReadTypeCd" id="oldReadTypeCd" />
	<input type="hidden" name="oldGno" id="oldGno" />
	<input type="hidden" name="oldSgType" id="oldSgType" />
	<input type="hidden" name="oldQty" id="oldQty" />
	<input type="hidden" name="orgChgDt" id="orgChgDt" />
	<input type="hidden" name="dlvAdrs1" id="dlvAdrs1" />
	<input type="hidden" name="stQty" id="stQty" />
	<input type="hidden" name="autoCnt" id="autoCnt" />
	<input type="hidden" name="cardCnt" id="cardCnt" />
	
<!-- search conditions -->
<div style="width: 1020px; margin: 0 auto;">
	<div style="width: 612px; border-right: 1px solid #c0c0c0; border-left: 1px solid #c0c0c0; border-top: 1px solid #c0c0c0; padding: 5px 5px 0 5px; float: left;">
		<select id="searchType" name="searchType" style="vertical-align: middle; padding: 3px; margin-top: -1px;">
			<option value="addr" <c:if test="${searchType eq 'addr' }"> selected </c:if>>주소</option>
			<option value="readnm" <c:if test="${searchType eq 'readnm' }"> selected </c:if>>독자명</option>
			<option value="readno" <c:if test="${searchType eq 'readno' }"> selected </c:if>>독자번호</option>
			<option value="telno" <c:if test="${searchType eq 'telno' }"> selected </c:if>>연락처</option>
		</select>&nbsp;
		<input type="text" id="searchValue" name="searchValue" onkeydown="if(event.keyCode == 13){fn_search(); }" value="${searchValue}" style="width: 445px; vertical-align: middle; padding: 4px 5px; margin-top: -1px;" maxlength="20"></input>
		<span class="btnCss2" ><a class="lk2" onclick="fn_search();" style="font-weight: bold;">검색</a></span>
	</div> 
	<div style="padding: 0 5px 5px 5px; border-bottom: 1px solid #c0c0c0; width: 386px; float: left; text-align: right;"> 
		<input type="text" id="opSearchJikuk" name="opSearchJikuk" onkeydown="if(event.keyCode == 13){}" value="" style="width: 200px; vertical-align: middle; padding: 4px 5px; margin-top: -1px"></input> 
		<span class="btnCss2" ><a class="lk2" onclick="" style="font-weight: bold;">검색</a></span>
	</div>
</div> 
<!-- //search conditions -->
<div style="padding: 0; clear: both;">
	<div style="width: 1010px; margin: 0 auto; overflow: hidden; padding: 5px 4px; border-right: 1px solid #c0c0c0; border-left: 1px solid #c0c0c0; border-bottom: 1px solid #c0c0c0; ">
		<div style="width: 615px; float: left; overflow: hidden; border: 0px solid red">
			<!-- 독자정보 -->
			<table class="tb_view" style="width: 615px">
				<colgroup>
					<col width="25px"> 
					<col width="70px">
					<col width="126px">
					<col width="70px"> 
					<col width="126px">
					<col width="70px">
					<col width="127px">
				</colgroup>
				<tr>
					<th rowspan="9">독<br/><br/><br/>자<br/><br/><br/>정<br/><br/><br/>보</th>
				    <th>지 국</th>
					<td colspan="3"><input type="text" id="boSeqNm" name="boSeqNm" value="" style="width: 200px; border: 0;" readonly="readonly"/></td>
					<th>독자상태</th>
					<td><input type="text" id="stdtNm" name="stdtNm" value="" style="width: 95%; font-weight: bold; border: 0;" readonly="readonly"/></td>
				</tr>
					<tr>
				    <th>독자번호</th>
					<td><input type="text" id="readNoDiv" name="readNoDiv" value="" style="width: 95%; border: 0;" readonly="readonly"/></td>
					<th>구역배달</th>
					<td>
						<select id="gno" name="gno" style="width: 80px;">
						</select>
					</td>
					 <th>전화번호</th>
					<td>
						<select id="homeTel1" name="homeTel1" style="vertical-align: middle; width: 45px; padding: 1px 0;">
						</select>
						<input type="text" id="homeTel2" name="homeTel2" value="" maxlength="4" style="ime-mode:disabled; width: 30px; vertical-align: middle;" onkeypress="inputNumCom();">
						<input type="text" id="homeTel3" name="homeTel3" value="" maxlength="4" style="ime-mode:disabled; width: 30px; vertical-align: middle;" onkeypress="inputNumCom();">
					</td>
					</tr>
				<tr>
				    <th>독자명</th>
					<td colspan="3"><input type="text" id="readNm" name="readNm" value="" style="width: 95%;" readonly="readonly"/></td>
					<th>핸드폰</th>
					<td>
						<select id="mobile1" name="mobile1" style="vertical-align: middle; width: 45px; padding: 1px 0;">
						</select>
						<input type="text" id="mobile2" name="mobile2" value="" maxlength="4" style="ime-mode:disabled; width: 30px; vertical-align: middle;" onkeypress="inputNumCom();">
						<input type="text" id="mobile3" name="mobile3" value="" maxlength="4" style="ime-mode:disabled; width: 30px; vertical-align: middle;" onkeypress="inputNumCom();">
					</td>
				</tr>
				<tr>
				    <th>도로명주소</th>
					<td style="text-align: left;">
						<input type="text" id="dlvZip" name="dlvZip" value="" style="width: 60px; vertical-align: middle;" readonly="readonly"/>&nbsp;<a href="#fakeUrl" onclick="popAddr('integSearchForm');"><img alt="우편번호찾기" src="/images/ico_search2.gif" style="border: 0; vertical-align: middle;" /></a>
					</td>
					<td colspan="4"><input type="text" id="newaddr" name="newaddr" value="" style="width: 98%; border: 0;"  readonly="readonly"/></td>
				</tr>
				<tr>
				    <th>상세주소</th>
					<td colspan="5"><input type="text" id="dlvAdrs2" name="dlvAdrs2" value="" style="width: 98%;" readonly="readonly"/></td>
				</tr>
			    <tr>
				    <th>신 문 명 </th>
					<td>
						<input type="text" id="newsNm" name="newsNm" value="" style="width: 98%; border: 0;" readonly="readonly"/>
					</td>
					<th>구독기간</th>
					<td><input type="text" id="term" name="term" value="" style="width: 95%; border: 0;" readonly="readonly"/></td>
					<th>독자유형</th>
					<td>
						<select name="readTypeCd" id="readTypeCd" style="width: 95%;">
							<c:forEach items="${readTypeList }" var="list">
							<option value="${list.CODE }">${list.CNAME }</option>
							</c:forEach>
						</select>
					</td>
			    </tr>
			    <tr>
				    <th>구독부수</th>
					<td>
						<input type="text" id="qty" name="qty" value="" style="width: 30px" maxlength="3"/>
						<input type="text" id="sumQty" name="sumQty" value="" style="color:blue; width: 55px; border: 0;" readonly="readonly">
					</td>
					<th>유가년월</th>
					<td><input type="text" id="sgBgmm" name="sgBgmm" value="" style="width: 95%;" readonly="readonly"/></td>
					<th>수금방법</th>
					<td>
						<select name="sgType" id="sgType" style="width:80px">
							<c:forEach items="${sgTypeList }" var="list">
							<option value="${list.CODE }">${list.CNAME }</option>
							</c:forEach> 
						</select>
					</td>
			    </tr>
			    <tr>
				    <th>단&nbsp;&nbsp;&nbsp;&nbsp;가</th>
					<td>
						<input type="text" id="uPrice" name="uPrice" value="" style="width: 55px;"/>
						<input type="text" id="sumUprice" name="sumUprice" value="" style="color:blue; width:55px; border: 0;" readonly="readonly"/>
					</td>
				    <th>해지일자</th>
					<td><input type="text" id="stdt" name="stdt" value="" style="width: 95%;" readonly="readonly" onclick="Calendar(this)"/></td>
					<th>해지사유</th>
					<td colspan="3">
						<select name="stSayou" id="stSayou" style="width: 90%">
							<option value=""></option>
							<c:forEach items="${stSayouList }" var="list"> 
								<option value="${list.CODE }">${list.CNAME }</option>
							</c:forEach>
						</select>
					</td>
			    </tr>
			    <tr>
			    	<th>비고</th>
			    	<td colspan="5"><textarea id="desc" name="desc" rows="" cols="" readonly="readonly" style="border: 1px solid #e5e5e5; width: 505px; height: 103px"></textarea></td>
			    </tr>
			</table>
			<!-- //구독정보 -->
		</div>
		<!-- //통화기록 -->
		<!--// 독자정보 -->
		<div style="width: 385px; float: left; border: 0px solid green ; padding-left: 7px; "> 
			<!-- 수금정보 -->			 
			<table class="tb_sugm" style="width: 385px">
				<colgroup>
					<col width="50px">
					<col width="80px">
					<col width="80px">
					<col width="80px">
					<col width="95px">
				</colgroup>
				<tr>
					<th colspan="5" style="padding: 10px 0;">수 금 정 보</th>									
				</tr>
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
					<c:set var="idx"  value="0"/>
					<c:forEach var="index" begin="1" end="12" step="1">
						<c:choose>
							<c:when test="${index < 10}">
								<c:set var="idx"  value="0${index }"/>
							</c:when>
							<c:otherwise>
								<c:set var="idx"  value="${index }"/>
							</c:otherwise>
						</c:choose>
						<tr id="now${idx}" style="display:block; <c:if test='${thisMonth eq idx }'>background-color: #f48d2e;</c:if>">
						<td style="width: 47px">
							<b>${thisYear}${idx}</b>
							<input type="hidden" id="nowYear${idx}" name="nowYear${idx}" value="2015${idx}" />
						</td>
						<td><input type="text" id="nowSnDt${idx}" name="nowSnDt${idx}" style="width: 75px" /></td>
						<td><input type="text" id="nowBillAmt${idx}" name="nowBillAmt${idx}" style="width: 75px" /></td>
						<td><input type="text" id="nowAmt${idx}" name="nowAmt${idx}" style="width: 75px" /></td>
						<td>
							<select name="nowSgbbCd${idx}" id="nowSgbbCd${idx}" style="width:80px">
								<option value=""></option>
								<c:forEach items="${sgTypeList }" var="list">
									<option value="${list.CODE }">${list.CNAME }</option>
								</c:forEach> 
							</select>
						</td>
					</tr>
				</c:forEach>
			</table>
			<!--// 수금정보 -->
			<!-- button -->
			<div style="padding: 5px 0 0 0; text-align: right;">
				<span id="btnRecovery" style="display: none;"><span class="btnCss2"><a class="lk2" onclick="fn_recovery();" style="font-weight: bold; color:red">독자복구</a></span></span>&nbsp;
				<span class="btnCss2"><a class="lk2" onclick="" style="font-weight: bold;">지국변경</a></span>&nbsp; 
				<span class="btnCss2" ><a class="lk2" onclick="" style="font-weight: bold;">부수추가</a></span>&nbsp;&nbsp;&nbsp; 
				<span class="btnCss2" ><a class="lk2" onclick="" style="font-weight: bold; color: blue">저&nbsp;&nbsp;&nbsp;장</a></span>
			</div>	
			<!-- //button -->
		</div>
		<!--// 독자 상세정보-->
	</div>					
</div>
<!-- list -->
<div class="box_list" style="padding-top: 5px; margin: 0 auto; clear: both; ">
	<table class="tb_list_a_5" style="width: 1020px">
		<colgroup>
			<col width="80px">
			<col width="80px">
			<col width="60px">
			<col width="160px">
			<col width="90px">
			<col width="50px">
			<col width="110px">
			<col width="300px">
			<col width="73px">
			<col width="17px">
		</colgroup>
		<tr>
			<th>지국</th>
			<th>독자번호</th>
			<th>매체명</th>
			<th>독자명</th>
			<th>수금방법</th>
			<th>부수</th>
			<th>전화번호</th>
			<th>주소</th>
			<th>확장/중지</th>
			<th>&nbsp;</th>
		</tr>
	</table>
	<div style="width: 1020px; margin: 0 auto; overflow-y: scroll; height: 250px;">
		<table class="tb_list_a_5" style="width: 1003px">
			<colgroup>
				<col width="80px">
				<col width="80px">
				<col width="60px">
				<col width="160px">
				<col width="90px">
				<col width="50px">
				<col width="110px">
				<col width="300px">
				<col width="73px">
			</colgroup>
			<c:choose>
				<c:when test="${empty readerList}">
					<tr>
						<td colspan="9" style="padding: 110px 0; font-size: 1.2em;">검색 결과가 없습니다.</td>
					</tr>
				</c:when>
				<c:otherwise>
					<c:forEach items="${readerList }" var="list" varStatus="i">
						<tr class="mover" onclick="fn_detailView('${list.READNO}', '${list.NEWSCD }', '${list.SEQ }', '${list.BOSEQ }' )" style="<c:if test="${list.BNO eq '999' }">color:#e74985;</c:if>" >
							<td>${list.BOSEQNM}</td>
							<td>${list.READNO}</td>
							<td>${list.NEWSSHORTNM}</td>
							<td><c:out value="${list.READNM}"/></td>
							<td>${list.SGTYPENM }</td>
							<td>${list.QTY}</td>
							<td><c:if test="${list.HOMETEL ne null}">${list.HOMETEL}<br/></c:if><c:if test="${list.MOBILE ne null}">${list.MOBILE}</c:if></td>
							<td>${list.ADDR}</td>
							<td>${fn:substring(list.HJDT,0,4) }-${fn:substring(list.HJDT,4,6) }-${fn:substring(list.HJDT,6,8) }</td>
						</tr>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</table>
	</div>
</div>
<!-- //list -->
</form>
<!-- processing viewer -->
<div id="prcssDiv"  class="loingProcessDiv"><div><img id="prcssDivAuto" src="/images/process4.gif" style="" data-playon="auto"/></div></div> 
<!-- //processing viewer --> 

