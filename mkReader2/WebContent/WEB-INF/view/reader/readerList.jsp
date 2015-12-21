<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mkreader.security.*" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<% String agency_userid = (String)session.getAttribute(ISiteConstant.SESSION_NAME_AGENCY_USERID); %>
<script type="text/javascript" src="/js/mini_calendar2.js"></script>
<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="/js/ajaxUtil.js"></script>
<script type="text/javascript" src="/js/common.js"></script> 
<script type="text/javascript">
jQuery.noConflict();
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

//  자세히 보기, 독자 수금정보 조회(ajax)
function detailView(readNo, newsCd, seq, boSeq) {
	var fm = document.getElementById("readerListForm");
	var totAddr = "";
	clearField();
	fm.desc.value="";
	
	//독자정보조회
	jQuery.ajax({
		type 		: "POST",
		url 		: "/reader/readerManage/ajaxSelectReaderData.do",
		dataType 	: "json",
		data		: "readNo="+readNo+"&boSeq="+boSeq+"&seq="+seq+"&newsCd="+newsCd,
		success:function(data){
			var result = data.readerData;
			
			fm.boSeq.value = result.BOSEQ;
			fm.seq.value = result.SEQ;
			fm.readNo.value = result.READNO;
			fm.gnoNm.value = result.GNO+"구역";
			fm.gno.value = result.GNO;
			fm.bno.value = result.BNO;
			fm.sno.value = result.SNO;
			fm.readNm.value = result.READNM;
			fm.homeTel1.value = result.HOMETEL1;
			fm.homeTel2.value = result.HOMETEL2; 
			fm.homeTel3.value = result.HOMETEL3;
			fm.mobile1.value = result.MOBILE1;
			fm.mobile2.value = result.MOBILE2;
			fm.mobile3.value = result.MOBILE3;
			fm.eMail.value = result.EMAIL;
			fm.dlvZip.value = result.DLVZIP;
											
			if(result.NEWADDR.length < 1) {
				totAddr = result.DLVADRS1;
			} else {
				totAddr = result.NEWADDR+" <b>("+result.DLVADRS1+")</b>";
			}
			document.getElementById("allAddr").innerHTML = "&nbsp;"+totAddr;
			
			fm.dlvAdrs1.value = result.DLVADRS1;
			fm.dlvAdrs2.value = result.DLVADRS2;
			fm.newaddr.value = result.NEWADDR;
			fm.bdMngNo.value = result.BDMNGNO;
			fm.rsdTypeCd.value = result.RSDTYPECD;
			fm.taskCd.value = result.TASKCD;
			fm.intFldCd.value = result.INTFLDCD;  
			fm.newsCd.value = result.NEWSCD;
			fm.oldNewsCd.value = result.NEWSCD;
			fm.oldGno.value = result.GNO;
			if(result.RECEIPT == 'N'){
				jQuery("#receipt").attr("checked",true);			
			}else{
				jQuery("#receipt").attr("checked",false);
			}
			fm.hjDt.value = result.HJDT;
			fm.hjDt2.value = result.APLCDT;
			fm.readTypeCd.value =  result.READTYPECD;
			fm.oldReadTypeCd.value =  result.READTYPECD;
			fm.qty.value =  result.QTY;
			if(result.QTY != result.SUMQTY) {
				fm.sumQty.value =  result.SUMQTY;
			} else {
				fm.sumQty.value =  "";
			}
			fm.oldQty.value =  result.QTY;
			fm.uPrice.value =  result.UPRICE;
			fm.oldUprice.value =  result.UPRICE;
			if(result.UPRICE != result.SUMUPRICE) {
				fm.sumUprice.value = result.SUMUPRICE;
			} else {
				fm.sumUprice.value =  "";
			}
			fm.dlvTypeCd.value =  result.DLVTYPECD;
			fm.spgCd.value =  result.SPGCD;
			fm.dlvPosiCd.value =  result.DLVPOSICD;
			fm.sgType.value =  result.SGTYPE;
			fm.oldSgType.value =  result.SGTYPE;
			fm.bnsBookCd.value =  result.BNSBOOKCD;
			fm.orgChgDt.value =  result.ORGCHGDT;
			fm.spRemk.value = result.REMK;
			fm.desc.value = "";
			fm.stSayou.value = jQuery.trim(result.STSAYOU);
			fm.oldStSayou.value = jQuery.trim(result.STSAYOU);
			fm.sgCycle.value = result.SGCYCLE;
			fm.oldSgCycle.value = result.SGCYCLE;
			fm.term.value = result.TERM+"개월";
			fm.boReadNo.value = result.BOREADNO;
			document.getElementById('callLog').innerHTML = "<a href=\"javascript:callLog();\">"+ result.CALLLOG+' 건' +"</a>";
			fm.oldStdt.value = jQuery.trim(result.STDT);
			fm.stdt.value = jQuery.trim(result.STDT);	
	 		fm.sgBgmm.value = result.SGBGMM;
			fm.hjPathCd.value = result.HJPATHCD;
			jQuery("#hjPsnm").append("<option value='"+result.HJPSNM+"'>"+result.HJPSNM+"</option>");
			jQuery("#hjPsregCd").append("<option value='"+result.HJPSREGCD+"'>"+result.HJPSREGCD+"</option>");
		},
		error    : function(r) { alert("독자정보조회 에러"); }
	}); //ajax end
	
	for(var i = 1 ; i < 13 ; i++ ){
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
	
	//수금리스트 조회
	var url = "/collection/collection/ajaxCollectionList_org.do?seq="+seq+"&readNo="+readNo+"&newsCd="+newsCd+"&boSeq="+boSeq;
	sendAjaxRequest(url, "readerListForm", "post", collectionList);
	
	//메모리스트 조회
	jQuery.ajax({
		type 		: "POST",
		url 		: "/util/memo/getAjaxMemoOfRecently.do",
		dataType 	: "json",
		data		: "readNo="+readNo,
		success:function(data){
			var jsonObjArr = data.memoList;
			
			var div_head = document.createElement("div");
			var div_note = document.createElement("div");
			if (jsonObjArr.length > 0) {
				for(var j=0 ; j < 1 ; j++){
					div_note = document.createElement("div");//font-weight: bold;
					div_head = document.createElement("div");
					div_note.onclick = function() {fn_insert_note(jsonObjArr[j].MEMO);};
					div_head.style.cssText = "font-weight: bold; padding: 3px 0 0 3px";
					div_head.innerText = "["+jsonObjArr[j].CREATE_ID+"] "+jsonObjArr[j].CREATE_DATE;
					div_note.innerText = jsonObjArr[j].MEMO;
					jQuery("#desc").append(div_head);
					jQuery("#desc").append(div_note);
					document.getElementById("remk").value = jsonObjArr[0].MEMO;
				}
			}else{
				div = document.createElement("div");
				div.innerText = "기록이 없습니다.";
				jQuery("desc").append(div);
			}
		},
		error    : function(r) { alert("독자메모조회 에러"); }
	}); //ajax end
	
	//메모 더보기 클릭이벤트 설정
	document.getElementById("tagMemoLlist").onclick = function(){fn_memo_view_more(readNo);};
	
	//정보수정
	fm.flag.value = "UPT";
	return;
}
	
/**
 *	비고저장 버튼 클릭 이벤트
 **/
function fn_saveRemk() {
	var fm = document.getElementById("readerListForm");
	
	//독자번호가 없을시
	if(!cf_checkNull("readNo", "독자")){return false;};
	if(!cf_checkNull("remk", "비고")){return false;};
		
	//글자수 제한
	if(cf_getValue("remk").length > 200) {
		alert("비고내용은 200자를 넘을 수 없습니다.");
		return false;
	}
	
	if(!confirm("비고를 저장하시겠습니까?")) {return false;}
	
	fm.target = "_self";
	fm.action = "/util/memo/saveMemoContents.do";
	fm.submit();
}

//신청경로 변경(확장자도 같이 변경해줘야함.)
function fn_changeHjPath(hjPathCd){
	if(hjPathCd =='005' || hjPathCd =='006' || hjPathCd =='007' || hjPathCd =='011'){
		jQuery.ajax({
			type 		: "POST",
			url 		: "/reader/readerManage/ajaxHjPsNmListForJquery.do",
			dataType 	: "json",
			data		: "hjPathCd="+hjPathCd+"&boSeq="+jQuery("#agencyid").val(),
			success:function(data){
				jQuery("#hjPsnm").empty();
				jQuery("#hjPsregCd").empty();
				for(var i=0;i<data.hjPsNmList.length;i++) {
					jQuery("#hjPsnm").append("<option value='"+data.hjPsNmList[i].HJPSNM+"'>"+data.hjPsNmList[i].HJPSNM+"</option>");
					jQuery("#hjPsregCd").append("<option value='"+data.hjPsNmList[i].HJPSREGCD+"'>"+data.hjPsNmList[i].HJPSREGCD+"</option>");
				}
			},
			error    : function(r) { alert("ajax error"); }
		}); //ajax end
	}else{
		jQuery("#hjPsnm").empty();
		jQuery("#hjPsregCd").empty();
	}
}

//확장자 변경(확장자코드도 같이 변경해줘야함.)
function sethjPregCd(){
	var selIdx=jQuery("#hjPsnm option").index(jQuery("#hjPsnm option:selected"));
	jQuery("#hjPsregCd option:eq("+selIdx+")").attr("selected", "selected");
}

//민원 처리  불배, 휴독 , 해지 팝업 오픈
function winPop(url) {
	var fm = document.getElementById("readerListForm");
	
	var actUrl = "/reader/minwon/popMinwon.do";
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
	fm.minGb.value = url;
	fm.target = "pop_minwon";
	fm.action = actUrl;
	fm.submit();
}

//페이징 펑션
function moveTo(where, seq) {
	var fm = document.getElementById("readerListForm");
	var url = "";
	
	if(cf_getValue("searchText")  != '' || cf_getValue("searchSgType") != '' || cf_getValue("searchNewsCdType") != ''){
		url = "/reader/readerManage/searchReader.do";
	}else{
		url =  "/reader/readerManage/readerList.do";
	}
	
	fm.target = "_self";
	fm.pageNo.value = seq;
	fm.action = "/reader/readerManage/searchReader.do";
	fm.submit();
}

//신규독자 버튼 클릭시 필드 초기화
function clearField(chkFlag){
	var fm = document.getElementById("readerListForm");
	
	if(cf_getValue("searchType") == '8'){
		document.getElementById("searchSgType").style.display  = 'inline';
		document.getElementById("searchNewsCdType").style.display  = 'none';
		document.getElementById("searchText").readonly = true;
		document.getElementById("searchText").style.backgroundColor = "#EAEAEA";
	}else if(cf_getValue("searchType") == '9'){
		document.getElementById("searchNewsCdType").style.display  = 'inline';
		document.getElementById("searchSgType").style.display  = 'none';
		document.getElementById("searchText").value='';
		document.getElementById("searchText").readonly = true;
		document.getElementById("searchText").style.backgroundColor = "#EAEAEA";
	}else{
		document.getElementById("searchSgType").style.display  = 'none';
		document.getElementById("searchNewsCdType").style.display  = 'none';
		document.getElementById("searchText").readonly = false;
		document.getElementById("searchText").style.backgroundColor = "";
	}
	//독자 정보 클리어
	document.getElementById("seq").value = '0001';
	document.getElementById("readNo").value = '';
	document.getElementById("gnoNm").value = '';
	document.getElementById("bno").value = '';
	document.getElementById("sno").value = '';
	document.getElementById("readNm").value = '';
	document.getElementById("bidt").value = '';
	document.getElementById("homeTel1").value = '02';
	document.getElementById("homeTel2").value = '';
	document.getElementById("homeTel3").value = '';
	document.getElementById("mobile1").value = '010';
	document.getElementById("mobile2").value = '';
	document.getElementById("mobile3").value = '';
	document.getElementById("eMail").value = '';
	document.getElementById("dlvZip").value = '';
	document.getElementById("dlvAdrs1").value = '';
	document.getElementById("dlvAdrs2").value = '';
	//document.getElementById("oldAddr").innerHTML = ""
	//document.getElementById("allAddr").innerHTML = "";
	document.getElementById("rsdTypeCd").value = '';
	document.getElementById("hjPathCd").value = '';
	document.getElementById("taskCd").value = '';
	document.getElementById("intFldCd").value = '';  
	document.getElementById("newsCd").value = '100';
	document.getElementById("oldNewsCd").value = '100';
	document.getElementById("oldGno").value = '';
	
	// 신규독자 버튼 클릭시에만 검색값 초기화
	if( chkFlag == "newReader"){
		document.getElementById("searchText").value = '';
	}
	
	document.getElementById('callLog').innerHTML =  "<a href=\"javascript:callLog();\">"+'0 건' +"</a>";
	document.getElementById("receipt").checked = false;
	var currentTime = new Date();
	var year = currentTime.getFullYear();
	var month = currentTime.getMonth() + 1;
	if (month < 10) month = "0" + month;
	var day = currentTime.getDate();
	if (day < 10) day = "0" + day;
	document.getElementById("hjDt").value = year + '-' + month + '-' + day; // 확장일자
	document.getElementById("hjDt2").value = year + '-' + month + '-' + day; // 구독일자
	document.getElementById("readTypeCd").value = '011';
	document.getElementById("oldReadTypeCd").value = '';
	document.getElementById("stQty").value = '';
	document.getElementById("qty").value = '1';
	document.getElementById("sumQty").value = '';
	document.getElementById("oldQty").value = '';
	document.getElementById("oldStSayou").value = '';
	document.getElementById("uPrice").value = '15000';
	document.getElementById("oldUprice").value = '';
	document.getElementById("sumUprice").value = '';
	document.getElementById("dlvTypeCd").value = '';
	document.getElementById("spgCd").value = '';
	document.getElementById("oldSgType").value = '';
	document.getElementById("dlvPosiCd").value = '';
	document.getElementById("sgType").value = '011';
	document.getElementById("bnsBookCd").value = '';
	//document.getElementById("aptCd").value = '';
	//document.getElementById("aptNm").value = '';
	document.getElementById("remk").value = '';
	document.getElementById("stSayou").value = '';
	document.getElementById("term").value = '';
	jQuery("#hjPsnm").empty();
	jQuery("#hjPsregCd").empty();
	document.getElementById("sgBgmm").value = '';
	document.getElementById("stdt").value = '';
	document.getElementById("oldStdt").value = '';
	document.getElementById("stSayou").value = '';
	document.getElementById("sgCycle").value = '1';
	document.getElementById("oldSgCycle").value = '';
	//document.getElementById("desc").value ="";
	
	//수금 정보 클리어
	for(var j=1 ; j < 13 ; j++){
		if(j < 10){ seq ='0'+j; }else{ seq = j; }
		 document.getElementById("preSnDt"+seq).value = '';
		 document.getElementById("preBillAmt"+seq).value = '';
		 document.getElementById("preAmt"+seq).value = '';
		 document.getElementById("preSgbbCd"+seq).value = '';
		 document.getElementById("nowSnDt"+seq).value = '';
		 document.getElementById("nowBillAmt"+seq).value = '';
		 document.getElementById("nowAmt"+seq).value = '';
		 document.getElementById("nowSgbbCd"+seq).value = '';
		 document.getElementById("nextSnDt"+seq).value = '';
		 document.getElementById("nextBillAmt"+seq).value = '';
		 document.getElementById("nextAmt"+seq).value = '';
		 document.getElementById("nextSgbbCd"+seq).value = '';
		 document.getElementById("sumgClam").innerHTML = '------------';
	}
	//신규등록
	fm.flag.value = "INS";
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
	var fm = document.getElementById("readerListForm");
	
	if(cf_getValue("readNo") == ''){
		alert('독자를 선택해 주세요.');
		return;
	}
	var left = (screen.width)?(screen.width - 830)/2 : 10;
	var top = (screen.height)?(screen.height - 600)/2 : 10;
	var winStyle = "width=400,height=500,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
	var newWin = window.open("", "call_log", winStyle);
	
	fm.target = "call_log";
	fm.action = "/reader/readerManage/popRetrieveCallLog.do";
	fm.submit();
}

//독자 검색
function fn_search(){
	var fm = document.getElementById("readerListForm");
	
	if(cf_getValue("searchType") == '8'){
		if(!cf_checkNull("searchSgType", "수금방법")){return false;};
	}else if(cf_getValue("searchType") == '9'){
		if(!cf_checkNull("searchNewsCdType", "신문명")){return false;};
	}else{
		if(!cf_checkNull("searchText", "검색어")){return false;};
		
		if(cf_getValue("searchType")  == '1' ||  cf_getValue("searchType")  == '2' || cf_getValue("searchType") == '3' || cf_getValue("searchType") == '6'){
			if(!isNumber(cf_getValue("searchText"))){
				alert('숫자만 가능합니다.');
				cf_mvFocus("searchText");
				return;
			}
		}
	}
	fm.pageNo.value = "1";
	fm.action="/reader/readerManage/searchReader.do";
	fm.target="_self";
	fm.submit();
	jQuery("#prcssDiv").show();
}

//추가 구독 팝업 오픈
function popExtendReader(gbn){
	var fm = document.getElementById("readerListForm");
	
	if(!cf_checkNull("readNo", "독자")){return false;};

	if( cf_getValue("stdt") != '' || cf_getValue("stSayou") != ''){
		alert("중지독자는 확장, 매체추가가 불가합니다.");
		return;
	}
	if(cf_getValue("oldReadTypeCd") == '016'){
		alert("본사 독자는 확장, 매체추가가 불가합니다.");
		return;
	}
	if(cf_getValue("oldReadTypeCd") == '017'){
		alert("소외계층 독자는 확장, 매체추가가 불가합니다.");
		return;
	}
	//팝업 오픈
	var left = (screen.width)?(screen.width - 1330)/2 : 10;
	var top = (screen.height)?(screen.height - 200)/2 : 10;
	var winStyle = "width=300,height=300,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
	var newWin = window.open("", "qty_extend", winStyle);
	newWin.focus();
	fm.target = "qty_extend";
	fm.action = "/reader/readerManage/popExtendReader.do?gbn="+gbn;
	fm.submit();
}

//추가 구독
function extendReader(){
	var fm = document.getElementById("readerListForm");
	fm.target = "_self";
	fm.action = "/reader/readerManage/extendReader.do";
	fm.submit();
}
	
//숫자만 입력 가능하도록 체크 입력값 검증
function isNumber(str) {
	if(str.length == 0) { return true; }
	for(var i=0; i < str.length; i++) {
		if(!('0' <= str.charAt(i) && str.charAt(i) <= '9')){ return false; }
	}
	return true;
}

//관리자 지국 선택..
function changeAgency(){
	var fm = document.getElementById("readerListForm");
	
	if(cf_getValue("agencySearch") != ''){
		<c:forEach items="${agencyList }" var="list">
			if('${list.NAME}' == agencySearch){
				fm.agency.value = '${list.SERIAL}';
			}
		</c:forEach>
	}
	fm.acion="/reader/readerManage/readerList.do";
	fm.target="_self";
	fm.submit();	
}

//구독부수 조정시 단가 계산 펑션
function controlPrice(){
	document.getElementById("uPrice").value = cf_getValue("qty") * 15000;
}

//검색 조건 변경
function changeSearch(searchTypeVal){
	if(searchTypeVal == '8') {
		document.getElementById("searchSgType").style.display  = 'inline';
		document.getElementById("searchNewsCdType").style.display  = 'none';
		document.getElementById("searchText").readOnly = true;
		document.getElementById("searchText").style.backgroundColor = "#EAEAEA";
	} else if(searchTypeVal == '9') {
		document.getElementById("searchNewsCdType").style.display  = 'inline';
		document.getElementById("searchSgType").style.display  = 'none';
		document.getElementById("searchText").value='';
		document.getElementById("searchText").readOnly = true;
		document.getElementById("searchText").style.backgroundColor = "#EAEAEA";
	} else {
		document.getElementById("searchSgType").style.display  = 'none';
		document.getElementById("searchNewsCdType").style.display  = 'none';
		document.getElementById("searchText").readOnly = false;
		document.getElementById("searchText").style.backgroundColor = "";
	}
}

//배달 번호 정렬
function sort(){
	var fm = document.getElementById("readerListForm");
	
	if(!confirm('배달번호를 정렬하시겠습니까?')){return;}
	
	fm.action="/reader/readerManage/deliveryNumSort.do";
	fm.target="_self";
	fm.submit();
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

//작년 수금 금년 수금 리스트 변경 컨트롤
function fn_changSumgList(gbn){
	if (gbn == '1') {
		if(document.getElementById("pre01").style.display == 'block'){
			return;
		}else if(document.getElementById("now01").style.display == 'block'){
			for(var  i = 1 ; i < 13 ; i++ ){
				if(i<10){ i = '0'+ i; }
				document.getElementById("pre"+i).style.display  = 'block';
				document.getElementById("now"+i).style.display  = 'none';
			}
			return;
		}else if(document.getElementById("next01").style.display == 'block'){
			for(var  i = 1 ; i < 13 ; i++ ){
				if(i<10){ i = '0'+ i; }
				document.getElementById("now"+i).style.display  = 'block';
				document.getElementById("next"+i).style.display  = 'none';
			}
		}
		return;
	}
	if (gbn == '2') {
		if(document.getElementById("pre01").style.display == 'block'){
			for(var  i = 1 ; i < 13 ; i++ ){
				if(i<10){ i = '0'+ i; }
				document.getElementById("now"+i).style.display  = 'block';
				document.getElementById("pre"+i).style.display  = 'none';
			}
			return;
		}else if(document.getElementById("now01").style.display == 'block'){
			for(var i = 1 ; i < 13 ; i++ ){
				if(i<10){ i = '0'+ i; }
				document.getElementById("next"+i).style.display  = 'block';
				document.getElementById("now"+i).style.display  = 'none';
			}
		}
		return;
	}
}

//작년 금년 수금
function fn_sumgClam(gbn){
	if(gbn == 'last'){
		document.getElementById("sumgClam").innerHTML = cf_getValue("lastYearSumgClam");	
	}else{
		document.getElementById("sumgClam").innerHTML = cf_getValue("thisYearSumgClam");	
	}
}

//수금정보 셋팅 펑션
function collectionList(responseHttpObj) {
	if (responseHttpObj) {
		try {
			var result = eval("(" + responseHttpObj.responseText + ")");
			if (result) { setCollectionList(result); }
		} catch (e) {
			alert("오류 : " + e);
		}
	}
}

/**
 * 수금정보설정
 */
function setCollectionList(jsonObjArr) {
	var fm = document.getElementById("readerListForm");
	var nowYear = '${nowyymm12}'; //현재 사용월분
	var deadLineDt = nowYear+"20";
	
	//초기화
	for(var j=1 ; j < 13 ; j++){
		if(j < 10){ seq ='0'+j; }else{ seq = j; }
		
		document.getElementById("preBillAmt"+seq).readOnly = false;
		document.getElementById("preAmt"+seq).readOnly = false;
		document.getElementById("preSgbbCd"+seq).options.length = 0;
		document.getElementById("nowBillAmt"+seq).readOnly = false;
		document.getElementById("nowAmt"+seq).readOnly = false;
		document.getElementById("nowSgbbCd"+seq).options.length = 0;

		<c:forEach items="${sgTypeList }" var="list" varStatus="i">
			document.getElementById("preSgbbCd"+seq).options[${i.index+1}] = new Option('${list.CNAME }' , '${list.CODE }' );
			document.getElementById("nowSgbbCd"+seq).options[${i.index+1}] = new Option('${list.CNAME }' , '${list.CODE }' );
			document.getElementById("nextSgbbCd"+seq).options[${i.index+1}] = new Option('${list.CNAME }' , '${list.CODE }' );
		</c:forEach>
	}
		
	//셋팅
	if (jsonObjArr.length > 0) {
		for(var j=1 ; j < 13 ; j++){
			if(j < 10){ seq ='0'+j; }else{ seq = j; }
				
			for ( var i = 0; i < jsonObjArr.length- 2; i++) {
				if(cf_getValue("preYear"+seq)  ==  jsonObjArr[i].YYMM ){//데이터 존재
					document.getElementById("preSnDt"+seq).value = jsonObjArr[i].SNDT;
					document.getElementById("preBillAmt"+seq).value = jsonObjArr[i].BILLAMT;
					document.getElementById("preAmt"+seq).value = jsonObjArr[i].AMT;
					document.getElementById("preClDt"+seq).value = jsonObjArr[i].CLDT;

					if(jsonObjArr[i].SGBBCD != '044'){
						if( cf_getValue("preClDt"+seq) < Number(deadLineDt)){
							document.getElementById("preSgbbCd"+seq).options.length = 0;
							document.getElementById("preSgbbCd"+seq).options[0] = new Option(jsonObjArr[i].SGBBNM , jsonObjArr[i].SGBBCD );
						// 처리일이 마감일보다 큰경우 수정가능 (2012.06.14 박윤철)
						}else{
							document.getElementById("preSgbbCd"+seq).value = jsonObjArr[i].SGBBCD;
						}
					}else{
						document.getElementById("preSgbbCd"+seq).value = jsonObjArr[i].SGBBCD;
					}
					document.getElementById("preSgbbCd"+seq).value = jsonObjArr[i].SGBBCD;
				}
				
				if(cf_getValue("nowYear"+seq)  ==  jsonObjArr[i].YYMM ){
					document.getElementById("nowSnDt"+seq).value = jsonObjArr[i].SNDT;
					document.getElementById("nowBillAmt"+seq).value = jsonObjArr[i].BILLAMT;
					document.getElementById("nowAmt"+seq).value = jsonObjArr[i].AMT;
					document.getElementById("nowClDt"+seq).value = jsonObjArr[i].CLDT;
					
					if( Number(cf_getValue("nowYear"+seq)) < Number(nowYear)  ){
						if(jsonObjArr[i].SGBBCD != '044'){
							if( cf_getValue("nowClDt"+seq) < Number(deadLineDt)){
								document.getElementById("nowSgbbCd"+seq).options.length = 0;
								document.getElementById("nowSgbbCd"+seq).options[0] = new Option(jsonObjArr[i].SGBBNM , jsonObjArr[i].SGBBCD );
							// 처리일이 마감일보다 큰경우 수정가능 (2012.06.14 박윤철)
							}else{
								document.getElementById("nowSgbbCd"+seq).value = jsonObjArr[i].SGBBCD;
							}
						}else{
							document.getElementById("nowSgbbCd"+seq).value = jsonObjArr[i].SGBBCD;
						}	
					}else{
						document.getElementById("nowSgbbCd"+seq).value = jsonObjArr[i].SGBBCD;
					}
					document.getElementById("nowSgbbCd"+seq).value = jsonObjArr[i].SGBBCD;
				}	
				if(cf_getValue("nextYear"+seq)  ==  jsonObjArr[i].YYMM ){
					document.getElementById("nextSnDt"+seq).value = jsonObjArr[i].SNDT;
					document.getElementById("nextBillAmt"+seq).value = jsonObjArr[i].BILLAMT;
					document.getElementById("nextAmt"+seq).value = jsonObjArr[i].AMT;
					document.getElementById("nextSgbbCd"+seq).value = jsonObjArr[i].SGBBCD;
					document.getElementById("nextClDt"+seq).value = jsonObjArr[i].CLDT;
				}
			}
		} 
		
		for ( var i = 0; i < jsonObjArr.length; i++) {
			if (i == jsonObjArr.length - 2) {
				document.getElementById("sumgClam").innerHTML = jsonObjArr[i].thisYear;
				document.getElementById("thisYearSumgClam").value = jsonObjArr[i].thisYear;
			}
			if (i == jsonObjArr.length - 1) {
				document.getElementById("lastYearSumgClam").value = jsonObjArr[i].lastYear;
			}
		}
	}
	//현재월부터 이후는 수정가능
	//현재월 은 미수만 가능
	for(var j=1 ; j < 13 ; j++){
		if(j < 10){ seq ='0'+j; }else{ seq = j; }
		
		if(cf_getValue("preSgbbCd"+seq) == ''){
			document.getElementById("preSnDt"+seq).readOnly = true;
			document.getElementById("preBillAmt"+seq).readOnly = true;
			document.getElementById("preAmt"+seq).readOnly = true;
			document.getElementById("preSgbbCd"+seq).options.length = 0;
		}else{
			if(cf_getValue("preSgbbCd"+seq) != '044'){
				// 처리일이 마감일보다 큰경우 수정가능 (2012.06.14 박윤철)
				if(cf_getValue("preClDt"+seq) < Number(deadLineDt)){
					document.getElementById("preBillAmt"+seq).readOnly = true;
					document.getElementById("preAmt"+seq).readOnly = true;
				}
			}
		}
		if( Number(cf_getValue("nowYear"+seq)) < Number(nowYear)  ){
			if(cf_getValue("nowSgbbCd"+seq) == ''){
				document.getElementById("nowSnDt"+seq).readOnly = true;
				document.getElementById("nowBillAmt"+seq).readOnly = true;
				document.getElementById("nowAmt"+seq).readOnly = true;
				document.getElementById("nowSgbbCd"+seq).options.length = 0;
			}else{
				if(cf_getValue("nowSgbbCd"+seq) != '044'){
					// 처리일이 마감일보다 큰경우 수정가능 (2012.06.14 박윤철)
					if(cf_getValue("nowClDt"+seq) < Number(deadLineDt)){
						document.getElementById("nowSnDt"+seq).readOnly = true;
						document.getElementById("nowBillAmt"+seq).readOnly = true;
						document.getElementById("nowAmt"+seq).readOnly = true;
					}
				}
			}
		}
	}
}
	
//독자정보 생성,수정
function fn_save() {
	var fm = document.getElementById("readerListForm");
	var flag = document.getElementById("flag").value;
	var url = "";
	var newsCd = document.getElementById("newsCd").value;
	var readNo = document.getElementById("readNo").value;
	var seq = document.getElementById("seq").value;
	var boSeq = document.getElementById("boSeq").value;
	var bno = document.getElementById("bno").value;
	var orgChgDt = document.getElementById("orgChgDt").value;
	var oldGno = document.getElementById("oldGno").value; 
	var dataChgYn = "";
	
	//수정시에만
	if("UPT" == flag) {
		//수정된 이력이 있는지 확인
		jQuery.ajax({
			type 		: "POST",
			url 		: "/reader/readerManage/ajaxCheckStopReaderYN.do",
			dataType 	: "json",
			async 		: false,
			data		: "newsCd="+newsCd+"&readNo="+readNo+"&seq="+seq+"&boSeq="+boSeq,
			success:function(data){
				if(data.chgDt != null && data.chgDt != orgChgDt) {
					dataChgYn = "Y";
					alert("독자 정보가 수정된 이력이 있습니다. 정보를 새로 가져옵니다.");
				} else {
					dataChgYn = "N";
				}
			},
			error    : function(r) { alert("ajax error"); }
		}); //ajax end
		
		if("Y" == dataChgYn) {
			jQuery("#prcssDiv").show();
			location.href = "/reader/readerManage/readerList.do";
			return false; 
		};
	}
	
	if(!cf_checkNull("readNm", "독자명")) { return false; }
	
	//해지가 아닐때만 지역,구역번호 입력
	if( (cf_getValue("stdt") == '' && cf_getValue("stSayou") == '')  && cf_getValue("gno") == '' ) {
		if(oldGno == '200' || oldGno == '300' || oldGno == '400' || oldGno == '500'){
			document.getElementById("gno").options[document.getElementById("gno").length] = new Option(oldGno,oldGno);
			fm.gno.value = oldGno;
		}else{
			if(!cf_checkNull("gno", "구역번호")) { return false; }
		}
	}
	// 구역번호 변경전에 해지 불가( 2012.07.11 박윤철)
	if(oldGno == "200" || oldGno == "300"  || oldGno == "400" || oldGno == "500" || oldGno == "600"){
		if(cf_getValue("oldStdt") == "" && cf_getValue("oldStSayou") == ""){
			if(cf_getValue("stdt") != "" || cf_getValue("stSayou") != ""){
				alert('본사 등록 독자 입니다. \n구역 조정 후 관리해 주세요.');
				fm.stdt.value = "" ;
				fm.stSayou.value = "" ;
				return;
			}
		}
	}
	
	// 교육용 독자 지국 중지 불가( 2013.01.30 박윤철)
	// 교육용지국인 경우 중지 가능( 2013.07.16 박윤철)
	if(cf_getValue("agencyid") != '521050' && cf_getValue("oldReadTypeCd") == '015'){
		if(cf_getValue("oldStdt") == "" && cf_getValue("oldStSayou") == ""){
			if(cf_getValue("stdt") != "" || cf_getValue("stSayou") != ""){
				alert('교육용독자 입니다. \n교육용 해지는 본사 담당자(02-2000-2027)에게 연락해 주세요.');
				fm.stdt.value = "" ;
				fm.stSayou.value = "" ;
				return;
			}
		}
	}

	if((cf_getValue("stdt") == '' && cf_getValue("stSayou") == '') && cf_getValue("bno") == ''){
		if(!cf_checkNull("bno", "배달번호")) { return false; }
	}
	
	if(!cf_checkNull("dlvZip", "우편번호")) { return false; }	
	if(!cf_checkNull("dlvAdrs1", "주소")) { return false; }
	//if(!cf_checkNull("dlvAdrs2", "상세주소")) { return false; }
	if(!cf_checkNull("newsCd", "신문명")) { return false; }

	if(cf_getValue("sgBgmm") != '' && cf_getValue("sgBgmm").length < 6){
		alert('유가년월을 정확히 입력해 주세요.\nex)201202');
		cf_mvFocus("sgBgmm");
		return;
	}else{
		if(cf_getValue("sgBgmm").indexOf('-') >-1 ){
			var tem = cf_getValue("sgBgmm").split('-');
			if(Number(tem[1]) < 1 || Number(tem[1]) > 12){
				alert('유가년월을 정확히 입력해 주세요.\nex)201202');
				cf_mvFocus("sgBgmm");
				return;
			}else{
				if(tem[1].length == 1){
					tem[1] = '0' + tem[1];
				}
				fm.sgBgmm.value = tem[0] + tem[1];
			}
		}else{
			var tem = cf_getValue("sgBgmm").substr(4,6);
			if(Number(tem) < 1 || Number(tem) > 12){
				alert('유가년월을 정확히 입력해 주세요.\nex)201202');
				cf_mvFocus("sgBgmm");
				return;
			}else{
				fm.sgBgmm.value = cf_getValue("sgBgmm").substr(0,4) + tem;
			}
		}
	}
	
	if(!cf_checkNull("sgType", "수금 방법")) { return false; }

	if(cf_getValue("remk").length > 300){
		alert("독자비고는 300byte를 초과할수 없습니다.");
		cf_mvFocus("remk");
		return;
	}
	
	if(!cf_checkNull("qty", "구독부수")) { return false; }
	if(!cf_checkNull("uPrice", "단가")) { return false; }

	if(cf_getValue("bno") == '999'){
		if(!cf_checkNull("stdt", "해지일자")) { return false; }
		if(!cf_checkNull("stSayou", "해지사유")) { return false; }
	}
	
	if(cf_getValue("stdt") != '' && cf_getValue("stSayou") == ''){
		if(!cf_checkNull("stSayou", "해지사유")) { return false; }
	}
	
	if( cf_getValue("stSayou") != '' && cf_getValue("stdt") == ''){
		if(!cf_checkNull("stdt", "해지일자")) { return false; }
	}
	
	//지로용비고 값 가져오기
	if(cf_getValue("spRemk").length > 100) {
		alert("지로용 비고는 100자까지 입력이 가능합니다.");
		cf_mvFocus("spRemk");
		return false;
	}
	
	// 교육용 독자 벨리데이션 추가(박윤철)
	if(cf_getValue("readTypeCd") =='015' && cf_getValue("oldReadTypeCd") == '' && cf_getValue("agencyid") != '521050'){
		alert('교육용 독자 등록은 본사만 가능합니다.');
		return;
	}
	if(cf_getValue("readTypeCd") =='016' && cf_getValue("oldReadTypeCd") == '' && cf_getValue("agencyid") != '521050'){
		alert('본사 직원 독자 등록은 본사만 가능합니다.');
		return;
	}
	if(cf_getValue("readTypeCd") =='017' && cf_getValue("oldReadTypeCd") == '' ){
		alert('소외계층 독자 등록은 본사만 가능합니다.');
		return;
	}
	if(cf_getValue("readNo") == '' && (cf_getValue("readTypeCd") !='021' && cf_getValue("readTypeCd") !='022')){
		//기증 홍보
		if(!cf_checkNull("sgBgmm", "유가년월")) { return false; }
	}
	
	if(cf_getValue("readNo") != ''){ //수정시

		if(cf_getValue("oldStdt") != ''  && cf_getValue("stdt") != cf_getValue("oldStdt") ){
			alert("해지독자는 수정 불가합니다.");
			return;
		}
		if(cf_getValue("oldStSayou") != ''  && cf_getValue("stSayou") != cf_getValue("oldStSayou") ){
			alert("해지독자는 수정 불가합니다.");
			return;
		}
		if(cf_getValue("newsCd") != cf_getValue("oldNewsCd")){
			alert("신문은 변경 불가합니다.");
			return;
		}
		if(cf_getValue("qty") != cf_getValue("oldQty") ){
			alert("구독부수는 변경 불가합니다.");
			return;
		}	
		if(cf_getValue("uPrice") != cf_getValue("oldUprice") ){
			alert("단가는 변경 불가합니다.");
			return;
		}
		//다른수금방법에서 카드로 변경시
		if(cf_getValue("oldSgType") != '022' && cf_getValue("sgType") == '022') {
			alert('카드신청은 지국에서 불가능하며 독자가 직접신청해야 합니다.');
			return;
		}
		
		if(cf_getValue("oldSgType") == '022' && cf_getValue("sgType") == '022' && cf_getValue("stdt") != '') {
			alert('카드독자 해지는 \n본사(02-2000-2000)로 연락해 해지해주세요.');
			return;
		}
		
		if( cf_getValue("oldReadTypeCd") == '016' && cf_getValue("readTypeCd") != '016' ){
			alert('본사 직원 독자의 경우 독자유형 변경이 불가합니다.');
			return;
		}
		if( cf_getValue("oldReadTypeCd") != '016' && cf_getValue("readTypeCd") == '016' ){
			alert('본사 직원 독자의 경우 독자유형 변경이 불가합니다.');
			return;
		}
		if(cf_getValue("oldReadTypeCd") == '016' && (cf_getValue("sgType") !='023' && cf_getValue("oldSgType") == '023')){
			alert('본사 직원 독자의 경우 수금방법 변경이 불가합니다.');
			return;
		}
		if(cf_getValue("oldReadTypeCd") == '016' && (cf_getValue("sgType") =='023' && cf_getValue("oldSgType") != '023')){
			alert('본사 직원 독자의 경우 수금방법 변경이 불가합니다.');
			return;
		}
		// 교육용 독자 벨리 데이션 추가(박윤철)
		if(cf_getValue("oldReadTypeCd") == '015' && cf_getValue("readTypeCd") != '015' && cf_getValue("agencyid") != '521050'){
			alert('교육용 독자의 경우 독자유형 변경이 불가합니다.');
			return;
		}
		if(cf_getValue("oldReadTypeCd") != '015' && cf_getValue("readTypeCd") == '015' && cf_getValue("agencyid") != '521050'){
			alert('교육용 독자의 경우 독자유형 변경이 불가합니다.');
			return;
		}
		if(cf_getValue("oldReadTypeCd") == '015' && (cf_getValue("sgType") !='023' && cf_getValue("oldSgType") == '023') && cf_getValue("agencyid") != '521050'){
			alert('교육용 독자의 경우 수금방법 변경이 불가합니다.');
			return;
		}
		if(cf_getValue("oldReadTypeCd") == '015' && (cf_getValue("sgType") =='023' && cf_getValue("oldSgType") != '023') && cf_getValue("agencyid") != '521050'){
			alert('교육용 독자의 경우 수금방법 변경이 불가합니다.');
			return;
		}
		
		// 학생(본사) 독자의 경우 자동이체가 아닌 상태에서 자동이체로 변경 불가 (2012.07.24 박윤철)
		if(cf_getValue("readTypeCd") == '013' && cf_getValue("oldSgType") != '021' && cf_getValue("sgType") == '021' ){
			alert("본사 자동이체 학생으로의 변경은 불가합니다.") ;
			fm.sgType.value = cf_getValue("oldSgType");
			return;
		}
		
		// 학생(본사) 독자의 경우 유형과 독자유형 동시에 변경 불가 (//자동이체 테이블 구조에 따라서 2012.06.16 박윤철)
		if(cf_getValue("oldReadTypeCd") == '013' && cf_getValue("readTypeCd") != '013' && cf_getValue("oldSgType") == '021' && (cf_getValue("sgType") != cf_getValue("oldSgType")) ){
			alert("본사 학생 독자의 경우 수금방법 변경 후에 유형 변경이 가능합니다.") ;
			fm.readTypeCd.value = cf_getValue("oldReadTypeCd");
			return;
		}
		
		//학생(본사)독자고 수금방법이 지로일때는 학생(본사)를 학생(지국)으로 변경(2013.11.15 문현국)
		if(cf_getValue("readTypeCd") == '013' && cf_getValue("sgType") == '011' ) {
			if(!confirm("지로로 변경하면 학생(지국) 독자로 변경됩니다. 변경하시겠습니까?")) {return;}
			fm.readTypeCd.value = "012";
		}
		
		if( cf_getValue("oldReadTypeCd") == '017' && cf_getValue("readTypeCd") != '017' ){
			alert('소외계층 독자의 경우 독자유형 변경이 불가합니다.');
			return;
		}
		if(cf_getValue("oldReadTypeCd") != '017' && cf_getValue("readTypeCd") == '017' ){
			alert('소외계층 독자의 경우 독자유형 변경이 불가합니다.');
			return;
		}
		if(cf_getValue("oldReadTypeCd") == '017' && (cf_getValue("sgType") !='023' && cf_getValue("oldSgType") == '023')){
			alert('소외계층 독자의 경우 수금방법 변경이 불가합니다.');
			return;
		}
		if(cf_getValue("oldReadTypeCd") == '017' && (cf_getValue("sgType") =='023' && cf_getValue("oldSgType") != '023')){
			alert('소외계층 독자의 경우 수금방법 변경이 불가합니다.');
			return;
		}
		if(cf_getValue("sgType") != cf_getValue("oldSgType")){
			if(cf_getValue("sgType") == '011' || cf_getValue("sgType") == '012' || cf_getValue("sgType") == '013' || 
					cf_getValue("sgType") == '021' ||	cf_getValue("sgType") == '022' || cf_getValue("sgType") == '023' || cf_getValue("sgType") == '024'){
				if(!confirm('수금방법 변경시 같은 독자번호를 가진 독자의 수금방법도 변경되며\n미수분 존재시 미수분 수금방법도 변경됩니다.\n수정하시겠습니까?')){ return; }
			}
		}
	// 신규독자만 필수 값 적용( 박윤철 2012.05.11 )
	} else {
		if(!cf_checkNull("rsdTypeCd", "주거구분")) { return false; }
		if(!cf_checkNull("hjPathCd", "신청경로")) { return false; }
	}
	if(cf_getValue("stSayou") != '' && cf_getValue("stdt") != '' && Number(cf_getValue("qty")) == 1){
		fm.stQty.value = '1' ;
	}
	//해지팝업
	if(cf_getValue("stSayou") != '' && cf_getValue("stdt") != '' && Number(cf_getValue("qty")) != 1){
		if(cf_getValue("oldStdt") =='' && cf_getValue("oldStSayou") =='' ){
			//팝업 오픈
			var left = (screen.width)?(screen.width - 1330)/2 : 10;
			var top = (screen.height)?(screen.height - 200)/2 : 10;
			var winStyle = "width=300,height=300,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
			var newWin = window.open("", "qty_close", winStyle);
			newWin.focus();
			
			readerListForm.target = "qty_close";
			readerListForm.action = "/reader/readerManage/popCloseReader.do";
			readerListForm.submit();
			return;	
		}else{
			fm.stQtyvalue = cf_getValue("qty");
		}
	}
	
	//현재월 미수일때 청구금액 없으면 단가로 채움
	if(cf_getValue("nowSgbbCd12") == '044'){
		fm.nowSnDt12.value = '';
		if(cf_getValue("nowBillAmt12")==''){
			fm.nowBillAmt12.value = cf_getValue("uPrice"); 
		}
	}
	
	for(var j=1 ; j < 13 ; j++){
		if(j < 10){ seq ='0'+j; } else { seq = j; }
		if(cf_getValue("nextSgbbCd"+seq) == '044'){
			document.getElementById("nextSnDt"+seq).value = '';
			if(cf_getValue("nextBillAmt"+seq)==''){
				document.getElementById("nextBillAmt"+seq).value = cf_getValue("uPrice"); 
			}
		}
	}
	
	for(var j=1 ; j < 13 ; j++){
		if(j < 10){ seq ='0'+j; } else { seq = j; }
		if( (cf_getValue("preBillAmt"+seq) != '' && cf_getValue("preAmt"+seq) != '') ){
			var yymm = cf_getValue("preYear"+seq);
			if((Number(cf_getValue("preBillAmt"+seq)) < Number(cf_getValue("preAmt"+seq)))  && 
				(Number(cf_getValue("preYear"+seq)) >= Number('201201'))  ){
				alert(yymm+'월분 수금액이 청구금액보다 큽니다.');
				cf_mvFocus("preBillAmt"+seq);
				return;	
			}
			if(cf_getValue("preSgbbCd"+seq) == '' && Number(cf_getValue("preYear"+seq)) >= Number('201201')){
				alert(yymm+'월분 수금 방법을 선택해 주세요.');
				cf_mvFocus("preBillAmt"+seq);
				return;
			}
		}
			
		if( (cf_getValue("nowBillAmt"+seq) != '' && cf_getValue("nowAmt"+seq) != '') ){
			var yymm = cf_getValue("nowYear"+seq);
			if((Number(cf_getValue("nowBillAmt"+seq)) < Number(cf_getValue("nowAmt"+seq))) && 
				Number(cf_getValue("nowYear"+seq)) >= Number('201201')){
				alert(yymm+'월분 수금액이 청구금액보다 큽니다.');
				cf_mvFocus("nowBillAmt"+seq);
				return;	
			}
			if(cf_getValue("nowSgbbCd"+seq) == '' && Number(cf_getValue("nowYear"+seq)) >= Number('201201')){
				alert(yymm+'월분 수금 방법을 선택해 주세요.');
				cf_mvFocus("nowBillAmt"+seq);
				return;
			}
		}
		if( (cf_getValue("nextBillAmt"+seq) != '' && cf_getValue("nextAmt"+seq) != '') ){
			var yymm = cf_getValue("nextYear"+seq);
			if(Number(cf_getValue("nextBillAmt"+seq)) < Number(cf_getValue("nextAmt"+seq))){
				alert(yymm+'월분 수금액이 청구금액보다 큽니다.');
				cf_mvFocus("nextBillAmt"+seq);
				return;	
			}
			if(cf_getValue("nextSgbbCd"+seq) == '' && Number(cf_getValue("nowYear"+seq)) >= Number('201201')){
				alert(yymm+'월분 수금 방법을 선택해 주세요.');
				cf_mvFocus("nextBillAmt"+seq);
				return;
			}
		}
		if(cf_getValue("preSgbbCd"+seq) != '' && cf_getValue("preSgbbCd"+seq) != '044'){
			if(cf_getValue("preSgbbCd"+seq) == '033' || cf_getValue("preSgbbCd"+seq) == '099'){
				document.getElementById("preBillAmt"+seq).value = '0';
				document.getElementById("preAmt"+seq).value = '0';
			}
			if(cf_getValue("preSnDt"+seq).replace(/(^\s*)|(\s*$)/gi, "") == ''){
				alert('수금일자를 입력해 주세요');
				cf_mvFocus("preSnDt"+seq);
				return;
			}
		}
		if(cf_getValue("nowSgbbCd"+seq) != '' && cf_getValue("nowSgbbCd"+seq) != '044'){
			if(cf_getValue("nowSgbbCd"+seq) == '033' || cf_getValue("nowSgbbCd"+seq) == '099'){
				document.getElementById("nowBillAmt"+seq).value = '0';
				document.getElementById("nowAmt"+seq).value = '0';
			}
			if(cf_getValue("nowSnDt"+seq).replace(/(^\s*)|(\s*$)/gi, "") == ''){
				alert('수금일자를 입력해 주세요');
				cf_mvFocus("nowSnDt"+seq);
				return;
			}
		}
		if(cf_getValue("nextSgbbCd"+seq) != '' && cf_getValue("nextSgbbCd"+seq) != '044'){
			if(cf_getValue("nextSgbbCd"+seq) == '033' || cf_getValue("nextSgbbCd"+seq) == '099'){
				document.getElementById("nextBillAmt"+seq).value = '0';
				document.getElementById("nextAmt"+seq).value = '0';
			}
			if(cf_getValue("nextSnDt"+seq).replace(/(^\s*)|(\s*$)/gi, "") == ''){
				alert('수금일자를 입력해 주세요');
				cf_mvFocus("nextSnDt"+seq);
				return;
			}
		}
		if(cf_getValue("preSnDt"+seq) != '' && cf_getValue("preSgbbCd"+seq) == ''){
			alert($("preYear"+seq).value+'월분 수금 방법을 선택해 주세요.');
			cf_mvFocus("preSgbbCd"+seq);
			return;
		}
		if(cf_getValue("nowSnDt"+seq) != '' && cf_getValue("nowSgbbCd"+seq) == ''){
			alert($("nowYear"+seq).value+'월분 수금 방법을 선택해 주세요.');
			cf_mvFocus("nowSgbbCd"+seq);
			return;
		}
		if(cf_getValue("nextSnDt"+seq) != '' && cf_getValue("nextSgbbCd"+seq) == ''){
			alert($("nextYear"+seq).value+'월분 수금 방법을 선택해 주세요.');
			cf_mvFocus("nextSgbbCd"+seq);
			return;
		}
		
		/* 미수로 재처리시 수금일/ 수금액 0원처리 (2012.07.18 박윤철) */
		if(cf_getValue("preSgbbCd"+seq) != '' && cf_getValue("preSgbbCd"+seq) == '044'){
			document.getElementById("preAmt"+seq).value = '0';
			document.getElementById("preSnDt"+seq).value = '' ;
		}else if(cf_getValue("nowSgbbCd"+seq) != '' && cf_getValue("nowSgbbCd"+seq) == '044'){
			document.getElementById("nowAmt"+seq).value = '0';
			document.getElementById("nowSnDt"+seq).value = '' ;
		}else if(cf_getValue("nextSgbbCd"+seq) != '' && cf_getValue("nextSgbbCd"+seq) == '044'){
			document.getElementById("nextAmt"+seq).value = '0';
			document.getElementById("nextSnDt"+seq).value = '' ;
		}
		
	}
	
	// 신규독자인경우 최종입력 여부 확인(이중 신청 방지 2012.08.22 박윤철)
	if("INS" == flag) {
		if(!confirm("신규독자를 입력하시겠습니까?")){ return; }
		url = "/reader/readerManage/saveReader.do";
	} else if("UPT" == flag) {
		if(!confirm("수정된 내용을 저장하시겠습니까?")){ return; }
		url = "/reader/readerManage/updateReaderData.do";
	}

	fm.target="_self";
	fm.action=url;
	fm.submit();
}
	
// 상세수금정보 출력
function detailSugm(id1, id2){
	if(id1.value == null || id1.value == ""){

	}else{
		document.getElementById("chgColumn").innerHTML = "처리일자";
		id1.style.display = "block";
		id2.style.display = "none";
	}
}

function closeSugm(id1, id2){
	document.getElementById("chgColumn").innerHTML = "금액";
	id1.style.display = "none";
	id2.style.display = "block";
}
	
jQuery(document).ready(function($){
	clearField();
	$("#prcssDiv").hide();
});
</script>
<form id="readerListForm" name="readerListForm" action="" method="post">
	<input type="hidden" id="minGb" name="minGb" value="" />
	<input type="hidden" id="seq" name="seq" value="" />
	<input type="hidden" id="boSeq" name="boSeq" value="" />
	<input type="hidden" id="stQty" name="stQty" value="" />
	<input type="hidden" id="boReadNo" name="boReadNo" value="" />
	<input type="hidden" id="oldNewsCd" name="oldNewsCd" value="100" />
	<input type="hidden" id="oldQty" name="oldQty" value="" />
	<input type="hidden" id="oldUprice" name="oldUprice" value="" />
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
	<input type="hidden" id="orgChgDt" name="orgChgDt" value="" />
	<!-- 페이징 처리 변수 -->
	<input type=hidden id="pageNo" name="pageNo" value="${param.pageNo}" />
	
<!--독자등록-->
	<div style="width: 1020px; margin: 0 auto; overflow: hidden; border: 0px solid red; padding-bottom: 5px">
		<!-- 독자정보&구독정보 -->
		<div style="width: 610px; float: left; border: 0px solid green; padding-right: 10px;">
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
					 <tr>
					    <th style="letter-spacing: -1px"><b class="b03">*</b>도로명주소</th>
						<td style="text-align: left;">
							&nbsp;<input type="text" id="dlvZip" name="dlvZip" value="" maxlength="6" style="width: 60px; vertical-align: middle;" readonly="readonly" />
							<a href="#fakeUrl" onclick="popAddr('readerListForm');"><img alt="우편번호찾기" src="/images/ico_search2.gif" style="border: 0; vertical-align: middle;" /></a>
						</td>
						<td colspan="4" style="text-align: left; height:20px; font-size: 13px" id="allAddr"></td>
					</tr>
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
									<select name="hjPathCd" id="hjPathCd" style="width: 98%" onchange="fn_changeHjPath(this.value);">
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
										<option value="">선택</option>
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
								<td><input type="text" size="10" id="stdt" name="stdt" value="<c:out value='${sdate}' />" style="width: 95%" onclick="Calendar(this)" readonly="readonly" /></td>
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
						<div style="text-align: left; padding: 5px 0 5px 5px; width: 335px;  border: 0px solid red; float: left;">
							<c:choose>
								<c:when test="${not empty admin_userid }">
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="alert('지국만 가능합니다.');">본사신청</a></span>
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="alert('지국만 가능합니다.');">본사불배</a></span>
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="alert('지국만 가능합니다.');">본사</a></span>
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="alert('지국만 가능합니다.');">본사휴독</a></span>
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="alert('지국만 가능합니다.');">본사해지</a></span>
								</c:when>
								<c:otherwise>
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="winPop('1')">본사신청</a></span>
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="winPop('001')">본사불배</a></span>
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="winPop('002')">본사</a></span>
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="winPop('003')">본사휴독</a></span>
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="winPop('004')">본사해지</a></span>
								</c:otherwise>
							</c:choose>
						</div>
						<div style="padding: 5px 0 0 0; text-align: right; border: 0px solid red; float: left; width: 260px">
							<c:choose>
								<c:when test="${not empty admin_userid }">
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="alert('지국만 가능합니다.');">추가구독</a></span>
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="alert('지국만 가능합니다.');">매체추가</a></span>&nbsp;&nbsp;&nbsp;&nbsp;
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="alert('지국만 가능합니다.');">신규독자</a></span>
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="alert('지국만 가능합니다.');">저 장</a></span>;
								</c:when>
								<c:otherwise>
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="popExtendReader('qty');">추가구독</a></span>
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="popExtendReader('newsCd');">매체추가</a></span>&nbsp;&nbsp;&nbsp;&nbsp;
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="clearField('newReader');">신규독자</a></span>
									<span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="fn_save();" style="color: blue; font-weight: bold;">저 장</a></span>
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
							<td onmouseover="detailSugm(preClDt<%=seq%>, preBillAmt<%=seq %>);" onmouseout="closeSugm(preClDt<%=seq %>, preBillAmt<%=seq %>);" style="width: 50px">
								<b><%=(String)request.getAttribute("lastyymm"+seq) %></b>
								<input type="hidden" id="preYear<%=seq %>" name="preYear<%=seq %>" value="<%=(String)request.getAttribute("lastyymm"+seq) %>" />
							</td>
							<td>
								<input type="text" id="preSnDt<%=seq %>" name="preSnDt<%=seq %>" maxlength="8" value="<c:out value='${sdate}' />" readonly="readonly" onclick="Calendar(this);" style="width: 80px; padding:  0;"/>
							</td>
							<td>
								<input type="text" id="preBillAmt<%=seq %>" name="preBillAmt<%=seq %>" style="width: 70px; ime-mode:disabled; padding: 0;" onkeypress="inputNumCom();"/>
								<input type="text" id="preClDt<%=seq %>" name="preClDt<%=seq %>" style="width: 70px; display:none; font-weight: bold; color: #ff0011;  padding: 0;"/>
							</td>
							<td><input type="text" id="preAmt<%=seq %>" name="preAmt<%=seq %>" style="width: 70px; ime-mode:disabled;  padding: 0;" onkeypress="inputNumCom();"/></td>
							<td>
								<select name="preSgbbCd<%=seq %>" id="preSgbbCd<%=seq %>" style="width: 90px;  height: 18px">
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
							<td onmouseover="detailSugm(nowClDt<%=seq%>, nowBillAmt<%=seq %>)" onmouseout="closeSugm(nowClDt<%=seq %>,nowBillAmt<%=seq %>)" style="width: 50px">
								<b><%=(String)request.getAttribute("nowyymm"+seq) %></b>
								<input type="hidden" id="nowYear<%=seq %>" name="nowYear<%=seq %>" value="<%=(String)request.getAttribute("nowyymm"+seq) %>" />
							</td>
							<td >
								<input type="text" id="nowSnDt<%=seq %>" name="nowSnDt<%=seq %>" maxlength="8" value="<c:out value='${sdate}' />" onclick="Calendar(this);" style="width: 80px; padding: 0;" readonly="readonly" />
							</td>
							<td>
								<input type="text" id="nowBillAmt<%=seq %>" name="nowBillAmt<%=seq %>" style="width: 70px; ime-mode:disabled; padding: 0;" onkeypress="inputNumCom();"/>
								<input type="text" id="nowClDt<%=seq %>" name="nowClDt<%=seq %>"  style="display:none; width: 70px; font-weight: bold; padding: 0; color: #ff0011"/>
							</td>
							<td><input type="text" id="nowAmt<%=seq %>" name="nowAmt<%=seq %>" style="width: 70px; ime-mode:disabled; padding: 0;" onkeypress="inputNumCom();"/></td>
							<td>
								<select name="nowSgbbCd<%=seq %>" id="nowSgbbCd<%=seq %>" style="width: 90px; height: 18px">
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
							<td onmouseover="detailSugm(nextClDt<%=seq%>, nextBillAmt<%=seq %>);" onmouseout="closeSugm(nextClDt<%=seq %>,nextBillAmt<%=seq %>);" style="width: 50px">
								<b><%=(String)request.getAttribute("nextyymm"+seq) %></b>
								<input type="hidden" id="nextYear<%=seq %>" name="nextYear<%=seq %>" value="<%=(String)request.getAttribute("nextyymm"+seq) %>" />
							</td>
							<td >
								<input type="text" id="nextSnDt<%=seq %>" name="nextSnDt<%=seq %>" maxlength="8" value="<c:out value='${sdate}' />" onclick="Calendar(this);" style="width: 80px; padding: 0;" readonly="readonly" />
							</td>
							<td >
								<input type="text" id="nextBillAmt<%=seq %>" name="nextBillAmt<%=seq %>" style="width: 70px; ime-mode:disabled; padding: 0;" onkeypress="inputNumCom();"/>
								<input type="text" id="nextClDt<%=seq %>" name="nextClDt<%=seq %>" style="display:none; width: 70px; font-weight: bold; padding: 0; color: #ff0011"/>
							</td>
							<td><input type="text" id="nextAmt<%=seq %>" name="nextAmt<%=seq %>" style="width: 70px; ime-mode:disabled; padding: 0;" onkeypress="inputNumCom();"/></td>
							<td>
								<select name="nextSgbbCd<%=seq %>" id="nextSgbbCd<%=seq %>" style="width: 90px; height: 18px">
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
						<div style="width: 333px; text-align: left; float: left; padding: 3px 0;"><textarea id="remk" name="remk" style="height:66px; width:328px;" rows="" cols=""></textarea></div>
						<div style="width: 58px; float: left; padding-top: 4px; font-weight: bold; cursor: pointer; vertical-align: bottom;">
							<div style="border: 1px solid #a4a7ac; background-color: #e5e5e5; padding: 21px 0; color: blue" onclick="fn_saveRemk();">비고<br/>저장</div>
							<!-- <span class="btnCss2"><a class="lk2" href="#fakeUrl" onclick="fn_saveRemk();">비고저장</a></span>-->
						</div>
					</div>
				</div> 
				<div style="padding-top: 5px; width: 400px;">
					[최근비고이력]
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="#fakeUrl"  id="tagMemoLlist" onclick="fn_memo_view_more('${billingInfo[0].READNO }')"><img src="/images/main_title_more.gif" style="vertical-align:middle; border:0" alt="전체리스트" />&nbsp;</a>					
				</div>
				<!-- //bottom -->
				<!-- form -->
				<div><textarea id="desc" name="desc" rows="" cols="" readonly="readonly" style="border: 1px solid #c0c0c0; width: 397px; height: 62px"></textarea></div>
				<!-- //form -->
			</div>
		</div>
		<!-- 상세리스트(월별수금내역)-->
		<div style="clear: both; padding-top: 10px; border: 1px solid #e5e5e5; clear: both; width: 1020px; margin: 0 auto; overflow: hidden;">
			<!-- 조회 조건-->
			<div style="padding: 0 5px 5px 5px; overflow: hidden; width: 1010px">
				<div class="box_gray" style="padding: 5px 0; text-align: center;">
   					<select id="searchType" name="searchType" onchange="changeSearch(this.value);" style="vertical-align: middle;">
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
			    	<input type="text" id="searchText" name="searchText" value="<c:out value='${param.searchText}'/>" style="width: 350px; vertical-align: middle;" onkeydown="if(event.keyCode == 13){fn_search(); }">&nbsp;&nbsp;
			    	<a href="#fakeUrl" onclick="fn_search();"><img src="/images/bt_search.gif" style="vertical-align: middle;" /></a>
			    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
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
			<div style="width: 1010px;  margin: 0 auto; height: 200px; overflow-y: scroll;">
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
					<c:set var="cssType" value=""/>
					<c:forEach items="${readerList }" var="list" varStatus="i">
						<c:choose>
							<c:when test="${list.BNO eq '999'}">
								<c:set var="cssType" value="cursor:pointer; background-color: #f9f9f9; color: #e74985"/>
							</c:when>
							<c:when test="${list.READTYPECD eq '099'}">
								<c:set var="cssType" value="cursor:pointer; background-color: #E3E3E3"/>
							</c:when>
							<c:otherwise>
								<c:set var="cssType" value="cursor:pointer; "/>
							</c:otherwise>
						</c:choose>
						<tr  class="mover" onclick="detailView('${list.READNO}','${list.NEWSCD}','${list.SEQ}','${list.BOSEQ}')" style="${cssType}">
							<td>${list.GNO }-${list.BNO }</td>
							<td>${list.READNO }</td>
							<td>${list.NEWSNM }</td>
							<td style="text-align: left;"><c:out value="${list.READNM }"/></td>
							<td>${list.QTY }</td>
							<td style="text-align: left;">${list.HOMETEL }</td>
							<td style="text-align: left;">${list.MOBILE }</td>
							<td style="text-align: left;">${list.ADDR }</td>
							<td>
								<c:choose>
									<c:when test="${list.BNO eq '999'}">
										${fn:substring(list.STDT,0,4) }-${fn:substring(list.STDT,4,6) }-${fn:substring(list.STDT,6,8) }
									</c:when>
									<c:otherwise>
										${fn:substring(list.HJDT,0,4) }-${fn:substring(list.HJDT,4,6) }-${fn:substring(list.HJDT,6,8) }
									</c:otherwise>
								</c:choose>
							</td>
							<td><fmt:formatNumber value="${list.SUMCOLLECT }" type="number" /></td>
							<td><fmt:formatNumber value="${list.ACCOUNTDUE }" type="number" /></td>
						</tr>
					</c:forEach>
				</table>
			</div>
			<div style="padding: 0;" ><%@ include file="/common/paging.jsp"%></div>
		<!-- //리스트 -->
	</div>
	<!-- //상세리스트 -->
</form>
<!-- processing viewer -->
<div id="prcssDiv"  class="loingProcessDiv"><div><img src="/images/process4.gif"/></div></div> 
<!-- //processing viewer --> 