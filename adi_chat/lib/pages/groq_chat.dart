import 'package:ChataKai/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart';
import '../api/groq_api.dart';
import 'package:ChataKai/Helper/local_storage_groq.dart';

import '../models/chat_user.dart';

class GAIChatScreen extends StatefulWidget {
  const GAIChatScreen({super.key, required this.user});

  final ChatUser user;

  @override
  _GAIChatScreenState createState() => _GAIChatScreenState();
}

class _GAIChatScreenState extends State<GAIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _showTypingIndicator = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await LocalStorage.getChatHistory();
    setState(() => _messages.addAll(history));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    LocalStorage.saveChatHistory(_messages);
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    final userMessage = ChatMessage(
      content: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _controller.clear();
      _isLoading = true;
      _showTypingIndicator = true;
    });

    _scrollToBottom();

    try {
      final response = await GroqService.getGroqQueryResponse(text);
      setState(() {
        _messages.add(
          ChatMessage(
            content: response,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(
            content: 'Error: ${e.toString().replaceAll('Exception: ', '')}',
            isUser: false,
            isError: true,
            timestamp: DateTime.now(),
          ),
        );
      });
    } finally {
      setState(() {
        _isLoading = false;
        _showTypingIndicator = false;
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _confirmClearHistory() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear History?'),
            content: const Text('This will delete all chat messages.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() => _messages.clear());
                  Navigator.pop(context);
                },
                child: const Text('Clear', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          if (!didPop) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                );
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: const Text(
              "Kai AI",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _confirmClearHistory,
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child:
                    _messages.isEmpty
                        ? const Center(
                          child: Text(
                            'What can I help with?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        )
                        : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            return ChatMessageBubble(
                              message: _messages[index],
                              onCopy:
                                  () => Clipboard.setData(
                                    ClipboardData(
                                      text: _messages[index].content,
                                    ),
                                  ),
                            );
                          },
                        ),
              ),
              if (_showTypingIndicator) _buildTypingIndicator(),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(
              Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(width: 8),
          Text('Kai is typing...', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 14, right: 10),
              child: TextField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Ask Anything...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 14, right: 10),
            child: IconButton(
              icon:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.send),
              onPressed: _isLoading ? null : _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String content;
  final bool isUser;
  final bool isError;
  final DateTime? timestamp;
  final String? imageUrl = FirebaseAuth.instance.currentUser?.photoURL;

  ChatMessage({
    required this.content,
    this.isUser = false,
    this.isError = false,
    this.timestamp, // Allow null values
  });
}

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback onCopy;

  const ChatMessageBubble({required this.message, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          message.isUser
              ? (message.imageUrl != null && message.imageUrl!.isNotEmpty
                  ? ClipOval(
                    child: Image.network(
                      message.imageUrl!,
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              Icon(Icons.error), // Handle errors
                    ),
                  )
                  : Icon(Icons.person)) // Default icon if no image
              : ClipOval(
                child: Image.asset(
                  "assets/images/kaiAI_logo.png",
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          Icon(Icons.error), // Handle errors
                ),
              ),
      title: Text(message.isUser ? 'You' : 'Kai'),
      subtitle: MarkdownBody(data: message.content, selectable: true),
      trailing: IconButton(icon: const Icon(Icons.copy, size: 20,), onPressed: onCopy),
    );
  }
}
