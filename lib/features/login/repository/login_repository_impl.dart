import '../../../core/core_src.dart';
import 'login_repository.dart';

class LoginRepositoryImpl extends LoginRepository {
  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> login({required String email, required String password}) async {
    await checkNetwork();
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (userCredential.user?.emailVerified == false) {
      throw EmailNotVerifiedException();
    }
  }

  @override
  Future<InfoUserMatchModel> getUser() async {
    await checkNetwork();
    final docRef = firestore
        .collection(FirebaseCollection.users)
        .doc(firebaseAuth.currentUser?.uid);

    return InfoUserMatchModel.fromJson((await docRef.get()).data() ?? {});
  }
}

class EmailNotVerifiedException implements Exception {
  EmailNotVerifiedException();
}
