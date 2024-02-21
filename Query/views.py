import os
import requests
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import FileUploadParser, MultiPartParser 
from rest_framework import status
from django.http import FileResponse, HttpResponse, StreamingHttpResponse
import firebase_admin
from firebase_admin import credentials, storage
import json
from json import JSONEncoder
from .keywords import getKeyword,getData, LgetLaws
class QueryView(APIView): 
    def get(self,request):
        inp=request.data.get('input')
        if inp is None:
            return Response({'error': 'Please provide input.'}, status=status.HTTP_400_BAD_REQUEST)
        keywords=getKeyword(inp)
        d=set()
        for i in keywords:
            d.add(i)
        if not keywords: 
            return Response(
                {'error':"Too sensitive to be discussed on this portal. Please provide distinct headers"},
                status=status.HTTP_406_NOT_ACCEPTABLE
            )
        opt=getData(d)
        return Response(opt[:min(15,len(opt))],status=status.HTTP_200_OK)
        
        
class ListHeaderViews(APIView):
    '''if error comes in Queryview, do use this'''
    def get(self,request):
        lists=request.data.get('lists')
        print(lists)
        d=set()
        for i in lists:
            d.add(i)
        if not lists:
            return Response({'error': 'Please provide list of headers.'}, status=status.HTTP_400_BAD_REQUEST)
        opt=getData(d)
        return Response(opt[:min(15,len(opt))],status=status.HTTP_200_OK)
  
  
  
class getLaws(APIView):
    def get(self,request):
        law=request.data.get('lawName')
        law=str(law).lower()
        if not law:
            return Response({'error': 'Please provide law name.'}, status=status.HTTP_400_BAD_REQUEST)
        opt=LgetLaws(law)
        return Response(opt, status=status.HTTP_200_OK)
      
class GetDocument(APIView):
    '''get document from indian kannon'''
    def get(self,request):
        id=request.data.get('id')
        print(id)
        if not id:
            return Response({'error': 'Please provide id.'}, status=status.HTTP_400_BAD_REQUEST)
        api=os.getenv('KANNON')
        url=f"https://api.indiankanoon.org/doc/{id}/"
        headers={
            "Authorization": "Token " + api,
            "format": "json"
        }
        response = requests.post(url, headers=headers)
        res=response.json()
        a=str(JSONEncoder().encode(res['doc']))
        a=a.replace(r"\n","<br>")
        a=a.replace(r"\u","&#x")
        a=a.replace(r'\"',r'"')
        a=a.replace(r"\t",'\t')
        return Response({
            "json":res,
            "html":a},status=status.HTTP_200_OK)
