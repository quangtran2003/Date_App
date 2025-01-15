import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date/core/base/base_repository/base_firebase_repository.dart';
import 'package:easy_date/features/chat/model/chat_message.dart';

import '../model/block_user_request.dart';
import '../model/message_type.dart';

abstract class ChatRepository extends BaseFirebaseRepository {
  String get userId;

  Stream<List<ChatMessage>> getNewMessageStream({
    required String receiverId,
    DocumentSnapshot<Object?>? firstDoc,
  });

  Future<void> createMessage({
    required String receiverId,
    required String message,
    required MessageType type,
  });

  Future<(List<ChatMessage>, DocumentSnapshot?, DocumentSnapshot?)>
      getOldMessages({
    required String receiverId,
    DocumentSnapshot? lastDoc,
  });

  /// Current user block other user
  Future<void> blockUser({
    required BlockUserRequest current,
    required BlockUserRequest other,
  });
}
