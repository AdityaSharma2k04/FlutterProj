import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.04 , vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {},
        child: ListTile(
            leading: CircleAvatar(child: Icon(CupertinoIcons.person_crop_circle_fill,)),
            title: Text("Aditya"),
            subtitle: Text("hello", maxLines: 1),
            trailing: Text("12:00pm", style: TextStyle(color: Colors.black54),),
          ),
      ),
    );
  }
}
