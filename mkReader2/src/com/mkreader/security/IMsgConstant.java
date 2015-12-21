package com.mkreader.security;

/**
 * 사이트 전반에서 사용되는 메세지를 정의한다.
 * @author shlee
 *
 */
public interface IMsgConstant {
	
	// 로그인 관련 메세지 ---------------------------------------------------------------
	/** 로그인 필요*/ 
	public static String MSG_LOGIN_NOT 			= "로그인후 이용 가능합니다.";
	/** 로그인 - 본사 관리자 로그인이 아닐 때 */ 
	public static String MSG_LOGIN_NOT_AUTH 	= "권한이 없습니다.";
	/** 로그인 - 본사 관리자 로그인이 아닐 때 */ 
	public static String MSG_LOGIN_NOT_AUTH_ADMIN 	= "본사 관리자만 이용 가능합니다.";
	/** 로그인 - 지국 사용자 로그인이 아닐 때 */ 
	public static String MSG_LOGIN_NOT_AUTH_AGENCY 	= "지국 사용자만 이용 가능합니다.";
	/** 기타작업 - 마감 작업 완료 */ 
	public static String MSG_SUCSSES_DEADLINE 	= "월 마감 작업이 완료 되었습니다.";
	/** 독자 - 교육용 독자 수금 입력 작업 완료 */ 
	public static String MSG_SUCSSES_EDUCATION 	= "교육용 독자 수금 작업이 완료 되었습니다.";
	/** 독자 - 소외계층 독자 수금 입력 작업 완료 */ 
	public static String MSG_SUCSSES_ALIENATION 	= "소외계층 독자 수금 작업이 완료 되었습니다.";
	/** 공통 에러 메시지 */ 
	public static String MSG_ERROR_MESSAGE 	= "죄송합니다. 네트워크에 오류가 발생했습니다.\\n잠시후에 다시 한번 시도해 주십시오.";
	
}