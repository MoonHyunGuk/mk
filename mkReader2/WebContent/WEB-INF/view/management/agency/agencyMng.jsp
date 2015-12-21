<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet">
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
/*----------------------------------------------------------------------
 * Desc   : 등록/수정기능 수행전 기본항목을 점검한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncValidation(){
	 var area1 = document.getElementById("area1").value;
	 var agencyType = document.getElementById("agencyType").value;
	 var idChkYn = document.getElementById("idChkYn").value;
	 
	 if(!cf_checkNull("userId", "아이디")){ return false; }
	 if(!cf_checkNull("name", "지국명")){ return false; }
	 if(!cf_checkNull("passwd", "비밀번호")){ return false; }
	 if(!cf_checkNull("name2", "지국장명")){ return false; }
	 if(!cf_checkNull("jikuk_Tel1", "전화번호")){ return false; }
	 if(!cf_checkNull("jikuk_Tel2", "전화번호")){ return false; }
	 if(!cf_checkNull("jikuk_Tel3", "전화번호")){ return false; }
	 if(!cf_checkNull("jikuk_Handy1", "휴대폰번호")){ return false; }
	 if(!cf_checkNull("jikuk_Handy2", "휴대폰번호")){ return false; }
	 if(!cf_checkNull("jikuk_Handy3", "휴대폰번호")){ return false; }
	 if(!cf_checkNull("passwd", "비밀번호")){ return false; }
	 //if(!cf_checkNull("jikuk_Email", "이메일1")){ return false; }
	 
	 if(area1 != '002') {
		 document.getElementById("area").value = "";
     }
	 
	 if(agencyType != '101' && agencyType != '102') {
		 document.getElementById("part").value = "";
     }
	 
	 if("N" == idChkYn) {
		 alert("아이디가 중복입니다. 확인해주세요.");
		 return false;
	 }
	 
	 return true;
}

/*----------------------------------------------------------------------
 * Desc   : 등록기능을 수행한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function doIns(){
	 var fm = document.getElementById("agencyInfoForm");
    if( fncValidation() ){
    	if(!confirm("지국을 등록하시겠습니까?")) {
    		return false;
    	} 
   		fm.target = "_self";
   		fm.action = "/management/adminManage/agencyInsert.do";
   		fm.submit();
   		window.opener.fncAgencyList();
   		self.close();
    }
}

/*----------------------------------------------------------------------
 * Desc   : 수정기능을 수행한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function doMod(){
	var fm = document.getElementById("agencyInfoForm");
	 
    if( fncValidation() ){
    	if(!confirm("지국정보를 수정하시겠습니까?")) {
    		return false;
		}
		fm.target = "_self";
		fm.action = "/management/adminManage/agencyModify.do";
		fm.submit();
		window.opener.fncAgencyList();
    }
}

/*----------------------------------------------------------------------
 * Desc   : 삭제기능을 수행한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function doDel(){
	var fm = document.getElementById("agencyInfoForm");
	 
	if(!confirm("지국을 삭제하시겠습니까?")) {
        return false;;
	}
	fm.target = "_self";
	fm.action = "/management/adminManage/agencyDelete.do";
	fm.submit();
}


/**
 * 지국 아이디 중복체크
 */
function chk_id_overlap(userId) {
	
	if(userId.length> 0) {
		if(userId.length < 6){
			alert("아이디(지국번호)는 6자리로 입력해주세요");
			document.getElementById("userId").focus();
			return;
		 }
		
		 jQuery.ajax({
				type 		: "POST",
				url 		: "/collection/collection/agencyOverlapChk.do",
				dataType 	: "json",
				data		: "userId="+userId,
				success:function(data){
					if(data.overlapYn == "N") {	//사용가능할때
						jQuery("#chkIdUseYes").css("display", "block");
						jQuery("#chkIdUseNo").css("display", "none");
						jQuery("#idChkYn").val("Y");
					} else {
						jQuery("#chkIdUseYes").css("display", "none");
						jQuery("#chkIdUseNo").css("display", "block");
						jQuery("#idChkYn").val("N");
					}
				},
				error    : function(r) { alert("ajax error"); }
			}); //ajax end
	}
}


/*----------------------------------------------------------------------
 * Desc   : 부서에따라 지역콤보 화면표시 제어
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function changeArea(val) {  
       if(val == '002') {
    	   jQuery("#Etable").css("display", "inline");
           //document.all.Etable.style.display='inline';
       } else {
    	   jQuery("#Etable").css("display", "none");
           //document.all.Etable.style.display='none';
       }
	}

/*----------------------------------------------------------------------
 * Desc   : 지국구분에따라 파트콤보 화면표시 제어
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function changeType(val) {  
   if(val == '101' || val == '102') {
	   jQuery("#Etable2").css("display", "inline");
          //document.all.Etable2.style.display='inline';
      } else {
   	   jQuery("#Etable2").css("display", "none");
          //document.all.Etable2.style.display='none';
      }
}
	
/**
 *	 팝업닫기
 **/
function fn_popClose() {
	window.close();
}
	
jQuery.noConflict();
</script>
</head>
<body>
<div class="box_Popup">
	<!-- title -->
	<div class="pop_title_box">지국 <c:if test="${(null ne agencyInfo.NUMID) }">관리</c:if> <c:if test="${(null eq agencyInfo.NUMID) }">등록</c:if></div>
	<form id="agencyInfoForm" name="agencyInfoForm" action="" method="post">
		<input type="hidden" name="numId" id="numId" value="<c:out value="${agencyInfo.NUMID}"/>">
		<c:if test="${(null ne agencyInfo.NUMID) }">
		<input type="hidden" name="idChkYn" id="idChkYn" value="Y">
		</c:if>
		<c:if test="${(null eq agencyInfo.NUMID) }">
		<input type="hidden" name="idChkYn" id="idChkYn" value="N">
		</c:if>
		<c:if test="${(null ne agencyInfo.NUMID) }">
			<input type="hidden" name="userId" id="userId" value="<c:out value="${agencyInfo.USERID}"/>" /> 
			<input type="hidden" name="serial" id="serial" value="<c:out value="${agencyInfo.SERIAL}"/>" />
		</c:if> 
		<input type=hidden id="pageNo" name="pageNo" value="${param.pageNo}" />
		<!-- edit -->  	
		<div style="width: 710px; padding: 10px 0 0 0">
		<table class="tb_search_left" style="width: 710px;">
			<colgroup>
				<col width="100px"> 
				<col width="255px">
				<col width="100px">
				<col width="255px">
			</colgroup>
				<tr>
				    <th>아 이 디</th>
					<td colspan="3">
						<c:if test="${(null ne agencyInfo.NUMID) }">
		                	 <c:out value="${agencyInfo.USERID}"/>
		            	</c:if>
		          	    <c:if test="${(null eq agencyInfo.NUMID) }">
		          	    	<div style="float: left; width: 90px;">
		            		 	<input type="text" name="userId" id="userId" style="width:80px; vertical-align: middle; ime-Mode:disabled; "  maxlength="6"  value="${agencyInfo.USERID}"  onblur="chk_id_overlap(this.value);" />
		            		 </div>
		            		 <div style="float: left; width: 30px;"><img id="chkIdUseYes" title="사용가능" alt="사용가능" src="/images/ico/ico_yes.png" style="width: 21px; vertical-align: middle; display: none;" /><img id="chkIdUseNo" title="사용불가" alt="사용불가" src="/images/ico/ico_no.png" style="width: 21px; vertical-align: middle" /></div>
		             </c:if>
					</td>
			    </tr>
			    <tr>
				    <th>*지 국 명</th>
					<td>
						<input type="text" name="name"  id="name" style="width:80px"  maxlength="10"   value="<c:out value="${agencyInfo.NAME}"/>"/>
					</td>
					<th>지국번호</th>
					<td>
						<c:if test="${(null ne agencyInfo.NUMID) }">
			                 <c:out value="${agencyInfo.SERIAL}"/>
			             </c:if>
			              <c:if test="${(null eq agencyInfo.NUMID) }">
			              		<c:choose>
			              			<c:when test="${agencyInfo.SERIAL ne null}">
			            	 			<input type="text" name="serial"  id="serial" style="width:80px"  maxlength="6"   value="<c:out value="${agencyInfo.SERIAL}"/>" readonly="readonly"/>
			            	 		</c:when>
			            	 		<c:otherwise>
			            	 			자동입력
			            	 		</c:otherwise>
			            	 	</c:choose>	
			             </c:if>
					</td>
			    </tr>
			    <tr>
				    <th>지 국 명2</th>
					<td colspan = "3">
						<input type="text" name="nameSub"  id="nameSub" style="width:80px"  maxlength="10"   value="<c:out value="${agencyInfo.NAME_SUB}"/>"/>
						※ 직영지국에서 개인지로번호로 지로 출력시 인쇄되는 지국명
					</td>
			    </tr>
		
			    <tr>
				    <th>*지 국 장</th>
					<td> 
						<input type="text" name="name2"  id="name2" style="width:80px"  maxlength="10"   value="<c:out value="${agencyInfo.NAME2}"/>"/>
					</td>
					<th>*비밀번호</th>
					<td>
						<input type="password" name="passwd" id="passwd" style="color:red; font-weight:bold; width:80px"  maxlength="15"   value="<c:out value="${agencyInfo.PASSWD}"/>" >
					</td>
			    </tr>		
		
			    <tr>
				    <th>*전화번호</th>
					<td>
						<select name="jikuk_Tel1" id="jikuk_Tel1" style="vertical-align: middle;" >
							<option>선택
							<c:forEach items="${telExcNo}" var="tel"  varStatus="status">
								<option value="${tel.CODE}"  <c:if test="${tel.CODE eq agencyInfo.JIKUK_TEL1}">selected</c:if>>${tel.CNAME}
						 	</c:forEach>
					  	</select>
				         - <input name="jikuk_Tel2" id="jikuk_Tel2" type="text"  style="width: 40px; vertical-align: middle" maxlength="4" value="<c:out value="${agencyInfo.JIKUK_TEL2}"/>"  style="ime-Mode:disabled"  onkeypress="inputNumCom();" />
				         - <input name="jikuk_Tel3" id="jikuk_Tel3" type="text"  style="width: 40px; vertical-align: middle" maxlength="4" value="<c:out value="${agencyInfo.JIKUK_TEL3}"/>" style="ime-Mode:disabled"  onkeypress="inputNumCom();" />
					</td>
					<th>팩스번호</th>
					<td>
						<select name="jikuk_Fax1" id="jikuk_Fax1"  style="vertical-align: middle;" >
							<option>선택
							<c:forEach items="${telExcNo}" var="tel"  varStatus="status">
								<option value="${tel.CODE}"  <c:if test="${tel.CODE eq agencyInfo.JIKUK_FAX1}">selected</c:if>>${tel.CNAME}
						 	</c:forEach>
					  	</select>
				         - <input name="jikuk_Fax2" id="jikuk_Fax2" type="text"  style="width: 40px; vertical-align: middle" maxlength="4" value="<c:out value="${agencyInfo.JIKUK_FAX2}"/>" style="ime-Mode:disabled"  onkeypress="inputNumCom();" />
				         - <input name="jikuk_Fax3" id="jikuk_Fax3" type="text"  style="width: 40px; vertical-align: middle" maxlength="4" value="<c:out value="${agencyInfo.JIKUK_FAX3}"/>" style="ime-Mode:disabled"  onkeypress="inputNumCom();" />
		          	</td>
			    </tr>		
			    <tr>
				    <th>*핸드폰</th>
					<td colspan="3">
						<select name="jikuk_Handy1"  id="jikuk_Handy1" style="vertical-align: middle;" >
							<option>선택
							<c:forEach items="${mblExcNo}" var="mbl"  varStatus="status">
								<option value="${mbl.CODE}"  <c:if test="${mbl.CODE eq agencyInfo.JIKUK_HANDY1}">selected</c:if>>${mbl.CNAME}
						 	</c:forEach>
					  	</select>
				         - <input name="jikuk_Handy2" id="jikuk_Handy2" type="text"  style="width: 40px; vertical-align: middle; ime-Mode:disabled" maxlength="4" value="<c:out value="${agencyInfo.JIKUK_HANDY2}"/>"  onkeypress="inputNumCom();" />
				         - <input name="jikuk_Handy3" id="jikuk_Handy3" type="text"  style="width: 40px; vertical-align: middle; ime-Mode:disabled" maxlength="4" value="<c:out value="${agencyInfo.JIKUK_HANDY3}"/>"  onkeypress="inputNumCom();" />
		          	</td>
				</tr>
				<tr>
					<th>이메일1</th>
					<td>
						<input name="jikuk_Email" id="jikuk_Email" type="text"  style="width: 95%" maxlength="40"   value="<c:out value="${agencyInfo.JIKUK_EMAIL}"/>">
					</td>
					<th>이메일2</th>
					<td>
						<input name="jikuk_Email2" id="jikuk_Email2" type="text"  style="width: 95%" maxlength="40"   value="<c:out value="${agencyInfo.JIKUK_EMAIL}"/>">
					</td>
			    </tr>	
		
			    <tr>
				    <th>우편번호</th>
					<td>	
						<input type="text" name="zip" id="zip" style="width:80px" maxlength="7"   value="<c:out value="${agencyInfo.ZIP}"/>"/>
					</td>
					<th>사업자번호</th>
					<td>
						<input name="iden_No" id="iden_No" type="text"  maxlength="12"  style="width:105px; ime-Mode:disabled"  value="<c:out value="${agencyInfo.IDEN_NO}"/>" />
					</td>
			    </tr>	
			    <tr>
					<th>지국주소</th>
					<td colspan="3">
						<input type="text" name="addr1"  id="addr1" style="width:450px"  maxlength="50"  value="<c:out value="${agencyInfo.ADDR1}"/>"/>
					</td>
			    </tr>	
			    <tr>
				    <th>지로번호</th>
					<td> 
						<input type="text" name="giro_No" id="giro_No" style="width:80px; ime-Mode:disabled" maxlength="7"  value="<c:out value="${agencyInfo.GIRO_NO}"/>"  onkeypress="inputNumCom();" />
					</td>
					<th>승인번호</th>
					<td>
						<input type="text" name="approval_No" id="approval_No" style="width:80px; ime-Mode:disabled" maxlength="6"  value="<c:out value="${agencyInfo.APPROVAL_NO}"/>"  onkeypress="inputNumCom();" />
					</td>
			     </tr>	
			     
				<tr>
				    <th>은행명</th>
					<td>
						<select name="bank" id="bank" >
								<option value = "">선택</option>
							<c:forEach items="${bankCb}" var="bankList"  varStatus="status">
								<option value="${bankList.BANKNUM}"  <c:if test="${bankList.BANKNUM eq agencyInfo.BANK}">selected</c:if>>${bankList.BANKNAME}</option>
						 	</c:forEach>
						</select>
					</td>
					<th>계좌번호</th>
					<td>
						<input type="text" name="bankNum" id="bankNum" style="width:160px; ime-Mode:disabled"  maxlength="16"  value="<c:out value="${agencyInfo.BANK_NUM}"/>" style="ime-Mode:disabled"  onkeypress="inputNumCom();" />
					</td>
			     </tr>	
			     <tr>
				    <th>지 역</th>
					<td>
						<select name="agencyArea" id="agencyArea" >
								<option value = "">선택</option>
							<c:forEach items="${agencyAreaCb}" var="agcArea"  varStatus="status">
								<option value="${agcArea.CODE}"  <c:if test="${agcArea.CODE eq agencyInfo.ZONE}">selected</c:if>>${agcArea.CNAME}</option>
						 	</c:forEach>
						</select>
					</td>
					<th>지국구분</th>
					<td>
						<div style="float: left;">
							<select name="agencyType" id="agencyType" onchange="changeType(this.value)" >
								<option value = "">선택</option>
								<c:forEach items="${agencyTypeCb}" var="agcType"  varStatus="status">
									<option value="${agcType.CODE}"  <c:if test="${agcType.CODE eq agencyInfo.TYPE}">selected</c:if>>${agcType.CNAME}</option>
							 	</c:forEach>
						  	</select>
					  	</div>
						<div id="Etable2" style="<c:if test="${('101' ne agencyInfo.TYPE)&&'102' ne agencyInfo.TYPE }">display:none;</c:if>text-align:center; float: left">
							&nbsp;&nbsp;
							<select name="part" id="part">
								<option value = "">선택</option>
								<c:forEach items="${partCb}" var="agcPart"  varStatus="status">
									<option value="${agcPart.CODE}"  <c:if test="${agcPart.CODE eq agencyInfo.PART}">selected</c:if>>${agcPart.CNAME}</option>
							 	</c:forEach>
						  	</select>
						</div>
			        </td>
			    </tr>	
			    <tr>
				    <th>담 당 자</th>
					<td>
					    <select id="manager" name="manager">
					    	<option>선택</option>
					    	<c:forEach items="${selectManagerList}" var="list"  varStatus="status">
								<option value="${list.NAME}"  <c:if test="${list.NAME eq agencyInfo.MANAGER}">selected="selected"</c:if>>${list.NAME}</option>
						 	</c:forEach>
					    </select>
		 			</td>
					<th>부 서</th>
					<td>
						<div style="float: left;">
							<select name="area1" id="area1" onchange="changeArea(this.value)" >
								<option value = "">선택</option>
								<c:forEach items="${areaCb}" var="area"  varStatus="status">
									<option value="${area.CODE}"  <c:if test="${area.CODE eq agencyInfo.AREA1}">selected</c:if>>${area.CNAME}</option>
							 	</c:forEach>
						  	</select>
						</div>
						<div id="Etable" style="<c:if test="${('002' ne agencyInfo.AREA1) }">display:none;</c:if>">
							&nbsp;<select name="area"  id="area" style="text-align:center; float: left">
								<option value = "">선택</option>
								<c:forEach items="${areaCb2}" var="area2"  varStatus="status">
									<option value="${area2.CODE}"  <c:if test="${area2.CODE eq agencyInfo.AREA}">selected</c:if>>${area2.CNAME}</option>
							 	</c:forEach>
						  	</select>
						</div>
			        </td>
			    </tr>	
			    <tr>
		            <th>계약일</th>
		            <td><input type="text" name="sdate" id="sdate" style="width:80px" maxlength="10"   value="<c:out value="${agencyInfo.SDATE}"/>" onclick="Calendar(this)"/></td>
		            <th>해약일</th>
		            <td><input type="text" name="edate"  id="edate" style="width:80px" maxlength="10"   value="<c:out value="${agencyInfo.EDATE}"/>" onclick="Calendar(this)"/></td>
				</tr>
			<c:if test="${(null ne agencyInfo.NUMID) }">
				<tr>
		            <th>등록일</th>
		            <td><input type="text" name="rdate" id="rdate" style="width:80px" maxlength="10"   value="<c:out value="${agencyInfo.RDATE}"/>" onclick="Calendar(this)"/></td>
					<th>등록자</th>
					<td><input type="text" name="admin" id="admin" style="width:80px"  maxlength="10"   value="<c:out value="${agencyInfo.ADMIN}"/>"/></td>
				</tr>
			</c:if> 
		        <tr>
			        <th>메모</th>
			        <td colspan="3" ><textarea rows="5" cols="50" name="memo" id="memo" style="width: 580px; height: 75px" ><c:out value="${agencyInfo.MEMO}"/></textarea></td>
		        </tr>	 						 		
			</table>  	
		</div>	
		</form>					
		<div style="width: 710px; text-align: right; padding: 10px 0 0 0;">
		   	  <c:if test="${(null ne agencyInfo.NUMID) }">
		    	<a href="#fakeUrl" onclick="doMod()"><img src="/images/bt_modi.gif" style="border: 0; vertical-align: middle" alt="" /></a>
		    	<a href="#fakeUrl" onclick="doDel()"><img src="/images/bt_delete.gif" style="border: 0; vertical-align: middle" alt="" /></a>
		    </c:if> 
		    <c:if test="${(null eq agencyInfo.NUMID) }">
		    	<a href="#fakeUrl" onclick="doIns()"><img src="/images/bt_insert.gif" style="border: 0; vertical-align: middle" alt="" /></a>
		    </c:if>
		    <a href="#fakeUrl" onclick="fn_popClose();"><img src="/images/bt_close.gif" style="border: 0; vertical-align: middle" /></a> 
		</div>
	</div>
</body>
</html>

