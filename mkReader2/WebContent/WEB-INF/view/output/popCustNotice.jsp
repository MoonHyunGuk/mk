<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.security.*" %>

<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	String admin_userid = (String) session.getAttribute(ISiteConstant.SESSION_NAME_ADMIN_USERID);
	String agency_userid 	= (String) session.getAttribute(ISiteConstant.SESSION_NAME_AGENCY_USERID);
	
	String login_type 	= (String) session.getAttribute(ISiteConstant.SESSION_NAME_LOGIN_TYPE);

	if ( login_type == null || (admin_userid == null && agency_userid == null) ) {
		%><script language="JavaScript">
		<!--
			alert("로그인한 시간이 오래되어 사이트 보안상\n자동 로그아웃되었습니다. 다시 로그인 해주세요.");
			location.href="<%= ISiteConstant.URI_LOGIN %>";
		//-->
		</script><%
		return ;
	}

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<title>고객 안내문</title>
<link rel='stylesheet' type='text/css' href='/css/mkcrm.css'>

<SCRIPT LANGUAGE="JavaScript">

/*----------------------------------------------------------------------
 * Desc   : 표의 ROW클릭시 INPUT박스에 해당ROW의 데이타 표시
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncSelAction(code){
	frmInfo.code.value = code;
	frmInfo.action = "/output/billOutput/popCustNotiView.do";
    frmInfo.submit();
}

/*----------------------------------------------------------------------
 * Desc   :  INPUT박스를 초기화 시킨다.
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function doReset(){
	/*frmInfo.code.value ="";*/
	frmInfo.giro.value = "";
	frmInfo.visit.value = "";
}

/*----------------------------------------------------------------------
 * Desc   : 등록 기능을 수행한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function doIns(){
	 var code = frmInfo.code.value;
	 
	 if(code == "" || code == null){
		 alert("코드를 입력해주세요(01~99)");
		 frmInfo.code.focus();
		 return;
	 }
	 
	 con=confirm(code+" 코드를 추가하시겠습니까?");
	    if(con==false){
	        return;
		}else{
	        frmInfo.action = "/output/billOutput/custNotiInsert.do";
	        frmInfo.submit();
		}	
}

/*----------------------------------------------------------------------
 * Desc   : 수정 기능을 수행한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function doMod(){
	 var code = frmInfo.code.value;
	 
	 if(code == "" || code == null){
		 alert("수정할 코드를 선택해주세요");
		 frmInfo.code.focus();
		 return;
	 }
	 
	 
	 con=confirm(code+" 코드를 수정하시겠습니까?");
	    if(con==false){
	        return;
		}else{
	        frmInfo.action = "/output/billOutput/custNotiModify.do";
	        frmInfo.submit();
		}	
}

/*----------------------------------------------------------------------
 * Desc   : 삭제 기능을 수행한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function doDel(){
	 var code = frmInfo.code.value;
	 
	 if(code == "" || code == null){
		 alert("삭제할 코드를 선택해주세요");
		 frmInfo.code.focus();
		 return;
	 }
	 
	 con=confirm(code+" 코드를 삭제하시겠습니까?");
	    if(con==false){
	        return;
 		}else{
	        frmInfo.action = "/output/billOutput/custNotiDelete.do";
	        frmInfo.submit();
 		}	
}

/*----------------------------------------------------------------------
 * Desc   : 숫자만 입력가능하도록 제어한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function inputNumCom(){
	 var keycode = event.keyCode;
	 
	 if( !((48 <= keycode && keycode <=57) || keycode == 13 || keycode == 46) ){
	  alert("숫자만 입력 가능합니다.");
	  event.keyCode = 0;  // 이벤트 cancel
	 }
	}

</SCRIPT>
</head>

<body topmargin="0" leftmargin="0">
	<table width="100%" height="25" border="0" cellspacing="0" cellpadding="0" >
		<tr>
			<td colspan="2" height="25" bgcolor="f48d2e" align="left"  class="box_m"><b>고객 안내문</b></td>
		</tr>
	</table>
	<form id= "frmInfo" name = "frmInfo" method="post">			
		<table width="100%"   cellpadding="2" cellspacing="1" border="0" class="b_01">
			<tr>
				<td width="35%" valign="top">					
					<table width="120" cellpadding="3" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01"  valign="top">
					  <tr align="center" class="box_p" >
					    <td bgcolor="f9f9f9" width="70" >코 드</td>
					    <td bgcolor="ffffff" width="50" ><input type="text" name="code"  class='box_n'  value="<c:out value="${notiDtl.CODE}"/>" style="ime-Mode:disabled; text-align:center" maxLength = "2" onKeyPress="inputNumCom();"  readonly /></td>
					  </tr>					  						  						  						  						  						  						  		   
					</table>	
				<td width="1%"></td>
				<td>
					<table width="100%" cellpadding="0" cellspacing="0" border="0" class="b_01"  valign="top">
				  	    <tr align="right">
				     	   <td colspan='4'  bgcolor="ffffff">
							<!--    <a href="javascript:doIns()"><img src="/images/bt_save.gif" border="0" align="absmiddle"></a>  -->
								<a href="javascript:doMod()"><img src="/images/bt_save.gif" border="0" align="absmiddle"></a> 
							<!--	<a href="javascript:doDel()"><img src="/images/bt_delete.gif" border="0" align="absmiddle"></a>  -->
								<a href="javascript:doReset()"><img src="/images/bt_cancle.gif" border="0" align="absmiddle"></a> 
						   </td>
						</tr>
			    	</table>
				</td>
			</tr>
			<tr>
				<td>
					<table width="100%" cellpadding="5" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01"  valign="top">
					  <tr bgcolor="f9f9f9" align="center" class="box_p" >
					    <td>지로 영수증</td>
					  </tr>			
					  <tr align="center" class="box_p" >
					    <td bgcolor="ffffff"><textarea rows="16" cols="23" name="giro"  style="overflow:hidden"><c:out value="${notiDtl.GIRO}"/></textarea></td>
					  </tr>							  						  						  						  						  						  		   
					</table>		
					<table width="100%" cellpadding="5" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01"  valign="top">
					  <tr bgcolor="f9f9f9" align="center" class="box_p" >
					    <td>방문 영수증</td>
					  </tr>			
					  <tr align="center" class="box_p" >
					    <td bgcolor="ffffff"><textarea rows="7" cols="14" name="visit"  style="overflow:hidden"><c:out value="${notiDtl.VISIT}"/></textarea></td>
					  </tr>	  						  						  						  						  						  						  		   
					</table>		
				</td>
				
				<td width="1%"></td>
				
				<!-- 리스트 -->
				<td width="59%"  valign="top">
					<table width="100%" cellpadding="4" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01"  valign="top">
				  	    <tr bgcolor="f9f9f9" align="center" class="box_p" >
			                <th>코드</th>
				            <th>지로영수증</th>
				            <th>방문영수증</th>				   
					    </tr>
					  
					<c:if test="${empty noti}">
			            <tr>
			               <td colspan="4" align="center">등록된 코드가 없습니다.</td>
			            </tr>
			        </c:if>
			        
			        <c:if test="${!empty noti}">        
			        <c:forEach items="${noti}" var="list"  varStatus="status">
						<tr id="oTr<c:out value="${status.count}"/>" bgcolor="ffffff" align="center"  style="cursor:hand;" onclick="fncSelAction('${list.CODE}')">
							<td  height="20" style="text-align:center;">${list.CODE }</td>
							<td  height="20" style="text-align:left">${list.GIRO }</td>
							<td  height="20" style="text-align:left;">${list.VISIT }</td>
						</tr>
				    </c:forEach>				
			        </c:if>
			    	</table>
			    	<br>※ 영수증별 안내문 내용은 좌측 칸에 맞추어 입력해 주세요.
			    	<br>&nbsp;&nbsp;&nbsp;&nbsp;개별영수증 출력시에는 '01'코드에 등록된 내용이 표기됩니다.
				</td>
			</tr>
		</table>
	</form>
	
	<!-- footer start -->
	<table width="100%" height="15" cellpadding="0" cellspacing="0" bgcolor="cfcfcf">
		<tr valign="bottom">
			<td align="center" class="b01"><b>MAEIL BUSINESS NEWSPAPER</b></td>
		</tr>
	</table>
	<!-- footer end -->

</body>
</html>
