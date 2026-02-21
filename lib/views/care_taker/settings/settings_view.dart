import 'package:Azunii_Health/core/models/static_user_model.dart';
import 'package:Azunii_Health/views/care_taker/settings/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../consts/colors.dart';
import '../../../consts/lang.dart';
import '../../../utils/percentage_size_ext.dart';
import '../../widget/text.dart';
import '../../widget/buttons.dart';
import '../../widget/Common_widgets/customAppBar.dart';
import '../../widget/Common_widgets/overlayloader.dart';

class Settingsview extends StatefulWidget {
  static const String routeName = '/settings-caregiver';
  final bool isOnDashboard;
  const Settingsview({super.key, this.isOnDashboard = false});

  @override
  State<Settingsview> createState() => _SettingsviewState();
}

class _SettingsviewState extends State<Settingsview> {
  final RxBool isEditMode = false.obs;

  @override
  void initState() {
    super.initState();
    _prefillData();
  }

  void _prefillData() {
    final controller = Get.put(SettingsController());
    final user = Staticdata.userModel;
    if (user != null) {
      controller.nameController.text = user.name;
      controller.emailController.text = user.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    final user = Staticdata.userModel;
    final name = user?.name ?? 'Guest User';
    final email = user?.email ?? 'No email provided';
    final role = user?.role ?? 'N/A';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'G';

    return Obx(() => OverlayLoader(
          isLoading: controller.isLoading.value,
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: SafeArea(
              child: Column(
                children: [
                  CustomAppBar(
                    title: 'Profile',
                    isOndashboard: widget.isOnDashboard ?? false,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(context.screenWidth * 0.05),
                      child: Column(
                        children: [
                          // Profile Avatar
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: context.screenWidth * 0.13,
                              backgroundColor: AppColors.primary,
                              child: Text(
                                initial,
                                style: GoogleFonts.manrope(
                                  fontSize: context.screenWidth * 0.13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: context.screenHeight * 0.02),
                          // Name
                          Text(
                            name,
                            style: GoogleFonts.manrope(
                              fontSize: context.screenWidth * 0.07,
                              fontWeight: FontWeight.w700,
                              color: AppColors.headingTextColor,
                            ),
                          ),
                          SizedBox(height: context.screenHeight * 0.005),
                          // Email
                          Text(
                            email,
                            style: GoogleFonts.manrope(
                              fontSize: context.screenWidth * 0.0375,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColor,
                            ),
                          ),
                          SizedBox(height: context.screenHeight * 0.04),
                          // Role Card
                          _buildInfoCard(context, Icons.person_outline, 'Role',
                              role.toUpperCase()),
                          SizedBox(height: context.screenHeight * 0.03),
                          // Profile Update Form
                          _buildUpdateForm(context, controller),
                          SizedBox(height: context.screenHeight * 0.03),
                          // Action Buttons
                          _buildActionButtons(context, controller),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildInfoCard(
      BuildContext context, IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.all(context.screenWidth * 0.04),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.screenWidth * 0.04),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Icon(icon,
              color: AppColors.primary, size: context.screenWidth * 0.05),
          SizedBox(width: context.screenWidth * 0.03),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: context.screenWidth * 0.0325,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor.withOpacity(0.7),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: context.screenWidth * 0.035,
              fontWeight: FontWeight.w600,
              color: AppColors.headingTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateForm(BuildContext context, SettingsController controller) {
    return Obx(() => Container(
          padding: EdgeInsets.all(context.screenWidth * 0.05),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(context.screenWidth * 0.04),
            border: Border.all(color: AppColors.primary.withOpacity(0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update Profile',
                style: GoogleFonts.manrope(
                  fontSize: context.screenWidth * 0.045,
                  fontWeight: FontWeight.w600,
                  color: AppColors.headingTextColor,
                ),
              ),
              SizedBox(height: context.screenHeight * 0.02),
              _buildTextField(context, 'Name', controller.nameController,
                  enabled: isEditMode.value),
              SizedBox(height: context.screenHeight * 0.015),
              _buildTextField(context, 'Email', controller.emailController,
                  enabled: isEditMode.value),
              SizedBox(height: context.screenHeight * 0.015),
              _buildTextField(
                  context, 'Password', controller.passwordController,
                  isPassword: true, enabled: isEditMode.value),
              SizedBox(height: context.screenHeight * 0.015),
              _buildTextField(context, 'Confirm Password',
                  controller.confirmPasswordController,
                  isPassword: true, enabled: isEditMode.value),
              SizedBox(height: context.screenHeight * 0.025),
              SizedBox(
                width: double.infinity,
                height: context.screenWidth * 0.12,
                child: AppElevatedButton(
                  onPressed: () => _handleEditProfile(controller),
                  title: isEditMode.value ? 'Update Profile' : 'Edit Profile',
                  backgroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildTextField(
      BuildContext context, String label, TextEditingController textController,
      {bool isPassword = false, bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: context.screenWidth * 0.0325,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor,
          ),
        ),
        SizedBox(height: context.screenHeight * 0.008),
        TextField(
          controller: textController,
          obscureText: isPassword,
          enabled: enabled,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.screenWidth * 0.02),
              borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.screenWidth * 0.02),
              borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.screenWidth * 0.02),
              borderSide:
                  BorderSide(color: AppColors.textColor.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.screenWidth * 0.02),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            contentPadding: EdgeInsets.symmetric(
                horizontal: context.screenWidth * 0.03,
                vertical: context.screenHeight * 0.015),
          ),
        ),
      ],
    );
  }

  void _handleEditProfile(SettingsController controller) {
    if (isEditMode.value) {
      // Show confirmation before updating
      _showConfirmationDialog(
        title: 'Update Profile',
        message: 'Are you sure you want to update your profile information?',
        confirmText: 'Update',
        confirmColor: AppColors.primary,
        onConfirm: () {
          controller.updateProfile();
          isEditMode.value = false;
        },
      );
    } else {
      // Show confirmation before entering edit mode
      _showConfirmationDialog(
        title: 'Edit Profile',
        message: 'Do you want to edit your profile information?',
        confirmText: 'Edit',
        confirmColor: AppColors.primary,
        onConfirm: () {
          isEditMode.value = true;
        },
      );
    }
  }

  Widget _buildActionButtons(
      BuildContext context, SettingsController controller) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: context.screenWidth * 0.12,
            child: AppElevatedButton(
              onPressed: () => _showLogoutConfirmation(controller),
              title: Lang.logOut,
              backgroundColor: AppColors.cardGray,
              textColor: AppColors.headingTextColor,
            ),
          ),
        ),
        SizedBox(width: context.screenWidth * 0.04),
        Expanded(
          child: SizedBox(
            height: context.screenWidth * 0.12,
            child: AppElevatedButton(
              onPressed: () => _showDeleteAccountConfirmation(controller),
              title: Lang.deleteAccount,
              backgroundColor: AppColors.lightRed,
              textColor: AppColors.redColor,
            ),
          ),
        ),
      ],
    );
  }

  void _showLogoutConfirmation(SettingsController controller) {
    _showConfirmationDialog(
      title: 'Logout',
      message: 'Are you sure you want to logout from your account?',
      confirmText: 'Logout',
      confirmColor: AppColors.primary,
      onConfirm: () {
        controller.logout();
      },
    );
  }

  void _showDeleteAccountConfirmation(SettingsController controller) {
    _showConfirmationDialog(
      title: 'Delete Account',
      message:
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
      confirmText: 'Delete',
      confirmColor: Colors.red,
      onConfirm: () {
        controller.deleteAccount();
      },
    );
  }

  void _showConfirmationDialog({
    required String title,
    required String message,
    required String confirmText,
    required Color confirmColor,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.headingTextColor,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.manrope(
            fontSize: 14,
            color: AppColors.textColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.manrope(
                fontSize: 14,
                color: AppColors.textColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              confirmText,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
