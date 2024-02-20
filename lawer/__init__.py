import json
import firebase_admin
from firebase_admin import credentials
import os
try:
    cred = credentials.Certificate(json.loads(os.getenv("FIREBASE_SDK")))
except:
    cred=credentials.Certificate("./a.json")
firebase_app = firebase_admin.initialize_app(cred, {
    'storageBucket': 'calcium-backup-411020.appspot.com'
})