import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date/core/core_src.dart';
import 'package:easy_date/features/match_user/match_user_src.dart';

class MatchUserRepositoryImp extends MatchUserRepository {
  Future<List<InfoUserMatchModel>> _fetchPage(InfoUserMatchModel userLogin,
      {DocumentSnapshot? startAfter}) async {
    final listSex = <int>{};
    List<InfoUserMatchModel> listInfo = [];

    if (userLogin.sexualOrientation == SexEnum.feMale.value) {
      listSex.addAll([
        SexEnum.male.value,
        SexEnum.all.value,
      ]);
    } else if (userLogin.sexualOrientation == SexEnum.male.value) {
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

    Query query = firestore
        .collection(FirebaseCollection.users)
        .where("status", isEqualTo: 1)
        .where("uid", isNotEqualTo: userLogin.uid)
        .where("sexualOrientation", whereIn: listSex);
    // .limit(10);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    QuerySnapshot querySnapshot = await query.get();

    for (final data in querySnapshot.docs) {
      InfoUserMatchModel infoUserSnap = InfoUserMatchModel.fromJsonDoc(data);
      if (!userLogin.users.containsKey(infoUserSnap.uid)) {
        if (infoUserSnap.imgDesc.isNotEmpty) {
          List<String> listImg = [];
          listImg = infoUserSnap.imgDesc.split(',');
          for (var value in listImg) {
            infoUserSnap.urlImgDesc.add(value);
          }
        }
        listInfo.add(infoUserSnap);
      }
    }

    if (querySnapshot.docs.isNotEmpty) {
      lastDocument = querySnapshot.docs.last;
    }
    return listInfo;
  }

  @override
  Future<List<InfoUserMatchModel>> fetchFirstPage(
      InfoUserMatchModel userLogin) async {
    await checkNetwork();
    List<InfoUserMatchModel> listInfoUserMatch = await _fetchPage(userLogin);

    return listInfoUserMatch;
  }

  // Get data cần match
  @override
  Future<List<InfoUserMatchModel>> getDataMatch(
      InfoUserMatchModel userLogin) async {
    await checkNetwork();
    List<InfoUserMatchModel> listInfoUserMatchModel =
        await fetchFirstPage(userLogin);
    return listInfoUserMatchModel;
  }

  @override
  Future<void> matchUser(String uidAcc, User user, String uidMatch) async {
    await checkNetwork();
    final documentReference =
        firestore.collection(FirebaseCollection.users).doc(uidAcc);

    await documentReference.update({
      'users.$uidMatch': user.toJson(),
    });
  }
}
