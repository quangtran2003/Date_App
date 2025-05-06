import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date/features/feature_src.dart';

class ChatRepositoryImpl extends ChatRepository {
  late final _chatRoomsCollection =
      firestore.collection(FirebaseCollection.chats);

  @override
  String getChatRoomId(String senderId, String receiverId) {
    final ids = [senderId, receiverId];
    ids.sort();
    return ids.join('_');
  }

  @override
  Stream<List<ChatMessage>> getNewMessageStream({
    required String receiverId,
    DocumentSnapshot<Object?>? firstDoc,
  }) {
    final chatRoomId = getChatRoomId(userId, receiverId);

    final messagesCollection = _chatRoomsCollection
        .doc(chatRoomId)
        .collection(FirebaseCollection.messages);

    var query = messagesCollection.orderBy(
      "createTime",
      descending: false,
    );

    if (firstDoc != null) {
      // Với descending: false => Chỉ lấy những tin nhắn có timestamp lớn hơn timestamp của firstDoc
      query = query.startAfterDocument(firstDoc);
    }

    return query.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatMessage.fromDocument(doc, userId))
              .toList(),
        );
  }

  @override
  Future<
      (
        List<ChatMessage>,
        DocumentSnapshot<Object?>?,
        DocumentSnapshot<Object?>?
      )> getOldMessages({
    required String receiverId,
    DocumentSnapshot<Object?>? lastDoc,
  }) async {
    final chatRoomId = getChatRoomId(userId, receiverId);

    final messagesCollection = _chatRoomsCollection
        .doc(chatRoomId)
        .collection(FirebaseCollection.messages);

    var query = messagesCollection
        .orderBy(
          "createTime",
          descending: true,
        )
        .limit(10);

    if (lastDoc != null) {
      // Với descending: true => Chỉ lấy những tin nhắn có timestamp nhỏ hơn timestamp của lastDoc
      query = query.startAfterDocument(lastDoc);
    }

    final querySnapshot = await query.get();

    final newLastDoc =
        querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;

    final newFirstDoc = (lastDoc == null && querySnapshot.docs.isNotEmpty)
        ? querySnapshot.docs.first
        : null;

    final users = querySnapshot.docs
        .map((doc) => ChatMessage.fromDocument(doc, userId))
        .toList();

    return (users, newLastDoc, newFirstDoc);
  }

  @override
  Future<void> createMessage({
    required String receiverId,
    required String message,
    required MessageTypeEnum type,
  }) async {
    final chatRoomId = getChatRoomId(userId, receiverId);

    final mewMessage = ChatMessageRequest(
      content: message,
      senderId: userId,
      type: type,
    );

    await Future.wait([
      // Add new message to chat room
      _chatRoomsCollection
          .doc(chatRoomId)
          .collection(FirebaseCollection.messages)
          .add(mewMessage.toJson()),

      // Update last message in chat room
      _chatRoomsCollection.doc(chatRoomId).set(
        {
          "users": [userId, receiverId],
          "lastMessage": mewMessage.toJson(),
          "lastMessageTime": FieldValue.serverTimestamp(),
        },
      ),
    ]);
  }

  @override
  String get userId {
    return firebaseAuth.currentUser!.uid;
  }

  @override

  /// Current user block other user
  Future<void> blockUser({
    required BlockUserRequest current,
    required BlockUserRequest other,
  }) async {
    final currentUserRef =
        firestore.collection(FirebaseCollection.users).doc(current.uid);
    final otherUserRef =
        firestore.collection(FirebaseCollection.users).doc(other.uid);

    await Future.wait([
      currentUserRef.update({
        "users.${other.uid}": other.toJson(),
      }),
      otherUserRef.update({
        "users.${current.uid}": current.toJson(),
      }),
    ]);
  }

  @override
  Future<void> pushNoti({
    required PushNotificationMessage notiModel,
    required String authToken,
  }) async {
    final response = await Dio().post(
      ApiUrl.urlPushNoti,
      data: notiModel.toJson(),
      options: Options(
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        validateStatus: (status) => true, // Tạm để debug toàn bộ response
      ),
    );

    logger.d('Response: ${response.statusCode} ${response.data}');

    // await baseSendRequest(
    //   ApiUrl.urlPushNoti,
    //   RequestMethod.POST,
    //   jsonMap: notiModel.toJson(),
    //   authBearerToken: authToken,
    // );
  }

  @override
  Future<String?> getDeviceReceiverToken(String uid) async {
    final docSnapshot =
        await firestore.collection(FirebaseCollection.users).doc(uid).get();

    if (docSnapshot.exists) {
      return docSnapshot.data()?['token'] as String?;
    } else {
      return null;
    }
  }
}
