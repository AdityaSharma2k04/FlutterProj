import 'dart:developer';

import 'package:ChataKai/pages/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Helper/dialog.dart';
import '../main.dart';
import 'otppage.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({super.key});

  @override
  State<PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  final phoneController = TextEditingController();

  void initState() {
    super.initState();
    phoneController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, result) {
          if (!didPop) {
            FocusScope.of(context).unfocus();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginPage()),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              },
              icon: Icon(Icons.arrow_back, color: Colors.black),
            ),
            title: Text("Login Using Phone Number"),
            shadowColor: Colors.black,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                SizedBox(height: mq.height * 0.35),
                Text("Phone Authentication", style: TextStyle(fontSize: 25),),
                SizedBox(height: mq.height * 0.03),
                TextFormField(
                  autofocus: true,
                  controller: phoneController,
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),

                    label: Text("Enter Your Phone Number"),
                    prefixIcon: Icon(Icons.phone),
                    hintText: "1234567890",
                    prefixText: "+91 ",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(onPressed: () async{
                    FirebaseAuth.instance.verifyPhoneNumber(phoneNumber: "+91 " + phoneController.text, verificationCompleted: (PhoneAuthCredential) {}, verificationFailed: (error){
                      log(error.toString());
                      Dialogs.showSnackBar(context, "Incorrect Phone Number");
                    }, codeSent: (verificationId, forceResendToken) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OtpPage(vId: verificationId,)));
                    }, codeAutoRetrievalTimeout: (verificationId) {
                      log("Auto Retrieval Timeout");
                    });
                  }, child: Text("Get Otp", style: TextStyle(color: Colors.black),),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
