part of 'user_list_repository.dart';

class UserListRepositoryImpl extends UserListRepository {
  late final String _userId = firebaseAuth.currentUser?.uid ?? '';

  @override
  Stream<List<Chat>> getChatList() {
    final query = firestore
        .collection(FirebaseCollection.chats)
        .where(FirebaseCollection.users, arrayContains: _userId)
        // Lọc các document trong collection "chats" mà trường "users" chứa `_userId`
        // Điều này có nghĩa là lấy tất cả các cuộc trò chuyện mà người dùng `_userId` đang tham gia
        .orderBy('lastMessageTime', descending: true)
        // Sắp xếp kết quả theo "lastMessageTime" giảm dần (cuộc trò chuyện mới nhất sẽ ở đầu danh sách)
        .snapshots();
    return query.map(
      (snapshot) => List.from(
        snapshot.docs.map(
          (doc) => Chat.fromJson(
            doc.data(),
            ChatMessage.fromJson(doc.data()['lastMessage'], _userId),
          ),
        ),
      ),
    );
  }

  @override
  Future<void> acceptUserRequest(MapEntry<String, User> user) async {
    await checkNetwork();
    return firestore.collection(FirebaseCollection.users).doc(_userId).update({
      "users.${user.key}": User(
        uid: user.value.uid,
        name: user.value.name,
        imgAvt: user.value.imgAvt,
        createTime: user.value.createTime,
        updateTime: user.value.updateTime,
        status: MatchEnum.accept.value,
      ).toJson(),
    });
  }

  @override
  Future<void> removeUserRequest(MapEntry<String, User> user) async {
    await checkNetwork();
    final collection = firestore.collection(FirebaseCollection.users);
    collection.doc(user.key).update({"users.$_userId": FieldValue.delete()});
    collection.doc(_userId).update({"users.${user.key}": FieldValue.delete()});
  }
}
