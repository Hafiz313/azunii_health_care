import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../consts/colors.dart';
import '../../widget/Common_widgets/customAppBar.dart';

class PrivacyPolicyView extends StatefulWidget {
  static const String routeName = '/privacy-policy';
  const PrivacyPolicyView({super.key});

  @override
  State<PrivacyPolicyView> createState() => _PrivacyPolicyViewState();
}

class _PrivacyPolicyViewState extends State<PrivacyPolicyView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Privacy Policy',
              isOndashboard: false,
            ),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        'Information We Collect',
                        'We collect information you provide directly to us, such as when you create an account, use our services, or contact us for support.',
                      ),
                      _buildSection(
                        'How We Use Your Information',
                        'We use the information we collect to provide, maintain, and improve our services, process transactions, and communicate with you.',
                      ),
                      _buildSection(
                        'Information Sharing',
                        'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this policy.',
                      ),
                      _buildSection(
                        'Data Security',
                        'We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.',
                      ),
                      _buildSection(
                        'Your Rights',
                        'You have the right to access, update, or delete your personal information. You may also opt out of certain communications from us.',
                      ),
                      _buildSection(
                        'Contact Us',
                        'If you have any questions about this Privacy Policy, please contact us at privacy@azunii.com',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.headingTextColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}