<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
 <%
	String _User_Agent = (request.getHeader("User-Agent")).toUpperCase();
	String _SCALE = "1.0";
	
	if((_User_Agent.indexOf("MOBILE") > 0) || (_User_Agent.indexOf("LGTELECOM") > 0)) {
	 _SCALE = "1.0";
	} else if(_User_Agent.indexOf("SAMSUNG") > 0) {
	_SCALE = "0.8";
	} 
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<meta name="viewport" content="width=device-width; initial-scale=<%=_SCALE %>; maximum-scale=1.0; minimum-scale=1.0;">
<title>���ϰ��� ����������</title>
<style type="text/css">
body,input,textarea,select,table,button{font-size:0.6em;line-height:1.25em;font-family: Dotum,Helvetica,AppleGothic,Sans-serif}
input{padding: 0; margin: 0;}
.tb_edit_mobile {margin:0 auto; text-align:center; border-collapse:collapse; font:normal 1.0em Gulim, "����", Verdana, Geneva; }
.tb_edit_mobile th, .tb_edit_mobile td {padding:4px 1px; }
.tb_edit_mobile th {text-align:center; border:1px solid #c0c0c0; background-color: #eeeeee; font-weight: bold;}
.tb_edit_mobile td {text-align:center; border:1px solid #c0c0c0; background-color: #fff; }
</style>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
function fn_login(boseq, yymm) {
	$("#errorTxt").empty();
	var fm = document.getElementById("fm");
	
	$.ajax({
		type 		: "POST",
		url 		: "/mobile/jidae/chkJidaeLogin.do",
		dataType 	: "json",
		data		: "boseq="+boseq+"&logPw="+$("#logPw").val(),
		beforeSend	: function () {
			// �ε������� ȣ��
			//jQuery("#prcssDiv").show();
	    },
		success:function(data){
			var chkYn = data.chkYn;
			
			if("N" == chkYn) {
				$("#errorTxt").append("��й�ȣ�� Ȯ�����ּ���");
			} else if("Y" == chkYn) {
				alert
				fm.target="_self";
				fm.action="/mobile/jidae/jidaeViewForPersonal.do";
				fm.submit();
			}
		}, 
		complete 	: function () {
			// �ε� ����������
			//NProgress.done();
			//jQuery("#prcssDiv").hide();
	    },
		error    : function(r) { alert("ajax error"); }
	}); //ajax end
}
</script>
</head>
<body> 
<form method="post" name="fm" id="fm">
	<input type="hidden" name="boseq" id="boseq" value="${boseq}" />
	<input type="hidden" name="yymm" id="yymm" value="${yymm}" />
	<div style="width: 100%; overflow: hidden;">
		<div style="width: 100%; padding-top: 5px">
			<div style="float: left; width: 17%;"><img alt="���ϰ���" src="/images/ico_ci_mk.jpg" style="width: 48px"></div>
			<div style="float: left; width: 83%; background-color: #f36f21; height: 38px;"></div>
		</div>
		<div style="clear: both; width: 98%; margin: 0 auto; padding-top: 15px; padding-bottom: 10px; border-left: 3px solid #f36f21; border-right: 3px solid #f36f21; border-bottom: 3px solid #f36f21; ">
			<div style="width: 95%; margin: 0 auto;">
				<div style="font-weight: bold; font-size: 1.6em; border: 0px solid red; padding-bottom: 5px;">${fn:substring(yymm, 0, 4)}�� ${fn:substring(yymm, 4, 6)}����</div>
				<div style="font-weight: bold; font-size: 1.6em; border: 0px solid blue">���볳�α������� �α���</div>
				<div style="overflow: hidden; width: 198px; margin: 0 auto; padding: 15px 0; border: 0px solid red">
					<div style="float: left; width: 150px; overflow: hidden;">
						<input type="password" id="logPw" name="logPw" style="font-size: 23px; border: 1px solid #58585a; width: 149px; vertical-align: middle; border-radius:0; background:rgba(0,0,0,0); height: 30px" maxlength="7" placeholder="��й�ȣ"/>
					</div>
					<div style="padding: 10px 10px; background-color: #221e1f; width: 25px; float: left; color: #fff; font-size: 1.3em; cursor: pointer;" onclick="fn_login('${boseq}', '${yymm }')">
						Ȯ��
					</div>
				</div>
			</div>
		</div>
	</div>
	<div style="padding: 5px 10px; font-size: 1.4em; font-weight: bold;">
		<div>�� ��й�ȣ�� ���ڰ������α׷� �α��� ��й�ȣ�Դϴ�. </div> 
		<div style="padding-top: 5px">�� ���ڰ������α׷��� ������� �ʴ� ������ ������ �ֹι�ȣ ���ڸ�(7�ڸ�)�� �־��ּ���.</div>
	</div>
</form>
<div id="errorTxt" style="text-align: center; font-weight: bold; color: red; padding-top: 15px; font-size: 2.0em;"></div>
</body>
</html>