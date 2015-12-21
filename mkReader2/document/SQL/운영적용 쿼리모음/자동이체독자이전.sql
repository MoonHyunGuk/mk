DECLARE

	v_cnt1 NUMBER := 0;
	v_cnt21 NUMBER := 0;
	v_cnt22 NUMBER := 0;
	v_cnt3 NUMBER := 0;
	v_cnt4 NUMBER := 0;
	v_cnt51 NUMBER := 0;
	v_cnt52 NUMBER := 0;
	v_cnt6 NUMBER := 0;
	
	v_cnttmp NUMBER := 0;
	
    read_no VARCHAR2(9) := '';	
	juminnum VARCHAR2(13) := '';
	saupja VARCHAR2(13) := '';
	readtypecd VARCHAR2(3) := '';
	
	reader_bno VARCHAR2(3) := '';

BEGIN
	DBMS_OUTPUT.ENABLE ;
	DBMS_OUTPUT.PUT_LINE('= 자동이체 독자이전 시작 =');
	
	--필수 : 이 스크립트를 실행하기 전에 아래 인덱스 생성문을 oracle client에서 먼저 실행한다.
	--CREATE INDEX IDX_TBL_USERS_1   ON  TBL_USERS (NUMID ) ;
	--CREATE INDEX IDX_TBL_USERS_STU_1   ON  TBL_USERS_STU (NUMID ) ;
	--CREATE INDEX IDX_TM_READER_NEWS_1 	ON TM_READER_NEWS (SGTYPE);
	--CREATE INDEX tm_reader_sugm_1 	ON tm_reader_sugm (sgbbcd, readno);
	--commit;

-- step 1 : 일반,지국독자 이전 - jikuk+readno 조합이 2개이상 있는 경우 
	--FOR tmp_list IN  (SELECT readno FROM tm_reader_news where sgtype = '021') LOOP
		-- 수금 테이블에 자동이체이면서 미수인 건들 결손처리
		--update tm_reader_sugm set sgbbcd = '031' 
		--where sgbbcd = '044' and readno = tmp_list.readno;
		--v_cnt1 := v_cnt1+1;
	--END LOOP;
	-- 구독정보 테이블에 자동이체인 것들 중지
	--update tm_reader_news set STDT = to_char(sysdate,'YYYYMMDD'), BNO = '999', STSAYOU = '099' where sgtype = '021';
	--DBMS_OUTPUT.PUT_LINE('데이터 처리 완료 : step1');
    --DBMS_OUTPUT.PUT_LINE(v_cnt1 || '개의 데이터가 처리되었습니다');
    
	
-- step 1 start ------------------------------------------------------------------------------------------------------------
	DBMS_OUTPUT.PUT_LINE('[step1 시작] 일반,지국학생 독자이전 - jikuk, readno 가 빈값이 아니면서 jikuk+readno 조합이 2개이상 있는 경우 EA21,EA13 상태만 insert');
	FOR tmp_list1 IN  (
		select B.* 
		from 
			tbl_users B 
			,( 
				select A.jikuk, A.readno 
				from ( 
					select * from tbl_users where status != 'EA99' and status != 'XX' and trim(jikuk) is not null 
				) A 
				where trim(A.readno) is not null 
				group by A.jikuk, A.readno having count(A.readno) >= 2
	    	) C
		where 
		    B.jikuk = C.jikuk
		    and B.readno = C.readno
		    and (status = 'EA21' or status = 'EA13')
		order by 
			B.rdate
	) LOOP
	
		select to_char(nvl(max(readno),0)+1) into read_no from tm_reader;
		
		-- 주민번호 or 사업자번호
		if (length(trim(tmp_list1.saup)) = 13) then
			juminnum := trim(tmp_list1.saup);	-- 주민등록번호
		else
			saupja := trim(tmp_list1.saup);		-- 사업자등록번호
		end if;
		
		-- 독자유형
		if (trim(tmp_list1.gubun) = '학생') then
			readtypecd := '012';				-- 학생지국
		else
			readtypecd := '011';				-- 일반
		end if;
		
		-- 통합독자 테이블에 신규로 등록
		insert into tm_reader (
			READNO,PRN,ERNNO,BIDT,INDT
		) values(
			read_no, juminnum, saupja, to_char(tmp_list1.birthd,'YYYYMMDD'), tmp_list1.rdate
		);
		
		-- 구독정보 테이블에 신규로 등록
		-- READTYPECD 일반:'011', 학생지국:'012', 학생본사:'013' 
		insert into tm_reader_news (
			READNO,NEWSCD,SEQ,BOSEQ,GNO,BNO,READTYPECD,READNM,
			HOMETEL1,HOMETEL2,HOMETEL3,MOBILE1,MOBILE2,MOBILE3,
			DLVZIP,DLVADRS1,DLVADRS2,SGTYPE,
			UPRICE,QTY,
			SGBGMM,SGCYCLE,APLCDT,INDT
		) values (
			read_no, '100', '0001', tmp_list1.JIKUK, '200', '000', readtypecd, tmp_list1.USERNAME,
			SUBSTR(regexp_substr(tmp_list1.phone ,'[^-]*'),0,4),
			SUBSTR(regexp_substr(substr(tmp_list1.phone ,regexp_instr(tmp_list1.phone,'-')+1,length(tmp_list1.phone)),'[^-]*'),0,4),
			SUBSTR(regexp_substr(tmp_list1.phone ,'[^-]*$',3),0,4),
			SUBSTR(regexp_substr(tmp_list1.handy ,'[^-]*'),0,4),
			SUBSTR(regexp_substr(substr(tmp_list1.handy ,regexp_instr(tmp_list1.handy,'-')+1,length(tmp_list1.handy)),'[^-]*'),0,4),
			SUBSTR(regexp_substr(tmp_list1.handy ,'[^-]*$',3),0,4),
			tmp_list1.ZIP1 || tmp_list1.ZIP2, substrb(tmp_list1.ADDR1,0,100), substrb(tmp_list1.ADDR2,0,100), '021', 
			to_number(trim(tmp_list1.BANK_MONEY)), to_number(trim(tmp_list1.BUSU)), 
			to_char(tmp_list1.SDATE,'YYYYMM'), 1, to_char(tmp_list1.SDATE,'YYYYMMDD'), tmp_list1.RDATE
		);
	        
		-- 자동이체독자정보(일반) 테이블에 readno를 넣어준다
		update tbl_users set readno = read_no, realjikuk = jikuk where numid = tmp_list1.numid;
		
		v_cnt1 := v_cnt1+1;
			
	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('[step1 완료] insert : ' || v_cnt1 || ' 개의 데이터가 처리되었습니다');
-- step 1 end --------------------------------------------------------------------------------------------------------------
	
-- step 2 start ------------------------------------------------------------------------------------------------------------
	DBMS_OUTPUT.PUT_LINE('[step2 시작] 일반,지국학생 독자이전 - jikuk, readno 가 빈값이 아니면서 jikuk+readno 조합이 1개 있는 경우  news에 없으면 insert 있으면 update');
	FOR tmp_list2 IN  (
		select B.* 
		from 
		    tbl_users B
		    , (
		          select A.jikuk, A.readno from (
		              select * from tbl_users where status != 'EA99' and status != 'XX' and trim(jikuk) is not null
		          ) A
		          where trim(A.readno) is not null 
		          group by A.jikuk, A.readno having count(A.readno) = 1
		    ) C
		where 
		    B.jikuk = C.jikuk
		    and B.readno = C.readno
		    and B.status != 'EA99' 
		    and B.status != 'XX'
		order by 
			B.rdate
	) LOOP
		
		-- 독자유형
		if (trim(tmp_list2.gubun) = '학생') then
			readtypecd := '012';				-- 학생지국
		else
			readtypecd := '011';				-- 일반
		end if;
			
		if (length(trim(tmp_list2.jikuk)) = 6 and length(trim(tmp_list2.readno)) = 5) then
			
			select count(*) into v_cnttmp from tm_reader_news where boseq = tmp_list2.jikuk and boreadno = tmp_list2.readno and seq = '0001';
			
			if ( v_cnttmp = 1 ) then
				select readno into read_no from tm_reader_news where boseq = tmp_list2.jikuk and boreadno = tmp_list2.readno and seq = '0001';
			else
				read_no := '';
			end if;
		else
			read_no := '';
		end if;
		
		if (length(trim(read_no)) = 9 ) then
			-- 자동이체독자정보(일반) 테이블에 readno를 넣어준다
			update tbl_users set readno = read_no, realjikuk = tmp_list2.jikuk where numid = tmp_list2.numid;
			
			select bno into reader_bno from tm_reader_news where readno = read_no and newscd = '100' and seq = '0001';
			
			if (reader_bno = '999') then	-- 중지독자면 구역/배달번호를 200/000 으로 수정한다.
				update tm_reader_news 
				set 
					sgtype = '021'
					, sgbgmm = to_char(tmp_list2.SDATE,'YYYYMM')
					, uprice = to_number(trim(tmp_list2.BANK_MONEY))
					, qty = to_number(trim(tmp_list2.BUSU))
					, gno = '200'
					, bno = '000'
					, READTYPECD = readtypecd
					, readnm = tmp_list2.USERNAME
				where 
					readno = read_no and newscd = '100' and seq = '0001';
			else
				update tm_reader_news 
				set 
					sgtype = '021'
					, sgbgmm = to_char(tmp_list2.SDATE,'YYYYMM')
					, uprice = to_number(trim(tmp_list2.BANK_MONEY))
					, qty = to_number(trim(tmp_list2.BUSU))
					, READTYPECD = readtypecd
					, readnm = tmp_list2.USERNAME
				where 
					readno = read_no and newscd = '100' and seq = '0001';
			end if;
			
			v_cnt21 := v_cnt21+1;
			
		else
			-- 주민번호 or 사업자번호
			if (length(trim(tmp_list2.saup)) = 13) then
				juminnum := trim(tmp_list2.saup);	-- 주민등록번호
			else
				saupja := trim(tmp_list2.saup);		-- 사업자등록번호
			end if;
		
			select to_char(nvl(max(readno),0)+1) into read_no from tm_reader;
			
			-- 통합독자 테이블에 신규로 등록
			insert into tm_reader (
				READNO,PRN,ERNNO,BIDT,INDT
			) values(
				read_no, juminnum, saupja, to_char(tmp_list2.birthd,'YYYYMMDD'), tmp_list2.rdate
			);
			
			-- 구독정보 테이블에 신규로 등록
			-- READTYPECD 일반:'011', 학생지국:'012', 학생본사:'013' 
			insert into tm_reader_news (
				READNO,NEWSCD,SEQ,BOSEQ,GNO,BNO,READTYPECD,READNM,
				HOMETEL1,HOMETEL2,HOMETEL3,MOBILE1,MOBILE2,MOBILE3,
				DLVZIP,DLVADRS1,DLVADRS2,SGTYPE,
				UPRICE,QTY,
				SGBGMM,SGCYCLE,APLCDT,INDT
			) values (
				read_no, '100', '0001', tmp_list2.JIKUK, '200', '000', readtypecd, tmp_list2.USERNAME,
				SUBSTR(regexp_substr(tmp_list2.phone ,'[^-]*'),0,4),
				SUBSTR(regexp_substr(substr(tmp_list2.phone ,regexp_instr(tmp_list2.phone,'-')+1,length(tmp_list2.phone)),'[^-]*'),0,4),
				SUBSTR(regexp_substr(tmp_list2.phone ,'[^-]*$',3),0,4),
				SUBSTR(regexp_substr(tmp_list2.handy ,'[^-]*'),0,4),
				SUBSTR(regexp_substr(substr(tmp_list2.handy ,regexp_instr(tmp_list2.handy,'-')+1,length(tmp_list2.handy)),'[^-]*'),0,4),
				SUBSTR(regexp_substr(tmp_list2.handy ,'[^-]*$',3),0,4),
				tmp_list2.ZIP1 || tmp_list2.ZIP2, substrb(tmp_list2.ADDR1,0,100), substrb(tmp_list2.ADDR2,0,100), '021', 
				to_number(trim(tmp_list2.BANK_MONEY)), to_number(trim(tmp_list2.BUSU)), 
				to_char(tmp_list2.SDATE,'YYYYMM'), 1, to_char(tmp_list2.SDATE,'YYYYMMDD'), tmp_list2.RDATE
			);
		        
			-- 자동이체독자정보(일반) 테이블에 readno를 넣어준다
			update tbl_users set readno = read_no, realjikuk = jikuk where numid = tmp_list2.numid;
			
			v_cnt22 := v_cnt22+1;
			
		end if;
	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('[step2 완료] update : ' || v_cnt21 || ', insert : ' || v_cnt22 || ' 개의 데이터가 처리되었습니다');
-- step 2 end --------------------------------------------------------------------------------------------------------------

-- step 3 start ------------------------------------------------------------------------------------------------------------
	DBMS_OUTPUT.PUT_LINE('[step3 시작] 일반,지국학생 독자이전 - jikuk 이 빈값이 아니고 readno 는 빈값이면서 jikuk+readno 조합이 없는 경우  무조건 insert');
	FOR tmp_list3 IN  (
		select * 
		from tbl_users 
		where 
			status != 'EA99' 
			and status != 'XX' 
			and trim(jikuk) is not null 
			and trim(readno) is null 
		order by 
			rdate
	) LOOP

		select to_char(nvl(max(readno),0)+1) into read_no from tm_reader;
		
		-- 주민번호 or 사업자번호
		if (length(trim(tmp_list3.saup)) = 13) then
			juminnum := trim(tmp_list3.saup);	-- 주민등록번호
		else
			saupja := trim(tmp_list3.saup);		-- 사업자등록번호
		end if;
		
		-- 독자유형
		if (trim(tmp_list3.gubun) = '학생') then
			readtypecd := '012';				-- 학생지국
		else
			readtypecd := '011';				-- 일반
		end if;
		
		-- 통합독자 테이블에 신규로 등록
		insert into tm_reader (
			READNO,PRN,ERNNO,BIDT,INDT
		) values(
			read_no, juminnum, saupja, to_char(tmp_list3.birthd,'YYYYMMDD'), tmp_list3.rdate
		);
		
		-- 구독정보 테이블에 신규로 등록
		-- READTYPECD 일반:'011', 학생지국:'012', 학생본사:'013' 
		insert into tm_reader_news (
			READNO,NEWSCD,SEQ,BOSEQ,GNO,BNO,READTYPECD,READNM,
			HOMETEL1,HOMETEL2,HOMETEL3,MOBILE1,MOBILE2,MOBILE3,
			DLVZIP,DLVADRS1,DLVADRS2,SGTYPE,
			UPRICE,QTY,
			SGBGMM,SGCYCLE,APLCDT,INDT
		) values (
			read_no, '100', '0001', tmp_list3.JIKUK, '200', '000', readtypecd, tmp_list3.USERNAME,
			SUBSTR(regexp_substr(tmp_list3.phone ,'[^-]*'),0,4),
			SUBSTR(regexp_substr(substr(tmp_list3.phone ,regexp_instr(tmp_list3.phone,'-')+1,length(tmp_list3.phone)),'[^-]*'),0,4),
			SUBSTR(regexp_substr(tmp_list3.phone ,'[^-]*$',3),0,4),
			SUBSTR(regexp_substr(tmp_list3.handy ,'[^-]*'),0,4),
			SUBSTR(regexp_substr(substr(tmp_list3.handy ,regexp_instr(tmp_list3.handy,'-')+1,length(tmp_list3.handy)),'[^-]*'),0,4),
			SUBSTR(regexp_substr(tmp_list3.handy ,'[^-]*$',3),0,4),
			tmp_list3.ZIP1 || tmp_list3.ZIP2, substrb(tmp_list3.ADDR1,0,100), substrb(tmp_list3.ADDR2,0,100), '021', 
			to_number(trim(tmp_list3.BANK_MONEY)), to_number(trim(tmp_list3.BUSU)), 
			to_char(tmp_list3.SDATE,'YYYYMM'), 1, to_char(tmp_list3.SDATE,'YYYYMMDD'), tmp_list3.RDATE
		);
	        
		-- 자동이체독자정보(일반) 테이블에 readno를 넣어준다
		update tbl_users set readno = read_no, realjikuk = jikuk where numid = tmp_list3.numid;
		
		v_cnt3 := v_cnt3+1;
	
	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('[step3 완료] insert : ' || v_cnt3 || ' 개의 데이터가 처리되었습니다');
-- step 3 end --------------------------------------------------------------------------------------------------------------
	
-- step 4 start ------------------------------------------------------------------------------------------------------------
	DBMS_OUTPUT.PUT_LINE('[step4 시작] 본사학생 독자이전 - jikuk, readno 가 빈값이 아니면서 jikuk+readno 조합이 2개이상 있는 경우 EA21,EA13 상태만 insert');
	FOR tmp_list4 IN  (
		select B.* 
		from 
			tbl_users_stu B 
			,( 
				select A.jikuk, A.readno 
				from ( 
					select * from tbl_users_stu where status != 'EA99' and status != 'XX' and trim(jikuk) is not null 
				) A 
				where trim(A.readno) is not null 
				group by A.jikuk, A.readno having count(A.readno) >= 2
	    	) C
		where 
		    B.jikuk = C.jikuk
		    and B.readno = C.readno
		    and (status = 'EA21' or status = 'EA13')
		order by 
			B.rdate
	) LOOP
	
		select to_char(nvl(max(readno),0)+1) into read_no from tm_reader;
		
		-- 주민번호 or 사업자번호
		if (length(trim(tmp_list4.saup)) = 13) then
			juminnum := trim(tmp_list4.saup);	-- 주민등록번호
		else
			saupja := trim(tmp_list4.saup);		-- 사업자등록번호
		end if;
		
		-- 통합독자 테이블에 신규로 등록
		insert into tm_reader (
			READNO,PRN,ERNNO,BIDT,INDT
		) values(
			read_no, juminnum, saupja, to_char(tmp_list4.birthd,'YYYYMMDD'), tmp_list4.rdate
		);
		
		-- 구독정보 테이블에 신규로 등록
		-- READTYPECD 일반:'011', 학생지국:'012', 학생본사:'013'
		insert into tm_reader_news (
			READNO,NEWSCD,SEQ,BOSEQ,GNO,BNO,READTYPECD,READNM,
			HOMETEL1,HOMETEL2,HOMETEL3,MOBILE1,MOBILE2,MOBILE3,
			DLVZIP,DLVADRS1,DLVADRS2,SGTYPE,
			UPRICE,QTY,
			SGBGMM,SGCYCLE,APLCDT,INDT
		) values (
			read_no, '100', '0001', tmp_list4.JIKUK, '200', '000', '013', tmp_list4.USERNAME,
			SUBSTR(regexp_substr(tmp_list4.phone ,'[^-]*'),0,4),
			SUBSTR(regexp_substr(substr(tmp_list4.phone ,regexp_instr(tmp_list4.phone,'-')+1,length(tmp_list4.phone)),'[^-]*'),0,4),
			SUBSTR(regexp_substr(tmp_list4.phone ,'[^-]*$',3),0,4),
			SUBSTR(regexp_substr(tmp_list4.handy ,'[^-]*'),0,4),
			SUBSTR(regexp_substr(substr(tmp_list4.handy ,regexp_instr(tmp_list4.handy,'-')+1,length(tmp_list4.handy)),'[^-]*'),0,4),
			SUBSTR(regexp_substr(tmp_list4.handy ,'[^-]*$',3),0,4),
			tmp_list4.ZIP1 || tmp_list4.ZIP2, substrb(tmp_list4.ADDR1,0,100), substrb(tmp_list4.ADDR2,0,100), '021', 
			to_number(trim(tmp_list4.BANK_MONEY)), to_number(trim(tmp_list4.BUSU)), 
			to_char(tmp_list4.SDATE,'YYYYMM'), 1, to_char(tmp_list4.SDATE,'YYYYMMDD'), tmp_list4.RDATE
		);
	        
		-- 자동이체독자정보(본사학생) 테이블에 readno를 넣어준다
		update tbl_users_stu set readno = read_no, realjikuk = jikuk where numid = tmp_list4.numid;
		
		v_cnt4 := v_cnt4+1;
	
	END LOOP;

	DBMS_OUTPUT.PUT_LINE('[step4 완료] insert : ' || v_cnt4 || ' 개의 데이터가 처리되었습니다');
-- step 4 end --------------------------------------------------------------------------------------------------------------

-- step 5 start ------------------------------------------------------------------------------------------------------------
	DBMS_OUTPUT.PUT_LINE('[step5 시작] 본사학생 독자이전 - jikuk, readno 가 빈값이 아니면서 jikuk+readno 조합이 1개 있는 경우  news에 없으면 insert 있으면 update');
	FOR tmp_list5 IN  (
		select B.* 
		from 
		    tbl_users_stu B
		    , (
		          select A.jikuk, A.readno from (
		              select * from tbl_users_stu where status != 'EA99' and status != 'XX' and trim(jikuk) is not null
		          ) A
		          where trim(A.readno) is not null 
		          group by A.jikuk, A.readno having count(A.readno) = 1
		    ) C
		where 
		    B.jikuk = C.jikuk
		    and B.readno = C.readno
		    and B.status != 'EA99' 
		    and B.status != 'XX'
		order by 
			B.rdate
	) LOOP
	
		if (length(trim(tmp_list5.jikuk)) = 6 and length(trim(tmp_list5.readno)) = 5) then
			
			select count(*) into v_cnttmp from tm_reader_news where boseq = tmp_list5.jikuk and boreadno = tmp_list5.readno and seq = '0001';
			
			if ( v_cnttmp = 1 ) then
				select readno into read_no from tm_reader_news where boseq = tmp_list5.jikuk and boreadno = tmp_list5.readno and seq = '0001';
			else
				read_no := '';
			end if;
		else
			read_no := '';
		end if;
		
		if (length(trim(read_no)) = 9 ) then
			-- 자동이체독자정보(본사학생) 테이블에 readno를 넣어준다
			update tbl_users_stu set readno = read_no, realjikuk = tmp_list5.jikuk where numid = tmp_list5.numid;
			
			select bno into reader_bno from tm_reader_news where readno = read_no and newscd = '100' and seq = '0001';
			
			if (reader_bno = '999') then	-- 중지독자면 구역/배달번호를 200/000 으로 수정한다.
				update tm_reader_news 
				set 
					sgtype = '021'
					, SGBGMM = to_char(tmp_list5.SDATE,'YYYYMM')
					, uprice = to_number(trim(tmp_list5.BANK_MONEY))
					, qty = to_number(trim(tmp_list5.BUSU))
					, gno = '200'
					, bno = '000'
					, readtypecd = '013'
					, readnm = tmp_list5.USERNAME
				where 
					readno = read_no and newscd = '100' and seq = '0001';
			else
				update tm_reader_news 
				set 
					sgtype = '021'
					, SGBGMM = to_char(tmp_list5.SDATE,'YYYYMM')
					, uprice = to_number(trim(tmp_list5.BANK_MONEY))
					, qty = to_number(trim(tmp_list5.BUSU))
					, readtypecd = '013'
					, readnm = tmp_list5.USERNAME
				where 
					readno = read_no and newscd = '100' and seq = '0001';
			end if;
			
			v_cnt51 := v_cnt51+1;
			
		else
	
			select to_char(nvl(max(readno),0)+1) into read_no from tm_reader;
			
			-- 주민번호 or 사업자번호
			if (length(trim(tmp_list5.saup)) = 13) then
				juminnum := trim(tmp_list5.saup);	-- 주민등록번호
			else
				saupja := trim(tmp_list5.saup);		-- 사업자등록번호
			end if;
			
			-- 통합독자 테이블에 신규로 등록
			insert into tm_reader (
				READNO,PRN,ERNNO,BIDT,INDT
			) values(
				read_no, juminnum, saupja, to_char(tmp_list5.birthd,'YYYYMMDD'), tmp_list5.rdate
			);
			
			-- 구독정보 테이블에 신규로 등록
			-- READTYPECD 일반:'011', 학생지국:'012', 학생본사:'013'
			insert into tm_reader_news (
				READNO,NEWSCD,SEQ,BOSEQ,GNO,BNO,READTYPECD,READNM,
				HOMETEL1,HOMETEL2,HOMETEL3,MOBILE1,MOBILE2,MOBILE3,
				DLVZIP,DLVADRS1,DLVADRS2,SGTYPE,
				UPRICE,QTY,
				SGBGMM,SGCYCLE,APLCDT,INDT
			) values (
				read_no, '100', '0001', tmp_list5.JIKUK, '200', '000', '013', tmp_list5.USERNAME,
				SUBSTR(regexp_substr(tmp_list5.phone ,'[^-]*'),0,4),
				SUBSTR(regexp_substr(substr(tmp_list5.phone ,regexp_instr(tmp_list5.phone,'-')+1,length(tmp_list5.phone)),'[^-]*'),0,4),
				SUBSTR(regexp_substr(tmp_list5.phone ,'[^-]*$',3),0,4),
				SUBSTR(regexp_substr(tmp_list5.handy ,'[^-]*'),0,4),
				SUBSTR(regexp_substr(substr(tmp_list5.handy ,regexp_instr(tmp_list5.handy,'-')+1,length(tmp_list5.handy)),'[^-]*'),0,4),
				SUBSTR(regexp_substr(tmp_list5.handy ,'[^-]*$',3),0,4),
				tmp_list5.ZIP1 || tmp_list5.ZIP2, substrb(tmp_list5.ADDR1,0,100), substrb(tmp_list5.ADDR2,0,100), '021', 
				to_number(trim(tmp_list5.BANK_MONEY)), to_number(trim(tmp_list5.BUSU)), 
				to_char(tmp_list5.SDATE,'YYYYMM'), 1, to_char(tmp_list5.SDATE,'YYYYMMDD'), tmp_list5.RDATE
			);
		        
			-- 자동이체독자정보(본사학생) 테이블에 readno를 넣어준다
			update tbl_users_stu set readno = read_no, realjikuk = jikuk where numid = tmp_list5.numid;
			
			v_cnt52 := v_cnt52+1;
			
		end if;
	
	END LOOP;

	DBMS_OUTPUT.PUT_LINE('[step5 완료] update : ' || v_cnt51 || ', insert : ' || v_cnt52 || ' 개의 데이터가 처리되었습니다');
-- step 5 end --------------------------------------------------------------------------------------------------------------

-- step 6 start ------------------------------------------------------------------------------------------------------------
	DBMS_OUTPUT.PUT_LINE('[step6 시작] 본사학생 독자이전 - jikuk 이 빈값이 아니고 readno 는 빈값이면서 jikuk+readno 조합이 없는 경우  무조건 insert');
	FOR tmp_list6 IN  (
		select * 
		from tbl_users_stu 
		where 
			status != 'EA99' 
			and status != 'XX' 
			and trim(jikuk) is not null 
			and trim(readno) is null 
		order by 
			rdate
	) LOOP
	
		select to_char(nvl(max(readno),0)+1) into read_no from tm_reader;
		
		-- 주민번호 or 사업자번호
		if (length(trim(tmp_list6.saup)) = 13) then
			juminnum := trim(tmp_list6.saup);	-- 주민등록번호
		else
			saupja := trim(tmp_list6.saup);		-- 사업자등록번호
		end if;
		
		-- 통합독자 테이블에 신규로 등록
		insert into tm_reader (
			READNO,PRN,ERNNO,BIDT,INDT
		) values(
			read_no, juminnum, saupja, to_char(tmp_list6.birthd,'YYYYMMDD'), tmp_list6.rdate
		);
		
		-- 구독정보 테이블에 신규로 등록
		-- READTYPECD 일반:'011', 학생지국:'012', 학생본사:'013'
		insert into tm_reader_news (
			READNO,NEWSCD,SEQ,BOSEQ,GNO,BNO,READTYPECD,READNM,
			HOMETEL1,HOMETEL2,HOMETEL3,MOBILE1,MOBILE2,MOBILE3,
			DLVZIP,DLVADRS1,DLVADRS2,SGTYPE,
			UPRICE,QTY,
			SGBGMM,SGCYCLE,APLCDT,INDT
		) values (
			read_no, '100', '0001', tmp_list6.JIKUK, '200', '000', '013', tmp_list6.USERNAME,
			SUBSTR(regexp_substr(tmp_list6.phone ,'[^-]*'),0,4),
			SUBSTR(regexp_substr(substr(tmp_list6.phone ,regexp_instr(tmp_list6.phone,'-')+1,length(tmp_list6.phone)),'[^-]*'),0,4),
			SUBSTR(regexp_substr(tmp_list6.phone ,'[^-]*$',3),0,4),
			SUBSTR(regexp_substr(tmp_list6.handy ,'[^-]*'),0,4),
			SUBSTR(regexp_substr(substr(tmp_list6.handy ,regexp_instr(tmp_list6.handy,'-')+1,length(tmp_list6.handy)),'[^-]*'),0,4),
			SUBSTR(regexp_substr(tmp_list6.handy ,'[^-]*$',3),0,4),
			tmp_list6.ZIP1 || tmp_list6.ZIP2, substrb(tmp_list6.ADDR1,0,100), substrb(tmp_list6.ADDR2,0,100), '021', 
			to_number(trim(tmp_list6.BANK_MONEY)), to_number(trim(tmp_list6.BUSU)), 
			to_char(tmp_list6.SDATE,'YYYYMM'), 1, to_char(tmp_list6.SDATE,'YYYYMMDD'), tmp_list6.RDATE
		);
	        
		-- 자동이체독자정보(본사학생) 테이블에 readno를 넣어준다
		update tbl_users_stu set readno = read_no, realjikuk = jikuk where numid = tmp_list6.numid;
		
		v_cnt6 := v_cnt6+1;
	
	END LOOP;

	DBMS_OUTPUT.PUT_LINE('[step6 완료] insert : ' || v_cnt6 || ' 개의 데이터가 처리되었습니다');
-- step 6 end --------------------------------------------------------------------------------------------------------------
	
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('= 자동이체 독자이전 완료(Commit적용됨) =');
	
EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
		DBMS_OUTPUT.PUT_LINE('= 자동이체 독자이전 에러(Rollback적용됨) = '||SQLERRM);
END;