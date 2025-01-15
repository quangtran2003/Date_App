import 'package:easy_date/core/core_src.dart';

part 'home_repository_impl.dart';

sealed class HomeRepository extends BaseFirebaseRepository {
  Stream<InfoUserMatchModel> getUserStream();
}
