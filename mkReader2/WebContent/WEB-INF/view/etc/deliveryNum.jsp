<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<style>
#xlist {
	width: 100%;
	height: 450px;
	overflow-y: auto;
}
</style>
<script type="text/javascript"  src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/ajaxUtil.js"></script>
<script type="text/javascript">
	// 배달번호 조정 구역코드 전체 선택/해지
	function checkControll(){
		//전체선택 1 , 전체해제 2
		var getObj = document.getElementsByTagName("input");
		var count = 0;
		if($("controll").checked == true){
			 for(var i=0; i < getObj.length; i++){
		        if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("gno") > -1 ){
		        	$("gno"+count).checked = true;
		        	count++;
		        }
		    }
		}else{
			for(var i=0; i < getObj.length; i++){
		        if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("gno") > -1 ){
		        	$("gno"+count).checked = false;
		        	count++;
		        }
		    }
		}
	}
	//배달 번호 정렬
	function sort(){
		var getObj = document.getElementsByTagName("input");
		var count = 0;
		for(var i=0; i < getObj.length; i++){
			if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("gno") > -1 ){
				count++;
			}
		}
		$("gnoSize").value = count;
		deliveryNumForm.action="/etc/deliveryNumSort/deliveryNumSort.do";
		deliveryNumForm.target="_self";
		deliveryNumForm.submit();
	}
</script>
<div><span class="subTitle">배달번호정렬</span></div>
<form id="deliveryNumForm" name="deliveryNumForm" action="" method="post">
<input type="hidden" id="gnoSize" name="gnoSize"/>
<div style="width: 1020px; overflow: hidden; margin: 0 auto;">
	<!-- button -->
	<div style="width: 500px; overflow: hidden; border: 0px solid red; padding: 5px 0 10px 0;">
		<div style="float: left; width: 250px; text-align: left;">
			<input type="checkbox" id="controll" name="controll" checked onclick="checkControll();" style="border: 0; vertical-align: middle;"> 선택, 해제 
		</div>
		<div style="float: left; width: 250px; text-align: right">
			<a href="#fakeUrl" onclick="sort();"><img src="/images/bt_numjo.gif"  style="border: 0; vertical-align: middle;"></a>
		</div>
	</div>
	<!-- button -->
	<!-- list -->
	<div style="width: 500px;">
		<table class="tb_list_a" style="width: 500px">
			<colgroup>
				<col width="35px">
				<col width="155px">
				<col width="155px">
				<col width="155px">
			</colgroup>
			<tr>
				<th></th>
				<th>조정</th>
				<th>구역코드</th>
				<th>배달조정</th>
			</tr>
		</table>
		<div style="height: 450px; overflow-y: scroll; width: 500px; margin: 0 auto;">
		<table class="tb_list_a" style="width: 483px">
			<colgroup>
				<col width="35px">
				<col width="155px">
				<col width="155px">
				<col width="138px">
			</colgroup>
			<c:forEach items="${gnoList }" var="list" varStatus="i">
				<tr>
					<td>${i.index +1}</td>
					<c:choose>
						<c:when test="${not empty gno }">
							<td>
								<input type="checkbox" id="gno${i.index }" name="gno${i.index }" value="${list.GNO }"  style="border: 0" <c:if test="${gno[i.index][0] eq list.GNO }"> checked </c:if> >
							</td>
						</c:when>
						<c:otherwise>
							<td>
								<input type="checkbox" id="gno${i.index }" name="gno${i.index }" value="${list.GNO }" checked style="border: 0" >
							</td>
						</c:otherwise>
					</c:choose>
					<td>${list.GNO }</td>
					<td>${gno[i.index][1] }</td>
				</tr>		
			</c:forEach>																																																																						
		</table>
	</div>
	</div>
	<!-- //list -->
</div>
</form>
