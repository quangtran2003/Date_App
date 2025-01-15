import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';

import '../../feature_src.dart';

class ProfileDetailRepositoryImpl extends ProfileDetailRepository {
  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<String> uploadAvatar(String path) async {
    await checkNetwork();
    // final image = await ImageUtil.compressImage(
    //   bytes: await File(path).readAsBytes(),
    //   maxWidth: 200,
    // );

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
        .update({"avatar": url});
  }

  @override
  Future<String> uploadImage(String path) async {
    await checkNetwork();
    // final image = await ImageUtil.compressImage(
    //   bytes: await File(path).readAsBytes(),
    //   maxWidth: 720,
    // );

    final ref = storage.ref().child(
        "${firebaseAuth.currentUser!.uid}/${IdGenerator.generate()}_profile");
    final uploadTask = ref.putFile(
      File(path),
      SettableMetadata(contentType: lookupMimeType(path)),
    );
    final snapshot = await uploadTask;
    return snapshot.ref.getDownloadURL();
  }

  @override
  Future<void> updateInfo(ProfileDetailRequest model) async {
    await checkNetwork();
    final documentReference =
        firestore.collection(FirebaseCollection.users).doc(model.uid);
    await documentReference.update(model.toJson());
  }

  @override
  Future<void> deleteImage(List<String> listImgUrl) async {
    // Delete old avatar, avatar will be stored with name: uid_avatar
    final oldImages =
        await storage.ref().child(firebaseAuth.currentUser!.uid).listAll();

    // oldImages.items.first.storage.

    final imageToDeletes = oldImages.items
        .where((e) =>
            shouldDelete(listImgUrl, e.fullPath) &&
            !e.fullPath.endsWith(avatarPostfix))
        .toList();

    for (final item in imageToDeletes) {
      await item.delete();
    }
  }

  bool shouldDelete(List<String> listImgUrl, String fullPath) {
    for (final img in listImgUrl) {
      if (img.contains(Uri.encodeComponent(fullPath))) {
        return false;
      }
    }

    return true;
  }

  @override
  void updateUser(
    InfoUserMatchModel model,
    ProfileDetailRequest request,
  ) {
    for (final userId in model.users.keys) {
      // 1: Tìm ra từng user với userId
      // 2: Update thông tin map users của user đó với thông tin user mới hiện tại
      firestore.collection(FirebaseCollection.users).doc(userId).update(
        {
          "users.${request.uid}.name": request.name,
        },
      ).onError(
        (error, stackTrace) {
          logger.e(error);
        },
      );
    }
  }
}
