<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.security.*" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% 
	String abcYn = (String)session.getAttribute(ISiteConstant.SESSION_NAME_ABC_CHK);
%>
<html>
	<head><title>독자원장</title>
	    <style type="text/css">
				html, 
				body { 
				height: 100%; 
				} 
	    </style>
    
    <script type="text/javascript" src="http://<%= ISiteConstant.OZ_DOWNLOAD_SERVER %>/js/ozinstall.js"></script>   
      
    </head>
    <body topmargin="0" leftmargin="0" style="text-align: center;">

             <script type="text/javascript">
                	function oz_activex_build (paramTag) {
                		for (var i = 0 ; i < paramTag.length ; i++)
                			document.write(paramTag[i]);
                	}

                	var oz_url		= "<%= ISiteConstant.OZ_DOWNLOAD_SERVER %>";
                	var oz_port		= "<%= ISiteConstant.OZ_DOWNLOAD_PORT %>";
                	var oz_viewer		= "/ozrviewer";
                	var oz_version		= "<%= ISiteConstant.OZ_VIEWER_VERSION %>";
                	var oz_namespace	= "<%= ISiteConstant.OZ_VIEWER_NAME %>";
                	var oz_serverurl	= oz_url + ":" + oz_port + "/oz51/server";
            </script>

            <div id="InstallOZViewer">
            <script type="text/javascript">
            		Initialize_ZT("ZTransferX"		,oz_url + ":" + oz_port + oz_viewer + "/ZTransferX.cab#version=" + oz_version, "CLSID:C7C7225A-9476-47AC-B0B0-FF3B79D55E67", "0", "0");
            		Insert_ZT_Param("download.Server"	,oz_url + oz_viewer + "/");
            		Insert_ZT_Param("download.Port"		,oz_port);
            		Insert_ZT_Param("download.Instruction"	,"ozrviewer.idf");
            		Insert_ZT_Param("install.Base"		,"<PROGRAMS>/Forcs");
            		Insert_ZT_Param("install.Namespace"	,oz_namespace);
            		Insert_ZT_Param("messagetitle"		,"Now installing OZViewer on your system. Please Wait...");
            		Start_ZT(oz_url + ":" + oz_port + oz_viewer + "/");
            </script>
            </div>


           <object id="ozviewer"  CLASSID="CLSID:0DEF32F8-170F-46f8-B1FF-4BF7443F5F25"  width="100%"   height="100%">
            <param name="connection.servlet" value="<%= ISiteConstant.OZ_SERVLET_SERVER %>">
<%
	if("Y".equals(abcYn)) {
%>           
            <param name="connection.reportname" value="/reader/abc/${target}.ozr">
<%
	} else {
%>
			 <param name="connection.reportname" value="/reader/${target}.ozr">        
<%
	}
%>    
            <param name="viewer.configmode" value="html">
            <param name="viewer.isframe" value="false">
            <param name="viewer.namespace" value= "<%= ISiteConstant.OZ_VIEWER_NAME %>" >
            <param name="odi.odinames" value="readerWonJang">
            <param name="odi.readerWonJang.pcount" value="8">
            <param name="odi.readerWonJang.args1" value="agency_serial='<c:out value="${agency_serial}"/>'">
            <param name="odi.readerWonJang.args2" value="guyukSql=<c:out value="${guyukSql}"/>">
            <param name="odi.readerWonJang.args3" value="newsCd=<c:out value="${newsCd}"/>">
            <param name="odi.readerWonJang.args4" value="readTypeCd=<c:out value="${readTypeCd}"/>">
            <param name="odi.readerWonJang.args5" value="terms1='<c:out value="${terms1}"/>'">
            <param name="odi.readerWonJang.args6" value="terms3='<c:out value="${terms3}"/>'">
            <param name="odi.readerWonJang.args7" value="terms5='<c:out value="${terms5}"/>'">
            <param name="odi.readerWonJang.args8" value="nowYYMM='<c:out value="${nowYYMM}"/>'">
            <param name="odi.readerWonJang.clientdmtype" value="Memory">
            <param name="odi.readerWonJang.serverdmtype" value="Memory">
            <param name="odi.readerWonJang.fetchtype" value="Concurrent">
        </object>

    </body>
</html>
