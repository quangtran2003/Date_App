import 'package:easy_date/features/feature_src.dart';
import 'package:easy_date/utils/widgets/image.dart';

part 'horizontal_list_view.dart';
part 'vertical_list_view.dart';

Widget _buildUserAvatar(String imgAvt, RxBool isOnline) {
  return Obx(
    () => Badge(
      isLabelVisible: isOnline.value,
      alignment: Alignment.bottomRight,
      smallSize: AppDimens.sizeIconSmall,
      backgroundColor: AppColors.lightPrimaryColor,
      child: ClipOval(
        child: SDSImageNetwork(
          SDSImageNetworkModel(
            borderRadius: BorderRadius.circular(AppDimens.radius90),
            width: AppDimens.sizeIconMedium * 2,
            height: AppDimens.sizeIconMedium * 2,
            imgUrl: imgAvt,
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
  );
}
