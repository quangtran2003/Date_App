import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date/core/core_src.dart';
import 'package:easy_date/features/recent_chat/model/user_model.dart';

import 'recent_chat_repository.dart';

class RecentChatRepositoryImpl extends RecentChatRepository {
  late final _usersCollection = firestore.collection(FirebaseCollection.users);

  /// Get all users stream
  @override
  Stream<List<UserModel>> getUserStream() {
    return _usersCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return UserModel.fromJson(doc.data());
        }).toList();
      },
    );
  }

  /// Get users with pagination
  @override
  Future<(List<UserModel>, DocumentSnapshot?)> getUsers({
    DocumentSnapshot? lastDoc,
  }) async {
    await checkNetwork();

    Query query = _usersCollection.orderBy('email').limit(10);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final querySnapshot = await query.get();

    final newLastDoc =
        querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;

    final users =
        querySnapshot.docs.map((doc) => UserModel.fromDocument(doc)).toList();

    return (users, newLastDoc);
  }
}
