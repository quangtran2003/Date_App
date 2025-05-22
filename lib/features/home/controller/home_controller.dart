import 'package:easy_date/core/core_src.dart';
import 'package:easy_date/features/chat_bot/controller/chat_bot_controller.dart';
import 'package:easy_date/features/chat_bot/ui/chat_bot_page.dart';
import 'package:easy_date/features/home/home_src.dart';
import 'package:easy_date/features/video_call/model/call_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import '../../../utils/utils_src.dart';

class HomeController extends BaseGetxController {
  final HomeRepository homeRepository;

  HomeController({required this.homeRepository});

  final currentPageIndex = 0.obs;
  final pageController = PageController();
  late final currentUser = Rxn<InfoUserMatchModel>();

  /// Nếu cần lắng nghe sự thay đổi của user, dùng `userStream` thay vì `currentUser`
  /// vì BehaviorSubject khi lắng nghe sẽ nhận được giá trị cuối cùng của stream
  late final userStream = BehaviorSubject<InfoUserMatchModel?>.seeded(null);

  bool _hasHandledUserChange = false;
  DateTime? _currentBackPressTime;
  final RxBool canPop = false.obs;

  @override
  void onInit() async {
    super.onInit();
    if (Get.isRegistered<CallArgs>() &&
        Get.find<CallArgs>().isFromTerminatedState) {
      await initBeforeFirstFrame();
    }
    userStream.addStream(homeRepository.getUserStream());
    currentUser.bindStream(userStream);
    //getUserCurrent();
    ever(
      currentUser,
      (user) async {
        if (!_hasHandledUserChange && user != null) {
          _hasHandledUserChange = true;
          //userStream.add(user);
          await Future.wait([
            homeRepository.getFirebaseMessagingToken(user.uid),
            homeRepository.updateUserOnlineStatus(
              isOnline: true,
              uid: user.uid,
            ),
          ]);
        }
      },
    );
  }

  @override
  void onClose() async {
    pageController.dispose();
    await userStream.drain();
    userStream.close();
    super.dispose();
  }

  void gotoChatBot() {
    Get.to(
      const ChatBotPage(),
    )?.then(
      (value) => Get.find<ChatBotController>().messageList.forEach(
        (element) {
          element.hasAnimated = false;
        },
      ),
    );
  }

  void selectPage(int index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (_currentBackPressTime == null ||
        now.difference(_currentBackPressTime ?? DateTime.now()) >
            const Duration(seconds: 2)) {
      _currentBackPressTime = now;
      Fluttertoast.showToast(msg: AppStr.exitApp.tr);
      return Future.value(false);
    }
    SystemNavigator.pop();
    return Future.value(true);
  }
}
