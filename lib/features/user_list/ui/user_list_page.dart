import 'package:easy_date/features/user_list/user_list_src.dart';

part 'user_list_widget.dart';

class UserListPage extends BaseGetWidget<UserListController> {
  final String? tagKey;
  const UserListPage({super.key, this.tagKey});

  @override
  String? get tag => tagKey;

  @override
  Widget buildWidgets(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: VerticalListView(tagKey: tagKey),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: UtilWidget.buildText(
        controller.listStatus.title,
        style: AppTextStyle.font18Bo,
      ),
      bottom: !controller.hasAcceptUsers
          ? null
          : HorizontalListView(tagKey: tagKey),
    );
  }
}
