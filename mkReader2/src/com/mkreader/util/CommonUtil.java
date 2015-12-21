package com.mkreader.util;

import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.mkreader.security.ISiteConstant;

public class CommonUtil extends MultiActionController implements 
		ISiteConstant {
	
	
	/**
	 * 로그인 아이디 체크
	 * @return
	 */
	public static String getLoginId(HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		String admin_userid = (String) session.getAttribute(SESSION_NAME_ADMIN_USERID);
		String agency_userid = (String) session.getAttribute(SESSION_NAME_AGENCY_USERID);
		
		if ( StringUtils.isNotEmpty(admin_userid)) {
			return admin_userid;
		}
		else {
			return agency_userid;
		}
	}
	
	/**
	 * 은행입력 불능코드
	 * @param val
	 * @return
	 */
	public static String err_code(String val) {
		String str = "";
		if( StringUtils.isEmpty(val) ){
			str = "결과값 없음";
		}else{
			
			if( "0000".equals(val) )	str = "정상";
			
			// 은행입력 불능코드
			else if( "0012".equals(val) )	str = "계좌번호 오류 또는 계좌번호 없음";
			else if( "0014".equals(val) )	str = "주민등록번호 또는 사업자등록번호 오류";
			else if( "0015".equals(val) )	str = "계정과목 오류";
			else if( "0005".equals(val) )	str = "계정과목 상이";
			else if( "0017".equals(val) )	str = "출금이체 미신청계좌";
			else if( "0019".equals(val) )	str = "출금이체신청 은행해지";
			else if( "0021".equals(val) )	str = "잔액 또는 지불가능잔액 부족";
			else if( "0022".equals(val) )	str = "입금한도 초과";
			else if( "0031".equals(val) )	str = "햬약계좌";
			else if( "0032".equals(val) )	str = "가명계좌 또는 실명미확인";
			else if( "0033".equals(val) )	str = "잡 좌";
			else if( "0034".equals(val) )	str = "법적제한계좌, 지급정지 또는 사고신고계좌";
			else if( "0035".equals(val) )	str = "압류/가압류 계좌";
			else if( "0036".equals(val) )	str = "잔액증명발급 계좌";
			else if( "0037".equals(val) )	str = "연체계좌 또는 지점통제계좌";
			else if( "0041".equals(val) )	str = "은행시스템오류";
			else if( "0051".equals(val) )	str = "기타 오류";
			else if( "A011".equals(val) )	str = "신청일자 오류";
			else if( "A015".equals(val) )	str = "동일 납주자번호 등록 오류";
			else if( "A016".equals(val) )	str = "이중신청";
			else if( "A018".equals(val) )	str = "납부자번호체계오류";
			
			// 센터입력 불능코드
			else if( "A012".equals(val) )	str = "신청구분 오류";
			else if( "0011".equals(val) )	str = "은행점코드 오류";
			else if( "0096".equals(val) )	str = "CMS 미참가은행";
			else if( "0061".equals(val) )	str = "의뢰금액이 0원인 경우";
			else if( "0062".equals(val) )	str = "건당 이체금액한도 초과";
			else if( "0068".equals(val) )	str = "통장기재내용 오류";
			else if( "0075".equals(val) )	str = "출금형태,금액 관련 오류";
			else if( "0081".equals(val) )	str = "파일형태 R, T, 일련번호 오류";
			else if( "0086".equals(val) )	str = "통장기재내역이 결제원에 등록된 내역과 상이한 경우";
			else if( "0087".equals(val) )	str = "한글 오류";
			else if( "0088".equals(val) )	str = "영문자/숫자 오류";
			else if( "0089".equals(val) )	str = "Space 오류";
			else if( "0090".equals(val) )	str = "All Zero 오류";
			else if( "0098".equals(val) )	str = "계좌번호 Alpha-Numeric + Space 오류";
			
			// 이용기관 입력 불능 코드
			else if( "A013".equals(val) )	str = "납부자번호 상이 또는 없음";
			else if( "A016".equals(val) )	str = "이중신청";
			else if( "A017".equals(val) )	str = "기타 오류	";

			// 연학 관리
			else if( "EEEE".equals(val) )	str = "결과값 없음";
			else if( "9999".equals(val) )	str = "환불";
			else if( "XXXX".equals(val) )	str = "기 출금분 청구";
			
			else							str = "정의되지 않은 코드";
		}
		
		return str;
	}
	
	/**
	 * 정규식 패턴 검증
	 * 
	 * @param pattern
	 * @param str
	 * @return
	 */
	public static boolean checkPattern(String pattern, String str) {
		if(str == null)return false;
		boolean okPattern = false;
		String regex = null;

		pattern = pattern.trim();

		// 숫자 체크
		if (StringUtils.equals("num", pattern)) {
			regex = "^[0-9]*$";
		}

		// 영문 체크

		// 이메일 체크
		if (StringUtils.equals("email", pattern)) {
			regex = "^[_a-z0-9-]+(.[_a-z0-9-]+)*@(?:\\w+\\.)+\\w+$";
		}

		// 전화번호 체크
		if (StringUtils.equals("tel", pattern)) {
			//regex = "^\\d{2,3}-\\d{3,4}-\\d{4}$";
			regex = "^[02|0[3-9]{1}[0-9]{1}]-[\\d{4}|\\d{3}]-\\d{4}$";
		}

		// 휴대폰번호 체크
		if (StringUtils.equals("phone", pattern)) {
			regex = "^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$";
		}

		okPattern = Pattern.matches(regex, str);
		return okPattern;
	}
}

