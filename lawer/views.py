from django.shortcuts import render
import firebase_admin
from firebase_admin import credentials
from rest_framework.decorators import api_view
from rest_framework.response import Response

def upload(request,username):
    user=username
    if(request.POST or request.FILES):
        