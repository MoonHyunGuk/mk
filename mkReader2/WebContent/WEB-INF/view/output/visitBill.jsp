<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript">
/*----------------------------------------------------------------------
 * Desc   : 고객안내문 팝업 오픈
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function popCustNoti() {

	actUrl = "/output/billOutput/popCustNotiView.do";
	window.open(actUrl,'고객안내문','width=700, height=580, toolbar=no, menubar=no, location=no, status=no, resizable=no, scrollbars=auto');

}


/*----------------------------------------------------------------------
 * Desc   : 인쇄 기능을 수행한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function doPrint(){
	 if(!validation()){
		 return;
	 }else{

		actUrl = "/output/billOutput/ozVisitViewer.do";
		window.open('','ozVisitBill','width=850, height=700, toolbar=no, menubar=no, location=no, status=no, resizable=1, scrollbars=no');

		frmInfo.target = "ozVisitBill";
		frmInfo.action = actUrl;
		frmInfo.submit();

	 }
}

/*----------------------------------------------------------------------
 * Desc   : 인쇄를 위한 선택 조건을 확인한다.
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function validation(){
	 
    var getObj = document.getElementsByTagName("input");
	var newsSize = 0;
    var readerSize = 0;
    var sugmSize = 0;
    var guyukSize = 0;
    for(var i=0; i < getObj.length; i++)
    {
    	if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("news") > -1 ){
    		newsSize++;
        }else if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("reader") > -1){
        	readerSize++;
        }else if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("sugm") > -1 ){
        	sugmSize++;
        }else if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("guyuk") > -1 ){
        	guyukSize++;
        }
    }
	$("newsSize").value = newsSize;
	$("readerSize").value = readerSize;
	$("sugmSize").value = sugmSize;
	$("guyukSize").value = guyukSize;

	var newsChk = 0;
    var readerChk = 0;
    var sugmChk = 0;
    var guyukChk = 0;
    
    for(var i=0; i < newsSize; i++)    {
    	if($("news"+i).checked) {
    		newsChk++;
        }
    }
    
    for(var i=0; i < readerSize; i++)    {
    	if($("reader"+i).checked) {
    		readerChk++;
        }
    }
    
    for(var i=0; i < sugmSize; i++)    {
    	if($("sugm"+i).checked) {
    		sugmChk++;
        }
    }
    
    for(var i=0; i < guyukSize; i++)    {
    	if($("guyuk"+i).checked) {
    		guyukChk++;
        }
    }
	 
	if(newsChk == 0){
		alert("매체구분을 선택해 주세요.");
		return false;
	}else 	if(readerChk == 0){
		alert("구독구분을 선택해 주세요.");
		return false;
	}else	if(sugmChk == 0){
		alert("수금방법을 선택해 주세요.");
		return false;
	}else 	if(guyukChk == 0){
		alert("인쇄할 구역을 선택해 주세요.");
		return false;
	}

	 return true;
 }
 
/*----------------------------------------------------------------------
 * Desc   : 체크박스 전체선택 / 전체해제
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function checkBoxCtr(gbnAll, gbn){

	var getObj = document.getElementsByTagName("input");
	var count = 0;
	if($(gbnAll).checked){
		 for(var i=0; i < getObj.length; i++){
	        if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf(gbn) > -1 ){
	        	$(gbn+count).checked = true;
	        	count++;
	        }
	    }
	}else{
		 for(var i=0; i < getObj.length; i++){
	        if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf(gbn) > -1 ){
	        	$(gbn+count).checked = false;
	        	count++;
	        }
	    }
	}
}


/*----------------------------------------------------------------------
 * Desc   : 인쇄조건에따라 '미수만인쇄' 화면표시 제어
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function changePrt() {  

       if(document.frmInfo.prtCb.value == document.frmInfo.prtCbAA.value) {
           document.all.Etable.style.display='block';
           document.frmInfo.all.disabled = false ;
       } else {
    	   document.frmInfo["misuOnly"].checked = false;
           document.all.Etable.style.display='none';
           document.frmInfo.all.disabled = false ;
       }
	}

/*----------------------------------------------------------------------
 * Desc   : 미수인쇄여부에따라 관련콤보 비활성화
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function changeMisu() {  
	 
       if( document.frmInfo.misuPrt[0].checked) {    	   
           document.frmInfo.month.disabled = false ;
           document.frmInfo.misuSum[0].disabled = false ;
           document.frmInfo.misuSum[1].disabled = false ;
           document.frmInfo.misuOnly.disabled = false ;
           document.frmInfo.all.disabled = false ;
           
       } else {    	   
    	   document.frmInfo.month.disabled = true ;
    	   document.frmInfo.misuSum[0].disabled = true ;
    	   document.frmInfo.misuSum[1].disabled = true ;
    	   document.frmInfo.misuOnly.checked = false;
    	   document.frmInfo.misuOnly.disabled = true ;
    	   document.frmInfo.all.disabled = false ;
       }
       return;
	}
	
/*----------------------------------------------------------------------
 * Desc   : 미수만 인쇄여부에따라 당월인쇄 체크박스 비활성화
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function changeMisuOnly() {  
	 
       if( document.frmInfo.misuOnly.checked) {    	   
    	   document.frmInfo.all.checked = false;
           document.frmInfo.all.disabled = true ;
           
       } else {    	   

    	   document.frmInfo.all.disabled = false ;
       }
       return;
	}

/*----------------------------------------------------------------------
 * Desc   : 당월전체 체크박스 클릭시 안내문구
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncInfo(){
	 alert("선택시 수금여부와 무관하게 당월분에 한해 전체 독자를 인쇄하고,   미선택시 미수독자만 인쇄합니다.");
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
	
</script>
<div><span class="subTitle">방문영수증</span></div>
<form id= "frmInfo" name = "frmInfo" method="post">
<!-- search conditions -->
<div>
	<table class="tb_search" style="width: 1020px;">
		<colgroup>
			<col width="100px;">
			<col width="230px;">
			<col width="100px;">
			<col width="220px;">
			<col width="100px;">
			<col width="270px;">
		</colgroup>
		<tr>
			<th>인쇄조건</th>
			<td style="text-align: left; padding-left: 10px;">
				<select name="prtCb" id="prtCb" style="vertical-align: middle;" onchange="changePrt()" >
					<option value ='${prtCb.AA}' selected>${prtCb.BA}월분</option>
			  	</select>&nbsp;
				<font class="b02"><input type="checkbox" id="subs" name="subs" value="1" style="border: 0; vertical-align: middle;"/> 신문명인쇄</font>
			  	  <!--	<div align="right">
							<font class="b02"><input type="checkbox" id="all" name="all" value="1"  onclick="fncInfo();"/> 당월전체</font>
					</div>
				  -->
			</td>
			<th>미수인쇄여부</th>
			<td>
				<input type="radio"  name="misuPrt"  value="0"  onclick="changeMisu()" checked style="border: 0; vertical-align: middle;"> 미수포함&nbsp;
				<input type="radio"  name="misuPrt"  value="1"   onclick="changeMisu()" style="border: 0; vertical-align: middle;"> 미수제외
			</td>
			<th>미수개월수</th>
			<td style="text-align: left; padding-left: 10px;">
				<select id="month" name="month"  style="vertical-align: middle; width: 70px">
					<option value='1' >1개월</option>
					<option value='2' >2개월</option>
					<option value='3' >3개월</option>
					<option value='4' >4개월</option>
					<option value='5' >5개월</option>
					<option value='6' >6개월</option>
					<option value='7' >7개월</option>
					<option value='8' >8개월</option>
					<option value='9' >9개월</option>
					<option value='10' >10개월</option>
					<option value='11' >11개월</option>
					<option value='12'  selected>12개월</option>		
					<option value='18' >18개월</option>
					<option value='24' >24개월</option>
			    </select>&nbsp;
				<font class="b02"><input type="checkbox" id="misuOnly" name="misuOnly"  onclick="changeMisuOnly()"  value="1" style="border: 0; vertical-align: middle;"/> 미수만인쇄</font>
			</td>
		</tr>
		<tr>
			<th>고객안내문</th>
			<td style="text-align: left; padding-left: 10px;">
				<select id="noti" name="noti"  style="vertical-align: middle; width: 55px">
					<option>미인쇄</option>
					<c:forEach items="${noti}" var="noti">
						<option value="${noti.CODE}"  <c:if test="${(notiNo eq noti.CODE) }">selected</c:if>>${noti.CODE}</option>
				 	</c:forEach>
			    </select>
			    <a href="#fakeUrl" onclick="popCustNoti()"><img src="/images/bt_view.gif" style="border: 0; vertical-align: middle;"></a>
				<font class="b02"><input type="checkbox" id="remkPrt" name="remkPrt" value="1" style="border: 0; vertical-align: middle;"/> 비고인쇄&nbsp;</font>
			</td>
			<th>미수통합</th>
			<td>
				<input type="radio"   name="misuSum"  value= "0" checked style="border: 0; vertical-align: middle;"> 통합인쇄&nbsp;
				<input type="radio"   name="misuSum"  value="1" style="border: 0; vertical-align: middle;"> 월별인쇄
			</td>
			<th>프린터모델</th>
			<td style="text-align: left; padding-left: 10px;">
				<select id="model" name="model"  style="width: 110px; vertical-align: middle;">
					<option value='1' >한섬XL6100</option>
					<option value='2' >양재글초롱526</option>
					<option value='3' >OCR-3000</option>
					<option value='4' selected>교세라FS-6975</option>
			    </select>&nbsp;
				<a href="#fakeUrl" onclick="doPrint()"><img src="/images/bt_pprint.gif"  style="border: 0; vertical-align: middle;"></a>
			    <input type=hidden id="prtCbAA" name="prtCbAA" value="${prtCb.AA}" />
			    <input type=hidden id="newsSize" name="newsSize" value="0" />
			    <input type=hidden id="readerSize" name="readerSize" value="0" />
			    <input type=hidden id="sugmSize" name="sugmSize" value="0" />
			    <input type=hidden id="guyukSize" name="guyukSize" value="0" />
			</td>
		</tr>
		<tr>
			<th>주소구분</th>
			<td colspan="5">
				<div>
				<span style="float: left; width: 700px;">
					<input type="radio" name="addrType"  value="roadNm" style="vertical-align: middle; border: 0;"> 도로명주소&nbsp;
					<input type="radio" name="addrType"  value="lotNo"  checked style="vertical-align: middle; border: 0;"> 지번주소
				</span>
				<span style="float: right; width: 100px;">
					<a href="#fakeUrl" onclick="doPrint()"><img src="/images/bt_jiro.gif" border="0" style="vertical-align: middle;"></a>
				</span>
				</div>
			</td>
		</tr>
	</table>
</div>
<!-- //search conditions -->
<!-- check conditons -->
<div style="overflow: hidden; padding: 15px 0 20px 0; width: 1020px; margin: 0 auto;">
	<!-- left -->
	<div style="float: left; width: 510px; padding-right: 10px; border: 0px solid">
		<table class="tb_list_a" style="width: 510px">
			<colgroup>
				<col width="25px">
				<col width="225px">
				<col width="125px">
				<col width="125px">
			</colgroup>
			<tr>
				<th><input type="checkbox" id="allNews" name="allNews" onclick="checkBoxCtr('allNews','news')" style="border: 0;" /></th>
				<th>매체구분</th>
				<th>약 자</th>
				<th>코 드</th>
			</tr>		
			<tr>
				<td style="padding-top: 1px;"></td>
				<td style="padding-top: 1px;"></td>
				<td style="padding-top: 1px;"></td>
				<td style="padding-top: 1px;"></td>
			</tr>						
			<c:forEach items="${newsCode}" var="list"  varStatus="status">
			<tr id="oTr<c:out value="${status.index}"/>">
				<td><input type="checkbox" id="news${status.index}" name="news${status.index}" value="${list.NEWSCD}" <c:if test="${('100' eq list.NEWSCD)}"> checked</c:if>  style="border: 0;" /></td>
				<td>${list.CNAME}</td>
				<td>${list.YNAME}</td>
				<td>${list.NEWSCD}</td>
			</tr>
	   		</c:forEach>								
		</table>
		<div style="overflow: hidden; padding: 10px 0 0 0px; border: 0px solid;">
			<!-- left -->
			<div style="float: left; padding-right: 10px; border: 0px solid; width: 230px">
				<table class="tb_list_a" style="width: 230px;">
					<colgroup>
						<col width="25px">
						<col width="70px">
						<col width="135px">
					</colgroup>
					<tr>
						<th><input type="checkbox" id="allReader" name="allReader" onclick="checkBoxCtr('allReader','reader');" style="border: 0;"/></th>
						<th>코드</th>
						<th>구독구분</th>
					</tr>
					<tr>
						<td style="padding-top: 1px;"></td>
						<td style="padding-top: 1px;"></td>
						<td style="padding-top: 1px;"></td>
					</tr>		
					<tr>
						<td><input type="checkbox" id="reader0" name="reader0" value='011' checked  style="border: 0;" /></td>
						<td>011</td>
						<td>일반</td>
					</tr>		
					<tr>
						<td><input type="checkbox" id="reader1" name="reader1" value='012'  style="border: 0;" /></td>
						<td>012</td>
						<td>학생 (지국)</td>
					</tr>		
					<tr>
						<td><input type="checkbox" id="reader2" name="reader2" value='013'  style="border: 0;" /></td>
						<td>013</td>
						<td>학생 (본사)</td>
					</tr>
				</table>
			</div>
			<!-- //left -->
			<!-- right -->
			<div style="float: left;">
				<table class="tb_list_a" style="width: 270px;">
					<colgroup>
						<col width="25px">
						<col width="70px">
						<col width="120px">
						<col width="55px">
					</colgroup>
					<tr>
						<th><input type="checkbox" id="allSugm" name="allSugm" onclick="checkBoxCtr('allSugm','sugm');" style="border: 0;"/></th>
						<th>코드</th>
						<th>수금방법</th>
						<th>약어</th>
					</tr>
					<tr>
						<td style="padding-top: 1px;"></td>
						<td style="padding-top: 1px;"></td>
						<td style="padding-top: 1px;"></td>
						<td style="padding-top: 1px;"></td>
					</tr>
					<tr>
						<td><input type="checkbox" id="sugm0" name="sugm0" value='011'  style="border: 0;" /></td>
						<td>011</td>
						<td>지로</td>
						<td>G</td>
					</tr>
					<tr>
						<td><input type="checkbox" id="sugm1" name="sugm1" value='012' checked  style="border: 0;" /></td>
						<td>012</td>
						<td>방문</td>
						<td>B</td>
					</tr>		
					<tr>
						<td><input type="checkbox" id="sugm2" name="sugm2" value='013' style="border: 0;" /></td>
						<td>013</td>
						<td>통장입금</td>
						<td>T</td>
					</tr>		
					<tr>
						<td><input type="checkbox" id="sugm3" name="sugm3" value='022'  style="border: 0;" /></td>
						<td>022</td>
						<td>카드</td>
						<td>C</td>
					</tr>		
				</table>		
			</div>
			<!-- //right -->
		</div>
	</div>
	<!-- //left -->
	<!-- right -->
	<div style="float: left; width: 500px;"> 
		<table class="tb_list_a">
			<colgroup>
				<col width="30px">
				<col width="100px">
				<col width="170px">
				<col width="100px">
				<col width="100px">
			</colgroup>
			<tr>
				<th><input type="checkbox" id="allGuyuk" name="allGuyukAll" onclick="checkBoxCtr('allGuyuk','guyuk')" style="border: 0;" /></th>
				<th>구 역</th>
				<th>구역명</th>
				<th>시 작</th>
				<th>종 료</th>
			</tr>
		</table>
		<div style="width: 500px; height: 390px; overflow-y: scroll; overflow-x: none;">
			<table class="tb_list_a" style="width: 483px">
				<colgroup>
					<col width="30px">
					<col width="100px">
					<col width="170px">
					<col width="100px">
					<col width="83px">
				</colgroup>
				<c:forEach items="${guyukList}" var="list"  varStatus="status">
					<tr id="oTr<c:out value="${status.count}"/>" >
						<td><input type="checkbox" id="guyuk${status.index}" name="guyuk${status.index}" value="${list.GU_NO}" style="border: 0;" /></td>
						<td>${list.GU_NO }</td>
						<td>${list.GU_NM }</td>
						<td><input name="strt${list.GU_NO}" type="text"  style="text-align:center;width:30px;ime-Mode:disabled" maxlength="3" value="001" onkeypress="inputNumCom();"></td>
						<td><input name="end${list.GU_NO}" type="text"  style="text-align:center;width:30px;ime-Mode:disabled" maxlength="3" value="998"  onkeypress="inputNumCom();"></td>
					</tr>
		   		</c:forEach>			
			</table>
		</div>
	</div>
	<!-- //right -->
</div>
</form>
