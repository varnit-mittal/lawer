import os
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import FileUploadParser, MultiPartParser 
from rest_framework import status
from django.http import FileResponse, HttpResponse, StreamingHttpResponse
import firebase_admin
import json
from firebase_admin import credentials, storage

cred = credentials.Certificate(json.loads(os.getenv("FIREBASE_SDK")))
firebase_app = firebase_admin.initialize_app(cred, {
    'storageBucket': 'calcium-backup-411020.appspot.com'
})