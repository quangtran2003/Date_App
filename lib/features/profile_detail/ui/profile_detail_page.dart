import 'dart:io';

import 'package:easy_date/generated/locales.g.dart';
import 'package:easy_date/utils/utils_src.dart';
import 'package:flutter/material.dart';
import '../../../core/core_src.dart';
import '../profile_detail_src.dart';

part 'profile_detail_widget.dart';

class ProfileDetailPage extends BaseGetWidget<ProfileDetailController> {
  const ProfileDetailPage({super.key});

  @override
  Widget buildWidgets(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: buildLoadingOverlay(
        () => Form(
          key: controller.formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppDimens.defaultPadding),
            children: [
              _buildAvatar(),
              AppDimens.vm12,
              _buildInfo(),
              AppDimens.vm12,
              _buildImage(),
              AppDimens.vm12,
            ],
          ),
        ),
      ),
    );
  }
}
