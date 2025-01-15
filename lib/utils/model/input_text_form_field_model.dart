import 'package:flutter/material.dart';

class InputTextModel {
  final IconData? iconLeading;

  final String? hintText;

  String? label;

  final TextEditingController controller;

  final FocusNode? focusNode;

  final FocusNode? nextNode;

  final bool obscureText;

  final double borderRadius;

  final TextInputAction iconNextTextInputAction;

  final ValueChanged<String>? submitFunc;

  final ValueChanged<String>? onNext;

  final FormFieldValidator<String>? validator;

  /// 0 : LengthLimitingText. Giới hạn ký tự nhập(nếu có)
  /// 1 : digitsOnly. Chỉ nhập số
  /// 2 : TaxCode. Kiểu nhập là mã số thuế
  /// 3 : Không cho nhập các ký tự đặc biệt. dấu cách
  final int inputFormatters;

  final TextInputType textInputType;

  /// The [maxLength] must be null, -1 or greater than zero. If it is null or -1
  /// then no limit is enforced.
  final int? maxLengthInputForm;

  final bool isReadOnly;

  final bool autoFocus;

  Color? fillColor;

  final Color? textColor;

  final Color? hintTextColor;

  final double? hintTextSize;

  final Color? prefixIconColor;

  final Color? errorTextColor;

  final Color? suffixColor;

  final ValueChanged<String>? onChanged;

  final int? maxLines;

  final Widget? suffixIcon;

  bool isShowCounterText;

  bool isValidate;

  final TextAlign textAlign;

  final Function()? onTap;

  final BorderSide? borderSide;

  final bool isValidateLength;

  final bool isShowBorder;

  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final bool showIconClear;
  final String? iconAssets;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? disabledBorder;
  final InputBorder? enabledBorder;
  final InputBorder? focusedErrorBorder;

  InputTextModel({
    this.iconLeading,
    this.label,
    this.hintText,
    required this.controller,
    this.focusNode,
    this.submitFunc,
    this.nextNode,
    this.obscureText = false,
    this.iconNextTextInputAction = TextInputAction.next,
    this.onNext,
    this.validator,
    this.inputFormatters = 0,
    this.borderRadius = 10.0,
    this.textInputType = TextInputType.text,
    this.maxLengthInputForm,
    this.isReadOnly = false,
    this.autoFocus = false,
    this.fillColor,
    this.textColor,
    this.hintTextColor,
    this.hintTextSize,
    this.prefixIconColor,
    this.errorTextColor,
    this.suffixColor,
    this.onChanged,
    this.maxLines = 1,
    this.suffixIcon,
    this.isShowCounterText = true,
    this.isValidate = false,
    this.textAlign = TextAlign.left,
    this.onTap,
    this.borderSide,
    this.isValidateLength = false,
    this.isShowBorder = true,
    this.contentPadding,
    this.showIconClear = true,
    this.border,
    this.iconAssets,
    this.focusedBorder,
    this.errorBorder,
    this.disabledBorder,
    this.enabledBorder,
    this.focusedErrorBorder,
  });
}
