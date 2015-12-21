<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib prefix="paging" uri="http://www.reflexion.co.kr/taglibs/paging" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript">

/*----------------------------------------------------------------------
 * Desc   : 조건별 리스트를 조회한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncAplcList(){
	 $("pageNo").value = '1';
	 frmList.target = "_self";
	 frmList.action = "/reader/readerAplc/aplcList.do";
	 frmList.submit();
}

// 구독정보 목록을 가져온다.
function fncKeySearch() {
	
	if ( event.keyCode == 13 ) {
		fncAplcList();
	}
}

/*----------------------------------------------------------------------
 * Desc   : 상세정보를 조회한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncAplcInfo(aplcdt, aplcno,boacptdt){
	 
	 actUrl = "/reader/readerAplc/popAplcReader.do";
	
     window.open('','pop_AplcReader','width=750, height=600, toolbar=0, menubar=0, location=0, status=0, scrollbars=0');

	 frmList.aplcdt.value = aplcdt;
	 frmList.aplcno.value = aplcno;
	 frmList.boacptdt.value = boacptdt;
      
     frmList.target = "pop_AplcReader";
     frmList.action = actUrl;
     frmList.submit();
}

/*----------------------------------------------------------------------
 * Desc   : 신규독자 등록 팝업을 호출한다
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function fncAplcIns(){	 
	actUrl = "/reader/readerAplc/popAplcReader.do";
	
    window.open('','pop_AplcReader','width=750, height=600, toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=0');

	frmList.aplcdt.value = "";
	frmList.aplcno.value = "";
	frmList.boacptdt.value = "";
	 
    frmList.target = "pop_AplcReader";
    frmList.action = actUrl;
    frmList.submit();

}

/*----------------------------------------------------------------------
 * Desc   : 페이징 펑션
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function moveTo(where, seq) {
	
		$("pageNo").value = seq;
		frmList.target="_self";
		frmList.action = "/reader/readerAplc/aplcList.do";
		frmList.submit();
}


/*----------------------------------------------------------------------
 * Desc   : 조회기간 설정
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
function setDate(arg,fr_dt,to_dt){
	 frmList.STDT.value = dateAdd(arg,fr_dt);
	 frmList.ETDT.value = dateAdd(arg,to_dt);
}


/*----------------------------------------------------------------------
 * Desc   : 날짜 수정
 * Auth   : 유진영
 *----------------------------------------------------------------------*/
 
function dateAdd(ymd, shift) { 

	var today = new  Date();     // 날자 변수 선언	 
    var year  = today.getYear();  // 로컬 컴퓨터의 년(year)을 구함
    var month = today.getMonth(); // 로컬 컴퓨터의 월(month)을 구함
    var date  = today.getDate();  // 로컬 컴퓨터의 일(day)을 구함
    
    if (("" + month).length == 1) { month = "0" + month; }
    if (("" + date).length   == 1) { date  = "0" + date;   }
        
    var tmp_date = new Date(year, month, date);
            
    if(ymd == 'y'){
        tmp_date.setFullYear(tmp_date.getFullYear() + shift); //y년을 더함
    }else if(ymd == 'm'){
        tmp_date.setMonth(tmp_date.getMonth() + shift);
    }else if(ymd == 'd'){
        tmp_date.setDate(tmp_date.getDate() + shift);  
    }
    
    return toTimeString(tmp_date);
}

function toTimeString(date) { //formatTime(date)
    var year  = date.getFullYear();
    var month = date.getMonth() + 1; // 1월=0,12월=11이므로 1 더함
    var date  = date.getDate();

    if (("" + month).length == 1) { month = "0" + month; }
    if (("" + date).length   == 1) { date  = "0" + date; }

    return ("" + year + "-" + month + "-" + date);
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
	
function fn_test() {
	var fm = document.getElementById("searchForm");
	var url = "http://www.juso.go.kr/support/AddressMainSearch.do?searchType=TOTAL";
	
	fm.target = "_blank";
	fm.action = url;
	fm.submit();
}
</script>
<!-- 
<form name="searchForm"  id="searchForm" method="get" >
	<input type="hidden"	name="searchType"	value="TOTAL" />
	<input type="hidden"	name="searchKeyword"		value="사당3동" />
	<input type="hidden"	name="currentPage" 	value="1" />
	<input type="hidden"	name="countPerPage"	value="10" />
	<input type="hidden"	name="reSrchFlag"	value="false" />
	<input type="hidden"	id="hiddenValue"	value="" />
	<input type="hidden"	id="hiddenIdx"	value="" />
	<input type="hidden"	id="hiddenMode1"	value="false" />
	<input type="hidden"	id="hiddenMode2"	value="false" />
</form>
<div style="padding: 10px;" onclick="fn_test();">test</div>
 -->
<div><span class="subTitle">본사신청독자관리</span></div>
<form id= "frmList" name="frmList" method="post" action="">
<!-- search conditions -->
<div>
	<table class="tb_search" style="width: 1020px;">
		<colgroup>
			<col width="100px">
			<col width="240px">
			<col width="100px">
			<col width="240px">
			<col width="100px">
			<col width="240x">
		</colgroup>
		<tr>
			<th>독자명</th>
			<td><input id="READNM" name="READNM" type="text"  maxlength="15"   value="<c:out value="${READNM}"/>"   style="width: 150px;ime-mode:active;" onkeydown="fncKeySearch();" /></td>
			<th>전화번호</th>
			<td>
				<input name="HOMETEL1" type="text" style="width:30px; ime-Mode:disabled"  onkeypress="inputNumCom();" maxlength="3" value="<c:out value="${HOMETEL1}"/>"  onkeydown="fncKeySearch();" />-
				<input name="HOMETEL2" type="text" style="width:40px; ime-Mode:disabled"  onkeypress="inputNumCom();" maxlength="4" value="<c:out value="${HOMETEL2}"/>"  onkeydown="fncKeySearch();" />-
				<input name="HOMETEL3" type="text" style="width:40px; ime-Mode:disabled"  onkeypress="inputNumCom();" maxlength="4" value="<c:out value="${HOMETEL3}"/>"  onkeydown="fncKeySearch();" />&nbsp;
			</td>
			<th>접수자</th>
			<td><input id="INCMGPERSNM" name="INCMGPERSNM" type="text"  maxlength="15"   value="<c:out value="${INCMGPERSNM}"/>"   style="width: 90px;ime-mode:active" onkeydown="fncKeySearch();" /></td>
		</tr>
		<tr>
			<th>관할지국</th>
			<td><input id="AGNM" name="AGNM" type="text"  maxlength="15"   value="<c:out value="${AGNM}"/>"   style="width: 90px;ime-mode:active"  onkeydown="fncKeySearch();" /></td>
			<th>확인여부</th>
			<td>
				<select name="ISCK"  style="width: 100px;">
					<option value="0" <c:if test="${0 eq ISCK}">selected</c:if>>전체</option>
			 	    <option value="1" <c:if test="${1 eq ISCK}">selected</c:if>>확인</option>
			 	    <option value="2" <c:if test="${2 eq ISCK}">selected</c:if>>미확인</option>
			 	    <option value="3" <c:if test="${3 eq ISCK}">selected</c:if>>취소</option>
			  	</select>
			</td>	
			<th>등록여부</th>
			<td>
				<select name="READTYPE"  style=" width: 100px;">
					<option value="0" <c:if test="${0 eq READTYPE}">selected</c:if>>전체</option>
			 	    <option value="1" <c:if test="${1 eq READTYPE}">selected</c:if>>등록</option>
			 	    <option value="2" <c:if test="${2 eq READTYPE}">selected</c:if>>미등록</option>
			  	</select>
			</td>
		</tr>
		<tr>
			<th>접수일자</th>
			<td colspan="4" style="border-right: 0;">
				<div style="width: 233px; float: left;">
					<input type="text" id="STDT" name="STDT"  value="<c:out value="${STDT}"/>" readonly="readonly" onclick="Calendar(this)" style="width: 75px;"/>
					&nbsp; ~ &nbsp; 
					<input type="text" id="ETDT" name="ETDT"  value="<c:out value="${ETDT}"/>" readonly="readonly" onclick="Calendar(this)"  style="width: 75px;"/>
				</div> 
				<div style="overflow: hidden; width: 250px; margin-top: 1px">
					<div onclick="setDate('d',0,0);" style="background-color:black;border:solid 1px #3D58A7; color:white; cursor: pointer; padding: 4px 0; width: 45px; text-align: center; float: left; font-weight: bold;">1일</div>
					<div style="width: 10px; float: left;">&nbsp;</div>
					<div onclick="setDate('d',-3,0);" style="background-color:black;border:solid 1px #3D58A7; color:white; cursor: pointer; padding: 4px 0; width: 45px; text-align: center; float: left; font-weight: bold;">3일</div>
					<div style="width: 10px; float: left;">&nbsp;</div>
					<div onclick="setDate('d',-7,0);" style="background-color:black;border:solid 1px #3D58A7; color:white; cursor: pointer; padding: 4px 0; width: 45px; text-align: center; float: left; font-weight: bold;">1주일</div>
					<div style="width: 10px; float: left;">&nbsp;</div>
					<div onclick="setDate('m',-1,0);" style="background-color:black;border:solid 1px #3D58A7; color:white; cursor: pointer; padding: 4px 0; width: 45px; text-align: center; float: left; font-weight: bold;">1개월</div>
				</div>
			</td>
			<td style="border-left: 0; text-align: right;">
				<img src="/images/bt_joh.gif" alt="조회" onclick="fncAplcList();"  style="vertical-align: middle;cursor: pointer;"/>
				&nbsp;
				<img src="/images/bt_newmem.gif" alt="신규독자" onclick="fncAplcIns();"  style="vertical-align: middle;cursor: pointer;"/>
				<input name="aplcdt" type="hidden" />
				<input name="aplcno" type="hidden" />
				<input name="boacptdt" type="hidden" />
				<input type=hidden id="pageNo" name="pageNo" value="${param.pageNo}" />
				&nbsp;&nbsp;
			</td>
		</tr>
	</table>
</div>
<!-- //search conditions -->
</form>
<!--//조회조건-->
<!-- list -->
<div style="padding-top:30px; border: 0px solid red">
	<div style="padding: 0 0 5px 5px"><b>◆ 조회건수 / 부수 : <c:out value="${totalCount}"/>건 / <c:out value="${totalQty}"/>부</b></div>	
	<table style="width:1015px" class="tb_list_a_5">
		<colgroup>
			<col width="80px">
			<col width="" >
			<col width="100px">
			<col width="75px">
			<col width="75px">
			<col width="50px">
			<col width="130px">
			<col width="60px">
			<col width="80px">
		</colgroup>
	    <tr>
            <th>독자명</th>
            <th>주 소</th>
            <th>전화번호</th>
            <th>관할지국</th>
            <th>확장경로</th>
            <th>부수</th>
            <th>신청/통보일시</th>
            <th>접수자</th>
            <th>지국확인</th>
	    </tr>
		<c:if test="${empty aplcList}">
			<tr>
				<td colspan="9">신규독자 정보가 없습니다.</td>
			</tr>
		</c:if>
	     <c:if test="${!empty aplcList}">
			<c:forEach items="${aplcList}" var="list"  varStatus="status">
				<tr class="mover" id="oTr<c:out value="${status.count}"/>" onclick="fncAplcInfo('${list.APLCDT}','${list.APLCNO}','${list.BOACPTDT}')" >
					<td style="text-align:left;">${list.READNM}</td>
					<td style="text-align:left;">
						<c:set var="addAddr" value=""/>
						<c:choose>
							<c:when test="${list.NEWADDR eq null}">
								<c:set var="addAddr" value="${list.DLVADRS1}"/>
							</c:when>
							<c:when test="${list.NEWADDR ne null}">
								<c:set var="addAddr" value="${list.NEWADDR}(${list.DLVADRS1})"/>
							</c:when>
						</c:choose>
						${addAddr}<br/> ${list.DLVADRS2}
					</td>
						<c:if test="${!empty list.HOMETEL2}">
							<td style="text-align:left;"><c:out value="${list.HOMETEL1}"/>-<c:out value="${list.HOMETEL2}"/>-<c:out value="${list.HOMETEL3}"/></td>
			            </c:if>
			            <c:if test="${empty list.HOMETEL2}">
			            	<td style="text-align:left;"><c:out value="${list.MOBILE1}"/>-<c:out value="${list.MOBILE2}"/>-<c:out value="${list.MOBILE3}"/></td>
			            </c:if>
					<td>${list.AGNAME}</td>
					<td>${list.HJPATHNM }</td>
					<td>${list.QTY }</td>
					<td>${list.INDT }<br/><span style="color:#0038ec">${list.CHGDT }</span></td>
					<td>${list.INPS }</td>
					<td>			
						<c:if test='${list.DELYN == "N"}'>
		                    	<c:out value="${list.BOACPTDT}" default="미확인"/>
		                </c:if>
		                <c:if test='${list.DELYN !="N"}'>취소</c:if>
					</td>
				</tr>
		    </c:forEach>
	    </c:if>
    </table>
    <%@ include file="/common/paging.jsp"  %>
</div>	
<!-- //list -->