<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

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

		actUrl = "/output/billOutput/ozVisitViewer2.do";
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



<table width="100%" cellpadding="0" cellspacing="0"  border="0">
	<tr>
		<td><img src="/images/tt_sub04_02.gif" border="0" align="absmiddle"></td>
	</tr>
</table>
<p style="margin-top:10px;">	
		
<!--인쇄조건-->
<form id= "frmInfo" name = "frmInfo" method="post">
    
<table width="100%" cellpadding="5" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
	<tr bgcolor="ffffff">
		<td bgcolor="f9f9f9" width="9%" align="center">
			<font class="b02">인쇄조건</font>
		</td>
		<td width="18%">
			<table width="100%"><tr><td>
				<div align="left">
					<select name="prtCb"   id="prtCb"  class='box_n'  style=' width: 100px;' onchange="changePrt()" >
						<!--<option value ='${prtCb.AA}' selected>${prtCb.BA}월분</option>  <!--운영용-->
						<option value ='201304' selected>2013-04월분</option>
						<option value ='201303' >2013-03월분</option>
						<option value ='201302' >2013-02월분</option>
						<option value ='201301' >2013-01월분</option>
						<option value ='201212' >2012-12월분</option>
						<option value ='201211' >2012-11월분</option>
						<option value ='201210' >2012-10월분</option>
						<option value ='201209' >2012-09월분</option>
						<option value ='201208' >2012-08월분</option>
						<option value ='201207' >2012-07월분</option>
						<option value ='201206' >2012-06월분</option>
						<option value ='201205' >2012-05월분</option>
						<option value ='201204' >2012-04월분</option>
						<option value ='201203' >2012-03월분</option>
						<option value ='201202' >2012-02월분</option>
						<option value ='201201' >2012-01월분</option>
				  	</select> <!--ABC용-->
				</div>
			</td>
			<td align="right">
				<!--<div  align="right" >
					<font class="b02"><input type="checkbox" id="subs" name="subs" value="1"/> 신문명인쇄</font>
				</div>  <!--운영용-->
		  	  	<div align="right">
						<font class="b02"><input type="checkbox" id="all" name="all" value="1"  onclick="fncInfo();" /> 당월전체</font>
				</div> <!--ABC용-->
			  
			</td></tr></table>
		</td>
		<td bgcolor="f9f9f9" width="9%" align="center">
			<font class="b02">미수인쇄여부</font>
		</td>
		<td width="18%">
			<input type="radio"  name="misuPrt"  value="0"  onClick="changeMisu()" checked> 미수포함</input> &nbsp;
			<input type="radio"  name="misuPrt"  value="1"   onClick="changeMisu()" > 미수제외</input>
		</td>
		<td bgcolor="f9f9f9" width="9%" align="center">
			<font class="b02">미수개월수</font>
		</td>
		<td width="18%" align="left" colspan='3'>
			<table width="100%"><tr><td>
				<div align="left">
					<select id="month" name="month"  style='border: 1px solid #cccccc; background-color: #ffffff; height: 20px; width: 70px'>
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
				</div>
			</td>
			<td align="right">
				<div  id="Etable"  align="left"  style='display:block'>
							<font class="b02"><input type="checkbox" id="misuOnly" name="misuOnly"  onClick="changeMisuOnly()"  value="1"/> 미수만인쇄</font>
				</div>
			</td></tr></table>
		</td>
	</tr>
	<tr bgcolor="ffffff">
		<td bgcolor="f9f9f9" width="9%" align="center">
			<font class="b02">고객안내문</font>
		</td>
		<td>
		<table width="100%" border="0" cellpadding="0" cellspacing="0" >
			<tr>
				<td>
					<div align="left">
						<select id="noti" name="noti"  style='border: 1px solid #cccccc; background-color: #ffffff; height: 20px; width: 55px'>
							<option>미인쇄</option>
								<c:forEach items="${noti}" var="noti">
									<option value="${noti.CODE}"  <c:if test="${(notiNo eq noti.CODE) }">selected</c:if>>${noti.CODE}</option>
							 	</c:forEach>
					    </select>
					    <a href="javascript:popCustNoti()"><img src="/images/bt_view.gif" border="0" align="absmiddle"></a>
					</div>
				</td>
				<td>
					<div align="right">
						<font class="b02"><input type="checkbox" id="remkPrt" name="remkPrt" value="1"/> 비고인쇄&nbsp;</font>
					</div>
				</td>
			</tr>
		</table>  
		</td>
		<td bgcolor="f9f9f9" width="9%" align="center">
			<font class="b02">미수통합</font>
		</td>
		<td width="18%">
			<input type="radio"   name="misuSum"  value= "0" checked> 통합인쇄</input> &nbsp;
			<input type="radio"   name="misuSum"  value="1" > 월별인쇄</input>
		</td>
		<td bgcolor="f9f9f9" width="9%" align="center">
			<font class="b02">프린터모델</font>
		</td>
		<td align="center"  colspan='3'>
		<table width="100%" border="0" cellpadding="0" cellspacing="0" >
			<tr>
				<td>
					<div align="left">
							<select id="model" name="model"  style='border: 1px solid #cccccc; background-color: #ffffff; height: 20px; width: 110px'>
								<option value='1'  selected>한섬XL6100</option>
								<option value='2' >양재글초롱526</option>
								<option value='3' >OCR-3000</option>
						    </select>&nbsp;
						</div>
				</td>
				<td>
					<div align="right">
						<a href="javascript:doPrint()"><img src="/images/bt_pprint.gif" border="0" align="absmiddle"></a>
					</div>
				</td>
			</tr>
		</table>  
		    <input type=hidden id="prtCbAA" name="prtCbAA" value="${prtCb.AA}" />
		    <input type=hidden id="newsSize" name="newsSize" value="0" />
		    <input type=hidden id="readerSize" name="readerSize" value="0" />
		    <input type=hidden id="sugmSize" name="sugmSize" value="0" />
		    <input type=hidden id="guyukSize" name="guyukSize" value="0" />
		</td>
	</tr>
</table>
   
<p style="margin-top:10px;">	

<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="e5e5e5">
	<tr bgcolor="ffffff">
		<td  width="50%" valign="top">
			<!-- 5개탭 메뉴-->
			<table width="100%" cellpadding="3" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
				<tr class="box_p" align="center">
					<td width="5%"><input type="checkbox" id="allNews" name="allNews" onClick="javascript:checkBoxCtr('allNews','news')" /></td>
					<td>매체구분</td>
					<td width="25%">약 자</td>
					<td width="25%">코 드</td>
				</tr>		
				<tr bgcolor="ffffff" align="center">
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>						
				<c:forEach items="${newsCode}" var="list"  varStatus="status">
				<tr id="oTr<c:out value="${status.index}"/>" bgcolor="ffffff" align="center" >
					<td style="text-align:center;"><input type="checkbox" id="news${status.index}" name="news${status.index}" value="${list.NEWSCD}" <c:if test="${('100' eq list.NEWSCD)}"> checked</c:if> /></td>
					<td style="text-align:center;">${list.CNAME}</td>
					<td style="text-align:center;">${list.YNAME}</td>
					<td style="text-align:center;">${list.NEWSCD}</td>
				</tr>
		   		</c:forEach>								
			</table>

			<p style="margin-top:10px;">
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td valign="top">
						<table width="100%" cellpadding="5" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
							<tr class="box_p" align="center">
								<td width="10%"><input type="checkbox" id="allReader" name="allReader" onClick="javascript:checkBoxCtr('allReader','reader');"/></td>
								<td width="30%">코드</td>
								<td>구독구분</td>
							</tr>
							<tr bgcolor="ffffff" align="center">
								<td></td>
								<td></td>
								<td></td>
							</tr>		
							<tr bgcolor="ffffff" align="center">
								<td><input type="checkbox" id="reader0" name="reader0" value='011' checked /></td>
								<td>011</td>
								<td>일반</td>
							</tr>		
							<tr bgcolor="ffffff" align="center">
								<td><input type="checkbox" id="reader1" name="reader1" value='012' /></td>
								<td>012</td>
								<td>학생 (지국)</td>
							</tr>		
							<tr bgcolor="ffffff" align="center">
								<td><input type="checkbox" id="reader2" name="reader2" value='013' /></td>
								<td>013</td>
								<td>학생 (본사)</td>
							</tr>																															
						</table>
					</td>
					<td width="10"></td>
					<td valign="top">
						<table width="100%" cellpadding="5" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
							<tr class="box_p" align="center">
								<td width="10%"><input type="checkbox" id="allSugm" name="allSugm" onClick="javascript:checkBoxCtr('allSugm','sugm');"/></td>
								<td width="25%">코드</td>
								<td>수금방법</td>
								<td width="20%">약어</td>
							</tr>
							<tr bgcolor="ffffff" align="center">
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
							<tr bgcolor="ffffff" align="center">
								<td><input type="checkbox" id="sugm0" name="sugm0" value='011'  /></td>
								<td>011</td>
								<td>지로</td>
								<td>G</td>
							</tr> 
							<tr bgcolor="ffffff" align="center">
								<td><input type="checkbox" id="sugm1" name="sugm1" value='012' checked/></td>
								<td>012</td>
								<td>방문</td>
								<td>B</td>
							</tr>		
							<!--<tr bgcolor="ffffff" align="center">
								<td><input type="checkbox" id="sugm2" name="sugm2" value='013' /></td>
								<td>013</td>
								<td>통장입금</td>
								<td>T</td>
							</tr>		
							<tr bgcolor="ffffff" align="center">
								<td><input type="checkbox" id="sugm3" name="sugm3" value='022' /></td>
								<td>022</td>
								<td>카드</td>
								<td>C</td>
							</tr>		-->
						</table>								
					</td>
				</tr>	
			</table>
		</td>
	


		<td width="10"></td>
		<!-- 우측메인-->
		<td valign="top">
			<table width="100%" cellpadding="3" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
				<tr class="box_p" align="center">
					<td width="5%"><input type="checkbox" id="allGuyuk" name="allGuyukAll" onClick="javascript:checkBoxCtr('allGuyuk','guyuk')" /></td>
					<td width="20%">구 역</td>
					<td>구역명</td>
					<td width="20%">시 작</td>
					<td width="20%">종 료</td>
				</tr>
				<tr bgcolor="ffffff" align="center">
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>		
				<c:forEach items="${guyukList}" var="list"  varStatus="status">
				<tr id="oTr<c:out value="${status.count}"/>" bgcolor="ffffff" align="center" >
					<td style="text-align:center;"><input type="checkbox" id="guyuk${status.index}" name="guyuk${status.index}" value="${list.GU_NO}"/></td>
					<td style="text-align:center;">${list.GU_NO }</td>
					<td style="text-align:center;">${list.GU_NM }</td>
					<td style="text-align:center;"><input name="strt${list.GU_NO}" type="text"  class="box_n" style="text-align:center;width:30" maxlength="3" value="001" style="ime-Mode:disabled"   onKeyPress="inputNumCom();"></td>
					<td style="text-align:center;"><input name="end${list.GU_NO}" type="text"  class="box_n" style="text-align:center;width:30" maxlength="3" value="998" style="ime-Mode:disabled"   onKeyPress="inputNumCom();"></td>
				</tr>
		   		</c:forEach>							
																									
				</table>
			</td>
		</tr>
	</table>
</form>