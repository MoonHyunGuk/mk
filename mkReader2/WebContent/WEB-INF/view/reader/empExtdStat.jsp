<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/js/ajaxUtil.js"></script>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript">

	// 부서별 현황 조회(ajax)
	function searchDetailStat(deptCd, deptNm){

		$("deptCd").value = deptCd;
		$("spanDeptNm").innerHTML = deptNm;
		clearTeamTable();
		createXMLHttpRequest();

		var url = "/reader/empExtd/empExtdStatAjax.do";
        xmlHttp.open("POST", url, true);
        xmlHttp.onreadystatechange = callback;
        xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8;");
        xmlHttp.send("deptCd="+deptCd);
	    
	}
	
	// XML Request생성
	function createXMLHttpRequest() {

	    if (window.ActiveXObject) {
	        xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
	    }else if (window.XMLHttpRequest) {
	        xmlHttp = new XMLHttpRequest();     
	    }
	}
	
	//json으로 요청값을 받을때
	function callback() {

		if (xmlHttp.readyState == 4) {
	    	if (xmlHttp.status == 200) {
	            var result = xmlHttp.responseText;
	            var autoComplete = eval('(' + result + ')');
	           
	            setTeamTable(autoComplete);
	        }else if(xmlHttp.status == 204){//데이터가 존재하지 않을 경우
	        	clearTeamTable();
	        }else{
	        	clearTeamTable();
	        }
	    }
	}
	
	/*----------------------------------------------------------------------
	 * Desc   : 부서별 현황 테이블 재구성
	 * Auth   : 박윤철
	 *----------------------------------------------------------------------*/
	function setTeamTable(autoComplete) {

	    var size = autoComplete.empExtdTeamStat.length;
		    
	    var row, cell1, cell2, cell3, cell4, cell5, cell6, cell7, cell8, cell9, cell10, cell11;
	    var teamNmNode, paperNode, paperStuNode, elecNode, elecStuNode, sumPaper, sumElec, elecFNode, elecFStuNode, sumElecF, sumTotal;
	
	    var total1 = 0;
	    var total2 = 0;
	    var total3 = 0;
	    var total4 = 0;
	    var total5 = 0;
	    var total6 = 0;
	    for (var i = 0; i < size; i++) {

	    	if(autoComplete.empExtdTeamStat[i].TEAMNM == "none"){
		        var nextNode1 = "부서정보없음";
	    	}else{
		        var nextNode1 = autoComplete.empExtdTeamStat[i].TEAMNM;    		
	    	}
	        var nextNode2 = autoComplete.empExtdTeamStat[i].PAPER;
	        var nextNode3 = autoComplete.empExtdTeamStat[i].PAPERSTU;
	        var nextNode4 = nextNode2+nextNode3;
	        var nextNode5 = autoComplete.empExtdTeamStat[i].ELEC;
	        var nextNode6 = autoComplete.empExtdTeamStat[i].ELECSTU;
	        var nextNode7 = nextNode5+nextNode6;

	        var nextNode8 = autoComplete.empExtdTeamStat[i].ELECF;
	        var nextNode9 = autoComplete.empExtdTeamStat[i].ELECFSTU;
	        var nextNode10 = nextNode8+nextNode9;

	        var nextNode11 = nextNode4+nextNode7+nextNode10;
		        
	        total1 += parseFloat(autoComplete.empExtdTeamStat[i].PAPER);
	        total2 += parseFloat(autoComplete.empExtdTeamStat[i].PAPERSTU);
	        total3 += parseFloat(autoComplete.empExtdTeamStat[i].ELEC);
	        total4 += parseFloat(autoComplete.empExtdTeamStat[i].ELECSTU);
	        
	        total5 += parseFloat(autoComplete.empExtdTeamStat[i].ELECF);
	        total6 += parseFloat(autoComplete.empExtdTeamStat[i].ELECFSTU);
	        
	        row = document.createElement("tr");
	        row.className = "teamTr";
		        
	        cell1 = document.createElement("td");
	        cell1.className = "teamTd1";
	        cell2 = document.createElement("td");
	        cell3 = document.createElement("td");
	        cell4 = document.createElement("td");
	        cell4.className = "teamTd3";
	        cell5 = document.createElement("td");
	        cell6 = document.createElement("td");
	        cell7 = document.createElement("td");
	        cell7.className = "teamTd3";

	        cell8 = document.createElement("td");
	        cell9 = document.createElement("td");
	        cell10 = document.createElement("td");
	        cell10.className = "teamTd3";

	        cell11 = document.createElement("td");
	        cell11.className = "teamTd2";
		
	        teamNmNode = document.createTextNode(nextNode1);
	        paperNode = document.createTextNode(nextNode2);
	        paperStuNode = document.createTextNode(nextNode3);
	        sumPaper = document.createTextNode(nextNode4);
	        elecNode = document.createTextNode(nextNode5);
	        elecStuNode = document.createTextNode(nextNode6);
	        sumElec = document.createTextNode(nextNode7);
	        
	        elecFNode = document.createTextNode(nextNode8);
	        elecFStuNode = document.createTextNode(nextNode9);
	        sumElecF = document.createTextNode(nextNode10);
	        
	        sumTotal = document.createTextNode(nextNode11);
	        
	        cell1.appendChild(teamNmNode);
	        cell2.appendChild(paperNode);
	        cell3.appendChild(paperStuNode);
	        cell4.appendChild(sumPaper);
	        cell5.appendChild(elecNode);
	        cell6.appendChild(elecStuNode);
	        cell7.appendChild(sumElec);
	        
	        cell8.appendChild(elecFNode);
	        cell9.appendChild(elecFStuNode);
	        cell10.appendChild(sumElecF);
	        
	        cell11.appendChild(sumTotal);

		    row.appendChild(cell1);
		    row.appendChild(cell2);
	        row.appendChild(cell3);
	        row.appendChild(cell4);
	        row.appendChild(cell5);
	        row.appendChild(cell6);
	        row.appendChild(cell7);
	        row.appendChild(cell8);
	        row.appendChild(cell9);
	        row.appendChild(cell10);
	        row.appendChild(cell11);
	        
	        $("teamTableBody").appendChild(row);
		}
	    $("total1").innerHTML = total1;
	    $("total2").innerHTML = total2;
	    $("total12").innerHTML = total1+total2;
	    $("total3").innerHTML = total3;
	    $("total4").innerHTML = total4;
	    $("total34").innerHTML = total3+total4;

	    $("total5").innerHTML = total5;
	    $("total6").innerHTML = total6;
	    $("total56").innerHTML = total5+total6;
	    
	    $("total123456").innerHTML = total1+total2+total3+total4+total5+total6;
	}
	
	// 부서별 현황 초기화
	function clearTeamTable(){
		jQuery("teamTableBody").remove();
		/*
	    var ind = $("teamTableBody").childNodes.length;
	    for (var i = ind - 1; i >= 0 ; i--) {
	    	$("teamTableBody").removeChild($("teamTableBody").childNodes[i]);
	    }
	    */
	}
	
	// 조회
	function fn_search(){
		var fm = document.getElementById("empExtdStatForm");
		
		fm.target = "_self";
		fm.action = "/reader/empExtd/empExtdStat.do";
		fm.submit() ;	
	}

	// 사원확장통계 엑셀저장
	function saveExcel(){
		var fm = document.getElementById("empExtdStatForm");
		
		fm.target="_self";
		fm.action = "/reader/empExtd/excelEmpExtdStat.do";
		fm.submit();
	}
	jQuery.noConflict();
</script>
<style> 
<!--
.teamTr{
	background-color: #ffffff;
	text-align: right;
}

.teamTd1{
	text-align: left;
}

.teamTd2{
	text-align: left;
	background-color: #F9F9F9;
}

.teamTd3{
	text-align: left;
	background-color: #FFFFCC;
}
-->
</style>
<!-- title -->
<div><span class="subTitle">사원확장 통계</span></div>
<!-- //title -->
<form id="empExtdStatForm" name="empExtdStatForm" action="" method="post">
<input type="hidden" id="deptCd" name="deptCd" value="${deptCd}" />
<!-- search conditions -->	
<div>
	<table class="tb_search" style="width: 1020px;">
		<colgroup>
			<col width="110px">
			<col width="910px">
		</colgroup>
		<tr>
			<th>신 청 일</th>
			<td>
				<div style="width: 80%; float: left;">
					<input type="text" id="fromDate" name="fromDate"  value="<c:out value='${fromDate}' />" readonly style="text-align: center; vertical-align: middle; width: 80px" onclick="Calendar(this)" /> ~ 
					<input type="text" id="toDate" name="toDate"  value="<c:out value='${toDate}' />" readonly style="text-align: center; vertical-align: middle; width: 80px" onclick="Calendar(this)"/>
					&nbsp; &nbsp;
					<a href="#fakeUrl" onclick="fn_search()"><img src="/images/bt_search.gif" style="vertical-align: middle; border: 0;" alt="검색"></a>
					&nbsp;
					<a href="#fakeUrl" onclick="saveExcel()"><img src="/images/bt_savexel.gif" style="vertical-align: middle; border: 0;" alt="액셀저장"></a>
				</div>
				<div style="width: 20%; float: left;">
					<input type="radio" name="chbx" value="all"  style="vertical-align: middle; border: 0;" <c:if test="${empty chbx or chbx eq 'all'}"> checked</c:if> onclick="fn_search()" /> 전체
					<input type="radio" name="chbx" value="on" style="vertical-align: middle; border: 0;" <c:if test="${chbx eq 'on'}"> checked</c:if> onclick="fn_search()" /> 중지독자제외
				</div>
			</td>
		</tr>
	</table>
</div>
<!-- //search conditions -->
<!-- 총계 세팅 -->
<c:set var="total_paper" value="0" />
<c:set var="total_paper_stu" value="0" />
<c:set var="total_elec" value="0" />
<c:set var="total_elec_stu" value="0" />
<!--// 총계 세팅 -->	
<!-- list -->
<div class="box_list" style="width: 1020px; margin: 0 auto;">
	<div style="text-align: right;"><b>${toDay}.</b></div>
	<div style="width: 550px ;float: left; padding-right: 20px">
		<div><b><img src="/images/i.gif" style="vertical-align: middle; border: 0;" alt=""> 실국별현황</b></div>
		<table class="tb_list_a" style="width: 550px">
			<colgroup>
				<col width="80px;">
				<col width="100px;">
				<col width="35px;">
				<col width="35px;">
				<col width="40px;">
				<col width="35px;">
				<col width="35px;">
				<col width="40px;">
				<col width="35px;">
				<col width="35px;">
				<col width="80px;">
			</colgroup>
			<tr>
				<th rowspan="3">회사명</th>
				<th rowspan="3">실국명</th>
				<th colspan="9">부수</th>
			</tr>
			<tr>
				<th colspan="3">신문</th>
				<th colspan="3">e신문</th>
				<th colspan="2">초판</th>
				<th rowspan="2">합계</th>
			</tr>
			<tr>
				<th>일반</th>
				<th>학생</th>
				<th>계</th>
				<th>일반</th>
				<th>학생</th>
				<th>계</th>
				<th>일반</th>
				<th>계</th>
			</tr>
			<c:forEach items="${empExtdStat}" var="list" varStatus="i">
				<!-- rowspan 세팅용 변수 -->
				<c:if test="${list.COMPNM ne prev_row}"><c:set var="check_row" value="0" /></c:if>
				<c:if test="${list.COMPNM eq prev_row}"><c:set var="check_row" value="${check_row + 1}" /></c:if>
				<!--// rowspan 세팅용 변수 -->
					
				<tr onclick="searchDetailStat('${list.DEPTCD}', '${list.DEPTNM}')" style="cursor: pointer;">
					<c:if test="${check_row == 0}">
						<td style="text-align: left" rowspan="<c:out value='${list.PARTCNT}'/>">${list.COMPNM}</td>
					</c:if>
						<td style="text-align: left">${list.DEPTNM}</td>
						<td style="text-align: right">${list.PAPER}</td>
						<td style="text-align: right">${list.PAPERSTU}</td>
						<td style="text-align: right; background-color: #FFFFCC">${list.PAPER+list.PAPERSTU}</td>
						<td style="text-align: right">${list.ELEC}</td>
						<td style="text-align: right">${list.ELECSTU}</td>
						<td style="text-align: right; background-color: #FFFFCC">${list.ELEC+list.ELECSTU}</td>
						<td style="text-align: right">${list.ELECF}</td>
						<td style="text-align: right; background-color: #FFFFCC">${list.ELECF}</td>
						<td style="text-align: right; background-color: #F9F9F9">${list.PAPER+list.PAPERSTU+list.ELEC+list.ELECSTU+list.ELECF}</td>
						
						<!-- 회사별 합계 세팅 -->
						<c:set var="sum_paper" value="${sum_paper+list.PAPER}" />
						<c:set var="sum_paper_stu" value="${sum_paper_stu+list.PAPERSTU}"/>
						<c:set var="sum_elec" value="${sum_elec+list.ELEC}"/>
						<c:set var="sum_elec_stu" value="${sum_elec_stu+list.ELECSTU}"/>
						<c:set var="sum_elecf" value="${sum_elecf+list.ELECF}"/>
						<c:set var="sum_elecf_stu" value="${sum_elecf_stu}"/>
						<!--// 회사별 합계 세팅 -->
				</tr>

					<!-- 회사별 마지막 줄에 소계 출력 -->
					<c:if test="${(list.PARTCNT-1) == check_row}">
						<tr>
							<td colspan="2" style="background-color: #FFE6D8">회사별 소계</td>
							<td style="text-align: right; background-color: #FFE6D8">${sum_paper}</td>
							<td style="text-align: right; background-color: #FFE6D8">${sum_paper_stu}</td>
							<td style="text-align: right; background-color: #FFE6D8">${sum_paper+sum_paper_stu}</td>
							<td style="text-align: right; background-color: #FFE6D8">${sum_elec}</td>
							<td style="text-align: right; background-color: #FFE6D8">${sum_elec_stu}</td>
							<td style="text-align: right; background-color: #FFE6D8">${sum_elec+sum_elec_stu}</td>
							<td style="text-align: right; background-color: #FFE6D8">${sum_elecf}</td>
							<td style="text-align: right; background-color: #FFE6D8">${sum_elecf+sum_elecf_stu}</td>
							<td style="text-align: right; background-color: #F9F9F9">${sum_paper+sum_paper_stu+sum_elec+sum_elec_stu+sum_elecf+sum_elecf_stu}</td>
						</tr>

						<!-- 회사별 합계 합산 -->
						<c:set var="total_paper" value="${total_paper+sum_paper}" />
						<c:set var="total_paper_stu" value="${total_paper_stu+sum_paper_stu}" />
						<c:set var="total_elec" value="${total_elec+sum_elec}" />
						<c:set var="total_elec_stu" value="${total_elec_stu+sum_elec_stu}"/>
						<c:set var="total_elecf" value="${total_elecf+sum_elecf}"/>
						<c:set var="total_elecf_stu" value="${total_elecf_stu+sum_elecf_stu}"/>
						<!--// 회사별 합계 합산 -->
					
						<!-- 회사별 합계 초기화 -->
						<c:set var="sum_paper" value="0" />
						<c:set var="sum_paper_stu" value="0" />
						<c:set var="sum_elec" value="0" />
						<c:set var="sum_elec_stu" value="0" />
						<c:set var="sum_elecf" value="0" />
						<c:set var="sum_elecf_stu" value="0" />
						<!--// 회사별 합계 초기화 -->

					</c:if>
					<!--// 회사별 마지막 줄에 소계 출력 -->

				<c:set var="prev_row"><c:out value="${list.COMPNM}" /></c:set>
			</c:forEach>
			<!-- 총계 출력 -->
			<tr>
				<td colspan="2" style="background-color: #CCDBFB">총계</td>
				<td style="text-align: right; background-color: #CCDBFB">${total_paper}</td>
				<td style="text-align: right; background-color: #CCDBFB">${total_paper_stu}</td>
				<td style="text-align: right; background-color: #CCDBFB">${total_paper+total_paper_stu}</td>
				<td style="text-align: right; background-color: #CCDBFB">${total_elec}</td>
				<td style="text-align: right; background-color: #CCDBFB">${total_elec_stu}</td>
				<td style="text-align: right; background-color: #CCDBFB">${total_elec+total_elec_stu}</td>
				<td style="text-align: right; background-color: #CCDBFB">${total_elecf}</td>
				<td style="text-align: right; background-color: #CCDBFB">${total_elecf+total_elecf_stu}</td>
				<td style="text-align: right; background-color: #CCDBFB">${total_paper+total_paper_stu+total_elec+total_elec_stu+total_elecf+total_elecf_stu}</td>
			</tr>
			<!--// 총계 출력 -->
		</table>
	</div>
	<div style="width: 450px ;float: left;">
		<div><b><img src="/images/i.gif" style="vertical-align: middle; border: 0" alt=""> <font id="spanDeptNm">편집국</font> 부서별 현황</b></div>
		<table class="tb_list_a" style="width: 450px">
			<colgroup>
				<col width="80px" >
				<col width="35px" >
				<col width="35px" >
				<col width="40px" >
				<col width="35px" >
				<col width="35px" >
				<col width="40px" >
				<col width="35px" >
				<col width="35px" >
				<col width="80px" >
			</colgroup>
			<tr>
				<th rowspan="3">부서명</th>
				<th colspan="9">부수</th>
			</tr>
			<tr>
				<th colspan="3">신문</th>
				<th colspan="3">e신문</th>
				<th colspan="2">초판</th>
				<th rowspan="2">합계</th>
			</tr>
			<tr>
				<th>일반</th>
				<th>학생</th>
				<th>계</th>
				<th>일반</th>
				<th>학생</th>
				<th>계</th>
				<th>일반</th>
				<th>계</th>
			</tr>
			<tbody id="teamTableBody">
				<c:forEach items="${empExtdTeamStat}" var="list" varStatus="i">
				<tr>
					<c:choose>
						<c:when test="${list.TEAMNM eq 'none'}">
							<td style="text-align: left">부서정보없음</td>
						</c:when>
						<c:otherwise>
							<td style="text-align: left">${list.TEAMNM}</td>
						</c:otherwise>
					</c:choose>
					<td style="text-align: right">${list.PAPER}</td>
					<td style="text-align: right">${list.PAPERSTU}</td>
					<td style="text-align: right; background-color: #FFFFCC">${list.PAPER+list.PAPERSTU}</td>
					<td style="text-align: right">${list.ELEC}</td>
					<td style="text-align: right">${list.ELECSTU}</td>
					<td style="text-align: right; background-color: #FFFFCC">${list.ELEC+list.ELECSTU}</td>
					<td style="text-align: right">${list.ELECF}</td>
					<td style="text-align: right; background-color: #FFFFCC">${list.ELECF}</td>
					<td style="text-align: right; background-color: #F9F9F9">${list.PAPER+list.PAPERSTU+list.ELEC+list.ELECSTU+list.ELECF}</td>
					
					<!-- 부서별 합계 세팅 -->
					<c:set var="total_paper2" value="${total_paper2+list.PAPER}" />
					<c:set var="total_paper_stu2" value="${total_paper_stu2+list.PAPERSTU}"/>
					<c:set var="total_elec2" value="${total_elec2+list.ELEC}"/>
					<c:set var="total_elec_stu2" value="${total_elec_stu2+list.ELECSTU}"/>
					<c:set var="total_elecf2" value="${total_elecf2+list.ELECF}"/>
					<c:set var="total_elecf_stu2" value="${total_elecf_stu2}"/>
					<!--// 부서별 합계 세팅 -->
				</tr>
				</c:forEach>
			</tbody>
			<!-- 총계 출력 -->
			<tr>
				<td style="background-color: #CCDBFB">총계</td>
				<td id="total1" style="text-align: right; background-color: #CCDBFB">${total_paper2}</td>
				<td id="total2" style="text-align: right; background-color: #CCDBFB">${total_paper_stu2}</td>
				<td id="total12"style="text-align: right; background-color: #CCDBFB">${total_paper2+total_paper_stu2}</td>
				<td id="total3" style="text-align: right; background-color: #CCDBFB">${total_elec2}</td>
				<td id="total4" style="text-align: right; background-color: #CCDBFB">${total_elec_stu2}</td>
				<td id="total34" style="text-align: right; background-color: #CCDBFB">${total_elec2+total_elec_stu2}</td>
				<td id="total5" style="text-align: right; background-color: #CCDBFB">${total_elecf2}</td>
				<td id="total56" style="text-align: right; background-color: #CCDBFB">${total_elecf2+total_elecf_stu2}</td>
				<td id="total123456" style="text-align: right; background-color: #CCDBFB">${total_paper2+total_paper_stu2+total_elec2+total_elec_stu2+total_elecf2+total_elecf_stu2}</td>
			</tr>
			<!--// 총계 출력 -->
		</table>
	</div>
</div>
<div style="width: 1020px ; clear: both; padding-top: 20px">
	<div><b><img src="/images/i.gif" style="vertical-align: middle; border: 0" alt=""> 개인실적 우수자</b></div>
	<table class="tb_list_a" style="width: 1020px">
		<colgroup>
			<col width="40px" >
			<col width="90px" >
			<col width="90px" >
			<col width="120px" >
			<col width="80px" >
			<col width="100px" >
			<col width="50px" >
			<col width="50px" >
			<col width="50px" >
			<col width="50px" >
			<col width="50px" >
			<col width="50px" >
			<col width="50px" >
			<col width="50px" >
			<col width="100px" >
		</colgroup>
		<tr>
			<th rowspan="3">순위</th>
			<th rowspan="3">회사명</th>
			<th rowspan="3">실국명</th>
			<th rowspan="3">부서명</th>
			<th rowspan="3">성명</th>
			<th rowspan="3">휴대폰번호</th>
			<th colspan="9">부수</th>
		</tr>
		<tr>
			<th colspan="3">신문</th>
			<th colspan="3">e신문</th>
			<th colspan="2">초판</th>
			<th rowspan="2">합계</th>
		</tr>
		<tr>
			<th>일반</th>
			<th>학생</th>
			<th>계</th>
			<th>일반</th>
			<th>학생</th>
			<th>계</th>
			<th>일반</th>
			<th>계</th>
		</tr>
		<c:forEach items="${getEmpExtdTop}" var="list" varStatus="i">
			<tr>
				<td>${list.RM}</td>
				<td style="text-align: left">${list.EMPCOMP}</td>
				<td style="text-align: left">${list.EMPDEPT}</td>
				<td style="text-align: left">${list.EMPTEAM}</td>
				<td style="text-align: left">${list.EMPNM}</td>
				<td>${list.EMPTEL}</td>
				<td style="text-align: right">${list.PAPER}</td>
				<td style="text-align: right">${list.PAPERSTU}</td>
				<td style="text-align: right; background-color: #FFFFCC">${list.PAPER+list.PAPERSTU}</td>
				<td style="text-align: right">${list.ELEC}</td>
				<td style="text-align: right">${list.ELECSTU}</td>
				<td style="text-align: right; background-color: #FFFFCC">${list.ELEC+list.ELECSTU}</td>
				<td style="text-align: right">${list.ELECF}</td>
				<td style="text-align: right; background-color: #FFFFCC">${list.ELECF}</td>
				<td style="text-align: right; background-color: #F9F9F9">${list.QTY}</td>
			</tr>
			</c:forEach>
	</table>
</div>
</form>