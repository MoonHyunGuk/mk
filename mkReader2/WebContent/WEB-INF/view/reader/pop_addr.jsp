<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet">
<script type="text/javascript">
/**
 * 조회버튼 클릭 이벤트
 */
function fn_search(){
	var fm = document.getElementById("addrForm");
	var search = document.getElementById("search");
	
	if(search.value == ''){
		alert('검색할 주소를 입력해 주세요.');
		search.focus();
		return;
	}
	fm.target="_self";
	fm.action="/reader/readerManage/searchAddr.do";
	fm.submit();
}

/**
 * 주소 세팅
 */
function setAddr(zip , addr , jikuk , jiSerial){
	var cmdVal = document.getElementById("cmd").value;
	if(cmdVal == '1'){ //독자관리에서 주소찾기
		window.opener.setAddr(zip , addr);
		self.close();	
	}else if(cmdVal == '2'){//이사 민원팝업에서 이전지국 주소찾기
		window.opener.setAddr(zip , addr , jikuk , jiSerial , $("cmd").value);
		self.close();
	}else if(cmdVal == '3'){//이사 민원팝업에서 인수지국 주소찾기
		window.opener.setAddr(zip , addr , jikuk , jiSerial , $("cmd").value);
		self.close();
	}else if(cmdVal == '4'){//자동이체 주소찾기
		window.opener.setAddr(zip , addr);
		self.close();
	}
	
}
</script>
</head>
<body>
<div class="box_Popup">
	<!-- title -->
	<div class="pop_title_box">우편번호찾기</div>
	<!-- //title -->
	<div style="padding-top: 5px;"> 
	<form id="addrForm" name="addrForm" action="/reader/readerManage/searchAddr.do" method="post">
		<input type="hidden" id="cmd" name="cmd" value="${cmd }"/>
		<table class="tb_search" style="width: 360px;">
			<col width="120px">
			<col width="240px">
			<tr>
				<th>주 소</th>
				<td>
					<input type="text" id="search" name="search" value="${search }" style="ime-Mode:active; width: 100px; vertical-align: middle;"  />
					<a href="#fakeUrl" onclick="fn_search();"><img src="/images/bt_search.gif" border="0" style="vertical-align: middle;" alt="검색" /></a>
				</td>
			</tr>
			<tr><td colspan="3">*주소검색은 동,면을 기준으로 검색됩니다.</td></tr>
		</table>
		<c:if test="${not empty addrList }">
			<div style="padding-top: 5px;">
				<table class="tb_list_a" style="width: 360px;">
					<col width="70px">
					<col width="290px">
					<tr>
						<th>우편번호</th>
						<th>상세주소</th>
					</tr>
				</table>
				<div style="width: 360px; height: 330px;overflow-y: scroll; overflow-x: none; margin: 0 auto;">
					<table class="tb_list_a" style="width: 343px;">
						<col width="70px">
						<col width="273px">
						<c:forEach items="${addrList }" var="list" varStatus="i">
						<tr>
							<td>${list.ZIP }</td>
							<td style="text-align: left;">&nbsp;<a href="#fakeUrl" onclick="setAddr('${list.ZIP }' , '${list.ADDR }');" style="text-decoration:none">${list.TXT }</a></td>
						</tr>
						</c:forEach>
					</table>
				</div>
			</div>
		</c:if>
	</form>
	</div>
</div>
</body>
</html>