import '../../feature_src.dart';
import '../../recent_chat/model/user_model.dart';

abstract class ProfileRepository extends BaseFirebaseRepository {
  Future<void> logout();
  Future<String> uploadAvatar(String path);
  Future<void> updateAvatarUrl(String url);
  Stream<UserModel> getUserStream();
  void updateUser(
    InfoUserMatchModel model,
    String imgAvt,
  );
}
