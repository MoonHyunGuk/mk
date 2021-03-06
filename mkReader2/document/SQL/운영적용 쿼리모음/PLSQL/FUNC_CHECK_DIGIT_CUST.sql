CREATE OR REPLACE FUNCTION FUNC_CHECK_DIGIT_CUST ( Cust_No Varchar2)
          RETURN CHAR IS 
          
    Result CHAR;
    Tot_Sum INTEGER := 0;
    i INTEGER := 1;
    k INTEGER := 1;
    Sum_tot Varchar2(4);
    ChkDigit Varchar2(20);
    Modsum INTEGER;

BEGIN

    ChkDigit := SUBSTR('12121212121212121212121212121212121212121212121212', -LENGTH(Cust_No));
    
    FOR i IN 1..LENGTH(Cust_No) LOOP
        Sum_tot := SUBSTR(Cust_No,i,1) * SUBSTR(ChkDigit,i,1);

        FOR k IN 1..LENGTH(Sum_tot) LOOP
            Tot_Sum := Tot_Sum + SUBSTR(Sum_tot,k,1);
        END LOOP;        
    END LOOP;
    
    Modsum := MOD(Tot_Sum, 10);
    Result := SUBSTR(10 - Modsum, -1, 1);

    RETURN Result;
    
END;