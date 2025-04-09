part of 'home_repository.dart';

final class HomeRepositoryImpl extends HomeRepository {
  @override
  Future<InfoUserMatchModel?> getUser() async {
    final docRef = await firestore
        .collection(FirebaseCollection.users)
        .doc(firebaseAuth.currentUser?.uid)
        .get();
    return docRef.exists ? InfoUserMatchModel.fromJsonDoc(docRef) : null;
  }

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
