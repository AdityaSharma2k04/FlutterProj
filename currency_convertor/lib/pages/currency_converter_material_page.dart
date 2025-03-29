import 'package:flutter/material.dart';

class CurrencyConvertorMaterialPage extends StatefulWidget {
  const CurrencyConvertorMaterialPage({super.key});

  @override
  State<CurrencyConvertorMaterialPage> createState() =>
      _CurrencyConvertorMaterialPage();
}

class _CurrencyConvertorMaterialPage
    extends State<CurrencyConvertorMaterialPage> {
  double result = 0;
  final textEditingController = TextEditingController();
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: Colors.white,
      width: 2,
      strokeAlign: BorderSide.strokeAlignOutside,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        title: Text(
          "Currency Convertor",
          style: TextStyle(color: Colors.black, fontSize: 40,fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "INR: ${result.toStringAsFixed(2)}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextField(
                controller: textEditingController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.done,
                onSubmitted:(String value){
                  result = double.parse(textEditingController.text) * 85.87;
                  setState(() {
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: border,
                  enabledBorder: border,
                  filled: true,
                  fillColor: Colors.black,
                  hintText: "Please Enter the Amount in INR",
                  hintStyle: const TextStyle(color: Colors.white60),
                  prefixIcon: const Icon(Icons.attach_money_sharp),
                  prefixIconColor: Colors.white,
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    result = double.parse(textEditingController.text) * 85.87;
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  // Adjusted height
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Convert"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
