<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging"%>
<script type="text/javascript">
	function goList() {
		var f = document.frm;
		
		f.action = "/billing/zadmin/cmsbank/index.do";
		f.submit();
	}

	function goChangeStatus(flag, jikuk, readno, serial, users_serial, result) {
		if ( flag == "1" ) {
			if ( result != null && result != "" ) {
				if ( confirm("정말 불능처리 하시겠습니까?") ) {
					var f = document.frm;
					
					f.jikuk.value = jikuk;
					f.readno.value = readno;
					f.serial.value = serial;
					f.users_serial.value = users_serial;
					f.result.value = result;
					f.flag.value = "1";		// 불능처리
					f.action = "/billing/zadmin/cmsbank/changeResult.do";
					f.submit();
				}
			}
			else if ( confirm("독자의 수금방법을 자동이체로 변경하시겠습니까?") ) {
				var f = document.frm;
				
				f.jikuk.value = jikuk;
				f.readno.value = readno;
				f.serial.value = serial;
				f.users_serial.value = users_serial;
				f.flag.value = "1";		// 자동이체 신청
				f.action = "/billing/zadmin/cmsbank/changeStatus.do";
				f.submit();
			}
		} 
		else if ( flag == "3" ) {
			if ( result == "0000" ) {
				if ( confirm("독자의 수금방법을 자동이체에서 방문으로 변경하시겠습니까?") ) {
					var f = document.frm;
	
					f.jikuk.value = jikuk;
					f.readno.value = readno;
					f.serial.value = serial;
					f.users_serial.value = users_serial;
					f.flag.value = "3";		// 자동이체 해지
					f.action = "/billing/zadmin/cmsbank/changeStatus.do";
					f.submit();
				}
			}
			else if ( result != "" ) {
				if ( confirm("정말 불능처리 하시겠습니까?") ) {
					var f = document.frm;
					
					f.jikuk.value = jikuk;
					f.readno.value = readno;
					f.serial.value = serial;
					f.users_serial.value = users_serial;
					f.result.value = result;
					f.flag.value = "3";		// 불능처리
					f.action = "/billing/zadmin/cmsbank/changeResult.do";
					f.submit();
				}
			}
		}
		else {
			alert("잘못된 flag값입니니다.");
		}
	}

	function makeEB12() {
		if ( confirm("EB12 파일을 생성하시겠습니까?") ) {
			var f = document.frm;
			
			f.action = "/billing/zadmin/cmsbank/process12b.do";
			f.submit();
		}
	}
	function popReaderView(boseq,serial){
		var width="600";
		var height="655";
		LeftPosition=(screen.width)?(screen.width-width)/2:100;
		TopPosition=(screen.height)?(screen.height-height)/2:100;
		url="/billing/zadmin/popup/view.do?boseq=" + boseq + "&serial=" + serial;
		winOpts = "scrollbars=1,toolbar=no,location=no,directories=no,width="+width+",height="+height+",resizable=no,left="+LeftPosition+",top="+TopPosition;
		var obj = window.open(url,'popup',winOpts);
	}
</script>
<!-- title -->
<div><span class="subTitle">은행신청 처리결과</span></div>
<!-- //title -->
<form name="frm" method="post">
<input type="hidden" id="numid" name="numid" value="${numid}" />
<input type="hidden" id="filename" name="filename" value="${filename}" />
<input type="hidden" id="cmsdate" name="cmsdate" value="${cmsdate}" />
<input type="hidden" id="pageNo" name="pageNo" value="${pageNo}" />
<input type="hidden" id="flag" name="flag" />
<input type="hidden" id="jikuk" name="jikuk" />
<input type="hidden" id="readno" name="readno" />
<input type="hidden" id="serial" name="serial" />
<input type="hidden" id="users_serial" name="users_serial" />
<input type="hidden" id="result" name="result" />
	<div class="box_gray" style="font-weight: bold; padding: 10px 0; width: 1020px;">CMS file : <font class="b03"><c:out value="${resultMap.FILENAME}" /></font> 처리 결과 명세</div>
	<div style="padding: 5px 0 10px 0;">
		<table class="tb_search" style="width: 1020px;">
			<col width="260px">
			<col width="760px">
			<tr>
				<th>신청접수 일자</th>
				<td><c:out value="${resultMap.CMSDATE}" /></td>
			</tr>
			<tr>
				<th>총 등록의뢰 건</th>
				<td><fmt:formatNumber value="${fn:trim(resultMap.TOTALS)}" type="number" /> 건</td>
			</tr>
			<tr>
				<th>신규 등록</th>
				<td><fmt:formatNumber value="${fn:trim(resultMap.TYPE1)}" type="number" /> 건</td>
			</tr>
			<tr>
				<th>변경 등록</th>
				<td><fmt:formatNumber value="${fn:trim(resultMap.TYPE2)}" type="number" /> 건</td>
			</tr>
			<tr>
				<th>해지 등록</th>
				<td><fmt:formatNumber value="${fn:trim(resultMap.TYPE3)}" type="number" /> 건</td>
			</tr>
			<tr>
				<th>임의 해지</th>
				<td><fmt:formatNumber value="${fn:trim(resultMap.TYPE4)}" type="number" /> 건</td>
			</tr>
		</table>
	</div>			
	<table class="tb_list_a_5" style="width: 1020px">
		<col width="120px">
		<col width="100px">
		<col width="120px">
		<col width="140px">
		<col width="140px">
		<col width="120px">
		<col width="280px">
		<tr>
			<th>일련번호</th>
			<th>신청일</th>	
			<th>신청구분</th>
			<th>납부자번호<br/>지국</th>
			<th>납부자번호<br/>개인구분</th>
			<th>불능코드</th>
			<th>&nbsp;</th>
		</tr>
		<c:choose>
			<c:when test="${empty resultList}">
				<tr><td colspan="7" >등록된 정보가 없습니다.</td></tr>
			</c:when>
			<c:otherwise>
				<c:forEach items="${resultList}" var="list" varStatus="status">
					<tr>
						<td><c:out value="${list.SERIAL}" /></td>
						<td><c:out value="${list.RDATE}" /></td>
					    <td><c:if test="${list.TYPE == '1'}">신청</c:if><c:if test="${list.TYPE == '3'}">해지</c:if><c:if test="${list.TYPE == '7'}">임의해지</c:if></td>
					    <td><c:out value="${fn:substring(list.NUMBER_,0,6)}" /></td>
						<td><a href="#fakeUrl" onclick="popReaderView('${fn:substring(list.NUMBER_,0,6)}','${fn:substring(list.NUMBER_,6,15)}');"><c:out value="${fn:substring(list.NUMBER_,6,15)}" /></a></td>
						<td><c:out value="${fn:substring(list.RESULT,1,5)}" /><br><c:out value="${list.CMSRESULTMSG}" /></td>
		                <td>
							<c:choose>
							<c:when test="${list.TYPE == '3'}">
								<c:if test="${fn:substring(list.RESULT,1,5) == '0000'}">
									<c:if test="${list.CCODE == 'CHNG'}">
										계좌변경 해지(완료)
									</c:if>
									<c:if test="${list.CCODE != 'CHNG'}">
										해지(완료)
									</c:if>
									
								</c:if>
								<c:if test="${fn:substring(list.RESULT,1,5) != '0000'}">
									<c:if test="${list.CCODE == 'CHNG'}">
										계좌변경 해지(${list.CMSRESULTMSG})
									</c:if>
									<c:if test="${list.CCODE != 'CHNG'}">
										불능처리(${list.CMSRESULTMSG})
									</c:if>
								</c:if>
							</c:when>
							<c:when test="${list.TYPE == '1'}">
								<c:choose>
								<c:when test="${fn:substring(list.RESULT,1,5) == '0000'}">
									<c:if test="${list.CCODE == 'CHNG'}">
										계좌변경 신청(완료)
									</c:if>
									<c:if test="${list.CCODE != 'CHNG'}">
										신청(완료)
									</c:if>
								</c:when>
								<c:when test="${fn:substring(list.RESULT,1,5) != '0000'}">
									<c:if test="${list.CCODE == 'CHNG'}">
										계좌변경 신청(${list.CMSRESULTMSG})
									</c:if>
									<c:if test="${list.CCODE != 'CHNG'}">
										불능처리(${list.CMSRESULTMSG})
									</c:if>
									
								</c:when>
								</c:choose>
							</c:when>
							</c:choose>
						</td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</table>
</form>
<div style="padding: 10px 0 20px 0; text-align: right; width: 1020px; margin: 0 auto;">
	<a href="#" onclick="history.go(-1);"><img src="/images/bt_back.gif" border="0" alt="돌아가기" /></a>
	<a href="#" onclick="makeEB12();"><img src="/images/bt_EB12.jpg" border="0" alt="EB12생성" /></a>
</div>