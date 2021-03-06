     
/* 구역테이블  */
--DROP TABLE TM_GUYUK;
CREATE TABLE TM_GUYUK (BOSEQ VARCHAR2(6) NOT NULL,
                       GU_NO VARCHAR2(3) NOT NULL,  --(101~199)
                       GU_NM VARCHAR2(20),
                       GU_APT NUMBER,
                       GU_BILLA NUMBER,
                       GU_OFFICE NUMBER,
                       GU_SANGA NUMBER,
                       GU_JUTEAK NUMBER,
                       GU_GITA NUMBER,
                       INDT DATE,
                       INPS VARCHAR2(20),
                       CHGDT DATE,
                       CHGPS VARCHAR2(20));
ALTER TABLE TM_GUYUK
ADD CONSTRAINT TM_GUYUK PRIMARY KEY (BOSEQ,GU_NO);

COMMENT ON TABLE TM_GUYUK IS '구역정보';
COMMENT ON COLUMN TM_GUYUK.BOSEQ IS '지국번호';
COMMENT ON COLUMN TM_GUYUK.GU_NO IS '구역번호'; 
COMMENT ON COLUMN TM_GUYUK.GU_NM IS '구역명';
COMMENT ON COLUMN TM_GUYUK.GU_APT IS '아파트수';
COMMENT ON COLUMN TM_GUYUK.GU_BILLA IS '빌라수';
COMMENT ON COLUMN TM_GUYUK.GU_OFFICE IS '사무실수';
COMMENT ON COLUMN TM_GUYUK.GU_SANGA IS '상가수';
COMMENT ON COLUMN TM_GUYUK.GU_JUTEAK IS '주택수';
COMMENT ON COLUMN TM_GUYUK.GU_GITA IS '기타수';
COMMENT ON COLUMN TM_GUYUK.INDT IS '등록일자';
COMMENT ON COLUMN TM_GUYUK.INPS IS '등록자';
COMMENT ON COLUMN TM_GUYUK.CHGDT IS '수정일자';
COMMENT ON COLUMN TM_GUYUK.CHGPS IS '수정자';




INSERT INTO TM_GUYUK (BOSEQ,GU_NO,GU_NM,INDT,INPS,CHGDT,CHGPS)
SELECT distinct BOSEQ, GNO, GNO||'구역',SYSDATE,'system', SYSDATE, 'system'
FROM TM_READER_NEWS
where BNO != '999';

update tm_guyuk set gu_apt=0, gu_billa=0, gu_office=0, gu_sanga=0, gu_juteak=0, gu_gita=0;
select * from tm_guyuk order by boseq, gu_no;




/* 지국별 매체코드 테이블  */
CREATE TABLE TM_AGENCY_NEWS (SERIAL VARCHAR2(6) NOT NULL,
                       NEWSCD VARCHAR2(3) NOT NULL,
                       INDT DATE,
                       INPS VARCHAR2(20)
                       );
ALTER TABLE TM_AGENCY_NEWS  
ADD CONSTRAINT TM_AGENCY_NEWS  PRIMARY KEY (SERIAL, NEWSCD);

COMMENT ON COLUMN TM_AGENCY_NEWS.SERIAL IS '지국번호';
COMMENT ON COLUMN TM_AGENCY_NEWS.NEWSCD IS '매체코드';
COMMENT ON COLUMN TM_AGENCY_NEWS.INDT IS '등록일자';
COMMENT ON COLUMN TM_AGENCY_NEWS.INPS IS '등록자';
COMMENT ON COLUMN TM_GUYUK.CHGDT IS '수정일자';
COMMENT ON COLUMN TM_GUYUK.CHGPS IS '수정자';

INSERT INTO TM_AGENCY_NEWS (SERIAL,NEWSCD,INDT,INPS)
SELECT USERID,'100',SYSDATE,'system'
FROM TM_AGENCY;




/* 지국별 고객안내문 테이블  */
CREATE TABLE TM_CUST_NOTICE (SERIAL VARCHAR2(6) NOT NULL,
                       CODE VARCHAR2(2) NOT NULL,
                       GIRO VARCHAR2(1000),
                       VISIT VARCHAR2(1000),
                       INDT DATE,
                       INPS VARCHAR2(20),
                       CHGDT DATE,
                       CHGPS VARCHAR2(20));
ALTER TABLE TM_CUST_NOTICE  
ADD CONSTRAINT TM_CUST_NOTICE  PRIMARY KEY (SERIAL, CODE);

COMMENT ON COLUMN TM_CUST_NOTICE.SERIAL IS '지국번호';
COMMENT ON COLUMN TM_CUST_NOTICE.CODE IS '코드';
COMMENT ON COLUMN TM_CUST_NOTICE.GIRO IS '지로영수증안내문';
COMMENT ON COLUMN TM_CUST_NOTICE.VISIT IS '방문영수증안내문';
COMMENT ON COLUMN TM_CUST_NOTICE.INDT IS '등록일자';
COMMENT ON COLUMN TM_CUST_NOTICE.INPS IS '등록자';
COMMENT ON COLUMN TM_CUST_NOTICE.CHGDT IS '수정일자';
COMMENT ON COLUMN TM_CUST_NOTICE.CHGPS IS '수정자';

INSERT INTO TM_CUST_NOTICE (SERIAL,CODE,GIRO,VISIT,INDT,INPS,CHGDT,CHGPS)
SELECT USERID,'01','', '', SYSDATE,'system',SYSDATE,'system'
FROM TM_AGENCY;
INSERT INTO TM_CUST_NOTICE (SERIAL,CODE,GIRO,VISIT,INDT,INPS,CHGDT,CHGPS)
SELECT USERID,'02','', '', SYSDATE,'system',SYSDATE,'system'
FROM TM_AGENCY;
INSERT INTO TM_CUST_NOTICE (SERIAL,CODE,GIRO,VISIT,INDT,INPS,CHGDT,CHGPS)
SELECT USERID,'03','', '', SYSDATE,'system',SYSDATE,'system'
FROM TM_AGENCY;
INSERT INTO TM_CUST_NOTICE (SERIAL,CODE,GIRO,VISIT,INDT,INPS,CHGDT,CHGPS)
SELECT USERID,'04','', '', SYSDATE,'system',SYSDATE,'system'
FROM TM_AGENCY;
INSERT INTO TM_CUST_NOTICE (SERIAL,CODE,GIRO,VISIT,INDT,INPS,CHGDT,CHGPS)
SELECT USERID,'05','', '', SYSDATE,'system',SYSDATE,'system'
FROM TM_AGENCY;
INSERT INTO TM_CUST_NOTICE (SERIAL,CODE,GIRO,VISIT,INDT,INPS,CHGDT,CHGPS)
SELECT USERID,'06','', '', SYSDATE,'system',SYSDATE,'system'
FROM TM_AGENCY;
INSERT INTO TM_CUST_NOTICE (SERIAL,CODE,GIRO,VISIT,INDT,INPS,CHGDT,CHGPS)
SELECT USERID,'07','', '', SYSDATE,'system',SYSDATE,'system'
FROM TM_AGENCY;


/* 개별영수증 임시저장공간  */
DROP TABLE TMP_BILL_PRT;
CREATE TABLE TMP_BILL_PRT (BOSEQ VARCHAR2(6) NOT NULL,
                           ID NUMBER(10) NOT NULL,
                           NAME VARCHAR2(50), 
                           JIKUK_TEL VARCHAR2(13),
                           GIRO_NO VARCHAR2(20),
			   APPROVAL_NO VARCHAR2(20),
                           NEWSCD VARCHAR2(3),
                           NEWSNM VARCHAR2(50),
                           READNO VARCHAR2(9),
                           GNO VARCHAR2(3),
                           BNO VARCHAR2(3),
                           HJDT VARCHAR2(10),
                           HJPSNM VARCHAR2(50),
                           SGBGMM VARCHAR2(6),
                           PHONE VARCHAR2(13),
			   PHONE2 VARCHAR2(13),
                           CLAMLISTLY VARCHAR2(15),
                           CLAMLISTTY VARCHAR2(15),
                           LASTBILL VARCHAR2(20),
                           READER_NO VARCHAR2(20),
                           READNM VARCHAR2(20),
                           ADDR VARCHAR2(200),
                           UPRICE VARCHAR2(8),
                           AMOUNT VARCHAR2(8),
                           REMK VARCHAR2(300),
                           NOTI_G VARCHAR2(1000),
                           NOTI_V VARCHAR2(1000),
                           YYMM VARCHAR2(20),
                           READBAND1 VARCHAR2(40),
                           READBAND VARCHAR2(40));
ALTER TABLE TMP_BILL_PRT
ADD CONSTRAINT TMP_BILL_PRT PRIMARY KEY (BOSEQ,ID);


COMMENT ON TABLE TMP_BILL_PRT IS '개별영수증 임시공간';







-- 매체코드 
UPDATE TC_COMMON SET YNAME = '매경', SORTFD = '01' WHERE CDCLSF = '100' AND CODE = '100';
INSERT INTO TC_COMMON VALUES('100','101','조선일보','조선','','','','','Y','','','','','02');
INSERT INTO TC_COMMON VALUES('100','102','중앙일보','중앙','','','','','Y','','','','','03');
INSERT INTO TC_COMMON VALUES('100','103','동아일보','동아','','','','','Y','','','','','04');
INSERT INTO TC_COMMON VALUES('100','104','한국경제','한경','','','','','Y','','','','','05');
INSERT INTO TC_COMMON VALUES('100','105','국민일보','국민','','','','','Y','','','','','06');
INSERT INTO TC_COMMON VALUES('100','106','농민신문','농민','','','','','Y','','','','','07');
INSERT INTO TC_COMMON VALUES('100','107','한국일보','한국','','','','','Y','','','','','08');
INSERT INTO TC_COMMON VALUES('100','108','한겨레','한겨','','','','','Y','','','','','09');
INSERT INTO TC_COMMON VALUES('100','109','경향신문','경향','','','','','Y','','','','','10');
INSERT INTO TC_COMMON VALUES('100','110','부산일보','부산','','','','','Y','','','','','11');
INSERT INTO TC_COMMON VALUES('100','111','서울신문','서울','','','','','Y','','','','','12');
INSERT INTO TC_COMMON VALUES('100','112','문화일보','문화','','','','','Y','','','','','13');
INSERT INTO TC_COMMON VALUES('100','113','매일신문','매일','','','','','Y','','','','','14');
INSERT INTO TC_COMMON VALUES('100','114','국제신문','국제','','','','','Y','','','','','15');
INSERT INTO TC_COMMON VALUES('100','115','세계일보','세계','','','','','Y','','','','','16');
INSERT INTO TC_COMMON VALUES('100','116','서울경제','서경','','','','','Y','','','','','17');
INSERT INTO TC_COMMON VALUES('100','117','스포츠조선','스조','','','','','Y','','','','','18');
INSERT INTO TC_COMMON VALUES('100','118','스포츠한국','스한','','','','','Y','','','','','19');
INSERT INTO TC_COMMON VALUES('100','119','일간스포츠','일스','','','','','Y','','','','','20');
INSERT INTO TC_COMMON VALUES('100','120','스포츠서울','스서','','','','','Y','','','','','21');
INSERT INTO TC_COMMON VALUES('100','121','스포츠동아','스동','','','','','Y','','','','','22');
INSERT INTO TC_COMMON VALUES('100','122','스포츠칸','스칸','','','','','Y','','','','','23');
INSERT INTO TC_COMMON VALUES('100','123','스포츠월드','스월','','','','','Y','','','','','24');
INSERT INTO TC_COMMON VALUES('100','124','강원일보','강원','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','125','머니투데이','머투','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','126','영남일보','영남','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','127','헤럴드경제','헤경','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','128','내일신문','내일','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','129','전자신문','전자','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','130','경남신문','경신','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','131','대전일보','대전','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','132','경인일보','경인','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','133','아시아경제','아경','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','134','광주일보','광주','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','135','강원도민일보','강도','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','136','파이낸셜뉴스','파뉴','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','137','The Korea Herald','코헤','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','138','충청투데이','충투','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','139','중도일보','중도','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','140','경기일보','경기','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','141','전남일보','전남','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','142','전북일보','전북','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','143','무등일보','무등','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','144','인천일보','인천','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','145','전국매일신문','전국','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','146','중부일보','중부','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','147','THE KOREA TIMES','코타','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','148','광남일보','광남','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','149','경북일보','경북','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','150','제주일보','제주','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','151','디지털타임스','디타','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','152','경상일보','경상','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','153','KOREA JOONGANG','코중','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','154','대구일보','대구','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','155','건설경제','건경','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','156','이투데이','이투','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','157','대구신문','대신','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','158','전남매일','전매','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','159','한라일보','한라','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','160','경남일보','경남','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','161','울산매일','울매','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','162','전북도민일보','전도','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','163','광주매일신문','광매','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','164','경남도민일보','남도','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','165','경북매일신문','경매','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','166','광주드림','광드','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','167','제민일보','제민','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','168','동양일보','동양','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','169','호남신문','호남','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','170','경북도민일보','경도','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','171','아시아투데이','아투','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','172','기호일보','기호','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','173','경남매일','남매','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','174','시대일보','시대','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','175','남도일보','남일','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','176','신아일보','신아','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','177','전라일보','전라','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','178','중부매일','중매','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','179','울산신문','울산','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','180','충청일보','충청','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','181','금강일보','금강','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','182','환경일보','환경','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','183','새전북신문','새전','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','184','경기신문','기신','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','185','경남연합일보','경연','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','186','인천신문','인신','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','187','제주도민일보','제도','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','188','아주경제','주경','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','189','호남매일','호매','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','190','충청신문','충신','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','191','경상매일신문','상매','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','192','충청매일','충매','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','193','전북중앙신문','전중','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','194','제주타임스','제타','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','195','충북일보','충북','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','196','서울일보','서일','','','','','Y','','','','','');
INSERT INTO TC_COMMON VALUES('100','197','충남일보','충일','','','','','Y','','','','','');







