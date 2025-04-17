part of 'home_repository.dart';

final class HomeRepositoryImpl extends HomeRepository {
  @override
  Stream<InfoUserMatchModel?> getUserStream() {
    final userId = firebaseAuth.currentUser?.uid;
    if (userId == null) {
      // Nếu chưa đăng nhập thì trả về Stream.empty() luôn cho an toàn
      return Stream.value(null);
    }

    final docRef = firestore.collection(FirebaseCollection.users).doc(userId);

    return docRef.snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) {
        // Nếu document chưa tồn tại, trả về InfoUserMatchModel rỗng
        return (null);
      }
      return InfoUserMatchModel.fromJson(data);
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
  Future<void> updateUserOnlineStatus({
    required bool isOnline,
    required String uid,
  }) async {
    firestore.collection(FirebaseCollection.users).doc(uid).update({
      'isOnline': isOnline,
    });
    final querySnapshot =
        await firestore.collection(FirebaseCollection.users).get();

    for (final doc in querySnapshot.docs) {
      final data = doc.data();

      // Kiểm tra nếu trong map 'users' có key là uid đang đăng nhập
      if (data.containsKey('users') && data['users'][uid] != null) {
        await firestore.collection('users').doc(doc.id).update({
          'users.$uid.isOnline': isOnline,
        });
      }
    }
  }
}
