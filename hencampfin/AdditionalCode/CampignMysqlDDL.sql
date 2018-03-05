######### Create a table in my sql for candidate data


CREATE TABLE chtest.campaign_fin (
    id int(11) NOT NULL ,
    candidate_name varchar(255)  ,
    committe_name varchar(255) ,
    registration_date date ,
    termination_date date,
    location varchar(255),
    office varchar(255),
    district_num varchar(30),
    ytd_revenues decimal(15,2),
    ytd_expenses decimal(15,2),
    cash_balance decimal(15,2),
    ins_date date ,
    PRIMARY KEY (id)
) ;


CREATE TABLE chtest.campaign_fin1 (
    id int(11) NOT NULL ,
    candidate_name varchar(255)  ,
    committe_name varchar(255) ,
    registration_date date ,
    termination_date varchar(30),
    location varchar(255),
    office varchar(255),
    district_num varchar(30),
    ytd_revenues decimal(15,2),
    ytd_expenses decimal(15,2),
    cash_balance decimal(15,2),
    ins_date date ,
    PRIMARY KEY (id)
) ;


CREATE TABLE chtest.campaign_fin_stg (
    id int(11) NOT NULL AUTO_INCREMENT,
    candidate_name varchar(255)  ,
    committe_name varchar(255) ,
    registration_date varchar(30) ,
    termination_date varchar(30) ,
    location varchar(255),
    office varchar(255),
    district_num varchar(30),
    ytd_revenues varchar(30),
    ytd_expenses varchar(30),
    cash_balance varchar(30),
    ins_date varchar(30) ,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin
AUTO_INCREMENT=1 ;



CREATE TABLE chtest.campaign_fin_stg_test (
    id int(11) ,
    candidate_name varchar(255)  ,
    committe_name varchar(255) ,
    registration_date varchar(30) ,
    termination_date varchar(30) ,
    location varchar(255),
    office varchar(255),
    district_num varchar(30),
    ytd_revenues varchar(30),
    ytd_expenses varchar(30),
    cash_balance varchar(30),
    ins_date varchar(30) ,
    PRIMARY KEY (id)
) ;





candidate_name, committe_name, registration_date, termination_date, location, office, district_num, ytd_revenues, ytd_expenses, cash_balance, ins_date

INSERT IGNORE INTO chtest.campaign_fin_stg (candidate_name, committe_name, registration_date, termination_date, location, office, district_num, ytd_revenues, ytd_expenses, cash_balance, ins_date) VALUES (%s, %s, %s,%s, %s, %s,%s, %s, %s, %s)

insert into chtest.campaign_fin (id, candidate_name, committe_name, registration_date, termination_date, location, office, district_num, ytd_revenues, ytd_expenses, cash_balance, ins_date) SELECT id, candidate_name, committe_name, STR_TO_DATE(registration_date, '%m/%d/%Y') AS regis_dt, CASE WHEN STR_TO_DATE((CASE WHEN termination_date = '' THEN NULL ELSE termination_date END), '%m/%d/%Y') IS NULL THEN STR_TO_DATE('2050-12-31', '%Y-%m-%d') ELSE STR_TO_DATE(termination_date, '%m/%d/%Y') END AS term_dt, location, office, district_num, CONVERT( REPLACE(REPLACE(ytd_revenues, '$', ''), ',', '') , DECIMAL (15 , 2 )) AS ytd_rev, CONVERT( REPLACE(REPLACE(ytd_expenses, '$', ''), ',', '') , DECIMAL (15 , 2 )) AS ytd_exp, CONVERT( REPLACE(REPLACE(cash_balance, '$', ''), ',', '') , DECIMAL (15 , 2 )) AS cash_bal, STR_TO_DATE(ins_date, '%Y-%m-%d') AS ins_dt FROM chtest.campaign_fin_stg WHERE candidate_name <> ''





List of IPs that needs to be enabled in mysql

64.18.0.0/20

64.233.160.0/19

66.102.0.0/20

66.249.80.0/20

72.14.192.0/18

74.125.0.0/16

108.177.8.0/21

173.194.0.0/16

207.126.144.0/20

209.85.128.0/17

216.58.192.0/19

216.239.32.0/19





############################### create my sql table for campaign finance for state

CREATE TABLE chtest.state_fin1 (
	id_num int(20),
	Recipient_reg_num varchar(255)  ,
	Recipient varchar(255)  ,
	Recipient_type varchar(255)  ,
	Recipient_subtype varchar(255)  ,
	Amount varchar(255)  ,
	Receipt_date varchar(255)  ,
	Year1 varchar(255)  ,
	Contributor varchar(255)  ,
	Contributor_ID varchar(255)  ,
	Contrib_Reg_Num varchar(255)  ,
	Contrib_type varchar(255)  ,
	Receipt_type varchar(255)  ,
	In_kind varchar(255)  ,
	In_kind_descr varchar(255)  ,
	Contrib_zip varchar(255)  ,
	Contrib_employer_ID varchar(255)  ,
	Contrib_Employer_name varchar(255) ,
    PRIMARY KEY (id_num)
)



CREATE TABLE chtest.state_fin (
	id_num int(20),
	Recipient_reg_num int(20)  ,
	Recipient varchar(255)  ,
	Recipient_type varchar(255)  ,
	Recipient_subtype varchar(255)  ,
	Amount decimal(15,2)  ,
	Receipt_date date ,
	Year1 int(20) ,
	Contributor varchar(255)  ,
	Contributor_ID int(20) ,
	Contrib_Reg_Num int(20)  ,
	Contrib_type varchar(255)  ,
	Receipt_type varchar(255)  ,
	In_kind varchar(255)  ,
	In_kind_descr varchar(255)  ,
	Contrib_zip int(20)  ,
	Contrib_employer_ID varchar(255)  ,
	Contrib_Employer_name varchar(255) ,
    PRIMARY KEY (id_num)
)

CREATE TABLE chtest.state_fin (
	id_num int(20),
	Recipient_reg_num varchar(255)  ,
	Recipient varchar(255)  ,
	Recipient_type varchar(255)  ,
	Recipient_subtype varchar(255)  ,
	Amount decimal(15,2)  ,
	Receipt_date date ,
	Year1 int(20) ,
	Contributor varchar(255)  ,
	Contributor_ID varchar(255) ,
	Contrib_Reg_Num varchar(255) ,
	Contrib_type varchar(255)  ,
	Receipt_type varchar(255)  ,
	In_kind varchar(255)  ,
	In_kind_descr varchar(255)  ,
	Contrib_zip varchar(255) ,
	Contrib_employer_ID varchar(255)  ,
	Contrib_Employer_name varchar(255) ,
    PRIMARY KEY (id_num)
)




insert into chtest.state_fin (id_num, Recipient_reg_num , Recipient , Recipient_type , Recipient_subtype , Amount  , Receipt_date  , Year1, Contributor , Contributor_ID, Contrib_Reg_Num , Contrib_type , Receipt_type , In_kind , In_kind_descr , Contrib_zip , Contrib_employer_ID , Contrib_Employer_name )
select
id_num,
CONVERT(Recipient_reg_num,UNSIGNED INTEGER) Recip_reg_num ,
Recipient ,
Recipient_type ,
Recipient_subtype ,
CONVERT(Amount, Decimal(15,2)) as amt   ,
STR_TO_DATE(Receipt_date, '%m/%d/%Y') Receipt_dt ,
CONVERT(Year1,UNSIGNED INTEGER) yr,
Contributor ,
CONVERT(Contributor_ID,UNSIGNED INTEGER) as contrib_id,
CONVERT(Contrib_Reg_Num,UNSIGNED INTEGER) as contrib_reg_n,
Contrib_type ,
Receipt_type ,
In_kind ,
In_kind_descr ,
Contrib_zip,
Contrib_employer_ID ,
Contrib_Employer_name
from
chtest.state_fin1

insert into chtest.state_fin (id_num, Recipient_reg_num , Recipient , Recipient_type , Recipient_subtype , Amount  , Receipt_date  , Year1, Contributor , Contributor_ID, Contrib_Reg_Num , Contrib_type , Receipt_type , In_kind , In_kind_descr , Contrib_zip , Contrib_employer_ID , Contrib_Employer_name )
select
id_num,
Recipient_reg_num ,
Recipient ,
Recipient_type ,
Recipient_subtype ,
CONVERT(Amount, Decimal(15,2)) as amt   ,
STR_TO_DATE(Receipt_date, '%m/%d/%Y') Receipt_dt ,
CONVERT(Year1,UNSIGNED INTEGER) yr,
Contributor ,
Contributor_ID,
Contrib_Reg_Num,
Contrib_type ,
Receipt_type ,
In_kind ,
In_kind_descr ,
Contrib_zip,
Contrib_employer_ID ,
Contrib_Employer_name
from
chtest.state_fin1




STR_TO_DATE(Receipt_date, '%m/%d/%y')
CONVERT(Recipient_reg_num,UNSIGNED INTEGER)






##################  Federal Campaign finances

CREATE TABLE chtest.CMTE_MST(
CMTE_ID  VARCHAR(9),
CMTE_NM  VARCHAR(200),
TRES_NM  VARCHAR(90),
CMTE_ST1  VARCHAR(34),
CMTE_ST2  VARCHAR(34),
CMTE_CITY  VARCHAR(30),
CMTE_ST  VARCHAR(2),
CMTE_ZIP  VARCHAR(9),
CMTE_DSGN  VARCHAR(1),
CMTE_TP  VARCHAR(1),
CMTE_PTY_AFFILIATION  VARCHAR(3),
CMTE_FILING_FREQ  VARCHAR(1),
ORG_TP  VARCHAR(1),
CONNECTED_ORG_NM  VARCHAR(200),
CAND_ID  VARCHAR(9),
PRIMARY KEY(CMTE_ID));


CREATE TABLE chtest.CAND_MST(
CAND_ID  VARCHAR(9),
CAND_NAME  VARCHAR(200),
CAND_PTY_AFFILIATION  VARCHAR(3),
CAND_ELECTION_YR  Number(4),
CAND_OFFICE_ST  VARCHAR(2),
CAND_OFFICE  VARCHAR(1),
CAND_OFFICE_DISTRICT  VARCHAR(2),
CAND_ICI  VARCHAR(1),
CAND_STATUS  VARCHAR(1),
CAND_PCC  VARCHAR(9),
CAND_ST1  VARCHAR(34),
CAND_ST2  VARCHAR(34),
CAND_CITY  VARCHAR(30),
CAND_ST  VARCHAR(2),
CAND_ZIP  VARCHAR(9),
PRIMARY KEY(CAND_ID));

CREATE TABLE chtest.CAND_CMT_LINK(
CAND_ID  VARCHAR(9),
CAND_ELECTION_YR  INT(4),
FEC_ELECTION_YR  INT(4),
CMTE_ID  VARCHAR(9),
CMTE_TP  VARCHAR(1),
CMTE_DSGN  VARCHAR(1),
LINKAGE_ID  INT(12),
PRIMARY KEY(LINKAGE_ID));



CREATE TABLE chtest.CONTRIB_TO_CMTE_FR_CMTE(
CMTE_ID  VARCHAR(9),
AMNDT_IND  VARCHAR(1),
RPT_TP  VARCHAR(3),
TRANSACTION_PGI  VARCHAR(5),
IMAGE_NUM  VARCHAR(18),
TRANSACTION_TP  VARCHAR(3),
ENTITY_TP  VARCHAR(3),
NAME1  VARCHAR(200),
CITY  VARCHAR(30),
STATE  VARCHAR(2),
ZIP_CODE  VARCHAR(9),
EMPLOYER  VARCHAR(38),
OCCUPATION  VARCHAR(38),
TRANSACTION_DT  VARCHAR(30),
TRANSACTION_AMT  DECIMAL(14,2),
OTHER_ID  VARCHAR(9),
TRAN_ID  VARCHAR(32),
FILE_NUM  INT(22),
MEMO_CD  VARCHAR(1),
MEMO_TEXT  VARCHAR(100),
SUB_ID  VARCHAR(20),
PRIMARY KEY(SUB_ID));



CREATE TABLE chtest.CONTRIB_TO_CAND_FR_CMTE(
CMTE_ID  VARCHAR(9),
AMNDT_IND  VARCHAR(1),
RPT_TP  VARCHAR(3),
TRANSACTION_PGI  VARCHAR(5),
IMAGE_NUM  VARCHAR(20),
TRANSACTION_TP  VARCHAR(3),
ENTITY_TP  VARCHAR(3),
NAME1  VARCHAR(200),
CITY  VARCHAR(30),
STATE  VARCHAR(2),
ZIP_CODE  VARCHAR(9),
EMPLOYER  VARCHAR(38),
OCCUPATION  VARCHAR(38),
TRANSACTION_DT  VARCHAR(30),
TRANSACTION_AMT  DECIMAL(14,2),
OTHER_ID  VARCHAR(9),
CAND_ID  VARCHAR(9),
TRAN_ID  VARCHAR(32),
FILE_NUM  INT(22),
MEMO_CD  VARCHAR(1),
MEMO_TEXT  VARCHAR(100),
SUB_ID  VARCHAR(20),
PRIMARY KEY(SUB_ID));




CREATE TABLE chtest.CONTRIB_TO_CMTE_FR_INDV(
CMTE_ID  VARCHAR(9),
AMNDT_IND  VARCHAR(1),
RPT_TP  VARCHAR(3),
TRANSACTION_PGI  VARCHAR(5),
IMAGE_NUM  VARCHAR(20),
TRANSACTION_TP  VARCHAR(3),
ENTITY_TP  VARCHAR(3),
NAME1  VARCHAR(200),
CITY  VARCHAR(30),
STATE  VARCHAR(2),
ZIP_CODE  VARCHAR(9),
EMPLOYER  VARCHAR(38),
OCCUPATION  VARCHAR(38),
TRANSACTION_DT  VARCHAR(30),
TRANSACTION_AMT  Decimal(14,2),
OTHER_ID  VARCHAR(9),
TRAN_ID  VARCHAR(32),
FILE_NUM  INT(22),
MEMO_CD  VARCHAR(1),
MEMO_TEXT  VARCHAR(100),
SUB_ID  VARCHAR(20),
PRIMARY KEY(SUB_ID));



CREATE TABLE chtest.CMTE_OPS_EXP(
CMTE_ID  VARCHAR(9),
AMNDT_IND  VARCHAR(1),
RPT_YR  INT(4),
RPT_TP  VARCHAR(3),
IMAGE_NUM  VARCHAR(20),
LINE_NUM  VARCHAR(30),
FORM_TP_CD  VARCHAR(8),
SCHED_TP_CD  VARCHAR(8),
NAME1  VARCHAR(200),
CITY  VARCHAR(30),
STATE  VARCHAR(2),
ZIP_CODE  VARCHAR(9),
TRANSACTION_DT  VARCHAR(20),
TRANSACTION_AMT  DECIMAL(14,2),
TRANSACTION_PGI  VARCHAR(5),
PURPOSE  VARCHAR(100),
CATEGORY  VARCHAR(3),
CATEGORY_DESC  VARCHAR(40),
MEMO_CD  VARCHAR(1),
MEMO_TEXT  VARCHAR(100),
ENTITY_TP  VARCHAR(3),
SUB_ID  VARCHAR(20),
FILE_NUM  VARCHAR(20),
TRAN_ID  VARCHAR(32),
BACK_REF_TRAN_ID  VARCHAR(32),
PRIMARY KEY(SUB_ID));



######## Denorm table

CREATE TABLE CAND_TRANS (
SUB_ID  VARCHAR(20),
CAND_ID  VARCHAR(9),
CAND_NAME  VARCHAR(200),
CAND_PTY_AFFILIATION  VARCHAR(3),
CAND_ELECTION_YR  INT(4),
CAND_OFFICE_ST  VARCHAR(2),
CAND_OFFICE  VARCHAR(1),
CAND_OFFICE_DISTRICT  VARCHAR(2),
CAND_ICI  VARCHAR(1),
CAND_STATUS  VARCHAR(1),
CAND_PCC  VARCHAR(9),
CAND_ST1  VARCHAR(34),
CAND_ST2  VARCHAR(34),
CAND_CITY  VARCHAR(30),
CAND_ST  VARCHAR(2),
CAND_ZIP  VARCHAR(9),
CMTE_ID  VARCHAR(9),
CMTE_NM  VARCHAR(200),
TRES_NM  VARCHAR(90),
CMTE_ST1  VARCHAR(34),
CMTE_ST2  VARCHAR(34),
CMTE_CITY  VARCHAR(30),
CMTE_ST  VARCHAR(2),
CMTE_ZIP  VARCHAR(9),
CMTE_DSGN  VARCHAR(1),
CMTE_TP  VARCHAR(1),
CMTE_PTY_AFFILIATION  VARCHAR(3),
CMTE_FILING_FREQ  VARCHAR(1),
ORG_TP  VARCHAR(1),
CONNECTED_ORG_NM  VARCHAR(200),
CAND_ID1  VARCHAR(9),
CMTE_ID1  VARCHAR(9),
AMNDT_IND  VARCHAR(1),
RPT_TP  VARCHAR(3),
TRANSACTION_PGI  VARCHAR(5),
IMAGE_NUM  VARCHAR(20),
TRANSACTION_TP  VARCHAR(3),
ENTITY_TP  VARCHAR(3),
NAME1  VARCHAR(200),
CITY  VARCHAR(30),
STATE  VARCHAR(2),
ZIP_CODE  VARCHAR(9),
EMPLOYER  VARCHAR(38),
OCCUPATION  VARCHAR(38),
TRANSACTION_DT  VARCHAR(30),
TRANSACTION_AMT  DECIMAL(14,2),
OTHER_ID  VARCHAR(9),
CAND_ID2  VARCHAR(9),
TRAN_ID  VARCHAR(32),
FILE_NUM  INT(22),
MEMO_CD  VARCHAR(1),
MEMO_TEXT  VARCHAR(100),
TRANS_YR INT(10),
TRANS_DT date,
PRIMARY KEY(SUB_ID ));




CREATE TABLE chtest.CAND_TRANS_stg1 (
SUB_ID  VARCHAR(20),
CAND_ID  VARCHAR(9),
CAND_NAME  VARCHAR(200),
CAND_PTY_AFFILIATION  VARCHAR(3),
CAND_ELECTION_YR  INT(4),
CAND_OFFICE_ST  VARCHAR(2),
CAND_OFFICE  VARCHAR(1),
CAND_OFFICE_DISTRICT  VARCHAR(2),
CAND_ICI  VARCHAR(1),
CAND_STATUS  VARCHAR(1),
CAND_PCC  VARCHAR(9),
CAND_ST1  VARCHAR(34),
CAND_ST2  VARCHAR(34),
CAND_CITY  VARCHAR(30),
CAND_ST  VARCHAR(2),
CAND_ZIP  VARCHAR(9),
CMTE_ID  VARCHAR(9),
CMTE_NM  VARCHAR(200),
TRES_NM  VARCHAR(90),
CMTE_ST1  VARCHAR(34),
CMTE_ST2  VARCHAR(34),
CMTE_CITY  VARCHAR(30),
CMTE_ST  VARCHAR(2),
CMTE_ZIP  VARCHAR(9),
CMTE_DSGN  VARCHAR(1),
CMTE_TP  VARCHAR(1),
CMTE_PTY_AFFILIATION  VARCHAR(3),
CMTE_FILING_FREQ  VARCHAR(1),
ORG_TP  VARCHAR(1),
CONNECTED_ORG_NM  VARCHAR(200),
CAND_ID1  VARCHAR(9),
CMTE_ID1  VARCHAR(9),
AMNDT_IND  VARCHAR(1),
RPT_TP  VARCHAR(3),
TRANSACTION_PGI  VARCHAR(5),
IMAGE_NUM  VARCHAR(20),
TRANSACTION_TP  VARCHAR(3),
ENTITY_TP  VARCHAR(3),
NAME1  VARCHAR(200),
CITY  VARCHAR(30),
STATE  VARCHAR(2),
ZIP_CODE  VARCHAR(9),
EMPLOYER  VARCHAR(38),
OCCUPATION  VARCHAR(38),
TRANSACTION_DT  VARCHAR(30),
TRANSACTION_AMT  DECIMAL(14,2),
OTHER_ID  VARCHAR(9),
CAND_ID2  VARCHAR(9),
TRAN_ID  VARCHAR(32),
FILE_NUM  INT(22),
MEMO_CD  VARCHAR(1),
MEMO_TEXT  VARCHAR(100),
TRANS_DT DATE,
TRANS_YR VARCHAR(4)
PRIMARY KEY(SUB_ID ));




SELECT
trim(CONTRIB_TO_CAND_FR_CMTE.SUB_ID) sub_i,
CAND_MST.CAND_ID,
CAND_MST.CAND_NAME,
CAND_MST.CAND_PTY_AFFILIATION,
CAND_MST.CAND_ELECTION_YR,
CAND_MST.CAND_OFFICE_ST,
CAND_MST.CAND_OFFICE,
CAND_MST.CAND_OFFICE_DISTRICT,
CAND_MST.CAND_ICI,
CAND_MST.CAND_STATUS,
CAND_MST.CAND_PCC,
CAND_MST.CAND_ST1,
CAND_MST.CAND_ST2,
CAND_MST.CAND_CITY,
CAND_MST.CAND_ST,
CAND_MST.CAND_ZIP,
CMTE_MST.CMTE_ID,
CMTE_MST.CMTE_NM,
CMTE_MST.TRES_NM,
CMTE_MST.CMTE_ST1,
CMTE_MST.CMTE_ST2,
CMTE_MST.CMTE_CITY,
CMTE_MST.CMTE_ST,
CMTE_MST.CMTE_ZIP,
CMTE_MST.CMTE_DSGN,
CMTE_MST.CMTE_TP,
CMTE_MST.CMTE_PTY_AFFILIATION,
CMTE_MST.CMTE_FILING_FREQ,
CMTE_MST.ORG_TP,
CMTE_MST.CONNECTED_ORG_NM,
CMTE_MST.CAND_ID,
CMTE_MST.CMTE_ID,
CONTRIB_TO_CAND_FR_CMTE.AMNDT_IND,
CONTRIB_TO_CAND_FR_CMTE.RPT_TP,
CONTRIB_TO_CAND_FR_CMTE.TRANSACTION_PGI,
CONTRIB_TO_CAND_FR_CMTE.IMAGE_NUM,
CONTRIB_TO_CAND_FR_CMTE.TRANSACTION_TP,
CONTRIB_TO_CAND_FR_CMTE.ENTITY_TP,
CONTRIB_TO_CAND_FR_CMTE.NAME1,
CONTRIB_TO_CAND_FR_CMTE.CITY,
CONTRIB_TO_CAND_FR_CMTE.STATE,
CONTRIB_TO_CAND_FR_CMTE.ZIP_CODE,
CONTRIB_TO_CAND_FR_CMTE.EMPLOYER,
CONTRIB_TO_CAND_FR_CMTE.OCCUPATION,
CONTRIB_TO_CAND_FR_CMTE.TRANSACTION_DT,
CONTRIB_TO_CAND_FR_CMTE.TRANSACTION_AMT,
CONTRIB_TO_CAND_FR_CMTE.OTHER_ID,
CONTRIB_TO_CAND_FR_CMTE.CAND_ID,
CONTRIB_TO_CAND_FR_CMTE.TRAN_ID,
CONTRIB_TO_CAND_FR_CMTE.FILE_NUM,
CONTRIB_TO_CAND_FR_CMTE.MEMO_CD,
CONTRIB_TO_CAND_FR_CMTE.MEMO_TEXT
from
chtest.CMTE_MST join
chtest.CONTRIB_TO_CAND_FR_CMTE on CONTRIB_TO_CAND_FR_CMTE.CMTE_ID = CMTE_MST.CMTE_ID join
chtest.CAND_MST on CONTRIB_TO_CAND_FR_CMTE.CAND_ID = CAND_MST.CAND_ID





INSERT INTO chtest.CAND_TRANS_stg1 (SUB_ID, CAND_ID, CAND_NAME, CAND_PTY_AFFILIATION, CAND_ELECTION_YR, CAND_OFFICE_ST, CAND_OFFICE, CAND_OFFICE_DISTRICT, CAND_ICI, CAND_STATUS, CAND_PCC, CAND_ST1, CAND_ST2, CAND_CITY, CAND_ST, CAND_ZIP, CMTE_ID, CMTE_NM, TRES_NM, CMTE_ST1, CMTE_ST2, CMTE_CITY, CMTE_ST, CMTE_ZIP, CMTE_DSGN, CMTE_TP, CMTE_PTY_AFFILIATION, CMTE_FILING_FREQ, ORG_TP, CONNECTED_ORG_NM, CAND_ID1, CMTE_ID1, AMNDT_IND, RPT_TP, TRANSACTION_PGI, IMAGE_NUM, TRANSACTION_TP, ENTITY_TP, NAME1, CITY, STATE, ZIP_CODE, EMPLOYER, OCCUPATION, TRANSACTION_DT, TRANSACTION_AMT, OTHER_ID, CAND_ID2, TRAN_ID, FILE_NUM, MEMO_CD, MEMO_TEXT, TRANS_DT, TRANS_YR)
SELECT
SUB_ID,
CAND_ID,
CAND_NAME,
CAND_PTY_AFFILIATION,
CAND_ELECTION_YR,
CAND_OFFICE_ST,
CAND_OFFICE,
CAND_OFFICE_DISTRICT,
CAND_ICI,
CAND_STATUS,
CAND_PCC,
CAND_ST1,
CAND_ST2,
CAND_CITY,
CAND_ST,
CAND_ZIP,
CMTE_ID,
CMTE_NM,
TRES_NM,
CMTE_ST1,
CMTE_ST2,
CMTE_CITY,
CMTE_ST,
CMTE_ZIP,
CMTE_DSGN,
CMTE_TP,
CMTE_PTY_AFFILIATION,
CMTE_FILING_FREQ,
ORG_TP,
CONNECTED_ORG_NM,
CAND_ID1,
CMTE_ID1,
AMNDT_IND,
RPT_TP,
TRANSACTION_PGI,
IMAGE_NUM,
TRANSACTION_TP,
ENTITY_TP,
NAME1,
CITY,
STATE,
ZIP_CODE,
EMPLOYER,
OCCUPATION,
TRANSACTION_DT,
TRANSACTION_AMT,
OTHER_ID,
CAND_ID2,
TRAN_ID,
FILE_NUM,
MEMO_CD,
MEMO_TEXT,
STR_TO_DATE(transaction_dt, '%m%d%Y') trans_dt,
year(STR_TO_DATE(transaction_dt, '%m%d%Y')) trans_yr
 from chtest.CAND_TRANS_stg


