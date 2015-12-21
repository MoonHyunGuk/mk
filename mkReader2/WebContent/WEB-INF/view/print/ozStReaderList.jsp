<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.security.*" %>

<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<html>
	<head><title>해지독자명단</title>
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
            <param name="connection.reportname" value="/print/<c:out value="${type}"/>.ozr">
            <param name="viewer.configmode" value="html">
            <param name="viewer.isframe" value="false">
            <param name="viewer.namespace" value= "<%= ISiteConstant.OZ_VIEWER_NAME %>" >
            
             <param name="odi.odinames" value="stReaderList">
            <param name="odi.stReaderList.pcount" value="10">
            <param name="odi.stReaderList.args1" value="boseq='<c:out value="${boseq}"/>'">
            <param name="odi.stReaderList.args2" value="check=<c:out value="${check}"/>">
            <param name="odi.stReaderList.args3" value="fromGno=<c:out value="${fromGno}"/>">
            <param name="odi.stReaderList.args4" value="toGno=<c:out value="${toGno}"/>">
            <param name="odi.stReaderList.args5" value="fromDate='<c:out value="${fromDate}"/>'">
            <param name="odi.stReaderList.args6" value="toDate='<c:out value="${toDate}"/>'">
            <param name="odi.stReaderList.args7" value="searchText=<c:out value="${searchText}"/>">
            <param name="odi.stReaderList.args8" value="stSayou=<c:out value="${stSayou}"/>">
            <param name="odi.stReaderList.args9" value="newsCd=<c:out value="${newsCd}"/>">
            <param name="odi.stReaderList.args10" value="sort=<c:out value="${sort}"/>">
            <param name="odi.stReaderList.clientdmtype" value="Memory">
            <param name="odi.stReaderList.serverdmtype" value="Memory">
            <param name="odi.stReaderList.fetchtype" value="Concurrent">
        </object>

    </body>
</html>
