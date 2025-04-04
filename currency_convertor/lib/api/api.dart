import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

Future<double?> getExchangeRate(String fromCurrency, String toCurrency) async {
  final url = Uri.parse('https://api.frankfurter.app/latest?from=$fromCurrency&to=$toCurrency');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    log("Data : $data");
    return data['rates'][toCurrency];
  } else {
    log('Failed to load exchange rate: ${response.statusCode}');
    return null;
  }
}
