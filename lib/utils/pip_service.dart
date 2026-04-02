import 'dart:io';
import 'package:flutter/services.dart';

class PipService {
  static const _channel = MethodChannel('vn.crusly.com/pip');

  static Future<void> setEnabled(bool enabled) async {
    if (!Platform.isAndroid) return;
    await _channel.invokeMethod('setPipEnabled', {'enabled': enabled});
  }

  static Future<void> enter() async {
    if (!Platform.isAndroid) return;
    await _channel.invokeMethod('enterPip');
  }
}
