import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date/core/core_src.dart';

import '../model/user_model.dart';

abstract class RecentChatRepository extends BaseFirebaseRepository {
  Stream<List<UserModel>> getUserStream();
  Future<(List<UserModel>, DocumentSnapshot?)> getUsers({
    DocumentSnapshot? lastDoc,
  });
}
