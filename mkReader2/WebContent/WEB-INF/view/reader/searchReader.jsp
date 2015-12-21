<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!-- H E A D E R  ::  START -->

<script type="text/javascript">
function search(){
	if($("searchText").value  == ''){
		alert("검색어를 입력해 주세요.");
		return;
	}
	searchReaderForm.action="";
	searchReaderForm.submit();
}
//페이징 펑션
function moveTo(where, seq) {
	
		$("pageNo").value = seq;
		searchReaderForm.action = "/reader/readerManage/searchReader.do";
		searchReaderForm.submit();
	
}

</script>
<form id="searchReaderForm" name="searchReaderForm" method="post">
	<!-- 페이징 처리 변수 -->
	<input type=hidden id="pageNo" name="pageNo" value="${param.pageNo}" />
	<!-- 페이징 처리 변수 -->
	<table>
		<tr><td>
		<input type="text" id="searchText" name="searchText" value="${param.searchText}"/> 
		<input type="radio" id="searchType" name="searchType" value="1" value="" checked="checked"/> 통합
		<input type="radio" id="searchType" name="searchType" value="2" value="" /> 구역
		<a href="javascript:search()">검색</a>
		</td></tr>
	</table>
	<table>
	<tr>
		<td>
		이름
		</td>
	</tr>
	<c:forEach items="${readerList}" var="list" >
		<tr><td>
		<a href="javascript:detailView('<c:out value="${list.READNM }"/>')" ><c:out value="${list.READNM }"/></a>
		</td></tr>
	</c:forEach>
	</table>
	<!-- P A G I N G :: START -->
		<div class="paging">
			<span>
			<c:choose>
				<c:when test="${pageInfo.min != 1}">
					<a href="javascript:moveTo('list', '1');"><img src="/admin/images/btnPrev2.gif" alt="처음" /></a>
					<a href="javascript:moveTo('list', '${pageInfo.min - 1}');"><img src="/admin/images/btnPrev.gif" alt="이전" /></a>
				</c:when>
				<c:otherwise>
					<img src="/admin/images/btnPrev2.gif" alt="처음" />
					<img src="/admin/images/btnPrev.gif" alt="이전" />
				</c:otherwise>
			</c:choose>
			</span>

			<paging:source totalCount="${pageInfo.count}" rowsPerPage="${pageInfo.rowsPerPage}" pageNum="${pageInfo.current}" var="status">
				<paging:iterate>
					<c:choose>
						<c:when test="${status.cur == pageInfo.current}">
							<strong>${status.cur}</strong>
						</c:when>
						<c:otherwise>
							<a href="javascript:moveTo('list', '${status.cur}');">${status.cur}</a>
						</c:otherwise>
					</c:choose>
				</paging:iterate>
			</paging:source>

			<span>
			<c:choose>
				<c:when test="${pageInfo.last != pageInfo.max}">
					<a href="javascript:moveTo('list', '${pageInfo.max + 1}');"><img src="/admin/images/btnNext.gif" alt="다음" /></a>
					<a href="javascript:moveTo('list', '${pageInfo.last}');"><img src="/admin/images/btNext2.gif" alt="끝" /></a>
				</c:when>
				<c:otherwise>
					<img src="/admin/images/btnNext.gif" alt="다음" />
					<img src="/admin/images/btNext2.gif" alt="끝" />
				</c:otherwise>
			</c:choose>
			</span>
		</div>
	<!-- P A G I N G :: E N D -->	
		
</form>