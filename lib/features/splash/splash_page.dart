import 'package:easy_date/utils/utils_src.dart';
import 'package:easy_date/utils/widgets/logo_loading.dart';

import '../../core/const/const_src.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Center(
        child:
            const LogoLoading().paddingOnly(bottom: AppDimens.paddingVerySmall),
      ),
    );
  }
}
