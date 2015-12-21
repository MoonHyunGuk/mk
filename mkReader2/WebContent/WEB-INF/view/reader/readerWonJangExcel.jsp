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
</style>
<% 
int size = (Integer)request.getAttribute("size");
String terms1 = (String)request.getAttribute("terms1");//명단 통계 구분
String terms2 = (String)request.getAttribute("terms2");//독자명 구분
String terms3 = (String)request.getAttribute("terms3");//중지독자포함
String terms4 = (String)request.getAttribute("terms4");//전화번호2 인쇄
String terms5 = (String)request.getAttribute("terms5");//비고인쇄
String nowYYMM = (String)request.getAttribute("nowYYMM");//사용 년월
String[] newsCd = (String[])request.getAttribute("newsCd");//뉴스코드
String[] newsNm = (String[])request.getAttribute("newsNm");//뉴스명

//통계 합계용 변수
int qty = 0;
int one = 0;
int two = 0;
int three = 0;
int four = 0;
int five = 0;
int six = 0;
int etc = 0;
int stu1 = 0;
int stu2 = 0;
int don = 0;
int pub = 0;
int edu = 0;
int firstSgbbMm = 0;
int halfYy = 0;
int oneYy = 0;
int twoYy = 0;
int threeYy = 0;
int fourYy = 0;
int fiveYy = 0;
int sixYy = 0;

for(int i=0 ; i < size ; i++){
	List printReaderList = (List)request.getAttribute("printReaderList"+i);
	String gno = (String)request.getAttribute("gno"+i);//구역번호
%>
	<br/>
	
	월분 : <%=nowYYMM.substring(0,4)%>-<%=nowYYMM.substring(4,6)%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	구역 : (<%= gno %>)<%= gno %>구역&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	출력일자 : <%=DateUtil.getCurrentDate("YYYYMMdd").substring(0,4) %>-<%=DateUtil.getCurrentDate("YYYYMMdd").substring(4,6) %>-<%=DateUtil.getCurrentDate("YYYYMMdd").substring(6,8) %>
	<table cellpadding=3 cellspacing=1 border=1 width=550 bgcolor=#fff>
		<tr class=bg_gray>
			<th>독자번호</th>
			<th>독자주소</th>
		<%if(terms2 != null && !"".equals(terms2)  ){ %>
			<th>독자명</th>
		<%} %>
		<%if(terms4 != null && !"".equals(terms4)  ){ %>
			<th>휴대전화</th>
		<%} %>
			<th>단가</th>
			<th>구독수금</th>
			<th>수금사항</th>
			<th>확장유가부수</th>
			<th>확장자</th>
			<th>전화번호</th>
		<%if(terms5 != null && !"".equals(terms5)  ){ %>
			<th>비고</th>
		<%} %>
		</tr>
		
		<%if(printReaderList.size() > 0 ){	 
			int col = 8;
			if(terms2 != null && !"".equals(terms2)  ){
				col ++;
			}
			if(terms4 != null && !"".equals(terms4)  ){
				col ++;
			}
			if(terms5 != null && !"".equals(terms5)  ){
				col ++;
			}
			for(int j=0 ; j < printReaderList.size() ; j++){
					 Map list = (Map)printReaderList.get(j);
			%>
				 
					<!-- @게시물 한 줄  ::  START -->
					<%if(!"999".equals(list.get("BNO"))){ %>
						<tr>
							<th><%= StringUtil.notNull(list.get("READERNO"))  %></th>
							<th><%=StringUtil.notNull(list.get("DLVADRS2")) %></th>
						<%if(terms2 != null && !"".equals(terms2)  ){ %>
							<th><%=StringUtil.notNull(list.get("READNM")) %></th>
						<%} %>
						<%if(terms4 != null && !"".equals(terms4)  ){ %>
							<th><%=StringUtil.notNull(list.get("MOBILE")) %></th>
						<%} %>
							<th><%=StringUtil.notNull(list.get("PRICE")) %></th>
							<th><%=StringUtil.notNull(list.get("SGTYPE")) %></th>
							<th><%=StringUtil.notNull(list.get("CLAMLIST")) %></th>
							<th><%=StringUtil.notNull(list.get("SGBGMM")) %></th>
							<th><%=StringUtil.notNull(list.get("HJPSNM")) %></th>
							<th><%=StringUtil.notNull(list.get("HOMETEL")) %></th>
						<%if(terms5 != null && !"".equals(terms5)  ){ %>
							<th><%=StringUtil.notNull(list.get("REMK")) %></th>
						<%} %>
						</tr>
					<%}else{ %>
						<tr>
							<th><font color="red"><%= StringUtil.notNull(list.get("READERNO"))  %></font></th>
							<th><font color="red"><%=StringUtil.notNull(list.get("DLVADRS2")) %></font></th>
						<%if(terms2 != null && !"".equals(terms2)  ){ %>
							<th><font color="red"><%=StringUtil.notNull(list.get("READNM")) %></font></th>
						<%} %>
						<%if(terms4 != null && !"".equals(terms4)  ){ %>
							<th><font color="red"><%=StringUtil.notNull(list.get("MOBILE")) %></font></th>
						<%} %>
							<th><font color="red"><%=StringUtil.notNull(list.get("PRICE")) %></font></th>
							<th><font color="red"><%=StringUtil.notNull(list.get("SGTYPE")) %></font></th>
							<th><font color="red"><%=StringUtil.notNull(list.get("CLAMLIST")) %></font></th>
							<th><font color="red"><%=StringUtil.notNull(list.get("SGBGMM")) %></font></th>
							<th><font color="red"><%=StringUtil.notNull(list.get("HJPSNM")) %></font></th>
							<th><font color="red"><%=StringUtil.notNull(list.get("HOMETEL")) %></font></th>
						<%if(terms5 != null && !"".equals(terms5)  ){ %>
							<th><font color="red"><%=StringUtil.notNull(list.get("REMK")) %></font></th>
						<%} %>
						</tr>
					<%} %>
			<%} %>
				</table>
		<%}else{ 
			int col = 8;
			if(terms2 != null && !"".equals(terms2)  ){
				col ++;
			}
			if(terms4 != null && !"".equals(terms4)  ){
				col ++;
			}
			if(terms5 != null && !"".equals(terms5)  ){
				col ++;
			}
		%>
			<tr>
				<td colspan=<%=col %>> 
					데이터가 없습니다.
				</td>
			</tr>
		</table>
		<%} %>
		<%
		if(terms1 != null && !"".equals(terms1)  ){ %>
			구역 : (<%= gno %>)<%= gno %>구역&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			작업일자 : <%=DateUtil.getCurrentDate("YYYYMMdd").substring(0,4) %>-<%=DateUtil.getCurrentDate("YYYYMMdd").substring(4,6) %>-<%=DateUtil.getCurrentDate("YYYYMMdd").substring(6,8) %>
			<table cellpadding=3 cellspacing=1 border=1 width=550 bgcolor=#fff>
				<tr class=bg_gray>
					<td rowspan="2">지명</td>
					<td rowspan="2">유가부수</td>
					<td colspan="8">준유가부수</td>
					<td colspan="4">무가부수</td>
					<td rowspan="2">배부</td>
					<td rowspan="2">첫수</td>
					<td colspan="7">구독기간별통계(범위:이하)</td>
				</tr>
				<tr class=bg_gray>
					<td><%=DateUtil.getWantDay(nowYYMM+"01", 2, 1 ).substring(4, 6) %></td>
					<td><%=DateUtil.getWantDay(nowYYMM+"01", 2, 2 ).substring(4, 6) %></td>
					<td><%=DateUtil.getWantDay(nowYYMM+"01", 2, 3 ).substring(4, 6) %></td>
					<td><%=DateUtil.getWantDay(nowYYMM+"01", 2, 4 ).substring(4, 6) %></td>
					<td><%=DateUtil.getWantDay(nowYYMM+"01", 2, 5 ).substring(4, 6) %></td>
					<td><%=DateUtil.getWantDay(nowYYMM+"01", 2, 6 ).substring(4, 6) %></td>
					<td>이후</td>
					<td>계</td>
					<td>학생</td>
					<td>기증</td>
					<td>홍보</td>
					<td>교육</td>
					<td>6월</td>
					<td>1년</td>
					<td>2년</td>
					<td>3년</td>
					<td>4년</td>
					<td>5년</td>
					<td>이상</td>
				</tr>
			<%for(int j=0 ; newsCd[j] != null && j < newsCd.length ; j++){

				List statistics = (List)request.getAttribute("statistics"+(i+1)+j);
				if((statistics == null || statistics.size() == 0) && !"".equals(StringUtil.notNull(newsCd[j])) ){ %>
					<tr>
						<td><%=newsNm[j] %></td>
						<td>0</td>
						<td>0</td>
						<td>0</td>
						<td>0</td>
						<td>0</td>
						<td>0</td>
						<td>0</td>
						<td>0</td>
						<td>0</td>
						<td>0</td>
						<td>0</td>
						<td>0</td>
						<td>0</td>
						<td>0</td>
						<td>0</td>
						<td>0</td>
						<td>0</td>
						<td>0</td>
						<td>0</td>
						<td>0</td>
						<td>0</td>
						<td>0</td>
					</tr>
				<%}
				for(int k=0 ; k < statistics.size() ; k++ ){
					Map list = (Map) statistics.get(k);
					qty = qty + Integer.parseInt(StringUtil.notNullToZero(list.get("QTY")));
					one = one + Integer.parseInt(StringUtil.notNullToZero(list.get("ONE")));
					two = two + Integer.parseInt(StringUtil.notNullToZero(list.get("TWO")));
					three = three + Integer.parseInt(StringUtil.notNullToZero(list.get("THREE")));
					four = four + Integer.parseInt(StringUtil.notNullToZero(list.get("FOUR")));
					five = five + Integer.parseInt(StringUtil.notNullToZero(list.get("FIVE")));
					six = six + Integer.parseInt(StringUtil.notNullToZero(list.get("SIX")));
					etc = etc + Integer.parseInt(StringUtil.notNullToZero(list.get("ETC")));
					stu1 = stu1 + Integer.parseInt(StringUtil.notNullToZero(list.get("STU1")));
					stu2 = stu2 + Integer.parseInt(StringUtil.notNullToZero(list.get("STU2")));
					don = don + Integer.parseInt(StringUtil.notNullToZero(list.get("DON")));
					pub = pub + Integer.parseInt(StringUtil.notNullToZero(list.get("PUB")));
					edu = edu + Integer.parseInt(StringUtil.notNullToZero(list.get("EDU")));
					firstSgbbMm = firstSgbbMm + Integer.parseInt(StringUtil.notNullToZero(list.get("FIRSTSGBBMM")));
					halfYy = halfYy + Integer.parseInt(StringUtil.notNullToZero(list.get("HALFYY")));
					oneYy = oneYy + Integer.parseInt(StringUtil.notNullToZero(list.get("ONEYY")));
					twoYy = twoYy + Integer.parseInt(StringUtil.notNullToZero(list.get("TWOYY")));
					threeYy = threeYy + Integer.parseInt(StringUtil.notNullToZero(list.get("THREEYY")));
					fourYy = fourYy + Integer.parseInt(StringUtil.notNullToZero(list.get("FOURYY")));
					fiveYy = fiveYy + Integer.parseInt(StringUtil.notNullToZero(list.get("FIVEYY")));
					sixYy = sixYy + Integer.parseInt(StringUtil.notNullToZero(list.get("SIXYY")));
					int tmp_qty = Integer.parseInt(StringUtil.notNullToZero(list.get("QTY")));
					int tmp_one = Integer.parseInt(StringUtil.notNullToZero(list.get("ONE")));
					int tmp_two = Integer.parseInt(StringUtil.notNullToZero(list.get("TWO")));
					int tmp_three = Integer.parseInt(StringUtil.notNullToZero(list.get("THREE")));
					int tmp_four = Integer.parseInt(StringUtil.notNullToZero(list.get("FOUR")));
					int tmp_five = Integer.parseInt(StringUtil.notNullToZero(list.get("FIVE")));
					int tmp_six = Integer.parseInt(StringUtil.notNullToZero(list.get("SIX")));
					int tmp_etc = Integer.parseInt(StringUtil.notNullToZero(list.get("ETC")));
					%>
					<tr>
						<td><%=newsNm[j] %></td>
						<td><%=StringUtil.notNullToZero(list.get("QTY") )%></td>
						<td><%=StringUtil.notNullToZero(list.get("ONE") )%></td>
						<td><%=StringUtil.notNullToZero(list.get("TWO") )%></td>
						<td><%=StringUtil.notNullToZero(list.get("THREE") )%></td>
						<td><%=StringUtil.notNullToZero(list.get("FOUR") )%></td>
						<td><%=StringUtil.notNullToZero(list.get("FIVE") )%></td>
						<td><%=StringUtil.notNullToZero(list.get("SIX") )%></td>
						<td><%=StringUtil.notNullToZero(list.get("ETC") )%></td>
						<td><%=tmp_one + tmp_two + tmp_three + tmp_four + tmp_five + tmp_six + tmp_etc %></td>
						<td><%=Integer.parseInt( StringUtil.notNullToZero( String.valueOf(list.get("STU1"))  ) ) + Integer.parseInt( StringUtil.notNullToZero( String.valueOf(list.get("STU2"))  ) )%></td>
						<td><%=StringUtil.notNullToZero(list.get("DON") )%></td>
						<td><%=StringUtil.notNullToZero(list.get("PUB") )%></td>
						<td><%=StringUtil.notNullToZero(list.get("EDU") )%></td>
						<td><%=tmp_qty + tmp_one + tmp_two + tmp_three + tmp_four + tmp_five + tmp_six + tmp_etc %></td>
						<td><%=StringUtil.notNullToZero(list.get("FIRSTSGBBMM") )%></td>
						<td><%=StringUtil.notNullToZero(list.get("HALFYY") )%></td>
						<td><%=StringUtil.notNullToZero(list.get("ONEYY") )%></td>
						<td><%=StringUtil.notNullToZero(list.get("TWOYY") )%></td>
						<td><%=StringUtil.notNullToZero(list.get("THREEYY") )%></td>
						<td><%=StringUtil.notNullToZero(list.get("FOURYY") )%></td>
						<td><%=StringUtil.notNullToZero(list.get("FIVEYY") )%></td>
						<td><%=StringUtil.notNullToZero(list.get("SIXYY") )%></td>
					</tr>
				
				<%}%>
			<%}%>
				<tr>
					<td>합계</td>
					<td><%=qty %></td>
					<td><%=one %></td>
					<td><%=two %></td>
					<td><%=three %></td>
					<td><%=four %></td>
					<td><%=five %></td>
					<td><%=six %></td>
					<td><%=etc %></td>
					<td><%=one+two+three+four+five+six+etc %></td>
					<td><%=stu1+stu2 %></td>
					<td><%=don %></td>
					<td><%=pub %></td>
					<td><%=edu %></td>
					<td><%=qty+one+two+three+four+five+six+etc %></td>
					<td><%=firstSgbbMm %></td>
					<td><%=halfYy %></td>
					<td><%=oneYy %></td>
					<td><%=twoYy %></td>
					<td><%=threeYy %></td>
					<td><%=fourYy %></td>
					<td><%=fiveYy %></td>
					<td><%=sixYy %></td>
				</tr>
			</table>
		<%}
		//통계 합계용 변수 초기화
		qty = 0;
		one = 0;
		two = 0;
		three = 0;
		four = 0;
		five = 0;
		six = 0;
		etc = 0;
		stu1 = 0;
		stu2 = 0;
		don = 0;
		pub = 0;
		edu = 0;
		firstSgbbMm = 0;
		halfYy = 0;
		oneYy = 0;
		twoYy = 0;
		threeYy = 0;
		fourYy = 0;
		fiveYy = 0;
		sixYy = 0;

		
		 %>
<%} %>


	
	
