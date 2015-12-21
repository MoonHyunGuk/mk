<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<head>
    <title>FileUploader Callback</title>
</head>
<body>
<input type="hidden" id="fullFilePath" name="fullFilePath" value="${FilePath}"/>
    <script type="text/javascript">
    	var oFileInfo = "<img src='"+$("fullFilePath").value+"'/>" ;

    	parent.parent.setPhotoToEditor(oFileInfo);
    	parent.parent.window.close();
    </script>
</body>
</html>
 