import 'dart:convert';

import 'package:easy_date/core/core_src.dart';
import '../../../routes/routers_src.dart';
import '../../../utils/utils_src.dart';
import '../exception/exception_handler.dart';

class BaseGetxController extends GetxController {
  RxBool isShowLoading = false.obs;
  String errorContent = '';
  final baseRequestController = Get.find<BaseConnectAPI>();
  final appConfig = Get.find<AppConfig>();

  ///1 CancelToken để huỷ 1 request.
  ///1 màn hình gắn với 1 controller, 1 controller có nhiều requests khi huỷ 1 màn hình => huỷ toàn bộ requests `INCOMPLETED` tại màn hình đó.
  List<CancelToken> cancelTokens = [];

  /// Sử dụng một số màn bắt buộc sử dụng loading overlay
  RxBool isLoadingOverlay = false.obs;

  void showLoading() {
    isShowLoading.value = true;
  }

  void hideLoading() {
    isShowLoading.value = false;
  }

  void showLoadingOverlay() {
    isLoadingOverlay.value = true;
  }

  void hideLoadingOverlay() {
    isLoadingOverlay.value = false;
  }

  void _setOnErrorListener() {
    baseRequestController.setOnErrorListener((error) {
      errorContent = AppStr.errorConnectFailedStr.tr;

      if (error is DioException) {
        switch (error.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            errorContent = AppStr.errorConnectTimeOut.tr;
            break;
          case DioExceptionType.cancel:
            // không hiện thông báo khi huỷ request
            errorContent = '';
            break;
          case DioExceptionType.badResponse:
            switch (error.response!.statusCode) {
              case AppConst.error400:
                errorContent = AppStr.error400.tr;
                break;
              case AppConst.error401:
                errorContent = AppStr.error401.tr;
                ShowPopup.showDialogNotification(errorContent,
                    isActiveBack: true, function: () {
                  Get.offAndToNamed(AppRoute.login.path);
                });
                return;

              case AppConst.error404:
                errorContent = AppStr.error404.tr;
                break;
              case AppConst.error500:
                errorContent = AppStr.errorInternalServer.tr;
                break;
              case AppConst.error502:
                errorContent = AppStr.error502.tr;
                break;
              case AppConst.error503:
                errorContent = AppStr.error503.tr;
                break;
              default:
                errorContent = AppStr.errorInternalServer.tr;
            }
            break;
          default:
            errorContent = AppStr.errorConnectFailedStr.tr;
        }
        // check lỗi khi tải pdf
        if (error.response?.data != null && error.response?.data is List<int>) {
          var result = utf8.decode(error.response?.data);
          var err = jsonDecode(result);
          if (err is Map) {
            errorContent = err['Message'];
          }
        }
      }

      isShowLoading.value = false;
      isLoadingOverlay.value = false;
      // if (errorContent.isNotEmpty) showSnackBar(errorContent);
      if (errorContent.isNotEmpty) {
        ShowPopup.showErrorMessage(errorContent);
      }
    });
  }

  void showMessage(
    String message, {
    Duration? duration,
    bool isSuccess = false,
  }) {
    showSnackBar(message, duration: duration, isSuccess: isSuccess);
  }

  void addCancelToken(CancelToken cancelToken) {
    cancelTokens.add(cancelToken);
  }

  void cancelRequest(CancelToken cancelToken) {
    if (!cancelToken.isCancelled) {
      cancelToken.cancel('Cancel when close controller!!!');
    }
  }

  @override
  void onClose() {
    for (var cancelToken in cancelTokens) {
      cancelRequest(cancelToken);
    }
    super.onClose();
  }

  @override
  void onReady() {
    _setOnErrorListener();
    super.onReady();
  }

  void handleException(
    dynamic exception, {
    String? customMessage,
    StackTrace? stackTrace,
  }) {
    ExceptionHandler.handle(
      exception,
      customMessage: customMessage,
      stackTrace: stackTrace,
    );
  }
}
