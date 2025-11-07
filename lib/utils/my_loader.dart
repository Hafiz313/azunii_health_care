
import 'package:flutter/material.dart';

import '../consts/colors.dart';

class MyLoader extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color color;

  const MyLoader(
      {super.key,
      this.size = 30.0,
      this.strokeWidth = 4.0,
      this.color = AppColors.primary});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }
}
