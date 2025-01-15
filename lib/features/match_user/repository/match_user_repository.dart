import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date/core/core_src.dart';

abstract class MatchUserRepository extends BaseFirebaseRepository {
  DocumentSnapshot? lastDocument;

  MatchUserRepository();

  Future<List<InfoUserMatchModel>> getDataMatch(InfoUserMatchModel userLogin);

  Future<List<InfoUserMatchModel>> fetchFirstPage(InfoUserMatchModel userLogin);

  // Future<List<InfoUserMatchModel>> fetchNextPage(InfoUserMatchModel userLogin);

  Future<void> matchUser(String uidAcc, User user, String uidMatch);
}
