CREATE OR REPLACE FUNCTION FUNC_GET_CLAMLIST2 (
    in_readno IN VARCHAR2    --독자번호
   ,in_newscd IN VARCHAR2    --매체코드
   ,in_seq  IN VARCHAR2
   ,in_yyyy  IN VARCHAR2 --년도 
)
    RETURN  VARCHAR2 IS

/*=================================================================================================
-- SF명     : FUNC_GET_CLAMLIST2
-- 시스템명 : 
-- 업무명   : 
-- 기능명   : 입력받은 해의 12개월 수금이력을 약어로 구성해 반환한다.
-- 작성일자 : 2011/11/24
-- 작성자   : 유진영 

=================================================================================================*/

    rv_return   VARCHAR2(12) := '------------';
    rv_fr_yymm  VARCHAR2(6)  := '';  --검색시작월
    rv_to_yymm  VARCHAR2(6)  := '';  --검색종료월

    rv_curryymm VARCHAR2(6)  := '';  --당월

    rv_bisiyymm VARCHAR2(6)  := '';  --년초기준년월

    CURSOR MEDI(P_READNO VARCHAR2, P_NEWSCD VARCHAR2, P_SEQ VARCHAR2, P_FR_YYMM VARCHAR2, P_TO_YYMM VARCHAR2, P_CURRYYMM VARCHAR2) IS
     SELECT
          SUBSTR(YYMM,5) AS YYMM
          ,
          CASE
            WHEN P_CURRYYMM > YYMM THEN
           LOWER( FUNC_COMMON_CDYNM ('119', SGBBCD))
         ELSE
          UPPER( FUNC_COMMON_CDYNM ('119', SGBBCD))
       END
          AS CLAMTYNM   -- 수금구분(방법)
     FROM
          TM_READER_SUGM
     WHERE
          READNO = P_READNO
      AND NEWSCD = P_NEWSCD
   AND SEQ    = P_SEQ
      AND YYMM BETWEEN P_FR_YYMM AND  P_TO_YYMM
     ORDER BY
       YYMM;

BEGIN

	rv_curryymm := in_yyyy||TO_CHAR(SYSDATE,'mm'); --당월구하기
	
	rv_fr_yymm :=  in_yyyy||'01'; --시작월
	
	rv_to_yymm :=  in_yyyy||'12';  --종료월
	
	rv_bisiyymm := SUBSTR(rv_curryymm,1,4)||'01';  --년초기준년월

	FOR MEDICUR IN MEDI(in_readno, in_newscd, in_seq, rv_fr_yymm, rv_to_yymm, rv_bisiyymm) LOOP

		rv_return := SUBSTR(rv_return, 1, TO_NUMBER(MEDICUR.YYMM)-1) || MEDICUR.CLAMTYNM || SUBSTR(rv_return, TO_NUMBER(MEDICUR.YYMM)+1);
	
	END LOOP;

    RETURN rv_return;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            rv_return   :=   '------------';
            RETURN rv_return;
        WHEN OTHERS THEN
            rv_return   :=   '------------';
            RETURN rv_return;

END FUNC_GET_CLAMLIST2;