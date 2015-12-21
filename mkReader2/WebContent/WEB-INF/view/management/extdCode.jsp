<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript">
/*----------------------------------------------------------------------
 * Desc   : 표의 ROW클릭시 INPUT박스에 해당ROW의 데이타 표시
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncSelAction(selRow,code,cName,resv2,name,resv3,useYn,sortFd){
	frmInfo.code.value = code;
	frmInfo.cName.value =cName;
	frmInfo.resv2.value = resv2;
	frmInfo.name.value = name;
	frmInfo.resv3.value = resv3;
	frmInfo.sortFd.value = sortFd;
}

/*----------------------------------------------------------------------
 * Desc   :  INPUT박스를 초기화 시킨다.
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function doReset(){
	frmInfo.code.value ="";
	frmInfo.cName.value = "";
	frmInfo.resv2.value = "";
	frmInfo.name.value = "";
	frmInfo.resv3.value = "";
	frmInfo.sortFd.value = "";
}

/*----------------------------------------------------------------------
 * Desc   : 등록 기능을 수행한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function doIns(){
	 var cName = frmInfo.cName.value;
	 
	 if(cName == "" || cName == null){
		 alert("확장자명을 입력해주세요");
		 frmInfo.cName.focus();
		 return;
	 }
	 
	 con=confirm("'"+cName+"'"+"확장자를 추가하시겠습니까?");
	    if(con==false){
	        return;
		}else{
	        frmInfo.action = "/management/codeManage/extdInsert.do";
	        frmInfo.submit();
		}	
}

/*----------------------------------------------------------------------
 * Desc   : 수정 기능을 수행한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function doMod(){
	 var cName = frmInfo.cName.value;
	 var code = frmInfo.code.value;

	 if(code == "" || code == null){
		 alert("수정하실 확장자를 선택해주세요");
		 frmInfo.code.focus();
		 return;
	 }

	 if(cName == "" || cName == null){
		 alert("확장자명을 입력해주세요");
		 frmInfo.cName.focus();
		 return;
	 }

	 con=confirm(code+"확장자를 수정하시겠습니까?");
	    if(con==false){
	        return;
		}else{
	        frmInfo.action = "/management/codeManage/extdModify.do";
	        frmInfo.submit();
		}	
}

/*----------------------------------------------------------------------
 * Desc   : 삭제 기능을 수행한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function doDel(){
	 var code = frmInfo.code.value;
	 
	 if(code == "" || code == null){
		 alert("삭제할 확장자를 선택해주세요");
		 frmInfo.code.focus();
		 return;
	 }
	 
	 con=confirm(code+"확장자를 삭제하시겠습니까?");
	    if(con==false){
	        return;
 		}else{
	        frmInfo.action = "/management/codeManage/extdUseN.do";
	        frmInfo.submit();
 		}	
}

/*----------------------------------------------------------------------
 * Desc   : 숫자만 입력가능하도록 제어한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function inputNumCom(){
	 var keycode = event.keyCode;
	 
	 if( !((48 <= keycode && keycode <=57) || keycode == 13 || keycode == 46) ){
	  alert("숫자만 입력 가능합니다.");
	  event.keyCode = 0;  // 이벤트 cancel
	 }
	}
	
</script>
<div><span class="subTitle">확장자관리</span></div>
<!-- edit -->
<form id= "frmInfo" name = "frmInfo" method="post">		
<div style="overflow: hidden; padding-bottom: 20px; width: 1020px; margin: 0 auto;;">
	<!-- left -->
	<div style="float: left; width: 400px; padding-right: 10px;">
		<table class="tb_list_a" style="width: 400px">
			<colgroup>
				<col width="140px">
				<col width="180px">
				<col width="180px">
			</colgroup>
			<tr>
				<th>확장자코드</th>
				<th>지국번호</th>
				<th>지국명</th>
			</tr>
			<tr>
				<td><input type="text" name="code"   style="text-align:center; border:0; width: 80%" readonly/></td>
				<td><input type="text" name="resv2"  style="text-align:center; border:0; width: 80%" value="${agencyInfo.USERID}" maxlength = "10" readonly /></td>
				<td><input type="text" name="name"  style="text-align:center; border:0; width: 80%" value="${agencyInfo.NAME}"  readonly  /></td>
			</tr> 						  						  						  						  						  						  						  		   
		</table>	
		<br/>
		<table class="tb_list_a" style="width: 400px">
			<colgroup>
				<col width="100px">
				<col width="100px">
				<col width="100px">
				<col width="100px">
			</colgroup>
			<tr>
				<th>확장자명</th>
				<td><input type="text" name="cName"  style="width: 75px;" maxlength = "10"  /></td>
				<th>정렬</th>
				<td><input type="text" name="sortFd"   style="width: 75px;ime-Mode:disabled" maxlength = "3"  onkeypress="inputNumCom();"  /></td>
			</tr>
			<tr>
				<th>비고</th>
				<td colspan="3"><input type="text" name="resv3"  style="width: 92%;" maxlength = "20"  /></td>
			</tr>		
		</table>
		<div style="text-align: right; padding-top: 10px;">
			<a href="#fakeUrl" onclick="doIns()"><img src="/images/bt_insert.gif" style="vertical-align: middle; border: 0;"></a> 
			<a href="#fakeUrl" onclick="doMod()"><img src="/images/bt_modi.gif" style="vertical-align: middle; border: 0;"></a> 
			<a href="#fakeUrl" onclick="doDel()"><img src="/images/bt_delete.gif" style="vertical-align: middle; border: 0;"></a> 
			<a href="#fakeUrl" onclick="doReset()"><img src="/images/bt_cancle.gif" style="vertical-align: middle; border: 0;"></a> 
		</div>
	</div>
	<!-- //left -->
	<!-- right -->
	<div style="float: left; width: 590px; padding-right: 10px;">
		<table class="tb_list_a" style="width: 590px;">
			<colgroup>
				<col width="120px">
				<col width="120px">
				<col width="110px">
				<col width="80px">
				<col width="80px">
				<col width="80px">
			</colgroup>
			<tr>
				<th>확장자코드</th>
				<th>확장자명</th>
				<th>지국번호</th>
				<th>지국명</th>
				<th>정렬</th>		
				<th>비고</th>			            		   
			</tr>
			<c:if test="${empty extdInfo}">
				<tr>
					<td colspan="6">등록된 확장자가 없습니다.</td>
				</tr>
			</c:if>
			<c:if test="${!empty extdInfo}">        
				<c:forEach items="${extdInfo}" var="list"  varStatus="status">
					<tr id="oTr<c:out value="${status.count}"/>" style="cursor:pointer;" onclick="fncSelAction('${status.count}','${list.CODE}','${list.CNAME}','${list.RESV2}','${list.NAME}','${list.RESV3}','${list.USEYN}','${list.SORTFD}')">
						<td>${list.CODE }</td>
						<td>${list.CNAME }</td>
						<td>${list.RESV2 }</td>
						<td>${list.NAME }</td>
						<td>${list.SORTFD }</td>
						<td>${list.RESV3 }</td>						
					</tr>
				</c:forEach>				
			</c:if>
    </table>
	</div>
	<!-- //right -->
</div>
</form>
<!-- //edit -->
