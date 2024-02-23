import 'package:flutter/material.dart';
import 'package:flutter_first/Pages/AccountPage.dart';
import 'package:flutter_first/Pages/FolderPage.dart';
import 'package:flutter_first/Pages/OptionsPage2.dart';
import 'package:flutter_first/Pages/ResultsPage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_first/main.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
  static List myl=[];
}


class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    String value1="";
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
                      onChanged: (value)
                      {
value1=value;
                      },
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
                    onPressed: () async {
                      // Handle submit button tap

                      String base = OpeningPage.baseUrl;
                      final url = OpeningPage.baseUrl + 'caseQuery/';
                      final body = jsonEncode({'input': value1});

                      final request = http.Request('GET', Uri.parse(url));
                      request.headers['Content-Type'] = 'application/json';
                      request.body = body;

                      // Send the request and get the response.
                      final response = await request.send();
                      final responseBody = await response.stream.bytesToString();

                      // Check if the response status is 406
                      if (response.statusCode == 406) {
                        // Redirect to OptionsPage2
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OptionsPage2()),
                        );
                      } else {
                        // Redirect to ResultsPage
                        List myList = jsonDecode(responseBody);
                        SearchPage.myl = myList;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ResultsPage()),
                        );
                      }
                    },

                    child: Text('Submit',style: TextStyle(
    color: Colors.white,)),

                    style: ElevatedButton.styleFrom(
                      primary: getColorFromHex("0E204E"),
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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => AccountPage()), // Assuming OpeningPage is in main.dart
                      (route) => false, // Clear all routes except for the new one
                );
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
