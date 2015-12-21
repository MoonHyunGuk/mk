<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript">
// 체크박스를 클릭해서 모든 체크박스를 선택 또는 선택해제한다.
function select_all(bool) {
    var lo_form1;
    lo_form1 = document.formList;

    if(lo_form1.modi==null) {					// 선택된 건이 없는 경우
        return;
//    } else if(lo_form1.idx.type=="checkbox") {	// 한건인 경우
    } else if(!lo_form1.modi.length) {
        lo_form1.modi.checked = bool;
    } else {									// 여러건인 경우
        for(var i=0; i<lo_form1.modi.length; i++) {
            lo_form1.modi[i].checked = bool;
        }
    }
} // select_all

function ok_submit(){
	var lo_form = document.formList;
	
	for(var i=0; i<lo_form.modi.length; i++) {
      if(lo_form.modi[i].checked){
        lo_form.chk[i].value = "true";
      }else{
        lo_form.chk[i].value = "false";
      }
    }
	lo_form.target 				= "ifrm";
	lo_form.action 				= "err_list_ok_stu.do";
	lo_form.submit();
	return;
}	    

// 해지독자제외
function select_all_exp(bool) {
    var lo_form1;
    lo_form1 = document.formList;
	
    if(lo_form1.modi==null) {					// 선택된 건이 없는 경우
        return;
    } else if(!lo_form1.modi.length) {
		if(lo_form1.status.value == "EA13-" || lo_form1.status.value == "EA14-" || lo_form1.status.value == "EA99") {
			lo_form1.modi.checked = bool;
        }
    } else {									// 여러건인 경우
        for(var i=0; i<lo_form1.modi.length; i++) {
			if(lo_form1.status[i].value == "EA13-" || lo_form1.status[i].value == "EA14-" || lo_form1.status[i].value == "EA99") {
				lo_form1.modi[i].checked = bool;
            }
        }
    }
}
</script>
<div><span class="subTitle">미수독자조회(학생)</span></div>
<form name="formList" method="post">
<!-- list -->
<div class="box_list">
	<div style="width: 1020px; text-align: right; color: darkblue; font-weight: bold;">※ ${s_msg}</div>
	<table class="tb_list_a_5" style="width: 1020px">
		<colgroup>
			<col width="75px">
			<col width="60px">
			<col width="85px">
			<col width="70px">
			<col width="150px">
			<col width="90px">
			<col width="90px">
			<col width="340px">
			<col width="60px">
		</colgroup>
		<tr>
		    <th>일련번호</th>
			<th>지국명</th>
			<th>지국전화</th>
			<th>독자번호</th>
			<th>독자명</th>
			<th>독자전화1</th>
			<th>독자전화2</th>
			<th>독자주소</th>
			<th>단가</th>
		</tr>
		<c:choose>
			<c:when test="${empty resultList}">
				<tr><td colspan="9">등록된 정보가 없습니다.</td></tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${resultList}" var="list" varStatus="status">
					<tr>
	                    <td><c:out value="${list.READNO}" /></td>
					    <td><c:out value="${list.NAME}" /></td>
					    <td style="text-align: left"><c:out value="${list.JIKUK_TEL}" /></td>
						<td><c:out value="${list.SERIAL}" /></td>
						<td style="text-align: left"><c:out value="${list.USERNAME}" /></td>
						<td style="text-align: left"><c:out value="${list.PHONE}" /></td>			
						<td style="text-align: left"><c:out value="${list.HANDY}" /></td>			
						<td style="text-align: left"><c:out value="${list.ADDR1}" />&nbsp;&nbsp;&nbsp;<c:out value="${list.ADDR2}" /></td>
						<%-- <td><input type="text" name="cmsmoney" size=6 value='<fmt:formatNumber value="${list.CMSMONEY}"  type="number" />' /></td>--%>
						<td style="text-align: right"><fmt:formatNumber value="${list.CMSMONEY}"  type="number" /></td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>
	<div style="width: 1020px; text-align: right; padding-top: 10px"><img src="/images/bt_exel.gif" onclick="window.open('./err_list_stu_excel.do','_self');" style="cursor:pointer;"/></div>
</div>
<div style="padding: 10px 0; text-align: right;"><a href="#" onclick="javascript:window.scroll(0,0);"><img alt="위로" title="위로" src="/images/ico_top.gif"></a></div>
<!-- list -->
</form>	
<iframe name="ifrm" width="100%" height="0"></iframe>