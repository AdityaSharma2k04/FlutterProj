class ChatUser {
  String? image;
  String? name;
  String? about;
  String? createdAt;
  bool? isOnline;
  String? lastActive;
  String? id;
  String? pushToken;
  String? email;

  ChatUser(
      {
        this.image,
        this.name,
        this.about,
        this.createdAt,
        this.isOnline,
        this.lastActive,
        this.id,
        this.pushToken,
        this.email});

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? "";
    name = json['name'] ?? "";
    about = json['about'] ?? "";
    createdAt = json['created_at'] ?? "";
    isOnline = json['is_online'] ?? "";
    lastActive = json['last_active'] ?? "";
    id = json['id'] ?? "";
    pushToken = json['push_token'] ?? "";
    email = json['email'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['name'] = this.name;
    data['about'] = this.about;
    data['created_at'] = this.createdAt;
    data['is_online'] = this.isOnline;
    data['last_active'] = this.lastActive;
    data['id'] = this.id;
    data['push_token'] = this.pushToken;
    data['email'] = this.email;
    return data;
  }
}
