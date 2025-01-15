import 'package:flutter/material.dart';

import '../../../core/core_src.dart';
import '../../../utils/widgets/utils_widgets.src.dart';

class MessageDateWidget extends StatelessWidget {
  const MessageDateWidget({
    Key? key,
    required this.date,
  }) : super(key: key);

  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppDimens.paddingVerySmall),
      padding: const EdgeInsets.all(AppDimens.padding6),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(AppDimens.radius12),
      ),
      child: UtilWidget.buildText(
        date,
        style: AppTextStyle.font14Re.copyWith(
          color: AppColors.white,
        ),
      ),
    );
  }
}
