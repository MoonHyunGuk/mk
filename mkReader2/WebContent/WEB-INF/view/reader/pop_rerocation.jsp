<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<head>
<script type="text/javascript" src="/js/ajaxUtil.js" charset="UTF-8"></script>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<link rel='stylesheet' type='text/css' href='/css/mkcrm.css'>
<style>
#xlist {
	width: 100%;
	height: 190px;
	overflow-y: auto;
}
</style>
<script type="text/javascript">
	//이전 민원 검색
	function search(){
		rerocationForm.target="_self";
		rerocationForm.action ="/reader/minwon/rerocation.do";
		rerocationForm.submit();
	}
	
	//이전 데이터 보기
	function setRerocation(index){
		$("aoSeq").value = document.getElementById('tem_AO_BOSEQ'+index).innerHTML;
		$("boSeq").value = document.getElementById('tem_BO_BOSEQ'+index).innerHTML;
		$("regNo").value = document.getElementById('tem_REGNO'+index).innerHTML;
		$("readNo").value = document.getElementById('tem_READNO'+index).innerHTML;
		$("newsCd").value = document.getElementById('tem_NEWSCD'+index).innerHTML;
		$("aoName").value = document.getElementById('tem_AO_BONAME'+index).innerHTML;
		$("boName").value = document.getElementById('tem_BO_BONAME'+index).innerHTML; 
		$("boHomeTel1").value = document.getElementById('tem_BO_HOMETEL1'+index).innerHTML;
		$("boHomeTel2").value = document.getElementById('tem_BO_HOMETEL2'+index).innerHTML;
		$("boHomeTel3").value = document.getElementById('tem_BO_HOMETEL3'+index).innerHTML;
		$("boZip").value = document.getElementById('tem_BO_ZIP'+index).innerHTML;
		$("regDt").value = document.getElementById('tem_REGDT'+index).innerHTML;
		$("boAdrs1").value = document.getElementById('tem_BO_ADRS1'+index).innerHTML;
		$("boAdrs2").value = document.getElementById('tem_BO_ADRS2'+index).innerHTML;
		$("boOffNm").value = document.getElementById('tem_BO_OFFNM'+index).innerHTML;
		$("readNm").value = document.getElementById('tem_READNM'+index).innerHTML;
		$("boMobile1").value = document.getElementById('tem_BO_MOBILE1'+index).innerHTML;
		$("boMobile2").value = document.getElementById('tem_BO_MOBILE2'+index).innerHTML;
		$("boMobile3").value = document.getElementById('tem_BO_MOBILE3'+index).innerHTML;
		$("moveDt").value = document.getElementById('tem_MOVEDT'+index).innerHTML;
		$("boQty").value = document.getElementById('tem_BO_QTY'+index).innerHTML;
		$("boMsg").value = document.getElementById('tem_BO_MSG'+index).innerHTML;
		
		$("aoHomeTel1").value = document.getElementById('tem_AO_HOMETEL1'+index).innerHTML;
		$("aoHomeTel2").value = document.getElementById('tem_AO_HOMETEL2'+index).innerHTML;
		$("aoHomeTel3").value = document.getElementById('tem_AO_HOMETEL3'+index).innerHTML;
		$("dlvHpDt").value = document.getElementById('tem_DLVHPDT'+index).innerHTML;
		$("stbgMm").value = document.getElementById('tem_STBGMM'+index).innerHTML;
		$("aoZip").value = document.getElementById('tem_AO_ZIP'+index).innerHTML;
		$("aoMobile1").value = document.getElementById('tem_AO_MOBILE1'+index).innerHTML;
		$("aoMobile2").value = document.getElementById('tem_AO_MOBILE2'+index).innerHTML;
		$("aoMobile3").value = document.getElementById('tem_AO_MOBILE3'+index).innerHTML;
		$("aoAdrs1").value = document.getElementById('tem_AO_ADRS1'+index).innerHTML;
		$("aoAdrs2").value = document.getElementById('tem_AO_ADRS2'+index).innerHTML;
		$("aoOffNm").value = document.getElementById('tem_AO_OFFNM'+index).innerHTML;
		$("aoQty").value = document.getElementById('tem_AO_QTY'+index).innerHTML;
		$("aoMsg").value = document.getElementById('tem_AO_MSG'+index).innerHTML;
		if(document.getElementById('tem_AO_CNFM_STAT'+index).innerHTML == ''){
			$("aoCnfmStat").value = '10';	
			$("aoCnfmStatNm").value = '미확인';
		}else{
			$("aoCnfmStat").value = document.getElementById('tem_AO_CNFM_STAT'+index).innerHTML;
			if($("aoCnfmStat").value == '10'){
				$("aoCnfmStatNm").value = '미확인';	
			}else if($("aoCnfmStat").value == '20'){
				$("aoCnfmStatNm").value = '확인';	
			}else if($("aoCnfmStat").value == '30'){
				$("aoCnfmStatNm").value = '거절';	
			} 
		}
		
		
		$("aoCnfmDt").value = document.getElementById('tem_AO_CNFM_DT'+index).innerHTML;
		$("boCnfmDt").value = document.getElementById('tem_BO_CNFM_DT'+index).innerHTML;
	}
	//신규등록
	function saveRerocation(){
		if($("boName").value ==''){
			alert('이사전 지국명을 입력해주세요');
			$("boName").focus();
			return;
		}
		if($("aoName").value ==''){
			alert('이사후 지국명을 입력해주세요');
			$("boName").focus();
			return;
		}
		if($("boQty").value ==''){
			alert('이전부수를 입력해주세요');
			$("boSeq").focus();
			return;
		}
		if($("aoQty").value ==''){
			alert('인수부수를 입력해주세요');
			$("aoSeq").focus();
			return;
		}
		
		rerocationForm.target="_self";
		rerocationForm.action ="/reader/minwon/saveRerocation.do";
		rerocationForm.submit();
	}
	//수정
	function update(gbn){
		//gbn  1.인수거절 2.이전처리 3.인수거절 4.인수처리
		if(gbn == 1 || gbn == 2){
			if($("boSeq").value != $("agency_serial").value ){
				alert("이전 작업은 인수 지국에서만 가능합니다.");
				return;
			}
		}
		if(gbn == 3 || gbn == 4){
			if($("aoSeq").value != $("agency_serial").value ){
				alert("인수 작업은 인수 지국에서만 가능합니다.");
				return;
			}
		}
		
		if($("boName").value ==''){
			alert('이사전 지국명을 입력해주세요');
			$("boName").focus();
			return;
		}
		if($("aoName").value ==''){
			alert('이사후 지국명을 입력해주세요');
			$("boName").focus();
			return;
		}
		if($("boSeq").value ==''){
			alert('이전부수를 입력해주세요');
			$("boSeq").focus();
			return;
		}
		if($("aoSeq").value ==''){
			alert('인수부수를 입력해주세요');
			$("aoSeq").focus();
			return;
		}
		$("gbn").value = gbn;
		rerocationForm.target="_self";
		rerocationForm.action ="/reader/minwon/updateRerocation.do";
		rerocationForm.submit();
	}
	//우편주소 팝업
	function popAddr(cmd){
		var left = (screen.width)?(screen.width - 1330)/2 : 10;
		var top = (screen.height)?(screen.height - 200)/2 : 10;
		var winStyle = "width=400,height=500,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		var newWin = window.open("", "pop_addr", winStyle);
		rerocationForm.target = "pop_addr";
		rerocationForm.action = "/reader/readerManage/popAddr.do?cmd="+cmd;
		rerocationForm.submit();
	}
	//우편주소팝업에서 우편주소 선택시 셋팅 펑션
	function setAddr(zip , addr , jikuk , jiSerial , cmd){
		
		if(cmd == '2'){
			$("boZip").value = zip;
			$("boAdrs1").value = addr;
			$("boName").value = jikuk;
			$("boSeq").value = jiSerial;	
		}else if(cmd == '3'){
			$("aoZip").value = zip;
			$("aoAdrs1").value = addr;
			$("aoName").value = jikuk;
			$("aoSeq").value = jiSerial;	
		}
		
	}
	//숫자만 입력 가능하도록 체크 키 다운시
	function inputNumCom(){
		var keycode = event.keyCode;
		 
		if ((event.keyCode<48) || (event.keyCode>57)){
			alert("숫자만 입력 가능합니다.");
			event.keyCode = 0;  // 이벤트 cancel
		}
	}
</script>

<form id="rerocationForm" name="rerocationForm" action="" method="post">
	<input type="hidden" id="regNo" name="regNo" />
	<input type="hidden" id="readNo" name="readNo" />
	<input type="hidden" id="newsCd" name="newsCd" />
	<input type="hidden" id="boSeq" name="boSeq" />
	<input type="hidden" id="aoSeq" name="aoSeq" />
	<input type="hidden" id="agency_serial" name="agency_serial" value="${agency_serial }"/>
	<input type="hidden" id="gbn" name="gbn" />
	<table width="98%" cellpadding="0" cellspacing="1" border="0">
		<tr>
			<td width="100%" valign="top">
				<p style="top-margin: 10px;">
					<table width="100%" cellpadding="5" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
						<tr bgcolor="ffffff">
							<td align="center" bgcolor="f9f9f9">
								<font class="b02">이전확인상태</font>&nbsp;&nbsp;&nbsp;
							</td>
							<td bgcolor="ffffff"  align="center">
								<select name="boCnfmStat" id="boCnfmStat" >
									<option value="40" <c:if test="${param.boCnfmStat eq '40'}">selected</c:if>>전체</option>
									<option value="20" <c:if test="${param.boCnfmStat eq '20'}">selected</c:if>>확인</option>
									<option value="10" <c:if test="${param.boCnfmStat eq '10' ||param.boCnfmStat eq '' }">selected</c:if>>미확인</option>
									<option value="30" <c:if test="${param.boCnfmStat eq '30'}">selected</c:if>>거절</option>
								</select>
							</td>
							<td  align="center" bgcolor="f9f9f9">
								<font class="b02" >인수확인상태</font>
							</td>
							<td bgcolor="ffffff" align="center">
								<select name="aoCnfmStat" id="aoCnfmStat" >
									<option value="40" <c:if test="${param.aoCnfmStat eq '40'}">selected</c:if>>전체</option>
									<option value="20" <c:if test="${param.aoCnfmStat eq '20'}">selected</c:if>>확인</option>
									<option value="10" <c:if test="${param.aoCnfmStat eq '10' || param.aoCnfmStat eq ''}">selected</c:if>>미확인</option>
									<option value="30" <c:if test="${param.aoCnfmStat eq '30'}">selected</c:if>>거절</option>
								</select>
							</td>
							<td bgcolor="ffffff"  align="center">
								<a href="javascript:search();"><img src="/images/bt_search.gif" border="0" align="absmiddle"></a>
							</td>
						</tr>
						<tr>
							<td colspan="5" rowspan="0" align="center" bgcolor="ffffff">
								<!--통합 내용출력자리-->
								<div id="xlist">
									<table width="100%" cellpadding="5" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
										<tr bgcolor="ffffff">
											<td align="center" width="11%"><font class="b02">순번</font></td>
											<td align="center" width="13%"><font class="b02">등록일자</font></td>
											<td align="center" width="13%"><font class="b02">이사일자</font></td>
											<td align="center" width="13%"><font class="b02">독자명</font></td>
											<td align="center" width="13%"><font class="b02">이사전지국</font></td>
											<td align="center" width="13%"><font class="b02">이사후지국</font></td>
											<td align="center" width="13%"><font class="b02">이전확인상태</font></td>
											<td align="center" width="13%"><font class="b02">인수확인상태</font></td>
										</tr>
										<c:forEach items="${rerocationList }" varStatus="i" var="list">
										<span id="tem_REGDT${i.index}" name="tem_REGDT${i.index}" style="display:none">${list.REGDT}</span>
										<span id="tem_BO_BONAME${i.index}" name="tem_BO_BONAME${i.index}" style="display:none">${list.BO_BONAME}</span>
										<span id="tem_AO_BONAME${i.index}" name="tem_AO_BONAME${i.index}" style="display:none">${list.AO_BONAME}</span>                        
										<span id="tem_REGNO${i.index}" name="tem_REGNO${i.index}" style="display:none">${list.REGNO}</span>                        
										<span id="tem_MOVEDT${i.index}" name="tem_MOVEDT${i.index}" style="display:none">${list.MOVEDT}</span>                     
										<span id="tem_DLVHPDT${i.index}" name="tem_DLVHPDT${i.index}" style="display:none">${list.DLVHPDT}</span>                  
										<span id="tem_STBGMM${i.index}" name="tem_STBGMM${i.index}" style="display:none">${list.STBGMM}</span>                     
										<span id="tem_READNO${i.index}" name="tem_READNO${i.index}" style="display:none">${list.READNO}</span>                     
										<span id="tem_NEWSCD${i.index}" name="tem_NEWSCD${i.index}" style="display:none">${list.NEWSCD}</span>                     
										<span id="tem_READNM${i.index}" name="tem_READNM${i.index}" style="display:none">${list.READNM}</span>                     
										<span id="tem_BO_BOSEQ${i.index}" name="tem_BO_BOSEQ${i.index}" style="display:none">${list.BO_BOSEQ}</span>               
										<span id="tem_AO_BOSEQ${i.index}" name="tem_AO_BOSEQ${i.index}" style="display:none">${list.AO_BOSEQ}</span>               
										<span id="tem_BO_ZIP${i.index}" name="tem_BO_ZIP${i.index}" style="display:none">${list.BO_ZIP}</span>                     
										<span id="tem_BO_ADRS1${i.index}" name="tem_BO_ADRS1${i.index}" style="display:none">${list.BO_ADRS1}</span>               
										<span id="tem_BO_ADRS2${i.index}" name="tem_BO_ADRS2${i.index}" style="display:none">${list.BO_ADRS2}</span>               
										<span id="tem_BO_OFFNM${i.index}" name="tem_BO_OFFNM${i.index}" style="display:none">${list.BO_OFFNM}</span>               
										<span id="tem_BO_HOMETEL1${i.index}" name="tem_BO_HOMETEL1${i.index}" style="display:none">${list.BO_HOMETEL1}</span>      
										<span id="tem_BO_HOMETEL2${i.index}" name="tem_BO_HOMETEL2${i.index}" style="display:none">${list.BO_HOMETEL2}</span>      
										<span id="tem_BO_HOMETEL3${i.index}" name="tem_BO_HOMETEL3${i.index}" style="display:none">${list.BO_HOMETEL3}</span>      
										<span id="tem_BO_MOBILE1${i.index}" name="tem_BO_MOBILE1${i.index}" style="display:none">${list.BO_MOBILE1}</span>         
										<span id="tem_BO_MOBILE2${i.index}" name="tem_BO_MOBILE2${i.index}" style="display:none">${list.BO_MOBILE2}</span>         
										<span id="tem_BO_MOBILE3${i.index}" name="tem_BO_MOBILE3${i.index}" style="display:none">${list.BO_MOBILE3}</span>         
										<span id="tem_AO_ZIP${i.index}" name="tem_AO_ZIP${i.index}" style="display:none">${list.AO_ZIP}</span>                     
										<span id="tem_AO_ADRS1${i.index}" name="tem_AO_ADRS1${i.index}" style="display:none">${list.AO_ADRS1}</span>               
										<span id="tem_AO_ADRS2${i.index}" name="tem_AO_ADRS2${i.index}" style="display:none">${list.AO_ADRS2}</span>               
										<span id="tem_AO_OFFNM${i.index}" name="tem_AO_OFFNM${i.index}" style="display:none">${list.AO_OFFNM}</span>               
										<span id="tem_AO_HOMETEL1${i.index}" name="tem_AO_HOMETEL1${i.index}" style="display:none">${list.AO_HOMETEL1}</span>      
										<span id="tem_AO_HOMETEL2${i.index}" name="tem_AO_HOMETEL2${i.index}" style="display:none">${list.AO_HOMETEL2}</span>      
										<span id="tem_AO_HOMETEL3${i.index}" name="tem_AO_HOMETEL3${i.index}" style="display:none">${list.AO_HOMETEL3}</span>      
										<span id="tem_AO_MOBILE1${i.index}" name="tem_AO_MOBILE1${i.index}" style="display:none">${list.AO_MOBILE1}</span>         
										<span id="tem_AO_MOBILE2${i.index}" name="tem_AO_MOBILE2${i.index}" style="display:none">${list.AO_MOBILE2}</span>         
										<span id="tem_AO_MOBILE3${i.index}" name="tem_AO_MOBILE3${i.index}" style="display:none">${list.AO_MOBILE3}</span>         
										<span id="tem_BO_CNFM_STAT${i.index}" name="tem_BO_CNFM_STAT${i.index}" style="display:none">${list.BO_CNFM_STAT}</span>   
										<span id="tem_BO_CNFM_DT${i.index}" name="tem_BO_CNFM_DT${i.index}" style="display:none">${list.BO_CNFM_DT}</span>         
										<span id="tem_BO_MSG${i.index}" name="tem_BO_MSG${i.index}" style="display:none">${list.BO_MSG}</span>                     
										<span id="tem_AO_CNFM_STAT${i.index}" name="tem_AO_CNFM_STAT${i.index}" style="display:none">${list.AO_CNFM_STAT}</span>   
										<span id="tem_AO_CNFM_DT${i.index}" name="tem_AO_CNFM_DT${i.index}" style="display:none">${list.AO_CNFM_DT}</span>         
										<span id="tem_AO_MSG${i.index}" name="tem_AO_MSG${i.index}" style="display:none">${list.AO_MSG}</span>                     
										<span id="tem_DELYN${i.index}" name="tem_DELYN${i.index}" style="display:none">${list.DELYN}</span>                        
										<span id="tem_REMK${i.index}" name="tem_REMK${i.index}" style="display:none">${list.REMK}</span>                        
										<span id="tem_INDT${i.index}" name="tem_INDT${i.index}" style="display:none">${list.INDT}</span>                         
										<span id="tem_INPS${i.index}" name="tem_INPS${i.index}" style="display:none">${list.INPS}</span>                          
										<span id="tem_CHGDT${i.index}" name="tem_CHGDT${i.index}" style="display:none">${list.CHGDT}</span>                        
										<span id="tem_CHGPS${i.index}" name="tem_CHGPS${i.index}" style="display:none">${list.CHGPS}</span>                        
										<span id="tem_BO_QTY${i.index}" name="tem_BO_QTY${i.index}" style="display:none">${list.BO_QTY}</span>
										<span id="tem_AO_QTY${i.index}" name="tem_AO_QTY${i.index}" style="display:none">${list.AO_QTY}</span>                         	
																			
										<tr bgcolor="ffffff" onclick="javascript:setRerocation(${i.index});" style="cursor:hand;">
											<td height="3">${i.index  + 1}</td>
											<td height="3">${list.REGDT }</td>
											<td height="3">${list.MOVEDT }</td>
											<td height="3">${list.READNM }</td>
											<td height="3">${list.BO_BONAME }</td>
											<td height="3">${list.AO_BONAME }</td>
											<c:choose>
												<c:when test="${list.BO_CNFM_STAT eq '20'}">
												<td height="3">확인</td>
												</c:when>
												<c:when test="${list.BO_CNFM_STAT eq '30'}">
												<td height="3">거절</td>
												</c:when>
												<c:when test="${list.BO_CNFM_STAT eq '10'}">
												<td height="3">미확인</td>
												</c:when>
												<c:otherwise>
												<td height="3">미확인</td>
												</c:otherwise>
											</c:choose>
											<c:choose>
												<c:when test="${list.AO_CNFM_STAT eq '20'}">
												<td height="3">확인</td>
												</c:when>
												<c:when test="${list.AO_CNFM_STAT eq '30'}">
												<td height="3">거절</td>
												</c:when>
												<c:when test="${list.AO_CNFM_STAT eq '10'}">
												<td height="3">미확인</td>
												</c:when>
												<c:otherwise>
												<td height="3">미확인</td>
												</c:otherwise>
											</c:choose>
										</tr>
										</c:forEach>
									</table>
								</div>
							</td>
						</tr>
					</table>
				</p>
			</td>
		</tr>
	</table>
	<p style="top-margin: 10px;">
	<table width="98%" cellpadding="3" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
		<tr>
			<td>
				<table width="100%" cellpadding="3" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
					<tr bgcolor="ffffff">
						<td bgcolor="f9f9f9" align="left" colspan="4"><font class="b02">이사전 정보</font></td>
					</tr>
					<tr bgcolor="ffffff">
						<td bgcolor="f9f9f9" width="20%" align="center"><font class="b02">지국명</font></td>
						<td width="30%">
							<input type="text" id="boName" name="boName" value="" class="box_n" readOnly/>
						</td>
						<td bgcolor="f9f9f9" width="20%" align="center"><font class="b02">전화번호</font></td>
						<td >
							<select id="boHomeTel1" name="boHomeTel1">
							<c:forEach items="${areaCode }" var="list">
								<option value="${list.CODE }">${list.CODE }</option>
							</c:forEach>
							</select>
							<input type="text" id="boHomeTel2" name="boHomeTel2" value="" class="box_s" maxlength="4" onKeyPress="inputNumCom();"/>
							<input type="text" id="boHomeTel3" name="boHomeTel3" value="" class="box_s" maxlength="4" onKeyPress="inputNumCom();"/>
						</td>
					</tr>
					<tr bgcolor="ffffff">
						<td bgcolor="f9f9f9"  align="center"><font class="b02">우편번호</font></td>
						<td >
							<input type="text" id="boZip" name="boZip" value="" class="box_s2" readOnly/>
							<input type="button" value="..." onClick="javascript:popAddr('2');"/>
						</td>
						<td bgcolor="f9f9f9" align="center"><font class="b02">등록일자</font></td>
						<td >
							<input type="text" id="regDt" name="regDt" value="${today }" class="box_n" readOnly"/>
						</td>
					</tr>
					<tr bgcolor="ffffff">
						<td bgcolor="f9f9f9"  align="center"><font class="b02">주소</font></td>
						<td colspan="3">
							<input type="text" id="boAdrs1" name="boAdrs1" value="" class="box_n" readOnly/>
						</td>
					</tr>
					<tr bgcolor="ffffff">
						<td bgcolor="f9f9f9"  align="center"><font class="b02">상세주소</font></td>
						<td colspan="3">
							<input type="text" id="boAdrs2" name="boAdrs2" value="" class="box_n"/>
						</td>
					</tr>
					<tr bgcolor="ffffff">
						<td bgcolor="f9f9f9"  align="center"><font class="b02">사무실명</font></td>
						<td colspan="3">
							<input type="text" id="boOffNm" name="boOffNm" value="" class="box_n"/>
						</td>
					</tr>
					<tr bgcolor="ffffff">
						<td bgcolor="f9f9f9"  align="center"><font class="b02">성명</font></td>
						<td >
							<input type="text" id="readNm" name="readNm" value="" class="box_n"/>
						</td>
						<td bgcolor="f9f9f9" align="center"><font class="b02">휴대폰</font></td>
						<td >
							<select id="boMobile1" name="boMobile1">
								<c:forEach items="${mobileCode }" var="list">
									<option value="${list.CODE }">${list.CODE }</option>
								</c:forEach>
							</select>
							<input type="text" id="boMobile2" name="boMobile2" value="" class="box_s" maxlength="4" onKeyPress="inputNumCom();"/>
							<input type="text" id="boMobile3" name="boMobile3" value="" class="box_s" maxlength="4" onKeyPress="inputNumCom();"/>
						</td>
					</tr>
					<tr bgcolor="ffffff">
						<td bgcolor="f9f9f9"  align="center"><font class="b02">이전일자</font></td>
						<td >
							<input type="text" id="moveDt" name="moveDt" value="" class="box_n" maxlength="8" onKeyPress="inputNumCom();"/>
						</td>
						<td bgcolor="f9f9f9" align="center"><font class="b02">이전부수</font></td>
						<td >
							<input type="text" id="boQty" name="boQty" value="" class="box_n" maxlength="3" onKeyPress="inputNumCom();"/>
						</td>
					</tr>
					<tr bgcolor="ffffff">
						<td bgcolor="f9f9f9" align="center"><font class="b02">비고</font></td>
						<td colspan="3" >
							<input type="text" id="boMsg" name="boMsg" value="" class="box_n"/>
						</td>
					</tr>
					<Tr>
						<td align="left" colspan="2">
							<input type="button" value="신규등록" onclick="javascript:saveRerocation();"/>
						</td>
						<td align="right" colspan="2">
							<input type="button" value="이전거절" onclick="javascript:update('1');"/>
							<input type="button" value="이전처리" onclick="javascript:update('2');"/>
						</td>
					</Tr>
				</table>
			</td>
			<td>
				<table width="100%" cellpadding="3" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
					<tr bgcolor="ffffff">
						<td bgcolor="f9f9f9" align="left" colspan="4"><font class="b02">이사후 정보</font></td>
					</tr>
					<tr bgcolor="ffffff">
						<td bgcolor="f9f9f9" width="20%" align="center"><font class="b02">지국명</font></td>
						<td width="30%">
							<input type="text" id="aoName" name="aoName" value="" class="box_n" readOnly/>
						</td>
						<td bgcolor="f9f9f9" width="20%" align="center"><font class="b02">전화번호</font></td>
						<td >
							<select id="aoHomeTel1" name="aoHomeTel1">
								<c:forEach items="${areaCode }" var="list">
									<option value="${list.CODE }">${list.CODE }</option>
								</c:forEach>
							</select>
							<input type="text" id="aoHomeTel2" name="aoHomeTel2" value="" class="box_s" maxlength="4" onKeyPress="inputNumCom();"/>
							<input type="text" id="aoHomeTel3" name="aoHomeTel3" value="" class="box_s" maxlength="4" onKeyPress="inputNumCom();"/>
						</td>
					</tr>
					<tr bgcolor="ffffff">
						<td bgcolor="f9f9f9"  align="center"><font class="b02">투입희망일</font></td>
						<td >
							<input type="text" id="dlvHpDt" name="dlvHpDt" value="" class="box_n" maxlength="8" onKeyPress="inputNumCom();"/>
						</td>
						<td bgcolor="f9f9f9" align="center"><font class="b02">수금시작월</font></td>
						<td >
							<input type="text" id="stbgMm" name="stbgMm" value="" class="box_n" maxlength="6" onKeyPress="inputNumCom();"/>
						</td>
					</tr>
					<tr bgcolor="ffffff">
						<td bgcolor="f9f9f9"  align="center"><font class="b02">우편번호</font></td>
						<td>
							<input type="text" id="aoZip" name="aoZip" value="" class="box_s2" readOnly onclick="javascript:popAddr('3');"/>
							<input type="button" value="..." onClick="javascript:popAddr('3');"/>
						</td>
						<td bgcolor="f9f9f9"  align="center"><font class="b02">휴대폰</font></td>
						<td>
							<select id="aoMobile1" name="aoMobile1" value="">
								<c:forEach items="${mobileCode }" var="list">
									<option value="${list.CODE }">${list.CODE }</option>
								</c:forEach>
							</select>
							<input type="text" id="aoMobile2" name="aoMobile2" value="" class="box_s" maxlength="4" onKeyPress="inputNumCom();"/>
							<input type="text" id="aoMobile3" name="aoMobile3" value="" class="box_s" maxlength="4" onKeyPress="inputNumCom();"/>
						</td>
					</tr>
					<tr bgcolor="ffffff">
						<td bgcolor="f9f9f9"  align="center"><font class="b02">주소</font></td>
						<td colspan="3">
							<input type="text" id="aoAdrs1" name="aoAdrs1" value="" class="box_n" readOnly/>
						</td>
					</tr>
					<tr bgcolor="ffffff">
						<td bgcolor="f9f9f9"  align="center"><font class="b02">상세주소</font></td>
						<td colspan="3">
							<input type="text" id="aoAdrs2" name="aoAdrs2" value="" class="box_n"/>
						</td>
					</tr>
					<tr bgcolor="ffffff">
						<td bgcolor="f9f9f9"  align="center"><font class="b02">사무실명</font></td>
						<td>
							<input type="text" id="aoOffNm" name="aoOffNm" value="" class="box_n"/>
						</td>
						<td bgcolor="f9f9f9"  align="center"><font class="b02">인수부수</font></td>
						<td>
							<input type="text" id="aoQty" name="aoQty" value="" class="box_n"  maxlength="3" onKeyPress="inputNumCom();"/>
						</td>
					</tr>
					<tr bgcolor="ffffff">
						<td bgcolor="f9f9f9"  align="center"><font class="b02">인수상태</font></td>
						<td >
							<input type="text" id="aoCnfmStatNm" name="aoCnfmStatNm" value="" class="box_n" readOnly/>
						</td>
						<td bgcolor="f9f9f9" align="center"><font class="b02">인수확인일자</font></td>
						<td >
							<input type="text" id="aoCnfmDt" name="aoCnfmDt" value="" class="box_n" readOnly />
						</td>
					</tr>
					<tr bgcolor="ffffff">
						<td bgcolor="f9f9f9"  align="center"><font class="b02">비고</font></td>
						<td colspan="3">
							<input type="text" id="aoMsg" name="aoMsg" value="" class="box_n"/>
						</td>
					</tr>
					<Tr>
						<td align="right" colspan="4">
							<input type="button" value="인수거절" onclick="javascript:update('3');"/>
							<input type="button" value="인수처리" onclick="javascript:update('4');"/>
						</td>
					</Tr>
				</table>
			</td>
		</tr>
	</table>
	</p>
</form>