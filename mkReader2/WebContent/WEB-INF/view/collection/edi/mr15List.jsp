<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript">
	//페이지 이동
	function moveTo(pageNo) {
		
		var frm = document.forms1;

		frm.pageNo.value = pageNo;
		frm.action = "mr15List.do";
		frm.submit();
		jQuery("#prcssDiv").show();
	}

</script>
<!-- title -->
<div><span class="subTitle">바코드 수납현황</span></div>
<!-- //title -->
<form name="forms1" method="post" action="mr15list.do">
<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />	
<!-- search conditions -->	
<table class="tb_search" style="width: 1020px">
	<colgroup>
		<col width="120px">
		<col width="200px">
		<col width="120px">
		<col width="580px">
	</colgroup>
	<tr>
		<th>지로번호</th>
		<td>
			<select name="jiroNum"  style="width: 140px">
				<option value = "">전체</option>
					<c:forEach items="${jiroList}" var="list"  varStatus="status">
						<option value="${list.GIRO_NO}"  <c:if test="${list.GIRO_NO eq jiroNum}">selected</c:if>>${list.GIRO_NO}(${list.NAME})</option>
				 	</c:forEach>
		  	</select>
		</td>
		<th>일자별 검색</th>
		<td>
			<input type="text" name="sdate" style="width: 80px; vertical-align: middle;" value="<c:out value='${sdate}' />" readonly onclick="Calendar(this)">&nbsp;~
			<input type="text" name="edate"style="width: 80px; vertical-align: middle;"  value="<c:out value='${edate}' />" readonly onclick="Calendar(this)">&nbsp;
   			<a href="#fakeUrl" onclick="moveTo('1');"><img src="/images/bt_joh.gif" style="vertical-align: middle; border: 0" alt="조회"></a>
		</td>
	</tr>
</table>
<!-- //search conditions -->
</form>
<c:set var="cash_cnt" value="0" />
<c:set var="cash_amt" value="0" />
<c:set var="cash_charge" value="0" />
<c:set var="cash_money" value="0" />
<c:set var="card_cnt" value="0" />
<c:set var="card_amt" value="0" />
<c:set var="card_charge" value="0" />
<c:set var="card_money" value="0" />
<c:set var="bank_cnt" value="0" />
<c:set var="bank_amt" value="0" />
<c:set var="bank_charge" value="0" />
<c:set var="bank_money" value="0" />
<!-- list -->
<div style="width: 1020px; margin: 0 auto; padding-top: 15px">
	<table class="tb_list_a" style="width: 1020px">
		<tr>
			<th rowspan=2>일 자</th>
			<th colspan=4>현 금</th>
			<th colspan=4>카 드</th>
			<th colspan=4>계좌이체</th>
			<th colspan=4>총 계</th>
		</tr>
		<tr>
			<th>건수</th>
			<th>금액</th>
			<th>수수료</th>
			<th>계</th>
			<th>건수</th>
			<th>금액</th>
			<th>수수료</th>
			<th>계</th>
			<th>건수</th>
			<th>금액</th>
			<th>수수료</th>
			<th>계</th>
			<th>건수</th>
			<th>금액</th>
			<th>수수료</th>
			<th>계</th>
		</tr>
		<c:choose>
			<c:when test="${empty resultList}">
				<tr><td colspan="17">등록된 정보가 없습니다.</td></tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${resultList}" var="list" varStatus="status">
					<c:set var="cash_cnt" value="${cash_cnt + list.CASH_CNT}" />
					<c:set var="cash_amt" value="${cash_amt + list.CASH_AMT}" />
					<c:set var="cash_charge" value="${cash_charge + list.CASH_CHARGE}" />
					<c:set var="cash_money" value="${cash_money + list.CASH_MONEY}" />
					<c:set var="card_cnt" value="${card_cnt + list.CARD_CNT}" />
					<c:set var="card_amt" value="${card_amt + list.CARD_AMT}" />
					<c:set var="card_charge" value="${card_charge + list.CARD_CHARGE}" />
					<c:set var="card_money" value="${card_money + list.CARD_MONEY}" />
					<c:set var="bank_cnt" value="${bank_cnt + list.BANK_CNT}" />
					<c:set var="bank_amt" value="${bank_amt + list.BANK_AMT}" />
					<c:set var="bank_charge" value="${bank_charge + list.BANK_CHARGE}" />
					<c:set var="bank_money" value="${bank_money + list.BANK_MONEY}" />
					<tr class="mover_color">
						<td>
							<c:choose>
							<c:when test="${not empty list.E_EDATE and fn:length(list.E_EDATE) >= 8}">
								<c:out value="${fn:substring(list.E_EDATE,0,4)}-${fn:substring(list.E_EDATE,4,6)}-${fn:substring(list.E_EDATE,6,8)}" />
							</c:when>
							<c:otherwise>
								<c:out value="${list.E_EDATE}" />
							</c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: right;">
							<c:choose>
							<c:when test="${not empty list.CASH_CNT}"><fmt:formatNumber value="${list.CASH_CNT}" type="number" /></c:when>
							<c:otherwise>0</c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: right;">
							<c:choose>
							<c:when test="${not empty list.CASH_AMT}"><fmt:formatNumber value="${list.CASH_AMT}" type="number" /></c:when>
							<c:otherwise>0</c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: right;">
							<c:choose>
							<c:when test="${not empty list.CASH_CHARGE}"><fmt:formatNumber value="${list.CASH_CHARGE}" type="number" /></c:when>
							<c:otherwise>0</c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: right;">
							<c:choose>
							<c:when test="${not empty list.CASH_MONEY}"><fmt:formatNumber value="${list.CASH_MONEY}" type="number" /></c:when>
							<c:otherwise>0</c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: right;">
							<c:choose>
							<c:when test="${not empty list.CARD_CNT}"><fmt:formatNumber value="${list.CARD_CNT}" type="number" /></c:when>
							<c:otherwise>0</c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: right;">
							<c:choose>
							<c:when test="${not empty list.CARD_AMT}"><fmt:formatNumber value="${list.CARD_AMT}" type="number" /></c:when>
							<c:otherwise>0</c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: right;">
							<c:choose>
							<c:when test="${not empty list.CARD_CHARGE}"><fmt:formatNumber value="${list.CARD_CHARGE}" type="number" /></c:when>
							<c:otherwise>0</c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: right;">
							<c:choose>
							<c:when test="${not empty list.CARD_MONEY}"><fmt:formatNumber value="${list.CARD_MONEY}" type="number" /></c:when>
							<c:otherwise>0</c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: right;">
							<c:choose>
							<c:when test="${not empty list.BANK_CNT}"><fmt:formatNumber value="${list.BANK_CNT}" type="number" /></c:when>
							<c:otherwise>0</c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: right;">
							<c:choose>
							<c:when test="${not empty list.BANK_AMT}"><fmt:formatNumber value="${list.BANK_AMT}" type="number" /></c:when>
							<c:otherwise>0</c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: right;">
							<c:choose>
							<c:when test="${not empty list.BANK_CHARGE}"><fmt:formatNumber value="${list.BANK_CHARGE}" type="number" /></c:when>
							<c:otherwise>0</c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: right;">
							<c:choose>
							<c:when test="${not empty list.BANK_MONEY}"><fmt:formatNumber value="${list.BANK_MONEY}" type="number" /></c:when>
							<c:otherwise>0</c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: right;">
							<c:choose>
							<c:when test="${empty list.CASH_CNT && empty list.CARD_CNT && empty list.BANK_CNT }">0</c:when>
							<c:otherwise><fmt:formatNumber value="${list.CASH_CNT+list.CARD_CNT+list.BANK_CNT}" type="number" /></c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: right;">
							<c:choose>
							<c:when test="${empty list.CASH_AMT && empty list.CARD_AMT && empty list.BANK_AMT }">0</c:when>
							<c:otherwise><fmt:formatNumber value="${list.CASH_AMT+list.CARD_AMT+list.BANK_AMT}" type="number" /></c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: right;">
							<c:choose>
							<c:when test="${empty list.CASH_CHARGE && empty list.CARD_CHARGE && empty list.BANK_CHARGE }">0</c:when>
							<c:otherwise><fmt:formatNumber value="${list.CASH_CHARGE+list.CARD_CHARGE+list.BANK_CHARGE}" type="number" /></c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: right;">
							<c:choose>
							<c:when test="${empty list.CASH_MONEY && empty list.CARD_MONEY && empty list.BANK_MONEY }">0</c:when>
							<c:otherwise><fmt:formatNumber value="${list.CASH_MONEY+list.CARD_MONEY+list.BANK_MONEY}" type="number" /></c:otherwise>
							</c:choose> 
						</td>
					</tr>
				</c:forEach>
				<tr style="background-color: #ccffcc">
					<td>총 계</td>
					<td style="text-align: right; ">
						<c:choose>
						<c:when test="${not empty cash_cnt}"><fmt:formatNumber value="${cash_cnt}" type="number" /></c:when>
						<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
					<td style="text-align: right; ">
						<c:choose>
						<c:when test="${not empty cash_amt}"><fmt:formatNumber value="${cash_amt}" type="number" /></c:when>
						<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
					<td style="text-align: right; ">
						<c:choose>
						<c:when test="${not empty cash_charge}"><fmt:formatNumber value="${cash_charge}" type="number" /></c:when>
						<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
					<td style="text-align: right; ">
						<c:choose>
						<c:when test="${not empty cash_money}"><fmt:formatNumber value="${cash_money}" type="number" /></c:when>
						<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
					<td style="text-align: right; ">
						<c:choose>
						<c:when test="${not empty card_cnt}"><fmt:formatNumber value="${card_cnt}" type="number" /></c:when>
						<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
					<td style="text-align: right; ;">
						<c:choose>
						<c:when test="${not empty card_amt}"><fmt:formatNumber value="${card_amt}" type="number" /></c:when>
						<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
					<td style="text-align: right; ">
						<c:choose>
						<c:when test="${not empty card_charge}"><fmt:formatNumber value="${card_charge}" type="number" /></c:when>
						<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
					<td style="text-align: right; ">
						<c:choose>
						<c:when test="${not empty card_money}"><fmt:formatNumber value="${card_money}" type="number" /></c:when>
						<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
					<td style="text-align: right; ">
						<c:choose>
						<c:when test="${not empty bank_cnt}"><fmt:formatNumber value="${bank_cnt}" type="number" /></c:when>
						<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
					<td style="text-align: right; ">
						<c:choose>
						<c:when test="${not empty bank_amt}"><fmt:formatNumber value="${bank_amt}" type="number" /></c:when>
						<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
					<td style="text-align: right; ">
						<c:choose>
						<c:when test="${not empty bank_charge}"><fmt:formatNumber value="${bank_charge}" type="number" /></c:when>
						<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
					<td style="text-align: right; ">
						<c:choose>
						<c:when test="${not empty bank_money}"><fmt:formatNumber value="${bank_money}" type="number" /></c:when>
						<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
					<td style="text-align: right; ">
						<c:choose>
						<c:when test="${not empty cash_cnt && not empty card_cnt && not empty bank_cnt}"><fmt:formatNumber value="${cash_cnt+card_cnt+bank_cnt}" type="number" /></c:when>
						<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
					<td style="text-align: right; ">
						<c:choose>
						<c:when test="${not empty cash_amt && not empty card_amt && not empty bank_amt}"><fmt:formatNumber value="${cash_amt+card_amt+bank_amt}" type="number" /></c:when>
						<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
					<td style="text-align: right; ">
						<c:choose>
						<c:when test="${not empty cash_charge && not empty card_charge && not empty bank_charge}"><fmt:formatNumber value="${cash_charge+card_charge+bank_charge}" type="number" /></c:when>
						<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
					<td style="text-align: right;">
						<c:choose>
						<c:when test="${not empty cash_money && not empty card_money && not empty bank_money}"><fmt:formatNumber value="${cash_money+card_money+bank_money}" type="number" /></c:when>
						<c:otherwise>0</c:otherwise>
						</c:choose>
					</td>
				</tr>
			</c:otherwise>
		</c:choose>
	</table>
</div>
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
