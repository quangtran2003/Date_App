import 'package:easy_date/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

extension SvgPicturePrecache on SvgPicture {
  Future<void> precache(BuildContext context) async {
    await svg.cache.putIfAbsent(
      bytesLoader.cacheKey(context),
      () => bytesLoader.loadBytes(null),
    );
  }
}

Future<void> precacheImages(BuildContext context) async {
  await Future.wait([
    // Precache Svg

    SvgPicture.asset(Assets.ASSETS_ICONS_IC_PROFILE_SELECTED_SVG)
        .precache(context),
    SvgPicture.asset(Assets.ASSETS_ICONS_IC_PROFILE_UNSELECTED_SVG)
        .precache(context),
    SvgPicture.asset(Assets.ASSETS_ICONS_IC_CHAT_SELECTED_SVG)
        .precache(context),
    SvgPicture.asset(Assets.ASSETS_ICONS_IC_CHAT_UNSELECTED_SVG)
        .precache(context),
    SvgPicture.asset(Assets.ASSETS_ICONS_IC_HOME_SELECTED_SVG)
        .precache(context),
    SvgPicture.asset(Assets.ASSETS_ICONS_IC_HOME_UNSELECTED_SVG)
        .precache(context),
    SvgPicture.asset(Assets.ASSETS_ICONS_APP_ICON2_SVG).precache(context),
    SvgPicture.asset(Assets.ASSETS_ICONS_IC_LOCATION_SVG).precache(context),

    // Precache Image
    precacheImage(
      const AssetImage(Assets.ASSETS_IMAGES_CHAT_BACKGROUND_PNG),
      context,
    ),
  ]);
}
