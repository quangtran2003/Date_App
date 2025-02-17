import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date/features/home/controller/home_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../utils/utils_src.dart';

abstract class BaseFirebaseRepository {
  late final firebaseAuth = FirebaseAuth.instance;
  late final firestore = FirebaseFirestore.instance;
  late final storage = FirebaseStorage.instance;
  late final firebaseMessage = FirebaseMessaging.instance;

  Future<void> checkNetwork() async {
    return NetworkUtil.checkNetwork();
  }
  Future<void>getToken()async{
await firebaseMessage.requestPermission();
await firebaseMessage.getToken().then((token) {
  Get.find<HomeController>().currentUser.to;
});
  }
}
