import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../consts/colors.dart';
import '../../../consts/assets.dart';
import '../../../consts/lang.dart';
import '../../widget/text.dart';
import '../../widget/buttons.dart';

class AddCaregiverView extends StatefulWidget {
  const AddCaregiverView({super.key});
  
  static const String routeName = '/add-caregiver';

  @override
  State<AddCaregiverView> createState() => _AddCaregiverViewState();
}

class _AddCaregiverViewState extends State<AddCaregiverView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  String? _selectedRelationship;
  bool _viewPermission = true;
  bool _addNotesPermission = true;

  final List<String> relationships = [
    'Spouse',
    'Parent',
    'Child',
    'Sibling',
    'Friend',
    'Other Family Member',
    'Healthcare Provider',
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: _buildAddCaregiverContent(),
            ),
          ],
        ),
      ),
    );
  }

  /// App Bar with back button, title, and notification bell
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.blackColor,
              size: 24,
            ),
            onPressed: () => Get.back(),
          ),
          // Title
          Expanded(
            child: Center(
              child: headline3(
                'Add Caregiver',
                color: AppColors.headingTextColor,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Notification bell
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.bellBgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                AppAssets.bell,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Add Caregiver Content
  Widget _buildAddCaregiverContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          
          // Header
          subText2(
            'Add Caregiver',
            color: AppColors.headingTextColor,
            align: TextAlign.start,
            fontWeight: FontWeight.w600,
          ),
          
          const SizedBox(height: 32),
          
          // Email Field
          _buildEmailField(),
          
          const SizedBox(height: 24),
          
          // Full Name Field
          _buildFullNameField(),
          
          const SizedBox(height: 24),
          
          // Relationship Dropdown
          _buildRelationshipDropdown(),
          
          const SizedBox(height: 32),
          
          // Permissions Section
          _buildPermissionsSection(),
          
          const SizedBox(height: 40),
          
          // Action Buttons
          _buildActionButtons(),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subText2(
          'Email',
          color: AppColors.headingTextColor,
          align: TextAlign.start,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          style: const TextStyle(
            color: AppColors.blackColor,
            fontFamily: 'Satoshi',
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: 'Enter Your Email',
            hintStyle: const TextStyle(
              color: AppColors.textColor,
              fontFamily: 'Satoshi',
              fontSize: 16,
            ),
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.textColor,
              size: 20,
            ),
            filled: true,
            fillColor: AppColors.cardGray,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFullNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subText2(
          'Full Name',
          color: AppColors.headingTextColor,
          align: TextAlign.start,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _fullNameController,
          textInputAction: TextInputAction.next,
          style: const TextStyle(
            color: AppColors.blackColor,
            fontFamily: 'Satoshi',
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: 'Enter Your Full Name',
            hintStyle: const TextStyle(
              color: AppColors.textColor,
              fontFamily: 'Satoshi',
              fontSize: 16,
            ),
            prefixIcon: const Icon(
              Icons.person_outline,
              color: AppColors.textColor,
              size: 20,
            ),
            filled: true,
            fillColor: AppColors.cardGray,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRelationshipDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subText2(
          'Relationship',
          color: AppColors.headingTextColor,
          align: TextAlign.start,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showRelationshipPicker(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.cardGray,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.people_outline,
                  color: AppColors.textColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedRelationship ?? 'Select Relationship',
                    style: TextStyle(
                      color: _selectedRelationship != null
                          ? AppColors.blackColor
                          : AppColors.textColor,
                      fontFamily: 'Satoshi',
                      fontSize: 16,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textColor,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // View Permission
        _buildPermissionToggle(
          icon: Icons.visibility_outlined,
          title: 'View',
          value: _viewPermission,
          onChanged: (value) {
            setState(() {
              _viewPermission = value;
            });
          },
        ),
        
        const SizedBox(height: 16),
        
        // Add Notes Permission
        _buildPermissionToggle(
          icon: Icons.note_add_outlined,
          title: 'Add Notes',
          value: _addNotesPermission,
          onChanged: (value) {
            setState(() {
              _addNotesPermission = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPermissionToggle({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: subText2(
              title,
              color: AppColors.headingTextColor,
              align: TextAlign.start,
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withOpacity(0.3),
            inactiveThumbColor: AppColors.textColor,
            inactiveTrackColor: AppColors.dividerGray,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: AppElevatedButton(
            onPressed: () {
              Get.back();
            },
            title: 'Cancel',
            backgroundColor: AppColors.cardGray,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AppElevatedButton(
            onPressed: () {
              _handleSendInvitation();
            },
            title: 'Send Invitation',
            backgroundColor: AppColors.primary,
          ),
        ),
      ],
    );
  }

  void _showRelationshipPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              subText2(
                'Select Relationship',
                color: AppColors.headingTextColor,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 20),
              ...relationships.map((relationship) {
                return ListTile(
                  title: Text(
                    relationship,
                    style: const TextStyle(
                      fontFamily: 'Satoshi',
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedRelationship = relationship;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _handleSendInvitation() {
    if (_emailController.text.isEmpty || 
        _fullNameController.text.isEmpty || 
        _selectedRelationship == null) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        backgroundColor: AppColors.redColor,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Handle send invitation
    Get.snackbar(
      'Success',
      'Invitation sent successfully!',
      backgroundColor: AppColors.green,
      colorText: AppColors.white,
      snackPosition: SnackPosition.TOP,
    );
    
    // Go back after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      Get.back();
    });
  }
}