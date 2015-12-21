<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/validator.js"></script>
<script type="text/javascript">
	// 구역번호 변경 시 독자 새로 조회
	function changeGno() {
		var frm = document.frm;

		if ( frm.gno.value ) {
			
			frm.action = "/collection/manual/areaDeposit.do";
			frm.submit();	
		}
	}

	// 독자유형 변경시 새로 조회 여부 체크
	function goRefresh(objName, objValue) {

		var inStopMember = "${inStopMember}";
		var memberType = "${memberType}";

		var isRefresh = false;

		if ( "inStopMember" == objName ) {
			var obj = document.getElementsByName(objName);
			for ( var i = 0; i < obj.length; i++ ) {
				if ( obj[i].checked  ) {
					if ( obj[i].value != inStopMember ) {
						isRefresh = true;
						break;
					}
				}
			}
		}
		else if ( "memberType" == objName ) {
			var obj = document.getElementsByName(objName);
			for ( var i = 0; i < obj.length; i++ ) {
				if ( obj[i].checked  ) {
					if ( obj[i].value != memberType ) {
						isRefresh = true;
						break;
					}
				}
			}
		}
		
		if ( isRefresh ) {
			changeGno();
		}
	}

	// 우측 입금처리 내역 전체 선택
	function allCheck() {
		var frm = document.submitFrm;

		var depChkbox = frm.depChkbox;
		if ( depChkbox != null ) {
			 
			if ( depChkbox.length == undefined ) {		// 객체는 존재하지만 해당 name을 가진 객체가 1개일때(배열로 인식되지 않았을 때)
				depChkbox.checked = frm.depChkboxAll.checked;
			}
			else {
				for ( var i = 0; i < depChkbox.length; i++ ) {
					depChkbox[i].checked = frm.depChkboxAll.checked;
				}
			}
		}
	}

	// 영역안내문 처리
	function processDisplaySectorInfo(trObjId, isDisplayInfo) {
		
		var tr_tmp = document.getElementById(trObjId);
		if ( tr_tmp ) {
			if ( isDisplayInfo ) {		// 노출
				tr_tmp.style.display = "block";
			}
			else {						// 미노출
				tr_tmp.style.display = "none";
			}
		}
	}
	

	// 입금처리할 때 사용할 JSON 배열 선언
	var depositArr = {};

	// 화면 노출용 입금액계 선언
	var totalMoney = 0;
	

	// 입금처리하기 위해 임시 저장
	function setDeposit(readno, readnm, newscd, seq, yymm, sgbbcd, gno, bno, billamt) {

		var frm = document.frm;

		if ( !frm.edate.value ) {
			alert("입금일자를 입력해 주세요.");
			frm.edate.focus();
			return;
		} 

		if ( "4" == sgbbcd ) {	// 미수인 것들만 처리

			var depType = frm.depType.value;
			var depTypeArr = depType.split("|");

			var sgTypeCode = depTypeArr[0];		// 수금방법 코드(3)
			var sgTypeAlpha = depTypeArr[1];	// 수금방법 문자(1)

			//if ( "031" != sgTypeCode && "032" != sgTypeCode && "033" != sgTypeCode && "044" != sgTypeCode ) {	// 현재 설정된 수금방법이 결손,재무,휴독,미수는 처리 안함
			if ( "044" != sgTypeCode ) {	// 현재 설정된 수금방법이 미수만 처리 안함

				var sgObjName = readno + newscd + seq + yymm;
				var sgObj = document.getElementById(sgObjName);
				
				if ( "4" == sgObj.innerHTML ) {	// 현재 화면에 미수(4)로 되어 있어야 설정 가능.

					// 영역안내문 미노출 - 구독정보 목록
					processDisplaySectorInfo("tr_tmp", false);

					// 1. 화면에 노출된 미수(4)를 설정된 수금방법으로 바꿔준다.
					sgObj.innerHTML = sgTypeAlpha;
					sgObj.style.cursor = "";	// 커서에 손모양 제거

					// 2. java단에 넘길 데이터목록에 추가한다.
					var tmpMap = {};
					tmpMap.readno = readno;			// 독자번호
					tmpMap.newscd = newscd;			// 매체번호
					tmpMap.seq = seq;				// 시퀀스
					tmpMap.yymm = yymm;				// 구독년월
					tmpMap.sgbbcd = sgTypeCode;		// 수금방법
					tmpMap.sndt = frm.edate.value;	// 입금일자
					tmpMap.billamt = billamt;		// 청구금액

					depositArr[sgObjName] = tmpMap;	// 전역배열에 저장(연관배열 형태로 저장)

					// 3. 우측 입금처리할 목록에 추가한다.
					var eleTd1 = document.createElement("td");			// 선택 - 체크박스
					var depChkbox;
					if ( navigator.userAgent.indexOf("MSIE") != -1 ) {
						depChkbox = document.createElement('<input type="checkbox" id="'+'td_'+sgObjName+'" name="depChkbox" />');
					} else {
						depChkbox = document.createElement("input");
						depChkbox.setAttribute("type", "checkbox");
						depChkbox.setAttribute("id", "td_" + sgObjName);
						depChkbox.setAttribute("name", "depChkbox");
					}
					eleTd1.appendChild(depChkbox);					

					var eleTd2 = document.createElement("td");			// 독자번호
					eleTd2.innerHTML = readno+ "  " + gno + "-" + bno;

					var eleTd3 = document.createElement("td");			// 독자명
					eleTd3.innerHTML = readnm;

					var eleTd4 = document.createElement("td");			// 입금월분
					eleTd4.innerHTML = yymm;

					var eleTd5 = document.createElement("td");			// 구분
					eleTd5.innerHTML = sgTypeAlpha;

					var eleTd6 = document.createElement("td");			// 입금일자
					eleTd6.innerHTML = frm.edate.value;

					var eleTd7 = document.createElement("td");			// 입금액
					eleTd7.innerHTML = makeCurrencyVal(billamt);

					var eleTr;
					if ( navigator.userAgent.indexOf("MSIE") != -1 ) {
						eleTr = document.createElement('<tr id="'+'trtd_'+sgObjName+'" bgcolor="ffffff" align="center" >');
					} else {
						eleTr = document.createElement("tr");
						eleTr.setAttribute("id", "trtd_" + sgObjName);
						eleTr.setAttribute("bgcolor", "ffffff");
						eleTr.setAttribute("align", "center");
					}
					
					eleTr.appendChild(eleTd1);
					eleTr.appendChild(eleTd2);
					eleTr.appendChild(eleTd3);
					eleTr.appendChild(eleTd4);
					eleTr.appendChild(eleTd5);
					eleTr.appendChild(eleTd6);
					eleTr.appendChild(eleTd7);

					var depositlist = document.getElementById("depositlist");
					depositlist.appendChild(eleTr);

					// 4. 입금액계 계산
					totalMoney += Number(billamt);
					document.getElementById("totalMoney").innerHTML = makeCurrencyVal(""+totalMoney);
				}
			}
		}
	}

	// 입금취소(선택항목만 처리)
	function cancelDeposit() {
		var frm = document.submitFrm;

		var depChkbox = frm.depChkbox;
		if ( depChkbox != null ) {
			 
			if ( depChkbox.length == undefined ) {		// 객체는 존재하지만 해당 name을 가진 객체가 1개일때(배열로 인식되지 않았을 때)
				
				// 1. 화면에서 삭제
				var tdObjId = depChkbox.id;
				var trObj = document.getElementById("tr" + tdObjId);
				trObj.parentNode.removeChild(trObj);

				// 2. 수금목록에서 해당 데이터를 원래 상태인 미수(4) 로 바꿔준다.
				var sgObjId = tdObjId.replace("td_", "");
				var sgObj = document.getElementById(sgObjId);
				sgObj.innerHTML = "4";
				sgObj.style.cursor = "hand";	// 커서에 손모양 추가

				// 3. 입금액계 계산
				totalMoney -= Number(depositArr[sgObjId].billamt);
				document.getElementById("totalMoney").innerHTML = makeCurrencyVal(""+totalMoney);
	
				// 4. 전역 배열에서 삭제
				delete depositArr[sgObjId];
			}
			else {
				var tmpArray = new Array();
				for ( var i = 0; i < depChkbox.length; i++ ) {	// 아래 루프에서만 처리할려면 삭제되면서 루프가 돌기 때문에 인덱스가 안맞아 처리불가능. 
					tmpArray[i] = depChkbox[i].id;				// 임시 배열에 id 저장
				}

				var isChecked = false;
				for ( var i = 0; i < tmpArray.length; i++ ) {	// 객체도 존재하고 2개 이상일 때(배열로 인식)

					var depChkbox = document.getElementById(tmpArray[i]);
		
					// 체크된 항목만 처리
					if ( depChkbox.checked == true ) {

						if ( isChecked == false ) {
							isChecked = true;
						}
						
						// 1. 화면에서 삭제
						var tdObjId = depChkbox.id;
						var trObj = document.getElementById("tr" + tdObjId);
						trObj.parentNode.removeChild(trObj);
						
						// 2. 수금목록에서 해당 데이터를 원래 상태인 미수(4) 로 바꿔준다.
						var sgObjId = tdObjId.replace("td_", "");
						var sgObj = document.getElementById(sgObjId);
						sgObj.innerHTML = "4";
						sgObj.style.cursor = "hand";	// 커서에 손모양 추가

						// 3. 입금액계 계산
						totalMoney -= Number(depositArr[sgObjId].billamt);
						document.getElementById("totalMoney").innerHTML = makeCurrencyVal(""+totalMoney);

						// 4. 전역 배열에서 삭제
						delete depositArr[sgObjId];
					}
				}

				if ( isChecked == false ) {
					alert("입금취소할 정보를 선택해 주세요.");
					return ;
				}
			}
		}
		else {
			alert("입금취소할 정보가 없습니다.");
			return ;
		}

		// 전체선택 checkbox 초기화
		document.getElementById("depChkboxAll").checked = false;

		// 입금액계가 0원이면 노출안함.
		if ( totalMoney == 0 ) {
			document.getElementById("totalMoney").innerHTML = "";
		}
	}

	// 입금처리(선택여부와 상관없음)
	function goDeposit() {
		var frm = document.frm;
		var submitFrm = document.submitFrm;

		submitFrm.depositArr.value = Object.toJSON(depositArr);		// JSON 객체로 변환

		if ( ! submitFrm.depositArr.value ) {
			alert("입금처리할 정보가 없습니다.");
			return ;
		}

		submitFrm.edate.value = frm.edate.value;
		submitFrm.gno.value = frm.gno.value;
		submitFrm.newscd.value = frm.newscd.value;
		submitFrm.depType.value = frm.depType.value;
		var inStopMember = document.getElementsByName("inStopMember");
		for ( var i = 0; i < inStopMember.length; i++ ) {
			if ( inStopMember[i].checked  ) {
				submitFrm.inStopMember.value = inStopMember[i].value;
				break;
			}
		}
		var memberType = document.getElementsByName("memberType");
		for ( var i = 0; i < memberType.length; i++ ) {
			if ( memberType[i].checked  ) {
				submitFrm.memberType.value = memberType[i].value;
				break;
			}
		}

		submitFrm.action = "/collection/manual/areaDepositProcess.do";
		submitFrm.submit();
	}
//-->
</script>
<div><span class="subTitle">구역별입금</span></div>
<div style="overflow: hidden;">
	<div style="float: left; width: 700px;">
		<!-- search conditions -->
		<form id="frm" name="frm" method="post">
		<div style="width: 700px;">
			<table class="tb_search">
				<colgroup>
					<col width="42px">
					<col width="65px">
					<col width="42px">
					<col width="105px">
					<col width="42px">
					<col width="95px">
					<col width="42px">
					<col width="85px">
					<col width="182px">
				</colgroup>
				  <tr>
				    <th>구역</th>
				    <td>
				    	<select id="gno" name="gno" onchange="changeGno();">
				    		<option value="">선택</option>
							<c:forEach items="${areaList}" var="list">
								<option value="${list.GU_NO }" <c:if test="${list.GU_NO eq gno}">selected</c:if>>${list.GU_NO}</option>
							</c:forEach>
								<option value="ALL" <c:if test="${'ALL' eq gno}">selected</c:if>>전체</option>
						</select>
				    </td>
				    <th>매체</th>
				    <td>
				    	<select id="newscd" name="newscd" onchange="changeGno();">
							<c:forEach items="${agencyNewsList}" var="list">
								<option value="${list.NEWSCD}" <c:if test="${list.NEWSCD eq newscd}">selected</c:if>>${list.CNAME}</option>
							</c:forEach>
						</select>
				    </td>
				    <th>방법</th>
				    <td>
				    	<select id="depType" name="depType">
							<c:forEach items="${sgTypeList}" var="list">
								<option value="${list.CODE}|${list.YNAME}" <c:if test="${list.CODE eq depType}">selected</c:if>>${list.CNAME}</option>
							</c:forEach>
						</select>
				    </td>
					<th>입금<br />일자</th>
					<td>
						<input type="text"  name="edate" value="<c:out value='${edate}' />"  style="width: 70px;" readonly onclick="Calendar(this)">
					</td>
					<th>
						<input type="radio" name="inStopMember" onclick="goRefresh('inStopMember', this.value);" value="1" style="border: 0; vertical-align: middle;" <c:if test="${empty inStopMember or inStopMember eq '1' }">checked</c:if> /> 중지독자포함
						<input type="radio" name="inStopMember" onclick="goRefresh('inStopMember', this.value);" value="2" style="border: 0; vertical-align: middle;" <c:if test="${inStopMember eq '2' }">checked</c:if> /> 미포함 
						<br>
						<input type="radio" name="memberType" onclick="goRefresh('memberType', this.value);" value="all" style="border: 0; vertical-align: middle;" <c:if test="${memberType eq 'all'}">checked</c:if> /> 전체 
						<input type="radio" name="memberType" onclick="goRefresh('memberType', this.value);" value="044" style="border: 0; vertical-align: middle;" <c:if test="${empty memberType or memberType eq '044'}">checked</c:if> /> 미수독자
					</th>
				  </tr>		  						  						  						  						  						  						  		   
				</table>
		</div>
		</form>
		<!-- //search conditions -->
		<!-- notice -->
		<div style="padding: 5px 0 10px 0">
			<span style="color:red;">※ 구역번호 변경, 매체변경, 옵션변경을 하시면 구독정보별 수금내역이 자동으로 조회됩니다.</span>
		</div>
		<!-- //notice -->
		<div style="border: 1px solid #e5e5e5; padding: 5px;">
			<table class="tb_list_n" style="width: 690px;">
				<colgroup> 
					<col width="82px">
					<col width="83px">
					<col width="21px">
					<col width="21px">
					<col width="21px">
					<col width="21px">
					<col width="21px">
					<col width="21px">
					<col width="21px">
					<col width="21px">
					<col width="21px">
					<col width="21px">
					<col width="21px">
					<col width="21px">
					<col width="21px">
					<col width="21px">
					<col width="21px">
					<col width="21px">
					<col width="21px">
					<col width="21px">
					<col width="21px">
					<col width="21px">
					<col width="21px">
					<col width="21px">
					<col width="21px">
					<col width="21px">
					<col width="21px">
				</colgroup>
				 <tr>
				    <th>독자번호</th>
					<th>독 자 명</th>
					<th>1</th><th>2</th><th>3</th><th>4</th><th>5</th><th>6</th><th>7</th><th>8</th><th>9</th><th>10</th><th>11</th><th>12</th>
					<th>1</th><th>2</th><th>3</th><th>4</th><th>5</th><th>6</th><th>7</th><th>8</th><th>9</th><th>10</th><th>11</th><th>12</th>
					<th></th>
				  </tr>
				<tr> 
			</table>
			<div style="overflow-x:none; overflow-y:scroll; height: 462px; width: 687px; border: 0px solid red">
				<table class="tb_list_n" style="width: 670px;">
					<colgroup>
						<col width="82px">
						<col width="82px">
						<col width="21px">
						<col width="21px">
						<col width="21px">
						<col width="21px">
						<col width="21px">
						<col width="21px">
						<col width="21px">
						<col width="21px">
						<col width="21px">
						<col width="21px">
						<col width="21px">
						<col width="21px">
						<col width="21px">
						<col width="21px">
						<col width="21px">
						<col width="21px">
						<col width="21px">
						<col width="21px">
						<col width="21px">
						<col width="21px">
						<col width="21px">
						<col width="21px">
						<col width="21px">
						<col width="21px">
					</colgroup>
					<c:choose>
						<c:when test="${not empty sugmList}">
							<!-- loop -->
							<c:forEach items="${sugmList}" var="list">
							<tr>
								<td align="left"><c:out value="${list.READNO}" /><br><c:out value="${list.GNO}" />-<c:out value="${list.BNO}" /></td>
								<td align="left"><c:out value="${list.READNM}" /></td>
								<td id="${list.READNO}${list.NEWSCD}${list.SEQ}${list.YYMM_01}" style="<c:choose><c:when test="${list.SGBBCD_01 eq '4'}">color:red;text-decoration: underline</c:when><c:otherwise>color:blue</c:otherwise></c:choose>; cursor: pointer" onclick="setDeposit('${list.READNO}', '${list.READNM}', '${list.NEWSCD}', '${list.SEQ}', '${list.YYMM_01}', '${list.SGBBCD_01}', '${list.GNO}', '${list.BNO}', '${list.BILLAMT_01}');"><c:out value="${list.SGBBCD_01}" /></td>
									<td id="${list.READNO}${list.NEWSCD}${list.SEQ}${list.YYMM_02}" style="<c:choose><c:when test="${list.SGBBCD_02 eq '4'}">color:red;text-decoration: underline</c:when><c:otherwise>color:blue</c:otherwise></c:choose>; cursor: pointer" onclick="setDeposit('${list.READNO}', '${list.READNM}', '${list.NEWSCD}', '${list.SEQ}', '${list.YYMM_02}', '${list.SGBBCD_02}', '${list.GNO}', '${list.BNO}', '${list.BILLAMT_02}');"><c:out value="${list.SGBBCD_02}" /></td>
									<td id="${list.READNO}${list.NEWSCD}${list.SEQ}${list.YYMM_03}" style="<c:choose><c:when test="${list.SGBBCD_03 eq '4'}">color:red;text-decoration: underline</c:when><c:otherwise>color:blue</c:otherwise></c:choose>; cursor: pointer" onclick="setDeposit('${list.READNO}', '${list.READNM}', '${list.NEWSCD}', '${list.SEQ}', '${list.YYMM_03}', '${list.SGBBCD_03}', '${list.GNO}', '${list.BNO}', '${list.BILLAMT_03}');"><c:out value="${list.SGBBCD_03}" /></td>
									<td id="${list.READNO}${list.NEWSCD}${list.SEQ}${list.YYMM_04}" style="<c:choose><c:when test="${list.SGBBCD_04 eq '4'}">color:red;text-decoration: underline</c:when><c:otherwise>color:blue</c:otherwise></c:choose>; cursor: pointer" onclick="setDeposit('${list.READNO}', '${list.READNM}', '${list.NEWSCD}', '${list.SEQ}', '${list.YYMM_04}', '${list.SGBBCD_04}', '${list.GNO}', '${list.BNO}', '${list.BILLAMT_04}');"><c:out value="${list.SGBBCD_04}" /></td>
									<td id="${list.READNO}${list.NEWSCD}${list.SEQ}${list.YYMM_05}" style="<c:choose><c:when test="${list.SGBBCD_05 eq '4'}">color:red;text-decoration: underline</c:when><c:otherwise>color:blue</c:otherwise></c:choose>; cursor: pointer" onclick="setDeposit('${list.READNO}', '${list.READNM}', '${list.NEWSCD}', '${list.SEQ}', '${list.YYMM_05}', '${list.SGBBCD_05}', '${list.GNO}', '${list.BNO}', '${list.BILLAMT_05}');"><c:out value="${list.SGBBCD_05}" /></td>
									<td id="${list.READNO}${list.NEWSCD}${list.SEQ}${list.YYMM_06}" style="<c:choose><c:when test="${list.SGBBCD_06 eq '4'}">color:red;text-decoration: underline</c:when><c:otherwise>color:blue</c:otherwise></c:choose>; cursor: pointer" onclick="setDeposit('${list.READNO}', '${list.READNM}', '${list.NEWSCD}', '${list.SEQ}', '${list.YYMM_06}', '${list.SGBBCD_06}', '${list.GNO}', '${list.BNO}', '${list.BILLAMT_06}');"><c:out value="${list.SGBBCD_06}" /></td>
									<td id="${list.READNO}${list.NEWSCD}${list.SEQ}${list.YYMM_07}" style="<c:choose><c:when test="${list.SGBBCD_07 eq '4'}">color:red;text-decoration: underline</c:when><c:otherwise>color:blue</c:otherwise></c:choose>; cursor: pointer" onclick="setDeposit('${list.READNO}', '${list.READNM}', '${list.NEWSCD}', '${list.SEQ}', '${list.YYMM_07}', '${list.SGBBCD_07}', '${list.GNO}', '${list.BNO}', '${list.BILLAMT_07}');"><c:out value="${list.SGBBCD_07}" /></td>
									<td id="${list.READNO}${list.NEWSCD}${list.SEQ}${list.YYMM_08}" style="<c:choose><c:when test="${list.SGBBCD_08 eq '4'}">color:red;text-decoration: underline</c:when><c:otherwise>color:blue</c:otherwise></c:choose>; cursor: pointer" onclick="setDeposit('${list.READNO}', '${list.READNM}', '${list.NEWSCD}', '${list.SEQ}', '${list.YYMM_08}', '${list.SGBBCD_08}', '${list.GNO}', '${list.BNO}', '${list.BILLAMT_08}');"><c:out value="${list.SGBBCD_08}" /></td>
									<td id="${list.READNO}${list.NEWSCD}${list.SEQ}${list.YYMM_09}" style="<c:choose><c:when test="${list.SGBBCD_09 eq '4'}">color:red;text-decoration: underline</c:when><c:otherwise>color:blue</c:otherwise></c:choose>; cursor: pointer" onclick="setDeposit('${list.READNO}', '${list.READNM}', '${list.NEWSCD}', '${list.SEQ}', '${list.YYMM_09}', '${list.SGBBCD_09}', '${list.GNO}', '${list.BNO}', '${list.BILLAMT_09}');"><c:out value="${list.SGBBCD_09}" /></td>
									<td id="${list.READNO}${list.NEWSCD}${list.SEQ}${list.YYMM_10}" style="<c:choose><c:when test="${list.SGBBCD_10 eq '4'}">color:red;text-decoration: underline</c:when><c:otherwise>color:blue</c:otherwise></c:choose>; cursor: pointer" onclick="setDeposit('${list.READNO}', '${list.READNM}', '${list.NEWSCD}', '${list.SEQ}', '${list.YYMM_10}', '${list.SGBBCD_10}', '${list.GNO}', '${list.BNO}', '${list.BILLAMT_10}');"><c:out value="${list.SGBBCD_10}" /></td>
									<td id="${list.READNO}${list.NEWSCD}${list.SEQ}${list.YYMM_11}" style="<c:choose><c:when test="${list.SGBBCD_11 eq '4'}">color:red;text-decoration: underline</c:when><c:otherwise>color:blue</c:otherwise></c:choose>; cursor: pointer" onclick="setDeposit('${list.READNO}', '${list.READNM}', '${list.NEWSCD}', '${list.SEQ}', '${list.YYMM_11}', '${list.SGBBCD_11}', '${list.GNO}', '${list.BNO}', '${list.BILLAMT_11}');"><c:out value="${list.SGBBCD_11}" /></td>
									<td id="${list.READNO}${list.NEWSCD}${list.SEQ}${list.YYMM_12}" style="<c:choose><c:when test="${list.SGBBCD_12 eq '4'}">color:red;text-decoration: underline</c:when><c:otherwise>color:blue</c:otherwise></c:choose>; cursor: pointer" onclick="setDeposit('${list.READNO}', '${list.READNM}', '${list.NEWSCD}', '${list.SEQ}', '${list.YYMM_12}', '${list.SGBBCD_12}', '${list.GNO}', '${list.BNO}', '${list.BILLAMT_12}');"><c:out value="${list.SGBBCD_12}" /></td>
									<td id="${list.READNO}${list.NEWSCD}${list.SEQ}${list.YYMM_13}" style="<c:choose><c:when test="${list.SGBBCD_13 eq '4'}">color:red;text-decoration: underline</c:when><c:otherwise>color:blue</c:otherwise></c:choose>; cursor: pointer" onclick="setDeposit('${list.READNO}', '${list.READNM}', '${list.NEWSCD}', '${list.SEQ}', '${list.YYMM_13}', '${list.SGBBCD_13}', '${list.GNO}', '${list.BNO}', '${list.BILLAMT_13}');"><c:out value="${list.SGBBCD_13}" /></td>
									<td id="${list.READNO}${list.NEWSCD}${list.SEQ}${list.YYMM_14}" style="<c:choose><c:when test="${list.SGBBCD_14 eq '4'}">color:red;text-decoration: underline</c:when><c:otherwise>color:blue</c:otherwise></c:choose>; cursor: pointer" onclick="setDeposit('${list.READNO}', '${list.READNM}', '${list.NEWSCD}', '${list.SEQ}', '${list.YYMM_14}', '${list.SGBBCD_14}', '${list.GNO}', '${list.BNO}', '${list.BILLAMT_14}');"><c:out value="${list.SGBBCD_14}" /></td>
									<td id="${list.READNO}${list.NEWSCD}${list.SEQ}${list.YYMM_15}" style="<c:choose><c:when test="${list.SGBBCD_15 eq '4'}">color:red;text-decoration: underline</c:when><c:otherwise>color:blue</c:otherwise></c:choose>; cursor: pointer" onclick="setDeposit('${list.READNO}', '${list.READNM}', '${list.NEWSCD}', '${list.SEQ}', '${list.YYMM_15}', '${list.SGBBCD_15}', '${list.GNO}', '${list.BNO}', '${list.BILLAMT_15}');"><c:out value="${list.SGBBCD_15}" /></td>
									<td id="${list.READNO}${list.NEWSCD}${list.SEQ}${list.YYMM_16}" style="<c:choose><c:when test="${list.SGBBCD_16 eq '4'}">color:red;text-decoration: underline</c:when><c:otherwise>color:blue</c:otherwise></c:choose>; cursor: pointer" onclick="setDeposit('${list.READNO}', '${list.READNM}', '${list.NEWSCD}', '${list.SEQ}', '${list.YYMM_16}', '${list.SGBBCD_16}', '${list.GNO}', '${list.BNO}', '${list.BILLAMT_16}');"><c:out value="${list.SGBBCD_16}" /></td>
									<td id="${list.READNO}${list.NEWSCD}${list.SEQ}${list.YYMM_17}" style="<c:choose><c:when test="${list.SGBBCD_17 eq '4'}">color:red;text-decoration: underline</c:when><c:otherwise>color:blue</c:otherwise></c:choose>; cursor: pointer" onclick="setDeposit('${list.READNO}', '${list.READNM}', '${list.NEWSCD}', '${list.SEQ}', '${list.YYMM_17}', '${list.SGBBCD_17}', '${list.GNO}', '${list.BNO}', '${list.BILLAMT_17}');"><c:out value="${list.SGBBCD_17}" /></td>
									<td id="${list.READNO}${list.NEWSCD}${list.SEQ}${list.YYMM_18}" style="<c:choose><c:when test="${list.SGBBCD_18 eq '4'}">color:red;text-decoration: underline</c:when><c:otherwise>color:blue</c:otherwise></c:choose>; cursor: pointer" onclick="setDeposit('${list.READNO}', '${list.READNM}', '${list.NEWSCD}', '${list.SEQ}', '${list.YYMM_18}', '${list.SGBBCD_18}', '${list.GNO}', '${list.BNO}', '${list.BILLAMT_18}');"><c:out value="${list.SGBBCD_18}" /></td>
									<td id="${list.READNO}${list.NEWSCD}${list.SEQ}${list.YYMM_19}" style="<c:choose><c:when test="${list.SGBBCD_19 eq '4'}">color:red;text-decoration: underline</c:when><c:otherwise>color:blue</c:otherwise></c:choose>; cursor: pointer" onclick="setDeposit('${list.READNO}', '${list.READNM}', '${list.NEWSCD}', '${list.SEQ}', '${list.YYMM_19}', '${list.SGBBCD_19}', '${list.GNO}', '${list.BNO}', '${list.BILLAMT_19}');"><c:out value="${list.SGBBCD_19}" /></td>
									<td id="${list.READNO}${list.NEWSCD}${list.SEQ}${list.YYMM_20}" style="<c:choose><c:when test="${list.SGBBCD_20 eq '4'}">color:red;text-decoration: underline</c:when><c:otherwise>color:blue</c:otherwise></c:choose>; cursor: pointer" onclick="setDeposit('${list.READNO}', '${list.READNM}', '${list.NEWSCD}', '${list.SEQ}', '${list.YYMM_20}', '${list.SGBBCD_20}', '${list.GNO}', '${list.BNO}', '${list.BILLAMT_20}');"><c:out value="${list.SGBBCD_20}" /></td>
									<td id="${list.READNO}${list.NEWSCD}${list.SEQ}${list.YYMM_21}" style="<c:choose><c:when test="${list.SGBBCD_21 eq '4'}">color:red;text-decoration: underline</c:when><c:otherwise>color:blue</c:otherwise></c:choose>; cursor: pointer" onclick="setDeposit('${list.READNO}', '${list.READNM}', '${list.NEWSCD}', '${list.SEQ}', '${list.YYMM_21}', '${list.SGBBCD_21}', '${list.GNO}', '${list.BNO}', '${list.BILLAMT_21}');"><c:out value="${list.SGBBCD_21}" /></td>
									<td id="${list.READNO}${list.NEWSCD}${list.SEQ}${list.YYMM_22}" style="<c:choose><c:when test="${list.SGBBCD_22 eq '4'}">color:red;text-decoration: underline</c:when><c:otherwise>color:blue</c:otherwise></c:choose>; cursor: pointer" onclick="setDeposit('${list.READNO}', '${list.READNM}', '${list.NEWSCD}', '${list.SEQ}', '${list.YYMM_22}', '${list.SGBBCD_22}', '${list.GNO}', '${list.BNO}', '${list.BILLAMT_22}');"><c:out value="${list.SGBBCD_22}" /></td>
									<td id="${list.READNO}${list.NEWSCD}${list.SEQ}${list.YYMM_23}" style="<c:choose><c:when test="${list.SGBBCD_23 eq '4'}">color:red;text-decoration: underline</c:when><c:otherwise>color:blue</c:otherwise></c:choose>; cursor: pointer" onclick="setDeposit('${list.READNO}', '${list.READNM}', '${list.NEWSCD}', '${list.SEQ}', '${list.YYMM_23}', '${list.SGBBCD_23}', '${list.GNO}', '${list.BNO}', '${list.BILLAMT_23}');"><c:out value="${list.SGBBCD_23}" /></td>
									<td id="${list.READNO}${list.NEWSCD}${list.SEQ}${list.YYMM_24}" style="<c:choose><c:when test="${list.SGBBCD_24 eq '4'}">color:red;text-decoration: underline</c:when><c:otherwise>color:blue</c:otherwise></c:choose>; cursor: pointer" onclick="setDeposit('${list.READNO}', '${list.READNM}', '${list.NEWSCD}', '${list.SEQ}', '${list.YYMM_24}', '${list.SGBBCD_24}', '${list.GNO}', '${list.BNO}', '${list.BILLAMT_24}');"><c:out value="${list.SGBBCD_24}" /></td>
							</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
					  		<tr bgcolor="ffffff" align="center">
					  			<td colspan="26">구독정보별 최근 2년내 수금내역이 나오는 영역입니다.</td>
					  		</tr>
						</c:otherwise>
					</c:choose>
				</table>
			</div>
		</div>
	</div>
	<div style="float: left; padding-left: 5px;">
		<!-- button -->
		<div style="padding: 24px 0 34px 0; text-align: right;">
			<a href="#fakeUrl" onclick="cancelDeposit();"><img src="/images/bt_eepd.gif" border="0" alt="입금취소"></a>&nbsp;
			<a href="#fakeUrl" onclick="goDeposit();"><img src="/images/bt_eepc.gif" border="0" alt="입금처리"></a>					
		</div>
		<!-- //button -->
		<form id="submitFrm" name="submitFrm" method="post">
		<input type="hidden" id="edate" name="edate" />						<!-- 입금일자 -->
		<input type="hidden" id="gno" name="gno" />							<!-- 구역번호 -->
		<input type="hidden" id="newscd" name="newscd" />					<!-- 매체코드 -->
		<input type="hidden" id="depType" name="depType" />					<!-- 수금방법 -->
		<input type="hidden" id="inStopMember" name="inStopMember" />		<!-- 중지독자포함여부 -->
		<input type="hidden" id="memberType" name="memberType" />			<!-- 전체 or 미수독자 -->
		<input type="hidden" id="depositArr" name="depositArr" />			<!-- 입금처리할 JSON Map -->
		<div>
			<div style="height:433px;overflow-x:scroll; overflow-y:scroll;  border: 1px solid #e5e5e5; padding: 5px 0;">
			<table class="tb_list_a" style="width: 290px">
				<colgroup>
					<col width="20px">
					<col width="45px">
					<col width="45px">
					<col width="45px">
					<col width="45px">
					<col width="45px">
					<col width="45px">
				</colgroup>
				<tr bgcolor="f9f9f9" align="center" class="box_p">
					<td><input type="checkbox" id="depChkboxAll" onclick="allCheck();" style="border: 0;" /></td>
					<td style="letter-spacing: -3px">독자번호</td>
					<td>독자명</td>
					<td style="letter-spacing: -3px">입금월분</td>
					<td>구분</td>
					<td style="letter-spacing: -3px">입금일자</td>
					<td>입금액</td>
				</tr>
			  <!--loop-->
			  <!-- 
			  <tr id="tr_test" bgcolor="ffffff" align="center">
			    <td><input type="checkbox" id="td_test" name="td_test" /></td>
				<td>123123123-001</td>
				<td>(주)현대영어사/초등</td>
				<td>2011-05</td>
				<td>B</td>
				<td>2011-11-30</td>
				<td>15000</td>
			  </tr>
			   -->
				<span id="depositlist">
				<tr id="tr_tmp">	<!-- 이 코드 지우지 마세요. -->
					<td colspan="7">입금처리할 수금목록이 보이는 영역입니다.</td>
				</tr>
				</span>
			 </table>
			</div>
		</div>
		<div style="padding-top: 5px; overflow: hidden;">
			<div style="width: 110px; border: 1px solid #e5e5e5; float: left; text-align: center; padding: 3px 0; font-weight: bold">입금액계</div>
			<div id="totalMoney" style="width:196px; border: 1px solid #e5e5e5; float: left; margin-left: -1px; padding: 3px 0;">&nbsp;</div>
		</div>
		</form>
	</div>
</div>


