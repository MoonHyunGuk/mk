<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> 
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ page import="com.mkreader.security.ISiteConstant" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript">

/*----------------------------------------------------------------------
 * Desc   : 년도별 수금현황 조회
 * Auth   : 박윤철
 *----------------------------------------------------------------------*/
function fn_search(){
	var frm = document.getElementById("sugmStatForm");
	frm.target = "_self";
	frm.action = "/print/print/searchSugmStats.do";
	frm.submit();
}

</script>

<style type="text/css">
	.subTitle{font-family: NanumGothicWeb,dotum,Helvetica,sans-serif;/*"HY헤드라인M",Verdana, sans-serif; */font-weight: bold; font-size: 16px; letter-spacing: -1px; padding-bottom: 10px;}

	.tb_search {margin:0 auto; text-align:center; border-collapse:collapse; font:normal 12px Gulim, "굴림", Verdana, Geneva; }
	.tb_search th, .tb_search td {padding:8px 1px; }
	.tb_search th {text-align:center; border:1px solid #e5e5e5; background-color: #f9f9f9; font-weight: bold/*#e48764*//*#e16536 */;}
	.tb_search td {text-align:left; border:1px solid #e5e5e5; background-color: #fff; padding-left: 10px;}

	.tb_list_a_5 {margin:0 auto; text-align:center; border-collapse:collapse; font:normal 12px Gulim, "굴림", Verdana, Geneva; }
	.tb_list_a_5 th, .tb_list_a_5 td {padding:5px 1px; }
	.tb_list_a_5 th {text-align:center; border:1px solid #e5e5e5; background-color: #f9f9f9; font-weight: bold/*#e48764*//*#e16536 */;}
	.tb_list_a_5 td {text-align:center; border:1px solid #e5e5e5; }

	.box_list{clear: both; width: 1020px; padding: 15px 0 20px 0;}
</style>

<form id="sugmStatForm" name="sugmStatForm" method="post">
	<!-- 타이틀 DIV -->
	<div style="padding-bottom: 10px;">
		<span class="subTitle">월별수금현황</span>
	</div>
	<!--// 타이틀 DIV -->
	<!-- 조회조건 DIV-->
	<div style="padding: 10px 0;">
		<table class="tb_search" style="width: 100%">
			<colgroup>
				<col width="10%"/>
				<col width="15%"/>
				<col width="10%"/>
				<col width="65%"/>
			</colgroup>
			<c:choose>
				<c:when test="${loginType eq 'A'}">
					<tr bgcolor="ffffff">
						<th>지국</th>
						<td>
							<select name="boseq" id="boseq" style="width: 100px;">
								<option value="">전체</option>
								<c:forEach items="${agencyAllList}" var="list">
									<option value="${list.SERIAL}" <c:if test="${param.boseq eq list.SERIAL}">selected </c:if>>${list.NAME}</option>
								</c:forEach>
							</select>&nbsp;&nbsp;
						</td>
						<th>조회년도</th>
						<td>
							<select name="years" id="years" style="vertical-align: middle;">
								<c:forEach items="${yearsList}" var="list">
									<c:if test="${list.RM < 4}">
										<option value="${list.YYYY}" <c:if test="${years eq list.YYYY}">selected </c:if>>${list.YYYY}</option>
									</c:if>
								</c:forEach>
							</select>&nbsp;&nbsp;
							<img src="/images/bt_joh.gif" style="vertical-align: middle; border: 0; cursor: pointer;" onclick="fn_search()">
						</td>
					</tr>
				</c:when>
				<c:otherwise>
					<tr>
						<th>조회년도</th>
						<td colspan="3">
							<input type="hidden" id="boseq" name="boseq" value="${boseq}"/>
							<select name="years" id="years" style="vertical-align: middle;">
								<c:forEach items="${yearsList}" var="list">
									<c:if test="${list.RM < 4}">
										<option value="${list.YYYY}" <c:if test="${years eq list.YYYY}">selected </c:if>>${list.YYYY}</option>
									</c:if>
								</c:forEach>
							</select>&nbsp;&nbsp;
							<img src="/images/bt_joh.gif" style="vertical-align: middle; border: 0; cursor: pointer;" onclick="fn_search()">
						</td>
					</tr>
				</c:otherwise>
			</c:choose>			
		</table>
	</div>
	<!--// 조회조건 DIV-->	
</form>
<!-- 조회결과 -->
<div class="box_list">
	<table class="tb_list_a_5" style="width: 100%;">  
		<colgroup>
			<col width="5%"/>
			<col width="8%"/>
			<col width="8%"/>
			<col width="8%"/>
			<col width="8%"/>
			<col width="8%"/>
			<col width="8%"/>
			<col width="7%"/>
			<col width="8%"/>
			<col width="7%"/>
			<col width="7%"/>
			<col width="8%"/>
			<col width="10%"/>
		</colgroup>
		<tr>
			<th>월 분</th>
			<th>지 로</th>
			<th>방 문</th>
			<th>통장수금</th>
			<th>자동이체</th>
			<th>카 드</th>
			<th>본사입금</th>
			<th>쿠 폰</th>
			<th>결 손</th>
			<th>재 무</th>
			<th>기 타</th>
			<th>월삭제</th>
			<th>합 계</th>
		</tr>
		<c:choose>
			<c:when test="${empty yearsSugmList}">
				<tr bgcolor="ffffff">
					<td colspan="13" align="center">검색 결과가 없습니다.</td>
				</tr>
			</c:when>
			<c:otherwise>
				<!-- 합계 변수지정 -->
				<c:set var="SUM_GIRO" value="0" />
				<c:set var="SUM_VISIT" value="0" />
				<c:set var="SUM_ACNT" value="0" />
				<c:set var="SUM_AUTO" value="0" />
				<c:set var="SUM_CARD" value="0" />
				<c:set var="SUM_OFFICE" value="0" />
				<c:set var="SUM_COUPON" value="0" />
				<c:set var="SUM_LOSS" value="0" />
				<c:set var="SUM_FINANCE" value="0" />
				<c:set var="SUM_ETC" value="0" />
				<c:set var="SUM_DEL" value="0" />
				<c:set var="SUM_TOTAL" value="0" />
				<!--// 합계 변수지정 -->

				<c:forEach items="${yearsSugmList}" var="list" varStatus="i">
				<tr>
					<th>${list.YYMM}</th>
					<td style="text-align: right;"><fmt:formatNumber value="${list.GIRO}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.VISIT}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.ACNT}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.AUTO}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.CARD}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.OFFICE}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.COUPON}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.LOSS}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.FINANCE}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.ETC}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.DEL}" type="number" /></td>
					<th style="font-weight: bold; text-align: right;"><fmt:formatNumber value="${list.TOTAL}" type="number" /></th>
				</tr>
				
				<c:set var="SUM_GIRO" value="${SUM_GIRO + list.GIRO}" />
				<c:set var="SUM_VISIT" value="${SUM_VISIT + list.VISIT}" />
				<c:set var="SUM_ACNT" value="${SUM_ACNT + list.ACNT}" />
				<c:set var="SUM_AUTO" value="${SUM_AUTO + list.AUTO}" />
				<c:set var="SUM_CARD" value="${SUM_CARD + list.CARD}" />
				<c:set var="SUM_OFFICE" value="${SUM_OFFICE + list.OFFICE}" />
				<c:set var="SUM_COUPON" value="${SUM_COUPON + list.COUPON}" />
				<c:set var="SUM_LOSS" value="${SUM_LOSS + list.LOSS}" />
				<c:set var="SUM_FINANCE" value="${SUM_FINANCE + list.FINANCE}" />
				<c:set var="SUM_ETC" value="${SUM_ETC + list.ETC}" />
				<c:set var="SUM_DEL" value="${SUM_DEL + list.DEL}" />
				<c:set var="SUM_TOTAL" value="${SUM_TOTAL + list.TOTAL}" />
				</c:forEach>
				
				<tr>
					<th>총 계</th>
					<th style="font-weight: bold; text-align: right;"><fmt:formatNumber value="${SUM_GIRO}" type="number" /></th>
					<th style="font-weight: bold; text-align: right;"><fmt:formatNumber value="${SUM_VISIT}" type="number" /></th>
					<th style="font-weight: bold; text-align: right;"><fmt:formatNumber value="${SUM_ACNT}" type="number" /></th>
					<th style="font-weight: bold; text-align: right;"><fmt:formatNumber value="${SUM_AUTO}" type="number" /></th>
					<th style="font-weight: bold; text-align: right;"><fmt:formatNumber value="${SUM_CARD}" type="number" /></th>
					<th style="font-weight: bold; text-align: right;"><fmt:formatNumber value="${SUM_OFFICE}" type="number" /></th>
					<th style="font-weight: bold; text-align: right;"><fmt:formatNumber value="${SUM_COUPON}" type="number" /></th>
					<th style="font-weight: bold; text-align: right;"><fmt:formatNumber value="${SUM_LOSS}" type="number" /></th>
					<th style="font-weight: bold; text-align: right;"><fmt:formatNumber value="${SUM_FINANCE}" type="number" /></th>
					<th style="font-weight: bold; text-align: right;"><fmt:formatNumber value="${SUM_ETC}" type="number" /></th>
					<th style="font-weight: bold; text-align: right;"><fmt:formatNumber value="${SUM_DEL}" type="number" /></th>
					<th style="font-weight: bold; text-align: right;"><fmt:formatNumber value="${SUM_TOTAL}" type="number" /></th>
				</tr>
			</c:otherwise>
		</c:choose>
	</table>
</div>
<!--// 조회결과 -->