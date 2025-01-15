import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date/features/feature_src.dart';

class Chat {
  Chat({
    this.users,
    this.lastMessage,
    this.lastMessageTime,
  });

  List<String>? users;
  ChatMessage? lastMessage;
  Timestamp? lastMessageTime;

  factory Chat.fromJson(Map json, ChatMessage lastMessage) {
    return Chat(
      users: json["users"] == null
          ? []
          : List<String>.from(json["users"]!.map((x) => x)),
      lastMessage: lastMessage,
      lastMessageTime: json["lastMessageTime"],
    );
  }

  Map toJson() => {
        "users": users,
        "lastMessage": lastMessage,
        "lastMessageTime": lastMessageTime,
      };
}
