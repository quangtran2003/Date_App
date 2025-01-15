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
        horizontal: AppDimens.defaultPadding,
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
    final allUsers = controller.userList.entries;
    final user = allUsers.elementAt(index);
    return InkWell(
      onTap: () {
        Get.toNamed(
          AppRoute.chat.path,
          arguments: UserChatArgument(
            uid: user.key,
            name: user.value.name,
            avatar: user.value.imgAvt,
          ),
        );
      },
      child: _buildUser(user.value),
    );
  }

  Widget _buildUser(User user) {
    return Column(
      children: [
        _buildUserAvatar(user.imgAvt),
        UtilWidget.buildText(
          user.name.length <= 8 ? user.name : '${user.name.substring(0, 8)}...',
          fontSize: AppDimens.fontSmall(),
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
