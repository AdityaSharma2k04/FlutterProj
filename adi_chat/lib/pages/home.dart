import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../api/api.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adi Chat"),
        leading: const Icon(CupertinoIcons.home),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () async {
            await APIs.auth.signOut();
            await GoogleSignIn().signOut();
          },
          child: Icon(Icons.add_comment, color: Colors.white),
          backgroundColor: Colors.blue,
        ),
      ),
      body: StreamBuilder(
        stream: APIs.firestore.collection('Users').snapshots(),
        builder: (context, snapshot) {
          final list = [];
          if(snapshot.hasData){
            final data = snapshot.data?.docs;
            for(var i in data!){
              log("Data: ${jsonEncode(i.data())}");
              list.add(i.data()['name']);
            }
          }
          return ListView.builder(
            padding: EdgeInsets.only(top: mq.height * 0.01),
            itemCount: list.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Text("Name: ${list[index]}");
            },
          );
        }
      ),
    );
  }
}
