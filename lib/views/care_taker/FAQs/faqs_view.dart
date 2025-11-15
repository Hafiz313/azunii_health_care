import 'package:flutter/material.dart';
import '../../../consts/colors.dart';
import '../../widget/text.dart';

class FAQsView extends StatelessWidget {
  static const String routeName = '/faqs-caregiver';

  const FAQsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBG,
      body: SafeArea(
        child: Center(
          child: headingText1(
            'Caregiver FAQs',
            color: AppColors.headingTextColor,
          ),
        ),
      ),
    );
  }
}
