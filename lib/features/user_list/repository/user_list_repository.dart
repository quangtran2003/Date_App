import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date/features/feature_src.dart';

part 'user_list_repository_impl.dart';

abstract class UserListRepository extends BaseFirebaseRepository {
  Stream<List<Chat>> getChatList();

  Future<void> acceptUserRequest(MapEntry<String, User> user);

  Future<void> removeUserRequest(MapEntry<String, User> user);
}
