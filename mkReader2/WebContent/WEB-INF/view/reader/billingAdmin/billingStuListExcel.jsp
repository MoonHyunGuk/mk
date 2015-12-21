<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.util.*" %>
<%@ page import="com.mkreader.util.StringUtil" %>
<%@page import="com.mkreader.util.DateUtil"%>
<head>
<title>독자 원장</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style>
body,a,table,tr,td {
	scrollbar-face-color: #E3E3E3;
	scrollbar-shadow-color: #ffffff;
	scrollbar-highlight-color: #B2B2B2;
	scrollbar-3dlight-color: #ffffff;
	scrollbar-darkshadow-color: #B2B2B2;
	scrollbar-track-color: #ffffff;
	scrollbar-arrow-color: #333333;
	font-family:"돋움", "verdana", "Helvetica";
	font-size:9pt; 
	color : #333333; 
	text-decoration:none;
	line-height :100%; 
	letter-spacing:0px;
}

.notice a:hover {
	font-family:"돋움", "verdana", "Helvetica";
	font-size:9pt;
	color:#4187A0; 
	text-decoration:none;
	line-height:130%; 
	letter-spacing:0px;
}

.board a:hover {
	font-family:"돋움", "verdana", "Helvetica";
	font-size:9pt;
	color:#197567;
	text-decoration:underline;
	line-height:130%; 
	letter-spacing:0px;
}

.menu a:hover {
	font-family:"돋움", "verdana", "Helvetica";
	font-size:9pt;
	color:#197567;
	text-decoration:underline;
	line-height:130%; 
	letter-spacing:0px;
}	

.res {
	color:#0082A2;
	border-width:1;
	border-style: solid;
	border-color: #CECECE;
	background-color: #ffffff; 
}

.bd {
	color:#6E9B33;
	border-width:1;
	border-style:solid;
	border-color:#CECECE;
	background-color:#FFFFFF
}
		
/*
input,select,textarea { 
	scrollbar-face-color: #ffffff;
	scrollbar-shadow-color: #C4C4C4;
	scrollbar-highlight-color: #ffffff;
	scrollbar-3dlight-color: #C4C4C4;
	scrollbar-darkshadow-color: #ffffff;
	scrollbar-track-color: #ffffff;
	scrollbar-arrow-color: #0082A2;
	font-family:"verdana", "Helvetica";
	font-size:8pt;
	color:#7B7C7C;
}
*/

A {
	text-decoration:none; 
			font-size: 9pt;
	color : #333333;
			line-height: 15px;
			font-face:돋움,seoul,helvetica;
}
A:hover {
	text-decoration:none; 
			font-size: 9pt;
	color : #ff6600;
			line-height: 15px;
			font-face:돋움,seoul,helvetica;
}


.default01 {
	 font-size: 9pt;
			 color: #000000;
			 text-decoration: none;
			 font-face:돋움,seoul,helvetica;
}

.default {
	 font-size: 9pt;
			 color: #000000;
			 text-decoration: none;
			 font-face:돋움,seoul,helvetica;
			 line-height: 22px;
}

.default_red {
	 font-size: 9pt;
			 color: B70039;
			 font-face:돋움,seoul,helvetica;
			 line-height: 22px;

}

.default_bold {
	 font-size: 9pt;
			 color: #000000;
			 font-face:돋움,seoul,helvetica;
			 line-height: 22px;
			 font-weight: bold;
}

.bg_gray { 
		background-color: #CCCCCC;
		font-face:돋움,seoul,helvetica;
		font-size: 9pt; 
		color: #333333;
		line-height: 15px; 
		text-align: center; 
		border-style: none
}

.bg_gray02 { 
		 background-color: #f6cc0b; 
		 font-face:돋움,seoul,helvetica; 
		 font-size: 9pt; color: #333333;                  
		 line-height: 20px; 
		 margin-left: 5px; 
		 padding-left: 5px; 
		 margin-right: 5px; 
		 padding-right: 5px; 
		 border-style: none
}


.bg_gray03 { 
		background-color: #CCCCCC; 
		font-face:돋움,seoul,helvetica; 
		font-size: 9pt; color: #333333;                  
		line-height: 20px; 
		border-bottom: white 1px solid; 
		border-left: white 1px solid; 
		border-right: white 1px solid; 
		border-top: white 1px solid; 
}


.linePit { 
		 background-color: #FFFFFF; 
		 font-face:돋움,seoul,helvetica; 
		 font-size: 9pt; color: #006699;                  
		 line-height: 100%; 
		 border-style: none
}

.bg_g { 
		background-color: #CCCCCC;
		font-face:돋움,seoul,helvetica;
		font-size: 9pt; 
		color: #333333;
		text-align: center; 
		border-style: none
}



.bg_g02 { 
		 background-color: #FFFFFF; 
		 font-face:돋움,seoul,helvetica; 
		 font-size: 9pt; color: #333333;                  
		 border-style: none
}


.form {
	border-bottom: black 1px solid;
	border-left: black 1px solid;
	border-right: black 1px solid;
	border-top: black 1px solid;
	font-family:"돋움", "Verdana", "Arial";
	font-size:9pt
	color: #000000;
}


.form02 {  
	border-bottom: white 1px solid; 
	border-left: white 1px solid; 
	border-right: white 1px solid; 
	border-top: white 1px solid; 
	font-family:"돋움", "Verdana", "Arial"; 
	font-size:9pt;
	color: #333333;
	padding-top : 3pt
}


.btn {
	border-bottom: black 1px solid;
	border-left: black 1px solid;
	border-right: black 1px solid;
	border-top: black 1px solid;
	font-family:"돋움", "Verdana", "Arial";
	font-size:9pt
	color: #000000;
	background-color: #CCCCCC;
}


.bg_gray01 { 
	background-color: #EFEFEF; 
	font-face:돋움,seoul,helvetica; 
	font-size: 9pt; color: #333333; 	line-height: 25px; 
	margin-left: 5px; 
	padding-left: 5px; 
	margin-right: 5px; 
	padding-right: 5px; 
	border-style: none 
}

.form03 {
	border-bottom: white 1px solid; 
	border-left: white 1px solid; 
	border-right: white 1px solid; 
	border-top: white 1px solid; 
	font-family:"돋움", "Verdana", "Arial"; font-size:9pt; padding-top : 3pt 
	}
	
.txt {
	mso-number-format:'\@'
}
.tdbd {
  BORDER-RIGHT: black 1px solid;
  BORDER-TOP: black 1px solid; 
  BORDER-LEFT: black 1px solid; 
  BORDER-BOTTOM: black 1px solid;
}

</style>
	<table cellpadding=3 cellspacing=1 border=0 width=550 bgcolor=#fff>
		<tr>
			<td align="center" height="20" colspan="9"><b>자동이체 학생 리스트</b></td>
		</tr>
	</table>
	<p style="top-margin:10px;">
	<table cellpadding=3 cellspacing=1 border=0 width=550 bgcolor=#fff>
		<tr>
			<td align="center" colspan="10"><b>[</b> ${fn:substring(fromDate,0,4 ) }년 ${fn:substring(fromDate,5,7 ) }월 ${fn:substring(fromDate,8,10 ) }일  ~ ${fn:substring(toDate,0,4 ) }년 ${fn:substring(toDate,5,7 ) }월 ${fn:substring(toDate,8,10 ) }일 <b>]</b></td>
		</tr>
	</table>
	<p style="top-margin:10px;">
	<table cellpadding=3 cellspacing=1 border=1 width=550 bgcolor=#fff>
		<tr class=bg_gray>
			<td align="center">관리지국</td>
			<td align="center">대학명</td>
			<td align="center">학과</td>
			<td align="center">학년</td>
			<td align="center">성명</td>
			<td align="center">주소</td>
			<td align="center">휴대폰</td>
			<td align="center">추천교수</td>			
			<td align="center">신청일<br/>(해지일)</td>
			<td align="center">현재상태</td>
		</tr>
		
		<c:choose>
			<c:when test="${empty excel }">
				<tr>
					<td align="center" colspan="9">
						데이터가 없습니다.
					</td>
				</tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${excel }" var="list">
					<tr>
						<td align="left">${list.JIKUKNM }</td>
						<td align="left">${list.STU_SCH }</td>
						<td align="left">${list.STU_PART }</td>
						<td align="center">${list.STU_CLASS }</td>
						<td align="left">${list.USERNAME }</td>
						<td align="left">${list.NEWADDR }(${list.ADDR1 })${list.ADDR2 }</td>
						<td align="left">${list.HANDY }</td>
						<td align="left">${list.STU_PROF }</td>
						<td align="center">${list.INDATE }<c:if test="${not empty list.R_OUT_DATE }"><br/>(<font class="b03">${list.R_OUT_DATE }</font>)</c:if></td>
						<c:choose>
							<c:when test="${list.STATUS eq '' }">
								<td align="center">비정규신규 신청</td>
							</c:when>
							<c:when test="${list.STATUS eq 'EA00' }">
								<td align="center">신규 신청</td>
							</c:when>
							<c:when test="${list.STATUS eq 'EA13' }">
								<td align="center">신규 CMS확인중</td>
							</c:when>
							<c:when test="${list.STATUS eq 'EA14' }">
								<td align="center">신청 오류</td>
							</c:when>
							<c:when test="${list.STATUS eq 'EA14-' }">
								<td align="center">해지 오류</td>
							</c:when>
							<c:when test="${list.STATUS eq 'EA21' }">
								<td align="center">정상</td>
							</c:when>
							<c:when test="${list.STATUS eq 'EA13-' }">
								<td align="center">해지 신청중</td>
							</c:when>
							<c:when test="${list.STATUS eq 'EA13-e' }">
								<td align="center">해지 오류</td>
							</c:when>
							<c:when test="${list.STATUS eq 'EA99' }">
								<td align="center">정상 해지</td>
							</c:when>
							<c:when test="${list.STATUS eq 'XX' }">
								<td align="center">삭제</td>
							</c:when>
						</c:choose>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
		</table>