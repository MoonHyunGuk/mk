<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
	function addProcess(){
		var frm = document.form1;
		if( !frm.jikuk_name.value ){
			alert("지국명을 입력해 주세요.");
			frm.jikuk_name.focus();
			return;
		}
		else if( !frm.jikuk_code.value ){
			alert("지국코드을 입력해 주세요.");
			frm.jikuk_code.focus();
			return;
		}
		else if( !frm.usernumid.value ){
			alert("자동이체독자고유번호를 입력해 주세요.");
			frm.usernumid.focus();
			return;
		}
		else if( !frm.username.value ){
			alert("이름을 입력해 주세요.");
			frm.username.focus();
			return;
		}
		else if( !frm.bank_name.value ){
			alert("은행명을 입력해 주세요.");
			frm.bank_name.focus();
			return;
		}
		else if( !frm.bank_num.value ){
			alert("계좌번호를 입력해 주세요.");
			frm.bank_num.focus();
			return;
		}
		else if( !frm.refund_price.value ){
			alert("금액을 입력해 주세요.");
			frm.refund_price.focus();
			return;
		}
		else if( !frm.refund_date.value ){
			alert("일시를 선택해 주세요.");
			frm.refund_date.focus();
			return;
		}
		
		frm.action = "input.do";
		frm.submit();
		jQuery("#prcssDiv").show();
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
	//페이지 이동
	function moveTo(type, pageNo) {
		
		var frm = document.form1;
	
		frm.pageNo.value = pageNo;
		frm.action = "list.do";
		frm.submit();
	}
</script>
<div><span class="subTitle">환불내역조회(일반)</span></div>
<form name="form1" method="post" action="list.do">
<input type="hidden" id="pageNo" name="pageNo" />
<input type="hidden" id="typecd" name="2" />
<!-- search conditions -->
<div class="box_white" style="padding: 10px 0; width: 1020px; margin: 0 auto;">
   	<select name="jikuk" id="jikuk" style="vertical-align: middle;">
   		<option value=''>전체</option>
		<c:forEach items="${jikukList}" var="list" varStatus="status">
			<c:if test="${not empty list.JINAM}">
				<c:choose>
				<c:when test="${jikuk eq list.THISJI}">
					<option value='<c:out value="${list.THISJI}" />' selected><c:out value="${list.JINAM}" /></option>
				</c:when>
				<c:otherwise>
					<option value='<c:out value="${list.THISJI}" />'><c:out value="${list.JINAM}" /></option>
				</c:otherwise>
				</c:choose>
			</c:if>
		</c:forEach>
   	</select>&nbsp;
   <input type="text" name="sdate" style="vertical-align: middle; width: 85px" value='<c:out value="${sdate}" />' readonly onclick="Calendar(this)"> ~ 
   <input type="text" name="edate" style="vertical-align: middle; width: 85px" value='<c:out value="${edate}" />' readonly onclick="Calendar(this)">&nbsp; 
   <a href="#fakeUrl" onclick="moveTo('list','1');"><img src="/images/bt_joh.gif" style="vertical-align: middle; border: 0" alt="조회"></a> 
</div>  	
<!-- //search conditions -->				
<!-- list -->
<div style="width: 1020px; margin: 0 auto; padding-top: 5px;">
	<table class="tb_list_a_5" style="width: 1020px">
		<colgroup>
			<col width="110px">
			<col width="100px">
			<col width="160px">
			<col width="180px">
			<col width="80px">
			<col width="150px">
			<col width="160px">
			<col width="80px">
		</colgroup>
		<tr>
			<th>지국명</th>
			<th>독자명</th>
			<th>자동이체독자번호</th>
			<th>주민번호</th>
			<th>금액</th>
			<th>은행명</th>
			<th>계좌번호</th>
			<th>일시</th>
		</tr>
		<c:choose>
			<c:when test="${empty resultList}">
				<tr><td colspan="8">찾으시는 내용이 없습니다.</td></tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${resultList}" var="list" varStatus="status">
					<tr>
						<td ><c:out value="${list.JIKUK_NAME}" /></td>
						<td style="text-align: left">
							<c:out value="${list.GUBUN}" />
							<br>
							<a href="#fakeUrl" onclick=
								<c:choose>
									<c:when test="${list.GUBUN eq '학생'}">"popMemberViewStu('${list.READNO}');"
									</c:when>
									<c:otherwise>"popMemberView('${list.READNO}');"</c:otherwise>
								</c:choose>
							>
							<c:choose>
								<c:when test="${not empty list.USERNAME}">
									<c:out value="${list.USERNAME}" />
								</c:when>
								<c:otherwise>
									<font color=red>삭제된 이용자</font>
								</c:otherwise>
							</c:choose>
							</a>
						</td>
						<td ><c:out value="${list.USERNUMID}" /></td>
						<td><c:out value="${list.JUMIN}" /></td>
						<td style="text-align: right;"><fmt:formatNumber value="${list.REFUND_PRICE}"  type="number" /></td>
						<td ><c:out value="${list.BANK_NAME}" /></td>
						<td ><c:out value="${list.BANK_NUM}" /></td>
						<td ><c:out value="${list.REFUND_DATE}" /></td>													
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>
	<!-- 서치 넘버-->					
	<%@ include file="/common/paging.jsp"  %>
	<!-- 서치 넘버 끝-->
	<!-- counting -->
	<div style="text-align: right; padding-bottom: 5px;">
		<div class="box_gray" style="padding: 5px 0; width: 500px; text-align: center; font-weight: bold; display: inline-block;">건수 : ${count} &nbsp;&nbsp;&nbsp; 금액 : <fmt:formatNumber value="${totals}"  type="number" /></div>
	</div>
	<!-- //counting -->
	<!-- editor -->
	<table class="tb_list_a_5" style="width: 1020px">
		<colgroup>
			<col width="110px">
			<col width="110px">
			<col width="110px">
			<col width="110px">
			<col width="140px">
			<col width="110px">
			<col width="110px">
			<col width="110px">
			<col width="110px">
		</colgroup>
		<tr>
			<th>지국명</th>
			<th>지국코드</th>
			<th>자동이체독자번호</th>
			<th>독자명</th>
			<th>주민번호</th>
			<th>은행명</th>
			<th>계좌번호</th>
			<th>금액</th>
			<th>일시</th>
		</tr>
		<tr>
			<td><input type="text" id="jikuk_name" name="jikuk_name" style="width: 95%"/></td>
			<td><input type="text" id="jikuk_code" name="jikuk_code" style="width: 95%"/></td>
			<td><input type="text" id="usernumid" name="usernumid" style="width: 95%" onkeypress="inputNumCom();"/></td>
			<td><input type="text" id="username" name="username" style="width: 95%"/></td>
			<td><input type="text" id="jumin" name="jumin" style="width: 95%"/></td>
			<td><input type="text" id="bank_name" name="bank_name" style="width: 95%"/></td>
			<td><input type="text" id="bank_num" name="bank_num" style="width: 95%"/></td>
			<td><input type="text" id="refund_price" name="refund_price" style="width: 95%" onkeypress="inputNumCom();"/></td>
			<td><input type="text" id="refund_date" name="refund_date" style="width: 95%" onclick="Calendar(this);" onfocus="Calendar(this);" readonly="readonly"/></td>
		</tr>
	</table>		
	<div style="width: 1020px; padding-top: 5px; text-align: right;"><a href="#" onclick="addProcess();"><img src="/images/bt_eepl.gif" style="vertical-align: middle; border: 0;" alt="입력"></a></div>
	<!-- //editor -->
</div>
<!-- //list -->
</form>
<!-- processing viewer -->
<div id="prcssDiv"  class="loingProcessDiv"><div><img src="/images/process4.gif"/></div></div>
<script type="text/javascript">
/** Jquery setting */
jQuery.noConflict();
jQuery(document).ready(function($) {
	$("#prcssDiv").hide();
});
</script>
<!-- //processing viewer --> 
