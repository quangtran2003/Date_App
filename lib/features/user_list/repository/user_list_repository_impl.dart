part of 'user_list_repository.dart';

class UserListRepositoryImpl extends UserListRepository {
  late final String _userId = firebaseAuth.currentUser?.uid ?? '';

  @override
  Stream<List<Chat>> getChatList() {
    final query = firestore
        .collection(FirebaseCollection.chats)
        .where(FirebaseCollection.users, arrayContains: _userId)
        .orderBy('lastMessageTime', descending: true)
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
        token: user.value.token,
        lastOnline: user.value.lastOnline,
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
