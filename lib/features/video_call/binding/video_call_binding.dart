import 'package:easy_date/features/feature_src.dart';
import 'package:easy_date/features/video_call/controller/video_call_controller.dart';
import 'package:easy_date/features/video_call/repository/video_call_repository.dart';

class VideoCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => VideoCallController(Get.find<VideoCallRepository>()),
    );
  }
}
