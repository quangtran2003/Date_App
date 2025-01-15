import 'package:flutter/services.dart';
import '../core/const/const_src.dart';

String formatTicketNo(num number) {
  String invoiceNo = number.toInt().toString();

  if (invoiceNo.isEmpty) {
    return '';
  }
  final int count = 7 - invoiceNo.length;

  for (int index = 0; index < count; index++) {
    invoiceNo = '0$invoiceNo';
  }
  return invoiceNo;
}

String formatHourNo(int number) {
  if (number < 10) return '0$number';
  return number.toString();
}

class TaxCodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length == 11) {
      String newString;
      if (newValue.text.endsWith('-')) {
        newString = newValue.text;
      } else {
        newString =
            '${newValue.text.substring(0, 10)}-${newValue.text.substring(10, 11)}';
      }

      if (oldValue.text.length == 12) {
        newString = newString.substring(0, 10);
      }
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(offset: newString.length),
      );
    }
    if (newValue.text.endsWith('-') && newValue.text.length != 11) {
      return oldValue;
    }
    return newValue;
  }
}

String twoDigits(int n) {
  if (n >= 10) return '$n';
  return '0$n';
}

String formatBySeconds(Duration duration) =>
    twoDigits(duration.inSeconds.remainder(60));

String formatByMinutes(Duration duration) {
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  return '$twoDigitMinutes:${formatBySeconds(duration)}';
}

String formatByHours(Duration duration) {
  return '${twoDigits(duration.inHours)}:${formatByMinutes(duration)}';
}

String formatMessError(dynamic mess) {
  try {
    return mess.values.first;
  } catch (e) {
    return AppStr.errorInternalServer;
  }
}

String nameProd(String? name) {
  try {
    if (name == null) return "";
    return name;
  } catch (e) {
    return "";
  }
}

String removeSpecialCharacters(String str) =>
    str.toLowerCase().replaceAll(RegExp('[^A-Za-z0-9]'), '');
