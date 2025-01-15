import 'package:flutter/material.dart';

import '../utils_src.dart';

import '../../core/const/const_src.dart';

class ActiveStatusWidget {
  static Widget buildStatus({
    required Map<int, Color> mapActiveStatus,
    required int statusId,
    required String activeStatus,
    EdgeInsetsGeometry? padding,
  }) =>
      Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(AppDimens.radius8),
          ),
          border: Border.all(
            color: mapActiveStatus[statusId] ?? AppColors.lightPrimaryColor,
          ),
        ),
        child: Padding(
          padding: padding ??
              const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingVerySmall,
                vertical: AppDimens.padding2,
              ),
          child: TextWidget.buildText(
            activeStatus,
            color: mapActiveStatus[statusId] ?? AppColors.dsGray1,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  static Widget buildStatusStr({
    required String activeStatus,
    Color? color,
    EdgeInsetsGeometry? padding,
  }) =>
      Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(AppDimens.radius4),
          ),
          border: Border.all(
            color: color ?? AppColors.dsGray4,
          ),
        ),
        child: Padding(
          padding: padding ??
              const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingVerySmall,
                vertical: AppDimens.padding2,
              ),
          child: TextWidget.buildText(
            activeStatus,
            color: color ?? AppColors.dsGray1,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}
