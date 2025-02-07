import 'package:easy_date/features/feature_src.dart';

class SDSBottomSheet extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? iconTitle;
  final bool isSecondDisplay;
  final bool isMiniSize;
  final double? miniSizeHeight;
  final Function()? onPressed;
  final Widget? actionArrowBack;
  final double? padding;
  final double? paddingBottom;
  final double? paddingTop;
  final bool noAppBar;
  final Color? backgroundColor;
  final TextAlign? textAlign;
  final double? maxWidth;
  final AlignmentGeometry? alignment;
  final bool isHeightMin;
  final double? paddingPage;
  const SDSBottomSheet({
    super.key,
    required this.title,
    required this.body,
    this.iconTitle,
    this.isSecondDisplay = false,
    this.isMiniSize = false,
    this.miniSizeHeight,
    this.onPressed,
    this.actionArrowBack,
    this.padding,
    this.paddingBottom,
    this.paddingTop,
    this.noAppBar = false,
    this.backgroundColor,
    this.textAlign,
    this.maxWidth,
    this.alignment,
    this.isHeightMin = false,
    this.paddingPage,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: paddingPage ?? AppDimens.paddingVerySmall,
        ),
        constraints: BoxConstraints(
          maxWidth: double.infinity,
          maxHeight: Get.height / 1.1,
        ),
        decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(
              AppDimens.radius8,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            noAppBar
                ? const SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title.tr,
                          textAlign: textAlign ?? TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Get.textTheme.titleLarge!.copyWith(),
                        ).paddingOnly(
                          left: AppDimens.paddingHuge,
                        ),
                      ),
                      SizedBox(
                        width: AppDimens.btnLarge,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: actionArrowBack ?? const CloseButton(),
                        ),
                      ),
                      iconTitle ?? const SizedBox(),
                    ],
                  ),
            isMiniSize
                ? Flexible(
                    child: SizedBox(
                      height: isHeightMin
                          ? null
                          : (miniSizeHeight ?? Get.height / 2),
                      child: body,
                    ),
                  )
                : Expanded(
                    child: body,
                  ),
          ],
        ).paddingSymmetric(
          horizontal: padding ?? 0,
        ),
      ),
    ).paddingOnly(
      bottom: paddingBottom ?? 0,
      top: paddingTop ?? 0,
    );
  }
}
