import 'dart:io';
import 'package:ChataKai/models/chat_user.dart';
import 'package:ChataKai/pages/home.dart';
import 'package:ChataKai/pages/loginPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../api/api.dart';
import 'package:ChataKai/Helper/dialog.dart';
import '../main.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key, required this.user});

  Future<void> requestGalleryPermissions() async {
    await Permission.photos.request();
  }

  Future<void> requestCameraPermissions() async {
    await Permission.camera.request();
  }

  final ChatUser user;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    super.initState();
  }
  String? setImage = null;
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

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
            leading: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                );
              },
              child: Icon(Icons.arrow_back, color: Colors.black),
            ),
            title: Text("Your Profile"),
            shadowColor: Colors.black,
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(width: mq.width, height: mq.height * 0.03),
                    Stack(
                      children: [
                        if (setImage != null) ClipRRect(
                              borderRadius: BorderRadius.circular(
                                mq.height * 0.1,
                              ),
                              child: Image.file(
                                File(setImage!),
                                width: mq.height * 0.2,
                                height: mq.height * 0.2,
                                fit: BoxFit.fill,
                              ),
                            ) else ClipRRect(
                              borderRadius: BorderRadius.circular(
                                mq.height * 0.1,
                              ),
                              child: CachedNetworkImage(
                                width: mq.height * 0.2,
                                height: mq.height * 0.2,
                                fit: BoxFit.contain,
                                imageUrl:
                                    widget.user.image ??
                                    'https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250',
                                placeholder:
                                    (context, url) =>
                                        const CircularProgressIndicator(),
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
                            onPressed: () {
                              _showBottomSheet();
                            },
                            child: Icon(Icons.edit, color: Colors.blue),
                            color: Colors.white,
                            shape: CircleBorder(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: mq.height * 0.03),
                    Text(
                      widget.user.email?.isNotEmpty == true
                          ? widget.user.email!
                          : widget.user.phoneNumber?.isNotEmpty == true
                          ? widget.user.phoneNumber!
                          : "No Contact Info",
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    SizedBox(height: mq.height * 0.05),
                    TextFormField(
                      onSaved: (val) => APIs.me.name = val ?? '',
                      validator:
                          (val) =>
                              val != null && val.isNotEmpty
                                  ? null
                                  : "Required Field",
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
                      onSaved: (val) => APIs.me.about = val,
                      validator:
                          (val) =>
                              val != null && val.isNotEmpty
                                  ? null
                                  : "Required Field",
                      initialValue:
                          widget.user.about ?? "Hey! I'm Using Adi Chat",
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          APIs.updateUserInfo().then((value) {
                            Dialogs.showSnackBar(
                              context,
                              "Profile Updated Successfully",
                            );
                          });
                        }
                      },
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
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(
            top: mq.height * 0.03,
            bottom: mq.height * 0.05,
          ),
          children: [
            Text(
              "Pick Profile Picture",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),

            SizedBox(height: mq.height * 0.02),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    fixedSize: Size(mq.width * 0.3, mq.height * .15),
                  ),
                  onPressed: () async {
                    widget.requestGalleryPermissions();
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery, imageQuality: 80
                    );
                    if(image != null){
                      setState(() {
                        setImage = image.path;
                      });
                      Navigator.pop(context);
                      await APIs.updateUserProfile(File(setImage!));
                    }
                  },
                  child: Image.asset("assets/images/add_image.png"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    fixedSize: Size(mq.width * 0.3, mq.height * .15),
                  ),
                  onPressed: () async {
                    widget.requestCameraPermissions();
                    final ImagePicker picker = ImagePicker();
                    final XFile? photo = await picker.pickImage(
                      source: ImageSource.camera, imageQuality: 80
                    );
                    if(photo != null){
                      setState(() {
                        setImage = photo.path;
                      });
                      Navigator.pop(context);
                      await APIs.updateUserProfile(File(setImage!));
                    }
                  },
                  child: Image.asset("assets/images/camera.png"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
