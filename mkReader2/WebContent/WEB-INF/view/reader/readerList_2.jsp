<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.security.*" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
String agency_userid = (String)session.getAttribute(ISiteConstant.SESSION_NAME_AGENCY_USERID);
%>

<style>
#xlist {
	width: 100%;
	height: 400px;
	overflow-y: scroll;
}
</style>
<SCRIPT LANGUAGE="JavaScript" src="/js/mini_calendar2.js"></SCRIPT>
<script type="text/javascript" src="/js/ajaxUtil.js" charset="UTF-8"></script>
<script type="text/javascript">
	//  자세히 보기, 독자 수금정보 조회(ajax)
	function detailView(index) {
		clearField();
		$("boSeq").value = document.getElementById('tem_boSeq0').innerHTML;
		$("seq").value = document.getElementById('tem_seq'+index).innerHTML;
		$("readNo").value = document.getElementById('tem_readNo'+index).innerHTML;
		$("gnoNm").value = document.getElementById('tem_gno'+index).innerHTML+"구역";
		$("gno").value = document.getElementById('tem_gno'+index).innerHTML;
		$("bno").value = document.getElementById('tem_bno'+index).innerHTML;
		$("sno").value = document.getElementById('tem_sno'+index).innerHTML;
		$("readNm").value = replaceHtml(document.getElementById('tem_readNm'+index).innerHTML);
		$("bidt").value = document.getElementById('tem_bidt'+index).innerHTML;
		$("homeTel1").value = document.getElementById('tem_homeTel1'+index).innerHTML;
		$("homeTel2").value = document.getElementById('tem_homeTel2'+index).innerHTML;
		$("homeTel3").value = document.getElementById('tem_homeTel3'+index).innerHTML;
		$("mobile1").value = document.getElementById('tem_mobile1'+index).innerHTML;
		$("mobile2").value = document.getElementById('tem_mobile2'+index).innerHTML;
		$("mobile3").value = document.getElementById('tem_mobile3'+index).innerHTML;
		$("eMail").value = document.getElementById('tem_eMail'+index).innerHTML;
		$("dlvZip").value = document.getElementById('tem_dlvZip'+index).innerHTML;
		$("dlvAdrs1").value = document.getElementById('tem_dlvAdrs1'+index).innerHTML;
		$("dlvAdrs2").value = replaceHtml(document.getElementById('tem_dlvAdrs2'+index).innerHTML);
		$("rsdTypeCd").value = document.getElementById('tem_rsdTypeCd'+index).innerHTML;
		$("taskCd").value = document.getElementById('tem_taskCd'+index).innerHTML;
		$("intFldCd").value = document.getElementById('tem_intFldCd'+index).innerHTML;  
		$("newsCd").value = document.getElementById('tem_newsCd'+index).innerHTML;
		$("oldNewsCd").value = document.getElementById('tem_newsCd'+index).innerHTML;
		$("oldGno").value = document.getElementById('tem_gno'+index).innerHTML;
		if(document.getElementById('tem_receipt'+index).innerHTML == 'N'){
			$("receipt").checked = true;			
		}else{
			$("receipt").checked = false;
		}
		var hjDt = document.getElementById('tem_hjDt'+index).innerHTML;
		var aplcDt = document.getElementById('tem_aplcDt'+index).innerHTML;

		if(aplcDt != ''){
			$("hjDt2").value = aplcDt.substring(0,4) + "-" + aplcDt.substring(4,6) + "-" + aplcDt.substring(6,8);
		}
		if(hjDt != ''){
			$("hjDt").value = hjDt.substring(0,4) + "-" + hjDt.substring(4,6) + "-" + hjDt.substring(6,8);
		}
		$("readTypeCd").value = document.getElementById('tem_readTypeCd'+index).innerHTML;
		$("oldReadTypeCd").value = document.getElementById('tem_readTypeCd'+index).innerHTML;
		$("qty").value = document.getElementById('tem_qty'+index).innerHTML;
		$("sumQty").value = document.getElementById('tem_sumQty'+index).innerHTML;
		$("oldQty").value = document.getElementById('tem_qty'+index).innerHTML;
		$("uPrice").value = document.getElementById('tem_uPrice'+index).innerHTML;
		$("sumUprice").value = document.getElementById('tem_sumUprice'+index).innerHTML;
		$("dlvTypeCd").value = document.getElementById('tem_dlvTypeCd'+index).innerHTML;
		$("spgCd").value = document.getElementById('tem_spgCd'+index).innerHTML;
		$("dlvPosiCd").value = document.getElementById('tem_dlvPosiCd'+index).innerHTML;
		$("sgType").value = document.getElementById('tem_sgType'+index).innerHTML;
		$("oldSgType").value = document.getElementById('tem_sgType'+index).innerHTML;
		$("bnsBookCd").value = document.getElementById('tem_bnsBookCd'+index).innerHTML;
		//$("aptCd").value = document.getElementById('tem_aptCd'+index).innerHTML;
		//$("aptNm").value = document.getElementById('tem_aptNm'+index).innerHTML;
		$("remk").value = replaceHtml(document.getElementById('tem_remk'+index).innerHTML);
		$("stSayou").value = document.getElementById('tem_stSayou'+index).innerHTML;
		$("oldStSayou").value = document.getElementById('tem_OldStSayou'+index).innerHTML;
		$("sgCycle").value = document.getElementById('tem_sgCycle'+index).innerHTML;
		$("term").value = document.getElementById('tem_term'+index).innerHTML+"개월";
		$("boReadNo").value = document.getElementById('tem_boReadNo'+index).innerHTML;
		document.getElementById('callLog').innerHTML =  "<a href=\"javascript:callLog();\">"+document.getElementById('tem_callLog'+index).innerHTML+' 건' +"</a>"; 
 		if(document.getElementById('tem_stdt'+index).innerHTML != ''){
			var stdt = document.getElementById('tem_stdt'+index).innerHTML;
			$("oldStdt").value = stdt.substring(0,4) + "-" + stdt.substring(4,6) + "-" + stdt.substring(6,8);
			$("stdt").value = stdt.substring(0,4) + "-" + stdt.substring(4,6) + "-" + stdt.substring(6,8);	
		}else{
			$("stdt").value = '';
		}
		
		var sgBgmm = document.getElementById('tem_sgBgmm'+index).innerHTML;
		if(sgBgmm != ''){
			$("sgBgmm").value = sgBgmm.substring(0,4)+"-"+sgBgmm.substring(4,6);	
		}		
		var hjPathCd = document.getElementById('tem_hjPathCd'+index).innerHTM;
		$("hjPathCd").value = document.getElementById('tem_hjPathCd'+index).innerHTML;
		$("hjPsnm").options[0] = new Option(document.getElementById('tem_hjPsnm'+index).innerHTML,document.getElementById('tem_hjPsnm'+index).innerHTML);
		$("hjPsregCd").options[0] = new Option(document.getElementById('tem_hjPsregCd'+index).innerHTML,document.getElementById('tem_hjPsregCd'+index).innerHTML);
		for( i = 1 ; i < 13 ; i++ ){
			if(i<10){
				i = '0'+ i;
			}
			if(document.getElementById("pre01").style.display == 'block'){
				document.getElementById("now"+i).style.display  = 'none';
				document.getElementById("next"+i).style.display  = 'none';
			}else if(document.getElementById("now01").style.display == 'block'){
				document.getElementById("pre"+i).style.display  = 'none';
				document.getElementById("next"+i).style.display  = 'none';
			}else if(document.getElementById("next01").style.display == 'block'){
				document.getElementById("pre"+i).style.display  = 'none';
				document.getElementById("now"+i).style.display  = 'none';
			}
		}
		var url = "/collection/collection/ajaxCollectionList.do?seq="+$('seq').value+"&readNo="+$('readNo').value+"&newsCd="+$('newsCd').value+"&boSeq="+$('boSeq').value;
		sendAjaxRequest(url, "readerListForm", "post", collectionList);
	}

	//수금정보 셋팅 펑션
	function collectionList(responseHttpObj) {
		if (responseHttpObj) {
			try {
				var result = eval("(" + responseHttpObj.responseText + ")");
				if (result) {
					setCollectionList(result);
				}
			} catch (e) {
				alert("오류 : " + e);
			}
		}
	}

	function setCollectionList(jsonObjArr) {
		var nowYear = '${nowyymm12}'; //현재 사용월분
		//초기화
		for(var j=1 ; j < 13 ; j++){
			if(j < 10){
				seq ='0'+j;
			}else{
				seq = j;
			}
			
			$("preBillAmt"+seq).readOnly = false;
			$("preAmt"+seq).readOnly = false;
			$("preSgbbCd"+seq).options.length = 0;
			$("nowBillAmt"+seq).readOnly = false;
			$("nowAmt"+seq).readOnly = false;
			$("nowSgbbCd"+seq).options.length = 0;

			<c:forEach items="${sgTypeList }" var="list" varStatus="i">
				$("preSgbbCd"+seq).options[${i.index+1}] = new Option('${list.CNAME }' , '${list.CODE }' );
				$("nowSgbbCd"+seq).options[${i.index+1}] = new Option('${list.CNAME }' , '${list.CODE }' );
				$("nextSgbbCd"+seq).options[${i.index+1}] = new Option('${list.CNAME }' , '${list.CODE }' );
			</c:forEach>
		}
		
		//셋팅
		if (jsonObjArr.length > 0) {
			for(var j=1 ; j < 13 ; j++){
				if(j < 10){
					seq ='0'+j;
				}else{
					seq = j;
				}
				
				for ( var i = 0; i < jsonObjArr.length- 2; i++) {
					if($("preYear"+seq).value  ==  jsonObjArr[i].YYMM ){//데이터 존재
						$("preSnDt"+seq).value = jsonObjArr[i].SNDT;
						$("preBillAmt"+seq).value = jsonObjArr[i].BILLAMT;
						$("preAmt"+seq).value = jsonObjArr[i].AMT;
/* ABC용수금 방법 콤보 컨트롤
						if(jsonObjArr[i].SGBBCD != '044'){
							$("preSgbbCd"+seq).options.length = 0;
							$("preSgbbCd"+seq).options[0] = new Option(jsonObjArr[i].SGBBNM , jsonObjArr[i].SGBBCD );	
						}else{
							$("preSgbbCd"+seq).value = jsonObjArr[i].SGBBCD;
						}
*/
						$("preSgbbCd"+seq).value = jsonObjArr[i].SGBBCD;
					}
					if($("nowYear"+seq).value  ==  jsonObjArr[i].YYMM ){
						$("nowSnDt"+seq).value = jsonObjArr[i].SNDT;
						$("nowBillAmt"+seq).value = jsonObjArr[i].BILLAMT;
						$("nowAmt"+seq).value = jsonObjArr[i].AMT;
/* ABC용수금 방법 콤보 컨트롤
						if( Number($("nowYear"+seq).value) < Number(nowYear)  ){
							if(jsonObjArr[i].SGBBCD != '044'){
								$("nowSgbbCd"+seq).options.length = 0;
								$("nowSgbbCd"+seq).options[0] = new Option(jsonObjArr[i].SGBBNM , jsonObjArr[i].SGBBCD );	
							}else{
								$("nowSgbbCd"+seq).value = jsonObjArr[i].SGBBCD;
							}	
						}else{
							$("nowSgbbCd"+seq).value = jsonObjArr[i].SGBBCD;
						}
*/
						$("nowSgbbCd"+seq).value = jsonObjArr[i].SGBBCD;
					}	
					if($("nextYear"+seq).value  ==  jsonObjArr[i].YYMM ){
						$("nextSnDt"+seq).value = jsonObjArr[i].SNDT;
						$("nextBillAmt"+seq).value = jsonObjArr[i].BILLAMT;
						$("nextAmt"+seq).value = jsonObjArr[i].AMT;
						$("nextSgbbCd"+seq).value = jsonObjArr[i].SGBBCD;
					}
				}
			} 
			for ( var i = 0; i < jsonObjArr.length; i++) {
				if (i == jsonObjArr.length - 2) {
					$("sumgClam").innerHTML = jsonObjArr[i].thisYear;
					$("thisYearSumgClam").innerHTML = jsonObjArr[i].thisYear;
				}
				if (i == jsonObjArr.length - 1) {
					$("lastYearSumgClam").innerHTML = jsonObjArr[i].lastYear;
				}
			}
		}
		//현재월부터 이후는 수정가능
		//현재월 이전은 미수만 가능
		for(var j=1 ; j < 13 ; j++){
			if(j < 10){
				seq ='0'+j;
			}else{
				seq = j;
			}
/* ABC용 수금관리 컨트롤
			if($("preSgbbCd"+seq).value == ''){
				$("preSnDt"+seq).readOnly = true;
				$("preBillAmt"+seq).readOnly = true;
				$("preAmt"+seq).readOnly = true;
				$("preSgbbCd"+seq).options.length = 0;
			}else{
				if($("preSgbbCd"+seq).value != '044'){
					$("preBillAmt"+seq).readOnly = true;
					$("preAmt"+seq).readOnly = true;
				}
			}
			if( Number($("nowYear"+seq).value) < Number(nowYear)  ){
				if($("nowSgbbCd"+seq).value == ''){
					$("nowSnDt"+seq).readOnly = true;
					$("nowBillAmt"+seq).readOnly = true;
					$("nowAmt"+seq).readOnly = true;
					$("nowSgbbCd"+seq).options.length = 0;
				}else{
					if($("nowSgbbCd"+seq).value != '044'){
						$("nowSnDt"+seq).readOnly = true;
						$("nowBillAmt"+seq).readOnly = true;
						$("nowAmt"+seq).readOnly = true;
					}
				}
			}
*/
		}
	}
	//작년 금년 수금
	function sumgClam(gbn){
		if(gbn == 'last'){
			$("sumgClam").innerHTML = $("lastYearSumgClam").innerHTML;	
		}else{
			$("sumgClam").innerHTML = $("thisYearSumgClam").innerHTML;	
		}
	}
	
	
	// 신청경로 변경(확장자도 같이 변경해줘야함.)
	function changeHjPath(){
		if($("hjPathCd").value =='006' || $("hjPathCd").value =='007'){
			$("boSeq").value = document.getElementById('tem_boSeq0').innerHTML;
			var url = "/reader/readerManage/ajaxHjPsNmList.do";
			sendAjaxRequest(url, "readerListForm", "post", hjPsNmList);
		}else{
			$("hjPsnm").options.length = 0;
			$("hjPsregCd").options.length = 0;
		}
		
	}
	
	function hjPsNmList(responseHttpObj) {
		if (responseHttpObj) {
			try {
				var result = eval("(" + responseHttpObj.responseText + ")");
				if (result) {
					setHjPsNmList(result);
				}
			} catch (e) {
				alert("오류 : " + e);
			}
		}
	}

	function setHjPsNmList(jsonObjArr) {
		$("hjPsnm").options.length = 0;
		$("hjPsregCd").options.length = 0;
		
		for( i=0 ; jsonObjArr.length > i ; i++){
			$("hjPsnm").options[i] = new Option(jsonObjArr[i].HJPSNM , jsonObjArr[i].HJPSNM );
		}
		for( i=0 ; jsonObjArr.length > i ; i++){
			$("hjPsregCd").options[i] = new Option(jsonObjArr[i].HJPSREGCD , jsonObjArr[i].HJPSREGCD );
		}
	}
	
	// 확장자 변경(확장자코드도 같이 변경해줘야함.)
	function sethjPregCd(){
		$("hjPsregCd").options[$("hjPsnm").selectedIndex].selected=true;
	}
	//작년 수금 금년 수금 리스트 변경 컨트롤
	function changSumgList(gbn){
		if (gbn == '1') {
			if(document.getElementById("pre01").style.display == 'block'){
				return;
			}else if(document.getElementById("now01").style.display == 'block'){
				for( i = 1 ; i < 13 ; i++ ){
					if(i<10){
						i = '0'+ i;
					}
					document.getElementById("pre"+i).style.display  = 'block';
					document.getElementById("now"+i).style.display  = 'none';
				}
				return;
			}else if(document.getElementById("next01").style.display == 'block'){
				for( i = 1 ; i < 13 ; i++ ){
					if(i<10){
						i = '0'+ i;
					}
					document.getElementById("now"+i).style.display  = 'block';
					document.getElementById("next"+i).style.display  = 'none';
				}
			}
			return;
		}
		if (gbn == '2') {
			if(document.getElementById("pre01").style.display == 'block'){
				for( i = 1 ; i < 13 ; i++ ){
					if(i<10){
						i = '0'+ i;
					}
					document.getElementById("now"+i).style.display  = 'block';
					document.getElementById("pre"+i).style.display  = 'none';
				}
				return;
			}else if(document.getElementById("now01").style.display == 'block'){
				for( i = 1 ; i < 13 ; i++ ){
					if(i<10){
						i = '0'+ i;
					}
					document.getElementById("next"+i).style.display  = 'block';
					document.getElementById("now"+i).style.display  = 'none';
				}
			}
			return;
		}
	}
	
	//민원 처리  불배, 휴독 , 해지 팝업 오픈
	function winPop(url) {
		actUrl = "/reader/minwon/popMinwon.do";
		if ("1" == url) { //신청 독자 조회
			actUrl = "/reader/readerManage/popRetrieveApplyReader.do";
			window.open('','pop_minwon','width=1000, height=730, toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1');
		} else if ("001" == url) {//불배 민원 독자 조회
			window.open('','pop_minwon','width=880, height=700, toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1');
		} else if ("002" == url) {//이전 요청 독자 조회
			actUrl = "/reader/minwon/popRerocation.do";
			window.open('','pop_minwon','width=1020, height=640, toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1');
		} else if ("003" == url) {//휴독 민원 독자 조회
			window.open('','pop_minwon','width=880, height=700, toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1');
		} else if ("004" == url) {//해지 민원 독자 조회
			window.open('','pop_minwon','width=880, height=700, toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1');
		}
		readerListForm.minGb.value = url;
		readerListForm.target = "pop_minwon";
		readerListForm.action = actUrl;
		readerListForm.submit();
	}

	//페이징 펑션
	function moveTo(where, seq) {
		if($("searchText").value  != '' || $("searchSgType").value != '' || $("searchNewsCdType").value != ''){
			$("pageNo").value = seq;
			readerListForm.target = "_self";
			readerListForm.action = "/reader/readerManage/searchReader.do";
			
			readerListForm.submit();
		}else{
			$("pageNo").value = seq;
			readerListForm.target = "_self";
			readerListForm.action = "/reader/readerManage/readerList.do";
			readerListForm.submit();	
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
	
	//신규독자 버튼 클릭시 필드 초기화
	function clearField(){
		if($("searchType").value == '8'){
			document.getElementById("searchSgType").style.display  = 'inline';
			document.getElementById("searchNewsCdType").style.display  = 'none';
			document.getElementById("searchText").readOnly = true;
			$("searchText").style.backgroundColor = "#EAEAEA";
		}else if($("searchType").value == '9'){
			document.getElementById("searchNewsCdType").style.display  = 'inline';
			document.getElementById("searchSgType").style.display  = 'none';
			$("searchText").value='';
			document.getElementById("searchText").readOnly = true;
			$("searchText").style.backgroundColor = "#EAEAEA";
		}else{
			document.getElementById("searchSgType").style.display  = 'none';
			document.getElementById("searchNewsCdType").style.display  = 'none';
			document.getElementById("searchText").readOnly = false;
			$("searchText").style.backgroundColor = "";
		}
		//독자 정보 클리어
		$("seq").value = '';
		$("readNo").value = '';
		$("gnoNm").value = '';
		$("bno").value = '';
		$("sno").value = '';
		$("readNm").value = '';
		$("bidt").value = '';
		$("homeTel1").value = '02';
		$("homeTel2").value = '';
		$("homeTel3").value = '';
		$("mobile1").value = '010';
		$("mobile2").value = '';
		$("mobile3").value = '';
		$("eMail").value = '';
		$("dlvZip").value = '';
		$("dlvAdrs1").value = '';
		$("dlvAdrs2").value = '';
		$("rsdTypeCd").value = '';
		$("hjPathCd").value = '';
		$("taskCd").value = '';
		$("intFldCd").value = '';  
		$("newsCd").value = '100';
		$("oldNewsCd").value = '100';
		$("oldGno").value = '';
		document.getElementById('callLog').innerHTML =  "<a href=\"javascript:callLog();\">"+'0 건' +"</a>";
		$("receipt").checked = false;
		var currentTime = new Date();
		var year = currentTime.getFullYear();
		var month = currentTime.getMonth() + 1;
		if (month < 10) month = "0" + month;
		var day = currentTime.getDate();
		if (day < 10) day = "0" + day;
		$("hjDt").value = year + '-' + month + '-' + day; // 확장일자
		$("hjDt2").value = year + '-' + month + '-' + day; // 구독일자
		$("readTypeCd").value = '011';
		$("oldReadTypeCd").value = '';
		$("stQty").value = '';
		$("qty").value = '1';
		$("sumQty").value = '';
		$("oldQty").value = '';
		$("oldStSayou").value = '';
		$("uPrice").value = '15000';
		$("sumUprice").value = '';
		$("dlvTypeCd").value = '';
		$("spgCd").value = '';
		$("oldSgType").value = '';
		$("dlvPosiCd").value = '';
		$("sgType").value = '011';
		$("bnsBookCd").value = '';
		//$("aptCd").value = '';
		//$("aptNm").value = '';
		$("remk").value = '';
		$("stSayou").value = '';
		$("term").value = '';
		$("hjPsnm").options.length = 0;
		$("hjPsregCd").options.length = 0;
		$("sgBgmm").value = '';
		$("stdt").value = '';
		$("oldStdt").value = '';
		$("stSayou").value = '';
		$("sgCycle").value = '';
		//수금 정보 클리어
		for(var j=1 ; j < 13 ; j++){
			if(j < 10){
				seq ='0'+j;
			}else{
				seq = j;
			}

			 $("preSnDt"+seq).value = '';
			 $("preBillAmt"+seq).value = '';
			 $("preAmt"+seq).value = '';
			 $("preSgbbCd"+seq).value = '';
			 $("nowSnDt"+seq).value = '';
			 $("nowBillAmt"+seq).value = '';
			 $("nowAmt"+seq).value = '';
			 $("nowSgbbCd"+seq).value = '';
			 $("nextSnDt"+seq).value = '';
			 $("nextBillAmt"+seq).value = '';
			 $("nextAmt"+seq).value = '';
			 $("nextSgbbCd"+seq).value = '';
			 $("sumgClam").innerHTML = '------------';
		}
	}
	
	//독자정보 생성,수정
	function save(){
		if($("readNm").value == ''){
			alert('독자명을 입력해 주세요.');
			$("readNm").focus();
			return;
		}

		//해지가 아닐때만 지역,구역번호 입력
		if( ($("stdt").value == '' && $("stSayou").value == '')  && $("gno").value == ''  ){
			if($("oldGno").value == '200' || $("oldGno").value == '300' || $("oldGno").value == '400' || $("oldGno").value == '500'){
				//
				$("gno").options[$("gno").length] = new Option($("oldGno").value,$("oldGno").value);
				$("gno").value = $("oldGno").value;
			}else{
				alert('구역번호를 입력해 주세요.');
				$("gno").focus();
				return;
			}
			
		}

		if(($("stdt").value == '' && $("stSayou").value == '')  && $("bno").value == ''){
			alert('배달번호를 입력해 주세요.');
			$("bno").focus();
			return;
		}
		if($("dlvZip").value == ''){
			alert('우편번호를 입력해 주세요.');
			$("dlvZip").focus();
			return;
		}else{
			if(isNumber($("dlvZip").value) == false ){
				alert('우편번호는 숫자만 가능합니다. 우편번호를 정확히 입력해주세요.');
				$("dlvZip").focus();
				return;
			}
		}
		if($("dlvAdrs1").value == ''){
			alert('주소를 입력해 주세요.');
			$("dlvAdrs1").focus();
			return;
		}
		if($("dlvAdrs2").value == ''){
			alert('상세주소를 입력해 주세요.');
			$("dlvAdrs2").focus();
			return;
		}
		if($("newsCd").value == ''){
			alert('신문명을 선택해 주세요.');
			$("newsCd").focus();
			return;
		}
		if($("sgBgmm").value != '' && $("sgBgmm").value.length < 6){
			alert('유가년월을 정확히 입력해 주세요.\nex)201202');
			$("sgBgmm").focus();
			return;
		}else{
			if($("sgBgmm").value.indexOf('-') >-1 ){
				var tem = $("sgBgmm").value.split('-');
				if(Number(tem[1]) < 1 || Number(tem[1]) > 12){
					alert('유가년월을 정확히 입력해 주세요.\nex)201202');
					$("sgBgmm").focus();
					return;
				}else{
					if(tem[1].length == 1){
						tem[1] = '0' + tem[1];
					}
					$("sgBgmm").value = tem[0] + tem[1];
				}
			}else{
				var tem = $("sgBgmm").value.substr(4,6);
				if(Number(tem) < 1 || Number(tem) > 12){
					alert('유가년월을 정확히 입력해 주세요.\nex)201202');
					$("sgBgmm").focus();
					return;
				}else{
					$("sgBgmm").value = $("sgBgmm").value.substr(0,4) + tem;
				}
			}
		}
		if($("sgType").value == ''){
			alert('수금 방법을 선택해 주세요.');
			$("sgType").focus();
			return;
		}
		if( checkBytes($("remk").value) > 300){
			alert("독자비고는 300byte를 초과할수 없습니다.");
			$("remk").focus();
			return;
		}
		if( $("qty").value == ''){
			alert("구독부수를 입력해 주세요");
			$("qty").focus();
			return;
		}
		if( $("uPrice").value == ''){
			alert("단가를 입력해 주세요");
			$("uPrice").focus();
			return;
		}
		if($("bno").value == '999'){
			if($("stdt").value == ''){
				alert("해지 일자를 입력해 주세요.");
				$("stdt").focus();
				return;
			}
			if($("stSayou").value == ''){
				alert("해지 사유를 입력해 주세요.");
				$("stSayou").focus();
				return;
			}
		}
		if( $("stdt").value != '' && $("stSayou").value == ''){
			alert("해지 사유를 입력해 주세요.");
			$("stSayou").focus();
			return;
		}
		if( $("stSayou").value != '' && $("stdt").value == ''){
			alert("해지 일자를 입력해 주세요.");
			$("stdt").focus();
			return;
		}
		// 교육용 독자 벨리데이션 추가(박윤철)
		if($("readTypeCd").value =='015' && $("oldReadTypeCd").value == '' && $("agencyid").value != '521050'){
			alert('교육용 독자 등록은 본사만 가능합니다.');
			return;
		}
		
		if($("readTypeCd").value =='016' && $("oldReadTypeCd").value == '' && $("agencyid").value != '521050'){
			alert('본사 직원 독자 등록은 본사만 가능합니다.');
			return;
		}
		if($("readTypeCd").value =='017' && $("oldReadTypeCd").value == '' ){
			alert('소외계층 독자 등록은 본사만 가능합니다.');
			return;
		}
		if($("readNo").value == '' && ($("readTypeCd").value !='021' && $("readTypeCd").value !='022')){
			//기증 홍보
			if($("sgBgmm").value ==''){
				alert("유가년월을 입력해 주세요.");
				$("sgBgmm").focus();
				return;
			}
		}
		if($("readNo").value != ''){
/* ABC용 해지독자 수정

			if($("oldStdt").value != ''  && $("stdt").value != $("oldStdt").value ){
				alert("해지독자는 수정 불가합니다.");
				return;
			}
			if($("oldStSayou").value != ''  && $("stSayou").value != $("oldStSayou").value ){
				alert("해지독자는 수정 불가합니다.");
				return;
			}

			if($("newsCd").value != $("oldNewsCd").value ){
				alert("신문은 변경 불가합니다.");
				return;
			}
//	ABC용 구독부수 수정기능
			if($("qty").value != $("oldQty").value ){
				alert("구독부수는 변경 불가합니다.");
				return;
			}	
*/
			
			if( $("oldReadTypeCd").value == '016' && $("readTypeCd").value != '016' ){
				alert('본사 직원 독자의 경우 독자유형 변경이 불가합니다.');
				return;
			}
			if( $("oldReadTypeCd").value != '016' && $("readTypeCd").value == '016' ){
				alert('본사 직원 독자의 경우 독자유형 변경이 불가합니다.');
				return;
			}
			if($("oldReadTypeCd").value == '016' && ($("sgType").value !='023' && $("oldSgType").value == '023')){
				alert('본사 직원 독자의 경우 수금방법 변경이 불가합니다.');
				return;
			}
			if($("oldReadTypeCd").value == '016' && ($("sgType").value =='023' && $("oldSgType").value != '023')){
				alert('본사 직원 독자의 경우 수금방법 변경이 불가합니다.');
				return;
			}
			// 교육용 독자 벨리 데이션 추가(박윤철)
			if( $("oldReadTypeCd").value == '015' && $("readTypeCd").value != '015' && $("agencyid").value != '521050'){
				alert('교육용 독자의 경우 독자유형 변경이 불가합니다.');
				return;
			}
			if( $("oldReadTypeCd").value != '015' && $("readTypeCd").value == '015' && $("agencyid").value != '521050'){
				alert('교육용 독자의 경우 독자유형 변경이 불가합니다.');
				return;
			}
			if($("oldReadTypeCd").value == '015' && ($("sgType").value !='023' && $("oldSgType").value == '023') && $("agencyid").value != '521050'){
				alert('교육용 독자의 경우 수금방법 변경이 불가합니다.');
				return;
			}
			if($("oldReadTypeCd").value == '015' && ($("sgType").value =='023' && $("oldSgType").value != '023') && $("agencyid").value != '521050'){
				alert('교육용 독자의 경우 수금방법 변경이 불가합니다.');
				return;
			}
			
			
			if( $("oldReadTypeCd").value == '017' && $("readTypeCd").value != '017' ){
				alert('소외계층 독자의 경우 독자유형 변경이 불가합니다.');
				return;
			}
			if( $("oldReadTypeCd").value != '017' && $("readTypeCd").value == '017' ){
				alert('소외계층 독자의 경우 독자유형 변경이 불가합니다.');
				return;
			}
			if($("oldReadTypeCd").value == '017' && ($("sgType").value !='023' && $("oldSgType").value == '023')){
				alert('소외계층 독자의 경우 수금방법 변경이 불가합니다.');
				return;
			}
			if($("oldReadTypeCd").value == '017' && ($("sgType").value =='023' && $("oldSgType").value != '023')){
				alert('소외계층 독자의 경우 수금방법 변경이 불가합니다.');
				return;
			}
			if($("sgType").value != $("oldSgType").value){
				if($("sgType").value == '011' || $("sgType").value == '012' || $("sgType").value == '013' || $("sgType").value == '021' ||
				   $("sgType").value == '022' || $("sgType").value == '023' || $("sgType").value == '024'){
					if(confirm('수금방법 변경시 같은 독자번호를 가진 독자의 수금방법도 변경되며\n미수분 존재시 미수분 수금방법도 변경됩니다.\n수정하시겠습니까?') == false){
						return;
					}
				}
			}
		}
		if($("stSayou").value != '' && $("stdt").value != '' && Number($("qty").value) == 1){
			$("stQty").value = '1' ;
		}
		if($("stSayou").value != '' && $("stdt").value != '' && Number($("qty").value) != 1){
			if($("oldStdt").value =='' && $("oldStSayou").value =='' ){
				//팝업 오픈
				var left = (screen.width)?(screen.width - 1330)/2 : 10;
				var top = (screen.height)?(screen.height - 200)/2 : 10;
				var winStyle = "width=300,height=300,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
				var newWin = window.open("", "qty_close", winStyle);
				readerListForm.target = "qty_close";
				readerListForm.action = "/reader/readerManage/popCloseReader.do";
				readerListForm.submit();
				return;	
			}else{
				$("stQty").value = $("qty").value;
			}
		}
		//현재월 미수일때 청구금액 없으면 단가로 채움
		if($("nowSgbbCd12").value == '044'){
			$("nowSnDt12").value = '';
			if($("nowBillAmt12").value==''){
				$("nowBillAmt12").value = $("uPrice").value; 
			}
		}
		for(var j=1 ; j < 13 ; j++){
			if(j < 10){
				seq ='0'+j;
			}else{
				seq = j;
			}
			if($("nextSgbbCd"+seq).value == '044'){
				$("nextSnDt"+seq).value = '';
				if($("nextBillAmt"+seq).value==''){
					$("nextBillAmt"+seq).value = $("uPrice").value; 
				}
			}
		}
		for(var j=1 ; j < 13 ; j++){
			if(j < 10){
				seq ='0'+j;
			}else{
				seq = j;
			}
			if( ($("preBillAmt"+seq).value != '' && $("preAmt"+seq).value != '') ){
				var yymm = $("preYear"+seq).value;
				if((Number($("preBillAmt"+seq).value) < Number($("preAmt"+seq).value))  && 
					(Number($("preYear"+seq).value) >= Number('201201'))  ){
					alert(yymm+'월분 수금액이 청구금액보다 큽니다.');
					$("preBillAmt"+seq).focus;
					return;	
				}
				if($("preSgbbCd"+seq).value == '' && Number($("preYear"+seq).value) >= Number('201201')){
					alert(yymm+'월분 수금 방법을 선택해 주세요.');
					$("preBillAmt"+seq).focus;
					return;
				}
			}
				
			if( ($("nowBillAmt"+seq).value != '' && $("nowAmt"+seq).value != '') ){
				var yymm = $("nowYear"+seq).value;
				if((Number($("nowBillAmt"+seq).value) < Number($("nowAmt"+seq).value)) && 
					Number($("nowYear"+seq).value) >= Number('201201')){
					alert(yymm+'월분 수금액이 청구금액보다 큽니다.');
					$("nowBillAmt"+seq).focus;
					return;	
				}
				if($("nowSgbbCd"+seq).value == '' && Number($("nowYear"+seq).value) >= Number('201201')){
					alert(yymm+'월분 수금 방법을 선택해 주세요.');
					$("nowBillAmt"+seq).focus;
					return;
				}
			}
			if( ($("nextBillAmt"+seq).value != '' && $("nextAmt"+seq).value != '') ){
				var yymm = $("nextYear"+seq).value;
				if(Number($("nextBillAmt"+seq).value) < Number($("nextAmt"+seq).value)){
					alert(yymm+'월분 수금액이 청구금액보다 큽니다.');
					$("nextBillAmt"+seq).focus;
					return;	
				}
				if($("nextSgbbCd"+seq).value == '' && Number($("nowYear"+seq).value) >= Number('201201')){
					alert(yymm+'월분 수금 방법을 선택해 주세요.');
					$("nextBillAmt"+seq).focus;
					return;
				}
			}
			if($("preSgbbCd"+seq).value != '' && $("preSgbbCd"+seq).value != '044'){
				if($("preSgbbCd"+seq).value == '033' || $("preSgbbCd"+seq).value == '099'){
					$("preBillAmt"+seq).value = '0';
					$("preAmt"+seq).value = '0';
				}
				if($("preSndt"+seq).value == ''){
					alert('수금일자를 입력해 주세요');
					$("preSndt"+seq).focus;
					return;
				}
			}
			if($("nowSgbbCd"+seq).value != '' && $("nowSgbbCd"+seq).value != '044'){
				if($("nowSgbbCd"+seq).value == '033' || $("nowSgbbCd"+seq).value == '099'){
					$("nowBillAmt"+seq).value = '0';
					$("nowAmt"+seq).value = '0';
				}
				if($("nowSndt"+seq).value == ''){
					alert('수금일자를 입력해 주세요');
					$("nowSndt"+seq).focus;
					return;
				}
			}
			if($("nextSgbbCd"+seq).value != '' && $("nextSgbbCd"+seq).value != '044'){
				if($("nextSgbbCd"+seq).value == '033' || $("nextSgbbCd"+seq).value == '099'){
					$("nextBillAmt"+seq).value = '0';
					$("nextAmt"+seq).value = '0';
				}
				if($("nextSndt"+seq).value == ''){
					alert('수금일자를 입력해 주세요');
					$("nextSndt"+seq).focus;
					return;
				}
			}
			if($("preSndt"+seq).value != '' && $("preSgbbCd"+seq).value == ''){
				alert($("preYear"+seq).value+'월분 수금 방법을 선택해 주세요.');
				$("preSgbbCd"+seq).focus();
				return;
			}
			if($("nowSndt"+seq).value != '' && $("nowSgbbCd"+seq).value == ''){
				alert($("nowYear"+seq).value+'월분 수금 방법을 선택해 주세요.');
				$("nowSgbbCd"+seq).focus();
				return;
			}
			if($("nextSndt"+seq).value != '' && $("nextSgbbCd"+seq).value == ''){
				alert($("nextYear"+seq).value+'월분 수금 방법을 선택해 주세요.');
				$("nextSgbbCd"+seq).focus();
				return;
			}
		}

		readerListForm.target="_self";
		readerListForm.action="/reader/readerManage/saveReader.do";
		readerListForm.submit();
	}
	
	//통화기록 보기
	function callLog(){
		if($("readNo").value == ''){
			alert('독자를 선택해 주세요.');
			return;
		}
		var left = (screen.width)?(screen.width - 830)/2 : 10;
		var top = (screen.height)?(screen.height - 600)/2 : 10;
		var winStyle = "width=400,height=500,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		var newWin = window.open("", "call_log", winStyle);
		readerListForm.target = "call_log";
		readerListForm.action = "/reader/readerManage/popRetrieveCallLog.do";
		readerListForm.submit();
	}
	
	//추가 구독 팝업 오픈
	function popExtendReader(gbn){
		if($("readNo").value == ''){
			alert('독자를 선택해 주세요.');
			return;
		}
		if( $("stdt").value != '' || $("stSayou").value != ''){
			alert("중지독자는 확장, 매체추가가 불가합니다.");
			return;
		}
		if($("oldReadTypeCd").value == '016'){
			alert("본사 독자는 확장, 매체추가가 불가합니다.");
			return;
		}
		if($("oldReadTypeCd").value == '017'){
			alert("소외계층 독자는 확장, 매체추가가 불가합니다.");
			return;
		}
		//팝업 오픈
		var left = (screen.width)?(screen.width - 1330)/2 : 10;
		var top = (screen.height)?(screen.height - 200)/2 : 10;
		var winStyle = "width=300,height=300,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		var newWin = window.open("", "qty_extend", winStyle);
		readerListForm.target = "qty_extend";
		readerListForm.action = "/reader/readerManage/popExtendReader.do?gbn="+gbn;
		readerListForm.submit();
	}
	//추가 구독
	function extendReader(){
		readerListForm.target = "_self";
		readerListForm.action = "/reader/readerManage/extendReader.do";
		readerListForm.submit();
	}
		
	//숫자만 입력 가능하도록 체크 입력값 검증
	function isNumber(str) {
		if(str.length == 0)
			return true;
	
		for(var i=0; i < str.length; i++) {
			if(!('0' <= str.charAt(i) && str.charAt(i) <= '9')){
			return false;
			}
		}
		return true;
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
	//관리자 지국 선택..
	function changeAgency(){
		if($("agencySearch").value != ''){
			<c:forEach items="${agencyList }" var="list">
				if('${list.NAME}' == $("agencySearch").value){
					$("agency").value = '${list.SERIAL}';
				}
			</c:forEach>
		}
		readerListForm.acion="/reader/readerManage/readerList.do";
		readerListForm.target="_self";
		readerListForm.submit();	
		
	}
	
	//주소코드 팝업
	function popAddrCode(){
		var left = (screen.width)?(screen.width - 1330)/2 : 10;
		var top = (screen.height)?(screen.height - 200)/2 : 10;
		var winStyle = "width=400,height=500,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		var newWin = window.open("", "pop_addrCode", winStyle);
		readerListForm.target = "pop_addrCode";
		readerListForm.action = "/reader/readerManage/popAddrCode.do";
		readerListForm.submit();
	}
	//주소코드팝업에서 주소코드 선택시 셋팅 펑션
	function setAddrCode(code , name){
		$("aptCd").value = code;
		$("aptNm").value = name;
	}
	
	//우편주소 팝업
	function popAddr(){
		var left = (screen.width)?(screen.width - 1330)/2 : 10;
		var top = (screen.height)?(screen.height - 200)/2 : 10;
		var winStyle = "width=400,height=500,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		var newWin = window.open("", "pop_addr", winStyle);
		readerListForm.target = "pop_addr";
		readerListForm.action = "/reader/readerManage/popAddr.do?cmd=1";
		readerListForm.submit();
	}
	//우편주소팝업에서 우편주소 선택시 셋팅 펑션
	function setAddr(zip , addr){
		$("dlvZip").value = zip;
		$("dlvAdrs1").value = addr;
	}
	//구독부수 조정시 단가 계산 펑션
	function controlPrice(){
		$("uPrice").value = $("qty").value * 15000;
	}
	//검색 조건 변경
	function changeSearch(){
		if($("searchType").value == '8'){
			document.getElementById("searchSgType").style.display  = 'inline';
			document.getElementById("searchNewsCdType").style.display  = 'none';
			document.getElementById("searchText").readOnly = true;
			$("searchText").style.backgroundColor = "#EAEAEA";
		}else if($("searchType").value == '9'){
			document.getElementById("searchNewsCdType").style.display  = 'inline';
			document.getElementById("searchSgType").style.display  = 'none';
			$("searchText").value='';
			document.getElementById("searchText").readOnly = true;
			$("searchText").style.backgroundColor = "#EAEAEA";
		}else{
			document.getElementById("searchSgType").style.display  = 'none';
			document.getElementById("searchNewsCdType").style.display  = 'none';
			document.getElementById("searchText").readOnly = false;
			$("searchText").style.backgroundColor = "";
		}
	}
	//독자 검색
	function search(){
		
		if($("searchType").value == '8'){
			if($("searchSgType").value  == ''){
				alert("수금방법을 선택해 주세요.");
				$("searchSgType").focus();
				return;
			}
		}else if($("searchType").value == '9'){
			if($("searchNewsCdType").value  == ''){
				alert("신문명을 선택해 주세요.");
				$("searchNewsCdType").focus();
				return;
			}
		}else{
			if($("searchText").value  == ''){
				alert("검색어를 입력해 주세요.");
				$("searchText").focus();
				return;
			}
			
			if($("searchType").value  == '1' || $("searchType").value  == '2' || $("searchType").value  == '3' || $("searchType").value  == '6'){
				if(isNumber($("searchText").value) == false ){
					alert('숫자만 가능합니다.');
					$("searchText").focus();
					return;
				}
			}
		}

		$("pageNo").value = '1';
		readerListForm.action="/reader/readerManage/searchReader.do";
		readerListForm.target="_self";
		readerListForm.submit();
	}
	
	//배달 번호 정렬
	function sort(){
		if(confirm('배달번호를 정렬하시겠습니까?') == false){
			return;
		}
		readerListForm.action="/reader/readerManage/deliveryNumSort.do";
		readerListForm.target="_self";
		readerListForm.submit();
	}
	
	window.attachEvent("onload", clearField);
	
</script>

<form id="readerListForm" name="readerListForm" action="" method="post">
	<input type="hidden" id="minGb" name="minGb" value="" />
	<input type="hidden" id="seq" name="seq" value="" />
	<input type="hidden" id="boSeq" name="boSeq" value="" />
	<input type="hidden" id="stQty" name="stQty" value="" />
	<input type="hidden" id="boReadNo" name="boReadNo" value="" />
	<input type="hidden" id="oldNewsCd" name="oldNewsCd" value="100" />
	<input type="hidden" id="oldQty" name="oldQty" value="100" />
	<input type="hidden" id="oldReadTypeCd" name="oldReadTypeCd" value="" />
	<input type="hidden" id="oldSgType" name="oldSgType" value="" />
	<input type="hidden" id="oldStdt" name="oldStdt" value="" />
	<input type="hidden" id="oldStSayou" name="oldStSayou" value="" />
	<input type="hidden" id="oldGno" name="oldGno" value="" />
	<input type="hidden" id="agencyid" name="agencyid" value="<%=agency_userid%>" />

	<!-- 페이징 처리 변수 -->
	<input type=hidden id="pageNo" name="pageNo" value="${param.pageNo}" />
	
	<!--독자등록-->
	<table width="100%" cellpadding="0" cellspacing="0"  border="0">
		<tr>
			<td width="60%" valign="top">
				<font class="b03"><b>[ 독자정보 ]</b></font> 
				<table width="100%" cellpadding="5" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
  					<c:if test="${not empty admin_userid }">
						<tr bgcolor="ffffff">
							<td bgcolor="f9f9f9" width="12%" align="center"><font class="b02">지 국 명</font></td>
							<td colspan="5">
								<select name="agency" id="agency" onChange="javascript:changeAgency();">
									<c:forEach items="${agencyList }" var="list">
									<option value="${list.SERIAL }"<c:if test="${agency_serial eq list.SERIAL }">selected</c:if>>${list.NAME }</option>
									</c:forEach>
								</select>
								<input type="text" id="agencySearch" name="agencySearch" style="width:100px" onkeydown="if(event.keyCode == 13){changeAgency();}"/>
								<a href="javascript:changeAgency();"><img src="/images/bt_search.gif" border="0" align="absmiddle"></a>
							</td>
						</tr>
					</c:if>
  					<tr bgcolor="ffffff">
					    <td bgcolor="f9f9f9" width="12%" align="center"><font class="b02">독자번호</font></td>
						<td>
							<input type="text" id="readNo" name="readNo" value="" style="text-align:right;padding-right:1px"  class='box_n' readOnly />
						</td>
						<td bgcolor="f9f9f9" width="10%" align="center"><font class="b02">구역명</font></td>
						<td><input type="text" id="gnoNm" name="gnoNm" value="" style="text-align:right;padding-right:1px"  class='box_n' readOnly/></td>
						<td bgcolor="f9f9f9" width="12%" align="center"><b class="b03">*</b><font class="b02">구역배달</font></td>
						<td>
							<div align="center">
								<select id="gno" name="gno" style="width:50px">
									<c:forEach items="${guYukList }" var="list">
										<option value="${list.GU_NO }">${list.GU_NO }</option>
									</c:forEach>
								</select> 
								<input type="text" id="bno" name="bno" value="" style="width:25px" maxlength="3" style="ime-Mode:disabled" onKeyPress="inputNumCom();"/> 
								<input type="text" id="sno" name="sno" value="" style="width:20px" maxlength="2" style="ime-Mode:disabled" onKeyPress="inputNumCom();"/>
							</div>
						</td>
  					</tr>
					<tr bgcolor="ffffff">
					    <td bgcolor="f9f9f9" align="center"><b class="b03">*</b><font class="b02">독 자 명</td>
						<td colspan="3"><input type="text" id="readNm" name="readNm" value="" class='box_n'/></td>
						<td bgcolor="f9f9f9" align="center"><font class="b02">생년월일</td>
						<td><input type="text" id="bidt" name="bidt" value="" class='box_n'  maxlength="8" style="ime-Mode:disabled" onKeyPress="inputNumCom();"/></td>
					</tr>
					<tr bgcolor="ffffff">
					    <td bgcolor="f9f9f9" align="center"><font class="b02">전화번호</td>
						<td><div align="center">
								<select id="homeTel1" name="homeTel1">
								<c:forEach items="${areaCode }" var="list">
									<option value="${list.CODE }">${list.CODE }</option>
								</c:forEach> 
								</select>
								<input type="text" id="homeTel2" name="homeTel2" value="" class='box_s' maxlength="4" style="ime-Mode:disabled" onKeyPress="inputNumCom();">
								<input type="text" id="homeTel3" name="homeTel3" value="" class='box_s' maxlength="4" style="ime-Mode:disabled" onKeyPress="inputNumCom();">
							</div></td>
						<td bgcolor="f9f9f9" align="center"><font class="b02">핸 드 폰</td>
						<td><div align="center">
								<select id="mobile1" name="mobile1"> 
								<c:forEach items="${mobileCode }" var="list">
									<option value="${list.CODE }">${list.CODE }</option>
								</c:forEach> 
								</select> 
								<input type="text" id="mobile2" name="mobile2" value="" class='box_s' maxlength="4" style="ime-Mode:disabled" onKeyPress="inputNumCom();"> 
								<input type="text" id="mobile3" name="mobile3" value="" class='box_s' maxlength="4" style="ime-Mode:disabled" onKeyPress="inputNumCom();">
							</div></td>
						<td bgcolor="f9f9f9" align="center"><font class="b02">E-mail</td>
						<td><input type="text" id="eMail" name="eMail" value=""  class='box_n'/></td>
					</tr>
					<tr bgcolor="ffffff">
					    <td bgcolor="f9f9f9" align="center"><b class="b03">*</b><font class="b02">우편번호</td>
						<td>
							<input type="text" id="dlvZip" name="dlvZip" value=""  class='box_n3' maxlength="6" readOnly/>
							<input type="button" value="..." onClick="javascript:popAddr();"/>
						</td>
						<td colspan="4"><input type="text" id="dlvAdrs1" name="dlvAdrs1" value=""  class='box_n' readOnly/></td>
					</tr>
					<!-- tr bgcolor="ffffff">
					    <td bgcolor="f9f9f9" align="center"><font class="b02">주소코드</td>
						<td>
							<input type="text" id=aptCd name="aptCd" value="" class='box_n3' readonly/>
							<input type="button" value="..." onClick="javascript:popAddrCode();"/>
						</td>
						<td colspan="4"><input type="text" id=aptNm name="aptNm" value="" class='box_n' readonly/></td>
					</tr -->
					<tr bgcolor="ffffff">
					    <td bgcolor="f9f9f9" align="center"><b class="b03">*</b><font class="b02">상세주소</td>
						<td colspan="5"><input type="text" id="dlvAdrs2" name="dlvAdrs2" value=""  class='box_n'/></td>
					</tr>
					<tr bgcolor="ffffff">
					   <td bgcolor="f9f9f9" align="center"><font class="b02">주거구분</td>
						<td>
							<select name="rsdTypeCd" id="rsdTypeCd" class='box_n'>
								<c:forEach items="${rsdTypeList }" var="list">
								<option value="${list.CODE }">${list.CNAME }</option>
								</c:forEach>
							</select>
						</td>
						<td bgcolor="f9f9f9" align="center"><font class="b02">직종</td>
						<td>
							<select name="taskCd" id="taskCd" class='box_n'>
								<c:forEach items="${taskList }" var="list">
								<option value="${list.CODE }">${list.CNAME }</option>
								</c:forEach>
							</select>
						</td>
						<td bgcolor="f9f9f9" align="center"><font class="b02">관심분야</td>
						<td>
							<select name="intFldCd" id="intFldCd" class='box_n'>
								<c:forEach items="${intFldList }" var="list">
								<option value="${list.CODE }">${list.CNAME }</option>
								</c:forEach>
							</select>
						</td>
					</tr>
				</table>

				<p style="top-margin:10px;">
				<font class="b03"><b>[ 구독정보 ]</b></font> &nbsp;&nbsp;&nbsp;<input type="checkbox" id="receipt" name="receipt"><font class="b03" style="color:blue">지로,방문 영수증 미출력 체크</font>
				<table width="100%" cellpadding="5" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
				    <tr bgcolor="ffffff">
					    <td bgcolor="f9f9f9" width="12%" align="center"><b class="b03">*</b><font class="b02">신 문 명 </font></td>
						<td width="23%">
							<select name="newsCd" id="newsCd" class='box_n'>
								<c:forEach items="${newSList }" var="list" varStatus="i">
								<option value="${list.CODE }" >${list.CNAME }</option>
								</c:forEach>
							</select>
						</td>
						<td bgcolor="f9f9f9" width="12%" align="center"><font class="b02">확장일자</font></td>
						<td width="120px"><input type="text" id="hjDt" name="hjDt"  value="<c:out value='${sdate}' />" readonly onClick="Calendar(this)" class='box_n'/></td>
						<td bgcolor="f9f9f9" width="12%" align="center"><font class="b02">독자유형</font></td>
						<td>
							<select name="readTypeCd" id="readTypeCd" class='box_n'>
								<c:forEach items="${readTypeList }" var="list">
								<option value="${list.CODE }">${list.CNAME }</option>
								</c:forEach>
							</select>
						</td>
				    </tr>
				    <tr bgcolor="ffffff">
					    <td bgcolor="f9f9f9" align="center"><b class="b03">*</b><font class="b02">구독부수</font></td>
						<td>
							<input type="text" id="qty" name="qty" value="1" class='box_s4' onKeyUp="controlPrice();" style="ime-Mode:disabled" onKeyPress="inputNumCom();">
							<input type="text" id="sumQty" name="sumQty" value="" Style="Color:blue;" class='box_s4' readonly">
						</td>
						<td bgcolor="f9f9f9" align="center"><b class="b03">*</b><font class="b02">유가년월</font></td>
						<td><input type="text" id="sgBgmm" name="sgBgmm" class='box_n' value="" maxlength="6" style="ime-Mode:disabled" onKeyPress="inputNumCom();" ></td>
						<td bgcolor="f9f9f9" align="center"><font class="b02">배달유형</font></td>
						<td>
							<select name="dlvTypeCd" id="dlvTypeCd" class='box_n'>
								<c:forEach items="${dlvTypeList }" var="list">
								<option value="${list.CODE }">${list.CNAME }</option>
								</c:forEach>
							</select>
						</td>
				    </tr>
				    <tr bgcolor="ffffff">
					    <td bgcolor="f9f9f9" align="center"><b class="b03">*</b><font class="b02">단&nbsp;&nbsp;&nbsp;&nbsp;가</font></td>
						<td>
							<input type="text" id="uPrice" name="uPrice" value="15000" class='box_s4' style="ime-Mode:disabled" onKeyPress="inputNumCom();"/>
							<input type="text" id="sumUprice" name="sumUprice" value="" Style="Color:blue;" class='box_s4' readonly/>
						</td>
						<td bgcolor="f9f9f9" align="center"><font class="b02">신청경로</font></td>
						<td>
							<select name="hjPathCd" id="hjPathCd" class='box_n' onChange="javascript:changeHjPath()">
								<c:forEach items="${hjPathList }" var="list">
								<option value="${list.CODE }">${list.CNAME }</option>
								</c:forEach>
							</select>
						</td>
						<td bgcolor="f9f9f9" align="center"><font class="b02">배달장소</font></td>
						<td>
							<select name="dlvPosiCd" id="dlvPosiCd" class='box_n'>
								<option value=""></option>
								<c:forEach items="${dlvPosiCdList }" var="list">
								<option value="${list.CODE }">${list.CNAME }</option>
								</c:forEach>
							</select>
						</td>
				    </tr>
				    <tr bgcolor="ffffff">
					    <td bgcolor="f9f9f9" align="center"><b class="b03">*</b><font class="b02">수금방법</font></td>
						<td>
							<select name="sgType" id="sgType" class='box_n'>
								<c:forEach items="${sgTypeList }" var="list">
								<option value="${list.CODE }">${list.CNAME }</option>
								</c:forEach> 
							</select>
							<input type="hidden" id="sgCycle" name="sgCycle" readonly class='box_s'/>
						</td>
						<td bgcolor="f9f9f9" align="center"><font class="b02">확 장 자</font></td>
						<td>
							<select name="hjPsnm" id="hjPsnm" class='box_n' onChange="javascript:sethjPregCd();">
							</select>
							<div style="display:none">
								<select name="hjPsregCd" id="hjPsregCd" class='box_n' >
								</select>
							</div>
						</td>
						<td bgcolor="f9f9f9" align="center"><font class="b02">자 매 지 </font></td>
						<td>
							<select name="bnsBookCd" id="bnsBookCd" class='box_n'>
								<option value=""></option>
								<c:forEach items="${bnsBookList }" var="list">
								<option value="${list.CODE }">${list.CNAME }</option>
								</c:forEach> 
							</select>
						</td>
				    </tr>
				    <tr bgcolor="ffffff">
					    <td bgcolor="f9f9f9" align="center"><font class="b02">구독일자</font></td>
						<td><input type="text" id="hjDt2" name="hjDt2" value="<c:out value='${sdate}' />" readonly onClick="Calendar(this)" class='box_n'/></td>
						<td bgcolor="f9f9f9" align="center"><font class="b02">구독기간</font></td>
						<td><input type="text" id="term" name="term" value="" readonly class='box_n'/></td>
						<td bgcolor="f9f9f9" align="center"><font class="b02">판촉물</td>
						<td>
							<select name="spgCd" id="spgCd" class='box_n'>
								<option value=""></option>
								<c:forEach items="${SpgCdList }" var="list">
								<option value="${list.CODE }">${list.CNAME }</option>
								</c:forEach>
							</select>
						</td>
				    </tr>
				    <tr bgcolor="ffffff">
					    <td bgcolor="f9f9f9" align="center"><font class="b02">해지일자</font></td>
						<td><input type="text" size="10" id="stdt" name="stdt" value="<c:out value='${sdate}' />" onClick="Calendar(this)" class='box_n'></td>
						<td bgcolor="f9f9f9" align="center"><font class="b02">해지사유</font></td>
						<td>
							<select name="stSayou" id="stSayou" class='box_n'>
								<option value=""></option>
								<c:forEach items="${stSayouList }" var="list">
								<option value="${list.CODE }">${list.CNAME }</option>
								</c:forEach>
							</select>
						</td>
						<td bgcolor="f9f9f9" align="center" onClick="javascript:callLog();" style="cursor:hand;"><font color="GREEN"><b>통화기록</b></font></td>
						<TD><span id="callLog" name="callLog" value="" ></span></TD>
				    </tr>
				    <tr align="right">
						<td colspan="6"  bgcolor="ffffff">
							<c:choose>
								<c:when test="${not empty admin_userid }">
								<a href="javascript:alert('지국만 가능합니다.');"><img src="/images/bt_save.gif" border="0" align="absmiddle"></a>&nbsp;&nbsp;
								<a href="javascript:alert('지국만 가능합니다.');"><img src="/images/bt_newmem.gif" border="0" align="absmiddle"></a>&nbsp;&nbsp;
								<a href="javascript:alert('지국만 가능합니다.');"><img src="/images/bt_add.gif" border="0" align="absmiddle"></a>&nbsp;&nbsp;
								<a href="javascript:alert('지국만 가능합니다.');"><img src="/images/news_add.gif" border="0" align="absmiddle"></a>
								</c:when>
								<c:otherwise>
								<a href="javascript:save();"><img src="/images/bt_save.gif" border="0" align="absmiddle"></a>&nbsp;&nbsp;
								<a href="javascript:clearField();"><img src="/images/bt_newmem.gif" border="0" align="absmiddle"></a>&nbsp;&nbsp;
								<a href="javascript:popExtendReader('qty');"><img src="/images/bt_add.gif" border="0" align="absmiddle"></a>&nbsp;&nbsp;
								<a href="javascript:popExtendReader('newsCd');"><img src="/images/news_add.gif" border="0" align="absmiddle"></a>
								</c:otherwise>
							</c:choose>
						</td>
						
					</tr>
				</table>
			</td>
			<!-- 메인 오른쪽 끝-->					
			<!-- 메인 왼쪽 시작-->					
			<td width="40%" valign="top" align="right">
				<table width="95%" cellpadding="0" cellspacing="0"  border="0">
					<tr>
						<td>
							<br>
							<table width="100%" cellpadding="1" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
    							<tr>
  									<td width="20">
										<a href="javascript:changSumgList('1');"><img src="/images/bt_gf02.gif" style="width:45" alt="이전" border="0" align="absmiddle"/></a>
									</td>
									<td width="20">
										<a href="javascript:changSumgList('2');"><img src="/images/bt_gf03.gif" style="width:45" alt="다음" border="0" align="absmiddle"/></a>
									</td>
									<td width="40">	
										<a href="javascript:sumgClam('last');"><img src="/images/bt_money01.gif" alt="작년수금" border="0" align="absmiddle"/></a>
									</td>
									<td align="center">
										<span id="sumgClam" name="sumgClam" >------------</span>
										<span id="lastYearSumgClam" name="lastYearSumgClam" style="display:none;"></span>
										<span id="thisYearSumgClam" name="thisYearSumgClam" style="display:none;"></span>
									</td>
									<td width="40">
										<a href="javascript:sumgClam('now');"><img src="/images/bt_money02.gif" alt="금년수금" border="0" align="absmiddle"/></a>
									</td>
  								</tr>
  							</table>
  							<table width="100%" cellpadding="1" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
   								<tr bgcolor="f9f9f9" align="center">
									<td align="center" width="50"><font class="b02">년월</font></td>									
									<td align="center" width="80"><font class="b02">수금일자</font></td>
									<td align="center" width="80"><font class="b02">금액</font></td>
									<td align="center" width="80"><font class="b02">수금액</font></td>
									<td align="center" width=""colspan="2"><font class="b02">방법</font></td>
								</tr>
								
  								<%for (int i=1 ; i< 13 ; i++){ 
  										String seq = "";
  										if(i<10){
  											seq = "0"+i;
  										}else{
  											seq = Integer.toString(i);
  										}
  									%>
									<tr bgcolor="ffffff" align="center" id="pre<%=seq %>" style="display:none;">
										<td align="center"><input type="text" id="preYear<%=seq %>" name="preYear<%=seq %>" value="<%=(String)request.getAttribute("lastyymm"+seq) %>" class='box_n' readOnly/></td>
										<td align="center"><input type="text" id="preSnDt<%=seq %>" name="preSnDt<%=seq %>" maxlength="8" class='box_n' value="<c:out value='${sdate}' />" readonly onClick="Calendar(this)" class='box_n'/></td>
										<td align="center"><input type="text" id="preBillAmt<%=seq %>" name="preBillAmt<%=seq %>" class='box_n' style="ime-Mode:disabled" onKeyPress="inputNumCom();"/></td>
										<td align="center"><input type="text" id="preAmt<%=seq %>" name="preAmt<%=seq %>" class='box_n' style="ime-Mode:disabled" onKeyPress="inputNumCom();"/></td>
										<td colspan="2">
											<select name="preSgbbCd<%=seq %>" id="preSgbbCd<%=seq %>" class='box_n'>
											</select>
										</td>
									</tr>
								<%} %>

								<%for (int i=1 ; i< 13 ; i++){ 
  										String seq = "";
  										if(i<10){
  											seq = "0"+i;
  										}else{
  											seq = Integer.toString(i);
  										}
  										if(i == 12){%>
  											<tr bgcolor="FF0011" align="center" id="now<%=seq %>" style="display:block;">
  										<%}else{%>
  											<tr bgcolor="ffffff" align="center" id="now<%=seq %>" style="display:block;">
  										<%} %>
										<td align="center"><input type="text" id="nowYear<%=seq %>" name="nowYear<%=seq %>" value="<%=(String)request.getAttribute("nowyymm"+seq) %>" class='box_n' readOnly/></td>
										<td align="center"><input type="text" id="nowSnDt<%=seq %>" name="nowSnDt<%=seq %>" maxlength="8" class='box_n' value="<c:out value='${sdate}' />" readonly onClick="Calendar(this)" class='box_n'/></td>
										<td align="center"><input type="text" id="nowBillAmt<%=seq %>" name="nowBillAmt<%=seq %>" class='box_n' style="ime-Mode:disabled" onKeyPress="inputNumCom();"/></td>
										<td align="center"><input type="text" id="nowAmt<%=seq %>" name="nowAmt<%=seq %>" class='box_n' style="ime-Mode:disabled" onKeyPress="inputNumCom();"/></td>
										<td colspan="2">
											<select name="nowSgbbCd<%=seq %>" id="nowSgbbCd<%=seq %>" class='box_n'>
											</select>
										</td>
									</tr>
								<%} %>

								<%for (int i=1 ; i< 13 ; i++){ 
  										String seq = "";
  										if(i<10){
  											seq = "0"+i;
  										}else{
  											seq = Integer.toString(i);
  										}
  								%>
									<tr bgcolor="ffffff" align="center" id="next<%=seq %>" style="display:none;">
										<td align="center"><input type="text" id="nextYear<%=seq %>" name="nextYear<%=seq %>" value="<%=(String)request.getAttribute("nextyymm"+seq) %>" class='box_n' readOnlyreadOnly/></td>
										<td align="center"><input type="text" id="nextSnDt<%=seq %>" name="nextSnDt<%=seq %>" maxlength="8" class='box_n' value="<c:out value='${sdate}' />" readonly onClick="Calendar(this)" class='box_n'/></td>
										<td align="center"><input type="text" id="nextBillAmt<%=seq %>" name="nextBillAmt<%=seq %>" class='box_n' style="ime-Mode:disabled" onKeyPress="inputNumCom();"/></td>
										<td align="center"><input type="text" id="nextAmt<%=seq %>" name="nextAmt<%=seq %>" class='box_n' style="ime-Mode:disabled" onKeyPress="inputNumCom();"/></td>
										<td colspan="2">
											<select name="nextSgbbCd<%=seq %>" id="nextSgbbCd<%=seq %>" class='box_n'>
											</select>
										</td>
									</tr>
								<%} %>
							</table>
							<table width="100%" cellpadding="1" cellspacing="1"  border="0" bgcolor="e5e5e5">
								<tr>
								  	<Td align="center">
										<c:choose>
											<c:when test="${not empty admin_userid }">
											<a href="javascript:alert('지국만 가능합니다.');"><img src="/images/bt_sin.gif" border="0" align="absmiddle"></a>
											<a href="javascript:alert('지국만 가능합니다.');"><img src="/images/bt_bul.gif" border="0" align="absmiddle"></a>
											<a href="javascript:alert('지국만 가능합니다.');"><img src="/images/bt_ee.gif" border="0" align="absmiddle"></a>
											<a href="javascript:alert('지국만 가능합니다.');"><img src="/images/bt_hyu.gif" border="0" align="absmiddle"></a>
											<a href="javascript:alert('지국만 가능합니다.');"><img src="/images/bt_hae.gif" border="0" align="absmiddle"></a>
											</c:when>
											<c:otherwise>
											<a href="javascript:winPop('1')"><img src="/images/bt_sin.gif" border="0" align="absmiddle"></a>
											<a href="javascript:winPop('001')"><img src="/images/bt_bul.gif" border="0" align="absmiddle"></a> 
											<a href="javascript:winPop('002')"><img src="/images/bt_ee.gif" border="0" align="absmiddle"></a> 
											<a href="javascript:winPop('003')"><img src="/images/bt_hyu.gif" border="0" align="absmiddle"></a> 
											<a href="javascript:winPop('004')"><img src="/images/bt_hae.gif" border="0" align="absmiddle"></a>
											</c:otherwise>
										</c:choose>
									</TD>
								</tr>
								<tr>
									<td align="center">
										<img src="/images/bt_dok.gif" border="0" align="absmiddle">
									</td>
								</tr>
								<tr bgcolor="ffffff">
									<td><textarea id="remk" name="remk" class='box_l'></textarea></td>
								</tr>
							</table>
							
						</td>

					</tr>
				</table>
			</td>
		</tr>
		<tr>
	  		<td colspan='2'>
				<p style="top-margin:10px;">
				<table width="100%" cellpadding="5" cellspacing="0" border="0" bgcolor="e5e5e5" class="b_01">
	  				<tr bgcolor="ffffff">
	    				<td bgcolor="ffffff" align="left" width="12%">
	    					<select class='search' id="searchType" name="searchType" onchange="javascript:changeSearch()">
								<option value='1' <c:if test="${param.searchType eq '1' }">selected</c:if> >구역</option>
								<option value='2' <c:if test="${param.searchType eq '2' }">selected</c:if> >구역+배달번호</option>
								<option value='3' <c:if test="${param.searchType eq '3' }">selected</c:if> >독자번호</option>
								<option value='4' <c:if test="${param.searchType eq '4' }">selected</c:if> >독자성명</option>
								<option value='5' <c:if test="${param.searchType eq '5' }">selected</c:if> >주소</option>
								<option value='6' <c:if test="${param.searchType eq '6' }">selected</c:if> >전화번호</option>
								<option value='8' <c:if test="${param.searchType eq '8'}">selected</c:if>>수금방법</option>
								<option value='9' <c:if test="${param.searchType eq '9'}">selected</c:if>>신문명</option>
								<option value='7' <c:if test="${empty param.searchType || param.searchType eq '7'}">selected</c:if>>통합</option>
							</select>
						</td>
						<td width="12%">
					    	<select name="searchSgType" id="searchSgType" style="display:none" class="box_100">
								<option value=""></option>
								<c:forEach items="${sgTypeList }" var="list">
									<option value="${list.CODE }" <c:if test="${searchSgType eq list.CODE}">selected</c:if>>${list.CNAME }</option>
								</c:forEach> 
							</select>
							<select name="searchNewsCdType" id="searchNewsCdType" style="display:none" class="box_100">
								<option value=""></option>
								<c:forEach items="${newSList }" var="list" varStatus="i">
									<option value="${list.CODE }" <c:if test="${searchNewsCdType eq list.CODE}">selected</c:if>>${list.CNAME }</option>
								</c:forEach>
							</select>
						<td>
					    	<input type="text" id="searchText" name="searchText" value="<c:out value='${param.searchText}'/>" style='border: 1px solid #cccccc; background-color: #ffffff; height: 20px; width: 350px;' onkeydown="if(event.keyCode == 13){search(); }">&nbsp;&nbsp;
					    	<a href="javascript:search();"><img src="/images/bt_search.gif" border="0" align="absmiddle"></a>
					    </td> 
					    <td align="right">
							<c:if test="${empty admin_userid }">
								<a href="javascript:sort();">배달번호정렬</a>
							</c:if>
					    </td>
					</tr>
				</table>
				<table width="100%" cellpadding="5" cellspacing="1" border="0" bgcolor="e5e5e5" class="b_01">
					<tr bgcolor="ffffff">
					    <td colspan="3"  align="center" bgcolor="ffffff">
	
						<!--통합 내용출력자리-->
						
							<table width="100%" cellpadding="5" cellspacing="0" border="0" bgcolor="efefef" class="b_01">
								<tr>
									<td colspan="11" height="1" bgcolor="e5e5e5"></td>
								</tr>
								<tr bgcolor="ffffff">
									<td align="center" width="60"><font class="b02">구역배달</font></td>
									<td align="center" width="55"><font class="b02">독자</font></td>
									<td align="center" width="39"><font class="b02">매체명</font></td>
									<td align="center" width="120"><font class="b02">독자명</font></td>
									<td align="center" width="29"><font class="b02">부수</font></td>
									<td align="center" width="80"><font class="b02">전화번호</font></td>
									<td align="center" width="80"><font class="b02">핸드폰</font></td>
									<td align="center" width=""><font class="b02">주소</font></td>
									<td align="center" width="60"><font class="b02">확장/중지</font></td>
									<td align="center" width="50"><font class="b02">총수금</font></td>
									<td align="center" width="50"><font class="b02">미수액</font></td>
									<td align="center" width="6px"></td>
								</tr>
							</table>

							<div id="xlist">
								<table width="100%" cellpadding="5" cellspacing="0" border="0" bgcolor="efefef" class="b_01">
									<c:forEach items="${readerList }" var="list" varStatus="i">
										<span id="tem_readNo${i.index}" name="tem_readNo${i.index}" style="display:none">${list.READNO}</span><!--독자번호-->
										<span id="tem_newsCd${i.index}" name="tem_newsCd${i.index}" style="display:none">${list.NEWSCD}</span><!--신문코드-->
										<span id="tem_seq${i.index}" name="tem_seq${i.index}" style="display:none">${list.SEQ}</span><!--일련번호-->
										<span id="tem_boSeq${i.index}" name="tem_boSeq${i.index}" style="display:none">${list.BOSEQ}</span><!--지국일련번호-->
										<span id="tem_boReadNo${i.index}" name="tem_boReadNo${i.index}" style="display:none">${list.BOREADNO}</span><!--지국독자번호-->
										<span id="tem_gno${i.index}" name="tem_gno${i.index}" style="display:none">${list.GNO}</span><!--구역-->
										<span id="tem_bno${i.index}" name="tem_bno${i.index}" style="display:none">${list.BNO}</span><!--배달번호-->
										<span id="tem_sno${i.index}" name="tem_sno${i.index}" style="display:none">${list.SNO}</span><!--사이번호-->
										<span id="tem_readTypeCd${i.index}" name="tem_readTypeCd${i.index}" style="display:none">${list.READTYPECD}</span><!--독자유형(일반학생기증투입강투)-->
										<span id="tem_readNm${i.index}" name="tem_readNm${i.index}" style="display:none"><c:out value="${list.READNM }"/></span><!--독자명-->
										<span id="tem_offiNm${i.index}" name="tem_offiNm${i.index}" style="display:none">${list.OFFINM}</span><!--사무실명-->
										<span id="tem_homeTel1${i.index}" name="tem_homeTel1${i.index}" style="display:none">${list.HOMETEL1}</span><!--전화번호1-->
										<span id="tem_homeTel2${i.index}" name="tem_homeTel2${i.index}" style="display:none">${list.HOMETEL2}</span><!--전화번호2-->
										<span id="tem_homeTel3${i.index}" name="tem_homeTel3${i.index}" style="display:none">${list.HOMETEL3}</span><!--전화번호3-->
										<span id="tem_mobile1${i.index}" name="tem_mobile1${i.index}" style="display:none">${list.MOBILE1}</span><!--휴대폰1-->
										<span id="tem_mobile2${i.index}" name="tem_mobile2${i.index}" style="display:none">${list.MOBILE2}</span><!--휴대폰2-->
										<span id="tem_mobile3${i.index}" name="tem_mobile3${i.index}" style="display:none">${list.MOBILE3}</span><!--휴대폰3-->
										<span id="tem_dlvZip${i.index}" name="tem_dlvZip${i.index}" style="display:none">${list.DLVZIP}</span><!--배달우편번호-->
										<span id="tem_dlvAdrs1${i.index}" name="tem_dlvAdrs1${i.index}" style="display:none">${list.DLVADRS1}</span><!--배달지주소1(우편주소)-->
										<span id="tem_dlvAdrs2${i.index}" name="tem_dlvAdrs2${i.index}" style="display:none"><c:out value="${list.DLVADRS2}"/></span><!--배달지주소2-->
										<span id="tem_dlvStrNm${i.index}" name="tem_dlvStrNm${i.index}" style="display:none">${list.DLVSTRNM}</span><!--배달거리명-->
										<span id="tem_dlvStrNo${i.index}" name="tem_dlvStrNo${i.index}" style="display:none">${list.DLVSTRNO}</span><!--배달거리번호-->
										<span id="tem_aptCd${i.index}" name="tem_aptCd${i.index}" style="display:none">${list.APTCD}</span><!--아파트코드-->
										<span id="tem_aptNm${i.index}" name="tem_aptNm${i.index}" style="display:none">${list.APTNM}</span><!--아파트코드-->
										<span id="tem_aptDong${i.index}" name="tem_aptDong${i.index}" style="display:none">${list.APTDONG}</span><!--아파트동-->
										<span id="tem_aptHo${i.index}" name="tem_aptHo${i.index}" style="display:none">${list.APTHO}</span><!--아파트호-->
										<span id="tem_sgType${i.index}" name="tem_sgType${i.index}" style="display:none">${list.SGTYPE}</span><!--수금방법-->
										<span id="tem_sgInfo${i.index}" name="tem_sgInfo${i.index}" style="display:none">${list.SGINFO}</span><!--수금지정보-->
										<span id="tem_sgTel1${i.index}" name="tem_sgTel1${i.index}" style="display:none">${list.SGTEL1}</span><!--수금자전화번호1-->
										<span id="tem_sgTel2${i.index}" name="tem_sgTel2${i.index}" style="display:none">${list.SGTEL2}</span><!--수금자전화번호2-->
										<span id="tem_sgTel3${i.index}" name="tem_sgTel3${i.index}" style="display:none">${list.SGTEL3}</span><!--수금자전화번호3-->
										<span id="tem_uPrice${i.index}" name="tem_uPrice${i.index}" style="display:none">${list.UPRICE}</span><!--단가-->
										<span id="tem_sumUprice${i.index}" name="tem_sumUprice${i.index}" style="display:none">${list.SUMUPRICE}</span><!--총단가-->
										<span id="tem_qty${i.index}" name="tem_qty${i.index}" style="display:none">${list.QTY}</span><!--부수-->
										<span id="tem_sumQty${i.index}" name="tem_sumQty${i.index}" style="display:none">${list.SUMQTY}</span><!--총부수-->
										<span id="tem_rsdTypeCd${i.index}" name="tem_rsdTypeCd${i.index}" style="display:none">${list.RSDTYPECD}</span><!--주거구분-->
										<span id="tem_dlvTypeCd${i.index}" name="tem_dlvTypeCd${i.index}" style="display:none">${list.DLVTYPECD}</span><!--배달유형(직배우송)-->
										<span id="tem_dlvPosiCd${i.index}" name="tem_dlvPosiCd${i.index}" style="display:none">${list.DLVPOSICD}</span><!--배달장소-->
										<span id="tem_hjPathCd${i.index}" name="tem_hjPathCd${i.index}" style="display:none">${list.HJPATHCD}</span><!--확장경로-->
										<span id="tem_hjTypeCd${i.index}" name="tem_hjTypeCd${i.index}" style="display:none">${list.HJTYPECD}</span><!--확장유형코드-->
										<span id="tem_hjPsregCd${i.index}" name="tem_hjPsregCd${i.index}" style="display:none">${list.HJPSREGCD}</span><!--확장자등록코드-->
										<span id="tem_hjPsnm${i.index}" name="tem_hjPsnm${i.index}" style="display:none">${list.HJPSNM}</span><!--확장자명-->
										<span id="tem_hjDt${i.index}" name="tem_hjDt${i.index}" style="display:none">${list.HJDT}</span><!--확장일자-->
										<span id="tem_aplcDt${i.index}" name="tem_aplcDt${i.index}" style="display:none">${list.APLCDT}</span><!--확장일자-->
										<span id="tem_sgBgmm${i.index}" name="tem_sgBgmm${i.index}" style="display:none">${list.SGBGMM}</span><!--수금시작월-->
										<span id="tem_sgEdmm${i.index}" name="tem_sgEdmm${i.index}" style="display:none">${list.SGEDMM}</span><!--수금종료월-->
										<span id="tem_sgCycle${i.index}" name="tem_sgCycle${i.index}" style="display:none">${list.SGCYCLE}</span><!--수금주기(1~12)-->
										<span id="tem_stdt${i.index}" name="tem_stdt${i.index}" style="display:none">${list.STDT}</span><!--중지일자-->
										<span id="tem_stSayou${i.index}" name="tem_stSayou${i.index}" style="display:none">${list.STSAYOU}</span><!--중지사유-->
										<span id="tem_OldStSayou${i.index}" name="tem_OldStSayou${i.index}" style="display:none">${list.STSAYOU}</span><!--중지사유-->
										<span id="tem_remk${i.index}" name="tem_remk${i.index}" style="display:none"><c:out value="${list.REMK}"/></span><!--비고-->
										<span id="tem_inps${i.index}" name="tem_inps${i.index}" style="display:none">${list.INPS}</span><!--입력자-->
										<span id="tem_chgPs${i.index}" name="tem_chgPs${i.index}" style="display:none">${list.CHGPS}</span><!--변경자-->
										<span id="tem_spgCd${i.index}" name="tem_spgCd${i.index}" style="display:none">${list.SPGCD}</span><!--판촉물코드-->
										<span id="tem_bnsBookCd${i.index}" name="tem_bnsBookCd${i.index}" style="display:none">${list.BNSBOOKCD}</span><!--보너스북코드-->
										<span id="tem_taskCd${i.index}" name="tem_taskCd${i.index}" style="display:none">${list.TASKCD}</span><!--직종코드-->
										<span id="tem_intFldCd${i.index}" name="tem_intFldCd${i.index}" style="display:none">${list.INTFLDCD}</span><!--관심코드-->
										<span id="tem_bidt${i.index}" name="tem_bidt${i.index}" style="display:none">${list.BIDT}</span><!--생년월일-->
										<span id="tem_eMail${i.index}" name="tem_eMail${i.index}" style="display:none">${list.EMAIL}</span><!--이메일-->
										<span id="tem_term${i.index}" name="tem_term${i.index}" style="display:none">${list.TERM}</span><!--구독기간-->
										<span id="tem_callLog${i.index}" name="tem_callLog${i.index}" style="display:none">${list.CALLLOG}</span><!--통화기록-->
										<span id="tem_receipt${i.index}" name="tem_receipt${i.index}" style="display:none">${list.RECEIPT}</span><!--영수증출력여부-->
										<c:choose>
										<c:when test="${list.BNO eq '999'}">
											<tr bgcolor="f9f9f9" onClick="javascript:detailView('${i.index}')" style="cursor:hand;">
												<td align="center" width="60"><font class="b03">${list.GNO }-${list.BNO }</font></td>
												<td align="center" width="55"><font class="b03">${list.READNO }</font></td>
												<td align="center" width="39"><font class="b03">${list.NEWSNM }</font></td>
												<td align="left" width="120"><font class="b03"><c:out value="${list.READNM }"/></font></td>
												<td align="center" width="29"><font class="b03">${list.QTY }</font></td>
												<td align="left" width="80"><font class="b03">${list.HOMETEL }</font></td>
												<td align="left" width="80"><font class="b03">${list.MOBILE }</font></td>
												<td align="left" width=""><font class="b03">${list.ADDR }</font></td>
												<td align="center" width="60"><font class="b03">${fn:substring(list.STDT,0,4) }-${fn:substring(list.STDT,4,6) }-${fn:substring(list.STDT,6,8) }</font></td>
												<td align="center" width="50"><font class="b03"><fmt:formatNumber value="${list.SUMCOLLECT }" type="number" /></font></td>
												<td align="center" width="50"><font class="b03"><fmt:formatNumber value="${list.ACCOUNTDUE }" type="number" /></font></td>
											</tr>
											<tr>
												<td colspan="11" height="1" bgcolor="e5e5e5"></td>
											</tr>
										</c:when>
										<c:otherwise>
											<tr bgcolor="ffffff" onClick="javascript:detailView('${i.index}')" style="cursor:hand;">
												<td align="center" width="60">${list.GNO }-${list.BNO }</td>
												<td align="center" width="55">${list.READNO }</td>
												<td align="center" width="39">${list.NEWSNM }</td>
												<td align="left" width="120"><c:out value="${list.READNM }"/></td>
												<td align="center" width="29">${list.QTY }</td>
												<td align="left" width="80">${list.HOMETEL }</td>
												<td align="left" width="80">${list.MOBILE }</td>
												<td align="left" width="">${list.ADDR }</td>
												<td align="center" width="60">${fn:substring(list.HJDT,0,4) }-${fn:substring(list.HJDT,4,6) }-${fn:substring(list.HJDT,6,8) }</td>
												<td align="center" width="50"><fmt:formatNumber value="${list.SUMCOLLECT }" type="number" /></td>
												<td align="center" width="50"><fmt:formatNumber value="${list.ACCOUNTDUE }" type="number" /></td>
											</tr>
											<tr>
												<td colspan="11" height="1" bgcolor="e5e5e5"></td>
											</tr>
										</c:otherwise>
										</c:choose>
									</c:forEach>
								</table>
							</div>
							<table width="100%" cellpadding="5" cellspacing="0" border="0" bgcolor="efefef" class="b_01">
								<tr>
									<td colspan="6" align="center"><%@ include file="/common/paging.jsp"%></td>
								</tr>
							</table>
						</td>
					</tr> 
				</table>
			</td>
		</tr>
	</table>
<!-- main 끝-->
</form>



