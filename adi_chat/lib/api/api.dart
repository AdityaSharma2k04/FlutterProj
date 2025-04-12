import 'dart:io';
import 'dart:ui';

import 'package:ChataKai/models/message.dart';
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
    final now = DateTime.now();
    final lastSeen =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

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
      lastActive: lastSeen,
      pushToken: '',
    );

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

  static Future<void> updateActiveStatus(bool isOnline) async {
    await firestore.collection("users").doc(user.uid).update({
      'is_online': isOnline,
    });
  }

  static Future<void> updateLastSeen(String last_seen) async {
    await firestore.collection("users").doc(user.uid).update({
      'last_active': last_seen,
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

  static String getConversationId(String id) =>
      user.uid.hashCode <= id.hashCode
          ? "${user.uid}_$id"
          : "${id}_${user.uid}";

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
    ChatUser chatUser,
  ) {
    return firestore
        .collection('UserChats/${getConversationId(chatUser.id!)}/messages/')
        .orderBy('sent', descending: false)
        .snapshots();
  }

  static Future<void> sendMessage(ChatUser chatUser, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Message message = Message(
      msg: msg,
      toId: chatUser.id,
      read: '',
      type: type,
      fromId: user.uid,
      sent: time,
    );
    final ref = firestore.collection(
      'UserChats/${getConversationId(chatUser.id!)}/messages/',
    );
    await ref.doc(time).set(message.toJson());
  }

  static Future<void> updateReadTime(Message message) async {
    try {
      final fromId = message.fromId;
      if (fromId == null) throw Exception('Message fromId is null');

      await firestore
          .collection('UserChats/${getConversationId(fromId)}/messages')
          .doc(message.sent)
          .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
    } catch (e) {
      print('Failed to update read time: $e');
      // You can handle the error further, like logging or showing UI messages
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
    ChatUser chatUser,
  ) {
    return firestore
        .collection('UserChats/${getConversationId(chatUser.id!)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    try {
      final ext = file.path.split('.').last;
      final ref = storage.ref().child("images/${getConversationId(chatUser.id!)}/${DateTime.now().millisecondsSinceEpoch}.$ext");

      // Upload file with metadata
      await ref.putFile(file, SettableMetadata(contentType: "image/$ext"));

      // Get download URL
      final imageUrl = await ref.getDownloadURL();

      // Update Firestore with image URL
      await sendMessage(chatUser, imageUrl, Type.image);
    } catch (e) {
      log("Error Sending Image: $e");
    }
  }
}
