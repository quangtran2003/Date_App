import 'package:easy_date/utils/widgets/util_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../core/core_src.dart';
import '../../chat_src.dart';

class CallMessageWidget extends StatelessWidget {
  const CallMessageWidget({
    Key? key,
    required this.message,
    required this.showDate,
  }) : super(key: key);

  final ChatMessage message;
  final bool showDate;

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
              UtilWidget.buildText(
                'ở đây có 1 cuộc gọi',
                style: AppTextStyle.font10Re.copyWith(
                  color: AppColors.grayLight6,
                ),
              ).paddingOnly(right: AppDimens.paddingSmallest),
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
}
