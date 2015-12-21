<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40">
<head>
<style>
<!--table
	{mso-displayed-decimal-separator:"\.";
	mso-displayed-thousand-separator:"\,";}
.font517062
	{color:windowtext;
	font-size:8.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;}
.xl6517062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl6617062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border:.5pt solid windowtext;
	background:white;
	mso-pattern:auto none;
	white-space:normal;}
.xl6717062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:General;
	text-align:general;
	vertical-align:middle;
	background:silver;
	mso-pattern:auto none;
	white-space:nowrap;}
.xl6817062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:General;
	text-align:general;
	vertical-align:middle;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl6917062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border:.5pt solid windowtext;
	background:#33CCCC;
	mso-pattern:auto none;
	white-space:normal;}
.xl7017062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:"_-* \#\,\#\#0_-\;\\-* \#\,\#\#0_-\;_-* \0022-\0022_-\;_-\@_-";
	text-align:center;
	vertical-align:middle;
	border:.5pt solid windowtext;
	background:#33CCCC;
	mso-pattern:auto none;
	white-space:normal;}
.xl7117062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	background:silver;
	mso-pattern:auto none;
	white-space:nowrap;}
.xl7217062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:General;
	text-align:general;
	vertical-align:middle;
	border:.5pt solid windowtext;
	background:white;
	mso-pattern:auto none;
	white-space:normal;}
.xl7317062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:"\#\,\#\#0";
	text-align:general;
	vertical-align:middle;
	border:.5pt solid windowtext;
	background:white;
	mso-pattern:auto none;
	white-space:normal;}
.xl7417062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border:.5pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:normal;}
.xl7517062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:"_-* \#\,\#\#0_-\;\\-* \#\,\#\#0_-\;_-* \0022-\0022_-\;_-\@_-";
	text-align:general;
	vertical-align:middle;
	border:.5pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl7617062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:"\#\,\#\#0";
	text-align:general;
	vertical-align:middle;
	border:.5pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:normal;}
.xl7717062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border:.5pt solid windowtext;
	background:#33CCCC;
	mso-pattern:auto none;
	white-space:normal;}
.xl7817062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:"\#\,\#\#0";
	text-align:general;
	vertical-align:middle;
	border:.5pt solid windowtext;
	background:#33CCCC;
	mso-pattern:auto none;
	white-space:normal;}
.xl7917062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:"_-* \#\,\#\#0_-\;\\-* \#\,\#\#0_-\;_-* \0022-\0022_-\;_-\@_-";
	text-align:general;
	vertical-align:middle;
	border:.5pt solid windowtext;
	background:#33CCCC;
	mso-pattern:auto none;
	white-space:nowrap;}
.xl8017062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:General;
	text-align:general;
	vertical-align:middle;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl8117062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:General;
	text-align:general;
	vertical-align:middle;
	background:silver;
	mso-pattern:auto none;
	white-space:nowrap;}
.xl8217062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:"\#\,\#\#0";
	text-align:center;
	vertical-align:middle;
	border:.5pt solid windowtext;
	background:#33CCCC;
	mso-pattern:auto none;
	white-space:normal;}
.xl8317062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:"\#\,\#\#0";
	text-align:general;
	vertical-align:middle;
	border:.5pt solid windowtext;
	background:white;
	mso-pattern:auto none;
	white-space:normal;}
.xl8417062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:"_-* \#\,\#\#0_-\;\\-* \#\,\#\#0_-\;_-* \0022-\0022_-\;_-\@_-";
	text-align:general;
	vertical-align:middle;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl8517062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:"_-* \#\,\#\#0_-\;\\-* \#\,\#\#0_-\;_-* \0022-\0022_-\;_-\@_-";
	text-align:general;
	vertical-align:middle;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl8617062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:"_-* \#\,\#\#0_-\;\\-* \#\,\#\#0_-\;_-* \0022-\0022_-\;_-\@_-";
	text-align:right;
	vertical-align:middle;
	border:.5pt solid windowtext;
	background:white;
	mso-pattern:auto none;
	white-space:normal;}
.xl8717062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:"_-* \#\,\#\#0_-\;\\-* \#\,\#\#0_-\;_-* \0022-\0022_-\;_-\@_-";
	text-align:right;
	vertical-align:middle;
	border:.5pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:normal;}
.xl8817062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:"_-* \#\,\#\#0_-\;\\-* \#\,\#\#0_-\;_-* \0022-\0022_-\;_-\@_-";
	text-align:right;
	vertical-align:middle;
	border:.5pt solid windowtext;
	background:#33CCCC;
	mso-pattern:auto none;
	white-space:normal;}
.xl8917062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:"_-* \#\,\#\#0_-\;\\-* \#\,\#\#0_-\;_-* \0022-\0022_-\;_-\@_-";
	text-align:right;
	vertical-align:middle;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl9017062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:"\#\,\#\#0";
	text-align:general;
	vertical-align:middle;
	background:white;
	mso-pattern:auto none;
	white-space:normal;}
.xl9117062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:normal;}
.xl9217062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:"\#\,\#\#0";
	text-align:center;
	vertical-align:middle;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:normal;}
.xl9317062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:"\#\,\#\#0";
	text-align:general;
	vertical-align:middle;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:normal;}
.xl9417062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:"_-* \#\,\#\#0_-\;\\-* \#\,\#\#0_-\;_-* \0022-\0022_-\;_-\@_-";
	text-align:right;
	vertical-align:middle;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:normal;}
.xl9517062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:"_-* \#\,\#\#0_-\;\\-* \#\,\#\#0_-\;_-* \0022-\0022_-\;_-\@_-";
	text-align:center;
	vertical-align:middle;
	border:.5pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl9617062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:"_-* \#\,\#\#0_-\;\\-* \#\,\#\#0_-\;_-* \0022-\0022_-\;_-\@_-";
	text-align:general;
	vertical-align:middle;
	border:.5pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl9717062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	border:.5pt solid windowtext;
	background:#FFFF99;
	mso-pattern:auto none;
	white-space:normal;}
.xl9817062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:"\#\,\#\#0";
	text-align:general;
	vertical-align:middle;
	border:.5pt solid windowtext;
	background:#FFFF99;
	mso-pattern:auto none;
	white-space:normal;}
.xl9917062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:"_-* \#\,\#\#0_-\;\\-* \#\,\#\#0_-\;_-* \0022-\0022_-\;_-\@_-";
	text-align:right;
	vertical-align:middle;
	border:.5pt solid windowtext;
	background:#FFFF99;
	mso-pattern:auto none;
	white-space:normal;}
.xl10017062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:"_-* \#\,\#\#0_-\;\\-* \#\,\#\#0_-\;_-* \0022-\0022_-\;_-\@_-";
	text-align:general;
	vertical-align:middle;
	border:.5pt solid windowtext;
	background:#FFFF99;
	mso-pattern:auto none;
	white-space:nowrap;}
.xl10117062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:General;
	text-align:general;
	vertical-align:middle;
	border:.5pt solid windowtext;
	background:#FFFF99;
	mso-pattern:auto none;
	white-space:normal;}
.xl10217062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:General;
	text-align:general;
	vertical-align:middle;
	border:.5pt solid windowtext;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:normal;}
.xl10317062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#CCFFFF;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:General;
	text-align:general;
	vertical-align:middle;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl10417062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#CCFFFF;
	font-size:10.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl10517062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:#CCFFFF;
	font-size:10.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:General;
	text-align:general;
	vertical-align:middle;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
.xl10617062
	{padding-top:1px;
	padding-right:1px;
	padding-left:1px;
	mso-ignore:padding;
	color:windowtext;
	font-size:12.0pt;
	font-weight:700;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-number-format:General;
	text-align:center;
	vertical-align:middle;
	mso-background-source:auto;
	mso-pattern:auto;
	white-space:nowrap;}
ruby
	{ruby-align:left;}
rt
	{color:windowtext;
	font-size:8.0pt;
	font-weight:400;
	font-style:normal;
	text-decoration:none;
	font-family:돋움, monospace;
	mso-font-charset:129;
	mso-char-type:none;}
-->
</style>
</head>

<body>
<!--[if !excel]>　　<![endif]-->
<!--다음 내용은 Microsoft Excel의 웹 게시 마법사를 사용하여 작성되었습니다.-->
<!--같은 내용의 항목이 다시 나타나면, DIV 태그 사이에 있는 정보가 변경될 것입니다.-->
<!----------------------------->
<!--Excel의 웹 페이지 마법사로 게시해서 나온 결과의 시작-->
<!----------------------------->

<div id="일반독자CMS내역" align=center x:publishsource="Excel">
<table x:str border=0 cellpadding=0 cellspacing=0 width=1291 class=xl6817062 style='border-collapse:collapse;table-layout:fixed;width:968pt'>
 <col class=xl6517062 width=64 style='mso-width-source:userset;mso-width-alt: 1820;width:48pt'>
 <col class=xl6517062 width=87 style='mso-width-source:userset;mso-width-alt: 2474;width:65pt'>
 <col class=xl6517062 width=49 style='mso-width-source:userset;mso-width-alt: 1393;width:37pt'>
 <col class=xl6817062 width=79 style='mso-width-source:userset;mso-width-alt: 2247;width:59pt'>
 <col class=xl8917062 width=80 style='width:60pt'>
 <col class=xl6817062 width=104 style='mso-width-source:userset;mso-width-alt: 2958;width:78pt'>
 <col class=xl6817062 width=97 style='mso-width-source:userset;mso-width-alt: 2759;width:73pt'>
 <col class=xl8517062 width=91 style='mso-width-source:userset;mso-width-alt: 2588;width:68pt'>
 <col class=xl10317062 width=80 style='width:60pt'>
 <col class=xl6817062 width=80 span=7 style='width:60pt'>
 <tr height=20 style='mso-height-source:userset;height:15.0pt'>
  <td colspan=8 height=20 class=xl10617062 width=651 style='height:15.0pt; width:488pt'><a name="RANGE!A1:H416">학생 독자 자동이체 현황</a></td>
  <td class=xl10317062 width=80 style='width:60pt'></td>
  <td class=xl6817062 width=80 style='width:60pt'></td>
  <td class=xl6817062 width=80 style='width:60pt'></td>
  <td class=xl6817062 width=80 style='width:60pt'></td>
  <td class=xl6817062 width=80 style='width:60pt'></td>
  <td class=xl6817062 width=80 style='width:60pt'></td>
  <td class=xl6817062 width=80 style='width:60pt'></td>
  <td class=xl6817062 width=80 style='width:60pt'></td>
 </tr>
 <tr height=20 style='height:15.0pt'>
  <td height=20 class=xl6517062 style='height:15.0pt'></td>
  <td class=xl6517062></td>
  <td class=xl6517062></td>
  <td class=xl6817062></td>
  <td class=xl8917062></td>
  <td class=xl6817062></td>
  <td class=xl6817062></td>
  <td class=xl8517062></td>
  <td class=xl8517062></td>
  <td class=xl10317062></td>
  <td class=xl6817062></td>
  <td class=xl6817062></td>
  <td class=xl6817062></td>
  <td class=xl6817062></td>
  <td class=xl6817062></td>
  <td class=xl6817062></td>
  <td class=xl6817062></td>
  <td class=xl6817062></td>
 </tr>
			<tr class=xl7117062 height=34 style='mso-height-source:userset;height:25.5pt'>
				<td class=xl6917062 width=87 style='border-left:none;width:65pt'><center>번호</td>
				<td class=xl6917062 width=87 style='border-left:none;width:65pt'><center>지국명</td>
				<td class=xl6917062 width=87 style='border-left:none;width:65pt'><center>지국번호</td>
				<td class=xl6917062 width=87 style='border-left:none;width:65pt'><center>건수</td>
				<td class=xl6917062 width=87 style='border-left:none;width:65pt'><center>금액</td>
				<td class=xl6917062 width=87 style='border-left:none;width:65pt'><center>은행수수료<br>(<c:out value="${pay1}" />원)</td>
				<td class=xl6917062 width=87 style='border-left:none;width:65pt'><center>합계</td>
				<td class=xl6917062 width=87 style='border-left:none;width:65pt'><center>상태</td>
				<td class=xl6917062 width=87 style='border-left:none;width:65pt'><center>환불건수</td>
				<td class=xl6917062 width=87 style='border-left:none;width:65pt'><center>환불금액</td>				
				<td class=xl10317062></td>
				<td class=xl6817062></td>
				<td class=xl6817062></td>
				<td class=xl6817062></td>
				<td class=xl6817062></td>
				<td class=xl6817062></td>
				<td class=xl6817062></td>
				<td class=xl6817062></td>
				<td class=xl6817062></td>				
				<td class=xl6817062></td>
				<td class=xl6817062></td>								
			</tr>
			
			<!-- 정상 데이터 목록 -->
			<c:set var="out_count" value="0" />
			<c:set var="out_money" value="0" />
			<c:set var="out_pay1" value="0" />
			<c:set var="out_pay2" value="0" />
			<c:set var="x_out_count" value="0" />
			<c:set var="x_out_money" value="0" />
			
			<c:forEach items="${resultList}" var="list" varStatus="status">
				<c:set var="in_pay1" value="${pay1 * list.CMSCOUNT}" />
				<c:set var="in_pay2" value="${pay2 * in_count}" />
				<c:set var="out_count" value="${out_count + list.CMSCOUNT}" />
				<c:set var="out_money" value="${out_money + list.CMSMONEY}" />
				<c:set var="out_pay1" value="${out_pay1 + in_pay1}" />
				<c:set var="out_pay2" value="${out_pay2 + in_pay2}" />
				<c:set var="x_out_count" value="${x_out_count + list.CMSCOUNT2}" />
				<c:set var="x_out_money" value="${x_out_money + list.CMSMONEY2}" />
				
				<tr class=xl6717062 height=17 style='mso-height-source:userset;height:12.75pt'>
					<td  height=17 class=xl6617062 width=64 style='height:12.75pt;border-top:none; width:48pt'><c:out value="${status.count}" /></td>
					<td  class=xl6617062 width=87 style='border-top:none;border-left:none; width:65pt'><c:out value="${list.JIKUK_NAME}" /></td>
					<td  class=xl6617062 width=87 style='border-top:none;border-left:none; width:65pt'><c:out value="${list.REALJIKUK}" /></td>
					<td  class=xl6617062 width=87 style='border-top:none;border-left:none; width:65pt'><c:out value="${list.CMSCOUNT}" /></td>
					<td  class=xl6617062 width=87 style='border-top:none;border-left:none; width:65pt'><fmt:formatNumber value="${list.CMSMONEY}" type="number" /></td>
					<td  class=xl6617062 width=87 style='border-top:none;border-left:none; width:65pt'><fmt:formatNumber value="${in_pay1}" type="number" /></td>
					<td  class=xl6617062 width=87 style='border-top:none;border-left:none; width:65pt'><fmt:formatNumber value="${list.CMSMONEY - in_pay1 - in_pay2}" type="number" /></td>
					<td  class=xl6617062 width=87 style='border-top:none;border-left:none; width:65pt'>정상</td>
					<td  class=xl6617062 width=87 style='border-top:none;border-left:none; width:65pt'><c:out value="${list.CMSCOUNT2}" /></td>
					<td  class=xl6617062 width=87 style='border-top:none;border-left:none; width:65pt'><c:out value="${list.CMSMONEY2}" /></td>
					<td  class=xl10317062></td>
					<td  class=xl6817062></td>
					<td  class=xl6817062></td>
					<td  class=xl6817062></td>
					<td  class=xl6817062></td>
					<td  class=xl6817062></td>
					<td  class=xl6817062></td>
					<td  class=xl6817062></td>
					<td  class=xl6817062></td>
					<td  class=xl6817062></td>
					<td  class=xl6817062></td>									
				</tr>
			</c:forEach>

			<!-- 정상 데이터 합계 -->
			<tr class=xl8117062 height=20 style='mso-height-source:userset;height:15.0pt'>
				<td height=20 class=xl7717062 width=64 style='height:15.0pt;border-top:none; width:48pt' colspan="3"><center>합계</td>
				<td class=xl7717062><c:out value="${out_count}" /></td>
				<td class=xl7717062><fmt:formatNumber value="${out_money}" type="number" /></td>
				<td class=xl7717062><fmt:formatNumber value="${out_pay1}" type="number" /></td>
				<td class=xl7717062><fmt:formatNumber value="${out_money - out_pay1 - out_pay2}" type="number" /></td>
				<td class=xl7917062 style='border-top:none;border-left:none' ></td>
				<td class=xl7717062><fmt:formatNumber value="${x_out_count}" type="number" /></td>
				<td class=xl7717062><fmt:formatNumber value="${x_out_money}" type="number" /></td>				
				<td  class=xl10317062></td>
				<td  class=xl6817062></td>
				<td  class=xl6817062></td>
				<td  class=xl6817062></td>
				<td  class=xl6817062></td>
				<td  class=xl6817062></td>
				<td  class=xl6817062></td>
				<td  class=xl6817062></td>
				<td  class=xl6817062></td>
				<td  class=xl6817062></td>
				<td  class=xl6817062></td>										
			</tr>
			
			<!-- 에러 데이터 목록 -->
			<c:set var="out_count" value="0" />
			<c:set var="out_money" value="0" />
			<c:set var="out_pay3" value="0" />
			
			<c:forEach items="${errorList}" var="list" varStatus="status">
				<c:set var="in_pay3" value="${pay3 * list.CMSCOUNT}" />
				<c:set var="out_count" value="${out_count + list.CMSCOUNT}" />
				<c:set var="out_money" value="${out_money + list.CMSMONEY}" />
				<c:set var="out_pay3" value="${out_pay3 + in_pay3}" />
				
				<tr class=xl8117062 height=20 style='mso-height-source:userset;height:15.0pt'>
					<td class=xl7717062 style='border-top:none;border-left:none;width:65pt'><c:out value="${status.count}" /></td>
					<td class=xl7717062 style='border-top:none;border-left:none;width:65pt'><c:out value="${list.JIKUK_NAME}" /></td>
					<td  class=xl7717062 style='border-top:none;border-left:none;width:65pt'><c:out value="${list.REALJIKUK}" /></td>
					<td  class=xl7717062 style='border-top:none;border-left:none;width:65pt'><c:out value="${list.CMSCOUNT}" /></td>
					<td  class=xl7717062 style='border-top:none;border-left:none;width:65pt'> </td>
					<td  class=xl7717062 style='border-top:none;border-left:none;width:65pt'><fmt:formatNumber value="${in_pay3}" type="number" /></td>
					<td  class=xl7717062 style='border-top:none;border-left:none;width:65pt'> </td>
					<td  class=xl7717062 style='border-top:none;border-left:none;width:65pt'> </td>
					<td  class=xl7717062 style='border-top:none;border-left:none;width:65pt'>오류</td>
					<td  class=xl10317062></td>
					<td  class=xl6817062></td>
					<td  class=xl6817062></td>
					<td  class=xl6817062></td>
					<td  class=xl6817062></td>
					<td  class=xl6817062></td>
					<td  class=xl6817062></td>
					<td  class=xl6817062></td>
					<td  class=xl6817062></td>						
				</tr>
			</c:forEach>

			<!-- 에러 데이터 합계 -->
			<tr class=xl8117062 height=20 style='mso-height-source:userset;height:15.0pt'>
				<td  class=xl7717062 style='border-top:none;border-left:none;width:65pt' colspan="3"><center>합계</td>
				<td  class=xl7717062 style='border-top:none;border-left:none;width:65pt'><c:out value="${out_count}" /></td>
				<td  class=xl7717062 style='border-top:none;border-left:none;width:65pt'> </td>
				<td  class=xl7717062 style='border-top:none;border-left:none;width:65pt'><fmt:formatNumber value="${out_pay3}" type="number" /></td>
				<td  class=xl7717062 style='border-top:none;border-left:none;width:65pt'> </td>
				<td  class=xl7717062 style='border-top:none;border-left:none;width:65pt'> </td>
				<td  class=xl7717062 style='border-top:none;border-left:none;width:65pt'></td>
				<td  class=xl10317062></td>
				<td  class=xl6817062></td>
				<td  class=xl6817062></td>
				<td  class=xl6817062></td>
				<td  class=xl6817062></td>
				<td  class=xl6817062></td>
				<td  class=xl6817062></td>
				<td  class=xl6817062></td>
				<td  class=xl6817062></td>						
			</tr>
		</table>
</body>

</html>