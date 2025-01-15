import 'package:easy_date/core/core_src.dart';

abstract class UsersSuggestRepository extends BaseFirebaseRepository {
  Future<InfoUserMatchModel?> getUserSuggest();
}
