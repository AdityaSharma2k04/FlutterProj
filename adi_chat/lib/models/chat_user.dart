class ChatUser {
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

  ChatUser({
    this.image,
    this.name,
    this.about,
    this.createdAt,
    this.isOnline,
    this.lastActive,
    this.id,
    this.pushToken,
    this.email,
    this.phoneNumber,
  });

  // Factory constructor for creating a ChatUser instance from JSON
  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      image: json['image'],
      name: json['name'],
      about: json['about'],
      createdAt: json['created_at'],
      isOnline: json['is_online']?.toString().toLowerCase() == 'true', // Ensure boolean type
      lastActive: json['last_active'],
      id: json['id'],
      pushToken: json['push_token'],
      email: json['email'], // Store as null if not present
      phoneNumber: json['phoneNumber'], // Ensure consistency
    );
  }

  // Convert ChatUser instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'about': about,
      'created_at': createdAt,
      'is_online': isOnline ?? false, // Default to false if null
      'last_active': lastActive,
      'id': id,
      'push_token': pushToken,
      'email': email, // Keep it as null if not present
      'phoneNumber': phoneNumber, // Use consistent key
    };
  }
}
