import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date/utils/date_utils.dart';

import '../../../core/enum/message_type.dart';

class ChatMessage {
  final bool isMe;
  final String content;
  final String senderId;
  final MessageTypeEnum type;
  final Timestamp createTime;

  // Local variables
  final DateTime createDate;
  final String createTimeHHmma;
  final String createTimeDdMMyyyy;

  ChatMessage({
    required this.senderId,
    required this.content,
    this.type = MessageTypeEnum.text,
    required this.createTime,
    this.isMe = false,
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
      type: MessageTypeEnum.fromInt(json["type"] ?? 0),
      createTime: createTime,
      createDate: createTimeDate,
      createTimeHHmma: createTimeHHmm,
      createTimeDdMMyyyy: createTimeDdMMyyyy,
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
      type: MessageTypeEnum.fromInt(data["type"] ?? 0),
      createTime: createTime,
      createDate: DateTime(
        createTimeDate.year,
        createTimeDate.month,
        createTimeDate.day,
      ),
      isMe: userId == senderId,
      createTimeHHmma: createTimeHHmm,
      createTimeDdMMyyyy: createTimeDdMMyyyy,
    );
  }
}
