import 'dart:developer';
import 'package:adi_chat/pages/home.dart';
import 'package:adi_chat/pages/phonelogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Helper/dialog.dart';
import '../api/api.dart';
import '../main.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key, required this.vId});

  final String vId;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => PhoneLogin()),
            );
          },
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text("OTP Verification"),
        shadowColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            SizedBox(height: mq.height * 0.35),
            Text(
              "We have sent a 6 digit OTP to your phone \n Please Verify",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: mq.height * 0.03),
            TextFormField(
              controller: otpController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.pin),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: "Enter OTP",
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final cred = PhoneAuthProvider.credential(
                      verificationId: widget.vId,
                      smsCode: otpController.text,
                    );
                    Dialogs.showProgressBar(context);
                    await FirebaseAuth.instance.signInWithCredential(cred);
                    Navigator.pop(context);
                    log(FirebaseAuth.instance.currentUser.toString());
                    if (await APIs.user_exists()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => HomeScreen()),
                      );
                    }
                    else {
                      APIs.createPhoneUser().then((value) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => HomeScreen()),
                        );
                      });
                    }
                  } catch (e) {
                    log('\n Wrong OTP$e');
                    Navigator.pop(context);
                    Dialogs.showSnackBar(context, "Incorrect OTP");
                    return null;
                  }
                },
                child: Text(
                  "Verify",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
