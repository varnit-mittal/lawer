import 'package:awesome_notifications/awesome_notifications.dart';
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
import 'package:intl_phone_number_input/intl_phone_number_input.dart'; // Import intl_phone_number_input package


void main() async {
  AwesomeNotifications().initialize(null,
  [  NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic notifications',
    channelDescription:'Basic',
    ),
  ],
    debug: true
  );
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that Flutter is initialized
  await dotenv.load(fileName: ".env");
  Firebase.initializeApp();
  runApp(MyApp());
}




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed)
    {
      if(!isAllowed)
        {
          AwesomeNotifications().requestPermissionToSendNotifications();

        }

    });
    return MaterialApp(
      home: OpeningPage(),
    );
  }
}

class OpeningPage extends StatelessWidget {

  // TextEditingController for the mobile number TextField
  final TextEditingController _phoneNumberController = TextEditingController();
  static String verify = "";
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
    var phone_number = "";
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Lawer',
          style: TextStyle(fontSize: 38, color: Colors.black, fontWeight:FontWeight.bold ),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

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
              SizedBox(height: 140),
              Text(
                'Sign Up / Log In',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 38),
              ),
              SizedBox(height: 40),
              // Replace TextField with InternationalPhoneNumberInput
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  phone_number = number.phoneNumber!;

                },
                inputDecoration: InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(),
                ),
                initialValue: PhoneNumber(isoCode: 'IN'),
              ),
              SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: phone_number,
                      verificationCompleted: (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {},
                      codeSent: (String verificationId, int? resendToken) {
                        OpeningPage.verify = verificationId;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OtpPage()),
                        );
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );
                  }, // Call sendOTP method
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
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
