import 'package:shared_preferences/shared_preferences.dart';

import '../pages/groq_chat.dart';

class LocalStorage {
  static const _chatKey = 'chat_history';

  static Future<void> saveChatHistory(List<ChatMessage> messages) async {
    final prefs = await SharedPreferences.getInstance();
    // Implement serialization logic
  }

  static Future<List<ChatMessage>> getChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    // Implement deserialization logic
    return [];
  }
}