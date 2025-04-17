import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_date/core/core_src.dart';
import 'package:easy_date/utils/utils_src.dart';
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
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAvatar(),
                  _buildInfo().paddingSymmetric(horizontal: 16),
                  ...List.generate(infoUserMatchModel.urlImgDesc.length,
                      (index) {
                    return SizedBox(
                      width: Get.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          imageUrl: infoUserMatchModel.urlImgDesc[index],
                          placeholder: (context, url) => Container(
                            alignment: Alignment.center,
                            child: const SizedBox(
                              width: 50,
                              height: 50,
                              child: Center(child: UtilWidget.buildLoading),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover, // Để hình ảnh phủ toàn bộ
                        ),
                      ).paddingSymmetric(horizontal: 16, vertical: 10),
                    );
                  })
                ],
              ),
            ),
            _buildMenu().paddingOnly(top: 20),
          ],
        ),
      ),
    );
  }

  Align _buildMenu() {
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
          _buildIcon(Icons.more_horiz),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Container _buildIcon(IconData iconData) {
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
          "${AppStr.address} ${infoUserMatchModel.place}",
          style: AppTextStyle.font14Re,
          maxLine: 2,
        ),
        UtilWidget.buildText(
          "${AppStr.sex} ${SexEnum.fromValue(infoUserMatchModel.gender)?.label ?? ''}",
          style: AppTextStyle.font14Re,
        ),
        if (infoUserMatchModel.bio.isNotEmpty)
          UtilWidget.buildText(
            infoUserMatchModel.bio,
            style: AppTextStyle.font14Re,
            maxLine: 5,
          ),
      ],
    );
  }

  SizedBox _buildAvatar() {
    return SizedBox(
      width: Get.width,
      child: SizedBox(
        width: Get.width,
        height: Get.height / 1.9,
        child: CachedNetworkImage(
          imageUrl: infoUserMatchModel.imgAvt,
          placeholder: (context, url) =>
              const Center(child: UtilWidget.buildLoading),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover, // Để hình ảnh phủ toàn bộ
        ),
      ),
    );
  }
}
