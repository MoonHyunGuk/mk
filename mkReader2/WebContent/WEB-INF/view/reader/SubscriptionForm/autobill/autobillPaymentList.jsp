<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>자동이체 거래내역 리스트</title>
<link type="text/css" href="/css/mkcrm.css" rel="stylesheet"> 
<style type="text/css">
.header_logo {position:absolute; left:23px; top:20px}
</style>
<script type="text/javascript">
/**
 * 팝업창 닫기
 */
function fn_window_close() {
	window.close();
}
</script>
</head>
<body>
<div class="box_Popup">
	<!-- header -->
	<div style="background:url(http://img.mk.co.kr/payment/bg_pay_top.gif) repeat-x 0 0;  height:45px; overflow: hidden; border-bottom: 2px solid #e3e3e3">
		<div class="header_logo"><img src="/images/logo/logo_mk.gif" alt="매일경제"/></div>	
	</div>
	<!-- //header -->
	<div style="overflow: hidden;">
		<div style="float: left; width: 190px; text-align: left;">
			<div><img alt="" src="/images/gif/logo_mypage.gif"></div>
			<div style="border: 1px solid #c5c5c5; width: 178px; padding: 15px 0; text-align: center;"><strong>${bankNm }</strong>&nbsp;님</div>
		</div>
		<div style="float: left;">
			<div style="font-size: 1.3em; color: #747474; font-weight: bold; padding: 20px 10px 10px 10px ;">자동이체 결제 내역</div>
			<div style="border-top: 2px solid #020202; width: 620px">
				<table class="tb_list_a" style="width: 617px;">
						<colgroup>   
							<col width="90px">  
							<col width="120px">  
							<col width="100px">  
							<col width="100px">  
							<col width="120px">     
							<col width="87px">
						</colgroup>
						<thead>
							<tr>
								<th>월 분</th>
								<th>결제일자</th>
								<th>청구금액</th>
								<th>결제금액</th>
								<th>결제방법</th>
								<th>결제상태</th>
							</tr>
						</thead>
				</table>
				<div style="width: 620px; height: 261px; overflow-y: scroll; margin: 0 auto;">
					<table class="tb_list_a" style="width: 600px;">
						<colgroup>  
							<col width="90px">  
							<col width="120px">  
							<col width="100px">  
							<col width="100px">  
							<col width="120px">     
							<col width="70px">
						</colgroup>
						<tbody>
							<c:choose>
								<c:when test="${sugmList ne null }">
									<c:forEach items="${sugmList }" var="list" varStatus="i">
										<tr>
											<td>${list.YYMM }</td>
											<td>${list.SNDT }</td>
											<td>${list.BILLAMT }</td>
											<td>${list.AMT }</td>
											<td>${list.SGBBCDNM }</td>
											<td>	
												<c:choose>
													<c:when test="${list.SGBBCD eq  list.SGGBCD}">수납</c:when>
													<c:when test="${list.SGBBCD eq  '044'}">미납</c:when>
													<c:when test="${list.SGBBCD ne  list.SGGBCD}">${SGBBCDNM }</c:when>
												</c:choose>
											</td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<tr><td colspan="5">- 결제 내역이 없습니다 -</td></tr>
								</c:otherwise>
							</c:choose>
				        </tbody>
					</table>
				</div>
			</div>
			<!-- button -->	
			<div style="text-align: right; padding-top: 10px; width: 620px">
				<span class="btnCss2"><a class="lk2" onclick="fn_window_close();">닫기</a></span>
			</div>
			<!-- //button -->
		</div>
	</div>
	<!-- notice -->
	<div style="padding: 20px 0 0 0; clear: both; text-align: center;">
		<div style="border-top: 2px solid #020202; padding: 10px 0 0 5px; font-size: 1.0em"> 
			Copyright© 2006. 매경인터넷(주). 서울특별시 중구 필동 1가 30-1 매경미디어센터 9층.<br/>
			매경인터넷은 회원의 허락없이 개인정보를 수집, 공개, 유출을 하지 않으며 회원정보의 보호를 위해 최선을 다합니다.<br/>
			사업자 등록번호 : 201-81-25980 / 통신판매업 신고 : 중구00083호&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;이용관련문의 : 02-2000-2000
		</div>
	</div>
	<!-- //notice -->
</div>
</body>
</html>