import 'dart:io';
import 'dart:typed_data';

import '../core/const/const_src.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import 'utils_src.dart';

Future<PermissionStatus> checkPermission(
    List<Permission> listPermission) async {
  PermissionStatus status = PermissionStatus.granted;
  Map<Permission, PermissionStatus> statuses = await listPermission.request();
  for (var value in statuses.values) {
    if (value == PermissionStatus.permanentlyDenied) {
      status = PermissionStatus.permanentlyDenied;
      break;
    }
    if (value == PermissionStatus.denied) {
      status = PermissionStatus.denied;
      break;
    }
  }
  return status;
}

Future<String> getPath(String fileName) async {
  String path = await getTemporaryDirectory().then((value) => value.path);

  return '$path${Platform.pathSeparator}$fileName';
}

DateTime? _currentBackPressTime;
Future<bool> onWillPop() {
  DateTime now = DateTime.now();
  if (_currentBackPressTime == null ||
      now.difference(_currentBackPressTime ?? DateTime.now()) >
          const Duration(seconds: 2)) {
    _currentBackPressTime = now;
    Fluttertoast.showToast(msg: AppStr.exitApp.tr);
    return Future.value(false);
  }
  return Future.value(true);
}

bool isNumeric(String s) {
  return double.tryParse(s) != null;
}

// Future<String> searchInvByQr() async {
//   var qrCode = await Get.toNamed(AppConst.routeQrCode);
//   return qrCode != null && qrCode.format == BarcodeFormat.qrcode
//       ? qrCode.code
//       : '';
// }

Future<String> saveFile(String fileName, Uint8List bytes) async {
  File file = File(await getPath(fileName));
  file.writeAsBytes(bytes);

  return file.path;
}

Future<void> shareFile(String fileName, Uint8List bytes) async {
  String path = await saveFile(fileName, bytes);
  // await Share.shareFiles([path]);

  await Share.shareXFiles(
    [XFile(path)],
  );
}
