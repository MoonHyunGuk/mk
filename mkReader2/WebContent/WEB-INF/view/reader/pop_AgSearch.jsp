<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>지국정보검색</title>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet">
<script type="text/javascript">
	function fn_search(){
		var fm = document.getElementById("agencyForm");
		var search = document.getElementById("search");
		
		if(search.value == ''){
			alert('검색할 주소를 입력해 주세요.');
			search.focus();
			return;
		}
		fm.target="_self";
		fm.action="/reader/readerAplc/popSearchAgency.do";
		fm.submit();
	}
	
	function setValue(zip, addr, boseq, jikuk, tel, handy){
		opener.setAgValue(zip, addr, boseq, jikuk, tel, handy);
		self.close();
	}
	
	function setAddr(zip , addr , jikuk , jiSerial){
		if($("cmd").value == '1'){ //독자관리에서 주소찾기
			window.opener.setAddr(zip , addr);
			self.close();	
		}else if($("cmd").value == '2'){//이사 민원팝업에서 이전지국 주소찾기
			window.opener.setAddr(zip , addr , jikuk , jiSerial , $("cmd").value);
			self.close();
		}else if($("cmd").value == '3'){//이사 민원팝업에서 인수지국 주소찾기
			window.opener.setAddr(zip , addr , jikuk , jiSerial , $("cmd").value);
			self.close();
		}else if($("cmd").value == '4'){//자동이체 주소찾기
			window.opener.setAddr(zip , addr);
			self.close();
		}
		
	}
</script>
</head>
<body>
<div class="box_Popup">
	<!-- title -->
	<div class="pop_title_box">지국정보검색</div>
	<!-- //title -->
	<div style="padding-top: 5px">
		<div class="box_white" style="width: 780px; padding: 10px 0;">
			<div style="padding-bottom: 5px;">찾고자하시는 주소의 (동/읍)을 입력하여 주십시오.<br />(예)노원구 상계동이라면 &quot;상계동&quot;</div>
		   <form name="agencyForm" id="agencyForm"  method="post">
		   		<div style="overflow: hidden; margin: 0 auto; width: 230px;">
		     	<table border="0" cellpadding="0" cellspacing="0" style="width: 230px;">
			        <tr>
			          <td><img src="/images/frame_01.gif" width="14" height="14" alt="" /></td>
			          <td height="14" background="/images/frame_02.gif"></td>
			          <td><img src="/images/frame_03.gif" width="14" height="14" alt="" /></td>
			        </tr>
			        <tr>
			          <td width="14" background="/images/frame_04.gif"></td>
			          <td bgcolor="#FFFFFF">
			          		<input type="text" name="search" id="search" value="${search}" onkeydown="javascript:if(event.keyCode == '13') {fn_search();return false;}" style="ime-mode:active; vertical-align: middle;" />
			          		<a href="#fakeUrl" onclick="fn_search();"><img src="/images/btn_search_02.gif" alt="검색" width="43" height="15" style="vertical-align: middle;"></a>
			          </td>
			          <td width="14" background="/images/frame_06.gif">&nbsp;</td>
			        </tr>
			        <tr>
			          <td><img src="/images/frame_07.gif" width="14" height="14" alt="" /></td>
			          <td height="14" background="/images/frame_08.gif"></td>
			          <td><img src="/images/frame_09.gif" width="14" height="14" alt="" /></td>
			        </tr>
		      </table>
		      </div>
		   </form>
		</div>
		<div style="padding-top: 5px;">
		    <table class="tb_list_a" style="width: 782px;">
				<colgroup>
					<col width="80px">
					<col width="325px"> 
					<col width="79px">
					<col width="79px">
					<col width="100px">
					<col width="119px">
				</colgroup>
				<c:if test="${empty addrList}">
					<tr><td colspan="6" style="height: 245px;">우편번호 검색 결과가 없습니다.</td></tr>
				</c:if>
				<c:if test="${!empty addrList}">
					<tr>
						<th>우편번호</th>
						<th>주소</th>
						<th>지국명</th>
						<th>성명</th>
						<th>전화번호</th>
						<th>핸드폰</th>
					</tr>
				</c:if>
			</table>
			<c:if test="${!empty addrList}">
				<div style="overflow-y:scroll;overflow-x:none; height:245px; width:780px;">
				<table class="tb_list_a" style="width: 763px;">
					<colgroup>
						<col width="80px">
						<col width="327px">
						<col width="80px">
						<col width="80px">
						<col width="100px">
						<col width="100px">
					</colgroup>
					<c:forEach var="list" items="${addrList}" varStatus="status">
						<c:set var="AGINFO" value="${fn:split(list.AGINFO, '^')}"/>
						<c:forEach var="s1" items="${AGINFO}" varStatus="s">
						    <c:if test="${s.count==1}"><c:set var="jikuk" value="${s1}"/></c:if>  
						    <c:if test="${s.count==2}"><c:set var="jikukowner" value="${s1}"/></c:if>  
						    <c:if test="${s.count==3}"><c:set var="tel" value="${s1}"/></c:if>
						    <c:if test="${s.count==4}"><c:set var="handy" value="${s1}"/></c:if>                        
					    </c:forEach> 
						<tr class="mover" onclick="setValue(
								'<c:out value="${list.ZIP}" />',
								'<c:out value="${list.ADDR}" />',
								'<c:out value="${list.JISERIAL}" />',
								'<c:out value="${jikuk}" />',
								'<c:out value="${tel}" />',
								'<c:out value="${handy}" />')" style="cursor: hand;">
							<td><c:out value="${list.ZIP}" />&nbsp;</td>
							<td style="text-align:left"><c:out value="${list.TXT}" />&nbsp;</td>
							<td ><c:out value="${jikuk}" />&nbsp;</td>
							<td ><c:out value="${jikukowner}" />&nbsp;</td>
							<td ><c:out value="${tel}" />&nbsp;</td>
						    <td ><c:out value="${handy}" />&nbsp;</td>
						</tr>
						 <c:set var="jikuk" value=""/>  
						 <c:set var="jikukowner" value=""/>  
						 <c:set var="tel" value=""/>
						 <c:set var="handy" value=""/>                       
					</c:forEach>
		      	</table>
		      	</div>
			</c:if>
       </div>
		<div style="width: 780px; margin: 0 auto; text-align: right; padding-top: 5px;"><a href="#fakeUrl" onclick="self.close(); return false;"><img src="/images/bt_close.gif" border="0"></a></div>
	</div>
</div>
</body>
</html>
