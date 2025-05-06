import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/const/const_src.dart';
import 'utils_src.dart';

class ShowPopup {
  static int _numDialog = 0;

  static Future<void> _showDialog(Widget dialog, bool isActiveBack,
      {bool barrierDismissible = false}) async {
    _numDialog++;
    await Get.dialog(
      NavigatorPopHandler(
        onPop: () => onBackPress(isActiveBack),
        child: dialog,
      ),
      barrierDismissible: barrierDismissible,
    ).whenComplete(() => _numDialog--);
  }

  static Future<bool> onBackPress(bool isActiveBack) {
    return Future.value(isActiveBack);
  }

  static void dismissDialog() {
    if (_numDialog > 0) {
      Get.back();
    }
  }

  /// Hiển thị loading
  ///
  /// `isActiveBack` có cho phép back từ bàn phím Android khi loading hay không, default = true
  void showLoadingWave({bool isActiveBack = true}) {
    _showDialog(getLoadingWidget(), isActiveBack);
  }

  static Widget getLoadingWidget() {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }

  static Widget _baseButton(
    Function? function,
    String text, {
    Color? colorText,
  }) {
    return UtilWidget.baseOnAction(
        onTap: () {
          dismissDialog();

          function?.call();
        },
        child: TextButton(
          onPressed: null,
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: AppDimens.fontBig(),
              color: colorText,
            ),
            textScaler: TextScaler.noScaling,
            maxLines: 1,
          ),
        ));
  }

  /// Hiển thị dialog thông báo với nội dung cần hiển thị
  ///
  /// `funtion` hành động khi bấm đóng
  ///
  /// `isActiveBack` có cho phép back từ bàn phím Android hay không, default = true
  ///
  /// `isChangeContext` default true: khi gọi func không close dialog hiện tại (khi chuyển sang màn mới thì dialog hiện tại sẽ tự đóng)
  static Future<void> showDialogNotification(
    String content, {
    bool isActiveBack = true,
    Function? function,
    String nameAction = AppStr.close,
  }) async {
    await _showDialog(
      Dialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 15, bottom: 10),
                child: Icon(
                  _buildIconDialog(content),
                  size: AppDimens.sizeDialogNotiIcon,
                  color: Colors.blueAccent,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                constraints: const BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(
                  child: Text(
                    content,
                    style: TextStyle(fontSize: AppDimens.fontMedium()),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    textScaler: TextScaler.noScaling,
                  ),
                ),
              ),
              const Divider(
                height: 1,
              ),
              SizedBox(
                width: double.infinity,
                child: _baseButton(
                  function,
                  nameAction,
                  colorText: AppColors.colorBlueAccent,
                ),
              ),
            ],
          ),
        ),
      ),
      isActiveBack,
    );
  }

  static Future<void> showErrorMessage(String error) async {
    await showDialogNotification(error, isActiveBack: false);
  }

  static Future<void> showErrorMessageOnce(
    String error,
  ) async {
    if (_numDialog < 1) {
      await showErrorMessage(error);
    }
  }

  static IconData _buildIconDialog(String errorStr) {
    IconData iconData;
    switch (errorStr) {
      case AppStr.errorConnectTimeOut:
        iconData = Icons.alarm_off;
        break;
      case AppStr.error400:
      case AppStr.error401:
      case AppStr.error404:
      case AppStr.error502:
      case AppStr.error503:
      case AppStr.errorInternalServer:
        iconData = Icons.warning;
        break;
      case AppStr.errorConnectFailedStr:
        iconData = Icons.signal_wifi_off;
        break;
      default:
        iconData = Icons.notifications_none;
    }
    return iconData;
  }

  static Future<void> showDialogConfirm(
    String content, {
    required Function confirm,
    required String actionTitle,
    bool isActiveBack = true,
    String title = BaseWidgetStr.notification,
    String exitTitle = BaseWidgetStr.cancel,
    Function? cancelFunc,
    bool isAutoCloseDialog = false,
  }) async {
    await _showDialog(
      Dialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: AutoSizeText(
                  title,
                  textScaleFactor: 1,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: AppDimens.fontBiggest(),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                constraints: const BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(
                  child: Text(
                    content,
                    style: Get.textTheme.bodyLarge?.copyWith(),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    textScaler: TextScaler.noScaling,
                  ),
                ),
              ),
              const Divider(
                height: 1,
              ),
              SizedBox(
                width: double.infinity,
                height: AppDimens.btnMedium,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: _baseButton(
                        cancelFunc,
                        exitTitle,
                        colorText: AppColors.dsGray3,
                      ),
                    ),
                    const VerticalDivider(
                      width: 1,
                      color: AppColors.darkAccentColor,
                    ),
                    Expanded(
                      child: _baseButton(
                        confirm,
                        actionTitle,
                        colorText: AppColors.colorRed,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isActiveBack,
    );
  }

  static Future<void> openAppSetting() async {
    await showDialogConfirm(
      'Hỗ trợ',
      confirm: () {
        Get.back();
        AppSettings.openAppSettings();
      },
      actionTitle: BaseWidgetStr.openSettings,
    );
  }

  static Future<void> openSupport() async {
    await showDialogSupport(
      AppStr.supportCus,
    );
  }

  static Future<void> showDialogSupport(
    String content, {
    bool isActiveBack = true,
    Function? function,
    String nameAction = AppStr.close,
  }) async {
    await _showDialog(
      Dialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: AutoSizeText(
                  content,
                  textScaleFactor: 1,
                  maxLines: 1,
                  style: Get.textTheme.titleLarge,
                ),
              ),
              UtilWidget.sizedBox10,
              SizedBox(
                width: double.infinity,
                child: _baseButton(
                  function,
                  nameAction,
                  colorText: AppColors.colorBlueAccent,
                ),
              ),
            ],
          ),
        ),
      ),
      isActiveBack,
    );
  }

  static Future<void> showDialogConfirmWidget({
    required Function confirm,
    required String actionTitle,
    bool isActiveBack = true,
    String title = AppStr.notification,
    String exitTitle = AppStr.cancel,
    Function? cancelFunc,
    bool isAutoCloseDialog = false,
    required Widget buildBody,
  }) async {
    await _showDialog(
      Dialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: AutoSizeText(
                  title,
                  textScaleFactor: 1,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: AppDimens.fontBiggest(),
                  ),
                ),
              ),
              buildBody,
              const Divider(
                height: 1,
              ),
              SizedBox(
                width: double.infinity,
                height: AppDimens.btnMedium,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: _baseButton(
                        cancelFunc,
                        exitTitle,
                        colorText: AppColors.dsGray3,
                      ),
                    ),
                    const VerticalDivider(
                      width: 1,
                      color: AppColors.darkAccentColor,
                    ),
                    Expanded(
                      child: _baseButton(
                        confirm,
                        actionTitle,
                        colorText: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isActiveBack,
    );
  }

  static Future<void> showDialogCustom(
    Widget child, {
    bool isActiveBack = true,
    Function? function,
    String nameAction = AppStr.close,
  }) async {
    await _showDialog(
      Dialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 15, bottom: 10),
                child: Icon(
                  _buildIconDialog(''),
                  size: AppDimens.sizeDialogNotiIcon,
                  color: Colors.blueAccent,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                constraints: const BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(
                  child: child,
                ),
              ),
              const Divider(
                height: 1,
              ),
              SizedBox(
                width: double.infinity,
                child: _baseButton(
                  function,
                  nameAction,
                  colorText: AppColors.colorBlueAccent,
                ),
              ),
            ],
          ),
        ),
      ),
      isActiveBack,
    );
  }
}
