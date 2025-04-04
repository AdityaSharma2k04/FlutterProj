import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'currency_converter_material_page.dart';

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
        if(mounted )Navigator.pushReplacement(context, MaterialPageRoute(builder:  (_) => const CurrencyConvertorMaterialPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Stack(
        children: [
          Positioned(
            top: mq.height * .15,
            width: mq.width * .5,
            right: mq.width * .25,
            child: Image.asset("assets/images/icon.png"),
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
