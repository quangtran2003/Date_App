import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date/core/enum/sex_enum.dart';

class InfoUserMatchModel {
  InfoUserMatchModel({
    required this.imgAvt,
    required this.birthday,
    required this.bio,
    required this.updateTime,
    required this.users,
    required this.imgDesc,
    required this.sexualOrientation,
    required this.uid,
    required this.createTime,
    required this.name,
    required this.place,
    required this.email,
    required this.status,
    required this.urlImgDesc,
    required this.gender,
  });

  final String imgAvt;
  final int birthday;
  final String bio;
  final Timestamp updateTime;
  final Map<String, User> users;
  final String imgDesc;
  final int sexualOrientation;
  final String uid;
  final Timestamp createTime;
  final String name;
  final String place;
  final String email;
  final int status;
  final List<String> urlImgDesc;
  final int gender;

  factory InfoUserMatchModel.fromJson(Map<String, dynamic> json) {
    return InfoUserMatchModel(
      imgAvt: json["imgAvt"] ?? "",
      birthday: json["birthday"] ?? 2020,
      bio: json["bio"] ?? "",
      updateTime: json["updateTime"] ?? Timestamp.now(),
      users: json["users"] != null
          ? Map.from(json["users"])
              .map((k, v) => MapEntry<String, User>(k, User.fromJson(v)))
          : {},
      imgDesc: json["imgDesc"] ?? "",
      sexualOrientation: json["sexualOrientation"] ?? SexEnum.all.value,
      uid: json["uid"] ?? "",
      createTime: json["createTime"] ?? Timestamp.now(),
      name: json["name"] ?? "",
      place: json["place"] ?? "",
      email: json["email"] ?? "",
      status: json["status"] ?? 0,
      urlImgDesc: [],
      gender: json["gender"] ?? SexEnum.feMale.value,
    );
  }

  factory InfoUserMatchModel.fromJsonDoc(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    return InfoUserMatchModel(
      imgAvt: json["imgAvt"] ?? "",
      birthday: json["birthday"] ?? 2020,
      bio: json["bio"] ?? "",
      updateTime: json["updateTime"] ?? Timestamp.now(),
      users: json["users"] != null
          ? Map.from(json["users"])
              .map((k, v) => MapEntry<String, User>(k, User.fromJson(v)))
          : {},
      imgDesc: json["imgDesc"] ?? "",
      sexualOrientation: json["sexualOrientation"] ?? 2,
      uid: json["uid"] ?? "",
      createTime: json["createTime"] ?? Timestamp.now(),
      name: json["name"] ?? "",
      place: json["place"] ?? "",
      email: json["email"] ?? "",
      status: json["status"] ?? 0,
      urlImgDesc: [],
      gender: json["gender"] ?? SexEnum.all.value,
    );
  }
}

class User {
  User(
      {required this.imgAvt,
      required this.createTime,
      required this.name,
      required this.updateTime,
      required this.status,
      required this.uid});

  final String uid;
  final String imgAvt;
  final Timestamp createTime;
  final String name;
  final Timestamp updateTime;
  final int status;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        imgAvt: json["imgAvt"] ?? "",
        createTime: json["createTime"] ?? Timestamp.now(),
        name: json["name"] ?? "",
        updateTime: json["updateTime"] ?? Timestamp.now(),
        status: json["status"] ?? -1,
        uid: json["uid"] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "imgAvt": imgAvt,
      "createTime": FieldValue.serverTimestamp(),
      "name": name,
      "updateTime": FieldValue.serverTimestamp(),
      "status": status,
      "uid": uid,
    };
  }
}
