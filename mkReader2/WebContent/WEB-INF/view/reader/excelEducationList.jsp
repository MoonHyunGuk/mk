<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.util.*" %>
<%@ page import="com.mkreader.util.StringUtil" %>
<%@page import="com.mkreader.util.DateUtil"%>
<head>
<title>교육용 독자 리스트</title>
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
		<c:choose>
			<c:when test="${loginType eq 'A'}">
				<tr>
					<td align="center" height="20" colspan="16"><b>교육용 독자 리스트</b></td>
				</tr>
			</c:when>
			<c:otherwise>
				<tr>
					<td align="center" height="20" colspan="11"><b>교육용 독자 리스트</b></td>
				</tr>
			</c:otherwise>
		</c:choose>
	</table>
	<p style="top-margin:10px;">
	<table cellpadding=3 cellspacing=1 border=1 width=550 bgcolor=#fff>
		<tr class=bg_gray>
			<c:choose>
				<c:when test="${loginType eq 'A'}">
					<td><font class="b02">번호</font></td>
					<td><font class="b02">회사명</font></td>
					<td><font class="b02">회사번호</font></td>
					<td><font class="b02">독자명</font></td>
					<td><font class="b02">우편번호</font></td>
					<td><font class="b02">주소</font></td>
					<td><font class="b02">전화번호</font></td>
					<td><font class="b02">휴대폰</font></td>
					<td><font class="b02">지국명</font></td>
					<td><font class="b02">지국코드</font></td>
					<td><font class="b02">팀명</font></td>
					<td><font class="b02">신청일</font></td>
					<td><font class="b02">부수</font></td>
					<td><font class="b02">단가</font></td>
					<td><font class="b02">독자번호</font></td>
					<td><font class="b02">상태</font></td>
				</c:when>
				<c:otherwise>
					<td><font class="b02">회사명</font></td>
					<td><font class="b02">독자명</font></td>
					<td><font class="b02">우편번호</font></td>
					<td><font class="b02">주소</font></td>
					<td><font class="b02">전화번호</font></td>
					<td><font class="b02">휴대폰</font></td>
					<td><font class="b02">신청일</font></td>
					<td><font class="b02">부수</font></td>
					<td><font class="b02">단가</font></td>
					<td><font class="b02">독자번호</font></td>
					<td><font class="b02">상태</font></td>
				</c:otherwise>
			</c:choose>
		</tr>
		<c:choose>
			<c:when test="${(empty educationList) }">
				<c:choose>
					<c:when test="${loginType eq 'A'}">
						<tr>
							<td align="center" colspan="16">데이터가 없습니다.</td>
						</tr>
					</c:when>
					<c:otherwise>
						<tr>
							<td align="center" colspan="11">데이터가 없습니다.</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:otherwise>
				<c:forEach items="${educationList }" var="list">
					<tr bgcolor="ffffff">
						<c:choose>
							<c:when test="${loginType eq 'A'}">
								<td align="left" style='mso-number-format:"\@";'>${list.SEQ }</td>
								<td align="left">${list.COMPANY_TEMP}</td>
								<td align="left" style='mso-number-format:"\@";'>${list.COMPANYCD}</td>
								<td align="left">${list.READNM}</td>
								<td align="left">${fn:substring(list.DLVZIP,0,3)}-${fn:substring(list.DLVZIP,3,6)}</td>
								<td align="left">${list.DLVADRS1} ${list.DLVADRS2}</td>
								<td align="center">${list.HOMETEL1 }-${list.HOMETEL2 }-${list.HOMETEL3 }</td>
								<td align="center">${list.MOBILE1 }-${list.MOBILE2 }-${list.MOBILE3 }</td>
								<td align="left">${list.AGENTNM}</td>
								<td align="left">${list.BOSEQ}</td>
								<td align="left">${list.TEAMNM}</td>
								<td align="center">${list.HJDT }</td>
								<td align="center">${list.QTY }</td>
								<td align="center">${list.UPRICE }</td>
								<td align="center">${list.READNO }</td>
								<c:choose>
									<c:when test="${list.DELYN eq 'Y' }"><td><font style="color:#e74985;">해지</font></td></c:when>
									<c:otherwise><td>정상</td></c:otherwise>
								</c:choose>
							</c:when>
							<c:otherwise>
								<td align="left">${list.COMPANYNM}</td>
								<td align="left">${list.READNM}</td>
								<td align="left">${fn:substring(list.DLVZIP,0,3)}-${fn:substring(list.DLVZIP,3,6)}</td>
								<td align="left">${list.DLVADRS1} ${list.DLVADRS2}</td>
								<td align="center">${list.HOMETEL1 }-${list.HOMETEL2 }-${list.HOMETEL3 }</td>
								<td align="center">${list.MOBILE1 }-${list.MOBILE2 }-${list.MOBILE3 }</td>
								<td align="center">${list.HJDT }</td>
								<td align="center">${list.QTY }</td>
								<td align="center">${list.UPRICE }</td>
								<td align="center">${list.READNO }</td>
								<c:choose>
									<c:when test="${list.DELYN eq 'Y' }"><td><font style="color:#e74985;">해지</font></td></c:when>
									<c:otherwise><td>정상</td></c:otherwise>
								</c:choose>		
							</c:otherwise>
						</c:choose>
												
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
		</table>
		