import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../utils/utils_src.dart';
import '../../core_src.dart';

abstract class BaseFirebaseRepository {
  late final firebaseAuth = FirebaseAuth.instance;
  late final firestore = FirebaseFirestore.instance;
  late final storage = FirebaseStorage.instance;
  late final firebaseMessage = FirebaseMessaging.instance;

  Future<void> checkNetwork() async {
    return NetworkUtil.checkNetwork();
  }

  Future<void> getFirebaseMessagingToken(Rxn<InfoUserMatchModel> user) async {
    await firebaseMessage.requestPermission();
    await firebaseMessage.getToken().then(
      (token) {
        if (token != null) {
          user.value?.token = token;
          logger.d('Push Token: $token');
        }
      },
    );
  }

  Future<void> updateActiveStatus({
    required bool isOnline,
    required String uid,
    required String token,
  }) async {
    firestore.collection('users').doc(uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': token,
    });
  }
}
