import 'package:flutter/services.dart';

import 'utils_src.dart';

class NumericTextFormatter extends TextInputFormatter {
  //0: VND, 1: Foreign
  final int type;

  final bool isDot;

  NumericTextFormatter({
    this.type = 0,
    this.isDot = false,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      if (newValue.text.replaceAll(RegExp(r"[-0-9.,]"), '').isNotEmpty) {
        return newValue = oldValue;
      }
      final newString = type == 0
          ? CurrencyUtils.formatCurrency(
              CurrencyUtils.formatNumberCurrency(
                newValue.text,
                isDot: isDot,
              ),
              isDot: isDot,
            )
          : CurrencyUtils.formatCurrencyForeign(
              newValue.text,
              isDot: isDot,
            );
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(offset: newString.length),
      );
    } else {
      return newValue;
    }
  }
}
