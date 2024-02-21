import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

class FilePage extends StatefulWidget {
  @override
  _FilePageState createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  List<String> files = ["File 1", "File 2", "File 3", "File 4"];
  List<String> filteredFiles = [];
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

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
              filteredFiles = files
                  .where((file) =>
                  file.toLowerCase().contains(value.toLowerCase()))
                  .toList();
            });
          },
        )
            : Text('Files'),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                  filteredFiles.clear();
                }
              });
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: isSearching ? filteredFiles.length : files.length,
        itemBuilder: (context, index) {
          final file =
          isSearching ? filteredFiles[index] : files[index];
          return InkWell(
            onTap: () {
              // Handle file tap
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.file_copy, size: 48.0), // Larger file icon
                SizedBox(height: 8.0),
                Text(file),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddOptionDialog(context);
        },
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          color: Colors.white,
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
              onPressed: () {
                String folderName = folderNameController.text;
                if (folderName.isNotEmpty) {
                  setState(() {
                    files.add(folderName);
                  });
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
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) return;

    List<PlatformFile> pickedFiles = result.files;

    for (PlatformFile pickedFile in pickedFiles) {
      // Your upload logic for each file
      File file = File(pickedFile.path!);
      // Prepare the request
      // For example:
      // var request = http.MultipartRequest('POST', Uri.parse('your_upload_endpoint'));
      // request.files.add(await http.MultipartFile.fromPath('file', file.path));
      // await request.send();
    }

    // You may want to handle the result after uploading files
  }
}

void main() {
  runApp(MaterialApp(
    home: FilePage(),
  ));
}
