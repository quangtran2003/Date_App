import '../../../core/core_src.dart';

abstract class LoginRepository extends BaseFirebaseRepository {
  Future<void> logout();
  Future<void> login({required String email, required String password});
  Future<InfoUserMatchModel> getUser();
}
