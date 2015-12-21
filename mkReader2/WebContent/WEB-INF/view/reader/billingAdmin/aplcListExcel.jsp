<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.util.*" %>
<%@ page import="com.mkreader.util.StringUtil" %>
<%@page import="com.mkreader.util.DateUtil"%>
<head>
<title>독자 원장</title>
<meta http-equiv="Content-Type" content="application/vnd.ms-excel;">
<style>
body{
	font-family:"돋움", "verdana", "Helvetica"; 
}

.txt { mso-number-format:'\@' }

.tot_table {margin:0 auto; text-align:center; border-collapse:collapse; font:normal 18px Gulim, "굴림", Verdana, Geneva; }
.tot_table th, .tot_table td {height: 30px; }
.tot_table th {text-align:center; border:1px solid #000; background-color: #ccc} 
.tot_table td {text-align:center; border:1px solid #000; }

.list_table {margin:0 auto; text-align:center; font:normal 16px Gulim, "굴림", Verdana, Geneva; border: 0;}
.list_table th, .list_table td {height: 30px}
.list_table th {text-align:center; background-color: #ccc} 
.list_table td {text-align:center; }
</style>
</head>
<body>
	<table style="background-color: #fff;">
		<tr>
			<td colspan="5">
				<table class="tot_table"> 
					<tr>
						<th>구분</th>
						<th>일반</th>
						<th>학생</th>
						<th>계</th>
					</tr>
					<tr>
						<td>일계</td>
						<td>${count[0].SUMDAY }</td>
						<td>${count[0].SUMDAYSTU }</td>
						<td>${count[0].SUMDAY + count[0].SUMDAYSTU }</td>
					</tr>
					<tr>
						<td>월계</td>
						<td>${count[0].SUMMONTH }</td>
						<td>${count[0].SUMMONTHSTU }</td>
						<td>${count[0].SUMMONTH + count[0].SUMMONTHSTU }</td>
					</tr>
					<tr>
						<td>누계</td>
						<td style="mso-number-format:'\#\,\#\#0_;">${count[0].SUMYEAR }</td>
						<td style="mso-number-format:'\#\,\#\#0_;">${count[0].SUMYEARSTU }</td>
						<td style="mso-number-format:'\#\,\#\#0_;">${count[0].SUMYEAR + count[0].SUMYEARSTU }</td>
					</tr>
				</table>
			</td>
			<td colspan="6" >
				<br/><span style="font-size: 26px; font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;신규 독자 일보</span>
				<br/><span style="font-size: 22px;">[ ${fn:substring(fromDate,0,4 ) }년 ${fn:substring(fromDate,5,7 ) }월 ${fn:substring(fromDate,8,10 ) }일  ~ ${fn:substring(toDate,0,4 ) }년 ${fn:substring(toDate,5,7 ) }월 ${fn:substring(toDate,8,10 ) }일 ]</span>
			</td>
		</tr>
	</table>
	<br />
	<table class="list_table" border="1px">
		<tr>
			<th rowspan="2" width="20%">독자명</th>
			<th rowspan="2" width="5%">우편번호</th>
			<th rowspan="2" colspan="5" width="30%">주소</th>
			<th rowspan="2" width="15%">연락처</th>
			<th rowspan="2" width="9%">관리지국</th>
			<th rowspan="2" width="10%">결제방법</th>
			<th colspan="2" width="10%">부수</th>
		</tr>
		<tr>
			<th>일반</th>
			<th>학생</th>
		</tr>
		<c:choose>
			<c:when test="${(empty aplc) && (empty tbl) && (empty stu) && (empty edu) && (empty card)}">
				<tr>
					<td colspan="11">
						데이터가 없습니다.
					</td>
				</tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${aplc }" var="list">
					<tr>
						<td style="text-align: left;">${list.USERNAME }</td>
						<td>${list.ZIP }</td>
						<td style="text-align: left;" colspan="5" >${list.ADDR }</td>
						<td>${list.HANDY }</td>
						<td>${list.BONM }</td>
						<td>${list.HJPATH }</td>
						<td>${list.BUSU }</td>
						<td></td>
					</tr>
				</c:forEach>
				<c:forEach items="${card }" var="list">
					<tr>
						<td style="text-align: left;">${list.USERNAME }</td>
						<td>${list.ZIP }</td>
						<td style="text-align: left;" colspan="5" >${list.ADDR1 }</td>
						<td>${list.HANDY }</td>
						<td>${list.BONM }</td>
						<td>${list.HJPATH }</td>
						<td>${list.BUSU }</td>
						<td></td>
					</tr>
				</c:forEach>
				<c:forEach items="${edu }" var="list">
					<tr>
						<td style="text-align: left;">${list.USERNAME }</td>
						<td>${list.ZIP }</td>
						<td style="text-align: left;"colspan="5" >${list.ADDR }</td>
						<td>${list.HANDY }</td>
						<td>${list.BONM }</td>
						<td>교육용</td>
						<td>${list.BUSU }</td>
						<td></td>
					</tr>
				</c:forEach>
				<c:forEach items="${tbl }" var="list">
					<tr>
						<td style="text-align: left;">${list.USERNAME }</td>
						<td>${list.ZIP }</td>
						<td style="text-align: left;"colspan="5" >${list.ADDR }</td>
						<td>${list.HANDY }</td>
						<td>${list.BONM }</td>
						<td>자동이체(일반)</td>
						<td>${list.BUSU }</td>
						<td></td>
					</tr>
				</c:forEach>
				<c:forEach items="${stu }" var="list">
					<tr>
						<td style="text-align: left;">${list.USERNAME }</td>
						<td>${list.ZIP }</td>
						<td style="text-align: left;" colspan="5" >${list.ADDR }</td>
						<td>${list.HANDY }</td>
						<td>${list.BONM }</td>
						<td>자동이체(학생)</td>
						<td></td>
						<td>${list.BUSU }</td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>
</body>