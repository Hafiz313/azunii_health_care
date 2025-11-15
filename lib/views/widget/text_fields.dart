import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../consts/colors.dart';
import '../../consts/fonts.dart';

class CustomTxtField extends StatelessWidget {
  final String? hintTxt;
  final String? title;
  final bool isHiddenPassword;
  final bool enabled;
  final bool isRequired;
  final TextInputAction textInputAction;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? hintStyle;
  final Color? fillColor;
  int? maxLength;
  int? maxLines;
  List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  final TextEditingController? textEditingController;

  CustomTxtField(
      {Key? key,
      this.hintTxt,
      this.title,
      this.validator,
      this.keyboardType,
      this.textInputAction = TextInputAction.next,
      this.textEditingController,
      this.maxLength,
      this.inputFormatters,
      this.isHiddenPassword = false,
      this.prefixIcon,
      this.suffixIcon,
      this.enabled = true,
      this.isRequired = false,
      this.hintStyle,
      this.fillColor,
      this.maxLines = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Row(
              children: [
                Text(
                  title!,
                  style: const TextStyle(
                    color: AppColors.blackColor,
                    fontFamily: FontFamily.satoshi,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                if (isRequired)
                  const Text(
                    '*',
                    style: TextStyle(
                      color: AppColors.redColor,
                    ),
                  )
              ],
            ),
          if (title != null) const SizedBox(height: 4),
          TextFormField(
            textInputAction: textInputAction,
            enabled: enabled,
            inputFormatters: inputFormatters,
            cursorColor: AppColors.green,
            maxLength: maxLength,
            keyboardType: keyboardType,
            controller: textEditingController,
            obscureText: isHiddenPassword,
            validator: validator,
            maxLines: maxLines,
            style: const TextStyle(
                color: AppColors.blackColor,
                fontFamily: FontFamily.satoshi,
                fontWeight: FontWeight.w500,
                fontSize: 13),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 0.05, color: AppColors.primary),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 0.1, color: AppColors.primary),
                  borderRadius: BorderRadius.circular(10)),
              disabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 0.05, color: AppColors.primary),
                  borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 0.3, color: AppColors.secondary),
                  borderRadius: BorderRadius.circular(10)),
              errorBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 0.1, color: AppColors.redColor),
                  borderRadius: BorderRadius.circular(10)),
              prefixIcon: prefixIcon,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 0,
              ),
              suffixIcon: suffixIcon,
              hintText: hintTxt,
              fillColor: AppColors.cardsColor,
              filled: true,
              hintStyle: const TextStyle(
                  color: AppColors.blackColor,
                  fontFamily: FontFamily.satoshi,
                  fontSize: 13,
                  fontWeight: FontWeight.w200),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 1.0, horizontal: 12.0),
            ),
          ),
        ],
      ),
    );
  }
}
