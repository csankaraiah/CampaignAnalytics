# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://doc.scrapy.org/en/latest/topics/item-pipeline.html

# Chakra March 05, 2018: Tried to change the destination file name by modifying the default
# item pipeline. Was not able to implement it successfully so far


import scrapy
from scrapy.pipelines.images import FilesPipeline
from scrapy.exceptions import DropItem


class HencampfinPipeline(FilesPipeline):
    def file_path(self, request, response=None, info=None):
        original_path = super(HencampfinPipeline, self).file_path(request, response=None, info=None)
        sha1_and_extension = original_path.split('/')[1] # delete 'full/' from the path
        return request.meta.get('filename','')[0] + "_" + sha1_and_extension

    # def get_media_requests(self, item, info):
    #     file_url = item['file_url']
    #     meta = {'filename': item['name']}
    #     yield Request(url=file_url, meta=meta)