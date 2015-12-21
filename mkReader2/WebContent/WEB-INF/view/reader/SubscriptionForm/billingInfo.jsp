<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<head>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/ajaxUtil.js" charset="UTF-8"></script>
<title>매일경제 자동이체</title>
<style> 
<!--
td {
	font-size: 9pt;
	text-align: justify;
	line-height: 4.5mm
}
 
input {
	border-style: groove;
	font-size: 9pt
}
-->
</style>
</head>
<script type="text/javascript">
	//이용 약관
	function useClauses(){
		billingForm.target="_self";
		billingForm.action="/reader/subscriptionForm/useClauses.do";
		billingForm.submit();
			
	}
	
</script>
<form id="billingForm" name="billingForm" action="" method="post">
<input type="hidden" name="mode">
<table cellpadding="0" cellspacing="0" width="676" height="100%">
	<tr>
		<td width="676" valign="top" height="56">
		<p><img src="/images/logo.gif" width="284" height="56" border="0" onclick="javascript:useClauses();"></p>
		</td>
	</tr>
	<tr>
		<td width="676" valign="top">
		<table cellpadding="0" cellspacing="0" width="676">
			<tr>
				<td width="149">
				<p><a href="/reader/subscriptionForm/billingEdit.do"><img src="/images/m1.gif" width="149" height="35" border=0 onMouseOver='this.src="/images/m1_ov.gif"' onMOuseOut='this.src="/images/m1.gif"'></a></p>
				</td>
				<td width="149">
				<p><a href="#"><img src="/images/m2.gif" width="149" height="35" border=0 onMouseOver='this.src="/images/m2_ov.gif"' onMOuseOut='this.src="/images/m2.gif"'></a></p>
				</td>
				<td width="149"></td>
				<td width="149"></td>
				<td width="3%">
				<p>&nbsp;</p>
				</td>
				<td width="61">
				<p align="center"><a href="javascript:close()"><img src="/images/close.gif" width="45" height="19" border="0"></a></p>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td width="676" valign="top" height="100%">
		<table cellpadding="20" cellspacing="10" width="676" height="100%"
			bgcolor="#C3BDA7">
			<tr>
				<td width="666" bgcolor="white" valign="top">
				<p align="center">   
				<table align="center" cellpadding="0" cellspacing="0" width="605">
					<tr>
						<td height=60></td>
					</tr>
					<tr>
						<td width="605" valign="top">
						<p><img src="/images/t3.gif" width="605" height="29" border="0"></p>
						</td>
					</tr>
					<tr>
						<td height=15></td>
					</tr>
					<tr>
						<td width="1102" height=100%>
						<c:choose>

						<c:when test="${empty billingInfo }">
						<table align="center" cellpadding="7" cellspacing="0" width="605" bgcolor="#DEDBCE">
						<tr>
							<td width="620">
							<table align="center" cellpadding="20" cellspacing="1" width="100%">
								<tr>
									<td width="589" height="50" bgcolor="#F4F1E7">
									<p style="margin-left: 20px;" align="center"><b>요청하신 내용으로
									조회되는 내역이 없습니다.<br>
									<br>
									<b>해당정보를 확인하시고 다시 요청하여 주십시요.<br>
									<br>
									학생독자인 경우에는 <a href="/reader/subscriptionForm/retrieveBillingStu" >여기</a>를 클릭해주세요</b><br>
									<br></p>
									</td>
								</tr>
							</table>
							<br>
							<br>
							<table>
								<tr>
									<td width="1102">
									<p align="center"><font color="#7E7864"><b>&quot; 아직
									자동이체를 신청하지 않으신 신규/기존 독자분들께서는 자동이체 신청을 먼저 해주세요 &quot;</b></font></p>
									</td>
								</tr>
								<tr>
									<td width="1102">
									<p>&nbsp;</p>
									</td>
								</tr>
							</table>
							<center><a href="/reader/subscriptionForm/billingEdit.do"><img src="/images/auto.gif" width="157" height="23" border="0"></a> &nbsp;&nbsp; 
							<img src="/images/back.gif" style="cursor: hand;" onclick="javascript:history.back();"></center>
							</td>
						</tr>
						</table>
						</c:when>
						

						<c:otherwise>
						<table align="center" cellpadding="0" cellspacing="0" width="605">
							<tr>
								<td width="1102">
								<table align="center" cellpadding="7" cellspacing="0" width="605"
									bgcolor="#DEDBCE">
									<tr>
										<td width="620">
										
											<table align="center" cellpadding="0" cellspacing="1" width="100%">
												<tr>
													<td width="110" height="53" bgcolor="#F4F1E7">
													<p style="margin-left: 20px;"><font color="#CC0000"><b>*</b></font><b>
													계좌번호</b></p>
													</td>
													<td width="360" height="53" bgcolor="#F4F1E7">
													<p style="margin-left: 20px;">${billingInfo[0].BANK_NUM }   </p>
													</td>
												</tr>
												<tr>
													<td width="110" height="30" bgcolor="#F4F1E7">
													<p style="margin-left: 20px;"><font color="#CC0000"><b>*</b></font><b>
													예금주명</b></p>
													</td>
													<td width="360" height="30" bgcolor="#F4F1E7">
													<p style="margin-left: 20px;">${billingInfo[0].USERNAME }</p>
													</td>
												</tr>
											</table>
										
										</td>
									</tr>
								</table>
								</td>
							</tr>
							<tr>
								<td width="1102">
								<p>&nbsp;</p>
								</td>
							</tr>
							<tr>
								<td width="1102">
								<p>&nbsp;</p>
								</td>
							</tr>
							<tr>
								<td width="1102">
								<table align="center" cellpadding="0" cellspacing="1" width="605">
									<tr>
										<td width="51" height="25" bgcolor="#DEDBCE">
										<p align="center">NO</p>
										</td>
										<td width="103" height="25" bgcolor="#DEDBCE">
										<p align="center">이체일</p>
										</td>
										<td width="55" height="25" bgcolor="#DEDBCE">
										<p align="center">은행명</p>
										</td>
										<td width="114" height="25" bgcolor="#DEDBCE">
										<p align="center">계좌번호</p>
										</td>
										<td width="100" height="25" bgcolor="#DEDBCE">
										<p align="center">출금액</p>
										</td>
										<td width="73" height="25" bgcolor="#DEDBCE">
										<p align="center">지국</p>
										</td>
										<td width="100" height="25" bgcolor="#DEDBCE">
										<p align="center">상태</p>
										</td>
									</tr>
									<c:choose>
									<c:when test="${empty paymentHist }">
									<tr>
										<td colspan="8" height="55" bgcolor="#DEDBCE">
										<p align="center">아직 이체 내역이 없습니다.</p>
										</td>
									</tr>
									</c:when>
									<c:otherwise>
									<c:forEach items="${paymentHist }" var="list">
										<tr>
											<td height="25" bgcolor="#DEDBCE">
											<p align="center">${list.SERIALNO }</p>
											</td>
											<td height="25" bgcolor="#DEDBCE">
											<p align="center">${list.CMSDATE }</p>
											</td>
											<td height="25" bgcolor="#DEDBCE">
											<p align="center">${list.BANKNAME }</p>
											</td>
											<td height="25" bgcolor="#DEDBCE">
											<p align="center">${list.BANK_NUM }</p>
											</td>
											<td height="25" bgcolor="#DEDBCE">
											<p align="center"><fmt:formatNumber value="${list.CMSMONEY}" type="number" pattern="#,###.##" /></p>
											</td>
											<td height="25" bgcolor="#DEDBCE">
											<p align="center">${list.JIKUKNM }</p>
											</td>
											<td height="25" bgcolor="#DEDBCE">
											<p align="center">${list.CMSRESULTMSG }</p>
											</td>
										</tr>
									</c:forEach>
									</c:otherwise>
									</c:choose>
									
									
									
									
								</table>
								</td>
							</tr>
						</table>
											
						</c:otherwise>
						</c:choose>




						</td>
					</tr>
				</table>
				   </p>
				</td>
			</tr>
 
		</table>
		</td>
	</tr>
	<tr>
		<td bgcolor="#C3BDA7">
		<table cellpadding="0" cellspacing="0" width="636" align="center">
			<tr>
				<td width="130">
				<table align="center" cellpadding="0" cellspacing="0" bgcolor="white">
					<tr>
						<td>
						<p align="center"><img src="/images/mklogo.gif" width="74" height="29" border="0" vspace="10" hspace="10"></p>
						</td>
					</tr>
				</table>
				</td>
				<td width="506" colspan="2">
				<table align="center" width="506" cellpadding="0" cellspacing="0">
					<tr>
						<td colspan="2" width="506">
						<p style="margin-top: 5px;">Copyright&copy; 2006. 매경인터넷(주).
						서울특별시 중구 필동 1가 30-1 매경미디어센터 9층.<br>
						매경인터넷은 회원의 허락없이 개인정보를 수집, 공개, 유출을 하지 않으며 회원정보의 <br>
						보호를 위해 최선을 다합니다.</p>
						</td>
					</tr>
					<tr>
						<td width="386">
						<p style="margin-bottom: 5px;">사업자 등록번호 : 201-81-25980 / 통신판매업
						신고 : 중구00083호 &nbsp;<br>
						이용관련문의 : 02-2000-2000&nbsp;</p>
						</td>
						<td width="120" valign="top">
						</td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
		
</form>