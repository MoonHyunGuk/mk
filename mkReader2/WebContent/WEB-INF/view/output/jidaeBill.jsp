<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript">
function fn_click_save() {
	var fm = document.getElementById("fm");
	fm.target="_self";
	fm.action = "/output/billOutput/jidaeCapture.do";
	fm.submit();
} 

/**
 * 오즈출력
 */
function fn_ozPrint(boseq){
	var fm = document.getElementById("fm");
	
	actUrl = "/output/billOutput/ozJidaePrint.do";
	window.open('','ozJidae','width=850, height=700, toolbar=no, menubar=no, location=no, status=no, resizable=1, scrollbar=no');

	fm.target = "ozJidae";
	fm.action = actUrl;
	fm.printBoseq.value = boseq;
	fm.submit();
	fm.target = "_self";
}

/**
 * 지대조회
 */
function fn_jidae_search() {
	var fm = document.getElementById("fm");
	
	fm.taget = "_self";
	fm.action = "/output/billOutput/selectJidaeView.do";
	fm.submit();
}
</script>
<div><span class="subTitle">지대납부금통지서</span></div>
<form id="fm" name="fm" method="post">
<input type="hidden" name="orgBoseq" id="orgBoseq" value="${orgBoseq }">
<input type="hidden" name="printBoseq" id="printBoseq" value="">
<input type="hidden" name="chkJisaYn" id="chkJisaYn" value="${chkJisaYn }">

<!-- search conditions 
<div style="border: 1px solid red; padding: 10px;" onclick="fn_click_save();">저장</div>
 //search conditions -->
 <!-- 부산지국들은 기타장려금이 안보여야함, 소계 및 실납입액에서도 기타장려금 금액 제거 2015.01,05-->
 <c:set var="chkBusan" value="${fn:substring(boseq, 0, 2) }" />
 <c:if test="${chkJisaYn == 'Y'}">	
	<div id="selectConditionBox" class="box_gray_left" style="width: 800px; text-align: center; padding: 10px 20px;">
		<span style="font-weight: bold; vertical-align: middle;">지국명</span> &nbsp;&nbsp;
		<select name="boseq" id="boseq" style="width: 100px; vertical-align: middle;">
			<option value=""> 선택</option>
			<c:forEach items="${agencyAllList }" var="list">
				<option value="${list.SERIAL }" <c:if test="${boseq eq list.SERIAL}">selected="selected" </c:if>>${list.NAME } </option>
			</c:forEach>
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
		<span style="font-weight: bold; vertical-align: middle;">월분</span> &nbsp;&nbsp;
		<select name="opYYMM" id="opYYMM" style="width: 100px; vertical-align: middle;"> 
			<c:forEach var="list"  items="${yymmList}" varStatus="i">
				<option value="${list}" <c:if test="${opYYMM eq list}">selected="selected"</c:if>>${fn:substring(list,0,4)}년 ${fn:substring(list,4,6)}월</option>
			</c:forEach>
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; 
		<span class="btnCss2"><a class="lk2" onclick="fn_jidae_search();"><b>조회</b></a></span>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
		&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
		<span class="btnCss2"><a class="lk2" onclick="fn_ozPrint('${boseq}');"><b>인쇄</b></a></span>
		&nbsp;<span class="btnCss4"><a class="lk3" onclick="fn_ozPrint('${printAllBoseq}');"><b>전체인쇄</b></a></span>
	</div>
	<br/>
</c:if>
<c:if test="${chkJisaYn == 'N'}">	
	<input type="hidden" name="boseq" id="boseq" value="${boseq }" />
	<div id="selectConditionBox" class="box_gray_left" style="width: 800px; text-align: center; padding: 10px 20px;">
		<span style="font-weight: bold; vertical-align: middle;">월분</span> &nbsp;&nbsp;
		<select name="opYYMM" id="opYYMM" style="width: 100px; vertical-align: middle;"> 
			<c:forEach var="list"  items="${yymmList}" varStatus="i">
				<option value="${list}" <c:if test="${opYYMM eq list}">selected="selected"</c:if>>${fn:substring(list,0,4)}년 ${fn:substring(list,4,6)}월</option>
			</c:forEach>
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<span class="btnCss2"><a class="lk2" onclick="fn_jidae_search();"><b>조회</b></a></span>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; 
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;
		<span class="btnCss2"><a class="lk2" onclick="fn_ozPrint('${boseq}');"><b>인쇄</b></a></span>
	</div>
	<br/>
</c:if>
<div style="width: 800px; padding: 20px; border: 1px solid #e5e5e5;">
	<div style="width: 800px;">
		<div style="width: 800px; text-align: left; padding-bottom: 10px; font-weight: bold; font-size: 1.3em;">(&nbsp;${jidaerData.MONTH }&nbsp;월분)</div>
		<table class="tb_edit_4" style="width: 800px">
			<colgroup>
				<col width="150px">
				<col width="250px">
				<col width="150px">
				<col width="250px">
			</colgroup>
			<tr>
				<th>지 국 명</th>
				<td>${jidaerData.BOSEQNM}</td>
				<th>코드번호</th>
				<td>${jidaerData.BOSEQCODE}</td>
			</tr>
			<tr>
				<th>소&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;속</th>
				<td>${jidaerData.TYPE}</td>
				<th>지국장명</th>
				<td>${jidaerData.AGENCYNM}</td>
			</tr>
		</table>
		<!-- 지대내역 -->
		<div style="padding-top: 10px;">
			<div style="font-weight: bold; font-size: 15px; padding-bottom: 3px">1. 지대내역</div>
			<table class="tb_edit_4" style="width: 800px">
				<colgroup>
					<col width="200px">
					<col width="200px">
					<col width="200px">
					<col width="200px">
				</colgroup>
				<tr>
					<th>구&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;분</th>
					<th>금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</th>
					<th>구&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;분</th>
					<th>금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</th>
				</tr>
				<tr>
					<th>전월이월액</th>
					<td><fmt:formatNumber value="${jidaerData.MISU}" pattern="#,###" /></td>
					<th>당월조정액</th>
					<td><fmt:formatNumber value="${jidaerData.CUSTOM}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th colspan="2">지대 공제내역 및 공제금액</th>
					<th>소&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;계</th>
					<td>
						<c:choose>
							<c:when test="${chkBusan ne '76'}">
								<fmt:formatNumber value="${jidaerData.SUBTOTAL}" pattern="#,###" />
							</c:when>
							<c:otherwise>
								<fmt:formatNumber value="${jidaerData.SUBTOTAL-jidaerData.TMP4}" pattern="#,###" />
							</c:otherwise>
						</c:choose>
					</td>
				<tr>
					<th>부수유지장려금</th>
					<td><fmt:formatNumber value="${jidaerData.BUSUGRANT}" pattern="#,###" /></td>
					<th><c:if test="${jidaerData.TMP1 != null}">소외계층,NIE</c:if></th>
					<td><fmt:formatNumber value="${jidaerData.TMP1}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th>학 생 장 려 금</th>
					<td><fmt:formatNumber value="${jidaerData.STUGRANT}" pattern="#,###" /></td>
					<th><c:if test="${jidaerData.TMP2 != null}">우편요금</c:if></th>
					<td><fmt:formatNumber value="${jidaerData.TMP2}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th>기 타 장 려 금</th>
					<td><fmt:formatNumber value="${jidaerData.ETCGRANT}" pattern="#,###" /></td>
					<th><c:if test="${jidaerData.TMP3 != null}">사원구독</c:if></th>
					<td><fmt:formatNumber value="${jidaerData.TMP3}" pattern="#,###" /></td>
				</tr>
				<tr> 
					<th>카&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;드</th>
					<td><fmt:formatNumber value="${jidaerData.CARD}" pattern="#,###" /></td>
					<th><c:if test="${jidaerData.TMP4 ne null}"><c:if test="${chkBusan ne '76'}">기&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;타</c:if></c:if></th>
					<td><c:if test="${chkBusan ne '76'}"><fmt:formatNumber value="${jidaerData.TMP4}" pattern="#,###" /></c:if></td>
				</tr>
				<tr> 
					<th>교&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;육&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;용</th>
					<td><fmt:formatNumber value="${jidaerData.EDU}" pattern="#,###" /></td>
					<th><c:if test="${jidaerData.TMP5 ne null}">지&nbsp;&nbsp;로&nbsp;/&nbsp;바&nbsp;&nbsp;코&nbsp;&nbsp;드</c:if></th>
					<td><fmt:formatNumber value="${jidaerData.TMP5}" pattern="#,###" /></td>
				</tr>
				<tr> 
					<th>자&nbsp;&nbsp;&nbsp;동&nbsp;&nbsp;&nbsp;이&nbsp;&nbsp;&nbsp;체</th>
					<td><fmt:formatNumber value="${jidaerData.AUTOBILL}" pattern="#,###" /></td>
					<th><c:if test="${jidaerData.TMP6 != null}">판매수수료(VAT)</c:if></th>
					<td><fmt:formatNumber value="${jidaerData.TMP6}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th>학&nbsp;&nbsp;&nbsp;생&nbsp;&nbsp;&nbsp;배&nbsp;&nbsp;&nbsp;달</th>
					<td><fmt:formatNumber value="${jidaerData.STU}" pattern="#,###" /></td>
					<th><c:if test="${jidaerData.TMP7 != null}">보&nbsp;&nbsp;증&nbsp;&nbsp;금&nbsp;&nbsp;&nbsp;&nbsp;대&nbsp;&nbsp;체</c:if></th>
					<td><fmt:formatNumber value="${jidaerData.TMP7}" pattern="#,###" /></td> 
				</tr>
			</table>
		</div>
		<!-- //지대내역 -->
		<!-- 당월지대납부내역 -->
		<div style="padding-top: 10px;">
			<div style="font-weight: bold; font-size: 15px; padding-bottom: 3px">2. 당월 지대 납부내역</div>
			<table class="tb_edit_4" style="width: 800px">
				<colgroup>
					<col width="200px">
					<col width="200px">
					<col width="200px">
					<col width="200px">
				</colgroup>
				<tr>
					<th>항&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</th>
					<th>금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</th>
					<th>항&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</th>
					<th>금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</th>
				</tr>
				<tr>
					<th>당월실납입액</th>
					<td style="font-weight: bold;">
						<c:choose>
							<c:when test="${chkBusan ne '76'}">
								<fmt:formatNumber value="${jidaerData.J_REALAMT}" pattern="#,###" />
							</c:when> 
							<c:otherwise>
								<fmt:formatNumber value="${jidaerData.J_REALAMT+jidaerData.TMP4}" pattern="#,###" />
							</c:otherwise>
						</c:choose>
					</td>
					<th>납 기 후 지 대</th>
					<td>
						<c:choose>
							<c:when test="${chkBusan ne '76'}">
								<fmt:formatNumber value="${jidaerData.J_OVERDATE}" pattern="#,###" />
							</c:when> 
							<c:otherwise>
								<fmt:formatNumber value="${jidaerData.J_OVERDATE+jidaerData.TMP4}" pattern="#,###" />
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<th>완 납 장 려 금</th>
					<td><fmt:formatNumber value="${jidaerData.J_OKGRANT1}" pattern="#,###" /></td>
					<th>완 납 장 려 금</th>
					<td><fmt:formatNumber value="${jidaerData.J_OKGRANT2}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th>납 기 내 지 대</th>
					<td style="font-weight: bold; color: blue">
						<c:choose>
							<c:when test="${chkBusan ne '76'}">
								<fmt:formatNumber value="${jidaerData.J_DUEDATE}" pattern="#,###" />
							</c:when> 
							<c:otherwise>
								<fmt:formatNumber value="${jidaerData.J_DUEDATE+jidaerData.TMP4}" pattern="#,###" />
							</c:otherwise>
						</c:choose>
					</td>
					<th>당월지대납입액</th>
					<td style="font-weight: bold; color: #bc0546">
						<c:choose>
							<c:when test="${chkBusan ne '76'}">
								<fmt:formatNumber value="${jidaerData.J_PAYAMT}" pattern="#,###" />
							</c:when> 
							<c:otherwise>
								<fmt:formatNumber value="${jidaerData.J_PAYAMT+jidaerData.TMP4}" pattern="#,###" />
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
			</table>
			<div style="padding-top: 3px">※완납장려금은 소정 기일내에 송금하셔야 혜택을 받으실 수 있습니다.</div>
		</div>
		<!-- //당월지대납부내역 -->
		<!-- 보증금 현황 -->
		<div style="padding-top: 10px;">
			<div style="font-weight: bold; font-size: 15px; padding-bottom: 3px">3. 보증금 현황</div>
			<table class="tb_edit_4" style="width: 800px">
				<colgroup>
					<col width="200px">
					<col width="200px">
					<col width="200px">
					<col width="200px">
				</colgroup>
				<tr>
					<th>전월이월액</th>
					<th>당월발생액</th>
					<th>당월감소액</th>
					<th>보증금잔액</th>
				</tr>
				<tr>
					<td style="height: 15px"><fmt:formatNumber value="${jidaerData.D_MISU}" pattern="#,###" /></td>
					<td><fmt:formatNumber value="${jidaerData.D_HAPPEN}" pattern="#,###" /></td>
					<td><fmt:formatNumber value="${jidaerData.D_MINUS}" pattern="#,###" /></td>
					<td><fmt:formatNumber value="${jidaerData.D_BALANCE}" pattern="#,###" /></td>
				</tr>
			</table>
		</div>
		<!-- //보증금 현황 -->
		<!-- 송금안내 -->
		<div style="padding-top: 10px;">
			<div style="font-weight: bold; font-size: 15px; padding-bottom: 3px">4. 송금안내(예금주 : 매일경제신문사 장대환)</div>
			<table class="tb_edit_4" style="width: 800px">
				<colgroup>
					<col width="150px">
					<col width="250px">
					<col width="150px">
					<col width="250px">
				</colgroup>
				<tr>
					<th>은 행 명</th>
					<th>계 좌 번 호</th>
					<th>은 행 명</th>
					<th>계 좌 번 호</th>
				</tr>
				<tr>
					<th>농&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;협</th>
					<td>${jidaerData.JIDAE_BANK1}</td>
					<th>우리은행</th>
					<td>${jidaerData.JIDAE_BANK2}</td>
				</tr>
				<tr>
					<th><c:if test="${jidaerData.JIDAE_BANK3 != null}">국민은행</c:if>&nbsp;</th>
					<td>${jidaerData.JIDAE_BANK3}</td>
					<th><c:if test="${jidaerData.JIDAE_BANK4 != null}">우 체 국</c:if>&nbsp;</th>
					<td>${jidaerData.JIDAE_BANK4}</td>
				</tr>
			</table>
		</div>
		<!-- //송금안내 -->
	</div>
</div>
<br/>
</form>
