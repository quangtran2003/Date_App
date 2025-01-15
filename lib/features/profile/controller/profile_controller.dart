import '../../feature_src.dart';

class ProfileController extends BaseGetxController {
  final ProfileRepository profileRepository;

  late final user = Get.find<HomeController>().currentUser;

  // final languageController = ValueNotifier<bool>(false);

  final isUploading = false.obs;

  ProfileController({
    required this.profileRepository,
  });

  // @override
  // void onClose() {
  //   languageController.dispose();
  //   super.onClose();
  // }

  Future<void> signOut() async {
    ShowPopup.showDialogConfirm(
      LocaleKeys.profile_titelLogout.tr,
      actionTitle: LocaleKeys.profile_yes.tr,
      confirm: () {
        profileRepository.logout();
        Get.offAllNamed(AppRoute.login.path);
      },
    );
  }

  Future<void> changeLanguage(LanguageEnum language) async {
    Get.updateLocale(language.locale);
    await SettingStorage.saveLanguage(language);
  }

  Future<void> selectAvatar() async {
    try {
      final imagePath = await ImageUtil.pickImage();
      if (imagePath != null) {
        isUploading.value = true;
        // Upload image to firebase storage
        final imageUrl = await profileRepository.uploadAvatar(imagePath);
        // Update user avatar in firestore
        await profileRepository.updateAvatarUrl(imageUrl);
        profileRepository.updateUser(user.value!, imageUrl);
      }
    } catch (e, s) {
      handleException(e, stackTrace: s);
    } finally {
      isUploading.value = false;
    }
  }

  void openProfileDetail() {
    Get.toNamed(
      AppRoute.profile_detail.path,
      arguments: {
        "currentUser": user.value,
      },
    );
  }

  void openBlockList() {
    Get.toNamed(
      AppRoute.userList.path,
      arguments: MatchEnum.block,
    );
  }
}
