import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import '../../core/const/const_src.dart';
import '../utils_src.dart';

class NumericKeyboard extends StatelessWidget
    with KeyboardCustomPanelMixin<TextEditingController>
    implements PreferredSizeWidget {
  @override
  final ValueNotifier<TextEditingController> notifier;
  final FocusNode focusNode;
  final void Function(String)? onChange;
  final int? typeFormatInput;
  final Widget? buttonBar;
  final int? lastDecimal;
  final int? maxlengthNum;
  final bool isCheckError;

  NumericKeyboard({
    super.key,
    required this.notifier,
    required this.focusNode,
    this.onChange,
    this.buttonBar,
    this.typeFormatInput,
    this.lastDecimal,
    this.maxlengthNum,
    this.isCheckError = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(buttonBar != null ? 315 : 270);

  String _formatValue(String oldValue, String newValue) {
    if (newValue.isEmpty) {
      return '';
    } else if (newValue.compareTo(oldValue) != 0) {
      if (newValue.length == 1 && newValue == '-') {
        return newValue;
      }
      if (newValue.replaceAll(RegExp(r"[-0-9]"), '').contains('..')) {
        return newValue = oldValue;
      }
      if (newValue.replaceAll(RegExp(r"[-0-9.,]"), '').isNotEmpty ||
          newValue.endsWith('-')) {
        return newValue = oldValue;
      }
      final newString = typeFormatInput == 0
          ? CurrencyUtils.formatCurrency(
              CurrencyUtils.formatNumberCurrency(newValue))
          : CurrencyUtils.formatCurrencyForeign(
              newValue,
              lastDecimal: lastDecimal,
              maxLengthNum: maxlengthNum,
              isCheckError: isCheckError,
            );

      return newString;
    } else {
      return newValue;
    }
  }

  void _insertText(String myText) {
    if (myText == BaseWidgetStr.done.tr) {
      focusNode.unfocus();
      return;
    }
    final text = notifier.value.text;
    final textSelection = notifier.value.selection;
    final newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      myText,
    );
    notifier.value.text = _formatValue(text, newText);
    notifier.value.selection = TextSelection.fromPosition(
        TextPosition(offset: notifier.value.text.length));

    updateValue(notifier.value);
    if (onChange != null) onChange!(notifier.value.text);
  }

  void _backspace() {
    final text = notifier.value.text;
    final textSelection = notifier.value.selection;
    final selectionLength = textSelection.end - textSelection.start;

    // There is a selection.
    if (selectionLength > 0) {
      final newText = text.replaceRange(
        textSelection.start,
        textSelection.end,
        '',
      );
      notifier.value.text = newText;
      notifier.value.selection = textSelection.copyWith(
        baseOffset: textSelection.start,
        extentOffset: textSelection.start,
      );
      return;
    }

    // The cursor is at the beginning.
    if (textSelection.start == 0) {
      return;
    }

    // Delete the previous character
    final previousCodeUnit = text.codeUnitAt(textSelection.start - 1);
    final offset = _isUtf16Surrogate(previousCodeUnit) ? 2 : 1;
    final newStart = textSelection.start - offset;
    final newEnd = textSelection.start;
    final newText = text.replaceRange(
      newStart,
      newEnd,
      '',
    );
    notifier.value.text = _formatValue(notifier.value.text, newText);

    notifier.value.selection = TextSelection.fromPosition(
        TextPosition(offset: notifier.value.text.length));
    updateValue(notifier.value);
    if (onChange != null) onChange!(notifier.value.text);
  }

  bool _isUtf16Surrogate(int value) {
    return value & 0xF800 == 0xD800;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap để rỗng để tránh việc click vào bàn phím => unfocus(mất bàn phím)
      onTap: () {},
      child: Material(
        elevation: 0.0,
        child: SingleChildScrollView(
          child: SizedBox(
            height: preferredSize.height,
            child: Column(
              children: [
                if (buttonBar != null) buttonBar!,
                Expanded(
                  child: Container(
                    color: Colors.black,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _keyboardInputButton(label: '1'),
                              _keyboardInputButton(label: '2'),
                              _keyboardInputButton(label: '3'),
                              _keyboardInputButton(label: '.'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _keyboardInputButton(label: '4'),
                              _keyboardInputButton(label: '5'),
                              _keyboardInputButton(label: '6'),
                              // _keyboardInputButton(
                              //     label: Get.find<AppController>().isSys78.value
                              //         ? ''
                              //         : '-'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _keyboardInputButton(label: '7'),
                              _keyboardInputButton(label: '8'),
                              _keyboardInputButton(label: '9'),
                              _keyboardInputButton(
                                  label: '',
                                  icon: Icons.backspace_outlined,
                                  color: AppColors.chipColor,
                                  function: _backspace),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _keyboardInputButton(label: '000'),
                              _keyboardInputButton(label: '0'),
                              _keyboardInputButton(
                                label: 'CE',
                                color: AppColors.chipColor,
                                function: () {
                                  notifier.value.text = '';
                                  notifier.value.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: notifier.value.text.length));
                                  updateValue(notifier.value);

                                  onChange?.call(notifier.value.text);
                                },
                              ),
                              _keyboardInputButton(
                                label: '',
                                icon: Icons.done,
                                color: AppColors.chipColor,
                                function: () => focusNode.unfocus(),
                              ),
                            ],
                          ),
                        )
                      ],
                    ).paddingOnly(top: 5, bottom: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _keyboardInputButton({
    required String label,
    IconData? icon,
    Color? color,
    Function? function,
  }) {
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      color: color ?? AppColors.white,
      child: InkWell(
        onTap: () => function != null ? function() : _insertText(label),
        child: SizedBox(
          height: 50,
          width: (Get.size.width / 4) - 10,
          child: Center(
            child: icon != null
                ? Icon(
                    icon,
                    color: AppColors.dsGray1,
                    size: 22,
                  )
                : AutoSizeText(
                    label,
                    style: Get.theme.textTheme.bodyLarge!.copyWith(
                      color: AppColors.dsGray1,
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
