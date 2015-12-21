<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.security.*" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> 
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link rel="shortcut icon" href="http://img.mk.co.kr/main/2012/favicon1.ico">
<title>매일경제 독자 프로그램</title>
<style type="text/css">
body{ background-color: #F7F3E7; color: #000; margin: 0 }

#block { 
 position: absolute; 
 top: 50%;
 left: 50%;
 margin: -102px 0 0 -237px; /* DIV박스 크기의 1/2로 마진을 잡아줍니다. */
 border: 0px solid skyblue; 
} 
</style>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/js/jquery.cookie.js"></script>
<script type="text/javascript">
var browserUseYn = "Y";
/**
 * 브라우져 체크
 */
function fn_BrowserCheck() { 
	var agent = navigator.userAgent.toLowerCase();
	 
	if ( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) ) {
		browserUseYn = "Y";
	} else {
		alert("인터넷 익스플로러 브라우저가 아닙니다. \n매경CRM프로그램은 익스플로러에서만 정상 작동합니다.");
		browserUseYn = "N";
	}
}
	
$(function(){
	fn_BrowserCheck();
	
	$("#passwd").keydown(function(e){
		if(e.keyCode == 13)fn_check();
	});
	
	$("#btn_submit").click(function(){
		fn_check();
	});
	
	fn_check = function(){
		var userId = $("#userid").val();

		if(userId != "jong722") {
			if(browserUseYn == "N") {
				alert("지금 사용하고 있는 브라우저에서는 프로그램 사용이 불가능합니다. 인터넷익스플로러를 이용해서 프로그램을 사용해주세요.");
				return;
			}
		}
		
		if ($.trim($("#userid").val()) == "") {
			alert("아이디를 입력하세요.");
			$("#userid").focus();
			return;
		}
		if ($.trim($("#passwd").val()) == "") {
			alert("패스워드를 입력하세요.");
			$("#passwd").focus();
			return;
		}
		fncSaveCookie();
		login();
	};
	
	// 화면이 로딩되는 시점
	settingIdPw = function(){
		
	    if($.cookie("user_chk") == "true"){
	        // 저장 되있던 쿠키값들을 적용
	        $("input:checkbox[id='user_chk']").attr("checked",true);
	        $("#userid").val($.cookie("user_id"));
	        $("#passwd").val($.cookie("user_pwd"));
	    }else{
	    	$("#userid").focus();
	    }
	};
	
	login = function() {
		var actUrl = "/main/login.do";

	  //  var passwd = document.admin.passwd.value;

	  //  if(passwd.substr(0,2) == "mk"){
	  //  	actUrl = "http://218.144.58.97/main/login.do";
	  //  	document.admin.passwd.value = passwd.substr(2,20) ;
	  //  }
	    $("#admin").attr("action",actUrl).submit();
	};
	
	fncSaveCookie = function() {
	    // 체크가 되어있으면
	    if($("input:checkbox[id='user_chk']").is(":checked")){
	    	$.cookie("user_chk","true");
	    	$.cookie("user_id",$("#userid").val());
	    	$.cookie("user_pwd",$("#passwd").val());
	    }else{
	        // 값들을 쿠키에 제거
	        $.cookie('user_chk',null);
	        $.cookie('user_id',null);
	        $.cookie('user_pwd',null);
	    }
	};
	settingIdPw();
});
</script>
</head>
<body>
	<form name="admin" method="post" id="admin" action="/main/login.do" >
    <div id="block" style="width: 474px; height: 204px;">
    	<div><img src="/admin/images/mk_1.gif" width="473" height="63" border="0" alt="매일경제"></div>
    	<div style="background: url(/admin/images/mk_bg.gif) repeat-y; width:473px;">
    		<div style="background-color: #f7f7f7; width: 430px; margin: 0 auto; overflow: hidden;  padding: 10px 0;">
    			<div style="float: left; width: 120px; text-align: center;"><img src="/admin/images/mk_img.gif" width="64" height="85" border="0" alt=""></div>
    			<div style="float: left ;width: 210px;">
    				<div style="padding: 10px 0 5px 0; overflow: hidden;">
    					<div style="font-weight: bold; font-size: 9pt; width: 70px; float: left;"><div style="margin-top: 4px;"><font color="#CC0000">*</font> 아 이 디</div></div>
    					<div style="width: 130px; float: left;"><input type="text" name="userid" id="userid" style="font-size:9pt; width: 125px; vertical-align: middle;ime-mode: inactive;" tabindex="3" /></div>
    				</div>
    				<div style="clear: both; overflow: hidden;">
    					<div style="font-weight: bold; font-size: 9pt; width: 70px; float: left;"><div style="margin-top: 4px;"><font color="#CC0000">*</font> 비밀번호</div></div>
    					<div style="width: 130px; float: left;">
    						<input type="password" name="passwd" id="passwd" style="font-size:9pt; width: 125px; vertical-align: middle;" tabindex="4"/>
    					</div>
    				</div>
    				<div style="text-align: right; padding-top: 5px;">
    					<input type="checkbox" name="user_chk" id="user_chk" tabindex="5"><span style="font-size:9pt;">ID/PW 저장</span>
    					&nbsp;&nbsp;&nbsp;
    				</div>
    			</div>
    			<div style="float: left; width: 100px; overflow: hidden;">
    				<div style="padding: 20px 0 0 0; text-align: center;">
    					<a href="#fakeUrl" id="btn_submit" tabindex="6"><img src="/admin/images/mk_login.gif"  style="width: 47px; height: 44px; border: 0;" alt="로그인" /></a>
    				</div>
    			</div>
    		</div>
    	</div>
    	<div style="clear: both;"><img src="/admin/images/mk_2.gif" style="width: 473px; height: 17px" alt="" /></div>  
    </div>
    </form>
</body>
</html>