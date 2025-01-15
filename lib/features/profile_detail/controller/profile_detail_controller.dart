import '../../feature_src.dart';

class ProfileDetailController extends BaseGetxController {
  final ProfileDetailRepository profileDetailRepo;

  final formKey = GlobalKey<FormState>();

  late final Rxn<InfoUserMatchModel> currentUser =
      Rxn<InfoUserMatchModel>(null);

  RxList<String> listImgUpload = <String>[].obs;
  final List<String> listImgUrl = [];
  String? avatarPath;
  final isUploadedAvatar = false.obs;

  // final languageController = ValueNotifier<bool>(false);

  RxInt gender = 0.obs;
  RxBool isSexualFemale = false.obs;
  RxBool isSexualMale = false.obs;
  RxBool isSexualRequired = false.obs;
  int? sexualOrientation;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();

  ProfileDetailController({
    required this.profileDetailRepo,
  });

  void onInitData() {
    if (currentUser.value != null) {
      if (currentUser.value!.status == StatusEnum.inactive.value) return;
      nameController.text = currentUser.value!.name;
      birthdayController.text = currentUser.value!.birthday.toString();
      bioController.text = currentUser.value!.bio;
      sexualOrientation = currentUser.value?.sexualOrientation;
      updateCheckBoxOrientation();
      placeController.text = currentUser.value!.place;
      avatarPath = currentUser.value!.imgAvt;
      gender.value = currentUser.value!.gender;
      listImgUpload.value = currentUser.value!.imgDesc.isNotEmpty
          ? currentUser.value!.imgDesc.split(',')
          : [];

      listImgUrl.addAll(listImgUpload);
    }
  }

  Future<void> selectAvatar() async {
    try {
      avatarPath = await ImageUtil.pickImage();
      isUploadedAvatar.value = true;
    } catch (e, s) {
      handleException(e, stackTrace: s);
    } finally {
      isUploadedAvatar.value = false;
    }
  }

  void onChangeGender(int? value) {
    gender.value = value!;
  }

  void onChangeSexualFemale(value) {
    isSexualFemale.value = value;
    updateSexualRequired();
  }

  void onChangeSexualMale(value) {
    isSexualMale.value = value;
    updateSexualRequired();
  }

  void updateSexualRequired() {
    isSexualRequired.value = false;
    if (!isSexualFemale.value && !isSexualMale.value) {
      isSexualRequired.value = true;
    }
  }

  Future<void> uploadImage(int index, {bool isUpdateImg = false}) async {
    try {
      final imgPath = await ImageUtil.pickImage();
      if (imgPath != null) {
        //Update img.
        if (isUpdateImg) {
          listImgUpload[index] = imgPath;
          final imgUrl = await profileDetailRepo.uploadImage(imgPath);
          listImgUrl[index] = imgUrl;
          return;
        }

        //Add img.
        if (listImgUpload.length > 3) return;
        listImgUpload.add(imgPath);
        final imgUrl = await profileDetailRepo.uploadImage(imgPath);
        listImgUrl.add(imgUrl);
      }
    } catch (e, s) {
      handleException(e, stackTrace: s);
    }
  }

  void onDeleteImage(int index) {
    listImgUrl.removeAt(index);
    listImgUpload.removeAt(index);
  }

  Future<void> onSaveInfo() async {
    try {
      await profileDetailRepo.deleteImage(listImgUrl);

      updateSexualOrientation();

      if (currentUser.value?.status == StatusEnum.inactive.value) {
        if (avatarPath.isNullOrEmpty) {
          showSnackBar(
            LocaleKeys.profileDetail_invalidAvatar.tr,
            isSuccess: false,
          );
          return;
        }
      }

      if (!(formKey.currentState?.validate() ?? false) ||
          isSexualRequired.value) return;

      showLoadingOverlay();
      final String imgAvt = await updateImageAvt();
      final String imgDesc = listImgUrl.join(',');

      ProfileDetailRequest request = ProfileDetailRequest(
        sexualOrientation: sexualOrientation!,
        bio: bioController.text,
        place: placeController.text,
        uid: currentUser.value!.uid,
        imgDesc: imgDesc,
        imgAvt: imgAvt,
        birthday: int.parse(birthdayController.text),
        name: nameController.text.trim(),
        status: StatusEnum.active.value,
        gender: gender.value,
      );

      await profileDetailRepo.updateInfo(request);
      if (currentUser.value != null) {
        // Side effect - Do not need await
        profileDetailRepo.updateUser(currentUser.value!, request);
      }

      showSnackBar(LocaleKeys.profileDetail_updateSuccess.tr);
      if (currentUser.value?.status == StatusEnum.inactive.value) {
        Get.offAllNamed(AppRoute.home.path);
        return;
      }
      Get.back();
    } catch (e, s) {
      handleException(e, stackTrace: s);
    } finally {
      hideLoadingOverlay();
    }
  }

  void updateSexualOrientation() {
    if (isSexualFemale.value && isSexualMale.value) {
      sexualOrientation = SexEnum.all.value;
    } else if (!isSexualFemale.value && !isSexualMale.value) {
      sexualOrientation = null;
      isSexualRequired.value = true;
    } else if (isSexualFemale.value) {
      sexualOrientation = SexEnum.feMale.value;
    } else if (isSexualMale.value) {
      sexualOrientation = SexEnum.male.value;
    }
  }

  void updateCheckBoxOrientation() {
    if (sexualOrientation == SexEnum.feMale.value) {
      isSexualFemale.value = true;
    } else if (sexualOrientation == SexEnum.male.value) {
      isSexualMale.value = true;
    } else {
      isSexualFemale.value = true;
      isSexualMale.value = true;
    }
  }

  Future<String> updateImageAvt() async {
    if (currentUser.value?.status == StatusEnum.active.value) {
      return avatarPath!;
    }
    final imgAvt = await profileDetailRepo.uploadAvatar(avatarPath!);
    return imgAvt;
  }

  bool inValidateInfo() {
    return nameController.text.isEmpty ||
        birthdayController.text.isEmpty ||
        placeController.text.isEmpty ||
        sexualOrientation == null;
  }

  Future<void> openDatePicker() async {
    final selectedDate =
        DateTime(int.tryParse(birthdayController.text) ?? DateTime.now().year);
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Expanded(
                child: Text(LocaleKeys.profileDetail_selectYear.tr),
              ),
              InkWell(
                onTap: () => Get.back(),
                child: const Icon(Icons.close),
              ),
            ],
          ),
          content: SizedBox(
            width: Get.height,
            height: Get.height / 3,
            child: Theme(
              data: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: AppColors.colorRed,
                ),
              ),
              child: YearPicker(
                firstDate: DateTime(DateTime.now().year - 50, 1),
                lastDate: DateTime(DateTime.now().year, 1),
                selectedDate: selectedDate,
                onChanged: (DateTime dateTime) {
                  birthdayController.text = dateTime.year.toString();
                  Get.back();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments["currentUser"] != null &&
        Get.arguments["currentUser"] is InfoUserMatchModel) {
      currentUser.value = Get.arguments["currentUser"];
    }
    onInitData();
  }

  @override
  void onClose() {
    nameController.dispose();
    bioController.dispose();
    birthdayController.dispose();
    placeController.dispose();
    super.onClose();
  }
}
