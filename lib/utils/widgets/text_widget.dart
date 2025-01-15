import 'package:flutter/material.dart';

import '../../core/const/const_src.dart';
import '../utils_src.dart';

class TextWidget {
  static Widget buildText(
    final String? text, {
    final double? fontSize,
    final Color? color,
    final FontWeight? fontWeight,
    final TextAlign? textAlign,
    final int? maxLines,
    final TextOverflow? overflow,
    final TextStyle? textStyle,
  }) {
    return Text(
      text ?? "",
      style: textStyle ??
          Get.textTheme.bodySmall!.copyWith(
            color: color ?? AppColors.dsGray1,
            fontWeight: fontWeight,
            fontSize: fontSize ?? AppDimens.fontSmall(),
            overflow: overflow ?? TextOverflow.ellipsis,
          ),
      textAlign: textAlign,
      maxLines: maxLines ?? 10,
    );
  }

  static Widget buildTextHeader(
    final String text, {
    final Color? color,
    final TextAlign? textAlign,
    final int? maxLines,
    final TextOverflow? overflow,
  }) {
    return Text(
      text,
      style: Get.textTheme.bodySmall!.copyWith(
        color: color ?? AppColors.dsGray1,
        fontWeight: FontWeight.bold,
        fontSize: AppDimens.fontMedium(),
        overflow: overflow ?? TextOverflow.ellipsis,
      ),
      textAlign: textAlign,
      maxLines: maxLines ?? 10,
    );
  }

  static Widget buildRowInfor({
    required String title,
    required String? value,
    double? fontSize,
    bool isShowSizedBox = true,
    FontWeight? fontWeight = FontWeight.w500,
    Color? colorValue,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget.buildText(
              title,
              color: AppColors.dsGray3,
              fontSize: fontSize,
            ),
            if (value != null) ...[
              UtilWidget.sizedWidth10,
              Expanded(
                child: TextWidget.buildText(
                  value,
                  fontWeight: fontWeight,
                  fontSize: fontSize,
                  textAlign: TextAlign.right,
                  color: colorValue,
                ),
              ),
            ],
          ],
        ),
        if (isShowSizedBox) UtilWidget.sizedBox8,
      ],
    );
  }

  static Widget buildColumnInfor({
    required String title,
    required String? value,
    double? fontSize,
    bool isShowDivider = false,
    FontWeight? fontWeight = FontWeight.w500,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget.buildText(
          title,
          color: AppColors.dsGray3,
        ),
        UtilWidget.sizedBox8,
        Align(
          alignment: Alignment.centerRight,
          child: TextWidget.buildText(
            value ?? "",
            fontWeight: fontWeight,
            fontSize: fontSize,
            textAlign: TextAlign.right,
          ),
        ),
        if (isShowDivider)
          UtilWidget.buildTextDivider(
            horizontal: 0,
          ),
      ],
    );
  }
}
