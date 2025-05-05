import 'package:easy_date/utils/utils_src.dart';
import 'package:easy_date/utils/widgets/logo_loading.dart';
import 'package:flutter/material.dart';

import '../../core/const/const_src.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            const LogoLoading().paddingOnly(bottom: AppDimens.paddingVerySmall),
      ),
    );
  }
}
