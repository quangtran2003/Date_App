import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_date/generated/locales.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/core_src.dart';
import '../../../utils/utils_src.dart';
import '../controller/sticker_controller.dart';

part 'sticker_widget.dart';

class StickerPage extends BaseGetWidget<StickerController> {
  const StickerPage({super.key});

  Future<void> _showDialogInputStickerAlbum() async {
    Get.defaultDialog(
      title: LocaleKeys.sticker_addStickerDialogTitle.tr,
      content: TextField(
        controller: controller.albumUrlTextCtrl,
        decoration: InputDecoration(
          hintText: LocaleKeys.sticker_enterAlumUrl.tr,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(LocaleKeys.app_cancel.tr),
        ),
        TextButton(
          onPressed: () {
            controller.addAlbum();
            Get.back();
          },
          child: Text(LocaleKeys.app_ok.tr),
        ),
      ],
    );
  }

  @override
  Widget buildWidgets(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: UtilWidget.buildAppBarTitle(
          LocaleKeys.sticker_stickerPageTitle.tr,
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _showDialogInputStickerAlbum();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
            child: Obx(
              () {
                if (controller.isShowLoading.value) {
                  return const Center(child: CupertinoActivityIndicator());
                }

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  itemBuilder: (context, index) {
                    final album = controller.albums[index];
                    return InkWell(
                      onTap: () {
                        controller.selectedAlbumIndex.value = index;
                      },
                      child: CachedNetworkImage(
                        imageUrl: album.stickers.first.link,
                      ),
                    );
                  },
                  itemCount: controller.albums.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 12);
                  },
                );
              },
            ),
          ),
          Expanded(
            child: Obx(
              () {
                if (controller.albums.isEmpty) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }

                final album =
                    controller.albums[controller.selectedAlbumIndex.value];

                if (album.stickers.isEmpty) {
                  return const Center(
                    child: Text("No stickers in this album!"),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final sticker = album.stickers[index];
                    return InkWell(
                      onTap: () {
                        controller.saveLastUsedAlbum(album.id);
                        Get.back(result: sticker);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(
                            AppDimens.radius8,
                          ),
                        ),
                        child: UtilWidget.buildCachedNetworkImage(
                          url: sticker.link,
                          direction: index % 2 == 0
                              ? ShimmerDirection.ltr
                              : ShimmerDirection.rtl,
                        ),
                      ),
                    );
                  },
                  itemCount: album.stickers.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
