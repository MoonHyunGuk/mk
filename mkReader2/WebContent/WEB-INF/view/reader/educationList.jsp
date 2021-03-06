<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ page import="com.mkreader.security.ISiteConstant" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script type="text/javascript">
	//숫자만 입력 가능하도록 체크 키 다운시
	function inputNumCom(){
		var keycode = event.keyCode;
		 
		if ((event.keyCode<48) || (event.keyCode>57)){
			alert("숫자만 입력 가능합니다.");
			event.keyCode = 0;  // 이벤트 cancel
		}
	}
	//페이징
	function moveTo(where, seq) {
		if($("loginType").value == "A"){
			if($("opBoSeq").value != '' || $("companyCd").value != '' || $("searchText").value != ''){
				$("pageNo").value = seq;
				educationForm.target = "_self";
				educationForm.action = "/reader/education/searchEducationList.do";
				educationForm.submit();
			}else{
				$("pageNo").value = seq;
				educationForm.target = "_self";
				educationForm.action = "/reader/education/retrieveEducationList.do";
				educationForm.submit();	
			}
		}else{
			if($("searchText").value != ''){
				$("pageNo").value = seq;
				educationForm.target = "_self";
				educationForm.action = "/reader/education/searchEducationList.do";
				educationForm.submit();
			}else{
				$("pageNo").value = seq;
				educationForm.target = "_self";
				educationForm.action = "/reader/education/retrieveEducationList.do";
				educationForm.submit();	
			}
		}
	}
	//readno등록
	function updateReadno(seq){
		if(    $("tmp_readNo"+seq).value.length != 9      ){
			alert('9자리 독자번호를 입력해주세요.');
			$("tmp_readNo"+seq).focus();
			return;
		}
		
		$("seq").value = seq;
		$("readNo").value = $("tmp_readNo"+seq).value ;
		
		educationForm.action="/reader/education/updateReadNo.do";
		educationForm.target="_self";
		educationForm.submit();
	}
	//검색
	function fn_search(){
		$("pageNo").value = '1';
		educationForm.target = "_self";
		educationForm.action = "/reader/education/searchEducationList.do";
		educationForm.submit();
	}
	//해지
	function del(seq , readNo , boSeq){
		if(confirm('교육용 독자를 해지 하시겠습니까?') == false){
			return;
		}
		$("seq").value = seq;
		$("readNo").value = readNo;
		$("agent").value = boSeq;
		educationForm.target = "_self";
		educationForm.action = "/reader/education/deleteReader.do";
		educationForm.submit();
	}
	//엑셀 저장
	function excel(){
		educationForm.target = "_self";
		educationForm.action = "/reader/education/excelEducationList.do";
		educationForm.submit();
	}
	//수금 이력
	function sugm(readNo , boSeq , news_seq , readNm){
		$("readNo").value = readNo;
		$("agent").value = boSeq;
		$("news_seq").value = news_seq;
		$("readNm").value = readNm;
		var left = (screen.width)?(screen.width - 830)/2 : 10;
		var top = (screen.height)?(screen.height - 600)/2 : 10;
		var winStyle = "width=500,height=650,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=0";
		var newWin = window.open("", "paymentHist", winStyle);
		educationForm.target = "paymentHist";
		educationForm.action = "/reader/education/popPaymentHist.do";
		educationForm.submit();
	}
	//교육용 독자 정보
	function educationInfo(seq , readNo , boSeq){
		$("seq").value = seq;
		$("readNo").value = readNo;
		$("agent").value = boSeq;
		educationForm.target = "_self";
		educationForm.action = "/reader/education/educationInfo.do";
		educationForm.submit();
	}
	//수금파일 입력
	function insertSugm(){
		var f = document.educationForm;
		
		
		
		if ( !f.sugmfile.value ) {
			alert("파일을 첨부해 주시기 바랍니다.");
			f.sugmfile.focus();
			return;
		}else{
			if(f.sugmfile.value.indexOf('xls') > -1){
				if(f.sugmfile.value.indexOf('xlsx') > -1){
					f.sugmfile.focus();
					alert('.xls 형식 파일만 입력 가능합니다.');
					return;
				}
			}else{
				f.sugmfile.focus();
				alert('.xls 형식 파일만 입력 가능합니다.');
				return;
			}
		}
		
		educationForm.target="_self";
		educationForm.action="/reader/education/saveSugm.do";
		educationForm.submit();
	}

</script>
<!-- title -->
<div><span class="subTitle">교육용독자 리스트</span></div>
<!-- //title -->
<form id="educationForm" name="educationForm" action="" method="post" enctype="multipart/form-data">
	<input type=hidden id="pageNo" name="pageNo" value="${param.pageNo}" />
	<input type=hidden id="loginType" name="loginType" value="${loginType}" />
	<input type=hidden id="seq" name="seq" value="" />
	<input type=hidden id="readNo" name="readNo" value="" />
	<input type=hidden id="readNm" name="readNm" value="" />
	<input type=hidden id="qty" name="qty" value="" />
	<input type=hidden id="agent" name="agent" value="" />
	<input type=hidden id="uPrice" name="uPrice" value="" />
	<input type=hidden id="news_seq" name="news_seq" value="" />
	<!-- search condition -->
	<div class="box_white" style="padding: 10px 0;">
		<c:if test="${loginType eq 'A'}">
			<font class="b02">지 국</font>&nbsp;
			<select id="opBoSeq" name="opBoSeq" onchange="fn_search();" style="vertical-align: middle; width: 100px;">
				<option value="">전 체</option>
				<c:forEach items="${agencyAllList }" var="list">
				<option value="${list.SERIAL }" <c:if test="${param.opBoSeq eq list.SERIAL }"> selected </c:if>>${list.NAME }</option>
				</c:forEach>
			</select>
			&nbsp;&nbsp;&nbsp;
			<font class="b02">업 체</font>&nbsp;
			<select id="companyCd" name="companyCd" onchange="fn_search();" style="vertical-align: middle;  width: 100px;">
				<option value="">전 체</option>
				<c:forEach items="${companyList }" var="list">
				<option value="${list.CODE }" <c:if test="${param.companyCd eq list.CODE }"> selected </c:if>>${list.CNAME }</option>
				</c:forEach>
			</select>
			&nbsp;&nbsp;&nbsp;
			<font class="b02">만료여부</font>&nbsp;
			<select id="expYn" name="expYn" style="vertical-align: middle;" onchange="fn_search();">
				<option value="ALL" <c:if test="${param.expYn eq 'ALL' }"> selected </c:if>>전 체</option>
				<option value="N" <c:if test="${param.expYn eq 'N' }"> selected </c:if>>정 상</option>
				<option value="Y" <c:if test="${param.expYn eq 'Y' }"> selected </c:if>>만 료</option>
			</select>
			&nbsp;&nbsp;&nbsp;
		</c:if>
		<font class="b02">상 태</font>&nbsp;
		<select id="status" name="status" style="vertical-align: middle;" onchange="fn_search();">
			<option value="1" <c:if test="${param.status eq '1' }"> selected </c:if>>전 체</option>
			<option value="2" <c:if test="${param.status eq '2' }"> selected </c:if>>정 상</option>
			<option value="3" <c:if test="${param.status eq '3' }"> selected </c:if>>해 지</option>
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<select id="searchKey" name="searchKey" style="vertical-align: middle;" >
			<option value="readnm" <c:if test="${param.searchKey eq 'readnm' }"> selected </c:if>>성 명</option>
			<option value="company" <c:if test="${param.searchKey eq 'company' }"> selected </c:if>>회 사 명</option>
			<option value="readno" <c:if test="${param.searchKey eq 'readno' }"> selected </c:if>>독자번호</option>
		</select>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="text" id="searchText" name="searchText" size="20" value="${param.searchText }" onkeydown="if(event.keyCode == 13){fn_search(); }" style="vertical-align: middle;"/>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<img src="/images/bt_search.gif" style="vertical-align: middle; border: 0; cursor: pointer;" onclick="fn_search();" />
		&nbsp;&nbsp;&nbsp;&nbsp;
		<img src="/images/bt_savexel.gif" style="vertical-align: middle; border: 0; cursor: pointer;" onclick="excel();" />
	</div>
	<!-- //search condition -->
	<c:if test="${loginType eq 'A'}">
		<div style="padding-top: 10px">
			<div class="box_white" style="padding: 10px 0; overflow: hidden;">
				<font class="b02">수금 등록</font>&nbsp; 
				<b class="b03">* .xls 파일만 수금 등록 가능합니다.</b>	&nbsp; &nbsp; &nbsp; &nbsp;
				<a href="<%=ISiteConstant.PATH_UPLOAD_EDUCATION_RESULT%>/sample.jpg" target="_blank">샘플파일 보기</a>&nbsp; &nbsp; &nbsp; &nbsp;
				<input type="file" name="sugmfile" id="sugmfile" style="width:400px; vertical-align: middle;">&nbsp; &nbsp; &nbsp; &nbsp; 
				<a href="#fakeUrl" onclick="insertSugm();"><img src="/images/bt_eepl.gif" style="vertical-align: middle; border: 0;"></a>
			</div>
		</div>
	</c:if>
	<!-- list -->
	<div class="box_list">
		<div style="padding: 0 0 5px 0;">
			<font class="b02">정상 구독 부수 : ${count }</font>
		</div>
		<table class="tb_list_a" style="width: 1020px;">  
			<colgroup>
				<c:choose>
					<c:when test="${loginType eq 'A'}">
						<col width="60px"/>
						<col width="110px"/>
						<col width="140px"/>
						<col width="295px"/>
						<col width="105px"/>
						<col width="35px" />
						<col width="35px"/>
						<col width="85px"/>
						<col width="65px"/>
						<col width="40px"/>
						<col width="50px"/>
					</c:when>
					<c:otherwise>
						<col width="110px"/>
						<col width="140px"/>
						<col width="375px"/>
						<col width="115px"/>
						<col width="40px" />
						<col width="40px"/>
						<col width="85px"/>
						<col width="65px"/>
						<col width="50px"/>
					</c:otherwise>
				</c:choose>
			</colgroup>	
			<tr>
				<c:if test="${loginType eq 'A'}">
					<th>지국</th>
				</c:if>
				<th>회사명</th>
				<th>독자명</th>
				<th>주소</th>
				<th>연락처</th>
				<th>부수</th>
				<th>단가</th>
				<th>신청일<br/>(해지일)</th>
				<th>독자번호</th>
				<th>상태</th>
				<c:choose>
					<c:when test="${loginType eq 'A'}">
						<th>해지</th>
					</c:when>
				</c:choose>			
			</tr>
			<c:forEach items="${educationList }" var="list">
				<tr class="mover_color">
					<c:choose>
						<c:when test="${loginType eq 'A'}">
							<td style="text-align: left;">${list.AGENTNM}</td>	
							<td style="text-align: left;">${list.COMPANY_TEMP}</td>
							<td style="text-align: left;"><a href="#fakeUrl" onclick="educationInfo('${list.SEQ }','${list.READNO }','${list.BOSEQ }');">${list.READNM}</a></td>
							<td style="text-align: left;">${list.DLVADRS1} ${list.DLVADRS2}</td>
							<td>${list.TEL }</td>
							<td>${list.QTY }</td>
							<td><a href="#fakeUrl" onclick="sugm('${list.READNO }','${list.BOSEQ }','${list.NEWS_SEQ }','${list.READNM }');">${list.UPRICE }</a></td>
							<c:choose>
								<c:when test="${list.DELYN eq 'Y' }">
									<td>${list.HJDT }<br/>(<font class="b03">${list.STDT }</font>)</td>
									<td>${list.READNO }</td>
									<td><font class="b03">해지</font></td>
								</c:when>
								<c:otherwise>
									<td>${list.HJDT }</td>
									<td>${list.READNO }</td>
									<td>정상</td>
								</c:otherwise>
							</c:choose>
							<td><a href="#fakeUrl" onclick="del('${list.SEQ }','${list.READNO }','${list.BOSEQ }');"><img src="/images/bt_imx.gif" alt="삭제" style="vertical-align: middle; border: 0;"/></a></td>
						</c:when>
						<c:otherwise>
							<td style="text-align: left;">${list.COMPANYNM}</td>
							<td style="text-align: left;">${list.READNM}</td>
							<td style="text-align: left;">${list.DLVADRS1} ${list.DLVADRS2}</td>
							<td>${list.TEL }</td>
							<td>${list.QTY }</td>
							<td><a href="#fakeUrl" onclick="sugm('${list.READNO }','${list.BOSEQ }','${list.NEWS_SEQ }','${list.READNM }');">${list.UPRICE }</a></td>
							<c:choose>
								<c:when test="${list.DELYN eq 'Y' }">
									<td>${list.HJDT }<br/>(<font class="b03">${list.STDT }</font>)</td>
									<td>${list.READNO }</td>
									<td><font class="b03">해지</font></td>
								</c:when>
								<c:otherwise>
									<td>${list.HJDT }</td>
									<td>${list.READNO }</td>
									<td>정상</td>
								</c:otherwise>
							</c:choose>
						</c:otherwise>
					</c:choose>
				</tr>
			</c:forEach>
		</table>
		<div style="width: 100%; background-color: #efefef; text-align: center;"><%@ include file="/common/paging.jsp"%></div>
	</div>
	<!-- //list -->
</form>