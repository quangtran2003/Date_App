import 'package:flutter/material.dart';
import '../../core/const/const_src.dart';

class BuildAppBar {
  static PreferredSizeWidget build({
    Widget? title,
    List<Widget>? actions,
    Widget? leading,
    bool backButton = true,
    AlignmentGeometry alignment = Alignment.center,
    double? width,
    Function()? onPressed,
    Color? backgroundColor,
    Color? backButtonColor,
    PreferredSizeWidget? bottom,
  }) {
    Widget? leadingAppBar;
    if (backButton) {
      leadingAppBar = leading ??
          BackButton(
            color: backButtonColor ?? AppColors.white,
            onPressed: onPressed,
          );
    }
    return AppBar(
      leading: leadingAppBar,
      surfaceTintColor: AppColors.white,
      bottom: bottom,
      title: width == null
          ? title
          : Align(
              alignment: alignment,
              child: SizedBox(
                width: width,
                child: title,
              ),
            ),
      automaticallyImplyLeading: backButton,
      backgroundColor: backgroundColor ?? AppColors.lightPrimaryColor,
      centerTitle: true,
      actions: actions,
    );
  }

  static Widget actionButton({
    VoidCallback? function,
    IconData? iconData,
  }) {
    return CircleAvatar(
      backgroundColor: AppColors.white,
      child: InkWell(
        onTap: function,
        child: Icon(
          iconData,
          color: AppColors.lightPrimaryColor,
        ),
      ),
    );
  }
}
