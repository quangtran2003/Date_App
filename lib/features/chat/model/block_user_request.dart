import 'package:cloud_firestore/cloud_firestore.dart';

class BlockUserRequest {
  final String uid;
  final String? imgAvt;
  final String name;
  final int status;

  const BlockUserRequest({
    required this.uid,
    this.imgAvt,
    required this.name,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'imgAvt': imgAvt,
      'name': name,
      'status': status,
      "createTime": FieldValue.serverTimestamp(),
      "updateTime": FieldValue.serverTimestamp(),
    };
  }
}
