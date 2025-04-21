import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date/features/feature_src.dart';
import 'package:easy_date/features/match_user/match_user_src.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:heart_overlay/heart_overlay.dart';

class MatchUserController extends BaseGetxController {
  MatchUserController({required this.matchUserRepository});

  final CardSwiperController cardSwiperController = CardSwiperController();

  RxList<InfoUserMatchModel> listInfoUserMatchModel =
      <InfoUserMatchModel>[].obs;

  final MatchUserRepository matchUserRepository;

  RxDouble ratioIconLeft = (1.0).obs;

  RxDouble ratioIconRight = 1.0.obs;

  double directionSwipe = -1; // 0: trái, 1 phải

  RxInt indexCard = 0.obs;

  late InfoUserMatchModel userMatchView;

  HomeController homeController = Get.find();

  final heartOverlayController = HeartOverlayController();

  @override
  Future<void> onInit() async {
    await getDataMatch();

    super.onInit();
  }

  Future<void> getDataMatch() async {
    showLoading();

    if (homeController.currentUser.value != null) {
      try {
        await getDataInit();
      } catch (e, s) {
        handleException(e, stackTrace: s);
      } finally {
        hideLoading();
      }
    }
  }

  Future<void> getDataInit() async {
    listInfoUserMatchModel.value = await matchUserRepository
        .fetchFirstPage(homeController.currentUser.value!);
    if (listInfoUserMatchModel.isNotEmpty) {
      userMatchView = listInfoUserMatchModel[0];
    }
  }

  Future<bool> onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) async {
    indexCard.value = currentIndex ?? previousIndex + 1;

    if (direction == CardSwiperDirection.right) {
      heartFly();
      matchUser(userMatchView);
    } else {
      skipUser(userMatchView);
    }

    if (currentIndex == null) {
      return false;
    }
    // loadMore();
    if (listInfoUserMatchModel.isNotEmpty &&
        indexCard.value < listInfoUserMatchModel.length) {
      userMatchView = listInfoUserMatchModel[indexCard.value];
    }
    setRatioIcon();
    return true;
  }

  void heartFly() {
    for (int i = 0; i < 40; i++) {
      Offset offset = Offset(
        // DX
        Random().nextDouble() * Get.width,
        // DY
        Random().nextDouble() * Get.height, // - 100 is for the button padding
      );

      heartOverlayController.showIcon(
        offset: offset,
      );
    }
  }

  void setRatioIcon() {
    ratioIconLeft.value = 1.0;
    ratioIconRight.value = 1.0;
    directionSwipe = -1;
  }

  void setSwipe(CardSwiperDirection horizontalDirection) {
    if (horizontalDirection == CardSwiperDirection.left) {
      if (directionSwipe == 1) {
        setRatioIcon();
      }
      directionSwipe = 0;
      if (110 * ratioIconLeft.value <= 230) {
        ratioIconLeft.value = ratioIconLeft.value + 0.098;
      }
      if (ratioIconRight.value > 0.1) {
        ratioIconRight.value = ratioIconRight.value - 0.098;
      } else {
        ratioIconRight.value = 0.1;
      }
    } else if (horizontalDirection == CardSwiperDirection.right) {
      if (directionSwipe == 0) {
        setRatioIcon();
      }
      directionSwipe = 1;
      if (110 * ratioIconRight.value <= 230) {
        ratioIconRight.value = ratioIconRight.value + 0.098;
      }
      if (ratioIconLeft.value > 0.1) {
        ratioIconLeft.value = ratioIconLeft.value - 0.098;
      } else {
        ratioIconLeft.value = 0.1;
      }
    }
  }

  Future<void> skipUser(
    InfoUserMatchModel infoUserMatchModel,
  ) async {
    String uidAcc = matchUserRepository.firebaseAuth.currentUser!.uid;
    User user = User(
        imgAvt: infoUserMatchModel.imgAvt,
        createTime: Timestamp.now(),
        name: infoUserMatchModel.name,
        updateTime: Timestamp.now(),
        status: PairingStatusEnum.skip,
        uid: infoUserMatchModel.uid);
    try {
      await matchUserRepository.matchUser(uidAcc, user, infoUserMatchModel.uid);
    } catch (e, s) {
      handleException(e, stackTrace: s);
    }
  }

  Future<void> matchUser(InfoUserMatchModel infoUserMatch) async {
    if (homeController.currentUser.value != null) {
      InfoUserMatchModel userModel = homeController.currentUser.value!;

      // Gửi yêu cầu cảu tài khoản đang đaăng nhập đến người B
      String uidAcc = matchUserRepository.firebaseAuth.currentUser!.uid;
      User userAcc = User(
        imgAvt: infoUserMatch.imgAvt,
        createTime: Timestamp.now(),
        name: infoUserMatch.name,
        updateTime: Timestamp.now(),
        status: PairingStatusEnum.request,
        uid: infoUserMatch.uid,
      );

      // Người B nhận yêu cầu từ tài khoản này
      User userMatch = User(
        imgAvt: userModel.imgAvt,
        createTime: Timestamp.now(),
        name: userModel.name,
        updateTime: Timestamp.now(),
        status: PairingStatusEnum.waiting,
        uid: userModel.uid,
      );

      try {
        await Future.wait([
          // thêm vào thằng tài khoản đang đăng nhập
          matchUserRepository.matchUser(uidAcc, userAcc, infoUserMatch.uid),

          // thêm vào tài khoản được match
          matchUserRepository.matchUser(
              infoUserMatch.uid, userMatch, userModel.uid),
        ]);
      } catch (e, s) {
        handleException(e, stackTrace: s);
      }
    } else {
      listInfoUserMatchModel.value = [];
    }
  }
}
