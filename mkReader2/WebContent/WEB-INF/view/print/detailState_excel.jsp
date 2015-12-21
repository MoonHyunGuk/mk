<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<head>
<title>매일경제 CMS 입금내역현황</title>
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
<script type="text/javascript" src="/js/common.js"></script>
<body>

		<!-- 게시판 테이블 :: START -->
		<table cellpadding=3 cellspacing=1 border=1 width=550 bgcolor=#fff>
			<tr class=bg_gray>
				<th>독자번호</th>
			    <th>독자명</th>
			    <th>주소</th>
			    <th>매체</th>
			    <th>월분</th>
			    <th>방법</th>
			    <th>수량</th>
			    <th>금액</th>
			    <th>입금일자</th>
			    <th>수금사항</th>
			</tr>
			
			<!-- 합계 변수지정start:: -->
			<c:set var="BILLQTY" value="0" />					<!-- 건수 합계 -->
			<c:set var="AMT" value="0" />						<!-- 금액 합계 -->
			
			<c:set var="BILLQTY_GNO" value="0" />				<!-- 건수 합계 -->
			<c:set var="AMT_GNO" value="0" />					<!-- 금액 합계 -->
			
			<!-- 합계 변수지정end:: -->
			
			<!-- @게시물 한 줄  ::  START -->
			<c:forEach items="${resultList}" var="list" varStatus="status">
				<tr>
                    <!-- 독자번호 -->
					<td>
						<c:out value="${list.READNO}" />
				    </td>
				    <!-- 독자명 -->
				    <td>
						<c:out value="${list.READNM}" />
				    </td>
				    <!-- 주소 -->
				    <td>
						<c:out value="${list.ADDR}" />
				    </td>
				    <!-- 매체 -->
				    <td>
						<c:out value="${list.NEWSCD_YNAME}" />
				    </td>
				    <!-- 월분 -->
				    <td>
						<c:out value="${list.YYMMSTR}" />
				    </td>
				    <!-- 방법 -->
				    <td>
						<c:out value="${list.SGBBCD_YNAME}" />
				    </td>
				    <!-- 수량 -->
				    <td>
				    	<c:out value="${list.BILLQTY}" />
				    </td>
				    <!-- 금액 -->
				    <td>
				    	<c:out value="${list.AMT}" />
				    </td>
				    <!-- 입금일자 -->
				    <td>
						<c:out value="${list.CLDT}" />
				    </td>
				    <!-- 수금사항 -->
				    <td>
						<c:out value="${list.THISYEARHISTORY}" />
				    </td>
				</tr>
				
				<c:set var="BILLQTY" value="${BILLQTY + list.BILLQTY}" />			<!-- 건수 합계 -->
				<c:set var="AMT" value="${AMT + list.AMT}" />						<!-- 금액 합계 -->
				<c:set var="BILLQTY_GNO" value="${BILLQTY_GNO + list.BILLQTY}" />	<!-- 건수 합계 -->
				<c:set var="AMT_GNO" value="${AMT_GNO + list.AMT}" />				<!-- 금액 합계 -->
				
				<c:if test="${(list.GNO ne resultList[status.index+1].GNO) or status.last}">
					<tr bgcolor="ffcccc">
						<td colspan="10">
							&nbsp; [${list.GNO}]구역 &nbsp; 수량 : ${BILLQTY_GNO} &nbsp; 금 &nbsp; 액 : <fmt:formatNumber value="${AMT_GNO}"  type="number" />
						</td>
					</tr>
					<c:set var="BILLQTY_GNO" value="0" />				<!-- 건수 합계 -->
					<c:set var="AMT_GNO" value="0" />					<!-- 금액 합계 -->
				</c:if>
				
			</c:forEach>
		
			<c:if test="${empty resultList}">
				<tr><td height="25" colspan="10" align="center">검색결과가 없습니다.</td></tr>
			</c:if>
			
			<tr bgcolor="ccdbfb">
			    <td align="center"><strong>합 &nbsp; 계</strong></td>
			    <!-- 독자명 -->
			    <td align="center">&nbsp;</td>
			    <!-- 주소 -->
			    <td align="center">&nbsp;</td>
			    <!-- 매체 -->
			    <td align="center">&nbsp;</td>
			    <!-- 월분 -->
			    <td align="center">&nbsp;</td>
			    <!-- 방법 -->
			    <td align="center">&nbsp;</td>
			    <!-- 수량 -->
			    <td align="center">
			    	<c:out value="${BILLQTY}" />
			    </td>
			    <!-- 금액 -->
			    <td align="right">
			    	<c:out value="${AMT}" />
			    </td>
			    <!-- 입금일자 -->
			    <td align="center">&nbsp;</td>
			    <!-- 수금사항 -->
			    <td align="center">&nbsp;</td>
		  </tr>
			<!-- @//게시물 한 줄  ::  E N D -->

		</table>
		<!-- 게시판 테이블 :: END -->

	<!-- content :: END-->	
</body>
