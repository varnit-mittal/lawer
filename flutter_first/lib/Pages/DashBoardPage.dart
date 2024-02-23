import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_first/Pages/AccountPage.dart';
import 'package:flutter_first/Pages/FolderPage.dart';
import 'package:flutter_first/Pages/OptionPage.dart';
import 'package:flutter_first/Pages/SearchPage.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final PageController _pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    // Automatic page transition
    _startPageTransition();
  }

  void _startPageTransition() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (_pageController.page == 2) {
        _pageController.animateToPage(
          0,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      } else {
        _pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; // Prevent back button from popping the route
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                // Add your notification functionality here
              },
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.transparent,
                          child: SvgPicture.asset(
                            'lib/assets/User_cicrle.svg',
                            width: 90,
                            height: 90,
                          ),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, Aryaman',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 44.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'YourFontFamily',
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 50.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 210,
                          height: 210,
                          child: buildButton(
                              context, 'lib/assets/Search.svg', 'Search', () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchPage()),
                            );
                          }),
                        ),
                        Container(
                          width: 210,
                          height: 210,
                          child: buildButton(
                              context, 'lib/assets/Folder_file.svg',
                              'Legal Files', () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FoldersPage()),
                            );
                          }),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 210,
                          height: 210,
                          child: buildButton(
                              context, 'lib/assets/Justice.svg', 'Laws', () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OptionsPage()),
                            );
                          }),
                        ),
                        Container(
                          width: 210,
                          height: 210,
                          child: buildButton(
                              context, 'lib/assets/User_circle.svg',
                              'Profile', () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AccountPage()),
                            );
                          }),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.0),
                    Container(
                      height: 150,
                      child: PageView(
                        controller: _pageController,
                        scrollDirection: Axis.horizontal,
                        children: [
                          buildStatsContainer(
                              getColorFromHex("0E204E"), Icons.assignment, 'Cases: 1M +'),
                          buildStatsContainer(
                              getColorFromHex("0E204E"), Icons.gavel, 'Laws: 100k +'),
                          buildStatsContainer(getColorFromHex("0E204E"), Icons.security,
                              'Cases Solved: 6 '),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: getColorFromHex("0E204E"),
              padding: EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lawer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 44.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String iconPath, String label,
      Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: getColorFromHex("0E204E"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              iconPath,
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatsContainer(Color color, IconData icon, String text) {
    return Center(
      child: Container(
        width: 450,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
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
    home: DashboardPage(),
  ));
}
