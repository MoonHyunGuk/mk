DECLARE

	v_cnt1 NUMBER := 0;
	v_cnt2 NUMBER := 0;
	v_cnt3 NUMBER := 0;
	v_cnt4 NUMBER := 0;
    
    v_cnt_check NUMBER := 0;
	
BEGIN
	DBMS_OUTPUT.ENABLE ;
	DBMS_OUTPUT.PUT_LINE('= 자동이체 수금이전 시작 =');
	
-- step 1 start ------------------------------------------------------------------------------------------------------------
	DBMS_OUTPUT.PUT_LINE('[step1 시작] 가장 마지막으로 처리된 자동이체 수금정보를 이전한다. (tbl_ea_log 에 ea21 상태만)');
	
	FOR tmp_list1 IN  (
		SELECT 
		  A.READNO
		  , TO_NUMBER(A.CMSMONEY) AS AMT
		  , A.SUBSMONTH AS YYMM
		  , B.UPRICE AS BILLAMT
		  , B.QTY AS BILLQTY
		  , B.BOSEQ
		  , (CASE WHEN A.CMSRESULT = '00000' THEN '021' ELSE '044' END) AS SGBBCD
		  , TO_CHAR(TO_DATE(CMSDATE,'YYMMDD'),'YYYYMMDD') AS DT_STR
		FROM
		  (
		    select 
		      USERNUMID
		      , CMSTYPE
		      , CMSDATE
		      , CMSRESULT
		      , SUBSMONTH
		      , CMSMONEY
		      , NUMID
		      , (SELECT READNO FROM TBL_USERS WHERE NUMID = USERNUMID AND ROWNUM = 1) AS READNO
		    from 
		      TBL_EA_LOG
		    where
		      CMSDATE = (SELECT MAX(CMSDATE) FROM TBL_EA_LOG WHERE CMSTYPE = 'EA21')
		      AND
		      CMSTYPE = 'EA21'
		  )A
		  , ( 
		    SELECT * FROM TM_READER_NEWS 
		    WHERE NEWSCD = '100' AND SEQ = '0001'
		  ) B
		WHERE
		  A.READNO = B.READNO

	) LOOP
    	SELECT COUNT(*) INTO v_cnt_check FROM TM_READER_SUGM WHERE READNO = tmp_list1.READNO AND NEWSCD = '100' AND YYMM = tmp_list1.YYMM AND SEQ = '0001';
		
		if ( v_cnt_check > 0 ) then
			UPDATE TM_READER_SUGM SET 
				BOSEQ = tmp_list1.BOSEQ , SGBBCD = tmp_list1.SGBBCD , SGGBCD = '021' , BILLAMT = tmp_list1.BILLAMT , BILLQTY = tmp_list1.BILLQTY
				, SGYYMM = '201112' , AMT = tmp_list1.AMT , SNDT = tmp_list1.DT_STR , ICDT = tmp_list1.DT_STR , CLDT = tmp_list1.DT_STR
			WHERE
				READNO = tmp_list1.READNO AND NEWSCD = '100' AND YYMM = tmp_list1.YYMM AND SEQ = '0001';
				
			v_cnt1 := v_cnt1+1;
		else
			INSERT INTO TM_READER_SUGM (
				READNO ,NEWSCD ,YYMM ,SEQ ,BOSEQ ,SGBBCD 
				,SGGBCD ,BILLAMT ,BILLQTY ,SGYYMM ,AMT ,SNDT ,ICDT ,CLDT
			) values(
				tmp_list1.READNO ,'100' ,tmp_list1.YYMM ,'0001' ,tmp_list1.BOSEQ ,tmp_list1.SGBBCD
				,'021' ,tmp_list1.BILLAMT ,tmp_list1.BILLQTY ,'201112' ,tmp_list1.AMT ,tmp_list1.DT_STR ,tmp_list1.DT_STR ,tmp_list1.DT_STR
			);
			
			v_cnt2 := v_cnt2+1;
		end if;
	
	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('[step1 완료] update : ' || v_cnt1 || ', insert : ' || v_cnt2 || ' 개의 데이터가 처리되었습니다');
-- step 1 end --------------------------------------------------------------------------------------------------------------

-- step 2 start ------------------------------------------------------------------------------------------------------------
	DBMS_OUTPUT.PUT_LINE('[step2 시작] 가장 마지막으로 처리된 자동이체 수금정보를 이전한다. (tbl_ea_log_stu 에 ea21 상태만)');
	
	FOR tmp_list2 IN  (
		SELECT 
		  A.READNO
		  , TO_NUMBER(A.CMSMONEY) AS AMT
		  , A.SUBSMONTH AS YYMM
		  , B.UPRICE AS BILLAMT
		  , B.QTY AS BILLQTY
		  , B.BOSEQ
		  , (CASE WHEN A.CMSRESULT = '00000' THEN '021' ELSE '044' END) AS SGBBCD
		  , TO_CHAR(TO_DATE(CMSDATE,'YYMMDD'),'YYYYMMDD') AS DT_STR
		FROM
		  (
		    select 
		      USERNUMID
		      , CMSTYPE
		      , CMSDATE
		      , CMSRESULT
		      , SUBSMONTH
		      , CMSMONEY
		      , NUMID
		      , (SELECT READNO FROM TBL_USERS_STU WHERE NUMID = USERNUMID AND ROWNUM = 1) AS READNO
		    from 
		      TBL_EA_LOG_STU
		    where
		      CMSDATE IN ('111212','111223')
		      AND
		      CMSTYPE = 'EA21'
		  )A
		  , ( 
		    SELECT * FROM TM_READER_NEWS 
		    WHERE NEWSCD = '100' AND SEQ = '0001'
		  ) B
		WHERE
		  A.READNO = B.READNO

	) LOOP
    	SELECT COUNT(*) INTO v_cnt_check FROM TM_READER_SUGM WHERE READNO = tmp_list2.READNO AND NEWSCD = '100' AND YYMM = tmp_list2.YYMM AND SEQ = '0001';
		
		if ( v_cnt_check > 0 ) then
			UPDATE TM_READER_SUGM SET 
				BOSEQ = tmp_list2.BOSEQ , SGBBCD = tmp_list2.SGBBCD , SGGBCD = '021' , BILLAMT = tmp_list2.BILLAMT , BILLQTY = tmp_list2.BILLQTY
				, SGYYMM = '201112' , AMT = tmp_list2.AMT , SNDT = tmp_list2.DT_STR , ICDT = tmp_list2.DT_STR , CLDT = tmp_list2.DT_STR
			WHERE
				READNO = tmp_list2.READNO AND NEWSCD = '100' AND YYMM = tmp_list2.YYMM AND SEQ = '0001';
				
			v_cnt3 := v_cnt3+1;
		else
			INSERT INTO TM_READER_SUGM (
				READNO ,NEWSCD ,YYMM ,SEQ ,BOSEQ ,SGBBCD 
				,SGGBCD ,BILLAMT ,BILLQTY ,SGYYMM ,AMT ,SNDT ,ICDT ,CLDT
			) values(
				tmp_list2.READNO ,'100' ,tmp_list2.YYMM ,'0001' ,tmp_list2.BOSEQ ,tmp_list2.SGBBCD
				,'021' ,tmp_list2.BILLAMT ,tmp_list2.BILLQTY ,'201112' ,tmp_list2.AMT ,tmp_list2.DT_STR ,tmp_list2.DT_STR ,tmp_list2.DT_STR
			);
			
			v_cnt4 := v_cnt4+1;
		end if;
	
	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('[step2 완료] update : ' || v_cnt3 || ', insert : ' || v_cnt4 || ' 개의 데이터가 처리되었습니다');
-- step 2 end --------------------------------------------------------------------------------------------------------------

	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('= 자동이체 수금이전 완료(Commit적용됨) =');
	
EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
		DBMS_OUTPUT.PUT_LINE('= 자동이체 수금이전 에러(Rollback적용됨) = '||SQLERRM);
END;