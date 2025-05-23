import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_date/features/feature_src.dart';
import 'package:shimmer/shimmer.dart';

class SDSImageNetwork extends StatelessWidget {
  final SDSImageNetworkModel sdsImageNetworkModel;
  const SDSImageNetwork(
    this.sdsImageNetworkModel, {
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    if (sdsImageNetworkModel.imgUrl.isNullOrEmpty) {
      return ClipRRect(
        borderRadius: sdsImageNetworkModel.borderRadius ??
            BorderRadius.circular(
              AppDimens.paddingVerySmall,
            ),
        child: SizedBox(
          width: sdsImageNetworkModel.width,
          height: sdsImageNetworkModel.height,
          child: sdsImageNetworkModel.errorWidget ??
              Image.asset(
                sdsImageNetworkModel.imageDefault,
                width: sdsImageNetworkModel.width,
              ),
        ),
      );
    }
    return ClipRRect(
      borderRadius: sdsImageNetworkModel.borderRadius ??
          BorderRadius.circular(AppDimens.paddingVerySmall),
      child: CachedNetworkImage(
        imageUrl: sdsImageNetworkModel.imgUrl!,
        fit: sdsImageNetworkModel.fit,
        width: sdsImageNetworkModel.width,
        height: sdsImageNetworkModel.height,
        progressIndicatorBuilder: (context, url, progress) {
          return Center(
            child: Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.grey.withOpacity(0.5),
              child: SizedBox(
                height: sdsImageNetworkModel.widthLoadding,
                width: sdsImageNetworkModel.widthLoadding,
                child: CircularProgressIndicator(
                  color: AppColors.dsGray3,
                  strokeWidth: 2,
                  value: progress.progress,
                ),
              ),
            ),
          );
        },
        errorWidget: (context, error, stackTrace) {
          return sdsImageNetworkModel.errorWidget ??
              Image.asset(
                sdsImageNetworkModel.imageDefault,
                width: sdsImageNetworkModel.width,
                color: AppColors.dsGray4,
              );
        },
      ),
    );
  }
}
