package com.mkreader.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.mkreader.security.ICodeConstant;
import com.mkreader.security.ISiteConstant;

public class CmsUtil {
	
	
	/**
	 * CMS 전문 Header 생성
	 * 
	 * @param companyCode(10)	- 기관번호 (이용기관식별번호)
	 * @param fileType(4)		- 전문코드, 파일형식코드 (파일이름의 앞 4자리에 해당되는 코드)
	 * @param requestDate(6)	- 신청접수일자 ("YYMMDD", File 이름과 동일한 날짜)
	 * @param spaceLength		- spaceLength 만큼 " " 로 채움.
	 * @return
	 * @throws Exception
	 */
	public static String createHeader( 
			String companyCode, String fileType, String requestDate, int spaceLength
	) {
		
		String fileDate = "";
		if ( requestDate.length() > 4 ) {
			fileDate = requestDate.substring(requestDate.length()-4);
		}
		
		String headerStr = 	ICodeConstant.CODE_CMS_LAYOUT_HEADER	// (1). Record 구분(Header Record 식별부호 "H")
							+ "00000000"							// (8). 일련번호 ("00000000" 고정값)
							+ companyCode							// (10). 기관번호 (이용기관식별번호)
							+ fileType + fileDate					// (8). File 이름 (EB11,EB12,EB13,EB14MMDD)
							+ requestDate							// (6). 신청접수일자 ("YYMMDD", File 이름과 동일한 날짜)
							;
		
		for ( int i = 0; i < spaceLength; i++ ) {
			headerStr += " ";
		}
		
		return headerStr;
	}
}

