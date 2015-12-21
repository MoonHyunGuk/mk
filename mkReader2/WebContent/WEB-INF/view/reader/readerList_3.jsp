<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.security.*" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<% String agency_userid = (String)session.getAttribute(ISiteConstant.SESSION_NAME_AGENCY_USERID); %>
<script type="text/javascript" src="/js/mini_calendar3.js"></script>
<script type="text/javascript" src="/js/ajaxUtil.js"></script>
<script type="text/javascript">
	//  자세히 보기, 독자 수금정보 조회(ajax)
	function detailView(index) {
		var fm = document.getElementById("readerListForm");
		
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
		$("newaddr").value = replaceHtml(document.getElementById('tem_newaddr'+index).innerHTML);
		//document.getElementById("oldAddr").innerHTML = "&nbsp;"+document.getElementById('tem_oldaddr'+index).innerHTML;
		var totAddr = "";
		if("" == document.getElementById('tem_newaddr'+index).innerHTML ) { //새주소가 없을때는 기존 주소를 보여준다.
			totAddr = document.getElementById('tem_dlvAdrs1'+index).innerHTML;
		} else {
			totAddr = document.getElementById('tem_newaddr'+index).innerHTML+"<b> ("+document.getElementById('tem_dlvAdrs1'+index).innerHTML+")</b>";
		}
		document.getElementById("allAddr").innerHTML = "&nbsp;"+totAddr;
		fm.bdMngNo.value = replaceHtml(document.getElementById('tem_bdMngNo'+index).innerHTML);
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
		$("spRemk").value = replaceHtml(document.getElementById('tem_remk'+index).innerHTML);
		//$("remk").value = "";
		$("desc").value = "";
		$("stSayou").value = document.getElementById('tem_stSayou'+index).innerHTML;
		$("oldStSayou").value = document.getElementById('tem_OldStSayou'+index).innerHTML;
		$("sgCycle").value = document.getElementById('tem_sgCycle'+index).innerHTML;
		$("oldSgCycle").value = document.getElementById('tem_sgCycle'+index).innerHTML;
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
		
		//메모리스트 조회
		var url = "/util/memo/getAjaxMemoOfRecently.do?readNo="+$('readNo').value;
		sendAjaxRequest(url, "readerListForm", "post", readerMemoInfo);
		
		//메모 더보기 클릭이벤트 설정
		document.getElementById("tagMemoLlist").onclick = function(){fn_memo_view_more($('readNo').value)};
		
		//정보수정
		fm.flag.value = "UPT";
	}
	
	//메모정보 셋팅 펑션
	function readerMemoInfo(responseHttpObj) {
		if (responseHttpObj) {
			try {
				var result = responseHttpObj.responseText.evalJSON();
				
				//메모리스트 세팅
				if(result.memoList != "") {
					setMemoList(result.memoList);
				} 

			} catch (e) {
				alert("오류(msg) : " + e);
			}
		}
	}
	
	//이전 비고내용 복사하기
	function fn_insert_note(val) {
		alert(val);
	}
	
	//메모리스트 조회
	function setMemoList (jsonObjArr){
		$("desc").value="";
		var div_head = document.createElement("div");
		var div_note = document.createElement("div");
		if (jsonObjArr.length > 0) {
			for(var j=0 ; j < jsonObjArr.length ; j++){
				div_note = document.createElement("div");//font-weight: bold;
				div_head = document.createElement("div");
				div_note.onclick = function() {fn_insert_note(jsonObjArr[j].MEMO)};
				div_head.style.cssText = "font-weight: bold; padding: 3px 0 0 3px";
				div_head.innerText = "["+jsonObjArr[j].CREATE_ID+"] "+jsonObjArr[j].CREATE_DATE;
				div_note.innerText = jsonObjArr[j].MEMO;
				div_note.style.cssText = "border-bottom: 1px solid #e5e5e5; padding-bottom: 3px";
				$("desc").appendChild(div_head);
				$("desc").appendChild(div_note);
				document.getElementById("remk").value = jsonObjArr[0].MEMO;
			}
		
		}else{
			div = document.createElement("div");
			div.innerText = "기록이 없습니다.";
			$("desc").appendChild(div);
		}
	}
	
	/**
	 *	비고저장 버튼 클릭 이벤트
	 **/
	function fn_saveRemk() {
		var fm = document.getElementById("readerListForm");
		var remk = document.getElementById("remk");
		var readNo = document.getElementById("readNo");
		
		//독자번호가 없을시
		if(readNo.value == "") {
			alert("독자를 먼저 선택해주세요.");
			return false;
		}
		
		if(remk.value == "") {
			alert("비고 내용을 입력해주세요.");
			remk.focus();
			return false;
		}
		
		//글자수 제한
		if(remk.value.length > 200) {
			alert("비고내용은 200자를 넘을 수 없습니다.");
			return false;
		}
		
		if(!confirm("비고를 저장하시겠습니까?")) {return false;}
		
		fm.target = "_self";
		fm.action = "/util/memo/saveMemoContents.do";
		fm.submit();
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
		var deadLineDt = nowYear+"20";

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
						$("preClDt"+seq).value = jsonObjArr[i].CLDT;
/* ABC용수금 방법 콤보 컨트롤
						if(jsonObjArr[i].SGBBCD != '044'){
							if( $("preClDt"+seq).value < Number(deadLineDt)){
								$("preSgbbCd"+seq).options.length = 0;
								$("preSgbbCd"+seq).options[0] = new Option(jsonObjArr[i].SGBBNM , jsonObjArr[i].SGBBCD );
							// 처리일이 마감일보다 큰경우 수정가능 (2012.06.14 박윤철)
							}else{
								$("preSgbbCd"+seq).value = jsonObjArr[i].SGBBCD;
							}
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
						$("nowClDt"+seq).value = jsonObjArr[i].CLDT;
/* ABC용수금 방법 콤보 컨트롤
						if( Number($("nowYear"+seq).value) < Number(nowYear)  ){
							if(jsonObjArr[i].SGBBCD != '044'){
								if( $("nowClDt"+seq).value < Number(deadLineDt)){
									$("nowSgbbCd"+seq).options.length = 0;
									$("nowSgbbCd"+seq).options[0] = new Option(jsonObjArr[i].SGBBNM , jsonObjArr[i].SGBBCD );
								// 처리일이 마감일보다 큰경우 수정가능 (2012.06.14 박윤철)
								}else{
									$("nowSgbbCd"+seq).value = jsonObjArr[i].SGBBCD;
								}
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
						$("nextClDt"+seq).value = jsonObjArr[i].CLDT;
					}
				}
			} 
			for ( var i = 0; i < jsonObjArr.length; i++) {
				if (i == jsonObjArr.length - 2) {
					$("sumgClam").innerHTML = jsonObjArr[i].thisYear;
					$("thisYearSumgClam").value = jsonObjArr[i].thisYear;
				}
				if (i == jsonObjArr.length - 1) {
					$("lastYearSumgClam").value = jsonObjArr[i].lastYear;
				}
			}
		}
		//현재월부터 이후는 수정가능
		//현재월 은 미수만 가능
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
					// 처리일이 마감일보다 큰경우 수정가능 (2012.06.14 박윤철)
					if($("preClDt"+seq).value < Number(deadLineDt)){
						$("preBillAmt"+seq).readOnly = true;
						$("preAmt"+seq).readOnly = true;
					}
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
						// 처리일이 마감일보다 큰경우 수정가능 (2012.06.14 박윤철)
						if( $("nowClDt"+seq).value < Number(deadLineDt)){
							$("nowSnDt"+seq).readOnly = true;
							$("nowBillAmt"+seq).readOnly = true;
							$("nowAmt"+seq).readOnly = true;
						}
					}
				}
			}
*/
		}
	}
	//작년 금년 수금
	function fn_sumgClam(gbn){
		if(gbn == 'last'){
			$("sumgClam").innerHTML = $("lastYearSumgClam").value;	
		}else{
			$("sumgClam").innerHTML = $("thisYearSumgClam").value;	
		}
	}
	
	
	// 신청경로 변경(확장자도 같이 변경해줘야함.)
	function changeHjPath(){
		if($("hjPathCd").value =='006' || $("hjPathCd").value =='007' || $("hjPathCd").value =='011'){
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
	function fn_changSumgList(gbn){
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
		} else if ("002" == url) {// 요청 독자 조회
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
			if( event.keyCode != 8 || event.keyCode != 46){
				alert("숫자만 입력 가능합니다.");
				event.keyCode = 0;  // 이벤트 cancel
			}
		}
	}
	
	//신규독자 버튼 클릭시 필드 초기화
	function clearField(chkFlag){
		var fm = document.getElementById("readerListForm");
		
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
		$("seq").value = '0001';
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
		//document.getElementById("oldAddr").innerHTML = ""
		document.getElementById("allAddr").innerHTML = "";
		$("rsdTypeCd").value = '';
		$("hjPathCd").value = '';
		$("taskCd").value = '';
		$("intFldCd").value = '';  
		$("newsCd").value = '100';
		$("oldNewsCd").value = '100';
		$("oldGno").value = '';
		
		// 신규독자 버튼 클릭시에만 검색값 초기화
		if( chkFlag == "newReader"){
			$("searchText").value = '';
		}
		
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
		$("sgCycle").value = '1';
		$("oldSgCycle").value = '';
		document.getElementById("desc").value ="";
		
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
		
		//신규등록
		fm.flag.value = "INS";
	}
	
	
	//독자정보 생성,수정
	function fn_save() {
		var fm = document.getElementById("readerListForm");
		var flag = document.getElementById("flag").value;
		var url = "";
		
		if(!cf_checkNull("readNm", "독자명")) { return false; }

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
		
		// 교육용 독자 지국 중지 불가( 2013.01.30 박윤철)
		// 교육용지국인 경우 중지 가능( 2013.07.16 박윤철)
		if($("agencyid").value != '521050' && $("oldReadTypeCd").value == '015'){
			if($("oldStdt").value == "" && $("oldStSayou").value == ""){
				if($("stdt").value != "" || $("stSayou").value != ""){
					alert('교육용 독자 입니다. \n본사 담당자에게 연락해 주세요.');
					$("stdt").value = "" ;
					$("stSayou").value = "" ;
					return;
				}
			}
		}

		// 구역번호 변경전에 해지 불가( 2012.07.11 박윤철)
		if($("oldGno").value == "200" || $("oldGno").value == "300"  || $("oldGno").value == "400" || $("oldGno").value == "500" || $("oldGno").value == "600"){
			if($("oldStdt").value == "" && $("oldStSayou").value == ""){
				if($("stdt").value != "" || $("stSayou").value != ""){
					alert('본사 등록 독자 입니다. \n구역 조정 후 관리해 주세요.');
					$("stdt").value = "" ;
					$("stSayou").value = "" ;
					return;
				}
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
		if(!cf_checkNull("dlvAdrs1", "주소")) { return false; }
		//if(!cf_checkNull("dlvAdrs2", "상세주소")) { return false; }
		if(!cf_checkNull("newsCd", "신문명")) { return false; }

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
		
		if(!cf_checkNull("sgType", "수금 방법")) { return false; }

		if( checkBytes($("remk").value) > 300){
			alert("독자비고는 300byte를 초과할수 없습니다.");
			$("remk").focus();
			return;
		}
		
		if(!cf_checkNull("qty", "구독부수")) { return false; }
		if(!cf_checkNull("uPrice", "단가")) { return false; }

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
		
		//지로용비고 값 가져오기
		var spRemkVal = document.getElementById("spRemk").value;
		
		if(spRemkVal.length > 100) {
			alert("지로용 비고는 100자까지 입력이 가능합니다.");
			document.getElementById("spRemk").focus();
			return false;
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
			
			// 학생(본사) 독자의 경우 자동이체가 아닌 상태에서 자동이체로 변경 불가 (2012.07.24 박윤철)
			if($("readTypeCd").value == '013' && $("oldSgType").value != '021' && $("sgType").value == '021' ){
				alert("본사 자동이체 학생으로의 변경은 불가합니다.") ;
				$("sgType").value = $("oldSgType").value;
				return;
			}
			
			// 학생(본사) 독자의 경우 유형과 독자유형 동시에 변경 불가 (//자동이체 테이블 구조에 따라서 2012.06.16 박윤철)
			if($("oldReadTypeCd").value == '013' && $("readTypeCd").value != '013' && $("oldSgType").value == '021' && ($("sgType").value != $("oldSgType").value) ){
				alert("본사 학생 독자의 경우 수금방법 변경 후에 유형 변경이 가능합니다.") ;
				$("readTypeCd").value = $("oldReadTypeCd").value;
				return;
			}
			
			//학생(본사)독자고 수금방법이 지로일때는 학생(본사)를 학생(지국)으로 변경(2013.11.15 문현국)
			if(document.getElementById("readTypeCd").value == '013' && document.getElementById("sgType").value == '011' ) {
				if(!confirm("지로로 변경하면 학생(지국) 독자로 변경됩니다. 변경하시겠습니까?")) {return;}
				
				document.getElementById("readTypeCd").value = "012";
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

		// 신규독자만 필수 값 적용( 박윤철 2012.05.11 )
		}else{
			if( $("rsdTypeCd").value == ''){
				alert("주거구분 선택해 주세요.");
				$("rsdTypeCd").focus();
				return;
			}
			if( $("hjPathCd").value == ''){
				alert("신청경로를 선택해 주세요.");
				$("hjPathCd").focus();
				return;
			}
			
		}
		if($("stSayou").value != '' && $("stdt").value != '' && Number($("qty").value) == 1){
			$("stQty").value = '1' ;
		}
		//해지팝업
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
				if($("preSnDt"+seq).value == ''){
					alert('수금일자를 입력해 주세요');
					$("preSnDt"+seq).focus;
					return;
				}
			}
			if($("nowSgbbCd"+seq).value != '' && $("nowSgbbCd"+seq).value != '044'){
				if($("nowSgbbCd"+seq).value == '033' || $("nowSgbbCd"+seq).value == '099'){
					$("nowBillAmt"+seq).value = '0';
					$("nowAmt"+seq).value = '0';
				}
				if($("nowSnDt"+seq).value == ''){
					alert('수금일자를 입력해 주세요');
					$("nowSnDt"+seq).focus;
					return;
				}
			}
			if($("nextSgbbCd"+seq).value != '' && $("nextSgbbCd"+seq).value != '044'){
				if($("nextSgbbCd"+seq).value == '033' || $("nextSgbbCd"+seq).value == '099'){
					$("nextBillAmt"+seq).value = '0';
					$("nextAmt"+seq).value = '0';
				}
				if($("nextSnDt"+seq).value == ''){
					alert('수금일자를 입력해 주세요');
					$("nextSnDt"+seq).focus;
					return;
				}
			}
			if($("preSnDt"+seq).value != '' && $("preSgbbCd"+seq).value == ''){
				alert($("preYear"+seq).value+'월분 수금 방법을 선택해 주세요.');
				$("preSgbbCd"+seq).focus();
				return;
			}
			if($("nowSnDt"+seq).value != '' && $("nowSgbbCd"+seq).value == ''){
				alert($("nowYear"+seq).value+'월분 수금 방법을 선택해 주세요.');
				$("nowSgbbCd"+seq).focus();
				return;
			}
			if($("nextSnDt"+seq).value != '' && $("nextSgbbCd"+seq).value == ''){
				alert($("nextYear"+seq).value+'월분 수금 방법을 선택해 주세요.');
				$("nextSgbbCd"+seq).focus();
				return;
			}
			
			/* 미수로 재처리시 수금일/ 수금액 0원처리 (2012.07.18 박윤철) */
			if($("preSgbbCd"+seq).value != '' && $("preSgbbCd"+seq).value == '044'){
				$("preAmt"+seq).value = '0';
				$("preSnDt"+seq).value = '' ;
			}else if($("nowSgbbCd"+seq).value != '' && $("nowSgbbCd"+seq).value == '044'){
				$("nowAmt"+seq).value = '0';
				$("nowSnDt"+seq).value = '' ;
			}else if($("nextSgbbCd"+seq).value != '' && $("nextSgbbCd"+seq).value == '044'){
				$("nextAmt"+seq).value = '0';
				$("nextSnDt"+seq).value = '' ;
			}
			
		}
		
		// 신규독자인경우 최종입력 여부 확인(이중 신청 방지 2012.08.22 박윤철)
		if($("readNo").value == ''){
			if(!confirm("신규독자를 입력하시겠습니까?")){
				return;
			}
		} else {
			if(!confirm("수정된 내용을 저장하시겠습니까?")){
				return;
			}
		}
		
		if("INS" == flag) {
			url = "/reader/readerManage/saveReader.do";
		} else if("UPT" == flag) {
			url = "/reader/readerManage/updateReaderData.do";
		}

		fm.target="_self";
		fm.action=url;
		fm.submit();
	}
	
	/**
	 * 주소변경여부
	 */
	function fn_addr_chg() {
		var fm = document.getElementById("readerListForm");
		
		fm.addrChgYn.value = "Y";
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
		var fm = document.getElementById("readerListForm");
		
		var left = 0;
		var top = 30;
		var winStyle = "width=520,height=700,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
		var newWin = window.open("", "pop_addr", winStyle);
		
		fm.target = "pop_addr";
		fm.action = "/common/common/popNewAddr.do";
		fm.submit();
	}
	
	//우편주소팝업에서 우편주소 선택시 셋팅 펑션
	function setAddr(zip , addr, newAddr, bdNm, dbMngNo){
		var fm = document.getElementById("readerListForm") ;
		
		var dlvZip = document.getElementById("dlvZip");
		var allAddr = document.getElementById("allAddr");
		var dlvAdrs2 = document.getElementById("dlvAdrs2");
		var newaddr = document.getElementById("newaddr");
		
		dlvZip.value = zip;
		newaddr.value = newAddr;
		allAddr.innerHTML = "";
		allAddr.innerHTML = newAddr+"("+addr+")";
		dlvAdrs2.value = bdNm;
		fm.bdMngNo.value = dbMngNo;
		fm.dlvAdrs1.value = addr;
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
	
	// 상세수금정보 출력
	function detailSugm(id1, id2){
		if(id1.value == null || id1.value == ""){

		}else{
			$("chgColumn").innerHTML = "처리일자";
			id1.style.display = "block";
			id2.style.display = "none";
		}
	}
	
	function closeSugm(id1, id2){
		$("chgColumn").innerHTML = "금액";
		id1.style.display = "none";
		id2.style.display = "block";
	}
	
	/**
	 *	비고 더보기 클릭 이벤트
	 **/
	function fn_memo_view_more(readno) {
		var winW = (screen.width-300)/2;
		var winH = (screen.height-600)/2;
		var url = '/util/memo/popMemoList.do?readno='+readno;
		
		window.open(url, '', 'width=300px, height=600px, resizable=yes, status=no, toolbar=no, location=no, top='+winH+', left='+winW);
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
	<input type="hidden" id="oldSgCycle" name="oldSgCycle" value="" />
	<input type="hidden" id="oldStdt" name="oldStdt" value="" />
	<input type="hidden" id="oldStSayou" name="oldStSayou" value="" />
	<input type="hidden" id="oldGno" name="oldGno" value="" />
	<input type="hidden" id="rtnUrl" name="rtnUrl" value="/reader/readerManage/searchReader.do" />
	<input type="hidden" id="agencyid" name="agencyid" value="<%=agency_userid%>" />
	<input type="hidden" id="addrChgYn" name="addrChgYn" value="N" />
	<input type="hidden" id="flag" name="flag" value="" />
	<input type="hidden" id="bdMngNo" name="bdMngNo" value="" />
	<input type="hidden" id="newaddr" name="newaddr" value="" />
	<input type="hidden" id="dlvAdrs1" name="dlvAdrs1" value="" />

	<!-- 페이징 처리 변수 -->
	<input type=hidden id="pageNo" name="pageNo" value="${param.pageNo}" />
	
<!--독자등록-->
	<div style="width: 1020px; margin: 0 auto; overflow: hidden; border: 0px solid red; padding-bottom: 5px">
		<!-- 독자정보&구독정보 -->
		<div style="width: 610px; float: left; border: 0px solid green; padding-right: 10px;">
			<div style="padding-bottom: 9px"><div class="subTitle_noIcon">독자관리</div></div>
			<!-- 독자정보 -->
				<div style="padding: 5px 0 5px 0;"><font class="b03"><b>[ 독자정보 ]</b></font></div> 
				<table class="tb_edit_4" style="width: 100%;">
					<colgroup>
						<col width="75px">
						<col width="130px">
						<col width="75px">
						<col width="130px">
						<col width="75px">
						<col width="125px"> 
					</colgroup>
					<c:if test="${not empty admin_userid }">
						<tr>
							<th>지 국 명</th>
							<td colspan="5">
								<select name="agency" id="agency" onchange="changeAgency();"> 
									<c:forEach items="${agencyList }" var="list">
									<option value="${list.SERIAL }"<c:if test="${agency_serial eq list.SERIAL }">selected</c:if>>${list.NAME }</option>
									</c:forEach>
								</select>
								<input type="text" id="agencySearch" name="agencySearch" style="width:100px" onkeydown="if(event.keyCode == 13){changeAgency();}"/>
								<a href="#fakeUrl" onclick="changeAgency();"><img src="/images/bt_search.gif" style="vertical-align:middle;border:0"></a>
							</td>
						</tr>
					</c:if>
					<tr>
					    <th>독자번호</th>
						<td>
							<input type="text" id="readNo" name="readNo" value="" style="width: 95%;" readonly="readonly" />
						</td>
						<th>구역명</th>
						<td><input type="text" id="gnoNm" name="gnoNm" value="" style="width: 95%;" readonly="readonly"/></td>
						<th><b class="b03">*</b>구역배달</th>
						<td style="text-align: left;">
							&nbsp;<select id="gno" name="gno" style="width:50px">
								<c:forEach items="${guYukList }" var="list">
									<option value="${list.GU_NO }">${list.GU_NO }</option>
								</c:forEach>
							</select> 
							<input type="text" id="bno" name="bno" value="" maxlength="3" style="width:25px;ime-mode:disabled" onkeypress="inputNumCom();"/> 
							<input type="text" id="sno" name="sno" value="" maxlength="2" style="width:20px;ime-mode:disabled" onkeypress="inputNumCom();"/>
						</td>
							</tr>
					<tr>
					    <th><b class="b03">*</b>독 자 명</th>
						<td colspan="3"><input type="text" id="readNm" name="readNm" value="" style="width: 98%; ime-mode:active"/></td>
						<th>생년월일</th>
						<td><input type="text" id="bidt" name="bidt" value="" maxlength="8" style="ime-mode:disabled; width: 95%" onkeypress="inputNumCom();"/></td>
					</tr>
					<tr >
					    <th>전화번호</th>
						<td>
							<select id="homeTel1" name="homeTel1">
							<c:forEach items="${areaCode }" var="list">
								<option value="${list.CODE }">${list.CODE }</option>
							</c:forEach> 
							</select>
							<input type="text" id="homeTel2" name="homeTel2" value="" maxlength="4" style="ime-mode:disabled; width: 30px" onkeypress="inputNumCom();">
							<input type="text" id="homeTel3" name="homeTel3" value="" maxlength="4" style="ime-mode:disabled; width: 30px" onkeypress="inputNumCom();">
						</td>
						<th>핸 드 폰</th>
						<td>
							<select id="mobile1" name="mobile1"> 
								<c:forEach items="${mobileCode }" var="list">
									<option value="${list.CODE }">${list.CODE }</option>
								</c:forEach> 
							</select> 
							<input type="text" id="mobile2" name="mobile2" value="" maxlength="4" style="ime-mode:disabled; width: 30px" onkeypress="inputNumCom();"> 
							<input type="text" id="mobile3" name="mobile3" value="" maxlength="4" style="ime-mode:disabled; width: 30px" onkeypress="inputNumCom();">
						</td>
						<th>E-mail</th>
						<td><input type="text" id="eMail" name="eMail" value=""  style="width: 95%;"/></td>
					</tr>
					<!-- 
					<tr >
					    <th><b class="b03">*</b>우편번호</th>
						<td style="text-align: left;">
							&nbsp;<input type="text" id="dlvZip" name="dlvZip" value="" maxlength="6" style="width: 60px; vertical-align: middle;" readonly="readonly" />
							<a href="#fakeUrl" onclick="popAddr();"><img alt="우편번호찾기" src="/images/ico_search2.gif" style="border: 0; vertical-align: middle;" /></a>
						</td>
						<td colspan="4" style="text-align: left; height:20px; font-size: 13px" id="oldAddr"></td>
					</tr>
					<tr >
					    <th style="letter-spacing: -1px"><b class="b03">*</b>도로명주소</th>
						<td colspan="5" style="text-align: left; height:20px; font-size: 13px" id="allAddr"></td>
					</tr>
					 -->
					 <tr >
					    <th style="letter-spacing: -1px"><b class="b03">*</b>도로명주소</th>
						<td style="text-align: left;">
							&nbsp;<input type="text" id="dlvZip" name="dlvZip" value="" maxlength="6" style="width: 60px; vertical-align: middle;" readonly="readonly" />
							<a href="#fakeUrl" onclick="popAddr();"><img alt="우편번호찾기" src="/images/ico_search2.gif" style="border: 0; vertical-align: middle;" /></a>
						</td>
						<td colspan="4" style="text-align: left; height:20px; font-size: 13px" id="allAddr"></td>
					</tr>
					<!-- tr >
					    <th>주소코드</td>
						<td>
							<input type="text" id=aptCd name="aptCd" value="" class='box_n3' readonly/>
							<input type="button" value="..." onclick="javascript:popAddrCode();"/>
						</td>
						<td colspan="4"><input type="text" id=aptNm name="aptNm" value="" class='box_n' readonly/></td>
					</tr -->
					<tr >
					    <th>상세주소</th>
						<td colspan="5"><input type="text" id="dlvAdrs2" name="dlvAdrs2" value=""  style="width: 98%"/></td>
					</tr>
					<tr >
					   <th><b class="b03">*</b>주거구분</th>
						<td>
							<select name="rsdTypeCd" id="rsdTypeCd" style="width: 95%;">
								<c:forEach items="${rsdTypeList }" var="list">
								<option value="${list.CODE }">${list.CNAME }</option>
								</c:forEach>
							</select>
						</td>
						<th>직종</th>
						<td>
							<select name="taskCd" id="taskCd"  style="width: 95%;">
								<c:forEach items="${taskList }" var="list">
								<option value="${list.CODE }">${list.CNAME }</option>
								</c:forEach>
							</select>
						</td>
						<th>관심분야</th>
						<td>
							<select name="intFldCd" id="intFldCd"  style="width: 95%;">
								<c:forEach items="${intFldList }" var="list">
								<option value="${list.CODE }">${list.CNAME }</option>
								</c:forEach>
							</select>
						</td>
					</tr>
				</table>
				<!-- //독자정보 -->
				<!-- 구독정보 -->
				<div style="padding-top:15px;">
					<div style="padding-bottom: 3px;"><font class="b03"><b>[ 구독정보 ]</b></font> &nbsp;&nbsp;&nbsp;<input type="checkbox" id="receipt" name="receipt" style="border: 0; vertical-align: middle;">&nbsp;<font class="b03" style="color:blue; vertical-align: middle;">지로,방문 영수증 미출력 체크</font></div>
					<div style="padding-bottom: 5px">
						<table class="tb_edit_4" style="width: 100%;">
							<colgroup>
								<col width="75px">
								<col width="130px">
								<col width="75px">
								<col width="130px">
								<col width="75px">
								<col width="125px"> 
							</colgroup>
						    <tr>
							    <th><b class="b03">*</b>신 문 명 </th>
								<td>
									<select name="newsCd" id="newsCd" style="width: 95%;">
										<c:forEach items="${newSList }" var="list" varStatus="i">
										<option value="${list.CODE }" >${list.CNAME }</option>
										</c:forEach>
									</select>
								</td>
								<th>확장일자</th>
								<td><input type="text" id="hjDt" name="hjDt"  value="<c:out value='${sdate}' />" readonly="readonly" onclick="Calendar(this)" style="width: 95%;"/></td>
								<th>독자유형</th>
								<td>
									<select name="readTypeCd" id="readTypeCd" style="width: 95%;">
										<c:forEach items="${readTypeList }" var="list">
										<option value="${list.CODE }">${list.CNAME }</option>
										</c:forEach>
									</select>
								</td>
						    </tr>
						    <tr>
							    <th><b class="b03">*</b>구독부수</th>
								<td>
									<input type="text" id="qty" name="qty" value="1" onkeyup="controlPrice();" style="ime-mode:disabled; width: 55px;" onkeypress="inputNumCom();">
									<input type="text" id="sumQty" name="sumQty" value="" style="color:blue; width: 55px; border: 0;" readonly="readonly">
								</td>
								<th><b class="b03">*</b>유가년월</th>
								<td><input type="text" id="sgBgmm" name="sgBgmm" value="" maxlength="6" style="ime-mode:disabled; width: 95%;" onkeypress="inputNumCom();" ></td>
								<th>배달유형</th>
								<td>
									<select name="dlvTypeCd" id="dlvTypeCd" style="width: 98%;">
										<c:forEach items="${dlvTypeList }" var="list">
										<option value="${list.CODE }">${list.CNAME }</option>
										</c:forEach>
									</select>
								</td>
						    </tr>
						    <tr>
							    <th><b class="b03">*</b>단&nbsp;&nbsp;&nbsp;&nbsp;가</th>
								<td>
									<input type="text" id="uPrice" name="uPrice" value="15000"  style="ime-mode:disabled; width: 55px" onkeypress="inputNumCom();"/>
									<input type="text" id="sumUprice" name="sumUprice" value="" style="color:blue; width:55px; border: 0;" readonly="readonly"/>
								</td>
								<th><b class="b03">*</b>신청경로</th>
								<td>
									<select name="hjPathCd" id="hjPathCd" style="width: 98%" onchange="changeHjPath()">
										<c:forEach items="${hjPathList }" var="list">
										<option value="${list.CODE }">${list.CNAME }</option>
										</c:forEach>
									</select>
								</td>
								<th>배달장소</th>
								<td>
									<select name="dlvPosiCd" id="dlvPosiCd" style="width: 98%">
										<option value=""></option>
										<c:forEach items="${dlvPosiCdList }" var="list">
										<option value="${list.CODE }">${list.CNAME }</option>
										</c:forEach>
									</select>
								</td>
						    </tr>
						    <tr>
							    <th><b class="b03">*</b>수금방법</th>
								<td>
									<select name="sgType" id="sgType" style="width:73px">
										<c:forEach items="${sgTypeList }" var="list">
										<option value="${list.CODE }">${list.CNAME }</option>
										</c:forEach> 
									</select>
									<select id="sgCycle" name="sgCycle" style="width:48px">
										<option value="1" selected="selected">월</option>
										<option value="3">분기</option>
									</select>
								</td>
								<th>확 장 자</th>
								<td>
									<select name="hjPsnm" id="hjPsnm"  style="width: 98%" onchange="sethjPregCd();">
									</select>
									<div style="display:none">
										<select name="hjPsregCd" id="hjPsregCd" style="width: 98%">
										</select>
									</div>
								</td>
								<th>자 매 지 </th>
								<td>
									<select name="bnsBookCd" id="bnsBookCd" style="width: 98%">
										<option value=""></option>
										<c:forEach items="${bnsBookList }" var="list">
										<option value="${list.CODE }">${list.CNAME }</option>
										</c:forEach> 
									</select>
								</td>
						    </tr>
						    <tr> 
							    <th>구독일자</th>    
								<td><input type="text" id="hjDt2" name="hjDt2" value="<c:out value='${sdate}' />" readonly="readonly" onclick="Calendar(this)" style="width: 95%"/></td>
								<th>구독기간</th>
								<td><input type="text" id="term" name="term" value="" readonly="readonly" style="width: 95%; border: 0;"/></td>
								<th>판촉물</th>
								<td>
									<select name="spgCd" id="spgCd" style="width: 98%">
										<option value=""></option>
										<c:forEach items="${SpgCdList }" var="list">
										<option value="${list.CODE }">${list.CNAME }</option>
										</c:forEach>
									</select>
								</td>
						    </tr>
						    <tr >
							    <th>해지일자</th>
								<td><input type="text" size="10" id="stdt" name="stdt" value="<c:out value='${sdate}' />" style="width: 95%" onclick="Calendar(this)"/></td>
								<th>해지사유</th>
								<td>
									<select name="stSayou" id="stSayou" style="width: 98%">
										<option value=""></option>
										<c:forEach items="${stSayouList }" var="list">
										<option value="${list.CODE }">${list.CNAME }</option>
										</c:forEach>
									</select>
								</td>
								<th onclick="callLog();" style="cursor:pointer;"><span style="color: GREEN"><b>통화기록</b></span></th>
								<td><div id="callLog"></div></td> 
						    </tr>
						     <tr >
							    <th>지로용비고</th>
								<td colspan="5"><input type="text" id="spRemk" name="spRemk" value="" style="width: 98%" maxlength="100" /></td>
						    </tr>
						</table>
					</div>
					<!-- button -->
					<div class="box_white">
						<div style="text-align: left; padding: 5px 0 5px 5px; width: 240px;  border: 0px solid red; float: left;">
							<c:choose>
								<c:when test="${not empty admin_userid }">
									<!-- 
									<a href="#fakeUrl" onclick="alert('지국만 가능합니다.');"><img src="/images/bt_sin.gif" style="vertical-align:middle;border:0"></a>
									<a href="#fakeUrl" onclick="alert('지국만 가능합니다.');"><img src="/images/bt_bul.gif" style="vertical-align:middle;border:0"></a>
									-->
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="alert('지국만 가능합니다.');">본사신청</a></span>
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="alert('지국만 가능합니다.');">본사불배</a></span>
									<div style="padding-top: 10px;">
										<!-- 
										<a href="#fakeUrl" onclick="alert('지국만 가능합니다.');"><img src="/images/bt_ee.gif" style="vertical-align:middle;border:0"></a>
										<a href="#fakeUrl" onclick="alert('지국만 가능합니다.');"><img src="/images/bt_hyu.gif" style="vertical-align:middle;border:0"></a>
										<a href="#fakeUrl" onclick="alert('지국만 가능합니다.');"><img src="/images/bt_hae.gif" style="vertical-align:middle;border:0"></a>
										-->
										<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="alert('지국만 가능합니다.');">본사</a></span>
										<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="alert('지국만 가능합니다.');">본사휴독</a></span>
										<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="alert('지국만 가능합니다.');">본사해지</a></span>
									</div>
								</c:when>
								<c:otherwise>
									<!-- 
									<a href="#fakeUrl" onclick="winPop('1')"><img src="/images/bt_sin.gif" style="vertical-align:middle;border:0"></a>
									<a href="#fakeUrl" onclick="winPop('001')"><img src="/images/bt_bul.gif" style="vertical-align:middle;border:0"></a>
									 -->
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="winPop('1')">본사신청</a></span>
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="winPop('001')">본사불배</a></span>
									<div style="padding-top: 5px;"> 
										<!-- 
										<a href="#fakeUrl" onclick="winPop('002')"><img src="/images/bt_ee.gif" style="vertical-align:middle;border:0"></a> 
										<a href="#fakeUrl" onclick="winPop('003')"><img src="/images/bt_hyu.gif" style="vertical-align:middle;border:0"></a> 
										<a href="#fakeUrl" onclick="winPop('004')"><img src="/images/bt_hae.gif" style="vertical-align:middle;border:0"></a>
										 -->
										<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="winPop('002')">본사</a></span>
										<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="winPop('003')">본사휴독</a></span>
										<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="winPop('004')">본사해지</a></span>
									</div>
								</c:otherwise>
							</c:choose>
						</div>
						<div style="padding: 5px 0 0 0; text-align: right; border: 0px solid red; float: left; width: 348px">
							<c:choose>
								<c:when test="${not empty admin_userid }">
									<!-- 
									<a href="#fakeUrl" onclick="alert('지국만 가능합니다.');"><img src="/images/bt_save.gif" style="vertical-align:middle;border:0"></a>&nbsp;&nbsp;
									<a href="#fakeUrl" onclick="alert('지국만 가능합니다.');"><img src="/images/bt_newmem.gif" style="vertical-align:middle;border:0"></a>
									 -->
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="alert('지국만 가능합니다.');">신규독자</a></span>&nbsp;
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="alert('지국만 가능합니다.');">저 장</a></span>
									<div style="padding-top: 10px;">
										<!--
										<a href="#fakeUrl" onclick="alert('지국만 가능합니다.');"><img src="/images/bt_add.gif" style="vertical-align:middle;border:0"></a>&nbsp;&nbsp;
										<a href="#fakeUrl" onclick="alert('지국만 가능합니다.');"><img src="/images/news_add.gif" style="vertical-align:middle;border:0"></a>
										 -->
										<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="alert('지국만 가능합니다.');">추가구독</a></span>&nbsp;
										<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="alert('지국만 가능합니다.');">매체추가</a></span>
									</div>
								</c:when>
								<c:otherwise>
									<!--
									<a href="#fakeUrl" onclick="save();"><img src="/images/bt_save.gif" style="vertical-align:middle;border:0"></a>&nbsp;&nbsp;
									<a href="#fakeUrl" onclick="clearField('newReader');"><img src="/images/bt_newmem.gif" style="vertical-align:middle;border:0"></a>
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="alert('해지');" style="color: #ff0000; font-weight: bold;">해 지</a></span>&nbsp;
									-->
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="clearField('newReader');">신규독자</a></span>&nbsp;
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="fn_save();" style="color: blue; font-weight: bold;">저 장</a></span>
									<div style="padding-top: 5px;">
										<!--
										<a href="#fakeUrl" onclick="popExtendReader('qty');"><img src="/images/bt_add.gif" style="vertical-align:middle;border:0"></a>&nbsp;&nbsp;
										<a href="#fakeUrl" onclick="popExtendReader('newsCd');"><img src="/images/news_add.gif" style="vertical-align:middle;border:0"></a>
										 -->
										<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="popExtendReader('qty');">추가구독</a></span>&nbsp;
										<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="popExtendReader('newsCd');">매체추가</a></span>
									</div>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
					<!-- //button -->
				</div>	
				<!-- //구독정보 -->
			</div>
			<!-- //독자정보&구독정보 -->			
			<!-- 월별수금내역 -->
			<div style="width: 400px; border: 0px solid yellow; float: left;">
				<!-- top selector -->
				<div style="float: left;">
					<div style="width: 130px; text-align: center; float: left; overflow: hidden; border: 0px solid red; ">
						<span class="btnCss2"><a href="#fakeUrl" onclick="fn_changSumgList('1');"><img src="/images/ico_prev2.png" alt="이전" style=" vertical-align: middle;" /> <b>이전</b></a></span>
						<span class="btnCss2"><a href="#fakeUrl" onclick="fn_changSumgList('2');"><b>다음</b> <img src="/images/ico_next2.png" alt="다음" style="vertical-align: middle;" /></a></span>
					</div>
				</div>
				<div style="width: 18px; float: left;">&nbsp;</div>
				<div style="float: left; width: 252px; border: 0px solid red;">
					<div style="width: 60px; float: left; border: 0px solid green">
						 <span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="fn_sumgClam('last')" style="font-weight: bold;">작년수금</a></span>
					</div>
					<div class="box_white" style="width: 120px; text-align: center;  float: left; padding: 6px 3px 5px 3px;">
						<span id="sumgClam" style="font-weight: bold; color: blue">------------</span>
						<input type="hidden" id="lastYearSumgClam" name="lastYearSumgClam" value="" />
						<input type="hidden" id="thisYearSumgClam" name="thisYearSumgClam" value="" />
					</div>
					<div style="width: 60px; float: left; border: 0px solid red; text-align: right;">				
						<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="fn_sumgClam('now')" style="font-weight: bold;">금년수금</a></span>		
					</div>
				</div>
				<!-- //top selector -->
				<!-- billing list -->	
				<div style="border: 0px solid red; width: 400px; padding-top: 3px; clear: both;">
					<table class="tb_sugm" style="width: 400px">
						<colgroup>
							<col width="50px">
							<col width="90px">
							<col width="80px">
							<col width="80px">
							<col width="100px">
						</colgroup>
						<tr>
							<th>년월</th>									
							<th>수금일자</th>
							<th><span id="chgColumn">금액</span></th>
							<th>수금액</th>
							<th>방법</th>
						</tr>
					</table>
				<%
						String seq = "";
						for (int i=1; i<13; i++){ 
							seq = "";
							if(i<10) { 
								seq = "0"+i; 
							} else { 
								seq = Integer.toString(i); 
							}
				%>
					<table class="tb_sugm" style="width: 400px">
						<colgroup>
							<col width="50px">
							<col width="90px">
							<col width="80px">
							<col width="80px">
							<col width="100px">
						</colgroup>
						<tr id="pre<%=seq %>" style="display:none;">
							<td onmouseover="detailSugm(preClDt<%=seq%>, preBillAmt<%=seq %>)" onmouseout="closeSugm(preClDt<%=seq %>, preBillAmt<%=seq %>)" style="width: 47px">
								<b><%=(String)request.getAttribute("lastyymm"+seq) %></b>
								<input type="hidden" id="preYear<%=seq %>" name="preYear<%=seq %>" value="<%=(String)request.getAttribute("lastyymm"+seq) %>" />
							</td>
							<td>
								<input type="text" id="preSnDt<%=seq %>" name="preSnDt<%=seq %>" maxlength="8" value="<c:out value='${sdate}' />" readonly="readonly" onclick="Calendar(this)" style="width: 85px;"/>
							</td>
							<td>
								<input type="text" id="preBillAmt<%=seq %>" name="preBillAmt<%=seq %>" style="width: 75px; ime-mode:disabled" onkeypress="inputNumCom();"/>
								<input type="text" id="preClDt<%=seq %>" name="preClDt<%=seq %>" style="width: 75px; display:none; font-weight: bold; color: #ff0011"/>
							</td>
							<td><input type="text" id="preAmt<%=seq %>" name="preAmt<%=seq %>" style="width: 75px; ime-mode:disabled;" onkeypress="inputNumCom();"/></td>
							<td>
								<select name="preSgbbCd<%=seq %>" id="preSgbbCd<%=seq %>" style="width: 95px;">
								</select>
							</td>
						</tr>
					</table>
				<% } //for end 
					
					for (int i=1 ; i< 13 ; i++){ 
						seq = "";
					
						if(i<10) {
							seq = "0"+i;
						} else {
							seq = Integer.toString(i);
						}
				%>
					<table class="tb_sugm" style="width: 400px">
						<colgroup>
							<col width="50px">
							<col width="90px">
							<col width="80px">
							<col width="80px">
							<col width="100px">
						</colgroup>
						<tr id="now<%=seq %>" style="<%if(i==12) {%>background-color: #f48d2e;<%} %>display: block;" >
							<td onmouseover="detailSugm(nowClDt<%=seq%>, nowBillAmt<%=seq %>)" onmouseout="closeSugm(nowClDt<%=seq %>,nowBillAmt<%=seq %>)" style="width: 47px">
								<b><%=(String)request.getAttribute("nowyymm"+seq) %></b>
								<input type="hidden" id="nowYear<%=seq %>" name="nowYear<%=seq %>" value="<%=(String)request.getAttribute("nowyymm"+seq) %>" />
							</td>
							<td >
								<input type="text" id="nowSnDt<%=seq %>" name="nowSnDt<%=seq %>" maxlength="8" value="<c:out value='${sdate}' />" onclick="Calendar(this)" style="width: 85px;" readonly="readonly" />
							</td>
							<td>
								<input type="text" id="nowBillAmt<%=seq %>" name="nowBillAmt<%=seq %>" style="width: 75px; ime-mode:disabled" onkeypress="inputNumCom();"/>
								<input type="text" id="nowClDt<%=seq %>" name="nowClDt<%=seq %>"  style="display:none; width: 75px; font-weight: bold; color: #ff0011"/>
							</td>
							<td><input type="text" id="nowAmt<%=seq %>" name="nowAmt<%=seq %>" style="width: 75px; ime-mode:disabled" onkeypress="inputNumCom();"/></td>
							<td>
								<select name="nowSgbbCd<%=seq %>" id="nowSgbbCd<%=seq %>" style="width: 95px;">
								</select>
							</td>
						</tr>
					</table>
				<% 
					}//for end
				
					for (int i=1 ; i< 13 ; i++){ 
						seq = "";
						if(i<10){
							seq = "0"+i;
						}else{
							seq = Integer.toString(i);
						}
				%>
					<table class="tb_sugm" style="width: 400px">
						<colgroup>
							<col width="50px">
							<col width="90px">
							<col width="80px">
							<col width="80px">
							<col width="100px">
						</colgroup>
						<tr  id="next<%=seq %>" style="display:none;">
							<td onmouseover="detailSugm(nextClDt<%=seq%>, nextBillAmt<%=seq %>)" onmouseout="closeSugm(nextClDt<%=seq %>,nextBillAmt<%=seq %>)" style="width: 47px">
								<b><%=(String)request.getAttribute("nextyymm"+seq) %></b>
								<input type="hidden" id="nextYear<%=seq %>" name="nextYear<%=seq %>" value="<%=(String)request.getAttribute("nextyymm"+seq) %>" />
							</td>
							<td >
								<input type="text" id="nextSnDt<%=seq %>" name="nextSnDt<%=seq %>" maxlength="8" value="<c:out value='${sdate}' />" onclick="Calendar(this)" style="width: 85px;" readonly="readonly" />
							</td>
							<td >
								<input type="text" id="nextBillAmt<%=seq %>" name="nextBillAmt<%=seq %>" style="width: 75px; ime-mode:disabled" onkeypress="inputNumCom();"/>
								<input type="text" id="nextClDt<%=seq %>" name="nextClDt<%=seq %>" style="display:none; width: 75px; font-weight: bold; color: #ff0011"/>
							</td>
							<td><input type="text" id="nextAmt<%=seq %>" name="nextAmt<%=seq %>" style="width: 75px; ime-mode:disabled" onkeypress="inputNumCom();"/></td>
							<td>
								<select name="nextSgbbCd<%=seq %>" id="nextSgbbCd<%=seq %>" style="width: 95px;">
								</select>
							</td>
						</tr>
					</table>
					<% }//for end %>
				</div>
				<!-- //billing list -->
				<!-- bottom -->
				<div style="padding: 4px 0 2px 0; width: 400px;">
					<div class="box_white" style="width: 391px; overflow: hidden; padding: 3px; "> 
						<div style="text-align: center; width: 391px; padding: 1px 3px 0 0;"><div style="background-color: #e5e5e5; font-weight: bold; border: 1px solid #cccccc; padding: 3px 0;">독자 비고</div></div>
						<div style="width: 333px; text-align: left; float: left; padding: 3px 0;"><textarea id="remk" name="remk" style="height:40px; width:328px;" rows="" cols=""></textarea></div>
						<div style="width: 58px; float: left; padding-top: 3px; font-weight: bold; cursor: pointer; vertical-align: bottom;">
							<div style="border: 1px solid #a4a7ac; background-color: #e5e5e5; padding: 6px 0; color: blue" onclick="fn_saveRemk();">비고<br/>저장</div>
							<!-- <span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="fn_saveRemk();">비고저장</a></span>-->
						</div>
					</div>
				</div> 
				<div style="padding-top: 5px; width: 400px;">
					[최근비고이력]
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="#fakeUrl"  id="tagMemoLlist" onclick="fn_memo_view_more('${billingInfo[0].READNO }')">
						<img src="/images/main_title_more.gif" style="vertical-align:middle; border:0" alt="전체리스트" />&nbsp;
					</a>					
				</div>
				<!-- //bottom -->
				<!-- form -->
				<div><textarea id="desc" name="desc" rows="" cols="" readonly="readonly" style="border: 1px solid #c0c0c0; width: 397px; height: 103px"></textarea></div>
				<!-- //form -->
			</div>
		</div>
		<!-- 상세리스트(월별수금내역)-->
		<div style="clear: both; padding-top: 10px; border: 1px solid #e5e5e5; clear: both; width: 1020px; margin: 0 auto; overflow: hidden;">
			<!-- 조회 조건-->
			<div style="padding: 0 5px 5px 5px; overflow: hidden; width: 1010px">
				<div class="box_gray" style="padding: 5px 0; text-align: center;">
   					<select id="searchType" name="searchType" onchange="javascript:changeSearch()" style="vertical-align: middle;">
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
			    	<select name="searchSgType" id="searchSgType" style="display:none; vertical-align: middle;">
						<option value=""></option>
						<c:forEach items="${sgTypeList }" var="list">
							<option value="${list.CODE }" <c:if test="${searchSgType eq list.CODE}">selected</c:if>>${list.CNAME }</option>
						</c:forEach> 
					</select>
					<select name="searchNewsCdType" id="searchNewsCdType" style="display:none; vertical-align: middle;">
						<option value=""></option>
						<c:forEach items="${newSList }" var="list" varStatus="i">
							<option value="${list.CODE }" <c:if test="${searchNewsCdType eq list.CODE}">selected</c:if>>${list.CNAME }</option>
						</c:forEach>
					</select>
			    	<input type="text" id="searchText" name="searchText" value="<c:out value='${param.searchText}'/>" style="width: 350px; vertical-align: middle;" onkeydown="if(event.keyCode == 13){search(); }">&nbsp;&nbsp;
			    	<a href="javascript:search();"><img src="/images/bt_search.gif" style="vertical-align: middle;" /></a>
			    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<c:if test="${empty admin_userid }">
						<a href="javascript:sort();" style="color: blue; font-weight: bold;">배달번호정렬</a>
					</c:if>
				</div>
			</div>
			<!--통합 내용출력자리-->
			<table class="tb_list" style="width: 1010px">
				<colgroup>
					<col width="60px">
					<col width="65px">
					<col width="45px">
					<col width="120px">
					<col width="30px">
					<col width="80px">
					<col width="90px">
					<col width="308px">
					<col width="80px">
					<col width="65px">
					<col width="50px">
					<col width="17px">
				</colgroup>
				<tr>
					<th>구역배달</th>
					<th>독자</th>
					<th>매체명</th>
					<th>독자명</th>
					<th>부수</th>
					<th>전화번호</th>
					<th>핸드폰</th>
					<th>주소</th>
					<th>확장/중지</th>
					<th>총수금</th>
					<th>미수액</th>
					<th></th>
				</tr>
			</table>
			<div style="width: 1010px;  margin: 0 auto; height: 300px; overflow-y: scroll;">
				<table class="tb_list" style="width: 993px;">
					<colgroup>
						<col width="60px">
						<col width="65px">
						<col width="45px">
						<col width="120px">
						<col width="30px">
						<col width="80px">
						<col width="90px">
						<col width="318px">
						<col width="80px">
						<col width="65px">
						<col width="50px">
					</colgroup>
					<c:forEach items="${readerList }" var="list" varStatus="i">
						<tr style="display: none;">
							<td>
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
							<span id="tem_newaddr${i.index}" name="tem_newaddr${i.index}" style="display:none"><c:out value="${list.NEWADDR}"/></span><!--배달지도로명주소-->
							<span id="tem_oldaddr${i.index}" name="tem_oldaddr${i.index}" style="display:none"><c:out value="${list.OLDADDR}"/></span><!--배달지도로명주소-->
							<span id="tem_bdMngNo${i.index}" name="tem_bdMngNo${i.index}" style="display:none"><c:out value="${list.BDMNGNO}"/></span><!--배달지빌딩관리번호-->
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
							</td>
						</tr>
						<c:choose>
						<c:when test="${list.BNO eq '999'}">
							<tr onclick="detailView('${i.index}')" style="cursor:pointer; background-color: #f9f9f9; color: #e74985">
								<td>${list.GNO }-${list.BNO }</td>
								<td>${list.READNO }</td>
								<td>${list.NEWSNM }</td>
								<td style="text-align: left;"><c:out value="${list.READNM }"/></td>
								<td>${list.QTY }</td>
								<td style="text-align: left;">${list.HOMETEL }</td>
								<td style="text-align: left;">${list.MOBILE }</td> 
								<td style="text-align: left;">${list.ADDR }</td>
								<td>${fn:substring(list.STDT,0,4) }-${fn:substring(list.STDT,4,6) }-${fn:substring(list.STDT,6,8) }</td>
								<td><fmt:formatNumber value="${list.SUMCOLLECT }" type="number" /></td>
								<td><fmt:formatNumber value="${list.ACCOUNTDUE }" type="number" /></td>
							</tr>
						</c:when>
						<c:when test="${list.READTYPECD eq '099'}">
							<tr onclick="detailView('${i.index}')" style="cursor:pointer; background-color: #E3E3E3">
								<td>${list.GNO }-${list.BNO }</td>
								<td>${list.READNO }</td>
								<td>${list.NEWSNM }</td>
								<td style="text-align: left;"><c:out value="${list.READNM }"/></td>
								<td>${list.QTY }</td>
								<td style="text-align: left;">${list.HOMETEL }</td>
								<td style="text-align: left;">${list.MOBILE }</td>
								<td style="text-align: left;">${list.ADDR }</td>
								<td>${fn:substring(list.HJDT,0,4) }-${fn:substring(list.HJDT,4,6) }-${fn:substring(list.HJDT,6,8) }</td>
								<td><fmt:formatNumber value="${list.SUMCOLLECT }" type="number" /></td>
								<td><fmt:formatNumber value="${list.ACCOUNTDUE }" type="number" /></td>
							</tr>
						</c:when>
						<c:otherwise>
							<tr  class="mover" onclick="detailView('${i.index}')">
								<td>${list.GNO }-${list.BNO }</td>
								<td>${list.READNO }</td>
								<td>${list.NEWSNM }</td>
								<td style="text-align: left;"><c:out value="${list.READNM }"/></td>
								<td>${list.QTY }</td>
								<td style="text-align: left;">${list.HOMETEL }</td>
								<td style="text-align: left;">${list.MOBILE }</td>
								<td style="text-align: left;">${list.ADDR }</td>
								<td>${fn:substring(list.HJDT,0,4) }-${fn:substring(list.HJDT,4,6) }-${fn:substring(list.HJDT,6,8) }</td>
								<td><fmt:formatNumber value="${list.SUMCOLLECT }" type="number" /></td>
								<td><fmt:formatNumber value="${list.ACCOUNTDUE }" type="number" /></td>
							</tr>
						</c:otherwise>
						</c:choose>
					</c:forEach>
				</table>
			</div>
			<div style="padding: 0;" ><%@ include file="/common/paging.jsp"%></div>
		<!-- //리스트 -->
	</div>
	<!-- //상세리스트 -->
</form>


