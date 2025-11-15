import 'package:flutter/material.dart';
import '../../../../consts/colors.dart';
import '../../../../consts/lang.dart';
import '../../../../utils/percentage_size_ext.dart';
import '../../../widget/text.dart';
import '../../../widget/Common_widgets/customAppBar.dart';

class PrivacyView extends StatefulWidget {
  static const String routeName = '/privacy-settings';

  const PrivacyView({super.key});

  @override
  State<PrivacyView> createState() => _PrivacyViewState();
}

class _PrivacyViewState extends State<PrivacyView> {
  bool dataSharing = false;
  bool locationServices = true;
  bool biometricAuth = true;
  bool twoFactorAuth = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: Lang.privacySecurity,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.screenWidth * 0.05),
                    _buildPrivacyHeader(),
                    SizedBox(height: context.screenWidth * 0.04),
                    _buildPrivacyOptions(context),
                    SizedBox(height: context.screenWidth * 0.05),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: headline6(
        Lang.privacySecurity,
        color: AppColors.headingTextColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildPrivacyOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildSwitchOption(
            context: context,
            title: Lang.dataSharing,
            icon: Icons.share_outlined,
            value: dataSharing,
            onChanged: (value) => setState(() => dataSharing = value),
          ),
          SizedBox(height: context.screenWidth * 0.03),
          _buildSwitchOption(
            context: context,
            title: Lang.locationServices,
            icon: Icons.location_on_outlined,
            value: locationServices,
            onChanged: (value) => setState(() => locationServices = value),
          ),
          SizedBox(height: context.screenWidth * 0.03),
          _buildSwitchOption(
            context: context,
            title: Lang.biometricAuth,
            icon: Icons.fingerprint_outlined,
            value: biometricAuth,
            onChanged: (value) => setState(() => biometricAuth = value),
          ),
          SizedBox(height: context.screenWidth * 0.03),
          _buildSwitchOption(
            context: context,
            title: Lang.twoFactorAuth,
            icon: Icons.security_outlined,
            value: twoFactorAuth,
            onChanged: (value) => setState(() => twoFactorAuth = value),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchOption({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(context.screenWidth * 0.04),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.dividerGray,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: context.screenWidth * 0.1,
            height: context.screenWidth * 0.1,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: context.screenWidth * 0.05,
            ),
          ),
          SizedBox(width: context.screenWidth * 0.04),
          Expanded(
            child: subText4(
              title,
              color: AppColors.headingTextColor,
              fontWeight: FontWeight.w500,
              align: TextAlign.start,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
