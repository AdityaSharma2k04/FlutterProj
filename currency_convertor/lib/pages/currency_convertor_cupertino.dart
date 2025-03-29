import 'package:flutter/cupertino.dart';

class CurrencyConverterCupertino extends StatefulWidget {
  const CurrencyConverterCupertino({super.key});

  @override
  State<CurrencyConverterCupertino> createState() => _CurrencyConverterCupertinoState();
}

class _CurrencyConverterCupertinoState extends State<CurrencyConverterCupertino> {
  double result = 0;
  final textEditingController = TextEditingController();

  // Define conversion rates
  final Map<String, double> conversionRates = {
    "USD": 85.87, // USD to INR
    "EUR": 93.45, // EUR to INR
  };

  String selectedCurrency = "USD"; // Default currency

  void convertCurrency() {
    FocusScope.of(context).unfocus(); // Close keyboard
    String input = textEditingController.text.trim();
    double? amount = double.tryParse(input);

    if (amount == null || amount <= 0) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("Invalid Input"),
          content: const Text("Please enter a valid amount."),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      double conversionRate = conversionRates[selectedCurrency] ?? 1.0; // Default to 1.0 if null
      result = amount * conversionRate;
    });
  }

  void showCurrencyPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text("Select Currency"),
        actions: [
          CupertinoActionSheetAction(
            child: const Text("USD"),
            onPressed: () {
              setState(() {
                selectedCurrency = "USD";
              });
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text("EUR"),
            onPressed: () {
              setState(() {
                selectedCurrency = "EUR";
              });
              Navigator.pop(context);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemGrey6,
        middle: Text(
          "Currency Converter",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: CupertinoColors.systemGrey6,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "INR: ₹${result.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: CupertinoColors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              CupertinoTextField(
                controller: textEditingController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                placeholder: "Enter amount in $selectedCurrency",
                prefix: const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(CupertinoIcons.money_dollar, color: CupertinoColors.black),
                ),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: CupertinoColors.systemGrey),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                style: const TextStyle(fontSize: 18, color: CupertinoColors.black),
              ),
              const SizedBox(height: 15),
              CupertinoButton(
                onPressed: showCurrencyPicker,
                color: CupertinoColors.systemBlue,
                child: Text("Currency: $selectedCurrency"),
              ),
              const SizedBox(height: 15),
              CupertinoButton.filled(
                onPressed: convertCurrency,
                child: const Text("Convert"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
