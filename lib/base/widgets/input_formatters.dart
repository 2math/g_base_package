import 'package:flutter/services.dart';

///Use as :
/// inputFormatters: [
///        WhitelistingTextInputFormatter(RegExp(r'[\d+\-\.]')),
///        NumberTextInputFormatter(decimalRange: 2),
///      ]
class NumberTextInputFormatter extends TextInputFormatter {
  NumberTextInputFormatter({this.decimalRange}) : assert(decimalRange == null || decimalRange > 0);

  final int? decimalRange;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    TextEditingValue newValue0 = sanitize(newValue);
    String text = newValue0.text;

    if (decimalRange == null) {
      return newValue0;
    }

    if (text == '.') {
      return TextEditingValue(
        text: '0.',
        selection: newValue0.selection.copyWith(baseOffset: 2, extentOffset: 2),
        composing: TextRange.empty,
      );
    }

    return isValid(text) ? newValue0 : oldValue;
  }

  bool isValid(String text) {
    int dots = '.'.allMatches(text).length;

    if (dots == 0) {
      return true;
    }

    if (dots > 1) {
      return false;
    }

    return text.substring(text.indexOf('.') + 1).length <= decimalRange!;
  }

  TextEditingValue sanitize(TextEditingValue value) {
    if (false == value.text.contains('-')) {
      return value;
    }

    String text = '-${value.text.replaceAll('-', '')}';

    return TextEditingValue(text: text, selection: value.selection, composing: TextRange.empty);
  }
}