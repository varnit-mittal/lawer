import 'package:flutter/material.dart';
import 'package:flutter_first/Pages/FilePage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_first/main.dart';
import 'package:flutter_first/Pages/OtpPage.dart';
import 'dart:convert';
import 'global.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';

// String path = '${OtpPage.Uid}/';

class FoldersPage extends StatefulWidget {
  @override
  _FoldersPageState createState() => _FoldersPageState();
}

class _FoldersPageState extends State<FoldersPage> {
  List<String> folders = [];
  List<String> filteredFolders = [];
  TextEditingController searchController = TextEditingController();

  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _getThingsOnStartup();
  }

  void _getThingsOnStartup() async {
    // var status = await Permission.storage.request();
    // if (status.isGranted) {
    //   // Permission granted, you can now access external storage
    //   print(status);
    // } else if (status.isDenied) {
    //   // Permission denied
    // } else if (status.isPermanentlyDenied) {
    //   // Permission permanently denied, open app settings
    //   openAppSettings();
    // }
    String base=OpeningPage.baseUrl;
    final url =  OpeningPage.baseUrl+'file/';
    // print(url);


    final String uid = OtpPage.Uid;

    filePath=uid;
    // print(uid);
    // print(filePath);

    final body = jsonEncode({'uid': filePath});

    //
    // // Create the HTTP request.
    final request = http.Request('GET', Uri.parse(url));
    request.headers['Content-Type'] = 'application/json';
    request.body = body;
    //
    // // Send the request and get the response.
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    //
    // // Print the response body.
    Map<String,dynamic> rbody = jsonDecode(responseBody);
    // print(rbody["Folders"]);

    for(int i=0;i<rbody["Folders"].length;i++)
      {
        String str= rbody["Folders"][i];
        // print(str);
        String result= str.replaceFirst(filePath+'/', "");
        int count=0;
        for(int j=0;j<result.length;j++)
          {
            if(result[j]=='/')
              count+=1;
          }
        if(count==1) {
          // print(result);
          String temp = result.replaceFirst('/', "");
        folders.add(temp);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
              filteredFolders = folders
                  .where((folder) =>
                  folder.toLowerCase().contains(value.toLowerCase()))
                  .toList();
            });
          },
        )
            : Text('Folders'),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                  filteredFolders.clear();
                }
              });
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: isSearching ? filteredFolders.length : folders.length,
        itemBuilder: (context, index) {
          final folder = isSearching ? filteredFolders[index] : folders[index];

          return InkWell(
            onLongPress: () {
              // Show options for folder
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(folder),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () async{
                            setState(()  {
                              folders.remove(folder);


                            });
                            Navigator.pop(context); //
                            // Delete folder option
                            // Implement your delete logic here
                            // After deletion, you might want to refresh the UI
                            final url = OpeningPage.baseUrl+'file/';
                            final body = jsonEncode({'name': filePath+'/'+folder+'/'});
// print(filePath);
                            //
                            // // Create the HTTP request.
                            final request = http.Request('DELETE', Uri.parse(url));
                            request.headers['Content-Type'] = 'application/json';
                            request.body = body;
                            //
                            // // Send the request and get the response.
                            final response = await request.send();
                            final responseBody = await response.stream.bytesToString();
                            // Handle any other necessary updates
                            // Close the dialog
                          },
                          child: Text('Delete',
                            style: TextStyle(fontSize: 22),
                          ),
                        ),

                      ],
                    ),
                  );
                },
              );
            },
            onTap: () {
              // Handle folder tap
              // print("*********$folder");
              filePath += '/$folder';
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FilePage()),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder,
                  size: 108.0,
                  color: getColorFromHex("0E204E"),
                ), // Larger folder icon
                SizedBox(height: 8.0),
                Text(folder),
              ],
            ),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //
      //   onPressed: () {
      //     _showAddFolderDialog(context);
      //   },
      //   backgroundColor: getColorFromHex("0E204E"),
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.white,
      //     // Set the color of the "+" icon to white
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
        width: 100,
        height: 100,
        child: FloatingActionButton(
          onPressed: () {
            _showAddFolderDialog(context);
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

  void _showAddFolderDialog(BuildContext context) {
    String value = "";
    String newFolderName = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Folder'),
          content: TextField(
            onChanged: (val){
              value = val;
            },
            decoration: InputDecoration(labelText: 'Folder Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async{
                newFolderName = value;
                String base=OpeningPage.baseUrl;
                final url =  OpeningPage.baseUrl+'folder/';
                // print(url);


                final String uid = OtpPage.Uid;
                final body = jsonEncode({'name': filePath+"/"+value});
                //
                // // Create the HTTP request.
                final request = http.Request('POST', Uri.parse(url));
                request.headers['Content-Type'] = 'application/json';
                request.body = body;
                //
                // // Send the request and get the response.
                final response = await request.send();
                final responseBody = await response.stream.bytesToString();
                setState(() {
                  if (newFolderName.isNotEmpty) {
                    folders.add(newFolderName);
                  }
                });
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Color getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}

void main() {
  runApp(MaterialApp(
    home: FoldersPage(),
  ));
}
