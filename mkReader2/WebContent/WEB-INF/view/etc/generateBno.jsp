<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<style>
#xlist {
	width: 100%;
	height: 500px;
	overflow-y: auto;
}
</style>
<SCRIPT LANGUAGE="JavaScript" src="/js/mini_calendar.js"></SCRIPT>
<script type="text/javascript" src="/js/ajaxUtil.js" charset="UTF-8"></script>

<script type="text/javascript">
	// 전체 선택/해지
	function checkControll(){
		//전체선택 1 , 전체해제 2
		var getObj = document.getElementsByTagName("input");
		var count = 0;
		if($("controll").checked == true){
			 for(var i=0; i < getObj.length; i++){
		        if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("boSeq") > -1 ){
		        	$("boSeq"+count).checked = true;
		        	count++;
		        }
		    }
		}else{
			for(var i=0; i < getObj.length; i++){
		        if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("boSeq") > -1 ){
		        	$("boSeq"+count).checked = false;
		        	count++;
		        }
		    }
		}
	}
	
	//실행
	function generateBno(){
		if(confirm('실행하시겠습니까?')==true){
			document.getElementById("progress").style.display  = 'block';
			var getObj = document.getElementsByTagName("input");
			var count = 0;
			for(var i=0; i < getObj.length; i++){
				if(getObj[i].type.toLowerCase() == "checkbox" && getObj[i].name.indexOf("boSeq") > -1 ){
					count++;
				}
			}
			$("boSeqSize").value = count;
			bnoForm.action="/etc/generateBno/generateBno.do";
			bnoForm.target="_self";
			bnoForm.submit();
		}
	}
	
	
</script>
<form id="bnoForm" name="bnoForm" action="" method="post">
<input type="hidden" id="boSeqSize" name="boSeqSize" value=""/>

<table width="100%" cellpadding="0" cellspacing="0"  border="0">
	<tr>
		<td colspan="2">					
			<table width="100%" cellpadding="0" cellspacing="0"  border="0">
				<tr>
					<td><B>배달번호 생성기</B></td>
				</tr>
				<tr>
					<td><input type="checkbox" id="controll" name="controll" checked onclick="javascript:checkControll();"> 전체 선택, 해제</td>
				</tr>
			</table>
		</td>
	</tr>
	<p style="margin-top:10px;">
	<tr>
		<td rowspan="">	
			<table width="100%" cellpadding="5" cellspacing="0" border="0" class="b_01">
				<tr>
					<td  valign="top">
						<div id="xlist">
							<table width="100%" border="0" cellpadding="5" cellspacing="1" bgcolor="e5e5e5" class="b_01">
								<tr bgcolor="f9f9f9" class="box_p"  align="center">
									<td width="15"></td>
									<td>지국코드</td>
									<td>지국명</td>
									<td>대상독자수</td>
								</tr>
								
								<c:forEach items="${agencyList }" var="list" varStatus="i">
								<tr bgcolor="ffffff"  align="center">
									<td><input type="checkbox" id="boSeq${i.index }" name="boSeq${i.index }" value="${list.BOSEQ }" checked/></td>
									<td>${list.BOSEQ }</td>
									<td>${list.BONM }</td>
									<td>${list.CNT }</td>
								</tr>
								</c:forEach>									
							</table>
						</div>
					</td>
				</tr>
			</table>
		</td>
		<td valign="top">
			<table width="100%" cellpadding="5" cellspacing="0" border="0" class="b_01">
				<tr>
					<td width="40%">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td width="10"></td>
							</tr>
							<tr height="50"><td colspan="3" align="center">
							</td></tr>
							<tr >
								<td colspan="3">
								<a href="javascript:generateBno();"><img src="/images/bt_sil.gif" border="0" align="right"></a>
								</td>
							</tr>
							<tr>
								<td align="center" colspan="3">
									<div id="progress" style="display:none">
										<img src="/images/progress.gif" ><br>
										잠시만 기다리십시오.<br>처리 중 입니다.
									</div>
								<td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>			
	</tr>
</table> 
</form>