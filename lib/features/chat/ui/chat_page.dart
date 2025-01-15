import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_date/assets.dart';
import 'package:easy_date/features/feature_src.dart';
import 'package:easy_date/utils/widgets/logo_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:heart_overlay/heart_overlay.dart';

import 'sticker_message_widget.dart';
import 'text_message_widget.dart';

part 'chat_widget.dart';

class ChatPage extends BaseGetWidget<ChatController> {
  const ChatPage({super.key});

  @override
  Widget buildWidgets(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.ASSETS_IMAGES_CHAT_BACKGROUND_PNG),
            fit: BoxFit.cover,
          ),
        ),
        child: _buildBody(),
      ),
    );
  }
}
