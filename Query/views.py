import os
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import FileUploadParser, MultiPartParser 
from rest_framework import status
from django.http import FileResponse, HttpResponse, StreamingHttpResponse
import firebase_admin
from firebase_admin import credentials, storage
import json
from .keywords import getKeyword
cred = credentials.Certificate(json.loads(os.getenv("FIREBASE_SDK")))
firebase_app = firebase_admin.initialize_app(cred, {
    'storageBucket': 'calcium-backup-411020.appspot.com'
})

class QueryView(APIView):
    def get(self,request):
        inp=request.data.get('input')
        if inp is None:
            return Response({'error': 'Please provide input.'}, status=status.HTTP_400_BAD_REQUEST)
        keywords=getKeyword(inp)
        d={}
        for i in keywords:
            d[i]=1
        if not keywords: 
            return Response(
                {'error':"Too sensitive to be discussed on this portal. Please provide distinct headers"},
                status=status.HTTP_406_NOT_ACCEPTABLE
            )
        with open("unidata.json","r") as f:
            data=json.load(f)
            output=[]
            for i in data:
                wt=0
                for j in i['keyword']:
                    if j in d:
                        wt+=1
                if wt>0:
                    output.append([i,wt])
            output.sort(key=lambda x:x[1],reverse=True)
            opt=[]
            for i in output:
                opt.append(data[i[0]])
            return Response(opt[:max(15,len(opt))],status=status.HTTP_200_OK)
        
        
