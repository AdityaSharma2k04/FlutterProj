import 'dart:developer';
import 'package:currency_convertor/Helper/dialog.dart';
import 'package:currency_convertor/api/api.dart';
import 'package:flutter/material.dart';

class CurrencyConvertorMaterialPage extends StatefulWidget {
  const CurrencyConvertorMaterialPage({super.key});

  @override
  State<CurrencyConvertorMaterialPage> createState() =>
      _CurrencyConvertorMaterialPage();
}

class _CurrencyConvertorMaterialPage
    extends State<CurrencyConvertorMaterialPage> {
  @override
  void initState() {
    super.initState();
    getRate();
  }

  double result = 0;
  double? rate;
  String fromCurrency = "USD";
  String toCurrency = "INR";
  List<String> currencies = [
    "USD", "EUR", "JPY", "GBP", "AUD",
    "CAD", "CHF", "CNY", "INR",
  ];

  Future<void> getRate() async {
    rate = await getExchangeRate(fromCurrency, toCurrency);
    if (rate == null) {
      if (mounted) Dialogs.showSnackBar(
          context, "Failed to fetch Exchange Rates");
      return;
    }
    setState(() {});
  }

  Future<void> convertCurrency() async {
    double? amount = double.tryParse(textEditingController.text);
    if (amount == null) {
      if (mounted) Dialogs.showSnackBar(context, "Enter a valid amount");
      return;
    }
    if (mounted) {
      setState(() {
        result = amount * (rate ?? 1);
      });
    }
  }

  final textEditingController = TextEditingController();
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: Colors.white,
      width: 2,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        title: const Text(
          "Currency Converter",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$toCurrency : ${result.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Currency selection row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // From Currency Dropdown
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: fromCurrency,
                          isExpanded: true,
                          items: currencies.map((String currency) {
                            return DropdownMenuItem<String>(
                              value: currency,
                              child: Text(currency),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              fromCurrency = newValue!;
                              if(fromCurrency == toCurrency) {
                                rate = 1;
                              } else {
                                getRate();
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  // Exchange icon
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.swap_horiz, color: Colors.white, size: 30),
                  ),

                  // To Currency Dropdown
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: toCurrency,
                          isExpanded: true,
                          items: currencies.map((String currency) {
                            return DropdownMenuItem<String>(
                              value: currency,
                              child: Text(currency),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              toCurrency = newValue!;
                              if(fromCurrency == toCurrency) {
                                rate = 1;
                              } else {
                                getRate();

                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Amount Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: textEditingController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                onSubmitted: (String value) async {
                  await convertCurrency();
                },
                decoration: InputDecoration(
                  focusedBorder: border,
                  enabledBorder: border,
                  filled: true,
                  fillColor: Colors.black,
                  hintText: "Enter Amount in $fromCurrency",
                  hintStyle: const TextStyle(color: Colors.white60),
                  prefixText: "$fromCurrency: "
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),

            // Convert Button
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  log("$fromCurrency to $toCurrency: Rate - $rate");
                  getRate();
                  rate ??= 1;
                  await convertCurrency();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Convert"),
              ),
            ),

            // Exchange Rate Display
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Exchange Rate: 1 $fromCurrency = ${rate ?? 'N/A'} $toCurrency",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
