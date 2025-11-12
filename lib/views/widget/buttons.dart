import 'package:azunii_health_care/utils/percentage_size_ext.dart';
import 'package:azunii_health_care/views/widget/text.dart';
import 'package:flutter/material.dart';

import '../../consts/colors.dart';

class AppElevatedButton extends StatelessWidget {
  const AppElevatedButton({
    required this.onPressed,
    required this.title,
    this.textColor,
    this.backgroundColor,
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final Function()? onPressed;
  final String title;
  final Color? backgroundColor;
  final double? width;
  final Color? textColor;

  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? context.percentWidth * 85,
      height: height ?? context.percentWidth * 11,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                5), // Removes the border radius (square corners)
          ),
          backgroundColor: backgroundColor ?? AppColors.green,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: subText2(
            fontWeight: FontWeight.w400,
            title,
            color: textColor ?? AppColors.white,
          ),
        ),
      ),
    );
  }
}
