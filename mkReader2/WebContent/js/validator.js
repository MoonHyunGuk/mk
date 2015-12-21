	// 아스키코드 범위를 이용한 한글 입력 검사
	function isName( value ) {
		if ( value.length > 0 ) {
			for ( var i=0; i<value.length; ++i ) {
				if ( value.charCodeAt(i) < 128 ) {	// 웬만한 특수문자 숫자 영문자는 여기 다 포함된다.
					return false;
				}
			}
			
			return true;
		}

		return false;		// 내용없음
	}
	
	// 정규표현식을 이용한 이메일 유효성 검사.
	function isEmail(value) {
		var regExp = /^[_a-zA-Z0-9]+([-+.][_a-zA-Z0-9]+)*@[_a-zA-Z0-9]+([-.][_a-zA-Z0-9]+)*\.[_a-zA-Z0-9]+([-.][_a-zA-Z0-9]+)*$/;
		if (regExp.test(value)) {
			return true;
		}
		return false;
	}
	
	// 정규표현식을 이용한 전화번호 유효성 검사.
	function checkPhone( phone ) {
		var regExp = /^[0]\d{1,2}\-\d{3,4}\-\d{4}$/;

		if ( phone.length > 0 ) {
			if ( regExp.test( phone ) ) {
				return true;
			}
		}
		
		return false;
	}

	// 전화번호 유효성 검사 (3개로 나눠진 버전)
	function checkPhone2( phone1, phone2, phone3 ) {
		var regExp1 = /^[0]\d{1,2}$/;
		var regExp2 = /^\d{3,4}$/;
		var regExp3 = /^\d{4}$/;

		if ( phone1.length > 0 && phone2.length > 0 && phone3.length > 0 ) {
			if ( regExp1.test( phone1 ) && regExp2.test( phone2 ) && regExp3.test( phone3 ) ) {
				return true;
			}
		}

		return false;
	}
	
	/*
		전화번호 유효성 검사
		phone1 - 필수인자
		phone2, phone3 - 선택인자(전화번호가 3개의 부분으로 나눠진 경우)
	*/
	function isPhone( phone1, phone2, phone3 ) {
		if ( phone1 && phone2 && phone3 ) {
			return checkPhone2( phone1, phone2, phone3 );
		}
		else if ( phone1 && !phone2 && !phone3 ) {
			return checkPhone( phone1 );
		}
		
		return false;	// 필수인자인 phone1 이 빈값인경우
	}

	// radio, checkbox 의 체크 유무 확인
	function isChecked( elements ) {
		var isChecked = false;

		for ( var i=0; i<elements.length; ++i ) {
			if ( elements[i].checked ) {
				isChecked = true;
				break;
			}
		}

		return isChecked;
	}
	
	// checkbox 배열에서 value 에 해당하는 항목의 checked 여부 확인
	function isCheckedByValue( checkbox, value ) {
		var isCheck = false;
		
		if ( checkbox && value ) {
			for ( var i=0; i<checkbox.length; ++i ) {
				if ( checkbox[i].value == value ) {
					if ( checkbox[i].checked ) {
						isCheck = true;
						break;
					}
				}
			}
		}

		return isCheck;
	}
	
	/*
	 *	pass1, pass2 - 문자열
	 *	length - 숫자 (비밀번호의 제한길이, 선택적 인자)
	 */
	function checkPassword( pass1, pass2, length ) {
		if ( !pass1 || ( pass1 != pass2 ) ) {
			return false;
		}
		if ( length && pass1.length < length ) {
			return false;
		}
		
		return true;
	}
	
	/*
	 *	시작일과 종료일 날짜 범위를 확인하는 함수
	 *	startDate 와 endDate 는 모두 javascript 의 Date 객체
	 */
	function verifyDateRange( startDate, endDate ) {
		if ( startDate.getTime() > endDate.getTime() ) {
			return false;
		}
		
		return true;
	}
	
	/*
	 *	숫자인지 검사하는 정규표현식
	 */
	function isNumber( value ) {
		var regExp = /^[0-9]+$/;
		
		if ( regExp.test( value ) ) {
			return true;
		}
		
		return false;
	}
	
	/*
	 * 우편번호인지 검사하는 함수
	 */
	function isZipCode(zipCode1, zipCode2) {
		if ( !isNumber(zipCode1) || !isNumber(zipCode2) ) {
			return false;
		}
		else if ( zipCode1.length != 3 || zipCode2.length != 3) {
			return false;
		}
		
		return true;
	}
	
	/*
	 *	jumin1 - 주민번호 앞자리(문자형)
	 *	jumin2 - 주민번호 뒷자리(문자형)
	 *	2009.04.28 - 외국인 등록번호 확인 로직 추가 (한영준)
	 */
	function isJumin( jumin1, jumin2 ) {
		
		var exp1 = /^\d{6}$/; // 6자리의 숫자인지
		var exp2 = /^\d{7}$/; // 7자리의 숫자인지
		
		if ( exp1.test( jumin1 ) && exp2.test( jumin2 ) ) {
			var arrNum = new Array( 13 ); // 주민번호를 배열에 저장
			var digit = new Array( 2, 3, 4, 5, 6, 7, 8, 9, 2, 3, 4, 5 ); // 가중치 값 저장
			var magicKey = 11;
			var sum = 0;
			var i = 0;
			var j = 0;
			
			// 6자리 7자리로 나눠진 주민번호를 하나씩 떼서 배열에 넣는다
			for ( i=0; i<jumin1.length; ++i ) {
				arrNum[i] = parseInt( jumin1.substr( i, 1 ), 10 );
			}
			for ( j=0; j<jumin2.length; ++i, ++j ) {
				arrNum[i] = parseInt( jumin2.substr( j, 1 ), 10 );
			}
			
			// 주민번호의 각각의 자리에 맞는 가중치값을 곱한 합을 구함
			for ( var k=0; k<12; ++k ) {
				sum += digit[k] * arrNum[k];
			}
			
			// 외국인 등록번호
			if ( arrNum[6] == 5 || arrNum[6] == 6 || arrNum[6] == 7 || arrNum[6] == 8) {
				
				var odd = arrNum[7] * 10 + arrNum[8];
				
				if ( odd % 2 != 0 ) {
					return false;
				}
				if ( ( arrNum[11] != 6 ) && ( arrNum[11] != 7 ) && ( arrNum[11] != 8 ) && ( arrNum[11] != 9 ) ) {
					return false;
				}
				
				sum = ( ( ( magicKey - ( sum % magicKey ) ) % 10 ) + 2 ) % 10;
			}
			else { // 주민등록 번호
				
				sum = ( magicKey - ( sum % magicKey ) ) % 10;
			}
			
			// 최종검증
			if ( sum == arrNum[12] ) {
				return true;
			}
		}
		
		return false;
	}
	
	/*
	 *	숫자가 아닌 문자를 제거해준다
	 */
	function removeNotTheNumbers( value ) {
		return value.replace( /[^0-9]/g, "" );
	}
	
	/*
	 *	3자리마다 ,를 추가하는 함수
	 *	element - input type="text"
	 */
	function makeCurrency( element ) {
		var start = 0;
		var end = 0;
		var result = "";
		var strMoney = removeNotTheNumbers( element.value );

		if ( strMoney.length > 3 ) {
			end = strMoney.length % 3;
			
			if (end == 0) {
				end += 3;
			}
			// 앞부분
			result = strMoney.substring( start, end ) + ",";
			start += end;
			end += 3;
			// 가운데
			while ( end != strMoney.length ) {
				result += strMoney.substring( start, end ) + ",";
				start += 3;
				end += 3;
			}
			// 마지막
			result += strMoney.substring( start, end );
			element.value = result;
			return;
		}
		else {
			element.value = strMoney;
			return;
		}
	}
	
	
	/*
	 *	3자리마다 ,를 추가하는 함수
	 *	element - input type="text"
	 */
	function makeCurrencyVal( val ) {
		if ( ! val ) {
			return "0";
		}
		
		var start = 0;
		var end = 0;
		var result = "";
		var strMoney = removeNotTheNumbers( val );
		if ( ! strMoney || strMoney == "0" ) {
			return strMoney;
		}
		
		var retVal = "";

		if ( strMoney.length > 3 ) {
			end = strMoney.length % 3;
			
			if (end == 0) {
				end += 3;
			}
			// 앞부분
			result = strMoney.substring( start, end ) + ",";
			start += end;
			end += 3;
			// 가운데
			while ( end != strMoney.length ) {
				result += strMoney.substring( start, end ) + ",";
				start += 3;
				end += 3;
			}
			// 마지막
			result += strMoney.substring( start, end );
			retVal = result;
		}
		else {
			retVal = strMoney;
		}
		
		return retVal;
	}
	
	/**
	 * 만 나이 계산
	 * @param jumin1	주민번호 앞자리
	 * @param jumin2	주민번호 뒷자리
	 * @return			만나이
	 */
	function getFullAge(jumin1, jumin2) {
		
		var fullAge = 0;
		
		if (jumin1 && jumin2) {
			
			var date = new Date();
			var year = date.getFullYear();
			var month = date.getMonth() + 1;
			var day = date.getDate();

			var chkAge = "";
			// 1900 년대 태어난 사람들
			if (jumin2.substring(0, 1) == "1" || jumin2.substring(0, 1) == "2") {
				chkAge = "19" + jumin1.substring(0, 2);
			}
			else { // 1900년대가 아닌 사람들(이전은 없을테니.. 2000이후 태어난 사람들)
				chkAge = "20" + jumin1.substring(0, 2);
			}

			fullAge = year - parseInt(chkAge, 10);
			
			if (month < parseInt(jumin1.substring(2, 4), 10)) {
				fullAge = fullAge -1;
			}
			else if (month == parseInt(jumin1.substring(2, 4), 10)) {
				if (day < parseInt(jumin1.substring(4), 10)) {
					fullAge = fullAge -1 ;
				}
			}
		}
		
		return fullAge;
	}
	
	function passwd_check(passwd) {
		
		var passwd_val = passwd.value;
		var c_cnt = 0;
		var n_cnt = 0;
		var tmp = "";
		
		if (!passwd_val) {
			alert("비밀번호는 반드시 입력하셔야 합니다.");
			passwd.focus();
			return false;
		}
		else if (passwd_val.length < 6) {
			alert("비밀번호는 6자리 이상 입력하셔야 합니다.");
			passwd.focus();
			return false;
		}
		
		for (var k = 0 ; k < passwd_val.length ; k++ ) {
			if (isNaN(parseInt(passwd_val.charAt(k))))
				c_cnt++;
		    else
		    	n_cnt++;
		}
		
		if (c_cnt < 1 || n_cnt < 1) {
			alert("비밀번호는 영자와 숫자를 혼합하셔야 합니다.");
			passwd.focus();
			return false;
		}
		else {
			for (var i = 0; i < passwd_val.length; i++) {
				tmp = passwd_val.charAt(i);
				if ( (i > 0) && (tmp == passwd_val.charAt(i-1)) ) { 
					if ( (i > 1) && (tmp == passwd_val.charAt(i-2)) ) {
						alert('3자리 이상 연속된 문자는 비밀번호로 사용할 수 없습니다.');
						passwd.focus();
						return false;
					}
				}
			}
		}
		
		return true;
	}
	
	function passwd_check_char(pwd1_n, pwd2_n, js_ssn, tel1_n, tel2_n) {
		
		var pw1 = document.getElementById(pwd1_n).value;
		var pw2 = document.getElementById(pwd2_n).value;
		var tel1 = "";
		if (tel1_n) {
			tel1 = document.getElementById(tel1_n).value;
		}
		var tel2 = "";
		if (tel2_n) {
			tel2 = document.getElementById(tel2_n).value;
		}
		var pw_ssn = document.getElementById(js_ssn).value;
		var chk1, chk2, chk3, chk4, chk5, chk6, chk7, chk8, chk9, chk10;

		if ((tel1 != "" && pw1.indexOf(tel1) > -1) || tel2 != "" && (pw1.indexOf(tel2) > -1)) {
			alert("전화번호를 비밀번호로 사용하실 수 없습니다.");
			document.getElementById(pwd1_n).value = "";
			document.getElementById(pwd2_n).value = "";
			document.getElementById(pwd1_n).focus();
			
			return false;
		}
		
		for (var j=0; j<pw1.length-4; j++) {
			var ch = pw1.charCodeAt(j);
			if ((eval(ch+2) == pw1.charCodeAt(j+1)) && (eval(ch+4) == pw1.charCodeAt(j+2)) && (eval(ch+6) == pw1.charCodeAt(j+3))) {
				alert("등차인 숫자를 비밀번호로 사용하실 수 없습니다.");
				document.getElementById(pwd1_n).value = "";
				document.getElementById(pwd2_n).value = "";
				document.getElementById(pwd1_n).focus();
				return false;
			}
		}
		
		chk1 = pw_ssn.charAt(0) + pw_ssn.charAt(1) + pw_ssn.charAt(2) + pw_ssn.charAt(3);
		chk2 = pw_ssn.charAt(1) + pw_ssn.charAt(2) + pw_ssn.charAt(3) + pw_ssn.charAt(4);
		chk3 = pw_ssn.charAt(2) + pw_ssn.charAt(3) + pw_ssn.charAt(4) + pw_ssn.charAt(5);
		chk4 = pw_ssn.charAt(3) + pw_ssn.charAt(4) + pw_ssn.charAt(5) + pw_ssn.charAt(6);
		chk5 = pw_ssn.charAt(4) + pw_ssn.charAt(5) + pw_ssn.charAt(6) + pw_ssn.charAt(7);
		chk6 = pw_ssn.charAt(5) + pw_ssn.charAt(6) + pw_ssn.charAt(7) + pw_ssn.charAt(8);
		chk7 = pw_ssn.charAt(6) + pw_ssn.charAt(7) + pw_ssn.charAt(8) + pw_ssn.charAt(9);
		chk8 = pw_ssn.charAt(7) + pw_ssn.charAt(8) + pw_ssn.charAt(9) + pw_ssn.charAt(10);
		chk9 = pw_ssn.charAt(8) + pw_ssn.charAt(9) + pw_ssn.charAt(10) + pw_ssn.charAt(11);
		chk10 = pw_ssn.charAt(9) + pw_ssn.charAt(10) + pw_ssn.charAt(11) + pw_ssn.charAt(12);

		if ( pw1.indexOf(chk1) > -1 || pw1.indexOf(chk2) > -1 || pw1.indexOf(chk3) > -1 ||
				pw1.indexOf(chk4) > -1 || pw1.indexOf(chk5) > -1 || pw1.indexOf(chk6) > -1 ||
				pw1.indexOf(chk7) > -1 || pw1.indexOf(chk8) > -1 || pw1.indexOf(chk9) > -1 ||
				pw1.indexOf(chk10) > -1 ) {
			alert("비밀번호에 주민번호의 일부분을 사용하실 수 없습니다.");
			document.getElementById(pwd1_n).value = "";
			document.getElementById(pwd2_n).value = "";
			document.getElementById(pwd1_n).focus();
			return false;
		}
		
		return true;
	}
	
	
	//입력 자릿수만큼 입력을 다 받게되면 자동으로 다음 입력엘리먼트로 focus 이동
	function autoTab(currId, nextId, maxLength) {

		if ( window.event.keyCode == 9 )		// 입력된 키가 tab key 라면 그냥 종료
			return;
		
		if ( currId && nextId && maxLength ) {
		
			var curr = document.getElementById(currId);
			var next = document.getElementById(nextId);
	
			if ( curr && curr.value && next ) {
				if ( curr.value.length >= maxLength ) {
					next.focus();
				}
			}
		}
	}
	
	/**
	 * element의 포커스 이동
	 * 
	 * @param currId	현재 포커스의 element ID
	 * @param nextId	이동 해야할 포커스의 element ID
	 * @param length	현재 input element의 value.length 와 비교할 값
	 * @return			없음
	 */
	function moveNextInput(currId, nextId, length) {
		
		if ( currId && nextId ) {
		
			var curr = document.getElementById(currId);
			var next = document.getElementById(nextId);
			
			if ( length ) {
				if ( curr.value && curr.value.length >= length ) {
					next.focus();
				}
			}
			else {
				next.focus();
			}
		}
	}
