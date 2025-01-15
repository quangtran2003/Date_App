import 'package:cloud_firestore/cloud_firestore.dart';

import 'message_type.dart';

class ChatMessageRequest {
  final String senderId;
  final String content;
  final MessageType type;

  const ChatMessageRequest({
    required this.senderId,
    required this.content,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'content': content,
      'type': type.firebaseValue,
      'createTime': FieldValue.serverTimestamp(),
    };
  }
}
