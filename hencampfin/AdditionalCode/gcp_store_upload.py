import argparse
import datetime
import pprint


# Imports the Google Cloud client library
from google.cloud import storage
import urllib.request

# set the google credential path on local machine. this is a json file for service account that has access to gcp project
# export GOOGLE_APPLICATION_CREDENTIALS='/Users/demo/Documents/learn/gcp/credentials/campaignanalytics-3e0e4a212537.json'


# Instantiates a client
storage_client = storage.Client()

# # The name for the new bucket
# bucket_name = 'testcli'
# # Creates the new bucket
# bucket = storage_client.create_bucket(bucket_name)
# print('Bucket {} created.'.format(bucket.name))

bucket_list = storage_client.list_buckets()

bucket_attrib1 = storage_client.get_bucket('campaign_fed_fin')

print(bucket_attrib1)


#urllib.request.urlopen("http://example.com/foo/bar").read()


#
# for bucket in bucket_list:
#     print(bucket)

bucket_name = 'campaign_fed_fin'
destination_blob_name = 'file1'
source_file_name = '/Users/demo/Documents/learn/pracpy/chscrapy/fcc_data/oppexpunzip/oppexp12.txt'


def upload_blob(bucket_name, source_file_name, destination_blob_name):
    """Uploads a file to the bucket."""
    storage_client = storage.Client()
    bucket = storage_client.get_bucket(bucket_name)
    blob = bucket.blob(destination_blob_name)

    blob.upload_from_filename(source_file_name)

    print('File {} uploaded to {}.'.format(
        source_file_name,
        destination_blob_name))


upload_blob(bucket_name,source_file_name,destination_blob_name)