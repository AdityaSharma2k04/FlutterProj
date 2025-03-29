import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'pages/splashScreen.dart';
import 'package:flutter/widgets.dart';

late Size mq;
void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((value){
  _initializeFirebase();
  runApp(MyApp());});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Adi Chat",
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 19),
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 1,
          ),
        ),
        home: const Splashscreen()
    );
  }
}

_initializeFirebase() async{
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}