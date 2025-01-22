import 'package:easy_date/core/core_src.dart';

import 'forgot_pass_repository.dart';

class ForgotPassRepositoryImpl extends ForgotPassRepository {
  @override
  Future<void> forgotPass({
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
