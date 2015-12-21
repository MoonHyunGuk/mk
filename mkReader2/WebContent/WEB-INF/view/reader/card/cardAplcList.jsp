<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ page import="com.mkreader.security.ISiteConstant" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/select2/select2.js"></script>
<link rel='stylesheet' type='text/css' href="/select2/select2.css"/>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript">
/**
 * 페이징처리
 */
function moveTo(where, seq) {
	var fm = document.getElementById("aplcForm");
	
	fm.pageNo.value = seq;
	fm.target = "_self";
	fm.action = "/reader/card/cardAplcList.do";
	fm.submit();	
}

/**
 * 조회버튼 클릭 이벤트
 */
function fn_search() {
	var fm = document.getElementById("aplcForm");
	
	fm.target="_self";
	fm.action="/reader/card/cardAplcList.do";
	fm.submit();
}

/**
 * 팝업에서 저장버튼 클릭 이벤트
 */
function fn_aplc_data_update()  {
	jQuery(document).ready(function($){
		setTimeout(function() {
			fn_search();
		},500);
	});
}

/**
 * 독자정보관리 등록 팝업
 */
function fn_popAplcReaderEdit(seqNo, userId) {
	var width="630";
	var height="655";
	var url = "/reader/card/cardAplcReaderInfo.do?seqNo="+seqNo+"&userId="+userId;
	
	var LeftPosition=(screen.width)?(screen.width-width)/2:100;
	var TopPosition=(screen.height)?(screen.height-height)/2:100;
	
	winOpts = "scrollbars=no,toolbar=no,location=no,directories=no,width="+width+"px,height="+height+"px,resizable=no,left="+LeftPosition+",top="+TopPosition;
	aplcEdit = window.open(url,'aplcEdit',winOpts);
}

jQuery.noConflict();
jQuery(document).ready(function($){
});
</script>
<!-- title -->
<div><span class="subTitle">카드구독신청리스트</span></div>
<form method="post" name="aplcForm" id="aplcForm" >
	<input type=hidden id="pageNo" name="pageNo" value="${param.pageNo}" />
	<!-- search conditions -->
	<div class="box_white" style="padding: 10px 0; width: 1020px; margin: 0 auto;">
		<font class="b02" style="vertical-align: middle;">조 회 일</font>
		<input type="text" id="fromDate" name="fromDate"  value="${fromDate}" readonly="readonly" style="text-align: center; width: 80px; vertical-align: middle;" onclick="Calendar(this)" /> ~ 
		<input type="text" id="toDate" name="toDate"  value="${toDate}" readonly="readonly" style="text-align: center; width: 80px;  vertical-align: middle;" onclick="Calendar(this)"/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<select name="searchType" id="searchType" style="vertical-align: middle;">
			<option value="userName" <c:if test="${searchType eq 'userName'}">selected </c:if>>독자명</option>
			<option value="userId" <c:if test="${searchType eq 'userId'}">selected </c:if>>독자ID</option>
		</select>&nbsp;&nbsp;
		<input type="text" name="searchKey" id="searchKey" value="${searchKey }"  style="width: 140px; vertical-align: middle;" onkeydown="if(event.keyCode == 13){fn_search(); }"/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<select name="opState" id="opState" style="vertical-align: middle;">
			<option value="" >전체</option>
			<option value="0" <c:if test="${opState eq '0'}">selected </c:if>>신청</option>
			<option value="1" <c:if test="${opState eq '1'}">selected </c:if>>정상인증</option>
			<option value="2" <c:if test="${opState eq '2'}">selected </c:if>>해지</option>
			<option value="3" <c:if test="${opState eq '3'}">selected </c:if>>청구제외</option>
		</select>&nbsp;&nbsp;
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<img src="/images/bt_search.gif" style="vertical-align: middle; border: 0; cursor: pointer;" onclick="fn_search();" alt="조회">
	</div>
	<!-- //search conditions -->
	<!-- list -->
	<div style="padding-top: 15px; ">
		<div style="padding: 5px 0 ; font-weight: bold; width: 1020px; margin: 0 auto;">[ 총 ${totalCount } 건 / ${pageInfo.lows} 건]</div>
		<table class="tb_list_a_5" style="width: 1020px">
			<col width="120px;" />
			<col width="70px;" />
			<col width="70px;" />
			<col width="320px;" />
			<col width="100px;" />
			<col width="100px;" />
			<col width="90px;" />
			<col width="80px;" />
			<col width="80px;" />
			<tr>
				<th style="padding: 7px 0">이름</th>
				<th>결합구분</th>
				<th>독자구분</th>
				<th>주 소</th>
				<th>전화번호</th>
				<th>휴대폰번호</th>
				<th>신청일</th>
				<th>지국명</th>
				<th>상 태</th>
			</tr>
			<c:choose>
				<c:when test="${fn:length(cardAplcList) > 0}">
					<c:forEach items="${cardAplcList}" var="list" varStatus="i">
						<tr class="mover_color" onclick="fn_popAplcReaderEdit('${list.SEQNO}','${list.USERID}');" style="cursor: pointer; <c:if test="${list.USESTATE eq '0'}">background-color: #EAF1FF </c:if>">
							<td>${list.USERNAME }<br/><strong>(${list.USERID })</strong></td>
							<td>	
								<c:choose>
									<c:when test="${list.JOIN_YN eq 'Y'}">결합</c:when>
									<c:otherwise>일반</c:otherwise>
								</c:choose>
							</td>
							<td>
								<c:choose>
									<c:when test="${list.GUBUNCODE eq '0'}">신규</c:when>
									<c:otherwise>기존</c:otherwise>
								</c:choose>
							</td>
							<td style="text-align: left;">
								<c:choose>
									<c:when test="${fn:length(list.ADDRDORO) > 0}">
										${list.ADDRDORO }<br/><b>(${list.ADDR1 })</b>${list.ADDR2 }
									</c:when>
									<c:otherwise>
										${list.ADDR1 } ${list.ADDR2 }
									</c:otherwise>
								</c:choose>
							</td>
							<td>${list.TELNO }</td>
							<td>${list.RCVTELNO }</td>
							<td>${list.INSDATE }</td>
							<td style="font-weight: bold;">${list.OFFICENM }</td>
							<td>
								<c:choose>
									<c:when test="${list.USESTATE eq '0'}"><span style="color: blue; font-weight: bold;">신청</span></c:when>
									<c:when test="${list.USESTATE eq '1'}"><span style="color: green">정상인증</span></c:when>
									<c:when test="${list.USESTATE eq '2'}"><span style="color: red">해지</span></c:when>
									<c:when test="${list.USESTATE eq '3'}"><span style="color: gray">청구제외</span></c:when>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<tr>
						<td colspan="9" style="padding: 8px 0">조회된 내용이 없습니다.</td>
					</tr>
				</c:otherwise>
			</c:choose>
		</table>
	</div>  
	<%@ include file="/common/paging.jsp"%>
	<!-- //list -->
</form>
<!-- processing viewer -->
<div id="prcssDiv"  class="loingProcessDiv"><div><img src="/images/process4.gif"/></div></div>
<script type="text/javascript">
/** Jquery setting */
jQuery.noConflict();
jQuery(document).ready(function($) {
	$("#prcssDiv").hide();
});
</script>
<!-- //processing viewer --> 
