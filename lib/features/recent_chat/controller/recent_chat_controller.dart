import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../core/core_src.dart';
import '../model/model_src.dart';
import '../repository/recent_chat_repository.dart';

class RecentChatController extends BaseRefreshGetxController {
  final RecentChatRepository recentChatRepository;

  DocumentSnapshot? lastUserDoc;
  final users = <UserModel>[].obs;

  RecentChatController({
    required this.recentChatRepository,
  });

  @override
  Future<void> onInit() async {
    super.onInit();
    // users.bindStream(recentChatRepository.getUserStream());
    showLoading();
    await getUsers();
    hideLoading();
  }

  Future<void> getUsers({bool isLoadMore = false}) async {
    try {
      final (newUsers, newLastDoc) =
          await recentChatRepository.getUsers(lastDoc: lastUserDoc);

      if (isLoadMore) {
        users.addAll(newUsers);
      } else {
        users.value = newUsers;
      }

      if (newLastDoc != null) {
        // Khi load hết dữ liệu newLastDoc sẽ null, nếu không check null và gán lại luôn
        // thì sẽ load lại từ page đầu
        lastUserDoc = newLastDoc;
      }
    } catch (e, stackTrace) {
      handleException(e, stackTrace: stackTrace);
    }
  }

  @override
  Future<void> onLoadMore() async {
    await getUsers(isLoadMore: true);
    refreshController.loadComplete();
  }

  @override
  Future<void> onRefresh() async {
    showLoading();
    lastUserDoc = null;
    await getUsers();
    refreshController.refreshCompleted();
    hideLoading();
  }
}
