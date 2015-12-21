<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.security.*" %>

<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<html>
	<head><title>방문영수증</title>
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
            <param name="connection.reportname" value="/output/abc/<c:out value="${type}"/>.ozr">
            <param name="viewer.configmode" value="html">
            <param name="viewer.isframe" value="false">
            <param name="viewer.namespace" value= "<%= ISiteConstant.OZ_VIEWER_NAME %>" >
            <param name="odi.odinames" value="visitBill">
            <param name="odi.visitBill.pcount" value="15">
            <param name="odi.visitBill.args1" value="userId='<c:out value="${userId}"/>'">
            <param name="odi.visitBill.args2" value="newsCd=<c:out value="${newsCd}"/>">
            <param name="odi.visitBill.args3" value="sugm=<c:out value="${sugm}"/>">
            <param name="odi.visitBill.args4" value="reader=<c:out value="${reader}"/>">
            <param name="odi.visitBill.args5" value="guyukSql=<c:out value="${guyukSql}"/>">
            <param name="odi.visitBill.args6" value="noti='<c:out value="${noti}"/>'">
            <param name="odi.visitBill.args7" value="prtCb='<c:out value="${prtCb}"/>'">
            <param name="odi.visitBill.args8" value="month=<c:out value="${month}"/>">
            <param name="odi.visitBill.args9" value="misuPrt='<c:out value="${misuPrt}"/>'">
            <param name="odi.visitBill.args10" value="misuOnly=<c:out value="${misuOnly}"/>">
            <param name="odi.visitBill.args11" value="misuSum='<c:out value="${misuSum}"/>'">
            <param name="odi.visitBill.args12" value="remkPrt='<c:out value="${remkPrt}"/>'">
            <param name="odi.visitBill.args13" value="all='<c:out value="${all}"/>'">
            <param name="odi.visitBill.args14" value="subs='<c:out value="${subs}"/>'">
            <param name="odi.visitBill.args15" value="visitSndt='<c:out value="${visitSndt}"/>'">
            <param name="odi.visitBill.clientdmtype" value="Memory">
            <param name="odi.visitBill.serverdmtype" value="Memory">
            <param name="odi.visitBill.fetchtype" value="Concurrent">
        </object>

    </body>
</html>
