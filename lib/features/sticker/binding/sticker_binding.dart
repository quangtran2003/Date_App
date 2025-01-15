import 'package:get/get.dart';

import '../sticker_src.dart';

class StickerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => StickerController(
        stickerRepository: Get.find<StickerRepository>(),
      ),
    );
  }
}
