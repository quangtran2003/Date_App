part of 'home_repository.dart';

final class HomeRepositoryImpl extends HomeRepository {
  @override
  Stream<InfoUserMatchModel> getUserStream() {
    final docRef = firestore
        .collection(FirebaseCollection.users)
        .doc(firebaseAuth.currentUser?.uid);
    return docRef.snapshots().map((snapshot) {
      return InfoUserMatchModel.fromJson(snapshot.data() ?? {});
    });
  }

  @override
  Future<String?> getFirebaseMessagingToken(String uidUser) async {
    await firebaseMessage.getToken().then(
      (token) async {
        if (token != null) {
          firestore
              .collection(FirebaseCollection.users)
              .doc(uidUser)
              .update({'token': token});
          logger.d('token device: $token');
          return token;
        }
      },
    );
    return null;
  }

  @override
  Future<void> updateActiveStatus({
    required bool isOnline,
    required String uid,
  }) async {
    firestore.collection(FirebaseCollection.users).doc(uid).update({
      'isOnline': isOnline,
    });
  }
}
