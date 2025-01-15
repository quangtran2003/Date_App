class ProfileDetailRequest {
  ProfileDetailRequest({
    required this.bio,
    required this.imgDesc,
    required this.sexualOrientation,
    required this.uid,
    required this.place,
    required this.status,
    required this.imgAvt,
    required this.name,
    required this.birthday,
    required this.gender,
  });

  final String bio;
  final String imgDesc;
  final int sexualOrientation;
  final String uid;
  final String place;
  final int status;
  final String imgAvt;
  final String name;
  final int birthday;
  final int gender;

  Map<String, dynamic> toJson() => {
        "name": name,
        "birthday": birthday,
        "imgDesc": imgDesc,
        "bio": bio,
        "sexualOrientation": sexualOrientation,
        "place": place,
        "imgAvt": imgAvt,
        "status": status,
        "gender": gender,
      };
}
