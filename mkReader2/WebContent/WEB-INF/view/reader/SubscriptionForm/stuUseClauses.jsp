<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<head>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<title>매일경제 학생 자동이체</title>
<style> 
<!--
td {
	font-size: 9pt;
	text-align: justify;
	line-height: 4.5mm
}
 
input {
	border-style: groove;
	font-size: 9pt
}
-->
</style>
</head>
<SCRIPT LANGUAGE="JavaScript"> 
<!--
	function check() {
		if ($("check1").checked == false)
		{
			alert("이용약관을 끝까지 읽어주시고 약관의 내용에 동의해주셔야 합니다.");
			$("check1").focus();
			return;
		}
		if ($("check2").checked == false)
		{
			alert("자동이체이용약관을 끝까지 읽어주시고 약관의 내용에 동의해주셔야 합니다.");
			$("check2").focus();
			return;
		}
		frmParent.target="_self";
		frmParent.action="/reader/subscriptionForm/stuBillingEdit.do";
		frmParent.submit();
	}
//-->
</SCRIPT>
<form id="frmParent" name="frmParent" method="post" >
<table cellpadding="0" cellspacing="0" width="676" height="100%">
	<tr>
		<td width="676" valign="top" height="56">
		<p><img src="/images/logo.gif" width="284" height="56" border="0"></p>
		</td>
	</tr>
	<tr>
		<td width="676" valign="top">
		<table cellpadding="0" cellspacing="0" width="676">
			<tr>
				<td width="149">
				<p><img src="/images/m1.gif"
					width="149" height="35" border=0
					onMouseOver='this.src="/images/m1_ov.gif"'
					onMOuseOut='this.src="/images/m1.gif"'></a></p>
				</td>
				<td width="149">
				<p><img src="/images/m2.gif"
					width="149" height="35" border=0
					onMouseOver='this.src="/images/m2_ov.gif"'
					onMOuseOut='this.src="/images/m2.gif"'></a></p>
				</td>
				<td width="149"></td>
				<td width="149"></td>
				<td width="3%">
				<p>&nbsp;</p>
				</td>
				<td width="61">
				<p align="center"><a href="javascript:close()"><img
					src="/images/close.gif" width="45" height="19" border="0"></a></p>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td width="676" valign="top" height="100%">
		<table cellpadding="20" cellspacing="10" width="676" height="100%"
			bgcolor="#C3BDA7">
			<tr>
				<td width="666" bgcolor="white" valign="top">
				<p align="center">
					


<table align="center" cellpadding="0" cellspacing="0" width="605">
    <tr>
        <td width="605" valign="top">
                <p><img src="/images/t5.gif" width="605" height="29" border="0"></p>
        </td>
    </tr>
<!--
	<tr>
        <td width="605" valign="top">
            <p>&nbsp;</p>
        </td>
    </tr>
-->
	<tr>
        <td width="605" valign="top">
			<table align="center" cellpadding="20" cellspacing="1" width="100%">
                <tr>
                    <td width="589" height="20" bgcolor="#DEDBCE">
						<textarea cols="77" rows="7" readonly>[제 1 장 총 칙]
 
제 1 조 (목적) 
 
이 약관은 매일경제신문사(이하 "회사"라 합니다) 가 제공하는 인터넷 관련 서비스(이하 "서비스"라 한다)를 이용함에 있어 이용자와 회사의 권리 의무 및 관련 절차등을 규정하는데 그 목적이 있습니다.
 
제 2 조 (약관의 효력 및 변경) 
 
① 이 약관의 내용은 온라인 상의 공지 및 기타 방법에 의한 회원 공지를 통해 효력이 발생합니다.
 
② 회사는 사정 변경의 경우와 영업상 주요사유가 있을 때 관계법률 및 법령하에 약관을 개정할 수 있습니다. 변경된 약관은 ①의 방법으로 회원에게 공지됨으로써 효력이 발생됩니다.
 
 
제 3 조 (약관 이외의 준칙)
 
① 이 약관에 언급되지 않은 사항이 전기통신기본법, 전기통신사업법, 정보통신망이용촉진 및 정보보호 등에 관한 법률 및 기타 관련 법령 또는 상관례에 따릅니다
 
② 이 약관은 회사가 제공하는 개별서비스에 관한 이용안내와 함께 적용합니다.
 
 
[제 2 장 서비스 이용계약]
 
제 4조 (이용계약의 성립) 
 
① "약관에 동의하십니까?" 라는 이용신청시의 물음에 회원이 "동의함"버튼을 클릭하면이 약관에 동의하는 것으로 간주됩니다. 
 
② '회원'이 변경된 약관에 동의하지 않을 경우, '서비스' 이용을 중단하고 탈퇴할 수 있습니다. 약관이 변경되어 제2조에 의하여 효력이 발생한 이후에도 계속적으로 '서비스'를 이용하는 경우에는 '회원'이 약관의 변경 사항에 동의한 것으로 봅니다.
 
③ 이용계약은 서비스 이용희망자의 이용약관 동의 후 이루어지는 이용 신청에 대하여 회사가 승낙함으로써 성립합니다. 
 
④ 회사는 제7조에 정하여 진 바에 따라 이용희망자의 서비스 이용신청에 대하여 동의합니다.  단, 가입신청자가 본 약관 제10조에 의하여 이전에 회원자격을 상실한 적이 있는 경우에는 회사의 명시적 거부가 없더라도 회사는 동의한 것으로 인정되지 않습니다.  다만 제10조에 의한 회원자격 상실 후 7일이 경과한 자는 회사의 회원 재가입 승낙을 얻어 회원에 다시 가입할 수 있습니다.  
 
 
제 5조 (회원의 탈퇴 및 자격 상실) 
 
① 회원은 회사에 언제든지 자신의 회원 등록을 말소해 줄 것(회원 탈퇴)을 요청할 수 있으며 회사는 위 요청을 받은 즉시 해당 회원의 회원 등록 말소를 위한 절차를 밟습니다.   
 
② 회원이 다음 각 호의 사유에 해당하는 경우, 회사는 회원의 회원자격을 적절한 방법으로 제한 및 정지, 상실 시킬 수 있습니다. 
 
가. 가입 신청 시에 허위 내용을 등록한 경우 
나. 다른 사람의 회사 이용을 방해하거나 그 정보를 도용하는 등 전자거래질서를 위협하는 경우 
다. 법령 및 본 약관을 위반한 경우 
라. 사회의 안녕과 질서, 미풍양속을 저해할 목적으로 등록하는 경우
마.  위와 같은 행위에 준하는 행위나 제20조 제2항에 규정한 행위를 하여 회사가 더 이상 회원의 자격을 유지하기 곤란하다고 판단한 경우  
 
③ 제2항에 의하여 회사가 회원의 회원자격을 상실시키기로 결정한 경우에는 회원등록을 직권 말소 합니다
 
 
제 6 조 (이용신청) 
 
① 본 서비스를 이용하기 위해서는 소정의 가입신청 양식에서 요구하는 모든 회원 정보를 기록하여 신청해야 합니다. 
 
② 가입신청 양식에 쓰는 모든 회원 정보는 모두 실제 데이터인 것으로 간주됩니다. 실명이나 실제 정보를 입력하지 않은 사용자는 법적인 보호를 받을 수 없으며, 서비스의 제한을 받을 수 있습니다. 
 
 
제 7 조 (이용신청의 승낙) 
 
① 회사는 제 5,6,조의 각 조항에 위배되는 경우를 제외하곤 서비스 이용신청을 승낙합니다.  
 
② 회사는 다음에 해당하는 경우, 그 사유가 해소될 때까지 승낙을 유보할 수 있습니다. 
 
가. 서비스 관련 설비에 여유가 없는 경우 
나. 기술상 지장이 있는 경우 
다. 가입해지 이후 일정한 기간이 경과하지 않은 경우
라. 기타 회사가 필요하다고 인정되는 경우 
 
③ 회사는 다음에 해당하는 경우, 가입을 승낙하지 않을 수 있습니다. 
 
가. 본인의 주민등록번호가 아닌 경우  
(다른 사람의 명의 또는 가명을 사용하여 신청하였을 경우)
나. 이용신청시 필요내용을 허위로 기재하여 신청한  경우
다. 사회의 안녕 질서 또는 미풍양속을 저해할 목적으로 신청한 경우
라. 기타 회사가 정한 이용신청 요건에 맞지 않을 경우
마. 선정적이고 음란한 내용의 아이디를 신청할 경우
바. 반사회적이고 관계법령에 저촉되는 아이디를 신청할 경우
사. 비어, 속어라고 판단되는 아이디를 신청할 경우
아. 만14세 미만의 아동이 부모 등의 법정대리인의 동의를 얻지 않은 경우
 
④ '회원'은 타회원의 정보 중 공개가 되어 있는 부분을 볼 수 있으며, 자신의 정보도 공개/비공개를 선택할 수 있습니다.
 
 
제 8 조 (회원정보의 변경)
 
회원은 이용신청 시 기재한 회원정보가 변경되었을 경우에는, 온라인으로 수정을 하여야하며 변경을 하지 않아 생기는 문제의 책임은 회원에게 있습니다 
 
 
[제 3 장 계약 당사자의 의무]
 
제 9 조 (회사의 의무) 
 
① 회사는 서비스 제공과 관련하여 취득한 회원의 개인정보를 본인의 사전 승낙 없이 타인에게 누설, 공개 또는 배포할 수 없으며, 서비스관련 업무 이외의 상업적 목적으로 사용 할 수 없습니다. 단, 다음에 해당하는 경우는 예외입니다. 
 
가. 금융실명거래 및 비밀보장에 관한 법률, 신용정보의 이용 및 보호에 관한 법률, 전기통신기본법, 전기통신사업법, 지방세법, 소비자보호법, 한국은행법, 형사소송법 등 법률에 특별한 규정이 있는 경우
나.  전기통신기본법, 전기통신 사업법, 지방세법, 소비자보호법, 한국은행법, 형사소송법 등 법령에 특별한 규정이 있는 경우
다. 통계작성/학술연구 또는 시장조사를 위하여 필요한 경우로서 특정 개인을 식별할 수 없는 형태로 제공하는 경우
라. 이벤트 참여 및 기타 보다 나은 서비스 제공을 위하여 이벤트 주최 및 후원하는 비즈니스 파트너 및 제휴사와는 회원의 일부 정보를 공유하는 경우
마.  공지된 비즈니스파트너 및 제휴사가 제공하는 상품이나 서비스제공을 위한 경우
 
다만, 라, 마 항의 경우에 회사는 비즈니스 파트너 및 제휴사에게 회원의 정보를 타인에게 누설하지 않을 것을 요구합니다.  그럼에도 불구하고 비즈니스 파트너 및 제휴사가 회원의 정보를 타인에게 누설하는 경우 회사는 고의, 중과실이 없는 한 누설에 대한 책임을 면합니다. 
 
② ①항의 범위 내에서, 회사는 업무와 관련하여 회원 전체 또는 일부의 개인 정보에 관한 통계 자료를 작성하여 이를 사용할수 있고, 서비스를 통하여 회원의 컴퓨터에 쿠키를
전송할 수 있습니다.
이 경우 회원은 쿠키의 수신을 거부하거나 쿠키의 수신에 대하여 경고하도록 사용하는 컴퓨터의 브라우져의 설정을 변경할 수 있습니다.   
 
③ 회사는 회원에게 회원의 서비스 이용 및 회사의 각종 행사 또는 정보서비스에 대해서 E메일이나 서신우편, SMS 등 유무선 통신 수단 등의 방법으로 회원에게 제공할 수 있습니다. 
또한, 회원 등록시 회사 및 회사의 비즈니스 파트너 및 제휴사들로부터 제공되는 제안이나 정보를 받아보겠다고 표시하셨다면, 서비스나 제품들에 관한 소식을 e-mail이나 서신우편, SMS 등 유무선 통신수단으로 보내드릴 것입니다. 만약 이러한 종류의 메일 또는 정보의 수신을 원치 않는 경우 개인정보수정에서 메일 또는 정보를 받고 싶지 않다는 내용으로 자신의 정보를 수정할 수 있습니다. 
④ 회사는 회원으로부터 제기되는 불만이 정당하다고 인정할 경우에는 즉시 처리함을 원칙으로 합니다. 다만 즉시 처리가 곤란한 경우에는 회원에게 그 사유와 처리 일정을 통보합니다.
 
	
제 10 조 (회원의 의무) 
① '회원'은 관계법령, 이 약관의 규정, 이용안내 및 주의사항  등 '회사'가 공지 또는 통지하는 사항을 준수해야 하며, 기타 '회사'의 업무에 방해되는 행위를 할 수 없습니다.
 
② '회원'은 '회사'의 사전 승낙 없이 서비스를 이용하여 어떠한 영리행위도 할 수 없습니다.
 
③ '회원'은 서비스를 이용하여 얻은 정보를 '회사'의 사전 승낙 없이  복사, 복제, 변경, 번역, 출판, 방송 및 기타의 방법으로 사용하거나 이를 타인에게 제공할 수 없습니다.
 
④ '회원'은 사진을 포함한 이미지 사용시 피사체에 대한 초상권, 상표권, 특허권 및 기타 권리를 자신이 취득해야 하며 만일 이들 권리에 대한 분쟁이 발생할 경우 회원이 모든 책임을 부담해야 합니다.  
 
⑤ 회원은 서비스 이용 시 다음 각 호의 행위를 하지 않아야 합니다. 
 
가. 다른 회원의 ID및 개인정보를 수집, 저장하여 부정하게 사용하는 행위 
나. 서비스에서 얻은 정보를 회사의 사전승낙 없이 회원의 이용 이외의 목적으로 복제 하거나 이를 변경, 출판 및 방송 등에 사용하거나 타인에게 제공하는 행위
다. 회사의 저작권, 타인의 저작권 등 기타 권리를 침해하는 행위 
라. 공공질서 및 미풍양속에 위반되는 내용의 정보, 문장, 도형 등을 타인에게 유포하는 행위
마. 범죄와 결부된다고 객관적으로 판단되는 행위
바. 타인의 명예를 훼손하거나 모욕하는 행위
사. 해킹 또는 컴퓨터바이러스를 유포하는 행위
아. 광고 또는 광고성 정보를 전송하거나 기타 영업을 위한 행위
자. 서비스의 안정적인 운영에 지장을 주거나 줄 우려가 있는 일체의 행위
차. 기타 관계법령에 위배되는 행위 
 
⑥ 회원은 관계법령, 이 약관에서 규정하는 사항, 서비스 이용 안내 및 주의 사항을 준수하여야 합니다.  
 
⑦ 회원은 내용별로 회사가 서비스 공지사항에 게시하거나 별도로 공지한 이용 제한 사항을 준수하여야 합니다.  
 
⑧ 회원은 회사의 사전 승낙없이 서비스를 이용하여 어떠한 영리행위도 할 수 없습니다.  
 
 
[제 4 장 서비스 제공 및 이용]
 
제 11 조 (서비스의 범주) 
 
① 이 약관은 회사에서 제공하는 모든 서비스에 기본적으로 적용되며, 다른 항의 별도 조항이 요구되는 서비스에는 부속약관을 둘 수 있습니다.
가. 회사의 비즈니스 파트너 및 제휴사들로부터 제공하는 서비스 범주
나. 커뮤니티 서비스 범주
다. 유,무형의 전자상거래 범주
라. 기타 회사가 정한 부가서비스 범주
 
 
제 12 조 (회원 아이디(ID)와 비밀번호 관리에 대한 회원의 의무)
 
① 아이디(ID)와 비밀번호에 대한 모든 관리는 회원에게 책임이 있습니다.  회원에게 부여된 아이디(ID)와 비밀번호의 관리소홀, 부정사용에 의해 생기는 모든 결과는 전적으로 회원에게 그 책임이 있습니다.  
 
② 자신의 아이디(ID)가 부정하게 사용된 경우 또는 기타 보안 위반에 대하여, 그러한 사실을 안 경우 회원은 반드시 회사에 그 사실을 통보해야 합니다.  
 
 
제 13조 (정보의 제공) 
 
회사는 회원이 서비스 이용 중 필요하고 인정되는 다양한 정보에 대해서 전자메일이나 서신우편 등의 방법으로 회원에게 제공할 수 있으며, 회원은 원하지 않을 경우 가입신청 메뉴와 회원정보수정 메뉴에서 정보수신거부를 할 수 있습니다.  
 
 
제 14조 (광고주와의 거래)
 
본 사이트에는 회사 이외의 광고주의 판촉활동을 위한 서비스가 포함되어 있습니다.  회사는 본 사이트에 게재되어 있거나 본 서비스를 통한 광고주의 판촉활동에 회원이 참여하여 거래한 결과로서 발생하는 모든 손실과 손해에 대해 책임을 지지 않습니다. 
 
제 15조 (회원의 게시물) 
 
회사는  회원이 본 서비스를 통하여 게시, 게재, 전자메일 또는 달리 전송한 내용물에 대해 일체 민,형사상의 책임을 지지 않으며, 다음의 경우에 해당될 경우 사전통지 없이 삭제할 수 있습니다.  
 
① 다른 회원이나 타인을 비방하거나, 프라이버시를 침해하거나, 중상모략으로 명예를 손상시키는 내용인 경우
 
② 서비스의 안정적인 운영에 지장을 주거나 줄 우려가 있는 경우 
 
③ 범죄적 행위에 관련된다고 인정되는 내용일 경우
 
④ 회사의 지적재산권, 타인의 지적재산권 등 기타 권리를 침해하는 내용인 경우  
 
⑤ 회사에서 규정한 게시기간을 초과한 경우  
 
⑥ 기타 관계법령에 위반된다고 판단되는 경우 
 
 
제 16 조 (게시물에 대한 권리 및 책임) 
 
① 본 사이트의 모든 게시물에 대한 저작권은 회사에 귀속됩니다.
 
② 회원이 게시한 저작물의 저작권은 회원의 소유에 속합니다.  다만 회원은 회사에 무료로 이용할 수 있는 권리를 허락한 것으로 봅니다. 
 
③ 회사소유의 게시물에 대한 보호는 회사에서 하며, 회사의 허가 없이 타인에 의해 게시물이 다른 사이트에서 사용 또는 인용되는 것은 금지 됩니다. 
 
 
제 17 조 (서비스 이용시간) 
 
① 서비스는 회사의 업무상 또는 기술상의 장애, 기타 특별한 사유가 없는 한  연중무휴, 1일 24시간 이용할 수 있습니다. 다만 설비의 점검 등 회사가 필요한 경우 또는 설비의 장애, 서비스 이용의 폭주 등 불가항력으로 인하여 서비스 이용에 지장이 있는 경우, 예외적으로 서비스 이용의 전부 또는 일부에 대하여 제한할 수 있습니다. 
 
② 회사는 제공하는 서비스 중 일부에 대한 서비스 이용시간을 별도로 정할 수 있으며, 이 경우 그 이용시간을 사전에 회원에게 공지 또는 통지합니다. 
 
 
제 18 조 (서비스 이용 책임)
 
회원은 서비스를 이용하여 불법 상품을 판매하는 영업 활동을 할 수 없으며 특히 해킹, 돈벌기 광고, 음란사이트를 통한 상업행위, 상용 S/W 불법배포 등을 할 수 없습니다.  이에 위반하여 발생한 민사상 또는 형사상 책임에 대하여 회사는 아무런 책임이 없습니다.
 
 
제 19 조 (서비스 제한 및 정지) 
 
① 회사는 전시, 사변, 천재지변 또는 이에 준하는 국가비상사태가 발생하거나 발생할 우려가 있는 경우와 전기통신사업법에 의한 기간통신 사업자가 전기통신서비스를 중지하는등 기타 불가항력적 사유가 있는 경우에는 서비스의 전부 또는 일부를 제한하거나 정지할 수 있습니다. 
 
② 회사는 제1항의 규정에 의하여 서비스의 이용을 제한하거나 정지한 때에는 그 사유 및 제한기간 등을 회원에게 알려야 합니다. 
 
 
[제 5 장 기 타]
 
제 20 조 (계약해지 및 이용제한)
 
① 회원이 이용계약을 해지하고자 하는 때에는 회원 본인이 회사에 해지신청을 해야 합니다.
 
② 회사는 회원이 다음에 해당하는 행위를 하였을 경우 사전통지 없이 이용계약을 해지하거나 또는 기간을 정하여 서비스 이용을 중지할 수 있습니다.
 
가. 타인의 서비스 ID 및 비밀번호를 도용한 경우 
나. 서비스 운영을 고의로 방해한 경우 
다. 공공질서 및 미풍양속에 저해되는 내용을 고의로 유포시킨 경우 
라. 회원이 국익 또는 사회적 공익을 저해할 목적으로 서비스이용을 계획 또는 실행하는 경우 
마. 타인의 명예를 손상시키거나 불이익을 주는 행위를 한 경우 
바. 서비스의 안정적 운영을 방해할 목적으로 다량의 정보를 전송하거나 광고성 정보를 전송하는 경우 
사. 정보통신설비의 오작동 이나 정보 등의 파괴를 유발시키는 컴퓨터 바이러스 프로그램등을 유포하는 경우
아. 회사, 다른 회원 또는 타인의 지적재산권을 침해하는 경우 
자. 정보통신윤리위원회 등 외부기관의 시정요구가 있거나 불법선거 운동과 관련하여 선거관리위원회의 유권해석을 받은 경우 
차. 타인의 개인정보, 회원ID 및 비밀번호를 부정하게 사용하는 경우 
카. 회사의 서비스 정보를 이용하여 얻은 정보를 회사의 사전 승낙없이 복제 또는 유통시키거나 상업적으로 이용하는 경우 
타. 회원이 자신의 홈페이지와 게시판에 음란물을 게재하거나 음란사이트를 링크하는 경우
파. 본 약관을 포함하여 기타 회사가 정한 이용조건 및 관계법령을 위반한 경우 
 
 
제 21 조 (손해배상) 
 
회사는 서비스 이용과 관련하여 회원에게 발생한 손해에 대하여 고의, 중과실이 없는 한 배상책임을 지지 않습니다.
 
제 22 조 (담보)
 
① 회사에서 제공하는 각종 정보, 회사의 비즈니스 파트너 및 제휴사들로부터 제공되는 정보 또는 특정전문가가 제공하는 정보(질문 및 대답 등의 형식으로 이루어지는 것 포함)는 과학적 실험절차와 검증절차를 거치지 않은 것일 수 있습니다.  회사는 위와 같은 정보에 대하여 그 내용의 신뢰도나 정확성을 담보하지 않습니다. 
 
② 회사는 회원이 서비스에 게재한 정보, 자료, 사실의 신뢰도, 정확성 등에 대하여 담보하지 않습니다.
 
③ 회사가 담보하지 않은 사항에 대하여는 제24조에서 정하는 바에 의하여 책임을 제한 또는 면제할 수 있습니다.
 
제23조 (양도금지)
  '회원'이 서비스의 이용권한, 기타 이용계약상 지위를 타인에게 양도하거나 담보로 제공할 수 없습니다.
 
제24조 (면책조항)
 
① 회사는 천재지변 또는 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 관한 책임이 면제됩니다. 
 
② 회사는 회원의 잘못으로 인해 서비스 이용의 장애가 발생한 경우에는 책임이 면제됩니다.
 
③  회사는 회원이 회사의 서비스 제공으로부터 기대되는 이익을 얻지 못하였거나, 서비스 자료에 대한 취사 선택 또는, 이용으로 발생하는 손해 등에 대해서는 책임이 면제됩니다.
 
④ 회사는 제22조에서 회사가 담보하지 않은 사항으로 인하여 발생한 손해에 대하여 책임이 면제됩니다.
 
 
제 25조 (분쟁의 해결 및 관할법원)
 
① '회사'와 '회원'은 서비스와 관련하여 발생한 분쟁을 원만하게 해결하기 위하여 필요한 모든 노력을 해야 합니다.
② 제1항의 규정에도 불구하고, 동 분쟁으로 인하여 소송이 제기될 경우에는 '회사'의 소재지를 관할하는 법원을 관할법원으로 합니다.
③ '회사'와 이용자간에 제기된 전자거래 소송에는 한국법을 적용합니다.
 
 
[부칙]
 
 (시행일) 이 약관은 2006년 02월 01일부터 시행합니다. 
</textarea><br>
						<center><input type="checkbox" id="check1" name="check1" value="true" style="border:none;">위의 이용약관에 명시된 내용에 동의합니다</center>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
        <td width="605" valign="top">
            <p>&nbsp;</p>
        </td>
    </tr>
	<tr>
        <td width="605" valign="top">
                <p><img src="/images/t6.gif" width="605" height="29" border="0"></p>
        </td>
    </tr>
	<tr>
        <td width="605" valign="top">
			<table align="center" cellpadding="20" cellspacing="1" width="100%">
                <tr>
                    <td width="589" height="20" bgcolor="#DEDBCE">
						<textarea cols="77" rows="7" readonly>제 1조(약관의 적용)  CMS 자동이체제도(이하 “자동이체”라 한다)에 의하여 신문구독료를 납부하고자 하는 자(이하 “납부자”라 한다)와 “매일경제신문사”에 대하여 이 약관을 적용합니다. 
 
제 2조(출금) 납부자가 지급하여야할 신문구독료에 대하여 은행 앞으로 청구가 있을 경우에는 별도의 통지 없이 납부자의 지정계좌에서 출금을 의뢰하는 기관(이하 “매일경제신문사”라 한다)이 지정하는 납기일(휴일인 경우 익 영업일)에 출금 대체 납부합니다. 다만, 자동이체를 위하여 지정계좌의 예금을 출금하는 경우에는 은행의 예금약관이나 약정서의 규정에도 불구하고 예금청구서 기타 관련증서 없이 자동이체 처리절차에 의하여 출금할 수 있습니다. 
 
제 3조(미출금분 추가 출금) 자동이체 지정계좌의 예금 잔액(자동대출 약정이 있는 경우 대출한도 포함)이 납기일 현재 매일경제의 청구금액보다 부족하거나, 예금의 지급제한, 약정대출의 연체 등 납부자의 과실에 의하여 대체납부가 불가능하여 발생한 미 출금분에 대해서는 당월 말일 추가 출금하게 됩니다.
 
제 4조(과실책임) 자동이체 지정계좌의 예금 잔액(자동대출 약정이 있는 경우 대출한도 포함)이 납기일 현재 매일경제신문사의 청구금액보다 부족하거나, 예금의 지급제한, 약정대출의 연체 등 납부자의 과실에 의하여 대체납부가 불가능한 경우의 손해는 납부자의 책임으로 합니다. 
 
제 5조(전액출금) 매일경제신문사는 전액출금방식으로 승인되었으므로 청구금액에 비해 예금 잔액이 부족할 경우는 잔액을 출금할 수 없으며 납부자의 예금계좌를 보유한 금융기관(이하 “은행”이라 한다)의 사정에 의하여 출금이 불가능 할 수 있습니다. 
 
제 6조(출금 우선순위) 납기일에 동일한 수종의 자동이체 청구가 있는 경우의 출금 우선 순위는 은행에서 정하는 바에 따릅니다. 
 
제 7조(신규, 해지, 변경) 자동납부 신청(신규, 해지, 변경)은 해당 납기일 30일전까지 신청서를 제출하여야 합니다. 
 
제 8조(최초 개시일) 자동이체 신규신청에 의한 이체개시일은 은행 및 매일경제신문사의 사정에 의하여 결정되어지며 통상 납부자가 자동이체를 신청한 다음 달 및 납부자가 지정하달(전월 및 당월 제외)이 자동이체 개시월이 됩니다. 
 
제 9조(출금기준 및 이의제기) 자동이체 신청에 의한 지정계좌에서의 출금은 해당 납기일 은행 영업시간 내에 입금된 예금에 한하여 매일경제신문사의 청구대로 출금하며, 청구금액에 이의가 있는 경우에는 납부자와 매일경제신문사 지국이 협의하여 조정하여야 합니다.
 
제 10조(정보제공) 자동이체 업무처리를 위하여 자동이체와 관련된 납부자의 계좌정보(거래은행명, 계좌번호, 주민(사업자)등록번호 등)가 은행 및 매일경제신문사의 자동이체 업무를 대행하는 매일경제 판매국 및 전산 대행사에 제공되며, 제공된 정보는 동 업무 이외의 목적에 사용할 수 없습니다. 
 
제 11조(은행에 신청시 약관 적용) 자동이체 신청서를 은행에 직접 제출하여 자동이체를 신청한 경우와 인터넷을 통하여 신청한 경우에도 이 약관을 적용합니다. 
 
◇ 금융거래정보의 제공 동의서 ◇
 
본 신청과 관련하여 본인은 다음 금융거래정보(거래은행명, 지점명, 계좌번호)를 출금이체를 신규 신청하는 때로부터 해지 신청할 때까지 상기 수납기관에 제공하는 것에 대하여 「금융실명거래 및 비밀보장에 관한 법률」의 규정에 따라 동의 합니다.
</textarea><br>
						<center><input type="checkbox" id="check2" name="check2" value="true" style="border:none;">위의 이용약관에 명시된 내용에 동의합니다</center>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
        <td width="605" valign="top">
            <p>&nbsp;</p>
        </td>
    </tr>
	<tr>
        <td width="605" valign="top">
            <p align="center">
            <a href="javascript:check();"><img src="/images/bt2.gif" width="71" height="23" border="0" ></a></p>
        </td>
    </tr>
</table>
</form>
				      </p>
				</td>
			</tr>
 
		</table>
		</td>
	</tr>
	<tr>
		<td bgcolor="#C3BDA7">
		<table cellpadding="0" cellspacing="0" width="636" align="center">
			<tr>
				<td width="130">
				<table align="center" cellpadding="0" cellspacing="0"
					bgcolor="white">
					<tr>
						<td>
						<p align="center"><img src="/images/mklogo.gif" width="74"
							height="29" border="0" vspace="10" hspace="10"></p>
						</td>
					</tr>
				</table>
				</td>
				<td width="506" colspan="2">
				<table align="center" width="506" cellpadding="0" cellspacing="0">
					<tr>
						<td colspan="2" width="506">
						<p style="margin-top: 5px;">Copyright&copy; 2006. 매경인터넷(주).
						서울특별시 중구 필동 1가 30-1 매경미디어센터 9층.<br>
						매경인터넷은 회원의 허락없이 개인정보를 수집, 공개, 유출을 하지 않으며 회원정보의 <br>
						보호를 위해 최선을 다합니다.</p>
						</td>
					</tr>
					<tr>
						<td width="386">
						<p style="margin-bottom: 5px;">사업자 등록번호 : 201-81-25980 / 통신판매업
						신고 : 중구00083호 &nbsp;<br>
						이용관련문의 : 02-2000-2000&nbsp;</p>
						</td>
						<td width="120" valign="top">
						</td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>