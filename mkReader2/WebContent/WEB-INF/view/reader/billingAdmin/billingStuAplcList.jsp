<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="com.mkreader.security.ISiteConstant" %>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript">
	//페이징
	function moveTo(where, seq) {

		$("pageNo").value = seq;
		billingStuAplcListForm.target = "_self";
		billingStuAplcListForm.action = "/reader/billingStuAdmin/billingStuAplcList.do";
		billingStuAplcListForm.submit();

	}
	//검색
	function fn_search(){
		
		if($("search_type").value == 'jikuk' ){
			$("realJikuk").value = '';
		}
		billingStuAplcListForm.target = "_self";
		billingStuAplcListForm.action = "/reader/billingStuAdmin/billingStuAplcList.do";
		billingStuAplcListForm.submit();
	}

	//신청 접수
	function acceptAplc(aplcdt, aplcno, warnYn){
		if(warnYn == "Y"){
			if(!confirm("30일 이내에 동일 계좌로 접수된 신청건이 존재 합니다. \n확인 후에 접수 진행해 주시기 바랍니다.")){
				return;
			}				
		}
		if(confirm("접수 처리 하시겠습니까?")){
			$("aplcdt").value = aplcdt;
			$("aplcno").value = aplcno;
			billingStuAplcListForm.target = "_self";
			billingStuAplcListForm.action = "/reader/billingStuAdmin/acceptStuAplcList.do";
			billingStuAplcListForm.submit();
		}
	}

	//신청 취소
	function cancelAplc(aplcdt, aplcno){
		if(confirm("취소 처리 하시겠습니까?")){
			$("aplcdt").value = aplcdt;
			$("aplcno").value = aplcno;
			billingStuAplcListForm.target = "_self";
			billingStuAplcListForm.action = "/reader/billingStuAdmin/refuseStuAplcList.do";
			billingStuAplcListForm.submit();
		}
	}
	//자세히 보기
	function detailVeiw(numId){
		var fm = document.getElementById("billingStuAplcListForm");
		/*
		billingStuAplcListForm.target="_self";
		billingStuAplcListForm.action = "/reader/billingStuAdmin/billingInfo.do";
		billingStuAplcListForm.submit();
		*/
		
		var left = (screen.width)?(screen.width - 750)/2 : 10;
		var top = (screen.height)?(screen.height - 750)/2 : 10;
		var winStyle = "width=750,height=750,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		var newWin = window.open("", "detailVeiw", winStyle);
		
		fm.target = "detailVeiw";
		fm.action = "/reader/billingStuAdmin/billingInfo.do?numId="+numId;
		fm.submit();
		
	}
	
	//
	function fn_showImage(imgNm) {
        var width="600";
    	var height="655";
    	url="/reader/billingAdmin/pop_showImage.jsp?imgNm=" + imgNm;
    	winOpts = "scrollbars=1,toolbar=no,location=no,directories=no,width="+width+",height="+height+",resizable=no,left=10,top=10";
    	window.open(url,'popup',winOpts);
	}

</script>
<!-- title -->
<div><span class="subTitle"> 학생구독신청리스트</span></div>
<!-- //title -->
<form id="billingStuAplcListForm" name="billingStuAplcListForm" action="" method="post">
<input type=hidden id="pageNo" name="pageNo" value="${param.pageNo}" />
<input type=hidden id="numId" name="numId" value="" />
<!-- search conditions -->
<div style="padding: 5px 0; width: 1020px">
	<table class="tb_search" style="width: 100%">
		<colgroup>
			<col width="100px">
			<col width="110px">
			<col width="100px">
			<col width="210px">
			<col width="500px">
		</colgroup>
		<tr>
			<th>상 태</th>
			<td>
				<select name="status" id="status" >
					<option value="ALL" <c:if test="${status eq 'ALL'}">selected </c:if>>전 체</option>
					<option value="0" <c:if test="${status eq '0'}">selected </c:if>>미확인</option>
					<option value="1" <c:if test="${status eq '1'}">selected </c:if>>접 수</option>
					<option value="2" <c:if test="${status eq '2'}">selected </c:if>>취 소</option>
				</select>
			</td>
			<th>신청일자</th>
			<td>
				<input type="text" id="fromDate" name="fromDate"  value="${fromDate}" readonly="readonly" onclick="Calendar(this)" style="vertical-align: middle; width: 85px"/> ~ 
				<input type="text" id="toDate" name="toDate"  value="${toDate}" readonly="readonly" onclick="Calendar(this)" style="vertical-align: middle; width: 85px"/>
			</td>
			<td>
				&nbsp;&nbsp;
				<select name="search_type" id="search_type" style="vertical-align: middle;">
					<option value="userName" <c:if test="${empty param.search_type or param.search_type eq 'userName'}">selected </c:if>>독자명</option>
					<option value="telNo" <c:if test="${param.search_type eq 'telNo'}">selected </c:if>>전화번호</option>
				</select>
				&nbsp;&nbsp;
				<input type="text" id="search_value" name="search_value"  value="${param.search_value}" onkeydown="if(event.keyCode == 13){fn_search();}"  style="vertical-align: middle; width: 140px"/> 
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="#fakeUrl" onclick="fn_search();"><img src="/images/bt_search.gif" style="vertical-align: middle; border: 0;"></a>
				
				<input type="hidden" id="aplcdt" name="aplcdt" />
				<input type="hidden" id="aplcno" name="aplcno" />
			
			</td>
		</tr>
	</table>
</div>
<!-- //search conditions -->
<!-- list -->
<div class="box_list">
	<table class="tb_list_a" style="width: 1020px">
		<colgroup>
			<col width="70px">
			<col width="90px">
			<col width="120px">
			<col width="40px">
			<col width="60px">
			<col width="215px">
			<col width="90px">
			<col width="85px">
			<col width="40px">
			<col width="60px">
			<col width="70px">
			<col width="40px">
			<col width="40px">
		</colgroup>
		<tr>
			<th>지국</th>
			<th>대학명</th>
			<th>학과</th>
			<th>학년</th>
			<th>성명</th>
			<th>주 &nbsp; 소</th>
			<th>연락처</th>
			<th>신청일시</th>
			<th>첨부</th>
			<th>접수자</th>
			<th>상태</th>
			<th>접수</th>
			<th>취소</th>
		</tr>
		
		<c:choose>
			<c:when test="${empty billingStuAplcList}">
				<tr><td colspan="13" >검색 결과가 없습니다.</td></tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${billingStuAplcList}" var="list" varStatus="i">
					<tr class="mover_color">
						<td style="text-align: left">${list.JIKUK}</td>
						<td style="text-align: left">${list.STU_SCH}</td>
						<td style="text-align: left">${list.STU_PART}</td>
						<td>${list.STU_CLASS}</td>
						<td style="text-align: left">
							<c:choose>
								<c:when test="${list.STATUS eq '1' }">
									<a href="#fakeUrl" onclick="detailVeiw('${list.USERNUMID}');">${list.USERNAME}</a>
								</c:when>
								<c:otherwise>
									${list.USERNAME}
								</c:otherwise>
							</c:choose>
						</td>
						<td style="text-align: left">${list.ADDR}</td>
						<td style="text-align: left">
							<c:choose>
								<c:when test="${empty list.HANDY}">
									${list.PHONE}
								</c:when>
								<c:otherwise>
									${list.HANDY}
								</c:otherwise>
							</c:choose>
						</td>
						<td>${list.INDT}</td>
						<td>
							<c:choose>
								<c:when test="${not empty list.FILE_NM}">
									<a href="#fakeUrl" onclick="fn_showImage('<%=ISiteConstant.PATH_UPLOAD_STU_APLC%>${list.FILE_NM}');" target="_blank"><img src="/images/ico_save_blue.png" style="vertical-align: middle;border: 0" alt="'${list.FILE_NM}" /></a>
								</c:when>
								<c:otherwise>
								</c:otherwise>
							</c:choose>
						</td>
						<td>${list.CHGPS}</td>
						<td>
							<c:choose>
								<c:when test="${list.STATUS eq '1' }">
									${list.CHGDT}
								</c:when>
								<c:when test="${list.STATUS eq '2' }">
									취 소
								</c:when>
								<c:otherwise>
									<c:choose>
										<c:when test="${list.WARN_YN eq 'Y' }">
											<img src="/images/spclMinwon.gif" alt="10일이내 동일계좌번호존재" style="vertical-align:middle; border:0" />					
										</c:when>
										<c:otherwise>
											미확인
										</c:otherwise>
									</c:choose>
								</c:otherwise>
							</c:choose>
						</td>
						<c:choose>
							<c:when test="${empty list.STATUS or list.STATUS eq '0' }">
								<td><a href="#fakeUrl" onclick="acceptAplc('${list.APLCDT}', '${list.APLCNO}', '${list.WARN_YN}');"><img src="/images/check.gif" alt="확인" style="vertical-align:middle; border:0" /></a></td>
								<td><a href="#fakeUrl" onclick="cancelAplc('${list.APLCDT}', '${list.APLCNO}');"><img src="/images/cross.gif" alt="취소" style="vertical-align:middle; border:0" /></a></td>
							</c:when>
							<c:otherwise>
								<td></td>
								<td></td>
							</c:otherwise>
						</c:choose>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>
	<%@ include file="/common/paging.jsp"%>
</div>
</form>