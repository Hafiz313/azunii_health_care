
import 'package:Azunii_Health/core/models/static_user_model.dart';
import 'package:Azunii_Health/utils/percentage_size_ext.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/customAppBar.dart';
import 'package:Azunii_Health/views/widget/Common_widgets/overlayloader.dart';
import 'package:Azunii_Health/views/widget/buttons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';
import 'controller/home_controller.dart';

class ProfileView extends StatefulWidget {
  final bool? isOndashboard;
  const ProfileView({super.key, this.isOndashboard = false});

  static const String routeName = '/profile';

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final HomeController controller = Get.find<HomeController>();
  final RxBool isEditMode = false.obs;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    _animationController.forward();
    _prefillData();
  }

  void _prefillData() {
    final user = Staticdata.userModel;
    if (user != null) {
      controller.nameController.text = user.name;
      controller.emailController.text = user.email;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  isOndashboard: widget.isOndashboard ?? false,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            //const SizedBox(height: 20),
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
                                radius: 50,
                                backgroundColor: AppColors.primary,
                                child: Text(
                                  initial,
                                  style: GoogleFonts.manrope(
                                    fontSize: context.percentWidth * 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            // Name
                            Text(
                              name,
                              style: GoogleFonts.manrope(
                                fontSize: context.percentWidth * 7,
                                fontWeight: FontWeight.w700,
                                color: AppColors.headingTextColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Email
                            Text(
                              email,
                              style: GoogleFonts.manrope(
                                fontSize: context.percentWidth * 3.75,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textColor,
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Role Card
                            _buildInfoCard(
                              context,
                              Icons.person_outline,
                              'Role',
                              role.toUpperCase(),
                            ),
                            const SizedBox(height: 24),
                            // Profile Update Form
                            _buildUpdateForm(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )));
  }

  Widget _buildUpdateForm() {
    return Obx(() => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withOpacity(0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update Profile',
                style: GoogleFonts.manrope(
                  fontSize: context.percentWidth * 4.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.headingTextColor,
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField('Name', controller.nameController,
                  enabled: isEditMode.value),
              const SizedBox(height: 12),
              _buildTextField('Email', controller.emailController,
                  enabled: isEditMode.value),
              const SizedBox(height: 12),
              _buildTextField('Password', controller.passwordController,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  enabled: isEditMode.value),
              const SizedBox(height: 12),
              _buildTextField(
                  'Confirm Password', controller.confirmPasswordController,
                  isPassword: true,
                  obscureText: _obscureConfirmPassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                  enabled: isEditMode.value),
              const SizedBox(height: 20),
              // Edit/Update Profile Button
              SizedBox(
                width: double.infinity,
                height: 45,
                child: AppElevatedButton(
                  onPressed: () => _handleEditProfile(),
                  title: isEditMode.value ? 'Update Profile' : 'Edit Profile',
                  backgroundColor: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 45,
                child: OutlinedButton(
                  onPressed: () => _showLogoutConfirmation(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Delete Account Button
              SizedBox(
                width: double.infinity,
                height: 45,
                child: OutlinedButton(
                  onPressed: () => _showDeleteAccountConfirmation(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.delete_forever, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Delete Account',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void _handleEditProfile() {
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

  void
  _showLogoutConfirmation() {
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

  void _showDeleteAccountConfirmation() {
    _showConfirmationDialog(
      title: 'Delete Account',
      message: 'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
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


  Widget _buildTextField(String label, TextEditingController textController,
      {bool isPassword = false,
      bool obscureText = false,
      VoidCallback? onToggleVisibility,
      bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: context.percentWidth * 3.25,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: textController,
          obscureText: isPassword ? obscureText : false,
          enabled: enabled,
          decoration: InputDecoration(
            suffixIcon: isPassword
                ? InkWell(
                    onTap: onToggleVisibility,
                    child: Icon(
                      obscureText ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                      color: AppColors.borderColor,
                      size: context.percentHeight * 2.0,
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: AppColors.textColor.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
      BuildContext context, IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: context.percentWidth * 5),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: context.percentWidth * 3.25,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor.withOpacity(0.7),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: context.percentWidth * 3.5,
              fontWeight: FontWeight.w600,
              color: AppColors.headingTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
