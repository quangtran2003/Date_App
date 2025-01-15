import 'package:easy_date/core/core_src.dart';

abstract class RegisterRepository extends BaseFirebaseRepository {
  Future<void> register({required String email, required String password});
}
