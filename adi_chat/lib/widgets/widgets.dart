import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/chat_user.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      margin: EdgeInsets.symmetric(horizontal: mq.width * 0.04, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {},
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * 0.03),
            // Rounded corners
            child: CachedNetworkImage(
              height: 50,
              // Fixed size for better UI
              width: 50,
              fit: BoxFit.cover,
              // Ensures the image is properly scaled
              imageUrl:
                  widget.user.image ??
                  'https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250',
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget:
                  (context, url, error) => const Icon(Icons.error, size: 40),
            ),
          ),
          title: Text(widget.user.name ?? ""),
          subtitle: Text(widget.user.about ?? "", maxLines: 1),
          trailing: Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
