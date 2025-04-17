import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String uid;
  final String? avatar;

  const UserModel({
    required this.email,
    required this.uid,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json["email"] ?? "",
      uid: json["uid"] ?? "",
      avatar: json["avatar"],
    );
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      email: data["email"] ?? "",
      uid: data["uid"] ?? "",
      avatar: data["avatar"],
    );
  }
}
