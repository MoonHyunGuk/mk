<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- P A G I N G :: START -->
	<div style="width: 100%; padding: 20px 0; margin: 0 auto; text-align: center; text-decoration: none;">  
		<c:choose>
			<c:when test="${pageInfo.min != 1}">
				<a href="javascript:moveTo('list', '1');"><img src="/images/bt_gf01.gif" style="border: 0; vertical-align: middle;" alt=""></a> 
				<a href="javascript:moveTo('list', '${pageInfo.min - 1}');"><img src="/images/bt_gf02.gif" style="border: 0; vertical-align: middle;" alt=""></a>&nbsp;
			</c:when>
			<c:otherwise>
				<img src="/images/bt_gf01.gif" style="border: 0; vertical-align: middle;" alt=""> 
				<img src="/images/bt_gf02.gif" style="border: 0; vertical-align: middle;" alt="">&nbsp;
			</c:otherwise>
		</c:choose>
		<paging:source totalCount="${pageInfo.count}" rowsPerPage="${pageInfo.rowsPerPage}" pageNum="${pageInfo.current}" var="status">
			<paging:iterate>
				<c:choose>
					<c:when test="${status.cur == pageInfo.current}">
						<strong><font class="b03">${status.cur}</font></strong>&nbsp;
					</c:when>
					<c:otherwise>
						<a href="javascript:moveTo('list', '${status.cur}');">${status.cur}</a>&nbsp;
					</c:otherwise>
				</c:choose>
			</paging:iterate>
		</paging:source>
		<c:choose>
			<c:when test="${pageInfo.last != pageInfo.max}">
				<a href="javascript:moveTo('list', '${pageInfo.max + 1}');"><img src="/images/bt_gf03.gif"style="border: 0; vertical-align: middle;" alt=""></a> 
				<a href="javascript:moveTo('list', '${pageInfo.last}');"><img src="/images/bt_gf04.gif" style="border: 0; vertical-align: middle;" alt=""></a>
			</c:when>
			<c:otherwise>
				<img src="/images/bt_gf03.gif" style="border: 0; vertical-align: middle;" alt=""> 
				<img src="/images/bt_gf04.gif" style="border: 0; vertical-align: middle;" alt="">
			</c:otherwise>
		</c:choose>
	</div>
<!-- P A G I N G :: E N D -->