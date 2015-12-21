<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<head>
<title>사원확장통계</title>
<style> 
<!--
.teamTr{
	background-color: ffffff;
	text-align: right;
}

.teamTd1{
	text-align: left;
}

.reamTd2{
	background-color: F9F9F9;
}

.reamTd3{
	background-color: FFFFCC;
}
-->
</style>

<table cellpadding=3 cellspacing=1 border=0 width=100% bgcolor=#fff>
	<tr>
		<td align="center" colspan="21"><font style="font-size: large; font-weight: bolder;">사원확장통계</font></td>
	</tr>
	<tr>
		<td align="right" colspan="21"><b>${fromDate} ~ ${toDate}</b></td>
	</tr>
</table>

<p style="top-margin:10px;">
<table width="100%" cellpadding=3 cellspacing=1 border=0 bgcolor=#fff>
	<tr>
		<td width="50%">
			<b>◆ 실국별통계</b>
			<table width="100%" cellpadding="5" cellspacing="1" border="1" bgcolor="e5e5e5" style="margin-top: 5px;">
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
				<tr bgcolor="f9f9f9">
					<td align="center" rowspan="3"><font class="b02">회사명</font></td>
					<td align="center" rowspan="3"><font class="b02">실국명</font></td>
					<td align="center" colspan="9"><font class="b02">부수</font></td>
				</tr>
				<tr bgcolor="f9f9f9">
					<th colspan="3">신문</th>
					<th colspan="3">e신문</th>
					<th colspan="2">초판</th>
					<td align="center" rowspan="2"><font class="b02">합계</font></td>
				</tr>
				<tr bgcolor="f9f9f9">
					<td align="center"><font class="b02">일반</font></td>
					<td align="center"><font class="b02">학생</font></td>
					<td align="center"><font class="b02">계</font></td>
					<td align="center"><font class="b02">일반</font></td>
					<td align="center"><font class="b02">학생</font></td>
					<td align="center"><font class="b02">계</font></td>
					<td align="center"><font class="b02">일반</font></td>
					<td align="center"><font class="b02">계</font></td>
				</tr>
				<!-- 총계 세팅 -->
				<c:set var="total_paper" value="0" />
				<c:set var="total_paper_stu" value="0" />
				<c:set var="total_elec" value="0" />
				<c:set var="total_elec_stu" value="0" />
				<!--// 총계 세팅 -->

				<c:forEach items="${empExtdStat}" var="list" varStatus="i">
					<!-- rowspan 세팅용 변수 -->
					<c:if test="${list.COMPNM ne prev_row}"><c:set var="check_row" value="0" /></c:if>
					<c:if test="${list.COMPNM eq prev_row}"><c:set var="check_row" value="${check_row + 1}" /></c:if>
					<!--// rowspan 세팅용 변수 -->
						
					<tr bgcolor="ffffff">
						<c:if test="${check_row == 0}">
							<td align="left" rowspan="<c:out value='${list.PARTCNT}'/>">${list.COMPNM}</td>
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
		</td>
		<td>
		</td>
		<td width="48%">
			<b>◆  ${empExtdTeamStat[0].DEPTNM} 부서별 통계</b>
			<table width="100%" cellpadding="5" cellspacing="1" border="1" bgcolor="e5e5e5" style="margin-top: 5px;">
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
				<tr bgcolor="f9f9f9">
					<td align="center" rowspan="3"><font class="b02">부서명</font></td>
					<td align="center" colspan="9"><font class="b02">부수</font></td>
				</tr>
				<tr bgcolor="f9f9f9">
					<td align="center" colspan="3"><font class="b02">신문</font></td>
					<td align="center" colspan="3"><font class="b02">e신문</font></td>
					<td align="center" colspan="2"><font class="b02">초판</font></td>
					<td align="center" rowspan="2"><font class="b02">합계</font></td>
				</tr>
				<tr bgcolor="f9f9f9">
					<td align="center"><font class="b02">일반</font></td>
					<td align="center"><font class="b02">학생</font></td>
					<td align="center"><font class="b02">계</font></td>
					<td align="center"><font class="b02">일반</font></td>
					<td align="center"><font class="b02">학생</font></td>
					<td align="center"><font class="b02">계</font></td>
					<td align="center"><font class="b02">일반</font></td>
					<td align="center"><font class="b02">계</font></td>
				</tr>
					<c:forEach items="${empExtdTeamStat}" var="list" varStatus="i">
					<tr bgcolor="ffffff">
						<c:choose>
							<c:when test="${list.TEAMNM eq 'none'}">
								<td align="left">부서정보없음</td>
							</c:when>
							<c:otherwise>
								<td align="left">${list.TEAMNM}</td>
							</c:otherwise>
						</c:choose>
						<td align="right">${list.PAPER}</td>
						<td align="right">${list.PAPERSTU}</td>
						<td align="right" bgcolor="FFFFCC">${list.PAPER+list.PAPERSTU}</td>
						<td align="right">${list.ELEC}</td>
						<td align="right">${list.ELECSTU}</td>
						<td align="right" bgcolor="FFFFCC">${list.ELEC+list.ELECSTU}</td>
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
		</td>
	</tr>
	<tr>
		<td colspan="3">
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<b>◆ 개인실적 우수자</b>
			<table width="100%" cellpadding="5" cellspacing="1" border="1" bgcolor="e5e5e5" style="margin-top: 5px;">
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
					<col width="50px" >
					<col width="50px" >
				</colgroup>
				<tr bgcolor="f9f9f9">
					<td align="center" rowspan="3"><font class="b02">순위</font></td>
					<td align="center" rowspan="3"><font class="b02">회사명</font></td>
					<td align="center" rowspan="3"><font class="b02">실국명</font></td>
					<td align="center" rowspan="3"><font class="b02">부서명</font></td>
					<td align="center" rowspan="3"><font class="b02">성명</font></td>
					<td align="center" rowspan="3"><font class="b02">휴대폰번호</font></td>
					<td align="center" colspan="9"><font class="b02">부수</font></td>
				</tr>
				<tr bgcolor="f9f9f9">
					<td align="center" colspan="3"><font class="b02">신문</font></td>
					<td align="center" colspan="3"><font class="b02">e신문</font></td>
					<td align="center" colspan="2"><font class="b02">초판</font></td>
					<td align="center" rowspan="2"><font class="b02">합계</font></td>
				</tr>
				<tr bgcolor="f9f9f9">
					<td align="center"><font class="b02">일반</font></td>
					<td align="center"><font class="b02">학생</font></td>
					<td align="center"><font class="b02">계</font></td>
					<td align="center"><font class="b02">일반</font></td>
					<td align="center"><font class="b02">학생</font></td>
					<td align="center"><font class="b02">계</font></td>
					<td align="center"><font class="b02">일반</font></td>
					<td align="center"><font class="b02">계</font></td>
				</tr>

				<c:forEach items="${getEmpExtdTop}" var="list" varStatus="i">
					<tr bgcolor="ffffff">
						<td align="center">${list.RM}</td>
						<td align="left">${list.EMPCOMP}</td>
						<td align="left">${list.EMPDEPT}</td>
						<td align="left">${list.EMPTEAM}</td>
						<td align="left">${list.EMPNM}</td>
						<td align="center">${list.EMPTEL}</td>
						<td align="right">${list.PAPER}</td>
						<td align="right">${list.PAPERSTU}</td>
						<td align="right" bgcolor="FFFFCC">${list.PAPER+list.PAPERSTU}</td>
						<td align="right">${list.ELEC}</td>
						<td align="right">${list.ELECSTU}</td>
						<td align="right" bgcolor="FFFFCC">${list.ELEC+list.ELECSTU}</td>
						<td style="text-align: right">${list.ELECF}</td>
						<td style="text-align: right; background-color: #FFFFCC">${list.ELECF}</td>
						<td align="right" bgcolor="F9F9F9">${list.QTY}</td>
					</tr>
					</c:forEach>
			</table>
		</td>
	</tr>
</table>