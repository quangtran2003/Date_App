import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date/core/base/base_repository/base_repository.dart';
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
}
