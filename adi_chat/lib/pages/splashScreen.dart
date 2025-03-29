import 'dart:developer';

import 'package:adi_chat/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../api/api.dart';
import '../main.dart';
import 'loginPage.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _Splashscreen();
}

class _Splashscreen extends State<Splashscreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2),(){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      if(APIs.auth.currentUser != null){
        log("\nUser: ${APIs.auth.currentUser}");
        Navigator.pushReplacement(context, MaterialPageRoute(builder:  (_) => const HomeScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder:  (_) => const LoginPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(

      body: Stack(
        children: [
          Positioned(
            top: mq.height * .15,
            width: mq.width * .5,
            right: mq.width * .25,
            child: Image.asset("assets/images/chat.png"),
          ),
          Positioned(
            bottom: mq.height * .15,
            width: mq.width,
            child: const Text("MADE IN AJMER WITH ❤️", textAlign: TextAlign.center,style: TextStyle(fontSize: 20, letterSpacing: 0.5),),
          ),
        ],
      ),
    );
  }
}
