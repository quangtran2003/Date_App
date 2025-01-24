
import 'forgot_pass_repository.dart';

class ForgotPassRepositoryImpl extends ForgotPassRepository {
  @override
  Future<void> forgotPass({
    required String email,
  }) async {
    await checkNetwork();
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
