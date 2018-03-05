# -*- coding: utf-8 -*-

# Chakra March 05 2018: This code pulls data from federal election commission and loads the file to local machine
# Check the settings and items file to update the path where the file gets stored.

from scrapy import Spider
from selenium import webdriver
from scrapy.selector import Selector
import time
from scrapy.loader import ItemLoader
from hencampfin.items import HencampfinItem




class FedcampfinSpider(Spider):
    name = 'fedcampfin'
    allowed_domains = ['classic.fec.gov']
    start_urls = ['http://classic.fec.gov/finance/disclosure/ftpdet.shtml#a2017_2018/']

    def parse(self, response):
        self.driver = webdriver.Chrome('/Users/demo/Documents/learn/pracpy/chscrapy/selenium_sample/chromedriver')
        self.driver.get('http://classic.fec.gov/finance/disclosure/ftpdet.shtml#a2017_2018/')
        time.sleep(5)
        self.driver.find_element_by_xpath('//*[@id="archive_link"]').click()
        sel = Selector(text=self.driver.page_source)
        l = ItemLoader(item=HencampfinItem(), response=response)

        # This section needs to be modified to pick files on particular topic
        # Once the file is downloaded, there is a separate python code that unzips the file
        file_urls = sel.xpath('//tbody/tr/td/a[contains(@href,"oppexp")]/@href').extract()

        l.add_value('file_urls', file_urls)

        return l.load_item()