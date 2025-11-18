import 'package:Azunii_Health/utils/percentage_size_ext.dart';
import 'package:Azunii_Health/views/widget/text.dart';
import 'package:flutter/material.dart';

import '../../consts/colors.dart';

class AppElevatedButton extends StatelessWidget {
  const AppElevatedButton({
    required this.onPressed,
    required this.title,
    this.textColor,
    this.fontSize,
    this.backgroundColor,
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final Function()? onPressed;
  final String title;
  final double? fontSize;
  final Color? backgroundColor;
  final double? width;
  final Color? textColor;

  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? context.percentWidth * 85,
      height: height ?? context.percentWidth * 12,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                10), // Removes the border radius (square corners)
          ),
          backgroundColor: backgroundColor ?? AppColors.green,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: subText5(
            fontSize: fontSize ?? 13,
            fontWeight: FontWeight.w500,
            title,
            color: textColor ?? AppColors.white,
          ),
        ),
      ),
    );
  }
}
