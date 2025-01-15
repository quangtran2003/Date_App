import 'package:easy_date/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BaseListEmpty extends StatelessWidget {
  const BaseListEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(Assets.ASSETS_ICONS_ICON_LIST_NULL_SVG),
    );
  }
  
}