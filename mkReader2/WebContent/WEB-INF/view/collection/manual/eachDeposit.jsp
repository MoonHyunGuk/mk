<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="/js/mini_calendar.js"></script>
<script type="text/javascript" src="/js/validator.js"></script>
<script type="text/javascript" src="/js/ajaxUtil.js"></script>
<script type="text/javascript" >
	var totalCount = 0;
	var totalMoney = 0;

	// 숫자만 입력가능하도록 처리
	function onlyNumber()
	{
		if(
			(event.keyCode < 48 || event.keyCode > 57) 
				&& (event.keyCode < 96 || event.keyCode > 105) 
				&& event.keyCode != 8 && event.keyCode != 9 && event.keyCode != 46 && event.keyCode != 13
		) {
			event.returnValue=false;
		}
		else if ( event.keyCode == 13 ) {		// 엔터키면 입금처리
			goDeposit();
		}
	}
	
	// 구독정보 조회 방식 변경 ( 고유번호 <-> 배달/구역 )
	function changeType() {
	
		if ( document.getElementById("gubun").value == "1" ) {
			document.getElementById("gubun_1").style.display = "block";
			document.getElementById("gubun_11").style.display = "block";
			document.getElementById("gubun_2").style.display = "none";
			document.getElementById("gubun_22").style.display = "none";
		}
		else {	//"2"
			document.getElementById("gubun_1").style.display = "none";
			document.getElementById("gubun_11").style.display = "none";
			document.getElementById("gubun_2").style.display = "block";
			document.getElementById("gubun_22").style.display = "block";
		}
	
		document.getElementById("readno").value = "";
		document.getElementById("gno").value = "";
		document.getElementById("bno").value = "";
	}

	// 입금방법 변경
	function changeDepType() {
		var frm = document.frm;
		
		var depTypeVal = frm.depType.options[frm.depType.selectedIndex].value;

		// 결손, 재무, 휴독, 미수이면
		if ( depTypeVal == "031" || depTypeVal == "032" || depTypeVal == "033" || depTypeVal == "044" ) {
			frm.depMoney.readOnly = true;	// 입금액 수정 불가
			frm.depMoney.value = "0";
		}
		else {
			frm.depMoney.readOnly = false;	// 입금액 수정 가능
		}

		frm.depMoney.focus();
	}

	// 입금 금액 노출처리
	function setDepositMoney() {

		var depositMoney = 0;

		var frm = document.frm;

		var depTypeVal = frm.depType.options[frm.depType.selectedIndex].value;
		
		// 결손, 재무, 휴독, 미수이면
		if ( depTypeVal == "031" || depTypeVal == "032" || depTypeVal == "033" || depTypeVal == "044" ) {
			frm.depMoney.value = "0";
		} else {
			var newsChkbox = frm.newsChkbox;
			if ( newsChkbox != null ) {
				if ( newsChkbox.length == undefined ) {		// 객체는 존재하지만 해당 name을 가진 객체가 1개일때(배열로 인식되지 않았을 때)
					if ( newsChkbox.checked == true) {
						var newsObjId = newsChkbox.id.replace("td_", "");
						depositMoney += Number(document.getElementById("money_"+newsObjId).value);
					}
				}
				else {
					for ( var i = 0; i < newsChkbox.length; i++ ) {
						if ( newsChkbox[i].checked == true ) {
							var newsObjId = newsChkbox[i].id.replace("td_", "");
							depositMoney += Number(document.getElementById("money_"+newsObjId).value);
						}
					}
				}
			}
	
			if ( Number(depositMoney) > 0 ) {
				frm.depMoney.value = Number(depositMoney);
			} else {
				frm.depMoney.value = "";
			}
		}
	}

	// 구독정보 목록 전체 선택(입금액 계산 포함)
	function allCheck() {

		var depositMoney = 0;
		
		var frm = document.frm;	
		
		var newsChkbox = frm.newsChkbox;
		if ( newsChkbox != null ) {
			 
			if ( newsChkbox.length == undefined ) {		// 객체는 존재하지만 해당 name을 가진 객체가 1개일때(배열로 인식되지 않았을 때)
				newsChkbox.checked = frm.newsChkboxAll.checked;
				if ( newsChkbox.checked == true) {
					var newsObjId = newsChkbox.id.replace("td_", "");
					depositMoney += Number(document.getElementById("money_"+newsObjId).value);
				}
			}
			else {
				for ( var i = 0; i < newsChkbox.length; i++ ) {
					newsChkbox[i].checked = frm.newsChkboxAll.checked;
					if ( newsChkbox[i].checked == true ) {
						var newsObjId = newsChkbox[i].id.replace("td_", "");
						depositMoney += Number(document.getElementById("money_"+newsObjId).value);
					}
				}
			}
		}

		var depTypeVal = frm.depType.options[frm.depType.selectedIndex].value;

		// 결손, 재무, 휴독, 미수이면
		if ( depTypeVal == "031" || depTypeVal == "032" || depTypeVal == "033" || depTypeVal == "044" ) {
			frm.depMoney.value = "0";
		} else {
			if ( Number(depositMoney) > 0 ) {
				frm.depMoney.value = Number(depositMoney);
			} else {
				frm.depMoney.value = "";
			}
		}

		frm.depMoney.focus();
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

	// 노출영역 초기화
	function initDisplaySector(spanObjId, trObjId, isDisplayInfo) {
		
		// 영역안내문 처리
		processDisplaySectorInfo(trObjId, isDisplayInfo);

		// 노출 목록 초기화
		var tmplist = document.getElementById(spanObjId);
		if ( tmplist ) { 
			var trNodes = tmplist.childNodes;
			
			if ( trNodes && trNodes.length > 1 ) {
				var tmpArray = new Array();
				var j = 0;
				for ( var i = 0; i < trNodes.length; i++ ) {	// 아래 루프에서만 처리할려면 삭제되면서 루프가 돌기 때문에 인덱스가 안맞아 처리불가능.
					if ( trNodes[i].nodeType == 1 ) {			// ie, ff, .. 각 브라우저에서 length 가 다르게 나올 수 있음. 그래서 nodeType 체크
						if ( trNodes[i].id != trObjId ) { 
							tmpArray[j++] = trNodes[i].id;				// 임시 배열에 id 저장
						}
					}
				}
				
				for ( var i = 0; i < tmpArray.length; i++ ) {
					var tmpTrObj = document.getElementById(tmpArray[i]);
					if ( tmpTrObj ) {
						tmpTrObj.parentNode.removeChild(tmpTrObj);
					}
				}
			}
		}
	}

	// 유효성 체크 - 구독정보 조회시
	function isValidateGetReader() {
		var frm = document.frm;
		
		if ( frm.gubun.value == "1" ) {
			if ( ! frm.readno.value ) {
				alert("고유번호를 입력해 주세요.");
				frm.readno.focus();
				return false;
			}
			if ( ! isNumber(frm.readno.value)) {
				alert("고유번호는 숫자만 입력 가능합니다.");
				frm.readno.value = "";
				frm.readno.focus();
				return false;
			}
			if ( frm.readno.value.length != 9 ) {
				alert("고유번호는 독자번호 9자리를 입력하셔야 합니다.");
				frm.readno.focus();
				return false;
			}			
		}
		else {
			if ( ! frm.gno.value ) {
				alert("구역번호를 입력해 주세요.");
				frm.gno.focus();
				return false;
			}
			if ( ! isNumber(frm.gno.value)) {
				alert("구역번호는 숫자만 입력 가능합니다.");
				frm.gno.value = "";
				frm.gno.focus();
				return false;
			}
			if ( ! frm.bno.value ) {
				alert("배달번호를 입력해 주세요.");
				frm.bno.focus();
				return false;
			}
			if ( ! isNumber(frm.bno.value)) {
				alert("배달번호는 숫자만 입력 가능합니다.");
				frm.bno.value = "";
				frm.bno.focus();
				return false;
			}
		}
	
		return true;
	}

	// 구독정보 목록을 가져온다.
	function getReaderNewsList() {
		
		if ( event.keyCode == 13 ) {
			event.returnValue = false;		// 입력폼이 하나 있을 때 강제 서브밋 되는 것을 방지.

			document.getElementById("newsChkboxAll").checked = false;

			if ( isValidateGetReader() ) {

				// 입금액 초기화
				document.getElementById("depMoney").value = "";

				// 노출영역 초기화 - 수금정보 목록
				initDisplaySector("sugmlist", "tr_tmpSugm", true);

				// 구독정보 상세정보 초기화
				document.getElementById("tmp_readtypenm").innerHTML = "";	// 수금방법
				document.getElementById("tmp_bno").innerHTML = "";			// 상태
				document.getElementById("tmp_dlvadrs1").innerHTML = "";		// 주소
				document.getElementById("tmp_dlvadrs2").innerHTML = "";		// 상세주소
				
				var url = "/collection/manual/ajaxGetNewsList.do";
				sendAjaxRequest(url, "frm", "post", setReaderNewsList);
			}
		}
	}

	// 가져온 구독정보 목록을 화면에 표시한다.
	function setReaderNewsList(responseHttpObj) {
		if (responseHttpObj) {
			try {
				var result = eval("(" + responseHttpObj.responseText + ")");
				if ( result == null ) {

					// 영역안내문 노출 - 구독정보 목록
					processDisplaySectorInfo("tr_tmpNews", true);

					document.getElementById("depMoney").readOnly = false;
					document.getElementById("depositType").value = "1";	// 개별입금
					
					alert("입력하신 고유번호나 구역/배달번호에 매칭되는 구독정보가 없습니다.");
					return ;
				}
				else {

					// 노출영역 초기화 - 구독정보 목록
					initDisplaySector("newslist", "tr_tmpNews", false);

					if ( result.length == 0 ) {

						// 영역안내문 노출 - 구독정보 목록
						processDisplaySectorInfo("tr_tmpNews", true);

						document.getElementById("depMoney").readOnly = false;
						document.getElementById("depositType").value = "1";	// 개별입금
						
						alert("입력하신 고유번호나 구역/배달번호에 매칭되는 구독정보가 없습니다.");
						return ;
					}
					else {
						// 다부수 독자이면 입금액을 변경 못하게한다.
						if ( result.length >= 2 ) {
							document.getElementById("depMoney").readOnly = true;
							document.getElementById("depositType").value = "2";	// 다부수입금
						}
						else {	// 개별 독자이면 입금액 조정 가능.
							document.getElementById("depMoney").readOnly = false;
							document.getElementById("depositType").value = "1";	// 개별입금
						}

						var tmpObjId = "";
						
						for ( var i = 0; i < result.length; i++ ) {
	
							// 구독정보 목록에 노출시킨다.
							var newsObjId = result[i].READNO + result[i].NEWSCD + result[i].SEQ;

							if ( result.length == 1 ) {
								tmpObjId = newsObjId;		// 구독정보가 하나이면 바로 입금처리 가능하게 하기 위해 id 를 저장해둔다.
							} 
							
							var eleTd1 = document.createElement("td");			// 선택 - 체크박스
							var chkbox;
							if ( navigator.userAgent.indexOf("MSIE") != -1 ) {
								chkbox = document.createElement('<input type="checkbox" id="'+'td_'+newsObjId+'" name="newsChkbox" onclick="setDepositMoney();" />');
							} else {
								chkbox = document.createElement("input");
								chkbox.setAttribute("type", "checkbox");
								chkbox.setAttribute("id", "td_" + newsObjId);
								chkbox.setAttribute("name", "newsChkbox");
							}

							// 화면에서는 구독정보에 있는 금액을 보여준다.
							// 수금정보에 있는 청구금액을 구독년월에 따라 계산하여 보여주려면 액션이 많아 부하가 생길 우려있음.
							// 결국 사용자가 영수증을 보고 금액을 수정할 수 있기 때문에 큰 문제 생길 소지는 없다고 생각됨.
							// 그리고 기존 The WON 에도 이렇게 구현되어 있음. - shlee
							var hiddenMoney;
							if ( navigator.userAgent.indexOf("MSIE") != -1 ) {
								hiddenMoney = document.createElement('<input type="hidden" id="'+'money_'+newsObjId+'" value="'+result[i].UPRICE+'" />');
							} else {
								hiddenMoney = document.createElement("input");
								hiddenMoney.setAttribute("type", "hidden");
								hiddenMoney.setAttribute("id", "money_" + newsObjId);
								hiddenMoney.setAttribute("value", result[i].UPRICE);	
							}
							eleTd1.appendChild(chkbox);
							eleTd1.appendChild(hiddenMoney);
	
							var eleTd2 = document.createElement("td");			// 독자번호
							eleTd2.innerHTML = result[i].READNO;
	
							var eleTd3 = document.createElement("td");			// 독자명
							eleTd3.innerHTML = result[i].READNM;

							var eleTd4 = document.createElement("td");			// 시퀀스
							eleTd4.innerHTML = Number(result[i].SEQ);
	
							var eleTd5 = document.createElement("td");			// 구역/배달
							eleTd5.innerHTML = result[i].GNO + "-" + result[i].BNO;
	
							var eleTd6 = document.createElement("td");			// 부수
							eleTd6.innerHTML = result[i].QTY;

							var eleTd7 = document.createElement("td");			// 금액
							eleTd7.innerHTML = makeCurrencyVal(result[i].UPRICE);
	
							var eleTd8 = document.createElement("td");			// 상태
							var bno = "" + result[i].BNO;
							if ( "999" == bno ) {
								eleTd8.innerHTML = "<font color=\"red\">중지</font>";
							}
							else {
								eleTd8.innerHTML = "정상";
							}

							var eleTd9 = document.createElement("td");			// 수금정보조회
							eleTd9.innerHTML = "<a href=\"javascript:getSugmList('"+result[i].READNO+"','"+result[i].NEWSCD+"','"+result[i].SEQ+"');\">조회</a>";
	
							var eleTr;
							if ( navigator.userAgent.indexOf("MSIE") != -1 ) {
								eleTr = document.createElement('<tr id="'+'trtd_'+newsObjId+'" bgcolor="ffffff" align="center">');
							} else {
								eleTr = document.createElement("tr");
								eleTr.setAttribute("id", "trtd_" + newsObjId);
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
							eleTr.appendChild(eleTd8);
							eleTr.appendChild(eleTd9);
	
							var newslist = document.getElementById("newslist");
							newslist.appendChild(eleTr);
						}

						// 입금년도에 커서를 넘긴다.
						document.getElementById("depYYYY").focus();

						// 구독정보가 1개라면 checkbox 선택 처리
						if ( result != null ) {
							if ( result.length == 1 ) {
								// 체크박스 선택
								document.getElementById("td_" + tmpObjId).checked = true;

								// 입금액 셋팅 함수 호출
								setDepositMoney();
							}
						}

						// 수금방법에 따라 입금액 처리
						changeDepType();
					}
				}
			} catch (e) {
				alert("오류 : " + e.description);
			}
		}
	}


	// 수금목록을 가져온다.
	function getSugmList(readno, newscd, seq) {

		if (readno && newscd && seq) {
			
			var sugmFrm = document.sugmFrm;

			sugmFrm.readno.value = readno;		// 독자번호
			sugmFrm.newscd.value = newscd;		// 매체코드
			sugmFrm.seq.value = seq;			// 시퀀스

			var url = "/collection/manual/ajaxGetSugmList.do";
			sendAjaxRequest(url, "sugmFrm", "post", setReaderSugmList);
		}
	}


	// 가져온 수금목록을 화면에 표시한다.
	function setReaderSugmList(responseHttpObj) {
		if (responseHttpObj) {
			try {
				var result = eval("(" + responseHttpObj.responseText + ")");
				if ( result == null ) {
					// 노출영역 초기화 - 수금정보 목록
					initDisplaySector("sugmlist", "tr_tmpSugm", true);
					
					alert("선택하신 구독정보에 대한 수금내역이 없습니다.");					
					return ;
				}
				else {
					
					// 노출영역 초기화 - 수금정보 목록
					initDisplaySector("sugmlist", "tr_tmpSugm", false);

					// 구독정보 상세정보 노출
					document.getElementById("tmp_readtypenm").innerHTML = result.READTYPENM;	// 수금방법
					var bno = "" + result.BNO;													// 상태
					if ( "999" == bno ) {
						document.getElementById("tmp_bno").innerHTML = "<font color=\"red\">중지</font>";
					}
					else {
						document.getElementById("tmp_bno").innerHTML = "정상";
					}
					
					document.getElementById("tmp_dlvadrs1").innerHTML = result.DLVADRS1;		// 주소
					document.getElementById("tmp_dlvadrs2").innerHTML = result.DLVADRS2;		// 상세주소

					// 수금정보 목록 노출
					if ( ! result.ITEMS || result.ITEMS.length == 0 ) {
						// 노출영역 초기화 - 수금정보 목록
						initDisplaySector("sugmlist", "tr_tmpSugm", true);
						
						alert("선택하신 구독정보에 대한 수금내역이 없습니다.");
						return ;
					}
					else {

						for ( var i = 0; i < result.ITEMS.length; i++ ) {
							
							// 수금정보 목록에 노출시킨다.
							var sugmObjId = result.ITEMS[i].READNO + result.ITEMS[i].NEWSCD + result.ITEMS[i].SEQ;
									
							var eleTd1 = document.createElement("td");			// 연도
							eleTd1.innerHTML = (result.ITEMS[i].SGBBCD == "044") ? "<font color='red'>"+result.ITEMS[i].YYYY+"</font>" : result.ITEMS[i].YYYY;
	
							var eleTd2 = document.createElement("td");			// 월
							eleTd2.innerHTML = (result.ITEMS[i].SGBBCD == "044") ? "<font color='red'>"+result.ITEMS[i].MM+"</font>" : result.ITEMS[i].MM;
	
							var eleTd3 = document.createElement("td");			// 입금일자
							var sndt = result.ITEMS[i].SNDT;
							if ( sndt && sndt.length >= 8 ) {
								sndt = sndt.substring(0, 4) + "-" + sndt.substring(4, 6) + "-" + sndt.substring(6, 8);
							}
							eleTd3.innerHTML = (result.ITEMS[i].SGBBCD == "044") ? "<font color='red'>"+sndt+"</font>" : sndt;
	
							var eleTd4 = document.createElement("td");			// 발행
							eleTd4.innerHTML = (result.ITEMS[i].SGBBCD == "044") ? "<font color='red'>"+makeCurrencyVal(result.ITEMS[i].BILLAMT)+"</font>" : makeCurrencyVal(result.ITEMS[i].BILLAMT);
	
							var eleTd5 = document.createElement("td");			// 입금액
							eleTd5.innerHTML = (result.ITEMS[i].SGBBCD == "044") ? "<font color='red'>"+makeCurrencyVal(result.ITEMS[i].AMT)+"</font>" : makeCurrencyVal(result.ITEMS[i].AMT);
	
							var eleTd6 = document.createElement("td");			// 구분
							eleTd6.innerHTML = (result.ITEMS[i].SGBBCD == "044") ? "<font color='red'>"+result.ITEMS[i].CNAME+"</font>" : result.ITEMS[i].CNAME;//CNAME
							
							var eleTr;
							if ( navigator.userAgent.indexOf("MSIE") != -1 ) {
								eleTr = document.createElement('<tr id="'+'trtdsugm_'+sugmObjId+'" bgcolor="ffffff" align="center">');
							} else {
								eleTr = document.createElement("tr");
								eleTr.setAttribute("id", "trtdsugm_" + sugmObjId);
								eleTr.setAttribute("bgcolor", "ffffff");
								eleTr.setAttribute("align", "center");
							}
							
							eleTr.appendChild(eleTd1);
							eleTr.appendChild(eleTd2);
							eleTr.appendChild(eleTd3);
							eleTr.appendChild(eleTd4);
							eleTr.appendChild(eleTd5);
							eleTr.appendChild(eleTd6);
	
							var sugmlist = document.getElementById("sugmlist");
							sugmlist.appendChild(eleTr);
						}
					}
				}
			} catch (e) {
				alert("오류 : " + e.description);
			}
		}
	}

	// 유효성 체크 - form submit
	function isValidate() {

		if ( isValidateGetReader() ) {

			var frm = document.frm;
			
			// 입금년월
			if ( ! frm.depYYYY.value ) {
				alert("입금년도를 입력해 주세요.");
				frm.depYYYY.focus();
				return false;
			}
			if ( ! isNumber(frm.depYYYY.value) ) {
				alert("입금년도는 숫자형태로 입력해 주세요.");
				frm.depYYYY.focus();
				return false;
			}
			if ( frm.depYYYY.value.length != 4 ) {
				alert("입금년도는 4자리로 입력해 주세요.");
				frm.depYYYY.focus();
				return false;
			}
			if ( frm.depYYYY.value.substring(0, 1) == "0" ) {
				alert("유효하지 않은 입금년도입니다. 다시 입력해 주세요.");
				frm.depYYYY.value = "";
				frm.depYYYY.focus();
				return false;
			}
			if ( ! frm.depMM.value ) {
				alert("입금월을 입력해 주세요.");
				frm.depMM.focus();
				return false;
			}
			if ( ! isNumber(frm.depMM.value) ) {
				alert("입금월은 숫자형태로 입력해 주세요.");
				frm.depMM.focus();
				return false;
			}
			if ( frm.depMM.value.length != 2 ) {
				alert("입금월은 2자리로 입력해 주세요.");
				frm.depMM.focus();
				return false;
			}
			if ( Number(frm.depMM.value) > 12 ) {
				alert("유효하지 않은 입금월입니다. 다시 입력해 주세요.");
				frm.depMM.value = "";
				frm.depMM.focus();
				return false;
			}

			// 구독정보 선택
			var isChecked = false;
			var newsChkbox = frm.newsChkbox;
			if ( newsChkbox != null ) {
				 
				if ( newsChkbox.length == undefined ) {		// 객체는 존재하지만 해당 name을 가진 객체가 1개일때(배열로 인식되지 않았을 때)
					if ( newsChkbox.checked == true ) {
						isChecked = true;
					}
				}
				else {
					for ( var i = 0; i < newsChkbox.length; i++ ) {
						if ( newsChkbox[i].checked == true ) {
							isChecked = true;
							break;
						} 
					}
				}
			}

			if ( isChecked == false ) {
				alert("입금처리할 구독정보를 아래 조회된 내역에서 선택해 주세요.\n구독정보가 여러개 있을 경우 직접 선택을 해야 합니다.");
				return false;
			}
			
			// 입금액
			if ( ! frm.depMoney.value ) {
				alert("입금액을 입력해 주세요.");
				frm.depMoney.focus();
				return false;
			}
			if ( ! isNumber(frm.depMoney.value) ) {
				alert("입금액은 숫자형태로 입력해 주세요.");
				frm.depMoney.focus();
				return false;
			}
		}
	
		return true;
	}


	// 입금처리
	function goDeposit() {

		if ( isValidate() ) {
	
			var frm = document.frm;

			var newsChkbox = frm.newsChkbox;
			if ( newsChkbox != null ) {

				// 입금처리할 때 사용할 JSON 배열 선언
				var depositArr = {};
				 
				if ( newsChkbox.length == undefined ) {		// 객체는 존재하지만 해당 name을 가진 객체가 1개일때(배열로 인식되지 않았을 때)
					if ( newsChkbox.checked == true ) {

						// 1. 구독정보 object id 를 가져온다.( readno(9) + newscd(3) + seq(4) )
						var tdObjId = newsChkbox.id;
						var newsObjId = tdObjId.replace("td_", "");

						// 2. java단에 넘길 데이터목록에 추가한다.
						var tmpMap = {};
						tmpMap.readno = newsObjId.substring(0,9);		// 독자번호
						tmpMap.newscd = newsObjId.substring(9,12);		// 매체코드
						tmpMap.seq = newsObjId.substring(12,16);		// 시퀀스
	
						depositArr[newsObjId] = tmpMap;	// 전역배열에 저장(연관배열 형태로 저장)
					}
				}
				else {
					if ( newsChkbox.length > 0 ) {
						for ( var i = 0; i < newsChkbox.length; i++ ) {
							if ( newsChkbox[i].checked == true ) {
	
								// 1. 구독정보 object id 를 가져온다.( readno(9) + newscd(3) + seq(4) )
								var tdObjId = newsChkbox[i].id;
								var newsObjId = tdObjId.replace("td_", "");
								
								// 2. java단에 넘길 데이터목록에 추가한다.
								var tmpMap = {};
								tmpMap.readno = newsObjId.substring(0,9);		// 독자번호
								tmpMap.newscd = newsObjId.substring(9,12);		// 매체코드
								tmpMap.seq = newsObjId.substring(12,16);		// 시퀀스
			
								depositArr[newsObjId] = tmpMap;	// 전역배열에 저장(연관배열 형태로 저장)
							} 
						}
					}
				}

				if ( depositArr ) {
					frm.depositArr.value = Object.toJSON(depositArr);		// JSON 객체로 변환

					if ( ! frm.depositArr.value ) {
						// 입금액 초기화
						document.getElementById("depMoney").value = "";
						
						alert("입금처리할 정보가 없습니다.");
						return ;
					}
					else {
						// 3. 입금처리 
						var url = "/collection/manual/ajaxEachDepositProcess.do";
						sendAjaxRequest(url, "frm", "post", goDepositLater);
					}
				}
			}
		}
	}

	// 입금처리 후 화면에서의 처리
	function goDepositLater(responseHttpObj) {
		if (responseHttpObj) {
			try {
				var result = eval("(" + responseHttpObj.responseText + ")");
				if ( result == null ) {
					// 입금액 초기화
					document.getElementById("depMoney").value = "";
					
					alert("수금처리가 정상적으로 완료되지 않았습니다.");
					return ;
				}
				else {
					if ( result.ITEMS != null ) {
						if ( result.ITEMS.length == 0 ) {
							// 입금액 초기화
							//document.getElementById("depMoney").value = "";

							// 알림메세지 뿌림.
							if ( result.MSG ) {
								alert(result.MSG);
							} else {
								alert("수금처리가 정상적으로 완료되지 않았습니다.");
							}
							
							return ;
						}
						else {

							// 영역안내문 삭제 - 입금내역 목록
							processDisplaySectorInfo("tr_tmpUpdate", false);
							
							for ( var i = 0; i < result.ITEMS.length; i++ ) {

								var eleTd1 = document.createElement("td");			// 독자번호
								eleTd1.innerHTML = result.ITEMS[i].READNO;					
		
								var eleTd2 = document.createElement("td");			// 독자명
								eleTd2.innerHTML = result.ITEMS[i].READNM;

								var eleTd3 = document.createElement("td");			// 시퀀스
								eleTd3.innerHTML = Number(result.ITEMS[i].SEQ);
		
								var eleTd4 = document.createElement("td");			// 주소
								eleTd4.innerHTML = result.ITEMS[i].DLVADRS1 + " " + result.ITEMS[i].DLVADRS2;
		
								var eleTd5 = document.createElement("td");			// 지명
								eleTd5.innerHTML = result.ITEMS[i].NEWSNM;
		
								var eleTd6 = document.createElement("td");			// 월분
								eleTd6.innerHTML = result.ITEMS[i].YYMM;
		
								var eleTd7 = document.createElement("td");			// 금액
								eleTd7.innerHTML = makeCurrencyVal(result.ITEMS[i].AMT);
		
								var eleTd8 = document.createElement("td");			// 수금방법
								eleTd8.innerHTML = result.ITEMS[i].SGBBNM;
		
								var eleTr;
								if ( navigator.userAgent.indexOf("MSIE") != -1 ) {
									eleTr = document.createElement('<tr bgcolor="ffffff" align="center">');
								} else {
									eleTr = document.createElement("tr");
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
								eleTr.appendChild(eleTd8);

								var updatelist = document.getElementById("updatelist");
								updatelist.appendChild(eleTr);

								// 화면 노출용 변수 처리
								totalCount++;
								totalMoney += Number(result.ITEMS[i].AMT);

								document.getElementById("totalCount").innerHTML = makeCurrencyVal(new String(totalCount));
								document.getElementById("totalMoney").innerHTML = makeCurrencyVal(new String(totalMoney));
							}
						}
					}

					// 체크박스 초기화
					frm.newsChkboxAll.checked = false;
					allCheck();

					// 알림메세지 뿌림.
					if ( result.MSG ) {
						alert(result.MSG);
					}

					// 입금액 초기화
					document.getElementById("depMoney").value = "";
				}
			} catch (e) {
				alert("오류 : " + e.description);

				// 입금액 초기화
				document.getElementById("depMoney").value = "";
			}
		}
	}

//-->
</script>
<div><span class="subTitle">개별/다부수입금</span></div>
<form id="frm" name="frm" method="post">
	<input type="hidden" id="depositArr" name="depositArr" />	<!-- 입금처리할 JSON Map -->
	<input type="hidden" id="depositType" name="depositType" value="1" />	<!-- 1:개별 구독정보 입금, 2:다부수 구독정보 입금 -->
	<div style="overflow: hidden;">
		<!-- left -->
		<div style="float: left; width: 600px; padding-right: 10px">
			<!-- top -->
			<div>
				<div style="padding-bottom: 10px;">
				<table class="tb_list_a">
					<colgroup>
						<col width="80px">
						<col width="120px">
						<col width="80px">
						<col width="120px">
						<col width="80px">
						<col width="120px">
					</colgroup>
					<tr>
						<th>구분</th>
						<td>
							<select id="gubun" name="gubun" onchange="changeType();">
								<option value="1">고유번호</option>
								<option value="2">구역/배달</option>						    		
							</select>
						</td>
						<th>매체</th>
						<td>
							<select id="newscd" name="newscd">
								<c:forEach items="${agencyNewsList}" var="list">
								<option value="${list.NEWSCD}" <c:if test="${list.NEWSCD eq newscd}">selected</c:if>>${list.CNAME}</option>
								</c:forEach>
							</select>
						</td>
						<th>입금일자</th>
						<td>
							<!-- <input type='text' id="" name="" class='box_n' /> -->
							<input type="text"name="edate" value="<c:out value='${edate}' />" readonly="readonly" onclick="Calendar(this)" style="width: 90%;">
						</td>
					</tr>
				</table>
				</div>
				<table class="tb_list_a">
					<colgroup>
						<col width="130px">
						<col width="130px">
						<col width="130px">
						<col width="130px">
						<col width="80px">
					</colgroup>
					<tr>
						<th>
							<span id="gubun_1">고유번호</span>
							<span id="gubun_2" style="display:none;">구역/배달</span>
						</th>
						<th>입금년월</th>
						<th>입금액</th>
						<th>입금방법</th>
						<th rowspan="2">
							<img src="/images/bt_eep.gif" style="vertical-align: middle; border: 0; cursor: pointer;" onclick="goDeposit();">&nbsp;
							<!-- <a href="#"><img src="/images/bt_end02.gif" border="0" align="absmiddle"></a> -->
						</th>
					 </tr>
					<tr>
						<td>
							<span id="gubun_11">
							<input type='text' id="depReadno" name="readno" maxlength="9" style="width: 95%" onkeydown="getReaderNewsList();">
							</span>
							<span id="gubun_22" style="display:none;">
							<input type='text' id="gno" name="gno" maxlength="3" style="width: 95%" onkeydown="getReaderNewsList();">&nbsp;
							<input type='text' id="bno" name="bno" maxlength="3" style="width: 95%" onkeydown="getReaderNewsList();">
							</span>
						</td>
						<td>
							<input type="text" id="depYYYY" name="depYYYY" value="${fn:substring(last_yymm, 0, 4)}" maxlength="4" onkeydown="onlyNumber();" style="width: 35px" > 년 
							<input type="text" id="depMM" name="depMM" value="${fn:substring(last_yymm, 4, 6)}" maxlength="2" onkeydown="onlyNumber();" style="width: 35px"> 월
						</td>
						<td>
							<input type='text' id="depMoney" name="depMoney" maxlength="7" onkeydown="onlyNumber();" style="width: 95%">
						</td>
						<td>
							<select name="depType" id="depType" style="width: 95%" onchange="changeDepType();">
								<c:forEach items="${sgTypeList}" var="list">
								<option value="${list.CODE }">${list.CNAME }</option>
								</c:forEach>
							</select>
						</td>
					</tr> 						  						  						  						  						  						  						  		   
				</table>
				<div style="padding: 5px 0;">
					<span style="color:red;">※ 고유번호나 구역/배달번호 란에 입력한 후 엔터키를 누르면 구독정보가 조회되고 <br />&nbsp;&nbsp;한번 더 엔터키를 누르면 자동 입금처리됩니다.</span>
				</div>
			</div>
			<!-- //top -->
			<!-- middle -->
			<div style="border: 1px solid #e5e5e5;">
				<div style="padding: 5px;">
					<div style="height:100px; overflow-y:scroll; overflow-x:none; border: 0px solid red">
					<table class="tb_list_a">
						<colgroup>
							<col width="30px">
							<col width="80px">
							<col width="75px">
							<col width="95px">
							<col width="90px">
							<col width="45px">
							<col width="45px">
							<col width="45px">
							<col width="80px">
						</colgroup>
						<tr>
							<th><input type="checkbox" id="newsChkboxAll" onclick="allCheck();" style="border: 0;" /></th>
							<th>독자번호</th>
							<th>독자명</th>
							<th>구분번호</th>
							<th>구역/배달</th>
							<th>부수</th>
							<th>금액</th>
							<th>상태</th>
							<th>수금내역</th>
						</tr>
						<span id="newslist">
						<tr id="tr_tmpNews" bgcolor="ffffff" align="center">	<!-- 이 코드 지우지 마세요. -->
							<td colspan="9">개별/다부수 구독정보가 나오는 영역입니다.</td>
						</tr>
						</span>
					</table>
					</div>
				</div>
				<div style="padding: 5px 0;">
					<span style="color:red;">※ 다부수 입금처리는 구독정보의 체크박스를 선택 후 입금버튼을 눌러주세요.</span>
				</div>
			</div>
			<!-- //middle -->
			<!-- bottom -->
			<div style="padding-top: 10px;">
				<table class="tb_list_a">
					<colgroup>
						<col width="300px;">
						<col width="300px;">
					</colgroup>
					<tr>
						<th>입금건수</th>
						<th>입금금액</th>
					</tr>
					<tr>
						<td><span id="totalCount">0</span> 건</td>
						<td><span id="totalMoney">0</span> 원</td>
					</tr>
				</table>
				<div style="height:450px;overflow-y:scroll;">
				<table class="tb_list_a" style="width: 583px;">
					<colgroup>
						<col width="100px;">
						<col width="73px;">
						<col width="100px;">
						<col width="50px;">
						<col width="50px;">
						<col width="50px;">
						<col width="50px;">
						<col width="100px;">
					</colgroup>
					<tr>
						<th>독자번호</th>
						<th>독자명</th>
						<th>구분번호</th>
						<th>주소</th>
						<th>지명</th>
						<th>월분</th>
						<th>금액</th>
						<th>수금방법</th>
					</tr>
					<span id="updatelist">
						<tr id="tr_tmpUpdate" bgcolor="ffffff" align="center">
							<td colspan="8">입금처리된 수금내역 목록이 보이는 영역입니다.</td>
						</tr>
					</span>		
				</table>
				</div>
			</div>
			<!-- //bottom -->
		</div>
		<!-- //left -->
		<!-- right -->
		<div style="float: left;">
			<div style="height: 39px;">&nbsp;</div>
			<div style="width: 395px; border: 1px solid #e5e5e5; padding: 5px">
				<table class="tb_list_a" style="width: 395px;">
					<colgroup>
						<col width="65px">
						<col width="133px">
						<col width="65px">
						<col width="132px">
					</colgroup>
					<tr>
						<th>수금방법</th>
						<td id="tmp_readtypenm" width="34%" bgcolor="ffffff" align="left"></td>
						<th><b>상태</b></th>
						<td id="tmp_bno" width="34%" bgcolor="ffffff" align="left"></td>
					</tr>
					<tr>
						<th>주소</th>
						<td id="tmp_dlvadrs1" colspan="5" align="left"></td>
					</tr>
					<tr>
						<th>상세주소</th>
						<td id="tmp_dlvadrs2" colspan="5" align="left"></td>
					</tr>
				</table>
				<div style="height: 5px;">&nbsp;</div>	
				<div style="width: 395px;height:608px;overflow-y:scroll;">
					<table class="tb_list_a" style="width: 378px;">
						<colgroup>
							<col width="50px">
							<col width="30px">
							<col width="90px">
							<col width="80px">
							<col width="80px">
							<col width="48px">
						</colgroup>
						<tr>
							<th>연도</th>
							<th>월</th>
							<th>입금일자</th>
							<th>청구액</th>
							<th>입금액</th>
							<th>구분</th>
						</tr>
						<span id="sugmlist">
							<tr id="tr_tmpSugm" bgcolor="ffffff" align="center">
								<td colspan="6">수금내역 조회 클릭 시 최근 2년내 수금내역이 보이는 영역입니다.</td>
							</tr>
						</span>
					</table>
				</div>
			</div>
		</div>
		<!-- //right -->
	</div>
</form>		
<!-- 수금내역 조회용 form -->
<form id="sugmFrm" name="sugmFrm" method="post">
	<input type="hidden" id="readno" name="readno" />
	<input type="hidden" id="newscd" name="newscd" />
	<input type="hidden" id="seq" name="seq" />
</form>

