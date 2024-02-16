from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import FileUploadParser, MultiPartParser 
from rest_framework import status
import firebase_admin
from .models import Folder
from firebase_admin import credentials, storage
from .serializers import FolderSerializer, FileSerializer

cred = credentials.Certificate("./firebase-sdk.json")
firebase_app = firebase_admin.initialize_app(cred, {
    'storageBucket': 'calcium-backup-411020.appspot.com'
})


class FolderView(APIView):
    def post(self, request):
        serializer = FolderSerializer(data=request.data)
        if serializer.is_valid():
            folder_name = serializer.validated_data['name']
            try:
                storage.bucket().blob(folder_name + '/').upload_from_string('', content_type='text/plain')  # Creates an empty file to represent the folder
                serializer.save() 
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            except Exception as e:
                return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class FileUploadView(APIView):
    parser_classes = [MultiPartParser, FileUploadParser]

    def post(self, request):
        folder_name = request.data.get('folder')
        file_obj = request.data['file']
        print(file_obj)

        try:
            folder = Folder.objects.get(name=folder_name)
        except Folder.DoesNotExist:
            return Response({'folder': 'Folder does not exist.'}, status=status.HTTP_400_BAD_REQUEST)

        blob = storage.bucket().blob(f'{folder_name}/{file_obj.name}')
        blob.upload_from_file(file_obj)
        serializer = FileSerializer(data={'name': file_obj.name, 'folder': folder.pk, 'file':file_obj})

        if serializer.is_valid():
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_409_CONFLICT)
