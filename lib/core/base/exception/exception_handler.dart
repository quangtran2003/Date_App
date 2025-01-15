import 'package:easy_date/generated/locales.g.dart';
import 'package:easy_date/utils/utils_src.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'firebase_error_code.dart';

class ExceptionHandler {
  static void handle(
    dynamic exception, {
    StackTrace? stackTrace,
    String? customMessage,
  }) {
    if (customMessage != null) {
      _showErrorSnackbar(customMessage);
      return;
    }

    if (exception is NoNetworkException) {
      _showErrorSnackbar(LocaleKeys.app_noInternet.tr);
    } else if (exception is FirebaseAuthException) {
      _handleFirebaseAuthException(exception);
    } else {
      _showErrorSnackbar(LocaleKeys.app_anErrorOccurred.tr);
      // Log unknown exception
      logger.e(exception, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(exception, stackTrace);
    }
  }

  static void _showErrorSnackbar(String message) {
    showSnackBar(message, isSuccess: false);
  }

  static void _handleFirebaseAuthException(FirebaseAuthException exception) {
    final message = FirebaseErrorCode.errorCodeMapper(exception.code);

    if (message == null) {
      // Log unknown exception
      logger.e(exception);
    }

    _showErrorSnackbar(message ?? LocaleKeys.app_anErrorOccurred.tr);
  }
}
