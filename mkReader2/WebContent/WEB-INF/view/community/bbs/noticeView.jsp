<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.security.ISiteConstant"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String userGb = "";
	if ( null != session.getAttribute(ISiteConstant.SESSION_NAME_ADMIN_LEVELS) ){
		userGb = (String)session.getAttribute(ISiteConstant.SESSION_NAME_ADMIN_LEVELS).toString();
	}
%>
<style type="text/css"> 
P{margin:0; padding: 0;} 
#xlist {
	width: 100%;
	height: 300px;
	overflow-y: scroll;
	overflow-x: none;
}
</style>
<script type="text/javascript">
	// 리스트
	function noticeList(){
		var frm = document.searchForm;

		frm.action = "./noticeList.do";
		frm.submit();
	}
	function form(type){
		if( type == 'delete' ){
			if( confirm('삭제하시겠습니까?')){
			}else{
				return;
			}
		}
		var frm = document.searchForm;
		frm.type.value = type;
		frm.action = "./noticeForm.do";
		frm.submit();
	
	}
		
	function downfile(file_path,file_name){
		TaskFrame.location.href = "/common/download_file.jsp?file_path=" + file_path + "&file_name=" + file_name ;
	}
</script>
<form name="searchForm" action="noticeList.do" method="post">
	<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />
	<input type="hidden" id="search_key" name="search_key" value="${search_key}" />
	<input type="hidden" id="search_type" name="search_type" value="${search_type}" />
	<input type="hidden" id="seq" name="seq" value="${seq}" />
	<input type="hidden" id="type" name="type" value="" />							
</form>
<div><span class="subTitle">공지사항(상세)</span></div>
<!-- edit -->
<div>
	<table class="tb_search" style="width: 1020px">
		<colgroup>
			<col width="110px">
			<col width="230px">
			<col width="110px">
			<col width="230px">
			<col width="110px">
			<col width="230px">
		</colgroup>
		<tr>
			<th>제목</th>
			<td colspan="3">${result.TITL}</td>
			<th>조회</th>
			<td>${result.CNT}</td>
		</tr>
		<tr>
			<th>작성자</th>
			<td>${result.INPS}</td>
			<th>첨부파일</th>
			<td>
				<c:choose>
				<c:when test="${empty result.FILE_PATH or empty result.REAL_FNM}">
					&nbsp;
				</c:when>
				<c:otherwise>
					<a href="#fakeUrl" onclick="downfile('${result.FILE_PATH}/','${result.SAVE_FNM}');">
						<img src="/images/ico_save_blue.png" style="border: 0; vertical-align: middle;">
						${result.REAL_FNM}
					</a>	
				</c:otherwise>
				</c:choose>
			</td>
			<th>등록일</th>
			<td>${result.INDT}</td>
		</tr>
		<tr>
			<th>내용</th>
			<td colspan="5" style="text-align: left;">
				<div style="clear: none;">
					<c:if test="${result.SEQ eq 169}">
						<img src="/images/매일경제852.jpg" style="border: 0; vertical-align: middle;" width="860px;"><br/>
					</c:if>
					<c:if test="${result.SEQ eq 172}">
						<img src="/images/설_휴간일및캠페인.jpg" style="border: 0; vertical-align: middle;" width="860px;"><br/>
					</c:if>
					${fn:replace(result.CONT, "<br>", "")}
				</div>
			</td>
		</tr>
	</table>
</div>
<!-- edit -->
<!-- button -->
<div style="text-align: right; padding-top: 10px;">
	<a href="#" onclick="noticeList();"><img src="/images/bt_back.gif" style="border: 0; vertical-align: middle;"></a> &nbsp;
	<%
	if ("9".equals(userGb) ){
	%>
		<a href="#fakeUrl" onclick="form('modify');"><img src="/images/bt_modi.gif" style="border: 0; vertical-align: middle;"></a> &nbsp;
		<a href="#fakeUrl" onclick="form('delete');"><img src="/images/bt_delete.gif" style="border: 0; vertical-align: middle;"></a> &nbsp;
	<%
	}
	%>
</div>
<%if(userGb.equals("9")){%>
<div><span class="subTitle">미열람 지국 리스트</span></div>
<div>	
	<div id="xlist" style="padding-left:14px;width:835px;">
		<table class="tb_list_a" width="100%">
			<colgroup>
				<col width="20px">
				<col width="113px"/>
				<col width="120px"/>
				<col width="122px"/>
				<col width="130px"/>
				<col width="90px"/>
				<col width="100px"/>
				<col width="189px"/>
			</colgroup>
		<tr>
			<th><input type="checkbox" id="controll" style="vertical-align: middle;"></th>
			<th>지국코드</th>
			<th>지국명</th>
			<th>부서</th>
			<th>구분</th>
			<th>지역</th>
			<th>담당자</th>
			<th>전화번호</th>
		</tr>
			<c:forEach items="${notReadNoticeJikukList}" var="list" varStatus="i">
			<tr>
				<td><input type="checkbox" id="boSeq${i.index}" name="boSeq${i.index}" value="${list.BOSEQCODE}"/></td>
				<td>${list.SERIAL}</td>
				<td>${list.NAME}</td>
				<td>${list.AREA1_NM}</td>
				<td>${list.TYPE_NM}</td>
				<td>${list.ZONE_NM}</td>
				<td>${list.MANAGER}</td>
				<td>${list.JIKUK_HANDY}</td>
			</tr>
			</c:forEach>
		</table>
	</div>
</div>
<%}%>


<!-- //button -->
<iframe name=TaskFrame id=TaskFrame style="width: 0; height: 0" src="about:blank"></iframe>
			
