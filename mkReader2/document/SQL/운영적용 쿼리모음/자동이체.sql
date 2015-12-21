-- 에러로그를 위한 컬럼 생성
ALTER TABLE tbl_EA21_log ADD ERR_STR CLOB;
COMMIT;
ALTER TABLE tbl_EA21_log_stu ADD ERR_STR CLOB;
COMMIT;

-- 기존 number type인 serial 컬럼을 안쓰고 8자리 varchar(8)인 serialno 쓰기 위해서.
ALTER TABLE tbl_cmsdata ADD SERIALNO VARCHAR(8);
ALTER TABLE tbl_cmsdata drop COLUMN SERIAL;
COMMIT;
ALTER TABLE tbl_cmsdata_stu ADD SERIALNO VARCHAR(8);
ALTER TABLE tbl_cmsdata_stu drop COLUMN SERIAL;
COMMIT;

-- 실제 사용할 지국코드를 위해 (tbl_users의 jikuk 은 금결원과 통신을 위해 변하지 않는 값임. 독자이전 시 지국코드 변경해줘야함.) 
ALTER TABLE TBL_USERS ADD REALJIKUK VARCHAR(6);
COMMIT;
ALTER TABLE TBL_USERS_STU ADD REALJIKUK VARCHAR(6);
COMMIT;

-- 수금처리를 위해 독자번호 필요
ALTER TABLE tbl_EA_log ADD READNO VARCHAR(9);
COMMIT;
ALTER TABLE tbl_EA_log_stu ADD READNO VARCHAR(9);
COMMIT;

-- 자동이체 파일 생성하기 위해 userid 컬럼에 not null 조건 제거
ALTER TABLE TBL_EA_LOG MODIFY (USERID VARCHAR2(50) NULL);
COMMIT;
ALTER TABLE TBL_EA_LOG_STU MODIFY (USERID VARCHAR2(50) NULL);
COMMIT;

-- EB12 로그테이블 생성
CREATE TABLE TBL_EA12_LOG (
    NUMID      NUMBER(19)        NOT NULL,
    LOGDATE    DATE              NOT NULL,
    MEMO       CLOB                  NULL,
    ERR_STR    CLOB                  NULL,
    ADMINID    NVARCHAR2(50)         NULL
  );

COMMENT ON TABLE TBL_EA12_LOG IS 'EB12로그';
COMMENT ON COLUMN TBL_EA12_LOG.NUMID IS '순차번호';
COMMENT ON COLUMN TBL_EA12_LOG.LOGDATE IS '입력날짜';
COMMENT ON COLUMN TBL_EA12_LOG.MEMO IS '메모';
COMMENT ON COLUMN TBL_EA12_LOG.ERR_STR IS '에러내용';
COMMENT ON COLUMN TBL_EA12_LOG.ADMINID IS '처리자 ID';
COMMIT;