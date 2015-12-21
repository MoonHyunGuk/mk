<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!-- H E A D E R  ::  START -->
<html>
<head>
<title>MK Reader - student</title>

</head>
<body>
<script language=javascript src='/js/mini_calendar.js'></script>
<script language="JavaScript">
<!--
function goPost() {                                    
    window.open("/services/cust_findpost01.do", "postHome", "width=460,height=250,scrollable=yes,resizable=no");
}
function go() {
	if (document.frmParent.username.value.length<1)
	{
		alert("구독자 성명/회사명은 필수 기재 사항입니다.");
		document.frmParent.username.focus();
		return false;
	}
	if (document.frmParent.handy_1.value.length<1)
	{
		alert("연락처는 필수 기재 사항입니다.");
		document.frmParent.handy_1.focus();
		return false;
	}
	if (document.frmParent.zip2.value.length<1)
	{
		alert("우편번호및 주소를 우편번호 찾기를 이용하여 입력해주세요.");
		goPost();
		return false;
	}
	if (document.frmParent.addr2.value.length<1)
	{
		alert("상세주소는 필수 기재 사항입니다.");
		document.frmParent.addr2.focus();
		return false;
	}

	if (document.frmParent.bank_username.value.length<1)
	{
		alert("예금주명은 필수 기재 사항입니다.");
		document.frmParent.bank_username.focus();
		return false;
	}
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
	function price() {
		idx1 = 7500;
		idx2 = document.frmParent.busu.value;

		document.frmParent.bank_money.value = eval( idx1 * idx2 );
	}
//-->
</script>

<c:choose>
<c:when test="${empty result}">
	<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
	<center>잘못된 요청입니다.</center>
</c:when>
<c:otherwise>
		
	<form name="frmParent" method="post" action="view_db_stu.do" onsubmit="return go();">
	<input type="hidden" name="numid" value="<c:out value='${result.numid}' />"/>
	<input type="hidden" name="view" value="<c:out value='${result.view}' />"/>
	<input type="hidden" name="view2" value="<c:out value='${result.view2}' />"/>
	<input type="hidden" name="page" value="<c:out value='${result.page}' />"/>
	<input type="hidden" name="orderby" value="<c:out value='${result.orderby}' />"/>
	<input type="hidden" name="orders" value="<c:out value='${result.orders}' />"/>
	<input type="hidden" name="searchkey" value="<c:out value='${result.searchkey}' />"/>
	<input type="hidden" name="searchtype" value="<c:out value='${result.searchtype}' />"/>
	<input type="hidden" name="search_state" value="<c:out value='${result.search_state}' />"/>
	<table align="center" cellpadding="0" cellspacing="0" width="605">
	    <tr>
	        <td width="605" valign="top">
	                <p><img src="/services/images/t2_stu.gif" width="605" height="29" border="0"/></p>
	        </td>
	    </tr>
	    <tr>
	        <td width="605" valign="top">
	            <p>&nbsp;</p>
	        </td>
	    </tr>
	    <tr>
	        <td width="605" valign="top">
	                        <p><b><font color="#CC0000">* 필수 기재란 입니다.</font></b></p>
	        </td>
	    </tr>
	    <tr>
	        <td width="605" valign="top">
	            <table align="center" cellpadding="0" cellspacing="1" width="605">
	                <tr>
	                    <td width="603" height="5" bgcolor="#AEA78B" colspan="2">
	                    </td>
	                </tr>
	                <tr>
	                    <td width="603" height="30" bgcolor="#DEDBCE" colspan="2">
	
	                        <p style="margin-left:20px;" align="center"><b><input type="radio" name="intype" style="border-style:none;" value="기존" <c:if test="${result.intype ne '신규' }">checked</c:if>/>기존고객 
	                        &nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="intype" style="border-style:none;" value="신규" <c:if test="${result.intype eq '신규' }">checked</c:if>/>신규고객</b></p>
	
	                    </td>
	                </tr>
	                <tr>
	                    <td width="166" height="30" bgcolor="#DEDBCE">
	                        <p style="margin-left:20px;">
								<font color="#CC0000"><b><img src="images/i.gif" width="9" height="9" border="0"></b></font><b> 대학명</b>
	                        </p>
	                    </td>
	                    <td width="436" height="30" bgcolor="#F4F1E7">
	                        <p style="margin-left:10px;"><input type="text" name="stu_sch" tabindex=1 maxlength=30 value="<c:out value='${result.stu_sch}' />"></p>
	                    </td>
	                </tr>
	                <tr>
	                    <td width="166" height="30" bgcolor="#DEDBCE">
	                        <p style="margin-left:20px;">
								<font color="#CC0000"><b><img src="images/i.gif" width="9" height="9" border="0"></b></font><b> 학과</b>
	                        </p>
	                    </td>
	                    <td width="436" height="30" bgcolor="#F4F1E7">
	                        <p style="margin-left:10px;"><input type="text" name="stu_part" tabindex=1 maxlength=30 value="<c:out value='${result.stu_part}' />"></p>
	                    </td>
	                </tr>
	                <tr>
	                    <td width="166" height="30" bgcolor="#DEDBCE">
	                        <p style="margin-left:20px;">
								<font color="#CC0000"><b><img src="images/i.gif" width="9" height="9" border="0"></b></font><b> 학년</b>
	                        </p>
	                    </td>
	                    <td width="436" height="30" bgcolor="#F4F1E7">
	                        <p style="margin-left:10px;"><input type="text" name="stu_class" tabindex=1 maxlength=2 value="<c:out value='${stu_class}' />"></p>
	                    </td>
	                </tr>                
	                <tr>
	                    <td width="166" height="30" bgcolor="#DEDBCE">
	                        <p style="margin-left:20px;"><font color="#CC0000"><b>*</b></font><b> 성명</b></p>
	                    </td>
	                    <td width="436" height="30" bgcolor="#F4F1E7">
	                        <p style="margin-left:10px;"><input type="text" name="username" tabindex=1 value="<c:out value='${result.username}' />" maxlength=30></p>
	                    </td>
	                </tr>
	                <tr>
	                    <td width="166" height="30" bgcolor="#DEDBCE">
	                        <p style="margin-left:20px;"><b><font color="#CC0000">* 
	                        </font> 휴대폰<br></b></p>
	                    </td>
	                    <td width="436" height="30" bgcolor="#F4F1E7">
	                        <p style="margin-top:4px; margin-left:10px;">
	                        	<c:set var="dphone" value="${fn:split(result.phone, '-')}" />
	                        	<c:set var="dhandy" value="${fn:split(result.handy, '-')}" />
	                        	<select name="handy_1" style="border-style:none;" tabindex=10>
									<option value="" selected>----</option>
									<option value="010"<c:if test="${dhandy[0] eq '010'}"> selected</c:if>>010</option>
									
									<option value="011"<c:if test="${dhandy[0] eq '011'}"> selected</c:if>>011</option>
									<option value="016"<c:if test="${dhandy[0] eq '016'}"> selected</c:if>>016</option>
									<option value="017"<c:if test="${dhandy[0] eq '017'}"> selected</c:if>>017</option>
									<option value="018"<c:if test="${dhandy[0] eq '018'}"> selected</c:if>>018</option>
									<option value="019"<c:if test="${dhandy[0] eq '019'}"> selected</c:if>>019</option>
									<option value="0130"<c:if test="${dhandy[0] eq '0130'}"> selected</c:if>>0130</option>
								</select>- 
								<input type="text" name="handy_2" maxlength="4" size="4" tabindex=11 value="<c:out value='${dhandy[1]}' />"> 
	                        	- <input type="text" name="handy_3" maxlength="4" size="4" tabindex=12 value="<c:out value='${dhandy[2]}' />">                    
						</td>
	                </tr>                
	                <tr>
	                    <td width="166" height="30" bgcolor="#DEDBCE">
	                        <p style="margin-left:20px;"><font color="#CC0000"><b>*</b></font><b> 전화번호</b></p>
	                    </td>
	                    <td width="436" height="30" bgcolor="#F4F1E7">
	                        <p style="margin-top:4px; margin-left:10px;">
	                        	<select name="tel_1" style="border-style:none;" tabindex=2>
									<option value="" selected>----</option>
									<option value="02"<c:if test="${dphone[0] eq '02'}" > selected</c:if>>02</option>
									
									
									<option value="031"<c:if test="${dphone[0] eq '031'}" > selected</c:if>>031</option>
									<option value="032"<c:if test="${dphone[0] eq '032'}" > selected</c:if>>032</option>
									<option value="033"<c:if test="${dphone[0] eq '033'}" > selected</c:if>>033</option>
									<option value="041"<c:if test="${dphone[0] eq '041'}" > selected</c:if>>041</option>
									<option value="042"<c:if test="${dphone[0] eq '042'}" > selected</c:if>>042</option>
									<option value="043"<c:if test="${dphone[0] eq '043'}" > selected</c:if>>043</option>
									<option value="051"<c:if test="${dphone[0] eq '051'}" > selected</c:if>>051</option>
									<option value="052"<c:if test="${dphone[0] eq '052'}" > selected</c:if>>052</option>
									<option value="053"<c:if test="${dphone[0] eq '053'}" > selected</c:if>>053</option>
									<option value="054"<c:if test="${dphone[0] eq '054'}" > selected</c:if>>054</option>
									<option value="055"<c:if test="${dphone[0] eq '055'}" > selected</c:if>>055</option>
									<option value="061"<c:if test="${dphone[0] eq '061'}" > selected</c:if>>061</option>
									<option value="062"<c:if test="${dphone[0] eq '062'}" > selected</c:if>>062</option>
									<option value="063"<c:if test="${dphone[0] eq '063'}" > selected</c:if>>063</option>
									<option value="064"<c:if test="${dphone[0] eq '064'}" > selected</c:if>>064</option>
									<option value="0502"<c:if test="${dphone[0] eq '0502'}" > selected</c:if>>0502</option>
								</select> - 
								<input type="text" name="tel_2" maxlength="4" size="4" tabindex=3 value="<c:out value='${dphone[1]}' />"> 
	                        	- <input type="text" name="tel_3" maxlength="4" size="4" tabindex=4 value="<c:out value='${dphone[2]}' />">                    
						</td>
	                </tr>
	                <tr>
	                    <td width="166" height="30" bgcolor="#DEDBCE">
	                        <p style="margin-left:20px;"><font color="#CC0000"><b>*</b></font><b> 우편번호</b></p>
	                    </td>
	                    <td width="436" height="30" bgcolor="#F4F1E7">
	                        <table cellpadding="0" cellspacing="0" width="90%" style="margin-left:10px;">
	                            <tr>
	                                <td width="486">                        <p><input type="text" name="zip1" maxlength="3" size="3" style="cursor:hand;" onClick='goPost();' readonly value="<c:out value='${result.zip1}' />"> 
	                                    - <input type="text" name="zip2" maxlength="3" size="3" style="cursor:hand;" onClick='goPost();' readonly value="<c:out value='${result.zip2}' />">&nbsp;
	                                    <img src="/services/images/zip_chk.gif" align="absmiddle" border="0" hspace="5" style="cursor:hand;" onClick='goPost();'></p>
	                                </td>
	                            </tr>
	                        </table>
	                    </td>
	                </tr>
	                <tr>
	                    <td width="166" height="30" bgcolor="#DEDBCE">
	                        <p style="margin-left:20px;"><font color="#CC0000"><b>*</b></font><b> 상세주소</b></p>
	                    </td>
	                    <td width="436" height="30" bgcolor="#F4F1E7">
	                        <table cellpadding="0" cellspacing="0" width="90%" style="margin-left:10px;">
	                            <tr>
	                                <td width="486">                        <p><input type="text" name="addr1" size="41" readonly style="cursor:hand;" onClick='goPost();' value="<c:out value='${result.addr1}' />"></p>
	                                </td>
	                            </tr>
	                            <tr>
	                                <td width="486">                        <p><input type="text" name="addr2" size="54" tabindex=5 value="<c:out value='${result.addr2}' />"></p>
	                                </td>
	                            </tr>
	                        </table>
	                    </td>
	                </tr>
	<SCRIPT LANGUAGE="JavaScript">
	<!--
		function chjikuk() {
	//		document.frmParent.jikuk_a.selectedIndex
			document.frmParent.user_number1.value = document.frmParent.jikuk_a.value;
	//		document.frmParent.user_number1.value = "999999";
		}
	//-->
	</SCRIPT>
					<tr>
	                    <td width="166" height="49" bgcolor="#DEDBCE">
	                        <p style="margin-left:20px;"> <b>&nbsp;&nbsp;<br></b></p>
	                    </td>
	                    <td width="436" height="49" bgcolor="#F4F1E7">
							<p style="margin-left:10px;">
							<input name="rdate" type="checkbox" value="<c:out value='${result.rdate}' />" <c:if test="${not empty result.rdate}">checked</c:if>>지국통보여부(<c:out value='${result.rdate}' />)
							<select name="jikuk_a" onchange="chjikuk();">
							<c:choose>
							<c:when test="${result.status ne 'EA21'}">
								<c:forEach items="${jikukList}" var="list" varStatus="status">
									<c:choose>
									<c:when test="${result.jikuk eq list.serial}">
										<option value="<c:out value='${list.serial}' />" selected><c:out value="${list.name}" /></option>
									</c:when>
									<c:otherwise>
										<option value="<c:out value='${list.serial}' />"><c:out value="${list.name}" /></option>
									</c:otherwise>
									</c:choose>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<c:choose>
								<c:when test="${not empty jikukList}">
									<c:forEach items="${jikukList}" var="list" varStatus="status">
										<option value="<c:out value='${list.serial}' />" selected><c:out value="${list.name}" /></option>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<option value="<c:out value='${result.jikuk}' />">지국DB에서 삭제되었습니다.</option>
								</c:otherwise>
								</c:choose>
								
							</c:otherwise>
							</c:choose>
							</select>
							</p>
	                    </td>
	                </tr>
	                <tr>
	                    <td width="166" height="30" bgcolor="#DEDBCE">
	                        <p style="margin-left:20px;"><font color="#CC0000"><b><img src="images/i.gif" width="9" height="9" border="0"></b></font><b> 구독부수</b></p>
	                    </td>
	                    <td width="436" height="30" bgcolor="#F4F1E7">
	                        <p style="margin-left:10px;">
	                        <select name="busu" onchange="price();">
	                        <c:forEach var="i" begin="1" end="99" step="1">
	                        	<option value="<c:out value='${i}' />"<c:if  test="${result.busu eq i}"> selected</c:if>><c:out value="${i}" /></option>
	                        </c:forEach>
	                        </select></p>
	                    </td>
	                </tr>
	                <tr>
	                    <td width="166" height="30" bgcolor="#DEDBCE">
	                        <p style="margin-left:20px;"> 
	                        <b>&nbsp;&nbsp;이메일</b></p>
	                    </td>
	                    <td width="436" height="30" bgcolor="#F4F1E7">
	                      
	                        <p style="margin-left:10px;"><input type="text" name="email" size="41" tabindex=14 value="<c:out value='${result.email}' />"></p>
	                    </td>
	                </tr>
	                <tr>
	                    <td width="166" height="30" bgcolor="#DEDBCE">
	                        <p style="margin-left:20px;">
								<font color="#CC0000"><b><img src="images/i.gif" width="9" height="9" border="0"></b></font><b> 추천교수</b>
	                        </p>
	                    </td>
	                    <td width="436" height="30" bgcolor="#F4F1E7">
	                        <p style="margin-left:10px;"><input type="text" name="stu_prof" tabindex=1 maxlength=30 value="<c:out value='${result.stu_prof}' />"></p>
	                    </td>
	                </tr>
	                <tr>
	                    <td width="166" height="30" bgcolor="#DEDBCE">
	                        <p style="margin-left:20px;">
								<font color="#CC0000"><b><img src="images/i.gif" width="9" height="9" border="0"></b></font><b> 권유자</b>
	                        </p>
	                    </td>
	                    <td width="436" height="30" bgcolor="#F4F1E7">
	                        <p style="margin-left:10px;"><input type="text" name="stu_adm" tabindex=1 maxlength=30 value="<c:out value='${result.stu_adm}' />"></p>
	                    </td>
	                </tr>
	                <tr>
	                    <td width="166" height="30" bgcolor="#DEDBCE">
	                        <p style="margin-left:20px;">
								<font color="#CC0000"><b><img src="images/i.gif" width="9" height="9" border="0"></b></font><b> 통화자</b>
	                        </p>
	                    </td>
	                    <td width="436" height="30" bgcolor="#F4F1E7">
	                        <p style="margin-left:10px;"><input type="text" name="stu_caller" tabindex=1 maxlength=30 value="<c:out value='${result.stu_caller}' />"></p>
	                    </td>
	                </tr>                                                
					<tr>
	                    <td width="166" height="49" bgcolor="#DEDBCE">
	                        <p style="margin-left:20px;"> <b>&nbsp;&nbsp;납부자번호<br></b></p>
	                    </td>
	                    <td width="436" height="49" bgcolor="#F4F1E7">
	                        <p style="margin-left:10px;"><input type="text" name="user_number1" tabindex=99 value="<c:out value='${result.jikuk}' />" maxlength="6" size="6" readonly style="border:none;" dir="rtl">
							<input type="text" name="user_number2" tabindex=5 value="<c:out value='${result.serial}' />" maxlength=5 size="6"<c:if test="${result.status eq 'EA21'}">readonly</c:if>>
							&nbsp;&nbsp;&quot;매일경제신문사 기재란 입니다&quot;</p>
	                    </td>
	                </tr>
					<tr>
	                    <td width="166" height="49" bgcolor="#DEDBCE">
	                        <p style="margin-left:20px;"> <b>&nbsp;&nbsp;지국독자번호<br></b></p>
	                    </td>
	                    <td width="436" height="49" bgcolor="#F4F1E7">
	                        <p style="margin-left:10px;"><input type="text" name="readno" tabindex=5 value="<c:out value='${result.readno}' />" maxlength=5 size="6">&nbsp;&nbsp;&quot;매일경제신문사 기재란 입니다&quot;</p>
	                    </td>
	                </tr>
					<tr>
	                    <td width="166" height="49" bgcolor="#DEDBCE">
	                        <p style="margin-left:20px;"> <b>&nbsp;&nbsp;신청일시<br></b></p>
	                    </td>
	                    <td width="436" height="49" bgcolor="#F4F1E7">
	                        <p style="margin-left:10px;"><%=rs("indate")%></p>
	                    </td>
	                </tr>			
				</table>
	        </td>
	    </tr>
	    <tr>
	        <td width="605" valign="top">
	            <p>&nbsp;</p>
	        </td>
	    </tr>
	    <tr>
	        <td width="605" valign="top">
	            <table width="605" cellpadding="0" cellspacing="0" height="29" background="/services/images/title_bg.gif">
	                <tr>
	                    <td width="620">
	                        <p style="margin-left:20px;"><b>납부자 정보</b></p>
	                    </td>
	                </tr>
	            </table>
	        </td>
	    </tr>
	    <tr>
	        <td width="605" valign="top">
	            <p>&nbsp;</p>
	        </td>
	    </tr>
	    <tr>
	        <td width="605" valign="top">
	            <p><b><font color="#CC0000"><img src="images/i.gif" width="9" height="9" border="0"> 익월 5일 출금</font></b></p>
	        </td>
	    </tr>       
	    <tr>
	        <td width="605" valign="top" height="382">
	            <table align="center" cellpadding="0" cellspacing="1" width="605">
	                <tr>
	                    <td width="603" height="5" colspan="2" bgcolor="#AEA78B">
	                        <input type="hidden" name="gubun" tabindex=6 value="학생">
	                    </td>
	                </tr>
					<tr>
	                    <td width="166" height="30" bgcolor="#DEDBCE">
	                        <p style="margin-left:20px;"><b><font color="#CC0000">* </font> 이체금액</b></p>
	                    </td>
	                    <td width="436" height="30" bgcolor="#F4F1E7">
	                        <p style="margin-left:10px;"><input type="text" name="bank_money" tabindex=6 value="<c:out value='${result.bank_money}' />" maxlength=13 ONKEYPRESS="if((event.keyCode<48)||(event.keyCode>57)) event.returnValue=false;" ></p>
	                    </td>
	                </tr>
					<tr>
	                    <td width="166" height="30" bgcolor="#DEDBCE">
	                        <p style="margin-left:20px;"><b><font color="#CC0000">* </font> 예금주명</b></p>
	                    </td>
	                    <td width="436" height="30" bgcolor="#F4F1E7">
	                        <p style="margin-left:10px;"><input type="text" name="bank_username" tabindex=6 value="<c:out value='${result.bank_name}' />" maxlength=30></p>
	                    </td>
	                </tr>
	                <tr>
	                    <td width="166" height="30" bgcolor="#DEDBCE">
	                        <p style="margin-left:20px;"><b><font color="#CC0000">* 
	                        </font>이체 은행</b></p>
	                    </td>
	                    <td width="436" height="30" bgcolor="#F4F1E7">
	                        <p style="margin-top:4px; margin-left:10px;">
	                        <select name="bank" size="1" tabindex=7>
								<option value="" selected>----</option>
								<c:forEach var="list" items="${bankList}" varStatus="status">
									<c:choose>
									<c:when test="${list.banknum eq fn:substring(result.bank,0,3)}">
										<option value="<c:out value='${list.banknum}' />" selected><c:out value="${list.bankname}" /></option>
									</c:when>
									<c:otherwise>
										<option value="<c:out value='${list.banknum}' />"><c:out value="${list.bankname}" /></option>
									</c:otherwise>
									</c:choose>
								</c:forEach>
	                      </select>                    
                      </td>
	                </tr>
	                <tr>
	                    <td width="166" height="30" bgcolor="#DEDBCE">
	                        <p style="margin-left:20px;"><b><font color="#CC0000">* 
	                        </font>계좌 번호</b></p>
	                    </td>
	                    <td width="436" height="30" bgcolor="#F4F1E7">
	                        <p style="margin-left:10px;"><input type="text" name="bank_num" size="41" ONKEYPRESS="if((event.keyCode<48)||(event.keyCode>57)) event.returnValue=false;" tabindex=8 value="<c:out value='${result.bank_num}' />" maxlength=16></p>
	                    </td>
	                </tr>
	                <tr>
	                    <td width="166" height="50" bgcolor="#DEDBCE">
	                        <p style="margin-left:20px;"><b><font color="#CC0000">* 
	                        </font>주민등록번호</b></p>
	                    </td>
	                    <td width="436" height="50" bgcolor="#F4F1E7">
	                        <p style="margin-left:10px;"><input type="text" name="bank_own" size="41" ONKEYPRESS="if((event.keyCode<48)||(event.keyCode>57)) event.returnValue=false;" tabindex=9 value="<c:out value='${result.saup}' />" maxlength=13><br>&quot; 
	                        계좌번호 발급시 기재된 주민번호</p>
	                    </td>
	                </tr>
	
	                <tr>
	                    <td width="166" height="30" bgcolor="#DEDBCE">
	                        <p style="margin-left:20px;"> 
	<b>&nbsp;&nbsp;이체시작월<br></b></p>
	                    </td>
	                    <td width="436" height="30" bgcolor="#F4F1E7">
	                      
	                        <p style="margin-left:10px;"><input type="text" name="sdate" size="12" tabindex=14 value="<c:out value='${result.sdate}' />" readonly onclick="Calendar(this)"></td>
	                </tr>
	                <tr>
	                    <td width="166" height="140" bgcolor="#DEDBCE">
	                        <p style="margin-left:20px;"> 
	                        <b>&nbsp;&nbsp;비고/통신란<br> &nbsp;&nbsp;</b>&quot; 200자 내외 작성 &quot;</p>
	                    </td>
	                    <td width="436" height="140" bgcolor="#F4F1E7">
	                        <p style="margin-left:10px;"><textarea name="memo" rows="8" cols="57" tabindex=15><c:out value="${result.memo}" /></textarea>                    </td>
	                </tr>
	            </table>
	        </td>
	    </tr>
	    <tr>
	        <td width="605" valign="top">
	            <p>&nbsp;</p>
	        </td>
	    </tr>
	    <tr>
	        <td width="605" valign="top">
	            <p align="center"><input type="submit" value=" 수 정 " border="0" tabindex=16>&nbsp;&nbsp;<input type="button"  value="   돌아가기   " onclick="history.go(-1);" id=button1 name=button1> </p>
	        </td>
	    </tr>
	</table>
	</form>
</c:otherwise>
</c:choose>
</body>
</html>


