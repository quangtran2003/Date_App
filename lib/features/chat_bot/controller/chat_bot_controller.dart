import 'dart:io';

import 'package:easy_date/features/chat_bot/model/message_model.dart';
import 'package:easy_date/features/feature_src.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class ChatBotController extends BaseGetxController {
  late final GenerativeModel model;
  final RxList<File?> imageFiles = RxList<File?>();
  final TextEditingController textCtrl = TextEditingController();
  final scrollController = ScrollController();
  final RxList<Message> messageList = RxList<Message>();
  final firstMessage = Message(
    id: 0,
    images: [],
    text: LocaleKeys.chat_suggestAI.tr,
    isMe: false,
  );

  @override
  onInit() async {
    super.onInit();
    const apiKey = "AIzaSyB10JQnQl57aPWbyfyEPg_bj9WXcW8mAtk";
    model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );
    messageList
      ..assignAll([firstMessage])
      ..listen((_) async {
        if (scrollController.hasClients) {
          scrollToBottom();
        }
      });
  }

  Future<void> pickImage({
    bool isFromCamera = true,
  }) async {
    const double width = 1000;
    const double height = 1000;
    const int quality = 100;

    final XFile? pickedFile = await ImagePicker().pickImage(
      source: isFromCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: width,
      maxHeight: height,
      imageQuality: quality,
    );
    if (pickedFile != null) {
      imageFiles.add(
        File(pickedFile.path),
      );
    }
  }

  Future<String> getResponseMessage(Message message) async {
    // Đọc các file ảnh thành byte array
    final imageBytes = await Future.wait(
      message.images
          .map((file) async => file != null ? await file.readAsBytes() : null),
    );

    final content = [
      Content.multi([
        TextPart(message.text.value),
        ...imageBytes.where((bytes) => bytes != null).map(
              (bytes) => DataPart('image/jpeg', bytes!),
            ),
      ]),
    ];
    try {
      final response = await model.generateContent(content);
      return response.text?.trim() ?? "not found";
    } catch (e) {
      return "not found..";
    }
  }

  //hàm cuộn listView XUống dưới
  // Future<void> scrollToBottom() async {
  //   if (scrollController.hasClients) {
  //     await scrollController.animateTo(
  //       scrollController.position.maxScrollExtent,
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeOut,
  //     );
  //   }
  // }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void sendQuestion() async {
    //await scrollToBottom();
    final question = textCtrl.text;
    if (question.isEmpty) return;
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch,
      text: question,
      images: List.from(imageFiles),
      isMe: true,
    );
    messageList.add(message);
    textCtrl.clear();
    imageFiles.clear();

    final messageResponse = Message(
      id: DateTime.now().millisecondsSinceEpoch,
      text: '',
      images: [],
      isMe: false,
      isTyping: true,
      hasAnimated: true,
    );
    messageList.add(messageResponse);
    // scrollDown();
    // await scrollToBottom();
    scrollToBottom();

    final response = await getResponseMessage(message);
    messageResponse
      ..text.value = response
      ..isTyping.value = false;
    scrollToBottom();
  }
}
