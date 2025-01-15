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
}
