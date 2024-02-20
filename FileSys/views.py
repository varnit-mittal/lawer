import os
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import FileUploadParser, MultiPartParser 
from rest_framework import status
from django.http import FileResponse, HttpResponse, StreamingHttpResponse
import firebase_admin
import json
from .models import Folder
from firebase_admin import credentials, storage
from .serializers import FolderSerializer, FileSerializer

# cred = credentials.Certificate(json.loads(os.getenv("FIREBASE_SDK")))
# firebase_app = firebase_admin.initialize_app(cred, {
#     'storageBucket': 'calcium-backup-411020.appspot.com'
# })
print(os.getenv("FIREBASE_SDK"))
# exit()
class FolderView(APIView):
    def post(self, request):
        serializer = FolderSerializer(data=request.data)
        if serializer.is_valid():
            folder_name = serializer.validated_data['name']
            try:
                storage.bucket().blob(folder_name + '/').upload_from_string('', content_type='text/plain')  # Creates an empty file to represent the folder
                # serializer.save() 
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            except Exception as e:
                return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class FileUploadView(APIView):
    parser_classes = [MultiPartParser, FileUploadParser]

    def post(self, request):
        folder_name = request.data.get('folder')
        file_obj = request.data.get('file')
        # print(file_obj)

        if(folder_name is None or file_obj is None):
            return Response({'error': 'Please provide both folder and file.'}, status=status.HTTP_400_BAD_REQUEST)
        try:
            folder = Folder.objects.get_or_create(name=folder_name)            
        except Folder.DoesNotExist:
            return Response({'folder': 'Folder does not exist.'}, status=status.HTTP_400_BAD_REQUEST)

        blob = storage.bucket().blob(f'{folder_name}/{file_obj.name}')
        blob.upload_from_file(file_obj)
        serializer = FileSerializer(data={'name': file_obj.name, 'folder': folder[0].pk, 'file':file_obj})
        if serializer.is_valid():
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_409_CONFLICT)

class FileView(APIView):
    def get(self,request):
        try:
            uid= request.data.get('uid')+'/'
        except:
            return Response({'error': 'User not authenticated'}, status=status.HTTP_401_UNAUTHORIZED)

        bucket = storage.bucket()
        
        result=bucket.list_blobs(prefix=uid)
        Folder=[]
        Files=[]
        for blob in result:
            if blob.name[-1]=='/':
                Folder.append(blob.name)
            else:
                Files.append(blob.name)
        return Response({
            'Folders':Folder,
            'Files':Files
        }, status=status.HTTP_200_OK)
    
    def delete(self,request):
        try:
            name= request.data.get('name')
        except:
            return Response({'error': 'User not authenticated'}, status=status.HTTP_401_UNAUTHORIZED)
        try:
            if(name[-1]=='/'):
                blobs=storage.bucket().list_blobs(prefix=name)
                for blob in blobs:
                    blob.delete()
                return Response({'message': 'Folder deleted successfully'}, status=status.HTTP_200_OK)
            else:
                storage.bucket().blob(name).delete()
                return Response({'message': 'File deleted successfully'}, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)
        

class GetFileView(APIView):
    def get(self, request):
        bucket = storage.bucket()
        try:
            filename = request.GET.get('filename')
            blob = bucket.blob(filename)
            file_content = blob.download_as_string()
            response = HttpResponse(file_content, content_type='application/octet-stream')
            response['Content-Disposition'] = 'attachment; filename="{}"'.format(filename)
            return response
        except FileNotFoundError:
            raise Response({'error': 'User not authenticated'}, status=status.HTTP_404_NOT_FOUND)