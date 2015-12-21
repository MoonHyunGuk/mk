package com.mkreader.security;

import java.util.List;

/**
 * 사이트 전반에서 사용되는 상수를 정의한다.
 * @author shlee
 *
 */
public interface ISiteConstant extends ICodeConstant, IMsgConstant {

	// URL/URI 정보 ------------------------------------------------------------
	/** 로그인 */ 
	public static String URI_LOGIN						= "/main/index.do";
	/** 로그인 프로세스 */ 
	public static String URI_LOGIN_PROCESS				= "/main/login.do";
	/** 로그아웃 */ 
	public static String URI_LOGOUT						= "/main/logout.do";
	/** 메인 */ 
	public static String URI_MAIN						= "/index.jsp";
	/** 관리자 메인 */ 
	public static String URI_MAIN_ADMIN					= "/admin/main.do";
	/** 지국 메인 */ 
	public static String URI_MAIN_AGENCY				= "/agency/main.do";
	
	
	// 세션 정보 ------------------------------------------------------------------
	/** 로그인 타입*/
	public static final String SESSION_NAME_LOGIN_TYPE 		= "login_type";
	
	/** 관리자 세션아이디*/
	public static final String SESSION_NAME_ADMIN_USERID 	= "admin_userid";
	/** 관리자 세션명*/
	public static final String SESSION_NAME_ADMIN_NAME	= "admin_name";
	/** 관리자 등급*/
	public static final String SESSION_NAME_ADMIN_LEVELS 	= "admin_levels";
	/** 영업담당여부체크*/
	public static final String SESSION_NAME_CHKSELLERYN = "seller_yn";
	/** 관리자, 관리팀여부체크*/
	public static final String SESSION_NAME_CHKADMINMNGYN = "admin_mng_yn";
	/** 담당구역코드*/
	public static final String SESSION_NAME_LOCALCODE = "local_code";
	/** 부서코드*/
	public static final String SESSION_NAME_COMPCD = "comp_cd";
	
	/** 지국 세션명 */
	public static final String SESSION_NAME_AGENCY_USERID 	= "agency_userid";
	/** 지국테이블 일련번호 */
	public static final String SESSION_NAME_AGENCY_NUMID 	= "agency_numid";
	/** 지국 일련번호 */
	public static final String SESSION_NAME_AGENCY_SERIAL 	= "agency_serial";
	/** 지국명 */
	public static final String SESSION_NAME_AGENCY_NAME 	= "agency_name";
	/** 지국 등급 */
	public static final String SESSION_NAME_AGENCY_LEVELS 	= "agency_levels";
	
	/** 홈페이지 권한*/
	public static final String SESSION_NAME_MENU_AUTH 	= "menu_auth";
	
	/** 지국 등급 */
	public static final String SESSION_NAME_ABC_CHK 	= "abcYn";
	
	/** 메뉴 */
	public static final String SESSION_MENU_LIST = "menu_list";
	
	/** 업무리스트 */
	public static final String SESSION_MKEVENT_LIST = "mkEvent_list";
	
	
	// 인코딩 정보 --------------------------------------------------------------
	public static String ENCODING_TYPE_CMS 					= "MS949";
	
	// 외부 서버 ( 현 가비아: 121.254.168.49) -----------------------------------
	public static String EXTERNAL_SERVER 			= "http://autogiro.co.kr";
	
	/** 디렉토리 이름 */ 
	public static String PATH_DIR_STU_APLC			= "/uploadedfile/stuaplc/";
	
	/** 파일 업로드 경로 - 절대경로 루트 */ 
	public static String PATH_UPLOAD_STU_APLC			= EXTERNAL_SERVER + PATH_DIR_STU_APLC;
	
	
	// OZ 경로 정보 ------------------------------------------------------------
	/** OZ VIEWER 다운로드 경로 */
	public static String OZ_DOWNLOAD_SERVER 			= "mk150.mk.co.kr";
	
	/** OZ VIEWER 버젼 */
	public static String OZ_VIEWER_VERSION 			= "2,2,2,2";
	
	/** OZ VIEWER 설치 폴더명 */
	public static String OZ_VIEWER_NAME 			= "mkcrm"; 
	
	/** OZ VIEWER 다운로드 포트 */
	public static String OZ_DOWNLOAD_PORT 			= "80";  //운영 포트 
	//public static String OZ_DOWNLOAD_PORT 			= "8085";  //개발 포트
	//public static String OZ_DOWNLOAD_PORT 			= "8001";  //개발 포트
	
	/** OZ 서버 서블릿 경로 */
	public static String OZ_SERVLET_SERVER 			= "http://mk150.mk.co.kr/oz51/server"; //운영
	//public static String OZ_SERVLET_SERVER 			= "http://218.144.58.97:8085/oz51/server";	//개발  
	//public static String OZ_SERVLET_SERVER 			= "http://218.144.58.2:9000/oz51/server";	//개발 
	//public static String OZ_SERVLET_SERVER 			= "http://localhost:8001/oz51/server";	//로컬
	//운영 : http://mk150.mk.co.kr/oz51/server,   개발 : http://218.144.58.97:8085/oz51/server, 로컬 : http://localhost:8001/oz51/server (로컬일경우 라이센스가 2012-02-16일까지이므로 pc날짜 수정후 사용)
	
	/** 매일경제 시스템 경로*/
	//public static String PATH_SERVER 			= "http://mk150.mk.co.kr/";
	//public static String PATH_SERVER 			= "http://localhost:8001/";
	 
	// 파일 경로 정보 ------------------------------------------------------------
	/** 서버 물리 루트 경로 */ 
	
	public static String PATH_PHYSICAL_HOME 			= "/home/tmax/mkreader";									//운영
	//public static String PATH_PHYSICAL_HOME 			= "/jeus6/webhome/mk_reader_home";					//개발
	//public static String PATH_PHYSICAL_HOME 			= "C:/MK_Reader/workspace/mkReader/wwwroot";	//로컬 
	
	// 가비아서버 물리 루트 경로
	//public static String PATH_PHYSICAL_HOME 			= "/www/autogiro_co_kr/www";

	/** 파일 업로드 경로 - 상대경로 루트 */ 
	public static String PATH_UPLOAD_ABSOLUTE_ROOT			= "/uploadedfile";	
	/** 파일 업로드 경로 - 절대경로 루트 */ 
	public static String PATH_UPLOAD_RELATIVE_ROOT			= PATH_PHYSICAL_HOME + PATH_UPLOAD_ABSOLUTE_ROOT;
	
	/** 디렉토리 이름(CMS 파일위치) 일반독자 */ 
	public static String PATH_DIR_CMS			= "/cms";
	/** 디렉토리 이름(EDI 파일위치) */ 
	public static String PATH_DIR_EDI			= "/edi";
	/** 디렉토리 이름(월마감 결과파일) */ 
	public static String PATH_DIR_DEADLINE			= "/deadLine";
	/** 디렉토리 이름(교육용 수금 입력 파일) */ 
	public static String PATH_DIR_EDUCATION			= "/education";
	/** 디렉토리 이름(비독자 일괄등록 파일) */ 
	public static String PATH_DIR_BI_READER			= "/bireader";
	/** 디렉토리 이름(소외계층 수금 입력 파일) */ 
	public static String PATH_DIR_ALIENATION		= "/alienation";
	/** 디렉토리 이름(카드독자 관련 파일) */ 
	public static String PATH_DIR_CARD				= "/card";
	
	/** 디렉토리 이름(수금 생성 입력 파일) */ 
	public static String PATH_DIR_GENERATE		= "/generate";
	
	/** 디렉토리 이름(ABC 입력 파일) */ 
	public static String PATH_DIR_ABC		= "/abc";
	
	/** 디렉토리 이름(지대통지서 입력 파일) */ 
	public static String PATH_DIR_JIDAE		= "/jidae";
	
	/** 디렉토리 이름(temp 파일) */ 
	public static String PATH_DIR_TEMP		= "/temp";

	/** 디렉토리 이름(EB11) 일반독자 - 은행신청 */
	public static String PATH_DIR_EB11			= PATH_DIR_CMS + "/EB11";
	/** 디렉토리 이름(EB12) 일반독자 - 은행신청결과 */
	public static String PATH_DIR_EB12			= PATH_DIR_CMS + "/EB12";
	/** 디렉토리 이름(EB13) 일반독자 - 이용기관신청 */
	public static String PATH_DIR_EB13			= PATH_DIR_CMS + "/EB13";
	/** 디렉토리 이름(EB14) 일반독자 - 이용기관신청결과 */
	public static String PATH_DIR_EB14			= PATH_DIR_CMS + "/EB14";
	/** 디렉토리 이름(EB21) 일반독자 - 출금이체의뢰 */
	public static String PATH_DIR_EB21			= PATH_DIR_CMS + "/EB21";
	/** 디렉토리 이름(EB22) 일반독자 - 출금이체결과 */
	public static String PATH_DIR_EB22			= PATH_DIR_CMS + "/EB22";
	/** 디렉토리 이름(GR15) 지로 - 수납명세서 */
	public static String PATH_DIR_GR15			= PATH_DIR_EDI + "/GR15";
	/** 디렉토리 이름(GR15) 지로 - 대행 수납명세서 */
	public static String PATH_DIR_GR15_AGENCY			= PATH_DIR_EDI + "/GR15AGENCY";
	/** 디렉토리 이름(GR65) 지로 - 수납명세서 */
	public static String PATH_DIR_GR65			= PATH_DIR_EDI + "/GR65";
	/** 디렉토리 이름(MR15) 더존 바코드수납 - 수납명세서 */
	public static String PATH_DIR_MR15			= PATH_DIR_EDI + "/MR15";
	
	
	/** 파일 업로드 경로 - 상대경로(CMS-EB13) 일반독자 - 은행신청 */ 
	public static String PATH_UPLOAD_ABSOLUTE_CMS_EB11		= PATH_UPLOAD_ABSOLUTE_ROOT + PATH_DIR_EB11;
	/** 파일 업로드 경로 - 상대경로(CMS-EB14) 일반독자 - 은행신청결과 */ 
	public static String PATH_UPLOAD_ABSOLUTE_CMS_EB12		= PATH_UPLOAD_ABSOLUTE_ROOT + PATH_DIR_EB12;
	/** 파일 업로드 경로 - 상대경로(CMS-EB13) 일반독자 - 이용기관신청 */ 
	public static String PATH_UPLOAD_ABSOLUTE_CMS_EB13		= PATH_UPLOAD_ABSOLUTE_ROOT + PATH_DIR_EB13;
	/** 파일 업로드 경로 - 상대경로(CMS-EB14) 일반독자 - 이용기관신청결과 */ 
	public static String PATH_UPLOAD_ABSOLUTE_CMS_EB14		= PATH_UPLOAD_ABSOLUTE_ROOT + PATH_DIR_EB14;
	/** 파일 업로드 경로 - 상대경로(CMS-EB21) 일반독자 - 출금이체의뢰 */ 
	public static String PATH_UPLOAD_ABSOLUTE_CMS_EB21		= PATH_UPLOAD_ABSOLUTE_ROOT + PATH_DIR_EB21;
	/** 파일 업로드 경로 - 상대경로(CMS-EB22) 일반독자 - 출금이체결과 */ 
	public static String PATH_UPLOAD_ABSOLUTE_CMS_EB22		= PATH_UPLOAD_ABSOLUTE_ROOT + PATH_DIR_EB22;
	/** 파일 업로드 경로 - 상대경로(EDI-GR15) 지로 - 수납명세서 */ 
	public static String PATH_UPLOAD_ABSOLUTE_EDI_GR15		= PATH_UPLOAD_ABSOLUTE_ROOT + PATH_DIR_GR15;
	/** 파일 업로드 경로 - 상대경로(EDI-GR15) 지로 - 대행 수납명세서 */ 
	public static String PATH_UPLOAD_ABSOLUTE_EDI_GR15_AGENCY	= PATH_UPLOAD_ABSOLUTE_ROOT + PATH_DIR_GR15_AGENCY;
	/** 파일 업로드 경로 - 상대경로(EDI-GR65) 지로 - 전자납부번호 등록 */ 
	public static String PATH_UPLOAD_ABSOLUTE_EDI_GR65		= PATH_UPLOAD_ABSOLUTE_ROOT + PATH_DIR_GR65;
	/** 파일 업로드 경로 - 상대경로(EDI-MR15) 더존 바코드수납 - 수납명세서 */ 
	public static String PATH_UPLOAD_ABSOLUTE_EDI_MR15		= PATH_UPLOAD_ABSOLUTE_ROOT + PATH_DIR_MR15;
	
	/** 파일 업로드 경로 - 절대경로(CMS-EB13) 일반독자 - 은행신청 */ 
	public static String PATH_UPLOAD_RELATIVE_CMS_EB11		= PATH_UPLOAD_RELATIVE_ROOT + PATH_DIR_EB11;
	/** 파일 업로드 경로 - 절대경로(CMS-EB14) 일반독자 - 은행신청결과 */ 
	public static String PATH_UPLOAD_RELATIVE_CMS_EB12		= PATH_UPLOAD_RELATIVE_ROOT + PATH_DIR_EB12;
	/** 파일 업로드 경로 - 절대경로(CMS-EB13) 일반독자 - 이용기관신청 */ 
	public static String PATH_UPLOAD_RELATIVE_CMS_EB13		= PATH_UPLOAD_RELATIVE_ROOT + PATH_DIR_EB13;
	/** 파일 업로드 경로 - 절대경로(CMS-EB14) 일반독자 - 이용기관신청결과 */ 
	public static String PATH_UPLOAD_RELATIVE_CMS_EB14		= PATH_UPLOAD_RELATIVE_ROOT + PATH_DIR_EB14;
	/** 파일 업로드 경로 - 절대경로(CMS-EB21) 일반독자 - 출금이체의뢰 */ 
	public static String PATH_UPLOAD_RELATIVE_CMS_EB21		= PATH_UPLOAD_RELATIVE_ROOT + PATH_DIR_EB21;
	/** 파일 업로드 경로 - 절대경로(CMS-EB22) 일반독자 - 출금이체결과 */ 
	public static String PATH_UPLOAD_RELATIVE_CMS_EB22		= PATH_UPLOAD_RELATIVE_ROOT + PATH_DIR_EB22;
	/** 파일 업로드 경로 - 절대경로(EDI-GR15) 지로 - 수납명세서 */ 
	public static String PATH_UPLOAD_RELATIVE_EDI_GR15		= PATH_UPLOAD_RELATIVE_ROOT + PATH_DIR_GR15;
	/** 파일 업로드 경로 - 절대경로(EDI-GR15) 지로 - 대행 수납명세서 */ 
	public static String PATH_UPLOAD_RELATIVE_EDI_GR15_AGENCY	= PATH_UPLOAD_RELATIVE_ROOT + PATH_DIR_GR15_AGENCY;
	/** 파일 업로드 경로 - 절대경로(EDI-GR65) 지로 - 전자납부번호 등록 */ 
	public static String PATH_UPLOAD_RELATIVE_EDI_GR65		= PATH_UPLOAD_RELATIVE_ROOT + PATH_DIR_GR65;
	/** 파일 업로드 경로 - 절대경로(EDI-MR15) 더존 바코드수납 - 수납명세서 */ 
	public static String PATH_UPLOAD_RELATIVE_EDI_MR15		= PATH_UPLOAD_RELATIVE_ROOT + PATH_DIR_MR15;
	
	/** 디렉토리 이름(EB13) 학생독자 - 이용기관신청 */
	public static String PATH_DIR_STU_EB13			= "/student" + PATH_DIR_CMS + "/EB13";
	/** 디렉토리 이름(EB14) 학생독자 - 이용기관신청결과 */
	public static String PATH_DIR_STU_EB14			= "/student" + PATH_DIR_CMS + "/EB14";
	/** 디렉토리 이름(EB21) 학생독자 - 출금이체의뢰 */
	public static String PATH_DIR_STU_EB21			= "/student" + PATH_DIR_CMS + "/EB21";
	/** 디렉토리 이름(EB22) 학생독자 - 출금이체결과 */
	public static String PATH_DIR_STU_EB22			= "/student" + PATH_DIR_CMS + "/EB22";
	
	/** 파일 업로드 경로 - 상대경로(CMS-EB13) 학생독자 - 이용기관신청 */ 
	public static String PATH_UPLOAD_ABSOLUTE_CMS_STU_EB13		= PATH_UPLOAD_ABSOLUTE_ROOT + PATH_DIR_STU_EB13;
	/** 파일 업로드 경로 - 상대경로(CMS-EB14) 학생독자 - 이용기관신청결과 */ 
	public static String PATH_UPLOAD_ABSOLUTE_CMS_STU_EB14		= PATH_UPLOAD_ABSOLUTE_ROOT + PATH_DIR_STU_EB14;
	/** 파일 업로드 경로 - 상대경로(CMS-EB21) 학생독자 - 출금이체의뢰 */ 
	public static String PATH_UPLOAD_ABSOLUTE_CMS_STU_EB21		= PATH_UPLOAD_ABSOLUTE_ROOT + PATH_DIR_STU_EB21;
	/** 파일 업로드 경로 - 상대경로(CMS-EB22) 학생독자 - 출금이체결과 */ 
	public static String PATH_UPLOAD_ABSOLUTE_CMS_STU_EB22		= PATH_UPLOAD_ABSOLUTE_ROOT + PATH_DIR_STU_EB22;
	
	/** 파일 업로드 경로 - 절대경로(CMS-EB13) 학생독자 - 이용기관신청 */ 
	public static String PATH_UPLOAD_RELATIVE_CMS_STU_EB13		= PATH_UPLOAD_RELATIVE_ROOT + PATH_DIR_STU_EB13;
	/** 파일 업로드 경로 - 절대경로(CMS-EB14) 학생독자 - 이용기관신청결과 */ 
	public static String PATH_UPLOAD_RELATIVE_CMS_STU_EB14		= PATH_UPLOAD_RELATIVE_ROOT + PATH_DIR_STU_EB14;
	/** 파일 업로드 경로 - 절대경로(CMS-EB21) 학생독자 - 출금이체의뢰 */ 
	public static String PATH_UPLOAD_RELATIVE_CMS_STU_EB21		= PATH_UPLOAD_RELATIVE_ROOT + PATH_DIR_STU_EB21;
	/** 파일 업로드 경로 - 절대경로(CMS-EB21) 학생독자 - 출금이체결과 */ 
	public static String PATH_UPLOAD_RELATIVE_CMS_STU_EB22		= PATH_UPLOAD_RELATIVE_ROOT + PATH_DIR_STU_EB22;
	
	/** 파일 업로드 경로 - 상대경로(게시판) 공지사항 */
	public static String PATH_UPLOAD_ABSOLUTE_BBS_NOTICE		= PATH_UPLOAD_ABSOLUTE_ROOT + "/bbs/notice";
	
	/** 파일 업로드 경로 - 절대경로(게시판) 공지사항 */
	public static String PATH_UPLOAD_RELATIVE_BBS_NOTICE		= PATH_UPLOAD_RELATIVE_ROOT + "/bbs/notice";
	
	/** 파일 업로드 경로 - 상대경로(게시판) 자료실 */
	public static String PATH_UPLOAD_ABSOLUTE_BBS_DATA		= PATH_UPLOAD_ABSOLUTE_ROOT + "/bbs/data";
	
	/** 파일 업로드 경로 - 절대경로(게시판) 자료실 */
	public static String PATH_UPLOAD_RELATIVE_BBS_DATA		= PATH_UPLOAD_RELATIVE_ROOT + "/bbs/data";
	
	/** 파일 업로드 경로 - 상대경로(직원게시판) */
	public static String PATH_UPLOAD_RELATIVE_BOARD_DATA	= PATH_UPLOAD_RELATIVE_ROOT + "/board";

	/** 파일 업로드 경로 - 월마감 결과 파일 */ 
	public static String PATH_UPLOAD_DEADLINE_RESULT		= PATH_UPLOAD_RELATIVE_ROOT + PATH_DIR_DEADLINE;

	/** 파일 업로드 경로 - 교육용 독자 입금 결과 파일 */ 
	public static String PATH_UPLOAD_EDUCATION_RESULT		= PATH_UPLOAD_ABSOLUTE_ROOT + PATH_DIR_EDUCATION;
	
	/** 파일 업로드 경로 - 비독자 등록 결과 파일 */ 
	public static String PATH_UPLOAD_BI_READER_RESULT		= PATH_UPLOAD_ABSOLUTE_ROOT + PATH_DIR_BI_READER;
	
	/** 파일 업로드 경로 - 소외계층 독자 입금 결과 파일 */ 
	public static String PATH_UPLOAD_ALIENATION_RESULT		= PATH_UPLOAD_ABSOLUTE_ROOT + PATH_DIR_ALIENATION;

	public static String PATH_UPLOAD_GENERATE_RESULT		= PATH_UPLOAD_ABSOLUTE_ROOT + PATH_DIR_GENERATE;
	
	public static String PATH_UPLOAD_ABC	= PATH_UPLOAD_ABSOLUTE_ROOT + PATH_DIR_ABC;
	
	public static String PATH_UPLOAD_JIDAE	= PATH_UPLOAD_ABSOLUTE_ROOT + PATH_DIR_JIDAE;
}