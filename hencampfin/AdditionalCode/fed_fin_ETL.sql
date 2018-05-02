## Query to create unique candidate table. Run this query and save the results as a table 

SELECT *
FROM (
  SELECT
      *,
      ROW_NUMBER()
          OVER (PARTITION BY CAND_ID order by cand_election_yr desc)
          row_number
  FROM campaign.CAND_MST
)
WHERE row_number = 1



## Get unique records for committee


SELECT *
FROM (
  SELECT
      *,
      ROW_NUMBER()
          OVER (PARTITION BY CMTE_ID order by CMTE_ST1 desc)
          row_number
  FROM campaign.CMTE_MST
)
WHERE row_number = 1


## function to parse date 

PARSE_DATE('%m%d%Y',  TRANSACTION_DT )


### query to get cmte contribution to candidate 

select CAND_MST_UNI.CAND_ID, CAND_NAME, extract(year from PARSE_DATE('%m%d%Y',  TRANSACTION_DT )), sum(TRANSACTION_AMT) from 
campaign.CMTE_MST_UNI join 
campaign.CONTRIB_TO_CAND_FR_CMTE on CONTRIB_TO_CAND_FR_CMTE.CMTE_ID = CMTE_MST_UNI.CMTE_ID join 
campaign.CAND_MST_UNI on CONTRIB_TO_CAND_FR_CMTE.CAND_ID = CAND_MST_UNI.CAND_ID  
where CAND_ST = 'MN'
and CAND_NAME in  ('KLOBUCHAR, AMY','FRANKEN, AL')
group by CAND_MST_UNI.CAND_ID, CAND_NAME, extract(year from PARSE_DATE('%m%d%Y',  TRANSACTION_DT ))
order by CAND_NAME desc



### CMTE to CAND denormalized table CMTE_TO_CAND_TRANS_DENORM

select 
a.CMTE_ID,
a.CMTE_NM,
a.TRES_NM,
a.CMTE_ST1,
a.CMTE_ST2,
a.CMTE_CITY,
a.CMTE_ST,
a.CMTE_ZIP,
a.CMTE_DSGN,
a.CMTE_TP,
a.CMTE_PTY_AFFILIATION,
a.CMTE_FILING_FREQ,
a.ORG_TP,
a.CONNECTED_ORG_NM,
a.CAND_ID,
b.CAND_NAME,
b.CAND_PTY_AFFILIATION,
b.CAND_ELECTION_YR,
b.CAND_OFFICE_ST,
b.CAND_OFFICE,
b.CAND_OFFICE_DISTRICT,
b.CAND_ICI,
b.CAND_STATUS,
b.CAND_PCC,
b.CAND_ST1,
b.CAND_ST2,
b.CAND_CITY,
b.CAND_ST,
b.CAND_ZIP,
c.AMNDT_IND,
c.RPT_TP,
c.TRANSACTION_PGI,
c.IMAGE_NUM,
c.TRANSACTION_TP,
c.ENTITY_TP,
c.NAME,
c.CITY,
c.STATE,
c.ZIP_CODE,
c.EMPLOYER,
c.OCCUPATION,
PARSE_DATE('%m%d%Y',  c.TRANSACTION_DT ) as trans_dt,
c.TRANSACTION_AMT,
c.OTHER_ID,
c.TRAN_ID,
c.FILE_NUM,
c.MEMO_CD,
c.MEMO_TEXT,
c.SUB_ID
from 
`campaign.CONTRIB_TO_CAND_FR_CMTE` c 
left outer join campaign.CMTE_MST_UNI a on  c.CMTE_ID = a.CMTE_ID
left outer join campaign.CAND_MST_UNI b on c.CAND_ID = b.CAND_ID



### from INDV to CMTE denormalized table 

CMTE_INDV_TO_CAND_TRANS_DENORM


select 
a.CMTE_ID,
a.CMTE_NM,
a.TRES_NM,
a.CMTE_ST1,
a.CMTE_ST2,
a.CMTE_CITY,
a.CMTE_ST,
a.CMTE_ZIP,
a.CMTE_DSGN,
a.CMTE_TP,
a.CMTE_PTY_AFFILIATION,
a.CMTE_FILING_FREQ,
a.ORG_TP,
a.CONNECTED_ORG_NM,
a.CAND_ID,
b.CAND_NAME,
b.CAND_PTY_AFFILIATION,
b.CAND_ELECTION_YR,
b.CAND_OFFICE_ST,
b.CAND_OFFICE,
b.CAND_OFFICE_DISTRICT,
b.CAND_ICI,
b.CAND_STATUS,
b.CAND_PCC,
b.CAND_ST1,
b.CAND_ST2,
b.CAND_CITY,
b.CAND_ST,
b.CAND_ZIP,
i.AMNDT_IND,
i.RPT_TP,
i.TRANSACTION_PGI,
i.IMAGE_NUM,
i.TRANSACTION_TP,
i.ENTITY_TP,
i.NAME,
i.CITY,
i.STATE,
i.ZIP_CODE,
i.EMPLOYER,
i.OCCUPATION,
CASE WHEN REGEXP_CONTAINS( TRANSACTION_DT, r'^[0-1][0-9][0-3][0-9][0-9]{2}(?:[0-9]{2})?') = true THEN PARSE_DATE('%m%d%Y',  TRANSACTION_DT ) ELSE  null END as trans_dt,
i.TRANSACTION_AMT,
i.OTHER_ID,
i.TRAN_ID,
i.FILE_NUM,
i.MEMO_CD,
i.MEMO_TEXT,
i.SUB_ID
from 
campaign.CONTRIB_TO_CMTE_FR_INDV i
left outer join campaign.CMTE_MST_UNI a on  i.CMTE_ID = a.CMTE_ID
left outer join campaign.CAND_MST_UNI b on a.CAND_ID = b.CAND_ID 



### Committee expense table  


select 
a.CMTE_ID,
a.CMTE_NM,
a.TRES_NM,
a.CMTE_ST1,
a.CMTE_ST2,
a.CMTE_CITY,
a.CMTE_ST,
a.CMTE_ZIP,
a.CMTE_DSGN,
a.CMTE_TP,
a.CMTE_PTY_AFFILIATION,
a.CMTE_FILING_FREQ,
a.ORG_TP,
a.CONNECTED_ORG_NM,
a.CAND_ID,
b.CAND_NAME,
b.CAND_PTY_AFFILIATION,
b.CAND_ELECTION_YR,
b.CAND_OFFICE_ST,
b.CAND_OFFICE,
b.CAND_OFFICE_DISTRICT,
b.CAND_ICI,
b.CAND_STATUS,
b.CAND_PCC,
b.CAND_ST1,
b.CAND_ST2,
b.CAND_CITY,
b.CAND_ST,
b.CAND_ZIP,
e.AMNDT_IND,
e.RPT_YR,
e.RPT_TP,
e.IMAGE_NUM,
e.LINE_NUM,
e.FORM_TP_CD,
e.SCHED_TP_CD,
e.NAME,
e.CITY,
e.STATE,
e.ZIP_CODE,
CASE WHEN REGEXP_CONTAINS( TRANSACTION_DT, r'^(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])[- /.](19|20)\d\d$') = true THEN PARSE_DATE('%m/%d/%Y',  TRANSACTION_DT ) ELSE  null END as trans_dt,
e.TRANSACTION_AMT,
e.TRANSACTION_PGI,
e.PURPOSE,
e.CATEGORY,
e.CATEGORY_DESC,
e.MEMO_CD,
e.MEMO_TEXT,
e.ENTITY_TP,
e.SUB_ID,
e.FILE_NUM,
e.TRAN_ID,
e.BACK_REF_TRAN_ID
from 
campaign.CMTE_OPS_EXP e
join campaign.CMTE_MST_UNI a on  e.CMTE_ID = a.CMTE_ID  
left outer join campaign.CAND_MST_UNI b on a.CAND_ID = b.CAND_ID 

#######################