<%@ page language="java" contentType="text/html; charset=MS949" pageEncoding="MS949"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%><%
	// ContentType 를 선언합니다.
	response.setContentType("Application/UnKnown");

	// 헤더값이 첨부파일을 선언합니다.
	response.addHeader("Content-Disposition", "attachment; filename=" + request.getParameter("fname"));

	// 파일생성으로 연것에 파일로 씀
%><c:out value="${data}" />