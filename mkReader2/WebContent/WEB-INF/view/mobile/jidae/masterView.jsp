<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
 <%
	String _User_Agent = (request.getHeader("User-Agent")).toUpperCase();
	String _SCALE = "1.0";
	
	if((_User_Agent.indexOf("MOBILE") > 0) || (_User_Agent.indexOf("LGTELECOM") > 0)) {
	 _SCALE = "1.0";
	} else if(_User_Agent.indexOf("SAMSUNG") > 0) {
	_SCALE = "0.8";
	} 
	
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<meta name="viewport" content="width=device-width; initial-scale=<%=_SCALE %>; maximum-scale=3.0; minimum-scale=1.0; user-scalable=yes;">
<title>매일경제 지대통지서</title>
<style type="text/css">
body,input,textarea,select,table,button{font-size:0.6em;line-height:1.25em;font-family: Dotum,Helvetica,AppleGothic,Sans-serif}

.tb_edit_mobile {margin:0 auto; text-align:center; border-collapse:collapse; font:normal 1.0em Gulim, "굴림", Verdana, Geneva; }
.tb_edit_mobile th, .tb_edit_mobile td {padding:4px 1px; }
.tb_edit_mobile th {text-align:center; border:1px solid #c0c0c0; background-color: #eeeeee; font-weight: bold;}
.tb_edit_mobile td {text-align:center; border:1px solid #c0c0c0; background-color: #fff; }

/** button */
.btnCss2 a{display:inline-block;width:61px;height:28px;line-height:27px;background:#ddd url(http://static.naver.com/www/m/cm/im/ftv2.gif) no-repeat 0 -42px;font-size:13px;letter-spacing:-1px;text-align: center; color:#666; text-decoration: none;}
.btnCss2 a.lk2{width:58px;background-position:0 -70px; cursor: pointer;}
</style>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
/**
 * 조회버튼 클릭 이벤트
 */
function fn_search() {
	var fm = document.getElementById("fm");
	var dataChkYn = "";
	
	jQuery.ajax({
		type 		: "POST",
		url 		: "/mobile/jidae/ajaxSelectJikukList.do",
		dataType 	: "json",
		async 		: false,
		data		: "localCode="+jQuery("#localCode").val()+"&chkSellerYn="+jQuery("#chkSellerYn").val()+"&chkAdminMngYn="+jQuery("#chkAdminMngYn").val()+"&boSeqNm="+jQuery("#boSeqNm").val(),
		success:function(data){
			var getBoseq = data.boSeq;
			
			if(getBoseq != null) {
				jQuery("#icoOkChk").show();
				jQuery("#icoNoChk").hide();
				jQuery("#boseq").val(getBoseq);
				dataChkYn ="Y";
			} else {
				jQuery("#icoOkChk").hide();
				jQuery("#icoNoChk").show();
				jQuery("#boseq").val("");
				dataChkYn ="N";
			}
			
			if("N" == dataChkYn) {
				alert("지국명을 확인해주세요.");
				return false; 
			} else	if("" == getBoseq) {
				alert("지국을 입력해 주세요.");
				return false;
			} else {
				fm.target = "_self";
				fm.action = "/mobile/jidae/masterJidaeView.do";
				fm.submit();
			}
		},
		error    : function(r) { alert("ajax error");}
	}); //ajax end
}

/**
 * 지국명 체크
 */
function fn_chkBoseqNm(boseqNm) {
	if(boseqNm.length < 1) {
		jQuery("#icoOkChk").hide();
		jQuery("#icoNoChk").show();
		jQuery("#boseq").val("");
	}
}

jQuery(document).ready(function($){
	var getBoseq = jQuery("#boseq").val();
	
	if(getBoseq != null) {
		jQuery("#icoOkChk").show();
		jQuery("#icoNoChk").hide();
	} else {
		jQuery("#icoOkChk").hide();
		jQuery("#icoNoChk").show();
		jQuery("#boseq").val("");
		jQuery("#boSeqNm").val("");
	}
});
</script>
</head>
<body>
<div style="width: 100%; padding-top: 5px">
	<div style="float: left; width: 17%;"><img alt="매일경제" src="/images/ico_ci_mk.jpg" style="width: 48px"></div>
	<div style="float: left; width: 83%; background-color: #f36f21; height: 38px;"></div>
</div>
<div style="clear: both; width: 98%; margin: 0 auto; padding-top: 10px; padding-bottom: 10px; border-left: 3px solid #f36f21; border-right: 3px solid #f36f21; border-bottom: 3px solid #f36f21; ">
	<div style="width: 95%; margin: 0 auto;">
		<div style="font-weight: bold; font-size: 1.4em; padding-bottom: 10px; text-align: center; overflow: hidden;">[지대납부금통지서]</div>
		<div style="overflow: hidden; padding-bottom: 10px;">
			<form action="#fakeUrl" name="fm" id="fm">
				<input type="hidden" name="userId" id="userId" value="${userId }" />
				<input type="hidden" name="boseq" id="boseq" value="${boseq }" />
				<input type="hidden" name="chkAdminMngYn" id="chkAdminMngYn" value="${chkAdminMngYn }" /> 	<!-- 관리자, 관리팀여부체크 -->
				<input type="hidden" name="chkSellerYn" id="chkSellerYn" value="${chkSellerYn }" />						<!-- 영업담당여부체크 -->
				<input type="hidden" name="localCode" id="localCode" value="${localCode }" />								<!-- 영업담당시 담당코드 -->
				<table class="tb_edit_mobile" style="width: 100%">
					<colgroup>
						<col width="18%" />
						<col width="60%" />
						<col width="2%" />
						<col width="20%" />
					</colgroup>
					<tr>
						<th>지 국 명</th>
						<td style="text-align: left;">	
							&nbsp;
							<input  type="text" name="boSeqNm" id="boSeqNm" value="${boSeqNm }" style="width: 40%; vertical-align: middle;" maxlength="6"  onblur="fn_chkBoseqNm(this.value);" />
							<img id="icoOkChk" alt="가능" src="/images/ico/ico_yes.png" style="vertical-align: middle; width: 16px;">
							<img id="icoNoChk" alt="불가능" src="/images/ico/ico_no.png"  style="vertical-align: middle; width: 16px">
								<!-- 
							<select name="boseq" id="boseq" style="width: 100px; vertical-align: middle; font-size: 1.2em">
								<option value=""> 선택</option>
								<c:forEach items="${agencyAllList }" var="list">
									<option value="${list.SERIAL }" <c:if test="${boseq eq list.SERIAL}">selected="selected" </c:if>>${list.NAME } </option>
								</c:forEach>
							</select>
								 -->
						</td>
						<td rowspan="2" style="border: 0px;">&nbsp;</td>
						<td rowspan="2" style="font-weight: bold; color: #ffffff; background-color: #f36f21; border: 1px solid #dd5606; padding: 0; font-size: 1.3em" onclick="fn_search();">조 회</td>
					</tr>
					<tr>
						<th>월&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;분</th>
						<td style="text-align: left;">
							&nbsp;	
							<select name="opYear" id="opYear" style="width: 70px; vertical-align: middle; font-size: 1.2em">
								<c:forEach var="i" begin="2014" end="${intYear}">
									<option value="${i}" <c:if test="${opYear eq i}">selected="selected"</c:if>>${i}년</option>
								</c:forEach> 
							</select>
							&nbsp;
							<select name="opMonth" id="opMonth" style="width: 70px; vertical-align: middle; font-size: 1.2em">
								<c:forEach var="i" begin="1" end="12">
									<c:choose>
										<c:when test="${i < 10}">
											<c:set var="optVal" value="0${i}" />
										</c:when>
										<c:otherwise>
											<c:set var="optVal" value="${i}" />
										</c:otherwise>
									</c:choose>
									<option value="${optVal}" <c:if test="${opMonth eq optVal}">selected="selected"</c:if>>${i}월분</option>
								</c:forEach>
							</select>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<table class="tb_edit_mobile" style="width: 100%">
			<colgroup>
				<col width="18%" />
				<col width="32%" />
				<col width="18%" />
				<col width="32%" />
			</colgroup>
			<tr>
				<th>소&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;속</th>
				<td>${jidaeData.TYPE}</td>
				<th>지국장명</th>
				<td>${jidaeData.AGENCYNM}</td>
			</tr>
		</table>
		<!-- 지대내역 -->
		<div style="padding-top: 10px;">
			<div style="font-weight: bold; font-size: 1.4em; padding-bottom: 3px">1. 지대내역</div>
			<table class="tb_edit_mobile" style="width: 100%">
				<colgroup>
					<col width="25%" />
					<col width="25%" />
					<col width="25%" />
					<col width="25%" />
				</colgroup>
				<tr>
					<th>구&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;분</th>
					<th>금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</th>
					<th>구&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;분</th>
					<th>금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</th>
				</tr>
				<tr>
					<th>전월이월액</th>
					<td><fmt:formatNumber value="${jidaeData.MISU}" pattern="#,###" /></td>
					<th>당월조정액</th>
					<td><fmt:formatNumber value="${jidaeData.CUSTOM}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th colspan="3">지대 공제내역 및 공제금액</th>
					<td><fmt:formatNumber value="${jidaeData.SUBTOTAL}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th><c:if test="${jidaeData.BUSUGRANT != null}">부수유지장려금</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.BUSUGRANT}" pattern="#,###" /></td>
					<th><c:if test="${jidaeData.TMP1 != null}">소외계층,NIE</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.TMP1}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th><c:if test="${jidaeData.STUGRANT != null}">학 생 장 려 금</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.STUGRANT}" pattern="#,###" /></td>
					<th><c:if test="${jidaeData.TMP2 != null}">우편요금</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.TMP2}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th><c:if test="${jidaeData.ETCGRANT != null}">기 타 장 려 금</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.ETCGRANT}" pattern="#,###" /></td>
					<th><c:if test="${jidaeData.TMP3 != null}">사원구독</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.TMP3}" pattern="#,###" /></td>
				</tr>
				<tr> 
					<th><c:if test="${jidaeData.CARD != null}">카&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;드</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.CARD}" pattern="#,###" /></td>
					<th><c:if test="${jidaeData.TMP4 != null}">기타</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.TMP4}" pattern="#,###" /></td>
				</tr>
				<tr> 
					<th><c:if test="${jidaeData.EDU != null}">교&nbsp;&nbsp;&nbsp;육&nbsp;&nbsp;&nbsp;용</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.EDU}" pattern="#,###" /></td>
					<th><c:if test="${jidaeData.TMP5 != null}">지로&nbsp;/&nbsp;바코드</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.TMP5}" pattern="#,###" /></td>
				</tr>
				<tr> 
					<th><c:if test="${jidaeData.AUTOBILL != null}">자&nbsp;&nbsp;동&nbsp;&nbsp;이&nbsp;&nbsp;체</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.AUTOBILL}" pattern="#,###" /></td>
					<th><c:if test="${jidaeData.TMP6 != null}">판매수수료(VAT)</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.TMP6}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th><c:if test="${jidaeData.STU != null}">학&nbsp;&nbsp;생&nbsp;&nbsp;배&nbsp;&nbsp;달</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.STU}" pattern="#,###" /></td>
					<th><c:if test="${jidaeData.TMP7 ne null}">보&nbsp;증&nbsp;금&nbsp;&nbsp;대&nbsp;체</c:if></th>
					<td><fmt:formatNumber value="${jidaeData.TMP7}" pattern="#,###" /></td> 
				</tr>
			</table>
			<c:if test="${jidaeData.TMP7 ne null}">
				<div style="padding-top: 3px">※적립보증금 지대 대체는 완납수당을 포함하여 공제하는 것을 원칙으로 합니다. 단 미수금 대체는 제외될수 있습니다.</div>
			</c:if>
		</div>
		<!-- //지대내역 -->
		<!-- 당월지대납부내역 -->
		<div style="padding-top: 10px;">
			<div style="font-weight: bold; font-size: 1.4em; padding-bottom: 3px">2. 당월 지대 납부내역</div>
			<table class="tb_edit_mobile" style="width: 100%">
				<colgroup>
					<col width="25%">
					<col width="25%">
					<col width="25%">
					<col width="25%">
				</colgroup>
				<tr>
					<th>항&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</th>
					<th>금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</th>
					<th>항&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</th>
					<th>금&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;액</th>
				</tr>
				<tr>
					<th>당월실납입액</th>
					<td style="font-weight: bold;"><fmt:formatNumber value="${jidaeData.J_REALAMT}" pattern="#,###" /></td>
					<th>납 기 후 지 대</th>
					<td><fmt:formatNumber value="${jidaeData.J_OVERDATE}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th>완 납 장 려 금</th>
					<td><fmt:formatNumber value="${jidaeData.J_OKGRANT1}" pattern="#,###" /></td>
					<th>완 납 장 려 금</th>
					<td><fmt:formatNumber value="${jidaeData.J_OKGRANT2}" pattern="#,###" /></td>
				</tr>
				<tr>
					<th>납 기 내 지 대</th>
					<td style="font-weight: bold; color: blue"><fmt:formatNumber value="${jidaeData.J_DUEDATE}" pattern="#,###" /></td>
					<th>당월지대납입액</th>
					<td  style="font-weight: bold; color: #bc0546"><fmt:formatNumber value="${jidaeData.J_PAYAMT}" pattern="#,###" /></td>
				</tr>
			</table>
			<c:if test="${fn:substring(jidaeData.BOSEQCODE,0,2) ne '52'}">
				<div style="padding-top: 3px">※완납장려금은 소정 기일내에 송금하셔야 혜택을 받으실 수 있습니다.</div>
			</c:if>
		</div>
		<!-- //당월지대납부내역 -->
		<!-- 보증금 현황 -->
		<div style="padding-top: 10px;">
			<div style="font-weight: bold; font-size: 1.4em; padding-bottom: 3px">3. 보증금 현황</div>
			<table class="tb_edit_mobile" style="width: 100%">
				<colgroup>
					<col width="25%">
					<col width="25%">
					<col width="25%">
					<col width="25%">
				</colgroup>
				<tr>
					<th>전월이월액</th>
					<th>당월발생액</th>
					<th>당월감소액</th>
					<th>보증금잔액</th>
				</tr>
				<tr>
					<td style="height: 15px"><fmt:formatNumber value="${jidaeData.D_MISU}" pattern="#,###" /></td>
					<td><fmt:formatNumber value="${jidaeData.D_HAPPEN}" pattern="#,###" /></td>
					<td><fmt:formatNumber value="${jidaeData.D_MINUS}" pattern="#,###" /></td>
					<td><fmt:formatNumber value="${jidaeData.D_BALANCE}" pattern="#,###" /></td>
				</tr>
			</table>
		</div>
		<!-- //보증금 현황 -->
		<!-- 송금안내 -->
		<div style="padding-top: 10px;">
			<div style="font-weight: bold; font-size: 1.4em; padding-bottom: 3px">4. 송금안내(예금주 : 매일경제신문사 장대환)</div>
			<table class="tb_edit_mobile" style="width: 100%">
				<colgroup>
					<col width="18%">
					<col width="32%">
					<col width="18%">
					<col width="32%">
				</colgroup>
				<tr>
					<th>은 행 명</th>
					<th>계 좌 번 호</th>
					<th>은 행 명</th>
					<th>계 좌 번 호</th>
				</tr>
				<tr>
					<th>농&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;협</th>
					<td>${jidaeData.JIDAE_BANK1}</td>
					<th>우리은행</th>
					<td>${jidaeData.JIDAE_BANK2}</td>
				</tr>
				<tr>
					<th><c:if test="${jidaeData.JIDAE_BANK3 != null}">국민은행</c:if>&nbsp;</th>
					<td>${jidaeData.JIDAE_BANK3}</td>
					<th><c:if test="${jidaeData.JIDAE_BANK4 != null}">우 체 국</c:if>&nbsp;</th>
					<td>${jidaeData.JIDAE_BANK4}</td>
				</tr>
			</table>
		</div>
		<!-- //송금안내 -->
		<div style="width: 100%; text-align: center; padding-top: 5px; font-size: 1.1em">
			<div>상기 금액을 조정 통지하오니 상위할 경우 이의 신청하여 주시기 바랍니다.</div>
			<div style="padding-top: 5px">서울특별시 중구 퇴계로</div>
			<div style="padding-top: 5px; font-weight: bold;">(주)매일경제신문사</div>
			<div style="padding-top: 5px;">독자마케팅국장 정현권 <img alt="직인" src="/images/stemp.png" style="width: 20px; vertical-align: middle;"></div>
		</div>
	</div>
</div>
</body>
</html>