from firebase_admin import credentials,storage
import firebase_admin


class StorageBucket:
    def __init__(self):
      self.bucket_name="art-therapy-d7fb6.appspot.com"
      self.cred_name="backend/service_account"
      cred=credentials.Certificate(self.cred_name)
      firebase_admin.initialize_app(cred,{"storageBucket":self.bucket_name})
      
    def uploadfile(self,firebase_filename,localpath):
       bucket=storage.bucket()
       blob=bucket.blob(firebase_filename)
       blob.upload_from_filename(localpath)
       blob.make_public()
       return blob.public_url
       





