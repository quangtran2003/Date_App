import 'package:flutter/material.dart';
import '../../../core/const/const_src.dart';

import '../../utils_src.dart';

class ButtonBackConfirm extends StatelessWidget {
  final String? textBtnLeft;
  final VoidCallback? funcBtnLeft;
  final String textBtnRight;
  final VoidCallback? funcBtnRight;
  final bool havePaddingBottom;
  const ButtonBackConfirm({
    this.textBtnLeft,
    this.funcBtnLeft,
    this.textBtnRight = "",
    this.funcBtnRight,
    super.key,
    this.havePaddingBottom = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UtilWidget.sizedWidth8,
        Flexible(
          child: ButtonBorder(
            btnTitle: textBtnLeft ?? AppStr.close,
            func: () {
              funcBtnLeft ?? Get.back();
            },
            havePaddingBottom: havePaddingBottom,
          ),
        ),
        UtilWidget.sizedWidth8,
        Flexible(
          child: BaseButton(
            btnTitle: textBtnRight,
            function: funcBtnRight,
            havePaddingBottom: havePaddingBottom,
            horizontal: AppDimens.paddingZero,
          ),
        ),
        UtilWidget.sizedWidth8,
      ],
    );
  }
}
