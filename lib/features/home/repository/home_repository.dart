import 'package:easy_date/core/core_src.dart';
import 'package:easy_date/utils/logger.dart';

part 'home_repository_impl.dart';

sealed class HomeRepository extends BaseFirebaseRepository {
  Stream<InfoUserMatchModel> getUserStream();
  Future<void> updateActiveStatus({
    required bool isOnline,
    required String uid,
  });
    Future<String?> getFirebaseMessagingToken(String uidUser);
}
