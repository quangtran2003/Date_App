import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date/core/config_noti/fcm.dart';
import 'package:heart_overlay/heart_overlay.dart';
import 'package:vibration/vibration.dart';

import '../../feature_src.dart';
import '../../match_user/match_user_src.dart';

const heartText = '❤';
const heartAnimationDuration = Duration(milliseconds: 1500);

class ChatController extends BaseRefreshGetxController {
  final ChatRepository chatRepository;

  final currentUser = Get.find<HomeController>().currentUser;
  final receiverUser = Get.arguments as UserChatArgument;

  final messageTextCtrl = TextEditingController();
  final chatScrollController = ScrollController();

  final showSendButton = false.obs;

  bool canShowHeartOverlay = true;
  final heartOverlayController = HeartOverlayController();
  StreamSubscription<List<ChatMessage>>? lastMessageSub;

  ChatController({
    required this.chatRepository,
  });

  DocumentSnapshot? firstMessageDoc;
  DocumentSnapshot? lastMessageDoc;

  final oldMessages = <ChatMessage>[].obs;
  final newMessages = <ChatMessage>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    _listenHeartMessage();

    showLoading();
    await getOldMessages();

    newMessages.bindStream(
      chatRepository.getNewMessageStream(
        receiverId: receiverUser.uid,
        firstDoc: firstMessageDoc,
      ),
    );

    hideLoading();
  }

  void _listenHeartMessage() {
    lastMessageSub = newMessages.listen((messages) async {
      final lastMessage = messages.lastOrNull;
      if (lastMessage == null) {
        return;
      }
      if (canShowHeartOverlay &&
          lastMessage.type == MessageType.text &&
          lastMessage.content == heartText) {
        canShowHeartOverlay = false;
        heartFly();
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 20);
        }
        await Future.delayed(heartAnimationDuration);
        canShowHeartOverlay = true;
      }
    });
  }

  @override
  Future<void> onLoadMore() async {
    await getOldMessages(isLoadMore: true);
    refreshController.loadComplete();
  }

  @override
  Future<void> onRefresh() async {
    showLoading();
    lastMessageDoc = null;
    await getOldMessages();
    refreshController.refreshCompleted();
    hideLoading();
  }

  Future<void> getOldMessages({bool isLoadMore = false}) async {
    try {
      final (messages, newLastDoc, newFirstDoc) =
          await chatRepository.getOldMessages(
        receiverId: receiverUser.uid,
        lastDoc: lastMessageDoc,
      );

      if (isLoadMore) {
        oldMessages.addAll(messages);
      } else {
        firstMessageDoc = newFirstDoc;
        oldMessages.value = messages;
      }

      if (newLastDoc != null) {
        // Khi load hết dữ liệu newLastDoc sẽ null, nếu không check null và gán lại luôn
        // thì sẽ load lại từ page đầu
        lastMessageDoc = newLastDoc;
      }
    } catch (e, stackTrace) {
      handleException(e, stackTrace: stackTrace);
    }
  }

  Future<void> sendMessage({
    String? customMessage,
  }) async {
    try {
      final message = customMessage ?? messageTextCtrl.text.trim();
      if (message.isEmpty) {
        return;
      }

      messageTextCtrl.clear();
      showSendButton.value = false;

      await Future.wait([
        chatRepository.createMessage(
          receiverId: receiverUser.uid,
          message: message,
          type: MessageType.text,
        ),
        pushNotif(message),
      ]);

      _scrollToBottom();
    } catch (e) {
      handleException(e);
    }
  }

  Future<void> sendSticker(Sticker sticker) async {
    try {
      await chatRepository.createMessage(
        receiverId: receiverUser.uid,
        message: sticker.link,
        type: MessageType.sticker,
      );

      await pushNotif(sticker.link, isSticker: true);

      _scrollToBottom();
    } catch (e) {
      handleException(e);
    }
  }

  Future<void> pushNotif(
    String message, {
    bool isSticker = false,
  }) async {
    // Step 1: Get receiver's FCM token
    final receiverToken =
        await chatRepository.getDeviceReceiverToken(receiverUser.uid);
    if (receiverToken == null) return;

    // Step 2: Get server auth token
    final serverAuthToken = await FCM.getToken();
    if (serverAuthToken.isEmpty) return;

    logger.d('AuthToken: $serverAuthToken');

    // Step 3: Prepare notification data
    final notificationPayload = getNotifModel(
      isSticker,
      message,
      receiverToken,
    );

    // Step 4: Push to server
    await chatRepository.pushNoti(
      notiModel: notificationPayload,
      authToken: serverAuthToken,
    );
  }

  PushNotificationMessage getNotifModel(
    bool isSticker,
    String message,
    String receiverToken,
  ) {
    final data = PushNotificationData(
      pageName: AppRouteEnum.chat.path,
      uidUser: receiverUser.uid,
      nameUser: receiverUser.name,
      imgUser: receiverUser.avatar,
      notifTitle: currentUser.value?.name ?? 'Người dùng Easy Date',
      notifBody: isSticker ? 'Đã gửi một nhãn dán!' : message,
    );
    return PushNotificationMessage(
      data: data,
      token: receiverToken,
    );
  }
  //   PushNotificationModel getNotifModel(
  //   bool isSticker,
  //   String message,
  //   String receiverToken,
  // ) {
  //   return PushNotificationModel(
  //     data: Data(
  //       pageName: AppRouteEnum.chat.path,
  //       uidUser: receiverUser.uid,
  //       nameUser: receiverUser.name,
  //       imgUser: receiverUser.avatar,
  //     ),
  //     notification: NotificationContent(
  //       title: currentUser.value?.name ?? 'Người dùng Easy Date',
  //       body: isSticker ? 'Đã gửi một nhãn dán!' : message,
  //     ),
  //     token: receiverToken,
  //   );
  // }

  Future<void> blockUser() async {
    if (currentUser.value == null) {
      showMessage(LocaleKeys.chat_userInfoNotFound.tr, isSuccess: false);
      return;
    }

    try {
      showLoading();
      // user hiện tại
      final user = BlockUserRequest(
        uid: currentUser.value!.uid,
        imgAvt: currentUser.value!.imgAvt,
        name: currentUser.value!.name,
        status: PairingStatusEnum.blocked, // BLOCKED
      );

      // user đối tác, bị user hiện tại block
      final otherUser = BlockUserRequest(
        uid: receiverUser.uid,
        imgAvt: receiverUser.avatar,
        name: receiverUser.name,
        status: PairingStatusEnum.block, // BLOCK
      );

      await chatRepository.blockUser(current: user, other: otherUser);

      showMessage(LocaleKeys.chat_blockUserSuccess.tr, isSuccess: true);
      Get.back();
    } catch (e, s) {
      handleException(e, stackTrace: s);
    } finally {
      hideLoading();
    }
  }

  void _scrollToBottom() {
    if (chatScrollController.hasClients) {
      chatScrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  void heartFly() {
    for (int i = 0; i < 10; i++) {
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

  @override
  void onClose() {
    messageTextCtrl.dispose();
    chatScrollController.dispose();
    lastMessageSub?.cancel();
    super.onClose();
  }
}
