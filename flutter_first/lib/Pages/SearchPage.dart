import 'package:flutter/material.dart';
import 'package:flutter_first/Pages/FolderPage.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Case'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // SVG at the top with text overlay
          Stack(
            children: [
              Container(
                width: screenWidth,
                height: screenHeight * 0.2, // Smaller size
                child: SvgPicture.asset(
                  'lib/assets/top.svg',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 40,
                left: 20,
                child: Text(
                  'INPUT YOUR CASE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          // Input box and submit button
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Input box
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: 'Input your case...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40), // Adding some space between input box and button
                // Submit button
    // ButtonTheme(
    // minWidth: 10.0,
    // height: 100.0,
    // child: ElevatedButton(
    // onPressed: () {},
    // child: Text("Submit"),
    // ),),
                SizedBox(
                  height:70, //height of button
                  width:170, //width of button
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle submit button tap
                    },
                    child: Text('Submit',style: TextStyle(
    color: Colors.white,)),

                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),


                      ),
                    ),
                  ),
                ),

              ],

            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: getColorFromHex("0E204E"),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: SvgPicture.asset(
                'lib/assets/Search.svg',
                width: 40,
                height: 40,
              ),
              onPressed: () {
                // Handle search button tap
              },
            ),
            IconButton(
              icon: SvgPicture.asset(
                'lib/assets/Folder_file.svg',
                width: 40,
                height: 40,
              ),
              onPressed: () {
                // Handle legal files button tap
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoldersPage()),
                );
              },
            ),
            IconButton(
              icon: SvgPicture.asset(
                'lib/assets/User_circle.svg',
                width: 40,
                height: 40,
              ),
              onPressed: () {
                // Handle profile button tap
              },
            ),
          ],
        ),
      ),
    );
  }
}

Color getColorFromHex(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}

void main() {
  runApp(MaterialApp(
    home: SearchPage(),
  ));
}
