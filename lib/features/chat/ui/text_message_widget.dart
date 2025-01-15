import 'package:easy_date/core/const/app_text_style.dart';
import 'package:easy_date/core/const/colors.dart';
import 'package:easy_date/core/const/dimens.dart';
import 'package:easy_date/features/chat/model/chat_message.dart';
import 'package:easy_date/features/chat/ui/message_date_widget.dart';
import 'package:flutter/material.dart';

import '../../../utils/utils_src.dart';

class TextMessageWidget extends StatelessWidget {
  const TextMessageWidget({
    Key? key,
    required this.message,
    this.showDate = false,
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
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (message.isMe)
                UtilWidget.buildText(
                  message.createTimeHHmma,
                  style: AppTextStyle.font10Re.copyWith(
                    color: AppColors.grayLight6,
                  ),
                ).paddingOnly(right: AppDimens.paddingSmallest),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(1, 1),
                        color: Colors.black12,
                        blurRadius: 2,
                      ),
                    ],
                    color: message.isMe
                        ? AppColors.senderMessageBgColor
                        : AppColors.receiverMessageBgColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(AppDimens.radius16),
                      topRight: const Radius.circular(AppDimens.radius16),
                      bottomLeft: message.isMe
                          ? const Radius.circular(AppDimens.radius16)
                          : Radius.zero,
                      bottomRight: message.isMe
                          ? Radius.zero
                          : const Radius.circular(AppDimens.radius16),
                    ),
                  ),
                  child: UtilWidget.buildText(
                    message.content,
                    style: AppTextStyle.font16Semi.copyWith(
                      color: AppColors.grayLight1,
                    ),
                    maxLine: 20,
                  ).paddingSymmetric(
                    vertical: AppDimens.paddingSmall,
                    horizontal: AppDimens.defaultPadding,
                  ),
                ),
              ),
              if (!message.isMe)
                UtilWidget.buildText(
                  message.createTimeHHmma,
                  style: AppTextStyle.font10Re.copyWith(
                    color: AppColors.grayLight6,
                  ),
                ).paddingOnly(left: AppDimens.paddingSmallest),
            ],
          ).paddingOnly(
            left: message.isMe ? AppDimens.paddingMedium : 0,
            right: message.isMe ? 0 : AppDimens.paddingMedium,
          ),
        ),
      ],
    );
  }
}
