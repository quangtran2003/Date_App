import 'package:easy_date/core/core_src.dart';

abstract class ForgotPassRepository extends BaseFirebaseRepository {
  Future<void> forgotPass({required String email, required String password});
}
