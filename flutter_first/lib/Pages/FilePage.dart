import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_first/Pages/OtpPage.dart';
import 'dart:io';
// import 'package:downloads'
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'global.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_first/main.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

class FilePage extends StatefulWidget {
  @override
  _FilePageState createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  List<String> files = [];
  List<String> Folders = [];
  List<String> filtereditems = [];
  List<String> items = [];

  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _getThingsOnStartup(0);
  }

  void _getThingsOnStartup( int reload) async {
    if (reload==1)
      {
        files.clear();
        Folders.clear();
        items.clear();
      }
    final body = jsonEncode({'uid': filePath});
    final url = OpeningPage.baseUrl + 'file/';
    print(filePath);

    final request = http.Request('GET', Uri.parse(url));
    request.headers['Content-Type'] = 'application/json';
    request.body = body;

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    Map<String, dynamic> rbody = jsonDecode(responseBody);
    print(rbody["Folders"]);
    print(rbody["Files"]);
    for(int i=0;i<rbody["Files"].length;i++)
    {
      String str= rbody["Files"][i];
      String result= str.replaceFirst(filePath+'/', "");
      int count=0;
      for(int j=0;j<result.length;j++)
      {
        if(result[j]=='/')
          count+=1;
      }
      if(count==0) {
        String temp = result;
        files.add(temp);
      }
    }

    for(int i=0;i<rbody["Folders"].length;i++)
    {
      String str= rbody["Folders"][i];
      String result= str.replaceFirst(filePath+'/', "");
      int count=0;
      for(int j=0;j<result.length;j++)
      {
        if(result[j]=='/')
          count+=1;
      }
      if(count==1) {
        String temp = result.replaceFirst('/', "");
        Folders.add(temp);
      }
    }
    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    List<String> items = [...files, ...Folders];
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              filtereditems = files
                  .where((file) => file
                  .toLowerCase()
                  .contains(value.toLowerCase()))
                  .toList();
            });
          },
        )
            : Text(
          'Files',
          style: TextStyle(fontSize: 32),
        ),
        leading: GestureDetector(
          onTap: () async {
            // Handle tap on the back button
            print("hello");
            List<String> myList = filePath.split("/");
            myList.removeLast();
            filePath = myList.join("/");
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, size: 40),
        ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search, size: 42),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                  filtereditems.clear();
                }
              });
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          // Handle tapping anywhere on the body
          print('Tapped on the body');
        },
        child: items.isEmpty
            ? Center(
          child: Text(
            "No files and folders found",
            style: TextStyle(fontSize: 18),
          ),
        )
            : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: isSearching ? filtereditems.length : items.length,
          itemBuilder: (context, index) {
            final itemName =
            isSearching ? filtereditems[index] : items[index];
            final isFolder = Folders.contains(itemName);
            return InkWell(
              onLongPress: () {
                // Show options for folder
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(itemName),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () async {

                              int flag = 0;
                              String temp = "";
                              for (int i = 0; i < itemName.length; i++) {
                                if (itemName[i] == '.') {
                                  flag = 1;
                                  break;
                                }
                              }

                              if (flag != 1) {
                                temp += itemName + '/';
                              } else {
                                temp = itemName;
                              }

                              setState(() {
                                items.remove(itemName);
                                files.remove(itemName);
                                Folders.remove(itemName);
                              });
                              Navigator.pop(context); //
                              final url =
                                  OpeningPage.baseUrl + 'file/';
                              final body = jsonEncode({
                                'name': filePath + '/' + temp
                              });

                              final request = http.Request(
                                  'DELETE', Uri.parse(url));
                              request.headers['Content-Type'] =
                              'application/json';
                              request.body = body;

                              final response = await request.send();
                              final responseBody = await response.stream
                                  .bytesToString();

                            },
                            child: Text(
                              'Delete',
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              onTap: () async {
                if (isFolder) {
                  // Handle itemName tap
                  // print("*********$itemName");
                  filePath += '/$itemName';
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FilePage()),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(itemName),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [


                            ListTile(
                              title: Text('Download'),
                              onTap: () async {
                                var status = await Permission.storage.status;
                                if (!status.isGranted) {
                                  print("hello");
                                  await Permission.storage.request();
                                }
                                AwesomeNotifications().createNotification(content: NotificationContent(id: 10, channelKey: 'basic_channel',
                                  title: 'FILE IS DOWNLOADED',
                                  body: "Aryaman",
                                ),);
                                final url2 = OpeningPage.baseUrl +
                                    'getfile/?filename=' +
                                    filePath +
                                    '/' +
                                    itemName;
                                var dio = Dio();
                                var path = '/storage/emulated/0/Download/';
                                var dir = Directory(path);
                                var response = await dio.download(
                                    url2, '${dir.path}/$itemName');


                                Navigator.pop(context);
                                _showAlertDialog(context);
                                // Call function to handle file download

                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isFolder ? Icons.folder : Icons.file_copy,
                    size: isFolder ? 98.0 : 98.0,
                    color: isFolder
                        ? getColorFromHex("0E204E")
                        : null,
                  ), // Larger folder or file icon
                  SizedBox(height: 8.0),
                  Text(itemName),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: SizedBox(
        width: 100,
        height: 100,
        child: FloatingActionButton(
          onPressed: () {
            _showAddOptionDialog(context);
            // Do something with the selected options, for example:
          },
          backgroundColor: getColorFromHex("0E204E"),
          splashColor: Colors.lightBlue,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 56,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }


  void _showAddOptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Folder'),
                onTap: () {
                  Navigator.pop(context);
                  _showAddFolderDialog(context);
                },
              ),
              ListTile(
                title: Text('Upload'),
                onTap: () async {
                  Navigator.pop(context);
                  await _uploadFile();

                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddFolderDialog(BuildContext context) {
    TextEditingController folderNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Folder'),
          content: TextField(
            controller: folderNameController,
            decoration: InputDecoration(
              hintText: 'Enter folder name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async{
                String folderName = folderNameController.text;
                if (folderName.isNotEmpty) {
                  setState(() {
                    Folders.add(folderName);
                  });


                  final baseUrl = OpeningPage.baseUrl;
                  final url3 = baseUrl + 'folder/';

                  final body = jsonEncode({'name': filePath+'/'+folderName});
                  var request = http.Request('POST', Uri.parse(url3));
                  request.headers['Content-Type'] = 'application/json';
                  request.body = body;

                  var response = await request.send();
                  var responseBody = await response.stream.bytesToString();
                  print(responseBody);
                    // print(files);

                }
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
      allowedExtensions: null,
    );



    if (result != null) {
      print(result);
      print(result.runtimeType);
      List<PlatformFile> pickedFiles = result.files;
      print(pickedFiles[0].runtimeType);

      final url2= OpeningPage.baseUrl+'fileUpload/';
      for (PlatformFile pickedFile in pickedFiles) {
        // File file = File(pickedFile.path!);
        var multipartFile = await http.MultipartFile.fromPath('file', pickedFile.path!, filename: pickedFile.name);
        // print(multipartFile.runtimeType);
        // Your upload logic for each file
        print(multipartFile.runtimeType);
        // var body = jsonEncode({'folder': filePath, 'file':multipartFile});
        var request = http.MultipartRequest('POST', Uri.parse(url2));
        request.headers['Content-Type'] = 'application/json';
        request.fields['folder']=filePath;
        request.files.add(multipartFile);
        var response = await request.send();
        var responseBody = await response.stream.bytesToString();
        print(responseBody);


      }
      _getThingsOnStartup(1);
    }



    // You may want to handle the result after uploading files
  }
}

Color getColorFromHex(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}
void _showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Alert'),
        content: Text('File  has been downloaded in your Download folder.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
void _showAlertDialog2(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Alert'),
        content: Text('File  has been deleted.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
void main() {
  runApp(MaterialApp(
    home: FilePage(),
  ));
}
