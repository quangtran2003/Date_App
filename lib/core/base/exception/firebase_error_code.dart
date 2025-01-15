import 'package:easy_date/generated/locales.g.dart';
import 'package:get/get.dart';

abstract final class FirebaseErrorCode {
  static const tooManyRequests = "too-many-requests";
  static const invalidCredential = "invalid-credential";
  static const channelError = "channel-error";
  static const wrongPassword = "wrong-password";
  static const invalidEmail = "invalid-email";
  static const userDisabled = "user-disabled";
  static const userNotFound = "user-not-found";
  static const emailAlreadyInUse = "email-already-in-use";
  static const operationNotAllowed = "operation-not-allowed";
  static const weakPassword = "weak-password";

  static String? errorCodeMapper(String code) {
    switch (code) {
      case FirebaseErrorCode.channelError:
      case FirebaseErrorCode.invalidCredential:
        return LocaleKeys.firebaseAuth_emailOrPasswordInvalid.tr;
      case FirebaseErrorCode.wrongPassword:
        return LocaleKeys.firebaseAuth_wrongPassword.tr;
      case FirebaseErrorCode.invalidEmail:
        return LocaleKeys.firebaseAuth_invalidEmail.tr;
      case FirebaseErrorCode.userDisabled:
        return LocaleKeys.firebaseAuth_userDisabled.tr;
      case FirebaseErrorCode.userNotFound:
        return LocaleKeys.firebaseAuth_userNotFound.tr;
      case FirebaseErrorCode.emailAlreadyInUse:
        return LocaleKeys.firebaseAuth_emailAlreadyInUse.tr;
      case FirebaseErrorCode.operationNotAllowed:
        return LocaleKeys.firebaseAuth_operationNotAllowed.tr;
      case FirebaseErrorCode.weakPassword:
        return LocaleKeys.firebaseAuth_weakPassword.tr;
      case FirebaseErrorCode.tooManyRequests:
        return LocaleKeys.firebaseAuth_tooManyRequests.tr;
      default:
        return null;
    }
  }
}
