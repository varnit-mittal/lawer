import 'package:flutter/material.dart';
import 'package:flutter_first/Pages/FolderPage.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          // Profile Picture and Username
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 80, // Increased size of the profile picture
                  backgroundColor: Colors.transparent, // Make the background transparent
                  child: SvgPicture.asset(
                    'lib/assets/User_cicrle.svg',
                    width: 160, // Adjust the width of the SVG image
                    height: 160, // Adjust the height of the SVG image
                  ),
                ),

                SizedBox(height: 10),
                Text(
                  'Aryaman Pathak',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32, // Increased font size of the username
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 70),
          // Information Fields
          InformationField(label: 'Email Address', value: 'paryaman79@gmail.com', fontSize: 20),
          SizedBox(height: 30),
          InformationField(label: 'Phone Number', value: '+917828083089', fontSize: 20),
          SizedBox(height: 30),
          InformationField(label: 'Date of Birth', value: 'January 1, 2000', fontSize: 20),
          SizedBox(height: 50),
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

class InformationField extends StatelessWidget {
  final String label;
  final String value;
  final double fontSize;

  InformationField({required this.label, required this.value, this.fontSize = 16});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18, // Keeping the label font size consistent
            ),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(fontSize: fontSize), // Using the provided font size for value
          ),
          Divider(), // Add a divider between fields
        ],
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
    home: AccountPage(),
  ));
}
