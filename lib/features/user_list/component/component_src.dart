import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_date/features/feature_src.dart';
part 'horizontal_list_view.dart';
part 'vertical_list_view.dart';

Widget _buildUserAvatar(String imgAvt, RxBool isOnline) {
  return Obx(
    () => Badge(
      isLabelVisible: !isOnline.value,
      alignment: Alignment.bottomRight,
      smallSize: AppDimens.sizeIconSmall,
      backgroundColor: AppColors.lightPrimaryColor,
      child: Container(
        width: AppDimens.sizeIconMedium * 2,
        height: AppDimens.sizeIconMedium * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white,
          border: Border.all(
            color: AppColors.primaryLight2.withOpacity(0.2),
            width: 2,
          ),
          image: DecorationImage(
            image: CachedNetworkImageProvider(imgAvt),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
  );
}
