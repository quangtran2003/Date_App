import 'package:easy_date/features/feature_src.dart';
import 'package:rxdart/rxdart.dart';

part 'user_list_controller_impl.dart';

abstract class UserListController extends BaseRefreshGetxController {
  final UserListRepository repository;

  UserListController({required this.repository});

  late final chatList = RxList<Chat>();

  late final listStatus = Get.arguments as MatchEnum? ?? MatchEnum.accept;

  late final homeController = Get.find<HomeController>();

  bool get isBlockList => listStatus == MatchEnum.block;

  bool get isAcceptList => listStatus == MatchEnum.accept;

  bool get isWaitingList => listStatus == MatchEnum.waiting;

  bool get hasAcceptUsers => isAcceptList && userList.isNotEmpty;

  Map<String, User> get userList;

  List<Chat> filterChatList(List<Chat> chats);

  Future<void> acceptUserRequest(MapEntry<String, User> user);

  Future<void> removeUserRequest(MapEntry<String, User> user);
}
