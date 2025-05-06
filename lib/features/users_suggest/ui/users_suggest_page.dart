import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_date/core/config_noti/local_notif.dart';
import 'package:easy_date/features/feature_src.dart';
import 'package:easy_date/utils/widgets/logo_loading.dart';
import 'package:shimmer/shimmer.dart';

import '../../../assets.dart';

part 'users_suggest_widget.dart';

class UsersSuggestPage extends GetView<UsersSuggestController> {
  const UsersSuggestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SDSSafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildListChoiceChips(controller),
            _buildCardInfo(controller),
            UtilWidget.buildDivider().paddingAll(AppDimens.paddingSmall),
            AppDimens.vm8
          ],
        ).paddingSymmetric(horizontal: AppDimens.paddingMedium),
      ),
    );
  }
}
