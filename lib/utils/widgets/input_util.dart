import 'package:flutter/material.dart';

import '../utils_src.dart';

class InputUtil {
  static void setPointerAfterText(
    TextEditingController textEditingController,
  ) {
    textEditingController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: textEditingController.text.length,
      ),
    );
  }

  static void buildInputDefault(
    TextEditingController textEditingController,
    String value, {
    int? lastDecimal,
    dynamic customMaxValue,
  }) {
    textEditingController
      ..text = CurrencyUtils.formatCurrencyForeign(
        value,
        lastDecimal: lastDecimal ?? 6,
        customMaxValue: customMaxValue,
      )
      ..selection = TextSelection.fromPosition(
        TextPosition(
          offset: CurrencyUtils.formatCurrencyForeign(
            value,
            lastDecimal: lastDecimal ?? 6,
            customMaxValue: customMaxValue,
          ).length,
        ),
      );
  }
}
