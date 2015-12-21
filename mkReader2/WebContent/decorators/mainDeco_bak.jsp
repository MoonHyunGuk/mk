<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.security.*" %>

<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.reflexion.co.kr/taglibs/paging" prefix="paging" %>
<%
	response.setHeader ("Pragma","No-cache"); 
	response.setDateHeader ("Expires", 0); 
	response.setHeader ("Cache-Control", "no-cache");
	
	String admin_userid = (String) session.getAttribute(ISiteConstant.SESSION_NAME_ADMIN_USERID);
	String agency_userid 	= (String) session.getAttribute(ISiteConstant.SESSION_NAME_AGENCY_USERID);
	String agency_name 	= (String) session.getAttribute(ISiteConstant.SESSION_NAME_AGENCY_NAME);
	String menu_auth 	= (String) session.getAttribute(ISiteConstant.SESSION_NAME_MENU_AUTH);
	String login_type 	= (String) session.getAttribute(ISiteConstant.SESSION_NAME_LOGIN_TYPE);

	int userLv = 0;
	// 관리자 권한인 경우 유저등급 세팅 (2013.02.05 박윤철)
	if( login_type.equals(ISiteConstant.LOGIN_TYPE_ADMIN) ){
		userLv 	=  Integer.parseInt((String)session.getAttribute(ISiteConstant.SESSION_NAME_ADMIN_LEVELS), 10);
	}

	if ( login_type == null || (admin_userid == null && agency_userid == null) ) {
		%><script language="JavaScript">
		<!--
			alert("로그인한 시간이 오래되어 사이트 보안상\n자동 로그아웃되었습니다. 다시 로그인 해주세요.");
			location.href="<%= ISiteConstant.URI_LOGIN %>";
		//-->
		</script><%
		return ;
	}
	
	String loginid = (login_type.equals(ISiteConstant.LOGIN_TYPE_ADMIN)) ? admin_userid : agency_name + "지국 (" + agency_userid + ")";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<title>매일경제 독자 프로그램</title>
<link rel='stylesheet' type='text/css' href='/css/mkcrm.css'>

<SCRIPT LANGUAGE="JavaScript">

function newImage(arg) {
	if (document.images) {
		rslt = new Image();
		rslt.src = arg;
		return rslt;
	}
}

function changeImages() {
	if (document.images && (preloadFlag == true)) {
		for (var i=0; i<changeImages.arguments.length; i+=2) {
			document[changeImages.arguments[i]].src = changeImages.arguments[i+1];
		}
	}
}

var preloadFlag = false;
function preloadImages() {
	if (document.images) {
		m_01_over = newImage("/zadmin/images/m_01-over.gif");
		m_01_m_02_over = newImage("/zadmin/images/m_01-m_02_over.gif");
		m_02_m_01_over = newImage("/zadmin/images/m_02-m_01_over.gif");
		m_02_over = newImage("/zadmin/images/m_02-over.gif");
		m_02_m_03_over = newImage("/zadmin/images/m_02-m_03_over.gif");
		m_03_m_02_over = newImage("/zadmin/images/m_03-m_02_over.gif");
		m_03_over = newImage("/zadmin/images/m_03-over.gif");
		preloadFlag = true;
	}
}

function showmenu(m) {
	menu=eval("document.all.menu"+m+".style");
	if(menu.display=="none") {
		for(i=1;i<6;i++) {
			if((i==3)||(i==5)){
				menu=eval("document.all.menu"+i+".style");
				
				if(m==i) {
					menu.display="";
					alert(i);
				} else {
					menu.display="none";
				}
			}
		}
	}
	else {
		menu.display="none";
	}
}
function popMemberViewStu(readno){
	var width="600";
	var height="655";
	LeftPosition=(screen.width)?(screen.width-width)/2:100;
	TopPosition=(screen.height)?(screen.height-height)/2:100;
	url="/billing/student/popup/view_stu.do?readno=" + readno;
	winOpts = "scrollbars=1,toolbar=no,location=no,directories=no,width="+width+",height="+height+",resizable=no,left="+LeftPosition+",top="+TopPosition;
	var obj = window.open(url,'popup',winOpts);
}
function popMemberView(readno){
	var width="600";
	var height="655";
	LeftPosition=(screen.width)?(screen.width-width)/2:100;
	TopPosition=(screen.height)?(screen.height-height)/2:100;
	url="/billing/zadmin/popup/view.do?readno=" + readno;
	winOpts = "scrollbars=1,toolbar=no,location=no,directories=no,width="+width+",height="+height+",resizable=no,left="+LeftPosition+",top="+TopPosition;
	var obj = window.open(url,'popup',winOpts);
}

</SCRIPT>
</head>

<body topmargin="0" leftmargin="0" style="overflow-x:auto;">
<!--top 메뉴 롤오버 및 인클루드원함 될 예정 아직 미완성-->
<table width="1200" height="80" border="0" cellspacing="0" cellpadding="0" background="/images/bg_topmenu.gif">
	<tr>
		<td width="200" align="center"><a href="/"><img src="/images/l_logo.gif" border="0" align="absmiddle"></a></td>
		<!-- 탑메뉴-->
		<td width="1000" height="80" align="left">
			<table width="1000" border="0" cellspacing="0" cellpadding="0">
				<tr>
			     <td height="38" align="right" colspan="2"> <font class="logf"> <a href="http://shop.living24.co.kr/" target="_blank">소모품구매</a></font> <font size="1px;" color="d5d5d5">│<font class="logf"> <a href="http://mcash.mk.co.kr:9900/index.php" target="_blank">카드수금</a></font> <font size="1px;" color="d5d5d5">│</font>   <font class="logf"> <a href="/front/searchJikuk.jsp" target="_blank">지국찾기</a></font> <font size="1px;" color="d5d5d5">│</font>  <font class="logf"> <a href="/">HOME</a></font> <font size="1px;" color="d5d5d5">│</font> <font class="logf"><a href="<%= ISiteConstant.URI_LOGOUT %>">LOGOUT</a></font>&nbsp;&nbsp;&nbsp;</td>
			    </tr>
				<tr>
					<td height="20" style="padding-left:50px;">
					<!-- 각 GNB 메뉴의 코드를 비교한다. -->
					<!-- 메뉴 - 독자 -->
					<% if ( menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { %>
					<a href="/reader/readerAplc/aplcList.do">
					<% } else { %>
					<a href="/reader/readerManage/readerList.do">
					<% } %>
						<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_READER %>" />
						<c:set var="menu_code2" value="<%= ICodeConstant.MENU_CODE_READER_BILLING %>" />
						<c:set var="menu_code3" value="<%= ICodeConstant.MENU_CODE_READER_EMPLOYEE %>" />
						<c:set var="menu_code4" value="<%= ICodeConstant.MENU_CODE_READER_EDUCATION %>" />
						<c:set var="menu_code5" value="<%= ICodeConstant.MENU_CODE_READER_ALIENATION %>" />
						<c:set var="menu_code6" value="<%= ICodeConstant.MENU_CODE_READER_CARD %>" />
						<c:set var="menu_code7" value="<%= ICodeConstant.MENU_CODE_EMP_EXTD %>" />
						<c:choose>
						<c:when test="${now_menu eq menu_code or now_menu eq menu_code2 or now_menu eq menu_code3 or now_menu eq menu_code4 or now_menu eq menu_code5 or now_menu eq menu_code6 or now_menu eq menu_code7}">
						<img src="/images/bt_top01_on.gif" border="0" align="absmiddle"></a>
						</c:when>
						<c:otherwise><img src="/images/bt_top01_off.gif" border="0" align="absmiddle"></a></c:otherwise></c:choose>
						<img src="/images/bt_top_line.gif" border="0" align="absmiddle">
						
					<!-- 메뉴 - 수금입력 -->
					<% if ( menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { %>
					<a href="/collection/edi/gr15list.do">
					<% } else { %>
					<a href="/collection/manual/eachDeposit.do">
					<% } %>
						<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_COLLECTION %>" />
						<c:set var="menu_code2" value="<%= ICodeConstant.MENU_CODE_COLLECTION_EDI %>" />
						<c:choose><c:when test="${now_menu eq menu_code or now_menu eq menu_code2}"><img src="/images/bt_top02_on.gif" border="0" align="absmiddle"></a></c:when>
						<c:otherwise><img src="/images/bt_top02_off.gif" border="0" align="absmiddle"></a></c:otherwise></c:choose>
						<img src="/images/bt_top_line.gif" border="0" align="absmiddle">
					
					<!-- 메뉴 - 현황조회 -->
					<% if ( menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { 
						if ( userLv > 8 ) { %>
						<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_PRINT %>" />
						<c:choose>
							<c:when test="${now_menu eq menu_code}">
								<a href="/reader/billingAdmin/aplcList.do"><img src="/images/bt_top03_on.gif" border="0" align="absmiddle"></a>
							</c:when>
							<c:otherwise>
								<a href="/reader/billingAdmin/aplcList.do"><img src="/images/bt_top03_off.gif" border="0" align="absmiddle"></a>
							</c:otherwise>
						</c:choose>
						<img src="/images/bt_top_line.gif" border="0" align="absmiddle">
						<%}
					} else { %>
						<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_PRINT %>" />
						<c:choose>
							<c:when test="${now_menu eq menu_code}">
								<a href="/print/print/conditionList.do"><img src="/images/bt_top03_on.gif" border="0" align="absmiddle"></a>
							</c:when>
							<c:otherwise>
								<a href="/print/print/conditionList.do"><img src="/images/bt_top03_off.gif" border="0" align="absmiddle"></a>
							</c:otherwise>
						</c:choose>
						<img src="/images/bt_top_line.gif" border="0" align="absmiddle">
					<% } %>

					<!-- 메뉴 - 고지서출력 -->
					<% if ( menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { %>
					<% } else { %>
					<a href="/output/billOutput/giroView.do">
						<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_OUTPUT %>" />
						<c:choose><c:when test="${now_menu eq menu_code}"><img src="/images/bt_top04_on.gif" border="0" align="absmiddle"></a></c:when>
						<c:otherwise><img src="/images/bt_top04_off.gif" border="0" align="absmiddle"></a></c:otherwise></c:choose>
						<img src="/images/bt_top_line.gif" border="0" align="absmiddle">
					<% } %>

					<!-- 메뉴 - 통계 -->
					<% if ( menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { 
						if ( userLv > 8 ) { %>
						<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_STATISTICS %>" />
						<c:choose>
							<c:when test="${now_menu eq menu_code}">
								<a href="/statistics/stats/state.do?type=peruse"><img src="/images/bt_top05_on.gif" border="0" align="absmiddle"></a>
							</c:when>
							<c:otherwise>
								<a href="/statistics/stats/state.do?type=peruse"><img src="/images/bt_top05_off.gif" border="0" align="absmiddle"></a>
							</c:otherwise>
						</c:choose>
						<img src="/images/bt_top_line.gif" border="0" align="absmiddle">
						<%}
					} else { %>
						<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_STATISTICS %>" />
						<c:choose>
							<c:when test="${now_menu eq menu_code}">
								<a href="/statistics/stats/state.do?type=peruse"><img src="/images/bt_top05_on.gif" border="0" align="absmiddle"></a>
							</c:when>
							<c:otherwise>
								<a href="/statistics/stats/state.do?type=peruse"><img src="/images/bt_top05_off.gif" border="0" align="absmiddle"></a>
							</c:otherwise>
						</c:choose>
						<img src="/images/bt_top_line.gif" border="0" align="absmiddle">
					<% } %>
					
					<!-- 메뉴 - 기타작업 -->
					<% if ( menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { 
						if ( loginid.equals("SUPERADMIN") ) { %>
						<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_ETC %>" />
						<c:choose>
							<c:when test="${now_menu eq menu_code}">
								<a href="/etc/deadLine/reteriveDeadLine.do"><img src="/images/bt_top06_on.gif" border="0" align="absmiddle"></a>
							</c:when>
							<c:otherwise>
								<a href="/etc/deadLine/reteriveDeadLine.do"><img src="/images/bt_top06_off.gif" border="0" align="absmiddle"></a>
							</c:otherwise>
						</c:choose>
						<img src="/images/bt_top_line.gif" border="0" align="absmiddle">
						<%}
					} else { %>
						<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_ETC %>" />
						<c:choose>
							<c:when test="${now_menu eq menu_code}">
								<a href="/etc/deliveryNumSort/reteriveDeliveryNum.do"><img src="/images/bt_top06_on.gif" border="0" align="absmiddle"></a>
							</c:when>
							<c:otherwise>
								<a href="/etc/deliveryNumSort/reteriveDeliveryNum.do"><img src="/images/bt_top06_off.gif" border="0" align="absmiddle"></a>
							</c:otherwise>
						</c:choose>
						<img src="/images/bt_top_line.gif" border="0" align="absmiddle">
					<% } %>						
					
					
					<!-- 메뉴 - 커뮤니티 -->
					<a href="/community/bbs/noticeList.do">
						<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_COMMUNITY %>" />
						<c:choose><c:when test="${now_menu eq menu_code}"><img src="/images/bt_top07_on.gif" border="0" align="absmiddle"></a></c:when>
						<c:otherwise><img src="/images/bt_top07_off.gif" border="0" align="absmiddle"></a></c:otherwise></c:choose>
						<img src="/images/bt_top_line.gif" border="0" align="absmiddle">
					
					<!-- 메뉴 - 관리 -->
					<% if ( menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { %>
					<a href="/management/adminManage/agencyList.do">
					<% } else { %>
					<a href="/management/agencyManage/agencyInfo.do">
					<% } %>
						<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_MANAGEMENT %>" />
						<c:choose><c:when test="${now_menu eq menu_code}"><img src="/images/bt_top08_on.gif" border="0" align="absmiddle"></a></c:when>
						<c:otherwise><img src="/images/bt_top08_off.gif" border="0" align="absmiddle"></a></c:otherwise></c:choose>
						<img src="/images/bt_top_line.gif" border="0" align="absmiddle">
					
					<!-- 메뉴 - 자동이체 -->
					<% if ( menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { %>
					<a href="/billing/zadmin/cmsrequest/index13.do">
					<% } else { %>
					<a href="/billing/branch/cmsrequest/index.do">
					<% } %>
						<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_BILLING %>" />
						<c:set var="menu_code2" value="<%= ICodeConstant.MENU_CODE_BILLING_STU %>" />
						<c:choose><c:when test="${now_menu eq menu_code or now_menu eq menu_code2}"><img src="/images/bt_top09_on.gif" border="0" align="absmiddle"></a></c:when>
						<c:otherwise><img src="/images/bt_top09_off.gif" border="0" align="absmiddle"></a></c:otherwise></c:choose>
						<img src="/images/bt_top_line.gif" border="0" align="absmiddle">
								
					</td>
					<td align="right">
					<font class="bname"><c:out value="<%= loginid %>" /> 님</font> 환영합니다.&nbsp;&nbsp;&nbsp;
					</td>
				</tr>
				<tr>
					<td height="18" colspan="2"></td>
				</tr>
			</table>

		</td>
	</tr>
	<tr>
		<td colspan="2" height="12" bgcolor="f48d2e" align="center"><!--<b>MAEIL BUSINESS NEWSPAPER</b>--></td>
	</tr>
</table>

<!-- 메인-->
<table width="1200" height="80" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<!-- left 메뉴 인클루드 원함-->
		<td width="143" bgcolor="e3e3e3" valign="top">
	
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<!-- 각 LNB 메뉴의 코드를 비교한다. -->
				<!-- 메뉴 - 메인 -->
				<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_MAIN %>" />
				<c:if test="${now_menu eq menu_code}">
					<tr>
						<td>
							<img src="/images/bt_left_jiro.gif" border="0" align="absmiddle">
						</td>
					</tr>  		
					<tr>
						<td class="box_m1" height="35">
							<p class="space10">
								<img src='/images/left_icon.gif' align='absmiddle'> 총건수 : <b><fmt:formatNumber value="${giroEdiInfo.CNT}"  type="number" /></b> 건
							<p class="space5">
								<img src='/images/left_icon.gif' align='absmiddle'> 합계 : <b><fmt:formatNumber value="${giroEdiInfo.E_MONEY}"  type="number" /></b> 원
							<p class="space6">
						</td>
					</tr>
					<tr>
						<td>
							<img src="/images/bt_left_ja.gif" border="0" align="absmiddle">
						</td>
					</tr>  
					<tr>
						<td class="box_m1" height="35">
							<p class="space10">
								<img src='/images/left_icon.gif' align='absmiddle'> 일반
							<p class="space10">
								<img src='/images/left_icon.gif' align='absmiddle'> 총건수 : <b><fmt:formatNumber value="${resultBill.CNT}"  type="number" /></b> 건
							<p class="space5">
								<img src='/images/left_icon.gif' align='absmiddle'> 합계 : <b><fmt:formatNumber value="${resultBill.CMSMONEY}"  type="number" /></b> 원
							<p class="space10">
								<img src='/images/left_icon.gif' align='absmiddle'> 학생
							<p class="space10">
								<img src='/images/left_icon.gif' align='absmiddle'> 총건수 : <b><fmt:formatNumber value="${resultBillStu.CNT}"  type="number" /></b> 건
							<p class="space5">
								<img src='/images/left_icon.gif' align='absmiddle'> 합계 : <b><fmt:formatNumber value="${resultBillStu.CMSMONEY}"  type="number" /></b> 원
							<p class="space6">
						</td>
					</tr>
					
					<!-- 메인알림 -->
					<c:if test="${not empty mainInfo}">
						<tr>
							<td><img src="/images/bt_left_alrim.gif" border="0" align="absmiddle"></td>
						</tr> 
						<tr>
							<td class="box_m1" height="2"></td>
						</tr> 
						<tr>
							<td align='center' bgcolor='F46F2E' height='128'>
							
							  <table width='138' height='126' bgcolor='#ffffff' border='0' cellspacing='0' cellpadding='0'>
							    <tr height='3'>
								  <td align='left' valign='top'><img src='/images/alrim_box1.gif' align='absmiddle'></td>
								</tr>
							    <tr>
								  <td style="word-break:break-all;" align='left'>
								  	${mainInfo.CONT}
								  </td>
								</tr>
							    <tr height='3'>
								  <td align='left' valign='top'><img src='/images/alrim_box2.gif' align='absmiddle'></td>
								</tr>
							  </table></td>
						</tr>					
						<tr class="line_m01" height="1"><td></td></tr>
						<tr class="line_m02" height="1"><td></td></tr>																
					</c:if>					
					<!-- 		
					<tr>
						<td>
							<img src="/images/bt_left_online.gif" border="0" align="absmiddle">
						</td>
					</tr>  		
					<tr>
						<td class="box_m1" height="35">
							<p class="space6">
								<img src='/images/left_icon.gif' align='absmiddle'> 총건수 : <b>0</b> 건
							<p class="space5">
								<img src='/images/left_icon.gif' align='absmiddle'> 합계 : <b>0</b> 원
							<p class="space6">
						</td>
					</tr>	
					 -->
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>	
					<tr><td height="7"> </td></tr>	                                                                                                                                     
				</c:if>
				
				
				<!-- 메뉴 - 독자 -->
				<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_READER %>" />
				<c:set var="menu_code2" value="<%= ICodeConstant.MENU_CODE_READER_BILLING %>" />
				<c:set var="menu_code3" value="<%= ICodeConstant.MENU_CODE_READER_EMPLOYEE %>" />
				<c:set var="menu_code4" value="<%= ICodeConstant.MENU_CODE_READER_EDUCATION %>" />
				<c:set var="menu_code5" value="<%= ICodeConstant.MENU_CODE_READER_ALIENATION %>" />
				<c:set var="menu_code6" value="<%= ICodeConstant.MENU_CODE_READER_CARD %>" />
				<c:set var="menu_code7" value="<%= ICodeConstant.MENU_CODE_EMP_EXTD %>" />
				<c:if test="${now_menu eq menu_code or now_menu eq menu_code2 or now_menu eq menu_code3 or now_menu eq menu_code4 or now_menu eq menu_code5 or now_menu eq menu_code6 or now_menu eq menu_code7}">
										
					<% if ( menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { %>
						<tr><td><img src="/images/tt_left01.gif" border="0" align="absmiddle"></td></tr>
						 
						<tr><td class="box_m" height="35"><a href="/reader/readerAplc/aplcList.do" OnFocus="this.blur()">본사신청독자관리</a></td></tr>
						<tr class="line_m01" height="1"><td></td></tr>
						<tr class="line_m02" height="1"><td></td></tr>
 						
						<tr><td class="box_m" height="35"><a href="/reader/minwon/retrieveIntegReaderSearch.do" OnFocus="this.blur()">통합독자리스트</a></td></tr>
						<tr class="line_m01" height="1"><td></td></tr>
						<tr class="line_m02" height="1"><td></td></tr>

						<tr><td class="box_m" height="35"><a href="/reader/billingAdmin/billingList.do" OnFocus="this.blur()">자동이체독자관리</a></td></tr>
						<tr class="line_m01" height="1"><td></td></tr>
						<tr class="line_m02" height="1"><td></td></tr>
						
					<%}else{ %>
					
						<tr><td><img src="/images/tt_left01.gif" border="0" align="absmiddle"></td></tr>
						<tr><td class="box_m" height="35"><a href="/reader/readerManage/readerList.do" OnFocus="this.blur()">독자관리</a></td></tr>
						<tr class="line_m01" height="1"><td></td></tr>
						<tr class="line_m02" height="1"><td></td></tr>
					
						<tr><td class="box_m" height="35"><a href="/reader/readerWonJang/retrieveReaderWonJang.do" OnFocus="this.blur()">독자원장</a></td></tr>
						<tr class="line_m01" height="1"><td></td></tr>
						<tr class="line_m02" height="1"><td></td></tr>
						
						<tr><td class="box_m" height="35"><a href="/reader/delivery/retrieveDeliveryList.do" OnFocus="this.blur()">배달명단</a></td></tr>
						<tr class="line_m01" height="1"><td></td></tr>
						<tr class="line_m02" height="1"><td></td></tr>
						
						<tr><td class="box_m" height="35"><a href="/reader/billing/billingList.do" OnFocus="this.blur()">자동이체독자</a></td></tr>
						<tr class="line_m01" height="1"><td></td></tr>
						<tr class="line_m02" height="1"><td></td></tr>
					<%} %>
					<c:if test="${now_menu eq menu_code2}">                                                                                                                                        
					<% if ( menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { %>
						<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/reader/billingAdmin/billingList.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 일반독자 리스트</a></font></td></tr>
						<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/reader/billingStuAdmin/billingList.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 학생독자 리스트</a></font></td></tr>
						<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/reader/billingStuAdmin/billingStuAplcList.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 학생구독신청리스트</a></font></td></tr>
						<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/reader/billingAdmin/billingEdit.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 일반독자 입력</a></font></td></tr>  
						<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/reader/billingStuAdmin/billingEdit.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 학생독자 입력</a></font></td></tr>  
					<% } else { %>
						<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/reader/billing/billingList.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 일반독자 리스트</a></font></td></tr>
						<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/reader/billingStu/billingList.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 학생독자 리스트</a></font></td></tr>
					<% } %>                                                                                                                                                                   
					</c:if>

					<!-- 카드독자관리 (2012.12.27 박윤철)-->
					<tr><td class="box_m" height="35"><a href="/reader/card/cardReaderList.do" OnFocus="this.blur()">카드독자관리</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					<c:if test="${now_menu eq menu_code6}">
						<% if ( menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { %>
							<!-- <tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/reader/card/cardReaderEdit.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 카드독자 입력</a></font></td></tr>   -->
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/reader/card/cardReaderList.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 카드독자 리스트</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/reader/card/cardReaderSugmList.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 카드독자 수금</a></font></td></tr>
						<%}else{%>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/reader/card/cardReaderList.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 카드독자 리스트</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/reader/card/cardReaderSugmListJikuk.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 카드독자 수금내역</a></font></td></tr>
						<%} %>
					</c:if>

					<% if ( menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { %>
						<tr><td class="box_m" height="35"><a href="/reader/employeeAdmin/retrieveEmployeeList.do" OnFocus="this.blur()">본사사원구독관리</a></td></tr>
						<tr class="line_m01" height="1"><td></td></tr>
						<tr class="line_m02" height="1"><td></td></tr>
					<%}else{ %>
						<tr><td class="box_m" height="35"><a href="/reader/employee/retrieveEmployeeList.do" OnFocus="this.blur()">본사사원구독관리</a></td></tr>
						<tr class="line_m01" height="1"><td></td></tr>
						<tr class="line_m02" height="1"><td></td></tr>
					<%} %>
					<c:if test="${now_menu eq menu_code3}">
						<% if ( menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { %>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/reader/employeeAdmin/employeeEdit.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 본사독자 입력</a></font></td></tr>  
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/reader/employeeAdmin/retrieveEmployeeList.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 본사독자 리스트</a></font></td></tr>
						<%}else{%>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/reader/employee/retrieveEmployeeList.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 본사독자 리스트</a></font></td></tr>
						<%} %>
					</c:if>
					
					<tr><td class="box_m" height="35"><a href="/reader/education/retrieveEducationList.do" OnFocus="this.blur()">교육용 구독관리</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					<c:if test="${now_menu eq menu_code4}">
						<% if ( menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { %>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/reader/education/educationEdit.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 교육용독자 입력</a></font></td></tr>  
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/reader/education/retrieveEducationList.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 교육용독자 리스트</a></font></td></tr>
							<!-- 
							<tr><td style="background-color:#f6f6f6; height:25px "><font class="left3Depth"><a href="/reader/education/eduReaderBatchList.do" >&nbsp;&nbsp;&nbsp;└ 교육용독자 일괄작업</a></font></td></tr>
							 -->
						<%}else{%>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/reader/education/retrieveEducationList.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 교육용독자 리스트</a></font></td></tr>
						<%} %>
					</c:if>
					
					<tr><td class="box_m" height="35"><a href="/reader/alienation/retrieveAlienationList.do" OnFocus="this.blur()">소외계층 구독관리</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					<c:if test="${now_menu eq menu_code5}">
						<% if ( menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { %>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/reader/alienation/alienationEdit.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 소외계층독자 입력</a></font></td></tr>  
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/reader/alienation/retrieveAlienationList.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 소외계층독자 리스트</a></font></td></tr>
						<%}else{%>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/reader/alienation/retrieveAlienationList.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 소외계층독자 리스트</a></font></td></tr>
						<%} %>
					</c:if>
					
					<% if ( menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { %>
						<tr><td class="box_m" height="35"><a href="/reader/minwon/retrieveMinwonList.do" OnFocus="this.blur()">독자민원관리</a></td></tr>
						<tr class="line_m01" height="1"><td></td></tr>
						<tr class="line_m02" height="1"><td></td></tr>
					
						<tr><td class="box_m" height="35"><a href="/reader/biReader/biReaderList.do" OnFocus="this.blur()">비독자관리</a></td></tr>
						<tr class="line_m01" height="1"><td></td></tr>
						<tr class="line_m02" height="1"><td></td></tr>
						
					
					
						<tr><td class="box_m" height="35"><a href="/reader/empExtd/empExtdList.do" OnFocus="this.blur()">사원확장관리</a></td></tr>
						<tr class="line_m01" height="1"><td></td></tr>
						<tr class="line_m02" height="1"><td></td></tr>
						<c:if test="${now_menu eq menu_code7}">
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/reader/empExtd/empExtdEdit.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 사원확장 입력</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/reader/empExtd/empExtdList.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 사원확장 리스트</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/reader/empExtd/empExtdStat.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 사원확장 통계</a></font></td></tr>
						</c:if>
					<%} %>
					
				</c:if>
								
				<!-- 메뉴 - 수금입력 -->
				<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_COLLECTION %>" />
				<c:set var="menu_code2" value="<%= ICodeConstant.MENU_CODE_COLLECTION_EDI %>" />
				<c:if test="${now_menu eq menu_code or now_menu eq menu_code2}">
					<% if ( ! menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { %>
					<tr><td><img src="/images/tt_left02.gif" border="0" align="absmiddle"></td></tr>
					<tr><td class="box_m" height="35"><a href="/collection/manual/eachDeposit.do" OnFocus="this.blur()">수동입금</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					
						<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_COLLECTION %>" />
						<c:if test="${now_menu eq menu_code}">
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/collection/manual/eachDeposit.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 개별/다부수입금</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/collection/manual/areaDeposit.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 구역별입금</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/collection/manual/visitSugmFormList.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 방문수금장부</a></font></td></tr>
						</c:if>
						
					<tr><td class="box_m" height="35"><a href="/collection/ediBranch/ediList.do" OnFocus="this.blur()">지로입금</a></td></tr>
						<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_COLLECTION_EDI %>" />
						<c:if test="${now_menu eq menu_code}">
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/collection/ediBranch/ediList.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 자료조회</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/collection/ediBranch/ediOverList.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 지로 과입금조회</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/collection/ediBranch/ediErrList.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 오류조회</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/collection/edi/gr15attach2.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 타 지로 엑셀다운</a></font></td></tr>
						</c:if>
					<% } %>
					
					<% if ( menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { %>
					<tr><td class="box_m" height="35"><a href="/collection/edi/gr15list.do" OnFocus="this.blur()">지로관리</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					
						<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_COLLECTION_EDI %>" />
						<c:if test="${now_menu eq menu_code}">
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/collection/edi/gr15attach.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 자료업로드</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/collection/edi/gr15list.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 자료조회</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/collection/edi/ediList.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 지국별 상세조회</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/collection/edi/gr15errList.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 오류조회</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/collection/edi/gr15overList.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 지로 과입금조회</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/collection/edi/mr15List.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 바코드 수납현황</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/collection/ediElect/gr65List.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 전자수납 관리</a></font></td></tr>
						</c:if>
					<% } %>
				</c:if>
								
				<!-- 메뉴 - 현황조회 -->
				<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_PRINT %>" />
				<c:if test="${now_menu eq menu_code}">
					<tr><td><img src="/images/tt_left03.gif" border="0" align="absmiddle"></td></tr>
					<% if ( ! menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { %>
					
					<tr><td class="box_m" height="35"><a href="/print/print/conditionList.do" OnFocus="this.blur()">조건별명단</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					<tr><td class="box_m" height="35"><a href="/print/print/misuState.do" OnFocus="this.blur()">미수독자명단</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					
					<tr><td class="box_m" height="35"><a href="/print/print/stReaderList.do" OnFocus="this.blur()">해지독자명단</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>

					<tr><td class="box_m" height="35"><a href="/print/print/detailState.do" OnFocus="this.blur()">입금내역현황</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					
					
					<tr><td class="box_m" height="35"><a href="/print/print/sugmState.do" OnFocus="this.blur()">일일수금현황</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					
					<tr><td class="box_m" height="35"><a href="/print/print/readerState.do" OnFocus="this.blur()">독자정보현황</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					
					<tr><td class="box_m" height="35"><a href="/print/print/jidaeListAgency.do" OnFocus="this.blur()">지대/본사입금현황</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					
					<% } %>
					
					<% if ( menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { %>
					<tr><td class="box_m" height="35"><a href="/reader/billingAdmin/aplcList.do" OnFocus="this.blur()">신규 독자 일보</a></td></tr>
					<tr><td class="box_m" height="35"><a href="/print/print/officeReaderState.do" OnFocus="this.blur()">본사신청구독통계</a></td></tr>
					<tr><td class="box_m" height="35"><a href="/print/print/stopOfficeReaderList.do" OnFocus="this.blur()">본사신청중지현황</a></td></tr>
					<tr><td class="box_m" height="35"><a href="/print/print/jidaeList.do" OnFocus="this.blur()">지대/본사입금현황</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					<% } %>
				</c:if>
				
				<!-- 메뉴 - 고지서출력 -->
				<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_OUTPUT %>" />
				<c:if test="${now_menu eq menu_code}">
					<tr><td><img src="/images/tt_left04.gif" border="0" align="absmiddle"></td></tr>
					<tr><td class="box_m" height="35"><a href="/output/billOutput/giroView.do" OnFocus="this.blur()">지로영수증</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					
					<tr><td class="box_m" height="35"><a href="/output/billOutput/visitView.do" OnFocus="this.blur()">방문영수증</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					
					<tr><td class="box_m" height="35"><a href="/output/billOutput/eachView.do" OnFocus="this.blur()">개별영수증</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
				</c:if>
				
				<!-- 메뉴 - 통계 -->
				<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_STATISTICS %>" />
				<c:if test="${now_menu eq menu_code}">
					<tr><td><img src="/images/tt_left05.gif" border="0" align="absmiddle"></td></tr>
					<tr><td class="box_m" height="35"><a href="/statistics/stats/state.do?type=peruse" OnFocus="this.blur()">통계일람</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					<tr><td class="box_m" height="35"><a href="/statistics/stats/state.do?type=paymentAdjustments" OnFocus="this.blur()">당월입금</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					<tr><td class="box_m" height="35"><a href="/statistics/stats/state.do?type=paymentStats" OnFocus="this.blur()">입금현황</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					<tr><td class="box_m" height="35"><a href="/statistics/stats/state.do?type=bill" OnFocus="this.blur()">유가현황</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					<tr><td class="box_m" height="35"><a href="/statistics/stats/delivery.do" OnFocus="this.blur()">배부현황</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
				</c:if>
				
				<!-- 메뉴 - 기타작업 -->
				<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_ETC %>" />
				<c:if test="${now_menu eq menu_code}">
					<tr><td><img src="/images/tt_left06.gif" border="0" align="absmiddle"></td></tr>
					<% if ( menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { %>
					<tr><td class="box_m" height="35"><a href="/etc/deadLine/reteriveDeadLine.do" OnFocus="this.blur()">월마감</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					<%}else{ %>
					<tr><td class="box_m" height="35"><a href="/etc/deliveryNumSort/reteriveDeliveryNum.do" OnFocus="this.blur()">배달번호정렬</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					<%} %>
				</c:if>
				
				<!-- 메뉴 - 커뮤니티 -->
				<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_COMMUNITY %>" />
				<c:if test="${now_menu eq menu_code}">
					<tr><td><img src="/images/bt_left_community.gif" border="0" align="absmiddle"></td></tr>
					<tr><td class="box_m" height="35"><a href="/community/bbs/noticeList.do" OnFocus="this.blur()">공지사항</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					<tr><td class="box_m" height="35"><a href="/community/bbs/dataList.do" OnFocus="this.blur()">자료실</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					<% if ( menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { %>
						<tr><td class="box_m" height="35"><a href="/community/bbs/mainList.do" OnFocus="this.blur()">메인알림</a></td></tr>
						<tr class="line_m01" height="1"><td></td></tr>
						<tr class="line_m02" height="1"><td></td></tr>
						<tr><td class="box_m" height="35"><a href="/community/bbs/retrieveBoard.do" OnFocus="this.blur()">직원게시판</a></td></tr>
						<tr class="line_m01" height="1"><td></td></tr>
						<tr class="line_m02" height="1"><td></td></tr>
	
					<%} %>
					
					<!-- 
					<tr><td class="box_m" height="35"><a href="#" OnFocus="this.blur()">자료실</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					
					<tr><td class="box_m" height="35"><a href="#" OnFocus="this.blur()">커뮤니티</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					-->
				</c:if>
				
				<!-- 메뉴 - 관리 -->
				<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_MANAGEMENT %>" />
				<c:if test="${now_menu eq menu_code}">
					
					<tr><td><img src="/images/tt_left07.gif" border="0" align="absmiddle"></td></tr>
					<% if ( menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { %>
					
					<tr><td class="box_m" height="35"><a href="/management/adminManage/agencyInfo.do" OnFocus="this.blur()">지국 등록</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					
					<tr><td class="box_m" height="35"><a href="/management/adminManage/agencyList.do" OnFocus="this.blur()">지국 관리</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					
					<tr><td class="box_m" height="35"><a href="javascript:alert('CRM메뉴를 이용해 주세요.')" OnFocus="this.blur()">지국별 지역할당</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					
					 
					<tr><td class="box_m"><a href="#fakeUrl" onclick="alert('CRM메뉴를 이용해 주세요.');">코드관리</a></td></tr>
					<!--
					<tr><td class="box_m"><a href="/management/code/codeList.do">코드관리</a></td></tr>
					-->
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					
					<% } else { %>
					
					<tr><td class="box_m" height="35"><a href="/management/agencyManage/agencyInfo.do" OnFocus="this.blur()">지국 정보</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					
					<tr><td class="box_m" height="35"><a href="/management/codeManage/guyukList.do" OnFocus="this.blur()">구역관리</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					
					<tr><td class="box_m" height="35"><a href="/management/codeManage/extdList.do" OnFocus="this.blur()">확장자관리</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					
					<tr><td class="box_m" height="35"><a href="/management/codeManage/newsList.do" OnFocus="this.blur()">매체관리</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					<!-- 
					<tr><td class="box_m" height="35"><a href="javascript:alert('기능 구현중으로 이용할수 없습니다.')" OnFocus="this.blur()">주소코드</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					-->
					<tr><td class="box_m" height="35"><a href="/management/codeManage/jikukZipList.do" OnFocus="this.blur()">관할지역</a></td></tr>
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					
					<% } %>
				</c:if>
				
				<!-- 메뉴 - 자동이체 -->
				<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_BILLING %>" />
				<c:set var="menu_code2" value="<%= ICodeConstant.MENU_CODE_BILLING_STU %>" />
				<c:if test="${now_menu eq menu_code or now_menu eq menu_code2}">
					
					<tr><td><img src="/images/tt_left08.gif" border="0" align="absmiddle"></td></tr>
					<% if ( menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { %>
						<tr><td class="box_m" height="35"><a href="/billing/zadmin/cmsrequest/index13.do" OnFocus="this.blur()">일반독자관리</a></td></tr>
					<% } else { %>
						<tr><td class="box_m" height="35"><a href="/billing/branch/cmsrequest/index.do" OnFocus="this.blur()">일반독자관리</a></td></tr>
					<% } %>	
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					
					<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_BILLING %>" />
					<c:if test="${now_menu eq menu_code}">
						<% if ( menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { %>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/billing/zadmin/cmsrequest/index13.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 이체신청(EB13)</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/billing/zadmin/cmsrequest/index.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 신청결과(EB14)</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/billing/zadmin/cmsget/index21.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 이체청구(EB21)</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/billing/zadmin/cmsget/index.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 청구결과(EB22)</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/billing/zadmin/cmsget/stat.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 이체내역조회</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/billing/zadmin/cmsget/err_list.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 미수독자조회</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/billing/zadmin/refund/list.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 환불내역입력</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/billing/zadmin/cmsbank/index.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 은행신청(EB11)</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/billing/zadmin/cmsbank/index12.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 은행신청결과(EB12)</a></font></td></tr>
							
						<% } else { %>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/billing/branch/cmsrequest/index.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 계좌확인내역</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/billing/branch/cmsget/index.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 출금신청내역</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/billing/branch/cmsget/stat.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 이체내역조회</a></font></td></tr>
						<% } %>
					</c:if>
					
					<% if ( menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { %>
						<tr><td class="box_m" height="35"><a href="/billing/student/cmsrequest/index13_stu.do" OnFocus="this.blur()">학생독자관리</a></td></tr>
					<% } else { %>
						<tr><td class="box_m" height="35"><a href="/billing/branch/cmsget/stat_stu.do" OnFocus="this.blur()">학생독자관리</a></td></tr>
					<% } %>
					
					<tr class="line_m01" height="1"><td></td></tr>
					<tr class="line_m02" height="1"><td></td></tr>
					
					<c:set var="menu_code" value="<%= ICodeConstant.MENU_CODE_BILLING_STU %>" />
					<c:if test="${now_menu eq menu_code}">	
						<% if ( menu_auth.equals(ICodeConstant.AUTH_CODE_ADMIN)) { %>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/billing/student/cmsrequest/index13_stu.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 이체신청(EB13)</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/billing/student/cmsrequest/index_stu.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 신청결과(EB14)</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/billing/student/cmsget/index21_stu.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 이체청구(EB21)</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/billing/student/cmsget/index_stu.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 청구결과(EB22)</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/billing/student/cmsget/stat_stu.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 이체내역조회</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/billing/student/cmsget/err_list_stu.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 미수독자조회</a></font></td></tr>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/billing/student/refund/list_stu.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 환불내역입력</a></font></td></tr>
						<% } else { %>
							<tr><td height="25" style="background-color:#f6f6f6;"><font class="left3Depth"><a href="/billing/branch/cmsget/stat_stu.do" OnFocus="this.blur()">&nbsp;&nbsp;&nbsp;└ 이체내역조회</a></font></td></tr>
						<% } %>
					</c:if>
				</c:if>

			</table>		
		</td>

		<!-- main 내용-->
		<td width="1057" class="pad10" valign="top">
		
			<decorator:body />

		</td>
		<!-- main 끝-->
	</tr>
</table>
<!-- 메인내용-->

<!-- footer start -->
<table width="100%" height="0" cellpadding="0" cellspacing="0" bgcolor="cfcfcf">
	<tr valign="bottom">
		<td align="center" class="b01"><img src="/images/l_bottom.gif" border="0" align="absmiddle"> Copyright ⓒ 2012 mk.co.kr  All right reserved.</td>
	</tr>
</table>


<!-- footer end -->

</body>
</html>

