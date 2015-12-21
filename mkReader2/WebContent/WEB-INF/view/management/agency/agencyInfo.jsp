<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript">
/*----------------------------------------------------------------------
 * Desc   : 수정기능을 수행한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function doMod(){
    if( fncValidation() ){
    	con=confirm("지국정보를 수정하시겠습니까?");
	    if(con==false){
	        return;
		}else{
			agencyInfoForm.action = "/management/agencyManage/agencyModify.do";
			agencyInfoForm.submit();
		}	
    }
}

/*----------------------------------------------------------------------
 * Desc   : 수정기능 수행전 기본항목을 점검한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncValidation(){
	 var passwd = agencyInfoForm.passwd.value;
	 var name2 = agencyInfoForm.name2.value;
	 var jikuk_Tel1 = agencyInfoForm.jikuk_Tel1.value;
	 var jikuk_Tel2 = agencyInfoForm.jikuk_Tel2.value;
	 var jikuk_Tel3 = agencyInfoForm.jikuk_Tel3.value;
	 var jikuk_Handy1 = agencyInfoForm.jikuk_Handy1.value;
	 var jikuk_Handy2 = agencyInfoForm.jikuk_Handy2.value;
	 var jikuk_Handy3 = agencyInfoForm.jikuk_Handy3.value;
	 
	 if(trim(passwd) == "" || passwd == null){
		 alert("비밀번호를 입력해주세요");
		 agencyInfoForm.passwd.focus();
	 return;
	 }
	 
	 if(trim(name2) == "" || name2 == null){
		 alert("지국장명을 입력해주세요");
		 agencyInfoForm.name2.focus();
	 return;
	 }
	 
	 if(jikuk_Tel1 == "" || jikuk_Tel1 == null){
		 alert("전화번호 국번을 선택해주세요");
		 agencyInfoForm.jikuk_Tel1.focus();
	 return;
	 }
	 
	 if(jikuk_Tel2 == "" || jikuk_Tel2 == null){
		 alert("전화번호를 입력해주세요");
		 agencyInfoForm.jikuk_Tel2.focus();
	 return;
	 }
	 
	 if(jikuk_Tel3 == "" || jikuk_Tel3 == null){
		 alert("전화번호를 입력해주세요");
		 agencyInfoForm.jikuk_Tel1.focus();
	 return;
	 }
	 
	 if( jikuk_Handy1 == "" ||  jikuk_Handy1 == null){
		 alert("휴대폰 국번을 선택해주세요");
		 agencyInfoForm. jikuk_Handy1.focus();
	 return;
	 }
	 
	 if( jikuk_Handy2 == "" ||  jikuk_Handy2 == null){
		 alert("휴대폰번호를 입력해주세요");
		 agencyInfoForm. jikuk_Handy2.focus();
	 return;
	 }
	 
	 if( jikuk_Handy3 == "" ||  jikuk_Handy3 == null){
		 alert("휴대폰번호를 입력해주세요");
		 agencyInfoForm. jikuk_Handy3.focus();
	 return;
	 }
	 return true;

}

/*----------------------------------------------------------------------
 * Desc   : 문자열의 공백을 제거한다.
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function trim(str) {  
	str = str.replace(/^\s+/, '');   
	for (var i = str.length - 1; i > 0; i--) {     
		if (/\S/.test(str.charAt(i))) {      
			str = str.substring(0, i + 1);       
			break;  
			} 
		}   
	return str;
	}
</script>
<div><span class="subTitle">지국 정보</span>
</div>
<!-- edit -->
<form id="agencyInfoForm" name="agencyInfoForm" action="" method="post">
<input type="hidden" name="serial"  value="<c:out value="${agencyInfo.SERIAL}"/>"/>
<input type="hidden" name="numId" value="<c:out value="${agencyInfo.NUMID}"/>">
<div style="width: 720px; padding-left: 15px;">
	<table class="tb_search" style="width: 720px;">
		<colgroup>
			<col width="110px">
			<col width="250px">
			<col width="110px">
			<col width="250px">
		</colgroup>
		<tr>
		    <th>지 국 명</th>
			<td style="text-align: left; padding-left: 10px">${agencyInfo.NAME}</td>
			<th>지국번호</th>
			<td style="text-align: left; padding-left: 10px">${agencyInfo.SERIAL}</td>
	    </tr>
	    <tr>
		    <th>*지 국 장</th>
			<td style="text-align: left; padding-left: 10px"><input type="text" name="name2"  style="width:80"  maxlength="10"   value="<c:out value="${agencyInfo.NAME2}"/>"/></td>
			<th>*비밀번호</th>
			<td style="text-align: left; padding-left: 10px"><input type="password" name="passwd" style="color:red;font-weight:bold; width:80"  maxlength="15"   value="<c:out value="${agencyInfo.PASSWD}"/>" ></td>
	    </tr>		
	    <tr>
		    <th>*전화번호</th>
			<td style="text-align: left; padding-left: 10px">
				<select name="jikuk_Tel1" >
					<option>선택
				<c:forEach items="${telExcNo}" var="tel"  varStatus="status">
					<option value="${tel.CODE}"  <c:if test="${tel.CODE eq agencyInfo.JIKUK_TEL1}">selected</c:if>>${tel.CNAME}
			 	</c:forEach>
			  	</select>
		         - <input name="jikuk_Tel2" type="text"  style="width:45px; ime-Mode:disabled;" maxlength="4" value="<c:out value="${agencyInfo.JIKUK_TEL2}"/>"  onkeypress="inputNumCom();">
		         - <input name="jikuk_Tel3" type="text"  style="width:45px; ime-Mode:disabled;" maxlength="4" value="<c:out value="${agencyInfo.JIKUK_TEL3}"/>"  onkeypress="inputNumCom();">
			</td>
			<th>팩스번호</th>
			<td style="text-align: left; padding-left: 10px">
				<select name="jikuk_Fax1" >
					<option>선택
				<c:forEach items="${telExcNo}" var="tel"  varStatus="status">
					<option value="${tel.CODE}"  <c:if test="${tel.CODE eq agencyInfo.JIKUK_FAX1}">selected</c:if>>${tel.CNAME}
			 	</c:forEach>
			  	</select>
		         - <input name="jikuk_Fax2" type="text"  style="width:45px; ime-Mode:disabled;" maxlength="4" value="<c:out value="${agencyInfo.JIKUK_FAX2}"/>" onkeypress="inputNumCom();" >
		         - <input name="jikuk_Fax3" type="text"  style="width:45px; ime-Mode:disabled;" maxlength="4" value="<c:out value="${agencyInfo.JIKUK_FAX3}"/>" onkeypress="inputNumCom();">
          	</td>
	    </tr>		
	    <tr>
		    <th>*핸드폰</th>
			<td style="text-align: left; padding-left: 10px">
				<select name="jikuk_Handy1" >
					<option>선택
				<c:forEach items="${mblExcNo}" var="mbl"  varStatus="status">
					<option value="${mbl.CODE}"  <c:if test="${mbl.CODE eq agencyInfo.JIKUK_HANDY1}">selected</c:if>>${mbl.CNAME}
			 	</c:forEach>
			  	</select>
		         - <input name="jikuk_Handy2" type="text"  style="width:45px; ime-Mode:disabled;" maxlength="4" value="<c:out value="${agencyInfo.JIKUK_HANDY2}"/>" onkeypress="inputNumCom();">
		         - <input name="jikuk_Handy3" type="text"  style="width:45px; ime-Mode:disabled;" maxlength="4" value="<c:out value="${agencyInfo.JIKUK_HANDY3}"/>" onkeypress="inputNumCom();">
          	</td>
			<th>이메일</th>
			<td style="text-align: left; padding-left: 10px"><input name="jikuk_Email" type="text"   maxlength="40"   value="<c:out value="${agencyInfo.JIKUK_EMAIL}"/>"></td>
	    </tr>	
	    <tr>
		    <th>우편번호</th>
			<td style="text-align: left; padding-left: 10px"><input type="text" name="zip"  style="width:80px" maxlength="7"   value="<c:out value="${agencyInfo.ZIP}"/>"/></td>
			<th>사업자번호</th>
			<td style="text-align: left; padding-left: 10px"><input name="iden_No" type="text"  maxlength="12"  style="width:105;ime-Mode:disabled"  value="<c:out value="${agencyInfo.IDEN_NO}"/>"></td>
	    </tr>	
	    <tr>
			<th>지국주소</th>
			<td colspan="3" style="text-align: left; padding-left: 10px"><input type="text" name="addr1"   style="width:450px"  maxlength="50"  value="<c:out value="${agencyInfo.ADDR1}"/>"/></td>
	    </tr>	
	    <tr>
		    <th>지로번호</th>
			<td style="text-align: left; padding-left: 10px"> 
				<input type="text" name="giro_No"   style="width:80px"  maxlength="7"  value="<c:out value="${agencyInfo.GIRO_NO}"/>" style="ime-Mode:disabled"  onkeypress="inputNumCom();" />
			</td>
			<th>승인번호</th>
			<td style="text-align: left; padding-left: 10px">
				<input type="text" name="approval_No"   style="width:80px"  maxlength="6"  value="<c:out value="${agencyInfo.APPROVAL_NO}"/>" style="ime-Mode:disabled"  onkeypress="inputNumCom();" />
			</td>
	     </tr>	
	     <c:if test="${('1' eq jikyungYn) }">
			<tr>
			    <th>지국명2</th>
				<td colspan = "3" style="font-weight: bold; text-align: left; padding-left: 10px">
					<input type="text" name="nameSub"  style="width:80px"  maxlength="10"   value="<c:out value="${agencyInfo.NAME_SUB}"/>"/>&nbsp;※ 개인지로번호로 지로 출력시 인쇄되는 지국명
				</td>
		    </tr>
	     </c:if>
	     <c:if test="${('1' ne jikyungYn) }">
				<input type="hidden" name="nameSub"  style="width:80px"  maxlength="10"   value="<c:out value="${agencyInfo.NAME_SUB}"/>"/>
	     </c:if>
	     <tr>
		    <th>은행명</th>
			<td style="text-align: left; padding-left: 10px">
				<select name="bank"  >
						<option value = "">선택</option>
					<c:forEach items="${bankCb}" var="bankList"  varStatus="status">
						<option value="${bankList.BANKNUM}"  <c:if test="${bankList.BANKNUM eq agencyInfo.BANK}">selected</c:if>>${bankList.BANKNAME}</option>
				 	</c:forEach>
				</select>
			</td>
			<th>계좌번호</th>
			<td style="text-align: left; padding-left: 10px">
				<input type="text" name="bankNum"  style="width:160px; ime-Mode:disabled"  maxlength="16"  value="<c:out value="${agencyInfo.BANK_NUM}"/>" onkeypress="inputNumCom();">
			</td>
	     </tr>	
	     <tr>
		    <th>담 당 자</th>
			<td style="text-align: left; padding-left: 10px">${agencyInfo.MANAGER}</td>
			<th>부 서</th>
			<td style="text-align: left; padding-left: 10px">${agencyInfo.AREA1_NM}</td>
	    </tr>		 						 		
	</table>  		
</div>
<!-- //edit -->
</form>
<!-- button -->					
<div style="width: 720px; text-align: right; padding-top: 10px; padding-left: 15px;">    	
   	<a href="#fakeUrl" onclick="doMod()"><img src="/images/bt_modi.gif" style="border: 0; vertical-align: middle; "></a>
</div>
<!-- button -->		