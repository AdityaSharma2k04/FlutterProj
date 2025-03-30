import 'dart:developer';
import 'dart:io';
import 'package:adi_chat/api/api.dart';
import '../Helper/dialog.dart';
import 'package:adi_chat/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 50), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  _handleGoogleButtonClick() async {
    try {
      Dialogs.showProgressBar(context);
      final user = await _signInWithGoogle();
      Navigator.pop(context);
      log("\nUser: ${user?.user}");
      log("\nUserAdditionalInfo: ${user?.additionalUserInfo}");

      if (await APIs.user_exists()) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      } else {
        APIs.create_user().then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
          );
        });
      }
    } catch (e) {
      log("Error signing in with Google: $e");
    }
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n Sign in with google: $e');
      Dialogs.showSnackBar(context, "Something Went Wrong");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Welcome to Adi Chat"),
        leading: Icon(Icons.arrow_back_outlined),
      ),

      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(seconds: 1, milliseconds: 50),
            top: mq.height * .15,
            width: mq.width * .5,
            right: _isAnimate ? mq.width * .25 : -mq.width * .5,
            child: Image.asset("assets/images/chat.png"),
          ),
          Positioned(
            bottom: mq.height * .2,
            width: mq.width * .9,
            left: mq.width * .05,
            height: mq.height * 0.07,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                elevation: 1,
              ),
              onPressed: () {
                _handleGoogleButtonClick();
              },
              icon: Image.asset("assets/images/google.png", height: 40),
              label: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  children: [
                    TextSpan(text: "Login with "),
                    TextSpan(
                      text: "Google",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
