import 'package:flutter/material.dart';
import 'package:flutter_first/Pages/FilePage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoldersPage extends StatefulWidget {
  @override
  _FoldersPageState createState() => _FoldersPageState();
}

class _FoldersPageState extends State<FoldersPage> {
  List<String> folders = ["Folder 1", "Folder 2", "Folder 3", "Folder 4"];
  List<String> filteredFolders = [];
  TextEditingController searchController = TextEditingController();

  bool isSearching = false;

  @override
  void initState() {
    _getThingsOnStartup();
    super.initState();
  }

  void _getThingsOnStartup() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      // Permission granted, you can now access external storage
      print(status);
    } else if (status.isDenied) {
      // Permission denied
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, open app settings
      openAppSettings();
    }
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
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: isSearching ? filteredFolders.length : folders.length,
        itemBuilder: (context, index) {
          final folder = isSearching ? filteredFolders[index] : folders[index];
          return InkWell(
            onTap: () {
              // Handle folder tap
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
                  size: 48.0,
                  color: getColorFromHex("0E204E"),
                ), // Larger folder icon
                SizedBox(height: 8.0),
                Text(folder),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddFolderDialog(context);
        },
        backgroundColor: getColorFromHex("0E204E"),
        child: Icon(
          Icons.add,
          color: Colors.white, // Set the color of the "+" icon to white
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showAddFolderDialog(BuildContext context) {
    String newFolderName = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Folder'),
          content: TextField(
            onChanged: (value) {
              newFolderName = value;
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
              onPressed: () {
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
