import 'dart:io';
import 'package:mime/mime.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../feature_src.dart';

const avatarPostfix = "_avatar";

class ProfileRepositoryImpl extends ProfileRepository {
  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<String> uploadAvatar(String path) async {
    await checkNetwork();

    // Delete old avatar, avatar will be stored with name: uid_avatar
    final oldImages =
        await storage.ref().child(firebaseAuth.currentUser!.uid).listAll();
    for (final img in oldImages.items) {
      if (storage.ref(img.fullPath).fullPath.endsWith(avatarPostfix)) {
        await img.delete();
        break;
      }
    }

    final ref = storage.ref().child(
        "${firebaseAuth.currentUser!.uid}/${IdGenerator.generate()}$avatarPostfix");
    final uploadTask = ref.putFile(
      File(path),
      SettableMetadata(contentType: lookupMimeType(path)),
    );
    final snapshot = await uploadTask;
    return snapshot.ref.getDownloadURL();
  }

  @override
  Future<void> updateAvatarUrl(String url) async {
    await checkNetwork();
    await firestore
        .collection(FirebaseCollection.users)
        .doc(firebaseAuth.currentUser!.uid)
        .update({"imgAvt": url});
  }

  @override
  Stream<UserModel> getUserStream() {
    return firestore
        .collection(FirebaseCollection.users)
        .doc(firebaseAuth.currentUser!.uid)
        .snapshots()
        .map((doc) => UserModel.fromDocument(doc));
  }

  @override
  void updateUser(
    InfoUserMatchModel model,
    String imgAvt,
  ) {
    for (final userId in model.users.keys) {
      // 1: Tìm ra từng user với userId
      // 2: Update thông tin map users của user đó với thông tin user mới hiện tại
      firestore.collection(FirebaseCollection.users).doc(userId).update(
        {
          "users.${model.uid}.imgAvt": imgAvt,
        },
      ).onError(
        (error, stackTrace) {
          logger.e(error);
        },
      );
    }
  }
}
