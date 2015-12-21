<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> 
<head>
<script type="text/javascript" src="/js/common.js"></script>
<link rel='stylesheet' type='text/css' href='/css/mkcrm.css'/>
<style type="text/css">
	.box_Popup{width: auto; padding: 10px;}

	.subTitle{font-family: NanumGothicWeb,dotum,Helvetica,sans-serif;/*"HY헤드라인M",Verdana, sans-serif; */font-weight: bold; font-size: 16px; letter-spacing: -1px; padding-bottom: 10px;}
	
	.tb_search {margin:0 auto; text-align:center; border-collapse:collapse; font:normal 12px Gulim, "굴림", Verdana, Geneva; }
	.tb_search th, .tb_search td {padding:8px 1px; }
	.tb_search th {text-align:center; border:1px solid #e5e5e5; background-color: #f9f9f9; font-weight: bold/*#e48764*//*#e16536 */;}
	.tb_search td {text-align:left; border:1px solid #e5e5e5; background-color: #fff; padding-left: 10px;}
</style>
<script type="text/javascript">
	var sgBgmm;

	function insertSgBgmm(){
		sgBgmm = document.getElementById("sgBgmm").value;

		if(!validateSgBgmm()){
			return;
		}

		window.returnValue = sgBgmm;
		window.close();
	}
	
	function validateSgBgmm(){
		if(!cf_checkNull("sgBgmm", "수금시작월")){
			return false;
		}else{
	        if(sgBgmm.length != 6){
	        	alert('수금시작월을 YYYYMM 형태로 입력해 주세요.');
				return false;
	        }else{
	        	if( Number(sgBgmm.substring(4,6)) < 1 ||  Number(sgBgmm.substring(4,6)) > 12  ){
	        		alert('수금시작월을 YYYYMM 형태로 입력해 주세요.');
					return false;
	       		}
	       	}
		}
		return true;
	}

</script>
</head>
<title>수금시작월 입력</title>
<body>
	<!-- 팝업 DIV -->
	<div class="box_Popup">
		<!-- 타이틀 DIV -->
		<div style="padding-left: 5px; padding-bottom: 5px; border-bottom:7px solid #f68600;"> 
			<span class="subTitle">수금시작월 입력</span>
		</div>
		<!--// 타이틀 DIV -->
		
		<!-- 컨텐츠 DIV -->
		<div style="padding: 10px 0;">
			<table class="tb_search" style="width: 100%">
				<colgroup>
					<col width="30%">
					<col width="70%">
				</colgroup>
				<tr>
					<th>수금시작월</th>
					<td>
						<input type="text" id="sgBgmm" name="sgBgmm" value=""/> e.g) 201309
					</td>
				</tr>
			</table>
		</div>
		<!--// 컨텐츠 DIV -->
		
		<!-- 버튼 DIV -->
		<div id="saveButton" style="text-align:center; width:100%; padding-top:10px">
			<a href="#fakeUrl" onclick="insertSgBgmm();"><img src="/images/bt_eepl.gif" style="vertical-align: middle; border: 0;" alt="입력"/></a>
			<a href="#fakeUrl" onclick="window.close();"><img src="/images/bt_cancel.gif" style="vertical-align: middle; border: 0;" alt="취소"/></a>
		</div>
		<!--// 버튼 DIV -->
	</div>
	<!--// 팝업 DIV -->
</body>
