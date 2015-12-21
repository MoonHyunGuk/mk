package com.mkreader.security;

/**
 * 코드를 정의한다.
 * @author shlee
 *
 */
public interface ICodeConstant {
	
	// 로그인타입 정보 ------------------------------------------------------------------
	/** 로그인타입 - 관리자 */
	public static final String LOGIN_TYPE_ADMIN 		= "A";
	/** 로그인타입 - 지국 */
	public static final String LOGIN_TYPE_BRANCH 		= "B";
	
	// 권한코드 정보 ------------------------------------------------------------------
	/** 권한코드 - 관리자 */
	public static final String AUTH_CODE_ADMIN 			= "1000";
	/** 권한코드 - 지국 */
	public static final String AUTH_CODE_AGENCY 		= "2000";
	
	
	// 메뉴코드 정보 -------------------------------------------------------------
	/** 메뉴코드 - 메인*/
	public static String MENU_CODE_MAIN 							= "0000";
	/** 메뉴코드 - 본사신청독자관리 */
	public static String MENU_CODE_READER 						= "0010";
	/** 메뉴코드 - 독자 - 자동이체독자관리 */
	public static String MENU_CODE_READER_BILLING			= "0011";
	/** 메뉴코드 - 독자 - 본사사원구독관리 */
	public static String MENU_CODE_READER_EMPLOYEE		= "0012";
	/** 메뉴코드 - 독자 - 교육용구독관리 */
	public static String MENU_CODE_READER_EDUCATION 	= "0013";
	/** 메뉴코드 - 독자 - 소외계층 */
	public static String MENU_CODE_READER_ALIENATION		= "0014";
	/** 메뉴코드 - 독자 - 카드독자관리 */
	public static String MENU_CODE_READER_CARD				= "0015";
	/** 메뉴코드 - 독자 - 사원확장 */
	public static String MENU_CODE_EMP_EXTD					= "0016";
	/** 메뉴코드 - 독자 - 통합독자리스트 */
	public static String MENU_CODE_COMBINE					= "0017";
	/** 메뉴코드 - 독자 - 독자민원관리 */
	public static String MENU_CODE_COMPLAIN					= "0018";
	/** 메뉴코드 - 독자 - 비독자관리 */
	public static String MENU_CODE_NON_READER				= "0019";
	/** 메뉴코드 - 독자 - 독자이전 */
	public static String MENU_CODE_READER_MOVE				= "0093";
	
	
	/** 메뉴코드 - 독자관리 */
	public static String MENU_CODE_J_READER 					= "1010";
	/** 메뉴코드 - 독자원장 */
	public static String MENU_CODE_J_READER_WONJANG		= "1011";
	/** 메뉴코드 - 배달명단 */
	public static String MENU_CODE_J_DELIVERY					= "1012";
		
	
	/** 메뉴코드 - 수금입력 - 수동입금 */
	public static String MENU_CODE_COLLECTION 				= "0020";
	/** 메뉴코드 - 수금입력 - EDI관리 */
	public static String MENU_CODE_COLLECTION_EDI			= "0021";
	
	/** 메뉴코드 - 고지서 */
	public static String MENU_CODE_OUTPUT 						= "0030";
	/** 메뉴코드 - 지로영수증 */
	public static String MENU_CODE_OUTPUT_JIRO 				= "1030";
	/** 메뉴코드 - 방문영수증 */
	public static String MENU_CODE_OUTPUT_VISIT 				= "1031";
	/** 메뉴코드 - 개별영수증 */
	public static String MENU_CODE_OUTPUT_EACH				= "1032";
	/** 메뉴코드 - 지대납부금통지서 */
	public static String MENU_CODE_OUTPUT_JIDAE				= "1033";
	
	/** 메뉴코드 - 인쇄 */
	public static String MENU_CODE_PRINT 							= "0040";
	/** 메뉴코드 - 신규 독자 일보 */
	public static String MENU_CODE_PRINT_NEW					= "0041";
	/** 메뉴코드 - 본사신청구독통계 */
	public static String MENU_CODE_PRINT_REDEAR_STATS 	= "0042";
	/** 메뉴코드 - 본사신청중지현황 */
	public static String MENU_CODE_PRINT_REDEAR_STOP 	= "0043";
	/** 메뉴코드 - 지대/본사입금현황 */
	public static String MENU_CODE_PRINT_JIDAE 				= "0044";
	/** 메뉴코드 - 지국별 실사현황 */
	public static String MENU_CODE_PRINT_SILSA				= "0045";
	/** 메뉴코드 - 조건별명단 */
	public static String MENU_CODE_PRINT_J_CONDITION		= "1040";
	/** 메뉴코드 - 미수독자명단 */
	public static String MENU_CODE_PRINT_J_NOPAIED 		= "1041";
	/** 메뉴코드 - 해지독자명단 */
	public static String MENU_CODE_PRINT_J_STOP 				= "1042";
	/** 메뉴코드 - 입금내역현황 */
	public static String MENU_CODE_PRINT_J_INCOME			= "1043";
	/** 메뉴코드 - 일일수금현황 */
	public static String MENU_CODE_PRINT_J_DAILY 				= "1044";
	/** 메뉴코드 - 독자정보현황 */
	public static String MENU_CODE_PRINT_J_READER 			= "1045";
	/** 메뉴코드 - 지대/본사입금현황 */
	public static String MENU_CODE_PRINT_J_JIDAE 				= "1046";
	
	
	
	/** 메뉴코드 - 통계 */
	public static String MENU_CODE_STATISTICS 						= "0050";
	/** 메뉴코드 - 통계-당월입금 */
	public static String MENU_CODE_STATISTICS_MONTH 			= "0051";
	/** 메뉴코드 - 통계-입금현황 */
	public static String MENU_CODE_STATISTICS_INCOMING 		= "0052";
	/** 메뉴코드 - 통계-유가현황 */
	public static String MENU_CODE_STATISTICS_BILL 				= "0053";
	/** 메뉴코드 - 통계-배부현황 */
	public static String MENU_CODE_STATISTICS_DELIVERY 		= "0054";
	/** 메뉴코드 - 통계-독자현황 */
	public static String MENU_CODE_STATISTICS_READER 		= "0055";
	/** 메뉴코드 - 통계-독자현황 */
	public static String MENU_CODE_STATISTICS_COST 		= "0056";
	
	/** 메뉴코드 - 기타작업 */
	public static String MENU_CODE_ETC 				= "0060";
	
	/** 메뉴코드 - 커뮤니티 */
	public static String MENU_CODE_COMMUNITY 					= "0070";
	/** 메뉴코드 - 커뮤니티-자료실 */
	public static String MENU_CODE_COMMUNITY_DATALIST 	= "0071";
	/** 메뉴코드 - 커뮤니티-메인알림 */
	public static String MENU_CODE_COMMUNITY_MAIN 			= "0072";
	/** 메뉴코드 - 커뮤니티-직원게시판 */
	public static String MENU_CODE_COMMUNITY_MEMBER 		= "0073";
	
	/** 메뉴코드 - 관리-지국 관리 */
	public static String MENU_CODE_MANAGEMENT_AGENCY 		= "0080";
	/** 메뉴코드 - 관리-코드관리 */
	public static String MENU_CODE_MANAGEMENT_CODE 			= "0081";
	/** 메뉴코드 - 관리-월마감 */
	public static String MENU_CODE_MANAGEMENT_MONTH_END 	= "0082";
	/** 메뉴코드 - 관리-도로명주소데이터입력 */
	public static String MENU_CODE_MANAGEMENT_ROADADDR 	= "0083";
	/** 메뉴코드 - 관리-도로명주소데이터입력 */
	public static String MENU_CODE_MANAGEMENT_RESTORE 		= "0084";
	/** 메뉴코드 - 관리-배달번호정렬 */
	public static String MENU_CODE_MANAGEMENT_HEADOFFICE 	= "0085";
	/** 메뉴코드 - 관리-ABC */
	public static String MENU_CODE_MANAGEMENT_ABC 				= "0086";
	/** 메뉴코드 - 관리-배달번호정렬 */
	public static String MENU_CODE_MANAGEMENT_HEADOFFICE2 = "0087";
	/** 메뉴코드 - 관리-사용자관리 */
	public static String MENU_CODE_MANAGEMENT_USER = "0088";
	
	
	/** 메뉴코드 - 관리-지국 정보 */
	public static String MENU_CODE_MANAGEMENT_JIKUK_INFO 		= "1081";
	/** 메뉴코드 - 관리-구역관리 */
	public static String MENU_CODE_MANAGEMENT_J_AREA 				= "1082";
	/** 메뉴코드 - 관리-확장자관리 */
	public static String MENU_CODE_MANAGEMENT_J_EXET 				= "1083";
	/** 메뉴코드 - 관리-매체관리 */
	public static String MENU_CODE_MANAGEMENT_MEDIA 				= "1084";
	/** 메뉴코드 - 관리-관할지역 */
	public static String MENU_CODE_MANAGEMENT_J_LOCATION 		= "1085";
	/** 메뉴코드 - 관리-배달번호정렬 */
	public static String MENU_CODE_MANAGEMENT_J_DELIVERY_CODE = "1086";
	
	
	/** 메뉴코드 - 자동이체 - 일반독자관리 */
	public static String MENU_CODE_BILLING 			= "0090";
	/** 메뉴코드 - 자동이체 - 학생독자관리 */
	public static String MENU_CODE_BILLING_STU		= "0091";
	
	
	/** 메뉴코드 - 지대통보서 */
	public static String MENU_CODE_MANAGEMENT_JIDAE = "0100"; 
	public static String MENU_CODE_MANAGEMENT_JIDAELIST = "0101";
	
	
	
	// 매일경제 정보 ------------------------------------------------------------------
	/** 기관코드*/
	public static String MK_COMPANY_CODE 		= "9922113081";
	/** 지로번호*/
	public static String MK_JIRO_NUMBER 		= "3146440";	
	/** 지로승인번호*/
	public static String MK_APPROVAL_NUMBER 		= "98092";	
	/** 계좌번호*/
	public static String MK_ACCOUNT_NUMBER 		= "70105536213001";
	/** 주거래은행번호*/
	public static String MK_MAIN_BANK_NUMBER 	= "0207010";
	/** 신문코드*/
	public static String MK_NEWSPAPER_CODE 		= "100";
	
	// 금융결제원 정보 ------------------------------------------------------------------
	/** 기관코드*/
	public static String COMPANY_CODE_KFTC 		= "9922112948";
	
	
	// CMS 전문 관련 코드 -------------------------------------------------------------
	/** CMS Recode 구분 코드 - header */
	public static String CODE_CMS_LAYOUT_HEADER 	= "H";
	/** CMS Recode 구분 코드 - data */
	public static String CODE_CMS_LAYOUT_DATA 		= "R";
	/** CMS Recode 구분 코드 - trailer */
	public static String CODE_CMS_LAYOUT_TRAILER 	= "T";
	
	/** CMS 신청 구분 코드 - 신규 */
	public static String CODE_CMS_REQ_TYPE_NEW				= "1";
	/** CMS 신청 구분 코드 - 해지 */
	public static String CODE_CMS_REQ_TYPE_CANCEL			= "3";
	/** CMS 신청 구분 코드 - 임의해지 */
	public static String CODE_CMS_REQ_TYPE_RANDOMLYCANCEL	= "7";
	
	
	// EDI 전문 관련 코드 -------------------------------------------------------------
	/** EDI Recode 구분 코드 - header */
	public static String CODE_EDI_LAYOUT_HEADER 	= "11";
	/** EDI Recode 구분 코드 - data */
	public static String CODE_EDI_LAYOUT_DATA 		= "22";
	/** EDI Recode 구분 코드 - trailer */
	public static String CODE_EDI_LAYOUT_TRAILER 	= "33";
	
	/** EDI 고객조회번호 예전코드와 새로운 코드의 구분자 - 본사전용 지로번호 */
	public static String CODE_EDI_NEW_READER_GUBUN			= "99";
	/** EDI 고객조회번호 예전코드와 새로운 코드의 구분자 - 본사전용 지로번호 외 */
	public static String CODE_EDI_NEW_READER_GUBUN_OTHERS	= "98";
	
	
	// 독자타입 관련 코드 -------------------------------------------------------------
	/** 독자타입 - 일반 */
	public static String CODE_READER_TYPE_GENERAL		= "011";
	/** 독자타입 - 학생지국 */
	public static String CODE_READER_TYPE_STU_BRANCH	= "012";
	/** 독자타입 - 학생본사 */
	public static String CODE_READER_TYPE_STU_HEAD		= "013";
	
	
	
	// 수금방법 관련 코드 -------------------------------------------------------------\
	/** 수금방법 - 지로 */
	public static String CODE_SUGM_TYPE_GIRO				= "011";
	/** 수금방법 - 방문 */
	public static String CODE_SUGM_TYPE_VISIT				= "012";
	/** 수금방법 - 자동이체 */
	public static String CODE_SUGM_TYPE_DIRECT_DEBIT		= "021";
	/** 수금방법 - 결손 */
	public static String CODE_SUGM_TYPE_LOSS		 		= "031";
	/** 수금방법 - 미수 */
	public static String CODE_SUGM_GUBUN_NOT_COMPLETE 		= "044";
	
	/** 학생 수금금액 */
	public static String CODE_SUGM_STU_AMT			 		= "7500";
	
	/** 수금금액 */
	public static String CODE_SUGM_AMT			 			= "15000";
}
