<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<link rel="stylesheet" type="text/css" href="/css/mkcrm.css">
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
//페이지 이동
function fn_moveTo(pageNo, chkSellerYn) {
	 
	var frm = document.getElementById("forms1");
	var fromYymm = document.getElementById("fromYymm").value;
	var toYymm = document.getElementById("toYymm").value;
	var fromMon = fromYymm.substring(4,6);
	var toMon = toYymm.substring(4,6);
	
	if(fromMon > toMon) {
		alert("시작월이 종료월보다 클 수 없습니다.");
		frm.fromYymm.focus();
		return false;
	}
	
	if(chkSellerYn == 'Y') {
		var boseq = document.getElementById("opBoseq").value;
		
		if(boseq == "") {
			alert("지국명을 선택해주세요.");
			return false;
		}			
	}

	frm.target="_self";
	frm.pageNo.value = pageNo;
	frm.action = "jidaeListAgency.do";
	frm.submit();
	jQuery("#prcssDiv").show();
}
</script>
<div><span class="subTitle">지대/본사입금현황</span></div>
<!-- search conditions -->
<form name="forms1" id="forms1" method="post" action="#fakeUrl">
<input type="hidden" id="pageNo" name="pageNo" value="" />	
<div>
	<table class="tb_search" style="width: 1020px">
		<colgroup>
			<col width="120px">
			<c:choose>
				<c:when test="${chkSellerYn == 'Y'}">
					<col width="390px">
					<col width="120px">
					<col width="390px">
				</c:when>
				<c:otherwise>
					<col width="900px">
				</c:otherwise>
			</c:choose>
		</colgroup>
		<tr>
			<th>월별 검색</th>
			<td style="text-align: left; padding-left: 10px;">
				<select name="fromYymm" id="fromYymm" style="vertical-align: middle;">
					<c:forEach var="list"  items="${yymmList}" varStatus="i">
						<option value="${list}" <c:if test="${fromYymm eq list}">selected="selected"</c:if>>${fn:substring(list,0,4)}년 ${fn:substring(list,4,6)}월</option>
					</c:forEach>
		  		</select>
		  		&nbsp;~&nbsp;
		  		<select name="toYymm" id="toYymm" style="vertical-align: middle;">
					<c:forEach var="list"  items="${yymmList}" varStatus="i">
						<option value="${list}" <c:if test="${toYymm eq list}">selected="selected"</c:if>>${fn:substring(list,0,4)}년 ${fn:substring(list,4,6)}월</option>
					</c:forEach>
		  		</select>&nbsp;&nbsp;
	   			<a href="#fakeUrl" onclick="fn_moveTo('1', '${chkSellerYn}');"><img src="/images/bt_joh.gif" style="vertical-align: middle; border: 0;"></a>
			</td>
			<c:if test="${chkSellerYn == 'Y'}">
				<th>지국명</th> 
				<td> 
					<select name="opBoseq" id=opBoseq style="width: 100px; vertical-align: middle;">
						<option value=""> 선택</option>
						<c:forEach items="${agencyAllList }" var="list">
							<option value="${list.SERIAL }" <c:if test="${opBoseq eq list.SERIAL}">selected </c:if>>${list.NAME } </option>
						</c:forEach>
					</select>
				</td>
			</c:if>
		</tr>
	</table>
</div>
</form>
<!-- //search conditions -->
<!-- list -->
<div style="padding: 15px 0; width: 1020px; margin: 0 auto;">
	<c:if test="${'수도권1부' eq type}">
	<div id="jidaeList" style="display:block;  width:1020px ">
		<div style="width: 1020px; overflow-x: scroll; overflow-y: none;">
		<table class="tb_list_a" style="width: 1100px;">
			<colgroup>
				<col width="50px">
				<col width="60px">
				<col width="55px">
				<col width="65px">
				<col width="65px">
				<col width="65px">
				<col width="65px">
				<col width="65px">
				<col width="65px">
				<col width="65px">
				<col width="65px">
				<col width="65px">
				<col width="65px">
				<col width="65px">
				<col width="90px">
				<col width="70px">
				<col width="60px">
			</colgroup>
			<tr>
				<th rowspan="2">지국명</th>
				<th rowspan="2">월 분</th>
				<th rowspan="2">전월미수</th>
				<th rowspan="2">조정액</th>
				<th colspan="10">본사입금현황</th>
				<th rowspan="2">지대실납입액</th>
				<th rowspan="2">이코노미</th>
				<th rowspan="2">씨티</th>
			</tr>
			<tr>
				<th>판매<br>수수료</th>
				<th>배달<br>장려금</th>
				<th>교육용</th>
				<th>카드</th>
				<th>자동<br>이체</th>
				<th>학생<br>배달</th>
				<th>소외<br>계층</th>
				<th>본사<br>사원</th>
				<th>통장</th>
				<th>지로</th>
			</tr>
			<c:choose>
				<c:when test="${empty resultList}">
					<tr>
						<td colspan="17" >등록된 정보가 없습니다.</td>
					</tr>
				</c:when>
				<c:otherwise>					
					<c:forEach items="${resultList}" var="list" varStatus="status">			
						<tr <c:if test="${'1' eq list.CHK}"> style="background-color: #eeeebb"  </c:if>  <c:if test="${'1' ne list.CHK}">  style="background-color: #ffffff"  </c:if> >
						    <td><c:out value="${list.NAME}" /></td>
							<td><c:out value="${fn:substring(list.YYMM,0,4)}-${fn:substring(list.YYMM,4,6)}" /></td>
							<td style="text-align: right;">
								<c:choose>	<c:when test="${not empty list.MISU}"><fmt:formatNumber value="${list.MISU}" type="number" /></c:when>	</c:choose>
							</td>
							<td style="text-align: right;">
								<c:choose>	<c:when test="${not empty list.CUSTOM}"><fmt:formatNumber value="${list.CUSTOM}" type="number" /></c:when>	</c:choose>
							</td>
							<td style="text-align: right;">
								<c:choose>	<c:when test="${not empty list.TMP6}"><fmt:formatNumber value="${list.TMP6}" type="number" /></c:when>	</c:choose>
							</td>
							<td style="text-align: right;">
								<c:choose>	<c:when test="${not empty list.GRAN}"><fmt:formatNumber value="${list.GRAN}" type="number" /></c:when>	</c:choose>
							</td>
							<td style="text-align: right;">
								<c:choose>	<c:when test="${not empty list.EDU}"><fmt:formatNumber value="${list.EDU}" type="number" /></c:when>	</c:choose>
							</td>
							<td style="text-align: right;">
								<c:choose>	<c:when test="${not empty list.CARD}"><fmt:formatNumber value="${list.CARD}" type="number" /></c:when>	</c:choose>
							</td>
							<td style="text-align: right;">
								<c:choose>	<c:when test="${not empty list.AUTOBILL}"><fmt:formatNumber value="${list.AUTOBILL}" type="number" /></c:when>	</c:choose>
							</td>
							<td style="text-align: right;">
								<c:choose>	<c:when test="${not empty list.STU}"><fmt:formatNumber value="${list.STU}" type="number" /></c:when>	</c:choose>
							</td>
							<td style="text-align: right;">
								<c:choose>	<c:when test="${not empty list.NEGLECT}"><fmt:formatNumber value="${list.NEGLECT}" type="number" /></c:when>	</c:choose>
							</td>
							<td style="text-align: right;">
								<c:choose>	<c:when test="${not empty list.OFFICE}"><fmt:formatNumber value="${list.OFFICE}" type="number" /></c:when>	</c:choose>
							</td>
							<td style="text-align: right;">
								<c:choose>	<c:when test="${not empty list.BANK}"><fmt:formatNumber value="${list.BANK}" type="number" /></c:when>	</c:choose>
							</td>
							<td style="text-align: right;">
								<c:choose>	<c:when test="${not empty list.GIRO}"><fmt:formatNumber value="${list.GIRO}" type="number" /></c:when>	</c:choose>
							</td>
							<td style="text-align: right; font-weight: bold; color: #0066cc; ">
								<c:choose>	<c:when test="${not empty list.JIDAE}"><fmt:formatNumber value="${list.JIDAE}" type="number" /></c:when>	</c:choose>
							</td>
							<td style="text-align: right;">
								<c:choose>	<c:when test="${not empty list.ECONOMY}"><fmt:formatNumber value="${list.ECONOMY}" type="number" /></c:when>	</c:choose>
							</td>
							<td style="text-align: right;">
								<c:choose>	<c:when test="${not empty list.CITY}"><fmt:formatNumber value="${list.CITY}" type="number" /></c:when>	</c:choose>
							</td>
						</tr>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</table>
		</div>
	</div>
	</c:if>
	<c:if test="${'수도권2부' eq type or '지방판매부'}">
		<table class="tb_list_a" style="width: 1020px;">
			<colgroup>
				<col width="60px">
				<col width="65px">
				<col width="60px">
				<col width="75px">
				<col width="75px">
				<col width="75px">
				<col width="75px">
				<col width="75px">
				<col width="75px">
				<col width="75px">
				<col width="75px">
				<col width="75px">
				<col width="95px">
				<col width="65px">
			</colgroup>
			<tr>
				<th rowspan="2">지국명</th>
				<th rowspan="2">월 분</th>
				<th rowspan="2">전월미수</th>
				<th rowspan="2">조정액</th>
				<th colspan="8">본사입금현황</th>
				<th rowspan="2">지대실납입액</th>
				<th rowspan="2">보증금</th>
			</tr>
			<tr>
				<th>판매<br>장려금</th>
				<th>교육용</th>
				<th>카드</th>
				<th>자동<br>이체</th>
				<th>학생<br>배달</th>
				<th>소외<br>계층</th>
				<th>우편<br>요금</th>
				<th>본사<br>사원</th>
			</tr>
			<c:choose>
				<c:when test="${empty resultList}">
					<tr>
						<td colspan="14" >등록된 정보가 없습니다.</td>
					</tr>
				</c:when>
				<c:otherwise>					
				<c:forEach items="${resultList}" var="list" varStatus="status">			
					<tr style="background-color: <c:if test="${'수도권1부' eq list.CHK}"> #eeeebb </c:if>  <c:if test="${'수도권1부' ne list.CHK}">#ffffff </c:if>" >
					    <td><c:out value="${list.NAME}" /></td>
						<td><c:out value="${fn:substring(list.YYMM,0,4)}-${fn:substring(list.YYMM,4,6)}" /></td>
						<td style="text-align: right;">
							<c:choose><c:when test="${not empty list.MISU}"><fmt:formatNumber value="${list.MISU}" type="number" /></c:when></c:choose>
						</td>
						<td style="text-align: right;">
							<c:choose><c:when test="${not empty list.CUSTOM}"><fmt:formatNumber value="${list.CUSTOM}" type="number" /></c:when></c:choose>
						</td>
						<td style="text-align: right;">
							<c:choose><c:when test="${not empty list.CHARGE}"><fmt:formatNumber value="${list.CHARGE}" type="number" /></c:when></c:choose>
						</td>
						<td style="text-align: right;">
							<c:choose><c:when test="${not empty list.EDU}"><fmt:formatNumber value="${list.EDU}" type="number" /></c:when>	</c:choose>
						</td>
						<td style="text-align: right;">
							<c:choose><c:when test="${not empty list.CARD}"><fmt:formatNumber value="${list.CARD}" type="number" /></c:when></c:choose>
						</td>
						<td style="text-align: right;">
							<c:choose><c:when test="${not empty list.AUTOBILL}"><fmt:formatNumber value="${list.AUTOBILL}" type="number" /></c:when></c:choose>
						</td>
						<td style="text-align: right;">
							<c:choose><c:when test="${not empty list.STU}"><fmt:formatNumber value="${list.STU}" type="number" /></c:when></c:choose>
						</td>
						<td style="text-align: right;">
							<c:choose><c:when test="${not empty list.NEGLECT}"><fmt:formatNumber value="${list.NEGLECT}" type="number" /></c:when></c:choose>
						</td>
						<td style="text-align: right;">
							<c:choose><c:when test="${not empty list.POST}"><fmt:formatNumber value="${list.POST}" type="number" /></c:when></c:choose>
						</td>
						<td style="text-align: right;">
							<c:choose><c:when test="${not empty list.OFFICE}"><fmt:formatNumber value="${list.OFFICE}" type="number" /></c:when></c:choose>
						</td>
						<td style="text-align: right; font-weight: bold; color: #0066cc">
							<c:choose><c:when test="${not empty list.JIDAE}"><fmt:formatNumber value="${list.JIDAE}" type="number" /></c:when></c:choose>
						</td>						
						<td style="text-align: right;">
							<c:choose><c:when test="${not empty list.DEPOSIT}"><fmt:formatNumber value="${list.DEPOSIT}" type="number" /></c:when></c:choose>
						</td>
					</tr>
				</c:forEach>
				</c:otherwise>
			</c:choose>
		</table>
	</c:if>
</div>
<!-- //list -->
<!-- notice -->
<div style="overflow: hidden; width: 1020px; margin: 0 auto;">
	<div style="width: 1000px; background-color: #e5e5e5; padding: 15px 10px">
	<c:choose>
		<c:when test="${'103' eq area1}">  <!-- 부산지사 -->
			<b>◈ 예 금 주 : 매일경제신문사 장대환<br></b>
			&nbsp;&nbsp;▷ 농협 : 360-01-043818<br>
			&nbsp;&nbsp;▷ 우리은행 : 701-042339-13-001<br>
			※ 완납 장려금은 소정 기일내에 송금하셔야 혜택을 받으실 수 있습니다. 
		</c:when>
		<c:when test="${'102' eq area1}">  <!-- 울산지사 -->
			<b>◈ 예 금 주 : 매일경제신문사 장대환<br></b>
			&nbsp;&nbsp;▷ 농협 : 360-01-043821<br>
			&nbsp;&nbsp;▷ 우리은행 : 701-042304-13-001<br>
			※ 완납 장려금은 소정 기일내에 송금하셔야 혜택을 받으실 수 있습니다. 
		</c:when>
		<c:when test="${'105' eq area1}">  <!-- 광주지사 -->
			<b>◈ 예 금 주 : 매일경제신문사 장대환<br></b>
			&nbsp;&nbsp;▷ 농협 : 360-01-043805<br>
			※ 완납 장려금은 소정 기일내에 송금하셔야 혜택을 받으실 수 있습니다. 
		</c:when>
		<c:when test="${'104' eq area1}">  <!-- 대전지사 -->
			<b>◈ 예 금 주 : 매일경제신문사 장대환<br></b>
			&nbsp;&nbsp;▷ 농협 : 360-01-043847<br>
			※ 완납 장려금은 소정 기일내에 송금하셔야 혜택을 받으실 수 있습니다. 
		</c:when>
		<c:when test="${'101' eq area1}">  <!-- 대구지사 -->
			<b>◈ 예 금 주 : 매일경제신문사 장대환<br></b>
			&nbsp;&nbsp;▷ 농협 : 360-01-043834<br>
			&nbsp;&nbsp;▷ 우리은행 : 701-042321-13-001<br>
			※ 완납 장려금은 소정 기일내에 송금하셔야 혜택을 받으실 수 있습니다. 
		</c:when>
		<c:otherwise>		
			<b>◈ 예 금 주 : 매일경제신문사 장대환<br></b>		
			<c:if test="${('1' eq jikyungYn) }">
				&nbsp;&nbsp;▷ 우리은행 : 050-055987-01-001<br>
			</c:if>
			<c:if test="${('1' ne jikyungYn) }">
				&nbsp;&nbsp;▷ 농협 : 047-01-003083 <br>
				&nbsp;&nbsp;▷ 우체국 : 012773-01-000022<br>
				&nbsp;&nbsp;▷ 국민은행 : 068-01-0111-852 <br>
				&nbsp;&nbsp;▷ 우리은행 : 050-055987-01-001<br>
				※ 완납 장려금은 소정 기일내에 송금하셔야 혜택을 받으실 수 있습니다.
			</c:if> 
		</c:otherwise>
	</c:choose>
	</div>
	<c:if test="${('수도권1부' ne jikyungYn) }">	
		<div style="background-color: #e5e5e5">
				<b>※ 노란색 음영표시 : 보증금 대체 지국<br></b>
		</div>
	</c:if>
</div>
<!-- //notice -->
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