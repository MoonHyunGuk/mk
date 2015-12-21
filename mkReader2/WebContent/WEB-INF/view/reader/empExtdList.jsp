<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/js/ajaxUtil.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript">
//페이징
function moveTo(where, seq) {
	var fm = document.getElementById("empExtdListForm");
	
	fm.pageNo.value = seq;
	fm.target = "_self";
	fm.action = "/reader/empExtd/searchEmpExtd.do";
	fm.submit() ;
}

/*----------------------------------------------------------------------
 * Desc   : 독자 상세보기
 * Auth   : 박윤철
 *----------------------------------------------------------------------*/
function detailReader(readno){
	 var fm = document.getElementById("empExtdListForm");

	var left = (screen.width)?(screen.width - 830)/2 : 10;
	var top = (screen.height)?(screen.height - 760)/2 : 10;
	var winStyle = "width=1024,height=768,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
	var newWin = window.open("", "detailReaderInfo", winStyle);
	
	fm.target = "detailReaderInfo"; 
	fm.action = "/reader/minwon/popReaderDetailInfo.do?readno="+readno;
	fm.submit();
}

/*----------------------------------------------------------------------
 * Desc   : 사원확장 정보 상세보기
 * Auth   : 박윤철
 *----------------------------------------------------------------------*/
function detailEmpExtdInfo(numId){
	 var fm = document.getElementById("empExtdListForm");

	fm.numId.value = numId;
	fm.target="_self";
	fm.action = "/reader/empExtd/empExtdInfo.do";
	fm.submit();
}

/*----------------------------------------------------------------------
 * Desc   : 사원확장 excel파일 일괄 입력
 * Auth   : 박윤철
 *----------------------------------------------------------------------*/
function uploadEmpExtdFile(){
	 var fm = document.getElementById("empExtdListForm");
	 var empExtdFile = document.getElementById("empExtdFile");
	 
	// 파일첨부 확인
	if(empExtdFile.value == null || empExtdFile.value == "") {
		empExtdFile.focus();
		alert("파일을 첨부해 주시기 바랍니다.");
		return;
	}else if(empExtdFile.value.indexOf(".xsl") < -1){
		empExtdFile.focus();
		alert(".xsl 형식의 파일만 입력 가능합니다.");
		return;
	}
	
	fm.target = "_self";
	fm.action = "/reader/empExtd/uploadEmpExtdFile.do";
	fm.submit() ;
}

/*----------------------------------------------------------------------
 * Desc   : 사원확장 excel파일 일괄 입력
 * Auth   : 박윤철
 *----------------------------------------------------------------------*/
function deleteEmpExtd(numId, status){
	var fm = document.getElementById("empExtdListForm");
	 
	// 신청 상태일때는 취소
	if(status == "0"){		
		if(!confirm("사원확장 독자를 취소 처리하시겠습니까?")){
			return;
		}
	// 접수 또는 정상 상태일때는 중지
	}else{
		if(!confirm("사원확장 독자를 중지 처리하시겠습니까?")){
			return;
		}
	}

	fm.stopStatus.value = status ;
	fm.numId.value = numId ;
	fm.target = "_self";
	fm.action = "/reader/empExtd/deleteEmpExtd.do";
	fm.submit() ;
}

/*----------------------------------------------------------------------
 * Desc   : 조회
 * Auth   : 박윤철
 *----------------------------------------------------------------------*/
function fn_search(){
	var fm = document.getElementById("empExtdListForm");
	
	fm.pageNo.value = "1";
	fm.target = "_self";
	fm.action = "/reader/empExtd/searchEmpExtd.do";
	fm.submit() ;
}

// 소속 부서 조회
function changeEmpComp(){
	var empComp = document.getElementById("empComp");
	
	if(empComp.value != ''){
		jQuery.ajax({
			type 		: "POST",
			url 		: "/reader/empExtd/ajaxOfficeNmForJqeury.do",
			dataType 	: "json",
			data		: "resv1="+empComp.value+"&resv3=1",
			success:function(data){
				jQuery("#empDept").empty();
				jQuery("#empDept").append("<option value=''>전체</option>");
				for(var i=0;i<data.office.length;i++) {
					jQuery("#empDept").append("<option value='"+data.office[i].CODE+"'>"+data.office[i].CNAME+"</option>");
				}
			},
			error    : function(r) { alert("소속회사 ajax error"); }
		}); //ajax end
	}else{
		jQuery("#empDept").empty();
		jQuery("#empDept").append("<option value=''>전체</option>");
		jQuery("#empTeam").empty();
		jQuery("#empTeam").append("<option value=''>전체</option>");
	}
}

//소속 팀 조회
function changeEmpDept(selectedVal){
	if(selectedVal != ''){
		jQuery.ajax({
			type 		: "POST",
			url 		: "/reader/empExtd/ajaxOfficeNmForJqeury.do",
			dataType 	: "json",
			data		: "resv1="+selectedVal+"&resv3=2",
			success:function(data){
				jQuery("#empTeam").empty();
				jQuery("#empTeam").append("<option value=''>전체</option>");
				for(var i=0;i<data.office.length;i++) {
					jQuery("#empTeam").append("<option value='"+data.office[i].CODE+"'>"+data.office[i].CNAME+"</option>");
				}
				jQuery("#empTeam").append("<option value='none'>부서정보없음</option>");
			},
			error    : function(r) { alert("실국 ajax error"); }
		}); //ajax end
		
	}else{
		jQuery("#empTeam").empty();
		jQuery("#empTeam").append("<option value=''>전체</option>");
	}
}


/*
function empDeptList(responseHttpObj) {

	if (responseHttpObj) {
		try {
			var result = eval("(" + responseHttpObj.responseText + ")");
			if (result) {
				setEmpDeptList(result);
			}
		} catch (e) {
			alert("오류 : " + e);
		}
	}
}

function setEmpDeptList(jsonObjArr) {
	var empDept = document.getElementById("empDept");

	if (jsonObjArr.length > 0) {
		empDept.options.length = 0;
		empDept.options[0] = new Option("전체", "");
		for ( var i = 0; i < jsonObjArr.length; i++) {
			empDept.options[i+1] = new Option(jsonObjArr[i].CNAME , jsonObjArr[i].CODE );
			if(jsonObjArr[i].CODE == '${empDept}'){
				empDept.options[i+1].selected = true;
			}
		}
	}else{
		empDept.options.length = 0;
		empDept.options[0] = new Option("전체", "");
	}
	
	changeEmpDept();
}
*/
// 소속 팀 조회
/*
function changeEmpDept(){
	var empDept = document.getElementById("empDept");
	var empTeam = document.getElementsByName("empTeam");

	if(empDept.value != ''){
		var url = "/reader/empExtd/ajaxOfficeNm.do?resv1="+$("empDept").value+"&resv3=2";
		sendAjaxRequest(url, "empExtdListForm", "post", empTeamList);
	}else{
		empTeam.options.length = 0;
		empTeam.options[0] = new Option("전체", "");
	}
}

function empTeamList(responseHttpObj) {
	if (responseHttpObj) {
		try {
			var result = eval("(" + responseHttpObj.responseText + ")");
			if (result) {
				setEmpTeamList(result);
			}
		} catch (e) {
			alert("오류 : " + e);
		}
	}
}

function setEmpTeamList(jsonObjArr) {
	var empTeam = document.getElementsByName("empTeam");
	
	if (jsonObjArr.length > 0) {
		empTeam.options.length = 0;
		empTeam.options[0] = new Option("전체", "");
		for ( var i = 0; i < jsonObjArr.length; i++) {
			empTeam.options[i+1] = new Option(jsonObjArr[i].CNAME , jsonObjArr[i].CODE );
			if(jsonObjArr[0].CODE == '${empTeam}'){
				empTeam.options[i+1].selected = true;
			}
		}
		empTeam.options[jsonObjArr.length+1] = new Option("부서정보없음", "none");
	}else{
		empTeam.options.length = 0;
		empTeam.options[0] = new Option("전체", "");
	}
}
*/
// 사원확장리스트 엑셀저장
function saveExcel(){
	var fm = document.getElementById("empExtdListForm");
	
	fm.target="_self";
	fm.action = "/reader/empExtd/excelEmpExtdList.do";
	fm.submit();
}

jQuery.noConflict();
</script>
<!-- title -->
<div><span class="subTitle">사원확장 리스트</span></div>
<!-- //title -->
<form id="empExtdListForm" name="empExtdListForm" action="" method="post" enctype="multipart/form-data">
<input type="hidden" id="numId" name="numId" value="" />
<input type="hidden" id="stopStatus" name="stopStatus" value="" />
<input type=hidden id="pageNo" name="pageNo" value="${param.pageNo}" />
<!-- search conditions -->
<div>
	<table class="tb_search" style="width: 1020px">
		<colgroup>
			<col width="100px">
			<col width="155px">
			<col width="100px">
			<col width="155px">
			<col width="100px">
			<col width="155px">
			<col width="100px">
			<col width="155px">
		</colgroup>
		<tr>
			<th>매 체${media}</th>
			<td>
				<select name="media" id="media" style="width: 100px;">
					<option value="" <c:if test="${empty media or media eq ''}">selected </c:if>>전체</option>
					<option value="1" <c:if test="${media eq '1'}">selected </c:if>>신문</option>
					<option value="2" <c:if test="${media eq '2'}">selected </c:if>>e신문</option>
					<option value="3" <c:if test="${media eq '3'}">selected </c:if>>초판</option>
				</select>
			</td>
			<th>독자유형</th>
			<td >
				<select id="readerTyp" name="readerTyp" style="width: 100px;">
					<option value="" <c:if test="${empty readerTyp or readerTyp eq ''}">selected </c:if>>전체</option>
					<option value="1" <c:if test="${readerTyp eq '1'}">selected </c:if>>일반</option>
					<option value="2" <c:if test="${readerTyp eq '2'}">selected </c:if>>학생</option>
					<option value="3" <c:if test="${readerTyp eq '3'}">selected </c:if>>교육</option>
				</select>
			</td>
			<th>신청구분</th>
			<td>
				<select id="gubun" name="gubun" style="width: 100px;">
					<option value="" <c:if test="${empty gubun or gubun eq ''}">selected </c:if>>전체</option>
					<option value="1" <c:if test="${gubun eq '1'}">selected </c:if>>개인</option>
					<option value="2" <c:if test="${gubun eq '2'}">selected </c:if>>기업</option>
				</select>
			</td>
			<th>상 태</th>
			<td>
				<select name="status" id="status">
					<option value="" <c:if test="${status eq ''}">selected </c:if>>전체</option>
					<option value="0" <c:if test="${status eq '0'}">selected </c:if>>신청</option>
					<option value="1" <c:if test="${status eq '1'}">selected </c:if>>접수</option>
					<option value="3" <c:if test="${status eq '3'}">selected </c:if>>정상</option>
					<option value="4" <c:if test="${status eq '4'}">selected </c:if>>해지</option>
				</select>
			</td>
		</tr>
		<tr>
			<th>지 국</th>
			<td>
				<select name="boseq" id="boseq" style="width: 100px;">
					<option value="">전체</option>
					<c:forEach items="${agencyAllList }" var="list">
						<option value="${list.SERIAL }" <c:if test="${boseq eq list.SERIAL}">selected </c:if>>${list.NAME } </option>
					</c:forEach>
				</select>
			</td>
			<th>소속회사</th>
			<td>
				<select id="empComp" name="empComp" onchange="changeEmpComp();">
					<option value="">전체</option>				
					<c:forEach items="${companyCd }" var="list">
						<option value="${list.CODE }" <c:if test="${list.CODE eq empComp}"> selected </c:if>>${list.CNAME }</option>
					</c:forEach>
				</select>
			</td>
			<th>실 국</th>
			<td>
				<select id="empDept" name="empDept" onchange="changeEmpDept(this.value);">
					<option value="">전체</option>
					<c:forEach items="${deptCd }" var="list">
						<option value="${list.CODE }" <c:if test="${list.CODE eq empDept}"> selected </c:if>>${list.CNAME }</option>
					</c:forEach>	
				</select>
			</td>
			<th>부 서</th>
			<td>
				<select id="empTeam" name="empTeam">
				<option value="">전체</option>
					<c:forEach items="${teamCd }" var="list">
						<option value="${list.CODE }" <c:if test="${list.CODE eq empTeam}"> selected </c:if>>${list.CNAME }</option>
					</c:forEach>
					<c:if test="${not empty teamCd}">
						<option value="none" <c:if test="${empTeam eq 'none'}"> selected </c:if>>부서정보없음</option>
					</c:if>
				</select>
			</td>
		</tr>
		<tr>
			<th>조 회 일</th>
			<td colspan="3">
				<select name="dateType" id="dateType" style="width: 100px; vertical-align: middle;">
					<option value="1" <c:if test="${empty dateType or dateType eq '1'}">selected </c:if>>신청일</option>
					<option value="2" <c:if test="${dateType eq '2'}">selected </c:if>>중지일</option>
				</select>&nbsp;&nbsp;
				<input type="text" id="fromDate" name="fromDate"  value="<c:out value='${fromDate}' />" readonly style="text-align: center; vertical-align: middle; width: 80px" onclick="Calendar(this)" /> ~ 
				<input type="text" id="toDate" name="toDate"  value="<c:out value='${toDate}' />" readonly style="text-align: center; vertical-align: middle; width: 80px" onclick="Calendar(this)" />
			</td>
			<th>파일업로드</th>
			<td colspan="3">
				미지원
				<!-- 
				<input type="file" name="empExtdFile" id="empExtdFile" style="width:300px; vertical-align: middle;"> &nbsp;
				<a href="#fakeUrl" onclick="uploadEmpExtdFile();"><img src="/images/bt_eepl.gif" style="vertical-align: middle; border: 0;" alt="입력"></a>
				 -->
			</td>
		</tr>
	</table>
</div>
<div style="padding-top: 5px ">
	<table class="tb_search" style="width: 1020px">
		<col width="100px">
		<col width="920px">
		<tr>
			<th>상세조회</th>
			<td>
				<select name="search_type" id="search_type" style="vertical-align: middle;">
					<option value="total" <c:if test="${search_type eq 'total'}">selected </c:if>>통합검색</option>
					<option value="empNm" <c:if test="${search_type eq 'empNm'}">selected </c:if>>권유자명</option>
					<option value="empTel" <c:if test="${search_type eq 'empTel'}">selected </c:if>>권유자휴대폰</option>
					<option value="readerNm" <c:if test="${search_type eq 'readerNm'}">selected </c:if>>독자명</option>
					<option value="company" <c:if test="${search_type eq 'company'}">selected </c:if>>회사명</option>
				</select>&nbsp;&nbsp;
				<input type="text" name="search_value" id="search_value" value="${search_value}"  style="width: 140px; vertical-align: middle;" onkeydown="if(event.keyCode == 13){fn_search(); }"/>&nbsp;&nbsp;
				<a href="#fakeUrl" onclick="fn_search()"><img src="/images/bt_search.gif" style="vertical-align: middle; border: 0;" alt="검색" /></a> &nbsp;
				<a href="#fakeUrl" onclick="saveExcel()"><img src="/images/bt_savexel.gif" style="vertical-align: middle; border: 0;" alt="엑셀저장" /></a>
			</td>
		</tr>
	</table>
</div>
<!-- //search conditions -->
<!-- list -->
<div class="box_list" style="width: 1020px; margin: 0 auto;">
	<!-- counting -->
	<div style="width: 100% ;text-align : left; padding-bottom: 5px;">
		<b>◆  신문 ${totalEmpExtdCount[0].PAPER + totalEmpExtdCount[0].PAPERSTU + totalEmpExtdCount[0].PAPEREDU}부(일반 ${totalEmpExtdCount[0].PAPER}, 학생 ${totalEmpExtdCount[0].PAPERSTU}, 교육용 ${totalEmpExtdCount[0].PAPEREDU})
		   / e신문 ${totalEmpExtdCount[0].ELEC+totalEmpExtdCount[0].ELECSTU+totalEmpExtdCount[0].ELECEDU}부(일반 ${totalEmpExtdCount[0].ELEC}, 학생 ${totalEmpExtdCount[0].ELECSTU}, 교육용 ${totalEmpExtdCount[0].ELECEDU})
		   / 초판 ${totalEmpExtdCount[0].ELECF+totalEmpExtdCount[0].ELECFSTU+totalEmpExtdCount[0].ELECFEDU}부(일반 ${totalEmpExtdCount[0].ELECF}, 학생 ${totalEmpExtdCount[0].ELECFSTU}, 교육용 ${totalEmpExtdCount[0].ELECFEDU})
		   / 총 ${totalEmpExtdCount[0].TOTAL}부</b> 
	</div>
	<!-- //counting -->
	<div>
		<table class="tb_list_a" style="width: 1020px">
			<colgroup>
			   <col width="33px" >
			   <col width="40px" >
			   <col width="90px" >
			   <col width="264px" >
			   <col width="90px" >
			   <col width="60px" >
			   <col width="35px" >
			   <col width="60px" >
			   <col width="30px" >
			   <col width="65px" >
			   <col width="105px" >
			   <col width="110px" >
			   <col width="30px" >
			</colgroup>
			<tr>
				<th rowspan="2">매체</th>
				<th rowspan="2">구분</th>
				<th colspan="3">구 &nbsp; 독 &nbsp; 자 &nbsp; 정 &nbsp; 보</th>
				<th rowspan="2">신 청 일</th>
				<th rowspan="2">부수</th>
				<th rowspan="2">지 국</th>
				<th rowspan="2">상태</th>
				<th colspan="3">권 &nbsp; 유 &nbsp; 자 &nbsp; 정 &nbsp; 보</th>			
				<th rowspan="2">중지</th>
			</tr>
			<tr>
				<th>독 자 명</th>
				<th>주 소</th>
				<th>연 락 처</th>
				<th>회 사</th>
				<th>소 속</th>
				<th>성 명</th>
			</tr>
			<c:forEach items="${empExtdList}" var="list" varStatus="i">
				<tr class="mover_color">
					<td>
						<c:choose>
							<c:when test="${list.MEDIA eq '1' and list.GUBUN eq '1' and list.READERTYP eq '1'}"><img src="/images/newspaper1.png" style="vertical-align:middle; border:0" alt=""/></c:when>
							<c:when test="${list.MEDIA eq '1' and list.GUBUN eq '2' and list.READERTYP eq '1'}"><img src="/images/newspaper2.png" style="vertical-align:middle; border:0" alt=""/></c:when>
							<c:when test="${list.MEDIA eq '1' and list.READERTYP eq '2'}"><img src="/images/newspaper3.png" style="vertical-align:middle; border:0" alt=""/></c:when>						
							<c:when test="${list.MEDIA eq '1' and list.READERTYP eq '3'}"><img src="/images/newspaper4.png" style="vertical-align:middle; border:0" alt=""/></c:when>						
							<c:when test="${list.MEDIA eq '2' and list.GUBUN eq '1' and list.READERTYP eq '1'}"><img src="/images/tablet1.png" style="vertical-align:middle; border:0" alt=""/></c:when>						
							<c:when test="${list.MEDIA eq '2' and list.GUBUN eq '2' and list.READERTYP eq '1'}"><img src="/images/tablet2.png" style="vertical-align:middle; border:0" alt=""/></c:when>						
							<c:when test="${list.MEDIA eq '2' and list.READERTYP eq '2'}"><img src="/images/tablet3.png" style="vertical-align:middle; border:0" alt=""/></c:when>						
							<c:when test="${list.MEDIA eq '2' and list.READERTYP eq '3'}"><img src="/images/tablet4.png" style="vertical-align:middle; border:0" alt=""/></c:when>
							<c:when test="${list.MEDIA eq '3' and list.GUBUN eq '1' and list.READERTYP eq '1'}"><img src="/images/tablet1_time.png" style="vertical-align:middle; border:0" alt=""/></c:when>						
							<c:when test="${list.MEDIA eq '3' and list.GUBUN eq '2' and list.READERTYP eq '1'}"><img src="/images/tablet2_time.png" style="vertical-align:middle; border:0" alt=""/></c:when>						
							<c:when test="${list.MEDIA eq '3' and list.READERTYP eq '2'}"><img src="/images/tablet3_time.png" style="vertical-align:middle; border:0" alt=""/></c:when>						
							<c:when test="${list.MEDIA eq '3' and list.READERTYP eq '3'}"><img src="/images/tablet4_time.png" style="vertical-align:middle; border:0" alt=""/></c:when>						
							<c:otherwise></c:otherwise>
						</c:choose>
					</td>
					<td>
						<c:choose>
							<c:when test="${list.GUBUN eq '1' and list.READERTYP ne '2' and list.READERTYP ne '3'}">개인</c:when>
							<c:when test="${list.READERTYP eq '2'}">학생</c:when>
							<c:when test="${list.READERTYP eq '3'}">교육</c:when>
							<c:otherwise>기업</c:otherwise>
						</c:choose>
					</td>
					<td style="text-align: left">
						<a href="#fakeUrl" onclick="detailEmpExtdInfo('${list.NUMID }');">${list.READNM}</a>
						<c:if test="${not empty list.COMPNM}">
						
							<c:choose>
								<c:when test="${fn:length(list.COMPNM) > 6}">
									<br/><a title="${list.COMPNM}" style="color: black;">${fn:substring(list.COMPNM, 0, 6)}...</a>
								</c:when>
								<c:otherwise>
									<br/>${list.COMPNM}
								</c:otherwise>					
							</c:choose>
						</c:if> 
					</td>
					<td style="text-align: left">
						<c:if test="${list.MEDIA eq '1' and list.READERTYP ne '2' and list.READERTYP ne '3'}">${list.NEWADDR}<br/><b>(${list.ADDR1 })</b>${list.ADDR2 }</c:if>
					</td>
					<td>${list.READTEL}</td>
					<td>
						${list.APLCDT}
						<c:if test="${list.STATUS eq '4' }">
							<font color="red">${list.STDT}</font>
						</c:if>
					</td>
					<td>${list.QTY}</td>
					<td style="text-align: left">
						<c:choose>
							<c:when test="${empty list.READNO}">
								<c:if test="${not empty list.BOSEQNM}">${list.BOSEQNM}</c:if>
							</c:when>
							<c:otherwise>
								<a href="#fakeUrl" onclick="detailReader('${list.READNO}');">${list.BOSEQNM}</a>
							</c:otherwise>
						</c:choose>
					</td>
					<td>
						<c:choose>
							<c:when test="${list.STATUS eq '0' }">
								<font color="green"><b>신청</b></font>
							</c:when>
							<c:when test="${list.STATUS eq '1' }">
								<font color="blue"><b>접수</b></font>
							</c:when>
							<c:when test="${list.STATUS eq '4' }">
								<font color="red"><b>중지</b></font>
							</c:when>
							<c:otherwise>
								<font color="navy"><b>정상</b></font>
							</c:otherwise>
						</c:choose>
					</td>
					<td style="text-align: left; background-color: #F9F9F9"><b>${list.EMPCOMP}</b></td>
					<td style="text-align: left; background-color: #F9F9F9"><b>${list.EMPDEPT}</b>
						<c:if test="${not empty list.EMPTEAM}">
							<br><font style="font-size: 11px;">(${list.EMPTEAM})</font>
						</c:if>
					</td>
					<td style="text-align: left; background-color: #F9F9F9"><b>${list.EMPNM}</b><br>(${list.EMPTEL})</td>
					<td style="background-color: #F9F9F9">
						<c:choose>
							<c:when test="${list.STATUS eq '2' or list.STATUS eq '4'}">
							</c:when>
							<c:otherwise>
								<a href="#fakeUrl" onclick="deleteEmpExtd('${list.NUMID}', '${list.STATUS}')">
									<img src="/images/bt_imx.gif" alt="삭제" style="vertical-align:middle; border:0" alt="삭제"/>
								</a>
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
			</c:forEach>
		</table>
		<%@ include file="/common/paging.jsp"%>
	</div>
</div>
<!-- //list -->
</form>
