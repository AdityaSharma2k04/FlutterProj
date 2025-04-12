import 'dart:developer';

import 'package:ChataKai/Helper/full_screen_image.dart';
import 'package:ChataKai/api/api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ChataKai/main.dart';
import 'package:ChataKai/Helper/time_formatter.dart';
import '../models/message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

  Widget _blueMessage() {
    if (widget.message.read!.isEmpty) {
      APIs.updateReadTime(widget.message);
      log("Message Read Updated");
    }
    return GestureDetector(
      onTap: () {
        if (widget.message.type == Type.image) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => FullScreenImagePage(imageUrl: widget.message.msg!),
            ),
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: mq.width * 0.04,
                vertical: mq.height * 0.01,
              ),
              padding: EdgeInsets.all(mq.width * 0.04),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.lightBlue),
                color: Color(0xffC6D7EFFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child:
                  widget.message.type == Type.text
                      ? Text(widget.message.msg!)
                      : ClipRRect(
                        child: CachedNetworkImage(
                          imageUrl: widget.message.msg!,
                          errorWidget:
                              (context, url, error) =>
                                  const Icon(Icons.error, size: 40),
                        ),
                      ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: mq.width * 0.05),
            child: Text(
              TimeFormatter.formatEpochToTime(
                context: context,
                epoch: widget.message.sent,
              ),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _greenMessage() {
    return GestureDetector(
      onTap: () {
        if (widget.message.type == Type.image) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => FullScreenImagePage(imageUrl: widget.message.msg!),
            ),
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: mq.height * 0.02),
              if (widget.message.read != "")
                Icon(Icons.done_all_rounded, color: Colors.blue),
              SizedBox(width: 2),
              Text(
                TimeFormatter.formatEpochToTime(
                  context: context,
                  epoch: widget.message.sent,
                ),
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: mq.width * 0.04,
                vertical: mq.height * 0.01,
              ),
              padding: EdgeInsets.all(mq.width * 0.04),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.lightGreen),
                color: Color.fromARGB(255, 218, 255, 176),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              ),
              child:
                  widget.message.type == Type.text
                      ? Text(widget.message.msg!)
                      : ClipRRect(
                        child: CachedNetworkImage(
                          imageUrl: widget.message.msg!,
                          errorWidget:
                              (context, url, error) =>
                                  const Icon(Icons.error, size: 40),
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
