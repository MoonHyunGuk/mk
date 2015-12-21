<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%

	//ContentType 를 선언합니다.
	response.setContentType("Application/x-msexcel");
	
	// 헤더값이 첨부파일을 선언합니다.
	response.setHeader("Content-Disposition", "attachment; filename=" + request.getParameter("fname") + ".xls");
	response.setHeader("Content-Description", "JSP Generated Data");
	
	/*
   Response.Buffer = TRUE
   Response.Charset = "euc-kr"
   Response.ContentType = "Application/x-msexcel"
   Response.CacheControl = "public"
   'ContentType 를 선언합니다.
   Response.AddHeader "Content-Disposition","attachment; filename=( " & fname & " ) 청구리스트" & ".xls"
   */
%>
<head>
<title>매일경제 CMS 데이터 관리 페이지</title>
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
	    <table cellpadding="0" cellspacing="1" width="900" bgcolor="#CCCCCC">
                <tr>
                    <td width="60" height="25" bgcolor="#3DABE9" align=center nowrap>
                        <font color="white">일련번호</font></span>
                    </td>
                    <!--td width="60" height="25" bgcolor="#3DABE9" align=center nowrap>
                        <font color="white">지국코드</font></span-->
					<td width="60" height="25" bgcolor="#3DABE9" align=center nowrap>
                        <font color="white">지국명</font></span>
                    </td>
                    <td width="80"  height="25" bgcolor="#3DABE9" align=center nowrap>
                        <font color="white">지국전화</font>
                    </td>
                    <td width="60"  height="25" bgcolor="#3DABE9" align=center nowrap>
                        <font color="white">독자번호</font>
                    </td>
					<td width="200" height="25" bgcolor="#3DABE9" align=center >
                        <font color="white">독자명</font>
                    </td>
					<td width="80" height="25" bgcolor="#3DABE9" align=center nowrap>
                        <font color="white">독자전화1</font>
                    </td>
					 <td width="80" height="25" bgcolor="#3DABE9" align=center nowrap>
                        <font color="white">독자전화2</font></td>

					<td width="300" height="25" bgcolor="#3DABE9" align=center nowrap>
                        <font color="white"> 독자주소</font>
                    </td>
					<td width="60" height="25" bgcolor="#3DABE9" align=center nowrap>
                        <font color="white"> 단가</font>
                    </td>

				</tr>
	<c:choose>
	<c:when test="${empty resultList}">		<!-- 정보가 없으면 -->
	<tr>
		<td colspan="9"  bgcolor="white" align="center" height=70>등록된 정보가 없습니다.</td>
	</tr>
	</c:when>
	<c:otherwise>
		<c:forEach items="${resultList}" var="list" varStatus="status">

                <tr  bgcolor="white" onMouseOver="this.style.backgroundColor='#e6e6e6'" onMouseOut="javascript:this.style.backgroundColor=''" >
                    <td  height="25">
                        <p align="center" style="margin-top:3px;"><span style="font-size:9pt;"><c:out value="${list.SERIALNO}" /></span></p>
                    </td>
				    <td align="left" height="25">
                        <p align="center" style="margin-top:px;"><c:out value="${list.JIKUK_NAME}" /></p>
                    </td>
				    <td align="left" height="25">
                        <p align="center" style="margin-top:px;"><c:out value="${list.JIKUK_TEL}" /></p>
                    </td>
					<td  height="25">
                        <p align="center" style="margin-top:px;"><c:out value="${list.SERIAL}" /></p>
                    </td>
					<td align="left" height="25">
                        <p align="center" style="margin-top:px;"><c:out value="${list.USERNAME}" /></p>
                    </td>
					<td align="left"  height="25">
                        <p align="center" style="margin-top:px;"><c:out value="${list.PHONE}" /></p>
                    </td>
					<td align="left" height="25">
					     <p align="center" style="margin-top:3px;"><span style="font-size:9pt;"><c:out value="${list.HANDY}" /></span></p>
                    </td>
					<td align="left" height="25">
                        <p align="center" style="margin-top:px;"><c:out value="${list.ADDR1}" />&nbsp;&nbsp;<c:out value="${list.ADDR2}" /></p>
                    </td>
					<td align="right" height="25">
                       <fmt:formatNumber value="${list.CMSMONEY}" pattern="\#,###.##" />
					</td>	
				</tr>
		</c:forEach>
	</c:otherwise>
	</c:choose>
  </table>
</body>