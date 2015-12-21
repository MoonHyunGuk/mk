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
 <!-- �λ��������� ��Ÿ������� �Ⱥ�������, �Ұ� �� �ǳ��Ծ׿����� ��Ÿ����� �ݾ� ���� 2015.01,05-->
 <c:set var="chkBusan" value="${fn:substring(jidaeData.BOSEQCODE, 0, 2) }" />
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
				<td>${jidaeData.TYPE}</td>
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
					<td><fmt:formatNumber value="${jidaeData.CUSTOM}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th colspan="3">���� �������� �� �����ݾ�</th>
					<td>
						<c:choose>
							<c:when test="${chkBusan ne '76'}">
								<fmt:formatNumber value="${jidaeData.SUBTOTAL}" pattern="#,###" />
							</c:when>
							<c:otherwise>
								<fmt:formatNumber value="${jidaeData.SUBTOTAL-jidaeData.TMP4}" pattern="#,###" />
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<th><c:if test="${jidaeData.BUSUGRANT != null}">�μ����������</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.BUSUGRANT}" pattern="#,###" /></td>
					<th><c:if test="${jidaeData.TMP1 != null}">�ҿܰ���,NIE</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.TMP1}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th><c:if test="${jidaeData.STUGRANT != null}">�� �� �� �� ��</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.STUGRANT}" pattern="#,###" /></td>
					<th><c:if test="${jidaeData.TMP2 != null}">������</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.TMP2}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th><c:if test="${jidaeData.ETCGRANT != null}">�� Ÿ �� �� ��</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.ETCGRANT}" pattern="#,###" /></td>
					<th><c:if test="${jidaeData.TMP3 != null}">�������</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.TMP3}" pattern="#,###" /></td>
				</tr>
				<tr> 
					<th><c:if test="${jidaeData.CARD != null}">ī&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.CARD}" pattern="#,###" /></td>
					<th><c:if test="${jidaeData.TMP4 != null}"><c:if test="${chkBusan ne '76'}">��Ÿ</c:if></c:if></th>
					<td><c:if test="${chkBusan ne '76'}"><fmt:formatNumber value="${jidaeData.TMP4}" pattern="#,###" /></c:if></td>
				</tr>
				<tr> 
					<th><c:if test="${jidaeData.EDU != null}">��&nbsp;&nbsp;&nbsp;��&nbsp;&nbsp;&nbsp;��</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.EDU}" pattern="#,###" /></td>
					<th><c:if test="${jidaeData.TMP5 != null}">��&nbsp;&nbsp;��&nbsp;/&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.TMP5}" pattern="#,###" /></td>
				</tr>
				<tr> 
					<th><c:if test="${jidaeData.AUTOBILL != null}">��&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;ü</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.AUTOBILL}" pattern="#,###" /></td>
					<th><c:if test="${jidaeData.TMP6 != null}">�Ǹż�����(VAT)</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.TMP6}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th><c:if test="${jidaeData.STU != null}">��&nbsp;&nbsp;��&nbsp;&nbsp;��&nbsp;&nbsp;��</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.STU}" pattern="#,###" /></td>
					<th><c:if test="${jidaeData.TMP7 ne null}">��&nbsp;��&nbsp;��&nbsp;&nbsp;��&nbsp;ü</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.TMP7}" pattern="#,###" /></td> 
				</tr>
			</table>
			<c:if test="${jidaeData.TMP7 ne null}">
				<div style="padding-top: 3px">������������ ���� ��ü�� �ϳ������� �����Ͽ� �����ϴ� ���� ��Ģ���� �մϴ�. �� �̼��� ��ü�� ���ܵɼ� �ֽ��ϴ�.</div>
			</c:if>
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
					<th>����ǳ��Ծ�</th>
					<td style="font-weight: bold;">
						<c:choose>
							<c:when test="${chkBusan ne '76'}">
								<fmt:formatNumber value="${jidaeData.J_REALAMT}" pattern="#,###" />
							</c:when> 
							<c:otherwise>
								<fmt:formatNumber value="${jidaeData.J_REALAMT+jidaeData.TMP4}" pattern="#,###" />
							</c:otherwise>
						</c:choose>
					</td>
					<th>�� �� �� �� ��</th>
					<td>
						<c:choose>
							<c:when test="${chkBusan ne '76'}">
								<fmt:formatNumber value="${jidaeData.J_OVERDATE}" pattern="#,###" />
							</c:when> 
							<c:otherwise>
								<fmt:formatNumber value="${jidaeData.J_OVERDATE+jidaeData.TMP4}" pattern="#,###" />
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<th>�� �� �� �� ��</th>
					<td><fmt:formatNumber value="${jidaeData.J_OKGRANT1}" pattern="#,###" /></td>
					<th>�� �� �� �� ��</th>
					<td><fmt:formatNumber value="${jidaeData.J_OKGRANT2}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th>�� �� �� �� ��</th>
					<td style="font-weight: bold; color: blue">
						<c:choose>
							<c:when test="${chkBusan ne '76'}">
								<fmt:formatNumber value="${jidaeData.J_DUEDATE}" pattern="#,###" />
							</c:when> 
							<c:otherwise>
								<fmt:formatNumber value="${jidaeData.J_DUEDATE+jidaeData.TMP4}" pattern="#,###" />
							</c:otherwise>
						</c:choose>
					</td>
					<th>������볳�Ծ�</th>
					<td style="font-weight: bold; color: #bc0546">
						<c:choose>
							<c:when test="${chkBusan ne '76'}">
								<fmt:formatNumber value="${jidaeData.J_PAYAMT}" pattern="#,###" />
							</c:when> 
							<c:otherwise>
								<fmt:formatNumber value="${jidaeData.J_PAYAMT+jidaeData.TMP4}" pattern="#,###" />
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
			</table>
			<c:if test="${fn:substring(jidaeData.BOSEQCODE,0,2) ne '52'}">
				<div style="padding-top: 3px">�ؿϳ�������� ���� ���ϳ��� �۱��ϼž� ������ ������ �� �ֽ��ϴ�.</div>
			</c:if>
		</div>
		<!-- //������볳�γ��� -->
		<!-- ������ ��Ȳ -->
		<div style="padding-top: 10px;">
			<div style="font-weight: bold; font-size: 1.4em; padding-bottom: 3px">3. ������ ��Ȳ <span style="font-weight: 1.0e">(${jidaeData.PREVMONTH }���� ���� �� ��������)</span></div>
			<table class="tb_edit_mobile" style="width: 100%">
				<colgroup>
					<col width="25%">
					<col width="25%"> 
					<col width="25%">
					<col width="25%">
				</colgroup>
				<tr>
					<th>�����̿���</th>
					<th>����߻���</th>
					<th>������Ҿ�</th>
					<th>�������ܾ�</th>
				</tr>
				<tr>
					<td style="height: 15px"><fmt:formatNumber value="${jidaeData.D_MISU}" pattern="#,###" /></td>
					<td><fmt:formatNumber value="${jidaeData.D_HAPPEN}" pattern="#,###" /></td>
					<td><fmt:formatNumber value="${jidaeData.D_MINUS}" pattern="#,###" /></td>
					<td><fmt:formatNumber value="${jidaeData.D_BALANCE}" pattern="#,###" /></td>
				</tr>
			</table>
		</div>
		<!-- //������ ��Ȳ -->
		<!-- �۱ݾȳ� -->
		<div style="padding-top: 10px;">
			<div style="font-weight: bold; font-size: 1.4em; padding-bottom: 3px">4. �۱ݾȳ�(������ : ���ϰ����Ź��� ���ȯ)</div>
			<table class="tb_edit_mobile" style="width: 100%">
				<colgroup>
					<col width="18%">
					<col width="32%">
					<col width="18%">
					<col width="32%">
				</colgroup>
				<tr>
					<th>�� �� ��</th>
					<th>�� �� �� ȣ</th>
					<th>�� �� ��</th>
					<th>�� �� �� ȣ</th>
				</tr>
				<tr>
					<th>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</th>
					<td>${jidaeData.JIDAE_BANK1}</td>
					<th>�츮����</th>
					<td>${jidaeData.JIDAE_BANK2}</td>
				</tr>
				<tr>
					<th><c:if test="${jidaeData.JIDAE_BANK3 != null}">��������</c:if>&nbsp;</th>
					<td>${jidaeData.JIDAE_BANK3}</td>
					<th><c:if test="${jidaeData.JIDAE_BANK4 != null}">�� ü ��</c:if>&nbsp;</th>
					<td>${jidaeData.JIDAE_BANK4}</td>
				</tr>
			</table>
		</div>
		<!-- //�۱ݾȳ� -->
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