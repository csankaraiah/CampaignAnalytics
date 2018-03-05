#### contiorbution amount from individual contributions are counted separate from cmte contributions

select b.cand_name,b.cand_city, a.* FROM `campaign.CMTE_MST_UNI`  a
join `campaign.CAND_MST_UNI` b on a.cand_id = b.cand_id
where cand_name like '%CRAIG, ANGELA DAWN%' -- cmte_id =	C00575209	cmtename = ANGIE CRAIG FOR CONGRESS

select sum( TRANSACTION_AMT) from `campaign.CMTE_TO_CAND_TRANS_DENORM`
where cand_name like '%CRAIG, ANGELA DAWN%' -- 2,724,868.0

select cmte_nm, sum( TRANSACTION_AMT) from `campaign.INDV_TO_CMTE_TRANS_DENOR`
where cand_name like '%CRAIG, ANGELA DAWN%' --2,501,747.0
group by CMTE_NM -- cmte_nm ANGIE CRAIG FOR CONGRESS



### Media spend by candidates

select name, case when purpose in ('MEDIA','MEDIA BUY','MEDIA BUY/PRODUCTION','MEDIA PRODUCTION') then 'MEDIA' else purpose end as cate ,cast(sum(transaction_amt) as integer) as spend from [campaign.CMTE_OPS_EXP_TRANS_DENORM]
where cand_office_st = 'MN'
and cand_pty_affiliation in ('DFL', 'DEM')
and year(trans_dt) in (2015,2016)
and cand_office = 'H'
and case when purpose in ('MEDIA','MEDIA BUY','MEDIA BUY/PRODUCTION','MEDIA PRODUCTION') then 'MEDIA' else purpose end = 'MEDIA'
group by name, cate
order by spend desc


### Spend categories
select case when purpose like '%MEDIA%' or purpose like '%SERVIC%' OR purpose like '%ADVERTI%' OR purpose like '%PRINT%' OR purpose like '%MAIL%' OR purpose like '%BILLBOARD%' OR purpose like '%POST%' then 'MEDIA'
            when purpose like '%PAYROLL%' OR purpose like '%INSUR%' OR purpose like '%STIPEND%' OR purpose like '%ADMINIS%' OR purpose like '%REIMBURSEMENT%' OR purpose like '%SALARY%' OR purpose like '%FEE%' then 'PAYROLL'
            when purpose like '%CONSULT%' then 'CONSULTING'
            when purpose like '%DATABASE%' OR purpose like '%SOFTWARE%' OR purpose like '%WEB%' OR purpose like '%TECHNO%' OR purpose like '%GRAPHIC%' OR purpose like '%COMPUTER%' OR purpose like '%DOMAIN%'  then 'IT'
            when purpose like '%FUND%' OR purpose like '%PHON%' then 'FUNDRAISING'
            when purpose like '%FOOD%' OR purpose like '%CARD%' OR purpose like '%CATERING%'OR purpose like '%EVENT%' OR purpose like '%TRAVEL%' OR purpose like '%MILEAGE%' OR purpose like '%MEALS%' then 'EVENTS'
            when purpose like '%RENT%' OR purpose like 'LODG%' OR purpose like 'LODG%' OR purpose like '%OFFICE%' OR purpose like '%TELEPHONE%' OR purpose like '%PURCHASE%' then 'OFFICE SPACE'
            else 'Others'
            end as cate
,cast(sum(transaction_amt) as integer) as spend from [campaign.CMTE_OPS_EXP_TRANS_DENORM]
where cand_office_st = 'MN'
and cand_pty_affiliation in ('DFL', 'DEM')
and ( ( year(trans_dt) in (2011,2012) and cand_office = 'S')
    OR ( year(trans_dt) in (2007,2008) and cand_office = 'S') )
group by cate
order by spend desc


## get top 15 media spend

Select * from (
select NAME ,
cast(sum(transaction_amt) as integer) as spend from [campaign.CMTE_OPS_EXP_TRANS_DENORM]
where cand_office_st = 'MN'
and cand_pty_affiliation in ('DFL', 'DEM')
and year(trans_dt) in (2015,2016)
and cand_office = 'H'
and case when purpose like '%MEDIA%' OR purpose like '%ADVERTI%' OR purpose like '%PRINT%' OR purpose like '%MAIL%' OR purpose like '%BILLBOARD%' OR purpose like '%POST%' then 'MEDIA'
            when purpose like '%PAYROLL%' OR purpose like '%INSUR%' OR purpose like '%STIPEND%' OR purpose like '%ADMINIS%' OR purpose like '%REIMBURSEMENT%' OR purpose like '%SALARY%' OR purpose like '%FEE%' then 'PAYROLL'
            when purpose like '%CONSULT%' or purpose like '%SERVIC%' then 'CONSULTING'
            when purpose like '%DATABASE%' OR purpose like '%SOFTWARE%' OR purpose like '%WEB%' OR purpose like '%TECHNO%' OR purpose like '%GRAPHIC%' OR purpose like '%COMPUTER%' OR purpose like '%DOMAIN%'  then 'IT'
            when purpose like '%FUND%' OR purpose like '%PHON%' then 'FUNDRAISING'
            when purpose like '%FOOD%' OR purpose like '%CATERING%'OR purpose like '%EVENT%' OR  purpose like '%CARD%'OR purpose like '%TRAVEL%' OR purpose like '%MILEAGE%' OR purpose like '%MEALS%' then 'EVENTS'
            when purpose like '%RENT%' OR purpose like 'LODG%' OR purpose like 'LODG%' OR purpose like '%OFFICE%' OR purpose like '%TELEPHONE%' OR purpose like '%PURCHASE%' then 'OFFICE SPACE'
            else 'Others'
            end = 'MEDIA'
group by NAME
order by spend desc ) t
limit 15



### Get overall campaign spend for senate elections of 2012 and 2008

Select * from (
select NAME ,
cast(sum(transaction_amt) as integer) as spend from [campaign.CMTE_OPS_EXP_TRANS_DENORM]
where cand_office_st = 'MN'
and cand_pty_affiliation in ('DFL', 'DEM')
and ( ( year(trans_dt) in (2011,2012) and cand_office = 'S')
    OR ( year(trans_dt) in (2007,2008) and cand_office = 'S') )
and case when purpose like '%MEDIA%' OR purpose like '%ADVERTI%' OR purpose like '%PRINT%' OR purpose like '%MAIL%' OR purpose like '%BILLBOARD%' OR purpose like '%POST%' then 'MEDIA'
            when purpose like '%PAYROLL%' OR purpose like '%INSUR%' OR purpose like '%STIPEND%' OR purpose like '%ADMINIS%' OR purpose like '%REIMBURSEMENT%' OR purpose like '%SALARY%' OR purpose like '%FEE%' then 'PAYROLL'
            when purpose like '%CONSULT%' or purpose like '%SERVIC%' then 'CONSULTING'
            when purpose like '%DATABASE%' OR purpose like '%SOFTWARE%' OR purpose like '%WEB%' OR purpose like '%TECHNO%' OR purpose like '%GRAPHIC%' OR purpose like '%COMPUTER%' OR purpose like '%DOMAIN%'  then 'IT'
            when purpose like '%FUND%' OR purpose like '%PHON%' then 'FUNDRAISING'
            when purpose like '%FOOD%' OR purpose like '%CATERING%'OR purpose like '%EVENT%' OR  purpose like '%CARD%'OR purpose like '%TRAVEL%' OR purpose like '%MILEAGE%' OR purpose like '%MEALS%' then 'EVENTS'
            when purpose like '%RENT%' OR purpose like 'LODG%' OR purpose like 'LODG%' OR purpose like '%OFFICE%' OR purpose like '%TELEPHONE%' OR purpose like '%PURCHASE%' then 'OFFICE SPACE'
            else 'Others'
            end = 'MEDIA'
group by NAME
order by spend desc ) t
limit 15


### Get the spend for governor election

case when purpose like '%MEDIA%' or purpose like '%SERVIC%' OR purpose like '%ADVERTI%' OR purpose like '%PRINT%' OR purpose like '%MAIL%' OR purpose like '%BILLBOARD%' OR purpose like '%POST%' then 'MEDIA'
            when purpose like '%PAYROLL%' OR purpose like '%INSUR%' OR purpose like '%STIPEND%' OR purpose like '%ADMINIS%' OR purpose like '%REIMBURSEMENT%' OR purpose like '%SALARY%' OR purpose like '%FEE%' then 'PAYROLL'
            when purpose like '%CONSULT%' then 'CONSULTING'
            when purpose like '%DATABASE%' OR purpose like '%SOFTWARE%' OR purpose like '%WEB%' OR purpose like '%TECHNO%' OR purpose like '%GRAPHIC%' OR purpose like '%COMPUTER%' OR purpose like '%DOMAIN%'  then 'IT'
            when purpose like '%FUND%' OR purpose like '%PHON%' then 'FUNDRAISING'
            when purpose like '%FOOD%' OR purpose like '%CARD%' OR purpose like '%CATERING%'OR purpose like '%EVENT%' OR purpose like '%TRAVEL%' OR purpose like '%MILEAGE%' OR purpose like '%MEALS%' then 'EVENTS'
            when purpose like '%RENT%' OR purpose like 'LODG%' OR purpose like 'LODG%' OR purpose like '%OFFICE%' OR purpose like '%TELEPHONE%' OR purpose like '%PURCHASE%' then 'OFFICE SPACE'
            else 'Others'
            end as cate
