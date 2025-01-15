import 'package:easy_date/core/base/base_src.dart';
import 'package:easy_date/core/storage/album_sticker_storage.dart';
import 'package:easy_date/core/storage/app_storage.dart';
import 'package:easy_date/generated/locales.g.dart';
import 'package:easy_date/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../sticker_src.dart';

class StickerController extends BaseGetxController {
  final StickerRepository stickerRepository;

  final albumUrlTextCtrl = TextEditingController();

  final albums = <AlbumSticker>[].obs;
  final selectedAlbumIndex = 0.obs;

  StickerController({
    required this.stickerRepository,
  });

  @override
  void onInit() {
    super.onInit();
    loadAlbums();
  }

  Future<void> saveLastUsedAlbum(String albumId) {
    return AppStorage.saveLastUsedAlbumStickerId(albumId);
  }

  Future<void> loadAlbums() async {
    final listAlbum = [...listDefaultAlbum, ...AlbumStickerStorage.albums];

    final lastUsedAlbumId = AppStorage.lastUsedAlbumStickerId;
    if (lastUsedAlbumId != null) {
      // Move last used album to the first position
      final index =
          listAlbum.indexWhere((element) => element.id == lastUsedAlbumId);
      if (index != -1) {
        final album = listAlbum.removeAt(index);
        listAlbum.insert(0, album);
      }
    }

    albums.value = listAlbum;
  }

  Future<void> addAlbum({
    String? customId,
  }) async {
    final id = customId ??
        RegExp(r'a/([^ ]*)').firstMatch(albumUrlTextCtrl.text.trim())?.group(1);

    if (id == null) {
      showSnackBar(LocaleKeys.sticker_invalidAlumUrl.tr, isSuccess: false);
      return;
    }

    try {
      showLoading();
      final album = await stickerRepository.getAlbumSticker(id: id);
      if (album.stickers.isNotEmpty) {
        await AlbumStickerStorage.saveAlbum(id: id, album: album);

        // Add new album to the first position
        albums.value = [album, ...albums];

        // Save last used album
        saveLastUsedAlbum(album.id);

        showSnackBar(LocaleKeys.sticker_loadAlumSuccess.tr);
      } else {
        showSnackBar(LocaleKeys.sticker_loadAlumError.tr, isSuccess: false);
      }
    } catch (e) {
      handleException(e);
    } finally {
      hideLoading();
    }
  }

  @override
  void onClose() {
    albumUrlTextCtrl.dispose();
    super.onClose();
  }
}
