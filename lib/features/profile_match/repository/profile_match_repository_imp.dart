import 'package:easy_date/core/models/info_user_match_model.dart';
import 'package:easy_date/features/profile_match/repository/profile_match_repository.dart';

import '../../../core/const/const_src.dart';

class ProfileMatchRepositoryImp extends ProfileMatchRepository {
  @override
  Future<InfoUserMatchModel?> getUserMatch(String uid) async {
    await checkNetwork();
    InfoUserMatchModel? userMatchModel;
    final documentSnapshot = await firestore
        .collection(FirebaseCollection.users)
        .where("uid", isEqualTo: uid)
        .get();

    if (documentSnapshot.docs.isNotEmpty) {
      userMatchModel =
          InfoUserMatchModel.fromJson(documentSnapshot.docs.first.data());

      List<String> listImg = [];
      listImg = userMatchModel.imgDesc.split(',');
      for (var value in listImg) {
        userMatchModel.urlImgDesc.add(value);
      }

      return userMatchModel;
    }
    return null;
  }
}
