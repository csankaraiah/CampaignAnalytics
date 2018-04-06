from google.cloud import bigquery



def explicit():
    # Explicitly use service account credentials by specifying the private key
    # file. All clients in google-cloud-python have this helper, see
    # https://googlecloudplatform.github.io/google-cloud-python/latest/core/auth.html#service-accounts
    bigquery_client = bigquery.Client.from_service_account_json(
        '/Users/demo/Documents/learn/gcp/credentials/campaignanalytics-d1c7eacb1c95.json')

    query_job = bigquery_client.query("""
        select precinct_name from `campaign.MN_PRECINCT_DIM`""")

    results = query_job.result()  # Waits for job to complete.

    for row in results:
        print(row)


if __name__ == '__main__':
    explicit()


import googlemaps
import json
import csv

gmaps = googlemaps.Client(key='XXXXXXXXX')

try:
    def get_zipcode(addr):
        geocode_result = gmaps.geocode(addr)
        try:
            json_result = json.loads(json.dumps(geocode_result[0]))
        except IndexError:
            json_result = [0]
            zipcode = 'null'
        try:
            zipcode = json_result["address_components"][7]["short_name"]
        except IndexError:
            zipcode = 'null'
        return zipcode
except IndexError:
    zipcode = 'null'

with open("LV_address_spit_5.csv") as f:
    addr = csv.reader(f)
    for col1 in addr:
        value = str(col1)
        zipcode = get_zipcode(value)
        print col1[0], ',', zipcode

