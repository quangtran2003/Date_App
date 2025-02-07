import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/const/const_src.dart';
import '../utils_src.dart';

class UtilWidget {
  static DateTime? _dateTime;
  static int _oldFunc = 0;
  static const throttleDuration = Duration(seconds: 2);

  static const Widget sizedBox10 = SizedBox(height: 10);
  static const Widget sizedBox8 = SizedBox(height: 8);
  static const Widget sizedBox5 = SizedBox(height: 5);
  static const Widget sizedBoxPaddingHuge =
      SizedBox(height: AppDimens.paddingHuge);
  static const Widget sizedBoxPadding =
      SizedBox(height: AppDimens.defaultPadding);
  static const Widget sizedWidth5 = SizedBox(width: 5);
  static const Widget sizedWidth10 = SizedBox(width: 10);
  static const Widget sizedWidth8 = SizedBox(width: 8);

  static Widget buildSafeArea(
    Widget childWidget, {
    double miniumBottom = 12,
    Color? color,
    bool top = false,
  }) {
    return Container(
      color: color ?? AppColors.scaffoldBackground,
      child: SafeArea(
        bottom: true,
        maintainBottomViewPadding: true,
        minimum: EdgeInsets.only(bottom: miniumBottom),
        child: childWidget,
      ),
    );
  }

  static Widget buildLogo(String imgLogo, double height) {
    return SizedBox(
      height: height,
      child: Image.asset(imgLogo),
    );
  }

  static const Widget buildLoading = CupertinoActivityIndicator();

  static Widget buildAppBarTitle(
    String title, {
    bool? textAlignCenter,
    Color? textColor,
  }) {
    textAlignCenter = textAlignCenter ?? GetPlatform.isAndroid;
    return AutoSizeText(
      title,
      textAlign: textAlignCenter ? TextAlign.center : TextAlign.left,
      style: AppTextStyle.font18Ex.copyWith(
        color: textColor ?? AppColors.grayLight1,
      ),
      maxLines: 2,
    );
  }

  static Widget buildTitle(String title) {
    return Text(
      title.tr,
      textScaler: TextScaler.noScaling,
      style: AppTextStyle.font14Bo.copyWith(color: AppColors.dsGray3),
      textAlign: TextAlign.center,
    );
  }

  static Widget buildSmartRefresherCustomFooter() {
    return CustomFooter(
      loadStyle: LoadStyle.ShowWhenLoading,
      builder: (context, mode) {
        if (mode == LoadStatus.loading) {
          return const CupertinoActivityIndicator();
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  static Widget buildDivider(
      {double height = 10.0, double thickness = 1.0, double indent = 0.0}) {
    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: indent,
    );
  }

  static Widget buildTextDivider({
    double? horizontal,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal ?? AppDimens.paddingVerySmall,
      ),
      child: Text(
        " -" * 200,
        maxLines: 1,
        style: const TextStyle(
          color: AppColors.dsGray3,
        ),
      ),
    );
  }

  static Widget buildEmpty(
      {required Function onRefresh,
      String emptyStr = BaseWidgetStr.dataEmpty}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        baseOnAction(
          onTap: onRefresh,
          child: const IconButton(
            icon: Icon(
              Icons.refresh,
              size: AppDimens.sizeIconMedium,
              color: Colors.white,
            ),
            onPressed: null,
          ),
        ),
        Center(
          child: Text(
            emptyStr.tr,
            style: Get.theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  /// Widget cài đặt việc refresh page
  static Widget buildSmartRefresher({
    required RefreshController refreshController,
    required Widget child,
    ScrollController? scrollController,
    Function()? onRefresh,
    Function()? onLoadMore,
    bool enablePullUp = false,
    bool enablePullDown = false,
  }) {
    return SmartRefresher(
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,
      scrollController: scrollController,
      header: const MaterialClassicHeader(),
      controller: refreshController,
      onRefresh: onRefresh,
      onLoading: onLoadMore,
      footer: UtilWidget.buildSmartRefresherCustomFooter(),
      child: child,
    );
  }

  static Widget buildShimmerLoading() {
    const padding = AppDimens.defaultPadding;
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(horizontal: padding, vertical: padding),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade400,
              highlightColor: Colors.grey.shade100,
              enabled: true,
              child: ListView.separated(
                  itemBuilder: (context, index) => Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 24.0,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                          sizedBox10,
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 16.0,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: Container(
                                  height: 16.0,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          sizedBox10,
                        ],
                      ),
                  separatorBuilder: (context, index) => const Divider(
                        height: 15,
                      ),
                  itemCount: 10),
            ),
          ),
        ],
      ),
    );
  }

  static Widget baseBottomSheet({
    required String title,
    required Widget body,
    Widget? iconTitle,
    bool isSecondDisplay = false,
    TextAlign? textAlign,
    AlignmentGeometry? alignment,
    Widget? actionArrowBack,
    Color? backgroundColor,
  }) {
    return SafeArea(
      bottom: false,
      minimum: EdgeInsets.only(
          top: Get.mediaQuery.padding.top + (isSecondDisplay ? 100 : 20)),
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.white,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title.tr,
                    textAlign: textAlign ?? TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Get.textTheme.titleLarge!.copyWith(
                      color: AppColors.lightPrimaryColor,
                    ),
                  ).paddingOnly(
                    left: AppDimens.paddingHuge,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: actionArrowBack ??
                      const CloseButton(
                        color: AppColors.lightPrimaryColor,
                      ),
                ),
                iconTitle ?? const SizedBox(),
              ],
            ).paddingSymmetric(
              vertical: AppDimens.paddingSmall,
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }

  static Widget buildButtonIcon({
    required IconData icons,
    required Function func,
    required Color colors,
    required String title,
    double sizeIcon = 20,
    double radius = 30,
    double padding = 8.0,
    Color? textColor,
    Color? iconColor = AppColors.white,
    String? imgAsset,
  }) =>
      UtilWidget.baseOnAction(
        onTap: func,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                color: colors,
                borderRadius: BorderRadius.circular(radius),
              ),
              child: imgAsset != null
                  ? Image.asset(
                      imgAsset,
                      fit: BoxFit.cover,
                      height: sizeIcon,
                      width: sizeIcon,
                    )
                  : Icon(
                      icons,
                      color: iconColor,
                      size: sizeIcon,
                    ),
            ),
            if (title.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                title.tr,
                style: Get.theme.textTheme.titleSmall!.copyWith(
                    color: textColor ?? AppColors.dsGray1, fontSize: 12),
              ),
            ]
          ],
        ),
      );

  static Widget buildCardBase(
    Widget child, {
    Color? colorBorder,
    Color? backgroundColor,
    BoxDecoration? decoration,
  }) =>
      Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(
              AppDimens.radius8,
            ),
          ),
          border: Border.all(
            color: colorBorder ?? Colors.transparent,
          ),
        ),
        child: child,
      );

  static Widget buildCardShadowBase({
    required Widget child,
    BoxDecoration? decoration,
    Color? backgroundColor,
  }) =>
      Container(
          decoration: decoration ??
              BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0.0, 2.0),
                      blurRadius: AppDimens.radius20,
                    )
                  ],
                  color: backgroundColor ?? AppColors.white,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(AppDimens.radius20),
                      bottomRight: Radius.circular(AppDimens.radius20))),
          child: child);

  /// Sử dụng để tránh trường hợp click liên tiếp khi thực hiện function
  static Widget baseOnAction({
    required Function onTap,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: () {
        DateTime now = DateTime.now();
        if (_dateTime == null ||
            now.difference(_dateTime ?? DateTime.now()) > 1.seconds ||
            onTap.hashCode != _oldFunc) {
          _dateTime = now;
          _oldFunc = onTap.hashCode;
          onTap();
        }
      },
      child: child,
    );
  }

  static Future<DateTime?> buildDateTimePicker({
    required DateTime dateTimeInit,
    DateTime? minTime,
    DateTime? maxTime,
  }) async {
    DateTime? newDateTime = await showRoundedDatePicker(
      context: Get.context!,
      height: 310,
      initialDate: dateTimeInit,
      firstDate: minTime ?? DateTime.utc(DateTime.now().year - 10),
      lastDate: maxTime,
      // barrierDismissible: true,
      theme: ThemeData(
        primaryColor: AppColors.white,
        dialogBackgroundColor: AppColors.dateTimeColor,
        primarySwatch: Colors.deepOrange,
        disabledColor: AppColors.dsGray3,
        focusColor: AppColors.lightPrimaryColor,
        textTheme: TextTheme(
          bodySmall:
              Get.textTheme.bodyLarge!.copyWith(color: AppColors.dsGray3),
          bodyMedium: Get.textTheme.bodyLarge,
        ),
      ),
      styleDatePicker: MaterialRoundedDatePickerStyle(
        paddingMonthHeader: const EdgeInsets.all(15),
        textStyleMonthYearHeader: Get.textTheme.bodyLarge,
        colorArrowNext: AppColors.dsGray3,
        colorArrowPrevious: AppColors.dsGray3,
        textStyleButtonNegative:
            Get.textTheme.bodyLarge!.copyWith(color: AppColors.dsGray3),
        textStyleButtonPositive: Get.textTheme.bodyLarge!
            .copyWith(color: AppColors.lightPrimaryColor),
      ),
    );
    return newDateTime;
  }

  static Widget buildEmptyIcon(
    IconData icon,
    String title,
  ) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: AppDimens.sizeIconExtraLarge,
            color: AppColors.orangeShade,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              title.tr,
              style: Get.textTheme.titleSmall!
                  .copyWith(fontSize: AppDimens.fontMedium()),
            ).paddingSymmetric(vertical: AppDimens.paddingSmall),
          ),
        ],
      ),
    );
  }

  static Widget buildTextFormField({
    String? title,
    required TextEditingController textEditingController,
    String hintText = '',
    int maxLength = 80,
    int? maxLines = 1,
    bool isValidate = false,
    bool enable = true,
    bool showMaxLength = true,
    TextAlign textAlign = TextAlign.start,
    TextInputAction textInputAction = TextInputAction.next,
    bool isProductCode = false,
    TextInputType keyboardType = TextInputType.multiline,
  }) {
    return TextFormField(
      keyboardAppearance: Brightness.light,
      validator: (val) {
        if (isValidate) {
          if (val!.isStringEmpty) {
            return AppStr.errorNoticeValidateNum.tr;
          }
          return null;
        }
        return null;
      },
      inputFormatters: isProductCode
          ? [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9-_\.]')),
              LengthLimitingTextFieldFormatterFixed(maxLength),
            ]
          : [
              LengthLimitingTextFieldFormatterFixed(maxLength),
            ],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType,
      style: Get.textTheme.bodyLarge,
      controller: textEditingController,
      maxLength: maxLength,
      maxLines: maxLines,
      enabled: enable,
      textAlign: textAlign,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.inputQuickTicket,
        hintText: hintText,
        hintStyle: Get.textTheme.bodyMedium!.copyWith(
          color: AppColors.dsGray3,
        ),
        labelText: title,
        labelStyle: Get.textTheme.bodyMedium!.copyWith(
          color: AppColors.dsGray3,
        ),
        errorStyle: const TextStyle(
          color: AppColors.colorRed,
        ),
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide:
              const BorderSide(width: 1, color: AppColors.inputQuickTicket),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide:
              const BorderSide(width: 1, color: AppColors.inputQuickTicket),
          borderRadius: BorderRadius.circular(10),
        ),
        counterText: showMaxLength ? null : "",
      ),
    ).paddingOnly(bottom: 4);
  }

  /// If style not null, color, fontWeight, overflow, fontSize will be ignored
  static Widget buildText(
    String text, {
    FontWeight? fontWeight,
    TextAlign? textAlign,
    Color? textColor,
    int? maxLine,
    double? fontSize,
    TextStyle? style,
  }) {
    return AutoSizeText(
      text.tr,
      textAlign: textAlign ?? TextAlign.start,
      style: style ??
          AppTextStyle.font12Re.copyWith(
            color: textColor ?? AppColors.grayLight2,
            fontWeight: fontWeight,
            overflow: TextOverflow.ellipsis,
            fontSize: fontSize ?? AppDimens.fontSmall(),
          ),
      maxLines: maxLine,
    );
  }

  static Widget buildSolidButton(
      {required String title,
      VoidCallback? onPressed,
      double? width,
      double? height,
      bool isLoading = false,
      bool showShadow = false,
      Color? backgroundColor}) {
    return Container(
      width: width,
      height: height ?? AppDimens.btnDefaultFigma,
      decoration: BoxDecoration(
        boxShadow: !showShadow
            ? null
            : [
                BoxShadow(
                  color: AppColors.colorConfirm.withOpacity(0.3),
                  blurRadius: 23.3,
                  offset: const Offset(1, 1),
                ),
              ],
      ),
      child: ElevatedButton(
        onPressed: () {
          DateTime now = DateTime.now();
          if (_dateTime == null ||
              now.difference(_dateTime ?? DateTime.now()) > throttleDuration ||
              onPressed.hashCode != _oldFunc) {
            _dateTime = now;
            _oldFunc = onPressed.hashCode;
            onPressed?.call();
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radius6),
          ),
          backgroundColor: backgroundColor ?? AppColors.primaryLight2,
          padding: const EdgeInsets.all(AppDimens.paddingVerySmall),
        ),
        child: Stack(
          children: [
            Center(
              child: buildText(
                title,
                style: AppTextStyle.font14Semi.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Visibility(
                visible: isLoading,
                child: const SizedBox(
                  height: AppDimens.btnSmall,
                  width: AppDimens.btnSmall,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.colorError,
                    ),
                  ),
                ),
              ).paddingOnly(right: AppDimens.paddingVerySmall),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildOutlineButton({
    required String title,
    String? secondTitle,
    VoidCallback? onPressed,
    double? width,
    double? height,
    Color? disableTextColor,
  }) {
    return SizedBox(
      width: width,
      height: height ?? AppDimens.btnDefaultFigma,
      child: OutlinedButton(
        onPressed: () {
          DateTime now = DateTime.now();
          if (_dateTime == null ||
              now.difference(_dateTime ?? DateTime.now()) > throttleDuration ||
              onPressed.hashCode != _oldFunc) {
            _dateTime = now;
            _oldFunc = onPressed.hashCode;
            onPressed?.call();
          }
        },
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radius6),
          ),
          side: BorderSide(
            color: onPressed != null
                ? AppColors.primaryLight2
                : AppColors.grayLight7,
          ),
          backgroundColor: onPressed != null
              ? AppColors.primaryLight7
              : AppColors.grayLight7,
        ),
        child: FittedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildText(
                title,
                style: AppTextStyle.font14Semi.copyWith(
                  color: onPressed != null
                      ? AppColors.primaryLight2
                      : disableTextColor ?? AppColors.grayLight6,
                ),
                textAlign: TextAlign.center,
              ),
              if (secondTitle != null)
                buildText(
                  secondTitle,
                  style: AppTextStyle.font14Semi.copyWith(
                    color: onPressed != null
                        ? AppColors.primaryLight2
                        : AppColors.grayLight4,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ).paddingSymmetric(vertical: AppDimens.paddingSmallest),
        ),
      ),
    );
  }

  static Widget buildDropdown<T>({
    required List<T> items,
    required String Function(T) display,
    T? selectedItem,
    Function(T?)? onChanged,
    double height = 50,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            const BorderRadius.all(Radius.circular(AppDimens.radius8)),
        border: Border.all(color: AppColors.grayLight7),
      ),
      child: DropdownButtonHideUnderlineCustom(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppDimens.defaultPadding),
          child: DropdownButtonCustom<T>(
            dropdownColor: Colors.white,
            isExpanded: true,
            items: items
                .map(
                  (e) => DropdownMenuItemCustom<T>(
                    value: e,
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimens.paddingVerySmall),
                      child: buildText(
                        display(e),
                        style: selectedItem == e
                            ? AppTextStyle.font14Bo
                            : AppTextStyle.font14Re,
                      ),
                    ),
                  ),
                )
                .toList(),
            value: selectedItem,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  static Widget buildChoiceChip({
    required String title,
    required bool isSelected,
    void Function(bool)? onChanged,
  }) {
    return ChoiceChip(
      label: buildText(
        title,
        style: AppTextStyle.font14Semi.copyWith(
          color: isSelected ? AppColors.primaryLight2 : AppColors.grayLight3,
        ),
      ),
      selected: isSelected,
      onSelected: onChanged,
      padding: const EdgeInsets.symmetric(
        vertical: AppDimens.paddingVerySmall,
        horizontal: AppDimens.paddingSmall,
      ),
      selectedColor: AppColors.primaryLight7,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isSelected ? AppColors.primaryLight2 : AppColors.grayLight7,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(AppDimens.radius16),
      ),
      showCheckmark: false,
    );
  }

  static Widget buildListChoiceChip<T>({
    required String title,
    required List<T> items,
    required String Function(T) itemTitle,
    T? selectedItem,
    ValueChanged<T>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildText(
          title,
          style: AppTextStyle.font14Bo.copyWith(color: AppColors.grayLight1),
        ).paddingOnly(
          bottom: AppDimens.paddingSmall,
        ),
        Wrap(
          alignment: WrapAlignment.start,
          spacing: AppDimens.paddingVerySmall,
          runSpacing: AppDimens.paddingVerySmall,
          children: items.map((item) {
            final isSelected = item == selectedItem;
            return buildChoiceChip(
              title: itemTitle(item),
              isSelected: isSelected,
              onChanged: (_) {
                onChanged?.call(item);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  static Widget buildBottomSheetFigma({
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.defaultPadding),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimens.radius30),
          topRight: Radius.circular(AppDimens.radius30),
        ),
      ),
      child: buildSafeArea(
        Container(
          constraints: BoxConstraints(maxHeight: Get.height * 0.8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildBottomSheetHeader(),
              child,
            ],
          ),
        ),
        color: Colors.transparent,
        miniumBottom: 18,
      ),
    );
  }

  static Widget buildBottomSheetItem({
    required String title,
    required String svgPath,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            svgPath,
            width: AppDimens.sizeIconMedium,
            height: AppDimens.sizeIconMedium,
          ).paddingOnly(
            right: AppDimens.defaultPadding,
          ),
          Expanded(
            child: UtilWidget.buildText(
              title,
              style: AppTextStyle.font16Semi.copyWith(
                color: AppColors.grayLight1,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ).paddingSymmetric(
        vertical: AppDimens.paddingSmall,
      ),
    );
  }

  static Widget buildBottomSheetHeader() {
    return Center(
      child: Container(
        height: AppDimens.paddingSmallest,
        width: AppDimens.sizeIconLarge,
        decoration: const BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(AppDimens.defaultPadding)),
          color: AppColors.grayLight6,
        ),
      ).paddingSymmetric(vertical: AppDimens.defaultPadding),
    );
  }

  static Widget buildCachedNetworkImage({
    double? width,
    double? height,
    required String url,
    ShimmerDirection direction = ShimmerDirection.ltr,
  }) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      placeholder: (context, url) {
        return const Center(
          child: CupertinoActivityIndicator(),
        );
      },
    );
  }
}
