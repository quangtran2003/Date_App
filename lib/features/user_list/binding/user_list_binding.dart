import 'package:easy_date/features/user_list/user_list_src.dart';

class UserListBinding extends Bindings {
  final String? tag;

  UserListBinding({
    this.tag,
  });

  @override
  void dependencies() {
    Get.lazyPut<UserListController>(
      () => UserListControllerImpl(
        repository: Get.find<UserListRepository>(),
      ),
      tag: tag,
    );
  }
}
