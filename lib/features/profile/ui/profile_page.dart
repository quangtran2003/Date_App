import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_date/core/core_src.dart';
import 'package:easy_date/utils/utils_src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                title: LocaleKeys.profile_profile,
                iconData: Icons.account_circle,
                onTap: controller.openProfileDetail,
              ),
              _buildListItem(
                title: LocaleKeys.profile_block_list,
                iconData: Icons.playlist_remove,
                onTap: controller.openBlockList,
              ),
              // _buildListItem(
              //   title: LocaleKeys.profile_setting,
              //   iconData: Icons.settings,
              // ),
              _buildListItem(
                title: LocaleKeys.profile_logout,
                iconData: Icons.login_outlined,
                onTap: controller.signOut,
              ),
              // _buildLanguage(controller),
            ],
          ).paddingSymmetric(horizontal: AppDimens.paddingSmall),
        ),
      ),
    );
  }
}
