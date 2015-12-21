/*------------------------------------------------------------------------------
-- 객체명 : MKDEV.FUNC_MONTH_DEADLINE
-- 생성일 : 2011-12-01 오후 5:38:36
-- 최종수정일 : 2012-01-02 오후 5:30:28
-- 상태 : VALID
------------------------------------------------------------------------------*/

CREATE OR REPLACE FUNCTION                                     FUNC_MONTH_DEADLINE_EB21_STU (






    IV_READNO    IN    VARCHAR2    -- 독자번호
)
    RETURN  VARCHAR2 IS
/*=================================================================================================
-- SF명     : FUNC_MONTH_DEADLINE_EB21_STU
-- 기능명   : 독자테이블과 수금테이블을 조회해서 마감작업(학생본사 EB21프로세스)
-- 작성일자 : 2011/12/10
-- 작성자   : 서영현

=================================================================================================*/
    MSG      VARCHAR2(255)     :=   '';     -- 결과 메시지
    RESULT_COUNT INTEGER;

    CURSOR READER(P_READNO VARCHAR2) IS
     SELECT READNO, NEWSCD, SEQ, BOSEQ, SGTYPE, UPRICE, QTY FROM TM_READER_NEWS A
		WHERE READNO = P_READNO
    AND
    BNO != '999'
		AND SGBGMM <= (SELECT TO_CHAR(SYSDATE,'YYYYMM') FROM DUAL)
		AND
		(SELECT YYMM FROM TM_READER_SUGM B
        WHERE B.READNO = P_READNO
    AND A.READNO = B.READNO
		AND A.NEWSCD = B.NEWSCD
		AND A.SEQ = B.SEQ
		AND B.YYMM = (SELECT TO_CHAR(SYSDATE,'YYYYMM') FROM DUAL)) IS NULL;

	PRAGMA autonomous_transaction;

BEGIN
	RESULT_COUNT :=0;
	FOR DEADLINECUR IN READER(IV_READNO) LOOP

		 INSERT INTO TM_READER_SUGM
		(READNO, NEWSCD, YYMM, SEQ, BOSEQ, SGBBCD, SGGBCD, BILLAMT, BILLQTY, INDT, INPS)
		 VALUES
		 (DEADLINECUR.READNO, DEADLINECUR.NEWSCD, (SELECT TO_CHAR(SYSDATE,'YYYYMM') FROM DUAL)
        , DEADLINECUR.SEQ, DEADLINECUR.BOSEQ,
         '044', DEADLINECUR.SGTYPE, DEADLINECUR.UPRICE, DEADLINECUR.QTY, SYSDATE, 'SYSTEM' );
	RESULT_COUNT := RESULT_COUNT + 1;
	END LOOP;

	MSG := 'SUCCESS FUNC_MONTH_DEADLINE_EB21_STU READNO ='||IV_READNO||' COUNT ='||RESULT_COUNT;
    COMMIT;
	RETURN  MSG;

    EXCEPTION
    	WHEN INVALID_CURSOR THEN
        	MSG   :=   'FAIL FUNC_MONTH_DEADLINE_EB21_STU READNO ='||IV_READNO||' INVALID_CURSOR_ERROR';
            ROLLBACK;
            RETURN MSG;
        WHEN   TOO_MANY_ROWS   THEN
        	MSG   :=   'FAIL FUNC_MONTH_DEADLINE_EB21_STU READNO ='||IV_READNO||' TOO_MANY_ROWS_ERROR';
            ROLLBACK;
            RETURN MSG;
        WHEN DUP_VAL_ON_INDEX THEN
        	MSG   :=   'FAIL FUNC_MONTH_DEADLINE_EB21_STU READNO ='||IV_READNO||' DUP_VAL_ON_INDEX_ERROR';
            ROLLBACK;
            RETURN MSG;
        WHEN OTHERS THEN
            MSG   :=   'FAIL FUNC_MONTH_DEADLINE_EB21_STU READNO ='||IV_READNO||' OTHERS_ERROR';
            ROLLBACK;
            RETURN MSG;

END FUNC_MONTH_DEADLINE_EB21_STU;