/*------------------------------------------------------------------------------
-- 객체명 : MKCRM.FUNC_MONTH_DEADLINE
-- 생성일 : 2011-12-01 오후 5:38:36
-- 최종수정일 : 2011-12-08 오후 1:30:28
-- 상태 : VALID
------------------------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION                                     MKCRM.FUNC_MONTH_DEADLINE (







    IV_BOSEQ    IN    VARCHAR2    -- 지국번호
    ,IV_YYMM    IN    VARCHAR2    -- 마감월
)
    RETURN  VARCHAR2 IS
/*=================================================================================================
-- SF명     : FUNC_MONTH_DEADLINE
-- 기능명   : 독자테이블과 수금테이블을 조회해서 마감작업
-- 작성일자 : 2011/12/02
-- 작성자   : 박경주

=================================================================================================*/
    MSG      VARCHAR2(255)     :=   '';     -- 결과 메시지
    RESULT_COUNT INTEGER;

    CURSOR READER(P_BOSEQ VARCHAR2, P_YYMM VARCHAR2) IS
     SELECT READNO, NEWSCD, SEQ, BOSEQ, SGTYPE, UPRICE, QTY FROM TM_READER_NEWS A
		WHERE BOSEQ = P_BOSEQ
		AND BNO != '999'
		AND SGBGMM <= P_YYMM
        AND READTYPECD ! = '021' AND READTYPECD ! = '022'
		AND
		(SELECT YYMM FROM TM_READER_SUGM B
        WHERE A.READNO = B.READNO
		AND A.NEWSCD = B.NEWSCD
		AND A.SEQ = B.SEQ
		AND B.YYMM = P_YYMM) IS NULL;

	PRAGMA autonomous_transaction;

BEGIN
	RESULT_COUNT :=0;
	FOR DEADLINECUR IN READER(IV_BOSEQ, IV_YYMM) LOOP

		 INSERT INTO TM_READER_SUGM
		(READNO, NEWSCD, YYMM, SEQ, BOSEQ, SGBBCD, SGGBCD, BILLAMT, BILLQTY, INDT, INPS)
		 VALUES
		 (DEADLINECUR.READNO, DEADLINECUR.NEWSCD, IV_YYMM, DEADLINECUR.SEQ, DEADLINECUR.BOSEQ,
         '044', DEADLINECUR.SGTYPE, DEADLINECUR.UPRICE, DEADLINECUR.QTY, SYSDATE, 'SYSTEM' );
	RESULT_COUNT := RESULT_COUNT + 1;
	END LOOP;

	MSG := 'SUCCESS FUNC_MONTH_DEADLINE BOSEQ ='||IV_BOSEQ||' COUNT ='||RESULT_COUNT;
    COMMIT;
	RETURN  MSG;

    EXCEPTION
    	WHEN INVALID_CURSOR THEN
        	MSG   :=   'FAIL FUNC_MONTH_DEADLINE BOSEQ ='||IV_BOSEQ||' INVALID_CURSOR_ERROR';
            ROLLBACK;
            RETURN MSG;
        WHEN   TOO_MANY_ROWS   THEN
        	MSG   :=   'FAIL FUNC_MONTH_DEADLINE BOSEQ ='||IV_BOSEQ||' TOO_MANY_ROWS_ERROR';
            ROLLBACK;
            RETURN MSG;
        WHEN DUP_VAL_ON_INDEX THEN
        	MSG   :=   'FAIL FUNC_MONTH_DEADLINE BOSEQ ='||IV_BOSEQ||' DUP_VAL_ON_INDEX_ERROR';
            ROLLBACK;
            RETURN MSG;
        WHEN OTHERS THEN
            MSG   :=   'FAIL FUNC_MONTH_DEADLINE BOSEQ ='||IV_BOSEQ||' OTHERS_ERROR';
            ROLLBACK;
            RETURN MSG;

END FUNC_MONTH_DEADLINE;

