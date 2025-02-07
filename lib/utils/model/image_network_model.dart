import 'package:easy_date/assets.dart';
import 'package:easy_date/core/core_src.dart';
import 'package:flutter/material.dart';

class SDSImageNetworkModel {
  final String? imgUrl;
  final double width;
  final double height;
  final String imageDefault;
  final Widget? errorWidget;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit fit;

  SDSImageNetworkModel({
    this.imgUrl,
    this.height = AppDimens.sizeImageBig,
    this.width = AppDimens.sizeImage,
    this.imageDefault = Assets.ASSETS_IMAGES_DEFAULT_IMAGE_PNG,
    this.errorWidget,
    this.borderRadius,
    this.fit = BoxFit.fill,
  });
}
