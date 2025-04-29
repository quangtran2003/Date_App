import 'package:bot_toast/bot_toast.dart';
import 'package:easy_date/core/const/dimens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackBar(
  String message, {
  Duration? duration,
  bool isSuccess = true,
}) {
  BotToast.showCustomText(
    duration: duration ?? (message.length > 100 ? 4.seconds : 2.seconds),
    align: Alignment.bottomLeft,
    toastBuilder: (cancel) {
      return Material(
        color: isSuccess ? Colors.green : Colors.red,
        child: Container(
          width: Get.width,
          padding: const EdgeInsets.symmetric(
            vertical: AppDimens.paddingSmallest,
            horizontal: AppDimens.paddingDefault,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  message,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  maxLines: 3,
                ),
              ),
              IconButton(
                onPressed: cancel,
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
