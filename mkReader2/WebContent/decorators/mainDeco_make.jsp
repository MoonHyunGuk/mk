<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mkreader.security.*" %>
<%@ page import="java.util.*" %>
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
	
	List<String> menuList = (List)session.getAttribute(ISiteConstant.SESSION_MENU_LIST);
	/*
	System.out.println("admin_userid = "+admin_userid);
	System.out.println("agency_userid = "+agency_userid);
	System.out.println("agency_name = "+agency_name);
	System.out.println("menu_auth = "+menu_auth);
	System.out.println("login_type = "+login_type);
	System.out.println("menuList1 = "+menuList);
	*/
	/*
	int userLv = 0;
	// 관리자 권한인 경우 유저등급 세팅 (2013.02.05 박윤철)
	if( login_type.equals(ISiteConstant.LOGIN_TYPE_ADMIN) ){
		userLv 	=  Integer.parseInt((String)session.getAttribute(ISiteConstant.SESSION_NAME_ADMIN_LEVELS), 10);
	}
	*/

	if ( login_type == null || (admin_userid == null && agency_userid == null) ) {
%>
		<script type="text/javascript" >
			alert("로그인한 시간이 오래되어 사이트 보안상\n자동 로그아웃되었습니다. 다시 로그인 해주세요.");
			location.href="<%= ISiteConstant.URI_LOGIN %>";
		</script>
<%
		return ;
	}
	
	String loginid = (login_type.equals(ISiteConstant.LOGIN_TYPE_ADMIN)) ? admin_userid : agency_name + "지국 (" + agency_userid + ")";
	//menu id
	String topMenuId	= request.getParameter("topMenuId");
	String topMenuNm = request.getParameter("topMenuNm");
	String subMenuId	= request.getParameter("subMenuId");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>매일경제 독자 프로그램</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" /> 
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet">
<link rel="shortcut icon" href="http://img.mk.co.kr/main/2012/favicon1.ico">
<script type="text/javascript" src="/js/prototype.js"></script> 
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript">
function popMemberViewStu(readno){
	var width="600";
	var height="655";
	LeftPosition=(screen.width)?(screen.width-width)/2:100;
	TopPosition=(screen.height)?(screen.height-height)/2:100;
	url="/billing/student/popup/view_stu.do?readno=" + readno;
	winOpts = "scrollbars=1,toolbar=no,location=no,directories=no,width="+width+",height="+height+",resizable=no,left="+LeftPosition+",top="+TopPosition;
	window.open(url,'popup',winOpts);
}

function popMemberView(readno){
	var width="600";
	var height="655";
	LeftPosition=(screen.width)?(screen.width-width)/2:100;
	TopPosition=(screen.height)?(screen.height-height)/2:100;
	url="/billing/zadmin/popup/view.do?readno=" + readno;
	winOpts = "scrollbars=1,toolbar=no,location=no,directories=no,width="+width+",height="+height+",resizable=no,left="+LeftPosition+",top="+TopPosition;
	window.open(url,'popup',winOpts);
}

/**
 * 자동이체독자관리 등록 팝업
 */
function fn_popReaderEdit(type) {
	var width="750";
	var height="750";
	var url = "";

	if("normal" == type) { //일반독자
		url="/reader/billingAdmin/billingInfo.do?flag=INS";
	} else if("stu" == type) { //학생독자
		url="/reader/billingStuAdmin/billingInfo.do?flag=INS";
	} else if("employee" == type) { //본사사원독자
		url = "/reader/employeeAdmin/employeeInfo.do?flag=INS";
	} else if("alienation" == type) { //소외계층독자
		url = "/reader/alienation/alienationInfo.do?flag=INS";
	} else if("niReader" == type) { //NI신문독자
		url = "/reader/alienation/niInfo.do?flag=INS";
	} else if("education" == type) { //교육용독자
		url = "/reader/education/educationInfo.do?flag=INS";
	} else if("education_excel" == type) { //교육용미수출력
		url = "/reader/education/educationUnpaid.do";
		width="350";
		height="170";
	}
	
	var LeftPosition=(screen.width)?(screen.width-width)/2:100;
	var TopPosition=(screen.height)?(screen.height-height)/2:100;
	
	winOpts = "scrollbars=1,toolbar=no,location=no,directories=no,width="+width+",height="+height+",resizable=no,left="+LeftPosition+",top="+TopPosition;
	window.open(url,'readerEdit',winOpts);
}

/**
 * 탑메뉴 이동
 */
function fn_menuMove(prntId, url, nm, subId) {
	var fm = document.getElementById("fm");
	
	fm.target="_self";
	fm.action=url;
	fm.topMenuId.value = prntId;
	fm.topMenuNm.value = nm;
	fm.subMenuId.value = subId;
	fm.submit();
}
</script>
</head>
<body>
<div class="mainBody">
<form name="fm" id="fm" method="post">
	<input type="hidden" id="topMenuId" name="topMenuId" value="<%=topMenuId%>">
	<input type="hidden" id="topMenuNm" name="topMenuNm" value="<%=topMenuNm%>">
	<input type="hidden" id="subMenuId" name="subMenuId" value="<%=subMenuId%>">
</form> 
<c:set var="topMenuId" value="<%=topMenuId %>" />
<!--top 메뉴 롤오버 및 인클루드원함 될 예정 아직 미완성-->
<table style="width: 1200px;  height: 80px; padding: 0; border-collapse:collapse;"> 
	<col width="143px">
	<col width="1057px">
	<tr style="background-color: #f5f5f5; border-bottom: 6px solid #f48d2e"> 
		<td style="text-align: left; padding-left: 20px"><a href="/"><img src="/images/l_logo.jpg" border="0" /></a></td>
		<!-- 탑메뉴-->
		<td> 
			<div style="width: 1057px;">
				<div style="text-align: right; height: 30px; font-weight: bold; vertical-align: top; padding-top: 5px;">
					<a href="http://ezh.kr/hysystem" target="_blank"><font style="color: #ff0000; font-weight: bold"> 원격제어연결</font></a> <font size="1px;" color="d5d5d5">│</font> 
					<font class="logf"> <a href="http://shop.living24.co.kr/" target="_blank">소모품구매</a></font> <font size="1px;" color="d5d5d5">│</font><font class="logf"> 
					<a href="http://mcash.mk.co.kr:9900/Login/VerifyAdmLoginFrm.php?Url=/index.php" target="_blank">카드수금</a></font> <font size="1px;" color="d5d5d5">│</font>   
					<font class="logf"> <a href="/front/searchJikuk.jsp" target="_blank">지국찾기</a></font> <font size="1px;" color="d5d5d5">│</font>  
					<font class="logf"> <a href="/">HOME</a></font> <font size="1px;" color="d5d5d5">│</font> 
					<font class="logf"><a href="<%= ISiteConstant.URI_LOGOUT %>">LOGOUT</a></font>&nbsp;&nbsp;&nbsp;
				</div>
				<div style="padding-left:20px; height: 20px;">
					<div style="width: 880px; float: left; padding-bottom: 5px;">
						<c:forEach var="list" items="<%=menuList%>" varStatus="i">
							<c:if test="${list.PARENT_MENU_ID ==0}">
								<a href="#fakeUrl" style="text-decoration: none;" onclick="fn_menuMove('${list.MENU_ID}', '${list.MENU_URL}', '${list.MENU_NAME }' , '${list.SUB_MENU_ID }');">
									<c:choose>
										<c:when test="${topMenuId eq list.MENU_ID}" > 
											<span class="mainMenu_txt_on">${list.MENU_NAME }</span>
										</c:when>
										<c:otherwise>
											<span class="mainMenu_txt_off">${list.MENU_NAME }</span>
										</c:otherwise>
									</c:choose>
									<img src="/images/bt_top_line.gif" style="vertical-align: middle; border: 0;" />
								</a>
							</c:if>
						</c:forEach>
					</div>
					<div style="width: 150px;  height: 20px; float: left; text-align: right;"><font class="bname"><c:out value="<%= loginid %>" /> 님</font> 환영합니다.&nbsp;&nbsp;&nbsp;</div>
				</div> 
			</div> 
		</td>
	</tr>
	<!-- 
	<tr style="background-color :#f48d2e; height: 9px; width: 100%">
		<td colspan="2">
			<div style="padding: 10px 0; margin-left: 15px; margin-right: 15px;color: #fff; font-weight: bold; float: left; border: 0px solid red; width: 60px;">공지사항</div> 
			<div style="padding: 10px 0; float: left; border: 0px solid;  width: 1000px;">
				<img src="/images/ico/ico_new.png"  style="vertical-align: middle;"/> <span style="margin-top: 5px; font-weight: bold; vertical-align: middle;">스마트빌 전자계산서 관련 공지사항(2015년 1월 15일)</span>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<img src="/images/ico/ico_new.png"  style="vertical-align: middle;"/> <span style="margin-top: 5px; font-weight: bold; vertical-align: middle;">독자마케팅국 단합대회(2015년 1월 16일)</span>
			</div> 
		</td> 
	</tr>
	 -->
	<tr>
		<td style="vertical-align: top; background-color: #F46F2E; border-top:1px solid #de5613; ">
			<c:set var="topMenuId" value="<%=topMenuId%>"/> 
			<c:choose>
				<c:when test="${topMenuId eq null }">
					<!-- 자동이체건수 -->
					<div class="box_m1" style="border-left:1px solid #de5613; border-right:1px solid #de5613;">
						<!-- 지로입금 -->
						<div>
							<div><img src="/images/bt_left_jiro.gif" style="vertical-align:middle; border:0;" alt="" /></div>
							<div style="margin-left: 5px;">
								<div id="divGiroInfo" style="padding: 5px 0; display: none;">
									<p class="space5">총건수 : <b><span id="giroInfoCnt"></span></b> 건</p>
									<p class="space5">합계 : <b><span id="giroInfoTot"></span></b> 원</p>
								</div>
								<div id="divGiroInfo_load" style="text-align: center; padding: 12px 0;"><img src="/images/progress.gif" alt="" style="width: 40px"/></div> 
							</div> 
						</div>
						<!-- //지로입금 -->
						<!-- 자동이체 -->
						<div>
							<div><img src="/images/bt_left_ja.gif" style="vertical-align:middle; border:0" alt=""></div>
							<div style="padding: 10px 0; margin-left: 5px;">
								<div style="font-weight: bold; color: #000;">[일반]</div>
								<div id="divResultBill" style="display: none;"> 
									<p class="space5">총건수 : <b><span id="resultBillCnt"></span></b> 건</p>
									<p class="space5">합계 : <b><span id="resultBillTot"></span></b> 원</p>
								</div>
								<div id="divResultBill_load" style="text-align: center; padding: 7px 0;"><img src="/images/progress.gif" alt="" style="width: 40px"/></div> 
								<div style="font-weight: bold; color: #000; padding: 10px 0 0 0; border-top: 2px solid #e5e5e5; margin-right: 5px">[학생]</div>
								<div id="divResultBillStu"  style="display: none;"> 
									<p class="space5">총건수 : <b><span id="resultBillStuCnt"></span></b> 건</p>
									<p class="space5">합계 : <b><span id="resultBillStuTot"></span></b> 원</p>
								</div>
								<div id="divResultBillStu_load" style="text-align: center; padding: 7px 0;"><img src="/images/progress.gif" alt="" style="width: 40px"/></div>
							</div>
						</div>
						<!-- //자동이체 -->
					</div>
					<!-- //자동이체건수 -->
					<!-- 알림판 -->
					<div>
						<div style="border: 1px solid #de5613"><img src="/images/bt_left_alrim.gif" style="vertical-align:middle; border:0" alt=""></div>
						<div style="text-align: center; background-color: #F46F2E; height: 128px; border-left: 1px solid #de5613; border-right: 1px solid #de5613">
							<table  style="width: 138px; height: 126px; background-color: #fff; border: 0">
							    <tr><td align="left" valign="top"><img src="/images/alrim_box1.gif" style="vertical-align: middle;" alt=""></td></tr>
							    <tr><td style="word-break:break-all;" align="left">${mainInfo.CONT}</td></tr>
							    <tr><td align="left" valign="top"><img src="/images/alrim_box2.gif" style="vertical-align: middle;" alt=""></td></tr>
							</table>
						</div>
						<div class="line_m01" style="height: 1px"></div>
					</div>
					<!-- //알림판 -->
				</c:when>
				<c:otherwise>
					<c:set var="prntId" value="<%=topMenuId %>" />
					<c:set var="prntNm" value="<%=topMenuNm  %>" />
					<c:set var="subId" value="<%=subMenuId  %>" />
					<div class="subTitleBox"><div>${prntNm }</div></div>  
					<!-- 2depth menu list -->
					<c:forEach var="list" items="<%=menuList%>" varStatus="i">
						<c:if test="${list.PARENT_MENU_ID eq prntId && list.MENU_DEPTH eq 2}">			
							<div <c:if test="${subId eq list.MENU_ID }">class="box_m_on"</c:if> <c:if test="${subId ne list.MENU_ID }">class="box_m"</c:if>>
								<a href="#fakeUrl" style="text-decoration: none;" onclick="fn_menuMove('${list.PARENT_MENU_ID}', '${list.MENU_URL}', '${prntNm }', '${list.MENU_ID }');">${list.MENU_NAME }</a>
							</div>
							<div class="line_m01" style="height: 1px;" /></div>
							<div class="line_m02" style="height: 1px;" /></div>
							<!-- 3depth menu list -->
							<c:forEach var="listSub" items="<%=menuList%>" varStatus="state">
								<c:if test="${listSub.PARENT_MENU_ID eq list.MENU_ID  && listSub.MENU_DEPTH eq 3 && subId eq list.MENU_ID}">
									<div class="box_m_sub"><font class="left3Depth"><a href="#fakeUrl" style="text-decoration: none;" onclick="fn_menuMove('${list.PARENT_MENU_ID}', '${listSub.MENU_URL}', '${prntNm }', '${list.MENU_ID }');">${listSub.MENU_NAME }</a></font></div>
								</c:if>
							</c:forEach>
						</c:if>
					</c:forEach>
					<!-- 
					<div style="margin-top: 70px">
						<div class="subTitleBox"><div>공지사항</div></div>  
						<div style="text-align: center; background-color: #F46F2E; height: 128px; border-left: 1px solid #de5613; border-right: 1px solid #de5613">
							<table  style="width: 138px; height: 126px; background-color: #fff; border: 0">
							    <tr><td align="left" valign="top"><img src="/images/alrim_box1.gif" style="vertical-align: middle;" alt=""></td></tr>
							    <tr>
							    	<td style="word-break:break-all;" align="top">
						    			<img src="/images/ico/ico_new.png"  style="vertical-align: middle;"/> <span style="margin-top: 5px; font-weight: bold; vertical-align: middle;">스마트빌 전자계산서 관련 공지사항(2015년 1월 15일)</span>
										<br /> <br />
										<img src="/images/ico/ico_new.png"  style="vertical-align: middle;"/> <span style="margin-top: 5px; font-weight: bold; vertical-align: middle;">독자마케팅국 단합대회(2015년 1월 16일)</span>
							    	</td>
							    </tr>
							    <tr><td align="left" valign="top"><img src="/images/alrim_box2.gif" style="vertical-align: middle;" alt=""></td></tr>
							</table>
						</div>
						<div class="line_m01" style="height: 1px"></div>
					</div>
					 -->
				</c:otherwise>
			</c:choose>
		</td>
		<!-- main 내용--> 
		<td style="width: 1057px; vertical-align: top; height: 628px;">
			<div style="padding: 10px 0 15px 10px;  border-top: 1px solid #de5613; height: 628px; overflow-y: scroll" ><decorator:body><page:param name="topMenuId">${topMenuId }</page:param></decorator:body></div>
		</td>
		<!-- main 끝-->
	</tr>
</table>
<!-- 메인내용-->
<!-- footer start -->
<div style="text-align: center; width: 1200px; background-color: #cfcfcf; font-weight: bold; border-top: 1px solid #3b3b3b;">
	<img src="/images/l_bottom.gif" style="vertical-align: middle; border: 0;" /> Copyright ⓒ 2012 mk.co.kr  All right reserved.
</div>
<!-- footer end -->
</div> 
</body>
</html>