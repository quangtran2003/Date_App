import 'dart:io';

import 'package:flutter/material.dart';

import '../../utils/utils_src.dart';

class AppDimens {
  static double fontSize10() => 10.divSF;
  static double fontSmallest() => 12.divSF;
  static double fontSmall() => 14.divSF;
  static double fontMedium() => 16.divSF;
  static double fontBig() => 18.divSF;
  static double fontBiggest() => 20.divSF;
  static double fontSize24() => 24.divSF;

  static final double paddingDevice =
      GetPlatform.isIOS ? Get.mediaQuery.padding.bottom : paddingVerySmall;
  static const double sizeImage = 50;
  static const double sizeImageMedium = 70;
  static const double sizeImageBig = 90;
  static const double sizeImageLarge = 200;
  static const double sizeImageMax = 300;

  static const bottomAppBarHeight = 60.0;

  static const double sizeTextSmall = 12;
  static const double btnSmall = 20;
  static const double btnMedium = 50;
  static const double btnLarge = 70;
  static const double btnDefault = 40;
  static const double btnDefaultFigma = 48;
  static const double btnFloatingButton = 48;

  static const double sizeIcon = 20;
  static const double sizeIconSmall = 12;
  static const double sizeIconDefault = 16;
  static const double sizeIconMedium = 24;
  static const double sizeIcon28 = 28;
  static const double sizeIconSpinner = 30;
  static const double sizeIconLarge = 36;
  static const double sizeIconExtraLarge = 200;
  static const double sizeDialogNotiIcon = 40;

  static const double paddingZero = 0;
  static const double padding2 = 2.0;
  static const double paddingSmallest = 4.0;
  static const double padding6 = 6.0;
  static const double paddingVerySmall = 8.0;
  static const double padding10 = 10.0;
  static const double paddingSmall = 12.0;
  static const double defaultPadding = 16.0;
  static const double paddingMedium = 20.0;
  static const double padding24 = 24.0;
  static const double paddingHuge = 32.0;
  static const double paddingExtra = 64.0;

  static const emptyWidget = SizedBox.shrink();
  static const emptyWidgetWide = SizedBox(width: double.infinity);

  // Horizontal margin
  static const hm4 = SizedBox(width: 4.0);
  static const hm8 = SizedBox(width: 8.0);
  static const hm12 = SizedBox(width: 12.0);
  static const hm16 = SizedBox(width: 16.0);
  static const hm20 = SizedBox(width: 20.0);
  static const hm24 = SizedBox(width: 24.0);
  static const hm32 = SizedBox(width: 32.0);
  static const hm48 = SizedBox(width: 48.0);

  // Vertical margin
  static const vm4 = SizedBox(height: 4.0);
  static const vm8 = SizedBox(height: 8.0);
  static const vm12 = SizedBox(height: 12.0);
  static const vm16 = SizedBox(height: 16.0);
  static const vm20 = SizedBox(height: 20.0);
  static const vm24 = SizedBox(height: 24.0);
  static const vm32 = SizedBox(height: 32.0);
  static const vm48 = SizedBox(height: 48.0);

  static const double showAppBarDetails = 200;
  static const double sizeAppBarBig = 120;
  static const double sizeAppBarMedium = 92;
  static const double sizeAppBar = 72;
  static const double sizeAppBarSmall = 44;

  // radiusBorder
  static const double radius4 = 4;
  static const double radius6 = 6;
  static const double radius8 = 8;
  static const double radius10 = 10;
  static const double radius12 = 12;
  static const double radius14 = 14;
  static const double radius16 = 16;
  static const double radius20 = 20;
  static const double radius30 = 30;
  static const double radius90 = 90;

  // appbar
  static const double paddingSearchBarBig = 50;
  static const double paddingSearchBar = 45;
  static const double paddingSearchBarMedium = 30;
  static const double paddingSearchBarSmall = 10;

  // page config print
  static const double heightPageConfig = 0.85;
  static const double widthPageConfig = 20;
  static const double heightItem = 35;
  static const double widthItem = 4;
  static const int maxLength = 20;
  static const int maxLengthMax = 50;

  //danh sach ve
  static const double heightItemsFilter = 60;

  //other
  static const double paddingTitleAndTextForm = 3;
  static double bottomPadding() {
    return Platform.isIOS ? AppDimens.paddingMedium : AppDimens.paddingSmall;
  }
}

extension GetSizeScreen on num {
  /// Tỉ lệ fontSize của các textStyle
  double get divSF {
    return this / Get.textScaleFactor;
  }

  // Tăng chiều dài theo font size
  double get mulSF {
    return this * Get.textScaleFactor;
  }
}
