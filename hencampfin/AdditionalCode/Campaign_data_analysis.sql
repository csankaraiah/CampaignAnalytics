## Code to profile the data for congressional candidate


## Demographics of the population in a given congressional district

select title, district01_est
from `campaign.MN_CENSUS_2016_DIST`
where upper(topic) = 'PEOPLE'
and upper(subject) = 'SEX AND AGE'
and upper(title) not in ('MALE', 'FEMALE', 'TOTAL POPULATION', '18 YEARS AND OVER','65 YEARS AND OVER');


## Total count of constituents who can vote based on census 2016

select title, district01_est
from `campaign.MN_CENSUS_2016_DIST`
where upper(topic) = 'PEOPLE'
and upper(subject) = 'SEX AND AGE'
and upper(title)  in ( '18 YEARS AND OVER');


#Result = 517,644


## Race for distrct 2 constituents

select topic, subject,title,DISTRICT02_EST, DISTRICT02_MOE
from `campaign.MN_CENSUS_2016_DIST`
where upper(topic) = 'PEOPLE'
and upper(subject) = 'RACE'
and title not in ('Total population','One race','Two or mote race','Some other race')
order by DISTRICT02_EST desc

## Ancestry

select topic, subject,title,DISTRICT02_EST, DISTRICT02_MOE
from `campaign.MN_CENSUS_2016_DIST`
where upper(topic) = 'PEOPLE'
and upper(subject) = 'ANCESTRY'
order by DISTRICT02_EST desc

## male female
select topic, subject,title,DISTRICT02_EST, DISTRICT02_MOE
from `campaign.MN_CENSUS_2016_DIST`
where upper(topic) = 'PEOPLE'
and upper(subject) = 'SEX AND AGE'
and title in ('Male','Female')





## Count of consitutuents who have registered under MN voters list as of march 2018

SELECT congressional, count(*) FROM campaign.MN_VOTERS_LIST
where congressional = '2'
group by congressional

#Result = 420,623


## Total precints under congressional district 2

Select * from `campaign.MN_PRECINCT_DIM`
where Congressional = 2

#Result = 292 precincts


## Total count of votes with different for district 2

select	CONGDIST,count(*) Total_Precints, sum(TOTVOTING) Total_Votes,
sum(USREPR) as JASON_LEWIS,	sum(USREPDFL) as ANGIE_CRAIG ,	sum(USREPWI) as PAULA_OVERBY ,
sum(USREPDFL - USREPR) ANGIE_DEFICIT , sum(USREPTOTAL) as Total
from `campaign.MN_ELECTION_RESULTS_2016`
where congdist = 2
group by CONGDIST

#Row	CONGDIST	Total_Precints	Total_Votes	JASON_LEWIS	ANGIE_CRAIG	PAULA_OVERBY	ANGIE_DEFICIT	Total
#1	2	292	384539	173970	167315	360	-6655	370514


## precint level election wins by candidate in district 2 for year 2016. Sorts the result by the precints where Angie lost by biggest margins


select VTDID,	PCTNAME,PCTCODE,	MCDNAME,	COUNTYNAME,	COUNTYCODE,	CONGDIST,TOTVOTING,
USREPR as JASON_LEWIS,	USREPDFL as ANGIE_CRAIG ,	USREPWI as PAULA_OVERBY ,
USREPDFL - USREPR ANGIE_DEFICIT , USREPTOTAL as Total
from `campaign.MN_ELECTION_RESULTS_2016`
where congdist = 2
and USREPDFL < USREPR
order by ANGIE_DEFICIT ASC


## County level deficit for congressional election district 2 for year 2016

select	CONGDIST, COUNTYNAME, count(*) Total_Precints, sum(TOTVOTING) Total_Votes,
sum(USREPR) as JASON_LEWIS,	sum(USREPDFL) as ANGIE_CRAIG ,	sum(USREPWI) as PAULA_OVERBY ,
sum(USREPDFL - USREPR) ANGIE_DEFICIT , sum(USREPTOTAL) as Total
from `campaign.MN_ELECTION_RESULTS_2016`
where congdist = 2
group by CONGDIST,COUNTYNAME
order by ANGIE_DEFICIT asc

#Result = Scott county is causing the most deficit with 4 time more than the next county which is Goodhue


## Top cities with biggest deficit

select	MCDNAME, count(*) Total_Precints, sum(TOTVOTING) Total_Votes,
sum(USREPR) as JASON_LEWIS,	sum(USREPDFL) as ANGIE_CRAIG ,	sum(USREPWI) as PAULA_OVERBY ,
sum(USREPDFL - USREPR) ANGIE_DEFICIT , sum(USREPTOTAL) as Total
from `campaign.MN_ELECTION_RESULTS_2016`
where congdist = 2
--and COUNTYNAME = 'Scott'
group by MCDNAME
order by ANGIE_DEFICIT asc
limit 5


## query for 2010 election results

select	precinct_name, count(*) Total_Precints, sum(TOTVOTers) Total_Votes,
sum(CONGR) as JASON_LEWIS,	sum(CONGDFL) as ANGIE_CRAIG ,	sum(CONGWI) as PAULA_OVERBY ,
sum(CONGDFL - CONGR) ANGIE_DEFICIT , sum(CONGTOT) as Total
from `campaign.MN_ELECTION_RESULTS_2010`
where CG = 2
--and COUNTYNAME = 'Scott'
group by precinct_name
order by ANGIE_DEFICIT asc
limit 5



#### past 3 years election



select	COUNTYNAME,MCDNAME,CONGDIST,
count(*) Total_Precints,
sum(TOTVOTING) Total_Votes,
'2016' YR,
sum(USREPDFL - USREPR) US_House_DFL_Deficit ,
sum(USPRSDFL - USPRSR) US_President_DFL_deficit,
sum(REG7AM)	registered_voters,
sum(EDR)	registered_voting_day,
sum(USPRSR) US_President_REP_votes,
sum(USPRSDFL) US_President_DFL_votes,
sum(USPRSTOTAL) US_President_Total,
sum(USREPR) as US_House_REP_votes,
sum(USREPDFL) as US_House_DFL_votes ,
sum(USREPTOTAL) as Total
from `campaign.MN_ELECTION_RESULTS_2016`
where congdist = 2
group by COUNTYNAME,MCDNAME,CONGDIST

UNION ALL

select	COUNTYNAME,MCDNAME,CONGDIST,
count(*) Total_Precints,
sum(TOTVOTING) Total_Votes,
'2014' YR,
sum(USREPDFL - USREPR) US_House_DFL_Deficit ,
0 US_President_DFL_deficit,
sum(REG7AM)	registered_voters,
sum(EDR)	registered_voting_day,
0 US_President_REP_votes,
0 US_President_DFL_votes,
0 US_President_Total,
sum(USREPR) as US_House_REP_votes,
sum(USREPDFL) as US_House_DFL_votes ,
sum(USREPTOTAL) as Total
from `campaign.MN_ELECTION_RESULTS_2014`
where congdist = 2
group by COUNTYNAME,MCDNAME,CONGDIST

UNION ALL

select	COUNTYNAME,MCDNAME,CONGDIST,
count(*) Total_Precints,
sum(TOTVOTING) Total_Votes,
'2012' YR,
sum(USREPDFL - USREPR) US_House_DFL_Deficit ,
sum(USPRSDFL - USPRSR) US_President_DFL_deficit,
sum(_7AM)	registered_voters,
sum(EDR)	registered_voting_day,
sum(USPRSR) US_President_REP_votes,
sum(USPRSDFL) US_President_DFL_votes,
sum(USPRSTOTAL) US_President_Total,
sum(USREPR) as US_House_REP_votes,
sum(USREPDFL) as US_House_DFL_votes ,
sum(USREPTOTAL) as Total
from `campaign.MN_ELECTION_RESULTS_2012`
where congdist = 2
group by COUNTYNAME,MCDNAME,CONGDIST
order by US_House_DFL_Deficit  asc





## However city wise Lakeville , Prior Lake & Farmington show the biggest deficits

select	CONGDIST,MCDNAME, count(*) Total_Precints, sum(TOTVOTING) Total_Votes,
sum(USREPR) as JASON_LEWIS,	sum(USREPDFL) as ANGIE_CRAIG ,	sum(USREPWI) as PAULA_OVERBY ,
sum(USREPDFL - USREPR) ANGIE_DEFICIT , sum(USREPTOTAL) as Total
from `campaign.MN_ELECTION_RESULTS_2016`
where congdist = 2
group by CONGDIST,MCDNAME
HAVING  ANGIE_DEFICIT < -100
order by ANGIE_DEFICIT ASC



## Candidates that are registered voters for Scott county based on MN voters list

select count(*) from `campaign.MN_VOTERS_LIST`
where Congressional = '2'
and countycode = '70' -- county code for Scott county check MN_PRECINT_DIM table

# Result = 83,409


## Estimated total population in Scott County
select * from campaign.CENSUS_US_COUNTY_2016
where STNAME = 'Minnesota'
and CTYNAME = 'Scott County'

#Result for year 2016 = 143,680 , Household = 48789



### Census data analysis
# get FIPS code for county
select * from `campaign.CENSUS_US_FIPS_CODE_DIM`
where state_abbreviation = 'MN'
and Entity_description = 'County'
and GU_Name = 'Scott' -- county_code = 139

# Get the population for scott county by can be used to get city level population as well
select sum(POPESTIMATE2016) from `campaign.CENSUS_BY_CITY_2016` pop
where STNAME = 'Minnesota'
and sumlev = 61
and county = 139
#Result = 143,680


## Population by sex and age for a county or city

select sum(Total_Estimate_Total_population) from `campaign.ACS_MN_BY_AGE_SEX_2016`
where trim(state) ='Minnesota'
and trim(County) = 'Scott County'
#Result = 139,490


## Topic cities in Scott county

select trim(city) ct ,count(*) cnt from `campaign.MN_VOTERS_LIST`
where Congressional = '2'
and countycode = '70'
group by  ct
order by cnt desc
limit 5

## Total eligible voters as of 2016 based on ASC estimates

select state,county , round(sum(eligible_voters)) tot_voters from (
select state,county,city, Total_Estimate_Total_population * (Total_Estimate_SELECTED_AGE_CATEGORIES__18_years_and_over/100) eligible_voters
from `campaign.ACS_MN_BY_AGE_SEX_2016`
where trim(state) ='Minnesota'
and trim(County) = 'Scott County') a
group by state,county

#result = 99,378


## eligible voters by city

select upper(state) st ,upper(county) cnty, upper(city) ci, cast(eligible_voters as int64) tot_eligible_voters from (
select state,county,city,
Total_Estimate_Total_population * (Total_Estimate_SELECTED_AGE_CATEGORIES__18_years_and_over/100) eligible_voters
from `campaign.ACS_MN_BY_AGE_SEX_2016`
where trim(state) ='Minnesota'
and upper(trim(replace(city,'city',''))) in (select city from `campaign.MN_VOTERS_LIST`
                    where Congressional = '2'
                    group by city )
) a



### total population est  by

select state,county,city,
Total_Estimate_Total_population,
Male_Estimate_Total_population,
Female_Estimate_Total_population,
Total_Estimate_AGE__Under_5_years,
Total_Estimate_AGE__5_to_9_years,
Total_Estimate_AGE__10_to_14_years,
Total_Estimate_AGE__15_to_19_years,
Total_Estimate_AGE__20_to_24_years,
Total_Estimate_AGE__25_to_29_years,
Total_Estimate_AGE__30_to_34_years,
Total_Estimate_AGE__35_to_39_years,
Total_Estimate_AGE__40_to_44_years,
Total_Estimate_AGE__45_to_49_years,
Total_Estimate_AGE__50_to_54_years,
Total_Estimate_AGE__55_to_59_years,
Total_Estimate_AGE__60_to_64_years,
Total_Estimate_AGE__65_to_69_years,
Total_Estimate_AGE__70_to_74_years,
Total_Estimate_AGE__75_to_79_years,
Total_Estimate_AGE__80_to_84_years,
Total_Estimate_AGE__85_years_and_over,
cast ( Total_Estimate_Total_population * (Total_Estimate_SELECTED_AGE_CATEGORIES__18_years_and_over/100) as int64)  eligible_voters
from `campaign.ACS_MN_BY_AGE_SEX_2016`
where trim(state) ='Minnesota'
and upper(trim(replace(city,'city',''))) in (select city from `campaign.MN_VOTERS_LIST`
                                              where Congressional = '2'
                                              group by city )




### total voters based on census

select upper(state) state,
upper(county) county,
upper(city) city,
Total_Estimate_Total_population,
Male_Estimate_Total_population,
Female_Estimate_Total_population,
cast ( Total_Estimate_Total_population * (Total_Estimate_AGE__Under_5_years/100) as int64)  AGE__Under_5_years,
cast ( Total_Estimate_Total_population * (Total_Estimate_AGE__5_to_9_years/100) as int64)  AGE__5_to_9_years,
cast ( Total_Estimate_Total_population * (Total_Estimate_AGE__10_to_14_years/100) as int64)  AGE__10_to_14_years,
cast ( Total_Estimate_Total_population * (Total_Estimate_AGE__15_to_19_years/100) as int64)  AGE__15_to_19_years,
cast ( Total_Estimate_Total_population * (Total_Estimate_AGE__20_to_24_years/100) as int64)  AGE__20_to_24_years,
cast ( Total_Estimate_Total_population * (Total_Estimate_AGE__25_to_29_years/100) as int64)  AGE__25_to_29_years,
cast ( Total_Estimate_Total_population * (Total_Estimate_AGE__30_to_34_years/100) as int64)  AGE__30_to_34_years,
cast ( Total_Estimate_Total_population * (Total_Estimate_AGE__35_to_39_years/100) as int64)  AGE__35_to_39_years,
cast ( Total_Estimate_Total_population * (Total_Estimate_AGE__40_to_44_years/100) as int64)  AGE__40_to_44_years,
cast ( Total_Estimate_Total_population * (Total_Estimate_AGE__45_to_49_years/100) as int64)  AGE__45_to_49_years,
cast ( Total_Estimate_Total_population * (Total_Estimate_AGE__50_to_54_years/100) as int64)  AGE__50_to_54_years,
cast ( Total_Estimate_Total_population * (Total_Estimate_AGE__55_to_59_years/100) as int64)  AGE__55_to_59_years,
cast ( Total_Estimate_Total_population * (Total_Estimate_AGE__60_to_64_years/100) as int64)  AGE__60_to_64_years,
cast ( Total_Estimate_Total_population * (Total_Estimate_AGE__65_to_69_years/100) as int64)  AGE__65_to_69_years,
cast ( Total_Estimate_Total_population * (Total_Estimate_AGE__70_to_74_years/100) as int64)  AGE__70_to_74_years,
cast ( Total_Estimate_Total_population * (Total_Estimate_AGE__75_to_79_years/100) as int64)  AGE__75_to_79_years,
cast ( Total_Estimate_Total_population * (Total_Estimate_AGE__80_to_84_years/100) as int64)  AGE__80_to_84_years,
cast ( Total_Estimate_Total_population * (Total_Estimate_AGE__85_years_and_over/100) as int64)  AGE__85_years_and_over,
cast ( Total_Estimate_Total_population * (Total_Estimate_SELECTED_AGE_CATEGORIES__18_years_and_over/100) as int64)  eligible_voters
from `campaign.ACS_MN_BY_AGE_SEX_2016`
where trim(state) ='Minnesota'
and upper(trim(replace(city,'city',''))) in (select city from `campaign.MN_VOTERS_LIST`
                                              where Congressional = '2'
                                              group by city )





######################## Federal Contribution and expense analysis



#### contribution amount from individual contributions are counted separate from cmte contributions

select b.cand_name,b.cand_city, a.* FROM `campaign.CMTE_MST_UNI`  a
join `campaign.CAND_MST_UNI` b on a.cand_id = b.cand_id
where cand_name like '%CRAIG, ANGELA DAWN%' -- cmte_id =	C00575209	cmtename = ANGIE CRAIG FOR CONGRESS

select sum( TRANSACTION_AMT) from `campaign.CMTE_TO_CAND_TRANS_DENORM`
where cand_name like '%CRAIG, ANGELA DAWN%' -- 2,724,868.0

select cmte_nm, sum( TRANSACTION_AMT) from `campaign.INDV_TO_CMTE_TRANS_DENOR`
where cand_name like '%CRAIG, ANGELA DAWN%' --2,501,747.0
group by CMTE_NM -- cmte_nm ANGIE CRAIG FOR CONGRESS


select * from campaign.CMTE_TO_CAND_TRANS_DENORM
where cand_name in ('LEWIS, JASON MARK MR.','CRAIG, ANGELA DAWN')
and year(trans_dt) in (2015,2016)

select * from campaign.INDV_TO_CMTE_TRANS_DENOR
where cand_name in ('LEWIS, JASON MARK MR.','CRAIG, ANGELA DAWN')
and year(trans_dt) in (2015,2016)





### Media spend by candidates

select name, case when purpose in ('MEDIA','MEDIA BUY','MEDIA BUY/PRODUCTION','MEDIA PRODUCTION') then 'MEDIA' else purpose end as cate ,cast(sum(transaction_amt) as integer) as spend
from [campaign.CMTE_OPS_EXP_TRANS_DENORM]
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



##### How can we increase the political engagement of communities? Here are couple of questions i have

Q1. Can we get a geo coded map that shows number of people who are registered to vote, who actually voted and who are eligible to vote
Q2. Can we get a report that shows voter turnout for presidential elections and non presidential elections
Q3. Can we get a report that shows folks who are interested in primaries by region.



### Analysis to provide  this results

Q1:
 Part 1 Number of people registered and number of people voted in 2016

select MCDNAME, COUNTYNAME,
sum(reg7am) registered_voters, sum(EDR) registered_voting_day, sum(totvoting) number_of_votes,
sum(USPRSTOTAL) pres_tot, sum(USPRSR) usp_rep_voters, sum(usprsdfl) usp_dem_voters,  sum(USPRSTOTAL) - (sum(USPRSR) + sum(usprsdfl)) usp_other_voters,
sum(USREPTOTAL) usrep_tot, sum(MNSENR) usrep_rep_voters, sum(MNSENDFL) usrep_dem_voters,
sum(MNSENTOTAL) mnsen_tot, sum(MNSENR) mnsen_rep_voters, sum(MNSENDFL) mnsen_dem_voters,
sum(MNLEGTOTAL) mnrep_tot, sum(MNLEGR) mnrep_rep_voters, sum(MNLEGDFL) mnrep_dem_voters
from [campaign.MN_ELECTION_RESULTS_2016]
where MCDNAME is not null
group by MCDNAME, COUNTYNAME

Q2:
  Part2: total poulation eligible to vote


select state,county,city, Est_SEX_AND_AGE_Total_population ,Est_CITIZEN_VOTING_AGE_POPULATION_Citizen_18_over_population
from `campaign.ACS_MN_DEMOGRA_BY_CITY_2016`
where trim(state) ='Minnesota'
and trim(County) = 'Scott'

# Final answer for Q1



SELECT
  census_pop.st,
  census_pop.cnty,
  census_pop.sub_division,
  census_pop.eligible_voters,
  elec_res.registered_voters,
  elec_res.number_of_votes,
  2016 yr
FROM (
  SELECT
    UPPER(TRIM(MCDNAME)) sub_div,
    UPPER(TRIM(COUNTYNAME)) conty,
    SUM(reg7am) registered_voters,
    SUM(EDR) registered_voting_day,
    SUM(totvoting) number_of_votes,
    SUM(USPRSTOTAL) pres_tot,
    SUM(USPRSR) usp_rep_voters,
    SUM(usprsdfl) usp_dem_voters,
    SUM(USPRSTOTAL) - (SUM(USPRSR) + SUM(usprsdfl)) usp_other_voters,
    SUM(USREPTOTAL) usrep_tot,
    SUM(MNSENR) usrep_rep_voters,
    SUM(MNSENDFL) usrep_dem_voters,
    SUM(MNSENTOTAL) mnsen_tot,
    SUM(MNSENR) mnsen_rep_voters,
    SUM(MNSENDFL) mnsen_dem_voters,
    SUM(MNLEGTOTAL) mnrep_tot,
    SUM(MNLEGR) mnrep_rep_voters,
    SUM(MNLEGDFL) mnrep_dem_voters
  FROM
    campaign.MN_ELECTION_RESULTS_2016
  WHERE
    UPPER(TRIM(COUNTYNAME)) = 'SCOTT'
  GROUP BY
    MCDNAME,
    COUNTYNAME ) elec_res
JOIN (
  SELECT
    UPPER(TRIM(state)) st,
    UPPER(TRIM(county)) cnty,
    UPPER(TRIM(city)) sub_division,
    Est_CITIZEN_VOTING_AGE_POPULATION_Citizen_18_over_population eligible_voters
  FROM
    `campaign.ACS_MN_DEMOGRA_BY_CITY_2016`
  WHERE
    UPPER(TRIM(state)) ='MINNESOTA'
    AND UPPER(TRIM(County)) = 'SCOTT') census_pop
ON
  elec_res.sub_div = census_pop.sub_division
  AND elec_res.conty = census_pop.cnty




##



SELECT
  census_pop.st,
  census_pop.cnty,
  census_pop.sub_division,
  census_pop.eligible_voters,
  elec_res.registered_voters,
  elec_res.number_of_votes,
  2014 yr
FROM (
  SELECT
    UPPER(TRIM(MCDNAME)) sub_div,
    UPPER(TRIM(COUNTYNAME)) conty,
    SUM(reg7am) registered_voters,
    SUM(EDR) registered_voting_day,
    SUM(totvoting) number_of_votes
  FROM
    campaign.MN_ELECTION_RESULTS_2014
  WHERE
    UPPER(TRIM(COUNTYNAME)) = 'SCOTT'
  GROUP BY
    MCDNAME,
    COUNTYNAME ) elec_res
JOIN (
  SELECT
    UPPER(TRIM(state)) st,
    UPPER(TRIM(county)) cnty,
    UPPER(TRIM(city)) sub_division,
    Est_CITIZEN_VOTING_AGE_POPULATION_Citizen_18_over_population eligible_voters
  FROM
    `campaign.ACS_MN_DEMOGRA_BY_CITY_2016`
  WHERE
    UPPER(TRIM(state)) ='MINNESOTA'
    AND UPPER(TRIM(County)) = 'SCOTT') census_pop
ON
  elec_res.sub_div = census_pop.sub_division
  AND elec_res.conty = census_pop.cnty



### Query to get age by subdivision

select upper(trim(state)) st ,
upper(trim(county)) cnty ,
upper(trim(city)) sub_division,
Est_SEX_AND_AGE_Total_population tot_pop,
Est_SEX_AND_AGE_Under_5_years + Est_SEX_AND_AGE_5_to_9_years + Est_SEX_AND_AGE_10_to_14_years  between0_to_15_pop,
Est_SEX_AND_AGE_15_to_19_years + Est_SEX_AND_AGE_20_to_24_years between15_to_25_pop,
Est_SEX_AND_AGE_25_to_34_years + Est_SEX_AND_AGE_35_to_44_years between25_45_pop,
Est_SEX_AND_AGE_45_to_54_years + Est_SEX_AND_AGE_55_to_59_years between45_59_pop,
Est_SEX_AND_AGE_60_to_64_years + Est_SEX_AND_AGE_65_to_74_years + Est_SEX_AND_AGE_75_to_84_years between60_85_pop,
Est_SEX_AND_AGE_85_years_over above85_pop
from `campaign.ACS_MN_DEMOGRA_BY_CITY_2016`
where upper(trim(state)) ='MINNESOTA'
--and upper(trim(county)) = 'SCOTT'


## Query to get household info

select upper(trim(state)) st ,
upper(trim(county)) cnty ,
upper(trim(city)) sub_division,
Est_Tot_Households tot_household ,
Est_Tot_Households___With_own_children_of_the_householder_under_18_years household_18underkid,
Est_Tot_Households___Married0couple_family household_marriedcouple,
Est_Tot_Households_Nonfamily_households household_nonfamily,
Est_HOUSEHOLDS_BY_TYPE_Average_household_size household_avgsize,
Est_SCHOOL_ENROLLMENT_Population_3_years_and_over_enrolled_in_school population_kids3above_school,
Est_SCHOOL_ENROLLMENT_Population_3_years_and_over_enrolled_in_school_Nursery_school_preschool population_kids_nursery_preschool,
Est_SCHOOL_ENROLLMENT_Population_3_years_and_over_enrolled_in_school_Kindergarten population_kids_kindergarden,
Est_SCHOOL_ENROLLMENT_Population_3_years_and_over_enrolled_in_school_Elementary_school__grades_108_ population_kidsgrade1_8,
Est_SCHOOL_ENROLLMENT_Population_3_years_and_over_enrolled_in_school_High_school__grades_9012_ population_kidsgrade9_12 ,
Est_SCHOOL_ENROLLMENT_Population_3_years_and_over_enrolled_in_school_College_or_graduate_school population_collegegraduate
from `campaign.ACS_MN_SOCIAL_ECON_BY_CITY_2016`
where upper(trim(state)) ='MINNESOTA'



## Query by education of 25+

select upper(trim(state)) st ,
upper(trim(county)) cnty ,
upper(trim(city)) sub_division,
Est_EDUCATIONAL_ATTAINMENT_Population_25_years_and_over population_over25,
Est_EDUCATIONAL_ATTAINMENT_Population_25_years_and_over_Less_than_9th_grade edu_attainment_lessthan9thgrade,
Est_EDUCATIONAL_ATTAINMENT_Population_25_years_and_over_9th_to_12th_grade_no_diploma edu_attainment_9thto12thgrade,
Est_EDUCATIONAL_ATTAINMENT_Population_25_years_and_over_High_school_graduate__includes_equivalency_ edu_attainment_highschool,
Est_EDUCATIONAL_ATTAINMENT_Population_25_years_and_over_Some_college_no_degree edu_attainment_college_nodegree,
Est_EDUCATIONAL_ATTAINMENT_Population_25_years_and_over_Associate_s_degree edu_attainment_asssociate_degree,
Est_EDUCATIONAL_ATTAINMENT_Population_25_years_and_over_Bachelor_s_degree edu_attainment_bachelors_degree,
Est_EDUCATIONAL_ATTAINMENT_Population_25_years_and_over_Graduate_or_professional_degree edu_attainment_graduate_degree
from `campaign.ACS_MN_SOCIAL_ECON_BY_CITY_2016`
where upper(trim(state)) ='MINNESOTA'



##Denormalized table

Select
a.st state,
b.cnty county,
c.sub_division subdivision,
eligible_voters,
registered_voters,
number_of_votes,
eligible_not_voted,
registered_not_voted,
Year,
tot_pop,
between0_to_15_pop,
between15_to_25_pop,
between25_45_pop,
between45_59_pop,
between60_85_pop,
above85_pop,
population_over25,
edu_attainment_lessthan9thgrade,
edu_attainment_9thto12thgrade,
edu_attainment_highschool,
edu_attainment_college_nodegree,
edu_attainment_asssociate_degree,
edu_attainment_bachelors_degree,
edu_attainment_graduate_degree,
tot_household,
household_18underkid,
household_marriedcouple,
household_nonfamily,
household_avgsize,
population_kids3above_school,
population_kids_nursery_preschool,
population_kids_kindergarden,
population_kidsgrade1_8,
population_kidsgrade9_12,
population_collegegraduate,
IncomeBenefits_Total,
IncomeBenefits_Below50K,
IncomeBenefits_50_99K,
IncomeBenefits_100_149K,
IncomeBenefits_150_199K,
IncomeBenefits_200K_andAbove,
Est_RACE_Total_population,
Est_RACE_One_race_White,
Est_RACE_One_race_Black_or_African_American,
Est_RACE_One_race_American_Indian_and_Alaska_Native,
Est_RACE_One_race_Asian,
Est_RACE_One_race_Native_Hawaiian_and_Other_Pacific_Islander,
Est_RACE_One_race_Some_other_race,
Est_RACE_Total_population_Two_or_more_races
from
ogdatabase.OG_CountySubdivision_counts a
left outer join ogdatabase.OG_CountySubdivision_by_age b on (a.st=b.st and a.cnty = b.cnty and a.sub_division = b.sub_division)
left outer join ogdatabase.OG_CountySubdivision_by_education c on (a.st=c.st and a.cnty = c.cnty and a.sub_division = c.sub_division)
left outer join ogdatabase.OG_CountySubdivision_by_household d on (a.st=d.st and a.cnty = d.cnty and a.sub_division = d.sub_division)
left outer join ogdatabase.OG_subdivision_income e on (a.st=e.st and a.cnty = e.cnty and a.sub_division = e.sub_division)
left outer join ogdatabase.OG_subdivision_race f on (a.st=f.st and a.cnty = f.cnty and a.sub_division = f.sub_division)






Select
a.st state,
a.cnty county,
a.sub_division subdivision,
a.eligible_voters,
a.registered_voters,
a.number_of_votes,
a.eligible_not_voted,
a.registered_not_voted,
b.tot_pop,
b.between0_to_15_pop,
b.between15_to_25_pop,
b.between25_45_pop,
b.between45_59_pop,
b.between60_85_pop,
b.above85_pop,
c.population_over25,
c.edu_attainment_lessthan9thgrade,
c.edu_attainment_9thto12thgrade,
c.edu_attainment_highschool,
c.edu_attainment_college_nodegree,
c.edu_attainment_asssociate_degree,
c.edu_attainment_bachelors_degree,
c.edu_attainment_graduate_degree,
d.tot_household,
d.household_18underkid,
d.household_marriedcouple,
d.household_nonfamily,
d.household_avgsize,
d.population_kids3above_school,
d.population_kids_nursery_preschool,
d.population_kids_kindergarden,
d.population_kidsgrade1_8,
d.population_kidsgrade9_12,
d.population_collegegraduate,
e.IncomeBenefits_Total,
e.IncomeBenefits_Below50K,
e.IncomeBenefits_50_99K,
e.IncomeBenefits_100_149K,
e.IncomeBenefits_150_199K,
e.IncomeBenefits_200K_andAbove,
f.Est_RACE_Total_population,
f.Est_RACE_One_race_White,
f.Est_RACE_One_race_Black_or_African_American,
f.Est_RACE_One_race_American_Indian_and_Alaska_Native,
f.Est_RACE_One_race_Asian,
f.Est_RACE_One_race_Native_Hawaiian_and_Other_Pacific_Islander,
f.Est_RACE_One_race_Some_other_race,
f.Est_RACE_Total_population_Two_or_more_races
from
ogdatabase.OG_CountySubdivision_counts a
left outer join ogdatabase.OG_CountySubdivision_by_age b on (a.st=b.st and a.cnty = b.cnty and a.sub_division = b.sub_division)
left outer join ogdatabase.OG_CountySubdivision_by_education c on (a.st=c.st and a.cnty = c.cnty and a.sub_division = c.sub_division)
left outer join ogdatabase.OG_CountySubdivision_by_household d on (a.st=d.st and a.cnty = d.cnty and a.sub_division = d.sub_division)
left outer join ogdatabase.OG_subdivision_income e on (a.st=trim(e.st) and a.cnty = trim(e.cnty) and a.sub_division = trim(e.sub_division))
left outer join ogdatabase.OG_subdivision_race f on (a.st=trim(f.st) and a.cnty = trim(f.cnty) and a.sub_division = trim(f.sub_division))




#####################  Get election result with lat long

select * from
(SELECT
  UPPER(PCTNAME) precinct_nm,
  PCTCODE ,
  COUNTYCODE,
  UPPER(MCDNAME) subdivision_nm,
  UPPER(COUNTYNAME) county_nm,
  'MN' state,
  CONGDIST,
  MNSENDIST,
  MNLEGDIST,
  CTYCOMDIST,
  SUM(reg7am) registered_voters,
  SUM(EDR) registered_voting_day,
  SUM(totvoting) number_of_votes,
  SUM(USPRSTOTAL) pres_tot,
  SUM(USPRSR) usp_rep_voters,
  SUM(usprsdfl) usp_dem_voters,
  SUM(USPRSTOTAL) - (SUM(USPRSR) + SUM(usprsdfl)) usp_other_voters,
  SUM(USREPTOTAL) usrep_tot,
  SUM(MNSENR) usrep_rep_voters,
  SUM(MNSENDFL) usrep_dem_voters,
  SUM(MNSENTOTAL) mnsen_tot,
  SUM(MNSENR) mnsen_rep_voters,
  SUM(MNSENDFL) mnsen_dem_voters,
  SUM(MNLEGTOTAL) mnrep_tot,
  SUM(MNLEGR) mnrep_rep_voters,
  SUM(MNLEGDFL) mnrep_dem_voters
FROM
  campaign.MN_ELECTION_RESULTS_2016
WHERE
  MCDNAME IS NOT NULL
GROUP BY
  PCTNAME,
  PCTCODE ,
  COUNTYCODE,
  MCDNAME,
  COUNTYNAME,
  CONGDIST,
  MNSENDIST,
  MNLEGDIST,
  CTYCOMDIST ) mn_results join
(select
Precinct_nm_upper,
PCTCODE PRECINCT_CODE,
COUNTYCODE COUNTY_CODE,
COUNTYNAME cnty_nm,
Lat,
Long,
latlong
from
`campaign.MN_PRECINCT_LOC_DIM` ) mn_loc
ON mn_results.PCTCODE = mn_loc.PRECINCT_CODE AND mn_results.COUNTYCODE = MN_LOC.COUNTY_CODE


##
select   concat(UPPER(PCTNAME),UPPER(COUNTYNAME)) prec_county,
FROM
  campaign.MN_ELECTION_RESULTS_2016


## Cleanup of precinct name

select PCTNAME, upper(trim(replace(replace(upper(trim(PCTNAME)),'.',''),'TOWNSHIP','TWP'))) from campaign.MN_ELECTION_RESULTS_2016
where upper(trim(PCTNAME)) in ('LINSELL TWP.','BEAVER TOWNSHIP','THIEF RIVER FALLS (5)')

select PCTNAME ,
length(upper(trim(PCTNAME))),
CONCAT(CONCAT(SUBSTR(upper(trim(PCTNAME)),1,STRPOS(upper(trim(PCTNAME)),'(')-2),' P-'),SUBSTR(upper(trim(PCTNAME)),STRPOS(upper(trim(PCTNAME)),'(')+1,length(upper(trim(PCTNAME)))-STRPOS(upper(trim(PCTNAME)),'(')-1))
from campaign.MN_ELECTION_RESULTS_2016
where upper(trim(PCTNAME)) like 'THIEF RIVER%'

select PCTNAME ,
CASE WHEN STRPOS(upper(trim(PCTNAME)),'(') >1 THEN
                  CONCAT(CONCAT(SUBSTR(upper(trim(PCTNAME)),1,STRPOS(upper(trim(PCTNAME)),'(')-2),' P-'),SUBSTR(upper(trim(PCTNAME)),STRPOS(upper(trim(PCTNAME)),'(')+1,length(upper(trim(PCTNAME)))-STRPOS(upper(trim(PCTNAME)),'(')-1))
     ELSE upper(trim(replace(replace(upper(trim(PCTNAME)),'.',''),'TOWNSHIP','TWP')))
     END PRECINCT_NAME
from campaign.MN_ELECTION_RESULTS_2016
where upper(trim(PCTNAME)) like 'THIEF RIVER%'
OR (upper(trim(PCTNAME)) in ('LINSELL TWP.','BEAVER TOWNSHIP','THIEF RIVER FALLS (5)'))




### Query to get number of votes


SELECT
  voterid,
  MAX(IF(extract(year from electiondate) =1993, VotingMethod , NULL)) AS yr1993,
MAX(IF(extract(year from electiondate) =1994, VotingMethod , NULL)) AS yr1994,
MAX(IF(extract(year from electiondate) =1995, VotingMethod , NULL)) AS yr1995,
MAX(IF(extract(year from electiondate) =1996, VotingMethod , NULL)) AS yr1996,
MAX(IF(extract(year from electiondate) =1997, VotingMethod , NULL)) AS yr1997,
MAX(IF(extract(year from electiondate) =1998, VotingMethod , NULL)) AS yr1998,
MAX(IF(extract(year from electiondate) =1999, VotingMethod , NULL)) AS yr1999,
MAX(IF(extract(year from electiondate) =2000, VotingMethod , NULL)) AS yr2000,
MAX(IF(extract(year from electiondate) =2001, VotingMethod , NULL)) AS yr2001,
MAX(IF(extract(year from electiondate) =2002, VotingMethod , NULL)) AS yr2002,
MAX(IF(extract(year from electiondate) =2003, VotingMethod , NULL)) AS yr2003,
MAX(IF(extract(year from electiondate) =2004, VotingMethod , NULL)) AS yr2004,
MAX(IF(extract(year from electiondate) =2005, VotingMethod , NULL)) AS yr2005,
MAX(IF(extract(year from electiondate) =2006, VotingMethod , NULL)) AS yr2006,
MAX(IF(extract(year from electiondate) =2007, VotingMethod , NULL)) AS yr2007,
MAX(IF(extract(year from electiondate) =2008, VotingMethod , NULL)) AS yr2008,
MAX(IF(extract(year from electiondate) =2009, VotingMethod , NULL)) AS yr2009,
MAX(IF(extract(year from electiondate) =2010, VotingMethod , NULL)) AS yr2010,
MAX(IF(extract(year from electiondate) =2011, VotingMethod , NULL)) AS yr2011,
MAX(IF(extract(year from electiondate) =2012, VotingMethod , NULL)) AS yr2012,
MAX(IF(extract(year from electiondate) =2013, VotingMethod , NULL)) AS yr2013,
MAX(IF(extract(year from electiondate) =2014, VotingMethod , NULL)) AS yr2014,
MAX(IF(extract(year from electiondate) =2015, VotingMethod , NULL)) AS yr2015,
MAX(IF(extract(year from electiondate) =2016, VotingMethod , NULL)) AS yr2016,
MAX(IF(extract(year from electiondate) =2017, VotingMethod , NULL)) AS yr2017,
MAX(IF(extract(year from electiondate) =2018, VotingMethod , NULL)) AS yr2018
FROM `campaign.MN_VOTERS_ELECTION`
--where voterid = 102286
GROUP BY voterid
ORDER BY voterid
limit 100

