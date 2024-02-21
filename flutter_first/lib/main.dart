import 'package:flutter/material.dart';
import 'package:flutter_first/Pages/DashBoardPage.dart';
import 'package:flutter_first/Pages/OtpPage.dart';
import 'package:flutter_first/Pages/AccountPage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that Flutter is initialized
 // Initialize Firebase
  await dotenv.load(fileName: ".env");
  // print(dotenv.env['URL']!);
  // print("hello");
  Firebase.initializeApp( );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OpeningPage(),
    );
  }
}

class OpeningPage extends StatelessWidget {
  // TextEditingController for the mobile number TextField
  final TextEditingController _phoneNumberController = TextEditingController();
  static String verify="";
  static String baseUrl = dotenv.env['URL']!;


  // Function to send OTP to the provided phone number
  Future<void> sendOTP(BuildContext context) async {
    String phoneNumber = _phoneNumberController.text.trim();
    // Validate phone number here if needed

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto-retrieval of OTP completed (not needed in this flow)
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle verification failed
          print('Failed to send OTP: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          // Navigate to OTP page with verificationId
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => OtpPage(verificationId: verificationId)),
          // );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Timeout handling (not needed in this flow)
        },
      );
    } catch (e) {
      print('Error sending OTP: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    var phone_number="";
    return Scaffold(
      appBar: AppBar(
        title: Text('App Name'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Welcome',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 44),
              ),
              SizedBox(height: 50),
              Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'lib/assets/login.svg',
                  width: 400,
                  height: 400,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 170),
              Text(
                'Sign Up / Log In',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 38),
              ),
              SizedBox(height: 40),
              TextField(
                keyboardType: TextInputType.phone,
                onChanged: (value)
                {
                  phone_number=value;
                },
                controller: _phoneNumberController, // Assign the controller
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => OtpPage()),
                    // );
                  await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: phone_number,
                  verificationCompleted: (PhoneAuthCredential credential) {},
                  verificationFailed: (FirebaseAuthException e) {},
                  codeSent: (String verificationId, int? resendToken) {

                    OpeningPage.verify=verificationId;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OtpPage()),
                    );
                    print("Hello, world!");
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {},
                  );
                  }, // Call sendOTP method
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  child: SizedBox(
                    width: 400,
                    height: 50,
                    child: Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
