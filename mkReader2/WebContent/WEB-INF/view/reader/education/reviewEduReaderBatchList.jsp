<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>엑셀 미리보기</title>
<link rel="stylesheet" type="text/css" href="/css/addStyle.css" />
<script type="text/javascript">
/**
 * 엑셀저장 버튼 클릭 펑션
 */
function fn_excel_save(errorCnt) {
	var fm = document.getElementById("fm");
	
	//필수등록 컬럼 확인
	if(errorCnt > 0) {
		alert("필수등록값을 확인해 주세요.");
		return false;
	}
	
	if(!confirm("독자 일괄 등록을 하시겠습니까?")) {
		return false;
	}
	
	fm.target = "_self";
	fm.action = "/reader/education/insertEduReadersForExcel.do";
	fm.submit();
	window.close();
}

/**
 * 닫기 버튼 클릭 펑션
 */
function fn_cancel() {
	window.close();
}
</script>
</head>
<body>
<form name="fm" id="fm" action="">
	<input type="hidden" name="uploadedFileName" id="uploadedFileName" value="${uploadedFileName}" />
</form>
<div class="box_Popup">
	<div class="pop_title_box"><div class="pop_title">교육독자일괄등록 내역</div></div>
	<div style="padding: 10px 0; text-align: left: ;">
		<div style="margin-top: 0 auto; width: 100%;">
			<div style="float: left; padding: 0 1000px 0 10px;"><b>총 <c:out value="${totalrows}" />건 / 현재 <c:out value="${rows}" />건</b></div>
			<div style="float: left;"><b class="b03">* 필수등록</b></div>
		</div>  
		<table class="tb_list_a" style="width: 1180px">
			<colgroup>
				<col width="70px">
				<col width="70px">
				<col width="140px">
				<col width="90px">
				<col width="90px">
				<col width="60px">
				<col width="240px">
				<col width="80px">
				<col width="40px">
				<col width="60px">
				<col width="80px">
				<col width="180px">
			</colgroup>
			<tr>
				<th><b class="b03">*</b>회사코드</th>
				<th><b class="b03">*</b>관리팀</th>
				<th><b class="b03">*</b>성 명</th>
				<th>휴대폰</th>
				<th>전 화</th>
				<th>우편번호</th>
				<th>주 소</th>
				<th><b class="b03">*</b>관리지국</th>
				<th><b class="b03">*</b>부수</th>
				<th><b class="b03">*</b>단가</th>
				<th><b class="b03">*</b>신청일</th>
				<th>비 고</th>
			</tr>
		</table>
		<div style="width: 1180px; overflow-y: scroll; height: 658px; overflow-x: none; margin: 0 auto;">
			<table class="tb_list_a" style="width: 1163px">
				<colgroup>
					<col width="70px">
					<col width="70px">
					<col width="140px">
					<col width="90px">
					<col width="90px">
					<col width="60px">
					<col width="240px">
					<col width="80px">
					<col width="40px">
					<col width="60px">
					<col width="80px">
					<col width="163px">
				</colgroup>
				<c:set var="errorColumnCount" value="0" />
				<c:forEach begin="1" end="${rows}" step="1" varStatus="i">
					<c:if test="${data[i.index][0] eq '' ||  data[i.index][1]eq '' || data[i.index][2] eq '' || data[i.index][12] eq '' || data[i.index][13] eq '' || data[i.index][14] eq '' || data[i.index][15] eq ''}"><c:set var="errorColumnCount" value="${errorColumnCount+1}" /></c:if>
					<tr>
						<td style="background-color: #faafca;"><c:out value="${data[i.index][0]}" /></td>
						<td <c:if test="${data[i.index][1] != ''}">style="background-color: #faafca;"</c:if>><c:out value="${data[i.index][1]}" /></td>
						<td <c:if test="${data[i.index][2] != ''}">style="background-color: #faafca;"</c:if>><c:out value="${data[i.index][2]}" /></td>
						<td><c:out value="${data[i.index][3]}" />-<c:out value="${data[i.index][4]}" />-<c:out value="${data[i.index][5]}" /></td>
						<td><c:out value="${data[i.index][6]}" />-<c:out value="${data[i.index][7]}" />-<c:out value="${data[i.index][8]}" /></td>
						<td><c:out value="${data[i.index][9]}" /></td>
						<td style="text-align: left; padding-left: 10px;"><c:out value="${data[i.index][10]}" /><br/><c:out value="${data[i.index][11]}" /></td>
						<td <c:if test="${data[i.index][12] != ''}">style="background-color: #faafca;"</c:if>><c:out value="${data[i.index][12]}" /></td>
						<td <c:if test="${data[i.index][13] != ''}">style="background-color: #faafca;"</c:if>><c:out value="${data[i.index][13]}" /></td>
						<td <c:if test="${data[i.index][14] != ''}">style="background-color: #faafca;"</c:if>><c:out value="${data[i.index][14]}" /></td>
						<td <c:if test="${data[i.index][15] != ''}">style="background-color: #faafca;"</c:if>><c:out value="${data[i.index][15]}" /></td>
						<td style="text-align: left; padding-left: 10px;"><c:out value="${data[i.index][16]}" /></td>
					</tr>
				</c:forEach>
			</table>
		</div>
	</div>
	<!-- button -->
	<div style="width: 1180px; text-align: right; border: 0px solid">
		<span class="btnCss2"><a class="lk2" onclick="fn_excel_save('${errorColumnCount}');">등록</a></span>&nbsp;
		<span class="btnCss2"><a class="lk2" onclick="fn_cancel();">취소</a></span>
	</div>
	<!-- //button -->
</div>
</body>
</html>