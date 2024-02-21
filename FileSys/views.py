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

class FolderView(APIView):
    """
    API view for creating a folder.

    This view handles the POST request to create a new folder in the file system.
    The folder name is provided in the request data.

    Returns:
        - If the folder is created successfully, returns the serialized data of the created folder with status code 201.
        - If there is an error during folder creation, returns an error message with status code 400.
        - If the request data is invalid, returns the validation errors with status code 400.
    """
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
    """
    API view for uploading files to a specific folder.

    Supports multipart/form-data requests with 'folder' and 'file' fields.

    Returns a response with the uploaded file details if successful,
    or an error response if the folder or file is missing or invalid.
    """
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
    """
    API view for managing files and folders.

    Methods:
    - get: Retrieve the list of folders and files.
    - delete: Delete a folder or file.
    """
    def get(self,request):
            """
            Retrieves the list of folders and files for a given user ID.

            Args:
                request (Request): The HTTP request object.

            Returns:
                Response: The HTTP response object containing the list of folders and files.

            Raises:
                Response: If the user is not authenticated, returns an error response with status code 401.
            """
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
    
    def delete(self, request):
        """
        Deletes a file or folder from the storage.

        Args:
            request (Request): The HTTP request object.

        Returns:
            Response: The HTTP response object.

        Raises:
            Exception: If an error occurs during the deletion process.
        """
        try:
            name = request.data.get('name')
        except:
            return Response({'error': 'User not authenticated'}, status=status.HTTP_401_UNAUTHORIZED)
        try:
            if name[-1] == '/':
                blobs = storage.bucket().list_blobs(prefix=name)
                for blob in blobs:
                    blob.delete()
                return Response({'message': 'Folder deleted successfully'}, status=status.HTTP_200_OK)
            else:
                storage.bucket().blob(name).delete()
                return Response({'message': 'File deleted successfully'}, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)
        

class GetFileView(APIView):
    """
    API view to retrieve a file from the storage bucket.

    Methods:
    - get: Retrieves the file content and returns it as a downloadable response.

    Attributes:
    - bucket: The storage bucket to retrieve the file from.
    """

    def get(self, request):
        bucket = storage.bucket()
        try:
            filename = request.data.get('filename')
            blob = bucket.blob(filename)
            file_content = blob.download_as_string()
            response = HttpResponse(file_content, content_type='application/octet-stream')
            response['Content-Disposition'] = 'attachment; filename="{}"'.format(filename)
            return response
        except FileNotFoundError:
            raise Response({'error': 'User not authenticated'}, status=status.HTTP_404_NOT_FOUND)