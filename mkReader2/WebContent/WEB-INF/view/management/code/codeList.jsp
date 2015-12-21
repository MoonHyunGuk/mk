<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" type="text/css" href="/css/addStyle.css" />
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script> 
<script type="text/javascript">
/**
 * 코드구분 검색 이벤트 펑션
 */
function fn_detailList() {
	var fm = document.getElementById("fm");
	
	fm.target = "_self";
	fm.action = "/management/code/codeSubList.do";
	fm.submit();
}

/**
 * 코드명 클릭 이벤트 펑션
 */
function fn_detailView(subCode) {
	var fm = document.getElementById("fm");
	
	fm.target = "_self";
	fm.action = "/management/code/codeDetailView.do";
	fm.subCode.value = subCode;
	fm.submit();
}

/**
 * 신규버튼 클릭 이벤트 펑션
 */
function fn_insert() {
	var fm = document.getElementById("fm");
	
	fm.target = "_self";
	fm.flag.value = "INS";
	fm.action = "/management/code/codeEdit.do";
	fm.submit();
}

/**
 * 수정버튼 클릭 이벤트 펑션
 */
function fn_update() {
	var fm = document.getElementById("fm");
	
	fm.target = "_self";
	fm.flag.value = "UPT";
	fm.action = "/management/code/codeEdit.do";
	fm.submit();
}

/**
 * 삭제버튼 클릭 이벤트 펑션
 */
function fn_delete(cdclsf, code) {
	var fm = document.getElementById("fm");
	
	if(!confirm(code+"코드를 삭제하시겠습니까?")) {
		return false;
	}
	
	fm.target = "_self";
	fm.cdclsf.value = cdclsf;
	fm.code.value = code;
	fm.action = "/management/code/deleteCodeData.do";
	fm.submit();
}

/**
 * 코드추가 아이콘 클릭 이벤트 펑션
 */
function fn_addInsDiv() {
	$j("#insDiv").css("display", "block");
}

/**
 * 코드등록 취소 버튼 클릭 이벤트
 */
function fn_codeAddCancel() {
	
	if(!confirm("취소하시겠습니까?")) {
		return false;
	}
	
	$j("#insCname").val("");		//값초기화
	$j("#insCode").val("");		//값초기화
	$j("#insDiv").css("display", "none");
}

/**
 * 코드구분 신규 등록
 */
function fn_addTopCode() {
	var fm = document.getElementById("fm");
	var chkCodeYn 		= document.getElementById("chkCodeYn").value;
	var chkCNameYn 	= document.getElementById("chkCNameYn").value;
	
	if("N" == chkCNameYn) {
		alert("코드명 중복 확인을 해주세요.");
		return false;
	}
	
	if("N" == chkCodeYn) {
		alert("코드 중복 확인을 해주세요.");
		return false;
	}
	
	if(!confirm("코드를 등록하시겠습니까?")) {
		return false;
	}
	
	fm.target = "_self";
	fm.action = "/management/code/insertTopCode.do";
	fm. submit();
}

/**
 * 코드구분 삭제
 */
 function fn_del_cdclsf() {
	var fm = document.getElementById("fm");
	
	if(!confirm("코드를 삭제하시겠습니까?")) {
		return false;
	}
	
	var cdclsf = $j("#selCdclsf option:selected").val();	
	fm.cdclsf.value = cdclsf;
	fm.target = "_self";
	fm.action = "/management/code/deleteTopCode.do";
	fm.submit();
}

/**
 * 코드구분 - 코드 중복조회
 */
function fn_chk_code_validation(opCode) {
	var fm = document.getElementById("fm");
	
	if(opCode.length > 2) {
		$j.ajax({
			type 		: "POST",
			url 		: "/management/code/chkCodeValidation.do",
			data		: "opCode="+opCode,
			success:function(data){
				if("Y" == data) {		//중복코드있음
					$j("#chkCodeOK").css("display", "none");
					$j("#chkCodeFAIL").css("display", "block");
					fm.chkCodeYn.value = "N";
				} else {
					$j("#chkCodeOK").css("display", "block");
					$j("#chkCodeFAIL").css("display", "none");
					fm.chkCodeYn.value = "Y";
				}
			},
			error:function(request,status,error){
			    alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		}); //ajax end
	}
}

/**
 * 코드구분 - 코드명 중복조회
 */
function fn_chk_code_name_validation(opCodeName) {
	var fm = document.getElementById("fm");
	
	if(opCodeName.length > 2) {
		$j.ajax({
			type 		: "POST",
			url 		: "/management/code/chkCodeNameValidation.do",
			data		: "opCodeName="+opCodeName,
			success:function(data){
				if("Y" == data) {		//중복코드있음
					$j("#chkCodeNmOK").css("display", "none");
					$j("#chkCodeNmFAIL").css("display", "block");
					fm.chkCNameYn.value = "N";
				} else {
					$j("#chkCodeNmOK").css("display", "block");
					$j("#chkCodeNmFAIL").css("display", "none");
					fm.chkCNameYn.value = "Y";
				}
			},
			error:function(request,status,error){
			    alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		}); //ajax end
	}
}
 
 
/** Jquery Setting */
var $j = jQuery.noConflict();
$j(document).ready(function() {
 	var selectedFocus = $j("#subCode").val();
 	
 	//코드(명) 선택위치 이동
 	if(selectedFocus != null) {
 		$j("#"+selectedFocus).focus();	
 	}
});
</script>
<div style="padding-bottom: 15px;"> 
	<span class="subTitle">코드관리</span>
</div>
<form id="fm" name="fm" method="post" action="">
	<input type="hidden" name="flag" id="flag" />
	<input type="hidden" name="cdclsf" id="cdclsf" />
	<input type="hidden" name="code" id="code" />
	<input type="hidden" name="chkCodeYn" id="chkCodeYn" value="N"/>
	<input type="hidden" name="chkCNameYn" id="chkCNameYn"  value="N"/>
	<input type="hidden" name="subCode" id="subCode" value="${subCode}" />
<div>
	<!-- search box -->
	<div style="width: 867px; padding-bottom: 10px;">
		<table class="tb_search" style="width: 867px">
			<colgroup>
				<col width="167px">
				<col width="700px">
			</colgroup>
			<tr>
				<th>코드구분</th>
				<td>
					<select name="selCdclsf" id="selCdclsf" onchange="fn_detailList();" style="vertical-align: middle;">
						<option value="">선택</option>
						<c:forEach items="${codeStep1List}" var="list" varStatus="cnt">
							<option value="${list.CODE}" <c:if test="${list.CODE == selCdclsf}">selected="selected"</c:if>>${list.CNAME}</option>
						</c:forEach>
					</select>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<c:if test="${loginType == 'A'}">
						<a href="#fakeUrl" onclick="fn_del_cdclsf();"><img alt="코드삭제" title="코드삭제" src="/images/ico_minus.gif" style="border: 0; vertical-align: middle; width: 16px;" /></a>&nbsp;
						<a href="#fakeUrl" onclick="fn_addInsDiv();"><img alt="코드추가" title="코드추가" src="/images/ico_plus.gif" style="border: 0; vertical-align: middle; width: 16px;" /></a>
					</c:if>
				</td>
			</tr>
		</table>
		<!-- input box -->
		<div id="insDiv" style="padding-top: 5px;  overflow: hidden; display: none; ">
			<table class="tb_search" style="width: 867px">
			<colgroup>
				<col width="67px">
				<col width="100px">
				<col width="220px">
				<col width="100px">
				<col width="240px">
				<col width="140px">
			</colgroup>
			<tr>
				<th>코드등록</th>
				<th>코드명</th>
				<td>
					<div style="float: left; padding-right: 10px; width: 150px; text-align: left;">
						<input type="text" name="insCname" id="insCname" maxlength="20" style="width: 150px;  vertical-align: middle;" onblur="fn_chk_code_name_validation(this.value)" />
					</div>
					<div style="float: left; text-align: left;">
						<img id="chkCodeNmOK" alt="사용가능" src="/images/ico_check.png" style="border: 0; vertical-align: middle; display: none;" />
						<img id="chkCodeNmFAIL" alt="사용불가" src="/images/ico_fail.png" style="border: 0; vertical-align: middle;" />
					</div>
				</td>
				<th>코드</th>
				<td style="border-right: 0;">
					<div style="float: left; padding-right: 10px; width: 100px; text-align: left;">
						<input type="text" name="insCode" id="insCode" maxlength="6" style="width: 100px;" onblur="fn_chk_code_validation(this.value);" />
					</div>
					<div style="float: left; text-align: left;">
						<img id="chkCodeOK" alt="사용가능" src="/images/ico_check.png" style="border: 0; vertical-align: middle; display: none;" />
						<img id="chkCodeFAIL" alt="사용불가" src="/images/ico_fail.png" style="border: 0; vertical-align: middle;" />
					</div>
				</td>
				<td style="border-left: 0;">
					<span class="btnCss2"><a class="lk2" onclick="fn_addTopCode();">저장</a></span>
					<span class="btnCss2"><a class="lk2" onclick="fn_codeAddCancel();">취소</a></span>
				</td>
			</tr>
		</table>
		</div>
		<!--//input box -->
	</div>
	<!-- //search box -->
	<!-- code step2 list -->
	<div style="width: 289px; float: left; border: 0px solid #e5e5e5; height: 620p01100x;">
		<div style="padding-bottom: 5px;">
			<div style="width: 282px; text-align: center; padding: 10px 0; background-color: #e5e5e5; font-weight: bold;">코드(명)</div>
		</div>
		<div style="width: 275px; border: 1px solid #e5e5e5; padding: 5px 0 5px 5px; overflow: hidden;">
			<div style="width: 275px; height: 610px; overflow-y: scroll; overflow-x: none;">
				<c:choose>
					<c:when test="${fn:length(codeStep2List) < 1}">
						<div style="overflow: hidden; padding-bottom: 3px;">
							<div style="padding: 10px 0; text-align: center; width: 250px;">조회된 내용이 없습니다.</div>
						</div>
					</c:when>
					<c:otherwise>
						<c:forEach items="${codeStep2List}" var="subList" varStatus="cnt">
							<div style="overflow: hidden; padding-bottom: 3px;">
								<div class="mover_orange"  id="${subList.CODE}" style="border: 2px solid #e5e5e5; padding: 10px 0; text-align: center; width: 250px; <c:if test="${subList.CODE eq subCode }">background-color: #b5772f; color:#fff; font-weight: bold;</c:if>" onclick="fn_detailView('${subList.CODE}');">${subList.CNAME}</div>
							</div>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>
	<!-- //code step2 list -->
	<!-- code detail view -->
	<div style="width: 576px; float: left; height: 720px;">
		<div style="padding-bottom: 5px;">
			<div style="width: 578px; text-align: center; padding: 10px 0; background-color: #e5e5e5; font-weight: bold;">상세보기</div>
		</div>
		<div style="width: 100%; border: 1px solid #e5e5e5; padding: 20px 0; height: 580px;">
			<table class="tb_search" style="width: 490px;">
				<colgroup>
					<col width="170px">
					<col width="320px">
				</colgroup>
				<tr>
					<th>코드구분</th>
					<td><c:out value="${selCdclsf}" /></td>
				</tr>
				<tr>
					<th>코 드</th>
					<td><c:out value="${subCode}" /></td>
				</tr>
				<tr>
					<th>코드명</th>
					<td><c:out value="${codeView.CNAME}" /></td>
				</tr>
				<tr>
					<th>코드약어</th>
					<td><c:out value="${codeView.YNAME}" /></td>
				</tr>
				<tr>
					<th>비 고</th>
					<td><c:out value="${codeView.REMK}" /></td>
				</tr>
				<tr>
					<th>예약1</th>
					<td><c:out value="${codeView.RESV1}" /></td>
				</tr>
				<tr>
					<th>예약2</th>
					<td><c:out value="${codeView.RESV2}" /></td>
				</tr>
				<tr>
					<th>예약3</th>
					<td><c:out value="${codeView.RESV3}" /></td>
				</tr>
				<tr>
					<th>우선순위</th>
					<td><c:out value="${codeView.SORTFD}" /></td>
				</tr>
			</table>
			<!-- button -->
			<div style="width: 490px; text-align: right; margin: 0 auto; padding-top: 10px; ">
				<c:if test="${subCode ne null && subCode != ''}">
					<span class="btnCss2"><a class="lk2" onclick="fn_delete('${selCdclsf}', '${subCode}');">삭제</a></span>
					<span class="btnCss2"><a class="lk2" onclick="fn_update();">수정</a></span>
				</c:if>
				<c:if test="${selCdclsf eq null || selCdclsf == ''}">
					<span class="btnCss2"><a class="lk2" onclick="fn_insert();">신규</a></span>
				</c:if>
			</div>
			<!-- //button -->
		</div>
	</div>
	<!-- //code detail view -->
</div>
</form>