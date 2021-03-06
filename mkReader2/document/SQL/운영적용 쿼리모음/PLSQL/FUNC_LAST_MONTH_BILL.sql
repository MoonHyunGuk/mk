 CREATE OR REPLACE FUNCTION FUNC_LAST_MONTH_BILL (
    in_boseq IN VARCHAR2    --지국번호
   ,in_newscd IN VARCHAR2   --매체코드
   ,in_readno  IN VARCHAR2  --독자번호
   ,in_gno  IN VARCHAR2     --구역번호
   ,in_yymm  IN VARCHAR2    --년도 
)
    RETURN  VARCHAR2 IS
     rv_return   VARCHAR2(30);

/*=================================================================================================
-- SF명     : FUNC_LAST_MONTH_BILL
-- 시스템명 : 
-- 업무명   : 
-- 기능명   : 방문영수증 출력시 전월분 수금내역을 구성해 반환한다.
-- 작성일자 : 2011/11/24
-- 작성자   : 유진영 

=================================================================================================*/


BEGIN
         SELECT X.YYMM||'/'||X.SNDT||'('||X.SGBBCD||')' LASTBILL
           INTO rv_return
           FROM (SELECT SUBSTR(A.YYMM,3,4) YYMM, 
                        TO_CHAR(TO_DATE(A.SNDT,'YYMMDD'),'YY-MM-DD') SNDT, 
                        FUNC_COMMON_CDYNM ('119', A.SGBBCD) SGBBCD
                  FROM TM_READER_SUGM A, 
                       TM_READER_NEWS B
                 WHERE A.BOSEQ = B.BOSEQ
                   AND A.NEWSCD = B.NEWSCD
                   AND A.READNO = B.READNO
                   AND A.SEQ = B.SEQ
                   AND B.GNO = in_gno
                   AND A.BOSEQ = in_boseq
                   AND A.NEWSCD = in_newscd
                   AND A.READNO = in_readno
                   AND A.SGBBCD != '044'
                   AND A.YYMM < in_yymm
                   ORDER BY A.YYMM DESC
                 ) X
          WHERE ROWNUM = 1;

    RETURN rv_return;

END FUNC_LAST_MONTH_BILL;