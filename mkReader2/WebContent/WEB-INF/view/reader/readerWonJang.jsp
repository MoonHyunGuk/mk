<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/ajaxUtil.js"></script>
<script type="text/javascript">
//전체선택 전체해제 : 매체
function checkBoxCtr3(){
	var frm = document.readerWonJangForm;
	var getObj = document.getElementsByTagName("input");
	var count = 0;
	if(frm.checkNews.checked == true){
		 for(var i=0; i < getObj.length; i++){
	        if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("newsCd") > -1 ){
	        	document.getElementById("newsCd"+count).checked = true;
	        	count++;
	        }
	    }
	}else if(frm.checkNews.checked == false){
		 for(var i=0; i < getObj.length; i++){
	        if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("newsCd") > -1 ){
	        	document.getElementById("newsCd"+count).checked = false;
	        	count++;
	        }
	    }
	}
}

//전체선택 전체해제 : 독자유형
function checkBoxCtr2(){
	var frm = document.readerWonJangForm;
	var getObj = document.getElementsByTagName("input");
	var count = 0;
	if(frm.checkReader.checked == true){
		 for(var i=0; i < getObj.length; i++){
	        if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("readerType") > -1 ){
	        	document.getElementById("readerType"+count).checked = true;
	        	count++;
	        }
	    }
	}else if(frm.checkReader.checked == false){
		 for(var i=0; i < getObj.length; i++){
	        if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("readerType") > -1 ){
	        	document.getElementById("readerType"+count).checked = false;
	        	count++;
	        }
	    }
	}
}


// 배달명단 조회
function retrieveList(){
    var getObj = document.getElementsByTagName("input"); 
    var fm = document.getElementById("readerWonJangForm");
    
    var neswCdSize = 0;
    var readerTypeSize = 0;
    for(var i=0; i < getObj.length; i++)
    {
        if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("news") > -1 ){
        	neswCdSize++;
        }else if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("readerType") > -1){
        	readerTypeSize++;
        }
    }
    
    fm.neswCdSize.value = neswCdSize;
    fm.readerTypeSize.value = readerTypeSize;
	fm.target="_self";
	fm.action="/reader/readerWonJang/retrieveReaderList.do";
	fm.submit();
}
	
//명단 인쇄
function print(){
	var getObj = document.getElementsByTagName("input");
	var fm = document.getElementById("readerWonJangForm");
	 
	var neswCdSize = 0;
    var readerTypeSize = 0;
    var printSize = 0;
    for(var i=0; i < getObj.length; i++)
    {
    	if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("news") > -1 ){
        	neswCdSize++;
        }else if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("readerType") > -1){
        	readerTypeSize++;
        }else if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("print") > -1 ){
        	printSize++;
        }
    }
    fm.printSize.value = printSize;
    fm.neswCdSize.value = neswCdSize;
    fm.readerTypeSize.value = readerTypeSize;
	
	actUrl = "/reader/readerWonJang/ozReaderWonJang.do";
	window.open('','ozReaderWonJang','width=950, height=800, toolbar=no, menubar=no, location=no, status=no, resizable=1, scrollbar=no');

	fm.target = "ozReaderWonJang";
	fm.action = actUrl;
	fm.submit();
}
	
//전체선택 전체해제
function checkBoxCtr(gbn){
	//전체선택 1 , 전체해제 2
	var getObj = document.getElementsByTagName("input");
	var count = 0;
	if(gbn == '1'){
		document.getElementById("check2").checked = false;
		 for(var i=0; i < getObj.length; i++){
	        if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("print") > -1 ){
	        	document.getElementById("print"+count).checked = true;
	        	count++;
	        }
	    }
	}else if(gbn == '2'){
		document.getElementById("check1").checked = false;
		 for(var i=0; i < getObj.length; i++){
	        if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("print") > -1 ){
	        	document.getElementById("print"+count).checked = false;
	        	count++;
	        }
	    }
	}
}

//엑셀로 저장		
function saveExcel(){
	var getObj = document.getElementsByTagName("input");
	var fm = document.getElementById("readerWonJangForm");
	
	var neswCdSize = 0;
    var readerTypeSize = 0;
    var printSize = 0;
    for(var i=0; i < getObj.length; i++)
    {
    	if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("news") > -1 ){
        	neswCdSize++;
        }else if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("readerType") > -1){
        	readerTypeSize++;
        }else if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("print") > -1 ){
        	printSize++;
        }
    }
    fm.printSize.value = printSize;
    fm.neswCdSize.value = neswCdSize;
    fm.readerTypeSize.value = readerTypeSize;
    
    fm.target="_self";
    fm.action = "/reader/readerWonJang/ExcelReaderList.do";
    fm.submit();
}

//관리자 지국 선택
function changeAgency(){
	var fm = document.getElementById("readerWonJangForm");
	
	if(document.getElementById("agencySearch").value != ''){
		<c:forEach items="${agencyList }" var="list">
			if('${list.NAME}' == document.getElementById("agencySearch").value){
				document.getElementById("agency").value = '${list.SERIAL}';
			}
		</c:forEach>
	}
	
	fm.action="/reader/readerWonJang/retrieveReaderWonJang.do";
	fm.target="_self";
	fm.submit();
}
</script>
<div> <span class="subTitle">독자원장</span></div>
<form id="readerWonJangForm" name="readerWonJangForm" action="" method="post">
	<input type="hidden" id="neswCdSize" name="neswCdSize" value=""/>
	<input type="hidden" id="printSize" name="printSize" value=""/>
	<input type="hidden" id="readerTypeSize" name="readerTypeSize" value=""/>
	<!-- search box -->
	<div style="padding: 5px;overflow: hidden; width: 490px; float: left;">
		<table style="width: 100%; border: 0;" class="tb_search">
			<colgroup>
				<col width="60px">
				<col width="">
			</colgroup>
			<c:if test="${not empty admin_userid }">
			<tr>
				<td align="center"><font class="b02">지국명</font></td>
				<td >
					<select name="agency" id="agency" onchange="changeAgency();" style="vertical-align: middle;">
						<c:forEach items="${agencyList }" var="list">
						<option value="${list.SERIAL }"<c:if test="${agency_serial eq list.SERIAL }">selected</c:if>>${list.NAME }</option>
						</c:forEach>
					</select>
					<input type="text" id="agencySearch" name="agencySearch" style="width:100px" onkeydown="if(event.keyCode == 13){changeAgency();}"/>
					<a href="#fakeUrl" onclick="changeAgency();"><img src="/images/bt_search.gif" style="vertical-align: middle; border: 0;" ></a>
				</td>
			</tr>
			</c:if>
			<tr> 
				<th>구역선택</th>
				<td>
					<input type="text" id="minGno" name="minGno" value="${minGno}" style="width:40px;vertical-align: middle;" maxlength="3" onkeypress="inputNumCom()" />~ 
					<input type="text" id="maxGno" name="maxGno" value="${maxGno}" style="width:40px;vertical-align: middle;" maxlength="3" onkeypress="inputNumCom()" />
					<a href="#fakeUrl" onclick="retrieveList();"><img src="/images/bt_joh.gif" style="vertical-align: middle; border: 0;"></a>
					&nbsp;&nbsp;&nbsp;
					<a href="#fakeUrl" onclick="print();"><img src="/images/bt_nprint.gif"  style="vertical-align: middle; border: 0;"></a>
				</td>					
			</tr>
		</table>
		<div style="width: 100%; padding: 15px 0 3px 0;">
			<input type="checkbox" id="check1" name="check1" onclick="checkBoxCtr('1');" style="border: 0; vertical-align: middle;">&nbsp;전체선택 &nbsp;&nbsp;<input type="checkbox" id="check2" name="check2" onclick="checkBoxCtr('2');" style="border: 0; vertical-align: middle;">&nbsp;전체해제
		</div>
		<div>
			<table class="tb_list_a" style="width: 490px;">  
				<colgroup>
					<col width="50px">
					<col width="110px">
					<col width="110px">
					<col width="110px">
					<col width="110px">
				</colgroup>
				<tr>
					<th>인쇄</th>
					<th>구역</th>
					<th>구역명</th>
					<th>시작배달</th>
					<th>종료배달</th>
				</tr>
			</table>
			<div style="width: 490px; overflow-y: scroll; overflow-x: none;  margin: 0 auto; height: 350px">
				<table class="tb_list_a" style="width: 473px;">
					<colgroup>
						<col width="50px">
						<col width="110px">
						<col width="110px"> 
						<col width="110px">
						<col width="93px">
					</colgroup>
					<c:forEach items="${readerList }" var="list" varStatus="i">
						<tr>
							<td><input type="checkbox" id="print${i.index}" name="print${i.index}" value="${list.GNO }" style="border: 0;"></td>
							<td>${list.GNO }</td>
							<td>${list.GNONM }</td>
							<td><input type="text" id="start${i.index }" name="start${i.index }" value="${list.MINBNO }"  style="width: 60px;"/></td>
							<td><input type="text" id="end${i.index }" name="end${i.index }" value="${list.MAXBNO }"  style="width: 60px;"/></td>
						</tr>
					</c:forEach>
				</table>
			</div>	
		</div>
	</div>
	<!-- //search box -->
	<!-- contents -->
	<!-- code no1 -->
	<div style="float: left; padding: 5px 10px 0 10px; border: 0px solid red; width: 195px;">
		<table class="tb_list_a" style="width: 195px;">  
			<colgroup>
				<col width="45px">
				<col width="50px">
				<col width="100px">
			</colgroup>
			<tr>
				<th><input type="checkbox" id="checkReader" name="checkReader" onclick="checkBoxCtr2();" style="border: 0;"></th>
				<th>코드</th>
				<th>구독 구분</th>
			</tr>
			<c:forEach items="${readerType }" var="list" varStatus="i">
				<tr bgcolor="ffffff" align="center">
					<td><input type="checkbox" id="readerType${i.index }" name="readerType${i.index }" value="${list.CODE }"  style="border: 0;"<c:if test="${readTypeCd[i.index] eq list.CODE}">checked="checked"</c:if>></td>
					<td>${list.CODE }</td>
					<td>${list.CNAME }</td>
				</tr>
		  </c:forEach>
		 </table>
	</div>
	<!-- //code no1 -->
	<div style="float: left; width: 270px; padding-top: 5px">
		<table class="tb_list_a" style="width: 270px;">  
			<colgroup>
				<col width="50px">
				<col width="150px">
				<col width="70px">
			</colgroup>
			<tr>
				<th><input type="checkbox" id="checkNews" name="checkNews" onclick="checkBoxCtr3();" style="border: 0;"></th>
				<th>신문명</th>
				<th>코드</th>
			  </tr>
			  <c:forEach items="${newSList }" var="list" varStatus="i">
			  <tr>
			      <td><input type="checkbox" id="newsCd${i.index}" name="newsCd${i.index}" value="${list.CODE }" style="border: 0;"<c:if test="${(newsCd[i.index] eq list.CODE) or (list.CODE eq '100')}">checked="checked"</c:if>></td>
			      <td>${list.CNAME }</td>
			      <td>${list.YNAME }</td>
			  </tr>
			  </c:forEach>
		</table>
		<br/>
		<!--인쇄조건-->
		<table class="tb_list_a" style="width: 270px;">  
			<tr>
			    <th>인쇄조건</th>
			</tr>
			<tr>
				<td>
					<div style="text-align: left; padding-top: 4px;">
						&nbsp;&nbsp;<input type="checkbox" id="terms1" name="terms1"  value="1" style="border: 0;"<c:if test="${not empty param.terms1 }">checked="checked"</c:if>> 명단 통계 구분
					</div>
					<div style="text-align: left; padding: 3px 0">
						&nbsp;&nbsp;<input type="checkbox" id="terms3" name="terms3"  value="1" style="border: 0;"<c:if test="${not empty param.terms3 }">checked="checked"</c:if>> 중지독자포함
					</div>
					<div style="text-align: left; padding-bottom: 3px">
						&nbsp;&nbsp;<input type="checkbox" id="terms5" name="terms5"  value="1" style="border: 0;"<c:if test="${not empty param.terms5 }">checked="checked"</c:if>> 비고인쇄
					</div>
				</td>
			</tr>
		 </table>			
		 <!--//인쇄조건-->		
	</div>
	<!-- //contents -->
</form>