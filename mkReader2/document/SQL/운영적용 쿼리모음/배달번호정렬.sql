/*------------------------------------------------------------------------------
-- 객체명 : MKCRM.FUNC_DELIVERY_NUM_SORT
-- 생성일 : 2011-12-13 오전 11:03:43
-- 최종수정일 : 2011-12-30 오전 9:44:33
-- 상태 : VALID
------------------------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION                                             MKCRM.FUNC_DELIVERY_NUM_SORT (








    IV_BOSEQ    IN    VARCHAR2    -- 지국번호
    ,IV_GNO    IN    VARCHAR2    -- 구역번호
)
    RETURN  VARCHAR2 IS
/*=================================================================================================
-- SF명     : FUNC_DELIVERY_NUM_SORT
-- 기능명   : 배달 번호 정렬
-- 작성일자 : 2011/12/02
-- 작성자   : 박경주

=================================================================================================*/
    MSG      VARCHAR2(255)     :=   '';     -- 결과 메시지
    RESULT_COUNT	INTEGER;

    CURSOR DELIVERYNUM(P_BOSEQ VARCHAR2, P_GNO VARCHAR2) IS
		SELECT
			READNO , NEWSCD , GNO , SEQ ,BNO , SNO FROM
		TM_READER_NEWS
		WHERE
			BOSEQ = P_BOSEQ
			AND BNO != '999'
			AND GNO = P_GNO
			ORDER BY BNO, SNO;

	PRAGMA autonomous_transaction;
BEGIN
	RESULT_COUNT :=1;

	FOR GNOCUR IN DELIVERYNUM(IV_BOSEQ, IV_GNO) LOOP
		IF RESULT_COUNT < 999 THEN
        	UPDATE TM_READER_NEWS SET
				BNO = lPad(RESULT_COUNT, 3, '0') , SNO = ''
			WHERE
				BOSEQ=IV_BOSEQ AND READNO=GNOCUR.READNO AND NEWSCD=GNOCUR.NEWSCD AND SEQ=GNOCUR.SEQ;
       ELSE
           UPDATE TM_READER_NEWS SET
				BNO = '998' , SNO = lPad(RESULT_COUNT-998, 2, '0')
			WHERE
				BOSEQ=IV_BOSEQ AND READNO=GNOCUR.READNO AND NEWSCD=GNOCUR.NEWSCD AND SEQ=GNOCUR.SEQ;
       END IF;

       RESULT_COUNT := RESULT_COUNT + 1;

	END LOOP;

	MSG := RESULT_COUNT-1;
    COMMIT;
	RETURN 'SUCCESS FUNC_DELIVERY_NUM_SORT  BOSEQ='||IV_BOSEQ||' GNO='||IV_GNO||' COUNT='|| MSG;


    EXCEPTION
    	WHEN INVALID_CURSOR THEN
        	MSG   :=  'FAIL FUNC_DELIVERY_NUM_SORT  BOSEQ='||IV_BOSEQ||' GNO='||IV_GNO||' INVALID_CURSOR_ERROR' ;
            ROLLBACK;
            RETURN MSG;
        WHEN   TOO_MANY_ROWS   THEN
        	MSG   :=  'FAIL FUNC_DELIVERY_NUM_SORT  BOSEQ='||IV_BOSEQ||' GNO='||IV_GNO||' TOO_MANY_ROWS_ERROR' ;
            ROLLBACK;
            RETURN MSG;
        WHEN DUP_VAL_ON_INDEX THEN
        	MSG   :=  'FAIL FUNC_DELIVERY_NUM_SORT  BOSEQ='||IV_BOSEQ||' GNO='||IV_GNO||' DUP_VAL_ON_INDEX_ERROR' ;
            ROLLBACK;
            RETURN MSG;
        WHEN OTHERS THEN
            MSG   :=  'FAIL FUNC_DELIVERY_NUM_SORT  BOSEQ='||IV_BOSEQ||' GNO='||IV_GNO||' OTHERS_ERROR' ;
            ROLLBACK;
            RETURN MSG;

END FUNC_DELIVERY_NUM_SORT;

