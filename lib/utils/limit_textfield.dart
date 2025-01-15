import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LengthLimitingTextFieldFormatterFixed
    extends LengthLimitingTextInputFormatter {
  @override
  // ignore: overridden_fields
  final int? maxLength;
  LengthLimitingTextFieldFormatterFixed(this.maxLength) : super(maxLength);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (maxLength == null ||
        maxLength == -1 ||
        newValue.text.characters.length <= maxLength!) {
      return newValue;
    }
    if (maxLength! > 0 && newValue.text.characters.length > maxLength!) {
      // If already at the maximum and tried to enter even more, keep the old
      // value.
      if (oldValue.text.characters.length == maxLength) {
        return oldValue;
      }

      // ignore: invalid_use_of_visible_for_testing_member
      return LengthLimitingTextInputFormatter.truncate(newValue, maxLength!);
    }
    return newValue;
  }
}
