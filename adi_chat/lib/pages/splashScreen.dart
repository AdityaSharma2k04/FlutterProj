import 'dart:developer';

import 'package:ChataKai/pages/home.dart';
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
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(systemNavigationBarColor: Colors.white));
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
            child: Column(
              children: [
                Image.asset("assets/images/chatakai_notext.png"),
                const SizedBox(height: 10,),
                const Text("Chatakai",textAlign: TextAlign.center, style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(fontSize: 20, letterSpacing: 0.5, color: Colors.black),
                    children: [
                      TextSpan(text: "Powered by "),
                      TextSpan(text: "Kai AI", style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),

              ],
            ),
          ),
          Positioned(
            bottom: mq.height * .15,
            width: mq.width,
            child: const Text("Made by Aditya Sharma", textAlign: TextAlign.center,style: TextStyle(fontSize: 20, letterSpacing: 0.5),),
          ),
        ],
      ),
    );
  }
}
