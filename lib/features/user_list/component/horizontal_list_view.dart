part of 'component_src.dart';

class HorizontalListView extends BaseGetWidget<UserListController>
    implements PreferredSizeWidget {
  const HorizontalListView({super.key, this.tagKey});

  final String? tagKey;

  @override
  String? get tag => tagKey;

  @override
  Size get preferredSize => Size.fromHeight(Get.height / 11);

  @override
  Widget buildWidgets(BuildContext context) {
    return SizedBox.fromSize(
      size: preferredSize,
      child: Obx(_buildList),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingDefault,
      ),
      itemCount: controller.userList.length,
      itemBuilder: _buildTile,
      separatorBuilder: (_, __) {
        return SizedBox(
          width: preferredSize.height / 4,
        );
      },
    );
  }

  Widget _buildTile(BuildContext context, int index) {
    // Sắp xếp entries: user online lên trước
    final sortedUsers = controller.userList.entries.toList()
      ..sort((a, b) {
        // true -> false = -1 => true đứng trước
        if (a.value.isOnline == b.value.isOnline) return 0;
        return a.value.isOnline.value ? -1 : 1;
      });

    final user = sortedUsers[index];

    return InkWell(
      onTap: () {
        Get.toNamed(
          AppRouteEnum.chat.path,
          arguments: UserChatArgument(
            uid: user.key,
            name: user.value.name,
            avatar: user.value.imgAvt,
            lastOnline: user.value.lastOnline,
          )..isOnline.value = user.value.isOnline.value,
        );
      },
      child: _buildUser(user.value),
    );
  }

  Widget _buildUser(User user) {
    return Column(
      children: [
        buildUserAvatar(user.imgAvt, user.isOnline),
        UtilWidget.buildText(
          user.name.length <= 8 ? user.name : '${user.name.substring(0, 8)}...',
          fontSize: AppDimens.fontSmall(),
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
