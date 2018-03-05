# -*- coding: utf-8 -*-
# Chakra March 05 2018: This code captures data from Hennepin county around the campaign finances that has been submitted by
# campaign committees running for minneapolis city mayor, city council, Hennepin county & park board.

from scrapy import Spider
from selenium import webdriver
from scrapy.selector import Selector
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import datetime
import os
import glob
import pymysql
import csv
import pandas as pd



class CandidatesSpider(Spider):
    name = 'candidates'
    allowed_domains = ['www16.co.hennepin.mn.us']
    start_urls = ['http://www16.co.hennepin.mn.us/cfrs/search_options.do']


    def parse(self, response):
        self.driver = webdriver.Chrome('/Users/demo/Documents/learn/pracpy/chscrapy/selenium_sample/chromedriver')
        self.driver.get('http://www16.co.hennepin.mn.us/cfrs/search.do')
        try:
            element = WebDriverWait(self.driver, 2).until(
                EC.presence_of_element_located((By.CSS_SELECTOR, "input[type='radio']")))
        finally:
            self.driver.find_element_by_css_selector("input[type='radio']").click()
            self.driver.find_element_by_xpath('//button[@class="btn btn-primary"]').click()

        self.driver.find_element_by_xpath('//h5/label/a[last()]').click()
        sel = Selector(text=self.driver.page_source)
        table = sel.xpath('//tbody/tr')

        for row in table:
            candidate_name = row.xpath('.//td[1]/a/text()').extract_first().strip() if row.xpath('.//td[1]/a/text()').extract_first() is not None else None
            committe_name = row.xpath('.//td[2]/text()').extract_first().strip() if row.xpath('.//td[2]/text()').extract_first() is not None else None
            registration_date = row.xpath('.//td[3]/text()').extract_first().strip() if row.xpath('.//td[3]/text()').extract_first() is not None else None
            termination_date = row.xpath('.//td[4]/text()').extract_first().strip() if row.xpath('.//td[4]/text()').extract_first() is not None else None
            location = row.xpath('.//td[5]/text()').extract_first().strip() if row.xpath('.//td[5]/text()').extract_first() is not None else None
            office = row.xpath('.//td[6]/text()').extract_first().strip() if row.xpath('.//td[6]/text()').extract_first() is not None else None
            district_num = row.xpath('.//td[7]/text()').extract_first() if row.xpath('.//td[7]/text()') is not None else None
            ytd_revenues = row.xpath('.//td[8]/text()').extract_first().strip() if row.xpath('.//td[8]/text()').extract_first() is not None else None
            ytd_expenses = row.xpath('.//td[9]/text()').extract_first().strip() if row.xpath('.//td[9]/text()').extract_first() is not None else None
            cash_balance = row.xpath('.//td[10]/text()').extract_first().strip() if row.xpath('.//td[10]/text()').extract_first() is not None else None
            now = datetime.datetime.now()
            ins_date = now.strftime("%Y-%m-%d")

            yield {'candidate_name': candidate_name,
                   'committe_name': committe_name,
                   'registration_date': registration_date,
                   'termination_date': termination_date,
                   'location': location,
                   'office': office,
                   'district_num': district_num,
                   'ytd_revenues': ytd_revenues,
                   'ytd_expenses': ytd_expenses,
                   'cash_balance': cash_balance,
                   'ins_date': ins_date
                   }
       # self.driver.quit()

    # Chakra March 05 , 2018: This section of the code writed the data to mysql DB

    def close(self, reason):
        csv_file = max(glob.iglob('*.csv'), key=os.path.getctime)
        os.rename(csv_file, 'candidate_fin.csv')

        df = pd.read_csv('/Users/demo/Documents/learn/pracpy/chscrapy/hencampfin/hencampfin/candidate_fin.csv')
        df_reorder = df[
            ['candidate_name', 'committe_name', 'registration_date', 'termination_date', 'location', 'office',
             'district_num', 'ytd_revenues', 'ytd_expenses', 'cash_balance', 'ins_date']]  # rearrange column here
        df_reorder.to_csv('/Users/demo/Documents/learn/pracpy/chscrapy/hencampfin/hencampfin/candidate_fin_1.csv',
                          index=False)

        connection = pymysql.connect(host='104.197.110.185',
                                     user='root',
                                     password='Enter password here',
                                     db='chtest',
                                     charset='utf8mb4',
                                     cursorclass=pymysql.cursors.DictCursor)

        csv_data = csv.reader(open('candidate_fin_1.csv'))

        cursor = connection.cursor()
        row_count = 0
        cursor.execute('truncate table chtest.campaign_fin_stg')
        for row in csv_data:
            if row_count != 0:
                # print(row)
                cursor.execute('INSERT IGNORE INTO chtest.campaign_fin_stg (candidate_name, committe_name, registration_date, termination_date, location, office, district_num, ytd_revenues, ytd_expenses, cash_balance, ins_date) VALUES (%s, %s, %s,%s, %s, %s,%s, %s, %s, %s, %s)', row)
            row_count += 1

        etl_table = ("insert into chtest.campaign_fin (id, candidate_name, committe_name, registration_date, termination_date, location, office, district_num, ytd_revenues, ytd_expenses, cash_balance, ins_date) SELECT id, candidate_name, committe_name, STR_TO_DATE(registration_date, '%m/%d/%Y') AS regis_dt, CASE WHEN STR_TO_DATE((CASE WHEN termination_date = '' THEN NULL ELSE termination_date END), '%m/%d/%Y') IS NULL THEN STR_TO_DATE('2050-12-31', '%Y-%m-%d') ELSE STR_TO_DATE(termination_date, '%m/%d/%Y') END AS term_dt, location, office, district_num, CONVERT( REPLACE(REPLACE(ytd_revenues, '$', ''), ',', '') , DECIMAL (15 , 2 )) AS ytd_rev, CONVERT( REPLACE(REPLACE(ytd_expenses, '$', ''), ',', '') , DECIMAL (15 , 2 )) AS ytd_exp, CONVERT( REPLACE(REPLACE(cash_balance, '$', ''), ',', '') , DECIMAL (15 , 2 )) AS cash_bal, STR_TO_DATE(ins_date, '%Y-%m-%d') AS ins_dt FROM chtest.campaign_fin_stg WHERE candidate_name <> '' " )
        cursor.execute('truncate table chtest.campaign_fin')
        cursor.execute(etl_table)
        connection.commit()
        connection.close()
