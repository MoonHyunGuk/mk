CREATE OR REPLACE FUNCTION FUNC_CHECK_DIGIT_BILLAMT ( bill_Amt Varchar2)
          RETURN CHAR IS 
          
    Result CHAR;
    Tot_Sum INTEGER := 0;
    i INTEGER := 1;
    Sum_tot Varchar2(4);
    ChkDigit Varchar2(20);
    Modsum INTEGER;

BEGIN

    ChkDigit := SUBSTR('137137137137137137137137137137137137137137137137', -LENGTH(bill_Amt));

    
    FOR i IN 1..LENGTH(bill_Amt) LOOP
        Sum_tot := SUBSTR(bill_Amt,i,1) * SUBSTR(ChkDigit,i,1);
        Tot_Sum := Tot_Sum + Sum_tot;
       
    END LOOP;
    
    Modsum := MOD(Tot_Sum, 10);
    Result := SUBSTR(10 - Modsum, -1, 1);

    RETURN Result;
    
END;