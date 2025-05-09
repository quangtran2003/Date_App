import 'package:easy_date/features/feature_src.dart';

class CallMessageWidget extends StatelessWidget {
  const CallMessageWidget({
    Key? key,
    required this.message,
    required this.showDate,
    required this.receiverName,
    required this.onTap,
  }) : super(key: key);

  final ChatMessage message;
  final bool showDate;
  final String receiverName;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showDate) MessageDateWidget(date: message.createTimeDdMMyyyy),
        Align(
          alignment:
              message.isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (message.isMe)
                UtilWidget.buildText(
                  message.createTimeHHmma,
                  style: AppTextStyle.font10Re.copyWith(
                    color: AppColors.grayLight6,
                  ),
                ).paddingOnly(right: AppDimens.paddingSmallest),
              _buildBoxCallAgain(onTap),
              if (!message.isMe)
                UtilWidget.buildText(
                  message.createTimeHHmma,
                  style: AppTextStyle.font10Re.copyWith(
                    color: AppColors.grayLight6,
                  ),
                ).paddingOnly(left: AppDimens.paddingSmallest),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBoxCallAgain(Function()? onTap) {
    final isAudioCall = message.type == MessageTypeEnum.audioCall;
    final titleCall = '${LocaleKeys.call_called.trParams({
          'user': message.isMe ? LocaleKeys.call_you.tr : receiverName,
        }).tr}${isAudioCall ? LocaleKeys.call_audio.tr : LocaleKeys.call_video.tr}';
    return InkWell(
      onTap: onTap,
      child: Container(
        width: AppDimens.sizeImageLarge,
        height: AppDimens.sizeImageBig,
        decoration: BoxDecoration(
          color: AppColors.receiverMessageBgColor,
          borderRadius: BorderRadius.circular(AppDimens.radius16),
        ),
        child: Column(
          children: [
            Expanded(
              child: UtilWidget.buildText(
                titleCall,
                maxLine: 2,
                style: AppTextStyle.font12Re.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            UtilWidget.buildDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: AppDimens.paddingSmallest,
              children: [
                Icon(
                  isAudioCall ? Icons.call : Icons.videocam,
                  size: AppDimens.sizeIconDefault,
                ),
                UtilWidget.buildText(
                  LocaleKeys.call_callAgain.tr,
                  style: AppTextStyle.font12Re.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ).paddingAll(AppDimens.paddingVerySmall),
      ),
    );
  }
}
