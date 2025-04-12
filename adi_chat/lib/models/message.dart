class Message {
  Message({
    required this.msg,
    required this.toId,
    required this.read,
    required this.type,
    required this.fromId,
    required this.sent,
  });

  late final String? msg;
  late final String? toId;
  late final String? read;
  late final Type type;
  late final String? fromId;
  late final String sent;

  factory Message.fromJson(Map<String, dynamic> json){
    return Message(
      msg: json["msg"].toString(),
      toId: json["toId"].toString(),
      read: json["read"].toString(),
      type: json["type"].toString() == Type.image.name ? Type.image : Type.text,
      fromId: json["fromId"].toString(),
      sent: json["sent"].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "toId": toId,
    "read": read,
    "type": type.name,
    "fromId": fromId,
    "sent": sent,
  };

}


enum Type {text, image}
