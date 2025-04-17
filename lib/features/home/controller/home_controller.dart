import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date/core/core_src.dart';
import 'package:easy_date/features/chat_bot/controller/chat_bot_controller.dart';
import 'package:easy_date/features/chat_bot/ui/chat_bot_page.dart';
import 'package:easy_date/features/home/home_src.dart';
import 'package:easy_date/utils/widgets/bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  @override
  void onInit() async {
    super.onInit();
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

  void getUserCurrent() {
    FirebaseFirestore.instance
        .collection(FirebaseCollection.users)
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .listen(
      (snapshot) {
        if (snapshot.exists) {
          currentUser.value = InfoUserMatchModel.fromJson(
            snapshot.data() ?? {},
          );
        } else {
          currentUser.value = null;
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
    Get.bottomSheet(
      isScrollControlled: true,
      SDSBottomSheet(
        noAppBar: true,
        isMiniSize: true,
        isHeightMin: false,
        miniSizeHeight: Get.height * 0.7,
        title: 'GEMINI',
        paddingPage: AppDimens.paddingZero,
        padding: AppDimens.paddingZero,
        body: const ChatBotPage(),
      ),
    ).then(
      (value) => Get.find<ChatBotController>().messageList.forEach(
        (element) {
          element.hasAnimated = false;
          element.images.clear();
        },
      ),
    );
  }

  void selectPage(int index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }
}
