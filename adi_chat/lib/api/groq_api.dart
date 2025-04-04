import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GroqService {
  static String apiKey = dotenv.env['API_KEY']!; // Replace with actual API key
  static const String apiUrl = "https://api.groq.com/openai/v1/chat/completions";

  static Future<String> getGroqQueryResponse(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "llama-3.3-70b-versatile",
          "messages": [
            {"role": "system", "content": "You are a helpful AI assistant."},
            {"role": "user", "content": userMessage},
          ],
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['choices'][0]['message']['content'];
      } else {
        throw Exception("API Error: ${response.body}");
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
