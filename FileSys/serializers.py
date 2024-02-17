from rest_framework import serializers
from .models import Folder, File

class FolderSerializer(serializers.ModelSerializer):
    class Meta:
        model = Folder
        fields = '__all__'

class FileSerializer(serializers.ModelSerializer):
    file = serializers.FileField()
    name = serializers.CharField()
    
    class Meta:
        model = File
        fields = '__all__'
        
