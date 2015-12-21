<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.security.*" %>

<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<html>
	<head><title>통 계</title>
	    <style type="text/css">
				html, 
				body { 
				height: 100%; 
				} 
	    </style>
    
    <script language="javascript" src="http://<%= ISiteConstant.OZ_DOWNLOAD_SERVER %>/js/ozinstall.js"></script>   
      
    </head>
    <body topmargin="0" leftmargin="0">

             <script language="javascript">
                	function oz_activex_build (paramTag) {
                		for (var i = 0 ; i < paramTag.length ; i++)
                			document.write(paramTag[i]);
                	}

                	var oz_url		= "<%= ISiteConstant.OZ_SERVLET_SERVER %>";
                	var oz_port		= "<%= ISiteConstant.OZ_DOWNLOAD_PORT %>";
                	var oz_viewer		= "/oz51/ozrviewer";
                	var oz_version		= "<%= ISiteConstant.OZ_VIEWER_VERSION %>";
                	var oz_namespace	= "<%= ISiteConstant.OZ_VIEWER_NAME %>";
                	var oz_serverurl	= oz_url + ":" + oz_port + "/oz51/server";
            </script>

            <center>

            <div id="InstallOZViewer">
            <script language="javascript">
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
            <param name="connection.reportname" value="/statistics/<c:out value="${type}"/>.ozr">
            <param name="viewer.configmode" value="html">
            <param name="viewer.isframe" value="false">
            <param name="viewer.namespace" value= "<%= ISiteConstant.OZ_VIEWER_NAME %>" >
            <param name="odi.odinames" value="statistics">
            <param name="odi.statistics.pcount" value="8">
            <param name="odi.statistics.args1" value="BOSEQ=<c:out value="${BOSEQ}"/>">
            <param name="odi.statistics.args2" value="NEWSCD=<c:out value="${NEWSCD}"/>">
            <param name="odi.statistics.args3" value="YYMM=<c:out value="${YYMM}"/>">
            <param name="odi.statistics.args4" value="STATS=<c:out value="${STATS}"/>">
            <param name="odi.statistics.args5" value="CODE_SUGM_AMT=<c:out value="${CODE_SUGM_AMT}"/>">
            <param name="odi.statistics.args6" value="TYPE=<c:out value="${type}"/>">
            <param name="odi.statistics.args7" value="FROMYYMMDD=<c:out value="${FROMYYMMDD}"/>">
            <param name="odi.statistics.args8" value="TOYYMMDD=<c:out value="${TOYYMMDD}"/>">
            <param name="odi.statistics.clientdmtype" value="Memory">
            <param name="odi.statistics.serverdmtype" value="Memory">
            <param name="odi.statistics.fetchtype" value="Concurrent">
        </object>

    </body>
</html>
