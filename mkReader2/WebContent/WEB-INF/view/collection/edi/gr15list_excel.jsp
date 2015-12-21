<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<head>
<title>매일경제 EDI 데이터 관리 페이지</title>
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
		 background-color: #FFFFFF; 
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
</style>
</head>
<script type="text/javascript" src="/js/common.js"></script>
<body>
	<div align='center'><font size='3' color='blue'>매경 자료 출력</font></div>
       기간 <c:out value="${sdate}" /> ~ <c:out value="${edate}" />
       <br>
       <center>

		<!-- 게시판 테이블 :: START -->
		<table cellpadding=3 cellspacing=1 border=1 width=550 bgcolor=#fff>
			<tr class=bg_gray>
				<th>지로번호</th>
				<th>지국코드</th>
				<th>지국명</th>
				<th>건수</th>
				<th>지로입금액</th>
				<th>수수료</th>
				<th>이체금액</th>
			</tr>
			
			<!-- @게시물 한 줄  ::  START -->
			<c:choose>
			<c:when test="${empty resultList}">
				<tr><td height="25" colspan="6" align="center">등록된 정보가 없습니다.</td></tr>
			</c:when>
			<c:otherwise>
				<c:set var="count1" value="0" />
				<c:set var="money1" value="0" />
				<c:set var="charge1" value="0" />
				<c:set var="echemoney1" value="0" />
				
				<c:forEach items="${resultList}" var="list" varStatus="status">
				
					<c:set var="count1" value="${count1 + list.COUNT}" />
					<c:set var="money1" value="${money1 + list.MONEY}" />
					<c:set var="charge1" value="${charge1 + list.CHARGE}" />
					<c:set var="echemoney1" value="${echemoney1 + list.MONEY - list.CHARGE}" />
					
					<tr>
	                    <td><c:out value="${list.E_JIRO}" /></td>
	                    <td><c:out value="${list.E_JCODE}" /></td>
					    <td><c:out value="${list.NAME}" /></td>
						<td>
							<c:choose>
							<c:when test="${not empty list.COUNT}"><c:out value="${list.COUNT}" /></c:when>
							<c:otherwise>0</c:otherwise>
							</c:choose>
						</td>
						<td align="right">
							<c:choose>
							<c:when test="${not empty list.MONEY}"><c:out value="${list.MONEY}" /></c:when>
							<c:otherwise>0</c:otherwise>
							</c:choose>
						</td>
						<td align="right">
							<c:choose>
							<c:when test="${not empty list.CHARGE}"><c:out value="${list.CHARGE}" /></c:when>
							<c:otherwise>0</c:otherwise>
							</c:choose>
						</td>
						<td align="right">
							<c:choose>
							<c:when test="${not empty list.MONEY && not empty list.CHARGE}"><c:out value="${list.MONEY - list.CHARGE}" /></c:when>
							<c:otherwise>0</c:otherwise>
							</c:choose>
						</td>
					</tr>
				</c:forEach>
				
				<tr bgcolor="ffffff" align="center" onMouseOver=this.style.backgroundColor='#eeeebb' onMouseOut=this.style.backgroundColor=''>
					<td></td>
					<td></td>
					<td>오류 계</td>
					<td>
						<c:choose>
						<c:when test="${not empty errcount}"><c:out value="${errcount}" /></c:when>
						<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
					<td align="right">
						<c:choose>
						<c:when test="${not empty summoney}"><c:out value="${summoney}" /></c:when>
						<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
					<td align="right">
						<c:choose>
						<c:when test="${not empty sumcharge}"><c:out value="${sumcharge}" /></c:when>
						<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
					<td align="right">
						<c:choose>
						<c:when test="${not empty summ}"><c:out value="${summ}" /></c:when>
						<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
				</tr>
				
				<c:set var="count1" value="${count1 + errcount}" />
				<c:set var="money1" value="${money1 + summoney}" />
				<c:set var="charge1" value="${charge1 + sumcharge}" />
				<c:set var="echemoney1" value="${echemoney1 + summ}" />
				
				<tr bgcolor="ffffff" align="center" onMouseOver=this.style.backgroundColor='#eeeebb' onMouseOut=this.style.backgroundColor=''>
					<td></td>
					<td></td>
					<td>총 계</td>
					<td>
						<c:choose>
						<c:when test="${not empty count1}"><c:out value="${count1}" /></c:when>
						<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
					<td align="right">
						<c:choose>
						<c:when test="${not empty money1}"><c:out value="${money1}" /></c:when>
						<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
					<td align="right">
						<c:choose>
						<c:when test="${not empty charge1}"><c:out value="${charge1}" /></c:when>
						<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
					<td align="right">
						<c:choose>
						<c:when test="${not empty echemoney1}"><c:out value="${echemoney1}" /></c:when>
						<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
				</tr>
			</c:otherwise>
			</c:choose>

			<!-- @//게시물 한 줄  ::  E N D -->

		</table>
		<!-- 게시판 테이블 :: END -->

	<!-- content :: END-->	
</body>