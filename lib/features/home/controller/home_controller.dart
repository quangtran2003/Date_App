import 'dart:developer';

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

  @override
  void onInit() async {
    super.onInit();
    showLoading();
try {
      var firebaseAuth = FirebaseAuth.instance;
      if (firebaseAuth.currentUser == null) {
        logger.e("User chưa đăng nhập!");
        return;
      }

      logger.d("Lấy dữ liệu từ Firestore...");

      final stream = homeRepository.getUserStream();

      await userStream.addStream(stream);
      logger.d("Đã thêm stream vào userStream");

      userStream.listen((data) {
        logger.d("User stream cập nhật: ${data?.name}");
      }, onError: (error) {
        logger.e("Lỗi stream: $error");
      });
    } catch (e, stack) {
      logger.e("Lỗi trong quá trình thêm stream", error: e, stackTrace: stack);
    }


    log("vao home");
    await homeRepository.getFirebaseMessagingToken(currentUser);

  //  await userStream.addStream(homeRepository.getUserStream());
    logger.d(currentUser);

    currentUser.bindStream(userStream);

    logger.d(currentUser);
    await Future.wait([
      homeRepository.updateActiveStatus(
        isOnline: true,
        token: userStream.value?.token ?? '',
        uid: userStream.value?.uid ?? '',
      ),
    ]);
    hideLoading();
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
