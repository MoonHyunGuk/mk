<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<link type="text/css" href="/css/cal/ui.datepicker.css" rel="stylesheet" >
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/js/cal/ui.datepicker.js"></script>
<script type="text/javascript">
/**
 * 조회버튼 클릭 이벤트
 */
function fn_searchList() {
	var fm = document.getElementById("fm");
	
	fm.target = "_self";
	fm.action = "/statistics/stats/readerTypeList.do";
	fm.submit();
}

/**
 * 엑셀다운버튼 클릭 이벤트
 */
function fn_byAmt_excelDown() {
	var fm = document.getElementById("fm");
	
	fm.target = "_self";
	fm.action = "/statistics/stats/readerTypeListForExcel.do";
	fm.submit();
}

/**
 *  Jquery
 **/ 
jQuery.noConflict();
jQuery(document).ready(function() { //문서가 로딩될때
	jQuery("#opStartDate").datepicker({ //#은 태그의 id값을 뜻한다.
		yearRange: '-10:+0',
		showOn: "both",
		dateFormat: 'yy-mm-dd', //날짜형식을 다양하게 줄수있음.
		buttonImageOnly: true //버튼이미지를 사용하겠다...
	});
	
	jQuery("#opEndDate").datepicker({ //#은 태그의 id값을 뜻한다.
		yearRange: '-10:+0',
		showOn: "both",
		dateFormat: 'yy-mm-dd', //날짜형식을 다양하게 줄수있음.
		buttonImageOnly: true //버튼이미지를 사용하겠다...
	});
});
</script>
<div style="padding-bottom: 10px;"> 
	<span class="subTitle">단가현황</span>
</div>
<div>
	<form method="post" name="fm" id="fm">
		<div style="overflow: hidden; padding-left: 5px;  width: 410px">
			<div class="box_gray_left" style="padding: 10px 0; width: 400px">
				<b>확장일</b>&nbsp;&nbsp;
				<input type="text" name="opStartDate" id="opStartDate" value="${opStartDate }"  style="width: 80px; vertical-align: middle; padding: 0;" readonly="readonly">&nbsp;~&nbsp;
				<input type="text" name="opEndDate" id="opEndDate" value="${opEndDate }"  style="width: 80px; vertical-align: middle; padding: 0;" readonly="readonly">
				&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;
				<a href="#fakeUrl" onclick="fn_searchList();"><img src="/images/bt_joh.gif" style="border: 0; vertical-align: middle;"></a>
			</div>
		</div>
	</form>
	<c:set var="totQty" value="0" />
	<!-- //정가독자 -->
	<div style="width: 410px; padding-top:  10px;">
		<table class="tb_list_a" style="width: 400px; padding-left: 10px;"> 
			<col width="200px">
			<col width="200px">
			<tr>
				<th>금액</th>
				<th>부수</th>
			</tr>
			<c:choose>
				<c:when test="${fn:length(readerListByUprice) > 0}">
					<c:forEach items="${readerListByUprice}" var="list"  varStatus="status" begin="0">
						<tr>
							<td><fmt:formatNumber type="number"  value="${list.UPRICE }" pattern="#,###" /></td>
							<td>
								<fmt:formatNumber type="number"  value="${list.QTY }" pattern="#,###" />
								<c:set var="totQty" value="${totQty+list.QTY }"  />
							</td>
						</tr>
					</c:forEach>
					<tr>
						<th>합계</th>
						<th>${totQty }</th>
					</tr>
				</c:when>
				<c:otherwise>
						<tr>
							<td colspan="2">조회된 결과가 없습니다.</td>
						</tr>
				</c:otherwise>
			</c:choose>
		</table>
	</div>
</div>
