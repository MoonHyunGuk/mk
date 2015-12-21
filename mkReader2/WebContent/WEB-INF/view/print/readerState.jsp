<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script type="text/javascript"src="/js/mini_calendar.js"></script>
<script type="text/javascript">	
	// 매체 종류 전체 선택/해제
	function checkControll(){
		var frm = document.frm;
		//전체선택 1 , 전체해제 2
		if(frm.controll.checked == true){
			if( frm.newsCd.length > 0 ){
				for(var i=0;i<frm.newsCd.length;i++){
					frm.newsCd[i].checked = true;
				}
			}			
		}else{
			if( frm.newsCd.length > 0 ){
				for(var i=0;i<frm.newsCd.length;i++){
					frm.newsCd[i].checked = false;
				}
			}	
		}
	}

	function fn_search(){
		var frm = document.frm;
		var result = false;
	
		if( frm.newsCd.length > 0 ){
			for(var i=0;i<frm.newsCd.length;i++){
				if(frm.newsCd[i].checked){
					result = true;
				}
			}
		}else if( frm.newsCd.value != "" && frm.newsCd.checked ){
			result = true;
		}else{
			alert('신문명을 체크해주세요.');
			result = false;
		}

		<c:if test="${empty boseq}">
			if(  result ){
				if ( confirm('많은 시간이 소요될 수도 있습니다.\n실행하시겠습니까?') ) {
					result = true;
				}else{
					result = false;
				}
			}
		</c:if>
	
		if( result ){
			
			frm.action = "./readerState.do";
			frm.submit();
		}
		
	}

	function ozPrint(){
		actUrl = "/print/print/ozReaderState.do";
		window.open('','ozReaderState','width=1000, height=800, toolbar=no, menubar=no, location=no, status=no, resizable=1, scrollbars=no');

		frm.target = "ozReaderState";
		frm.action = actUrl;
		frm.submit();
		frm.target ="";
	}
</script>
<div><span class="subTitle">독자정보현황</span></div>
<!-- search conditions -->
<form id="frm" name="frm" method="post">
<div style="overflow: hidden; width: 815px; border: 0px solid ">
	<!-- search conditions(left) -->
	<div style="float: left; width: 400px; padding-right: 10px;">
		<table class="tb_search" style="width: 400px;">
			<colgroup>
				<col width="80px">
				<col width="320px">
			</colgroup>
			<tr>
				<th>조회구분</th>
				<td style="text-align: left;padding-left: 10px;">
						<select id="gubun" name="gubun" style="vertical-align: middle;">
								<option value="6" <c:if test="${gubun eq '6'}">selected</c:if>>전체</option>
								<option value="5" <c:if test="${gubun eq '5'}">selected</c:if>>독자유형</option>
								<option value="1" <c:if test="${gubun eq '1'}">selected</c:if>>주거구분</option>
								<option value="2" <c:if test="${gubun eq '2'}">selected</c:if>>직종구분</option>
								<option value="3" <c:if test="${gubun eq '3'}">selected</c:if>>관심분야</option>
								<option value="4" <c:if test="${gubun eq '4'}">selected</c:if>>구독기간</option>
						</select>
						&nbsp;&nbsp;
					<a href="#fakeUrl" onclick="fn_search();"><img src="/images/bt_joh.gif" style="border: 0; vertical-align: middle;"/></a>
					<a href="#fakeUrl" onclick="ozPrint();"><img src="/images/bt_print.gif" style="border: 0; vertical-align: middle;" /></a>
				</td>
			</tr>			
		</table>
	</div>
	<!-- //search conditions(left) -->
	<!-- search conditions(right) -->
	<div style="float: left;">
		<div style="border: 1px solid #e5e5e5; padding: 5px; width: 340px">
			<table class="tb_list_a" style="width: 330px">
				<colgroup>
					<col width="25px;">
					<col width="65px;">
					<col width="80px;">
					<col width="170px;">
				</colgroup>
				<tr bgcolor="f9f9f9" align="center" class="box_p" >
					<td width="20"></td>
					<td><input type="checkbox" id="controll" name="controll"  onclick="checkControll();" style="border: 0;"> </td>
					<td>코드</td>
					<td>신문명</td>
				</tr>
				<tr id=div1 style="display:none;"><td><input type="checkbox" id="newsCd" name="newsCd" value="0" /></td></tr>
			</table>
			<div style="width: 330px;height:115px;overflow-y:scroll;margin: 0 auto;">
			<table class="tb_list_a" style="width: 313px">
				<colgroup>
					<col width="25px;">
					<col width="65px;">
					<col width="80px;">
					<col width="153px;">
				</colgroup>
				<c:forEach var="list" items="${newsCodeList}" varStatus="status">
					<tr >
						<td>${status.count}</td>
						<td>
							<input type="checkbox" id="newsCd" name="newsCd" value="${list.CODE}"  style="border: 0;"
								<c:choose>
								<%-- 매일경제 기본으로 체크 --%>
								<c:when test="${empty newsCd}">
									<c:if test="${list.CODE eq '100'}"> checked
									</c:if>
								</c:when>
								<%-- 폼으로 넘어온 값 체크--%>
								<c:otherwise>
									<c:forEach items="${newsCd}" varStatus="counter">
										<c:if test="${newsCd[counter.index] eq list.CODE}"> checked
										</c:if>
									</c:forEach>
								</c:otherwise>
								</c:choose>
							/>
						</td>
						<td><c:out value="${list.YNAME}" /></td>
						<td><c:out value="${list.CNAME}" /></td>
					</tr>			
				</c:forEach>
			</table>
			</div>
		</div>
	</div>
</div>
</form>
<!-- search conditions -->
<!-- 합계 변수지정start:: -->
<c:set var="A" value="0" />					
<c:set var="B" value="0" />						
<c:set var="C" value="0" />					
<c:set var="D" value="0" />						
<c:set var="E" value="0" />					
<c:set var="F" value="0" />						
<c:set var="G" value="0" />					
<c:set var="H" value="0" />						
<c:set var="I" value="0" />					
<c:set var="J" value="0" />						
<c:set var="K" value="0" />			
<c:set var="EMPTY" value="0" />			
<c:set var="TOTAL" value="0" />						
<!-- 합계 변수지정end:: -->
<!-- list -->
<div style="clear: both; padding: 15px 0 20px 0; width: 815px; text-align: left;"> 
	<!-- 주거구분 -->
	<c:if test="${gubun eq '1'}">
		<table class="tb_list_a" style="width: 810px">
			<colgroup>
				<col width="110px">
				<col width="87px">
				<col width="88px">
				<col width="87px">
				<col width="88px">
				<col width="87px">
				<col width="88px">
				<col width="87px">
				<col width="88px">
			</colgroup>
			<tr>
				<th>구역</th>
			    <th>사무실</th>
			    <th>아파트</th>
			    <th>다세대/빌라</th>
			    <th>단독</th>
			    <th>상가</th>
			    <th>기타</th>
			    <th>미등록</th>
			    <th>합계</th>
			  </tr>
			<!-- 합계 변수지정end:: -->
			<c:forEach var="list" items="${resultList}" varStatus="status">
				<tr>
					<td><c:out value="${list.GNO}" />구역</td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.OFFICE}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.APT}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.BILLA}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.DANDOK}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.SANGGA}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.ETC}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.EMPTY}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.TOTAL}" type="number" /></td>
				</tr>
				<c:set var="A" value="${A + list.OFFICE}" />	
				<c:set var="B" value="${B + list.APT}" />		
				<c:set var="C" value="${C + list.BILLA}" />	
				<c:set var="D" value="${D + list.DANDOK}" />		
				<c:set var="E" value="${E + list.SANGGA}" />	
				<c:set var="F" value="${F + list.ETC}" />		
				<c:set var="EMPTY" value="${EMPTY + list.EMPTY}" />	
				<c:set var="TOTAL" value="${TOTAL + list.TOTAL}" />		
			</c:forEach>
			 <tr style="background-color: #ccdbfb">
				<td align="center"><strong>합 &nbsp; 계</strong></td>
				<td style="text-align: right;"><fmt:formatNumber value="${A}"  type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${B}"  type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${C}"  type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${D}"  type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${E}"  type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${F}"  type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${EMPTY}"  type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${TOTAL}"  type="number" /></td>
			</tr>
			<tr style="background-color: #ccffcc">
				<td><strong>비 &nbsp; 율</strong></td>
				<td style="text-align: right;" >
					<c:if test="${TOTAL ne '0'}">
						<fmt:parseNumber var="tmp1" value="${A}" integerOnly="false"/>
						<fmt:parseNumber var="tmp2" value="${TOTAL}" integerOnly="false"/>
						<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
				</td>
				<td style="text-align: right;" >
					<c:if test="${TOTAL ne '0'}">
						<fmt:parseNumber var="tmp1" value="${B}" integerOnly="false"/>
						<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
				</td>
				<td style="text-align: right;" >
					<c:if test="${TOTAL ne '0'}">
						<fmt:parseNumber var="tmp1" value="${C}" integerOnly="false"/>
						<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
				</td>
				<td style="text-align: right;" >
					<c:if test="${TOTAL ne '0'}">
						<fmt:parseNumber var="tmp1" value="${D}" integerOnly="false"/>
						<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
				</td>
				<td style="text-align: right;" >
					<c:if test="${TOTAL ne '0'}">
						<fmt:parseNumber var="tmp1" value="${E}" integerOnly="false"/>
						<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
				</td>
				<td style="text-align: right;" >
					<c:if test="${TOTAL ne '0'}">
						<fmt:parseNumber var="tmp1" value="${F}" integerOnly="false"/>
						<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
				</td>
				<td style="text-align: right;">
					<c:if test="${TOTAL ne '0'}">
						<fmt:parseNumber var="tmp1" value="${EMPTY}" integerOnly="false"/>
						<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
				</td>
				<!-- 합계금액 -->
				<td style="text-align: right;">
					<c:if test="${TOTAL ne '0'}">
						<fmt:parseNumber var="tmp1" value="${TOTAL}" integerOnly="false"/>
						<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
				</td>
			</tr>    
		</table>
	</c:if>
	<!-- //주거구분 -->
	<!-- 직종구분 -->
	<c:if test="${gubun eq '2'}">
		<table class="tb_list_a"  style="width: 810px">
			<colgroup>
				<col width="110px">
				<col width="87px">
				<col width="88px">
				<col width="87px">
				<col width="88px">
				<col width="87px">
				<col width="88px">
				<col width="87px">
				<col width="88x">
			</colgroup>
			<tr>
				<th>구역</th>
				<th>기업</th>
				<th>금융업</th>
				<th>공공기관</th>
				<th>자영업</th>
				<th>가정</th>
				<th>기타</th>
				<th>미등록</th>
				<th>합계</th>
			</tr>
			<!-- 합계 변수지정end:: -->
			<c:forEach var="list" items="${resultList}" varStatus="status">
				<tr>
					<td><c:out value="${list.GNO}" />구역</td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.A}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.B}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.C}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.D}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.E}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.F}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.EMPTY}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.TOTAL}" type="number" /></td>
				</tr>
				<c:set var="A" value="${A + list.A}" />	
				<c:set var="B" value="${B + list.B}" />		
				<c:set var="C" value="${C + list.C}" />	
				<c:set var="D" value="${D + list.D}" />		
				<c:set var="E" value="${E + list.E}" />	
				<c:set var="F" value="${F + list.F}" />		
				<c:set var="EMPTY" value="${EMPTY + list.EMPTY}" />	
				<c:set var="TOTAL" value="${TOTAL + list.TOTAL}" />		
			</c:forEach>
			<tr style="background-color: #ccdbfb">
				<td><strong>합 &nbsp; 계</strong></td>
				<td style="text-align: right;"><fmt:formatNumber value="${A}"  type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${B}"  type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${C}"  type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${D}"  type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${E}"  type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${F}"  type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${EMPTY}"  type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${TOTAL}"  type="number" /></td>
			</tr>
			<tr style="background-color: #ccffcc">
			    <td><strong>비 &nbsp; 율</strong></td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${A}" integerOnly="false"/>
						<fmt:parseNumber var="tmp2" value="${TOTAL}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${B}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${C}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${D}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${E}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${F}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;">
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${EMPTY}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <!-- 합계금액 -->
			    <td style="text-align: right;">
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${TOTAL}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
	     	</tr>    
		</table>
	</c:if>
	<!-- //직종구분 -->
	<!-- 관심분야 -->
	<c:if test="${gubun eq '3'}">
		<table class="tb_list_a" style="width: 810px">
			<colgroup>
				<col width="110px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="62px">
			</colgroup>
			<tr>
				<th>구역</th>
			    <th>경제</th>
			    <th>부동산</th>
			    <th>증권</th>
			    <th>금융</th>
			    <th>기업<br>뉴스</th>
			    <th>정치</th>
			    <th>사회</th>
			    <th>문화</th>
			    <th>교육</th>
			    <th>기타</th>
			    <th>미등록</th>
			    <th>합계</th>
			</tr>
			<!-- 합계 변수지정end:: -->
			<c:forEach var="list" items="${resultList}" varStatus="status">
				<tr>
					<td><c:out value="${list.GNO}" />구역</td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.A}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.B}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.C}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.D}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.E}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.F}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.G}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.H}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.I}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.J}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.EMPTY}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.TOTAL}" type="number" /></td>
				</tr>
				<c:set var="A" value="${A + list.A}" />	
				<c:set var="B" value="${B + list.B}" />		
				<c:set var="C" value="${C + list.C}" />	
				<c:set var="D" value="${D + list.D}" />		
				<c:set var="E" value="${E + list.E}" />	
				<c:set var="F" value="${F + list.F}" />		
				<c:set var="G" value="${G + list.G}" />		
				<c:set var="H" value="${H + list.H}" />		
				<c:set var="I" value="${I + list.I}" />		
				<c:set var="J" value="${J + list.J}" />		
				<c:set var="EMPTY" value="${EMPTY + list.EMPTY}" />	
				<c:set var="TOTAL" value="${TOTAL + list.TOTAL}" />		
			 </c:forEach>
			 <tr style="background-color: #ccdbfb">
			    <td align="center"><strong>합 &nbsp; 계</strong></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${A}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${B}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${C}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${D}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${E}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${F}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${G}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${H}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${I}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${J}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${EMPTY}"  type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${TOTAL}"  type="number" /></td>
		     </tr>
		     <tr style="background-color: #cffcc">
				<td><strong>비 &nbsp; 율</strong></td>
				<td style="text-align: right;" >
					<c:if test="${TOTAL ne '0'}">
						<fmt:parseNumber var="tmp1" value="${A}" integerOnly="false"/>
						<fmt:parseNumber var="tmp2" value="${TOTAL}" integerOnly="false"/>
						<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
				</td>
				<td style="text-align: right;" >
					<c:if test="${TOTAL ne '0'}">
						<fmt:parseNumber var="tmp1" value="${B}" integerOnly="false"/>
						<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
				</td>
				<td style="text-align: right;" >
					<c:if test="${TOTAL ne '0'}">
						<fmt:parseNumber var="tmp1" value="${C}" integerOnly="false"/>
						<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
				</td>
				<td style="text-align: right;" >
					<c:if test="${TOTAL ne '0'}">
						<fmt:parseNumber var="tmp1" value="${D}" integerOnly="false"/>
						<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
				</td>
				<td style="text-align: right;" >
					<c:if test="${TOTAL ne '0'}">
						<fmt:parseNumber var="tmp1" value="${E}" integerOnly="false"/>
						<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
				</td>
				<td style="text-align: right;" >
					<c:if test="${TOTAL ne '0'}">
						<fmt:parseNumber var="tmp1" value="${F}" integerOnly="false"/>
						<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
				</td>
				<td style="text-align: right;" >
					<c:if test="${TOTAL ne '0'}">
						<fmt:parseNumber var="tmp1" value="${G}" integerOnly="false"/>
						<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
				</td>
				<td style="text-align: right;" >
					<c:if test="${TOTAL ne '0'}">
						<fmt:parseNumber var="tmp1" value="${H}" integerOnly="false"/>
						<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
				</td>
				<td style="text-align: right;" >
					<c:if test="${TOTAL ne '0'}">
						<fmt:parseNumber var="tmp1" value="${I}" integerOnly="false"/>
						<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
				</td>
				<td style="text-align: right;" >
					<c:if test="${TOTAL ne '0'}">
						<fmt:parseNumber var="tmp1" value="${J}" integerOnly="false"/>
						<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
				</td>
				<td style="text-align: right;">
					<c:if test="${TOTAL ne '0'}">
						<fmt:parseNumber var="tmp1" value="${EMPTY}" integerOnly="false"/>
						<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
				</td>
				<!-- 합계금액 -->
				<td style="text-align: right;">
					<c:if test="${TOTAL ne '0'}">
						<fmt:parseNumber var="tmp1" value="${TOTAL}" integerOnly="false"/>
						<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
				</td>
			</tr>    
		</table>
	</c:if>
	<!-- //관심분야 -->
	<!-- 구독기간 -->
	<c:if test="${gubun eq '4'}">
		<table class="tb_list_a" style="width: 810px;">
			<colgroup>
				<col width="110px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="62px">
			</colgroup>
			<tr>
			    <th><c:out value="${list.GNO}" />구역</th>
			    <th>1~6<br>개월</th>
			    <th>7~12<br>개월</th>
			    <th>1년<br>이상</th>
			    <th>2년<br>이상</th>
			    <th>3년<br>이상</th>
			    <th>5년<br>이상</th>
			    <th>10년<br>이상</th>
			    <th>15년<br>이상</th>
			    <th>20년<br>이상</th>
			    <th>25년<br>이상</th>
			    <th>30년<br>이상</th>
			    <th>합계</th>
			</tr>
			<!-- 합계 변수지정end:: -->
			<c:forEach var="list" items="${resultList}" varStatus="status">
				<tr>
					<td><c:out value="${list.GNO}" />구역</td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.A}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.B}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.C}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.D}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.E}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.F}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.G}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.H}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.I}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.J}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.K}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.TOTAL}" type="number" /></td>
				</tr>
				<c:set var="A" value="${A + list.A}" />	
				<c:set var="B" value="${B + list.B}" />		
				<c:set var="C" value="${C + list.C}" />	
				<c:set var="D" value="${D + list.D}" />		
				<c:set var="E" value="${E + list.E}" />	
				<c:set var="F" value="${F + list.F}" />		
				<c:set var="G" value="${G + list.G}" />		
				<c:set var="H" value="${H + list.H}" />		
				<c:set var="I" value="${I + list.I}" />		
				<c:set var="J" value="${J + list.J}" />		
				<c:set var="K" value="${K + list.K}" />	
				<c:set var="TOTAL" value="${TOTAL + list.TOTAL}" />		
			</c:forEach>
			<tr style="background-color: #ccdbfb">
				<td><strong>합 &nbsp; 계</strong></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${A}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${B}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${C}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${D}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${E}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${F}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${G}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${H}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${I}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${J}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${K}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${TOTAL}"  type="number" /></td>
			</tr>
			<tr style="background-color: #ccffcc">
		    	<td><strong>비 &nbsp; 율</strong></td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${A}" integerOnly="false"/>
						<fmt:parseNumber var="tmp2" value="${TOTAL}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${B}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${C}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${D}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${E}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${F}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${G}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${H}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${I}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${J}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;">
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${K}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <!-- 합계금액 -->
			    <td style="text-align: right;">
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${TOTAL}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
				</td>
			</tr>
		</table>
	</c:if>			
	<!-- //구독기간 -->
	<!-- 독자유형 -->
	<c:if test="${gubun eq '5'}">
		<table class="tb_list_a" style="width: 810px">
			<colgroup>
				<col width="110px">
				<col width="70px">
				<col width="70px">
				<col width="70px">
				<col width="70px">
				<col width="70px">
				<col width="70px">
				<col width="70px">
				<col width="70px">
				<col width="70px">
				<col width="70px">
			</colgroup>
			<tr>
				<th><c:out value="${list.GNO}" />구역</th>
			    <th>일반</th>
			    <th>학생(지국)</th>
			    <th>학생(본사)</th>
			    <th>병독</th>
			    <th>교육</th>
			    <th>본사사원</th>
			    <th>소외계층</th>
			    <th>기증</th>
			    <th>홍보</th>
			    <th>합계</th>
			</tr>
			<!-- 합계 변수지정end:: -->
			<c:forEach var="list" items="${resultList}" varStatus="status">
				<tr>
					<td><c:out value="${list.GNO}" />구역</td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.A}" type="number" /></td>
					<td style="text-align: right;"><fmt:formatNumber value="${list.B}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.C}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.D}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.E}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.F}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.G}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.H}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.I}" type="number" /></td>
				    <td style="text-align: right;"><fmt:formatNumber value="${list.TOTAL}" type="number" /></td>
				</tr>
				<c:set var="A" value="${A + list.A}" />	
				<c:set var="B" value="${B + list.B}" />		
				<c:set var="C" value="${C + list.C}" />	
				<c:set var="D" value="${D + list.D}" />		
				<c:set var="E" value="${E + list.E}" />	
				<c:set var="F" value="${F + list.F}" />		
				<c:set var="G" value="${G + list.G}" />		
				<c:set var="H" value="${H + list.H}" />		
				<c:set var="I" value="${I + list.I}" />		
				<c:set var="TOTAL" value="${TOTAL + list.TOTAL}" />		
			</c:forEach>
			<tr style="background-color: #ccdbfb">
			    <td><strong>합 &nbsp; 계</strong></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${A}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${B}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${C}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${D}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${E}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${F}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${G}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${H}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${I}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${TOTAL}"  type="number" /></td>
			</tr>
			<tr style="background-color: #ccffcc">
		    	<td><strong>비 &nbsp; 율</strong></td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${A}" integerOnly="false"/>
						<fmt:parseNumber var="tmp2" value="${TOTAL}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${B}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${C}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${D}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${E}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${F}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${G}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${H}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${I}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <!-- 합계금액 -->
			    <td style="text-align: right;">
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${TOTAL}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
				</td>
			</tr>
		</table>
	</c:if>			
	<!-- //독자유형 -->
	<!-- 독자유형 -->
	<!-- 합계 변수지정end:: -->
	<c:set var="A" value="0" />					
	<c:set var="B" value="0" />						
	<c:set var="C" value="0" />					
	<c:set var="D" value="0" />						
	<c:set var="E" value="0" />					
	<c:set var="F" value="0" />						
	<c:set var="G" value="0" />					
	<c:set var="H" value="0" />						
	<c:set var="I" value="0" />						
	<c:set var="TOTAL" value="0" />
	<!-- 합계 변수지정end:: -->
	<c:if test="${gubun eq '6'}">
		<div style="font-weight: bold; padding: 5px 0;" >■ 독자유형</div>
		<table class="tb_list_a" style="width: 810px">
			<colgroup>
				<col width="110px">
				<col width="70px">
				<col width="70px">
				<col width="70px">
				<col width="70px">
				<col width="70px">
				<col width="70px">
				<col width="70px">
				<col width="70px">
				<col width="70px">
				<col width="70px">
			</colgroup>
			<tr>
				<th>구 분</th>
			    <th>일반</th>
			    <th>학생(지국)</th>
			    <th>학생(본사)</th>
			    <th>병독</th>
			    <th>교육</th>
			    <th>본사사원</th>
			    <th>소외계층</th>
			    <th>기증</th>
			    <th>홍보</th>
			    <th>합계</th>
			</tr>
			<c:forEach var="list" items="${resultList5}" varStatus="status">
				<c:set var="A" value="${A + list.A}" />	
				<c:set var="B" value="${B + list.B}" />		
				<c:set var="C" value="${C + list.C}" />	
				<c:set var="D" value="${D + list.D}" />		
				<c:set var="E" value="${E + list.E}" />	
				<c:set var="F" value="${F + list.F}" />		
				<c:set var="G" value="${G + list.G}" />		
				<c:set var="H" value="${H + list.H}" />		
				<c:set var="I" value="${I + list.I}" />		
				<c:set var="TOTAL" value="${TOTAL + list.TOTAL}" />		
			</c:forEach>
			<tr>
				<td>부 &nbsp; 수</td>
				<td style="text-align: right;"><fmt:formatNumber value="${A}"  type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${B}"  type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${C}"  type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${D}"  type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${E}"  type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${F}"  type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${G}"  type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${H}"  type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${I}"  type="number" /></td>
				<td style="text-align: right;"><fmt:formatNumber value="${TOTAL}"  type="number" /></td>
			</tr>
			<tr>
			    <td align="center">비 &nbsp; 율</td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${A}" integerOnly="false"/>
						<fmt:parseNumber var="tmp2" value="${TOTAL}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${B}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${C}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${D}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${E}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${F}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${G}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${H}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${I}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <!-- 합계금액 -->
			    <td style="text-align: right;">
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${TOTAL}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			</tr>    
		</table>				 
		<br>
		<!-- 합계 변수지정end:: -->
		<c:set var="A" value="0" />					
		<c:set var="B" value="0" />						
		<c:set var="C" value="0" />					
		<c:set var="D" value="0" />						
		<c:set var="E" value="0" />					
		<c:set var="F" value="0" />						
		<c:set var="G" value="0" />					
		<c:set var="H" value="0" />						
		<c:set var="I" value="0" />					
		<c:set var="J" value="0" />						
		<c:set var="K" value="0" />			
		<c:set var="EMPTY" value="0" />			
		<c:set var="TOTAL" value="0" />	
		<!-- 합계 변수지정end:: -->
		<!-- 주거구분 -->
	 	<div style="font-weight: bold; padding: 5px 0;" >■ 주거구분</div>
		<table class="tb_list_a" style="width: 810px">
			<colgroup>
				<col width="110px">
				<col width="87px">
				<col width="88px">
				<col width="87px">
				<col width="88px">
				<col width="87px">
				<col width="88px">
				<col width="87px">
				<col width="88px">
			</colgroup>
			<tr>
				<th>구 분</th>
			    <th>사무실</th>
			    <th>아파트</th>
			    <th>다세대/빌라</th>
			    <th>단독</th>
			    <th>상가</th>
			    <th>기타</th>
			    <th>미등록</th>
			    <th>합계</th>
			</tr>
			<c:forEach var="list" items="${resultList}" varStatus="status">
				<c:set var="A" value="${A + list.OFFICE}" />	
				<c:set var="B" value="${B + list.APT}" />		
				<c:set var="C" value="${C + list.BILLA}" />	
				<c:set var="D" value="${D + list.DANDOK}" />		
				<c:set var="E" value="${E + list.SANGGA}" />	
				<c:set var="F" value="${F + list.ETC}" />		
				<c:set var="EMPTY" value="${EMPTY + list.EMPTY}" />	
				<c:set var="TOTAL" value="${TOTAL + list.TOTAL}" />		
			</c:forEach>
			<tr>
			    <td>부 &nbsp; 수</td>
			    <td style="text-align: right;"><fmt:formatNumber value="${A}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${B}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${C}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${D}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${E}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${F}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${EMPTY}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${TOTAL}"  type="number" /></td>
			</tr>
			<tr>
				<td>비 &nbsp; 율</td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${A}" integerOnly="false"/>
						<fmt:parseNumber var="tmp2" value="${TOTAL}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${B}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${C}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${D}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${E}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${F}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;">
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${EMPTY}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <!-- 합계금액 -->
			    <td style="text-align: right;">
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${TOTAL}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			</tr>    
		</table>
		<br>
		<!-- //주거구분 -->
		<!-- 합계 변수지정end:: -->
		<c:set var="A" value="0" />					
		<c:set var="B" value="0" />						
		<c:set var="C" value="0" />					
		<c:set var="D" value="0" />						
		<c:set var="E" value="0" />					
		<c:set var="F" value="0" />						
		<c:set var="G" value="0" />					
		<c:set var="H" value="0" />						
		<c:set var="I" value="0" />					
		<c:set var="J" value="0" />						
		<c:set var="K" value="0" />			
		<c:set var="EMPTY" value="0" />			
		<c:set var="TOTAL" value="0" />	
		<!-- 합계 변수지정end:: -->
		<!-- 직종구분 -->
		<div style="font-weight: bold; padding: 5px 0;" >■ 직종구분</DIV>
		<table class="tb_list_a" style="width: 810px">
			<colgroup>
				<col width="110px">
				<col width="87px">
				<col width="88px">
				<col width="87px">
				<col width="88px">
				<col width="87px">
				<col width="88px">
				<col width="87px">
				<col width="88x">
			</colgroup>
			<tr>
				<th>구 분</th>
				<th>기업</th>
				<th>금융업</th>
				<th>공공기관</th>
				<th>자영업</th>
				<th>가정</th>
				<th>기타</th>
				<th>미등록</th>
				<th>합계</th>
			</tr>
			<c:forEach var="list" items="${resultList2}" varStatus="status">
				<c:set var="A" value="${A + list.A}" />	
				<c:set var="B" value="${B + list.B}" />		
				<c:set var="C" value="${C + list.C}" />	
				<c:set var="D" value="${D + list.D}" />		
				<c:set var="E" value="${E + list.E}" />	
				<c:set var="F" value="${F + list.F}" />		
				<c:set var="EMPTY" value="${EMPTY + list.EMPTY}" />	
				<c:set var="TOTAL" value="${TOTAL + list.TOTAL}" />		
			</c:forEach>
			<tr>
				<td>부 &nbsp; 수</td>
			    <td style="text-align: right;"><fmt:formatNumber value="${A}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${B}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${C}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${D}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${E}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${F}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${EMPTY}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${TOTAL}"  type="number" /></td>
			</tr>
			<tr>
		    	<td>비 &nbsp; 율</td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${A}" integerOnly="false"/>
						<fmt:parseNumber var="tmp2" value="${TOTAL}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${B}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${C}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${D}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${E}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${F}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;">
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${EMPTY}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <!-- 합계금액 -->
			    <td style="text-align: right;">
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${TOTAL}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			</tr>    
		</table>
		<br>
		<!-- //직종구분 -->
		<!-- 합계 변수지정end:: -->
		<c:set var="A" value="0" />					
		<c:set var="B" value="0" />						
		<c:set var="C" value="0" />					
		<c:set var="D" value="0" />						
		<c:set var="E" value="0" />					
		<c:set var="F" value="0" />						
		<c:set var="G" value="0" />					
		<c:set var="H" value="0" />						
		<c:set var="I" value="0" />					
		<c:set var="J" value="0" />						
		<c:set var="K" value="0" />			
		<c:set var="EMPTY" value="0" />			
		<c:set var="TOTAL" value="0" />	
		<!-- 합계 변수지정end:: -->
		<!-- 관심분야 -->
		<div style="font-weight: bold; padding: 5px 0;" >■ 관심분야</div>
		<table class="tb_list_a" style="width: 810px">
			<colgroup>
				<col width="110px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="62px">
			</colgroup>
			<tr>
				<th>구 분</th>
			    <th>경제</th>
			    <th>부동산</th>
			    <th>증권</th>
			    <th>금융</th>
			    <th>기업<br>뉴스</th>
			    <th>정치</th>
			    <th>사회</th>
			    <th>문화</th>
			    <th>교육</th>
			    <th>기타</th>
			    <th>미등록</th>
			    <th>합계</th>
			</tr>
			<c:forEach var="list" items="${resultList3}" varStatus="status">
				<c:set var="A" value="${A + list.A}" />	
				<c:set var="B" value="${B + list.B}" />		
				<c:set var="C" value="${C + list.C}" />	
				<c:set var="D" value="${D + list.D}" />		
				<c:set var="E" value="${E + list.E}" />	
				<c:set var="F" value="${F + list.F}" />		
				<c:set var="G" value="${G + list.G}" />		
				<c:set var="H" value="${H + list.H}" />		
				<c:set var="I" value="${I + list.I}" />		
				<c:set var="J" value="${J + list.J}" />		
				<c:set var="EMPTY" value="${EMPTY + list.EMPTY}" />	
				<c:set var="TOTAL" value="${TOTAL + list.TOTAL}" />		
			</c:forEach>
			<tr>
			    <td>부 &nbsp; 수</td>
			    <td style="text-align: right;"><fmt:formatNumber value="${A}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${B}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${C}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${D}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${E}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${F}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${G}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${H}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${I}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${J}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${EMPTY}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${TOTAL}"  type="number" /></td>
			</tr>
			<tr>
				<td>비 &nbsp; 율</td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${A}" integerOnly="false"/>
						<fmt:parseNumber var="tmp2" value="${TOTAL}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${B}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${C}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${D}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${E}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${F}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${G}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${H}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${I}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${J}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;">
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${EMPTY}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <!-- 합계금액 -->
			    <td style="text-align: right;">
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${TOTAL}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			</tr>    
		</table>
		<br>
		<!-- //관심분야 -->
		<!-- 합계 변수지정end:: -->
	    <c:set var="A" value="0" />					
		<c:set var="B" value="0" />						
		<c:set var="C" value="0" />					
		<c:set var="D" value="0" />						
		<c:set var="E" value="0" />					
		<c:set var="F" value="0" />						
		<c:set var="G" value="0" />					
		<c:set var="H" value="0" />						
		<c:set var="I" value="0" />					
		<c:set var="J" value="0" />						
		<c:set var="K" value="0" />			
		<c:set var="EMPTY" value="0" />			
		<c:set var="TOTAL" value="0" />			
		<!-- 합계 변수지정end:: -->
		<!-- 구독기간 -->
		<div style="font-weight: bold; padding: 5px 0;" >■ 구독기간</DIV>
		<table class="tb_list_a" style="width: 810px;">
			<colgroup>
				<col width="110px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="58px">
				<col width="62px">
			</colgroup>
			<tr>
			    <th>구 분</th>
			    <th>1~6<br>개월</th>
			    <th>7~12<br>개월</th>
			    <th>1년<br>이상</th>
			    <th>2년<br>이상</th>
			    <th>3년<br>이상</th>
			    <th>5년<br>이상</th>
			    <th>10년<br>이상</th>
			    <th>15년<br>이상</th>
			    <th>20년<br>이상</th>
			    <th>25년<br>이상</th>
			    <th>30년<br>이상</th>
			    <th>합계</th>
			</tr>
			<c:forEach var="list" items="${resultList4}" varStatus="status">
				<c:set var="A" value="${A + list.A}" />	
				<c:set var="B" value="${B + list.B}" />		
				<c:set var="C" value="${C + list.C}" />	
				<c:set var="D" value="${D + list.D}" />		
				<c:set var="E" value="${E + list.E}" />	
				<c:set var="F" value="${F + list.F}" />		
				<c:set var="G" value="${G + list.G}" />		
				<c:set var="H" value="${H + list.H}" />		
				<c:set var="I" value="${I + list.I}" />		
				<c:set var="J" value="${J + list.J}" />		
				<c:set var="K" value="${K + list.K}" />	
				<c:set var="TOTAL" value="${TOTAL + list.TOTAL}" />		
			</c:forEach>
			<tr>
			    <td>부 &nbsp; 수</td>
			    <td style="text-align: right;"><fmt:formatNumber value="${A}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${B}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${C}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${D}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${E}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${F}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${G}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${H}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${I}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${J}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${K}"  type="number" /></td>
			    <td style="text-align: right;"><fmt:formatNumber value="${TOTAL}"  type="number" /></td>
			</tr>
			<tr>
				<td>비 &nbsp; 율</td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${A}" integerOnly="false"/>
						<fmt:parseNumber var="tmp2" value="${TOTAL}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${B}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${C}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${D}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${E}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${F}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${G}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${H}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${I}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;" >
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${J}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <td style="text-align: right;">
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${K}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
			    </td>
			    <!-- 합계금액 -->
			    <td style="text-align: right;">
			    	<c:if test="${TOTAL ne '0'}">
				    	<fmt:parseNumber var="tmp1" value="${TOTAL}" integerOnly="false"/>
				    	<fmt:parseNumber var="tmp" value="${tmp1/tmp2}" integerOnly="false"/>
						<fmt:formatNumber value="${tmp}" maxFractionDigits="2" type="percent" />
					</c:if>
				</td>
			</tr>    
		</table>
		<!-- //구독기간 -->
	</c:if>
</div>
<!-- //list -->
