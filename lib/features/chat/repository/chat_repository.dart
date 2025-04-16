import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date/features/feature_src.dart';

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

  Future<void> pushNoti({
    required PushNotificationModel notiModel,
    required String authToken,
  });
  Future<String?> getDeviceReceiverToken(String uid);
}
