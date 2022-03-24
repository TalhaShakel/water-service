import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Phone extends StatefulWidget {
  @override
  State<Phone> createState() => _PhoneState();
}

TextEditingController phonecon = TextEditingController();
TextEditingController otpcon = TextEditingController();

class _PhoneState extends State<Phone> {
  String verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: phonecon,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Phone Num",
                  hintText: "Enter valid number"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: otpcon,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Otp",
                  hintText: "Enter your code"),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                fetchotp();
              },
              child: Text("Fetch OTP")),
          ElevatedButton(
              onPressed: () {
                verifyotp();
              },
              child: Text("Send"))
        ],
      ),
    );
  }

  void verifyotp() {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otpcon.text.toString());
  }

  void fetchotp() async {
    try {
      FirebaseAuth auth = await FirebaseAuth.instance;
      print(phonecon.text);
      auth.verifyPhoneNumber(
        phoneNumber: phonecon.text.toString(),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print("Invalid PhoneNumber");
          }
        },
        codeSent: (String verificationId, int resendToken) async {
          this.verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
