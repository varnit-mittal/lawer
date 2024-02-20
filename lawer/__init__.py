import json
import firebase_admin
from firebase_admin import credentials
import os

cred = credentials.Certificate(json.loads(os.getenv("FIREBASE_SDK")))
firebase_app = firebase_admin.initialize_app(cred, {
    'storageBucket': 'calcium-backup-411020.appspot.com'
})