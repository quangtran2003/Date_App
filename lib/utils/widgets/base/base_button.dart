import 'package:flutter/material.dart';

import '../../../core/core_src.dart';
import '../../utils_src.dart';

class BaseButton extends StatelessWidget {
  final String btnTitle;
  final VoidCallback? function;
  final Color? color;
  final bool isLoading;
  final bool showLoading;
  final bool havePaddingBottom;
  final double? horizontal;
  const BaseButton({
    this.btnTitle = "",
    this.color,
    this.function,
    this.isLoading = false,
    this.showLoading = true,
    super.key,
    this.havePaddingBottom = true,
    this.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? AppColors.lightPrimaryColor;
    return ElevatedButton(
      onPressed: !isLoading ? function : () {},
      style: ElevatedButton.styleFrom(
        foregroundColor: buttonColor,
        backgroundColor: buttonColor,
        shadowColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppDimens.radius8,
          ),
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              btnTitle.tr,
              style: TextStyle(
                fontSize: AppDimens.fontMedium(),
                color: AppColors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Visibility(
              visible: isLoading && showLoading,
              child: const SizedBox(
                height: AppDimens.btnSmall,
                width: AppDimens.btnSmall,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.colorRed,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    )
        .paddingOnly(
          bottom: havePaddingBottom
              ? AppDimens.paddingDevice
              : AppDimens.paddingZero,
        )
        .paddingSymmetric(
          horizontal: horizontal ?? AppDimens.paddingVerySmall,
        );
  }
}
