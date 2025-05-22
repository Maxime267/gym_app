import 'package:flutter/services.dart';

class TimeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    String formatted = '';
    if (digits.length <= 2) {
      formatted = digits;
    } else if (digits.length <= 4) {
      final minutes = digits.substring(0, digits.length - 2);
      final seconds = digits.substring(digits.length - 2);
      formatted = '$minutes:$seconds';
    } else {
      final minutes = digits.substring(0, 2);
      final seconds = digits.substring(2, 4);
      formatted = '$minutes:$seconds';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}