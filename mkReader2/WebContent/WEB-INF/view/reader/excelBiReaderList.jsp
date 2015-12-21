<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.util.*" %>
<%@ page import="com.mkreader.util.StringUtil" %>
<%@page import="com.mkreader.util.DateUtil"%>
<head>
<title>비독자 리스트</title>
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
			<td align="center" height="35" colspan="20"><font size="5"><b>비독자 리스트</b></font></td>
		</tr>
	</table>
	<p style="margin-top:5px;">
	<table cellpadding=3 cellspacing=1 border=1 width=550 bgcolor=#fff>
		<tr class=bg_gray>
			<td  align="center"><font class="b02"><b>등록일자</b></font></td>
			<td  align="center"><font class="b02"><b>그룹1</b></font></td>
			<td  align="center"><font class="b02"><b>그룹2</b></font></td>
			<td  align="center"><font class="b02"><b>그룹3</b></font></td>
			<td  align="center"><font class="b02"><b>성명</b></font></td>
			<td  align="center"><font class="b02"><b>직장우편번호</b></font></td>
			<td  align="center"><font class="b02"><b>직장주소</b></font></td>
			<td  align="center"><font class="b02"><b>소속기관</b></font></td>
			<td  align="center"><font class="b02"><b>직책</b></font></td>
			<td  align="center"><font class="b02"><b>부서</b></font></td>
			<td  align="center"><font class="b02"><b>직장전화</b></font></td>
			<td  align="center"><font class="b02"><b>팩스</b></font></td>
			<td  align="center"><font class="b02"><b>휴대폰</b></font></td>
			<td  align="center"><font class="b02"><b>이메일</b></font></td>
			<td  align="center"><font class="b02"><b>자택우편번호</b></font></td>
			<td  align="center"><font class="b02"><b>자택주소</b></font></td>
			<td  align="center"><font class="b02"><b>자택전화</b></font></td>
			<td  align="center"><font class="b02"><b>비독자구분(중요도)</b></font></td>
			<td  align="center"><font class="b02"><b>구독여부</b></font></td>
			<td  align="center"><font class="b02"><b>비고</b></font></td>
		</tr>
		<c:choose>
			<c:when test="${(empty biReaderList) }">
				<tr>
					<td align="center" colspan="20">
						데이터가 없습니다.
					</td>
				</tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${biReaderList}" var="list">
					<tr>
						<Td align="center">${list.APLCDT}</Td>
						<Td align="left">${list.BI_GROUP_NM1}</Td>
						<Td align="left">${list.BI_GROUP_NM2}</Td>
						<Td align="left">${list.BI_GROUP_NM3}</Td>
						<Td align="left">${list.BI_READNM}</Td>
						<Td align="center">${list.OFFZIP}</Td>
						<Td align="left">${list.OFFADRS1} ${list.OFFADRS2}</Td>
						<Td align="left">${list.ORGAN}</Td>
						<Td align="left">${list.OFFDUTY}</Td>
						<Td align="left">${list.OFFDEPT}</Td>
						
						<c:if test="${!empty list.OFFTEL2}">
			                <td style="text-align:left;"><c:out value="${list.OFFTEL1}"/>-<c:out value="${list.OFFTEL2}"/>-<c:out value="${list.OFFTEL3}"/></td>
			            </c:if>
			            <c:if test="${empty list.OFFTEL2}">
			            	<td style="text-align:left;"></td>
			            </c:if>

						<c:if test="${!empty list.OFFFAX2}">
			                <td style="text-align:left;"><c:out value="${list.OFFFAX1}"/>-<c:out value="${list.OFFFAX2}"/>-<c:out value="${list.OFFFAX3}"/></td>
			            </c:if>
			            <c:if test="${empty list.OFFFAX2}">
			            	<td style="text-align:left;"></td>
			            </c:if>
			            
						<c:if test="${!empty list.MOBILE2}">
			                <td style="text-align:left;"><c:out value="${list.MOBILE1}"/>-<c:out value="${list.MOBILE2}"/>-<c:out value="${list.MOBILE3}"/></td>
			            </c:if>
			            <c:if test="${empty list.MOBILE2}">
			            	<td style="text-align:left;"></td>
			            </c:if>
			            
						<Td align="left">${list.EMAIL}</Td>
						<Td align="center">${list.HOMEZIP}</Td>
						<Td align="left">${list.HOMEADRS1} ${list.HOMEADRS2}</Td>

						<c:if test="${!empty list.HOMETEL2}">
			                <Td style="text-align:left;"><c:out value="${list.HOMETEL1}"/>-<c:out value="${list.HOMETEL2}"/>-<c:out value="${list.HOMETEL3}"/></td>
			            </c:if>
			            <c:if test="${empty list.HOMETEL2}">
			            	<Td style="text-align:left;"></td>
			            </c:if>
			            
						<Td align="center">${list.GUBUN}</Td>
						<Td align="center">${list.SMGUDOK}</Td>
						<Td align="center">${list.REMK}</Td>
					</tr>
				</c:forEach>
				
			</c:otherwise>
		</c:choose>
		</table>
		