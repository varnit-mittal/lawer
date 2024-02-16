"""
URL configuration for lawer project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from FileSys import views
from django.conf.urls.static import static
from django.conf import settings

urlpatterns = [
    path("admin/", admin.site.urls),
    path('folder/',views.FolderView.as_view()), #create Folder
    path('fileUpload/',views.FileUploadView.as_view()),  #upload a file in a folder
    path('file/',views.FileView.as_view()), #get all files and folders and delete also
    path('getfile/',views.GetFileView.as_view()), #get file
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
