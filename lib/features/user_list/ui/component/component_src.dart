import 'package:easy_date/features/feature_src.dart';
import 'package:easy_date/utils/widgets/image.dart';

part 'horizontal_list_view.dart';
part 'vertical_list_view.dart';

Widget buildUserAvatar(String imgAvt, RxBool isOnline) {
  return Obx(
    () => Stack(
      alignment: Alignment.bottomRight,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            double size = constraints.maxHeight < AppDimens.btnDefaultFigma
                ? constraints.maxHeight
                : AppDimens.btnDefaultFigma;

            return ClipOval(
              child: SDSImageNetwork(
                SDSImageNetworkModel(
                  borderRadius: BorderRadius.circular(AppDimens.radius90),
                  width: size,
                  height: size,
                  imgUrl: imgAvt,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
        Visibility(
          visible: isOnline.value,
          child: Container(
            width: AppDimens.sizeIconSmall,
            height: AppDimens.sizeIconSmall,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.lightPrimaryColor,
            ),
          ),
        )
      ],
    ),
  );
}
