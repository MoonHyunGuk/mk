<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript">
/*----------------------------------------------------------------------
 * Desc   : 추가 기능을 수행한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function doIns(code, news){
	con=confirm("'"+news+"' 매체를 추가로 관리하시겠습니까?");
    if(con==false){
        return;
	}else{
		frmInfo.code.value = code;
		frmInfo.news.value = news;
        frmInfo.action = "/management/codeManage/newsInsert.do";
        frmInfo.submit();
	 }
}

/*----------------------------------------------------------------------
 * Desc   : 삭제 기능을 수행한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function doDel(code, news){
	 
	 if(code == '100'){
		 alert("'매일경제'는 필수 관리대상입니다.");
		 return;
	 }
	 
	con=confirm("'"+news+"' 매체를 관리대상에서 제외하시겠습니까?");
    if(con==false){
        return;
	}else{
		frmInfo.code.value = code;
		frmInfo.news.value = news;
        frmInfo.action = "/management/codeManage/newsDelete.do";
        frmInfo.submit();
	 }
}

</script>
<div><span class="subTitle">매체관리</span></div>
<!-- edit -->
<form id= "frmInfo" name = "frmInfo" method="post">
<input type="hidden" name="code" value="" />
<input type="hidden" name="news" value="" />	
<div style="overflow: hidden; padding-bottom: 20px; width: 1020px; margin: 0 auto;">
	<!-- left -->
	<div style="float: left; width: 500px; padding-right: 10px;">
		<div><img src="/images/ic_arr.gif" style="border: 0; vertical-align: "><b> 전체 매체</b></div>
		<table class="tb_list_a" style="width: 500px;">
			<colgroup>
				<col width="30px;">
				<col width="175px;">
				<col width="125px;">
				<col width="120px;">
				<col width="50px;">
			</colgroup>
			<tr>
				<th>&nbsp;</th>
				<th>매체구분</th>
				<th>약 자</th>
				<th>코 드</th>
				<th>추 가</th>
			</tr>		
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>						
			<c:forEach items="${newsAllList}" var="list"  varStatus="status">
			<tr id="oTr<c:out value="${status.count}"/>">
				<td>${status.count}</td>
				<td>${list.CNAME}</td>
				<td>${list.YNAME}</td>
				<td>${list.CODE}</td>
				<td><a href="#fakeUrl" onclick="doIns('${list.CODE}','${list.CNAME}')"><img src="/images/ic_arr.gif" style="border: 0; vertical-align: middle;"></a></td>
			</tr>
	   		</c:forEach>								
		</table>
	</div>
	<!-- //left -->
	<!-- right -->
	<div style="float: left; width: 500px;;">
		<div><img src="/images/ic_arr.gif" style="border: 0; vertical-align: "><b> 관리 매체</b></div>
		<table class="tb_list_a" style="width: 500px">
			<colgroup>
				<col width="30px;">
				<col width="175px;">
				<col width="125px;">
				<col width="120px;">
				<col width="50px;">
			</colgroup>
			<tr>
				<th></th>
				<th>매체구분</th>
				<th>약 자</th>
				<th>코 드</th>
				<th>삭 제</th>
			</tr>		
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>						
			<c:forEach items="${newsList}" var="list"  varStatus="status">
			<tr id="oTr<c:out value="${status.count}"/>">
				<td>${status.count}</td>
				<td>${list.CNAME}</td>
				<td>${list.YNAME}</td>
				<td>${list.NEWSCD}</td>
				<td><a href="#fakeUrl" onclick="doDel('${list.NEWSCD}','${list.CNAME}')"><img src="/images/bt_imx.gif" style="border: 0; vertical-align: middle;"></a></td>
			</tr>
	   		</c:forEach>								
		</table>
		<div style="padding-top: 10px;">※ 본 시스템으로 관리를 원하는 매체를 관리매체 목록에 추가해 주세요.</div>
	</div>
	<!-- //right -->
</div>
</form>
<!-- //edit -->