<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
	function noticeView(seq){
		var frm = document.getElementById("searchForm");
	
		frm.seq.value = seq;
		frm.action = "/community/bbs/noticeView.do";
		frm.submit();
	}
	
	function downfile(file_path,file_name){
		TaskFrame.location.href = "/common/download_file.jsp?file_path=" + file_path + "&file_name=" + file_name ;
	}

	function searchMinwon(aplcdt){
		/*
		if( $("tempSdate").value == '' ){
			alert('날짜를 선택해 주세요.');
			return;
		}
		if( $("tempEdate").value == '' ){
			alert('날짜를 선택해 주세요.');
			return;
		}
		
		var tempSdate =  $("tempSdate").value.split("-");
		var tempEdate =  $("tempEdate").value.split("-");
		
		$("sdate").value = tempSdate[0] + tempSdate[1] + tempSdate[2];
		$("edate").value = tempEdate[0] + tempEdate[1] + tempEdate[2];
		*/

		var frm = document.getElementById("searchForm");
		document.getElementById("sdate").value = aplcdt;
		document.getElementById("edate").value = aplcdt;
		

		actUrl = "/reader/readerManage/retrieveApplyReader.do";
		window.open('','pop_minwon','width=970, height=870, toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1');


		frm.target = "pop_minwon";
		frm.action = actUrl;
		frm.submit();
	}
		
	//숫자 자리수 표시
	function fn_numberPotion(val) {
		if(val > 0) {
			val = new String(val);
	
			var A1 = val.length - 3;
			var n   = 0;
			var d   = -3;
			n = (val.length % 3 == 0)? (val.length / 3) - 1 : (val.length / 3);
			 
			for(var i = 1; i <= n; i++)
			{
			var An = A1 + ((i - 1) * d);
			 
			val = new String(val);
			val = val.substring(0, An) + ',' + val.substring(An, val.length);
			}
		} else if(val == 0){
			val = val;
		} else {
			val = "";
		}
		return val;
	}
	
jQuery.noConflict();
jQuery(document).ready(function($){
	
	//지로입금 건수/합계 조회
	setTimeout(function() {
		$.ajax({
			type 		: "POST",
			url 		: "/admin/ajaxGiroEdiInfo.do",
			dataType 	: "json",
			data		: "JIKUK="+$("#JIKUK").val(),
			success:function(val){			
				$("#divGiroInfo_load").css("display", "none");
				$("#divGiroInfo").css("display", "block");
				
				//자릿수 표시
				var chgCNT = fn_numberPotion(val.giroEdiInfo[0].CNT);
				var chgE_MONEY = fn_numberPotion(val.giroEdiInfo[0].E_MONEY);
				
				$("#giroInfoCnt").html(chgCNT); 
				$("#giroInfoTot").html(chgE_MONEY);
			},
			error    : function(r) { alert("지로입금 건수/합계 조회 실패"); }
		}); //ajax end
	}, 500);
	
	//자동이체 일반 건수/합계 조회
	setTimeout(function() {
		$.ajax({
			type 		: "POST",
			url 		: "/admin/ajaxResultBill.do",
			dataType 	: "json",
			data		: "JIKUK="+$("#JIKUK").val(),
			success:function(val){			
				$("#divResultBill_load").css("display", "none");
				$("#divResultBill").css("display", "block");
				
				//자릿수 표시
				var chgCNT = fn_numberPotion(val.resultBill[0].CNT);
				var chgCMSMONEY = fn_numberPotion(val.resultBill[0].CMSMONEY);
				
				$("#resultBillCnt").html(chgCNT); 
				$("#resultBillTot").html(chgCMSMONEY);
			},
			error    : function(r) { alert("자동이체 일반 건수/합계 조회 실패"); }
		}); //ajax end
	}, 1000);

	//자동이체 학생 건수/합계 조회
	setTimeout(function() {
		$.ajax({
			type 		: "POST",
			url 		: "/admin/ajaxResultBillStu.do",
			dataType 	: "json",
			data		:  "JIKUK="+$("#JIKUK").val(),
			success:function(val){
				$("#divResultBillStu_load").css("display", "none");
				$("#divResultBillStu").css("display", "block");
				
				//자릿수 표시
				var chgCNT = fn_numberPotion(val.resultBillStu[0].CNT);
				var chgCMSMONEY = fn_numberPotion(val.resultBillStu[0].CMSMONEY);
				
				$("#resultBillStuCnt").html(chgCNT); 
				$("#resultBillStuTot").html(chgCMSMONEY);
			},
			error    : function(r) { alert("자동이체 학생 건수/합계 조회 실패"); }
		}); //ajax end
	}, 1500);
	
	closePopup = function(id){
		jQuery("#" + id).hide();
	}
});
</script>
<form name="searchForm"  id="searchForm"  action="" method="post">
	<input type="hidden" id="pageNo" name="pageNo" value="1" />										
	<input type="hidden" id="seq" name="seq" value="" />
	<input type="hidden" id="type" name="type" value="" />
	<input type="hidden" id="sdate" name="sdate" value="" />
	<input type="hidden" id="edate" name="edate" value="" />
	<input type="hidden" id="isCheck" name="isCheck" value="02" />
	<input type="hidden" id="JIKUK" name="JIKUK" value="${JIKUK}" />
</form>
<div style="width: 1040px; padding-bottom: 20px">
	<div style="width: 1030px; padding: 5px 0 0 20px;">
		<!-- 공지사항-->
		<div style="width: 810px; overflow: hidden;">
			<!-- title -->
			<div style="float: left; width: 740px; text-align: left; padding: 0 0 5px 0"><!-- <img src="/images/main_title_1.gif" style="vertical-align:middle; border:0" alt="" />  --><span class="mainTitle">공지사항</span></div>
			<div style="float: left; width: 70px; text-align: right; margin-top: 3px">
				<a href="/community/bbs/noticeList.do" onfocus="this.blur();">
					<img src="/images/main_title_more.gif" style="vertical-align:middle; border:0" alt="전체리스트" />&nbsp;
				</a>
			</div>
			<!-- //title -->
			<table style="width: 800px; clear: both; " class="tb_none">
				<tr>
					<th><img src="/images/main_title_box1.gif" style="vertical-align:middle; border:0" alt="" /></th>
					<td style="width: 70px ;text-align: center;"><img src="/images/main_title_c1.gif" style="vertical-align:middle; border:0" alt="" /></td>
					<td style="width: 1px"><img src="/images/main_title_box_space.gif" style="vertical-align:middle; border:0" alt="" /></td>
					<td style="width: 466px ;text-align: center;"><img src="/images/main_title_c2.gif" style="vertical-align:middle; border:0" alt="" /></td>
					<td style="width: 1px"><img src="/images/main_title_box_space.gif" style="vertical-align:middle; border:0" alt="" /></td>
					<td style="width: 100px ;text-align: center;"><img src="/images/main_title_c3.gif" style="vertical-align:middle; border:0" alt="" /></td>
					<td style="width: 1px"><img src="/images/main_title_box_space.gif" style="vertical-align:middle; border:0" alt="" /></td>
					<td style="width: 100px ;text-align: center;"><img src="/images/main_title_c4.gif" style="vertical-align:middle; border:0" alt="" /></td>
					<td style="width: 1px"><img src="/images/main_title_box_space.gif" style="vertical-align:middle; border:0" alt="" /></td>
					<td style="width: 60px ;text-align: center;"><img src="/images/main_title_c5.gif" style="vertical-align:middle; border:0" alt="" /></td>
					<th><img src="/images/main_title_box3.gif" style="vertical-align:middle; border:0" alt="" /></th>
				</tr>
			</table>
			<table class="tb_m_list" style="width: 800px;"> 
				<colgroup>
					<col width="75px">
					<col width="455px">
					<col width="105px">
					<col width="100px">
					<col width="65px">
				</colgroup>
				<c:choose>
				<c:when test="${empty noticeList}">
					<tfoot>
						<tr><td colspan="5" style="text-align: center;">등록된 정보가 없습니다.</td></tr>
					</tfoot>
				</c:when>
				<c:otherwise>
					<c:forEach var="list" items="${noticeList}" varStatus="status">
						<tr>
							<td class="b03"><c:if test="${jikukType eq '101' or jikukType eq '102'}"><c:if test="${list.IS_READ == 'N'}"><img src="/images/ico/ico_new.png"  style="vertical-align: middle;"/></c:if></c:if></td>
							<td style="text-align: left;<c:if test="${jikukType eq '101' or jikukType eq '102'}"><c:if test="${list.IS_READ == 'N'}">font-weight:bold;</c:if></c:if>"><a href="/community/bbs/noticeView.do?seq=${list.SEQ}"><c:out value="${list.TITL}" /></a></td>
							<td><c:out value="${list.INPS}" /></td>
							<td class="b01" ><c:out value="${list.INDT}" /></td>
							<td>
								<c:choose>
								<c:when test="${empty list.FILE_PATH or empty list.REAL_FNM}">
									&nbsp;
								</c:when>
								<c:otherwise>
									<a href="javascript:downfile('${list.FILE_PATH}/','${list.REAL_FNM}');">
										<img src="/images/ico_save_blue.png" style="vertical-align:middle; border:0" alt="" />
									</a>	
								</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</c:otherwise>
				</c:choose>
			</table>					
		</div>
		<!-- //공지사항-->
		<!-- 신규구독신청자-->
		<div style="width: 810px; overflow: hidden; margin-top:30px;">
			<!-- title --> 
			<div style="width: 810px; text-align: left; padding: 0 0 5px 0"><!-- <img src="/images/main_title_2.gif" style="vertical-align:middle; border:0" alt="" /> --><span class="mainTitle">신규 구독 신청자</span></div>
			<!-- //title -->
			<table style="width: 800px; clear: both; " class="tb_none">
				<tr>
					<th><img src="/images/main_title_box1.gif" style="vertical-align:middle; border:0" alt="" /></th>
					<td style="width: 197px ;text-align: center;"><img src="/images/main_title_c6.gif" style="vertical-align:middle; border:0" alt="" /></td>
					<td style="width: 1px"><img src="/images/main_title_box_space.gif" style="vertical-align:middle; border:0" alt="" /></td>
					<td style="width: 200px ;text-align: center;"><img src="/images/main_title_c7.gif" style="vertical-align:middle; border:0" alt="" /></td>
					<td style="width: 1px"><img src="/images/main_title_box_space.gif" style="vertical-align:middle; border:0" alt="" /></td>
					<td style="width: 200px ;text-align: center;"><img src="/images/main_title_c8.gif" style="vertical-align:middle; border:0" alt="" /></td>
					<td style="width: 1px"><img src="/images/main_title_box_space.gif" style="vertical-align:middle; border:0" alt="" /></td>
					<td style="width: 200px ;text-align: center;"><img src="/images/main_title_c10.gif" style="vertical-align:middle; border:0" alt="" /></td>
					<th><img src="/images/main_title_box3.gif" style="vertical-align:middle; border:0" alt="" /></th>
				</tr>
			</table>			
			<div style="width: 800px;height:150px;overflow-y:scroll; margin: 0 auto;">
			<c:choose>
				<c:when test="${empty applyReaderList}">
					<table class="tb_m_list" style="width: 783px;">
						<tr><td colspan="4"  style="text-align: center; padding: 84px 0;">신규 구독 신청자가 없습니다.</td></tr>
					</table>
				</c:when>
				<c:otherwise>
					<table class="tb_m_list" style="width: 783px">
						<colgroup>
							<col width="205px" >
							<col width="200px" >
							<col width="193px" > 
							<col width="185px" >
						</colgroup>						
							<c:forEach var="list" items="${applyReaderList}" varStatus="status">
									<tr onclick="javascript:searchMinwon('${list.APLCDT}')" style="cursor:pointer;">
										<td>
											<c:if test="${not empty list.APLCDT and fn:length(list.APLCDT) == 8}">
												<c:out value="${fn:substring(list.APLCDT,0,4)}" />-<c:out value="${fn:substring(list.APLCDT,4,6)}" />-<c:out value="${fn:substring(list.APLCDT,6,8)}" />
											</c:if>
										</td>
										<td><c:out value="${list.PATHNAME}" /></td>
										<td><c:out value="${list.SGTYPENAME}" /></td>
										<td><c:out value="${list.READNM}" /></td>
									</tr>
							</c:forEach>
					</table>
				</c:otherwise>
			</c:choose>
			</div>
		</div>
		<!-- //신규구독신청자-->
		
		<div>
			<!-- 자동이체신청자-->
			<div style="float: left; width: 810px; padding-top: 15px">
				<!-- title -->
				<div style="width: 810px; text-align: left; padding: 0 0 5px 0"><!-- <img src="/images/main_title_3.gif" style="vertical-align:middle; border:0" alt="" /> --><span class="mainTitle">자동이체 신청자</span></div>
				<!-- //title -->
				<table style="width: 800px; clear: both; " class="tb_none">
					<tr>
						<th><img src="/images/main_title_box1.gif" style="vertical-align:middle; border:0" alt="" /></th>
						<td style="width: 154px ;text-align: center;"><img src="/images/main_title_c12.gif" style="vertical-align:middle; border:0" alt="" /></td>
						<td style="width: 1px"><img src="/images/main_title_box_space.gif" style="vertical-align:middle; border:0" alt="" /></td>
						<td style="width: 154px ;text-align: center;"><img src="/images/main_title_c13.gif" style="vertical-align:middle; border:0" alt="" /></td> 
						<td style="width: 1px"><img src="/images/main_title_box_space.gif" style="vertical-align:middle; border:0" alt="" /></td>
						<td style="width: 154px ;text-align: center;"><img src="/images/main_title_c14.gif" style="vertical-align:middle; border:0" alt="" /></td>
						<td style="width: 1px"><img src="/images/main_title_box_space.gif" style="vertical-align:middle; border:0" alt="" /></td>
						<td style="width: 154px ;text-align: center;"><img src="/images/main_title_c16.gif" style="vertical-align:middle; border:0" alt="" /></td>
						<td style="width: 1px"><img src="/images/main_title_box_space.gif" style="vertical-align:middle; border:0" alt="" /></td>
						<td style="width: 178px ;text-align: center;"><img src="/images/main_title_c15.gif" style="vertical-align:middle; border:0" alt="" /></td>
						<th><img src="/images/main_title_box3.gif" style="vertical-align:middle; border:0" alt="" /></th>
					</tr>
				</table>						
				<div style="width:800px;height:150px;overflow-y:scroll; margin: 0 auto;">
				<c:choose>
					<c:when test="${empty resultBillList}">
						<table class="tb_m_list" style="width: 783px; ">			
							<tr><td colspan="6"  style="text-align: center;  padding: 84px 0;">신규 자동이체 신청자가 없습니다.</td></tr>
						</table>
					</c:when>
					<c:otherwise>
							<table class="tb_m_list" style="width: 783px">
								<colgroup>
									<col width="153px" >
									<col width="155px" >
									<col width="155px" > 
									<col width="155px" >
									<col width="165px" >
								</colgroup>		
								<c:forEach var="list" items="${resultBillList}" varStatus="status">						
									<tr>
										<td><c:out value="${list.INDATE }" /></td>
										<td><c:out value="${list.USERNAME}" /></td>
										<td><c:out value="${list.BANK_NAME}" /></td>
										<td><c:out value="${list.BANK_NUM}" /></td>
										<td><c:out value="${list.BANK}" /></td>
									</tr>
								</c:forEach>
							</table>
					</c:otherwise>
				</c:choose>
				</div>
			</div>
			<!-- //자동이체신청자-->
			<div style="float: left; width: 180px; padding: 0 0 20px 20px; border: 0px solid green">
				<div style="height: 15px">&nbsp;</div>
				<c:if test="${JIKUK eq null}">  
					<div style="width: 180px; text-align: left; padding: 0 0 5px 0"><span class="mainTitle">예약해지리스트</span></div>
					<div style="border: 1px solid #e2e2e2; height: 150px; padding: 15px; overflow-y: scroll;">
						<c:forEach items="${stopReserveList }" var="list" varStatus="i">
							<div style="padding: 5px 0; border-bottom:  1px solid #e2e2e2">
								<img src="/images/ic_org_icon.gif" title="" style="vertical-align: middle;"/> <b>${list.READNM }</b> <br/>&nbsp;(${list.INDT } / ${list.INPSNM })
							</div>
						</c:forEach>
					</div>
				</c:if> 
			</div>
		</div>
	</div>
</div>
<iframe name="TaskFrame" id="TaskFrame" style="width: 0; height: 0" src="about:blank"  frameborder="0"></iframe>
