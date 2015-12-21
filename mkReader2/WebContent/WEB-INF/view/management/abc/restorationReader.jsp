<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ page import="com.mkreader.security.ISiteConstant" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript">
	var yymmList = new Array();
	<c:forEach var="yymm" items="${yymmList}">
		yymmList[yymmList.length] = "${yymm}";
	</c:forEach>
	jQuery(function($){
		$("#boseq,#readnm").keypress(function(e){
			if(e.keyCode == "13"){
				$("#search_btn").trigger( "click" );
			}
		});
		$("#search_btn").click(function(){
			$("#listForm").attr("action","restorationReader.do").submit();
		});
		
		$("#deleteReaderBtn").click(function(){
			if($("#READNO").val() == ""){
				alert("독자를 선택해주세요.");
				return;
			}
			if(confirm("정말로 삭제하시겠습니까?")){
				var url = "deleteReaderInfo.do";
				var obj = {"readno":$("#READNO").val(),"boseq":$("#BOSEQ").val(),"seq":$("#SEQ").val()};
				$.getJSON(url,obj,function(data){
					if(data.result){
						alert("독자삭제가 완료되었습니다.");
						$("#tr" + $("#READNO").val() + $("#SEQ").val() + $("#BOSEQ") + $("#NEWSCD")).remove();
				         $("form").each(function(){
				               if(this.id == "editForm") this.reset();
				         });
					}else{
						alert("독자삭제가 실패하엿습니다.");
					}
				});
			}
		});
		
		$("#updateBtn").click(function(){
			if($("#READNO").val() == ""){
				alert("독자를 선택해주세요.");
				return;
			}
			var sugmArray = new Array();
			var sugmObj = null;
			$("tr[id^=201]").each(function(){
				sugmObj = {
							"cldt":$(this).find("[name=CLDT]").val(),
							"billamt":$(this).find("[name=BILLAMT]").val(),
							"amt":$(this).find("[name=AMT]").val(),
							"billqty":$(this).find("[name=BILLQTY]").val(),
							"sgbbcd":$(this).find("[name=SGBBCD]").val(),
							"yymm":$(this).attr("id"),
						}
				sugmArray[sugmArray.length] = sugmObj;
			});
			var obj = {
					"readno":$("#READNO").val(),
					"readnm":$("#READNM").val(),
					"seq":$("#SEQ").val(),
					"hjdt":$("#HJDT").val(),
					"sgbgmm":$("#SGBGMM").val(),
					"qty":$("#QTY").val(),
					"uprice":$("#UPRICE").val(),
					"stdt":$("#STDT").val(),
					"dlvzip":$("#DLVZIP").val(),
					"dlvadrs1":$("#DLVADRS1").val(),
					"dlvadrs2":$("#DLVADRS2").val(),
					"newaddr":$("#NEWADDR").val(),
					"newscd":$("#NEWSCD").val(),
					"boseq":$("#BOSEQ").val(),
					"sgtype":$("#SGTYPE").val(),
					"gno":$("#GNO").val(),
					"bno":$("#BNO").val(),
					"sno":$("#SNO").val(),
					"hometel1":$("#HOMETEL1").val(),
					"hometel2":$("#HOMETEL2").val(),
					"hometel3":$("#HOMETEL3").val(),
					"mobile1":$("#MOBILE1").val(),
					"mobile2":$("#MOBILE2").val(),
					"mobile3":$("#MOBILE3").val(),
					"readtypecd":$("#READTYPECD").val(),
					"stsayou":$("#STSAYOU").val(),
					"sugmList": JSON.stringify(sugmArray)
			};
			var url = "updateReaderInfo.do";
			$.getJSON(url,obj,function(data){
				if(data.result){
					alert("독자수정이 완료되었습니다.");
				}else{
					alert("독자수정이 실패하엿습니다.");
				}
			});
		});
		
		var currentTR = null;

		loadReader = function(readno,seq,boseq,newscd,obj){
			if(currentTR != null){
				$("#"+currentTR).css("background-color","");
			}
			currentTR = obj.id;
			$("#"+currentTR).css("background-color","darkgray");
			var url = "getReaderInfo.do";
			var param = {"readno":readno,"seq":seq,"boseq":boseq,"newscd":newscd};
			$.getJSON(url,param,function(data){
				$("#READNM").val(data.READNM);
				$("#READNO").val(data.READNO);
				$("#SEQ").val(data.SEQ);
				$("#HJDT").val(data.HJDT);
				$("#SGBGMM").val(data.SGBGMM);
				$("#QTY").val(data.QTY);
				$("#UPRICE").val(data.UPRICE);
				$("#STDT").val(data.STDT);
				$("#DLVZIP").val(data.DLVZIP);
				$("#DLVADRS1").val(data.DLVADRS1);
				$("#DLVADRS2").val(data.DLVADRS2);
				$("#NEWADDR").val(data.NEWADDR);
				$("#BOSEQ").val(data.BOSEQ);
				$("#NEWSCD").val(data.NEWSCD);
				$("#SGTYPE").val(data.SGTYPE).attr("selected","selected");
				$("#READTYPECD").val(data.READTYPECD).attr("selected","selected");
				$("#GNO").val(data.GNO);
				$("#BNO").val(data.BNO);
				$("#SNO").val(data.SNO);
				$("#HOMETEL1").val(data.HOMETEL1);
				$("#HOMETEL2").val(data.HOMETEL2);
				$("#HOMETEL3").val(data.HOMETEL3);
				$("#MOBILE1").val(data.MOBILE1);
				$("#MOBILE2").val(data.MOBILE2);
				$("#MOBILE3").val(data.MOBILE3);
				$("#STSAYOU").val(data.STSAYOU);
				for(var i=0;i<yymmList.length;i++){
					var cldt = "",billamt = "",amt = "",billqty = "",sgbbcd = "",yymm  ="";
					$.each(data.SUGMLIST,function(key,data){
						if(data.YYMM == yymmList[i]){
							cldt = data.CLDT,billamt = data.BILLAMT,amt = data.AMT,billqty = data.BILLQTY,sgbbcd = data.SGBBCD,yymm = data.YYMM;
						}
					})
					$("#" + yymmList[i] + " [name=YYMM]").val(yymm);
					$("#" + yymmList[i] + " [name=CLDT]").val(cldt);
					$("#" + yymmList[i] + " [name=BILLAMT]").val(billamt);
					$("#" + yymmList[i] + " [name=AMT]").val(amt);
					$("#" + yymmList[i] + " [name=BILLQTY]").val(billqty);
					$("#" + yymmList[i] + " [name=SGBBCD]").val(sgbbcd).attr("selected","selected");
					
//					$("#" + i + "CLDT").val(cldt);
//					$("#" + i + "BILLAMT").val(billamt);
//					$("#" + i + "AMT").val(amt);
//					$("#" + i + "BILLQTY").val(billqty);
//					$("#" + i + "SGBBCD").val(sgbbcd).attr("selected","selected");
				}
			});
		};
	});
</script>
<!-- title -->
<div><span class="subTitle">복구독자 수정</span></div>
<!-- //title -->
<div>
	<div style="width: 1050px; border: 0px solid; overflow: hidden;">
		<form name="listForm" id="listForm" method="post">
		<div style=" width: 500px; float: left;">
			<div style=" width: 500px; text-align: left; padding: 3px 0; font-size: 1.2em; font-weight: bold;">[복구된 독자 리스트]</div>
			<table class="tb_search" style="width: 500px">
				<col width="70px">
				<col width="100px">
				<col width="70px">
				<col width="100px">
				<col width="60px">
				<col width="100px"> 
				<tr>
					<th>지국코드</th>
					<td><input type="text" style="width: 80px" name="boseq" id="boseq" value="${boseq}"/></td>
					<th>독자명</th>
					<td><input type="text" style="width: 80px" name="readnm" id="readnm" value="${readnm}"/></td>
					<th>수금방법</th> 
					<td>
						<select name="sgtype" id="sgtype">
								<option value=""<c:if test="${sgtype == ''}"> selected="selected"</c:if>>전체</option>
								<option value="011"<c:if test="${sgtype == '011'}"> selected="selected"</c:if>>지로</option>
								<option value="012"<c:if test="${sgtype == '012'}"> selected="selected"</c:if>>방문</option>
								<option value="013"<c:if test="${sgtype == '013'}"> selected="selected"</c:if>>통장입금</option>
								<option value="021"<c:if test="${sgtype == '021'}"> selected="selected"</c:if>>자동이체</option>
								<option value="022"<c:if test="${sgtype == '022'}"> selected="selected"</c:if>>카드</option>
								<option value="023"<c:if test="${sgtype == '023'}"> selected="selected"</c:if>>본사입금</option>
								<option value="024"<c:if test="${sgtype == '024'}"> selected="selected"</c:if>>쿠폰</option>
								<option value="031"<c:if test="${sgtype == '031'}"> selected="selected"</c:if>>결손</option>
								<option value="032"<c:if test="${sgtype == '032'}"> selected="selected"</c:if>>재무</option>
								<option value="033"<c:if test="${sgtype == '033'}"> selected="selected"</c:if>>휴독</option>
								<option value="044"<c:if test="${sgtype == '044'}"> selected="selected"</c:if>>미수</option>
								<option value="099"<c:if test="${sgtype == '099'}"> selected="selected"</c:if>>월삭제</option>
								<option value="088"<c:if test="${sgtype == '088'}"> selected="selected"</c:if>>기타</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>독자유형</th>
					<td>
						<select name="readertype" id="readertype">
							<option value="0"<c:if test="${readertype == '0'}"> selected="selected"</c:if>>전체독자</option>
							<option value="1"<c:if test="${readertype == '1'}"> selected="selected"</c:if>>일반독자</option>
							<option value="2"<c:if test="${readertype == '2'}"> selected="selected"</c:if>>복구독자</option>
						</select>
					</td>
					<th>부수</th>
					<td colspan="2" style="border-right:0px;"><input type="text" name="minqty" id="minqty" size="5" value="${minqty}"> ~ <input type="text" name="maxqty" id="maxqty" size="5" value="${maxqty}"></td>
					<td style="border-left:0px;">
						<div style="float: right;">
							<span class="btnCss2"><a class="lk2" href="#" id="search_btn">조회</a></span>&nbsp;
						</div>
					</td>
				</tr>
			</table>
			<table class="tb_list_a_5" style="width: 500px">
				<colgroup>
					<col width="70px">
					<col width="200px"/>
					<col width="70px"/>
					<col width="70px"/>
					<col width="90px"/>
				</colgroup>
				<tr>
					<th>수금방법</th>
					<th>독자명</th>
					<th>독자번호</th>
					<th>부수</th>
					<th>수금된총금액</th>
				</tr>
			</table>
			<div style="width: 100%;height: 480px;overflow-y: scroll;overflow-x: none;">
			<table class="tb_list_a" style="width: 500px">
				<colgroup>
					<col width="70px">
					<col width="200px"/>
					<col width="70px"/>
					<col width="70px"/>
					<col width="90px"/>
				</colgroup>
				<c:forEach items="${readerList}" var="reader" step="1">
				<tr class="mover" onclick="loadReader('${reader.READNO}','${reader.SEQ}','${reader.BOSEQ}','${reader.NEWSCD}',this);" id="tr${reader.READNO}${reader.SEQ}${reader.BOSEQ}${reader.NEWSCD}">
					<td>
						<c:if test="${reader.SGTYPE == '011'}">지로</c:if>
						<c:if test="${reader.SGTYPE == '012'}">방문</c:if>
						<c:if test="${reader.SGTYPE == '013'}">통장입금</c:if>
						<c:if test="${reader.SGTYPE == '021'}">자동이체</c:if>
						<c:if test="${reader.SGTYPE == '022'}">카드</c:if>
						<c:if test="${reader.SGTYPE == '023'}">본사입금</c:if>
						<c:if test="${reader.SGTYPE == '024'}">쿠폰</c:if>
						<c:if test="${reader.SGTYPE == '031'}">결손</c:if>
						<c:if test="${reader.SGTYPE == '032'}">재무</c:if>
						<c:if test="${reader.SGTYPE == '033'}">휴독</c:if>
						<c:if test="${reader.SGTYPE == '044'}">미수</c:if>
						<c:if test="${reader.SGTYPE == '099'}">월삭제</c:if>
						<c:if test="${reader.SGTYPE == '088'}">기타</c:if>
					</td>
					<td>${reader.READNM}</td>
					<td>${reader.READNO}</td>
					<td>${reader.QTY}</td>
					<td style="text-align: left;">${reader.TOTALSUGM}</td>
				</tr>
				</c:forEach>
			</table>
			</div>
			<!--div style="padding-top: 10px; text-align: center;">
				<span style="font-weight: bold; vertical-align: middle;">수금총금액&nbsp;:&nbsp;2,000,000원</span>&nbsp; &nbsp; &nbsp;
				<span style="font-weight: bold; vertical-align: middle;">수금총부수&nbsp;:&nbsp;100부</span>
			</div-->
		</div>
		</form>
		<form name="editForm" id="editForm">
		<input type="hidden" name="BOSEQ" id="BOSEQ"/>
		<input type="hidden" name="NEWSCD" id="NEWSCD"/>
		<div style=" width: 540px; float: left;padding-left:10px;">
			<div style=" width: 540px; text-align: left; padding: 3px 0; font-size: 1.2em; font-weight: bold;">[독자정보]</div>
			<table class="tb_list_a" style="width: 540px">
				<tr>
					<th style="width:60px;">독자명</th>
					<td colspan="3"><input type="text" style="width: 190px" name="READNM" id="READNM"/></td>
					<th>독자번호</th>
					<td>
						<input type="text" style="width: 80px" name="READNO" id="READNO" readOnly="readOnly"/>
						<input type="hidden" name="SEQ" id="SEQ"/>
					</td>
					<th>부수</th>
					<td><input type="text" style="width: 60px" name="QTY" id="QTY"/></td>
				</tr>
				<tr>
					<th>전화번호</th>
					<td colspan="3"><input type="text" style="width: 50px" name="HOMETEL1" id="HOMETEL1"/>&nbsp;<input type="text" style="width: 50px" name="HOMETEL2" id="HOMETEL2"/>&nbsp;<input type="text" style="width: 50px" name="HOMETEL3" id="HOMETEL3"/></td>
					<th>휴대폰</th> 
					<td colspan="3"><input type="text" style="width: 50px" name="MOBILE1" id="MOBILE1"/>&nbsp;<input type="text" style="width: 50px" name="MOBILE2" id="MOBILE2"/>&nbsp;<input type="text" style="width: 50px" name="MOBILE3" id="MOBILE3"/></td>
				</tr>
				<tr>
					
					<th>수금방법</th>
					<td>
						<select name="SGTYPE" id="SGTYPE" style="width:50px">
							<option value="011">지로</option>
							<option value="012">방문</option>
							<option value="013">통장입금</option>
							<option value="021">자동이체</option>
							<option value="022">카드</option>
							<option value="023">본사입금</option>
							<option value="024">쿠폰</option>
							<option value="031">결손</option>
							<option value="032">재무</option>
							<option value="033">휴독</option>
							<option value="044">미수</option>
							<option value="088">기타</option>
							<option value="099">월삭제</option>
						</select>
					</td>
					<th>유가년월</th> 
					<td><input type="text" style="width: 60px" name="SGBGMM" id="SGBGMM"/></td>
					<th>구역배달</th>
					<td><input type="text" style="width: 30px" name="GNO" id="GNO"/><input type="text" style="width: 25px" name="BNO" id="BNO"/><input type="text" style="width: 20px" name="SNO" id="SNO"/></td>
					<th>단가</th>
					<td><input type="text" style="width: 50px" name="UPRICE" id="UPRICE"/></td>
				</tr>
				<tr>
					
					<th>독자유형</th> 
					<td>
						<select name="READTYPECD" id="READTYPECD" style="width:50px;">
										<option value="011">일반</option>
										<option value="012">학생(지국)</option>
										<option value="013">학생(본사)</option>
										<option value="014">병독</option>
										<option value="015">교육</option>
										<option value="016">본사사원</option>
										<option value="017">소외계층</option>
										<option value="018">NI</option>
										<option value="021">기증</option>
										<option value="022">홍보</option>
									</select>
						
					</td>
					<th>확장일</th>
					<td><input type="text" style="width: 60px" name="HJDT" id="HJDT"/></td>
					<th>해지일자</th> 
					<td><input type="text" style="width: 60px" name="STDT" id="STDT"/></td>
					<th>해지사유</th>
					<td><input type="text" style="width: 50px" name="STSAYOU" id="STSAYOU"/></td>
				</tr>
				<tr>
					<th>지번주소</th>
					<td colspan="7"><input type="text" name="DLVZIP" id="DLVZIP" style="width:55px;">&nbsp;&nbsp;<input type="text" style="width: 200px" name="DLVADRS1" id="DLVADRS1"/><input type="text" style="width: 200px" name="DLVADRS2" id="DLVADRS2"/></td>
				</tr>
				<tr>
					<th>새주소</th>
					<td colspan="7"><input type="text" style="width: 460px" name="NEWADDR" id="NEWADDR"/></td>
				</tr>
			</table>
			<br />
			<table class="tb_list_a" style="width: 550px">
				<col width="50px">
				<col width="100px">
				<col width="100px">
				<col width="100px">
				<col width="100px">
				<col width="100px"> 
				<tr>
					<th>년월</th>
					<th>수금일자</th>
					<th>금액</th>
					<th>수금액</th>
					<th>부수</th>
					<th>방법</th>
				</tr>
				<tr id="201312">
					<td>201312<input type="hidden" value="" name="YYMM"></td>
					<td><input type="text" style="width: 80px" value="" name="CLDT"/></td>
					<td><input type="text" style="width: 80px" value="" name="BILLAMT"/></td>
					<td><input type="text" style="width: 80px" value="" name="AMT"/></td>
					<td><input type="text" style="width: 40px" value="" name="BILLQTY"/></td>
					<td>
						<select name="SGBBCD">
							<option value="">전체</option>
							<option value="011">지로</option>
							<option value="012">방문</option>
							<option value="013">통장입금</option>
							<option value="021">자동이체</option>
							<option value="022">카드</option>
							<option value="023">본사입금</option>
							<option value="024">쿠폰</option>
							<option value="031">결손</option>
							<option value="032">재무</option>
							<option value="033">휴독</option>
							<option value="044">미수</option>
							<option value="099">월삭제</option>
							<option value="088">기타</option>
						</select>
					</td>
				</tr>
				<c:forEach var="yymm" items="${yymmList}" varStatus="stat">
				<tr id="${yymm}">
					<td>${yymm}<input type="hidden" value="" name="YYMM"></td>
					<td><input type="text" style="width: 80px" value="" name="CLDT"/></td>
					<td><input type="text" style="width: 80px" value="" name="BILLAMT"/></td>
					<td><input type="text" style="width: 80px" value="" name="AMT"/></td>
					<td><input type="text" style="width: 40px" value="" name="BILLQTY"/></td>
					<td>
						<select name="SGBBCD">
							<option value="">전체</option>
							<option value="011">지로</option>
							<option value="012">방문</option>
							<option value="013">통장입금</option>
							<option value="021">자동이체</option>
							<option value="022">카드</option>
							<option value="023">본사입금</option>
							<option value="024">쿠폰</option>
							<option value="031">결손</option>
							<option value="032">재무</option>
							<option value="033">휴독</option>
							<option value="044">미수</option>
							<option value="099">월삭제</option>
							<option value="088">기타</option>
						</select>
					</td>
				</tr>
				</c:forEach>
			</table>
		</div>
		<div style="float: right;padding-top:10px;">
			<span class="btnCss2"><a class="lk2" href="#" id="updateBtn">수정</a></span>&nbsp;
			<span class="btnCss2"><a class="lk2" style="color:red;" href="#" id="deleteReaderBtn">독자삭제</a></span>&nbsp;
		</div>
		</form>
	</div>
</div>