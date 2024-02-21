import 'package:flutter_first/Pages/DashBoardPage.dart';
import 'package:flutter_first/Pages/SignUpPage.dart';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_first/main.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class OtpPage extends StatefulWidget {
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  List<TextEditingController> otpControllers =
  List.generate(6, (index) => TextEditingController());
  final FirebaseAuth auth = FirebaseAuth.instance;
  String code = "";
  int _start = 60; // Timer start value
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text('OTP ')),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: screenHeight * 0.05),
            Align(
              alignment: Alignment.topCenter,
              child: SvgPicture.asset(
                'lib/assets/otp.svg',
                width: screenWidth * 0.9,
                height: screenHeight * 0.4,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Remaining time text
                  _start == 0
                      ? TextButton(
                    onPressed: () {
                      // Reset timer and resend OTP
                      _start = 60;
                      startTimer();
                    },
                    child: Text("Resend OTP"),
                  )
                      : Text("Resend OTP in $_start seconds"),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Verification Code',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 38),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Please confirm the security code received on your mobile number.',
                      style:
                      TextStyle(fontWeight: FontWeight.w200, fontSize: 22),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Expanded(
                        child: Container(
                          height: 60,
                          margin: EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: Center(
                            child: TextField(
                              controller: otpControllers[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              decoration: InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                              ),
                              style: TextStyle(fontSize: 20),
                              onChanged: (value) {
                                print(value);
                                otpControllers[index]
                                    .text = value; // Set the text of the controller to the entered value
                                // Concatenate all the values to form the OTP
                                code = otpControllers
                                    .map((controller) => controller.text)
                                    .join();

                                if (value.length == 1 && index < 5) {
                                  FocusScope.of(context).nextFocus();
                                } else if (value.length == 1 && index == 5) {
                                  FocusScope.of(context).unfocus();
                                }
                                print(code);
                              },
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  ElevatedButton(
                    onPressed: () async {
                      print(code);
                      //print(OpeningPage.verify);
                      try {
                        await verifyOTPAndSignIn(
                            OpeningPage.verify, code); // Replace with your verification ID
                      } catch (e) {}
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: SizedBox(
                      width: 400,
                      height: 60,
                      child: Center(
                        child: Text(
                          'Confirm',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
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

  Future<void> verifyOTPAndSignIn  (
      String verificationId, String code) async {
    print(code);
    print(verificationId);
    print("hello");
    try {
      // Create PhoneAuthCredential
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );

      // Sign in with the credential
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      // Check if the user already exists
      if (userCredential.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),

        ); // Replace '/signup' with your actual route name
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OtpPage()),
        ); // Replace '/dashboard' with your actual route name
      }
    } catch (e) {
      // Handle sign-in errors
      print("Error signing in: $e");
      // Handle error accordingly, e.g., show an error message to the user
    }
  }


  bool isNumeric(String value) {
    return int.tryParse(value) != null;
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: OtpPage(),
  ));
}
