import 'package:easy_date/core/core_src.dart';

part 'home_repository_impl.dart';

sealed class HomeRepository extends BaseFirebaseRepository {
  Future<InfoUserMatchModel?> getUser();
  Stream<InfoUserMatchModel> getUserStream();
}
