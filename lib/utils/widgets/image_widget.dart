import 'package:easy_date/utils/utils_src.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/const/const_src.dart';

class ImageWidgets {
  static Widget imageSvg(
    String assetName, {
    final double? width,
    final double? height,
    final Color? color,
  }) {
    return SvgPicture.asset(
      assetName,
      fit: BoxFit.contain,
      height: height,
      colorFilter: ColorFilter.mode(
        color ?? AppColors.dsGray1,
        BlendMode.srcIn,
      ),
      width: width ?? AppDimens.sizeIconMedium,
    );
  }

  static Widget svgImgShadow(
    String imageUrl, {
    final double? width,
    final double? height,
    final Color? color,
    final Color? colorBackground,
    final double? widthBackground,
    final double? heightBackground,
  }) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0.0, 2.0),
              blurRadius: AppDimens.radius20,
            )
          ],
          color: colorBackground ?? AppColors.lightPrimaryColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(AppDimens.radius8))),
      width: widthBackground ?? AppDimens.sizeImage,
      height: height ?? AppDimens.sizeImage,
      child: imageSvg(
        imageUrl,
        width: width,
        height: height,
        color: color ?? AppColors.white,
      ).paddingAll(AppDimens.paddingSmallest),
    );
  }

  static Widget svgImgString(
    String imageUrl,
    String value, {
    Color? textColor,
  }) {
    return Row(
      children: [
        ImageWidgets.imageSvg(
          imageUrl,
          width: AppDimens.btnSmall,
          color: AppColors.dsGray2,
        ).paddingOnly(
          right: AppDimens.paddingSmallest,
        ),
        Expanded(
          child: TextWidget.buildText(
            value,
            color: textColor ?? AppColors.dsGray3,
          ),
        ),
      ],
    ).paddingSymmetric(
      vertical: AppDimens.paddingSmallest,
    );
  }
}
