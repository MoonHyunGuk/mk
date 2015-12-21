<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<head>
<title>사원확장리스트</title>

<form id="empExtdListForm" name="empExtdListForm" action="" method="post" enctype="multipart/form-data">

	<table width="100%" cellpadding="0" cellspacing="0"  border="0">
		<tr>
			<td align="center" colspan="21"><font style="font-size: large; font-weight: bolder;">사원확장리스트</font></td>
		</tr>
		<tr>
			<td>
			</td>
		</tr>
	</table>

	<div style="width: 100% ;float: left; margin-top: 10px;">
		<b>◆  신문 ${totalEmpExtdCount[0].PAPER + totalEmpExtdCount[0].PAPERSTU + totalEmpExtdCount[0].PAPEREDU}부(일반 ${totalEmpExtdCount[0].PAPER}, 학생 ${totalEmpExtdCount[0].PAPERSTU}, 교육용 ${totalEmpExtdCount[0].PAPEREDU})
		   / e신문 ${totalEmpExtdCount[0].ELEC+totalEmpExtdCount[0].ELECSTU+totalEmpExtdCount[0].ELECEDU}부(일반 ${totalEmpExtdCount[0].ELEC}, 학생 ${totalEmpExtdCount[0].ELECSTU}, 교육용 ${totalEmpExtdCount[0].ELECEDU})
		   / 초판 ${totalEmpExtdCount[0].ELECF+totalEmpExtdCount[0].ELECFSTU+totalEmpExtdCount[0].ELECFEDU}부(일반 ${totalEmpExtdCount[0].ELECF}, 학생 ${totalEmpExtdCount[0].ELECFSTU}, 교육용 ${totalEmpExtdCount[0].ELECFEDU})
		   / 총 ${totalEmpExtdCount[0].TOTAL}부</b>  
	</div>
	<table width="100%" cellpadding="5" cellspacing="1" border="1" bgcolor="e5e5e5" class="b_01" style="margin-top: 5px;">
		<colgroup>
			<col width="33px" />
			<col width="40px" />
			<col width="" />
			<col width="" />
			<col width="" />
			<col width="78px" />
			<col width="60px" />
			<col width="35px" />
			<col width="60px" />
			<col width="30px" />
			<col width="65px" />
			<col width="105px" />
			<col width="90px" />
			<col width="" />
			<col width="" />
		</colgroup>
		<tr bgcolor="f9f9f9">
			<td align="center" rowspan="2"><font class="b02">매체</font></td>
			<td align="center" rowspan="2"><font class="b02">구분</font></td>
			<td align="center" colspan="4"><font class="b02">구 &nbsp; 독 &nbsp; 자 &nbsp; 정 &nbsp; 보</font></td>
			<td align="center" rowspan="2"><font class="b02">신 청 일</font></td>
			<td align="center" rowspan="2"><font class="b02">부수</font></td>
			<td align="center" rowspan="2"><font class="b02">지 국</font></td>
			<td align="center" rowspan="2"><font class="b02">상태</font></td>
			<td align="center" colspan="5"><font class="b02">권 &nbsp; 유 &nbsp; 자 &nbsp; 정 &nbsp; 보</font></td>			
		</tr>
		<tr bgcolor="f9f9f9">
			<td align="center"><font class="b02">독 자 명</font></td>
			<td align="center"><font class="b02">회 사 명(담당자)</font></td>
			<td align="center"><font class="b02">주 소</font></td>
			<td align="center"><font class="b02">연 락 처</font></td>
			<td align="center"><font class="b02">회 사</font></td>
			<td align="center"><font class="b02">부 서</font></td>
			<td align="center"><font class="b02">팀</font></td>
			<td align="center"><font class="b02">성 명</font></td>
			<td align="center"><font class="b02">휴대폰</font></td>
		</tr>
		<c:forEach items="${empExtdList}" var="list" varStatus="i">
			<tr <c:if test="${list.MEDIA eq '1' and (list.READERTYP ne '2' or list.READERTYP ne '3')}">bgcolor="ffffff"</c:if><c:if test="${list.MEDIA eq '2' or list.MEDIA eq '3' or list.READERTYP eq '2'}">bgcolor="FFFFCC"</c:if>>
				<td align="center">
					<c:choose>
						<c:when test="${list.MEDIA eq '1' }">신문</c:when>
						<c:when test="${list.MEDIA eq '2' }">e신문</c:when>
						<c:otherwise>초판</c:otherwise>
					</c:choose>
				</td>
				<td align="center">
					<c:choose>
						<c:when test="${list.GUBUN eq '1' and list.READERTYP ne '2'}">개인</c:when>
						<c:when test="${list.READERTYP eq '2'}">학생</c:when>
						<c:otherwise>기업</c:otherwise>
					</c:choose>
				</td>
				<td align="left">${list.READNM}</td>
				<td>${list.COMPNM}</td>
				<td align="left"><c:if test="${list.MEDIA eq '1' and list.READERTYP ne '2'}">${list.ADDR1} ${list.ADDR2}</c:if></td>
				<td align="center">${list.READTEL}</td>
				<td align="center">
					${list.APLCDT}
					<c:if test="${list.STATUS eq '4' }">
						<br><font color="red">${list.STDT}</font>
					</c:if>
				</td>
				<td align="right">${list.QTY}</td>
				<td align="left">${list.BOSEQNM}</td>
				<td align="center">
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
				<td align="left">${list.EMPCOMP}</td>
				<td align="left">${list.EMPDEPT}</td>
				<td align="left">${list.EMPTEAM}</td>
				<td align="left">${list.EMPNM}</td>
				<td align="left">${list.EMPTEL}</td>
			</tr>
		</c:forEach>
	</table>

</form>
</body>
