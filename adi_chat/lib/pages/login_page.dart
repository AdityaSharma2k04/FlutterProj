import 'dart:developer';
import 'dart:io';
import 'package:ChataKai/api/api.dart';
import 'package:ChataKai/pages/phone_login.dart';
import 'package:flutter/services.dart';
import '../Helper/dialog.dart';
import 'package:ChataKai/pages/home.dart';
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
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
        );
      } else {
        APIs.create_user().then((value) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false,
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Welcome to ChataKai"),
        leading: IconButton(icon: Icon(Icons.arrow_back_outlined), onPressed: (){
          SystemNavigator.pop();
        },),
      ),

      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(seconds: 1, milliseconds: 50),
            top: mq.height * .15,
            width: mq.width * .5,
            right: _isAnimate ? mq.width * .25 : -mq.width * .5,
            child: Image.asset("assets/images/chatakai_notext.png"),
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
          Positioned(
            bottom: mq.height * .1,
            width: mq.width * .9,
            left: mq.width * .05,
            height: mq.height * 0.07,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                elevation: 1,
              ),
              onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => PhoneLogin()));
              },
              icon: Icon(Icons.phone, size: 40,),
              label: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  children: [
                    TextSpan(text: "Login with "),
                    TextSpan(
                      text: "Phone Number",
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
