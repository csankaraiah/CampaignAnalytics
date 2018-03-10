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












