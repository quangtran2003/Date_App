import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../utils/utils_src.dart';

abstract class BaseFirebaseRepository {
  late final firebaseAuth = FirebaseAuth.instance;
  late final firestore = FirebaseFirestore.instance;
  late final storage = FirebaseStorage.instance;

  Future<void> checkNetwork() async {
    return NetworkUtil.checkNetwork();
  }
}
