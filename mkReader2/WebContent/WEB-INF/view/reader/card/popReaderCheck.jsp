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
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript">
//  자세히 보기, 독자 수금정보 조회(ajax)
function detailView(seq, readno, newscd, boseq) {
	var fm = document.getElementById("readerListForm");
	//독자정보조회
	jQuery.ajax({
		type 		: "POST",
		url 		: "/reader/readerManage/ajaxSelectReaderData.do",
		dataType 	: "json",
		data		: "readNo="+readno+"&boSeq="+boseq+"&seq="+seq+"&newsCd="+newscd,
		success:function(data){
			var result = data.readerData;
			
			fm.boSeq.value = result.BOSEQ;
			fm.boSeqNm.value  = result.BOSEQNM;
			fm.seq.value = result.SEQ;
			fm.newsCd.value = result.NEWSCD;
			fm.readNo.value = result.READNO;
			fm.gno.value = result.GNO;
			fm.readNm.value = result.READNM; 
			fm.homeTel.value = result.HOMETEL1+"-"+result.HOMETEL2+"-"+result.HOMETEL3;
			fm.mobile.value = result.MOBILE1+"-"+result.MOBILE2+"-"+result.MOBILE3;;
			fm.dlvZip.value = result.DLVZIP;
			fm.newaddr.value = result.NEWADDR;
			fm.dlvAdrs1.value = result.DLVADRS1;
			fm.dlvAdrs2.value = result.DLVADRS2;
			fm.bdMngNo.value = result.BDMNGNO;
			fm.newsCd.value = result.NEWSCD;
			fm.newsNm.value = result.NEWSNM;
			fm.readTypeCd.value =  result.READTYPECD;
			fm.readTypeNm.value =  result.READTYPENM;
			fm.hjDt.value =  result.HJDT;
			fm.qty.value =  result.QTY;
			if(result.QTY != result.SUMQTY && result.SUMQTY>0) { 
				fm.sumQty.value =  result.SUMQTY;
			} else {
				fm.sumQty.value =  "";
			}
			fm.uPrice.value =  result.UPRICE;
			if(result.UPRICE != result.SUMUPRICE && result.SUMUPRICE != null) {
				fm.sumUprice.value = result.SUMUPRICE;
			} else {
				fm.sumUprice.value =  "";
			}
			
			fm.orgSgTypeCd.value =  result.SGTYPE;
			fm.sgTypeNm.value =  result.SGTYPENM;
			fm.term.value = result.TERM+"개월";
			fm.stdt.value = jQuery.trim(result.STDT);
			fm.stSayouNm.value = result.STSAYOUNM;
			jQuery("#stdtNm").empty();
			if(result.STSAYOUNM == null) {
				jQuery("#stdtNm").append("<span style='color:green;font-weight:bold'>정상</span>");
			} else {
				//fm.stdtNm.value = "<span style='color:red'>해지</span>";
				jQuery("#stdtNm").append("<span style='color:red;font-weight:bold'>해지</span>");
			}
	 		fm.sgBgmm.value = result.SGBGMM;
		},
		error    : function(r) { alert("독자정보조회 에러"); }
	}); //ajax end
}

/**
 * 선택버튼 클릭이벤트
 */
function fn_selectReaderInfo() {
	var boSeq = cf_getValue("boSeq");
	var seq = cf_getValue("seq");
	var newsCd = cf_getValue("newsCd");
	var stdt = cf_getValue("stdt");
	var orgSgTypeCd = cf_getValue("orgSgTypeCd"); 
	var readTypeCd = cf_getValue("readTypeCd");
	
	if(stdt.length > 1) {
		alert("중지된 독자는 선택하실 수 없습니다.");
		return false;
	}
	
	opener.document.getElementById("seq").value = seq;
	opener.document.getElementById("newsCd").value = newsCd;
	opener.document.getElementById("orgSgTypeCd").value = orgSgTypeCd;
	opener.document.getElementById("readTypeCd").value = readTypeCd;
	opener.document.getElementById("orgboSeq").value = boSeq;
	opener.document.getElementById("readNoChkYn").value = "Y";
	window.close();
}
</script>
</head>
<body>
<div class="box_Popup">
<div class="pop_title_box">독자상세보기</div>
<div style="padding-top: 10px;">
<form id="readerListForm" name="readerListForm" method="post">
	<!-- 페이징 처리 변수 -->
	<input type=hidden id="detailPageNo" name="detailPageNo" value="${param.pageNo}" />
	<input type=hidden id="boSeq" name="boSeq" value="" />
	<input type=hidden id="seq" name="seq" value="" />
	<input type=hidden id="bdMngNo" name="bdMngNo" value="" />
	<input type=hidden id="newsCd" name="newsCd" value="" />
	<input type=hidden id="orgSgTypeCd" name="orgSgTypeCd" value="" />
	<input type=hidden id="readTypeCd" name="readTypeCd" value="" />
	<!-- //페이징 처리 변수 -->
	<!--독자 상세정보-->
	<div style="width: 660px; border: 0px solid red ">
		<div><font class="b03"><b>[ 독자정보 ]</b></font></div>
		<!-- 독자정보 -->
		<div>
			<table class="tb_view" style="width: 660px">
				<colgroup>
					<col width="70px">
					<col width="150px">
					<col width="70px">
					<col width="150px">
					<col width="70px">
					<col width="150px">
				</colgroup>
				<tr>
				    <th>지 국</th>
					<td colspan="3"><input type="text" id="boSeqNm" value="${readerInfo.JIKUKNM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
					<th>독자상태</th>
					<td id="stdtNm"></td>
				</tr>
 				<tr>
				    <th>독자번호</th>
					<td><input type="text" id="readNo" value="${readerInfo.READNO}" style="border: 0; width: 95%;" readonly="readonly"/></td>
					<th>구역</th>
					<td><input type="text" id="gno" style="border: 0; width: 95%;" value='<c:out value="${readerInfo.GNO}"/>/<c:out value="${readerInfo.BNO}"/><c:out value="${readerInfo.SNO}"/>' readonly="readonly"/></td>
					<th>전화번호</th>
					<td><input type="text" id="homeTel" value="${readerInfo.HOMETEL}" style="border: 0; width: 95%;" readonly="readonly"/></td>
 				</tr>
				<tr>
				    <th>독자명</th>
					<td colspan="3"><input type="text" id="readNm" value="${readerInfo.READNM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
					<th>핸드폰</th>
					<td><input type="text" id="mobile" value="${readerInfo.MOBILE}" style="border: 0; width: 95%;" readonly="readonly"/></td>
				</tr>
				<tr>
				    <th>우편번호</th>
					<td style="text-align: left;"><input type="text" id="dlvZip" value="${readerInfo.DLVZIP}" style="border: 0; width: 95%;" readonly="readonly"/></td>
					<th>지번주소</th>
					<td colspan="3"><input type="text" id="dlvAdrs1" value="${readerInfo.DLVADRS1}" style="width: 98%; border: 0" readonly="readonly"/></td>
				</tr>
				<tr>
				    <th>도로명주소</th>
					<td colspan="5"><input type="text" id="newaddr" value="${readerInfo.NEWADDR}" style="width: 98%; border: 0"  readonly="readonly"/></td>
				</tr>
				<tr>
				    <th>상세주소</th>
					<td colspan="5"><input type="text" id="dlvAdrs2" value="${readerInfo.DLVADRS2}" style="width: 98%; border: 0" readonly="readonly"/></td>
				</tr>
			</table>
		</div>
		<!-- //독자정보 -->
		<div style="padding: 10px 0 0 0"><font class="b03"><b>[ 구독정보 ]</b></font></div>
		<div>
			<table class="tb_view" style="width: 660px">
				<colgroup>
					<col width="70px">
					<col width="150px">
					<col width="70px">
					<col width="150px">
					<col width="70px">
					<col width="150px">
				</colgroup>
			    <tr>
				    <th>신 문 명 </th>
					<td><input type="text" id="newsNm" value="${readerInfo.NEWSNM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
					<th>확장일자</th>
					<td><input type="text" id="hjDt" value="${readerInfo.HJDT}" style="border: 0; width: 95%;" readonly="readonly"/></td>
					<th>독자유형</th>
					<td><input type="text" id="readTypeNm" value="${readerInfo.READTYPENM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
			    </tr>
			    <tr>
				    <th>구독부수</th>
					<td>
						<input type="text" id="qty" value="${readerInfo.QTY}" style="border: 0; width: 55px;" readonly="readonly"/>
						<input type="text" id="sumQty" name="sumQty" value="" style="color:blue; width: 55px; border: 0;" readonly="readonly">
					</td>
					<th>유가년월</th>
					<td><input type="text" id="sgBgmm" value="${readerInfo.SGBGMM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
					<th>배달유형</th>
					<td><input type="text" id="dlvtypenm" value="${readerInfo.DLVTYPENM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
			    </tr>
			    <tr>
				    <th>단&nbsp;&nbsp;&nbsp;&nbsp;가</th>
					<td>
						<input type="text" id="uPrice" value="${readerInfo.UPRICE}" style="border: 0; width: 55px;" readonly="readonly"/>
						<input type="text" id="sumUprice" name="sumUprice" value="" style="color:blue; width:55px; border: 0;" readonly="readonly"/>
					</td>
					<th>수금방법</th>
					<td><input type="text" id="sgTypeNm" value="${readerInfo.SGTYPENM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
					<th>구독기간</th>
					<td><input type="text" id="term" value="${readerInfo.TERM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
			    </tr>
			    <tr>
				    <th>해지일자</th>
					<td><input type="text" id="stdt" value="${readerInfo.STDT}" style="border: 0; width: 95%;" readonly="readonly"/></td>
					<th>해지사유</th>
					<td colspan="3"><input type="text" id="stSayouNm" value="${readerInfo.STSAYOUNM}" style="border: 0; width: 95%;" readonly="readonly"/></td>
			    </tr>
			</table>
		</div>
		<!-- //구독정보 -->
	</div>
	<div style="padding: 5px 0; text-align: right;">
		<span class="btnCss2" ><a class="lk2" onclick="fn_selectReaderInfo();" style="font-weight: bold;">선택</a></span>
	</div>
	<!--// 독자 상세정보-->					
	<div style="padding-top: 10px; width: 660px; border: 0px solid green">
		<!--통합 내용출력자리-->
		<table class="tb_list_a" style="width: 660px; margin: 0 auto">
			<colgroup>
				<col width="60px">
				<col width="50px">
				<col width="90px">
				<col width="30px">
				<col width="90px">
				<col width="250px">
				<col width="90px">
			</colgroup>
			<tr>
				<th>구역배달</th>
				<th>매체</th>
				<th>독자명</th>
				<th>부수</th>
				<th>핸드폰</th>
				<th>주소</th>
				<th>확장/중지</th>
			</tr>
		</table>
		<div style="overflow-y: scroll; overflow-x: none; width: 660px; height: 130px; margin: 0 auto">
		<table class="tb_list_a" style="width: 643px;">
			<colgroup>
				<col width="60px">
				<col width="50px">
				<col width="90px">
				<col width="30px">
				<col width="90px">
				<col width="250px">
				<col width="73px">
			</colgroup>
			<c:choose>
				<c:when test="${empty readerList}">
					<tr>
						<td colspan="13" align="center">검색 결과가 없습니다.</td>
					</tr>
				</c:when>
				<c:otherwise>
					<c:forEach items="${readerList}" var="list" varStatus="i">
						<c:if test="${flag==1 and i.first}">
							<script type="text/javascript">
								detailView('${list.SEQ}','${list.READNO}','${list.NEWSCD}', '${list.BOSEQ}');
							</script>
						</c:if>
						<tr onclick="detailView('${list.SEQ}','${list.READNO}','${list.NEWSCD}', '${list.BOSEQ}')" style="cursor:pointer; <c:if test="${list.BNO eq '999'}">color: #e74985; background-color: #f9f9f9</c:if>">
							<td>${list.GNO }-${list.BNO }</td>
							<td>${list.NEWSNM }</td>
							<td><c:out value="${list.READNM }"/></td>
							<td>${list.QTY }</td>
							<td style="text-align: left;">${list.MOBILE }</td>
							<td style="text-align: left;">${list.ADDR }</td>
							<td>${fn:substring(list.STDT,0,4) }-${fn:substring(list.STDT,4,6) }-${fn:substring(list.STDT,6,8) }</td>
						</tr>
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
