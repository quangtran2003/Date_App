import 'package:easy_date/assets.dart';
import 'package:easy_date/core/base/base_src.dart';
import 'package:easy_date/core/const/dimens.dart';
import 'package:easy_date/features/match_user/match_user_src.dart';
import 'package:easy_date/generated/locales.g.dart';
import 'package:easy_date/utils/utils_src.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heart_overlay/heart_overlay.dart';

import '../../../core/const/app_text_style.dart';

part 'match_user_view.dart';

class MatchUserPage extends BaseGetWidget<MatchUserController> {
  const MatchUserPage({super.key});

  @override
  Widget buildWidgets(BuildContext context) {
    return SDSSafeArea(
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: baseShowLoading(
          () => _body(controller),
        ),
      ),
    );
  }
}
