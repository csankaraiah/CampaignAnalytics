from google.cloud import storage


# credentials_dict = {
#     'type': 'service_account',
#     'client_id': os.environ['BACKUP_CLIENT_ID'],
#     'client_email': os.environ['BACKUP_CLIENT_EMAIL'],
#     'private_key_id': os.environ['BACKUP_PRIVATE_KEY_ID'],
#     'private_key': os.environ['BACKUP_PRIVATE_KEY'],
# }
# credentials = ServiceAccountCredentials.from_json_keyfile_dict(
#     credentials_dict
# )

credentials = '/Users/demo/Documents/learn/gcp/credentials/campaignanalytics-3e0e4a212537.json'

client = storage.Client(credentials=credentials, project='campaignanalytics-182101')
bucket = client.get_bucket('testcli')
blob = bucket.blob('/Users/demo/Documents/learn/pracpy/chscrapy/fcc_data/oppexpunzip/oppexp12.txt')
blob.upload_from_filename('/Users/demo/Documents/learn/pracpy/chscrapy/fcc_data/oppexpunzip/oppexp12.txt')