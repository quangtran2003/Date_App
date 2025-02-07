import 'package:easy_date/features/feature_src.dart';

class BuildInputTextWithLabel extends StatelessWidget {
  final BuildInputText buildInputText;
  final String? label;
  final TextStyle? textStyle;
  final bool isRequired;

  const BuildInputTextWithLabel({
    Key? key,
    this.label,
    required this.buildInputText,
    this.isRequired = false,
    this.textStyle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: label != null,
          child: Row(
            children: [
              UtilWidget.buildText(
                label ?? '',
                style: textStyle ??
                    AppTextStyle.font16Bo.copyWith(
                      color: AppColors.grayLight1,
                    ),
              ),
              Visibility(
                visible: isRequired,
                child: UtilWidget.buildText(
                  '*',
                  fontSize: AppDimens.fontMedium(),
                  textColor: AppColors.colorRed,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: AppDimens.paddingVerySmall,
        ),
        buildInputText,
      ],
    );
  }
}
