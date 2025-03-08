import 'package:easy_date/core/core_src.dart';
import 'package:easy_date/utils/logger.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

part 'home_repository_impl.dart';

sealed class HomeRepository extends BaseFirebaseRepository {
  Stream<InfoUserMatchModel> getUserStream();
}
