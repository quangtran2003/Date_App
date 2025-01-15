import 'package:easy_date/features/feature_src.dart';

class UsersSuggestRepositoryImpl extends UsersSuggestRepository {
  @override
  Future<InfoUserMatchModel?> getUserSuggest() async {
    await checkNetwork();

    final userLogin = Get.find<HomeController>().currentUser.value;
    final listSex = <int>{};
    if (userLogin?.sexualOrientation == SexEnum.feMale.value) {
      listSex.addAll([
        SexEnum.male.value,
        SexEnum.all.value,
      ]);
    } else if (userLogin?.sexualOrientation == SexEnum.male.value) {
      listSex.addAll(
        [
          SexEnum.feMale.value,
          SexEnum.all.value,
        ],
      );
    } else {
      listSex.addAll([
        SexEnum.feMale.value,
        SexEnum.male.value,
        SexEnum.all.value,
      ]);
    }
    final documentSnapshot = await firestore
        .collection(FirebaseCollection.users)
        .where("status", isEqualTo: 1)
        .where("uid", isNotEqualTo: userLogin?.uid)
        .where("sexualOrientation", whereIn: listSex)
        .limit(1)
        .orderBy("uid", descending: true)
        .get();
    return documentSnapshot.docs.isEmpty
        ? null
        : InfoUserMatchModel.fromJson(documentSnapshot.docs[0].data());
  }
}
