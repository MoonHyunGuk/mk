<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.security.*" %>

<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<html>
	<head><title>조건별명단</title>
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
            <param name="connection.reportname" value="/print/conditionList.ozr">
            <param name="viewer.configmode" value="html">
            <param name="viewer.isframe" value="false">
            <param name="viewer.namespace" value= "<%= ISiteConstant.OZ_VIEWER_NAME %>" >
            <param name="odi.odinames" value="conditionList">
            <param name="odi.conditionList.pcount" value="15">
            <param name="odi.conditionList.args1" value="boseq='<c:out value="${boseq}"/>'">
            <param name="odi.conditionList.args2" value="listType=<c:out value="${listType}"/>">
            <param name="odi.conditionList.args3" value="fromYyyymmdd=<c:out value="${fromYyyymmdd}"/>">
            <param name="odi.conditionList.args4" value="toYyyymmdd=<c:out value="${toYyyymmdd}"/>">
            <param name="odi.conditionList.args5" value="fromGno=<c:out value="${fromGno}"/>">
            <param name="odi.conditionList.args6" value="toGno=<c:out value="${toGno}"/>">
            <param name="odi.conditionList.args7" value="newsCd=<c:out value="${newsCd}"/>">
            <param name="odi.conditionList.args8" value="order=<c:out value="${order}"/>">
            <param name="odi.conditionList.args9" value="hiddenOpt2Sel1=<c:out value="${hiddenOpt2Sel1}"/>">
            <param name="odi.conditionList.args10" value="hiddenOpt2Sel2=<c:out value="${hiddenOpt2Sel2}"/>">
            <param name="odi.conditionList.args11" value="hiddenOpt2Sel3=<c:out value="${hiddenOpt2Sel3}"/>">
            <param name="odi.conditionList.args12" value="hiddenOpt2Sel4=<c:out value="${hiddenOpt2Sel4}"/>">
            <param name="odi.conditionList.args13" value="hiddenOpt1Text1=<c:out value="${hiddenOpt1Text1}"/>">
            <param name="odi.conditionList.args14" value="hiddenOpt1Text2=<c:out value="${hiddenOpt1Text2}"/>">
            <param name="odi.conditionList.args15" value="hiddenOpt2Text3=<c:out value="${hiddenOpt2Text3}"/>">
            <param name="odi.conditionList.clientdmtype" value="Memory">
            <param name="odi.conditionList.serverdmtype" value="Memory">
            <param name="odi.conditionList.fetchtype" value="Concurrent">
        </object>

    </body>
</html>
