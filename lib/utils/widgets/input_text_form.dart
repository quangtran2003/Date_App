import 'package:flutter_svg/svg.dart';

import '../../core/const/const_src.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils_src.dart';

class BuildInputText extends StatefulWidget {
  final InputTextModel inputTextFormModel;

  const BuildInputText(this.inputTextFormModel, {super.key});

  @override
  BuildInputTextState createState() => BuildInputTextState();
}

class BuildInputTextState extends State<BuildInputText> {
  final RxBool _isShowButtonClear = false.obs;
  final RxBool _showPassword = false.obs;

  @override
  void initState() {
    widget.inputTextFormModel.controller.addListener(() {
      if (widget.inputTextFormModel.controller.text.isNotEmpty) {
        _isShowButtonClear.value = true;
      }
    });
    _showPassword.value = widget.inputTextFormModel.obscureText;
    super.initState();
  }

  List<TextInputFormatter> getFormatters() {
    switch (widget.inputTextFormModel.inputFormatters) {
      case 1:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(
              widget.inputTextFormModel.maxLengthInputForm),
        ];
      case 2:
        return [
          TaxCodeFormatter(),
          FilteringTextInputFormatter.allow(RegExp(r"[0-9-]")),
          LengthLimitingTextInputFormatter(14),
        ];
      case 3:
        return [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9-_\.]')),
        ];
      case 4:
        return [
          NumericTextFormatter(),
        ];
      case 5:
        return [
          FilteringTextInputFormatter.deny(RegExp(r'( )')),
        ];
      default:
        return [
          LengthLimitingTextFieldFormatterFixed(
              widget.inputTextFormModel.maxLengthInputForm)
        ];
    }
  }

  Widget? _suffixIcon() {
    if (widget.inputTextFormModel.suffixIcon != null) {
      return widget.inputTextFormModel.suffixIcon;
    }
    if (!_isShowButtonClear.value || widget.inputTextFormModel.isReadOnly) {
      return null;
    }
    return widget.inputTextFormModel.obscureText
        ? GestureDetector(
            onTap: () {
              _showPassword.toggle();
            },
            child: Icon(
              _showPassword.value
                  ? Icons.visibility_off_outlined
                  : Icons.remove_red_eye_outlined,
              color: widget.inputTextFormModel.suffixColor ?? AppColors.dsGray1,
            ),
          )
        : Visibility(
            visible: _isShowButtonClear.value &&
                !widget.inputTextFormModel.isReadOnly,
            child: GestureDetector(
              onTap: () {
                widget.inputTextFormModel.controller.clear();
                _isShowButtonClear.value = false;
              },
              child: Icon(
                Icons.clear,
                color:
                    widget.inputTextFormModel.suffixColor ?? AppColors.dsGray1,
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextFormField(
        maxLines: widget.inputTextFormModel.maxLines,
        inputFormatters: getFormatters(),
        validator: widget.inputTextFormModel.validator ??
            (value) {
              if (value!.isEmpty &&
                  widget.inputTextFormModel.isValidate &&
                  widget.inputTextFormModel.label.isStringNotEmpty) {
                return widget.inputTextFormModel.label! + AppStr.inputEmpty;
              } else {
                if (value.length <= 10 &&
                    widget.inputTextFormModel.isValidateLength) {
                  return widget.inputTextFormModel.label! +
                      AppStr.inputValidateLength();
                }
              }
              return null;
            },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (v) {
          if (!_isShowButtonClear.value || v.isEmpty) {
            _isShowButtonClear.value = v.isNotEmpty;
          }
          widget.inputTextFormModel.onChanged?.call(v);
        },
        textInputAction: widget.inputTextFormModel.iconNextTextInputAction,
        style: TextStyle(
          color: widget.inputTextFormModel.textColor ?? AppColors.dsGray1,
          fontSize:
              widget.inputTextFormModel.hintTextSize ?? AppDimens.fontSmall(),
        ),
        controller: widget.inputTextFormModel.controller,
        obscureText: _showPassword.value,
        onTap: widget.inputTextFormModel.onTap,
        autofocus: widget.inputTextFormModel.autoFocus,
        focusNode: widget.inputTextFormModel.focusNode,
        textAlign: widget.inputTextFormModel.textAlign,
        keyboardType: widget.inputTextFormModel.textInputType,
        readOnly: widget.inputTextFormModel.isReadOnly,
        maxLength: widget.inputTextFormModel.maxLengthInputForm,
        onFieldSubmitted: (v) {
          if (widget.inputTextFormModel.submitFunc != null) {
            widget.inputTextFormModel.submitFunc!.call(v);
          } else if (widget.inputTextFormModel.iconNextTextInputAction
                  .toString() ==
              TextInputAction.next.toString()) {
            FocusScope.of(context)
                .requestFocus(widget.inputTextFormModel.nextNode);

            widget.inputTextFormModel.onNext?.call(v);
          }
        },
        decoration: InputDecoration(
          counterText: widget.inputTextFormModel.isShowCounterText ? null : '',
          filled: true,
          fillColor: widget.inputTextFormModel.fillColor ?? Colors.white,
          hintStyle: AppTextStyle.font14Re.copyWith(
            color:
                widget.inputTextFormModel.hintTextColor ?? AppColors.grayLight4,
          ),
          hintText: widget.inputTextFormModel.hintText,
          errorStyle: TextStyle(
            color: widget.inputTextFormModel.errorTextColor ??
                const Color(0xFFFF0000),
          ),
          errorMaxLines: 2,
          prefixIcon: widget.inputTextFormModel.iconLeading != null
              ? Icon(
                  widget.inputTextFormModel.iconLeading,
                  color: widget.inputTextFormModel.prefixIconColor ??
                      Colors.black54,
                  size: 20,
                )
              : (widget.inputTextFormModel.iconAssets != null
                  ? SizedBox(
                      width: AppDimens.sizeIconDefault,
                      height: AppDimens.sizeIconDefault,
                      child: Center(
                        child: SvgPicture.asset(
                          widget.inputTextFormModel.iconAssets!,
                        ),
                      ),
                    )
                  : null),
          prefixStyle:
              const TextStyle(color: Colors.red, backgroundColor: Colors.white),
          border: widget.inputTextFormModel.border ?? InputBorder.none,
          contentPadding: widget.inputTextFormModel.contentPadding ??
              const EdgeInsets.all(AppDimens.paddingSmall),
          suffixIcon:
              widget.inputTextFormModel.showIconClear ? _suffixIcon() : null,
          focusedBorder: widget.inputTextFormModel.focusedBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radius6),
                borderSide: const BorderSide(color: AppColors.primaryLight2),
              ),
          errorBorder: widget.inputTextFormModel.errorBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radius6),
                borderSide: const BorderSide(color: Colors.red),
              ),
          enabledBorder: widget.inputTextFormModel.enabledBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radius6),
                borderSide: const BorderSide(
                  color: AppColors.grayLight7,
                ),
              ),
          disabledBorder: widget.inputTextFormModel.disabledBorder,
          focusedErrorBorder: widget.inputTextFormModel.focusedErrorBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radius6),
                borderSide: const BorderSide(color: Colors.red),
              ),
        ),
      ),
    );
  }
}
