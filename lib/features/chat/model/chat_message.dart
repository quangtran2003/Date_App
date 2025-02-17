// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:easy_date/utils/date_utils.dart';

import 'message_type.dart';

class ChatMessage {
  final bool isMe;
  final String content;
  final String senderId;
  final MessageType type;
  final Timestamp createTime;
  final bool? isOnline;
  final String? token;

  // Local variables
  final DateTime createDate;
  final String createTimeHHmma;
  final String createTimeDdMMyyyy;

  ChatMessage({
    this.isMe = false,
    required this.content,
    required this.senderId,
    this.type = MessageType.text,
    required this.createTime,
    this.isOnline,
    this.token,
    required this.createDate,
    required this.createTimeHHmma,
    required this.createTimeDdMMyyyy,
  });

  factory ChatMessage.fromJson(Map json, String userId) {
    final senderId = json["senderId"];
    final Timestamp createTime = json["createTime"] ?? Timestamp.now();
    final createTimeDate = createTime.toDate();
    final createTimeHHmm =
        convertDateToString(createTimeDate, PATTERN_18).toLowerCase();
    final createTimeDdMMyyyy = convertDateToString(createTimeDate, PATTERN_1);
    return ChatMessage(
      senderId: senderId,
      content: json["content"],
      isMe: userId == senderId,
      type: MessageType.fromInt(json["type"] ?? 0),
      createTime: createTime,
      createDate: createTimeDate,
      createTimeHHmma: createTimeHHmm,
      createTimeDdMMyyyy: createTimeDdMMyyyy,
      isOnline: json["isOnline"],
      token: json["token"],
    );
  }

  factory ChatMessage.fromDocument(
    DocumentSnapshot doc,
    String userId,
  ) {
    // final data = doc.data() as Map<String, dynamic>;
    final data = doc.data() as Map<String, dynamic>;
    final Timestamp createTime = data["createTime"] ?? Timestamp.now();
    final createTimeDate = createTime.toDate();
    final createTimeHHmm =
        convertDateToString(createTimeDate, PATTERN_18).toLowerCase();
    final createTimeDdMMyyyy = convertDateToString(createTimeDate, PATTERN_1);

    final senderId = data["senderId"] ?? "";
    return ChatMessage(
      senderId: data["senderId"] ?? "",
      content: data["content"] ?? "",
      type: MessageType.fromInt(data["type"] ?? 0),
      createTime: createTime,
      createDate: DateTime(
        createTimeDate.year,
        createTimeDate.month,
        createTimeDate.day,
      ),
      isMe: userId == senderId,
      createTimeHHmma: createTimeHHmm,
      createTimeDdMMyyyy: createTimeDdMMyyyy,
      isOnline: data["isOnline"] ?? false,
      token: data["token"],
    );
  }
}
