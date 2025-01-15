part of 'component_src.dart';

class VerticalListView extends BaseGetWidget<UserListController> {
  final String? tagKey;

  const VerticalListView({super.key, this.tagKey});

  @override
  String? get tag => tagKey;

  @override
  Widget buildWidgets(BuildContext context) {
    return baseShowLoading(() {
      if (controller.isAcceptList) {
        return Obx(_buildChatList);
      }
      return Obx(_buildUserList);
    });
  }

  Widget _buildChatList() {
    if (controller.chatList.isEmpty) {
      return const BaseListEmpty();
    }
    return ListView.builder(
      itemBuilder: _buildChatItem,
      itemCount: controller.chatList.length,
    );
  }

  Widget _buildUserList() {
    if (controller.userList.isEmpty) {
      return const BaseListEmpty();
    }
    return ListView.builder(
      itemBuilder: _buildUserItem,
      itemCount: controller.userList.length,
    );
  }

  Widget _buildUserName(String? name) {
    return UtilWidget.buildText(
      name ?? '',
      fontSize: AppDimens.fontSmall(),
      fontWeight: FontWeight.bold,
    );
  }

  Widget _buildUserItem(BuildContext context, int index) {
    final user = controller.userList.entries.elementAt(index);
    return ListTile(
      title: _buildUserName(user.value.name),
      leading: _buildUserAvatar(user.value.imgAvt),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton.filledTonal(
            onPressed: () => controller.removeUserRequest(user),
            icon: const Icon(Icons.close),
          ),
          Visibility(
            visible: controller.isWaitingList,
            child: IconButton.filledTonal(
              onPressed: () => controller.acceptUserRequest(user),
              icon: const Icon(Icons.check),
            ),
          ),
        ],
      ),
      onTap: controller.isBlockList
          ? null
          : () {
              Get.toNamed(
                AppRoute.profile_match.path,
                arguments: user.value.uid,
              );
            },
    );
  }

  Widget _buildChatItem(BuildContext context, int index) {
    final chat = controller.chatList[index];
    final lastMessage = chat.lastMessage;
    final lastTime = lastMessage?.createDate;
    var lastContent = lastMessage?.content ?? '';
    final user1 = controller.homeController.currentUser.value;
    final userId1 = user1?.uid;
    chat.users?.remove(userId1);
    final userId2 = chat.users?.last;
    final user2 = controller.userList[userId2];

    String getLastTime() {
      if (lastTime == null) return '';
      final now = DateTime.now();
      final isToday = now.year == lastTime.year &&
          now.month == lastTime.month &&
          now.day == lastTime.day;
      return convertDateToString(lastTime, isToday ? PATTERN_11 : PATTERN_2);
    }

    String getLastMessage() {
      lastContent = lastMessage?.type == MessageType.text
          ? lastContent
          : LocaleKeys.user_chatSticker.tr;
      return lastMessage?.isMe == false
          ? lastContent
          : LocaleKeys.user_chatSender.trParams({'content': lastContent});
    }

    if (user2 == null || userId2 == null) {
      return const SizedBox.shrink();
    }

    return ListTile(
      leading: _buildUserAvatar(user2.imgAvt),
      title: _buildUserName(user2.name),
      subtitle: Row(
        children: [
          Flexible(
            child: UtilWidget.buildText(getLastMessage()),
          ),
          const Icon(
            Icons.circle,
            size: AppDimens.padding2,
          ).paddingSymmetric(horizontal: AppDimens.padding6),
          UtilWidget.buildText(getLastTime()),
        ],
      ),
      onTap: () {
        Get.toNamed(
          AppRoute.chat.path,
          arguments: UserChatArgument(
            uid: userId2,
            name: user2.name,
            avatar: user2.imgAvt,
          ),
        )?.then((_) {
          // controller.chatList.refresh();
        });
      },
    );
  }
}
