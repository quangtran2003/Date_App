import 'package:easy_date/core/core_src.dart';
import 'package:easy_date/generated/locales.g.dart';
import 'package:easy_date/utils/utils_src.dart';
import 'package:easy_date/utils/widgets/image.dart';
import 'package:flutter/material.dart';

class InfoUserMatchView extends StatelessWidget {
  final InfoUserMatchModel infoUserMatchModel;

  const InfoUserMatchView(this.infoUserMatchModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatar(),
                _buildInfo(),
                ..._buildImagesDescription()
              ],
            ),
          ),
          _buildMenu(),
        ],
      ),
    );
  }

  List<Widget> _buildImagesDescription() {
    return List.generate(infoUserMatchModel.urlImgDesc.length, (index) {
      return SDSImageNetwork(
        SDSImageNetworkModel(
          width: Get.width,
          height: Get.height / 2,
          borderRadius: BorderRadius.circular(AppDimens.radius16),
          imgUrl: infoUserMatchModel.urlImgDesc[index],
          fit: BoxFit.cover,
        ),
      ).paddingAll(AppDimens.paddingDefault);
    });
  }

  Widget _buildMenu() {
    return Align(
      alignment: Alignment.topLeft,
      child: Row(
        children: [
          const SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () {
              Get.back();
            },
            child: _buildIcon(Icons.close),
          ),
          const Flexible(
            fit: FlexFit.tight,
            child: SizedBox(),
          ),
          // /_buildIcon(Icons.more_horiz),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    ).paddingOnly(top: AppDimens.paddingMedium);
  }

  Widget _buildIcon(IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black87,
      ),
      width: 40,
      height: 40,
      child: Icon(
        iconData,
        color: Colors.white,
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        UtilWidget.buildText(
          "${infoUserMatchModel.name}, ${infoUserMatchModel.birthday}",
          style: AppTextStyle.font20Bo,
        ),
        UtilWidget.buildText(
          "${LocaleKeys.matchUser_address.tr} ${infoUserMatchModel.place}",
          style: AppTextStyle.font14Re,
          maxLine: 2,
        ),
        UtilWidget.buildText(
          "${LocaleKeys.matchUser_gender.tr} ${SexEnum.fromValue(infoUserMatchModel.gender)?.label ?? ''}",
          style: AppTextStyle.font14Re,
        ),
        if (infoUserMatchModel.bio.isNotEmpty)
          UtilWidget.buildText(
            infoUserMatchModel.bio,
            style: AppTextStyle.font14Re,
            maxLine: 5,
          ),
      ],
    ).paddingSymmetric(horizontal: AppDimens.paddingDefault);
  }

  Widget _buildAvatar() {
    return SDSImageNetwork(
      SDSImageNetworkModel(
        width: Get.width,
        height: Get.height / 2,
        borderRadius: BorderRadius.circular(AppDimens.radius16),
        imgUrl: infoUserMatchModel.imgAvt,
        fit: BoxFit.cover,
      ),
    ).paddingSymmetric(horizontal: AppDimens.paddingDefault);
  }
}
