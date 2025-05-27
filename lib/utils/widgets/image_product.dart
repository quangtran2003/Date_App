import 'package:easy_date/assets.dart';
import 'package:easy_date/core/core_src.dart';
import 'package:easy_date/utils/model/image_network_model.dart';
import 'package:easy_date/utils/widgets/image.dart';
import 'package:easy_date/utils/widgets/image_svg.dart';
import 'package:flutter/material.dart';

class SDSImageProduct extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? paddingImage;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit? fit;

  const SDSImageProduct({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.paddingImage,
    this.borderRadius,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return SDSImageNetwork(
      SDSImageNetworkModel(
        imgUrl: imageUrl,
        width: width ?? AppDimens.btnLarge,
        height: height ?? AppDimens.btnLarge,
        errorWidget: Padding(
          padding:
              paddingImage ?? const EdgeInsets.all(AppDimens.paddingSmall),
          child: const SDSImageSvg(
         Assets.ASSETS_IMAGES_PNG_DEFAULT_IMAGE_PNG,
          ),
        ),
        fit: fit ?? BoxFit.cover,
        borderRadius: borderRadius ??
            const BorderRadius.all(
              Radius.circular(
                AppDimens.paddingVerySmall,
              ),
            ),
      ),
    );
  }
}
