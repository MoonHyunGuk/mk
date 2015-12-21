<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="com.mkreader.security.ISiteConstant" %>
<script type="text/javascript">
	//페이징
	function moveTo(where, seq) {
		<c:choose>
			<c:when test="${loginType eq 'A'}">
				if($("searchText").value  != '' || $("boSeq").value  != '' || $("status").value  != '1'){
					$("pageNo").value = seq;
					alienationListForm.target = "_self";
					alienationListForm.action = "/reader/alienation/searchNIList.do";
					alienationListForm.submit();
				}else{
					$("pageNo").value = seq;
					alienationListForm.target = "_self";
					alienationListForm.action = "/reader/alienation/searchNIList.do";
					alienationListForm.submit();	
				}
			</c:when>
			<c:otherwise>
				if($("searchText").value  != '' || $("status").value  != '1'){
					$("pageNo").value = seq;
					alienationListForm.target = "_self";
					alienationListForm.action = "/reader/alienation/searchNIList.do";
					alienationListForm.submit();
				}else{
					$("pageNo").value = seq;
					alienationListForm.target = "_self";
					alienationListForm.action = "/reader/alienation/searchNIList.do";
					alienationListForm.submit();	
				}
			</c:otherwise>
		</c:choose>
	}
	//검색
	function fn_search(){
		var fm = document.getElementById("alienationListForm");
		
		fm.target = "_self";
		fm.pageNo.value = "1";
		fm.opBoSeq.value = document.getElementById("boSeq").value; 
		fm.action = "/reader/alienation/searchNIList.do";
		fm.submit();
	}

	//NI계층 리스트엑셀저장
	function fn_nieExcelDown(){
		/*
		var fm = document.getElementById("fm");
		var excelBoseq 			= document.getElementById("boSeq").value;
		var excelSearchKey 		= document.getElementById("searchKey").value; 
		var excelSearchText 	= document.getElementById("searchText").value;
		var excelStatus			= document.getElementById("status").value;
		
		alert("excelBoseq = "+excelBoseq);
		alert("excelSearchKey = "+excelSearchKey);
		alert("excelSearchText = "+excelSearchText);
		alert("excelStatus = "+excelStatus);
		fm.excelBoseq.value = excelBoseq;
		fm.excelSearchKey.value = excelSearchKey;
		fm.excelSearchText.value = excelSearchText;
		fm.excelStatus.value = excelStatus;
		fm.target="_self";
		fm.action = "/reader/alienation/excelNIList.do";
		fm.submit();
		*/
		alienationListForm.target="_self";
		alienationListForm.action = "/reader/alienation/excelNiList.do";
		alienationListForm.submit();
	}
	
	//해지
	function closeNews(readNo){
		$("readNo").value = readNo;
		
		if(confirm('신문 구독을 중지 하시겠습니까?') == false){
			return;
		}
		
		alienationListForm.target="_self";
		alienationListForm.action = "/reader/alienation/closeNINews.do";
		alienationListForm.submit();
	}
	
	//자세히 보기
	function detailVeiw(boSeq , readNo , newsCd , seq){
		var fm = document.getElementById("alienationListForm");

		<c:choose>
			<c:when test="${loginType eq 'A'}">
				$("boSeqSerial").value = boSeq;
				$("readNo").value = readNo;
				$("newsCd").value = newsCd;
				$("seq").value = seq;
				
				var left = (screen.width)?(screen.width - 750)/2 : 10;
				var top = (screen.height)?(screen.height - 750)/2 : 10;
				var winStyle = "width=750,height=750,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
				var newWin = window.open("", "detailVeiw", winStyle);
				
				fm.target = "detailVeiw";
				fm.action = "/reader/alienation/niInfo.do";
				fm.submit();
			</c:when>
			<c:otherwise>
				fm.target = "_self";
				fm.action = "/reader/readerManage/searchReader.do?searchText="+readNo+"&searchType=7";
				fm.submit();
			</c:otherwise>
		</c:choose>
	}
	
	//수금 이력
	function sugm(boSeq , readNo , newsCd , seq , readNm){
		$("boSeqSerial").value = boSeq;
		$("readNo").value = readNo;
		$("newsCd").value = newsCd;
		$("seq").value = seq;
		$("readNm").value = readNm;
		var left = (screen.width)?(screen.width - 830)/2 : 10;
		var top = (screen.height)?(screen.height - 600)/2 : 10;
		var winStyle = "width=500,height=650,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=0";
		var newWin = window.open("", "paymentHist", winStyle);
		alienationListForm.target = "paymentHist";
		alienationListForm.action = "/reader/alienation/popPaymentHist.do?gbn=alienation";
		alienationListForm.submit();
	}
	
	//수금파일 입력
	function insertSugm(){
		var f = document.alienationListForm;
		
		if ( !f.sugmfile.value ) {
			alert("파일을 첨부해 주시기 바랍니다.");
			f.sugmfile.focus();
			return;
		}else{
			if(f.sugmfile.value.indexOf('xls') > -1){
				if(f.sugmfile.value.indexOf('xlsx') > -1){
					f.sugmfile.focus();
					alert('.xls 형식 파일만 입력 가능합니다.');
					return;
				}
			}else{
				f.sugmfile.focus();
				alert('.xls 형식 파일만 입력 가능합니다.');
				return;
			}
		}
		
		alienationListForm.target="_self";
		alienationListForm.action="/reader/alienation/saveSugm.do";
		alienationListForm.submit();
	}
</script>
<!-- title -->
<div><span class="subTitle">NIE신문독자리스트</span></div>
<!-- //title -->
<!-- 
<form id="fm" name="fm" method="post">
	<input type="hidden" name="excelBoseq" id="excelBoseq"/>
	<input type="hidden" name="excelSearchKey" id="excelSearchKey"/>
	<input type="hidden" name="excelSearchText" id="excelSearchText"/>
	<input type="hidden" name="excelStatus" id="excelStatus"/>
</form>
 -->
<form id="alienationListForm" name="alienationListForm" method="post" enctype="multipart/form-data">
<input type=hidden id="pageNo" name="pageNo" value="${param.pageNo}" />
<input type=hidden id="readNo" name="readNo" value="" />
<input type=hidden id="newsCd" name="newsCd" value="" />
<input type=hidden id="seq" name="seq" value="" />
<input type=hidden id="readNm" name="readNm" value="" />
<input type=hidden id="boSeqSerial" name="boSeqSerial" value="" />
<input type=hidden id="flag" name="flag" value="UPT" />
<input type=hidden id="opBoSeq" name="opBoSeq" value="" />

	<!-- search condition -->
	<div class="box_white" style="padding: 10px 0; margin: 0 auto; width: 1020px;">
		<c:if test="${loginType eq 'A'}">
			<select id="boSeq" name="boSeq" style="vertical-align: middle;" onchange="fn_search();">
				<option value="">전 체 지 국 보 기</option>
				<c:forEach items="${agencyAllList }" var="list">
					<option value="${list.SERIAL }" <c:if test="${param.boSeq eq list.SERIAL }"> selected </c:if>>${list.NAME }</option>
				</c:forEach>
			</select>
		</c:if>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<select id="searchKey" name="searchKey" style="vertical-align: middle;">
			<option value="readnm" <c:if test="${param.searchKey eq 'readnm' }"> selected </c:if>>성 명</option>
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="text" id="searchText" name="searchText" style="width: 140px; vertical-align: middle;" value="${param.searchText }" onkeydown="if(event.keyCode == 13){fn_search(); }"/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<a href="#fakeurl"  onclick="fn_search();"><img src="/images/bt_search.gif" style="vertical-align: middle; border: 0;" alt="검색"></a>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<select id="status" name="status" style="vertical-align: middle;" onchange="fn_search();">
			<option value="1" <c:if test="${param.status eq '1' }"> selected </c:if>>전체</option>
			<option value="2" <c:if test="${param.status eq '2' }"> selected </c:if>>정상</option>
			<option value="3" <c:if test="${param.status eq '3' }"> selected </c:if>>해지</option>
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<a href="#fakeUrl" onclick="fn_nieExcelDown();"><img src="/images/bt_savexel.gif" style="vertical-align: middle; border: 0;" alt="엑셀저장" /></a>
	</div>
	<!-- //search condition -->
	<c:if test="${loginType eq 'A'}">
		<div style="padding-top: 10px">
			<div class="box_white" style="padding: 10px 0; overflow: hidden; width: 1020px; margin: 0 auto;">
				<font class="b02">수금 등록</font>&nbsp;
				<b class="b03">* .xls 파일만 수금 등록 가능합니다.</b>	&nbsp; &nbsp; &nbsp; &nbsp;
				<a href="<%=ISiteConstant.PATH_UPLOAD_ALIENATION_RESULT%>/sample.jpg" target="_blank">샘플파일 보기</a>&nbsp; &nbsp; &nbsp; &nbsp;
				<input type="file" name="sugmfile" id="sugmfile" style="width:400px; vertical-align: middle;">	&nbsp; &nbsp; &nbsp; &nbsp; 
				<a href="#fakeurl" onclick="insertSugm();"><img src="/images/bt_eepl.gif"style="vertical-align: middle; border: 0;" ></a>
			</div>
		</div>
	</c:if>
	<!-- counting -->
	<c:if test="${not (param.status eq '3') }">
		<div style="padding: 15px 0 5px 0;">
			<font class="b02">정상 구독 부수 : ${count }</font>
		</div>
	</c:if>
	<!-- //counting -->
	<!-- list -->
	<div>
		<table class="tb_list_a" style="width: 1020px;">  
			<colgroup>
				<c:choose>
					<c:when test="${loginType eq 'A'}">
						<col width="65px">
						<col width="100px">
						<col width="185px">
						<col width="90px">
						<col width="50px">
						<col width="50px">
						<col width="65px">
						<col width="70px">
						<col width="80px">
						<col width="80px">
					</c:when>
					<c:otherwise>
						<col width="65px">
						<col width="100px">
						<col width="285px">
						<col width="150px">
						<col width="50px">
						<col width="50px">
						<col width="115px">
						<col width="105px">
						<col width="100px">
					</c:otherwise>
				</c:choose>
			</colgroup>	
			<tr>
				<th>관리지국</th>
				<th>성명</th>
				<th>주소</th>
				<th>연락처</th>
				<th>부수</th>
				<th>금액</th>
				<th>신청일<br/>(해지일)</th>
				<c:if test="${loginType eq 'A'}">
					<th>해지</th>
				</c:if>
				<th>독자번호</th>
				<th>현재상태</th>
			</tr>
			<c:forEach items="${alienationList }" var="list" varStatus="i">
				<tr class="mover_color">
					<td>${list.JIKUKNM }</td>
					<td style="text-align: left;"><a href="javascript:detailVeiw('${list.BOSEQ }','${list.READNO }','${list.NEWSCD }','${list.SEQ }');">${list.READNM }</a></td>
					<td style="text-align: left;">${list.NEWADDR }<br/><b>(${list.DLVADRS1 })</b>${list.DLVADRS2 }</td>
					<td>${list.TEL }</td>
					<td>${list.QTY }</td>
					<td style="text-align: left;"><a href="javascript:sugm('${list.BOSEQ }','${list.READNO }','${list.NEWSCD }','${list.SEQ }','${list.READNM }');">${list.UPRICE }</a></td>
					<c:choose>
						<c:when test="${list.BNO eq '999' }">
							<td>${list.HJDT }<br/>(<font class="b03">${list.STDT }</font>)</td>
							<c:if test="${loginType eq 'A'}">
								<td></td>
							</c:if>
							<td align="center">${list.READNO }</td>
							<td align="center">해지</td>
						</c:when>
						<c:otherwise>
							<td align="center">${list.HJDT }</td>
							<c:if test="${loginType eq 'A'}">
								<td><a href="javascript:closeNews('${list.READNO }');">해지</a></td>
							</c:if>
							<td align="center">${list.READNO }</td>
							<td align="center">정상</td>
						</c:otherwise>
					</c:choose>
				</tr>
			</c:forEach>
		</table>
	</div>
	<!-- ..list -->
	<%@ include file="/common/paging.jsp"%>
</form>