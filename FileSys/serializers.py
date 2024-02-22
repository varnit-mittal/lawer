from rest_framework import serializers
from .models import Folder, File

class FolderSerializer(serializers.ModelSerializer):
    class Meta:
        model = Folder
        fields = '__all__'

class FileSerializer(serializers.ModelSerializer):
    file = serializers.FileField()
    name = serializers.CharField()
    
    def get_url(self, obj):
        return obj.get('download_url', None)
    
    class Meta:
        model = File
        fields = '__all__'
        
