<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript">
/*----------------------------------------------------------------------
 * Desc   : 독자 조회
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncReaderList() {
	 var readNo = frmInfo.readNo.value;
 	 if(trim(readNo) == "" || readNo == null){
	 	 alert("독자번호를 입력해주세요");
		 frmInfo.readNo.focus();
	     return;
	 }
 	 
 	 if(trim(readNo).length < 9){
		 alert("독자번호는 9자리로 입력해주세요");
		 frmInfo.readNo.focus();
	 return;
	 }
 	 
 	frmInfo.reader.value = "";
	frmInfo.news.value =  "";
	frmInfo.seq.value =  "";
 	  	 
 	frmInfo.action = "/output/billOutput/eachReaderView.do";
 	frmInfo.submit();
}

/*----------------------------------------------------------------------
 * Desc   : 독자목록의 ROW클릭시 독자 상세정보를 표시
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncSelAction(reader, news, seq){
	frmInfo.reader.value = reader;
	frmInfo.news.value = news;
	frmInfo.seq.value = seq;
	
	frmInfo.action = "/output/billOutput/eachReaderView.do";
    frmInfo.submit();
}

/*----------------------------------------------------------------------
 * Desc   : 개별 영수증 발행
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncInsertBill() {
	 var readNo =frmInfo.readNo.value;
	 var sYear =frmInfo.sYear.value;
	 var sMonth =frmInfo.sMonth.value;
	 var eYear =frmInfo.eYear.value;
	 var eMonth =frmInfo.eMonth.value;
	 var qty =frmInfo.qty.value;
	 var amount =frmInfo.amount.value;
	 
 	 if(trim(readNo) == "" || readNo == null){
	 	 alert("영수증을 발행할 독자를 조회해주세요");
		 frmInfo.readNo.focus();
	     return;
	 }
 	 
 	if(trim(sYear) == "" || sYear == null){
	 	 alert("청구 시작년도를 입력해주세요");
		 frmInfo.sYear.focus();
	     return;
	 }
 	
 	if(trim(sMonth) == "" || sMonth == null){
	 	 alert("청구 시작월을 입력해주세요");
		 frmInfo.sMonth.focus();
	     return;
	 }
 	
 	if(trim(eYear) == "" || eYear == null){
	 	 alert("청구 종료년도를 입력해주세요");
		 frmInfo.eYear.focus();
	     return;
	 }
	
	if(trim(eMonth) == "" || eMonth == null){
	 	 alert("청구 종료월을 입력해주세요");
		 frmInfo.eMonth.focus();
	     return;
	 }
	 
	 if(trim(sYear).length < 4){
		 alert("시작년도는 4자리로 입력해주세요");
		 frmInfo.sYear.focus();
	 return;
	 }
	 
	 if(trim(eYear).length < 4){
		 alert("종료년도는 4자리로 입력해주세요");
		 frmInfo.eYear.focus();
	 return;
	 }
	 
	 if(sYear > eYear){
		 alert("종료년도는 시작년도이후로 입력해주세요..");
		 frmInfo.eYear.focus();
	 return;
	 }
	 
	 if(sYear == eYear && sMonth > eMonth){
		 alert("종료월은 시작월과 같거나 시작월 이후로 입력해주세요..");
		 frmInfo.eMonth.focus();
	 return;
	 }
	 
	 if(trim(sMonth).length < 2){
		 alert("시작월은 2자리로 입력해주세요(ex : '1'=> '01', '4' =>'04')");
		 frmInfo.sMonth.focus();
	 return;
	 }
	 
	 if(trim(eMonth).length < 2){
		 alert("종료월은 2자리로 입력해주세요(ex : '1'=> '01', '4' =>'04')");
		 frmInfo.eMonth.focus();
	 return;
	 }
	  
	 if(trim(sMonth) != '01' && trim(sMonth) != '02' && trim(sMonth) != '03' && trim(sMonth) != '04' && trim(sMonth) != '05' && trim(sMonth) != '06' && 
			 trim(sMonth) != '07' && trim(sMonth) != '08' && trim(sMonth) != '09' && trim(sMonth) != '10' && trim(sMonth) != '11' && trim(sMonth) != '12' ){
		 alert("시작월은 '01'~'12'사이의 값으로 입력해주세요");
		 frmInfo.sMonth.focus();
	 return;
	 }
	 
	 if(trim(eMonth) != '01' && trim(eMonth) != '02' && trim(eMonth) != '03' && trim(eMonth) != '04' && trim(eMonth) != '05' && trim(eMonth) != '06' && 
			 trim(eMonth) != '07' && trim(eMonth) != '08' && trim(eMonth) != '09' && trim(eMonth) != '10' && trim(eMonth) != '11' && trim(eMonth) != '12' ){
		 alert("종료월은 '01'~'12'사이의 값으로 입력해주세요");
		 frmInfo.eMonth.focus();
	 return;
	 }
	 
	 if(trim(qty) == "" || qty == null){
	 	 alert("청구 부수를 입력해주세요");
		 frmInfo.qty.focus();
	     return;
	 }
	 
	 if(trim(amount) == "" || amount == null){
	 	 alert("청구 금액을 입력해주세요");
		 frmInfo.amount.focus();
	     return;
	 }

 	con=confirm("영수증을 발행하시겠습니까?");
    if(con==false){
        return;
	}else{
	 	frmInfo.action = "/output/billOutput/insertBill.do";
	 	frmInfo.submit();
	}	

}

/*----------------------------------------------------------------------
 * Desc   : 개별 영수증 삭제
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncDeleteBill(boseq, id) {

		frmInfo.boseq.value = boseq;
		frmInfo.id.value = id;
		
	 	frmInfo.action = "/output/billOutput/deleteBill.do";
	 	frmInfo.submit();	

}

/*----------------------------------------------------------------------
 * Desc   : 개별 영수증 모두 삭제
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncDeleteAll() {
 	 
 	con=confirm("발행된 모든 영수증을 삭제하시겠습니까?");
    if(con==false){
        return;
	}else{
	 	frmInfo.action = "/output/billOutput/deleteAllBill.do";
	 	frmInfo.submit();
	}	

}

/*----------------------------------------------------------------------
 * Desc   : 지로 인쇄 기능을 수행한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function doPrintGiro(){

		actUrl = "/output/billOutput/ozEachGiroViewer.do";
		window.open('','ozEachGiroBill','width=1000, height=800, toolbar=no, menubar=no, location=no, status=no, resizable=1, scrollbars=no');

		frmInfo.target = "ozEachGiroBill";
		frmInfo.action = actUrl;
		frmInfo.submit();
		frmInfo.target ="";
}


/*----------------------------------------------------------------------
 * Desc   : 방문 인쇄 기능을 수행한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function doPrintVisit(){

		actUrl = "/output/billOutput/ozEachVisitViewer.do";
		window.open('','ozEachVisitBill','width=850, height=700, toolbar=no, menubar=no, location=no, status=no, resizable=1, scrollbars=no');

		frmInfo.target = "ozEachVisitBill";
		frmInfo.action = actUrl;
		frmInfo.submit();
		frmInfo.target ="";

}

/*----------------------------------------------------------------------
 * Desc   : 직영 체크박스 클릭시 안내문구
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncInfo(){
	 alert("선택시 직영지로번호(3146440)로 발행되고,   미선택시 지국정보에   등록된 지로번호로 발행합니다.");
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

/*----------------------------------------------------------------------
 * Desc   : 문자열의 공백을 제거한다.
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function trim(str) {  
	str = str.replace(/^\s+/, '');   
	for (var i = str.length - 1; i > 0; i--) {     
		if (/\S/.test(str.charAt(i))) {      
			str = str.substring(0, i + 1);       
			break;  
			} 
		}   
	return str;
	}
	
/*----------------------------------------------------------------------
 * Desc   : 고객안내문 팝업 오픈
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function popCustNoti() {

	actUrl = "/output/billOutput/popCustNotiView.do";
	window.open(actUrl,'고객안내문','width=700, height=580, toolbar=no, menubar=no, location=no, status=no, resizable=no, scrollbars=auto');

}
</script>
<div><span class="subTitle">개별영수증</span></div>
<form id= "frmInfo" name = "frmInfo" method="post">
<!-- search conditions -->
<div>
	<table class="tb_list_a" style="width: 1020px">
		<colgroup>
			<col width="80px">
			<col width="130px">
			<col width="80px">
			<col width="130px">
			<col width="80px">
			<col width="130px">
			<col width="80px">
			<col width="310px">
		</colgroup>
		<tr>
			<th>지 국</th>
			<td>
				<select name="serial" >
						<c:forEach items="${agencyList}" var="agency"  varStatus="status">
							<option value="${agency.SERIAL}"  <c:if test="${agency.SERIAL eq serial}">selected</c:if>>${agency.NAME}</option>
					 	</c:forEach>
			  	</select>
			</td>
			<th>매 체</th>
			<td>
				<select name="newsCd" style="width: 100px;">
					<option value = "">전체</option>
					<c:forEach items="${newsCode}" var="news"  varStatus="status">
						<option value="${news.NEWSCD}"  <c:if test="${news.NEWSCD eq newsCd}">selected</c:if>>${news.CNAME}</option>
				 	</c:forEach>
			  	</select>
			</td>
			<th>독자번호</th>
			<td >
			  	<input id="readNo" name="readNo" type="text"  maxLength="9"   value="<c:out value="${readNo}"/>"  style="ime-Mode:disabled; border: 1px solid #cccccc; background-color: #ffffff; height: 20px; width: 70px;" onkeypress="inputNumCom();" >
			  	<input type="hidden"  id="reader"  name="reader" value="<c:out value="${reader.READNO}"/>">
			  	<input type="hidden"  id="news"  name="news" value="<c:out value="${reader.NEWSCD}"/>">
			  	<input type="hidden" id="seq"  name="seq" value="<c:out value="${reader.SEQ}"/>">
			</td>
			<th>프린터모델</th>
			<td>
				<select id="pageSize" name="pageSize"  style="width: 50px; vertical-align: middle;">
					<option value='A3' >A3</option>
					<option value='A4' selected>A4</option>
				</select>&nbsp;
				<select id="model" name="model"  style="width: 110px; vertical-align: middle;">
					<option value='1' >한섬XL6100</option>
					<option value='2' >양재글초롱526</option>
					<option value='3' >OCR-3000</option>
					<option value='4' selected>교세라FS-6975</option>
			    </select>&nbsp;
				<a href="#fakeUrl" onclick="fncReaderList()"><img src="/images/bt_joh.gif" style="border: 0; vertical-align: middle;"></a> 
				<a href="/reader/readerManage/readerList.do" target="_blank"><img src="/images/bt_viewdoc.gif" style="border: 0; vertical-align: middle;"></a> 
			</td>
		</tr>
	</table>
</div>
<!-- //search conditions -->
<!-- contents -->
<div class="box_list" style="width: 1020px; margin: 0 auto;">
	<!-- left -->
	<div style="width: 350px; float: left; padding-right: 10px;">
		<div style="width: 343px; padding: 5px 0 5px 5px; border: 1px solid #e5e5e5">
			<div style="height:70px; overflow-y:scroll; width: 343px">
				<table class="tb_list_a" style="width: 323px">
					<colgroup>
						<col width="110px">
						<col width="80px">
						<col width="70px">
						<col width="63px">
					</colgroup>
					<tr>
						<th>독자번호</th>
						<th>독자명</th>
						<th>매 체</th>
						<th>부수</th>
					</tr>
					<c:forEach var="list" items="${readerList}" varStatus="status">
						<tr style="cursor:pointer ;" onclick="fncSelAction('${list.READNO}','${list.NEWSCD}','${list.SEQ}')">
							<td <c:if test="${('999' eq list.BNO) }"> style="color:red"</c:if>><c:out value="${list.READNO}" /></td>
							<td <c:if test="${('999' eq list.BNO) }"> style="color:red"</c:if>><c:out value="${list.READNM}" /></td>
							<td <c:if test="${('999' eq list.BNO) }"> style="color:red"</c:if>><c:out value="${list.NEWSNM}" /></td>
							<td <c:if test="${('999' eq list.BNO) }"> style="color:red"</c:if>><c:out value="${list.QTY}" /> 부</td>
						</tr>			
					</c:forEach>
				</table>
			</div>
		</div>
		<div style="width: 350px; padding: 10px 0">
			<table class="tb_search" style="width: 350px;">
				<colgroup>
					<col width="75px">
					<col width="275px">
				</colgroup>
				<tr>
					<th>고유번호</th>
					<td><input type="text" name="readerNo"  style="border:0;"  value="<c:out value="${reader.READER}"/>" readonly/></td>
				</tr>
				<tr>
					<th>독 자 명</th>
					<td><input type="text" name="readNm" style="border:0;" value="<c:out value="${reader.READNM}"/>" readonly/></td>										
				</tr>			
				<tr>
					<th>주 소</th>
					<td><input type="text" name="addr"  style="border:0;" value="<c:out value="${reader.ADDR}"/>" readonly/></td>										
				</tr>		
				<tr>
					<th>전화번호</th>
					<td><input type="text" name="phone" style="border:0;" value="<c:out value="${reader.PHONE}"/>" readonly/></td>										
				</tr>		
			 	<tr>
					<th>비 고</th>
					<td><input type="text" name="remk"  style="border:0;" value="<c:out value="${reader.REMK}"/>" readonly/></td>										
				</tr>										  
			</table>
		</div>
		<div>
			<table class="tb_search" style="width: 350px">
				<colgroup>
					<col width="90px">
					<col width="40px">
					<col width="75px">
					<col width="85px">
					<col width="60px">
				</colgroup>
			  	<tr>
					<th>청구월분</th>
					<td colspan="3" align="left" >
						<input type="text" name="sYear" style="ime-Mode:disabled;width:35px;text-align:center;" maxlength="4"   value=""   onkeypress="inputNumCom();"/> -
						<input type="text" name="sMonth"  style="ime-Mode:disabled;width:20px;text-align:center;" maxlength="2"   value=""   onkeypress="inputNumCom();"/>
						~
						<input type="text" name="eYear" style="ime-Mode:disabled;width:35px;text-align:center;" maxlength="4"   value=""   onkeypress="inputNumCom();"/> -
						<input type="text" name="eMonth"  style="ime-Mode:disabled;width:20px;text-align:center;" maxlength="2"   value=""   onkeypress="inputNumCom();"/>
					</td>		
					<td <c:if test="${('1' eq jikyungYn) }">rowspan="6"</c:if><c:if test="${('1' ne jikyungYn) }">rowspan="5"</c:if>>
						<a href="#fakeUrl" onclick="fncInsertBill()"><img src="/images/bt_bal.gif" style="border: 0; vertical-align: middle;"></a>
					</td>							
				</tr>		
				<tr>
					<th>청구부수</th>
					<td><input type="text" name="qty" style="ime-Mode:disabled;width:30px" maxlength="3" onkeypress="inputNumCom();" /></td>
					<th>청구금액</th>
					<td><input type="text" name="amount"  style="ime-Mode:disabled;width: 65px" maxlength="8" onKeyPress="inputNumCom();" /></td>
				</tr>		
				<tr>
					<th>인쇄구분</th>
					<td colspan="3">
						<input type="radio"   name="misuSum"  value= "0" checked style="border: 0; vertical-align: middle;"/> 통합인쇄&nbsp;
						<input type="radio"   name="misuSum"  value="1" style="border: 0; vertical-align: middle;"/> 월별인쇄
					</td>										
				</tr>
				<tr>
					<th>고객안내문</th>
					<td colspan="3">
						<select id="noti" name="noti"  style="width: 70px; vertical-align: middle;">
							<c:forEach items="${noti}" var="noti">
								<option value="${noti.CODE}"  <c:if test="${notiNo eq noti.CODE }">selected</c:if>>${noti.CODE}</option>
							</c:forEach>
							<option>미인쇄</option>
						</select>
						<a href="#fakeUrl" onclick="popCustNoti()"><img src="/images/bt_view.gif" style="border: 0; vertical-align: middle;"></a>
					</td>										
				</tr>
				<c:if test="${('1' eq jikyungYn) }">
				<tr>
					<th>지로구분</th>
					<td colspan="3">
						<input type="radio" id="jikyung" name="jikyung" value="1" checked style="border: 0; vertical-align: middle;"/> 직영지로&nbsp;&nbsp;
						<input type="radio" id="jikyung" name="jikyung" value="2"  style="border: 0; vertical-align: middle;"/> 지국지로
					</td>										
				</tr>			
				</c:if>
				<tr>
					<th>주소구분</th>
					<td colspan="3">
						<input type="radio" name="addrType"  value="roadNm" style="vertical-align: middle; border: 0;"> 도로명주소&nbsp;
						<input type="radio" name="addrType"  value="lotNo"  checked style="vertical-align: middle; border: 0;"> 지번주소
					</td>										
				</tr>						  									  						  
			</table>  
		</div>
	</div>
	<!-- //left -->
	<!-- middle -->
	<div style="width: 580px; float: left; overflow: hidden;">
		<!-- middle_left-->
		<div style="float: left; width: 280px; padding-right: 10px;">
			<table class="tb_list_a" style="width: 280px">
				<colgroup>
					<col width="40px">
					<col width="30px">
					<col width="70px">
					<col width="40px">
					<col width="60px">
					<col width="40px">
				<colgroup>
				<tr>
					<th>연도</th>
					<th>월</th>
					<th>입금일자</th>
					<th>금액</th>
					<th>입금액</th>
					<th>구분</th>
				</tr>			  
				<c:forEach var="sgList" items="${sugmList1}" varStatus="status">
					<tr>
						<td><c:out value="${sgList.YY}" /></td>
						<td><c:out value="${sgList.MM}" /></td>
						<td><c:out value="${sgList.SNDT}" /></td>
						<td><c:out value="${sgList.BILLAMT}" /></td>
						<td><c:out value="${sgList.AMT}" /></td>
						<td><c:out value="${sgList.SGBBNM}" /></td>
					</tr>			
				</c:forEach>		
			</table>
		</div>
		<!-- //middle_left-->
		<!-- middle_right-->
		<div style="float: left; width: 280px;">
			<table class="tb_list_a" style="width: 280px">
				<colgroup>
					<col width="40px">
					<col width="30px">
					<col width="70px">
					<col width="40px">
					<col width="60px">
					<col width="40px">
				<colgroup>
				<tr bgcolor="f9f9f9" align="center" class="box_p" >
					<td>연도</td>
					<td>월</td>
					<td>입금일자</td>
					<td>금액</td>
					<td>입금액</td>
					<td>구분</td>
				</tr>
				<c:forEach var="sgList2" items="${sugmList2}" varStatus="status">
					<tr >
						<td><c:out value="${sgList2.YY}" /></td>
						<td><c:out value="${sgList2.MM}" /></td>
						<td><c:out value="${sgList2.SNDT}" /></td>
						<td><c:out value="${sgList2.BILLAMT}" /></td>
						<td><c:out value="${sgList2.AMT}" /></td>
						<td><c:out value="${sgList2.SGBBNM}" /></td>
					</tr>			
				</c:forEach>		
			</table>
		</div>
		<!-- //middle_right-->
	</div>
	<!-- middle -->
	<!-- right -->
	<div style="float: left; width: 75px; border: 0px solid red">
		<div><a href="#fakeUrl" onclick="doPrintGiro()"><img src="/images/bt_jiro.gif"  style="vertical-align: middle; border: 0;"/></a></div>
		<div style="padding: 10px 0;"><a href="#fakeUrl" onclick="doPrintVisit()"><img src="/images/bt_bang.gif"  style="vertical-align: middle; border: 0;"/></a></div>
		<div><font class="b02"><input type="checkbox" id="subs" name="subs" value="1"   style="vertical-align: middle; border: 0;"/> 신문명</font></div>
		<div style="padding-top: 240px;"><a href="#fakeUrl" onclick="fncDeleteAll()"><img src="/images/bt_deleteall.gif"  style="vertical-align: middle; border: 0;"></a></div>
	</div>
	<!-- //right -->
</div>
<!-- //contents -->
<!-- bottom -->
<div class="box_list">
	<table class="tb_list_a" style="width: 1020px;">
		<tr>
			<th>고유번호</th>
			<th>독자명</th>
			<th>주 소</th>
			<th>확장일자</th>
			<th>매체명</th>
			<th>구독금액</th>
			<th>월분</th>
			<th>부수</th>
			<th>인쇄금액</th>
			<th>
				건별삭제
				<input type="hidden" id="boseq"  name="boseq" value="">
				<input type="hidden" id="id"  name="id" value="">
			</th>
		</tr>
		<c:forEach var="bill" items="${billList}" varStatus="status">
			<tr>
				<td><c:out value="${bill.READER_NO}" /></td>
				<td style="text-align:left;"><c:out value="${bill.READNM}" /></td>
				<td style="text-align:left;"><c:out value="${bill.ADDR}" /></td>
				<td><c:out value="${bill.HJDT}" /></td>
				<td><c:out value="${bill.NEWSNM}" /></td>
				<td><c:out value="${bill.UPRICE}" /></td>
				<td><c:out value="${bill.YYMM}" /></td>
				<td><c:out value="${bill.QTY}" /></td>
				<td><c:out value="${bill.AMOUNT}" /></td>
				<td><a href="#fakeUrl" onclick="fncDeleteBill('${bill.BOSEQ}','${bill.ID}')"><img src="/images/bt_imx.gif" style="border: 0; vertical-align: middle;"></a></td>
			</tr>			
		</c:forEach>		
	</table>
</div>
</form>
