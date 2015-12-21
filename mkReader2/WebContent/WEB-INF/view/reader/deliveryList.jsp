<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript"  src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/ajaxUtil.js"></script>
<script type="text/javascript">
	// 매체 종류 전체 선택/해제
	function checkControll(){
		var frm = document.deliveryListForm;
		var getObj = document.getElementsByTagName("input");
		var count = 0;
		if(frm.checkNews.checked == true){
			 for(var i=0; i < getObj.length; i++){
		        if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("newsCd") > -1 ){
		        	$("newsCd"+count).checked = true;
		        	count++;
		        }
		    }
		}else if(frm.checkNews.checked == false){
			 for(var i=0; i < getObj.length; i++){
		        if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("newsCd") > -1 ){
		        	$("newsCd"+count).checked = false;
		        	count++;
		        }
		    }
		}
	}

	// 배달명단 인쇄 선택/ 해제
	function checkPrintControll(){
		var frm = document.deliveryListForm;
		var getObj = document.getElementsByTagName("input");
		var count = 0;
		if(frm.checkPrint.checked == true){
			 for(var i=0; i < getObj.length; i++){
		        if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("print") > -1 ){
		        	$("print"+count).checked = true;
		        	count++;
		        }
		    }
		}else if(frm.checkPrint.checked == false){
			 for(var i=0; i < getObj.length; i++){
		        if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("print") > -1 ){
		        	$("print"+count).checked = false;
		        	count++;
		        }
		    }
		}
	}
	
	// 배달명단 조회
	function retrieveDeList(){
	    var getObj = document.getElementsByTagName("input"); 
	    var neswCdSize = 0;
    
    	for(var i=0; i < getObj.length; i++)
	    {
	        if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("news") > -1){
	        	neswCdSize++;
	        }
	    }
    	
	    $("neswCdSize").value = neswCdSize;
		deliveryListForm.target="_self";
		deliveryListForm.action="/reader/delivery/retrieveDeliveryList.do";
		deliveryListForm.submit();
		deliveryListForm.target ="";
	}
	
	//프린트
	function print(){
		var getObj = document.getElementsByTagName("input"); 
		var neswCdSize = 0;
	    var printSize = 0;
	    for(var i=0; i < getObj.length; i++)
	    {
	        if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.substr(0,4) == "prin"){
	        	printSize++;
	        }else if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("news") > -1){
	        	neswCdSize++;
	        }
	    }
		$("neswCdSize").value = neswCdSize;
		$("printSize").value = printSize;
		
		actUrl = "/reader/delivery/ozDeliveryList.do";
		window.open('','ozDeliveryList','width=850, height=700, toolbar=no, menubar=no, location=no, status=no, resizable=1, scrollbar=no');

		deliveryListForm.target = "ozDeliveryList";
		deliveryListForm.action = actUrl;
		deliveryListForm.submit();
		
		
	}
	//관리자 지국 선택
	function changeAgency(){
		if($("agencySearch").value != ''){
			<c:forEach items="${agencyList }" var="list">
				if('${list.NAME}' == $("agencySearch").value){
					$("agency").value = '${list.SERIAL}';
				}
			</c:forEach>
		}
		deliveryListForm.action="/reader/delivery/retrieveDeliveryList.do";
		deliveryListForm.target="_self";
		deliveryListForm.submit();
	}
	
	/*----------------------------------------------------------------------
	 * Desc   : 인쇄조건에따라 '비고인쇄' 화면표시 제어
	 * Auth   : 유진영
	 *----------------------------------------------------------------------*/
	function changePrt() {  
	       if(document.deliveryListForm["detailYn"].checked == true) {
	    	   document.deliveryListForm["remkYn"].checked = true;
	    	   document.deliveryListForm["reaNmYn"].checked = true;
	    	   document.deliveryListForm.reaNmYn.disabled = true ;
	           document.all.Etable.style.display='block';
	       } else {
	    	   document.deliveryListForm["remkYn"].checked = false;
	    	   document.deliveryListForm.reaNmYn.disabled = false ;
	           document.all.Etable.style.display='none';
	       }
	}
	
</script>
<div><span class="subTitle">배달명단</span></div>
<form id="deliveryListForm" name="deliveryListForm" action="" method="post">
	<input type="hidden" id="neswCdSize" name="neswCdSize" value=""/>
	<input type="hidden" id="printSize" name="printSize" value=""/>
	<!-- search box -->
	<c:if test="${not empty admin_userid }">
		<div style="padding: 5px;overflow: hidden;">
			<table width="100%" cellpadding="0" cellspacing="0"  border="0">
				<tr>
					<td width="10%" align="center"><font class="b02">지 국 명</font></td>
					<td>
						<select name="agency" id="agency" onchange="javascript:changeAgency();">
							<c:forEach items="${agencyList }" var="list">
							<option value="${list.SERIAL }"<c:if test="${agency_serial eq list.SERIAL }">selected</c:if>>${list.NAME }</option>
							</c:forEach>
						</select>
						<input type="text" id="agencySearch" name="agencySearch" style="width:100px" onkeydown="if(event.keyCode == 13){changeAgency();}"/>
						<a href="javascript:changeAgency();"><img src="/images/bt_search.gif" border="0" align="absmiddle"></a>
					</td>
				</tr>
			</table>
		</div>
	</c:if>
	<!-- //search box -->
	<!-- contents -->
	<div style="overflow: hidden; width: 100%; border: 0px solid; padding-bottom: 40px;">
		<!-- 배달 리스트 -->
		<div style="float: left; width: 500px;">
			<table class="tb_list_a" style="width: 500px;">  
				<colgroup>
					<col width="50px">
					<col width="90px">
					<col width="90px">
					<col width="90px">
					<col width="90px">
					<col width="90px">
				</colgroup>
				<tr>
			    	<th><input type="checkbox" id="checkPrint" name="checkPrint" onclick="checkPrintControll();" style="border: 0;"></th>
			    	<th>구역</th>
			    	<th>구역명</th>
			    	<th>전체독자</th>
			    	<th>시작배달</th>
			    	<th>종료배달</th>
			    </tr>
			</table>
			<div style="width: 500px; overflow-y: scroll; overflow-x: none;  margin: 0 auto;">
			<table class="tb_list_a" style="width: 483px;">  
				<colgroup>
					<col width="50px">
					<col width="90px">
					<col width="90px">
					<col width="90px">
					<col width="90px">
					<col width="73px">
				</colgroup>
			    <c:forEach items="${deliveryList }" var="list" varStatus="i">
				    <tr>
				    	<td><input type="checkbox" id="print${i.index}" name="print${i.index}" value="${list.GNO }" style="border: 0;"></td>
						<td>${list.GNO }</td>
						<td>${list.GNM }</td>
						<td>${list.COUNT }</td>
						<td><input type="text" id="start${i.index }" name="start${i.index }" value="${list.MINBNO }" style="width: 95%"/></td>
						<td><input type="text" id="end${i.index }" name="end${i.index }" value="${list.MAXBNO }" style="width: 95%"/></td>
					</tr>
				</c:forEach>
			</table>
			</div>
		</div>
		<!-- //배달 리스트 -->
		<!-- check no1 -->
		<div style="float: left; padding: 0 10px; width: 155px; ">
			<div class="box_gray" style="width: 155px; height: 135px;">
				<div style="padding: 30px 0 0 10px;">
					<input type="checkbox" id="detailYn" name="detailYn"  value="Y"  onclick="changePrt()" style="border: 0; vertical-align: middle;"/> 자세히인쇄
				</div>
				<div style="padding: 10px 10px 10px 20px;">
					<input type="checkbox" id="reaNmYn" name="reaNmYn" value="Y" style="border: 0; vertical-align: middle;" /> 독자명출력
				</div>
				<div style="padding: 0 0 30px 20px; ">
					<div  id="Etable" style="display:none;">
						<input type="checkbox" id="remkYn" name="remkYn" value="Y" style="border: 0; vertical-align: middle;"/> 비고 출력
					</div>
				</div>
			</div>
			<br>
			<div class="box_gray" style="width: 155px; height: 125px;">
				<div style="text-align: center; padding-top: 35px">
					<img src="/images/bt_questdone.gif" style="border: 0; vertical-align: middle; cursor: pointer;" onclick="retrieveDeList();">
				</div>
				<div style="text-align: center; padding-top: 5px;">
					<img src="/images/bt_print02.gif" style="border: 0; vertical-align: middle; cursor: pointer;" onclick="print();">
				</div>
			</div>
		</div>
		<!-- //check no1 -->
		<!-- check no2 -->
		<div style="float: left; border: 0px solid; width: 340px;">
			<table class="tb_list_a" style="width: 340px;">  
				<colgroup>
					<col width="50px">
					<col width="150px">
					<col width="140px">
				</colgroup>
				<tr>
				    <th><input type="checkbox" id="checkNews" name="checkNews"  onclick="checkControll();" style="border: 0; vertical-align: middle;"> </th>
				    <th>신문명</th>
				    <th>코드</th>
			  	</tr>
			    <c:forEach items="${newSList }" var="list" varStatus="i">
				  	<tr>
				      	<td height="20"><input type="checkbox" id="newsCd${i.index}" name="newsCd${i.index}" value="${list.CODE }"  style="border: 0; vertical-align: middle;" <c:if test="${(newsCd[i.index] eq list.CODE) or (list.CODE eq '100')}">checked</c:if>></td>
				      	<td>${list.CNAME }</td>
				      	<td>${list.YNAME }</td>
				  	</tr>
				</c:forEach>
			</table>
		</div>
		<!-- //check no2 -->
	</div>
	<!-- //contents -->
</form>
			
				
			
					
		
