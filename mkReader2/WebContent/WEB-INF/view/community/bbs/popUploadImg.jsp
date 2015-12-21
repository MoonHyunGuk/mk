<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page import="java.util.List" %>

<html>
<head>
<meta http-equiv='Content-type' content='text/html; charset=utf-8'>
<meta http-equiv="cache-control" content="no-cache, must-revalidate">
<meta http-equiv="pragma" content="no-cache">
<title>이미지삽입</title>
<link rel="stylesheet" type="text/css" href="../css/editor.css" />
<link href="../css/imgupload.css" rel="stylesheet" type="text/css" />
<style type="text/css">
  body { margin:0; padding:0; }
</style>
<script language="javascript">
var capaHTML = 0;
var isGecko = 0;

if ( navigator.product == "Gecko" ) {
  capaHTML = 1;
  isGecko = 1;
}

function fileCheck( target, obj) {
    pathpoint = obj.lastIndexOf('.');
    filepoint = obj.substring(pathpoint+1,obj.length);
    filetype = filepoint.toLowerCase();
    if(filetype=='jpg' || filetype=='gif' || filetype=='png' || filetype=='jpeg') {
        if( !isGecko ) {
        brower = navigator.userAgent.toUpperCase();
      if (brower.indexOf('MSIE 7') != -1 || brower.indexOf('MSIE 8') != -1 ) {
        //target.innerHTML = '<font color=\"B0B0B0\">미리보기는 MS IE 6.0 이하에서만<br>가능합니다.</font>';
      } else {
        target.innerHTML = "<img src='" + obj + "' width='220' height='143'>";
      }
    } else {
            //target.innerHTML = '<font color=\"B0B0B0\">미리보기는 MS IE계열만<br>가능합니다.</font>';
    }
    } else {
        alert('이미지 파일만 선택할 수 있습니다.');
        target.innerHTML = '';
        return false;
    }
}

function submitImageUploadForm(uploadForm)
{
  var theFrm = document.editor_upimage;

  fileName = theFrm.update_image.value;
  if (fileName == "") {
    alert('본문에 삽입할 이미지를 선택해주세요.');
    return;
  }
    pathpoint = fileName.lastIndexOf('.');
    filepoint = fileName.substring(pathpoint+1,fileName.length);
    filetype = filepoint.toLowerCase();
    if (filetype != 'jpg' && filetype != 'gif' && filetype != 'png' && filetype != 'jpeg' && filetype !='bmp') {
        alert('이미지 파일만 선택할 수 있습니다.');
        self.close();
        return;
    }

    theFrm.imagepath.value = parent.parent.imagepath;
  try {
      theFrm.submit();
  } catch (e) {
    theFrm.reset();
    alert('파일을 업로드할 수 없습니다.');
    return;
  }
}

function closeWin() {
  parent.parent.oEditors.getById["<%=request.getParameter("id")%>"].exec("SE_TOGGLE_IMAGEUPLOAD_LAYER");
  return false;
}

</script>
</head>
<body>
<div id="naver_common_editor">
  <form id="editor_upimage" name="editor_upimage" action="imgUploadProc.jsp" method="post" enctype="multipart/form-data">
  <input type="hidden" name="imagepath">
  <input type="hidden" name="id" value="<%=request.getParameter("id")%>">
  <div class="pic_content" style="border:0;">
    <p class="search"><input type="file" name="update_image" style="width:222px;ime-mode:disabled" onchange="fileCheck(document.getElementById('update_image_view'), this.value);" onkeydown="return false"></p>
    <div class="pic_area" id="update_image_view">
    	저작권을 보호합시다.<br/>
    	이용자 피해 방지와 관리자 보호를 위해 저작권 침해가 우려되는 파일의 사용을 일부 제한하고 있습니다. 
    </div>
    <div class="btn_box">
      <a href="javascript:submitImageUploadForm(document.getElementById('editor_upimage'));"><img src="../img/btn_layer_confirm.gif" alt="확인" width="38" height="21"></a>
      <a href="javascript:closeWin()"><img src="../img/btn_layer_cancel.gif" alt="취소" width="38" height="21" border="0"></a>
    </div>
  </div>
  </form>
</div>
</body>
</html>
