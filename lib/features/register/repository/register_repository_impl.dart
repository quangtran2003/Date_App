import 'package:easy_date/core/core_src.dart';

import 'register_repository.dart';

class RegisterRepositoryImpl extends RegisterRepository {
  @override
  Future<void> register({
    required String email,
    required String password,
  }) async {
    await checkNetwork();

    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await userCredential.user?.sendEmailVerification();

    // Save user info in a separate doc
    await firestore
        .collection(FirebaseCollection.users)
        .doc(userCredential.user!.uid)
        .set(
      {
        "uid": userCredential.user!.uid,
        "email": email,
      },
    );
  }
}
