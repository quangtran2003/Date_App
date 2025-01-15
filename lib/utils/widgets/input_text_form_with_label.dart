import 'package:easy_date/utils/utils_src.dart';
import 'package:flutter/material.dart';

import '../../core/const/const_src.dart';

class BuildInputTextWithLabel extends StatelessWidget {
  final BuildInputText buildInputText;
  final String label;
  final TextStyle? textStyle;
  final bool isRequired;

  const BuildInputTextWithLabel({
    Key? key,
    required this.label,
    required this.buildInputText,
    this.isRequired = false,
    this.textStyle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            UtilWidget.buildText(
              label,
              style: textStyle ??
                  AppTextStyle.font16Bo.copyWith(
                    color: AppColors.grayLight1,
                  ),
            ),
            Visibility(
              visible: isRequired,
              child: UtilWidget.buildText(
                '*',
                fontSize: AppDimens.fontMedium(),
                textColor: AppColors.colorRed,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: AppDimens.paddingVerySmall,
        ),
        buildInputText,
      ],
    );
  }
}
