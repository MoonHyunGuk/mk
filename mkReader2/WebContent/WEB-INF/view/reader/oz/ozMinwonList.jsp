<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.security.*" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% 
	String abcYn = (String)session.getAttribute(ISiteConstant.SESSION_NAME_ABC_CHK);
%>
<html>
	<head><title>민원리스트</title>
	    <style type="text/css">
				html, 
				body { 
				height: 100%; 
				} 
	    </style>
    
    <script type="text/javascript" src="http://<%= ISiteConstant.OZ_DOWNLOAD_SERVER %>/js/ozinstall.js"></script>   
      
    </head>
    <body topmargin="0" leftmargin="0" style="text-align:center;">

             <script type="text/javascript" >
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
            <script type="text/javascript" >
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
            <param name="connection.reportname" value="/reader/minwonList.ozr">
            <param name="viewer.configmode" value="html">
            <param name="viewer.isframe" value="false">
            <param name="viewer.namespace" value= "<%= ISiteConstant.OZ_VIEWER_NAME %>" >
            <param name="odi.odinames" value="minwonList">
            <param name="odi.minwonList.pcount" value="8">
            <param name="odi.minwonList.args1" value="fromDate='<c:out value="${fromDate}"/>'">
            <param name="odi.minwonList.args2" value="toDate='<c:out value="${toDate}"/>'">
            <param name="odi.minwonList.args3" value="search_value=${search_value}">
            <param name="odi.minwonList.args4" value="search_type=${search_type}">
            <param name="odi.minwonList.args5" value="userId=${userId}">
            <param name="odi.minwonList.args6" value="morningWorker=${morningWorker}">
            <param name="odi.minwonList.args7" value="lunchWorker=${lunchWorker}">
            <param name="odi.minwonList.args8" value="dinnerWorker=${dinnerWorker}">
            <param name="odi.minwonList.clientdmtype" value="Memory">
            <param name="odi.minwonList.serverdmtype" value="Memory">
            <param name="odi.minwonList.fetchtype" value="Concurrent">
        </object>

    </body>
</html>
