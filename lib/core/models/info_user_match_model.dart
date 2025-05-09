import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date/core/enum/sex_enum.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

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
    this.token = '',
    this.lastOnline,
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
  String token;
  final RxBool isOnline = false.obs;
  final Timestamp? lastOnline;

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
      token: json["token"] ?? '',
      lastOnline: json["lastOnline"] is Timestamp
          ? json["lastOnline"] as Timestamp
          : Timestamp.now(),
    )..isOnline.value = json["isOnline"] ?? false;
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
      token: json["token"] ?? '',
      lastOnline: json["lastOnline"] is Timestamp
          ? json["lastOnline"] as Timestamp
          : Timestamp.now(),
    )..isOnline.value = json["isOnline"] ?? false;
  }
}

class User {
  User({
    required this.imgAvt,
    required this.createTime,
    required this.name,
    required this.updateTime,
    required this.status,
    required this.uid,
    this.token = '',
    this.lastOnline,
  });

  final String uid;
  final String imgAvt;
  final Timestamp createTime;
  final String name;
  final Timestamp updateTime;
  final int status;
  String token = '';
  final RxBool isOnline = false.obs;
  final Timestamp? lastOnline;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      imgAvt: json["imgAvt"] ?? "",
      createTime: json["createTime"] ?? Timestamp.now(),
      name: json["name"] ?? "",
      updateTime: json["updateTime"] ?? Timestamp.now(),
      status: json["status"] ?? -1,
      uid: json["uid"] ?? "",
      token: json["token"] ?? '',
      lastOnline: json["lastOnline"] is Timestamp
          ? json["lastOnline"] as Timestamp
          : null,
    )..isOnline.value = json["isOnline"] ?? false;
  }

  Map<String, dynamic> toJson() {
    return {
      "imgAvt": imgAvt,
      "createTime": FieldValue.serverTimestamp(),
      "name": name,
      "updateTime": FieldValue.serverTimestamp(),
      "status": status,
      "uid": uid,
      "token": token,
      "lastOnline": lastOnline ?? Timestamp.now(),
      "isOnline": isOnline.value
    };
  }
}
