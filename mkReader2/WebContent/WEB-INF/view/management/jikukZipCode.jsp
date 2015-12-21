<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript">
/*----------------------------------------------------------------------
 * Desc   : 조회 기능을 수행한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function doSearch(){
	 var txt = frmInfo.txt.value;
	 
	 if(txt == "" || txt == null){
		 alert("조회할 주소를 입력해주세요");
		 frmInfo.txt.focus();
		 return;
	 }
	 
     frmInfo.action = "/management/codeManage/jikukZipList.do";
     frmInfo.submit();

}

</script>
<div><span class="subTitle">관할지역</span>
</div>
<form id= "frmInfo" name = "frmInfo" method="post">
<!-- search conditions -->
<div class="box_white" style="padding: 10px 0; width: 1020px; margin: 0 auto">
	<b>주 소</b>&nbsp;<input type="text" name="txt"  value="<c:out value='${txt}'/>"  style="width: 150px; vertical-align: middle;"  maxlength = "15" />&nbsp;
	<a href="#fakeUrl" onclick="doSearch()"><img src="/images/bt_search.gif" style="border: 0; vertical-align: middle; "></a> 
</div>
<!-- //search conditions -->
<!-- list -->
<div class="box_list" style="width: 1020px; margin: 0 auto;">
	<table class="tb_list_a" style="width: 1020px;">
		<colgroup>
			<col width="110px">
			<col width="110px">
			<col width="650px">
			<col width="150px">
		</colgroup>
	    <tr>
            <th>우편번호</th>
            <th>일련번호</th>
            <th>상세주소</th>
            <th>담당지국</th>
	    </tr>
		<c:if test="${empty jikukZipList}">
           <tr>
               <td colspan="4">검색 결과가 없습니다.</td>
           </tr>
        </c:if>
        <c:if test="${!empty jikukZipList}">
		    <c:forEach items="${jikukZipList}" var="list"  varStatus="status">
				<tr id="oTr<c:out value="${status.count}"/>">
					<td>${list.ZIP }</td>
					<td>${list.SERIAL }</td>
					<td style="text-align:left;">${list.TXT }</td>
					<td>${list.JIKUK }</td>
				</tr>
				<c:if test="${status.last}">
				<tr>
					<td colspan="4" style="background-color: #e5e5e5; font-weight: bold; padding: 5px 0;">총 ${status.count} 건이 조회되었습니다.</td>
				</tr>
				</c:if>
	  		</c:forEach>
         </c:if>
    </table>
</div>
<!-- //list -->
</form>


