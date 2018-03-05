# CampaignAnalytics
This repository has code that was used to pull campaign finance data.
The data is being pulled from couple of places. One is from FCC (Federal Campaign Comission) and other is from Hennepin county campaign finance.

Here are the high level steps that are followed to get the data 

## For Hennepin county campaign finances 
1. Use scrapy to pull data from hennepin county website
2. Load the data pulled to a mySQL database in Google Cloud

## For Federal Campaign Finances
1. Use scrapy to download all the files from fedearal campaign commissions website
2. Code that unzips the file on local machine
3. All all the files to google cloud storage
4. Create tables in google BigQuery for each of the data sets
5. Do bulk load of data from google cloud storage to BigQuery using gsutil or cloud console
6. Create denormalized tables that combines data from multiple table. 
7. Use google data studio to vizualize the data.
