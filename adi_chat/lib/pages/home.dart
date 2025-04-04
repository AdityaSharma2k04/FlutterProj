import 'dart:developer';
import 'package:ChataKai/models/chat_user.dart';
import 'package:ChataKai/pages/groq_chat.dart';
import 'package:ChataKai/pages/profile_screen.dart';
import 'package:ChataKai/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api/api.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> _list = [];
  final List<ChatUser> _search = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: PopScope(
        canPop: !_isSearching,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          if (_isSearching) {
            setState(() {
              _isSearching = false;
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title:
                !_isSearching
                    ? const Text("ChataKai")
                    : TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Name/Email/PhoneNo.",
                      ),
                      style: TextStyle(fontSize: 18, letterSpacing: 0.5),
                      autofocus: true,
                      onChanged: (val) {
                        _search.clear();
                        for (var i in _list) {
                          if ((i.name?.toLowerCase().contains(
                                    val.toLowerCase(),
                                  ) ??
                                  false) ||
                              (i.email?.toLowerCase().contains(
                                    val.toLowerCase(),
                                  ) ??
                                  false) ||
                              (i.phoneNumber?.toLowerCase().contains(
                                    val.toLowerCase(),
                                  ) ??
                                  false)) {
                            _search.add(i);
                          }
                        }
                        log("Search List: ${_search.toString()}");
                        setState(() {});
                      },
                    ),
            leading: const Icon(CupertinoIcons.home),
            shadowColor: Colors.black,
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(
                  _isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : CupertinoIcons.search,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UserProfile(user: APIs.me),
                    ),
                  );
                },
                icon: Icon(Icons.more_vert),
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // Ensures buttons take minimal space
              children: [
                FloatingActionButton(
                  heroTag: "Add Users", // Unique heroTag
                  onPressed: () {
                    // Action for first button
                  },
                  child: Icon(Icons.add_comment, color: Colors.white),
                  backgroundColor: Colors.blue,
                ),
                SizedBox(height: 10), // Space between buttons
                FloatingActionButton(
                  heroTag: "Kai AI", // Unique heroTag
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GAIChatScreen(user: APIs.me),
                      ),
                    );
                  },
                  backgroundColor: Colors.white, // White background
                  shape: const CircleBorder(), // Ensures circular shape
                  child: ClipOval( // Ensures image is clipped in a circular way
                    child: Image.asset(
                      "assets/images/kaiAI_logo.png",
                      width: 56,  // Ensures it fits inside FAB
                      height: 56, // Ensures it fits inside FAB
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: StreamBuilder(
            stream: APIs.getAllUser(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  _list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                      [];
                  if (_list.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Connection Found!",
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.only(top: mq.height * 0.01),
                      itemCount: _isSearching ? _search.length : _list.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                          user: _isSearching ? _search[index] : _list[index],
                        );
                      },
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
