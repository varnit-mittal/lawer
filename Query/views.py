import os
import requests
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from json import JSONEncoder
from .keywords import getKeyword,getData, LgetLaws
class QueryView(APIView): 
    def get(self,request):
        """
        Handle GET request for querying precedent based on the input case.

        Parameters:
        - request: The HTTP request object.
        - body: The body of the request with "input" set to the required input query

        Returns:
        - Response: The HTTP response object with the relevant precedent 
        """
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
    '''
    If you get error in QueryView, then call this endpoint with the list of headers (like ['murder','homicide']) 
    Parameters:
        - request: The HTTP request object.
        - body: The body of the request with "lists" set to the list of headers
    
    Returns:
        - Response: The response object with the list of relevant precedent
    '''
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
    '''
    Handles GET requests for querying laws based on a list of headers 
    Parameters:
        - request: The HTTP request object.
        - body: The body of the request with "lawName" set to the list of headers
    
    Returns:
        - Response: The response object with the list of relevant laws
    '''
    def get(self,request):
        law=request.data.get('lawName')
        law=str(law).lower()
        if not law:
            return Response({'error': 'Please provide law name.'}, status=status.HTTP_400_BAD_REQUEST)
        opt=LgetLaws(law)
        return Response(opt, status=status.HTTP_200_OK)
      
class GetDocument(APIView):
    '''Gets the document based on the id of the document from Indian Kanoon API
    Parameters:
        - request: The HTTP request object.
        - body: The body of the request with "id" set to the id of the document
    
    Returns:
        - Response: The response object with the "json" as json and "html" as html representation of the document
    
    '''
    
    def get(self,request):
        id=request.data.get('id')
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
        return Response({
            "json":res,
            "html":a},status=status.HTTP_200_OK)
