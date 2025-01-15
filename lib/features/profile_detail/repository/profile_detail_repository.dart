import '../../feature_src.dart';

abstract class ProfileDetailRepository extends BaseFirebaseRepository {
  Future<void> logout();
  Future<String> uploadAvatar(String path);
  Future<void> updateAvatarUrl(String url);
  Future<String> uploadImage(String path);
  Future<void> updateInfo(ProfileDetailRequest model);
  Future<void> deleteImage(List<String> listImgUrl);
  void updateUser(
    InfoUserMatchModel model,
    ProfileDetailRequest request,
  );
}
