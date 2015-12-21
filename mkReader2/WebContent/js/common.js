/*
 ****************************************************************************
 * common javaScript
 * @projectDescription 매일경제독자관리시스템 공통펑션
 * 
 ****************************************************************************
 */

/**
 * @Description 해당 ID의 객체의 값이 없거나 null 인 경우 false를 반환 한다.
 * @param String id : 객체 아이디,
 *        String msg : 오류 메시지 
 * @returns boolean
 */
function cf_checkNull(id, msg){
	var obj = document.getElementById(id);
	
	// ID의 값이 NULL or 값이 없는지 확인
	if(obj.value == null || obj.value == ""){
		alert(msg+" 는(은) 필수 입력입니다.");
		obj.focus();
		return false;
	}else{
		return true;
	}
}


/**
 * @Description 해당 ID의 객체의 값이 없거나 null 인 경우 false를 반환 한다.
 * @param String id : 객체 아이디,
 *        String value : 비교 값
 * @return boolean
 */
function cf_checkValue(id, value){
	var obj = document.getElementById(id);
	var result;
	// ID의 값을 확인하여 일치여부를 확인하여 true or false를 리턴한다.
	if(obj.value != value){
		result = false;
	}else{
		result = true;
	}
	return result;
}

/**
 * @Description 키 다운시 체크 하여 숫자가 아닌경우 KeyEvent를 cancel 한다.
 */
function cf_checkNumeric(){
	var obj = document.getElementById(id);
	 
	if ((event.keyCode<48) || (event.keyCode>57)){
		alert("숫자만 입력 가능합니다.");
		event.keyCode = 0;  // 이벤트 cancel
	}
}

/**
 * @Description 객체의 값을 조회해 온다
 * @param id : 객체아이디
 */
function cf_getValue(id) {
	var returnVal = document.getElementById(id).value;
	return returnVal;
}

/**
 * @Description 객체로 포커스를 이동한다.
 * @param id 객체아이디
 */
function cf_mvFocus(id) {
	document.getElementById(id).focus();
	return;
}

/**
 * @Description 수금년월입력창을 팝업하고 입력값을 검증하여 이상이 없는경우 전달받은ID 값에 입력하고 그 결과를 리턴한다.
 * @param String id : 객체 아이디
 * @return boolean result : 입력 처리 결과
 */
function cf_popSgBgmm(id){
	var obj = document.getElementById(id);
	var url = "/common/common/popInsertSgbgmm.do";
	var popOption = "dialogWidth:400px; dialogHeight:150px;center:yes;scroll:no;status:no;help:no;location:no";
	var sgBgmm = window.showModalDialog(url, window, popOption);

	if(sgBgmm != null && sgBgmm != "undefined"){
		obj.value = sgBgmm;
		return true;
	}else{
		return false;
	}

}


/**
 * @Description 팝업창을 중앙에 위치시킨다.
 */
function cf_centerPopup(){
    var x,y;
    if (self.innerHeight) { // IE 외 모든 브라우저
        x = (screen.availWidth - self.innerWidth) / 2;
        y = (screen.availHeight - self.innerHeight) / 2;
    }else if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict 모드
        x = (screen.availWidth - document.documentElement.clientWidth) / 2;
        y = (screen.availHeight - document.documentElement.clientHeight) / 2;
    }else if (document.body) { // 다른 IE 브라우저( IE < 6)
        x = (screen.availWidth - document.body.clientWidth) / 2;
        y = (screen.availHeight - document.body.clientHeight) / 2;
    }
    window.moveTo(x,y);
}


/**
 * 게시판 상세 댓글 부분 컨트롤
 * @return
 */
function boardReplyUi(userId){
	var ulp = $("answerViewUl"); // id선택 $, $$클래스 선택
	var tLi = ulp.select(".answer1Depth"); 

		tLi.each(function(item,i){ //li 순번적으로 
			var aa = item.down("a",1); //a 선택
			aa.observe("click", function(){
				var textareaBox = $(item).down("textarea"); //textarea선택
				var userWrite = $(item).down("p"); //p 댓글선택 
				var btnt = $(item).down(".modifCancel");
				textareaBox.value = (userWrite.innerHTML).replace(/[<BR>]{4}/gi,"\r\n");//textarea에 덧글 담기
				textareaBox.toggle();
				userWrite.toggle();
				btnt.toggle();
			});
			item.select(".answer2Depth").each(function(jtem,j){
				var jj = jtem.down("a",0); //a 선택
				jj.observe("click", function() { 
					var textareaBox= $(jtem).down("textarea"); //textarea선택
					var userWrite = $(jtem).down("p"); //p 댓글선택 
					var btnt = $(jtem).down(".modifCancel");
					textareaBox.innerHTML = userWrite.innerHTML;//textarea에 덧글 담기		
					textareaBox.toggle();
					userWrite.toggle();
					btnt.toggle();
				});
			});
			
			item.down("a").onclick=function(){return false;};
			item.down("a").observe("click",function(){
				
				
				//로그인체크해주세요.
				if(userId==""){
					alert('로그인이 필요합니다.');
					window.document.location = "/member/login.do";
				}
				
				item.down(".addReplyWrite2depth").toggle();
			});
		});
}

/**
 * 코스정보을 인쇄하는 함수
 * @return print
 */
function coursePrint(){
	window.print();
};

function courseTab(index){
	stp.toggleSrc(".courseTabImg",index);
	if(index==0){
		$("courseShop").hide();
		$("courseMap").show();
	}else{
		$("courseShop").show();
		$("courseMap").hide();
	}
	
	$("courseTab").select("li").each(function(item,i){
		item.removeClassName("tabOn");
	});
	$("courseTab").select("li")[index].addClassName("tabOn");
};

/**
 * 뷰페이지의 폰트사이즈 조정하는 함수
 * obj = element의 id
 * mode = up(확대), down(축소)
 */
function fontSizeControl(obj, mode) {
	var container = $(obj);
	var boxFontsize = parseInt($(container).getStyle("font-size"));
	if(boxFontsize >= 32 && mode == "up") {
		alert("더 이상 확대할 수 없습니다.");
	} else if(boxFontsize <= 10 && mode == "down") {
		alert("더 이상 축소할 수 없습니다.");
	} else {
		var setBoxFontSize = fontControlEvent(boxFontsize, mode);		
		$(container).setStyle({"fontSize" : setBoxFontSize});
		
		container.select("span").each(function(item, i) {
			var itemFontSize = parseInt($(item).getStyle("font-size"));
			var setItemFontSize = 0;
			if(setBoxFontSize != itemFontSize) {
				setItemFontSize = fontControlEvent(itemFontSize, mode);				
				$(item).setStyle({"fontSize" : setItemFontSize});
			}
		});	
	}
}
/**
 * 뷰페이지의 폰트사이즈를 리턴할 함수
 * getFontSize = 기존 element의 font-size
 * getMode = up(확대), down(축소)
 * @return setFontSize
 */
function fontControlEvent(getFontSize, getMode) {
	var setFontSize = 0;
	
	if(getMode == "up") {
		if(getFontSize <= 10) {
			setFontSize = 12;
			return setFontSize;
		} else if(getFontSize <= 12) {
			setFontSize = 14;
			return setFontSize;			
		} else if(getFontSize <= 14) {
			setFontSize = 18;
			return setFontSize;			
		} else if(getFontSize <= 18) {
			setFontSize = 24;
			return setFontSize;			
		} else {
			setFontSize = 32;
			return setFontSize;			
		} 
	} else if(getMode == "down") {
		if(getFontSize >= 32) {
			setFontSize = 24;
			return setFontSize;			
		} else if(getFontSize >= 24) {
			setFontSize = 18;
			return setFontSize;			
		} else if(getFontSize >= 18) {
			setFontSize = 14;
			return setFontSize;			
		} else if(getFontSize >= 14) {
			setFontSize = 12;
			return setFontSize;			
		} else if(getFontSize >= 12) {
			setFontSize = 10;
			return setFontSize;			
		} else {
			setFontSize = 10;
			return setFontSize;
		}
	}
}



var selectElementIndex = 0;
var sELiData = new Array();
var sTempData = new Array();
/**
 * 셀렉트을 UI로 변경하는 함수 
 * @return
 */
function selectMakeElement(oId,dId,userEmail,addPadding){
	var oId = oId; //셀렉트 박스
	var dId = dId; //직접입력시 사용되는 인풋
	var idNum = oId;
	var span = stp.$E("span");
	var addPdd = (addPadding)?addPadding:10; // span의 사이즈을 잡을때 사용
	span.addClassName("selectElementMakeCase");
	
	$(oId).parentNode.insertBefore(span,$(oId));
	$(oId).hide();
	sELiData[idNum] = new Array();
	$(oId).select("option").each(function(item,i){
		sELiData[idNum].push(item.text);
	});
	var posTop = new Array();
	posTop = (stp.browser()[0]=="ie" && stp.browser()[1]=="6.0")?["3px","0"]:posTop;
	span.innerHTML ="<div class='case' style='top:"+posTop[0]+"'>" +
						"<ul id='emailSelectUl"+idNum+"'>" +
							"<li><a href='#'>"+$(oId).options[$(oId).selectedIndex].text+"</a></li>" +
						"</ul>" +
						"<div class='icon' style='top:"+posTop[1]+"'><a href='#'><img src='/images/common/btn/btnSelectElementDown.gif' alt='' /></a></div>" +
					"</div><img src='/images/common/btn/dot.gif' width='1' height='1' />";
	
	//각 엘리먼트의 가로값 자동지정 부분 
	//IE7 가로값 버그 잡기
	var objWid = ($(oId).getWidth()+22);
	objWid = (stp.browser()[1]=="7.0" && stp.browser()[0]=="ie")?objWid+20:objWid;
	objWid = (stp.browser()[0]=="op")?objWid-18:objWid;
	span.down("div").setStyle({"width":objWid+"px"});
	span.down("ul").setStyle({"width":objWid+"px","height":"24px"});
	span.setStyle({"paddingRight":(objWid+addPdd)+"px"})
	
	//각 링크들 observe연결
	span.down("a").onclick=function(){return false;};
	span.down("a").observe("click",function(){
		if(1<$(oId).select("option").length){
			makeOptionText();
		}
	});
	
	span.down("a",1).onclick=function(){return false;};
	span.down("a",1).observe("click",function(){
		if(1<$(oId).select("option").length){
			makeOptionText();
		}
	});
	
	//수정시 텍스트 값을 이용하여 값을 넣음.
	
	if(userEmail){
		var opt = $(oId).select("option").find(function(optItem,optI){
			return (optItem.text == userEmail);
		});
		if(!opt){
			$(dId).value = userEmail;
			$(dId).show();
			$("emailSelectUl"+idNum).down("a").innerHTML = "직접입력";
		}else{
			$("emailSelectUl"+idNum).down("a").innerHTML = userEmail;
		}
		
		//$(oId).selectedIndex = index;
		//$("emailSelectUl"+idNum).down("a").innerHTML = $(oId).value;
	};
	
	
	//셀렉트박스 안의option 역할을 하는 li을 만들어주는 함수
	var makeOptionText = function(){
		//리턴되는 값을 위해 백업
		sTempData[idNum] = $("emailSelectUl"+idNum).down("a").innerHTML;//이미 선택되어잇는 데이터
		var tempH;
		if(5<$(oId).select("option").length){
			tempH = 120;
		}else{
			tempH = 24+(($(oId).select("option").length-1) * 22);
		}
		span.down("ul").setStyle({"height":tempH+"px","overflow":"auto"});
		
		var tTxt="";
		$("emailSelectUl"+idNum).innerHTML = "";
		$(sELiData[idNum]).each(function(item,i){
			tTxt += "<li><a href='#' num='"+i+"'>"+item+"</a></li>";
		});
		$("emailSelectUl"+idNum).innerHTML = tTxt;
		$("emailSelectUl"+idNum).select("li").first().addClassName("str");
		$("emailSelectUl"+idNum).select("li").last().addClassName("end");
		$("emailSelectUl"+idNum).select("li").each(function(item){
			item.setStyle({"width":(objWid-30)+"px"});
		});
		
		
		$("emailSelectUl"+idNum).select("a").each(function(item,i){
			item.num = i;
			item.onclick=function(){return false;};
			item.observe("click",function(){
				span.down(".icon").show();
				span.down("ul").setStyle({"height":"24px","overflow":"hidden"});
				
				
				//만약 "직접선택" 일경우
				if(dId){
					(item.innerHTML=="직접입력")?$(dId).show():$(dId).hide();
					$(dId).value = (item.innerHTML=="직접입력" || item.innerHTML=="선택해주세요.")?"":item.innerHTML;
				}
				// 버튼들 값 전달 (value)
				$(oId).selectedIndex = item.num;
				//버튼들 기본 액션 (ui)
				$("emailSelectUl"+idNum).innerHTML = "<li><a href='#'>"+item.innerHTML+"</a></li>";
				$("emailSelectUl"+idNum).down("a").onclick=function(){return false;};
				$("emailSelectUl"+idNum).down("a").observe("click",function(){
					makeOptionText();
				}.bind(this));
				
				//셀렉트에 onchange이벤트가 있는 경우 사용한다.
				if($(oId).onchange){;
					$(oId).onchange();
				};
				sTempData[idNum] = $("emailSelectUl"+idNum).down("a").innerHTML;//이미 선택되어잇는 데이터
			}.bind(this)); 
		});
		
		setTimeout(function(){
			$(document.body).observe("click",function(){
				span.down(".icon").show();
				span.down("ul").setStyle({"height":"24px","overflow":"hidden"});
				$("emailSelectUl"+idNum).innerHTML = "<li><a href='#'>"+sTempData[idNum]+"</a></li>";
				$("emailSelectUl"+idNum).down("a").onclick=function(){return false;};
				$("emailSelectUl"+idNum).down("a").observe("click",function(){
					makeOptionText();
				}.bind(this));
				$(document.body).stopObserving("click");
			});
		},500);
		span.down(".icon").hide();
	};
};

//플래쉬에 현재위치을 넣어주는 스크립트.
function cutLocation(){
	var nowLoca = (location.href).split(".org")[1];
	//alert(nowLoca);
	if((nowLoca.indexOf("?cs_no") != -1) || (nowLoca.indexOf("?GROUP_NO") != -1)){
		nowLoca = nowLoca.split("&")[0];
	}else{
		nowLoca = nowLoca.split("?")[0];
	}
	return nowLoca;
};

//innerHTML 특수문자 체크
function replaceHtml(inputString){
	inputString = replaceStr(inputString , "&amp;" , "&");
	inputString = replaceStr(inputString , "&lt;" , "<");
	inputString = replaceStr(inputString , "&gt;" , ">");

	return inputString;
}
function replaceStr(inputString, targetString, replacement)
 {
	  var v_ret = null;
	  var v_regExp = new RegExp(targetString, "g");
	  v_ret = inputString.replace(v_regExp, replacement);
	  
	  return v_ret;
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


//우편주소 팝업
function popAddr(formName){
	var fm = document.getElementById(formName);
	
	var left = 0;
	var top = 30;
	var winStyle = "width=520,height=700,left="+ left + ",top=" + top +",toolbar=0, menubar=0, location=0, status=0, resizeable=0, scrollbars=1";
	var newWin = window.open("", "pop_addr", winStyle);
	newWin.focus();
	
	fm.target = "pop_addr";
	fm.action = "/common/common/popNewAddr.do";
	fm.submit();
}

/**
 * 숫자3자리마다 콤마표시
 * @param number
 * @returns
 */
function cf_number_format(number) {
	var nArr = String(number).split('').join(',').split('');
	for( var i=nArr.length-1, j=1; i>=0; i--, j++)  if( j%6 != 0 && j%2 == 0) nArr[i] = '';
	return nArr.join('');
 }


/**
 * 핸드폰 데쉬(-)추가
 * @param value 핸드폰번호
 * @param inputId 수정된 번호 넣을 곳 아이디
 * @exception cf_phone_number_mark(this.value, 'deliveryNum1')
 * @returns
 */
function cf_phone_number_mark(value, inputId) {
	var orgPhoneNum = jQuery.trim(value);
	var orgNumLen = orgPhoneNum.length;
	var modifyedNum = "";
	
	if(orgNumLen < 13 && orgNumLen > 0 && orgPhoneNum != null) {
		orgPhoneNum = orgPhoneNum.replace(/-/g,"");
		
		//핸드폰 자리수확인
		if(orgPhoneNum < 10) {
			alert("번호가 잘못입력되었습니다.");
			return false;
		}
		
		if(orgNumLen < 11) { //가운데자리가 3자리인 핸드폰 번호
			modifyedNum = orgPhoneNum.substring(0, 3)+"-"+orgPhoneNum.substring(3, 6)+"-"+orgPhoneNum.substring(6, 10); 
		} else {
			modifyedNum = orgPhoneNum.substring(0, 3)+"-"+orgPhoneNum.substring(3, 7)+"-"+orgPhoneNum.substring(7, 11); 
		}
		document.getElementById(inputId).value = modifyedNum;
	}
}

/**
 * 숫자자리콤마찍기
 * @param n
 * @returns
 */
function cf_commify(n) {
	if(n !=  null) {		
		var reg = /(^[+-]?\d+)(\d{3})/;   // 정규식
		n += '';                          // 숫자를 문자열로 변환
		
		while (reg.test(n))
		n = n.replace(reg, '$1' + ',' + '$2');
		return n;
	} else {
		return ' ';
	}
}


//마우스 오른쪽 막기
/*
document.oncontextmenu = returnEventFalse;
document.ondragstart = returnEventFalse;
document.onselectstart = returnEventFalse;
function returnEventFalse(){
	event.returnValue = false;
}
*/