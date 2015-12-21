<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript"src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/js/ajaxUtil.js" charset="UTF-8"></script>
<script type="text/javascript">
	// 매체 종류 전체 선택/해제
	function checkControll(){
		var frm = document.stReaderForm;

		//전체선택 1 , 전체해제 2
		if(frm.controll.checked == true){
			if( frm.newsCd.length > 0 ){
				for(var i=0;i<frm.newsCd.length;i++){
					frm.newsCd[i].checked = true; 
				}
			}			
		}else{
			if( frm.newsCd.length > 0 ){
				for(var i=0;i<frm.newsCd.length;i++){
					frm.newsCd[i].checked = false;
				}
			}	
		}
	}

	//처음 시작시
	function init(){
		var stReaderList = document.getElementById("stReaderList").value;
		var yearStaticList  = document.getElementById("yearStaticList").value;
		var sayouStaticList  = document.getElementById("sayouStaticList").value;
		
		//리스트 화면 제어
		if(stReaderList.length > 1 ) {
			document.getElementById("list").style.display = "block";
			document.getElementById("yearStatic").style.display = "none";
			document.getElementById("sayouStatic").style.display = "none";
		} else if(yearStaticList.length > 1 ) {
			document.getElementById("yearStatic").style.display = "block";
			document.getElementById("list").style.display = "none";
			document.getElementById("sayouStatic").style.display = "none";
		} else if(sayouStaticList.length > 1 ) {
			document.getElementById("sayouStatic").style.display = "block";
			document.getElementById("yearStatic").style.display = "none";
			document.getElementById("list").style.display = "none";
		}
		
		//날짜세팅
		var fromDateVal = document.getElementById("fromDate").value;
		var toDateVal = document.getElementById("toDate").value;
		
		if("" == fromDateVal && "" == toDateVal) {
			var currentTime = new Date();
			var year = currentTime.getFullYear();
			var month = currentTime.getMonth() + 1;
			if (month < 10) month = "0" + month;
			var day = currentTime.getDate();
			if (day < 10) day = "0" + day; 
			$("fromDate").value = '${fn:substring(nowYYMM[0].SDATE,0,4)}' + '-' + '${fn:substring(nowYYMM[0].SDATE,4,6)}' + '-' + '${fn:substring(nowYYMM[0].SDATE,6,8)}';  
			$("toDate").value = year + '-' + month + '-' + day;  
		}
		
		if(document.stReaderForm.check[1].checked == true){
			$("searchText").value = "";
			$("searchText").readOnly = true;
			$("searchText").style.backgroundColor = "#EAEAEA"; 
			document.getElementById("searchType1").style.display = "none";
			document.getElementById("searchType2").style.display = "";
		}else if(document.stReaderForm.check[2].checked == true){
			$("searchText").readOnly = false;
			$("searchText").style.backgroundColor = "";
			document.getElementById("searchType1").style.display = "";
			document.getElementById("searchType2").style.display = "none";
		}else{
			$("searchText").value = "";
			$("searchText").readOnly = true;
			$("searchText").style.backgroundColor = "#EAEAEA";
			document.getElementById("searchType1").style.display = "";
			document.getElementById("searchType2").style.display = "none";
		}
	}
	
	function changeList(){
		if(document.stReaderForm.check[1].checked == true){
			$("searchText").value = "";
			$("searchText").readOnly = true;
			$("searchText").style.backgroundColor = "#EAEAEA";
			document.getElementById("searchType1").style.display = "none";
			document.getElementById("searchType2").style.display = "";
		}else if(document.stReaderForm.check[2].checked == true){
			$("searchText").readOnly = false;
			$("searchText").style.backgroundColor = "";
			document.getElementById("searchType1").style.display = "";
			document.getElementById("searchType2").style.display = "none";
		}else{
			$("searchText").value = "";
			$("searchText").readOnly = true;
			$("searchText").style.backgroundColor = "#EAEAEA";
			document.getElementById("searchType1").style.display = "";
			document.getElementById("searchType2").style.display = "none";
		}
		
	}
	
	//해지독자 조회
	function fn_stReaderList(){
		var fm = document.getElementById("stReaderForm");
		var newsCd = 0;

		for(var i=0 ; i< document.stReaderForm.newsCd.length ; i++){
			if(document.stReaderForm.newsCd[i].checked){
				newsCd ++;
			}	
		}

		if(newsCd == 0){
			alert("신문명을 선택해 주세요.");
			return;
		}

		if(document.stReaderForm.check[2].checked){
			if($("searchText").value == ''){
				alert("확장자명을 입력해주세요.");
				$("searchText").focus();
				return;
			}
		}

		fm.target="_self";
		fm.action="/print/print/stReaderList.do";
		fm.submit();

		jQuery("#prcssDiv").show();
	}

	function ozPrint(){
		var fm = document.getElementById("stReaderForm");
		var actUrl = "/print/print/ozStReaderList.do";
		window.open('','ozStReaderList','width=1000, height=800, toolbar=no, menubar=no, location=no, status=no, resizable=1, scrollbars=no');

		fm.target = "ozStReaderList";
		fm.action = actUrl;
		fm.submit();
	}
</script>
 <div><span class="subTitle">해지독자명단</span>
</div>
<!-- search conditions -->
<form id="stReaderForm" name="stReaderForm" action="" method="post">
	<input type="hidden" name="stReaderList" id="stReaderList" value="${stReaderList }">
	<input type="hidden" name="yearStaticList " id="yearStaticList" value="${yearStatic  }">
	<input type="hidden" name="sayouStaticList" id="sayouStaticList" value="${sayouStatic  }">
<div style="width: 1018px; border: 1px solid #e5e5e5; background-color: #f9f9f9; overflow: hidden;">
	<!--left -->
	<div style="float: left; width: 170px; padding: 10px;">
		<table class="tb_edit_4" style="width: 170px;">
			<colgroup> 
				<col width="30px">
				<col width="140px">
			</colgroup>
			<tr>
				<td><input type="radio" id="check" name="check" value="1" checked onclick="changeList();"  style="border: 0;" <c:if test="${param.check eq '1'}"> checked </c:if>/></td>
				<td>해지독자 명단</td>
			</tr>
			<tr>
				<td><input type="radio" id="check" name="check" value="2" onclick="changeList();" style="border: 0;" <c:if test="${param.check eq '2'}"> checked </c:if>/></td>
				<td>해지사유별 명단</td>
			</tr>
			<tr>
				<td><input type="radio" id="check" name="check" value="3" onclick="changeList();" style="border: 0;" <c:if test="${param.check eq '3'}"> checked </c:if>/></td>
				<td>확장자별 해지명단</td>
			</tr>
			<tr>
				<td><input type="radio" id="check" name="check" value="4" onclick="javascript:changeList();" style="border: 0;" <c:if test="${param.check eq '4'}"> checked </c:if>/></td>
				<td>해지일자별 미수명단</td>
			</tr>
		</table>
		<div style="height: 14px;">&nbsp;</div>
		<table class="tb_edit_4" style="width: 170px;">
			<colgroup>
				<col width="30px">
				<col width="140px">
			</colgroup>
			<tr>
				<td><input type="radio" id="check" name="check" value="5" onclick="changeList();" style="border: 0;" <c:if test="${param.check eq '5'}"> checked </c:if>/></td>
				<td>해지사유별 통계</td>
			</tr>
			<tr>
				<td><input type="radio" id="check" name="check" value="6" onclick="changeList();" style="border: 0;" <c:if test="${param.check eq '6'}"> checked </c:if>/></td>
				<td>구독기간별 해지통계</td>
			</tr>
		</table>
	</div>
	<!-- //left -->
	<!-- middle -->
	<div style="float: left; width: 330px; padding: 10px;">
		<table class="tb_search" style="width: 330px;">
			<colgroup>
				<col width="110px">
				<col width="220px">
			</colgroup>
			<tr>
				<th>구역선택</th>
				<td style="text-align: left; padding-left: 10px;">
					<select id="fromGno" name="fromGno">
						<c:forEach items="${gnoList }" var="list">
							<option value="${list.GNO }"  <c:if test="${param.fromGno eq list.GNO}"> selected </c:if>>${list.GNO }</option>
						</c:forEach>
					</select>
					&nbsp;&nbsp;
					<select id="toGno" name="toGno">
						<c:forEach items="${gnoList }" var="list" varStatus="i">
							<c:choose>
								<c:when test="${empty param.toGno}">
									<option value="${list.GNO }" <c:if test="${i.last}"> selected </c:if>>${list.GNO }</option>									
								</c:when>
								<c:otherwise>
									<option value="${list.GNO }" <c:if test="${param.toGno eq list.GNO}"> selected </c:if>>${list.GNO }</option>
								</c:otherwise>
							</c:choose>	c
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th>날짜선택</th>
				<td style="text-align: left; padding-left: 10px;">
					<input type="text" id="fromDate" name="fromDate"  style="width: 85px;" value="${param.fromDate}" readonly onclick="Calendar(this)"/>
					 ~ <input type="text" id="toDate" name="toDate"  style="width: 85px;" value="${param.toDate}" readonly onclick="Calendar(this)"/>
				</td>
			</tr>
			<tr>
				<th>검색내용</th>
				<td style="text-align: left; padding-left: 10px;">
					<div id= "searchType1">
						<input type="text" id="searchText" name="searchText" value="${param.searchText }" readonly/>
					</div>
					<div id= "searchType2" style="display:none">
						<select id="stSayou" name="stSayou">
							<c:forEach items="${stSayouList }" var="list">
								<option value="${list.CODE }" <c:if test="${param.stSayou eq list.CODE}"> selected </c:if>>${list.CNAME }</option>
							</c:forEach>
						</select>
					</div>
				</td>
			</tr>
			<tr>
				<th>정렬</th>
				<td style="text-align: left; padding-left: 10px;">
					<input type="radio" id="sort" name="sort" value="gno"  style="border: 0;" <c:if test="${param.sort eq 'gno' || empty param.sort}"> checked </c:if>/> 구역별 
					&nbsp;&nbsp;&nbsp;
					<input type="radio" id="sort" name="sort" value="date" style="border: 0;" <c:if test="${param.sort eq 'date' }"> checked </c:if>/>  확장일자별
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<a href="#fakeUrl" onclick="fn_stReaderList();"><img src="/images/bt_joh.gif" style="border: 0; vertical-align: middle;"></a>
					<a href="#fakeUrl" onclick="ozPrint();"><img src="/images/bt_print.gif" style="border: 0; vertical-align: middle;"></a>
				</td>
			</tr>
		</table>
	</div>
	<!-- //middle -->
	<!-- right -->
	<div style="float: left; width: 455px; padding: 10px; border: 0px solid red">
		<div style="border: 1px solid #e5e5e5; padding: 5px 0 5px 5px">
			<div style="height:160px; overflow-y:scroll; overflow-x: none;">
			<table class="tb_list_a" style="width: 425px">
				<colgroup>
					<col width="90px">
					<col width="215px"> 
					<col width="120px">
				</colgroup>
				<tr>
				    <th><input type="checkbox" id="controll" name="controll"  style="border: 0;" onclick="checkControll();"> </th>
				    <th>신문명</th>
				    <th>코드</th>
			  	</tr>
			  	<tr id=div1 style="display:none;"> 
			  		<td colspan="3"><input type="checkbox" id="newsCd" name="newsCd" value="0" /></td> 
			  	</tr>
				<c:forEach items="${newSList }" var="list" varStatus="i">
					<tr>
						<td height="20">
							<input type="checkbox" id="newsCd" name="newsCd" value="${list.CODE }"  style="border: 0;" 
								<c:forEach items="${newsCd}" varStatus="counter">
											<c:if test="${newsCd[counter.index] eq list.CODE}"> checked</c:if>
								</c:forEach>>
						</td>
						<td>${list.CNAME }</td>
						<td>${list.YNAME }</td>
					</tr>
				</c:forEach>
			</table>									
			</div>
		</div>
	</div>
	<!-- //right -->
</div>
</form>
<!-- //search conditions -->
<!-- count -->
<div style="clear: both; width: 1020px; text-align: left; font-weight: bold; padding: 20px 0 5px 0">
	<c:if test="${param.check ne '5' && param.check ne '6' && param.check ne '4'}">
		<c:set var="readerQty" value="0" />									
		<c:set var="stuQty" value="0" />									
		<c:set var="etcQty" value="0" />									
		<c:set var="totalQty" value="0" />						
		<c:forEach var="list" items="${stReaderList}" varStatus="status">
			<c:if test="${list.GUBUN == '일반'}">
					<c:set var="readerQty" value="${readerQty + list.QTY}" />		
			</c:if>
			<c:if test="${list.GUBUN == '학생(지국)' || list.GUBUN == '학생(본사)'}">
					<c:set var="stuQty" value="${stuQty + list.QTY}" />		
			</c:if>
			<c:if test="${list.GUBUN != '일반' && list.GUBUN != '학생(지국)' && list.GUBUN != '학생(본사)'}">
				<c:set var="etcQty" value="${etcQty + list.QTY}" />				
			</c:if>
			<c:set var="totalQty" value="${totalQty + list.QTY}" />		
		</c:forEach>
		◆ 일반: <fmt:formatNumber value="${readerQty}" type="number" />부&nbsp;&nbsp;&nbsp;학생: <fmt:formatNumber value="${stuQty}" type="number" />부&nbsp;&nbsp;&nbsp;기타: <fmt:formatNumber value="${etcQty}" type="number" />부&nbsp;&nbsp;&nbsp;총부수: <fmt:formatNumber value="${totalQty}" type="number" />부
	</c:if>
	<c:if test="${param.check eq '4'}">
		<c:set var="readerQty" value="0" />									
		<c:set var="stuQty" value="0" />									
		<c:set var="etcQty" value="0" />									
		<c:set var="totalQty" value="0" />						
	
		<c:forEach var="list" items="${stReaderList}" varStatus="status">
			<c:if test="${list.GUBUN == '일반'}">
				<c:if test="${list.MISU > 0 }">
					<c:set var="readerQty" value="${readerQty + list.QTY}" />		
				</c:if>
			</c:if>
			<c:if test="${list.GUBUN == '학생(지국)' || list.GUBUN == '학생(본사)'}">
				<c:if test="${list.MISU > 0 }">
					<c:set var="stuQty" value="${stuQty + list.QTY}" />		
				</c:if>
			</c:if>
			<c:if test="${list.GUBUN != '일반' && list.GUBUN != '학생(지국)' && list.GUBUN != '학생(본사)'}">
				<c:if test="${list.MISU > 0 }">
					<c:set var="etcQty" value="${etcQty + list.QTY}" />			
				</c:if>
			</c:if>
			<c:if test="${list.MISU > 0 }">
				<c:set var="totalQty" value="${totalQty + list.QTY}" />		
			</c:if>
		 </c:forEach>
		◆ 일반: <fmt:formatNumber value="${readerQty}" type="number" />부&nbsp;&nbsp;&nbsp;학생: <fmt:formatNumber value="${stuQty}" type="number" />부&nbsp;&nbsp;&nbsp;기타: <fmt:formatNumber value="${etcQty}" type="number" />부&nbsp;&nbsp;&nbsp;총부수: <fmt:formatNumber value="${totalQty}" type="number" />부
	</c:if>
</div>
<!-- //count -->
<!-- 해지리스트 -->
<div id="list" style="overflow-x: auto; overflow-y: scroll; width:1020px; height: 400px; display:block;">
	<table class="tb_list_a"
		<c:choose>
			<c:when test="${param.remk eq 'on' }">style="width: 1560px;"</c:when>
			<c:otherwise>style="width: 1360px;"</c:otherwise>
		</c:choose>>
		<colgroup>
			<col width="130px">	<!-- 독자번호 -->
			<col width="80px">	<!-- 구분 -->
			<col width="180px">	<!-- 독자명 -->
			<col width="280px">	<!-- 주소 -->
			<col width="100px">	<!-- 전화번호 -->
			<col width="100px">	<!-- 휴대폰번호 -->
			<col width="45px">	<!-- 매체 -->
			<col width="45px">	<!-- 부수 -->
			<col width="50px">	<!-- 단가 -->
			<col width="50px">	<!-- 수금 -->
			<col width="60px">	<!-- 확장자 -->
			<col width="80px">	<!-- 확정일자 -->
			<col width="60px">	<!-- 유가월 -->
			<col width="80px">	<!-- 중지일자 -->
			<col width="110px">	<!-- 중지사유 -->
			<col width="110px">	<!-- 수금사항 -->
			<c:choose>
				<c:when test="${param.remk eq 'on' }">
					<col width="200px">
				</c:when>
			</c:choose>
		</colgroup>
		<c:choose>
			<c:when test="${not (param.check eq '4') }">
				<tr>
					<th>독자번호</th>
					<th>구분</th>
					<th>독자명</th>
					<th>주소</th>
					<th>전화번호</th>
					<th>휴대폰</th>
					<th>매체</th>
					<th>부수</th>
					<th>단가</th>
					<th>수금</th>
					<th>확장자</th>
					<th>확장일자</th>
					<th>유가월</th>
					<th>중지일자</th>
					<th>중지사유</th>
					<th>수금사항</th>
					<c:if test="${param.remk eq 'on' }"><th>비고</th></c:if>
				</tr>
				<c:forEach items="${stReaderList }" var="list">
					<tr>
						<td style="text-align: left;" >${list.READNO }</td>
						<td>${list.GUBUN }</td>
						<td style="text-align: left;" >${list.READNM }</td>
						<td style="text-align: left;" >${list.ADDR }</td>
						<td style="text-align: left;" >${list.HOMETEL }</td>
						<td style="text-align: left;" >${list.MOBILE }</td>
						<td>${list.NEWSNM }</td>
						<td>${list.QTY }</td>
						<td><fmt:formatNumber value="${list.UPRICE }" type="number" /></td>
						<td>${list.SGTYPE }</td>
						<td>${list.HJPSNM }</td>
						<td>${list.HJDT }</td>
						<td>${list.SGBGMM }</td>
						<td>${list.STDT }</td>
						<td>${list.SAYOU }</td>
						<td>${list.CLAMLIST }</td>
						<c:if test="${param.remk eq 'on' }"><td style="text-align: left;">${list.REMK }</td></c:if>
					</tr>
				</c:forEach>
			</c:when>
			<c:otherwise>
				<tr>
					<th>독자번호</th>
					<th>구분</th>
					<th>독자명</th>
					<th>주소</th>
					<th>전화번호</th>
					<th>휴대폰</th>
					<th>매체</th>
					<th>부수</th>
					<th>단가</th>
					<th>수금</th>
					<th>확장자</th>
					<th>확장일자</th>
					<th>유가월</th>
					<th>중지일자</th>
					<th>중지사유</th>
					<th>수금사항</th>
					<c:if test="${param.remk eq 'on' }"><th>비고</th></c:if>
				</tr>
				<c:forEach items="${stReaderList }" var="list">
					<c:if test="${list.MISU > 0 }">
					<tr>
						<td style="text-align: left;" >${list.READNO }</td>
						<td>${list.GUBUN }</td>
						<td style="text-align: left;" >${list.READNM }</td>
						<td style="text-align: left;" >${list.ADDR }</td>
						<td style="text-align: left;" >${list.HOMETEL }</td>
						<td style="text-align: left;" >${list.MOBILE }</td>
						<td>${list.NEWSNM }</td>
						<td>${list.QTY }</td>
						<td><fmt:formatNumber value="${list.UPRICE }" type="number" /></td>
						<td>${list.SGTYPE }</td>
						<td>${list.HJPSNM }</td>
						<td>${list.HJDT }</td>
						<td>${list.SGBGMM }</td>
						<td>${list.STDT }</td>
						<td>${list.SAYOU }</td>
						<td>${list.CLAMLIST }</td>
						<c:if test="${param.remk eq 'on' }"><td style="text-align: left;">${list.REMK }</td></c:if>
					</tr>
					</c:if>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>
</div>
<!-- 해지 사유 통계 -->
<div id="sayouStatic" style="display:none;  overflow: auto; width: 1020px;">
	<table class="tb_list_a_3_5">
		<tr>
			<th>구역</th>
			<c:forEach items="${stSayouList }" var="list">
				<th>${list.CNAME } </th>
			</c:forEach>
			<th>소계</th>
		</tr>
		<c:set var="sum1" value="0"/>
		<c:set var="sum2" value="0"/>
		<c:set var="sum3" value="0"/>
		<c:set var="sum4" value="0"/>
		<c:set var="sum5" value="0"/>
		<c:set var="sum6" value="0"/>
		<c:set var="sum7" value="0"/>
		<c:set var="sum8" value="0"/>
		<c:set var="sum9" value="0"/>
		<c:set var="sum10" value="0"/>
		<c:set var="sum11" value="0"/>
		<c:set var="sum12" value="0"/>
		<c:set var="sum13" value="0"/>
		<c:set var="sum14" value="0"/>
		<c:set var="sum99" value="0"/>
		<c:forEach items="${sayouStatic }" var="list" varStatus="i">
			<c:set var="sum1" value="${sum1 + list.SAYOU1 }"/>
			<c:set var="sum2" value="${sum2 + list.SAYOU2 }"/>
			<c:set var="sum3" value="${sum3 + list.SAYOU3 }"/>
			<c:set var="sum4" value="${sum4 + list.SAYOU4 }"/>
			<c:set var="sum5" value="${sum5 + list.SAYOU5 }"/>
			<c:set var="sum6" value="${sum6 + list.SAYOU6 }"/>
			<c:set var="sum7" value="${sum7 + list.SAYOU7 }"/>
			<c:set var="sum8" value="${sum8 + list.SAYOU8 }"/>
			<c:set var="sum9" value="${sum9 + list.SAYOU9 }"/>
			<c:set var="sum10" value="${sum10 + list.SAYOU10 }"/>
			<c:set var="sum11" value="${sum11 + list.SAYOU11 }"/>
			<c:set var="sum12" value="${sum12 + list.SAYOU12 }"/>
			<c:set var="sum13" value="${sum13 + list.SAYOU13 }"/>
			<c:set var="sum14" value="${sum14 + list.SAYOU14 }"/>
			<c:set var="sum99" value="${sum99 + list.SAYOU99 }"/>
			<tr>
				<td>${list.GNO }</td>
				<td>${list.SAYOU1 }</TD>
				<td>${list.SAYOU2 }</td>
				<td>${list.SAYOU3 }</td>
				<td>${list.SAYOU4 }</td>
				<td>${list.SAYOU5 }</td>
				<td>${list.SAYOU6 }</td>
				<td>${list.SAYOU7 }</td>
				<td>${list.SAYOU8 }</td>
				<td>${list.SAYOU9 }</td>
				<td>${list.SAYOU10 }</td>
				<td>${list.SAYOU11 }</td>
				<td>${list.SAYOU12 }</td>
				<td>${list.SAYOU13 }</td>
				<td>${list.SAYOU14 }</td>
				<td>${list.SAYOU99 }</td>
				<td>${list.SAYOU1+list.SAYOU2+list.SAYOU3+list.SAYOU4+list.SAYOU5+list.SAYOU6+list.SAYOU7+list.SAYOU8+list.SAYOU9+list.SAYOU10+list.SAYOU11+list.SAYOU12+list.SAYOU13+list.SAYOU14+list.SAYOU99 }</td>
			</tr>
		</c:forEach>
		<tr>
			<td>합계</td>
			<td>${sum1 }</td>
			<td>${sum2 }</td>
			<td>${sum3 }</td>
			<td>${sum4 }</td>
			<td>${sum5 }</td>
			<td>${sum6 }</td>
			<td>${sum7 }</td>
			<td>${sum8 }</td>
			<td>${sum9 }</td>
			<td>${sum10 }</td>
			<td>${sum11 }</td>
			<td>${sum12 }</td>
			<td>${sum13 }</td>
			<td>${sum14 }</td>
			<td>${sum99 }</td>
			<td>${sum1+sum2+sum3+sum4+sum5+sum6+sum7+sum8+sum9+sum10+sum11+sum12+sum13+sum14+sum99 }</td>
		</tr>
	</table>
</div>
<!-- 사용년별 사유 통계 -->
<div id="yearStatic" style="display:none;  overflow: auto; width: 1020px;">
	<table class="tb_list_a" style="width: 1020px;">
		<colgroup>
			<col width="81px">
			<col width="78px">
			<col width="78px">
			<col width="78px">
			<col width="78px">
			<col width="78px">
			<col width="78px">
			<col width="78px">
			<col width="78px">
			<col width="78px">
			<col width="78px">
			<col width="78px">
			<col width="81px">
		</colgroup>
		<tr>
			<th>구역</th>
			<th>1년</th>
			<th>2년</th>
			<th>3년</th>
			<th>4년</th>
			<th>5년</th>
			<th>6년</th>
			<th>7년</th>
			<th>8년</th>
			<th>9년</th>
			<th>10년</th>
			<th>기타</th>
			<th>소계</th>
		</tr>
		<c:set var="sum1" value="0"/>
		<c:set var="sum2" value="0"/>
		<c:set var="sum3" value="0"/>
		<c:set var="sum4" value="0"/>
		<c:set var="sum5" value="0"/>
		<c:set var="sum6" value="0"/>
		<c:set var="sum7" value="0"/>
		<c:set var="sum8" value="0"/>
		<c:set var="sum9" value="0"/>
		<c:set var="sum10" value="0"/>
		<c:set var="sum11" value="0"/>
		<c:forEach items="${yearStatic }" var="list">
			<c:set var="sum1" value="${sum1 + list.TERM1 }"/>
			<c:set var="sum2" value="${sum2 + list.TERM2 }"/>
			<c:set var="sum3" value="${sum3 + list.TERM3 }"/>
			<c:set var="sum4" value="${sum4 + list.TERM4 }"/>
			<c:set var="sum5" value="${sum5 + list.TERM5 }"/>
			<c:set var="sum6" value="${sum6 + list.TERM6 }"/>
			<c:set var="sum7" value="${sum7 + list.TERM7 }"/>
			<c:set var="sum8" value="${sum8 + list.TERM8 }"/>
			<c:set var="sum9" value="${sum9 + list.TERM9 }"/>
			<c:set var="sum10" value="${sum10 + list.TERM10 }"/>
			<c:set var="sum11" value="${sum11 + list.TERM11 }"/>
			<tr>
				<td>${list.GNO }</td>
				<td>${list.TERM1 }</td>
				<td>${list.TERM2 }</td>
				<td>${list.TERM3 }</td>
				<td>${list.TERM4 }</td>
				<td>${list.TERM5 }</td>
				<td>${list.TERM6 }</td>
				<td>${list.TERM7 }</td>
				<td>${list.TERM8 }</td>
				<td>${list.TERM9 }</td>
				<td>${list.TERM10 }</td>
				<td>${list.TERM11 }</td>
				<td>${list.TERM1+list.TERM2+list.TERM3+list.TERM4+list.TERM5+list.TERM6+list.TERM7+list.TERM8+list.TERM9+list.TERM10+list.TERM11 }</td>
			</tr>
		</c:forEach>
		<tr>
			<td>합계</td>
			<td>${sum1 }</td>
			<td>${sum2 }</td>
			<td>${sum3 }</td>
			<td>${sum4 }</td>
			<td>${sum5 }</td>
			<td>${sum6 }</td>
			<td>${sum7 }</td>
			<td>${sum8 }</td>
			<td>${sum9 }</td>
			<td>${sum10 }</td>
			<td>${sum11 }</td>
			<td>${sum1+sum2+sum3+sum4+sum5+sum6+sum7+sum8+sum9+sum10+sum11 }</td>
		</tr>
	</table>
</div>
<div style="height: 20px;">&nbsp;</div>
<!-- //사용년별 사유 통계 -->
<!-- processing viewer -->
<div id="prcssDiv"  class="loingProcessDiv"><div><img src="/images/process4.gif"/></div></div>
<script type="text/javascript">
/** Jquery setting */
jQuery.noConflict();
jQuery(document).ready(function($) {
	init();
	$("#prcssDiv").hide();
});
</script>
<!-- //processing viewer --> 