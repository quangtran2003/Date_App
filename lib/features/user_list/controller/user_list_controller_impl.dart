part of 'user_list_controller.dart';

class UserListControllerImpl extends UserListController {
  UserListControllerImpl({required super.repository});

  @override
  void onInit() async {
    super.onInit();
    if (listStatus == MatchEnum.accept) {
      chatList.bindStream(chatListStream());
    }
  }

  @override
  Future<void> onLoadMore() async {}

  @override
  Future<void> onRefresh() async {}

  @override
  Map<String, User> get userList {
    final allUsers = homeController.currentUser.value?.users ?? {};
    final matchedUsers = allUsers.entries.where(
      (user) => user.value.status == listStatus.value,
    );
    return {for (final user in matchedUsers) user.key: user.value};
  }

  @override
  List<Chat> filterChatList(List<Chat> chats) {
    return List.from(
      chats.where((chat) {
        final users = chat.users ?? [];
        return users.any((userId) =>
           userList.containsKey(userId),
        );
      }),
    );
  }

  @override
  Future<void> acceptUserRequest(MapEntry<String, User> user) async {
    try {
      final currentUser = homeController.currentUser.value;
      if (currentUser == null) return;
      await repository.acceptUserRequest(user);
      await repository.firestore
          .collection(FirebaseCollection.users)
          .doc(user.key)
          .update({
        "users.${currentUser.uid}": User(
          uid: currentUser.uid,
          name: currentUser.name,
          imgAvt: currentUser.imgAvt,
          createTime: currentUser.createTime,
          updateTime: currentUser.updateTime,
          status: MatchEnum.accept.value,
          token: currentUser.token,
          lastOnline: currentUser.lastOnline,
        ).toJson(),
      });
      final params = {'username': user.value.name};
      showSnackBar(LocaleKeys.user_acceptUser.trParams(params).tr);
    } catch (e) {
      handleException(e);
    }
  }

  @override
  Future<void> removeUserRequest(MapEntry<String, User> user) async {
    try {
      await repository.removeUserRequest(user);
      final params = {'username': user.value.name};
      showSnackBar(
        switch (listStatus) {
          MatchEnum.block => LocaleKeys.user_unblockUser.trParams(params).tr,
          MatchEnum.waiting => LocaleKeys.user_rejectUser.trParams(params).tr,
          _ => LocaleKeys.profileDetail_updateSuccess.tr,
        },
      );
    } catch (e) {
      handleException(e);
    }
  }

  Stream<List<Chat>> chatListStream() {
    return CombineLatestStream.combine2(
      repository.getChatList(),
      homeController.userStream,
      (chats, useMatch) {
        final users = useMatch?.users;
        if (users == null || users.isEmpty) return [];

        final filteredChats = chats
            .where((chat) =>
                chat.users
                    ?.any((uid) => users[uid]?.status == listStatus.value) ??
                false)
            .toList();

        return filteredChats;
      },
    );
  }
}
