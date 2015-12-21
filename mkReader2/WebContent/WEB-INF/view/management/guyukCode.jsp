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
function fncSelAction(selRow,userId,guNo,guNm,guApt,guBilla,guOffice,guSanga,guJuteak,guGita){
	frmInfo.userId.value = userId;
	frmInfo.guNo.value =guNo;
	frmInfo.guNm.value = guNm;
	frmInfo.guApt.value = guApt;
	frmInfo.guBilla.value = guBilla;
	frmInfo.guOffice.value = guOffice;
	frmInfo.guSanga.value = guSanga;
	frmInfo.guJuteak.value = guJuteak;
	frmInfo.guGita.value =guGita ;
}

/*----------------------------------------------------------------------
 * Desc   :  INPUT박스를 초기화 시킨다.
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function doReset(){
	frmInfo.guNo.value ="";
	frmInfo.guNm.value = "";
	frmInfo.guApt.value = "";
	frmInfo.guBilla.value = "";
	frmInfo.guOffice.value = "";
	frmInfo.guSanga.value = "";
	frmInfo.guJuteak.value = "";
	frmInfo.guGita.value = "";
}

/*----------------------------------------------------------------------
 * Desc   : 등록 기능을 수행한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function doIns(){
	 var guNo = frmInfo.guNo.value;
	 var guNm = frmInfo.guNm.value;
	 
	 if(guNo == "" || guNo == null){
		 alert("구역번호를 입력해주세요");
		 frmInfo.guNo.focus();
		 return;
	 }
	 
	 if(guNm == "" || guNm == null){
		 alert("구역명을 입력해주세요");
		 frmInfo.guNm.focus();
		 return;
	 }

	if(guNo.substring(0,1) !="1" || guNo.length <=2){
		alert("구역번호는 101~199 사이의 값으로 입력해주세요.");
		 frmInfo.guNo.focus();
		return;
	}
	 con=confirm(frmInfo.guNo.value+"구역을 추가하시겠습니까?");
	    if(con==false){
	        return;
		}else{
	        frmInfo.action = "/management/codeManage/guyukInsert.do";
	        frmInfo.submit();
		}	
}

/*----------------------------------------------------------------------
 * Desc   : 수정 기능을 수행한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function doMod(){
	 var guNo = frmInfo.guNo.value;
	 var guNm = frmInfo.guNm.value;
	 
	 if(guNo == "" || guNo == null){
		 alert("수정할 구역을 선택해주세요");
		 frmInfo.guNo.focus();
		 return;
	 }
	 
	 if(guNm == "" || guNm == null){
		 alert("구역명을 입력해주세요");
		 frmInfo.guNm.focus();
		 return;
	 }
	 
	 con=confirm(frmInfo.guNo.value+"구역을 수정하시겠습니까?");
	    if(con==false){
	        return;
		}else{
	        frmInfo.action = "/management/codeManage/guyukModify.do";
	        frmInfo.submit();
		}	
}

/*----------------------------------------------------------------------
 * Desc   : 삭제 기능을 수행한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function doDel(){
	 var guNo = frmInfo.guNo.value;
	 
	 if(guNo == "" || guNo == null){
		 alert("삭제할 구역을 선택해주세요");
		 frmInfo.guNo.focus();
		 return;
	 }
	 
	 con=confirm(frmInfo.guNo.value+"구역을 삭제하시겠습니까?");
	    if(con==false){
	        return;
 		}else{
	        frmInfo.action = "/management/codeManage/guyukDelete.do";
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
<div><span class="subTitle">구역관리</span></div>
<!-- edit -->
<form id= "frmInfo" name = "frmInfo" method="post">		
<div style="overflow: hidden; width: 1020px; margin: 0 auto;">
	<!-- left -->
	<div style="float: left; width: 400px; padding-right: 10px;">
		<table class="tb_list_a" style="width: 400px">
			<colgroup>
				<col width="140px">
				<col width="180px">
				<col width="180px">
			</colgroup>
			<tr>
				<th>지국번호</th>
				<th>구역번호</th>
				<th>구역명</th>
			</tr>
			<tr>
				<td><input type="text" name="userId"  value="<c:out value='${userId}'/>"  style="text-align:center;border:0" readonly/></td>
				<td><input type="text" name="guNo"  style="ime-Mode:disabled; width: 85%" maxlength = "3" onkeypress="inputNumCom();"  /></td>
				<td><input type="text" name="guNm" style="width: 85%" maxlength = "10" /></td>
			</tr> 						  						  						  						  						  						  						  		   
		</table>	
		<br />
		<table class="tb_search" style="width: 400px">
			<colgroup>
				<col width="60px">
				<col width="73px">
				<col width="60px">
				<col width="73px">
				<col width="60px">
				<col width="74px">
			</colgroup>
			<tr>
				<th>APT</th>
				<td><input type="text" name="guApt" style="ime-Mode:disabled; text-align:right; width: 45px;;" maxlength = "3" onkeypress="inputNumCom();" /></td>
				<th>빌라</th>
				<td><input type="text" name="guBilla" style="ime-Mode:disabled; text-align:right; width: 45px;;" maxlength = "3" onkeypress="inputNumCom();" /></td>
				<th>사무실</th>
				<td><input type="text" name="guOffice" style="ime-Mode:disabled; text-align:right; width: 45px;;" maxlength = "3" onkeypress="inputNumCom();" /></td>
			</tr>
			<tr>
				<th>상가</th>
				<td><input type="text" name="guSanga" style="ime-Mode:disabled; text-align:right; width: 45px;;" maxlength = "3" onkeypress="inputNumCom();" /></td>
				<th>주택</th>
				<td><input type="text" name="guJuteak" style="ime-Mode:disabled; text-align:right; width: 45px;;" maxlength = "3" onkeypress="inputNumCom();" /></td>
				<th>기타</th>
				<td><input type="text" name="guGita" style="ime-Mode:disabled; text-align:right; width: 45px;;" maxlength = "3"  onkeypress="inputNumCom();" /></td>
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
				<col width="85px">
				<col width="85px">
				<col width="70px">
				<col width="70px">
				<col width="70px">
				<col width="70px">
				<col width="70px">
				<col width="70px">
			</colgroup>
			<tr>
				<th>구역번호</th>
				<th>구역명</th>
				<th>APT</th>
				<th>빌라</th>
				<th>사무실</th>
				<th>상가</th>
				<th>주택</th>
				<th>기타</th>						   
			</tr>
			<c:if test="${empty guyukInfo}">
				<tr>
					<td colspan="8" align="center">등록된 구역이 없습니다.</td>
				</tr>
			</c:if>
			<c:if test="${!empty guyukInfo}">        
				<c:forEach items="${guyukInfo}" var="list"  varStatus="status">
					<tr id="oTr<c:out value="${status.count}"/>" style="cursor:pointer;" onclick="fncSelAction('${status.count}','${list.BOSEQ}','${list.GU_NO}','${list.GU_NM}','${list.GU_APT}','${list.GU_BILLA}','${list.GU_OFFICE}','${list.GU_SANGA}','${list.GU_JUTEAK}','${list.GU_GITA}')">
						<td>${list.GU_NO }</td>
						<td>${list.GU_NM }</td>
						<td>${list.GU_APT }</td>
						<td>${list.GU_BILLA }</td>
						<td>${list.GU_OFFICE }</td>
						<td>${list.GU_SANGA }</td>
						<td>${list.GU_JUTEAK }</td>
						<td>${list.GU_GITA }</td>
					</tr>
				</c:forEach>				
			</c:if>
		</table>
	</div>
	<!-- //right -->
</div>
</form>
<!-- //edit -->
