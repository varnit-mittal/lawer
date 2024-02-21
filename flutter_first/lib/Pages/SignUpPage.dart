import 'package:flutter/material.dart';
import 'package:flutter_first/Pages/DashBoardPage.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  DateTime? _selectedDate = DateTime.now();
  String username = "";
  String email = "";

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null)
      setState(() {
        _selectedDate = picked;
      });
  }

  String getFormattedDOB() {
    if (_selectedDate != null) {
      return DateFormat('yyyy-MM-dd').format(_selectedDate!);
    }
    return ''; // Return empty string if no date is selected
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SvgPicture.asset(
                'lib/assets/signup.svg',
                width: screenWidth * 0.9,
                height: screenHeight * 0.4,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Sign Up',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 44),
            ),
            SizedBox(height: screenHeight * 0.05),
            TextField(
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            TextField(
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Date of Birth:',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    _selectedDate != null
                        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                        : 'Select Date',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.04),
            ElevatedButton(
              onPressed: () {
                String dob = getFormattedDOB();
                addUserToDatabase(username, email, dob);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              child: Text(
                'Submit',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void addUserToDatabase(String username, String email, String dob) async {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    DatabaseReference userDataRef =
    FirebaseDatabase.instance.ref().child('users');
    userDataRef.child(user.uid).set({
      'username': username,
      'email': email,
      'dob': dob,
      'uid': user.uid,
    });
  }
}
