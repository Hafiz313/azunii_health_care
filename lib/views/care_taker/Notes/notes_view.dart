import 'package:flutter/material.dart';
import '../../../consts/colors.dart';
import '../../widget/text.dart';

class Notesview extends StatelessWidget {
  static const String routeName = '/notes-caregiver';
  
  const Notesview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBG,
      body: SafeArea(
        child: Center(
          child: headingText1(
            'Caregiver Notes',
            color: AppColors.headingTextColor,
          ),
        ),
      ),
    );
  }
}