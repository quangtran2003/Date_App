import 'package:get/get.dart';

class Message {
  final int id;
  final Rx<String> text = ''.obs;
  final List<String> images;
  bool hasAnimated;
  final RxBool isTyping = false.obs;
  final bool isMe;

  Message({
    required String text,
    required this.images,
    required this.id,
    this.isMe = false,
    this.hasAnimated = false,
    bool? isTyping,
  }) {
    this.text.value = text;
    this.isTyping.value = isTyping ?? false;
  }
}
