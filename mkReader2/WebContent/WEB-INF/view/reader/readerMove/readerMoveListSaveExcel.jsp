<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.util.*" %>
<%@ page import="com.mkreader.util.StringUtil" %>
<%@page import="com.mkreader.util.DateUtil"%>
<head>
<title>독자이전 리스트</title>
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
	<table cellpadding=3 cellspacing=1 border=0 width="550" bgcolor="#fff" class="tot_table">
		<tr>
			<td align="center" height="20" colspan="10"><b>독자이전 리스트</b></td>
		</tr>
	</table>
	<p style="top-margin:10px;">
	<table style="width: 1020px" class="list_table" border="1px">  
		<colgroup>
			<col width="45px">
			<col width="70px">
			<col width="100px">
			<col width="300px">
			<col width="80px">
			<col width="80px">
			<col width="80px">
			<col width="50px">
			<col width="60px">
			<col width="70px">
			<col width="70px">
		</colgroup>	
		<tr>
			<th>번호</th>
			<th>독자명</th>
			<th>전화번호</th>
			<th>주 &nbsp; &nbsp; &nbsp; 소</th>
			<th>전출지국</th>
			<th>전입지국</th>
			<th>부수</th>
			<th>수금방법</th>
			<th>수금월</th>
			<th>이전일자</th>
			<th>상 태</th>
		</tr>
		<c:forEach items="${readerMoveList}" var="list"  varStatus="status">
			<tr class="mover_color" style="cursor:pointer;" id="${list.SEQ}" onclick="editReaderMove(this.id);">
				<td>${status.index + 1}</td>
				<td>${list.READNM}</td>
				<td>${list.OUT_HANDY1}-${list.OUT_HANDY2}-${list.OUT_HANDY3}</td>
				<td>
					${list.OUT_ADRS1}${list.OUT_ADRS2}<br/>${list.IN_ADRS1}${list.IN_ADRS2}
				</td>				
				<td>${list.OUT_BOSEQNM}</td>
				<td>${list.IN_BOSEQNM}</td>
				<td>${list.QTY}</td>
				<td><c:if test="${list.SGTYPE == '011'}">지로</c:if><c:if test="${list.SGTYPE == '021'}">자동이체</c:if><c:if test="${list.SGTYPE == '022'}">카드</c:if><c:if test="${list.SGTYPE == '023'}">본사입금</c:if></td>
				<td>${list.SGYYMM}</td>
				<td>${list.MOVEDT}</td>
				<td>
				<font color="blue"><b><c:if test="${list.STATUS == '1'}">처리중</c:if><c:if test="${list.STATUS == '2'}">완료</c:if><c:if test="${list.STATUS == '3'}">재이전</c:if><c:if test="${list.STATUS == '4'}">취소</c:if></b></font>
				</td>
			</tr>
		</c:forEach>
	</table>