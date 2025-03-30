import 'package:adi_chat/models/chat_user.dart';
import 'package:adi_chat/pages/home.dart';
import 'package:adi_chat/pages/loginPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../api/api.dart';
import 'package:adi_chat/Helper/dialog.dart';
import '../main.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key, required this.user});

  final ChatUser user;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
            );
          },
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text("Profile Screen"),
        shadowColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
        child: Column(
          children: [
            SizedBox(width: mq.width, height: mq.height * 0.03),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * 0.1),
                  child: CachedNetworkImage(
                    width: mq.height * 0.2,
                    height: mq.height * 0.2,
                    fit: BoxFit.fill,
                    imageUrl:
                        widget.user.image ??
                        'https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250',
                    placeholder:
                        (context, url) => const CircularProgressIndicator(),
                    errorWidget:
                        (context, url, error) =>
                            const Icon(Icons.error, size: 40),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: MaterialButton(
                    elevation: 1,
                    onPressed: () {},
                    child: Icon(Icons.edit, color: Colors.blue),
                    color: Colors.white,
                    shape: CircleBorder(),
                  ),
                ),
              ],
            ),
            SizedBox(height: mq.height * 0.03),
            Text(
              widget.user.email ?? ' ',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            SizedBox(height: mq.height * 0.05),
            TextFormField(
              initialValue: widget.user.name ?? "User",
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.person),
                hintText: "username",
                label: Text("Name"),
              ),
            ),
            SizedBox(height: mq.height * 0.05),
            TextFormField(
              initialValue: widget.user.about ?? "Hey! I'm Using Adi Chat",
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.info_outline),
                hintText: "Feeling Happy",
                label: Text("About"),
              ),
            ),
            SizedBox(height: mq.height * 0.05),
            FloatingActionButton.extended(
              onPressed: () {},
              icon: const Icon(Icons.edit, color: Colors.white),
              label: Text(
                "Update",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              backgroundColor: Colors.blue,
              shape: const StadiumBorder(),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.red,
          onPressed: () async {
            Dialogs.showProgressBar(context);
            await APIs.auth.signOut();
            await GoogleSignIn().signOut().then((value) {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
              );
            });
          },
          icon: Icon(Icons.logout, color: Colors.white),
          label: Text(
            "Logout",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
