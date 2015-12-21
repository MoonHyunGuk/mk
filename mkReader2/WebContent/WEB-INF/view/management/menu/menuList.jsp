<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<div style="padding-bottom: 5px;"><span class="subTitle">메뉴관리</span></div>
<!-- search box -->
<div class="box_gray" style="padding: 10px 0; width: 1020px;">
	<span style="font-weight: bold; vertical-align: middle;">부서</span>&nbsp;&nbsp; 
	<select id="opPart" name="opPart" style="vertical-align: middle;">
	 	<c:forEach items="${partList}" var="list"  varStatus="status">
			<option value="${list.CODE }" >${list.CNAME }</option>
		</c:forEach>
	</select>&nbsp; 
</div>
<!-- //search box -->
<!-- list -->
<div>
</div>
<!-- //list -->
<!-- processing viewer -->
<div id="prcssDiv"  class="loingProcessDiv"><div><img src="/images/process4.gif"/></div></div>
<script type="text/javascript">
/** Jquery setting */
jQuery.noConflict();
jQuery(document).ready(function($) {
	$("#prcssDiv").hide();
});
</script>
<!-- //processing viewer --> 