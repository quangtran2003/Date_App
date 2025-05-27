import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../assets.dart';
import '../../core/const/const_src.dart';
import '../utils_src.dart';

class ItemUtils {
  static Widget itemLine({
    required String title,
    Function()? func,
    bool hasLeadingBg = false,
    Widget? leading,
    Widget? trailing = const Icon(
      Icons.chevron_right,
      size: 25,
      color: Colors.black,
    ),
    Widget? subtitle,
    Color? iconColor,
    String? imgAsset,
  }) {
    return UtilWidget.baseOnAction(
      onTap: func ?? () {},
      child: Ink(
        child: ListTile(
          leading: SizedBox(
            width: 35,
            height: 35,
            child: leading ??
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(120)),
                    border: Border.all(
                      color: Colors.grey.shade700,
                      width: 0.2,
                    ),
                  ),
                  child: Image.asset(
                    imgAsset ?? Assets.ASSETS_IMAGES_PNG_APP_ICON_PNG,
                  ),
                ),
          ),
          title: Text(
            title,
            style: Get.textTheme.bodyMedium!.copyWith(color: AppColors.dsGray1),
          ),
          subtitle: subtitle,
          trailing: trailing,
        ),
      ),
    );
  }

  static Widget buildDivider({double height = 1.0}) {
    return Container(
      color: Get.theme.cardColor,
      height: 0,
      width: Get.width,
      child: Divider(
        thickness: height,
        indent: 20,
        endIndent: 20,
      ),
    );
  }

  static Widget partItem({
    required IconData icons,
    required String title,
    required Color color,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Row(
        children: [
          Expanded(
              child: Icon(
            icons,
            color: color,
          )),
          Expanded(
              flex: 4,
              child: Text(title,
                  style: Get.textTheme.titleMedium!.copyWith(color: color))),
        ],
      ),
    );
  }

  static Widget itemSwitch({
    required String title,
    String subTitile = '',
    Function()? func,
    bool? value,
    Color? activeColor,
    required void Function(bool)? onChanged,
    TextAlign? textAlign,
    FontWeight? fontWeight,
    Color? textColor,
    int? maxLine,
    double? fontSize,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            children: [
              AutoSizeText(
                title.tr,
                textAlign: textAlign ?? TextAlign.start,
                style: Get.textTheme.bodyLarge!.copyWith(
                  color: textColor ?? AppColors.dsGray1,
                  fontWeight: fontWeight,
                  overflow: TextOverflow.ellipsis,
                  fontSize: fontSize ?? AppDimens.fontMedium(),
                ),
                maxLines: maxLine ?? 1,
              ),
              AutoSizeText(
                subTitile.tr,
                textAlign: textAlign ?? TextAlign.center,
                style: Get.textTheme.bodySmall!.copyWith(
                  fontWeight: fontWeight,
                  fontSize: AppDimens.fontSmall(),
                ),
              ),
            ],
          ),
        ),
        CupertinoSwitch(
          activeTrackColor: activeColor ?? AppColors.lightPrimaryColor,
          value: value ?? false,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
