import 'package:easy_date/core/base/base_repository/base_firebase_repository.dart';

import '../../../core/models/models_src.dart';

abstract class ProfileMatchRepository extends BaseFirebaseRepository {


  Future<InfoUserMatchModel?> getUserMatch(String uid);

}
