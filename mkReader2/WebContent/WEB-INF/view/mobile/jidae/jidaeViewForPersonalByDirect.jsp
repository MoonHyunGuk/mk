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
<meta name="viewport" content="width=device-width; initial-scale=<%=_SCALE %>; maximum-scale=3.0; minimum-scale=1.0; user-scalable=yes;">
<title>���ϰ��� ����������</title>
<style type="text/css">
body,input,textarea,select,table,button{font-size:0.6em;line-height:1.25em;font-family: Dotum,Helvetica,AppleGothic,Sans-serif}

.tb_edit_mobile {margin:0 auto; text-align:center; border-collapse:collapse; font:normal 1.0em Gulim, "����", Verdana, Geneva; }
.tb_edit_mobile th, .tb_edit_mobile td {padding:4px 1px; }
.tb_edit_mobile th {text-align:center; border:1px solid #c0c0c0; background-color: #eeeeee; font-weight: bold;}
.tb_edit_mobile td {text-align:center; border:1px solid #c0c0c0; background-color: #fff; }
</style>
</head>
<body>
<div style="width: 100%; padding-top: 5px">
	<div style="float: left; width: 17%;"><img alt="���ϰ���" src="/images/ico_ci_mk.jpg" style="width: 48px"></div>
	<div style="float: left; width: 83%; background-color: #f36f21; height: 38px;"></div>
</div>
<div style="clear: both; width: 98%; margin: 0 auto; padding-top: 10px; padding-bottom: 10px; border-left: 3px solid #f36f21; border-right: 3px solid #f36f21; border-bottom: 3px solid #f36f21; ">
	<div style="width: 95%; margin: 0 auto;">
		<div style="font-weight: bold; font-size: 1.4em; padding-bottom: 5px; text-align: center; overflow: hidden;">[���볳�α�������]</div>
		<div style="font-weight: bold; font-size: 1.4em; padding: 3px 0px; overflow: hidden;">${fn:substring(yymm, 0, 4)}�� ${fn:substring(yymm, 4, 6)}����</div>
		<table class="tb_edit_mobile" style="width: 100%">
			<colgroup>
				<col width="18%">
				<col width="32%">
				<col width="18%">
				<col width="32%">
			</colgroup>
			<tr>
				<th>�� �� ��</th>
				<td>${jidaeData.BOSEQNM}</td>
				<th>�ڵ��ȣ</th>
				<td>${jidaeData.BOSEQCODE}</td>
			</tr>
			<tr>
				<th>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</th>
				<td>������1��</td>
				<th>�������</th>
				<td>${jidaeData.AGENCYNM}</td>
			</tr>
		</table>
		<!-- ���볻�� -->
		<div style="padding-top: 10px;">
			<div style="font-weight: bold; font-size: 1.4em; padding-bottom: 3px">1. ���볻��</div>
			<table class="tb_edit_mobile" style="width: 100%">
				<colgroup>
					<col width="25%">
					<col width="25%">
					<col width="25%">
					<col width="25%">
				</colgroup>
				<tr>
					<th>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</th>
					<th>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</th>
					<th>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</th>
					<th>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</th>
				</tr>
				<tr>
					<th>�����̿���</th>
					<td><fmt:formatNumber value="${jidaeData.MISU}" pattern="#,###" /></td>
					<th>���������</th>
					<td style="font-weight: bold;"><fmt:formatNumber value="${jidaeData.CUSTOM}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th colspan="4">���� �Ա� ��Ȳ</th>
				</tr>
				<tr>
					<th>��������</th>
					<td><fmt:formatNumber value="${jidaeData.ETCGRANT}" pattern="#,###" /></td> 
					<th>�� ��</th>
					<td><fmt:formatNumber value="${jidaeData.BANK}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th>�� �� ��</th>
					<td><fmt:formatNumber value="${jidaeData.EDU}" pattern="#,###" /></td>
					<th>�� ��</th>
					<td><fmt:formatNumber value="${jidaeData.GIRO}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th>ī ��</th>
					<td><fmt:formatNumber value="${jidaeData.CARD}" pattern="#,###" /></td>
					<th></th>
					<td></td>
				</tr>
				<tr> 
					<th>�ڵ���ü</th>
					<td><fmt:formatNumber value="${jidaeData.AUTOBILL}" pattern="#,###" /></td>
					<th></th>
					<td></td>
				</tr>
				<tr> 
					<th>�л����</th>
					<td><fmt:formatNumber value="${jidaeData.STU}" pattern="#,###" /></td>
					<th></th>
					<td></td> 
				</tr>
				<tr> 
					<th>�ҿܰ���,NIE</th>
					<td><fmt:formatNumber value="${jidaeData.TMP1}" pattern="#,###" /></td>
					<th>�Ǹż�����(VAT)</th>
					<td><fmt:formatNumber value="${jidaeData.TMP6}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th>������</th>
					<td><fmt:formatNumber value="${jidaeData.TMP3}" pattern="#,###" /></td>
					<th>�Ұ�</th>
					<td style="font-weight: bold; color: blue;"><fmt:formatNumber value="${jidaeData.ETCGRANT+jidaeData.BANK+jidaeData.EDU+jidaeData.GIRO+jidaeData.CARD+jidaeData.AUTOBILL+jidaeData.STU+jidaeData.TMP1+jidaeData.TMP6+jidaeData.TMP3}" pattern="#,###" /></td>
				</tr>
			</table>
		</div>
		<!-- //���볻�� -->
		<!-- ������볳�γ��� -->
		<div style="padding-top: 10px;">
			<div style="font-weight: bold; font-size: 1.4em; padding-bottom: 3px">2. ��� ���� ���γ���</div>
			<table class="tb_edit_mobile" style="width: 100%">
				<colgroup>
					<col width="25%">
					<col width="25%">
					<col width="25%">
					<col width="25%">
				</colgroup>
				<tr>
					<th>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</th>
					<th>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</th>
					<th>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</th>
					<th>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</th>
				</tr>
				<tr>
					<th>������볳�Ծ�</th>
					<td  style="font-weight: bold; color: #bc0546"><fmt:formatNumber value="${jidaeData.J_REALAMT}" pattern="#,###" /></td>
					<th></th>
					<td></td> 
				</tr>
			</table>
		</div>
		<!-- //������볳�γ��� -->
		<!-- ������ ��Ȳ -->
		<div style="padding-top: 10px;">
			<div style="font-weight: bold; font-size: 1.4em; padding-bottom: 3px">3. ��Ÿ</div>
			<table class="tb_edit_mobile" style="width: 100%">
				<colgroup>
					<col width="25%">
					<col width="25%">
					<col width="25%">
					<col width="25%">
				</colgroup>
				<tr>
					<th>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</th>
					<th>�� �� �� ��</th>
					<th>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ƽ</th>
					<th>&nbsp;</th>
				</tr>
				<tr>
					<th style="height: 15px">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</th>
					<td><fmt:formatNumber value="${jidaeData.ECONOMY}" pattern="#,###" /></td>
					<td><fmt:formatNumber value="${jidaeData.CITY}" pattern="#,###" /></td>
					<td></td>
				</tr>
			</table>
		</div>
		<!-- //������ ��Ȳ -->
		<div style="width: 100%; text-align: center; padding-top: 5px; font-size: 1.1em">
			<div>��� �ݾ��� ���� �����Ͽ��� ������ ��� ���� ��û�Ͽ� �ֽñ� �ٶ��ϴ�.</div>
			<div style="padding-top: 5px">����Ư���� �߱� ����</div>
			<div style="padding-top: 5px; font-weight: bold;">(��)���ϰ����Ź���</div>
			<div style="padding-top: 5px;">���ڸ����ñ��� ������ <img alt="����" src="/images/stemp.png" style="width: 20px; vertical-align: middle;"></div>
		</div>
	</div>
</div>
</body>
</html>