import 'dart:io';

import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

const _checkUpdateInterval = Duration(minutes: 10);
const _currentTrack = UpdateTrack.stable;

class ShorebirdUtils {
  static final instance = ShorebirdUtils._();
  ShorebirdUtils._();

  final _updater = ShorebirdUpdater();
  DateTime? _lastCheckTime;

  Future<void> checkUpdateAndRestart() async {
    // Chỉ chạy trên mobile
    if (!Platform.isAndroid && !Platform.isIOS) return;

    // Throttle: kiểm tra tối đa 1 lần / 10 phút
    final now = DateTime.now();
    if (_lastCheckTime != null &&
        now.difference(_lastCheckTime!) < _checkUpdateInterval) {
      return;
    }
    _lastCheckTime = now;

    var status = await _updater.checkForUpdate(track: _currentTrack);

    if (status == UpdateStatus.outdated) {
      await _updater.update();
      status = UpdateStatus.restartRequired;
    }

    if (status == UpdateStatus.restartRequired) {
      Get.snackbar(
        'Cập nhật',
        'Ứng dụng đã được cập nhật. Đang khởi động lại...',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      await Future.delayed(const Duration(seconds: 3));
      Restart.restartApp();
    }
  }
}
