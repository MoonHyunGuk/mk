<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<head>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<title>매일경제 사원확장</title>
<style> 
<!--
td {font-size: 9pt;
	text-align: justify;
	line-height: 4.5mm}
 
img {border:none}
.table_style1 td {padding:5px 10px}
input {border:1px solid #CCC }
.td_style1 {background:#f0f1f3; border-top:1px solid #dcdcdc}
.td_style2 {border-top:1px solid #dcdcdc}
.td_style11 {border-top:2px solid #0d1a49; background:#f0f1f3}
.td_style22 {border-top:2px solid #0d1a49; background:#fff}
.td_style223 {border-top:2px solid #0d1a49; border-bottom:2px solid #0d1a49; background:#fff}
.td_style13 {border-top:1px solid #dcdcdc; border-bottom:2px solid #0d1a49; background:#f0f1f3}
.td_style23 {border-top:1px solid #dcdcdc; border-bottom:2px solid #0d1a49; background:#fff}
.td_style31 {border-top:2px solid #0d1a49; border-bottom:1px solid #0d1a49; border-right:1px solid #0d1a49; background:#f0f1f3; text-align: center}
.td_style30 {border-top:2px solid #0d1a49; border-bottom:1px solid #0d1a49; background:#f0f1f3; text-align: center}
.td_style32 {border-top:2px solid #0d1a49; border-bottom:1px solid #0d1a49; border-left:1px solid #0d1a49; background:#f0f1f3; text-align: center}
-->
</style>
</head>
<script  type="text/javascript"> 
	function search() {

		empExtdForm.target="_self";
		empExtdForm.action="/reader/subscriptionForm/searchEmpExtd.do";
		empExtdForm.submit();
	}
	
	//숫자만 입력 가능하도록 체크 키 다운시
	function inputNumCom(){
		var keycode = event.keyCode;

		if (event.keyCode == 13){
			search();
		}else{
			if ((event.keyCode<48) || (event.keyCode>57)){
				alert("숫자만 입력 가능합니다.");
				event.keyCode = 0;  // 이벤트 cancel
			}
		}

	}
</script>
<form id="empExtdForm" name="empExtdForm" method="post" >

<div style="width:100%; text-align:center; color:#6f6f6f;" >
<table cellpadding="0" cellspacing="0" width="800" border="0">
	<tr>
		<td width="100%"  height="56"  style="padding:8px 15px 2px; border-bottom:7px solid #f68600; background:#FFFFFFF">
			<a href="/"><img src="/images/l_mk_blacklogo.png"  alt="매일경제" /></a>
		</td>
	</tr>
	<tr>
		<td align="center">

            <table cellpadding="20" cellspacing="10" width="100%" height="100%" bgcolor="#eaeaea" style="margin-top: 10px;">
				<tr>
					<td width="100%" bgcolor="white" valign="top">	
						<h3>사원확장 실적 조회</h3>
						<table align="center" cellpadding="0" cellspacing="0" width="900" class="table_style1">
							<colgroup>
								<col width="25%" />
								<col width="75%" />
							</colgroup>
							<tr>
								<td class="td_style11"><img src="/images/ic_org_icon.gif"" alt="" style="padding-bottom:2px"/>&nbsp;  <strong>성명</strong></td>
								<td class="td_style22"><input type="text" id="empNm" name="empNm" value="${param.empNm}" tabindex=1 maxlength=30></td>
							</tr>
							<tr>
								<td class="td_style13"><img src="/images/ic_org_icon.gif" alt="" style="padding-bottom:2px"/>&nbsp; <strong>휴대폰번호</strong></td>
								<td class="td_style23">
									<select id="empTel1" name="empTel1" style="border-style: none;">
										<c:forEach items="${mobileCode }" var="list">
											<option value="${list.CODE}" <c:if test="${param.empTel1 eq list.CODE}">selected </c:if>>${list.CODE}</option>
										</c:forEach>
									</select>
									- <input type="text" id="empTel2" name="empTel2" value="${param.empTel2}" maxlength="4" size="4" style="ime-Mode:disabled" onKeyPress="inputNumCom();">
									- <input type="text" id="empTel3" name="empTel3" value="${param.empTel3}" maxlength="4" size="4" style="ime-Mode:disabled" onKeyPress="inputNumCom();">
									&nbsp;&nbsp;
									&nbsp;&nbsp;
									&nbsp;&nbsp;
									<a href="javascript:search()"><img src="/images/bt_search.gif" border="0" align="absmiddle"></a> &nbsp;
								</td>
							</tr>
						</table>

						<c:if test="${empty empExtdList}">
							<table align="center" cellpadding="0" cellspacing="0" border="0" width="900" style="margin-top: 5px;">
								<tr>
									<td><center>조회 결과가 없습니다.</center></td>
								</tr>
							</table>
						</c:if>

						<c:if test="${not empty empExtdList}">
						<table align="center" cellpadding="0" cellspacing="0" border="0" width="900" style="margin-top: 5px;">
							<colgroup>
								<col width="10%" />
								<col width="10%" />
								<col width="20%" />
								<col width="25%" />
								<col width="15%" />
								<col width="20%" />
							</colgroup>
							<tr>
								<td colspan="6">
									<b>◆  신문 ${totalEmpExtdCount[0].PAPER + totalEmpExtdCount[0].PAPERSTU + totalEmpExtdCount[0].PAPEREDU}부(일반 ${totalEmpExtdCount[0].PAPER}, 학생 ${totalEmpExtdCount[0].PAPERSTU}, 교육용 ${totalEmpExtdCount[0].PAPEREDU})/ 전자판 ${totalEmpExtdCount[0].ELEC+totalEmpExtdCount[0].ELECSTU+totalEmpExtdCount[0].ELECEDU}부(일반 ${totalEmpExtdCount[0].ELEC}, 학생 ${totalEmpExtdCount[0].ELECSTU}, 교육용 ${totalEmpExtdCount[0].ELECEDU})/ 총 ${totalEmpExtdCount[0].TOTAL}부</b> 
								</td>
							</tr>
							<tr>
								<td class="td_style31"><strong>매체</strong></td>
								<td class="td_style30"><strong>신청일</strong></td>
								<td class="td_style32"><strong>독자명</strong></td>
								<td class="td_style32"><strong>회사명</strong></td>
								<td class="td_style32"><strong>부수</strong></td>
								<td class="td_style32"><strong>진행상태</strong></td>
							</tr>
							<c:set var="totalQty" value="0" />
							<c:forEach items="${empExtdList}" var="list" varStatus="i">
								<tr>
									<td style="text-align: center; border-bottom:1px solid #dcdcdc">
										<c:choose>
											<c:when test="${list.MEDIA eq '2' }"><font color="blue">전자판</font></c:when>
											<c:otherwise>신문</c:otherwise>
										</c:choose>
									</td>
									<td style="text-align: center; border-bottom:1px solid #dcdcdc">${list.APLCDT}</td>
									<td style="text-align: left; border-bottom:1px solid #dcdcdc; padding-left: 20px;">${list.READNM}</td>
									<td style="text-align: left; border-bottom:1px solid #dcdcdc; padding-left: 20px;">
										<c:choose>
											<c:when test="${not empty list.COMPNM}">${list.COMPNM}</c:when>
											<c:otherwise>&nbsp;</c:otherwise>
										</c:choose>
									</td>
									<td style="text-align: right; border-bottom:1px solid #dcdcdc; padding-right: 20px;">${list.QTY}</td>
									<td style="text-align: center; border-bottom:1px solid #dcdcdc">
									<c:choose>
										<c:when test="${list.STATUS eq '0' }">
											<font color="green"><b>신청</b></font>
										</c:when>
										<c:when test="${list.STATUS eq '1' }">
											<font color="blue"><b>접수</b></font>
										</c:when>
										<c:when test="${list.STATUS eq '4' }">
											<font color="red"><b>중지</b></font>
										</c:when>
										<c:otherwise>
											<font color="navy"><b>정상</b></font>
										</c:otherwise>
									</c:choose>
									</td>
								</tr>
								<c:set var="totalQty" value="${totalQty+list.QTY}" />
							</c:forEach>
							<tr>
								<td colspan="6">&nbsp;</td>
							</tr>
							<tr>
								<td colspan="4" style="text-align: right;"><b>총 확장부수 :</b></td>
								<td style="text-align: right; padding-right: 20px;"><b>${totalQty}</b></td>
								<td>&nbsp;</td>
							</tr>
						</table>
					</c:if>

					</td>
				</tr>
			</table>

		</td>
	</tr>
</table>
</div>

<!-- 이용안내 -->
<div style="width:100%; text-align:center; color:#6f6f6f;" >
<table cellpadding="0" cellspacing="0" width="800" border="0">
	<tr>
		<td align="center">

            <table cellpadding="20" cellspacing="10" width="100%" height="100%" bgcolor="#eaeaea" style="margin-top: 10px;">
				<tr>
					<td width="100%" bgcolor="white" valign="top">	
						<h3>이용안내</h3>
						<table align="center" cellpadding="0" cellspacing="0" width="900" class="table_style1">
							<colgroup>
								<col width="25%" />
							</colgroup>
							<tr>
								<td class="td_style223">
<!-- 									■ 확장실적은 2013년도부터 조회 가능합니다. -->
									■ 실적은 사원확장대회 종료 전까지 매주 업데이트 됩니다.<br>
									■ 확장비는 구독상태 유지여부에 따라 달라지므로 조회된 실적과는 다를 수 있습니다.<br>
									■ 휴대폰번호가 변경된 경우에는 정확한 조회가 되지 않습니다.<br>
									■ 개인 전자판 실적은 신청자가 회원가입, 추천인등록, 정기결제까지 완료돼야 인정됩니다.<br>
									■ 신청일과 진행상태는 데이터 처리과정상 다소 차이가 발생할 수 있습니다.<br>
									  &nbsp; &nbsp;(접수와 정상은 크게 다르지 않으나 중지의 경우 실적 및 확장비 지급대상에서도 제외 됩니다.)
								</td>
							</tr>
						</table>
						
						<h3>서비스 문의</h3>
						<table align="center" cellpadding="0" cellspacing="0" width="900" class="table_style1">
							<colgroup>
								<col width="25%" />
								<col width="75%" />
							</colgroup>
							<tr>
								<td class="td_style11">
									<center><strong>
										접수/ 실적문의<br>
										기업체 전자판 이용문의<br>
										휴대폰번호 변경
									</strong></center>
								</td>
								<td class="td_style22"><strong>02-2000-2038~9</strong></td>
							</tr>
							<tr>
								<td class="td_style13">
									<center><strong>
										신문 구독 불편사항<br>
										개인 전자판 이용문의
									</strong></center>
								</td>
								<td class="td_style23"><strong>02-2000-2000</strong></td>
							</tr>
						</table>

					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</div>
<!--// 이용안내 -->


<div style="width:100%; text-align:center; font-size:12px; padding-top:7px; color:#6f6f6f;" >
	<table >
		<tr>
			<td>
				<img src="/images/mklogo.gif" width="74" height="29" border="0" vspace="10" hspace="10" >
			</td>
			<td>
				Copyright ⓒ 2013 mk.co.kr  All right reserved.<br/>
				이용관련문의 : 02-2000-2038~9  신문구독 불편접수 : 02-2000-2000
			</td>
		</tr>
	</table>
</div>	
</form>