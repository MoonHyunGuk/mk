<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<head>
<link rel='stylesheet' type='text/css' href='/css/mkcrm.css'>
<style>
#xlist {
	width: 100%;
	height: 190px;
	overflow-y: auto;
}
</style>
<SCRIPT LANGUAGE="JavaScript" src="/js/mini_calendar.js"></SCRIPT>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript">
	function searchMinwon(){
		
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
		$("sdate").value = tempSdate[0] + tempSdate[1]+ tempSdate[2];
		$("edate").value = tempEdate[0] + tempEdate[1]+ tempEdate[2];
		
		minwonForm.action="/reader/minwon/minwon.do";
		minwonForm.target="_self";
		minwonForm.submit();
	}
	function setMinwon(aplcNo , aplcDt , aplcTypeCd , titl , cont , stdt , etdt , readNm , homeTel , mobile , readNo , dlvAdrs , recpRemk , boRemk){
		$("aplcNo").value = aplcNo;
		$("aplcDt").value = aplcDt;
		$("aplcTypeCd").value = aplcTypeCd;
		if(aplcTypeCd == '001'){
			$("aplcTypeNm").value = "불배";
		}else if(aplcTypeCd == '002'){
			$("aplcTypeNm").value = "이전";
		}else if(aplcTypeCd == '003'){
			$("aplcTypeNm").value = "휴독";
		}else if(aplcTypeCd == '004'){
			$("aplcTypeNm").value = "해지";
		}else{
			$("aplcTypeNm").value = "기타";
		}
		$("titl").value = titl ;
		$("cont").value = cont ;
		if(aplcTypeCd == '003'){
			$("stdt").value = stdt ;
			$("etdt").value = etdt ;
		}
		$("readNm").value = readNm ;
		$("homeTel").value = homeTel ;
		$("mobile").value = mobile ;
		$("readNo").value = readNo ;
		$("dlvAdrs").value = dlvAdrs ;
		$("recpRemk").value = recpRemk ;
		$("boRemk").value = boRemk ;
		
	}
	function saveMinwon(){
		if($("boRemk").value == ''){
			alert('처리내용을 적어주세요.');
			$("boRemk").focus();
			return;
		}
		if( checkBytes($("boRemk").value) > 100){
			alert("독자비고는 100byte를 초과할수 없습니다.");
			$("boRemk").focus();
			return;
		}
		minwonForm.action = "/reader/minwon/actionMinwon.do";
		minwonForm.target="_self";
		minwonForm.submit();
		self.close();
	}
	//바이트 계산 function
	function checkBytes(expression ){
	 	var form = $("searchForm");
	 	var VLength=0;
	 	var temp = expression;
	 	var EscTemp;
	 	if(temp!="" & temp !=null) {
	 		for(var i=0;i<temp.length;i++){
	 			if (temp.charAt(i)!=escape(temp.charAt(i))){
	 				EscTemp=escape(temp.charAt(i));
 					if (EscTemp.length>=6){
 						VLength+=2;
 					}else{
 						VLength+=1;
 					}
 				}else{
 					VLength+=1;
 				}
 			}
 		}

 		return VLength;
 	}
</script>
</head>
<form id="minwonForm" name="minwonForm" action="" method="post">
	<input type=hidden id="pageNo" name="pageNo" value="${param.pageNo}" />
	<input type=hidden id="sdate" name="sdate" value="" />
	<input type=hidden id="edate" name="edate" value="" />
	<input type="hidden" id="aplcNo" name="aplcNo" value="" class='box_n'/>
	<input type="hidden" id="aplcTypeCd" name="aplcTypeCd" value="" class='box_n'/>
	
	<table width="98%" cellpadding="0" cellspacing="1" border="0">
	<tr>
		<td width="100%" valign="top">
			<p style="top-margin: 10px;">
				<table width="100%" cellpadding="5" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
					<tr bgcolor="ffffff">
						<td align="center" bgcolor="f9f9f9">
							<font class="b02">불편유형</font>&nbsp;&nbsp;&nbsp;
						</td>
						<td bgcolor="ffffff"  align="center">
							<select name="minGb" id="minGb" >
								<option value="" <c:if test="${param.minGb eq ''}"> selected </c:if> >전체</option>
								<option value="002" <c:if test="${param.minGb eq '002'}"> selected </c:if>>이전</option>
								<option value="003" <c:if test="${param.minGb eq '003'}"> selected </c:if>>휴독</option>
								<option value="004" <c:if test="${param.minGb eq '004'}"> selected </c:if>>해지</option>
								<option value="005" <c:if test="${param.minGb eq '005'}"> selected </c:if>>기타</option>
							</select>
						</td>
						<td  align="center" bgcolor="f9f9f9">
							<font class="b02" >접수일자</font>
						</td>
						<td bgcolor="ffffff" colspan="2"  align="center">
							<c:choose>
							<c:when test="${empty param.sdate && empty param.edate}">
								<input type="text" size="10" id="tempSdate" name="tempSdate" value="<c:out value='${sdate}' />" readonly onclick="Calendar(this)">~
								<input type="text" size="10" id="tempEdate" name="tempEdate" value="<c:out value='${edate}' />" readonly onclick="Calendar(this)">
							</c:when>
							<c:otherwise>
								<input type="text" size="10" id="tempSdate" name="tempSdate" value="<c:out value='${fn:substring(param.sdate,0,4)}-${fn:substring(param.sdate,4,6)}-${fn:substring(param.sdate,6,8)}' />" readonly onclick="Calendar(this)">~
								<input type="text" size="10" id="tempEdate" name="tempEdate" value="<c:out value='${fn:substring(param.edate,0,4)}-${fn:substring(param.edate,4,6)}-${fn:substring(param.edate,6,8)}' />" readonly onclick="Calendar(this)">
							</c:otherwise>
							</c:choose>
						</td>
						<td  align="center" bgcolor="f9f9f9">
							<font class="b02" >처리상태</font>
						</td>
						<td bgcolor="ffffff"  align="center">
							<select name="isCheck" id="isCheck" >
								<option value=""  <c:if test="${param.isCheck eq ''}"> selected </c:if>>전체</option>
								<option value="1" <c:if test="${param.isCheck eq '1'}"> selected </c:if>>확인</option>
								<option value="2" <c:if test="${param.isCheck eq '2'}"> selected </c:if>>미확인</option>
							</select>
						</td>
						<td bgcolor="ffffff"  align="center">
							<a href="javascript:searchMinwon();"><img src="/images/bt_search.gif" border="0" align="absmiddle"></a>
						</td>
					</tr>
					<tr>
						<td colspan="8" rowspan="4" align="center" bgcolor="ffffff">
							<!--통합 내용출력자리-->
							<div id="xlist">
								<table width="100%" cellpadding="5" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
									<tr bgcolor="ffffff">
										<td align="center" width="5%"><font class="b02">순번</font></td>
										<td align="center" width="10%"><font class="b02">신청일자</font></td>
										<td align="center" width="10%"><font class="b02">신청유형</font></td>
										<td align="center" width="20%"><font class="b02">제목</font></td>
										<td align="center" width="45%"><font class="b02">내용</font></td>
										<td align="center" width="10%"><font class="b02">처리상태</font></td>
									</tr>
									<c:forEach items="${minwonList }" varStatus="i" var="list">
									<tr bgcolor="ffffff" onclick="javascript:setMinwon('${list.APLCNO}', '${list.APLCDT}', '${list.APLCTYPECD }', '${list.TITL }', '${list.CONT }', '${list.STDT }', '${list.ETDT }', '${list.READNM }', '${list.HOMETEL1}${list.HOMETEL2}${list.HOMETEL3 }', '${list.MOBILE1}${list.MOBILE2}${list.MOBILE3 }', '${list.READNO}', '${list.DLVADRS1} ${list.DLVADRS2}', '${list.RECP_REMK}', '${list.BO_REMK}');" style="cursor:hand;">
										<td height="3">${i.index + 1}</td>
										<td height="3">${list.APLCDT }</td>
										<td height="3">
										<c:choose>
											<c:when test="${list.APLCTYPECD eq '001'}">
												불배
											</c:when>
											<c:when test="${list.APLCTYPECD eq '002'}">
												이전
											</c:when>
											<c:when test="${list.APLCTYPECD eq '003'}">
												휴독
											</c:when>
											<c:when test="${list.APLCTYPECD eq '004'}">
												해지
											</c:when>
											<c:otherwise>
												기타
											</c:otherwise>
										</c:choose>
										</td>
										<td height="3">${list.TITL }</td>
										<td height="3">${list.CONT }</td>
										<td height="3">
										<font class="b02"><font class="b03">
										<c:choose>
											<c:when test="${list.BO_CNFMYN eq '1'}">
												확인
											</c:when>
											<c:otherwise>
												미확인
											</c:otherwise>
										</c:choose>
										</font></font>
										</td>
									</tr>
									</c:forEach>
								</table>
							</div>
						</td>
					</tr>
				</table>
		</td>
	</tr>
	</table>
	<p style="top-margin: 10px;">
	<table width="98%" cellpadding="5" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
		<tr bgcolor="ffffff">
			<td bgcolor="f9f9f9"  align="center"><font class="b02">접수일자</font></td>
			<td >
				<input type="text" id="aplcDt" name="aplcDt" readonly class='box_n'/>
			</td>
			<td   bgcolor="f9f9f9" align="center"><font class="b02">불편유형</font></td>
			<td >
				<input type="text" id="aplcTypeNm" name="aplcTypeNm" readnoly class='box_n'/>	<!-- 신청유형 001 불배, 002 이전,  003 휴독, 004 해지, 999 기타-->
			</td>
			<td  bgcolor="f9f9f9" align="center"><font class="b02">제목</font></td>
			<td  colspan="3">
				<input type="text" id="titl" name="titl" readnoly class='box_n'/>
			</td>
		</tr>
		<tr bgcolor="ffffff">
			<td bgcolor="f9f9f9" rowspan="2" align="center"><font class="b02">내용</td>
			<td colspan="5" rowspan="2">
				<textarea id="cont" name="cont" readnoly style="height:80px; width:100%; overflow:hidden" > </textarea>
			</td>
			<td bgcolor="f9f9f9" align="center"><font class="b02">휴독시작</td>
			<td>
				<input type="text" id="stdt" name="stdt" readnoly class='box_n'/>
			</td>
		</tr>
		<tr bgcolor="ffffff">
			<td bgcolor="f9f9f9" align="center"><font class="b02">휴독종료</td>
				<td align="center">
					<input type="text" id="etdt" name="etdt" readnoly class='box_n'/>
				</td>
		</tr>
		<tr bgcolor="ffffff">
			<td bgcolor="f9f9f9" align="center" width="10%"><font class="b02">독자명</td>
			<td width="15%">
				<input type="text" id="readNm" name="readNm" readnoly class='box_n'/>
			</td>
			<td bgcolor="f9f9f9" align="center" width="10%"><font class="b02">전화번호</td>
			<td width="15%">
				<input type="text" id="homeTel" name="homeTel" readnoly class='box_n'/>
			</td>
			<td bgcolor="f9f9f9" align="center" width="10%"><font class="b02">휴대폰</td>
			<td width="15%">
				<input type="text" id="mobile" name="mobile" readnoly class='box_n'/>
			</td>
			<td bgcolor="f9f9f9" align="center" width="10%"><font class="b02">독자번호</td>
			<td width="15%">
				<input type="text" id="readNo" name="readNo" readnoly class='box_n'/>
			</td>
		</tr>
		<tr bgcolor="ffffff">
			<td bgcolor="f9f9f9" align="center"><font class="b02">주소</td>
			<td colspan="7">
				<input type="text" id="dlvAdrs" name="dlvAdrs" readnoly class='box_n'/>
			</td>
		</tr>
		<tr bgcolor="ffffff">
			<td bgcolor="f9f9f9" align="center" ><font class="b02">접수자 비고</td>
			<td colspan="7">				
				<textarea id="recpRemk" name="recpRemk" readonly style="height:50px; width:100%; overflow:hidden"> </textarea>
			</td>
		</tr>
		<tr bgcolor="ffffff">
			<td bgcolor="f9f9f9" align="center" ><font class="b02">처리내용</td>
			<td colspan="7">
				<textarea id="boRemk" name="boRemk" style="height:50px; width:100%; overflow:hidden"></textarea>
			</td>
		</tr>
		<tr bgcolor="ffffff">
			<td align="right"  colspan="8"><font class="b02">
				<a href="javascript:saveMinwon();"><img src="/images/bt_save.gif" border="0" align="absmiddle"></a>&nbsp;&nbsp;
				<a href="javascript:self.close()"><img src="/images/bt_cancle.gif" border="0" align="absmiddle"></a>
			</td>
					
		</tr>
	</table>
</form>

<script type="text/javascript">
 	 window.resizeTo(880, 700);
</script>