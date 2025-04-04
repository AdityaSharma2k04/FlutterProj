import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';
import 'package:ChataKai/models/chat_user.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/chat_user_phone.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static User get user => auth.currentUser!;
  static late ChatUser me;

  static Future<bool> user_exists() async {
    return (await firestore.collection("users").doc(user.uid).get()).exists;
  }

  static Future<void> getSelfInfo() async {
    final doc = await firestore.collection("users").doc(user.uid).get();

    if (doc.exists) {
      me = ChatUser.fromJson(doc.data()!);
      log("My Data: ${doc.data()}");
    } else {
      if (auth.currentUser?.phoneNumber != null) {
        await createPhoneUser().then((_) => getSelfInfo());
      } else {
        await create_user().then((_) => getSelfInfo());
      }
    }
  }

  static Future<void> create_user() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
      id: user.uid,
      name: user.displayName ?? "Unknown User",
      phoneNumber: null,
      email: user.email?.isNotEmpty == true ? user.email : null,
      image:
          user.photoURL ??
          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
      about: "Hey I'm using Adi Chat",
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
    );

    await firestore.collection("users").doc(user.uid).set(chatUser.toJson());
  }

  static Future<void> createPhoneUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    log("Creating phone user with UID: ${user.uid}");
    log("User Phone Number: ${user.phoneNumber}");

    final chatUserPhone = ChatUserPhone(
      id: user.uid,
      phoneNumber: user.phoneNumber,
      email: user.email?.isNotEmpty == true ? user.email : null,
      name: user.phoneNumber ?? "Unknown User",
      image:
          user.photoURL ??
          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
      about: "Hey, I'm using Adi Chat",
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
    );

    log("Storing Phone User: ${chatUserPhone.toJson()}");

    await firestore
        .collection("users")
        .doc(user.uid)
        .set(chatUserPhone.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> updateUserInfo() async {
    await firestore.collection("users").doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  static Future<void> updateUserProfile(File file) async {
    try {
      final ext = file.path.split('.').last;
      final ref = storage.ref().child("profile_picture/${user.uid}.$ext");

      // Upload file with metadata
      await ref.putFile(file, SettableMetadata(contentType: "image/$ext"));

      // Get download URL
      final downloadUrl = await ref.getDownloadURL();
      me.image = downloadUrl;

      // Update Firestore with image URL
      await firestore.collection("users").doc(user.uid).update({
        'image': me.image,
      });
    } catch (e) {
      log("Error updating profile picture: $e");
    }
  }
}
