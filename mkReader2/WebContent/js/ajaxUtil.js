	// Ajax 통신에 사용될 XMLHTTP 객체를 생성 (Cross Browsing)
	function createHttpRequest() {
		if ( window.ActiveXObject ) {
			try {
				// IE6
				return new ActiveXObject("Msxml2.XMLHTTP");
			}
			catch (e) {
				try {
					// IE4, IE5
					return new ActiveXObject("Microsoft.XMLHTTP");
				}
				catch (e2) {
					return null;
				}
			}
		}
		else if ( window.XMLHttpRequest ) {
			// Mozilla, FireFox, Opera, Safari, Konqueror3
			return new XMLHttpRequest();
		}
		else {
			return null;
		}
	}
	
	function sendAjaxData(url, query, callback) {
		xmlhttp.open('POST', url, true);
		xmlhttp.onreadystatechange = callback;
		xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=utf-8");
		xmlhttp.send(query);
	}

	/*
		checkbox 의 복수 선택시 선택된 항목을 query string 으로 만들어주는 함수
		checkboxs = document.getElementsByName() 함수로 가져온 checkbox 의 배열
	*/
	function checkboxGetQueryBuilder( checkboxs, name ) {
		var query = "";
		
		if ( checkboxs ) {
			for ( var i=0; i<checkboxs.length; ++i ) {
				if ( checkboxs[i].checked ) {
					if ( query.length != 0 ) {
						query += "&";
					}
					if ( name ) {
						query += name + "=" + checkboxs[i].value;
					}
					else {
						query += checkboxs[i].name + "=" + checkboxs[i].value;
					}
				}
			}
		}
		
		return query;
	}
	
	function sendAjaxRequest(responseURL, dataParam, method, callbackFunc) {

		var parameters;
		
		// 파라미터 설정 (연관배열 or 폼 )
		if(dataParam instanceof Object)  {
			parameters = dataParam;		// 연관배열
		} else {
			parameters = eval("Form.serialize(" + dataParam + ")");		// 폼
		}

		new Ajax.Request(
			responseURL,
			{
				method : method,
				parameters : parameters,
				
				//onLoading : function() {alert("ajax onLoading");},
				
				onSuccess : function(transport) {
					var responseTxt = transport.responseText || "no response text";
					
					if ( callbackFunc == null ) {
						alert("Ajax onSuccess\n\n" + responseTxt);
					} else {
						callbackFunc(transport);
					}
				}
				
				//onFailure : function() {alert("ajax onFailure");},
				//onComplete : function() {alert("ajax onComplete");}
			}
		);
	}