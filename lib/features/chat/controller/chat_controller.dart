import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date/core/config_noti/fcm.dart';
import 'package:easy_date/features/video_call/model/call_args.dart';
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

  String get getRoomId => chatRepository.getChatRoomId(
        currentUser.value!.uid,
        receiverUser.idReceiver,
      );

  @override
  Future<void> onInit() async {
    super.onInit();

    showLoading();
    _listenHeartMessage();
    await getOldMessages();

    newMessages.bindStream(
      chatRepository.getNewMessageStream(
        receiverId: receiverUser.idReceiver,
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
          lastMessage.type == MessageTypeEnum.text &&
          lastMessage.content == heartText) {
        canShowHeartOverlay = false;
        heartFly();
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate(duration: 20);
        }
        await Future.delayed(heartAnimationDuration);
        canShowHeartOverlay = true;
      }
    });
  }

  String timeAgoCustom(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final DateTime dateTime = timestamp.toDate();
    final Duration diff = DateTime.now().difference(dateTime);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds} ${LocaleKeys.chat_secondeAgo.tr}';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} ${LocaleKeys.chat_minuteAgo.tr}';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} ${LocaleKeys.chat_hourAgo.tr}';
    } else if (diff.inDays < 30) {
      return '${diff.inDays} ${LocaleKeys.chat_dayAgo.tr}';
    } else if (diff.inDays < 365) {
      final int months = (diff.inDays / 30).floor();
      return '$months ${LocaleKeys.chat_monthAgo.tr}';
    } else {
      final int years = (diff.inDays / 365).floor();
      return '$years ${LocaleKeys.chat_yearAgo.tr}';
    }
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
        receiverId: receiverUser.idReceiver,
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
          receiverId: receiverUser.idReceiver,
          message: message,
          type: MessageTypeEnum.text,
        ),
        pushNotif(
          message,
          type: MessageTypeEnum.text,
        ),
      ]);

      _scrollToBottom();
    } catch (e) {
      handleException(e);
    }
  }

  Future<void> sendSticker(Sticker sticker) async {
    try {
      await chatRepository.createMessage(
        receiverId: receiverUser.idReceiver,
        message: sticker.link,
        type: MessageTypeEnum.sticker,
      );

      await pushNotif(
        LocaleKeys.chat_sendedASticker.tr,
        type: MessageTypeEnum.sticker,
      );

      _scrollToBottom();
    } catch (e) {
      handleException(e);
    }
  }

  Future<void> sendCall(MessageTypeEnum type) async {
    try {
      await chatRepository.createMessage(
        receiverId: receiverUser.idReceiver,
        message: '',
        type: type,
      );

      await pushNotif(
        LocaleKeys.notification_tapToJoinVideoCall.tr,
        type: type,
      );

      _scrollToBottom();
    } catch (e) {
      handleException(e);
    }
  }

  Future<void> pushNotif(
    String message, {
    required MessageTypeEnum type,
  }) async {
    try {
      // Step 1: Get receiver's FCM token
      final receiverToken =
          await chatRepository.getDeviceReceiverToken(receiverUser.idReceiver);
      //bỏ cmt nếu muốn test noti trên thiết bị hiện tại
      //await chatRepository.firebaseMessage.getToken();
      logger.d(receiverToken);
      if (receiverToken == null) return;

      // Step 2: Get server auth token
      final serverAuthToken = await FCM.getToken();
      logger.d(serverAuthToken);

      // Step 3: Prepare notification data
      final notificationPayload = getNotifModel(
        type: type,
        message: message,
        receiverToken: receiverToken,
      );

      // Step 4: Push to server
      await chatRepository.pushNoti(
        notiModel: notificationPayload,
        authToken: serverAuthToken,
      );
    } catch (e) {
      logger.d(e);
    }
  }

  PushNotificationMessage getNotifModel({
    required MessageTypeEnum type,
    required String message,
    required String receiverToken,
  }) {
    final callId =
        type == MessageTypeEnum.audioCall || type == MessageTypeEnum.videoCall
            ? getRoomId
            : null;
    final data = PushNotificationData(
      callId: callId,
      pageName: type.getPageName,
      nameSender: currentUser.value?.name,
      imgAvtSender: currentUser.value?.imgAvt,
      idReceiver: receiverUser.idReceiver,
      idSender: currentUser.value?.uid,
      notifTitle:
          currentUser.value?.name ?? LocaleKeys.notification_easyDateUser.tr,
      notifBody: message,
      type: type.value.toString(),
    );
    return PushNotificationMessage(
      data: data,
      token: receiverToken,
    );
  }

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
        uid: receiverUser.idReceiver,
        imgAvt: receiverUser.imgAvtReceiver,
        name: receiverUser.nameReceiver,
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

  void gotoVideoCallPage(MessageTypeEnum typeMessageEnum) async {
    Get.toNamed(
      AppRouteEnum.video_call.path,
      arguments: CallArgs(
        idCurrentUser: currentUser.value?.uid ?? '',
        nameCurrentUser: currentUser.value?.name ?? '',
        callID: getRoomId,
        typeCall: typeMessageEnum,
      ),
    );
    await sendCall(typeMessageEnum);
  }

  @override
  void onClose() {
    messageTextCtrl.dispose();
    chatScrollController.dispose();
    lastMessageSub?.cancel();
    super.onClose();
  }
}
