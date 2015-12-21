<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
 <%
	String _User_Agent = (request.getHeader("User-Agent")).toUpperCase();
	String _SCALE = "1.0";
	
	if((_User_Agent.indexOf("MOBILE") > 0) || (_User_Agent.indexOf("LGTELECOM") > 0)) {
	 _SCALE = "1.0";
	} else if(_User_Agent.indexOf("SAMSUNG") > 0) {
	_SCALE = "0.8";
	} 
	
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<meta name="viewport" content="width=device-width; initial-scale=<%=_SCALE %>; maximum-scale=3.0; minimum-scale=1.0; user-scalable=yes;">
<title>매일경제 지대통지서</title>
<style type="text/css">
body,input,textarea,select,table,button{font-size:0.6em;line-height:1.25em;font-family: Dotum,Helvetica,AppleGothic,Sans-serif}

.tb_edit_mobile {margin:0 auto; text-align:center; border-collapse:collapse; font:normal 1.0em Gulim, "굴림", Verdana, Geneva; }
.tb_edit_mobile th, .tb_edit_mobile td {padding:4px 1px; }
.tb_edit_mobile th {text-align:center; border:1px solid #c0c0c0; background-color: #eeeeee; font-weight: bold;}
.tb_edit_mobile td {text-align:center; border:1px solid #c0c0c0; background-color: #fff; }
</style>
</head>
<body>
<div style="width: 100%; padding-top: 5px">
	<div style="float: left; width: 17%;"><img alt="매일경제" src="/images/ico_ci_mk.jpg" style="width: 48px"></div>
	<div style="float: left; width: 83%; background-color: #f36f21; height: 38px;"></div>
</div>
<div style="clear: both; width: 98%; margin: 0 auto; padding-top: 10px; padding-bottom: 10px; border-left: 3px solid #f36f21; border-right: 3px solid #f36f21; border-bottom: 3px solid #f36f21; ">
	<div style="width: 95%; margin: 0 auto;">
		<div style="font-weight: bold; font-size: 1.4em; padding-bottom: 5px; text-align: center; overflow: hidden;">[지대납부금통지서]</div>
		<div style="font-weight: bold; font-size: 1.4em; padding: 3px 0px; overflow: hidden;">${fn:substring(yymm, 0, 4)}년 ${fn:substring(yymm, 4, 6)}월분</div>
		<table class="tb_edit_mobile" style="width: 100%">
			<colgroup>
				<col width="18%">
				<col width="32%">
				<col width="18%">
				<col width="32%">
			</colgroup>
			<tr>
				<th>지 국 명</th>
				<td>${jidaeData.BOSEQNM}</td>
				<th>코드번호</th>
				<td>${jidaeData.BOSEQCODE}</td>
			</tr>
			<tr>
				<th>소&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;속</th>
				<td>수도권1팀</td>
				<th>지국장명</th>
				<td>${jidaeData.AGENCYNM}</td>
			</tr>
		</table>
		<!-- 지대내역 -->
		<div style="padding-top: 10px;">
			<div style="font-weight: bold; font-size: 1.4em; padding-bottom: 3px">1. 지대내역</div>
			<table class="tb_edit_mobile" style="width: 100%">
				<colgroup>
					<col width="25%">
					<col width="25%">
					<col width="25%">
					<col width="25%">
				</colgroup>
				<tr>
					<th>구&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;분</th>
					<th>금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</th>
					<th>구&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;분</th>
					<th>금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</th>
				</tr>
				<tr>
					<th>전월이월액</th>
					<td><fmt:formatNumber value="${jidaeData.MISU}" pattern="#,###" /></td>
					<th>당월조정액</th>
					<td style="font-weight: bold;"><fmt:formatNumber value="${jidaeData.CUSTOM}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th colspan="4">본사 입금 현황</th>
				</tr>
				<tr>
					<th>배달장려금</th>
					<td><fmt:formatNumber value="${jidaeData.ETCGRANT}" pattern="#,###" /></td> 
					<th>통 장</th>
					<td><fmt:formatNumber value="${jidaeData.BANK}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th>교 육 용</th>
					<td><fmt:formatNumber value="${jidaeData.EDU}" pattern="#,###" /></td>
					<th>지 로</th>
					<td><fmt:formatNumber value="${jidaeData.GIRO}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th>카 드</th>
					<td><fmt:formatNumber value="${jidaeData.CARD}" pattern="#,###" /></td>
					<th></th>
					<td></td>
				</tr>
				<tr> 
					<th>자동이체</th>
					<td><fmt:formatNumber value="${jidaeData.AUTOBILL}" pattern="#,###" /></td>
					<th></th>
					<td></td>
				</tr>
				<tr> 
					<th>학생배달</th>
					<td><fmt:formatNumber value="${jidaeData.STU}" pattern="#,###" /></td>
					<th></th>
					<td></td> 
				</tr>
				<tr> 
					<th>소외계층,NIE</th>
					<td><fmt:formatNumber value="${jidaeData.TMP1}" pattern="#,###" /></td>
					<th>판매수수료(VAT)</th>
					<td><fmt:formatNumber value="${jidaeData.TMP6}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th>본사사원</th>
					<td><fmt:formatNumber value="${jidaeData.TMP3}" pattern="#,###" /></td>
					<th>소계</th>
					<td style="font-weight: bold; color: blue;"><fmt:formatNumber value="${jidaeData.ETCGRANT+jidaeData.BANK+jidaeData.EDU+jidaeData.GIRO+jidaeData.CARD+jidaeData.AUTOBILL+jidaeData.STU+jidaeData.TMP1+jidaeData.TMP6+jidaeData.TMP3}" pattern="#,###" /></td>
				</tr>
			</table>
		</div>
		<!-- //지대내역 -->
		<!-- 당월지대납부내역 -->
		<div style="padding-top: 10px;">
			<div style="font-weight: bold; font-size: 1.4em; padding-bottom: 3px">2. 당월 지대 납부내역</div>
			<table class="tb_edit_mobile" style="width: 100%">
				<colgroup>
					<col width="25%">
					<col width="25%">
					<col width="25%">
					<col width="25%">
				</colgroup>
				<tr>
					<th>항&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</th>
					<th>금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</th>
					<th>항&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</th>
					<th>금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</th>
				</tr>
				<tr>
					<th>당월지대납입액</th>
					<td  style="font-weight: bold; color: #bc0546"><fmt:formatNumber value="${jidaeData.J_REALAMT}" pattern="#,###" /></td>
					<th></th>
					<td></td> 
				</tr>
			</table>
		</div>
		<!-- //당월지대납부내역 -->
		<!-- 보증금 현황 -->
		<div style="padding-top: 10px;">
			<div style="font-weight: bold; font-size: 1.4em; padding-bottom: 3px">3. 기타</div>
			<table class="tb_edit_mobile" style="width: 100%">
				<colgroup>
					<col width="25%">
					<col width="25%">
					<col width="25%">
					<col width="25%">
				</colgroup>
				<tr>
					<th>항&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</th>
					<th>이 코 노 미</th>
					<th>씨&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;티</th>
					<th>&nbsp;</th>
				</tr>
				<tr>
					<th style="height: 15px">금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</th>
					<td><fmt:formatNumber value="${jidaeData.ECONOMY}" pattern="#,###" /></td>
					<td><fmt:formatNumber value="${jidaeData.CITY}" pattern="#,###" /></td>
					<td></td>
				</tr>
			</table>
		</div>
		<!-- //보증금 현황 -->
		<div style="width: 100%; text-align: center; padding-top: 5px; font-size: 1.1em">
			<div>상기 금액을 조정 통지하오니 상위할 경우 이의 신청하여 주시기 바랍니다.</div>
			<div style="padding-top: 5px">서울특별시 중구 퇴계로</div>
			<div style="padding-top: 5px; font-weight: bold;">(주)매일경제신문사</div>
			<div style="padding-top: 5px;">독자마케팅국장 정현권 <img alt="직인" src="/images/stemp.png" style="width: 20px; vertical-align: middle;"></div>
		</div>
	</div>
</div>
</body>
</html>