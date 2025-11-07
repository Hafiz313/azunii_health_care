import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    required this.onPressed,
    required this.title,
    this.backgroundColor,
    Key? key,
    this.width,
    this.height, this.textStyle,
  }) : super(key: key);

  final Function()? onPressed;
  final String title;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      // style: ElevatedButton.styleFrom(
      //   backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.secondary,
      // ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Text(
          title,
          style:textStyle?? const TextStyle(
            color: Colors.white, // Or any color you prefer
            fontSize: 16.0, // Adjust font size as needed
          ),
        ),
      ),
    );
  }
}
