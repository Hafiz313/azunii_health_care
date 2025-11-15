import 'package:flutter/material.dart';
import '../../../consts/colors.dart';
import '../../widget/text.dart';

class Medication_caretaker extends StatelessWidget {
  static const String routeName = '/medication-caregiver';
  
  const Medication_caretaker({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBG,
      body: SafeArea(
        child: Center(
          child: headingText1(
            'Caregiver Medication',
            color: AppColors.headingTextColor,
          ),
        ),
      ),
    );
  }
}