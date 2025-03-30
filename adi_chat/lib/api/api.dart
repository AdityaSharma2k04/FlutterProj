import 'package:adi_chat/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User get user => auth.currentUser!;

  static Future<bool> user_exists() async {
    return (await firestore.collection("users").doc(user.uid).get()).exists;
  }

  static Future<void> create_user() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      image: user.photoURL.toString(),
      about: "Hey I'm using Adi Chat",
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
    );

    return (await firestore
            .collection("users")
            .doc(user.uid).set(chatUser.toJson()));
  }

}
