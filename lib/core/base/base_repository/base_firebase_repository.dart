import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date/core/base/base_repository/base_repository.dart';
import 'package:easy_date/core/const/firebase_collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../utils/utils_src.dart';

abstract class BaseFirebaseRepository extends BaseRepository {
  late final firebaseAuth = FirebaseAuth.instance;
  late final firestore = FirebaseFirestore.instance;
  late final storage = FirebaseStorage.instance;
  late final firebaseMessage = FirebaseMessaging.instance;

  @override
  Future<void> checkNetwork() async {
    return NetworkUtil.checkNetwork();
  }

  Future<void> updateUserOnlineStatus({
    required bool isOnline,
    required String uid,
  }) async {
    logger.d(FieldValue.serverTimestamp());
    firestore.collection(FirebaseCollection.users).doc(uid).update({
      'isOnline': isOnline,
      'lastOnline': FieldValue.serverTimestamp(),
    });
    final querySnapshot =
        await firestore.collection(FirebaseCollection.users).get();

    for (final doc in querySnapshot.docs) {
      final data = doc.data();

      // Kiểm tra nếu trong map 'users' có key là uid đang đăng nhập
      if (data.containsKey('users') && data['users'][uid] != null) {
        await firestore.collection('users').doc(doc.id).update({
          'users.$uid.isOnline': isOnline,
          'users.$uid.lastOnline': FieldValue.serverTimestamp(),
        });
      }
    }
  }
}
