import 'dart:io';
import 'package:ChataKai/models/chat_user.dart';
import 'package:ChataKai/pages/home.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../api/api.dart';
import '../main.dart';
import '../models/message.dart';
import '../widgets/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.user});
  Future<void> requestGalleryPermissions() async {
    await Permission.photos.request();
  }

  Future<void> requestCameraPermissions() async {
    await Permission.camera.request();
  }
  final ChatUser user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _emojiShowing = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && _emojiShowing) {
        setState(() => _emojiShowing = false);
      }
    });
    super.initState();
  }

  void scrollToBottom({bool force = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent + 200;
          _scrollController.jumpTo(maxScroll);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          if (_emojiShowing) {
            setState(() => _emojiShowing = false);
          }
        },
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 234, 248, 255),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            flexibleSpace: _appBar(),
            shadowColor: Colors.black,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

                          // Scroll to bottom after list is built

                          WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom(force: true));
                          if (_list.isEmpty) {
                            return const Center(child: Text("Say Hii!!👋", style: TextStyle(fontSize: 24)));
                          } else {
                            return ListView.builder(
                              controller: _scrollController,
                              itemCount: _list.length,
                              padding: EdgeInsets.only(top: mq.height * 0.01),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) => MessageCard(message: _list[index]),
                            );
                          }
                      }
                    },
                  ),
                ),
                chatInput(),
                if (_emojiShowing)
                  SizedBox(
                    height: 256,
                    child: EmojiPicker(
                      textEditingController: _textController,
                      scrollController: _scrollController,
                      config: Config(
                        height: 256,
                        checkPlatformCompatibility: true,
                        viewOrderConfig: const ViewOrderConfig(),
                        emojiViewConfig: EmojiViewConfig(
                          emojiSizeMax: 28 *
                              (foundation.defaultTargetPlatform ==
                                  TargetPlatform.iOS
                                  ? 1.2
                                  : 1.0),
                        ),
                        skinToneConfig: const SkinToneConfig(),
                        categoryViewConfig: const CategoryViewConfig(),
                        bottomActionBarConfig: const BottomActionBarConfig(),
                        searchViewConfig: const SearchViewConfig(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: mq.height * 0.01,
        horizontal: mq.height * 0.015,
      ),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        _emojiShowing = !_emojiShowing;
                      });
                    },
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      onTap: () {
                        if (_emojiShowing) {
                          setState(() {
                            _emojiShowing = false;
                          });
                        }
                      },
                      focusNode: _focusNode,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type Something",
                        hintStyle: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        await widget.requestGalleryPermissions();
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80
                        );
                        if(image != null){
                          await APIs.sendChatImage(widget.user, File(image.path));
                        }
                      },
                    icon: const Icon(Icons.image, color: Colors.blueAccent),
                  ),
                  IconButton(
                    onPressed: () async {
                        widget.requestCameraPermissions();
                    final ImagePicker picker = ImagePicker();
                    final XFile? photo = await picker.pickImage(
                      source: ImageSource.camera, imageQuality: 80
                    );
                        if(photo != null){
                          await APIs.sendChatImage(widget.user, File(photo.path));
                        }
                      },
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text, Type.text);
                _textController.text = '';
                scrollToBottom(force: true);
              }
            },
            shape: const CircleBorder(),
            color: Colors.blue,
            padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 5),
            minWidth: 0,
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _appBar() {
    return SafeArea(
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                );
              },
              icon: const Icon(Icons.arrow_back, color: Colors.black54),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * 0.1),
              child: CachedNetworkImage(
                width: mq.height * .05,
                height: mq.height * .05,
                fit: BoxFit.cover,
                imageUrl: widget.user.image ??
                    'https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250',
                placeholder: (context, url) =>
                const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                const Icon(Icons.error, size: 40),
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.user.name ?? widget.user.phoneNumber ?? "Unknown",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 1),
                Text(
                  (widget.user.isOnline == true)
                      ? "Online"
                      : (widget.user.lastActive != null
                      ? "Last Seen ${widget.user.lastActive!}"
                      : "Last Seen Unavailable"),
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
