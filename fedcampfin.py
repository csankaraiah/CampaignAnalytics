##### Code for getting campaign finance data 

cd /Users/demo/Documents/learn/pracpy/chscrapy/campaignfin/hencampfin

scrapy genspider fedcampfin 'classic.fec.gov/finance/disclosure/ftpdet.shtml#a2017_2018'


## Xpath for clicking on archive
//*[@id="archive_link"]


//*[@id="foia_files"]/div[1]/div/table/tbody/tr[2]/td[2]

//*[@id="foia_files"]/div[3]/div/table/tbody/tr[2]/td[2]

//*[@id="foia_files"]/div[2]/div/table/tbody/tr[5]/td[2]




## Scrapy shell 

from selenium import webdriver

driver.get(url)

driver = webdriver.Chrome('/Users/demo/Documents/learn/pracpy/chscrapy/selenium_sample/chromedriver')

driver.get('http://classic.fec.gov/finance/disclosure/ftpdet.shtml#a2017_2018/')

driver.find_element_by_xpath('//*[@id="archive_link"]').click()


from scrapy.selector import Selector

sel = Selector(text=driver.page_source)

sel.xpath('//tbody/tr')

sel.xpath('//tbody/tr/td/a[contains(@href,"zip")]').extract()

fileurl = sel.xpath('//tbody/tr/td/a[contains(@href,"zip")]').extract()



a[contains(@href,"zip")]





for url in fileurl:
	candid_url = url.xpath('.//@href').extract_first()
	print(candid_url)


sel.xpath('//tbody/tr/td/a[contains(text(),'zip')]/@href').extract()




https://cg-519a459a-0ea3-42c2-b7bc-fa1143481f74.s3-us-gov-west-1.amazonaws.com/bulk-downloads/2018/cm18.zip


https://cg-519a459a-0ea3-42c2-b7bc-fa1143481f74.s3-us-gov-west-1.amazonaws.com/bulk-downloads/2018/cm18.zip





######### Google cloud storage upload

gs://campaign_fed_fin/CMTE_MST/cmunzip/*


gs://campaign_fed_fin/CMTE_MST/cnunzip/*

gs://campaign_fed_fin/CAND_CMT_LINK/cclunzip/*


gs://campaign_fed_fin/CONTRIB_TO_CMTE_FR_CMTE/othunzip/*


gs://campaign_fed_fin/CONTRIB_TO_CAND_FR_CMTE/*

gs://campaign_fed_fin/CMTE_OPS_EXP/oppexpunzip/*


gs://campaign_fed_fin/CONTRIB_TO_CAND_FR_INDV/indivunzip/*

