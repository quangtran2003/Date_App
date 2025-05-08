import 'package:cloud_firestore/cloud_firestore.dart';

class CallInfo {
  final String callId;
  final String callerId;
  final String receiverId;
  final int status;
  final Timestamp createTime;

  CallInfo({
    required this.callId,
    required this.callerId,
    required this.receiverId,
    required this.status,
    required this.createTime,
  });

  // Chuyển đối tượng thành Map để lưu vào Firestore
  Map<String, dynamic> toJson() {
    return {
      'callId': callId,
      'callerId': callerId,
      'receiverId': receiverId,
      'status': status,
      'createTime': FieldValue.serverTimestamp(),
    };
  }

  // Tạo đối tượng từ Map lấy ra từ Firestore
  factory CallInfo.fromJson(Map<String, dynamic> json) {
    return CallInfo(
      callId: json['callId'] as String,
      callerId: json['callerId'] as String,
      receiverId: json['receiverId'] as String,
      status: json['status'] as int,
      createTime: json['createTime'] ?? Timestamp.now(),
    );
  }
}
