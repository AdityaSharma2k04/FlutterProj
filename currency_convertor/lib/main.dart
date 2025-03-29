import 'package:currency_convertor/pages/currency_convertor_cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'pages/currency_converter_material_page.dart';

void main() {
  runApp(const MyCupertinoApp());
}

/*
Types of Widgets:
1. StatelessWidget
2. Stateful Widget
 */

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CurrencyConvertorMaterialPage(),
    );
  }
}

class MyCupertinoApp extends StatelessWidget {
  const MyCupertinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: CurrencyConverterCupertino(),
    );
  }
}

