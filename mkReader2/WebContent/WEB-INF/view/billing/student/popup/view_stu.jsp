<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.security.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	String admin_userid = (String) session.getAttribute(ISiteConstant.SESSION_NAME_ADMIN_USERID);
	String agency_userid 	= (String) session.getAttribute(ISiteConstant.SESSION_NAME_AGENCY_USERID);
	
	String menu_auth 	= (String) session.getAttribute(ISiteConstant.SESSION_NAME_MENU_AUTH);
	String login_type 	= (String) session.getAttribute(ISiteConstant.SESSION_NAME_LOGIN_TYPE);

	if ( login_type == null || (admin_userid == null && agency_userid == null) ) {
%>
		<script type="text/javascript">
			alert("로그인한 시간이 오래되어 사이트 보안상\n자동 로그아웃되었습니다. 다시 로그인 해주세요.");
			documnet.parent.location.href="<%= ISiteConstant.URI_LOGIN %>";
			window.close();
		</script><%
		return ;
	}
%>
<!-- H E A D E R  ::  START -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>MK Reader</title>
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet">
<script type="text/javascript">
<!--
function go() {
	
	if (document.frmParent.bank.selectedIndex==0)
	{
		alert("이체은행을 선택해주세요");
		document.frmParent.bank.focus();
		return false;
	}
	if (document.frmParent.bank_num.value.length<10)
	{
		alert("계좌번호는 필수 기재 사항입니다.");
		document.frmParent.bank_num.focus();
		return false;
	}
	if (document.frmParent.bank_own.value.length<1)
	{
		alert("예금주의 주민등록번호 혹은 사업자 등록번호를 기재해 주세요.");
		document.frmParent.bank_own.focus();
		return false;
	}
	return true;
}
//-->
</script>
</head>
<body>
<div class="box_Popup">
	<!-- title -->
	<div class="pop_title_box">학생독자정보</div>
	<!-- //title -->
	<c:choose>
		<c:when test="${empty result}">
			<div style="text-align: center;">
				<br><br><br><br><br><br><br><br><br><br>잘못된 요청입니다.
			</div>
		</c:when>
		<c:otherwise>
			<form name="frmParent" method="post" action="view_db_stu.do" onSubmit="return go();">
			<input type="hidden" name="readno" value="<c:out value='${readno}' />">
				<!-- 구독자정보 -->
				<div style="font-weight: bold; padding: 10px 0 5px 0;">구독자 정보</div>
				<table class="tb_search" style="width: 550px">
					<col width="140px">
					<col width="410px">
					<tr>
					 	<th>구독자 성명/회사명</th>
						<td ><c:out value='${result.READNM}' /></td>
					</tr>									
					<tr>
					 	<th>휴대폰</th>
						<td>
							<c:if test="${not empty result.MOBILE1 and not empty result.MOBILE2 and not empty result.MOBILE3}">
	                       		<c:out value="${result.MOBILE1}" /> - <c:out value="${result.MOBILE2}" /> - <c:out value="${result.MOBILE3}" />
	                       	</c:if>
						</td>
					</tr>						 						
					<tr>
					 	<th>전화번호</th>
						<td >
							<c:if test="${not empty result.HOMETEL1 and not empty result.HOMETEL2 and not empty result.HOMETEL3}">
	                       		<c:out value="${result.HOMETEL1}" /> - <c:out value="${result.HOMETEL2}" /> - <c:out value="${result.HOMETEL3}" />
	                       	</c:if>
						</td>
					</tr>
					<tr>
					 	<th>상세주소</th>
						<td><c:out value="${result.DLVADRS1}" />&nbsp;<c:out value="${result.DLVADRS2}" /></td>
					</tr>	
					<tr>
					 	<th>구독부수</th>
						<td><c:out value="${result.QTY}" /></td>
					</tr>	
					<tr>
					 	<th>이메일</th>
						<td><c:out value="${result.EMAIL}" /></td>
					</tr>									 
							
					<tr>
					 	<th>납부자번호</th>
						<td><c:out value="${result.JIKUK}" /><c:out value="${result.SERIAL}" /></td>
					</tr>						 						 						 						 				 				 				 	
					<tr>
					 	<th>독자번호</th>
						<td><c:out value='${result.READNO}' /></td>
					</tr>
					<tr>
					 	<th>신청일시</th>
						<td><span><c:out value="${result.INDT}" /></span></td>
					</tr>
				</table>  	
				<!-- //구독자정보 -->
				<!-- 납부자정보 -->
				<div style="font-weight: bold; padding: 10px 0 5px 0;">납부자 정보</div>
				<table class="tb_search" style="width: 550px">
					<col width="140px">
					<col width="410px">
				 	<tr>
				 		<th>이체금액</th>
						<td><c:out value="${result.UPRICE}" /></td>
					</tr>
					<tr>
					 	<th>예금주명/법인명</th>
						<td><c:out value='${result.BANK_NAME}' /></td>
					</tr>
					<tr>
					 	<th>이체 은행</th>
						<td>
							<c:choose>
		                        <c:when test="${result.STATUS eq 'EA21' or result.STATUS eq 'EA13'}">
		                        	<c:forEach var="list" items="${bankList}" varStatus="status">
										<c:if test="${list.BANKNUM eq fn:substring(result.BANK,0,3)}">
											<c:out value="${list.BANKNAME}" />
										</c:if>
									</c:forEach>
		                        </c:when>
		                        <c:otherwise>
			                        <select name="bank" size="1" tabindex=7>
										<option value="" selected="selected">----</option>
										<c:forEach var="list" items="${bankList}" varStatus="status">
											<c:choose>
											<c:when test="${list.BANKNUM eq fn:substring(result.BANK,0,3)}">
												<option value="<c:out value='${list.BANKNUM}' />" selected><c:out value="${list.BANKNAME}" /></option>
											</c:when>
											<c:otherwise>
												<option value="<c:out value='${list.BANKNUM}' />"><c:out value="${list.BANKNAME}" /></option>
											</c:otherwise>
											</c:choose>
										</c:forEach>
			                      </select>
		                        </c:otherwise>
	                        </c:choose>
						</td>
					</tr>							
					<tr>
					 	<th>계좌 번호</th>
						<td>
							<c:choose>
		                        <c:when test="${result.STATUS eq 'EA21' or result.STATUS eq 'EA13'}">
									<c:out value='${result.BANK_NUM}' />
		                        </c:when>
		                        <c:otherwise>
			                        <input type="text" name="bank_num" size="41" onkeypress="if((event.keyCode<48)||(event.keyCode>57)) event.returnValue=false;" tabindex="8" value="<c:out value='${result.BANK_NUM}' />" maxlength="16" />
		                        </c:otherwise>
	                        </c:choose>
						</td>
					</tr>
					<tr >
					 	<th >주민등록번호/<br/>사업자등록번호</th>
						<td >
							<c:choose>
		                        <c:when test="${result.STATUS eq 'EA21' or result.STATUS eq 'EA13'}">
									<c:out value='${result.SAUP}' />
		                        </c:when>
		                        <c:otherwise>
			                        <input type="text" name="bank_own" size="41" onkeypress="if((event.keyCode<48)||(event.keyCode>57)) event.returnValue=false;" tabindex="9" value="<c:out value='${result.SAUP}' />" maxlength="13" /><br>
		                        </c:otherwise>
	                        </c:choose>
	                        <br />* 계좌번호 발급시기재된 주민번호
						</td>
					</tr>
					<tr >
					 	<th><font class="box_p">비고/통신란</font><br />"200자 내외 작성"</th>
						<td >
							<c:out value="${result.REMK}" />
						</td>
					</tr>														 	
				</table>					
				<!-- //납부자정보 -->
				<!-- 통화기록 -->			
				<div style="font-weight: bold; padding: 10px 0 5px 0;">통화 기록</div>
				<table class="tb_list_a_5" style="width: 550px">
					<col width="140px">
					<col width="410px">			
				 	<tr>
				 		<th>&nbsp;&nbsp; 통화시간</th>
						<th>통화내용</th>
					</tr>
					<c:choose>
						<c:when test="${empty callList}">
							<tr><td colspan="2">통화 기록이 없습니다.</td></tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="list" items="${callList}">
								<tr>
									<td><c:out value="${list.INDATE}" /></td>
									<td><c:out value="${list.REMK}" /></td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
		 		</table>	
				<!-- //통화기록 -->			
				<div style="width: 550px; text-align: right; padding-top: 10px;">
			  		<c:choose>
					<c:when test="${result.STATUS eq 'EA21' or result.STATUS eq 'EA13'}">
					</c:when>
					<c:otherwise>
						<a href="#fakeUrl" onclick="document.frmParent.submit();"><img src="/images/bt_save.gif" border="0" alt="" /></a>
					</c:otherwise>
					</c:choose>
	            	<a href="#fakeUrl" onclick="window.close();"><img src="/images/bt_close.gif" border="0"  alt="" /></a>
	            </div>
			</form>
		</c:otherwise>
	</c:choose>
</div>
</body>
</html>


