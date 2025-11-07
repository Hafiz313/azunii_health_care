import 'package:azunii_health_care/utils/percentage_size_ext.dart';
import 'package:azunii_health_care/views/widget/text.dart';
import 'package:flutter/material.dart';

import '../../consts/colors.dart';

class AppElevatedButtonV1 extends StatefulWidget {
  AppElevatedButtonV1({
    required this.onPressed,
    required this.title,
    this.backgroundColor,
    super.key,
  });

  final Function()? onPressed;
  final String title;
  final Color? backgroundColor;

  @override
  State<AppElevatedButtonV1> createState() => _AppElevatedButtonV1State();
}

class _AppElevatedButtonV1State extends State<AppElevatedButtonV1> {
  TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              5), // Removes the border radius (square corners)
        ),
        backgroundColor: widget.backgroundColor ?? AppColors.green,
      ),
      child: Text(
        widget.title,
        style: textStyle ??
             const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize:  14),
      ),
    );
  }
}
