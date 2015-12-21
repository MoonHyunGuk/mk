<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.security.*" %>

<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<html>
	<head><title>방문수금 장부</title>
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

                	var oz_url		= "<%= ISiteConstant.OZ_DOWNLOAD_SERVER %>";
                	var oz_port		= "<%= ISiteConstant.OZ_DOWNLOAD_PORT %>";
                	var oz_viewer		= "/ozrviewer";
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
            <param name="connection.reportname" value="/collection/visitSugmList.ozr">
            <param name="viewer.configmode" value="html">
            <param name="viewer.isframe" value="false">
            <param name="viewer.namespace" value= "<%= ISiteConstant.OZ_VIEWER_NAME %>" >
            <param name="odi.odinames" value="visitSugmList">
            <param name="odi.visitSugmList.pcount" value="3">
            <param name="odi.visitSugmList.args1" value="BOSEQ=<c:out value="${boseq}"/>">
            <param name="odi.visitSugmList.args2" value="SDATE=<c:out value="${fromDate}"/>">
            <param name="odi.visitSugmList.args3" value="EDATE=<c:out value="${toDate}"/>">            
            <param name="odi.visitSugmList.clientdmtype" value="Memory">
            <param name="odi.visitSugmList.serverdmtype" value="Memory">
            <param name="odi.visitSugmList.fetchtype" value="Concurrent">
        </object>

    </body>
</html>
