import 'package:easy_date/core/core_src.dart';
import 'package:easy_date/features/biometric/ui/biometric_setting/biometric_setting.dart';
import 'package:easy_date/utils/utils_src.dart';
import 'package:easy_date/utils/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

import '../../../generated/locales.g.dart';
import '../profile_src.dart';

part 'profile_widget.dart';

class ProfilePage extends BaseGetWidget<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget buildWidgets(BuildContext context) {
    return Scaffold(
      body: baseShowLoading(
        () => SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfile(),
                const Divider(
                  color: AppColors.dsGray4,
                  height: 0.5,
                ),
                _buildListItem(
                  title: LocaleKeys.profile_profile.tr,
                  iconData: Icons.account_circle,
                  onTap: controller.openProfileDetail,
                ),
                _buildListItem(
                  title: LocaleKeys.profile_block_list.tr,
                  iconData: Icons.playlist_remove,
                  onTap: controller.openBlockList,
                ),
                const BiometricSetting(),
                _buildLanguage(controller),
                _buildListItem(
                  title: LocaleKeys.profile_logout.tr,
                  iconData: Icons.output,
                  onTap: controller.signOut,
                ),
              ],
            ).paddingSymmetric(horizontal: AppDimens.paddingSmall),
          ),
        ),
      ),
    );
  }
}
