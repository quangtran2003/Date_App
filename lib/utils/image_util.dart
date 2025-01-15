import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

abstract final class ImageUtil {
  static final _imagePicker = ImagePicker();

  static Future<String?> pickImage({
    ImageSource source = ImageSource.gallery,
  }) async {
    final file = await _imagePicker.pickImage(source: source);
    if (file != null) {
      return file.path;
    }
    return null;
  }

  /// Compress image and keep aspect ratio
  ///
  /// Result image will be in `JPEG` format
  static Future<Uint8List> compressImage({
    required Uint8List bytes,
    int? maxWidth,
    int? maxHeight,
    int quality = 85,
  }) async {
    final image = img.decodeImage(bytes);
    if (image == null) {
      throw Exception("Invalid image");
    }

    if (maxWidth == null && maxHeight == null) {
      return img.encodeJpg(image, quality: quality);
    }

    img.Image? resizedImage;
    if (maxWidth != null && maxHeight != null) {
      if (maxWidth < image.width || maxHeight < image.height) {
        resizedImage = img.copyResize(
          image,
          width: maxWidth < maxHeight ? maxWidth : null,
          height: maxWidth < maxHeight ? null : maxHeight,
          maintainAspect: true,
        );
      }
    } else {
      if (maxWidth != null && maxWidth < image.width) {
        resizedImage = img.copyResize(
          image,
          width: maxWidth,
          maintainAspect: true,
        );
      } else if (maxHeight != null && maxHeight < image.height) {
        resizedImage = img.copyResize(
          image,
          height: maxHeight,
          maintainAspect: true,
        );
      }
    }

    return img.encodeJpg(resizedImage ?? image, quality: quality);
  }
}
