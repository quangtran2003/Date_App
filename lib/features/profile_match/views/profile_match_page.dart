import 'package:easy_date/features/feature_src.dart';
import 'package:easy_date/features/match_user/match_user_src.dart';
import 'package:easy_date/features/profile_match/profile_match_src.dart';

class ProfileMatchPage extends BaseGetWidget<ProfileMatchController> {
  const ProfileMatchPage({super.key});

  @override
  Widget buildWidgets(BuildContext context) {
    return Scaffold(
      body: baseShowLoading(
        () => controller.infoUserMatchModel == null
            ? const BaseListEmpty()
            : InfoUserMatchView(controller.infoUserMatchModel!),
      ),
    );
  }
}
