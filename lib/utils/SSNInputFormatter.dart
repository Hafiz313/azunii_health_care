import 'package:flutter/services.dart';

class SSNInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text =
        newValue.text.replaceAll(RegExp(r'\D'), ''); // Remove non-numeric chars

    String formattedText = '';
    for (int i = 0; i < text.length; i++) {
      if (i == 3 || i == 5) {
        formattedText += '-';
      }
      formattedText += text[i];
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
