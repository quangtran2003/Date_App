import 'package:flutter/material.dart';

import '../../../core/core_src.dart';
import '../../utils_src.dart';

class ButtonBorder extends StatelessWidget {
  final String btnTitle;
  final VoidCallback? func;
  final Color? textColor;
  final FontWeight? fontWeight;
  final bool havePaddingBottom;
  const ButtonBorder({
    this.btnTitle = "",
    this.func,
    super.key,
    this.textColor,
    this.fontWeight,
    this.havePaddingBottom = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: func,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.dsGray3,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(
              AppDimens.radius8,
            ),
          ),
        ),
        height: AppDimens.btnDefault,
        child: Center(
          child: TextWidget.buildText(
            btnTitle,
            fontWeight: fontWeight,
            color: textColor,
          ),
        ),
      ),
    ).paddingOnly(
      bottom:
          havePaddingBottom ? AppDimens.paddingDevice : AppDimens.paddingZero,
    );
  }
}
