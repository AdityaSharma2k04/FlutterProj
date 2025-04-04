import 'package:firebase_auth/firebase_auth.dart';

class ChatUserPhone {
  late String? image;
  late String? name;
  late String? about;
  late String? createdAt;
  late bool? isOnline;
  late String? lastActive;
  late String? id;
  late String? pushToken;
  late String? email;
  late String? phoneNumber;

  ChatUserPhone({
    required this.phoneNumber,
    required this.image,
    required this.name,
    required this.about,
    required this.createdAt,
    required this.isOnline,
    required this.lastActive,
    required this.id,
    required this.pushToken,
    required this.email,
  });

  // Convert Firebase User to ChatUserPhone
  factory ChatUserPhone.fromFirebaseUser(User user) {
    return ChatUserPhone(
      phoneNumber: user.phoneNumber, // Ensure we store correct phone number
      image: user.photoURL,
      name: user.displayName ?? user.phoneNumber ?? "Unknown User",
      about: "Hey there! I'm using this app.",
      createdAt: user.metadata.creationTime?.toIso8601String() ?? "",
      isOnline: false,
      lastActive: user.metadata.lastSignInTime?.toIso8601String() ?? "",
      id: user.uid,
      pushToken: "",
      email: user.email, // Store email properly
    );
  }

  // Convert JSON to ChatUserPhone
  factory ChatUserPhone.fromJson(Map<String, dynamic> json) {
    return ChatUserPhone(
      image: json['image'] ?? "",
      name: json['name'] ?? "",
      about: json['about'] ?? "",
      createdAt: json['created_at'] ?? "",
      isOnline: json['is_online'] ?? false,
      lastActive: json['last_active'] ?? "",
      id: json['id'] ?? "",
      pushToken: json['push_token'] ?? "",
      email: json['email'], // No need for null check
      phoneNumber: json['phoneNumber'], // Store correctly
    );
  }

  // Convert ChatUserPhone to JSON
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'about': about,
      'created_at': createdAt,
      'is_online': isOnline,
      'last_active': lastActive,
      'id': id,
      'push_token': pushToken,
      'email': email, // Store email even if it's null
      'phoneNumber': phoneNumber, // Ensure phone number is stored
    };
  }
}
